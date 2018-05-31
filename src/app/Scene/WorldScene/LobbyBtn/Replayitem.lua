local Replayitem = class("Replayitem", function()
    return cc.CSLoader:createNode("game/common/Node_RecordItem.csb")
end)

function Replayitem:ctor()
	local mainLayer = self:getChildByName("Ie_Record")
	local Tt_RoomNo  = mainLayer:getChildByName("Tt_RoomNo")--房号
	local Tt_Time  = mainLayer:getChildByName("Tt_Time")--对战时间
	self._bn_Detail = mainLayer:getChildByName("Bn_Detail")--查看详情按钮
	





	lt.CommonUtil:addNodeClickEvent(self._bn_Detail, handler(self, self.onDetail))
	


end

function Replayitem:onDetail(event)

end

return Replayitem