
local RichTextScaleNode = class("RichTextScaleNode", function()
	return display.newScale9Sprite("image/ui/common/common_info_2.png", 0, 0, cc.size(350, 10 + 2 * 7))
end)

RichTextScaleNode._costomSize = cc.size(390, 10)
RichTextScaleNode._infoNode = nil

RichTextScaleNode._richTextArray = nil
RichTextScaleNode._size = cc.size(300,200)
RichTextScaleNode._callBack = nil
RichTextScaleNode._padding = 7
RichTextScaleNode._height = 0
RichTextScaleNode._friendSpaceLayer = 0
RichTextScaleNode._richTextTable = nil
function RichTextScaleNode:ctor(layer,stateTabel,upvoteTabel,callBack,zoneTalkInfo)
	local upvoteArray = upvoteTabel or {}
	local textArray = stateTabel or {}
	self._richTextTable = {}
    table.sort(textArray, function(text1, text2)
        return text1:getCreateTime() < text2:getCreateTime()
    end)


	self._callBack = callBack
	self._friendSpaceLayer = layer
	self._infoNode = display.newNode()
	self:addChild(self._infoNode)

	self._richTextArray = {}
	local height = 0

	local nameHeight = 0
	if #upvoteArray > 0 then

	    local praiseImg = display.newSprite("#space_btn_praise.png")
        praiseImg:setAnchorPoint(0,1)
        praiseImg:setPosition(0,height)
        self._infoNode:addChild(praiseImg)

		local richText = lt.RichText.new()
    	richText:setAnchorPoint(cc.p(0, 1))
        richText:setSize(cc.size(310, 10))
        richText:onClicked(handler(self, self.richTest))
    	self._infoNode:addChild(richText)
    	self._richTextArray[#self._richTextArray + 1] = richText

		for i = 1,#upvoteArray do
	    	local nameText = lt.RichTextText.new(upvoteArray[i]:getPlayerName().."  ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = upvoteArray[i]:getPlayerId()})
	    	richText:insertElement(nameText)
		end

		
		self._richTextTable[#self._richTextTable + 1] = richText

		richText:formatText()
		nameHeight = richText:getContentSize().height

	end

    if #textArray > 0 then
    	local calCount = math.min(#textArray, 3)
    	local commentsImg = display.newSprite("#space_btn_comments.png")
		commentsImg:setAnchorPoint(0,1)
		if #upvoteArray > 0 then
			commentsImg:setPosition(0,-nameHeight - 5)
		else
	    	commentsImg:setPosition(0,0)
	    end
	    self._infoNode:addChild(commentsImg)
    	for i=1,calCount do
    		local richText = lt.RichText.new()
	    	richText:setAnchorPoint(cc.p(0, 1))
	        richText:setSize(cc.size(300, 10))
	        richText:onClicked(handler(self, self.richTest))
	    	self._infoNode:addChild(richText)

	    	self._richTextArray[#self._richTextArray + 1] = richText

	    	local nameText = lt.RichTextText.new(textArray[i]:getFromPlayerName(),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = textArray[i]:getFromPlayerId()})
	    	richText:insertElement(nameText)

            if textArray[i]:getFromPlayerId() ~= textArray[i]:getToPlayerId() and textArray[i]:getToPlayerId() ~= 0 then
                local replyText = lt.RichTextText.new(lt.StringManager:getString("STRING_FRIEND_SPACE_55"),lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
                richText:insertElement(replyText)

                local toNameText = lt.RichTextText.new(textArray[i]:getToPlayerName(),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.GREEN,{linkInfo = textArray[i]:getFromPlayerId()})
                richText:insertElement(toNameText)
            end

            local contentText = "："..textArray[i]:getContent()
	    	-- local contentText = lt.RichTextText.new("："..textArray[i]:getContent(),20,lt.Constants.DEFAULT_LABEL_COLOR_2)
	    	-- richText:insertElement(contentText)

	    	local keyStart = "(【#(%d+)】)"
        
            local subArray = {}
            local mathchArray = {}
            for k,v in string.gmatch(contentText, keyStart) do
                mathchArray[#mathchArray + 1] = {str = k, emojiNum = v}
            end

            local messageArray = {}
            local subStr = contentText
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
                    richText:insertElement(contentInfo)
                    --local msg = string.format("(普通文字)%s", messageInfo.text)
      
                elseif ty == 1 then
                    if tonumber(messageInfo.emojiNum) <= lt.Constants.EMIOY_MAX_ID then
                        local emoji = lt.Emoji.new(messageInfo.emojiNum,true)
                        emoji:setContentSize(cc.size(44,44))
                        --textLabel:setSize(cc.size(textLabel:getContentSize().width-16,textLabel:getContentSize().height))
                        --print("textLabel:getContentSize().width:"..textLabel:getContentSize().width)
                        local richItem = cpp.RichItemCustom:create(0, lt.Constants.COLOR.WHITE, 255, emoji)
                        richText:addItem(richItem)
                    else
                        local contentInfo = lt.RichTextText.new(messageInfo.text,lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
                        richText:insertElement(contentInfo)
                    end

                end
            end


            if i == 1 then
            	if #mathchArray > 0 then
	            	if #upvoteArray > 0 then
						commentsImg:setPosition(0,-nameHeight - 28)
					else
						commentsImg:setPosition(0,-20)
				    end
				else
					if #upvoteArray > 0 then
						commentsImg:setPosition(0,-nameHeight - 10)
					else
						commentsImg:setPosition(0,-5)
					end
				end
            end


	    	richText:formatText()

	    	self._richTextTable[#self._richTextTable + 1] = richText
    	end
    end
end

function RichTextScaleNode:getCustomSize()
	self:adjustSize()

	return self._costomSize
end

function RichTextScaleNode:adjustSize()
	local sumHeight = 0
	for _,richText in ipairs(self._richTextArray) do
		richText:setPositionX(42)
		richText:setPositionY(-sumHeight)

		local height = richText:getContentSize().height + 5

		sumHeight = sumHeight + height
	end

	self._costomSize = cc.size(360, sumHeight)

	self:setPreferredSize(cc.size(self._costomSize.width + 2 * self._padding, self._costomSize.height + 2 * self._padding))
	self._infoNode:setPosition(self._padding, self._padding + sumHeight)
end

function RichTextScaleNode:richTest(sender)
	if self._callBack then
		self._callBack(sender)
	end
end

function RichTextScaleNode:getAllRichText()
	return self._richTextTable
end


function RichTextScaleNode:getRichTextBg()
	return self._richTextBg
end


return RichTextScaleNode
