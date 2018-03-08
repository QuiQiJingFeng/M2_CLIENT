
-- 玩家自定义数据
local PreferenceManager = {}

PreferenceManager._bundleVersion = nil
PreferenceManager._resourceVersion = nil

PreferenceManager._loginName = nil
PreferenceManager._password = nil

PreferenceManager._serverDefault = {}
PreferenceManager._gameDefault = {}

function PreferenceManager:init()
	-- local filePath = cc.UserDefault:getXMLFilePath()
	-- mac 下 ~/Library/Preferences/com.cocos.quick.apps.player.plist
end

-- 游戏激活
function PreferenceManager:setGameActive()
	local settingDefault = self:getSettingDefault()

	settingDefault["game_active"] = gameActive

	local key = "GAME_DEFAULT_SETTING_SDK_GAME_ACTIVE"
	cc.UserDefault:getInstance():setBoolForKey(key, gameActive)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:isGameActive()
	local settingDefault = self:getSettingDefault()

	local gameActive = settingDefault["game_active"]
	if gameActive == nil then
		local key = "GAME_DEFAULT_SETTING_SDK_GAME_ACTIVE"
		gameActive = cc.UserDefault:getInstance():getBoolForKey(key, false)
		settingDefault["game_active"] = gameActive
	end

	return gameActive
end

-- 游戏版本号
function PreferenceManager:setBundleVersion(bundleVersion)
	self._bundleVersion = bundleVersion

	cc.UserDefault:getInstance():setStringForKey("GAME_BUNDLE_VERSION", self._bundleVersion)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getBundleVersion()
	if not self._bundleVersion then
		self._bundleVersion = cc.UserDefault:getInstance():getStringForKey("GAME_BUNDLE_VERSION", lt.ConfigManager:getBundleVersion())
	end

	return self._bundleVersion
end

-- 资源版本号
function PreferenceManager:setResourceVersion(resourceVersion)
	self._resourceVersion = resourceVersion

	cc.UserDefault:getInstance():setIntegerForKey("GAME_RESOURCE_VERSION", self._resourceVersion)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getResourceVersion()
	if not self._resourceVersion then
		self._resourceVersion = cc.UserDefault:getInstance():getIntegerForKey("GAME_RESOURCE_VERSION", lt.ConfigManager:getResourceVersion())
	end

	return self._resourceVersion
end

function PreferenceManager:isSpecialUpdate(version, tag)
	version = version or 0
	tag = tag or 0

	local key = "GAME_SPECIAL_UPDATE_V_"..version.."_T_"..tag
	return cc.UserDefault:getInstance():getBoolForKey(key, false)
end

function PreferenceManager:setSpecialUpdate(version, tag)
	version = version or 0
	tag = tag or 0

	local key = "GAME_SPECIAL_UPDATE_V_"..version.."_T_"..tag
	cc.UserDefault:getInstance():setBoolForKey(key, true)
	cc.UserDefault:getInstance():flush()
end

-- 默认账号
function PreferenceManager:setLoginInfo(loginName, password)
	if self._loginName == loginName and self._password == password then
		return
	end

	self._loginName = loginName
	self._password = password

	cc.UserDefault:getInstance():setStringForKey("GAME_LOGIN_NAME", loginName)
	cc.UserDefault:getInstance():setStringForKey("GAME_PASSWORD", password)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getLoginInfo()
	if not self._loginName or not self._password then
		-- 获取存储信息
		self._loginName = cc.UserDefault:getInstance():getStringForKey("GAME_LOGIN_NAME")
		self._password = cc.UserDefault:getInstance():getStringForKey("GAME_PASSWORD")
	end

	return self._loginName, self._password
end

