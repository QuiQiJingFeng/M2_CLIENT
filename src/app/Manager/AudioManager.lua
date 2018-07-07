
-- 用于管理游戏内音效
local audio = require("cocos.framework.audio")

local AudioManager = {}

AudioManager._bgMusicStack = nil
AudioManager._effectMusic  = nil

AudioManager._musicTable = nil
AudioManager._soundTable = nil

AudioManager._musicOn   	= false
AudioManager._soundOn   	= false

AudioManager._isPauseMusic = false

AudioManager._musicSysOn	= true
AudioManager._musicPause	= false

AudioManager._soundSysOn	= true
AudioManager._soundExtraOn 	= true

function AudioManager:init()
	-- 根据平台决定格式

    self._musicTable = {}
    self._soundTable = {}

    self._bgMusicStack = {}

    -- 重置音效
    self:resetSoundSet()
    -- 重置音乐
    self:resetMusicSet()

    self._musicSysOn	= true
    self._musicPause 	= false

    self._soundSysOn 	= true
    self._soundExtraOn = true
end

-- ################################################## 音乐 ##################################################
function AudioManager:resetMusicSet()
	self._musicOn = lt.PreferenceManager:getMusicOn()

	local musicValue = lt.PreferenceManager:getMusicValue()
    self:setMusicVolume(musicValue, true)
end

function AudioManager:setMusicVolumeRate(volumeRate)
	local musicValue = lt.PreferenceManager:getMusicValue()

    self:setMusicVolume(musicValue * volumeRate, true)
end

function AudioManager:setMusicVolume(volume)
	audio.setMusicVolume(volume / 100)
end

function AudioManager:setMusicOn(musicOn)
	self._musicOn = musicOn
	-- 开关发生变化

	if self._musicOn then
		self:resumeMusic()
	else
		self:pauseMusic()
	end

	lt.PreferenceManager:setMusicOn(self._musicOn)
end

-- 缓存音乐
function AudioManager:preloadMusic(path, musicName)
	if not musicName then
		return
	end

	musicName = string.format("%s%s.mp3", path, musicName)

	self:_preloadMusic(musicName)
end

function AudioManager:_preloadMusic(musicName)
	if not self._musicSysOn or not self._musicOn then
		return
	end

	self._musicTable[musicName] = true

	audio.preloadMusic(musicName)
end

-- 卸载音乐
function AudioManager:unloadMusic(path, musicName)
	if not musicName then
		return
	end

	musicName = string.format("%s%s.mp3", path, musicName)

	self:_unloadMusic(musicName)
end

function AudioManager:_unloadMusic(musicName)
	if not self._musicSysOn or not self._musicOn then
		return
	end

	self._musicTable[musicName] = nil


end

function AudioManager:playMusic(path, musicName, loop)
	if not musicName then
		return
	end

	musicName = string.format("%s%s.mp3", path, musicName)

	return self:_playMusic(musicName, loop)
end

