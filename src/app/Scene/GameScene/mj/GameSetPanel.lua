
--设置层
local GameSetPanel = class("GameSetPanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/csb/base/GameFunBtnPanel.csb")
end)


function GameSetPanel:ctor()
	GameSetPanel.super.ctor(self)


	self:getChildByName("Bg_Help_Start"):setVisible(false)
	self:getChildByName("Bg_Help_NoStart"):setVisible(false)
	self:getChildByName("Bg_MaskLead"):setVisible(false)
	self:getChildByName("Bg_MaskGiftLead"):setVisible(false)
	self:getChildByName("Bg_MaskChatLead"):setVisible(false)
	self:getChildByName("Btn_ChatLead"):setVisible(false)
	self:getChildByName("Btn_LeadBg"):setVisible(false)
	self:getChildByName("Panel_RecordCtrl"):setVisible(false)
	self:getChildByName("Node_InviteView"):setVisible(false)
	self:getChildByName("Bg_ShareLayer"):setVisible(false)
	self:getChildByName("Button_Invite"):setVisible(false)

	local ruleBtn = self:getChildByName("Button_GameRule")
	local setBtn = self:getChildByName("Button_More")
	local voiceBtn = self:getChildByName("Button_Voice")

	lt.CommonUtil:addNodeClickEvent(setBtn, handler(self, self.onSetClick))
	lt.CommonUtil:addNodeClickEvent(ruleBtn, handler(self, self.onRuleClick))

	lt.CommonUtil:addNodeClickEvent(voiceBtn,handler(self, self.onTouchBeginVoice),true,handler(self, self.onTouchEndVoice),handler(self, self.onTouchEndVoice))

	self.__playAudioList = {}
end

function GameSetPanel:onTouchBeginVoice()
	--开始录音之前 清空当前声音列表中的所有声音,并停止当前正在播放的声音
	self.__playAudioList = {}
	lt.CommonUtil:stopAllAudio()
	
	self.isStart = lt.CommonUtil:recordBegin()
end

function GameSetPanel:onTouchEndVoice()
	if not self.isStart then
		print("ERROR: 内部错误")
		return
	end
	local ok = lt.CommonUtil:stopRecord()
	if not data then
		print("停止失败")
		return
	end
	local content = lt.CommonUtil:convertWavToMp3()
	if not content then
		print("转码失败")
		return
	end
	-- 向服务器发送音频
	lt.NetWork:sendTo(lt.GameEventManager.EVENT.SEND_AUDIO, {data = content})
end

function GameSetPanel:onSetClick(event) 
	local setLayer = lt.SettingLayer.new()
    lt.UILayerManager:addLayer(setLayer, true)
end

function GameSetPanel:onRuleClick(event) 

end

function GameSetPanel:processPlaying(data)
	local writePath = cc.FileUtils:getInstance():getWritablePath()
	local path = writePath + "audio.mp3"
	local file = io.open(path,"wb")
	file:write(data)
	file:close()
	lt.CommonUtil:playAudio(path,function(result) 
			local temp = table.remove(self.__playAudioList,1)
			if temp then
				-- 一个播放完毕 继续播放另一个
				self:processPlaying(temp)
			end
		end)
end

function GameSetPanel:onNoticeSendAudio(content)
	local user_pos = content.user_pos
	local data = content.data
	
	local playing = lt.CommonUtil:isPlayingAudio()
	if playing then
		table.insert(self.__playAudioList,data)
		return
	end
	self:processPlaying(data)
end

function GameSetPanel:onEnter()   
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_SEND_AUDIO, handler(self, self.onNoticeSendAudio), "GameSetPanel.onNoticeSendAudio")
end

function GameSetPanel:onExit()
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_SEND_AUDIO, "GameSetPanel.onNoticeSendAudio")
end

return GameSetPanel