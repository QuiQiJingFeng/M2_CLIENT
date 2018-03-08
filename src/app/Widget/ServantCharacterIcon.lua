
-- 英灵特性Icon
local ServantCharacterIcon = class("ServantCharacterIcon", lt.GameIcon)

function ServantCharacterIcon:ctor()
	self.super.ctor(self)
end

function ServantCharacterIcon:updateInfo(Type,id)
	self.super.updateInfo(self,self.TYPE.CHARACTER_SERVANT,id)

	self._itemType = self.TYPE.CHARACTER_SERVANT
	self._type = self.TYPE.CHARACTER_SERVANT
	self._modelId = id

	local servantCharacterInfo = lt.CacheManager:getServantCharacter(id)
	if not servantCharacterInfo then
		return
	end
	local grade = servantCharacterInfo:getLevel()
	local qualityName = lt.ResourceManager:getQualityBg(grade)
	local qualityIconName = lt.ResourceManager:getQualityIcon(grade)

	if self._qualityBg then
		self._qualityBg:removeFromParent()
		self._qualityBg = nil
	end

	if self._qualityIcon then
		self._qualityIcon:removeFromParent()
		self._qualityIcon = nil
	end
	
	self._qualityBg = display.newSprite(qualityName)
	self._qualityBg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
	self:addChild(self._qualityBg)

	if grade > lt.Constants.QUALITY.QUALITY_WHITE then
		self._qualityIcon = display.newSprite(qualityIconName)
		self._qualityIcon:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self:addChild(self._qualityIcon)
	end

	if self._iconImg then
		self._iconImg:removeFromParent()
		self._iconImg = nil
	end

	local iconNum = servantCharacterInfo:getIconId()
	self._iconImg = display.newSprite("image/servant/character/sc"..iconNum..".png")
	self._iconImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
	self:addChild(self._iconImg)
end

function ServantCharacterIcon:setEmpty()
	self.super.setEmpty(self)
	if self._questionIcon then self._questionIcon:setVisible(false) end
	if self._unenableIcon then self._unenableIcon:setVisible(false) end
	if self._iconImg then self._iconImg:setOpacity(255) end
end

function ServantCharacterIcon:setQuestionIcon(visible)
	if not self._questionIcon then
		self._questionIcon = display.newSprite("#common_icon_question.png")
		self._questionIcon:setPosition(40,40)
		self:addChild(self._questionIcon,100)
	end
	self._questionIcon:setVisible(visible)
end

function ServantCharacterIcon:setUnenableIcon(visible)
	if not self._unenableIcon then
		self._unenableIcon = display.newSprite("#servant_icon_unenable.png")
		self._unenableIcon:setAnchorPoint(1,0)
		self._unenableIcon:setPosition(80,0)
		self:addChild(self._unenableIcon,100)
	end
	if visible then
		self._iconImg:setOpacity(150)
	else
		self._iconImg:setOpacity(255)
	end
	self._unenableIcon:setVisible(visible)
end

return ServantCharacterIcon
