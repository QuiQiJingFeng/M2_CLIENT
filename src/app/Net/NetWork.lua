local luasocket = require "socket"
local crypt = require "crypt"
local bit = require "bit"

local network = {}

local NETSTATE = {
	--未连接状态
	UN_CONNECTED = 0,
	CONNECTING = 1,
	WAIT_LOGIN = 2,
	CONNECTED = 3,
	WAIT_RECONNECTED = 4,
}

--心跳间隔
local HEART_BEAT_DT = 60

-- 数据包头长度
local HEADER_SIZE = 2

--连接超时时间
local CONNECT_TIMEOUT = 3

function network:init()
    -- 注册protobuf协议
    protobuf.register(cc.FileUtils:getInstance():getStringFromFile("proto/protocol.pb"))

    self._net_state = NETSTATE.UN_CONNECTED

    lt.GameEventManager:addListener("heartbeat", handler(self, self.onHeartbeatResponse), "network:onHeartbeatResponse")

    return self
end

function network:onHeartbeatResponse(event)
    --如果收到心跳包返回
    self._waite_heartbeat = nil
end

function network:isIPV6(host)
    -- 使用socket.dns判断服务器地址是否为IPv6地址
    for k,v in pairs(luasocket.dns.getaddrinfo(host) or {}) do
        if v.family == "inet6" then
            return true  
        end
    end

    return false
end

function network:updateState(state)
	self._net_state = state
end

--重新建立连接
function network:reconnect()
	--关掉原来的socket
	self._socket:close()
	--清空数据缓存
	self._receive_data = ""
	--重置密钥交换字段
    self._challenge = nil
    self._clientkey = nil
    self._serverkey = nil
    self._secret = nil
    --重置连接超时字段
    self._connect_dt = 0

    self._session_id = 0

    self._heart_dt = 0

    self._send_map = {}

    local host,port = self._host,self._port
    if self:isIPV6(host) then
    	self._socket = luasocket.tcp6()
    else
    	self._socket = luasocket.tcp()
    end
    -- 由于是阻塞socket，所以将超时时间设为0防止阻塞，也因此不再根据connect的返回值判断是否连接成功
    self._socket:settimeout(0)

    self._socket:connect(host,port)

    self:updateState(NETSTATE.CONNECTING)
end

--连接
function network:connect(host,port,callback)
	assert(host,"host must be none nil")
	assert(port,"port must be none nil")
	--连接成功后的回调
	self._callback = callback
	--记录下地址和端口号  自动重连的时候会用到
	self._host = host
	self._port = port

	--数据接收缓存
	self._receive_data = ""

    --交换密钥的字段
    self._challenge = nil
    self._clientkey = nil
    self._serverkey = nil
    self._secret = nil

    --连接超时计算
    self._connect_dt = 0

    --session id
    self._session_id = 0

    self._heart_dt = 0

    self._send_map = {}

    if self:isIPV6(host) then
    	self._socket = luasocket.tcp6()
    else
    	self._socket = luasocket.tcp()
    end
    -- 由于是阻塞socket，所以将超时时间设为0防止阻塞，也因此不再根据connect的返回值判断是否连接成功
    self._socket:settimeout(0)

    self._socket:connect(host,port)

    self:updateState(NETSTATE.CONNECTING)
end

-- 收包
function network:receive()
    local pattern, status, partial = nil, true, nil

    if self._socket and self._net_state >= NETSTATE.CONNECTING and self._net_state <= NETSTATE.CONNECTED then
        pattern, status, partial = self._socket:receive("*a")
    end

    assert(status,"receive data cache error")

    -- 拼接数据
    if pattern then
        self._receive_data = self._receive_data .. pattern
    elseif partial then
        self._receive_data = self._receive_data .. partial
    end
end

function network:unpackData()
    -- 按照大段编码规则分割数据
    local receive_size = #self._receive_data
    if receive_size >= HEADER_SIZE then
        local data_size = self._receive_data:byte(1) * 256 + self._receive_data:byte(2)
        local data_end_pos = data_size + HEADER_SIZE
        if receive_size >= data_end_pos then
            -- 获取完整的一个包数据，进行解析
            local data = crypt.base64decode(self._receive_data:sub(HEADER_SIZE + 1, data_end_pos))
            -- 剩余数据等待下一次解析
            self._receive_data = self._receive_data:sub(data_end_pos + 1)

            if self._secret then
                data = crypt.desdecode(self._secret, data)
            end

            local data_content, err = protobuf.decode("S2C", data)
            if not err then
                return data_content
            else
                print("encode Protobuf Error: %s", err)
            end
        end
    end
