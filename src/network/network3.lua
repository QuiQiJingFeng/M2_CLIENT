local luasocket = require "socket"
local user = require "logic.user"

local bit = App.Util.bit
local crypt = App.Util.crypt
local event_manager = App.EventManager

-- 重连最大次数
local RETRY_MAX_COUNT = 3
-- 重连间隔指数
local RETRY_POW_X = 2
-- 超时时长
local CONNECT_TIMEOUT = 3
-- 心跳间隔
local HEART_BEAT_DT = 60
-- 数据包头长度
local HEADER_SIZE = 2

-- 网络状态
local NETWORK_STATUS = {
    ["unconnected"] = 0,
    ["connecting"] = 1,
    ["wait_login"] = 2,
    ["connected"] = 3,
    ["wait_reconnect"] = 4,
}

local socket = nil
local server_address = nil
local server_port = nil

local cur_status = NETWORK_STATUS["unconnected"]
local receive_data = ""
local connect_dt = 0

local challenge = nil
local clientkey = nil
local serverkey = nil
local secret = nil

local retry_count = 0
local retry_dt = 0

local heart_beat_dt = 0

local session_id = 0
local send_data_map = {}

local network = {}
function network:init()
    -- 注册protobuf协议
    protobuf.register(cc.FileUtils:getInstance():getStringFromFile("proto/protocol.pb"))

    return self
end

local function isIPv6(address)
    -- 使用socket.dns判断服务器地址是否为IPv6地址
    for k,v in pairs(luasocket.dns.getaddrinfo(address) or {}) do
        if v.family == "inet6" then
            return true  
        end
    end

    return false
end

local function changeStatus(status)
    cur_status = NETWORK_STATUS[status]
    event_manager:emit("network_status", status)
end

local function unpackData()
    -- 按照大段编码规则分割数据
    local receive_size = #receive_data
    if receive_size >= HEADER_SIZE then
        local data_size = receive_data:byte(1) * 256 + receive_data:byte(2)
        local data_end_pos = data_size + HEADER_SIZE
        if receive_size >= data_end_pos then
            -- 获取完整的一个包数据，进行解析
            local data = crypt.base64decode(receive_data:sub(HEADER_SIZE + 1, data_end_pos))
            -- 剩余数据等待下一次解析
            receive_data = receive_data:sub(data_end_pos + 1)

            if secret then
                data = crypt.desdecode(secret, data)
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

-- 收包
local function receive()
    local pattern, err, partial = nil, true, nil
    if socket and cur_status >= NETWORK_STATUS["connecting"] and cur_status <= NETWORK_STATUS["connected"] then
        pattern, err, partial = socket:receive("*a")
    end

    -- 拼接数据
    if pattern then
        receive_data = receive_data .. pattern
    elseif partial then
        receive_data = receive_data .. partial
    end

    return err
end

local function send(data_content)
    local success, data, err = pcall(protobuf.encode, "C2S", data_content)
    if not success or err then
        print("encode protobuf error:", err)
    elseif data then
        if secret then
            success, data = pcall(crypt.desencode, secret, data) 
            if not success then
                print("desencode error")
                return false
            end
        end

        data = crypt.base64encode(data)
        local size = #data
        data = string.char(bit.band(bit.rshift(size, 8), 0xff)) .. string.char(bit.band(size, 0xff)) .. data

        local _, err = socket:send(data)
        if err then
            changeStatus("wait_reconnect")
        end

        return true
    end

    return false
end

local function onData(data_content)
    if data_content["session_id"] then
        local session_id = data_content["session_id"]
        data_content["session_id"] = nil

        local msg_item = send_data_map[session_id]
        if msg_item then
            local rsp_name, rsp_msg = next(data_content)
            local callback = msg_item.callback
            if isfunction(callback) then
                callback(rsp_msg)
            end
            send_data_map[session_id] = nil
        end
    else
        local rsp_name, rsp_msg = next(data_content)
        event_manager:emit(rsp_name, rsp_msg)
    end
end

local function caculateConnectTime(dt)
    -- 累计连接耗时
    if connect_dt > CONNECT_TIMEOUT then
        -- 连接超时，尝试重连
        changeStatus("wait_reconnect")
    else
        -- 未超时，累计连接耗时
        connect_dt = connect_dt + dt
    end
end

