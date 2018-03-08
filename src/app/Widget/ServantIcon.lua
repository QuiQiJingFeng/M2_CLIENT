-- 英灵Icon
local ServantIcon = class("ServantIcon", lt.GameIcon)

function ServantIcon:ctor()
	ServantIcon.super.ctor(self)
end

function ServantIcon:updateInfo(Type,id)
	self.super.updateInfo(self,self.TYPE.SERVANT,id)

	self._itemType = self.TYPE.SERVANT
	self._type = self.TYPE.SERVANT
	self._modelId = id

	local servantInfo = lt.CacheManager:getServantInfo(id)

	if not servantInfo then
		return
	end

	local grade = servantInfo:getQuality() --用紫橙
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

	self._iconImg = display.newSprite("image/servant/pics/servants"..servantInfo:getFigureId()..".png")
	self._iconImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
	self:addChild(self._iconImg)
end

function ServantIcon:getModelId()
	return self._modelId
end
return ServantIcon
