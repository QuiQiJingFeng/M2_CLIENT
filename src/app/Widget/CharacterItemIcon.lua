-- 特性书Icon
local CharacterItemIcon = class("CharacterItemIcon", lt.GameIcon)

function CharacterItemIcon:ctor()
	self.super.ctor(self)
end

function CharacterItemIcon:setEmpty()
	self.super.setEmpty(self)
	if self._selectIcon then self._selectIcon:setVisible(false) end
	if self._learnIcon then self._learnIcon:setVisible(false) end
end

function CharacterItemIcon:select()
	if not self._selectIcon then
		self._selectIcon = display.newSprite("image/ui/common/common_selected_2.png")
		self._selectIcon:setPosition(40,40)
		self:addChild(self._selectIcon,101)
	end
	self._selectIcon:setVisible(true)
end

function CharacterItemIcon:unSelect()
	if self._selectIcon then 
		self._selectIcon:setVisible(false) 
	end
end

function CharacterItemIcon:setLearnIcon()
	if not self._learnIcon then
		self._learnIcon = display.newSprite("#servant_icon_learn.png")
		self._learnIcon:setPosition(65,65)
		self:addChild(self._learnIcon,101)
	end
	self._learnIcon:setVisible(true)
end

function CharacterItemIcon:setUnLearnIcon()
	if self._learnIcon then 
		self._learnIcon:setVisible(false) 
	end
end

function CharacterItemIcon:setOpacity(delta)
	if self._iconImg then
		self._iconImg:setOpacity(delta)
	end
end

return CharacterItemIcon
