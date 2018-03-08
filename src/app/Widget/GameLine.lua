
local GameLine = class("GameLine", function()
	return display.newNode()
end)

GameLine.TYPE = {
	BROWN_ORANGE 			= 1, -- 棕橙相间 横向
	BROWN_ORANGE_PORTRAIT   = 2, -- 棕橙相间 纵向
	FLESH 					= 3, -- 肉色
	GRAY 					= 4, -- 灰色
	GRAY_LINE 				= 5, -- 灰色 无间隔
	WHITE 					= 6, -- 白色
	BLACK					= 7, -- 黑色 无间隔
	NEW_GRAY			    = 8, -- 灰色 无间隔
	NEW_WHITE               = 9, -- 白色 无间隔
	NEW_GRAY_2			    = 10, -- 灰色 
}

function GameLine:ctor(type, width)
	local pic 	    = nil
	local baseWidth = 1

	if type == self.TYPE.BROWN_ORANGE then
		pic = "#common_line_1.png"
		baseWidth = 34

		local num = math.modf(width / baseWidth)

		for idx = 1, num do
			local component = display.newSprite(pic)

			local x = ((1 - num) / 2 + idx - 1) * baseWidth

			component:setPosition(x, 0)
			self:addChild(component)
		end
	elseif type == self.TYPE.BROWN_ORANGE_PORTRAIT then
		pic = "#common_line_1.png"
		baseWidth = 34

		self:setRotation(90)

		local num = math.modf(width / baseWidth)

		for idx = 1, num do
			local component = display.newSprite(pic)

			local x = ((1 - num) / 2 + idx - 1) * baseWidth

			component:setPosition(x, 0)
			self:addChild(component)
		end
	elseif type == self.TYPE.FLESH then
		pic = "#common_line_2.png"

		local component = display.newScale9Sprite(pic,0,0,cc.size(width, 2))
		self:addChild(component)
	elseif type == self.TYPE.GRAY then
		pic = "#common_line_3.png"
		baseWidth = 16

		local num = math.modf(width / baseWidth)

		for idx = 1, num do
			local component = display.newSprite(pic)

			local x = ((1 - num) / 2 + idx - 1) * baseWidth

			component:setPosition(x, 0)
			self:addChild(component)
		end
	elseif type == self.TYPE.GRAY_LINE then
		pic = "#common_line_3.png"

		local component = display.newScale9Sprite(pic,0,0,cc.size(width, 2))
		self:addChild(component)

	elseif type == self.TYPE.WHITE then
		pic = "#common_line_4.png"
		baseWidth = 16

		local num = math.modf(width / baseWidth)

		for idx = 1, num do
			local component = display.newSprite(pic)

			local x = ((1 - num) / 2 + idx - 1) * baseWidth

			component:setPosition(x, 0)
			self:addChild(component)
		end

	elseif type == self.TYPE.BLACK then
		pic = "#common_line_5.png"

		local component = display.newScale9Sprite(pic,0,0,cc.size(width, 2))
		self:addChild(component)

	elseif type == self.TYPE.NEW_GRAY_2 then
		pic = "#common_line_6.png"
		baseWidth = 16

		local num = math.modf(width / baseWidth)

		for idx = 1, num do
			local component = display.newSprite(pic)

			local x = ((1 - num) / 2 + idx - 1) * baseWidth

			component:setPosition(x, 0)
			self:addChild(component)
		end
	elseif type == self.TYPE.NEW_GRAY then
		pic = "#common_line_7.png"

		local component = display.newScale9Sprite(pic,0,0,cc.size(width, 2))
		self:addChild(component)
	elseif type == self.TYPE.NEW_WHITE then
		pic = "#common_line_8.png"

		local component = display.newScale9Sprite(pic,0,0,cc.size(width, 2))
		self:addChild(component)
	end
end

return GameLine
