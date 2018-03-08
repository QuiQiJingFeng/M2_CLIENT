
local OccupationIcon = class("OccupationIcon", function(occupationId,scale)
	local rScale = scale or 0.5
	local iconStr = "#"..lt.ResourceManager.OCCUPATION_EMBLEM[occupationId]
	local icon = display.newSprite(iconStr)
	icon:setScale(rScale)
	return icon
end)

return OccupationIcon
