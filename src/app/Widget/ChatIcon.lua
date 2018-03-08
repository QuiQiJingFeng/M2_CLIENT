--聊天气泡
local ChatIcon = class("ChatIcon", function(smallType)
	return display.newSprite("#common_icon_bg_big.png")
end)

ChatIcon._baseScale = 1
ChatIcon._iconImg = nil
ChatIcon._selectFlag = nil
ChatIcon._equipFlag = nil
ChatIcon.TYPE = {
	FACE    =    1,--头像
	CHATBG  =    2,--聊天气泡
}

function ChatIcon:ctor(smallType)
	if smallType then
		self._baseScale = 76 / 88
		self:setRealScale(1)
	end

	self:setCascadeOpacityEnabled(true)
end

function ChatIcon:updateInfo(type,id)
	self._equipFlag = nil
	self._selectFlag = nil
	if self._iconImg then
		self._iconImg:removeFromParent()
		self._iconImg = nil
	end

	if not type then return end
	if not id then return end

	local personalityInfo = lt.CacheManager:getPersonality(id)

	if not personalityInfo then return end

	local iconNum = personalityInfo:getIcon()

	local iconPic = nil

	if type == self.TYPE.FACE then
		iconPic = string.format("image/face/%d.png", id)
	elseif type == self.TYPE.CHATBG then
		iconPic = string.format("image/chatbg/%d.png", iconNum)
	end
	self._iconImg = display.newSprite(iconPic)

	if not self._iconImg then return end

	if self._baseScale ~= 1 then
		self._iconImg:setScale(88/76)
	end
	self._iconImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
	self:addChild(self._iconImg)

	local lockImg = display.newSprite("#common_img_lock.png")
	lockImg:setAnchorPoint(1,1)
	lockImg:setPosition(self._iconImg:getContentSize().width, self._iconImg:getContentSize().height)
	self._iconImg:addChild(lockImg)



	local decorationListTabel = lt.DataManager:getDecorationListTabel()
	local avatarId = lt.DataManager:getPlayer():getAvatarId()
    local bubbleId = lt.DataManager:getPlayer():getBubbleId()

	for decorationId,decoration in pairs(decorationListTabel) do
		if decorationId == id then
			lockImg:setVisible(false)
			if decoration:getIsEquipped() == 1 then
				self:setEquipped(true)
			end
		end
	end	
end

function ChatIcon:setEquipped(equipped)
	if equipped then
        if not self._equipFlag then
            self._equipFlag = display.newSprite("#common_equip_icon.png")
            self._equipFlag:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
            self:addChild(self._equipFlag,100)
        else
            self._equipFlag:setVisible(true)
        end
    else
        if self._equipFlag then 
            self._equipFlag:setVisible(false)
        end
    end
end

function ChatIcon:setSelected(selected)
    if selected then
        if not self._selectFlag then
            self._selectFlag = display.newSprite("#common_icon_selected.png")
            self._selectFlag:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
            self:addChild(self._selectFlag,100)
        else
            self._selectFlag:setVisible(true)
        end
    else
        if self._selectFlag then 
            self._selectFlag:setVisible(false)
        end
    end
end

function ChatIcon:setRealScale(scale)
	self:setScale(self._baseScale * scale)
end

return ChatIcon