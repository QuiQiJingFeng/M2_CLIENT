
local ScrollNumber = class("ScrollNumber", function()
	return lt.GameBMLabel.new("", "#fonts/ui_num_11.fnt")
end)

-- 0.05 变化一次 总时长1.5s 变化30次

ScrollNumber._preNum = nil
ScrollNumber._curNum = nil
ScrollNumber._num = nil

ScrollNumber._deltaNum = 0

ScrollNumber._duration	= 0.8
ScrollNumber._interval	= 0.05

ScrollNumber._updateHandler = nil

function ScrollNumber:ctor(preNum, curNum)
	self:setNodeEventEnabled(true)

	self._preNum = preNum
	self._curNum = curNum
	self._num = self._preNum

	self._deltaNum = (self._curNum - self._preNum) / self._duration

	self:setString(string.format("%.0f", self._num))
end

function ScrollNumber:onEnter()
	self._updateHandler = lt.scheduler.scheduleGlobal(handler(self, self.updateNum), self._interval)
end

function ScrollNumber:onExit()
	if self._updateHandler then
		lt.scheduler.unscheduleGlobal(self._updateHandler)
		self._updateHandler = nil
	end
end

function ScrollNumber:updateNum(delta)
	self._num = self._num + self._deltaNum * delta

	if self._deltaNum > 0 then
		if self._num > self._curNum then
			-- 变化完毕
			self._num = self._curNum

			lt.scheduler.unscheduleGlobal(self._updateHandler)
			self._updateHandler = nil
		end
	else
		if self._num < self._curNum then
			-- 变化完毕
			self._num = self._curNum

			lt.scheduler.unscheduleGlobal(self._updateHandler)
			self._updateHandler = nil
		end
	end

	-- UI表现
	self:setString(string.format("%.0f", self._num))
end

return ScrollNumber
