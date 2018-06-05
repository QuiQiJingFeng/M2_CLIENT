local ReplayWatchLayer = class("ReplayWatchLayer", function()
    return cc.CSLoader:createNode("game/common/RecordDetailLayer.csb")
end)

function ReplayWatchLayer:ctor()
	local mainLayer = self:getChildByName("Ie_Bg")
	local Ie_Share = self:getChildByName("Ie_Share")
	Ie_Share:setVisible(false)--不用直接false掉
	local Ie_Mark_share = self:getChildByName("Ie_Mark_share")
	Ie_Mark_share:setVisible(false)--不用直接false掉
	
	
	local Bn_Close  = mainLayer:getChildByName("Bn_Close")
	Bn_Close:setPosition(cc.p(1285.13,593))



	self.sv_Detail  = mainLayer:getChildByName("SV_Detail")
	local size = self.sv_Detail:getContentSize()
	--self.sv_Detail:setInnerContainerSize(cc.size(size.width,750))--人数X150

	local UITableView = require("app.UI.UITableView")
	self._zj_ReplayWatchitem = UITableView:bindNode(self.sv_Detail,"app.Scene.WorldScene.LobbyBtn.ReplayWatchitem")
	--[[
	--local x = {650,500,350,200,50}
	local itemposY = 50--最后一个是50,每次递增150
	for i=1,5 do
		if i ~= 1 then
			itemposY =itemposY + 150
		end
		print("====",itemposY)
		local ReplayWatchitem = lt.ReplayWatchitem.new()
		ReplayWatchitem:setPosition(600,itemposY)--x坐标恒定600
    	self.sv_Detail:addChild(ReplayWatchitem)
	end--]]
	





	lt.CommonUtil:addNodeClickEvent(Bn_Close, handler(self, self.onClose))
	


end

function ReplayWatchLayer:listenRoomListUpdate(result)
	print("=======11=1=1=1==1=1")
	local reveice = clone(result.replays) --拼接序号进去
	for i=1,#reveice do
		reveice[i].xuhao = i
	end
	self._zj_ReplayWatchitem:setData(reveice,0,15,10)
end

function ReplayWatchLayer:onClose(event)
	lt.UILayerManager:removeLayer(self)
end

return ReplayWatchLayer