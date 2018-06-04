local Replayitem = class("Replayitem", function()
    local root = cc.CSLoader:createNode("game/common/Node_RecordItem.csb")
    local mainLayer = root:getChildByName("Ie_Record")
    return mainLayer
end)

---[[
function Replayitem:ctor()

 
	local Tt_RoomNo  = self:getChildByName("Tt_RoomNo")--房号
	local Tt_Time  = self:getChildByName("Tt_Time")--对战时间
	self._bn_Detail = self:getChildByName("Bn_Detail")--查看详情按钮
	





	lt.CommonUtil:addNodeClickEvent(self._bn_Detail, handler(self, self.onDetail))
	


end

function Replayitem:refreshData(data)

end

function Replayitem:onDetail(event)
	local ReplayWatchLayer = lt.ReplayWatchLayer.new()
    lt.UILayerManager:addLayer(ReplayWatchLayer, true)
end

return Replayitem--]]