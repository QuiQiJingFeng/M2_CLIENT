local ShopLayer = class("ShopLayer", function()
    return cc.CSLoader:createNode("hallcomm/common/ShowReChargeLayer.csb")
end)

function ShopLayer:ctor()
	local mainLayer = self:getChildByName("Ie_Bg")
	--返回按钮
	local backBtn = mainLayer:getChildByName("Button_CloseRechargeLayer")

	local ScrollViews = mainLayer:getChildByName("ScrollView_Recharge")

	for i=1,10 do
		local item = ScrollViews:getChildByName("Image_SmallRechargeBg_"..i)
		local button = item:getChildByName("Button_1")
		local moneynum = button:getChildByName("Text_13")
		local function menuZhuCeCallback(sender,eventType)
	        if eventType == ccui.TouchEventType.began then
	        	print("花费金钱 : "..moneynum:getString())--金钱数量
	        	local num = moneynum:getString()
	        	local PaytypeLayer = lt.PaytypeLayer.new(num)
    			lt.UILayerManager:addLayer(PaytypeLayer, true)
	        end
		end 
		button:addTouchEventListener(menuZhuCeCallback)
	end
	

	lt.CommonUtil:addNodeClickEvent(backBtn, handler(self, self.onBack))
end

function ShopLayer:onBack(event)
	lt.UILayerManager:removeLayer(self)
end

return ShopLayer