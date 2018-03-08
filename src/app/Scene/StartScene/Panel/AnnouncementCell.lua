
--获取途径cell
local AnnouncementCell = class("AnnouncementCell", function()
	return display.newSprite("#common_tab_gray_1.png")
end)

AnnouncementCell._cellSize = cc.size(172, 66)
function AnnouncementCell:ctor()
	self._infoNode = display.newNode()
	
	self:addChild(self._infoNode)
end

function AnnouncementCell:updateInfo(info)


	local title = info:getTitle()

	local nameLabel = lt.GameLabel.new(title,lt.Constants.FONT_SIZE4,lt.Constants.COLOR.WHITE,{outline = true,outlineSize = 1, outlineColor = lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
    nameLabel:setAnchorPoint(0.5, 0.5)
    nameLabel:setPosition(86, 33)
    self._infoNode:addChild(nameLabel)

end

function AnnouncementCell:selected()
    self:setSpriteFrame("common_tab_yellow_1.png")
end

function AnnouncementCell:unSelect()
    self:setSpriteFrame("common_tab_gray_1.png")
end

return AnnouncementCell