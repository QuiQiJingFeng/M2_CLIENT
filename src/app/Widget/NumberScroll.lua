
local NumberCell = class("NumberCell", function()
	local node = display.newNode()
	node:setContentSize(92, 40)
	return node
end)

NumberCell._number = nil

function NumberCell:ctor(number)
	self._number = number

	if not self._number then
		return
	end

	local numberLabel = lt.GameLabel.new(self._number, 18, lt.Constants.DEFAULT_LABEL_COLOR_2, {outline = true})
	numberLabel:setPosition(46, 20)
	self:addChild(numberLabel)
end

local NumberScrollCell = class("NumberScrollCell", lt.ScrollView)

NumberScrollCell._min = nil
NumberScrollCell._max = nil
NumberScrollCell._cur = nil

function NumberScrollCell:ctor(params)
	NumberScrollCell.super.ctor(self, params)

	self._scrollNode = display.newNode()
    self._scrollNode:setPosition(self:getViewRect().x, self:getViewRect().y)
    self:addScrollNode(self._scrollNode)
end

function NumberScrollCell:getCur()
	return self._cur
end

function NumberScrollCell:updateInfo(min, max, cur)
	self._min = min or 1
	self._max = max or 100
	self._cur = min

	-- 创建数字
	local idx = 0
	-- 3个空
	for i=1,3 do
		local numberCell = NumberCell.new()
		numberCell:setPosition(0, 40 * idx)
		self._scrollNode:addChild(numberCell)

		idx = idx + 1
	end

	-- 数字
	for i=self._max,self._min,-1 do
		local numberCell = NumberCell.new(i)
		numberCell:setPosition(0, 40 * idx)
		self._scrollNode:addChild(numberCell)

		idx = idx + 1
	end

	-- 3个空
	for i=1,3 do
		local numberCell = NumberCell.new()
		numberCell:setPosition(0, 40 * idx)
		self._scrollNode:addChild(numberCell)

		idx = idx + 1
	end

	self._cur = cur
	local ratio = self._cur - self._max
	local newY = (ratio * 40) + self.viewRect_.y
	self:scrollTo(self.viewRect_.x, newY)
end

function NumberScrollCell:scrollAuto()
	local offsetX, offsetY = self:getOffset()

	local ratio = lt.CommonUtil:fixValue(math.round((offsetY - self.viewRect_.y) / 40), self._min - self._max, 0)

	self._cur = ratio + self._max

	-- self:scrollTo(offsetX, )
	local newY = (ratio * 40) + self.viewRect_.y

	transition.moveBy(self.scrollNode,
		{x = 0, y = (newY - offsetY), time = 0.3,
		easing = "backout"})
end

local NumberScroll = class("NumberScroll", function()
	return display.newLayer()
end)

NumberScroll._delegate = nil

NumberScroll._numberScrollCell1 = nil
NumberScroll._numberScrollCell2 = nil

NumberScroll._touchPos = nil

function NumberScroll:ctor(delegate, params)
	self:setNodeEventEnabled(true)

	self._delegate = delegate
	params = params or {}

	local size = cc.size(212, 300)

	self._bg = lt.GameNewPanel.new(lt.GameNewPanel.TYPE.NEW_DARK_GRAY, 0, 0, size)
	self:addChild(self._bg)

	-- 重写设定位置
	self.setPosition = function(self, x, y)
        self._bg:setPosition(x, y)
    end

	local size2 = cc.size(96, 284)
	local size3 = cc.size(92, 280)
	local posX1 = size.width * 0.5 - 52
	local posX2 = size.width * 0.5 + 52
	local posY  = size.height * 0.5
	local listBg1 = lt.GameNewPanel.new(lt.GameNewPanel.TYPE.NEW_GRAY, posX1, posY, size2)
	self._bg:addChild(listBg1)

	local listBg2 = lt.GameNewPanel.new(lt.GameNewPanel.TYPE.NEW_GRAY, posX2, posY, size2)
	self._bg:addChild(listBg2)

	local selectBorder = display.newSprite("#common_number_scroll_select.png")
	selectBorder:setPosition(self._bg:getContentSize().width / 2, self._bg:getContentSize().height / 2)
	self._bg:addChild(selectBorder)

	local min = params.min or 1
	local max = params.max or 100
	local lv1 = params.lv1 or min
	local lv2 = params.lv2 or max

	self._numberScrollCell1 = NumberScrollCell.new({viewRect = cc.rect(posX1 - size3.width / 2, posY - size3.height / 2, size3.width, size3.height), direction = cc.ui.UIScrollView.DIRECTION_VERTICAL})
	self._bg:addChild(self._numberScrollCell1)
	self._numberScrollCell1:updateInfo(min, max, lv1)

	self._numberScrollCell2 = NumberScrollCell.new({viewRect = cc.rect(posX2 - size3.width / 2, posY - size3.height / 2, size3.width, size3.height), direction = cc.ui.UIScrollView.DIRECTION_VERTICAL})
	self._bg:addChild(self._numberScrollCell2)
	self._numberScrollCell2:updateInfo(min, max, lv2)
end

function NumberScroll:onEnter()
	self:setNodeEventEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		if event.name == "began" then
			self._touchPos = cc.p(event.x, event.y)
			return true
		elseif event.name == "ended" then
			-- 没点击在自身区域 则隐藏
			local rect = self._bg:getBoundingBox()

			if not cc.rectContainsPoint(rect, cc.p(self._touchPos)) then
				self:close()
			end
		end
	end)
end

function NumberScroll:close()
	local v1 = self._numberScrollCell1:getCur()
	local v2 = self._numberScrollCell2:getCur()

	if v1 > v2 then
		v1, v2 = v2, v1
	end

	self._delegate:onNumberScrollComplete(v1, v2)

	self:removeFromParent()
end

return NumberScroll
