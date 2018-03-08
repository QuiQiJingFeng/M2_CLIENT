
local GameListCell = class("GameListCell", function(type, width, x, y, height)
	local filename  = nil
	local capInsets = nil

	local size = cc.size(width, 0)
	local winScale = lt.CacheManager:getWinScale()
	if type == 1 then
		filename = "image/ui/common/common_listcell_1.png"
		capInsets = cc.rect(5, 5, 40, 94)
		size.height = height or 104*lt.CacheManager:getWinScale()
	elseif type == 2 then
		filename = "image/ui/common/common_listcell_2.png"
		capInsets = cc.rect(5, 5, 40, 84)
		size.height = height or 94*lt.CacheManager:getWinScale()
	end

	x = x or 0
	y = y or 0

	return display.newScale9Sprite(filename, x, y, size, capInsets)
end)

GameListCell.TYPE = {
	GAME_LIST_CELL_TYPE_1 = 1,
	GAME_LIST_CELL_TYPE_2 = 2,
}

return GameListCell
