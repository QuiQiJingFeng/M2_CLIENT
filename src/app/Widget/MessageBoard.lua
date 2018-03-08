
-- 留言板
local MessageBoard = class("MessageBoard", function()
	return display.newNode()
end)

MessageBoard._cellHeight = 0
MessageBoard._delMessageCallBack = nil
function MessageBoard:ctor()
	self._infoNode = display.newNode()

	self:addChild(self._infoNode)
end

function MessageBoard:updateInfo(friendSpaceLayer,zoneMessageInfo,showBg,delMessageCallBack)
	
	self._infoNode:removeAllChildren()

	self._friendSpaceLayer = friendSpaceLayer
	self._delMessageCallBack = delMessageCallBack
    local simpleInfo = lt.SimplePlayerInfo.new(zoneMessageInfo:getFromSimplePlayerData())

    local zoneType = self._friendSpaceLayer:getZoneType()

    local player = lt.DataManager:getPlayer()
    local playerId = player:getId()
    local friendInfo = self._friendSpaceLayer:getFriendInfo()

    local zonePlayerId = self._friendSpaceLayer:getZonePlayerId()

    local messageZonePlayerId = zoneMessageInfo:getPlayerId()

    local zonePlayerName = zoneMessageInfo:getPlayerName()

    local textLabel = lt.RichText.new()
    textLabel:setAnchorPoint(cc.p(0, 1))
    textLabel:setSize(cc.size(360, 10))

    if zonePlayerId == messageZonePlayerId then

        if zoneMessageInfo:getToPlayerId() ~= zoneMessageInfo:getFromPlayerId() and zoneMessageInfo:getToPlayerId() ~= 0 and zoneMessageInfo:getGiftItemId() <= 0 then

            
            local toText = lt.RichTextText.new(lt.StringManager:getString("STRING_FRIEND_SPACE_34"),20,lt.Constants.DEFAULT_LABEL_COLOR_2)
            textLabel:insertElement(toText)

            local nameText = lt.RichTextText.new(zoneMessageInfo:getToPlayerName(),20,lt.Constants.COLOR.PROPERTY_BLUE)
            textLabel:insertElement(nameText)

            local talkText = lt.RichTextText.new(lt.StringManager:getString("STRING_FRIEND_SPACE_35"),20,lt.Constants.DEFAULT_LABEL_COLOR_2)
            textLabel:insertElement(talkText)

        end
    else

        if zoneMessageInfo:getToPlayerId() ~= zonePlayerId then
            textLabel = lt.RichText.new()
            textLabel:setAnchorPoint(cc.p(0, 1))
            textLabel:setSize(cc.size(360, 10))
            

            local toText = lt.RichTextText.new(lt.StringManager:getString("STRING_FRIEND_SPACE_34"),20,lt.Constants.DEFAULT_LABEL_COLOR_2)
            textLabel:insertElement(toText)


            local nameText = lt.RichTextText.new(zoneMessageInfo:getToPlayerName(),20,lt.Constants.COLOR.PROPERTY_BLUE)
            textLabel:insertElement(nameText)

            local talkText = lt.RichTextText.new(lt.StringManager:getString("STRING_FRIEND_SPACE_35"),20,lt.Constants.DEFAULT_LABEL_COLOR_2)
            textLabel:insertElement(talkText)

        else

            if zoneMessageInfo:getFromPlayerId() == zonePlayerId then
                textLabel = lt.RichText.new()
                textLabel:setAnchorPoint(cc.p(0, 1))
                textLabel:setSize(cc.size(360, 10))

            else
                textLabel = lt.RichText.new()
                textLabel:setAnchorPoint(cc.p(0, 1))
                textLabel:setSize(cc.size(360, 10))

                local toText = lt.RichTextText.new(lt.StringManager:getString("STRING_FRIEND_SPACE_36"),20,lt.Constants.DEFAULT_LABEL_COLOR_2)
                textLabel:insertElement(toText)

                local nameText = lt.RichTextText.new(zoneMessageInfo:getPlayerName(),20,lt.Constants.COLOR.PROPERTY_BLUE)
                textLabel:insertElement(nameText)

                local replyText = lt.RichTextText.new(lt.StringManager:getString("STRING_FRIEND_SPACE_37"),20,lt.Constants.DEFAULT_LABEL_COLOR_2)
                textLabel:insertElement(replyText)

            end
        end


    end
    local content = zoneMessageInfo:getContent()
    -- local contentText = lt.RichTextText.new(zoneMessageInfo:getContent(),20,lt.Constants.DEFAULT_LABEL_COLOR_2)
    -- textLabel:insertElement(contentText)

    local keyStart = "(【#(%d+)】)"
    
    local subArray = {}
    local mathchArray = {}
    for k,v in string.gmatch(content, keyStart) do
        mathchArray[#mathchArray + 1] = {str = k, emojiNum = v}
    end

    local messageArray = {}
    local subStr = content
    for _,mathchInfo in ipairs(mathchArray) do
        local st, ed = string.find(subStr, mathchInfo.str)
        if st then
            if st > 1 then
                -- 前面有普通文本
                local subMessage = string.sub(subStr, 1, st - 1)
                --printf("subMessage is %s", subMessage)
                messageArray[#messageArray + 1] = {ty = 0, text = subMessage}
            end

            local subMessage = string.sub(subStr, st, ed)
            messageArray[#messageArray + 1] = {ty = 1, text = subMessage, emojiNum = mathchInfo.emojiNum}

            -- 留下剩下的
            subStr = string.sub(subStr, ed + 1)
            --printf("subStr is %s", subStr)
        end
    end

    if  string.len(subStr) > 0 then
        -- 剩余文本为普通文本
        messageArray[#messageArray + 1] = {ty = 0, text = subStr}
    end



    for _,messageInfo in ipairs(messageArray) do
        local ty = messageInfo.ty
        if ty == 0 then

            local contentInfo = lt.RichTextText.new(messageInfo.text,lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
            textLabel:insertElement(contentInfo)
            --local msg = string.format("(普通文字)%s", messageInfo.text)

        elseif ty == 1 then
            if tonumber(messageInfo.emojiNum) <= lt.Constants.EMIOY_MAX_ID then
                local emoji = lt.Emoji.new(messageInfo.emojiNum,true)
                emoji:setContentSize(cc.size(44,44))
                --textLabel:setSize(cc.size(textLabel:getContentSize().width-16,textLabel:getContentSize().height))
                --print("textLabel:getContentSize().width:"..textLabel:getContentSize().width)
                local richItem = cpp.RichItemCustom:create(0, lt.Constants.COLOR.WHITE, 255, emoji)
                textLabel:addItem(richItem)
            else
                local contentInfo = lt.RichTextText.new(messageInfo.text,lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
                textLabel:insertElement(contentInfo)
            end

        end
    end


    textLabel:formatText()
    

    local cellHeight = 60 + textLabel:getContentSize().height

    if cellHeight < 86 then
        cellHeight = 86
    end

    self._cellHeight = cellHeight

    local infoBg = lt.GameInfoBg.new(lt.GameInfoBg.TYPE.GAME_INFO_BG_TYPE_2, cc.size(510,cellHeight), 0 , cellHeight/2)
    infoBg:setAnchorPoint(0,0.5)



    if not showBg then
        self._infoNode:addChild(infoBg)
    end
  
    local iconImg = lt.PlayerFace.new()
    iconImg:setPosition(10,cellHeight - 2)
    iconImg:setAnchorPoint(0, 1)
    iconImg:updateInfo(simpleInfo:getOccupationId(),nil,nil,simpleInfo:getAvatarId())
    iconImg:setTag(lt.FriendMessagePanel.LEVELMESSAGE_TAG)
    iconImg.id = zoneMessageInfo:getFromPlayerId()
    self._infoNode:addChild(iconImg)

    local nameLabel = lt.GameLabel.new(simpleInfo:getName(), lt.Constants.FONT_SIZE1, lt.Constants.COLOR.SPACE_BROWN)
    nameLabel:setAnchorPoint(0, 1)
    nameLabel:setPosition(iconImg:getPositionX() + iconImg:getContentSize().width, iconImg:getPositionY() - 10)
    self._infoNode:addChild(nameLabel)

    textLabel:setPosition(iconImg:getPositionX() + iconImg:getContentSize().width, nameLabel:getPositionY() - nameLabel:getContentSize().height -10)
    self._infoNode:addChild(textLabel)

    --判断礼物存在
    local itemId = zoneMessageInfo:getGiftItemId()

    if itemId > 0 then

        local capInsets = cc.rect(30, 10, 4, 8)

        local maskBg = display.newScale9Sprite("image/ui/common/common_label_bg.png", nameLabel:getPositionX() + 160 , nameLabel:getPositionY(), cc.size(102, 28), capInsets)
        maskBg:setAnchorPoint(0, 1)
        self._infoNode:addChild(maskBg)

        local imageName = "#space_img_hua.png"
        if itemId == lt.Constants.SPACE_GIFT.FLOWERS then
            imageName = "#space_img_hua.png"
        elseif itemId == lt.Constants.SPACE_GIFT.CAR then
            imageName = "#space_img_car.png"
        elseif itemId == lt.Constants.SPACE_GIFT.HOUSE then
            imageName = "#space_img_house.png"
        end

        local giftImg = display.newSprite(imageName)
        giftImg:setAnchorPoint(0, 0.5)
        --giftImg:setScale(0.8)
        giftImg:setPosition(5, maskBg:getContentSize().height / 2)
        maskBg:addChild(giftImg)

        local giftNum = lt.GameLabel.new(zoneMessageInfo:getGiftItemSize(),lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2,{outline = true})
        giftNum:setAnchorPoint(0.5, 0.5)
        giftNum:setPosition(giftImg:getPositionX() + giftImg:getContentSize().width + 22, maskBg:getContentSize().height / 2)
        maskBg:addChild(giftNum)
    end


    local time = zoneMessageInfo:getCreateTime()
    local day = lt.CommonUtil:getFormatDay(time, 1)
    local timeLabel = lt.GameLabel.new(day,lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
    timeLabel:setAnchorPoint(1, 1)
    timeLabel:setPosition(510 - 20,nameLabel:getPositionY())
    self._infoNode:addChild(timeLabel)


    if zoneType == lt.Constants.ZONE_TYPE.OWN or zoneMessageInfo:getFromPlayerId() == playerId then
        local deleteBtn = lt.ScaleButton.new("#space_btn_delete.png")
        deleteBtn:setPosition(510 - 30, textLabel:getPositionY() - 15)
        deleteBtn:setTag(zoneMessageInfo:getId())
        deleteBtn.info = zoneMessageInfo
        deleteBtn:onButtonClicked(handler(self, self.onDeleteMessage))
        self._infoNode:addChild(deleteBtn)
    end

    self._infoNode:setContentSize(510,self._cellHeight)
    self:setContentSize(510,self._cellHeight)
end

function MessageBoard:onDeleteMessage(event)
	if self._delMessageCallBack then
		self._delMessageCallBack(event)
	end
end

function MessageBoard:getInfoNode()
	return self._infoNode
end

function MessageBoard:getCellHeight()
	return self._cellHeight
end

return MessageBoard