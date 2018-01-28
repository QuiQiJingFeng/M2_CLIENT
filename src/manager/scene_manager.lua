local manager = class("scene_manager")

function manager:ctor()

end

function manager:runScene(name,transition, time, more,...)

	local scene_dir = string.format("scene.%s",name)
	local scene_path = scene_dir..".main"

	local scene = require(scene_path):create(...)
	--将场景的名称和路径记录下来
	scene.scene_name = name
	scene.scene_dir = scene_dir
	
	display.runScene(scene,transition, time, more)
end

return manager