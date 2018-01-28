local scene = class("login_scene", require("scene.prototype"))

function scene:onCreate(...)
	self.logic_login = require("scene.login_scene.logics.logic_login")
	--逻辑初始化
	self.logic_login:init()
	
end

function scene:onEnter()
	--UI初始化
	self:showLayer("login_layer")
	
end

function scene:onUpdate(dt)

end

return scene