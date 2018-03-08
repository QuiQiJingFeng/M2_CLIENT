
local GemIcon = class("GemIcon", lt.GameIcon)


function GemIcon:ctor()
	self.super.ctor(self)

	self:setNodeEventEnabled(true)
    self:setTouchSwallowEnabled(true)

	self._infoNode = display.newNode()
	self:addChild(self._infoNode)
end

function GemIcon:setNewFlagVisible(bool)
	if bool then
		self:getNoticeFlagIcon()
	else
		self:clearNoticeFlagIcon()
	end
end

function GemIcon:getNoticeFlagIcon()
	if not self._noticeFlag then
		self._noticeFlag = ccs.Armature:create("uieffect_new_icon")
		self._noticeFlag:setPosition(70, 70)
		self._noticeFlag:getAnimation():playWithIndex(0)
		self:addChild(self._noticeFlag,999)
	end

	self._noticeFlag:setVisible(true)
end

function GemIcon:clearNoticeFlagIcon()
	if self._noticeFlag then
		self._noticeFlag:removeFromParent()
		self._noticeFlag = nil
	end
end

return GemIcon