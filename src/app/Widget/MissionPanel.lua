
local MissionPanel = class("MissionPanel", lt.ScrollViewCell)

MissionPanel._calllback = nil

function MissionPanel:ctor(size, callback)
    self._calllback = callback

    local backgroundSprite = display.newSprite("image/button.png")
    backgroundSprite:pos(display.cx, display.cy)
    self:addChild(backgroundSprite)

    local helpButton = lt.MissionButton.new("image/btn_help.png", 17)
    helpButton:pos(display.cx, display.cy)
    helpButton:onButtonClicked(handler(self, self.onClick))
    self:addChild(helpButton)
end

function MissionPanel:onClick(event)
    local missionButton = event.target
    lt.CommonUtil.print("MissionPanel:onClick:" .. missionButton.missionId)

    self._calllback(missionButton.missionId)
end

return MissionPanel
