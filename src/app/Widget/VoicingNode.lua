local VoicingNode = class("VoicingNode", function()
	return display.newLayer()
end)

function VoicingNode:ctor(showType)
	self:setTouchSwallowEnabled(false)

	self._voiceNode = display.newScale9Sprite("#message_talk_bg.png")
    self._voiceNode:setPreferredSize(cc.size(220, 200))
    self._voiceNode:setPosition(display.cx,display.cy)
    self._voiceNode:setVisible(false)
    self:addChild(self._voiceNode)

    local iconTalk = display.newSprite("#city_img_microphone.png")
    iconTalk:setPosition(self._voiceNode:getContentSize().width/2,self._voiceNode:getContentSize().height/2+20)
    self._voiceNode:addChild(iconTalk)

    local lblTips = lt.GameLabel.newString("STRING_MESSAGE_TIPS_0", 20, lt.Constants.DEFAULT_LABEL_COLOR_2, {outline = 1})
    lblTips:setPosition(iconTalk:getPositionX(),iconTalk:getPositionY()- iconTalk:getContentSize().height / 2 - 30)
    self._voiceNode:addChild(lblTips)

    self._cancleNode = display.newScale9Sprite("#message_talk_bg.png")
    self._cancleNode:setPreferredSize(cc.size(220, 200))
    self._cancleNode:setPosition(display.cx,display.cy)
    self._cancleNode:setVisible(false)
    self:addChild(self._cancleNode)

    local iconCancle = display.newSprite("#city_img_return.png")
    iconCancle:setPosition(self._cancleNode:getContentSize().width/2,self._cancleNode:getContentSize().height/2+20)
    self._cancleNode:addChild(iconCancle)

    local lblCancelTips = lt.GameLabel.newString("STRING_MESSAGE_TIPS_0", 20, lt.Constants.COLOR.RED, {outline=1})
    lblCancelTips:setPosition(iconCancle:getPositionX(),iconCancle:getPositionY()- iconCancle:getContentSize().height / 2 - 30)
    self._cancleNode:addChild(lblCancelTips)
end

function VoicingNode:showVoicing()
	self._voiceNode:setVisible(true)
	self._cancleNode:setVisible(false)

	--最多录制一分钟，超过自动发送语音
    self._voiceNode:stopAllActions()
    self._voiceNode:runAction(cca.seq{
        cca.delay(60),

        cca.cb(function()
            self._voiceNode:setVisible(false)
        end)
    })
end

function VoicingNode:showCancel()
	self._voiceNode:setVisible(false)
	self._cancleNode:setVisible(true)
end

function VoicingNode:hide()
	self._voiceNode:setVisible(false)
	self._cancleNode:setVisible(false)
end

function VoicingNode:remove()
	lt.UILayerManager:removeLayer(self)
end

return VoicingNode
