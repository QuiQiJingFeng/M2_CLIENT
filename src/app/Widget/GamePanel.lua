
-- 游戏内通用版面
local GamePanel = class("GamePanel", function(type, x, y, size, params)
	local filename  = nil
	local capInsets = nil
	local padding = 7

	if type == 100 then
		filename = "image/ui/common/common_bg_f_3.png"
		capInsets = cc.rect(35, 35, 1, 1)
	elseif type == 101 then
		filename = "image/ui/common/common_bg_f_1.png"
		capInsets = cc.rect(35, 35, 1, 1)
	elseif type == 102 then
		filename = "image/ui/common/common_bg_f_2.png"
		capInsets = cc.rect(35, 35, 1, 1)
	elseif type == 200 then
		filename = "image/ui/common/common_bg_n_1.png"
		capInsets = cc.rect(35, 35, 1, 1)
	elseif type == 201 then
		filename = "image/ui/common/common_bg_n_2.png"
		capInsets = cc.rect(35, 35, 1, 1)
	elseif type == 202 then
		filename = "image/ui/common/common_bg_n_3.png"
	elseif type == 203 then
		filename = "image/ui/common/common_bg_n_4.png"
	elseif type == 204 then
		filename = "image/ui/common/common_bg_n_5.png"
	elseif type == 205 then
		filename = "image/ui/common/common_bg_n_6.png"
	elseif type == 206 then
		filename = "image/ui/common/common_bg_n_7.png"
	elseif type == 207 then
		filename = "image/ui/common/common_bg_n_8.png"
	end

	size = cc.size(size.width + padding * 2, size.height + padding * 2)

	return display.newScale9Sprite(filename, x, y, size, capInsets)
end)

GamePanel.TYPE = {
	--以下为正式ui
	FORMAL_BLACK                = 100, -- 黑底白框
	FORMAL_WHITE                = 101, -- 白底灰框
	FORMAL_TRANSPARENT          = 102, -- 透明底灰框

	--以下为新版修改ui
	NEW_BGWHITE					= 200, --通用外框透明底标题高光
	NEW_BLACK					= 201, --通用外框灰色
	NEW_WHITE					= 202, --通用外框白色
	NEW_TIPSBGWHITE				= 203, --tip外框白色
	NEW_TIPSBLACK				= 204, --tip透明灰色框
	NEW_WHITESHADOW				= 205, --通用白色带阴影
	NEW_DARK_GRAY			    = 206, --深灰
	NEW_TIPS_BLUE				= 207, -- tips外框蓝色
}

GamePanel._winScale = lt.CacheManager:getWinScale()

GamePanel._padding = 7

-- self:getContentSize().width
function GamePanel:ctor(type, x, y, size, params)
end

function GamePanel:setPanelSize(size)
	self:setPreferredSize(cc.size(size.width + self._padding * 2, size.height + self._padding * 2))
end

return GamePanel
