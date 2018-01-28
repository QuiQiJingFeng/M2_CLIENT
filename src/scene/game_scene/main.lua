local scene = class("game_scene", require("scene.prototype"))

function scene:onCreate(...)
 print("FYD  onCreate")
	
end

function scene:onEnter()
	--UI初始化
	 print("FYD  onEnter")
	local sp = cc.Sprite:create("card_heap.png")
	self:addChild(sp)
end

function scene:onUpdate(dt)

end

return scene