
local SwitchButtonGroup = class("SwitchButtonGroup")

SwitchButtonGroup._buttonArray = nil

function SwitchButtonGroup:ctor()
	self._buttonArray = {}
end

function SwitchButtonGroup:addSwitchButton(switchButton)
	switchButton:onButtonClicked(handler(self, self.onSwitchClicked))

	table.insert(self._buttonArray, switchButton)
end

function SwitchButtonGroup:onSwitchClicked(event)
	local target = event.target

	for _,button in ipairs(self._buttonArray) do
		if button == target then
			button:select()
		else
			button:unselect()
		end
	end
end

function SwitchButtonGroup:resetGroup()
	self._buttonArray = {}
end

function SwitchButtonGroup:getButtonArray()
	return self._buttonArray
end

return SwitchButtonGroup
