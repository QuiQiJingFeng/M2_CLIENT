
-- 切换型按钮
local SwitchButton = class("SwitchButton", lt.PushButton)

SwitchButton._imageName1 = nil
SwitchButton._imageName2 = nil

function SwitchButton:ctor(imageName1, imageName2, options)
	options = options or {}

	local iconPic = options.icon
	if iconPic then
		-- 正中心 Icon
		local icon = display.newSprite(iconPic)
		self:addChild(icon)
	end

	local labelPic = options.labelPic
	if labelPic then
		local labelX = options.labelX or 0
		local labelY = options.labelY or 0

		local label = display.newSprite(labelPic)
		label:setPosition(labelX, labelY)
		self:addChild(label)
	end

    self._imageName1 = imageName1
    self._imageName2 = imageName2

    SwitchButton.super.ctor(self, {normal = self._imageName1, pressed = self._imageName2}, options)
end

function SwitchButton:select()
	self:setButtonImage(lt.PushButton.NORMAL, self._imageName2, true)
end

function SwitchButton:unselect()
	self:setButtonImage(lt.PushButton.NORMAL, self._imageName1, true)
end

return SwitchButton
