
-- 走马灯(拓展？等需要的时候再说吧)
local RollingLabel = class("RollingLabel", function()
    return cc.ClippingRegionNode:create()
end)

RollingLabel._rect = nil

RollingLabel._strIdx = 0
RollingLabel._strArray = nil

RollingLabel._handle = nil
RollingLabel._checkLabel = nil
RollingLabel._labelTable = nil

RollingLabel._size = 0
RollingLabel._color = nil
RollingLabel._speed = 0
RollingLabel._padding = 0

function RollingLabel:ctor(rect, params)
	self:setNodeEventEnabled(true)

	self._rect = rect
	self:setClippingRegion(rect)

    self._strArray = {}
    self._strNums = 0
    self._labelTable = {}

    if not params then
    	params = {}
    end

    self._size = params.size or 20
    self._color = params.color or lt.Constants.COLOR.WHITE
    self._speed = params.speed or 40
    self._padding = params.padding or 40
    if params.str then
    	self._strArray[#self._strArray + 1] = params.str
    end

    if #self._strArray > 0 then
    	self._handle = lt.scheduler.scheduleUpdateGlobal(handler(self, self.onUpdate))
    end
end

function RollingLabel:onExit()
	self:clear()
end

function RollingLabel:clear()
	if self._handle then
		lt.scheduler.unscheduleGlobal(self._handle)
	end
	for idx,label in pairs(self._labelTable) do
		label:removeSelf()
	end
	self._strArray = {}
	self._labelTable = {}
	self._checkLabel = nil
end

function RollingLabel:setString(str)
	self:clear()
	self._strArray[#self._strArray + 1] = str
	if #self._strArray > 0 then
    	self._handle = lt.scheduler.scheduleUpdateGlobal(handler(self, self.onUpdate))
    end
end

function RollingLabel:onUpdate(delta)
	if not self._checkLabel then
		self._strIdx = self._strIdx + 1
		if self._strIdx > #self._strArray then
			self._strIdx = 1
		end
		local str = self._strArray[self._strIdx]

		-- 还没有文字
		local label = lt.GameLabel.new(str, self._size, self._color)
		label:setAnchorPoint(0, 0.5)
		label:setPosition(self._rect.x + self._rect.width, 0)
		self:addChild(label)

		self._checkLabel = label
		self._labelTable[#self._labelTable + 1] = label
	end

	-- 所有字左移动
	for idx,label in pairs(self._labelTable) do
		local x = label:getPositionX()
		local width = label:getContentSize().width

		local newX = x - self._speed * delta
		local newRight = newX + width

		if label == self._checkLabel then
			-- 判断右侧过线
			if newRight < self._rect.x + self._rect.width - self._padding then
				self._checkLabel = nil
			end
		end

		if newRight < self._rect.x then
			-- 出界了
			label:removeSelf()
			self._labelTable[idx] = nil
		else
			label:setPositionX(newX)
		end
	end
end

return RollingLabel