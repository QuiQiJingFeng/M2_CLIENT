local ConfigManager = {}
ConfigManager._gameDict = {}

function ConfigManager:init()
	local gamePath = cc.FileUtils:getInstance():fullPathForFilename("game.plist")
	self._gameDict = cc.FileUtils:getInstance():getValueMapFromFile(gamePath)
end

--游戏版本号
function ConfigManager:getBundleVersion()
	if not self._bundleVersion then
		self._bundleVersion = self._gameDict["GAME_BUNDLE_VERSION"]
	end

	return self._bundleVersion
end

--登录设备
function ConfigManager:getDevice()
	if not self._device then
		self._device = tonumber(self._gameDict["GAME_DEVICE"])
	end

	return self._device
end

--平台号
function ConfigManager:getPlatformId()
	if not self._platformId then
		self._platformId = tonumber(self._gameDict["GAME_PLATFORM_ID"])
	end

	return self._platformId
end

--suffix
function ConfigManager:getSuffix()
	if not self._suffix then
		self._suffix = self._gameDict["GAME_SUFFIX"]
	end

	return self._suffix
end

--资源版本号
function ConfigManager:getResourceVersion()
	if not self._resourceVersion then
		self._resourceVersion = tonumber(self._gameDict["GAME_RESOURCE_VERSION"])
	end

	return self._resourceVersion
end

--游戏id
function ConfigManager:getGameId()
	if not self._gameId then
		self._gameId = tonumber(self._gameDict["GAME_GAME_ID"])
	end

	return self._gameId
end

--usertype
function ConfigManager:getUserType()
	if not self._userType then
		self._userType = self._gameDict["GAME_USER_TYPE"]
	end
	
	return self._userType
end

--sdkId
function ConfigManager:getSdkId()
	if not self._sdkId then
		self._sdkId = tonumber(self._gameDict["GAME_SDK_ID"])
	end
	
	return self._sdkId
end

--channelId
function ConfigManager:getChannelId()
	if not self._channelId then
		self._channelId = tonumber(self._gameDict["GAME_CHANNEL_ID"])
	end
	
	return self._channelId
end

--pt
function ConfigManager:getPT()
	if not self._pt then
		self._pt = tonumber(self._gameDict["GAME_PT"])
	end

	if not self._pt then
		self._pt = 0
	end
	
	return self._pt
end

-- resExtra1
function ConfigManager:getResExtra1()
	if not self._resExtra1 then
		self._resExtra1 = tonumber(self._gameDict["GAME_RES_EXTRA_1"])
	end
	
	return self._resExtra1 or 0
end

-- 隐藏Logo
function ConfigManager:getHideLogo()
	if not self._hideLogo then
		self._hideLogo = tonumber(self._gameDict["GAME_HIDE_LOGO"])
	end
	
	return self._hideLogo or 0
end

-- 隐藏Logo
function ConfigManager:getHideMovie()
	if not self._hideMovie then
		self._hideMovie = tonumber(self._gameDict["GAME_HIDE_MOVIE"])
	end
	
	return self._hideMovie or 0
end

-- QA模式
function ConfigManager:isQA()
	if self._isQA == nil then
		self._isQA = tonumber(self._gameDict["GAME_QA_MODEL"]) == 1
	end
	
	return self._isQA
end

-- 模拟器
function ConfigManager:isSimulator()
	if self._isSimulator == nil then
		self._isSimulator = tonumber(self._gameDict["GAME_SIMULATOR"]) == 1
	end
	
	return self._isSimulator
end

-- 服务器端口号
function ConfigManager:getGameServerUrlPort()
	if self._gameServerUrlPort == nil then
		self._gameServerUrlPort = tonumber(self._gameDict["GAME_SERVER_URL_PORT"])
	end

	return self._gameServerUrlPort
end

return ConfigManager
