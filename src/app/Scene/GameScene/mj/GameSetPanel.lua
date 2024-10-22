
--设置层
local GameSetPanel = class("GameSetPanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/csb/base/GameFunBtnPanel.csb")
end)


function GameSetPanel:ctor(deleget)
	GameSetPanel.super.ctor(self)
	self._deleget = deleget

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

	--邀请按钮
	self.inviteBtn = self:getChildByName("Button_Invite")

	local ruleBtn = self:getChildByName("Button_GameRule")
	local setBtn = self:getChildByName("Button_More")
	self._voiceBtn = self:getChildByName("Button_Voice")
	self._chatBtn = self:getChildByName("Button_Chat")
	self:configChatVisible()

	self._panel_RecordCtrl = self:getChildByName("Panel_RecordCtrl")

	self._button_PausePlay = self._panel_RecordCtrl:getChildByName("Button_PausePlay")
	self._sprite_Pause = self._button_PausePlay:getChildByName("Sprite_Pause")--暂停
	self._sprite_Play = self._button_PausePlay:getChildByName("Sprite_Play")--播放
	self._sprite_Play:setVisible(false)

	local Button_Fast = self._panel_RecordCtrl:getChildByName("Button_Fast")--加速
	local Button_Slowe = self._panel_RecordCtrl:getChildByName("Button_Slowe")--减速


	lt.CommonUtil:addNodeClickEvent(setBtn, handler(self, self.onSetClick))
	lt.CommonUtil:addNodeClickEvent(ruleBtn, handler(self, self.onRuleClick))

	lt.CommonUtil:addNodeClickEvent(self._sprite_Play, handler(self, self.onPlay))--播放
	lt.CommonUtil:addNodeClickEvent(self._sprite_Pause, handler(self, self.onPause))--暂停
	lt.CommonUtil:addNodeClickEvent(Button_Fast, handler(self, self.onFast))--加速
	lt.CommonUtil:addNodeClickEvent(Button_Slowe, handler(self, self.onSlowe))--减速
	
	lt.CommonUtil:addNodeClickEvent(self._voiceBtn,handler(self, self.onTouchEndVoice),true,handler(self, self.onTouchBeginVoice),handler(self, self.onTouchCanceled), handler(self, self.onTouchMoved))

	lt.CommonUtil:addNodeClickEvent(self._chatBtn, handler(self, self.onChatBtnClick))

	lt.CommonUtil:addNodeClickEvent(self.inviteBtn, handler(self, self.onInviteBtnClick))

	self.__recording = false
end

function GameSetPanel:configChatVisible(bool)
	if not lt.DataManager:getMyselfPositionInfo().is_sit then
		self._voiceBtn:setVisible(false)
		self._chatBtn:setVisible(false)
	else
		self._voiceBtn:setVisible(true)
		self._chatBtn:setVisible(true)
	end
end

function GameSetPanel:onInviteBtnClick()
	--邀请按钮点击
	local invitePanel = lt.InvitePanel.new()
	lt.UILayerManager:addLayer(invitePanel, true)
end

function GameSetPanel:UpdateCardBgColor()--暂停
	self._deleget:UpdateCardBgColor()
end

function GameSetPanel:onTouchReplayUIShow()--显示出来
	self._panel_RecordCtrl:setVisible(true)
	self._voiceBtn:setVisible(false)--不需要false掉
	self._chatBtn:setVisible(false)
end
function GameSetPanel:onTouchReplayUIPlay()--播放
	self._sprite_Play:setVisible(true)
	self._sprite_Pause:setVisible(false)
end
function GameSetPanel:onTouchReplayUIPause()--暂停
	self._sprite_Pause:setVisible(true)
	self._sprite_Play:setVisible(false)
end

function GameSetPanel:onPlay(event)--播放事件
	self:onTouchReplayUIPause()
	self._deleget:ReplayStarReplay()
end

function GameSetPanel:onPause(event)--暂停事件
	self:onTouchReplayUIPlay()
	self._deleget:ReplayStopReplay()
