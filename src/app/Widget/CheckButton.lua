
-- 勾选按钮
local CheckButton = class("CheckButton", lt.PushButton)

CheckButton._check = false
CheckButton._checkFlag = nil

function CheckButton:ctor(params)
	CheckButton.super.ctor(self, "#common_check_bg.png", params)

	params = params or {}

	self._iconCheckOn = "#common_icon_selected.png"

	if params.iconCheckOn then
		self._iconCheckOn = params.iconCheckOn
	end

	if params.checkHandler then
		self:onButtonClicked(params.checkHandler)
	else
		self:onButtonClicked(handler(self, self.onCheck))
	end
end

function CheckButton:setCheck(check)
	self._check = check

	self:updateCheck()
end

function CheckButton:getCheck()
	return self._check
end

function CheckButton:onCheck()
	self._check = not self._check

	self:updateCheck()
end

function CheckButton:updateCheck()
	if self._check then
		if not self._checkFlag then
			self._checkFlag = display.newSprite(self._iconCheckOn)
			self:addChild(self._checkFlag)
		else
			self._checkFlag:setVisible(true)
		end
	else
		if self._checkFlag then
			self._checkFlag:setVisible(false)
		end
	end
end

return CheckButton
