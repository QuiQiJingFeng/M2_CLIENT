
local PropertyRelationship = class("PropertyRelationship", function()
	return display.newNode()
end)

-- 元素关系图
function PropertyRelationship:ctor()
	local height = 36

	local arrow1 = display.newSprite("#common_arrow_green.png")
	arrow1:setPosition(-40 - 2 * height / math.sqrt(3) / 2, 0)
	arrow1:setRotation(30)
	self:addChild(arrow1)

	local arrow2 = display.newSprite("#common_arrow_green.png")
	arrow2:setPosition(-40, -height)
	arrow2:setRotation(-90)
	self:addChild(arrow2)

	local arrow3 = display.newSprite("#common_arrow_green.png")
	arrow3:setPosition(-40 + 2 * height / math.sqrt(3) / 2, 0)
	arrow3:setRotation(150)
	self:addChild(arrow3)

	local fire = lt.PropertyIcon.new(lt.Constants.PROPERTY.FIRE)
	fire:setPosition(-40, height)
	self:addChild(fire)

	local water = lt.PropertyIcon.new(lt.Constants.PROPERTY.WATER)
	water:setPosition(-40 - 2 * height / math.sqrt(3), -height)
	self:addChild(water)

	local wind = lt.PropertyIcon.new(lt.Constants.PROPERTY.WIND)
	wind:setPosition(-40 + 2 * height / math.sqrt(3), -height)
	self:addChild(wind)

	local arrow4 = display.newSprite("#common_arrow_green_2.png")
	arrow4:setPosition(60, 0)
	self:addChild(arrow4)

	local light = lt.PropertyIcon.new(lt.Constants.PROPERTY.LIGHT)
	light:setPosition(60, height)
	self:addChild(light)

	local dark = lt.PropertyIcon.new(lt.Constants.PROPERTY.DARK)
	dark:setPosition(60, -height)
	self:addChild(dark)
end

return PropertyRelationship
