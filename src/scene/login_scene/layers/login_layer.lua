local layer = class("login_layer",cc.Layer)

function layer:ctor()
	local temp = cc.Sprite:create("card_heap.png")
	self:addChild(temp)
end

return layer