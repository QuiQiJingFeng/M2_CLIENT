local FigureIcon = class("FigureIcon", lt.GameIcon)

function FigureIcon:ctor()
	self.super.ctor(self)
end

function FigureIcon:updateInfo(Type,id)
	self._modelId = id

	if Type == lt.Constants.FIGURE_TYPE.AVATER then
		if self._iconImg then
			self._iconImg:removeFromParent()
			self._iconImg = nil
		end

		local iconPic = string.format("image/face/%d.png", id)
		self._iconImg = display.newSprite(iconPic)
		self._iconImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self:addChild(self._iconImg)
	elseif Type == lt.Constants.FIGURE_TYPE.BUBBLE then
		if self._iconImg then
			self._iconImg:removeFromParent()
			self._iconImg = nil
		end

		local iconPic = string.format("image/bubble/%d.png", id)
		self._iconImg = display.newSprite(iconPic)
		self._iconImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self:addChild(self._iconImg)
	end
end

function FigureIcon:setEmpty()
	self.super.setEmpty(self)
	if self._selectIcon then self._selectIcon:setVisible(false) end
end

function FigureIcon:select()
	if not self._selectIcon then
		self._selectIcon = display.newSprite("image/ui/common/common_selected_2.png")
		self._selectIcon:setPosition(40,40)
		self:addChild(self._selectIcon,101)
	end
	self._selectIcon:setVisible(true)
end

function FigureIcon:unSelect()
	if self._selectIcon then 
		self._selectIcon:setVisible(false) 
	end
end

function FigureIcon:setLockIconVisible(bool)
	self.super.setLockIconVisible(self,bool)
	if bool then
		self:setOpacity(150)
	else
		self:setOpacity(255)
	end
end

return FigureIcon
