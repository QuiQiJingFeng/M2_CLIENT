
--录音弹框
local RecordVoiceLayer = class("RecordVoiceLayer", function()

    return cc.CSLoader:createNode("game/mjcomm/csb/base/RecordVoiceLayer.csb")
end)

function RecordVoiceLayer:ctor()

	--录音时间太短
	self._recordTimeTip = lt.CommonUtil:getChildByNames(self, "Se_VoiceCutBg", "Tt_Prompt")
	--正常录音
 	self._recordTip = lt.CommonUtil:getChildByNames(self, "Se_VoiceCutBg", "Se_Bg")

 	--信号格
 	self._aniVoice = lt.CommonUtil:getChildByNames(self._recordTip, "Ani_Voice")

 	self:showNormal()
end

function RecordVoiceLayer:closeRecordVoiceLayer()
	lt.UILayerManager:removeLayer(self)
end

function RecordVoiceLayer:showTimeTip()
	self._recordTimeTip:setVisible(true)
	self._recordTip:setVisible(false)

	lt.scheduler.performWithDelayGlobal(
		function( )
			lt.UILayerManager:removeLayer(self)
		end
		, 1)
end

function RecordVoiceLayer:showNormal()
	self._recordTimeTip:setVisible(false)
	self._recordTip:setVisible(true)
end

return RecordVoiceLayer