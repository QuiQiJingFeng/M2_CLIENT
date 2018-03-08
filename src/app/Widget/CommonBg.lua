


local CommonBg = class("CommonBg", function()
	return display.newNode()
end)

local CommonBgContrast = {
	[1]  =  "image/ui/alchemy_bg_1.jpg",
}

CommonBg.TYPE = {
	       ALCHEMY_BG_1  		= 1,
}

function CommonBg:addTo(node, size, offset, type, opacity)
	local commonBg = lt.CommonBg.new(size, type, opacity)
	local x, y = node:getContentSize().width/2,node:getContentSize().height/2
	if offset then
		x = x + offset.x
		y = y + offset.y
	end
	commonBg:setPosition(x, y)
	node:addChild(commonBg)
end

function CommonBg:ctor(size, type, opacity)
	self:setNodeEventEnabled(true)
	self._filename = "image/ui/common_bg.jpg"
	opacity = opacity or 0.4
	if type then
		self._filename = CommonBgContrast[type]
	end
	local bg = display.newSprite(self._filename)
	local winScale = lt.CacheManager:getWinScale()
	local scaleX = size.width/bg:getContentSize().width*winScale
	local scaleY = size.height/bg:getContentSize().height*winScale
	bg:setScaleX(scaleX)
	bg:setScaleY(scaleY)
	bg:setOpacity(255*opacity)
	self:addChild(bg)
end

function CommonBg:onExit()
	display.removeSpriteFrameByImageName(self._filename)
end

return CommonBg
