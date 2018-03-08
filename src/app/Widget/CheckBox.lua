
-- 选择控件 多个只能选中一个
local CheckBox = class("CheckBox")

CheckBox._checkButtonArray = nil

CheckBox._checkIdx = 0

CheckBox._checkUpdateHandler = nil

function CheckBox:ctor()
	self._checkButtonArray = {}
end

function CheckBox:setCheckIdx(checkIdx)
	self._checkIdx = checkIdx

	self:updateCheck()
end

function CheckBox:getCheckIdx()
	return self._checkIdx
end

function CheckBox:addCheckButton()
	local checkButton = lt.CheckButton.new({checkHandler = handler(self, self.onCheck)})
	local checkIdx = #self._checkButtonArray + 1

	self._checkButtonArray[checkIdx] = checkButton

	checkButton:setTag(checkIdx)

	return checkButton
end

function CheckBox:onCheck(event)
	local checkButton = event.target

	local checkIdx = checkButton:getTag()

	self._checkIdx = checkIdx

	self:updateCheck()

	if self._checkUpdateHandler then
		self._checkUpdateHandler(self._checkIdx)
	end
end

function CheckBox:updateCheck()
	for checkIdx,checkButton in ipairs(self._checkButtonArray) do
		if checkIdx == self._checkIdx then
			checkButton:setCheck(true)
		else
			checkButton:setCheck(false)
		end
	end
end

function CheckBox:onCheckUpdate(handler)
	self._checkUpdateHandler = handler
end

return CheckBox