end

function GameSetPanel:onFast(event)--加速事件
	self._deleget:ReplayaddSpeed()
end

function GameSetPanel:onSlowe(event)--减速事件
	self._deleget:ReplaysurSpeed()
end

function GameSetPanel:onChatBtnClick(event)
	local chatLayer = lt.ChatLayer:new()
	lt.UILayerManager:addLayer(chatLayer, true)		
end

--开始录音的时候,服务端发过来的声音全部丢弃 并且停止当前的声音

function GameSetPanel:showRecordVoiceLayer()
	self._recordVoiceLayer = lt.RecordVoiceLayer.new()
	lt.UILayerManager:addLayer(self._recordVoiceLayer, true)	
end

function GameSetPanel:hideRecordVoiceLayer()
	if self._recordVoiceLayer then
		lt.UILayerManager:removeLayer(self._recordVoiceLayer)
		self._recordVoiceLayer = nil
	end
end

function GameSetPanel:onTouchBeginVoice()
	self:showRecordVoiceLayer()
	self._movedCancel = false
	lt.CommonUtil:stopAllAudio()
	self.__recording = true
	self.isStart = lt.CommonUtil:recordBegin()
end

function GameSetPanel:onTouchCanceled()
	self:hideRecordVoiceLayer()

	lt.CommonUtil:stopRecord()
end

function GameSetPanel:onTouchMoved(event, callBack)
	local x, y = event:getTouchMovePosition().x, event:getTouchMovePosition().y
    local contentSize = self._voiceBtn:getBoundingBox()
    local rect = cc.rect(self._voiceBtn:getPositionX()-contentSize.width / 2, self._voiceBtn:getPositionY() - contentSize.height / 2 , contentSize.width, contentSize.height)

    if cc.rectContainsPoint(rect, cc.p(x, y)) then
    else
    	self._movedCancel = true
    	if callBack then
    		callBack()
    	end
        self:hideRecordVoiceLayer()
        lt.CommonUtil:stopRecord()
    end
end

function GameSetPanel:onTouchEndVoice()

	if self._movedCancel then
		self._movedCancel = false
		return
	end

	self:hideRecordVoiceLayer()

	self.__recording = false
	if not self.isStart then
		print("ERROR: 内部错误")
		return
	end
	local ok = lt.CommonUtil:stopRecord()
	if not ok then
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
	local setLayer = lt.SettingLayer.new(self)
    lt.UILayerManager:addLayer(setLayer, true)
end

function GameSetPanel:onRuleClick(event) 

end

function GameSetPanel:setRoomBg(id)
	self._deleget:setRoomBg(id)
end

function GameSetPanel:onNoticeSendAudio(content)
	local user_pos = content.user_pos
	local data = content.data
	if self.__recording then 
		return
	end
	local writePath = cc.FileUtils:getInstance():getWritablePath()
	local path = writePath .. "audio.mp3"
	local file = io.open(path,"wb")
	file:write(data)
	file:close()

	lt.CommonUtil:playAudio(path)
end

function GameSetPanel:hideInviteBtn()
	self.inviteBtn:setVisible(false)
end

function GameSetPanel:onClientConnectAgain()
	self:configChatVisible()
end

function GameSetPanel:onEnter()   
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_SEND_AUDIO, handler(self, self.onNoticeSendAudio), "GameSetPanel.onNoticeSendAudio")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.HIDE_INVITE_BTN, handler(self, self.hideInviteBtn), "GameSetPanel.hideInviteBtn")

	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.CLIENT_CONNECT_AGAIN, handler(self, self.onClientConnectAgain), "GameSetPanel:onClientConnectAgain")

end

function GameSetPanel:onExit()
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_SEND_AUDIO, "GameSetPanel.onNoticeSendAudio")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.HIDE_INVITE_BTN, "GameSetPanel.hideInviteBtn")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.CLIENT_CONNECT_AGAIN, "GameSetPanel:onClientConnectAgain")
end

return GameSetPanel