function AudioManager:_playMusic(musicName, loop)
	if #self._bgMusicStack > 0 then
		if not musicName then
			-- 继续播放
			musicName = self._bgMusicStack[#self._bgMusicStack]
		elseif musicName == self._bgMusicStack[#self._bgMusicStack] then
			-- 音乐没变
			return
		else
			-- 停止当前的音乐信息
			self:stopMusic()

			self._bgMusicStack[#self._bgMusicStack + 1] = musicName
		end
	else
		-- 停止当前的音乐信息
		self:stopMusic()

		self._bgMusicStack[#self._bgMusicStack + 1] = musicName
	end

	if not self._musicSysOn or not self._musicOn then
		return
	end
	
	if not isset(self._musicTable, musicName) then
		self:_preloadMusic(musicName)
	end

	audio.playMusic(self._bgMusicStack[#self._bgMusicStack], loop)
end

function AudioManager:pushMusic(path, musicName, loop)
	if not musicName then
		return
	end

	musicName = string.format("%s%s.mp3", path, musicName)

	return self:_pushMusic(musicName, loop)
end

function AudioManager:_pushMusic(musicName, loop)
	-- 停止当前的音乐信息
	self:stopMusic(false)

	self._bgMusicStack[#self._bgMusicStack + 1] = musicName

	if not self._musicSysOn or not self._musicOn then
		return
	end
	
	if not isset(self._musicTable, musicName) then
		self:_preloadMusic(musicName)
	end

	audio.playMusic(self._bgMusicStack[#self._bgMusicStack], loop)
end

function AudioManager:popMusic()
	self:_popMusic()
end

function AudioManager:_popMusic()
	-- 停止当前的音乐信息
	self:stopMusic(false)

	self._bgMusicStack[#self._bgMusicStack] = nil

	if not self._musicSysOn or not self._musicOn then
		return
	end

	if #self._bgMusicStack > 0 then
		-- 还有音乐
		audio.playMusic(self._bgMusicStack[#self._bgMusicStack], loop)
	end
end

function AudioManager:stopMusic(clearMusic)
	self:_stopMusic(clearMusic)
end

function AudioManager:_stopMusic(clearMusic)
	if clearMusic then
		for _,bgMusic in ipairs(self._bgMusicStack) do
			self:_unloadMusic(bgMusic)
		end
	end

	audio.stopMusic()
end

-- 音乐暂停
function AudioManager:pauseMusic()
	self._isPauseMusic = true

	self:_pauseMusic()
end

function AudioManager:_pauseMusic()
	self:_stopMusic()
end

-- 音乐恢复
function AudioManager:resumeMusic()
	self._isPauseMusic = false

	self:_resumeMusic()
end

function AudioManager:_resumeMusic()
	if #self._bgMusicStack == 0 then
		return
	end

	self:_playMusic()
end

-- 暂停音效(系统暂停)
function AudioManager:pauseSysMusic()
	do return end

	self._musicSysOn = false

	self:_pauseMusic()
end

-- 恢复音效(系统暂停)
function AudioManager:resumeSysMusic()
	do return end

	self._musicSysOn = true

	if not self._isPauseMusic then
		self:_resumeMusic()
	end
end

-- ################################################## 音效 ##################################################
function AudioManager:resetSoundSet()
	self._soundOn = lt.PreferenceManager:getSoundOn()

	local soundValue = lt.PreferenceManager:getSoundValue()
    self:setSoundVolume(soundValue, true)
end

function AudioManager:setSoundVolumeRate(volumeRate)
	local soundValue = lt.PreferenceManager:getSoundValue()

    self:setSoundVolume(soundValue * volumeRate, true)
end

function AudioManager:setSoundVolume(volume)
	audio.setSoundsVolume(volume / 100)
end

function AudioManager:setSoundOn(soundOn)
	self._soundOn = soundOn

	lt.PreferenceManager:setSoundOn(self._soundOn)
end

function AudioManager:preloadSound(path, soundName, level)
	if not soundName then
		return
	end

	soundName = string.format("%s%s.mp3", path, soundName)

	self:_preloadSound(soundName, level)

	return soundName
end

function AudioManager:_preloadSound(soundName, level)
	self._soundTable[soundName] = level or 1

	audio.preloadSound(soundName)
end

function AudioManager:playSound(path, soundName, loop)
	if not soundName then
		return
	end

	soundName = string.format("%s%s.mp3", path, soundName)

	return self:_playSound(soundName, loop)
end

function AudioManager:_playSound(soundName, loop)
	if not self._soundSysOn or not self._soundExtraOn then
		return
	end

	if not self._soundOn then
		return
	end
	
	if not isset(self._soundTable, soundName) then
		self:_preloadSound(soundName)
	end

	return audio.playSound(soundName, loop)
end

function AudioManager:stopSound(handle)
	if not handle then
		return
	end

	audio.stopSound(handle)
end

-- 暂停音效(系统暂停)
function AudioManager:pauseSysSound()
	do return end

	self._soundSysOn = false
end

-- 恢复音效(系统暂停)
function AudioManager:resumeSysSound()
	do return end
	
	self._soundSysOn = true
end

-- 暂停音效(战斗打开mic暂停)
function AudioManager:pauseSound()
	self._soundExtraOn = false
end

-- 恢复音效(战斗关闭mic暂停)
function AudioManager:resumeSound()
	self._soundExtraOn = true
end

-- 卸载音效
function AudioManager:unloadSound(soundName)
	if self._soundTable[soundName] and self._soundTable[soundName] < 2 then
		self._soundTable[soundName] = nil
	end

	audio.unloadSound(soundName)
end

function AudioManager:unloadAllSound()
	for soundName,level in pairs(self._soundTable) do
		if level < 2 then
			self._soundTable[soundName] = nil

			audio.unloadSound(soundName)
		end
	end
end

-- ################################################## 通用音效 ##################################################
function AudioManager:buttonClicked()
	--self:playSound("res/hallcomm/sound/lobby/", "btn")

	self:playSound("game/mjcomm/sound/mj/", "btn")
end

function AudioManager:playMjCardSound(value, sex)--0 女 1 男
	--self:playSound("res/hallcomm/sound/lobby/", "btn")
	sex = sex or 0
	local path = "game/mjcomm/sound/mj/"
	local soundStr = "m"
	if sex == 0 then
		soundStr = "w"..value
	elseif sex == 1 then
		soundStr = "m"..value
	end
	self:playSound(path, soundStr)
end

return AudioManager
