
local GameNewPanelContrast = {
	[1]  =  "image/ui/common/common_bg_new_1.png",
	[2]  =  "image/ui/common/common_bg_new_2.png",
	[3]  =  "image/ui/common/common_bg_new_3.png",
	[4]  =  "image/ui/common/common_bg_new_4.png",
	[10] =  "image/ui/common/common_bg_new_10.png",
	[11] =  "image/ui/common/common_bg_new_11.png",
	[12] =  "image/ui/common/common_bg_new_12.png",
	[13] =  "image/ui/common/common_bg_new_13.png",
	[14] =  "image/ui/common/common_bg_new_14.png",
	[15] =  "image/ui/common/common_bg_new_15.png",
	[16] =  "image/ui/common/common_bg_new_16.png",
	[17] =  "image/ui/common/common_bg_new_17.png",
}
-- 游戏内通用版面2017/2/19
local GameNewPanel = class("GameNewPanel", function(type, x, y, size, params)
	local filename  = GameNewPanelContrast[type]
	local capInsets = nil

	return display.newScale9Sprite(filename, x, y, size, capInsets)
end)

GameNewPanel.TYPE = {
	--最新版ui
	TRANSPARENT          		= 1, --透明底框
	NEW_WHITE 					= 2, --白色底框
	NEW_GRAY 					= 3, --灰色底框
	BLACK  					    = 4, --公告里面的黑框

	NEW_WHITE_SHADOW			= 10, -- 白色弹框(阴影)
	NEW_BLACK					= 11, -- 黑色弹框
	NEW_DARK_GRAY				= 12, -- 深灰色弹框
	NEW_DARK_CHAT				= 13, -- 走马灯和当前聊天主角头顶的框
	NEW_CHAT				    = 14, -- 聊天界面背景框
	NEW_BLUE				    = 15, -- 蓝色框
	NEW_YELLOW				    = 16, -- 黄色框
	NEW_DARK_BLACK				= 17, -- 黄色框
}

GameNewPanel._winScale = lt.CacheManager:getWinScale()

function GameNewPanel:ctor(type, x, y, size, params)
end

function GameNewPanel:setPanelSize(size)
	self:setPreferredSize(cc.size(size.width, size.height))
end

return GameNewPanel
