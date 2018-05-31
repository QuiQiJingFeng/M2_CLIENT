local ReplayWatchitem = class("ReplayWatchitem", function()
    return cc.CSLoader:createNode("game/common/Node_RecordDetaileItem.csb")
end)

function ReplayWatchitem:ctor()
	local mainLayer = self:getChildByName("Ie_Record")

	local Tt_No  = mainLayer:getChildByName("Tt_No")--序号
	local Tt_RoundID  = mainLayer:getChildByName("Tt_RoundID")--回放码
	local Tt_Time  = mainLayer:getChildByName("Tt_Time")--对战时间

	--local Tt_Name  = mainLayer:getChildByName("Tt_Name"1-6)--玩家名字
	--local Tt_Score  = mainLayer:getChildByName("Tt_Score"1-6)--玩家分数


	local Bn_Share  = mainLayer:getChildByName("Bn_Share")--分享按钮
	local Bn_Detail  = mainLayer:getChildByName("Bn_Detail")--回放按钮
	Bn_Share:setVisible(true)
	Bn_Detail:setVisible(true)



	



	lt.CommonUtil:addNodeClickEvent(Bn_Share, handler(self, self.onShare))
	lt.CommonUtil:addNodeClickEvent(Bn_Detail, handler(self, self.onDetail))
	lt.CommonUtil:addNodeClickEvent(Bn_Close, handler(self, self.onClose))
	


end

function ReplayWatchitem:onClose(event)
	lt.UILayerManager:removeLayer(self)
end

function ReplayWatchitem:onShare(event)
	local WXShareLayer = lt.WXShareLayer.new()
    lt.UILayerManager:addLayer(WXShareLayer, true)
end

function ReplayWatchitem:onDetail(event)
end

return ReplayWatchitem