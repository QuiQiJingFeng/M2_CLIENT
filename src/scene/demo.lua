local scene = class("demo_scene", require("scene.prototype"))

function scene:onCreate()

end

function scene:onEnter()
    self:showLayer("demo")
end

return scene