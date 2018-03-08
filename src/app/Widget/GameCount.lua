
local GameCount = class("GameCount", function(type)
	if not type then
		type = 1
	end
	local pic = "#common_count_bg_1.png"
	if type == 2 then
		pic = "#common_count_bg_2.png"
	end

	return display.newSprite(pic)
end)

GameCount._num = nil

function GameCount:ctor(type, num)
	local font = "#fonts/ui_num_1.fnt"

	if type == 2 then
		font = "#fonts/ui_num_4.fnt"
	end

	if not num then
		num = 0
	end

	self._num = lt.GameBMLabel.new(num, font)
	self._num:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
	self:addChild(self._num)
end

function GameCount:setNum(num)
	if not num then
		num = 0
	end

	self._num:setString(num)
end

return GameCount
