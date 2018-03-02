local scene = class("game_scene", require("scene.prototype"))

function scene:onCreate(...)
 print("FYD  onCreate")
	
end

function scene:onEnter()
	--UI初始化
	self:showLayer("main_layer")
end

function scene:onUpdate(dt)

end

return scene