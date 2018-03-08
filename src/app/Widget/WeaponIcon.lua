
-- 武器Icon
local WeaponIcon = class("WeaponIcon", lt.GameIcon)

function WeaponIcon:ctor()
	self.super.ctor(self)
end

function WeaponIcon:updateInfo(id)
	local weaponInfo = lt.CacheManager:getWeapon(id)
	
	local equipmentInfo = lt.CacheManager:getEquipmentInfo(weaponInfo:getModelId())
	if equipmentInfo then
		local grade = equipmentInfo:getQuality()
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


		local iconNum = equipmentInfo:getIconNum()
		local iconPic = string.format("#%d.png", iconNum)
		self._iconImg = display.newSprite(iconPic)
		self._iconImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self:addChild(self._iconImg)
	end

	self._modelId = id
end

function WeaponIcon:setEmpty()
	self.super.setEmpty(self)
	if self._selectIcon then self._selectIcon:setVisible(false) end
end

function WeaponIcon:select()
	if not self._selectIcon then
		self._selectIcon = display.newSprite("image/ui/common/common_selected_2.png")
		self._selectIcon:setPosition(40,40)
		self:addChild(self._selectIcon,101)
	end
	self._selectIcon:setVisible(true)
end

function WeaponIcon:unSelect()
	if self._selectIcon then 
		self._selectIcon:setVisible(false) 
	end
end

function WeaponIcon:setLockIconVisible(bool)
	self.super.setLockIconVisible(self,bool)
	if bool then
		self:setOpacity(150)
	else
		self:setOpacity(255)
	end
end

return WeaponIcon
