local VoiceCell = class("VoiceCell", function()
    return display.newNode()
end)

function VoiceCell:ctor(chatInfo,textWidth,textHeight,oppsite,updateDb)
    self._chatInfo = chatInfo
    self._updateDb = updateDb
    self._voicing = false

    self:setContentSize(textWidth, textHeight)

    self._iconVoice = ccs.Armature:create("battle_chat")
    self._iconVoice:getAnimation():playWithIndex(1)
    self._iconVoice:setRotation(-90)
    self._iconVoice:setPosition(textWidth-20,textHeight-45)
    self:addChild(self._iconVoice)


    self._btnVoice = cc.ui.UIPushButton.new("#common_cell_newgray.png")
    self._btnVoice:setPosition(textWidth/2-15,textHeight-45)
    self._btnVoice:setButtonSize(textWidth-50,60)
    self._btnVoice:setTouchEnabled(false)
    self:addChild(self._btnVoice)

    local time = math.ceil(chatInfo:getDuration()/1000)

    if time < 1 then
        time = 1
    end

    local lblTips = lt.GameLabel.new(string.format(lt.StringManager:getString("STRING_MESSAGE_TIPS_1"), time),lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
    lblTips:setPosition(self._btnVoice:getContentSize().width/2,self._btnVoice:getContentSize().height/2)
    self._btnVoice:addChild(lblTips)

    if oppsite then
        self._iconVoice:setRotation(0)
        self._iconVoice:setPosition(20,textHeight-45)
        self._btnVoice:setPosition(textWidth/2+18,textHeight-45)

        self._iconRead = display.newSprite("#common_count_bg_2.png")
        self._iconRead:setScale(0.5)
        self._iconRead:setPosition(textWidth - 25, textHeight-25)
        self:addChild(self._iconRead)
        if chatInfo:getRead() == 1 then
            self._iconRead:setVisible(false)
        end
    end

end

function VoiceCell:onVoice(event)
    if self._voicing then
        self:stopVoice()
        return
    end
    
    lt.AudioMsgManager:playAudio(self._chatInfo)

    self._chatInfo:setRead(1)
    if self._updateDb then
        lt.ChatManager:updateChatInfo(self._chatInfo)
    end
    if self._iconRead then
        self._iconRead:setVisible(false)
    end
    self._iconVoice:getAnimation():playWithIndex(0)
    self._voicing = true
end

function VoiceCell:isVoicing()
    return self._voicing
end

function VoiceCell:stopVoice()
    self:stopAnimation()
end

function VoiceCell:stopAnimation()
    self._voicing = false
    lt.AudioMsgManager:stopAudio()

    self:stopAllActions()
    self._iconVoice:getAnimation():playWithIndex(1)
end


function VoiceCell:clearAnimation()
    self._voicing = false
    self:stopAllActions()
    self._iconVoice:getAnimation():playWithIndex(1)
end

function VoiceCell:onAnimation()
    self._voicing = true
    self._iconVoice:getAnimation():playWithIndex(0)
end

function VoiceCell:getMessageId()
    if self._chatInfo:getMessageId() ~= 0 then
        return self._chatInfo:getMessageId()
    end
    return 0
end

return VoiceCell
