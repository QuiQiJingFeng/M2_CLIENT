
-- 属性ICON
local PropertyIcon = class("PropertyIcon", function(property)
	if not property then
		return display.newSprite()
	else
		local picName = lt.ResourceManager:getPropertyPic(property)
		return display.newSprite("#" .. picName);
	end
end)

function PropertyIcon:update(property)
	if not property or property == lt.Constants.PROPERTY.NIL then
		self:setTexture(nil)
		self:setTextureRect(cc.rect(0,0,0,0))
		return
	end

	local picName = lt.ResourceManager:getPropertyPic(property)

	local frame = display.newSpriteFrame(picName)
	if frame then
		self:setSpriteFrame(frame)
	end
end

return PropertyIcon