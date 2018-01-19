local scene = class("login_scene", require("scene.prototype"))

function scene:onCreate(...)
	--逻辑初始化
end

function scene:onEnter()
	--UI初始化
	self:showLayer("login_layer")
end

function scene:onUpdate(dt)

end

return scene