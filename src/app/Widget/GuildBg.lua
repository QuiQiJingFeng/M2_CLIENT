
local GuildBg = class("GuildBg", function()
	return display.newNode()
end)

function GuildBg:addTo(node,height,width)
	local guildBg = lt.GuildBg.new(height,width)
	guildBg:setPosition(node:getContentSize().width-2,node:getContentSize().height/2)
	node:addChild(guildBg)
end

function GuildBg:ctor(height,width)
	self:setNodeEventEnabled(true)

	local bg = display.newSprite("image/ui/server_bg.jpg")
	local winScale = lt.CacheManager:getWinScale()
	local scaleY = height/bg:getContentSize().height*winScale
	local scaleX = winScale
	if width then
		scaleX = width/bg:getContentSize().width*winScale
	end
	bg:setScaleX(scaleX)
	bg:setScaleY(scaleY)
	bg:setAnchorPoint(1,0.5)
	self:addChild(bg)
end

function GuildBg:onExit()
	display.removeSpriteFrameByImageName("image/ui/server_bg.jpg")
end

return GuildBg
