
local GameListBg = class("GameListBg", function(type, height, x, y)
	local filename  = nil
	local capInsets = nil

	local size = cc.size(0, height)

	local winScale = lt.CacheManager:getWinScale()

	if type == 1 then
		filename = "image/ui/common/common_listbg_1.png"
		capInsets = cc.rect(5, 5, 215, 20)
		size.width = 230*winScale
	elseif type == 2 then
		filename = "image/ui/common/common_listbg_2.png"
		capInsets = cc.rect(5, 5, 203, 20)
		size.width = 213*winScale
	elseif type == 3 then
		filename = "image/ui/common/common_listbg_3.png"
		capInsets = cc.rect(5, 5, 269, 20)
		size.width = 279*winScale
	elseif type == 4 then
		filename = "image/ui/common/common_listbg_4.png"
		capInsets = cc.rect(5, 5, 174, 20)
		size.width = 184*winScale
	end

	x = x or 0
	y = y or 0

	return display.newScale9Sprite(filename, x, y, size, capInsets)
end)

GameListBg.TYPE = {
	GAME_LIST_BG_TYPE_1 = 1,
	GAME_LIST_BG_TYPE_2 = 2,
	GAME_LIST_BG_TYPE_3 = 3,
	GAME_LIST_BG_TYPE_4 = 4,
}

return GameListBg
