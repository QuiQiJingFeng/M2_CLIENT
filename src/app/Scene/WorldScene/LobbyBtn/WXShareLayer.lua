local WXShareLayer = class("WXShareLayer", function()
    return cc.CSLoader:createNode("hallcomm/lobby/WechatShareLayer.csb")
end)

function WXShareLayer:ctor()
	local mainLayer = self:getChildByName("Ie_Bg")
	--返回按钮
	self._bn_Close = mainLayer:getChildByName("Bn_Close")
	
	self._wxQun = mainLayer:getChildByName("Image_489")--好友群
	self._wxMoments = mainLayer:getChildByName("Image_489_0")--朋友圈

	self._image_584 = self._wxMoments:getChildByName("Image_584")--每天首次分享朋友圈的奖励
	self._image_584:setVisible(false)
	


	lt.CommonUtil:addNodeClickEvent(self._bn_Close, handler(self, self.onClose))
	lt.CommonUtil:addNodeClickEvent(self._wxQun, handler(self, self.onQun))
	lt.CommonUtil:addNodeClickEvent(self._wxMoments, handler(self, self.onMoments))
end

function WXShareLayer:onClose(event)
	lt.UILayerManager:removeLayer(self)
end

function WXShareLayer:onQun(event)--好友群接口

end

function WXShareLayer:onMoments(event)--朋友圈接口

end

return WXShareLayer