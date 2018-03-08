--用于管理弹出组件的zorder管理和唯一显示
local UIManager = {}

UIManager._uiArray = {}
UIManager.ZORDER = 999

function UIManager:addNode(node)
	local index = #self._uiArray+1
	self._uiArray[index] = node
	return index
end

function UIManager:removeNode(node)
	local index = node:getNodeIndex()
	self._uiArray[index] = nil
end

function UIManager:reorder(node)
	for k,v in pairs(self._uiArray) do
		v:setLocalZOrder(self.ZORDER)
		v:getParent():setLocalZOrder(self.ZORDER)
		v:closePanel()
	end

	node:openPanel()
	node:setLocalZOrder(self.ZORDER+1)
	node:getParent():setLocalZOrder(self.ZORDER+1)
end

return UIManager
