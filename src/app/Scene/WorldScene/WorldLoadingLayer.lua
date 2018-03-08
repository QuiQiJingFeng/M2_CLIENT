
-- ################################################## 世界切换时所用的遮罩 ##################################################
local WorldLoadingLayer = class("WorldLoadingLayer", function()
	return display.newColorLayer(cc.c4b(0, 0, 0, 255))
end)

function WorldLoadingLayer:ctor()
	self:setNodeEventEnabled(true)

	local randomIdx = math.random(1, 7)
	self._pic = "image/loading/game_loading_"..randomIdx..".jpg"

	local sprite = display.newSprite(self._pic)
	sprite:setPosition(display.cx, display.cy)
	self:addChild(sprite)


	local tips = lt.CacheManager:getTips(lt.DataManager:getPlayerLevel())
	if tips ~= "" then
		local tipsBg = display.newScale9Sprite("image/loading/game_loading_mask.png", 0, 0, cc.size(display.width, 64))
		tipsBg:setAnchorPoint(0.5, 0)
		tipsBg:setPosition(display.cx, 0)
		self:addChild(tipsBg)

		local tipsLabel = lt.GameLabel.new(tips, 20, lt.Constants.COLOR.YELLOW, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
		tipsLabel:setPosition(display.cx, 32)
		tipsBg:addChild(tipsLabel)
	end
end

function WorldLoadingLayer:onExit()
	display.removeSpriteFrameByImageName(self._pic)
end

return WorldLoadingLayer
