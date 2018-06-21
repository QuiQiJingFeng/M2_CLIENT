require("config")
require("cocos.init")
local scene = class("downloadScene",function() 
		return cc.Scene:create()
	end)

function scene:ctor()
	local layer = require("app.Scene.DownloadScene.downloadLayer").new()
	self:addChild(layer)
end

return scene