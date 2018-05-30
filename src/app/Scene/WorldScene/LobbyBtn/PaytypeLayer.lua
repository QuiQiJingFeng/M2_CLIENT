local PaytypeLayer = class("PaytypeLayer", function()
    return cc.CSLoader:createNode("hallcomm/lobby/RechargeWayLayer.csb")
end)

function PaytypeLayer:ctor(moneynum)
	local mainLayer = self:getChildByName("Ie_Bg")
	--返回按钮
	local backBtn = mainLayer:getChildByName("Bn_Close")

	local Ie_PayBg = mainLayer:getChildByName("Ie_PayBg")

	local Bn_Alipay = Ie_PayBg:getChildByName("Bn_Alipay")
	local Bn_WeChat = Ie_PayBg:getChildByName("Bn_WeChat")

	
	lt.CommonUtil:addNodeClickEvent(Bn_Alipay, handler(self, self.onAlipay))
	lt.CommonUtil:addNodeClickEvent(Bn_WeChat, handler(self, self.onWeChat))
	lt.CommonUtil:addNodeClickEvent(backBtn, handler(self, self.onBack))
end

function PaytypeLayer:onBack(event)
	lt.UILayerManager:removeLayer(self)
end

function PaytypeLayer:onAlipay(event)
	--支付宝接口
end

function PaytypeLayer:onWeChat(event)
	--微信接口
end

return PaytypeLayer