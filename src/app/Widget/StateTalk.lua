
-- 状态说说
local StateTalk = class("StateTalk", function()
	return display.newScale9Sprite("image/ui/common/common_bg_n_3.png", 0, 0, cc.size(524, 24))
	--return display.newNode()
end)

StateTalk.TYPE = {
	FRIEND_CIRCLE   = 0, -- 好友圈
	TALK_ABOUT      = 1, -- 说说
}

StateTalk._type    = nil
StateTalk._infoNode = nil
StateTalk._qualityBg = nil
StateTalk._costomSize = cc.size(510, 10)
StateTalk._padding = 7
StateTalk._baseHeight = 30
StateTalk._praiseBtnCallBack = nil
StateTalk._commentsBtnCallBack = nil
StateTalk._friendSpaceLayer = nil
StateTalk._richTextNode = nil

function StateTalk:ctor()
	self._infoNode = display.newNode()
	self:addChild(self._infoNode)
end

function StateTalk:updateInfo(layer,type, info, commentArray,upvoteArray,praiseBtnCallBack,commentsBtnCallBack,richTestCallBack,delMessageCallBack)
	
	self._infoNode:removeAllChildren()
	self._richTextNode = nil

	self._type = type
	self._friendSpaceLayer = layer
	self._praiseBtnCallBack = praiseBtnCallBack
	self._commentsBtnCallBack = commentsBtnCallBack
	self._richTestCallBack  = richTestCallBack
	self._delMessageCallback = delMessageCallBack
	self._commentArray = commentArray or {}
	self._upvoteArray  = upvoteArray or {}
	local zoneTalkInfo = info
    local upvoteNum = #self._upvoteArray
    local commentNum = #self._commentArray


	if self._type == self.TYPE.FRIEND_CIRCLE then

		local height = 0

		local playerAvatarId = zoneTalkInfo:getPlayerAvatarId()

	    local iconImg = lt.PlayerFace.new()
	    iconImg:setPosition(10,height - 5)
	    iconImg:setAnchorPoint(0, 1)
	    iconImg.id = zoneTalkInfo:getPlayerId()
	    iconImg:setTag(99999)

	    iconImg:updateInfo(zoneTalkInfo:getOccupationId(),nil,nil,playerAvatarId)
	    self._infoNode:addChild(iconImg)



	    local nameLabel = lt.GameLabel.new(zoneTalkInfo:getPlayerName(), lt.Constants.FONT_SIZE1, lt.Constants.COLOR.SPACE_BROWN)
	    nameLabel:setAnchorPoint(0, 1)
	    nameLabel:setPosition(iconImg:getPositionX() + iconImg:getContentSize().width + 5, iconImg:getPositionY())
	    self._infoNode:addChild(nameLabel)


	    local time = zoneTalkInfo:getCreateTime()
	    local day = lt.CommonUtil:getFormatDay(time, 1)
	    local timeLabel = lt.GameLabel.new(day,lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
	    timeLabel:setAnchorPoint(1, 1)
	    timeLabel:setPosition(510 - 30,nameLabel:getPositionY())
	    self._infoNode:addChild(timeLabel)


	    local currentTime = lt.CommonUtil:getCurrentTime()
	    local realTime = currentTime - time
	    
	    if realTime < 24 * 60 * 60 then
	    	if realTime / 60 < 60 then

	    		if realTime < 1 then
	    			realTime = 1
	    		end

	    		timeLabel:setString(string.format(lt.StringManager:getString("STRING_FRIEND_SPACE_50"),math.ceil(realTime / 60)))
	    	else
	    		timeLabel:setString(string.format(lt.StringManager:getString("STRING_FRIEND_SPACE_51"),math.floor(realTime / 60 / 60)))
	    	end
	    end


	    local content = zoneTalkInfo:getContent()
	    height = height + nameLabel:getContentSize().height + 5

	    -- local textLabel = lt.GameLabel.new(zoneTalkInfo:getContent(), lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
	    -- textLabel:setAnchorPoint(0, 1)
	    -- textLabel:setPosition(nameLabel:getPositionX(), - height)
	    -- textLabel:setDimensions(380,0)
	    -- textLabel:setLineBreakWithoutSpace(true)
	    -- self._infoNode:addChild(textLabel)

	    local textLabel = lt.RichText.new()
	    textLabel:setPosition(nameLabel:getPositionX(), - height)
	    textLabel:setSize(cc.size(380, 10))
	    textLabel:setAnchorPoint(cc.p(0,1))
	    self._infoNode:addChild(textLabel)
	    
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


        
	    height = height + textLabel:getContentSize().height

	    -- 点赞
	    local praisebtn = lt.ScaleButton.new("#space_btn_bag.png")
	    praisebtn:setAnchorPoint(0.5,0.5)
	    praisebtn:setPosition(textLabel:getPositionX() + 48, -height - 24)
	    praisebtn:setTag(zoneTalkInfo:getId())
	    praisebtn.info = zoneTalkInfo
	    praisebtn:onButtonClicked(handler(self, self.onPraiseBtnCallBack))
	    self._infoNode:addChild(praisebtn)



	    --点赞的心
	    local img = "#space_btn_praise.png"
	    if self:checKUpvoteIsTure() then
	    	img = "#stall_icon_heart.png"
	    end
	    --点赞的心
	    local praiseImg = display.newSprite(img)
	    praiseImg:setAnchorPoint(0,0.5)
	    praiseImg:setPosition(-48,praisebtn:getContentSize().height / 2)
	    praisebtn:addChild(praiseImg)

	    if self:checKUpvoteIsTure() then
	    	praiseImg:setScale(0.8)
	    end

	    --点赞的数目
	    local praiseLabel = lt.GameLabel.new(upvoteNum,lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
	    praiseLabel:setPosition(15,praisebtn:getContentSize().height / 2)
	    praisebtn:addChild(praiseLabel)

	    --评论
	    local commentsbtn = lt.ScaleButton.new("#space_btn_bag.png")
	    commentsbtn:setAnchorPoint(0.5,0.5)
	    commentsbtn:setPosition(praisebtn:getPositionX() + 120,praisebtn:getPositionY())
	    commentsbtn:setTag(zoneTalkInfo:getId())
	    commentsbtn.info = zoneTalkInfo
	    commentsbtn:onButtonClicked(handler(self, self.onCommentsBtnCallBack))
	    self._infoNode:addChild(commentsbtn)

	    --评论的图片
	    local commentsImg = display.newSprite("#space_btn_comments.png")
	    commentsImg:setAnchorPoint(0,0.5)
	    commentsImg:setPosition(-48,commentsbtn:getContentSize().height / 2)
	    commentsbtn:addChild(commentsImg)

	    --评论的数目
	    local commentsLabel = lt.GameLabel.new(commentNum,lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
	    commentsLabel:setPosition(15,commentsbtn:getContentSize().height / 2)
	    commentsbtn:addChild(commentsLabel)

	    local deleteBtn = lt.ScaleButton.new("#space_btn_delete.png")
	    deleteBtn:setPosition(commentsbtn:getPositionX() + 190, commentsbtn:getPositionY())
	    deleteBtn:onButtonClicked(handler(self, self.onDeleteMessage))
	    deleteBtn.info = zoneTalkInfo

	    local playerId = lt.DataManager:getPlayerId()
	    if playerId == zoneTalkInfo:getPlayerId() then
	    	self._infoNode:addChild(deleteBtn)
	    end




	    height = height + 46

	    if commentNum > 0 or upvoteNum > 0 then
		    self._richTextNode = lt.RichTextScaleNode.new(self._friendSpaceLayer,self._commentArray,self._upvoteArray ,handler(self, self.richTest),zoneTalkInfo)
		    self._richTextNode:setAnchorPoint(0, 1)
		    self._richTextNode:setPosition(textLabel:getPositionX() - 4, -height)
		    self._infoNode:addChild(self._richTextNode)
		end

	    self._baseHeight = height

	    self._costomSize = cc.size(510, height)
	    --self:setContentSize(cc.size(self._costomSize.width + 2 * self._padding, self._costomSize.height + 2 * self._padding))
	    self:setPreferredSize(cc.size(self._costomSize.width + 2 * self._padding, self._costomSize.height + 2 * self._padding))
	    self._infoNode:setPosition(self._padding, self._padding + height)
	elseif self._type == self.TYPE.TALK_ABOUT then
		
        local timeBg = lt.GameInfoBg.new(lt.GameInfoBg.TYPE.GAME_INFO_BG_TYPE_2, cc.size(100,30), 5, -5)
	    timeBg:setAnchorPoint(0,1)
	    self._infoNode:addChild(timeBg)

	    local time = zoneTalkInfo:getCreateTime()

	    local day = lt.CommonUtil:getFormatDay(time, 4)
	    local timeLabel = lt.GameLabel.new(day,lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
	    timeLabel:setAnchorPoint(0.5, 0.5)
	    timeLabel:setPosition(timeBg:getContentSize().width / 2,timeBg:getContentSize().height / 2)
	    timeBg:addChild(timeLabel)

        -- 状态
        local height = -5
        local content = zoneTalkInfo:getContent()
		-- local textLabel = lt.GameLabel.new(zoneTalkInfo:getContent(), lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
	 --    textLabel:setAnchorPoint(0, 1)
	 --    textLabel:setPosition(116, height)
	 --    textLabel:setDimensions(380,0)
	 --    textLabel:setLineBreakWithoutSpace(true)
	 --    self._infoNode:addChild(textLabel)
 	    local textLabel = lt.RichText.new()
	    textLabel:setPosition(116, height)
	    textLabel:setSize(cc.size(380, 10))
	    textLabel:setAnchorPoint(cc.p(0,1))
	    self._infoNode:addChild(textLabel)
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


	    height = height + textLabel:getContentSize().height

	    -- 点赞
	    local praisebtn = lt.ScaleButton.new("#space_btn_bag.png")
	    praisebtn:setAnchorPoint(0.5,0.5)
	    praisebtn:setPosition(textLabel:getPositionX() + 48, -height - 28)
	    praisebtn:setTag(zoneTalkInfo:getId())
	    praisebtn:onButtonClicked(handler(self, self.onPraiseBtnCallBack))
	    self._infoNode:addChild(praisebtn)

	    --点赞的心
	    local img = "#space_btn_praise.png"
	    if self:checKUpvoteIsTure() then
	    	img = "#stall_icon_heart.png"
	    end


	    local praiseImg = display.newSprite(img)
	    praiseImg:setAnchorPoint(0,0.5)
	    praiseImg:setPosition(-48,praisebtn:getContentSize().height / 2)
	    praisebtn:addChild(praiseImg)

	    if self:checKUpvoteIsTure() then
	    	praiseImg:setScale(0.8)
	    end

	    --点赞的数目
	    local praiseLabel = lt.GameLabel.new(upvoteNum,lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
	    praiseLabel:setPosition(15,praisebtn:getContentSize().height / 2)
	    praisebtn:addChild(praiseLabel)

	    --评论
	    local commentsbtn = lt.ScaleButton.new("#space_btn_bag.png")
	    commentsbtn:setAnchorPoint(0.5,0.5)
	    commentsbtn:setPosition(praisebtn:getPositionX() + 120,praisebtn:getPositionY())
	    commentsbtn:setTag(zoneTalkInfo:getId())
	    commentsbtn.info = zoneTalkInfo
	    commentsbtn:onButtonClicked(handler(self, self.onCommentsBtnCallBack))
	    self._infoNode:addChild(commentsbtn)

	    --评论的图片
	    local commentsImg = display.newSprite("#space_btn_comments.png")
	    commentsImg:setAnchorPoint(0,0.5)
	    commentsImg:setPosition(-48,commentsbtn:getContentSize().height / 2)
	    commentsbtn:addChild(commentsImg)

	    --评论的数目
	    local commentsLabel = lt.GameLabel.new(commentNum,lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
	    commentsLabel:setPosition(15,commentsbtn:getContentSize().height / 2)
	    commentsbtn:addChild(commentsLabel)

	    local playerId = lt.DataManager:getPlayer():getId()

	    local deleteBtn = lt.ScaleButton.new("#space_btn_delete.png")
	    deleteBtn:setPosition(commentsbtn:getPositionX() + 190, commentsbtn:getPositionY())
	    deleteBtn:onButtonClicked(handler(self, self.onDeleteMessage))
	    deleteBtn:setTag(zoneTalkInfo:getId())
	    

	    if playerId == zoneTalkInfo:getPlayerId() then
	    	self._infoNode:addChild(deleteBtn)
	    end

	    height = height + 46 + 5

	    if commentNum > 0 or upvoteNum > 0 then
		    self._richTextNode = lt.RichTextScaleNode.new(self._friendSpaceLayer,self._commentArray,self._upvoteArray ,handler(self, self.richTest),zoneTalkInfo)
		    self._richTextNode:setAnchorPoint(0, 1)
		    self._richTextNode:setPosition(textLabel:getPositionX() - 4, - height)
		    self._infoNode:addChild(self._richTextNode)
		end

	    self._baseHeight = height

	    self._costomSize = cc.size(510, height)
	    --self:setContentSize(cc.size(self._costomSize.width + 2 * self._padding, self._costomSize.height + 2 * self._padding))
	    self:setPreferredSize(cc.size(self._costomSize.width + 2 * self._padding, self._costomSize.height + 2 * self._padding))
	    self._infoNode:setPosition(self._padding, self._padding + height)
	end
end

function StateTalk:getCustomSize()
	self:adjustSize()

	return self._costomSize
end

function StateTalk:adjustSize()
	local sumHeight = self._baseHeight + 5
	--dump(self._richTextNode)
	if self._richTextNode then
		local customSize = self._richTextNode:getCustomSize()
		sumHeight = sumHeight + customSize.height + 2 * self._padding
	end

	self._costomSize = cc.size(510, sumHeight)
	--self:setContentSize(cc.size(self._costomSize.width + 2 * self._padding, self._costomSize.height + 2 * self._padding))
	self:setPreferredSize(cc.size(self._costomSize.width + 2 * self._padding, self._costomSize.height + 2 * self._padding))
	self._infoNode:setPosition(self._padding, self._padding + sumHeight)
end

function StateTalk:getRichTextNode()

 	return self._richTextNode
end

function StateTalk:setAllRichTextTouchEnanled(bool)
	local richtextNode = self:getRichTextNode()

	if richtextNode == nil then return end
	local allRichTextTable = richtextNode:getAllRichText()

	if #allRichTextTable > 0 then
		for i=1,#allRichTextTable do
			allRichTextTable[i]:setTouchEnabled(bool)
		end
	end
end

function StateTalk:richTest(sender)
	if self._richTestCallBack then
		self._richTestCallBack(sender)
	end
end

function StateTalk:onPraiseBtnCallBack(event)
	self._praiseBtnCallBack(event)
end

function StateTalk:onCommentsBtnCallBack(event)
	self._commentsBtnCallBack(event)
end

function StateTalk:onDeleteMessage(event)
	self._delMessageCallback(event)
end

function StateTalk:getInfoNode()
	return self._infoNode
end


function StateTalk:checKUpvoteIsTure()
	local upvote = false

    local player = lt.DataManager:getPlayer()
    local playerId = player:getId()

    local upvoteNum = #self._upvoteArray or {}

    for i = 1,upvoteNum do
        if self._upvoteArray[i]:getPlayerId() == player:getId() then
            upvote = true
        end
    end

    return upvote
end

return StateTalk
