
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

return PreferenceManager