
local SetLayer = class("SetLayer", function()
    return cc.CSLoader:createNode("hallcomm/lobby/LobbySetLayer.csb")--  FriendLayer
end)

function SetLayer:ctor()
	local layer = self:getChildByName("Ie_Bg")
	local Ie_Mark = self:getChildByName("Ie_Mark")

	self.Bn_MusicOn = layer:getChildByName("Bn_MusicOn")
	self.Bn_SoundOn = layer:getChildByName("Bn_SoundOn")
	self.Bn_MusicOff = layer:getChildByName("Bn_MusicOff")
	self.Bn_SoundOff = layer:getChildByName("Bn_SoundOff")
	local Bn_Close = layer:getChildByName("Bn_Close")
	-- 退出登录
	local Bn_signOut = layer:getChildByName("Bn_ExitAccount")
	self.SoundCheck = layer:getChildByName("Se_SoundCheck")
	self.MusicCheck = layer:getChildByName("Se_MusicCheck")
	lt.CommonUtil:addNodeClickEvent(self.Bn_MusicOn, function() self:setMusic(true) end, false)	
	lt.CommonUtil:addNodeClickEvent(self.Bn_SoundOn, function() self:setSound(true) end, false)	
	lt.CommonUtil:addNodeClickEvent(self.Bn_MusicOff, function() self:setMusic(false) end, false)	
	lt.CommonUtil:addNodeClickEvent(self.Bn_SoundOff, function() self:setSound(false) end, false)	
	lt.CommonUtil:addNodeClickEvent(Bn_Close, function() self:onClose() end, false)	
	lt.CommonUtil:addNodeClickEvent(Bn_signOut, function() self:signOut() end)	
	lt.CommonUtil:addNodeClickEvent(Ie_Mark, function() self:onClose() end, false)	

	local xuanzhonGameyx = lt.PreferenceManager:getSoundOn()   --记录选中游戏音效
	local xuanzhonGameyy = lt.PreferenceManager:getMusicOn()   --记录选中游戏音乐

	if xuanzhonGameyy then
		local px, py = self.Bn_MusicOn:getPosition()
		self.MusicCheck:setPosition(px, py)
	else
		local px, py = self.Bn_MusicOff:getPosition()
		self.MusicCheck:setPosition(px, py)
	end

	if xuanzhonGameyx then
		local px, py = self.Bn_SoundOn:getPosition()
		self.SoundCheck:setPosition(px, py)
	else
		local px, py = self.Bn_SoundOff:getPosition()
		self.SoundCheck:setPosition(px, py)
	end


end

function SetLayer:setMusic( isOpen )
	if isOpen then
		AudioEngine.setMusicVolume(1)                              --设置背景音乐音量
		lt.AudioManager:setMusicOn(true)
		local px, py = self.Bn_MusicOn:getPosition()
		self.MusicCheck:setPosition(px, py)
	else
		AudioEngine.setMusicVolume(0)                              --设置背景音乐音量
		lt.AudioManager:setMusicOn(false)
		local px, py = self.Bn_MusicOff:getPosition()
		self.MusicCheck:setPosition(px, py)
	end

	print("AudioEngine:getMusicVolume, isOpen", AudioEngine.getMusicVolume(), isOpen)
end

function SetLayer:onClose(  )
	lt.UILayerManager:removeLayer(self)
end

function SetLayer:setSound( isOpen )
	if isOpen then
		AudioEngine.setEffectsVolume(1)    
		lt.AudioManager:setSoundOn(true)--开                        --设置音效音量
		local px, py = self.Bn_SoundOn:getPosition()
		self.SoundCheck:setPosition(px, py)
	else
		AudioEngine.setEffectsVolume(0)
		lt.AudioManager:setSoundOn(false)--关
		local px, py = self.Bn_SoundOff:getPosition()
		self.SoundCheck:setPosition(px, py)
	end
	print("AudioEngine:getEffectsVolume, isOpen", AudioEngine.getEffectsVolume(), isOpen)
end

function SetLayer:signOut()
	local scene = lt.InitScene:new()
	lt.SceneManager:replaceScene(scene)
end


return SetLayer