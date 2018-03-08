
local GameInfoBg = class("GameInfoBg", function(type, size, x, y)
	local filename  = nil
	local capInsets = nil

	if type == 1 then
		filename = "image/ui/common/common_info_1.png"
		capInsets = cc.rect(20, 20, 1, 1)
	elseif type == 2 then
		filename = "image/ui/common/common_info_2.png"
		capInsets = cc.rect(10, 10, 54, 10)
	elseif type == 3 then
		filename = "image/ui/common/common_info_3.png"
		capInsets = cc.rect(20, 20, 1, 1)
	elseif type == 4 then
		filename = "image/ui/common/common_info_4.png"
		capInsets = cc.rect(20, 20, 1, 1)
	elseif type == 5 then
		filename = "image/ui/common/common_info_5.png"
		capInsets = cc.rect(20, 20, 1, 1)
	elseif type == 6 then
		filename = "image/ui/common/common_info_6.png"
		capInsets = cc.rect(30, 12, 1, 1)
	elseif type == 7 then
		filename = "image/ui/common/common_info_7.png"
		capInsets = cc.rect(20, 20, 1, 1)
	elseif type == 8 then
		filename = "image/ui/common/common_info_8.png"
		capInsets = cc.rect(20, 20, 1, 1)
	elseif type == 9 then
		filename = "image/ui/common/common_info_9.png"
		capInsets = cc.rect(20, 20, 1, 1)
	elseif type == 10 then
		filename = "image/ui/common/common_info_10.png"
		capInsets = cc.rect(20, 20, 1, 1)
	elseif type == 11 then--有点透明的灰色
		filename = "image/ui/common/common_info_11.png"
		capInsets = cc.rect(20, 20, 15, 15)
	elseif type == 12 then--有点透明的灰黑
		filename = "image/ui/common/common_info_12.png"
		capInsets = cc.rect(20, 20, 1, 1)
	elseif type == 13 then--listview的背景黑色
		filename = "image/ui/common/common_info_13.png"
		capInsets = cc.rect(20, 20, 15, 15)
	elseif type == 14 then
		filename = "image/ui/common/common_info_14.png"
		capInsets = cc.rect(20, 10, 40, 11)
	elseif type == 15 then
		filename = "image/ui/common/common_info_15.png"
		capInsets = cc.rect(20, 10, 40, 11)
	elseif type == 16 then
		filename = "image/ui/common/common_info_16.png"
		capInsets = cc.rect(20, 20, 5, 5)
	elseif type == 17 then
		filename = "image/ui/common/common_info_17.png"
		capInsets = cc.rect(10, 10, 54, 10)
	elseif type == 19 then
		filename = "image/ui/common/common_info_19.png"
		capInsets = cc.rect(20, 20, 1, 1)
	elseif type == 20 then
		filename = "image/ui/common/common_info_20.png"
		capInsets = cc.rect(20, 20, 1, 1)
	elseif type == 21 then
		filename = "image/ui/common/common_info_21.png"
		capInsets = cc.rect(20, 20, 1, 1)
	elseif type == 22 then
		filename = "image/ui/common/common_info_22.png"
		capInsets = cc.rect(20, 10, 40, 11)
	elseif type == 23 then
		filename = "image/ui/common/common_info_23.png"
		capInsets = cc.rect(20, 20, 1, 1)
	elseif type == 24 then
		filename = "image/ui/common/common_info_24.png"
		capInsets = cc.rect(10, 10, 54, 10)
	elseif type == 102 then
		filename = "image/ui/common/common_label_bg_2.png"
		capInsets = cc.rect(20, 20, 10, 10)
	end

	x = x or 0
	y = y or 0

	return display.newScale9Sprite(filename, x, y, size, capInsets)
end)

GameInfoBg.TYPE = {
	GAME_INFO_BG_TYPE_1 = 1,
	GAME_INFO_BG_TYPE_2 = 2,
	GAME_INFO_BG_TYPE_3 = 3,
	GAME_INFO_BG_TYPE_4 = 4,
	GAME_INFO_BG_TYPE_5 = 5,
	GAME_INFO_BG_TYPE_6 = 6,
	GAME_INFO_BG_TYPE_7 = 7,
	GAME_INFO_BG_TYPE_8 = 8,
	GAME_INFO_BG_TYPE_9 = 9,
	GAME_INFO_BG_TYPE_10 = 10,
	GAME_INFO_BG_TYPE_11 = 11,
	GAME_INFO_BG_TYPE_12 = 12,
	GAME_INFO_BG_TYPE_13 = 13,
	GAME_INFO_BG_TYPE_14 = 14,
	GAME_INFO_BG_TYPE_15 = 15,
	GAME_INFO_BG_TYPE_16 = 16,
	GAME_INFO_BG_TYPE_17 = 17,
	GAME_INFO_BG_TYPE_19 = 19,
	GAME_INFO_BG_TYPE_20 = 20,
	GAME_INFO_BG_TYPE_21 = 21,
	GAME_INFO_BG_TYPE_22 = 22,
	GAME_INFO_BG_TYPE_23 = 23,
	GAME_INFO_BG_TYPE_24 = 24,
	GAME_INFO_BG_TYPE_102 = 102,
}

return GameInfoBg
