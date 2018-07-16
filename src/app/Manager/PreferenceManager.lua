
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

-- ################################################## 游戏设置 ##################################################
function PreferenceManager:getSettingDefault()
	if not isset(self._gameDefault, "setting") then
		self._gameDefault["setting"] = {}
	end

	return self._gameDefault["setting"]
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

function PreferenceManager:setBgcolor(monsterId)--游戏背景颜色选择保存
	local key = "SELECTBGCOLOR"..lt.DataManager:getPlayerUid()
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getBgcolor()
	local key = "SELECTBGCOLOR"..lt.DataManager:getPlayerUid()
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setMJcolor(monsterId)--记录选中麻将颜色
	local key = "SELECTMJCOLOR"..lt.DataManager:getPlayerUid()
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getMJcolor()
	local key = "SELECTMJCOLOR"..lt.DataManager:getPlayerUid()
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setGemeyy(monsterId)--记录选中游戏音乐
	local key = "SELECTGAMEYY"..lt.DataManager:getPlayerUid()
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getGemeyy()
	local key = "SELECTGAMEYY"..lt.DataManager:getPlayerUid()
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setGamelanguage(monsterId)--记录选中游戏语言
	local key = "SELECTGAMELANGUAGE"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getGamelanguage()
	local key = "SELECTGAMELANGUAGE"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setGameyuyin(monsterId)--记录game语音
	local key = "SELECTGAMEYUYIN"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getGameyuyin()
	local key = "SELECTGAMEYUYIN"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setGamevibrate(monsterId)--记录game震动提醒
	local key = "SELECTGAMEVIBRATE"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getGamevibrate()
	local key = "SELECTGAMEVIBRATE"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setGameshake(monsterId)--记录game抖动特效
	local key = "SELECTGAMESHAKE"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getGameshake()
	local key = "SELECTGAMESHAKE"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoA(monsterId)--记录推到胡记录房间信息资费
	local key = "CREATEROOMINFOTDHA"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoA()
	local key = "CREATEROOMINFOTDHA"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoB(monsterId)--记录推到胡记录房间信息 圈数
	local key = "CREATEROOMINFOTDHB"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoB()
	local key = "CREATEROOMINFOTDHB"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoC(monsterId)--记录推到胡记录房间信息 胡牌
	local key = "CREATEROOMINFOTDHC"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoC()
	local key = "CREATEROOMINFOTDHC"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoD(monsterId)--记录推到胡记录房间信息 报听
	local key = "CREATEROOMINFOTDHD"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoD()
	local key = "CREATEROOMINFOTDHD"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoE(monsterId)--记录推到胡记录房间信息 只可自摸胡
	local key = "CREATEROOMINFOTDHE"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoE()
	local key = "CREATEROOMINFOTDHE"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoF(monsterId)--记录推到胡记录房间信息 只可自摸胡
	local key = "CREATEROOMINFOTDHF"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoF()
	local key = "CREATEROOMINFOTDHF"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoSQMJA(monsterId)--记录商丘麻将记录房间信息 资费
	local key = "CREATEROOMINFOSQMJA"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoSQMJA()
	local key = "CREATEROOMINFOSQMJA"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoSQMJB(monsterId)--记录商丘麻将记录房间信息 圈数
	local key = "CREATEROOMINFOSQMJB"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoSQMJB()
	local key = "CREATEROOMINFOSQMJB"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoSQMJC(monsterId)--记录商丘麻将记录房间信息 风牌
	local key = "CREATEROOMINFOSQMJC"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoSQMJC()
	local key = "CREATEROOMINFOSQMJC"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoSQMJD(monsterId)--记录商丘麻将记录房间信息 下跑
	local key = "CREATEROOMINFOSQMJD"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoSQMJD()
	local key = "CREATEROOMINFOSQMJD"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoSQMJE(monsterId)--记录商丘麻将记录房间信息 暗杠锁死
	local key = "CREATEROOMINFOSQMJE"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoSQMJE()
	local key = "CREATEROOMINFOSQMJE"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoSQMJF(monsterId)--记录商丘麻将记录房间信息 亮四打一
	local key = "CREATEROOMINFOSQMJF"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoSQMJF()
	local key = "CREATEROOMINFOSQMJF"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoSQMJG(monsterId)--记录商丘麻将记录房间信息 掐张
	local key = "CREATEROOMINFOSQMJG"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoSQMJG()
	local key = "CREATEROOMINFOSQMJG"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoSQMJH(monsterId)--记录商丘麻将记录房间信息 偏次
	local key = "CREATEROOMINFOSQMJH"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoSQMJH()
	local key = "CREATEROOMINFOSQMJH"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoSQMJI(monsterId)--记录商丘麻将记录房间信息 缺门
	local key = "CREATEROOMINFOSQMJI"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoSQMJI()
	local key = "CREATEROOMINFOSQMJI"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoSQMJJ(monsterId)--记录商丘麻将记录房间信息 门清
	local key = "CREATEROOMINFOSQMJJ"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoSQMJJ()
	local key = "CREATEROOMINFOSQMJJ"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoSQMJK(monsterId)--记录商丘麻将记录房间信息 暗卡
	local key = "CREATEROOMINFOSQMJK"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoSQMJK()
	local key = "CREATEROOMINFOSQMJK"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoSQMJL(monsterId)--记录商丘麻将记录房间信息 自摸加嘴
	local key = "CREATEROOMINFOSQMJL"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoSQMJL()
	local key = "CREATEROOMINFOSQMJL"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoSQMJM(monsterId)--记录商丘麻将记录房间信息 对对胡
	local key = "CREATEROOMINFOSQMJM"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoSQMJM()
	local key = "CREATEROOMINFOSQMJM"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoSQMJN(monsterId)--记录商丘麻将记录房间信息 明听暗听
	local key = "CREATEROOMINFOSQMJN"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoSQMJN()
	local key = "CREATEROOMINFOSQMJN"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoPLZA(monsterId)--记录飘癞子记录房间信息 资费
	local key = "CREATEROOMINFOPLZA"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoPLZA()
	local key = "CREATEROOMINFOPLZA"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoPLZB(monsterId)--记录飘癞子记录房间信息 圈数
	local key = "CREATEROOMINFOPLZB"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoPLZB()
	local key = "CREATEROOMINFOPLZB"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoPLZC(monsterId)--记录飘癞子记录房间信息 是否可点炮
	local key = "CREATEROOMINFOPLZC"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoPLZC()
	local key = "CREATEROOMINFOPLZC"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
		--monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoHZMJA(monsterId)--记录红中麻将记录房间信息 资费
	local key = "CREATEROOMINFOHZMJA"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoHZMJA()
	local key = "CREATEROOMINFOHZMJA"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoHZMJB(monsterId)--记录红中麻将记录房间信息 圈数
	local key = "CREATEROOMINFOHZMJB"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoHZMJB()
	local key = "CREATEROOMINFOHZMJB"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoHZMJC(monsterId)--记录红中麻将记录房间信息 人数
	local key = "CREATEROOMINFOHZMJC"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoHZMJC()
	local key = "CREATEROOMINFOHZMJC"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoHZMJD(monsterId)--记录红中麻将记录房间信息 奖码数
	local key = "CREATEROOMINFOHZMJD"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoHZMJD()
	local key = "CREATEROOMINFOHZMJD"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoHZMJE(monsterId)--记录红中麻将记录房间信息 可胡七对
	local key = "CREATEROOMINFOHZMJE"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoHZMJE()
	local key = "CREATEROOMINFOHZMJE"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoHZMJF(monsterId)--记录红中麻将记录房间信息 喜分
	local key = "CREATEROOMINFOHZMJF"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoHZMJF()
	local key = "CREATEROOMINFOHZMJF"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoHZMJG(monsterId)--记录红中麻将记录房间信息 一码不中当全中
	local key = "CREATEROOMINFOHZMJG"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoHZMJG()
	local key = "CREATEROOMINFOHZMJG"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key,-99)
	--if monsterId == 0 then
	--	monsterId = 1
	--end
	return monsterId
end

function PreferenceManager:setCreateRoominfoDDZA(monsterId)--记录斗地主记录房间信息 资费
	local key = "CREATEROOMINFODDZA"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoDDZA()
	local key = "CREATEROOMINFODDZA"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoDDZB(monsterId)--记录斗地主记录房间信息 圈数
	local key = "CREATEROOMINFODDZB"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoDDZB()
	local key = "CREATEROOMINFODDZB"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoDDZC(monsterId)--记录斗地主记录房间信息 玩法
	local key = "CREATEROOMINFODDZC"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoDDZC()
	local key = "CREATEROOMINFODDZC"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end

function PreferenceManager:setCreateRoominfoDDZD(monsterId)--记录斗地主记录房间信息 封顶
	local key = "CREATEROOMINFODDZD"
	cc.UserDefault:getInstance():setIntegerForKey(key, monsterId)
  	cc.UserDefault:getInstance():flush()
end

function PreferenceManager:getCreateRoominfoDDZD()
	local key = "CREATEROOMINFODDZD"
	local monsterId = cc.UserDefault:getInstance():getIntegerForKey(key)
	if monsterId == 0 then
		monsterId = 1
	end
	return monsterId
end


return PreferenceManager
