
-- ʱװIcon
local DressIcon = class("DressIcon", lt.GameIcon)

function DressIcon:ctor()
	self.super.ctor(self)
end

function DressIcon:updateInfo(id)
	local dressInfo = lt.CacheManager:getDress(id)
	self.super.updateInfo(self,lt.GameIcon.TYPE.ITEM, dressInfo:getIcon())
	self._modelId = id
end

function DressIcon:setEmpty()
	self.super.setEmpty(self)
	if self._selectIcon then self._selectIcon:setVisible(false) end
end

function DressIcon:select()
	if not self._selectIcon then
		self._selectIcon = display.newSprite("image/ui/common/common_selected_2.png")
		self._selectIcon:setPosition(40,40)
		self:addChild(self._selectIcon,101)
	end
	self._selectIcon:setVisible(true)
end

function DressIcon:unSelect()
	if self._selectIcon then 
		self._selectIcon:setVisible(false) 
	end
end

function DressIcon:setLockIconVisible(bool)
	self.super.setLockIconVisible(self,bool)
	if bool then
		self:setOpacity(150)
	else
		self:setOpacity(255)
	end
end

return DressIcon
