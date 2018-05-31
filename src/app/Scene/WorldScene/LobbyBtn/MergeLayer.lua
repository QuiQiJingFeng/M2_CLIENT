local MergeLayer = class("MergeLayer", function()
    return cc.CSLoader:createNode("hallcomm/lobby/LobbyWXClip.csb")
end)

function MergeLayer:ctor()
	local mainLayer = self:getChildByName("Ie_BG")
	--返回按钮
	self._bn_Close = mainLayer:getChildByName("Button_Close")
	
	self._image = mainLayer:getChildByName("Image_16")
	self._textLabel = mainLayer:getChildByName("Text_5")
	self._text_WX = mainLayer:getChildByName("Text_WX")
	self._copyBtn = mainLayer:getChildByName("Image_17")

	self._twolayer = self:getChildByName("Ie_BG1")
	self._twolayer:setVisible(false)
	self._trueBtn = self._twolayer:getChildByName("Image_17")

	lt.CommonUtil:addNodeClickEvent(self._bn_Close, handler(self, self.onClose))
	lt.CommonUtil:addNodeClickEvent(self._trueBtn, handler(self, self.onTrue))
	lt.CommonUtil:addNodeClickEvent(self._copyBtn, handler(self, self.onCopy))
end

function MergeLayer:onClose(event)
	lt.UILayerManager:removeLayer(self)
end

function MergeLayer:onTrue(event)
	self._twolayer:setVisible(false)
end

function MergeLayer:onCopy(event)
	--调用剪切板接口
	self._twolayer:setVisible(true)

end

return MergeLayer