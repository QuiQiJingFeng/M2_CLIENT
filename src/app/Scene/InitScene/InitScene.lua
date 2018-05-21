
local InitScene = class("InitScene", function()
    return display.newScene("InitScene")
end)

function InitScene:ctor()
    local initLayer = lt.InitLayer.new()
    self:addChild(initLayer)
end

return InitScene
