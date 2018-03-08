
-- 网络对象!!!!
local NetSprite = class("NetSprite",function()
	return display.newSprite()
end)

function NetSprite:ctor(url)
	-- 改为md5
	local md5Name = crypto.md5(url)

	local fileName = "temp/"..md5Name..".png"
	local filePath = cc.FileUtils:getInstance():fullPathForFilename(fileName)

	--获取本地存储目录
	self.path = device.writablePath
	if device.platform == "mac" then
		self.path = self.path.."download/"
	end
	self.path = self.path.."temp/"

	if not io.exists(self.path) then
		--lt.lfs.mkdir(self.path) --目录不存在，创建此目录
		cc.FileUtils:getInstance():createDirectory(self.path)
	end
	self.url  = url
	self:createSprite()
end

function NetSprite:getUrlMd5()
	local fileMd5 = crypto.md5(self.url)
	local fullPath = self.path..fileMd5..".png"
	if io.exists(fullPath) then
		return true, fullPath
	else
		return false, fullPath
	end
end

function NetSprite:setUrlMd5(isOvertime)
	if isOvertime then --如果不是超时
		lt.CommonUtil.print("isOvertime")
	end
end

function NetSprite:createSprite()
	local isExist,fileName = self:getUrlMd5()
	if isExist then --如果存在，直接更新纹理

		self:updateTexture(fileName) 

	else --如果不存在，启动http下载

		-- if network.getInternetConnectionStatus() == cc.kCCNetworkStatusNotReachable then
		-- 	lt.CommonUtil.print("not net")
		-- 	return
		-- end

		local request = network.createHTTPRequest(function(event)
			self:onRequestFinished(event,fileName)end,self.url, "GET")
		request:start()
	end
end

function NetSprite:onRequestFinished(event, fileName)
    local ok = (event.name == "completed")
    local request = event.request
    if not ok then
        -- 请求失败，显示错误代码和错误消息
        lt.CommonUtil.print(request:getErrorCode(), request:getErrorMessage())
        return
    end

    local code = request:getResponseStatusCode()
    if code ~= 200 then
        -- 请求结束，但没有返回 200 响应代码
        lt.CommonUtil.print(code)
        return
    end

    -- 请求成功，显示服务端返回的内容
    local response = request:getResponseString()
    
    --保存下载数据到本地文件，如果不成功，重试30次。
    local times = 1 
    while (not request:saveResponseData(fileName)) and times < 30 do
    	times = times + 1
    end
    local isOvertime = (times == 30) --是否超时
    self:setUrlMd5(isOvertime) --保存md5
    self:updateTexture(fileName) --更新纹理
end

function NetSprite:updateTexture(fileName)
	self:setTexture(fileName)
end

return NetSprite