end

--计算连接时间,如果超时需要重新连接
function network:caculateConnectTime(dt)
	if self._connect_dt > CONNECT_TIMEOUT then
		--连接超时,尝试重新连接
		self:updateState(NETSTATE.WAIT_RECONNECTED)
	else
		self._connect_dt = self._connect_dt +dt
	end
end

function network:update(dt)

	if self._net_state == NETSTATE.UN_CONNECTED then
		return
	end

	if self._net_state == NETSTATE.CONNECTING then
		-- 与服务器端约定：链接建立后服务端立刻回发一个握手包，用于确认连接成功
        self:receive()

        local data_content = self:unpackData() or {}

        -- 判断收到的第一个包是否为握手包
        if data_content["handshake"] then
            local rsp_msg = data_content["handshake"]
            self._challenge = crypt.base64decode(rsp_msg["v1"])
            self._clientkey = crypt.randomkey()
            self._serverkey = crypt.base64decode(rsp_msg["v2"])
            local secret = crypt.dhsecret(self._serverkey, self._clientkey)
            local req_msg = {}
            req_msg["v1"] = crypt.base64encode(crypt.dhexchange(self._clientkey))
            req_msg["v2"] = crypt.base64encode(crypt.hmac64(self._challenge, secret))

            --发送回应包
            self:send({["handshake"] = req_msg},nil,true)

            self._secret = secret

            --连接成功,连接计时重置为0
            self._connect_dt = 0
            --状态置为已连接
            self._net_state = NETSTATE.CONNECTED
            --连接成功回调 之后可以进行登录
            self._callback()
        else
            self:caculateConnectTime(dt)
        end
    elseif self._net_state == NETSTATE.CONNECTED then
    	--收包
    	self:receive()
    	--TODO
    	local data_content = self:unpackData()
    	if not data_content then
    		return
    	end
    	local new_session_id = nil

    	local rsp_name,rsp_msg
    	for k,v in pairs(data_content) do
    		if k == "session_id" then
    			new_session_id = v
    		else
    			rsp_name = k
    			rsp_msg = v
    		end
    	end

        print("rsp_name ==>",rsp_name,new_session_id)
    	local item = self._send_map[new_session_id]
    	if item then
    		--如果是请求返回
            if item.callback then
                item.callback(rsp_msg)
            else
                lt.GameEventManager:post(rsp_name, rsp_msg)
            end
    	else
            --如果是推送 走这里
            lt.GameEventManager:post(rsp_name, rsp_msg)
        end

    	--心跳相关处理
    	if self._heart_dt > HEART_BEAT_DT then
    		self._heart_dt = 0
    		--发送心跳包
    		self:send({["heartbeat"] = {}},nil,true)
    		self._waite_heartbeat = true
    	else
    		--累计心跳间隔时间
    		self._heart_dt = self._heart_dt + dt
    		if self._waite_heartbeat then
    			--如果100ms内都没有收到心跳回包 则按断开处理
    			self:updateState(NETSTATE.WAIT_RECONNECTED)
    		end
    	end
	end
end

function network:send(data_content,callback,ignore_session)

	if not (self._socket and (self._net_state == NETSTATE.CONNECTING or self._net_state == NETSTATE.CONNECTED)) then
		return false
	end

	if not ignore_session then
		self._session_id = self._session_id + 1
		data_content.session_id = self._session_id
		--记录一下 发送的包,收到回包之后删除
		self._send_map[self._session_id] = {data_content = data_content,callback = callback}
	end
	print("FYD+++++",data_content)
    local success, data, err = pcall(protobuf.encode, "C2S", data_content)
    if not success or err then
        print("encode protobuf error:", err)
    elseif data then
        if self._secret then
            success, data = pcall(crypt.desencode, self._secret, data) 
            if not success then
                print("desencode error")
                return false
            end
        end

        data = crypt.base64encode(data)
        local size = #data
        data = string.char(bit.band(bit.rshift(size, 8), 0xff)) .. string.char(bit.band(size, 0xff)) .. data

        local _, err = self._socket:send(data)
        if err then
            self:updateState(NETSTATE.WAIT_RECONNECTED)
        end

        return true
    end

    return false
end

-- 定时update
local scheduler = cc.Director:getInstance():getScheduler()
network.schedule_id = scheduler:scheduleScriptFunc(function(dt)
    network:update(dt)
end, 0.1, false)

return network