-- 默认登录角色
function PreferenceManager:setLoginId(token,playerId)
	token = crypto.md5(token)
	local key = "login_id_"..token
	if not self._login then
		self._login = {}
	end
	self._login[key] = playerId
	cc.UserDefault:getInstance():setIntegerForKey("GAME_LOGIN_ID_"..token, playerId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getLoginId(token)
	token = crypto.md5(token)
	local key = "login_id_"..token
	if not self._login then
		self._login = {}
	end

	local loginId = self._login[key]
	if not loginId then
		loginId = cc.UserDefault:getInstance():getIntegerForKey("GAME_LOGIN_ID_"..token,0)
		self._login[key] = loginId
	end

	return loginId
end

-- 默认地下城难度
function PreferenceManager:getDungeonDefaultDifficulty(dungeonClassId)
    return -1 -- 没有默认/未开启
end

-- 默认服务器
function PreferenceManager:setDefaultServerId(token, serverId)
    token = crypto.md5(token)

	serverId = serverId or -1
	if not self._serverDefault["server"] then
		self._serverDefault["server"] = {}
	end

	self._serverDefault["server"][token] = serverId

	cc.UserDefault:getInstance():setIntegerForKey("GAME_DEFAULT_SERVER_"..token, serverId)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getDefaultServerId(token)
    token = crypto.md5(token)

	if not self._serverDefault["server"] then
		self._serverDefault["server"] = {}
	end

	local defaultServerId = self._serverDefault["server"][token]
	if not defaultServerId then
		defaultServerId = cc.UserDefault:getInstance():getIntegerForKey("GAME_DEFAULT_SERVER_"..token, -1)

		if defaultServerId ~= -1 then
			self._serverDefault["server"][token] = defaultServerId
		end
	end

	return defaultServerId
end

-- 默认游戏数据(根据账号)
function PreferenceManager:setInitGameInfo()
	self._serverDefault["initgameInfo"] = true

	local key   = "GAME_DEFAULT_INIT_GAME_INFO"
	cc.UserDefault:getInstance():setBoolForKey(key, true)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getInitGameInfo()
	local initgameInfo = self._serverDefault["initgameInfo"]

	if initgameInfo == nil then
		local key   = "GAME_DEFAULT_INIT_GAME_INFO"
		initgameInfo = cc.UserDefault:getInstance():getBoolForKey(key, false)
		self._serverDefault["initgameInfo"] = initgameInfo
	end

	return initgameInfo
end

function PreferenceManager:setSimpleGameInfo(serverId)
    local token    = lt.DataManager:getToken()

    local gameInfo = self:getDefaultGameInfo(token, serverId)
    if not gameInfo then
    	self:_setDefaultGameInfo(token, serverId)
    end
end

function PreferenceManager:setLoginPlayerInfo()
	if not self._serverDefault["loginPlayerInfo"] then
		self._serverDefault["loginPlayerInfo"] = {}
	end

	local token = lt.DataManager:getToken()
	token = crypto.md5(token)

	if not self._serverDefault["loginPlayerInfo"][token] then
		self._serverDefault["loginPlayerInfo"][token] = {}
	end

	local serverId = lt.DataManager:getCurServerId()

	local loginPlayerArray = {}
	local playerArray = lt.DataManager:getLoginPlayerArray()
	for _, loginPlayer in pairs(playerArray) do
		loginPlayerArray[#loginPlayerArray+1] = {id=loginPlayer.id,occupation_id=loginPlayer.occupation_id,level=loginPlayer.level,sex=loginPlayer.sex}
	end

	self._serverDefault["loginPlayerInfo"][token][serverId] = loginPlayerArray

	local key   = "GAME_DEFAULT_LOGIN_PLAYER_INFO_"..token.."_"..serverId
	local value = json.encode(loginPlayerArray)
	cc.UserDefault:getInstance():setStringForKey(key, value)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()

	return loginPlayerArray
end

function PreferenceManager:getLoginPlayerArray(token, serverId)
	token = crypto.md5(token)

	if not self._serverDefault["loginPlayerInfo"] then
		self._serverDefault["loginPlayerInfo"] = {}
	end

	if not self._serverDefault["loginPlayerInfo"][token] then
		self._serverDefault["loginPlayerInfo"][token] = {}
	end

	local loginPlayerArray = self._serverDefault["loginPlayerInfo"][token][serverId]
	if not loginPlayerArray then
		local key   = "GAME_DEFAULT_LOGIN_PLAYER_INFO_"..token.."_"..serverId
		local loginPlayerInfoStr = cc.UserDefault:getInstance():getStringForKey(key)
		if loginPlayerInfoStr ~= "" then
			loginPlayerArray = json.decode(loginPlayerInfoStr)
			self._serverDefault["loginPlayerInfo"][token][serverId] = loginPlayerArray
		else
			loginPlayerArray = {}
		end
	end

	return loginPlayerArray
end

function PreferenceManager:setWeaponInfo()
	if not self._serverDefault["weaponInfo"] then
		self._serverDefault["weaponInfo"] = {}
	end

	local weaponId = 0
	local unlockWeapon = 0
	local isWeaponEffectId = 0

	local assistantId = 0
	local unlockAssistant = 0
	local isAssistantEffectId = 0

	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	if not self._serverDefault["weaponInfo"][serverId] then
		self._serverDefault["weaponInfo"][serverId] = {}
	end

	local player = lt.DataManager:getPlayer()
    local playerEquipmentSlotTable = lt.DataManager:getPlayerEquipmentSlotTable()

    if player:getWeaponEffectModelId() > 0 then
        -- 设定了武器模型
        local equipmentInfo = lt.CacheManager:getEquipmentInfo(player:getWeaponEffectModelId())
        if equipmentInfo then
        	weaponId = equipmentInfo:getFigureId()
        	if equipmentInfo:hasEffect() then
        		unlockWeapon = 1
        	end
        	isWeaponEffectId = 1
        end
    else
		local playerEquipmentSlotTable = lt.DataManager:getPlayerEquipmentSlotTable()
		local playerEquipmentWeapon = playerEquipmentSlotTable[lt.Constants.EQUIPMENT_TYPE.WEAPON]

		if playerEquipmentWeapon then
			weaponId = playerEquipmentWeapon:getModelId()
			if playerEquipmentWeapon:hasEffect() then
				unlockWeapon = 1
			end
		end
    end


    if player:getExclusiveEffectModelId() > 0 then
        -- 设定了副手模型
        local equipmentInfo = lt.CacheManager:getEquipmentInfo(player:getExclusiveEffectModelId())
        if equipmentInfo then
            assistantId = equipmentInfo:getFigureId()
            if equipmentInfo:hasEffect() then
            	unlockAssistant = 1
            end
            isAssistantEffectId = 1
        end
    else
	    local playerEquipmentAssistant = playerEquipmentSlotTable[lt.Constants.EQUIPMENT_TYPE.ASSISTANT]
		if playerEquipmentAssistant then
			assistantId = playerEquipmentAssistant:getModelId()
			if playerEquipmentAssistant:hasEffect() then
				unlockAssistant = 1
			end
		end
    end

	local weaponInfo = {weapon_id=weaponId,unlock_weapon=unlockWeapon,is_weapon_effect_id=isWeaponEffectId,assistant_id=assistantId,unlock_assistant=unlockAssistant,is_assistant_effect_id = isAssistantEffectId}
	self._serverDefault["weaponInfo"][serverId][playerId] = weaponInfo

	local key = "GAME_DEFAULT_WEAPON_INFO_"..serverId.."_"..playerId
	local value = json.encode(weaponInfo)

	cc.UserDefault:getInstance():setStringForKey(key, value)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getWeaponInfo(serverId,playerId)
	if not self._serverDefault["weaponInfo"] then
		self._serverDefault["weaponInfo"] = {}
	end

	if not self._serverDefault["weaponInfo"][serverId] then
		self._serverDefault["weaponInfo"][serverId] = {}
	end

	local weaponInfo = self._serverDefault["weaponInfo"][serverId][playerId]
	if not weaponInfo then
		local key   = "GAME_DEFAULT_WEAPON_INFO_"..serverId.."_"..playerId
		local weaponInfoStr = cc.UserDefault:getInstance():getStringForKey(key)
		if weaponInfoStr ~= "" then
			weaponInfo = json.decode(weaponInfoStr)
			self._serverDefault["weaponInfo"][serverId][playerId] = weaponInfo
		end
	end

	if not weaponInfo then
		weaponInfo = {weapon_id=0,unlock_weapon=0,assistant_id=0,unlock_assistant=0}
	end

	return weaponInfo
end

function PreferenceManager:setGuardBattleRound(round)
	if not self._serverDefault["guardBattleRound"] then
		self._serverDefault["guardBattleRound"] = {}
	end

	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	if not self._serverDefault["guardBattleRound"][serverId] then
		self._serverDefault["guardBattleRound"][serverId] = {}
	end

	self._serverDefault["guardBattleRound"][serverId][playerId] = round

	local key = "GAME_DEFAULT_GUARD_BATTLE_ROUND_INFO_"..serverId.."_"..playerId
	cc.UserDefault:getInstance():setIntegerForKey(key, round)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getGuardBattleRound()
	if not self._serverDefault["guardBattleRound"] then
		self._serverDefault["guardBattleRound"] = {}
	end

	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	if not self._serverDefault["guardBattleRound"][serverId] then
		self._serverDefault["guardBattleRound"][serverId] = {}
	end

	local round = self._serverDefault["guardBattleRound"][serverId][playerId]
	if not round then
		local key = "GAME_DEFAULT_GUARD_BATTLE_ROUND_INFO_"..serverId.."_"..playerId
		round = cc.UserDefault:getInstance():getIntegerForKey(key,1)
	end

	return round
end

function PreferenceManager:setDefaultGameInfo()
    local token    = lt.DataManager:getToken()
    local serverId = lt.DataManager:getCurServerId()
    local player   = lt.DataManager:getPlayer()
    local hero     = lt.DataManager:getHero()

    local occupationId = hero:getOccupation()
    local name 		   = player:getName()
    local vip          = player:getVipLevel()
    local level        = player:getLevel()
    local fightPower   = hero:getFightPower(true)

   	self:_setDefaultGameInfo(token, serverId, occupationId, name, vip, level, fightPower)
end

function PreferenceManager:_setDefaultGameInfo(token, serverId, occupationId, name, vip, level, fightPower)
    token = crypto.md5(token)
    occupationId = occupationId or 1
    name = name or "?"
    vip = vip or "?"
    level = level or "?"
    fightPower = fightPower or "?"
	if not self._serverDefault["gameInfo"] then
		self._serverDefault["gameInfo"] = {}
	end

	if not self._serverDefault["gameInfo"][token] then
		self._serverDefault["gameInfo"][token] = {}
	end

	local gameInfo = {occupationId = occupationId, name = name, vip = vip, level = level, fightPower = fightPower}
	self._serverDefault["gameInfo"][token][serverId] = gameInfo

	local key   = "GAME_DEFAULT_GAME_INFO_"..token.."_"..serverId
	local value = occupationId.."_"..name.."_"..vip.."_"..level.."_"..fightPower
	cc.UserDefault:getInstance():setStringForKey(key, value)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getDefaultGameInfo(token, serverId)
    token = crypto.md5(token)

	if not self._serverDefault["gameInfo"] then
		self._serverDefault["gameInfo"] = {}
	end

	if not self._serverDefault["gameInfo"][token] then
		self._serverDefault["gameInfo"][token] = {}
	end

	local gameInfo = self._serverDefault["gameInfo"][token][serverId]
	if not gameInfo then
		local key   = "GAME_DEFAULT_GAME_INFO_"..token.."_"..serverId
		local gameInfoStr = cc.UserDefault:getInstance():getStringForKey(key)
		if gameInfoStr ~= "" then
			local gameInfArray = string.split(gameInfoStr, "_")
			if gameInfArray then
				gameInfo = {occupationId = gameInfArray[1], name = gameInfArray[2], vip = gameInfArray[3], level = gameInfArray[4], fightPower = gameInfArray[5]}
				self._serverDefault["gameInfo"][token][serverId] = gameInfo
			end
		end
	end

	return gameInfo
end

function PreferenceManager:getPlayerDefault(serverId, playerId)
	self._gameDefault[serverId] = self._gameDefault[serverId] or {}
	self._gameDefault[serverId][playerId] = self._gameDefault[serverId][playerId] or {}

	return self._gameDefault[serverId][playerId]
end

-- 默认传送门
function PreferenceManager:setDungeonDefaultTransfer(dungeonClassId, transferDoorId)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	self:_setDungeonDefaultTransfer(serverId, playerId, dungeonClassId, transferDoorId)
end
function PreferenceManager:_setDungeonDefaultTransfer(serverId, playerId, dungeonClassId, transferDoorId)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	local dungeonDefaultTransfer = playerDefault["dungeonDefaultTransfer"]
	if not dungeonDefaultTransfer then
		dungeonDefaultTransfer = {}
		playerDefault["dungeonDefaultTransfer"] = dungeonDefaultTransfer
	end

	if dungeonDefaultTransfer[dungeonClassId] == transferDoorId then
		return
	end

	dungeonDefaultTransfer[dungeonClassId] = transferDoorId

	cc.UserDefault:getInstance():setIntegerForKey("GAME_DEFAULT_"..serverId.."_"..playerId.."_DDT_"..dungeonClassId, transferDoorId)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getDungeonDefaultTransfer(dungeonClassId)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_getDungeonDefaultTransfer(serverId, playerId, dungeonClassId)
end

function PreferenceManager:_getDungeonDefaultTransfer(serverId, playerId, dungeonClassId)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	local dungeonDefaultTransfer = playerDefault["dungeonDefaultTransfer"]
	if not dungeonDefaultTransfer then
		dungeonDefaultTransfer = {}
		playerDefault["dungeonDefaultTransfer"] = dungeonDefaultTransfer
	end

	if not isset(dungeonDefaultTransfer, dungeonClassId) then
		dungeonDefaultTransfer[dungeonClassId] = cc.UserDefault:getInstance():getIntegerForKey("GAME_DEFAULT_"..serverId.."_"..playerId.."_DDT_"..dungeonClassId)
	end

	return dungeonDefaultTransfer[dungeonClassId]
end

-- 记录地图Id
function PreferenceManager:setWorldMapId(worldMapId)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_setWorldMapId(serverId, playerId, worldMapId)
end

function PreferenceManager:_setWorldMapId(serverId, playerId, worldMapId)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	playerDefault["worldMapId"] = worldMapId

	cc.UserDefault:getInstance():setIntegerForKey("GAME_DEFAULT_"..serverId.."_"..playerId.."_WMID", worldMapId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getWorldMapId()
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_getWorldMapId(serverId, playerId)
end

function PreferenceManager:_getWorldMapId(serverId, playerId)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	local worldMapId = playerDefault["worldMapId"]

	if not worldMapId then
		local key   = "GAME_DEFAULT_"..serverId.."_"..playerId.."_WMID"
		worldMapId = cc.UserDefault:getInstance():getIntegerForKey(key, lt.Constants.DEFAULT_WORLD_MAP_ID)
		playerDefault["worldMapId"] = worldMapId
	end
	return worldMapId
end

-- 记录当前坐标
function PreferenceManager:setWorldMapPosition(worldMapId, x, y)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_setWorldMapPosition(serverId, playerId, worldMapId, x, y)
end

function PreferenceManager:_setWorldMapPosition(serverId, playerId, worldMapId, x, y)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	x = math.round(x)
	y = math.round(y)

	local position = cc.p(x, y)

	local worldMapPosition = playerDefault["worldMapPosition"]
	if not worldMapPosition then
		worldMapPosition = {}
		playerDefault["worldMapPosition"] = worldMapPosition
	end

	worldMapPosition[worldMapId] = position

	local key = "GAME_DEFAULT_"..serverId.."_"..playerId.."_WMPOS_"..worldMapId
	local positionStr = x.."_"..y
	cc.UserDefault:getInstance():setStringForKey(key, positionStr)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getWorldMapPosition(worldMapId)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_getWorldMapPosition(serverId, playerId, worldMapId)
end

function PreferenceManager:_getWorldMapPosition(serverId, playerId, worldMapId)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	local worldMapPosition = playerDefault["worldMapPosition"] or {}

	local position = worldMapPosition[worldMapId]

	if not position then
		local key   = "GAME_DEFAULT_"..serverId.."_"..playerId.."_WMPOS_"..worldMapId
		local positionStr = cc.UserDefault:getInstance():getStringForKey(key)
		local positionArray = string.split(positionStr, "_")
		if #positionArray == 2 then
			local x = checkint(positionArray[1])
			local y = checkint(positionArray[2])

			position = cc.p(x, y)
		end

		worldMapPosition[worldMapId] = position
	end

	return position
end

function PreferenceManager:clearWorldMapPosition(worldMapId)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	self:_clearWorldMapPosition(serverId, playerId, worldMapId)
end

function PreferenceManager:_clearWorldMapPosition(serverId, playerId, worldMapId)
	local playerDefault = self:getPlayerDefault(serverId, playerId)
	local worldMapPosition = playerDefault["worldMapPosition"] or {}
	local position = worldMapPosition[worldMapId]
	if position then
		-- 存在信息 删除当前信息
		worldMapPosition[worldMapId] = nil

		local key = "GAME_DEFAULT_"..serverId.."_"..playerId.."_WMPOS_"..worldMapId
		cc.UserDefault:getInstance():setStringForKey(key, "")
  		cc.UserDefault:getInstance():flush()
	end
end

--活跃活动相关
function PreferenceManager:setActivityState(activityId, state)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_setActivityState(serverId, playerId, activityId, state)
end

function PreferenceManager:_setActivityState(serverId, playerId, activityId, state)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	playerDefault["activityState"] = playerDefault["activityState"] or {}
	playerDefault["activityState"][activityId] = state

	local key   = string.format("GAME_DEFAULT_%d_%d_AS_%d", serverId, playerId, activityId)

	cc.UserDefault:getInstance():setIntegerForKey(key, state)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getActivityState(activityId)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_getActivityState(serverId, playerId, activityId)
end

function PreferenceManager:_getActivityState(serverId, playerId, activityId)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	playerDefault["activityState"] = playerDefault["activityState"] or {}

	if not isset(playerDefault["activityState"], activityId) then
		local key   = string.format("GAME_DEFAULT_%d_%d_AS_%d", serverId, playerId, activityId)
		local state = cc.UserDefault:getInstance():getIntegerForKey(key, 0)
		playerDefault["activityState"][activityId] = state
	end

	return playerDefault["activityState"][activityId]
end

-- 每日签到相关
function PreferenceManager:setDailySignin(array)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_setDailySignin(serverId, playerId, array)
end

function PreferenceManager:_setDailySignin(serverId, playerId, array)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	playerDefault["dailySignin"] = array

	local key   = "GAME_DEFAULT_"..serverId.."_"..playerId.."_TIMEID"
	local value = json.encode(array)

	cc.UserDefault:getInstance():setStringForKey(key, value)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getDailySignin()
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_getDailySignin(serverId, playerId)
end

function PreferenceManager:_getDailySignin(serverId, playerId)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	local array = playerDefault["dailySignin"]

	if not array then
		local key   = "GAME_DEFAULT_"..serverId.."_"..playerId.."_TIMEID"
		local stateJson = cc.UserDefault:getInstance():getStringForKey(key)
		if stateJson ~= "" then
			array = json.decode(stateJson)
		end
	end
	
	return array or {}
end

-- ################################################## 战斗数据 ##################################################
function PreferenceManager:_setBattleData(serverId, playerId, battleStr)
	local key = "GAME_DEFAULT_"..serverId.."_"..playerId.."_GBI"

	cc.UserDefault:getInstance():setStringForKey(key, battleStr)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:_getBattleData(serverId, playerId)
	local key = "GAME_DEFAULT_"..serverId.."_"..playerId.."_GBI"

	return cc.UserDefault:getInstance():getStringForKey(key, "")
end

----战力提升相关
function PreferenceManager:setPromoteState(stateArray)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_setPromoteState(serverId, playerId, stateArray)
end

function PreferenceManager:_setPromoteState(serverId, playerId, stateArray)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	playerDefault["promoteState"] = stateArray

	local key   = "GAME_DEFAULT_"..serverId.."_"..playerId.."_PS"
	local value = json.encode(stateArray)

	cc.UserDefault:getInstance():setStringForKey(key, value)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getPromoteState()
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_getPromoteState(serverId, playerId)
end

function PreferenceManager:_getPromoteState(serverId, playerId)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	local stateArray = playerDefault["promoteState"]

	if not stateArray then
		local key   = "GAME_DEFAULT_"..serverId.."_"..playerId.."_PS"
		local stateJson = cc.UserDefault:getInstance():getStringForKey(key)
		if stateJson ~= "" then
			stateArray = json.decode(stateJson)
		end
	end
	return stateArray or {}
end

----装备分解相关
function PreferenceManager:setResolveState(stateArray)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_setResolveState(serverId, playerId, stateArray)
end

function PreferenceManager:_setResolveState(serverId, playerId, stateArray)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	playerDefault["resolveState"] = stateArray

	local key   = "GAME_DEFAULT_"..serverId.."_"..playerId.."_RS"
	local value = json.encode(stateArray)

	cc.UserDefault:getInstance():setStringForKey(key, value)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getResolveState()
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_getResolveState(serverId, playerId)
end

function PreferenceManager:_getResolveState(serverId, playerId)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	local stateArray = playerDefault["resolveState"]

	if not stateArray then
		local key   = "GAME_DEFAULT_"..serverId.."_"..playerId.."_RS"
		local stateJson = cc.UserDefault:getInstance():getStringForKey(key)
		if stateJson ~= "" then
			stateArray = json.decode(stateJson)
		end
	end
	return stateArray or {}
end

-- 默认地下城难度
function PreferenceManager:getDungeonDifficulty(dungeonClassId)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_getDungeonDifficulty(serverId, playerId, dungeonClassId)
end

function PreferenceManager:_getDungeonDifficulty(serverId, playerId, dungeonClassId)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	local dungeonDifficulty = playerDefault["dungeonDifficulty"]
	if not dungeonDifficulty then
		dungeonDifficulty = {}
		playerDefault["dungeonDifficulty"] = dungeonDifficulty
	end

	if not isset(dungeonDifficulty, dungeonClassId) then
		dungeonDifficulty[dungeonClassId] = cc.UserDefault:getInstance():getIntegerForKey("GAME_DEFAULT_"..serverId.."_"..playerId.."_DD_"..dungeonClassId, lt.Constants.DIFFICULTY.NORMAL)
	end

	return dungeonDifficulty[dungeonClassId]
end

function PreferenceManager:setDungeonDifficulty(dungeonClassId, difficulty)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_setDungeonDifficulty(serverId, playerId, dungeonClassId, difficulty)
end

function PreferenceManager:_setDungeonDifficulty(serverId, playerId, dungeonClassId, difficulty)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	local dungeonDifficulty = playerDefault["dungeonDifficulty"]
	if not dungeonDifficulty then
		dungeonDifficulty = {}
		playerDefault["dungeonDifficulty"] = dungeonDifficulty
	end

	dungeonDifficulty[dungeonClassId] = difficulty

	cc.UserDefault:getInstance():setIntegerForKey("GAME_DEFAULT_"..serverId.."_"..playerId.."_DD_"..dungeonClassId, difficulty)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

-- 英灵特性筛选
function PreferenceManager:setServantCharacterFilter(filter)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_setServantCharacterFilter(serverId, playerId, filter)
end

function PreferenceManager:_setServantCharacterFilter(serverId, playerId, filter)
	local playerDefault = self:getPlayerDefault(serverId, playerId)
	
	playerDefault["servantCharacterFilter"] = filter

	cc.UserDefault:getInstance():setBoolForKey("GAME_DEFAULT_"..serverId.."_"..playerId.."_SCF", filter)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getServantCharacterFilter()
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_getServantCharacterFilter(serverId, playerId)
end
function PreferenceManager:_getServantCharacterFilter(serverId, playerId)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	local servantCharacterFilter = playerDefault["servantCharacterFilter"]
	if servantCharacterFilter == nil then
		servantCharacterFilter = cc.UserDefault:getInstance():getBoolForKey("GAME_DEFAULT_"..serverId.."_"..playerId.."_SCF", true)
	end

	return servantCharacterFilter
end

-- ################################################## 资源相关 ##################################################
---- 资源-地图
-- 资源-地图-地下城
function PreferenceManager:setResourceDungeonMap(dungeonId, md5)
	if not self._serverDefault["resource"] then
		self._serverDefault["resource"] = {}
	end

	if not self._serverDefault["resource"]["map"] then
		self._serverDefault["resource"]["map"] = {}
	end

	if not self._serverDefault["resource"]["map"]["dungeon"] then
		self._serverDefault["resource"]["map"]["dungeon"] = {}
	end

	self._serverDefault["resource"]["map"]["dungeon"][dungeonId] = md5
	local key = "GAME_DEFAULT_RESOURCE_MAP_DUNGEON_"..dungeonId
	cc.UserDefault:getInstance():setStringForKey(key, md5)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getResourceDungeonMap(dungeonId)
	if not self._serverDefault["resource"] then
		self._serverDefault["resource"] = {}
	end

	if not self._serverDefault["resource"]["map"] then
		self._serverDefault["resource"]["map"] = {}
	end

	if not self._serverDefault["resource"]["map"]["dungeon"] then
		self._serverDefault["resource"]["map"]["dungeon"] = {}
	end

	local md5 = self._serverDefault["resource"]["map"]["dungeon"][dungeonId]
	if not md5 then
		local key = "GAME_DEFAULT_RESOURCE_MAP_DUNGEON_"..dungeonId
		md5 = cc.UserDefault:getInstance():getStringForKey(key, "")
		self._serverDefault["resource"]["map"]["dungeon"][dungeonId] = md5
	end

	return md5
end

---- 资源-英灵(包括模型和技能)
function PreferenceManager:setResourceServant(modelId, md5)
	if not self._serverDefault["resource"] then
		self._serverDefault["resource"] = {}
	end

	if not self._serverDefault["resource"]["servant"] then
		self._serverDefault["resource"]["servant"] = {}
	end

	self._serverDefault["resource"]["servant"][modelId] = md5

	local key = "GAME_DEFAULT_RESOURCE_SERVANT_"..modelId
	cc.UserDefault:getInstance():setStringForKey(key, md5)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getResourceServant(modelId)
	if not self._serverDefault["resource"] then
		self._serverDefault["resource"] = {}
	end

	if not self._serverDefault["resource"]["servant"] then
		self._serverDefault["resource"]["servant"] = {}
	end

	local md5 = self._serverDefault["resource"]["servant"][modelId]
	if not md5 then
		local key = "GAME_DEFAULT_RESOURCE_SERVANT_"..modelId
		md5 = cc.UserDefault:getInstance():getStringForKey(key, "")
		self._serverDefault["resource"]["servant"][modelId] = md5
	end

	return md5
end

---- 资源-Boss(包括模型和技能)
function PreferenceManager:setResourceBoss(modelId, md5)
	if not self._serverDefault["resource"] then
		self._serverDefault["resource"] = {}
	end

	if not self._serverDefault["resource"]["boss"] then
		self._serverDefault["resource"]["boss"] = {}
	end

	self._serverDefault["resource"]["boss"][modelId] = md5

	local key = "GAME_DEFAULT_RESOURCE_BOSS_"..modelId
	cc.UserDefault:getInstance():setStringForKey(key, md5)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getResourceBoss(modelId)
	if not self._serverDefault["resource"] then
		self._serverDefault["resource"] = {}
	end

	if not self._serverDefault["resource"]["boss"] then
		self._serverDefault["resource"]["boss"] = {}
	end

	local md5 = self._serverDefault["resource"]["boss"][modelId]
	if not md5 then
		local key = "GAME_DEFAULT_RESOURCE_BOSS_"..modelId
		md5 = cc.UserDefault:getInstance():getStringForKey(key, "")
		self._serverDefault["resource"]["boss"][modelId] = md5
	end

	return md5
end

---- 资源-模型
function PreferenceManager:setResourceModel(modelId, md5)
	if not self._serverDefault["resource"] then
		self._serverDefault["resource"] = {}
	end

	if not self._serverDefault["resource"]["model"] then
		self._serverDefault["resource"]["model"] = {}
	end

	self._serverDefault["resource"]["model"][modelId] = md5

	local key = "GAME_DEFAULT_RESOURCE_MODEL_"..modelId
	cc.UserDefault:getInstance():setStringForKey(key, md5)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getResourceModel(modelId)
	if not self._serverDefault["resource"] then
		self._serverDefault["resource"] = {}
	end

	if not self._serverDefault["resource"]["model"] then
		self._serverDefault["resource"]["model"] = {}
	end

	local md5 = self._serverDefault["resource"]["model"][modelId]
	if not md5 then
		local key = "GAME_DEFAULT_RESOURCE_MODEL_"..modelId
		md5 = cc.UserDefault:getInstance():getStringForKey(key, "")
		self._serverDefault["resource"]["model"][modelId] = md5
	end

	return md5
end


---- 资源-技能

-- 资源-技能-英灵
function PreferenceManager:setResourceSSkill(skillId, md5)
	if not self._serverDefault["resource"] then
		self._serverDefault["resource"] = {}
	end

	if not self._serverDefault["resource"]["sskill"] then
		self._serverDefault["resource"]["sskill"] = {}
	end

	self._serverDefault["resource"]["sskill"][skillId] = md5

	local key = "GAME_DEFAULT_RESOURCE_SSKILL_"..skillId
	cc.UserDefault:getInstance():setStringForKey(key, md5)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getResourceSSkill(skillId)
	if not self._serverDefault["resource"] then
		self._serverDefault["resource"] = {}
	end

	if not self._serverDefault["resource"]["sskill"] then
		self._serverDefault["resource"]["sskill"] = {}
	end

	local md5 = self._serverDefault["resource"]["sskill"][skillId]
	if not md5 then
		local key = "GAME_DEFAULT_RESOURCE_SSKILL_"..skillId
		md5 = cc.UserDefault:getInstance():getStringForKey(key, "")
		self._serverDefault["resource"]["sskill"][skillId] = md5
	end

	return md5
end

-- 资源-技能-怪物
function PreferenceManager:setResourceSkill(skillId, md5)
	if not self._serverDefault["resource"] then
		self._serverDefault["resource"] = {}
	end

	if not self._serverDefault["resource"]["skill"] then
		self._serverDefault["resource"]["skill"] = {}
	end

	self._serverDefault["resource"]["skill"][skillId] = md5

	local key = "GAME_DEFAULT_RESOURCE_SKILL_"..skillId
	cc.UserDefault:getInstance():setStringForKey(key, md5)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getResourceSkill(skillId)
	if not self._serverDefault["resource"] then
		self._serverDefault["resource"] = {}
	end

	if not self._serverDefault["resource"]["skill"] then
		self._serverDefault["resource"]["skill"] = {}
	end

	local md5 = self._serverDefault["resource"]["skill"][skillId]
	if not md5 then
		local key = "GAME_DEFAULT_RESOURCE_SKILL_"..skillId
		md5 = cc.UserDefault:getInstance():getStringForKey(key, "")
		self._serverDefault["resource"]["skill"][skillId] = md5
	end

	return md5
end

-- ################################################## 公告设置 ##################################################
function PreferenceManager:setAnnouncementDaily(announcementDailySet)
	local settingDefault = self:getSettingDefault()

	settingDefault["announcement_daily"] = announcementDailySet

	local key = "GAME_DEFAULT_ANNOUNCEMENT_DAILY"

	cc.UserDefault:getInstance():setBoolForKey(key, announcementDailySet)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getAnnouncementDaily()
	local settingDefault = self:getSettingDefault()

	local announcementDailySet = settingDefault["announcement_daily"]
	if announcementDailySet == nil then
		local key = "GAME_DEFAULT_ANNOUNCEMENT_DAILY"
		announcementDailySet = cc.UserDefault:getInstance():getBoolForKey(key, false)
		settingDefault["announcement_daily"] = announcementDailySet
	end

	return announcementDailySet
end

-- 配合公告每日显示用
function PreferenceManager:setAnnouncementTime(announcementTime)
	if not announcementTime then
		announcementTime = lt.CommonUtil:getCurrentTime()
	end

	local settingDefault = self:getSettingDefault()

	settingDefault["announcement_time"] = announcementTime

	local key = "GAME_DEFAULT_ANNOUNCEMENT_TIME"

	cc.UserDefault:getInstance():setIntegerForKey(key, announcementTime)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getAnnouncementTime()
	local settingDefault = self:getSettingDefault()

	local announcementTimeSet = settingDefault["announcement_time"]
	if not announcementTimeSet then
		local key = "GAME_DEFAULT_ANNOUNCEMENT_TIME"
		announcementTimeSet = cc.UserDefault:getInstance():getIntegerForKey(key, 0)
		settingDefault["announcement_time"] = announcementTimeSet
	end

	return announcementTimeSet
end

-- ################################################## 游戏设置 ##################################################
function PreferenceManager:getSettingDefault()
	if not isset(self._gameDefault, "setting") then
		self._gameDefault["setting"] = {}
	end

	return self._gameDefault["setting"]
end

-- 游戏语音种类(0日语 默认, 1中文)
function PreferenceManager:setCastSet(castSet)
	local settingDefault = self:getSettingDefault()

	settingDefault["cast"] = castSet

	local key = "GAME_DEFAULT_SETTING_CAST"
	cc.UserDefault:getInstance():setIntegerForKey(key, castSet)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCastSet()
	local settingDefault = self:getSettingDefault()

	local castSet = settingDefault["cast"]
	if not castSet then
		local key = "GAME_DEFAULT_SETTING_CAST"
		castSet = cc.UserDefault:getInstance():getIntegerForKey(key, 1)
		settingDefault["cast"] = castSet
	end

	return castSet
end

-- 游戏音效音量
function PreferenceManager:setSoundOn(soundOn)
	local settingDefault = self:getSettingDefault()

	settingDefault["sound_on"] = soundOn

	local key = "GAME_DEFAULT_SETTING_SOUND_ON"
	cc.UserDefault:getInstance():setBoolForKey(key, soundOn)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getSoundOn()
	local settingDefault = self:getSettingDefault()

	local soundOn = settingDefault["sound_on"]
	if soundOn == nil then
		local key = "GAME_DEFAULT_SETTING_SOUND_ON"
		soundOn = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["sound_on"] = soundOn
	end

	return soundOn
end

function PreferenceManager:setSoundValue(soundValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["sound_value"] = soundValue

	local key = "GAME_DEFAULT_SETTING_SOUND_VALUE"
	cc.UserDefault:getInstance():setIntegerForKey(key, soundValue)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getSoundValue()
	local settingDefault = self:getSettingDefault()

	local soundValue = settingDefault["sound_value"]
	if not soundValue then
		local key = "GAME_DEFAULT_SETTING_SOUND_VALUE"
		soundValue = cc.UserDefault:getInstance():getIntegerForKey(key, 100)
		settingDefault["sound"] = soundValue
	end

	return soundValue
end

-- 游戏音乐音量
function PreferenceManager:setMusicOn(musicOn)
	local settingDefault = self:getSettingDefault()

	settingDefault["music_on"] = musicOn

	local key = "GAME_DEFAULT_SETTING_MUSIC_ON"
	cc.UserDefault:getInstance():setBoolForKey(key, musicOn)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getMusicOn()
	local settingDefault = self:getSettingDefault()

	local musicOn = settingDefault["music_on"]
	if musicOn == nil then
		local key = "GAME_DEFAULT_SETTING_MUSIC_ON"
		musicOn = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["music_on"] = musicOn
	end

	return musicOn
end

function PreferenceManager:setMusicValue(musicValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["music"] = musicValue

	local key = "GAME_DEFAULT_SETTING_MUSIC"
	cc.UserDefault:getInstance():setIntegerForKey(key, musicValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getMusicValue()
	local settingDefault = self:getSettingDefault()

	local musicValue = settingDefault["music"]
	if not musicValue then
		local key = "GAME_DEFAULT_SETTING_MUSIC"
		musicValue = cc.UserDefault:getInstance():getIntegerForKey(key, 100)
		settingDefault["music"] = musicValue
	end

	return musicValue
end

--个人设置
function PreferenceManager:setPushtipsOn(flag)
	local key = "GAME_DEFAULT_SETTING_PUSH_TIPS"
	cc.UserDefault:getInstance():setBoolForKey(key, flag)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getPushtipsOn()
	local key = "GAME_DEFAULT_SETTING_PUSH_TIPS"
	return cc.UserDefault:getInstance():getBoolForKey(key, true)
end

-- 语音播放
function PreferenceManager:setAutoAudioWorld(autoAudioWorldValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["auto_audio_world"] = autoAudioWorldValue

	local key = "GAME_DEFAULT_SETTING_AUTO_AUDIO_WORLD"
	cc.UserDefault:getInstance():setBoolForKey(key, autoAudioWorldValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getAutoAudioWorld()
	local settingDefault = self:getSettingDefault()

	local autoAudioWorldValue = settingDefault["auto_audio_world"]
	if autoAudioWorldValue == nil then
		local key = "GAME_DEFAULT_SETTING_AUTO_AUDIO_WORLD"
		autoAudioWorldValue = cc.UserDefault:getInstance():getBoolForKey(key, false)
		settingDefault["auto_audio_world"] = autoAudioWorldValue
	end

	return autoAudioWorldValue
end

function PreferenceManager:setAutoAudioGuild(autoAudioGuildValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["auto_audio_guild"] = autoAudioGuildValue

	local key = "GAME_DEFAULT_SETTING_AUTO_AUDIO_GUILD"
	cc.UserDefault:getInstance():setBoolForKey(key, autoAudioGuildValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getAutoAudioGuild()
	local settingDefault = self:getSettingDefault()

	local autoAudioGuildValue = settingDefault["auto_audio_guild"]
	if autoAudioGuildValue == nil then
		local key = "GAME_DEFAULT_SETTING_AUTO_AUDIO_GUILD"
		autoAudioGuildValue = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["auto_audio_guild"] = autoAudioGuildValue
	end

	return autoAudioGuildValue
end

function PreferenceManager:setAutoAudioCurrent(autoAudioCurrentValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["auto_audio_current"] = autoAudioCurrentValue

	local key = "GAME_DEFAULT_SETTING_AUTO_AUDIO_CURRENT"
	cc.UserDefault:getInstance():setBoolForKey(key, autoAudioCurrentValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getAutoAudioCurrent()
	local settingDefault = self:getSettingDefault()

	local autoAudioCurrentValue = settingDefault["auto_audio_current"]
	if autoAudioCurrentValue == nil then
		local key = "GAME_DEFAULT_SETTING_AUTO_AUDIO_CURRENT"
		autoAudioCurrentValue = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["auto_audio_current"] = autoAudioCurrentValue
	end

	return autoAudioCurrentValue
end

function PreferenceManager:setAutoAudioAnswerParty(autoAudioCurrentValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["auto_audio_answer_party"] = autoAudioCurrentValue

	local key = "GAME_DEFAULT_SETTING_AUTO_AUDIO_ANSWER_PARTY"
	cc.UserDefault:getInstance():setBoolForKey(key, autoAudioCurrentValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getAutoAudioAnswerParty()
	local settingDefault = self:getSettingDefault()

	local autoAudioCurrentValue = settingDefault["auto_audio_answer_party"]
	if autoAudioCurrentValue == nil then
		local key = "GAME_DEFAULT_SETTING_AUTO_AUDIO_ANSWER_PARTY"
		autoAudioCurrentValue = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["auto_audio_answer_party"] = autoAudioCurrentValue
	end

	return autoAudioCurrentValue
end

function PreferenceManager:setAutoAudioTeam(autoAudioTeamValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["auto_audio_team"] = autoAudioTeamValue

	local key = "GAME_DEFAULT_SETTING_AUTO_AUDIO_TEAM"
	cc.UserDefault:getInstance():setBoolForKey(key, autoAudioTeamValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getAutoAudioTeam()
	local settingDefault = self:getSettingDefault()

	local autoAudioTeamValue = settingDefault["auto_audio_team"]
	if autoAudioTeamValue == nil then
		local key = "GAME_DEFAULT_SETTING_AUTO_AUDIO_TEAM"
		autoAudioTeamValue = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["auto_audio_team"] = autoAudioTeamValue
	end

	return autoAudioTeamValue
end

--弹幕开关

function PreferenceManager:setAutoBarrageWorld(autoAudioTeamValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["auto_barrage_world"] = autoAudioTeamValue

	local key = "GAME_DEFAULT_SETTING_AUTO_BARRAGE_WORLD"
	cc.UserDefault:getInstance():setBoolForKey(key, autoAudioTeamValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getAutoBarrageWorld()
	local settingDefault = self:getSettingDefault()

	local autoAudioTeamValue = settingDefault["auto_barrage_world"]
	if autoAudioTeamValue == nil then
		local key = "GAME_DEFAULT_SETTING_AUTO_BARRAGE_WORLD"
		autoAudioTeamValue = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["auto_barrage_world"] = autoAudioTeamValue
	end

	return autoAudioTeamValue
end

--
function PreferenceManager:setAutoBarrageTeam(autoAudioTeamValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["auto_barrage_team"] = autoAudioTeamValue

	local key = "GAME_DEFAULT_SETTING_AUTO_BARRAGE_TEAM"
	cc.UserDefault:getInstance():setBoolForKey(key, autoAudioTeamValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getAutoBarrageTeam()
	local settingDefault = self:getSettingDefault()

	local autoAudioTeamValue = settingDefault["auto_barrage_team"]
	if autoAudioTeamValue == nil then
		local key = "GAME_DEFAULT_SETTING_AUTO_BARRAGE_TEAM"
		autoAudioTeamValue = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["auto_barrage_team"] = autoAudioTeamValue
	end

	return autoAudioTeamValue
end

--
function PreferenceManager:setAutoBarrageGuild(autoAudioTeamValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["auto_barrage_guild"] = autoAudioTeamValue

	local key = "GAME_DEFAULT_SETTING_AUTO_BARRAGE_GUILD"
	cc.UserDefault:getInstance():setBoolForKey(key, autoAudioTeamValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getAutoBarrageGuild()
	local settingDefault = self:getSettingDefault()

	local autoAudioTeamValue = settingDefault["auto_barrage_guild"]
	if autoAudioTeamValue == nil then
		local key = "GAME_DEFAULT_SETTING_AUTO_BARRAGE_GUILD"
		autoAudioTeamValue = cc.UserDefault:getInstance():getBoolForKey(key, false)
		settingDefault["auto_barrage_guild"] = autoAudioTeamValue
	end

	return autoAudioTeamValue
end

--
function PreferenceManager:setAutoBarrageCurrent(autoAudioTeamValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["auto_barrage_current"] = autoAudioTeamValue

	local key = "GAME_DEFAULT_SETTING_AUTO_BARRAGE_CURRENT"
	cc.UserDefault:getInstance():setBoolForKey(key, autoAudioTeamValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getAutoBarrageCurrent()
	local settingDefault = self:getSettingDefault()

	local autoAudioTeamValue = settingDefault["auto_barrage_current"]
	if autoAudioTeamValue == nil then
		local key = "GAME_DEFAULT_SETTING_AUTO_BARRAGE_CURRENT"
		autoAudioTeamValue = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["auto_barrage_current"] = autoAudioTeamValue
	end

	return autoAudioTeamValue
end


--主界面显示的聊天频道
function PreferenceManager:setChannelWorld(channelValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["channel_world"] = channelValue

	local key = "GAME_DEFAULT_SETTING_CHANNEL_WORLD"
	cc.UserDefault:getInstance():setBoolForKey(key, channelValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getChannelWorld()
	local settingDefault = self:getSettingDefault()

	local channelValue = settingDefault["channel_world"]
	if channelValue == nil then
		local key = "GAME_DEFAULT_SETTING_CHANNEL_WORLD"
		channelValue = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["channel_world"] = channelValue
	end

	return channelValue
end

function PreferenceManager:setChannelTeam(channelValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["channel_team"] = channelValue

	local key = "GAME_DEFAULT_SETTING_CHANNEL_TEAM"
	cc.UserDefault:getInstance():setBoolForKey(key, channelValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getChannelTeam()
	local settingDefault = self:getSettingDefault()

	local channelValue = settingDefault["channel_team"]
	if channelValue == nil then
		local key = "GAME_DEFAULT_SETTING_CHANNEL_TEAM"
		channelValue = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["channel_team"] = channelValue
	end

	return channelValue
end

function PreferenceManager:setChannelInvite(channelValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["channel_invite"] = channelValue

	local key = "GAME_DEFAULT_SETTING_CHANNEL_INVITE"
	cc.UserDefault:getInstance():setBoolForKey(key, channelValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getChannelInvite()
	local settingDefault = self:getSettingDefault()

	local channelValue = settingDefault["channel_invite"]
	if channelValue == nil then
		local key = "GAME_DEFAULT_SETTING_CHANNEL_INVITE"
		channelValue = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["channel_invite"] = channelValue
	end

	return channelValue
end

function PreferenceManager:setChannelGuild(channelValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["channel_guild"] = channelValue

	local key = "GAME_DEFAULT_SETTING_CHANNEL_GUILD"
	cc.UserDefault:getInstance():setBoolForKey(key, channelValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getChannelGuild()
	local settingDefault = self:getSettingDefault()

	local channelValue = settingDefault["channel_guild"]
	if channelValue == nil then
		local key = "GAME_DEFAULT_SETTING_CHANNEL_GUILD"
		channelValue = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["channel_guild"] = channelValue
	end

	return channelValue
end

function PreferenceManager:setChannelCurrent(channelValue)
	local settingDefault = self:getSettingDefault()
	settingDefault["channel_current"] = channelValue

	local key = "GAME_DEFAULT_SETTING_CHANNEL_CURRENT"
	cc.UserDefault:getInstance():setBoolForKey(key, channelValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getChannelCurrent()
	local settingDefault = self:getSettingDefault()

	local channelValue = settingDefault["channel_current"]
	if channelValue == nil then
		local key = "GAME_DEFAULT_SETTING_CHANNEL_CURRENT"
		channelValue = cc.UserDefault:getInstance():getBoolForKey(key, false)
		settingDefault["channel_current"] = channelValue
	end

	return channelValue
end

function PreferenceManager:setInviteReference(channelValue)
	local settingDefault = self:getSettingDefault()

	settingDefault["invite_reference"] = channelValue

	local key = "GAME_DEFAULT_SETTING_INVITE_REFERENCE"
	cc.UserDefault:getInstance():setBoolForKey(key, channelValue)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getInviteReference()
	local settingDefault = self:getSettingDefault()

	local channelValue = settingDefault["invite_reference"]
	if channelValue == nil then
		local key = "GAME_DEFAULT_SETTING_INVITE_REFERENCE"
		channelValue = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["invite_reference"] = channelValue
	end

	return channelValue
end


-- 游戏减图片质量优化
function PreferenceManager:setTextureSet(textureSet)
	local settingDefault = self:getSettingDefault()

	settingDefault["texture"] = textureSet

	local key = "GAME_DEFAULT_SETTING_TEXTURE"
	cc.UserDefault:getInstance():setIntegerForKey(key, textureSet)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getTextureSet()
	local settingDefault = self:getSettingDefault()

	local textureSet = settingDefault["texture"]
	if not textureSet then
		-- 默认设置
		local key = "GAME_DEFAULT_SETTING_TEXTURE"
		local default = 3
		if device.platform == "android" then
			default = 2
		end
		textureSet = cc.UserDefault:getInstance():getIntegerForKey(key, default)
		settingDefault["texture"] = textureSet
	end

	return textureSet
end

-- 游戏降帧优化
function PreferenceManager:setOptimisedSet(optimisedSet)
	local settingDefault = self:getSettingDefault()

	settingDefault["optimised"] = optimisedSet

	local key = "GAME_DEFAULT_SETTING_OPTIMISED"
	cc.UserDefault:getInstance():setBoolForKey(key, optimisedSet)  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getOptimisedSet()
	local settingDefault = self:getSettingDefault()

	local optimisedSet = settingDefault["optimised"]
	if optimisedSet == nil then
		local key = "GAME_DEFAULT_SETTING_OPTIMISED"
		local default = true
		optimisedSet = cc.UserDefault:getInstance():getBoolForKey(key, default)
		settingDefault["optimised"] = optimisedSet
	end

	return optimisedSet
end

-- 游戏降帧测试
function PreferenceManager:setFrameSet(frameSet)
	local settingDefault = self:getSettingDefault()

	settingDefault["frame"] = frameSet

	local key = "GAME_DEFAULT_SETTING_FRAME"
	cc.UserDefault:getInstance():setBoolForKey(key, frameSet)  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getFrameSet()
	local settingDefault = self:getSettingDefault()

	local frameSet = settingDefault["frame"]
	if frameSet == nil then
		local key = "GAME_DEFAULT_SETTING_FRAME"
		frameSet = cc.UserDefault:getInstance():getBoolForKey(key, false)
		settingDefault["frame"] = frameSet
	end

	return frameSet
end

-- 游戏消息通知
function PreferenceManager:setNoticeSet(noticeSet)
	local settingDefault = self:getSettingDefault()

	settingDefault["notice"] = noticeSet

	local key = "GAME_DEFAULT_SETTING_NOTICE"
	cc.UserDefault:getInstance():setBoolForKey(key, noticeSet)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getNoticeSet()
	local settingDefault = self:getSettingDefault()

	local noticeSet = settingDefault["notice"]
	if noticeSet == nil then
		local key = "GAME_DEFAULT_SETTING_NOTICE"
		noticeSet = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["notice"] = noticeSet
	end

	return noticeSet
end


-- 游戏消息通知
function PreferenceManager:setNoticeSetting(tag,noticeSet)
	local settingDefault = self:getSettingDefault()

	settingDefault[tag] = noticeSet

	local key = "GAME_DEFAULT_SETTING_NOTICE_"..tag
	cc.UserDefault:getInstance():setBoolForKey(key, noticeSet)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getNoticeSetting(tag)
	local settingDefault = self:getSettingDefault()

	local noticeSet = settingDefault[tag]
	if noticeSet == nil then
		local key = "GAME_DEFAULT_SETTING_NOTICE_"..tag
		noticeSet = cc.UserDefault:getInstance():getBoolForKey(key, false)
		settingDefault[tag] = noticeSet
	end

	return noticeSet
end

function PreferenceManager:setNoticeInited(flag)
	local key = "GAME_DEFAULT_SETTING_NOTICE_INITIED"
	cc.UserDefault:getInstance():setBoolForKey(key, flag)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getNoticeInited()
	local key = "GAME_DEFAULT_SETTING_NOTICE_INITIED"
	return cc.UserDefault:getInstance():getBoolForKey(key, false)
end


-- 游戏战斗语音
function PreferenceManager:setBattleVoiceSet(voiceSet)
	local settingDefault = self:getSettingDefault()

	settingDefault["battle_voice"] = voiceSet

	local key = "GAME_DEFAULT_SETTING_BATTLE_VOICE"
	cc.UserDefault:getInstance():setBoolForKey(key, voiceSet)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getBattleVoiceSet()
	local settingDefault = self:getSettingDefault()

	local voiceSet = settingDefault["battle_voice"]
	if voiceSet == nil then
		local key = "GAME_DEFAULT_SETTING_BATTLE_VOICE"
		voiceSet = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault["battle_voice"] = voiceSet
	end

	return voiceSet
end

-- 游戏战斗麦克风
function PreferenceManager:setBattleMicSet(micSet)
	local settingDefault = self:getSettingDefault()

	settingDefault["battle_mic"] = micSet

	local key = "GAME_DEFAULT_SETTING_BATTLE_MIC"
	cc.UserDefault:getInstance():setBoolForKey(key, micSet)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getBattleMicSet()
	local settingDefault = self:getSettingDefault()

	local micSet = settingDefault["battle_mic"]
	if micSet == nil then
		local key = "GAME_DEFAULT_SETTING_BATTLE_MIC"
		micSet = cc.UserDefault:getInstance():getBoolForKey(key, false)
		settingDefault["battle_mic"] = micSet
	end

	return micSet
end

-- 游戏技能自动释放设置
function PreferenceManager:setAutoHeroSkill(index,value)
	local settingDefault = self:getSettingDefault()
	local key1 = "auto_hero_skill_"..index
	settingDefault[key1] = value

	local key = "GAME_DEFAULT_SETTING_AUTO_HERO_SKILL_"..index
	cc.UserDefault:getInstance():setBoolForKey(key, value)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getAutoHeroSkill(index)
	local settingDefault = self:getSettingDefault()

	local skillKey = "auto_hero_skill_"..index
	local autoHeroSkillValue = settingDefault[skillKey]
	if autoHeroSkillValue == nil then
		local key = "GAME_DEFAULT_SETTING_AUTO_HERO_SKILL_"..index
		autoHeroSkillValue = cc.UserDefault:getInstance():getBoolForKey(key, true)
		settingDefault[skillKey] = autoHeroSkillValue
	end

	return autoHeroSkillValue
end

-- 游戏自动战斗设置
function PreferenceManager:setAutoBattle(autoBattle)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_setAutoBattle(serverId, playerId, autoBattle)
end

function PreferenceManager:_setAutoBattle(serverId, playerId, autoBattle)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	playerDefault["auto_battle"] = autoBattle

	local key   = "GAME_DEFAULT_SETTING_AUTO_BATTLE_"..serverId.."_"..playerId

	cc.UserDefault:getInstance():setBoolForKey(key, autoBattle)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getAutoBattle()
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	return self:_getAutoBattle(serverId, playerId)
end

function PreferenceManager:_getAutoBattle(serverId, playerId)
	local playerDefault = self:getPlayerDefault(serverId, playerId)

	local autoBattle = playerDefault["auto_battle"]
	if autoBattle == nil then
		local key   = "GAME_DEFAULT_SETTING_AUTO_BATTLE_"..serverId.."_"..playerId
		autoBattle = cc.UserDefault:getInstance():getBoolForKey(key, true)
		playerDefault["auto_battle"] = autoBattle
	end

	return autoBattle
end

-- ################################################## 搜索历史 ##################################################
function PreferenceManager:addSearchHistory(simpleItem)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()
	local key = "GAME_SEARCH_HISTORY_"..serverId.."_"..playerId
	local searchHistoryArray = self:getSearchHistory()
	for _,searchHistory in pairs(searchHistoryArray) do
		if searchHistory.itemType == simpleItem.itemType and searchHistory.itemModelId == simpleItem.itemModelId then
			return
		end
	end
	local count = #searchHistoryArray
	if count >= 8 then
		table.remove(searchHistoryArray,1)
	end
	searchHistoryArray[#searchHistoryArray+1] = simpleItem
	cc.UserDefault:getInstance():setStringForKey(key, json.encode(searchHistoryArray))
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getSearchHistory()
	if not self._searchHistoryArray then
		local serverId = lt.DataManager:getCurServerId()
		local playerId = lt.DataManager:getPlayerId()
		local key = "GAME_SEARCH_HISTORY_"..serverId.."_"..playerId
		local searchHistory = cc.UserDefault:getInstance():getStringForKey(key, "{}")
		self._searchHistoryArray = json.decode(searchHistory)
	end
	return self._searchHistoryArray
end

function PreferenceManager:setWorldPlayerCount(worldPlayerCount)
	local settingDefault = self:getSettingDefault()

	settingDefault["world_player_count"] = worldPlayerCount

	local key = "GAME_DEFAULT_SETTING_WORLD_PLAYER_COUNT"
	cc.UserDefault:getInstance():setIntegerForKey(key, worldPlayerCount)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getWorldPlayerCount()
	local settingDefault = self:getSettingDefault()

	local worldPlayerCount = settingDefault["world_player_count"]
	if worldPlayerCount == nil then
		local key = "GAME_DEFAULT_SETTING_WORLD_PLAYER_COUNT"
		local default = 8
		if device.platform == "ios" then
			default = 12
		end
		worldPlayerCount = cc.UserDefault:getInstance():getIntegerForKey(key, default)
		settingDefault["world_player_count"] = worldPlayerCount
	end

	return worldPlayerCount
end

-- 视野范围
function PreferenceManager:setWorldViewRange(vorldViewRange)
	local settingDefault = self:getSettingDefault()

	settingDefault["world_view_range"] = vorldViewRange

	local key = "GAME_DEFAULT_SETTING_WORLD_VIEW_RANGE"
	cc.UserDefault:getInstance():setIntegerForKey(key, vorldViewRange)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getWorldViewRange()
	local settingDefault = self:getSettingDefault()

	local worldViewRange = settingDefault["world_view_range"]
	if worldViewRange == nil then
		local key = "GAME_DEFAULT_SETTING_WORLD_VIEW_RANGE"
		local default = 2
		worldViewRange = cc.UserDefault:getInstance():getIntegerForKey(key, default)
		settingDefault["world_view_range"] = worldViewRange
	end

	return worldViewRange
end

function PreferenceManager:setSelectMonsterId(monsterId)--魔王的宝藏上次选择的id
	local settingDefault = self:getSettingDefault()
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()
	settingDefault["select_monster_id"] = monsterId

	local key = "GAME_DEFAULT_SELECT_MONSTER_ID"..serverId.."_"..playerId
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
	-- 刷新写入  
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getSelectMonsterId()
	local settingDefault = self:getSettingDefault()

	local monsterId = settingDefault["select_monster_id"]
	if monsterId == nil then
		local serverId = lt.DataManager:getCurServerId()
		local playerId = lt.DataManager:getPlayerId()
		local key = "GAME_DEFAULT_SELECT_MONSTER_ID"..serverId.."_"..playerId
		monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
		settingDefault["select_monster_id"] = monsterId
	end

	return monsterId
end

-- ################################################## 活跃活动推送与提示 ##################################################
--活跃活动推送开关
function PreferenceManager:setActiveActivityCallmeSwitch(activityId, flag)
	local key = "GAME_ACTIVITY_CALL_ME"
	local activeActivityPushTable = self:getActiveActivityCallmeTable()

	activeActivityPushTable[tostring(activityId)] = flag
	cc.UserDefault:getInstance():setStringForKey(key, json.encode(activeActivityPushTable))
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getActiveActivityCallmeTable()
	if not self._activeActivityCallmeTable then
		local key = "GAME_ACTIVITY_CALL_ME"
		local activeActivityPushTable = cc.UserDefault:getInstance():getStringForKey(key, "{}")
		self._activeActivityCallmeTable = json.decode(activeActivityPushTable)
	end
	return self._activeActivityCallmeTable
end

function PreferenceManager:reSetActiveActivityCallmeSwitch()
	local key = "GAME_ACTIVITY_CALL_ME"
	local activeActivityPushTable = {}
	cc.UserDefault:getInstance():setStringForKey(key, json.encode(activeActivityPushTable))
  	cc.UserDefault:getInstance():flush()
  	self._activeActivityCallmeTable = nil
end

function PreferenceManager:clearActiveActivityCallmeSwitch()
	local activeActivityPushTable = self:getActiveActivityCallmeTable()
	for k,v in pairs(activeActivityPushTable) do
		v = false
	end
	local key = "GAME_ACTIVITY_CALL_ME"
	cc.UserDefault:getInstance():setStringForKey(key, json.encode(activeActivityPushTable))
  	cc.UserDefault:getInstance():flush()
end

--活跃活动提示开关
function PreferenceManager:setActiveActivityPushSwitch(activityId, flag)
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()
	local key = "GAME_ACTIVITY_PUSH"..serverId.."_"..playerId
	local activeActivityPushTable = self:getActiveActivityPushTable()
	activeActivityPushTable[tostring(activityId)] = flag
	cc.UserDefault:getInstance():setStringForKey(key, json.encode(activeActivityPushTable))
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getActiveActivityPushTable()
	if not self._activeActivityPushTable then
		local serverId = lt.DataManager:getCurServerId()
		local playerId = lt.DataManager:getPlayerId()
		local key = "GAME_ACTIVITY_PUSH"..serverId.."_"..playerId
		local activeActivityPushTable = cc.UserDefault:getInstance():getStringForKey(key, "{}")
		self._activeActivityPushTable = json.decode(activeActivityPushTable)
	end
	return self._activeActivityPushTable
end

-- ################################################## 称号 ##################################################
--称号红点
function PreferenceManager:setPlayerTitleNotice(titleId, flag)
	local settingDefault = self:getSettingDefault()

	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()

	local key = "GAME_PLAYER_TITLE_NOTICE"..serverId.."_"..playerId
	local titleTable = self:getPlayerTitleNotice()
	titleTable[tostring(titleId)] = flag
	cc.UserDefault:getInstance():setStringForKey(key, json.encode(titleTable))
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getPlayerTitleNotice()
	if not self._playerTitleNotice then
		local serverId = lt.DataManager:getCurServerId()
		local playerId = lt.DataManager:getPlayerId()
		local key = "GAME_PLAYER_TITLE_NOTICE"..serverId.."_"..playerId
		local activeActivityPushTable = cc.UserDefault:getInstance():getStringForKey(key, "{}")
		self._playerTitleNotice = json.decode(activeActivityPushTable)
	end
	return self._playerTitleNotice
end

function PreferenceManager:resetPlayerTitleNotice()
	if self._playerTitleNotice then
		self._playerTitleNotice = nil
	end

	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()
	local key = "GAME_PLAYER_TITLE_NOTICE"..serverId.."_"..playerId
	local titleTable = {}
	cc.UserDefault:getInstance():setStringForKey(key, json.encode(titleTable))
  	cc.UserDefault:getInstance():flush()
end

--玩家获取的称号
function PreferenceManager:setPlayerTitle(titleId, info)--0 为永久 
	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()
	local key = "GAME_PLAYER_TITLE"..serverId.."_"..playerId
	local titleTable = self:getPlayerTitleTable() or {}
	titleTable[tostring(titleId)] = info
	cc.UserDefault:getInstance():setStringForKey(key, json.encode(titleTable))
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getPlayerTitleTable()
	if not self._playerTitleTable then
		local serverId = lt.DataManager:getCurServerId()
		local playerId = lt.DataManager:getPlayerId()
		local key = "GAME_PLAYER_TITLE"..serverId.."_"..playerId
		local activeActivityPushTable = cc.UserDefault:getInstance():getStringForKey(key)
		self._playerTitleTable = json.decode(activeActivityPushTable)
	end
	return self._playerTitleTable
end

function PreferenceManager:resetPlayerTitle(tempTitleTable)--重设
	if self._playerTitleTable then
		self._playerTitleTable = nil
	end
	if not tempTitleTable then
		tempTitleTable = {}
	end

	local serverId = lt.DataManager:getCurServerId()
	local playerId = lt.DataManager:getPlayerId()
	local key = "GAME_PLAYER_TITLE"..serverId.."_"..playerId
	cc.UserDefault:getInstance():setStringForKey(key, json.encode(tempTitleTable))
  	cc.UserDefault:getInstance():flush()
end

-- ################################################## 自定义设备号 ##################################################
PreferenceManager._customDevice = nil
function PreferenceManager:getCustomDevice(token)
	if not self._customDevice then
		self._customDevice = cc.UserDefault:getInstance():getStringForKey("GAME_CUSTOM_DEVICE", "")

		if self._customDevice == "" then
			-- 首次初始化 没有数据 创建
			token = token or ""

			self._customDevice = string.format("%s_%.0f", token, lt.SocketManager:getTime() * 1000)
			cc.UserDefault:getInstance():setStringForKey("GAME_CUSTOM_DEVICE", self._customDevice)
			cc.UserDefault:getInstance():flush()
		end
	end

	return self._customDevice
end

-- ################################################## 操作设定 ##################################################
function PreferenceManager:setKeyControlInfo(keyControlTable)
	self._keyControlTable = clone(keyControlTable)

	local keyControlInfo = json.encode(self._keyControlTable)

	cc.UserDefault:getInstance():setStringForKey("GAME_KEY_CONTROL_INFO", keyControlInfo)
	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getKeyControlInfo()
	if not self._keyControlTable then
		local keyControlInfo = cc.UserDefault:getInstance():getStringForKey("GAME_KEY_CONTROL_INFO", "")
		self._keyControlTable = json.decode(keyControlInfo) or {}
	end

	return self._keyControlTable
end

return PreferenceManager