local function update(dt)
    if socket then
        if cur_status == NETWORK_STATUS["unconnected"] then
            -- 未连接
            -- 理论上不做任何事
        elseif cur_status == NETWORK_STATUS["connecting"] then
            -- 正在连接
            -- 与服务器端约定：链接建立后服务端立刻回发一个握手包，用于确认连接成功
            local err = receive()
            local data_content = unpackData() or {}

            -- 判断收到的第一个包是否为握手包
            if data_content["handshake"] then
                local rsp_msg = data_content["handshake"]
                challenge = crypt.base64decode(rsp_msg["v1"])
                clientkey = crypt.randomkey()
                serverkey = crypt.base64decode(rsp_msg["v2"])
                local _secret = crypt.dhsecret(serverkey, clientkey)
                local req_msg = {}
                req_msg["v1"] = crypt.base64encode(crypt.dhexchange(clientkey))
                req_msg["v2"] = crypt.base64encode(crypt.hmac64(challenge, _secret))

                send({["handshake"] = req_msg})

                secret = _secret

                -- 重置计时
                retry_count = 0
                heart_beat_dt = 0

                connect_dt = 0
                --登陆
                network:login()
            else
                caculateConnectTime(dt)
            end
        elseif cur_status == NETWORK_STATUS["wait_login"] then
            local err = receive()
            local data_content = unpackData() or {}

            if data_content["login"] then
                local rsp_msg = data_content["login"]
                if rsp_msg.result == "success" then
                    user:setReconnectToken(rsp_msg.reconnect_token)

                    -- 连接成功
                    changeStatus("connected")

                    -- 重发缓存包
                    local keys = table.keys(send_data_map)
                    table.sort(keys)
                    for _,key in ipairs(keys) do
                        local send_data = send_data_map[key]
                        send(send_data.data_content)
                    end 
                else
                    changeStatus("unconnected")
                end
                
                event_manager:emit("login_result", rsp_msg)
            else
                caculateConnectTime(dt)
            end
        elseif cur_status == NETWORK_STATUS["connected"] then
            -- 已连接
            -- 收包
            local err = receive()

            -- 先循环分割并处理数据包
            local data_content = unpackData()
            while data_content do
                onData(data_content)
                data_content = unpackData()
            end

            -- 如果收包时发生错误，尝试重连
            if err and err ~= "timeout" then
                changeStatus("wait_reconnect")
                return
            end

            -- 心跳包
            if heart_beat_dt > HEART_BEAT_DT then
                heart_beat_dt = 0

                -- 发送心跳包
                send({["heartbeat"] = { ["timestamp"] = 123 }})
            else
                -- 累计心跳间隔时长
                heart_beat_dt = heart_beat_dt + dt
            end
        elseif cur_status == NETWORK_STATUS["wait_reconnect"] then
            -- 等待重连
            -- 判断是否超过最大重连次数
            if retry_count < RETRY_MAX_COUNT then
                -- 尝试重连
                -- 根据重连次数指数级增长间隔时长
                if retry_dt > math.pow(RETRY_POW_X, retry_count + 1) then
                    -- 连接
                    retry_count = retry_count + 1
                    retry_dt = 0
                    network:connect(server_address, server_port, true)
                else
                    -- 累计重连间隔时长
                    retry_dt = retry_dt + dt
                end
            else
                -- 超过最大重连次数，通知断开连接
                -- TODO:通知断开连接
                changeStatus("unconnected")
            end
        end
    end
end

-- 发包
function network:send(data_content, callback)
    if socket and cur_status == NETWORK_STATUS["connected"] then
        session_id = session_id + 1
        data_content.session_id = session_id

        local msg_item = {}
        msg_item.data_content = data_content
        msg_item.callback = callback
        send_data_map[session_id] = msg_item

        return send(data_content)
    end
    return false
end

-- 连接
function network:connect(address, port,callback)
    assert(address)
    assert(port)

    --连接成功后的回调
    self.connect_callback = callback
    --交换密钥的字段
    challenge = nil
    clientkey = nil
    serverkey = nil
    secret = nil

    connect_dt = 0

    server_address = address
    server_port = port
    receive_data = ""



    -- 判断是否为IPv6
    if isIPv6(address) then
        socket = luasocket.tcp6()
    else
        socket = luasocket.tcp()
    end

    -- 由于是阻塞socket，所以将超时时间设为0防止阻塞，也因此不再根据connect的返回值判断是否连接成功
    socket:settimeout(0)
    socket:connect(server_address, server_port)
    changeStatus("connecting")
end

-- 断开连接
function network:disconnect()
    if socket then
        socket:close()
    end
    changeStatus("unconnected")
    socket = nil
    server_address = nil
    server_port = nil
    receive_data = ""
    session_id = 0
    send_data_map = {}

    --如果是主动断开连接的话,tocken置为空
    user:setReconnectToken(nil)
    user:setIsReconnect(nil)
end

-- 定时update
local scheduler = cc.Director:getInstance():getScheduler()
network.schedule_id = scheduler:scheduleScriptFunc(function(dt)
    update(dt)
end, 0.1, false)

return network
