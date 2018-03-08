
local MissionButton = class("MissionButton", lt.ScaleButton)

MissionButton.missionId = 0

function MissionButton:ctor(imageName, missionId)
    MissionButton.super.ctor(self, imageName)

    self.missionId = missionId
end

return MissionButton