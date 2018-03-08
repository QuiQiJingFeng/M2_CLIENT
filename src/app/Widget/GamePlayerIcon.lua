
local GamePlayerIcon = class("GamePlayerIcon", function()
	return display.newSprite("#common_icon_bg_big.png")
end)

GamePlayerIcon.TYPE = {
	SIMPLE = 0,
	LEVEL_NAME = 1
}

GamePlayerIcon._figure = nil
GamePlayerIcon._level = nil
GamePlayerIcon._name = nil

function GamePlayerIcon:ctor()
	-- 边框
	local border = display.newSprite("#common_icon_border.png")
	border:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
	self:addChild(border, 10)

	-- 头像
	self._figure = display.newSprite()
	self._figure:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
	self:addChild(self._figure)
end

function GamePlayerIcon:updateInfo(type, params)
	if type == 0 then
		self:updateFigure(params)
	elseif type == 1 then
		self:updateInfoType1(params)
	end
end

function GamePlayerIcon:updateFigure(figureId)
	lt.CommonUtil.print("GamePlayerIcon:updateFigure")
end

function GamePlayerIcon:updateInfoType1(simplePlayerInfo)
	if not simplePlayerInfo then
		return
	end

	-- 头像
	self:updateFigure()

	self._level = lt.GameCount.new(1, simplePlayerInfo:getLevel())
	self._level:setPosition(self:getContentSize().width - 6, 8)
	self:addChild(self._level, 10)

	self._name = lt.GameLabel.new(simplePlayerInfo:getName(), 18, lt.Constants.COLOR.BROWN)
	self._name:setPosition(self:getContentSize().width / 2, -16)
	self:addChild(self._name, 20)
end

return GamePlayerIcon
