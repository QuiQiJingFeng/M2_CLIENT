
local RollingChatNode = class("RollingChatNode", function()
    return cc.ClippingRegionNode:create()
end)

RollingChatNode._rect = nil

RollingChatNode._strIdx = 0
RollingChatNode._strArray = nil

RollingChatNode._handle = nil
RollingChatNode._checkNode = nil
RollingChatNode._nodeTable = nil

function RollingChatNode:ctor(rect)
	self:setNodeEventEnabled(true)

	self._rect = rect
	self:setClippingRegion(rect)

	self._chatInfo = nil
    self._chatArray = {}
    self._strNums = 0
    self._nodeTable = {}
end

function RollingChatNode:onExit()
	self:clear()
end

function RollingChatNode:setRect(rect)
	self._rect = rect
	self:setClippingRegion(rect)
end

function RollingChatNode:clear()
	if self._handle then
		lt.scheduler.unscheduleGlobal(self._handle)
        self._handle = nil
	end
	for idx,node in pairs(self._nodeTable) do
		node:removeSelf()
	end
	self._strArray = {}
	self._nodeTable = {}
	self._checkNode = nil
end

function RollingChatNode:setChatInfo(chatInfo)
	self:clear()
	self._chatInfo = chatInfo
	self._handle = lt.scheduler.scheduleUpdateGlobal(handler(self, self.onUpdate))
end

function RollingChatNode:onUpdate(delta)
	if not self._checkNode then
		local node  = display.newNode()
		node:setAnchorPoint(0,0.5)
		node:setPosition(self._rect.x, 0)
		self:addChild(node)

		
		local message = self._chatInfo:getMessage()
		local subType = self._chatInfo:getSubType()


		local positionX = 0

		if subType == lt.Constants.CHAT_SUB_TYPE.LINK_LINE then
			local subContentJson = self._chatInfo:getSubContent()
            local subContent = json.decode(subContentJson)

            local checkMessage = string.gsub(message, "+", "_")

            local subArray = {}
            local emojiCount = 0
            for keyStr,linkInfo in pairs(subContent) do
                keyStr = string.gsub(keyStr, "+", "_")
                if string.match(keyStr, "【#") then
                    emojiCount = emojiCount + 1
                end
                local st, ed = string.find(checkMessage, keyStr)
                if st then
                    subArray[#subArray + 1] = {st = st, ed = ed, linkInfo = linkInfo}
                end
            end

            local tempMessage = message
            local messageArray = {}
            local messageLen = string.len(message)


            table.sort(subArray, function(info1, info2)
                return info1.st < info2.st
            end)

            local pos = 1
            for _,subInfo in ipairs(subArray) do
                
                local st        = subInfo.st
                local ed        = subInfo.ed
                local linkInfo  = subInfo.linkInfo

                if st > pos then
                    local subMessage = string.sub(tempMessage, pos, st - 1)
                    messageArray[#messageArray + 1] = {ty = 0, text = subMessage}
                    pos = st
                end


                local linkMessage = string.sub(tempMessage, pos, ed)
                messageArray[#messageArray + 1] = {ty = 1, text = linkMessage, linkInfo = linkInfo}
                pos = ed + 1
            end

            if pos <= messageLen then
                -- 剩余普通文本
                local subMessage = string.sub(tempMessage, pos, messageLen)
                messageArray[#messageArray + 1] = {ty = 0, text = subMessage}
            end

            for _,messageInfo in ipairs(messageArray) do
                local ty = messageInfo.ty
                if ty == 0 then
                    local labelMessage = lt.GameLabel.new(messageInfo.text, 20, lt.Constants.COLOR.WHITE)
					labelMessage:setAnchorPoint(0, 0.5)
					labelMessage:setPosition(positionX, 0)
					node:addChild(labelMessage)
					positionX = positionX + labelMessage:getContentSize().width
					node:setContentSize(node:getContentSize().width+labelMessage:getContentSize().width,0)
                elseif ty == 1 then
                    if messageInfo.linkInfo.itemType == lt.GameIcon.TYPE.EMOJI then
                        local emoji = lt.Emoji.new(messageInfo.linkInfo.id,true)
                        emoji:setAnchorPoint(0,0.5)
                        emoji:setContentSize(cc.size(44,44))
                        emoji:setPosition(positionX,5)
                        node:addChild(emoji)
                        positionX = positionX + 44
                        node:setContentSize(node:getContentSize().width+44,0)
                    else
                    	local _linkInfo = messageInfo.linkInfo
                    	local quality = 1
                        if _linkInfo.itemType == lt.GameIcon.TYPE.ITEM then
                            local itemInfo = lt.CacheManager:getItemInfo(_linkInfo.modelId)
                            if itemInfo then
                                quality = itemInfo:getGrade()
                            end
                        elseif _linkInfo.itemType == lt.GameIcon.TYPE.EQUIPMENT then
                            local equipmentInfo = lt.CacheManager:getEquipmentInfo(_linkInfo.modelId)
                            if equipmentInfo then
                                quality = equipmentInfo:getQuality()
                            end
                        elseif _linkInfo.itemType == lt.GameIcon.TYPE.SERVANT then
                            local servantInfo = lt.CacheManager:getServantInfo(_linkInfo.modelId)
                            if servantInfo then
                                local quality = servantInfo:getQuality()
                            end
                        end
                    	local realText = string.gsub(string.gsub(messageInfo.text, "【", "["), "】","]")
                    	local labelMessage = lt.GameLabel.new(realText, 20, lt.UIMaker:getGradeColor(quality))
						labelMessage:setAnchorPoint(0, 0.5)
						labelMessage:setPosition(positionX, 0)
						node:addChild(labelMessage)
						positionX = positionX + labelMessage:getContentSize().width
						node:setContentSize(node:getContentSize().width+labelMessage:getContentSize().width,0)
                    end
                end
            end
		else
			local labelMessage = lt.GameLabel.new(message, 20, lt.Constants.COLOR.WHITE)
			labelMessage:setAnchorPoint(0, 0.5)
			labelMessage:setPosition(0, 0)
			node:addChild(labelMessage)
			node:setContentSize(node:getContentSize().width+labelMessage:getContentSize().width,0)
		end

		self._checkNode = node
		self._nodeTable[#self._nodeTable + 1] = node
	end

	-- 所有字左移动
	for idx,node in pairs(self._nodeTable) do
		if node:getContentSize().width <= self._rect.width then
            --文字不用滚动
            lt.GameEventManager:post(lt.GameEventManager.EVENT.CLOSE_TRUMPET)
			return
		end

		local x = node:getPositionX()
		local width = node:getContentSize().width

		local newX = x - 40 * delta
		local newRight = newX + width

		if node == self._checkNode then
			-- 判断右侧过线
			if newRight < self._rect.x + self._rect.width - 5 then
				--self._checkNode = nil
				if self._handle then
                    --滚动完毕
                    lt.GameEventManager:post(lt.GameEventManager.EVENT.CLOSE_TRUMPET)
					lt.scheduler.unscheduleGlobal(self._handle)
                    self._handle = nil
				end
			end
		end

		if newRight < self._rect.x then

		else
			node:setPositionX(newX)
		end
	end
end

return RollingChatNode