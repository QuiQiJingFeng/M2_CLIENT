--用于弹出层的zorder管理
local SceneManager = {}

SceneManager.ZORDER = 1
SceneManager._mainLayers = {} --一级界面

function SceneManager:addLayer(layer,isMainLayer)
	display.getRunningScene():addChild(layer,self.ZORDER,self.ZORDER)
	self.ZORDER = self.ZORDER + 1
	if isMainLayer then
		self._mainLayers[#self._mainLayers+1] = layer
		for _,mainLayer in pairs(self._mainLayers) do
			mainLayer:setVisible(false)
		end
	end
end

function SceneManager:removeLayer(layer)
	local currLayer = display.getRunningScene():getChildByTag(self.ZORDER)
	if currLayer then
		local order = currLayer:getLocalZOrder()
		currLayer:setLocalZOrder(order-1)
		currLayer:setTag(order-1)
	end
	layer:removeFromParent()
	if #self._mainLayers > 0 then
		table.remove(self._mainLayers,#self._mainLayers+1)
		local mainLayer = self._mainLayers[#self._mainLayers+1]
		if mainLayer then
			mainLayer:setVisible(true)
		end
	end
	self.ZORDER = self.ZORDER - 1
end

function SceneManager:resetOrder()
	self.ZORDER = 1
	self._mainLayers = {}
end

function SceneManager:replaceScene(scene)
	self:resetOrder()
	cc.Director:getInstance():replaceScene(scene)
end

function SceneManager:getCurrentZorder()
	return self.ZORDER
end

return SceneManager
