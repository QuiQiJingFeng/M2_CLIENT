local scene = class("test_scene", require("scene.prototype"))

function scene:onCreate()

end

function scene:onEnter()
    self:showLayer("test")
end

return scene