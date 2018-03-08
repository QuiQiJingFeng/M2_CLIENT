
--符文
local RuneIcon = class("RuneIcon", function()
	return display.newSprite()
end)

RuneIcon.TYPE = {
	NORAML    =   1, --普通
	CANBUY    =   2, --可购买
	LOCK      =   3, --锁着的
	SELECT    =   4, --选中的
}


RuneIcon.COLOR = {
	RED       =   1, --红色
	BLUE      =   2, --蓝色
	GREEN     =   3, --绿色
	PURPLE    =   4, --紫色
}

function RuneIcon:ctor()
	self._infoNode = display.newNode()
	self:addChild(self._infoNode)
end

function RuneIcon:updateInfo(color,type,id,params)

	self._infoNode:removeAllChildren()


	if params and params.level then
		local  str  = string.format(lt.StringManager:getString("STRING_RUNE_STRING_4"), params.level)

		local levelLable = lt.GameLabel.new(str, lt.Constants.FONT_SIZE3, lt.Constants.DEFAULT_LABEL_COLOR_2,{outline = true})
		levelLable:setPosition(35, 40)
		self._infoNode:addChild(levelLable)
	end


	if color == self.COLOR.RED then

		if type == self.TYPE.NORAML then

			local frame = display.newSpriteFrame("rune_red_normal.png")

			self:setSpriteFrame(frame)

		elseif type == self.TYPE.CANBUY then

			local frame = display.newSpriteFrame("rune_red_canbuybg.png")

			self:setSpriteFrame(frame)

			local lockImg = display.newSprite("#rune_red_canbuy.png")
			lockImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
			self._infoNode:addChild(lockImg)

		elseif type == self.TYPE.LOCK then

			local frame = display.newSpriteFrame("rune_red_lockbg.png")

			self:setSpriteFrame(frame)

			local lockImg = display.newSprite("#rune_red_lock.png")
			lockImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
			self._infoNode:addChild(lockImg)

		elseif type == self.TYPE.SELECT then
			
			local frame = display.newSpriteFrame("rune_icon_select.png")

			self:setSpriteFrame(frame)
		end

	elseif color == self.COLOR.BLUE then

		if type == self.TYPE.NORAML then

			local frame = display.newSpriteFrame("rune_blue_normal.png")

			self:setSpriteFrame(frame)

		elseif type == self.TYPE.CANBUY then

			local frame = display.newSpriteFrame("rune_blue_canbuybg.png")

			self:setSpriteFrame(frame)

			local lockImg = display.newSprite("#rune_blue_canbuy.png")
			lockImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
			self._infoNode:addChild(lockImg)

		elseif type == self.TYPE.LOCK then

			local frame = display.newSpriteFrame("rune_blue_lockbg.png")

			self:setSpriteFrame(frame)

			local lockImg = display.newSprite("#rune_blue_lock.png")
			lockImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
			self._infoNode:addChild(lockImg)

		elseif type == self.TYPE.SELECT then
			local frame = display.newSpriteFrame("rune_icon_select.png")

			self:setSpriteFrame(frame)
		end

	elseif color == self.COLOR.GREEN then

		if type == self.TYPE.NORAML then

			local frame = display.newSpriteFrame("rune_green_normal.png")

			self:setSpriteFrame(frame)

		elseif type == self.TYPE.CANBUY then

			local frame = display.newSpriteFrame("rune_green_canbuybg.png")

			self:setSpriteFrame(frame)

			local lockImg = display.newSprite("#rune_green_canbuy.png")
			lockImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
			self._infoNode:addChild(lockImg)

		elseif type == self.TYPE.LOCK then

			local frame = display.newSpriteFrame("rune_green_lockbg.png")

			self:setSpriteFrame(frame)

			local lockImg = display.newSprite("#rune_green_lock.png")
			lockImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
			self._infoNode:addChild(lockImg)

		elseif type == self.TYPE.SELECT then
			local frame = display.newSpriteFrame("rune_icon_select.png")

			self:setSpriteFrame(frame)
		end

	elseif color == self.COLOR.PURPLE then

		if type == self.TYPE.NORAML then

			local frame = display.newSpriteFrame("rune_purple_normal.png")

			self:setSpriteFrame(frame)

		elseif type == self.TYPE.CANBUY then

			local frame = display.newSpriteFrame("rune_purple_canbuybg.png")

			self:setSpriteFrame(frame)

			local lockImg = display.newSprite("#rune_purple_canbuy.png")
			lockImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
			self._infoNode:addChild(lockImg)

		elseif type == self.TYPE.LOCK then

			local frame = display.newSpriteFrame("rune_purple_lockbg.png")

			self:setSpriteFrame(frame)

			local lockImg = display.newSprite("#rune_purple_lock.png")
			lockImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
			self._infoNode:addChild(lockImg)

		elseif type == self.TYPE.SELECT then
			local frame = display.newSpriteFrame("rune_icon_select.png")

			self:setSpriteFrame(frame)
		end

	end


	--local id = math.random(1, 4)

	if id then
		local iconPic = string.format("image/rune/%d.png", id)
		self._runeIcon = display.newSprite(iconPic)
		self._runeIcon:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self._infoNode:addChild(self._runeIcon)
	end

end

return RuneIcon
