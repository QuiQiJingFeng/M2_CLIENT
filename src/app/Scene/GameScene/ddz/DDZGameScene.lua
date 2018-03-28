local DDZGameScene = class("DDZGameScene", function( )
	return display.newScene()
end)

function DDZGameScene:ctor( ... )
	local gameLayer = lt.DDZGameLayer.new()

	self:addChild(gameLayer)
end

function DDZGameScene:onEnter( ... )
	print("DDZGameScene:onEnter")
end


function DDZGameScene:onExit( ... )
	print("DDZGameScene:onExit")
end



return DDZGameScene