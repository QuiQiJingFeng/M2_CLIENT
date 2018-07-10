
local GmaeResultTotalEndLayer = class("GmaeResultTotalEndLayer", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/gwidget/TotalResultLayer.csb")
end)
local posY = 80
-- 1334  
function GmaeResultTotalEndLayer:ctor(info, deleget)
	GmaeResultTotalEndLayer.super.ctor(self)
    self._deleget = deleget
	self._Ie_Bg = self:getChildByName("Ie_Bg")
    self._bn_Close = self._Ie_Bg:getChildByName("Bn_Close")
    local Node_Status = self._Ie_Bg:getChildByName("Node_Status")
    self._bn_Leave = Node_Status:getChildByName("Bn_Leave")
    self._bn_Share = Node_Status:getChildByName("Bn_Share")
    

    lt.CommonUtil:addNodeClickEvent(self._bn_Close, handler(self, self.onClose))
    lt.CommonUtil:addNodeClickEvent(self._bn_Leave, handler(self, self.onLeave))
    lt.CommonUtil:addNodeClickEvent(self._bn_Share, handler(self, self.onShare))

    ---拼接分享的数据结构
    local roomInfo = lt.DataManager:getGameRoomInfo()
    
    local roomTable = {}
    local pxTable = {}
    local infoTable = {}
    self.shareTable = {}
    roomTable = clone(roomInfo)
    pxTable = clone(info.sattle_list)
    table.sort(pxTable, function(a, b) return a.score > b.score end)
    infoTable = clone(pxTable)
    dump(infoTable)
    table.insert( self.shareTable, infoTable )--1
    --开始时间
    local discore = roomTable.room_setting.other_setting[1]
    local pay_type = roomTable.room_setting.pay_type
    local round = roomTable.room_setting.round
    local owner_id = lt.DataManager:getPlayerUid()
    local room_id = info.room_id
    local begin_time = info.begin_time

    table.insert(self.shareTable, discore)--底分 2
    table.insert(self.shareTable, pay_type)--支付类型 3
    table.insert(self.shareTable, round)--局数 4
    table.insert(self.shareTable, owner_id)--房主 5
    table.insert(self.shareTable, room_id)--房间号 6
    table.insert(self.shareTable, begin_time)--开始时间 7

    dump(self.shareTable)


end
function GmaeResultTotalEndLayer:show(array)
    --[[
    message SattleItem{
    optional int32 user_id = 1;
    optional int32 user_pos = 2;
    optional int32 hu_num = 3;
    optional int32 ming_gang_num = 4;
    optional int32 an_gang_num = 5;
    optional int32 reward_num = 6;
}
//总结算
message NoticeTotalSattle {
    required int32 room_id = 1;
    repeated SattleItem sattle_list = 2;
}--]]
--[[
array = {room_id = 10086,sattle_list = {[1] = {user_id = 10086,user_pos = 1,hu_num = 25,ming_gang_num = 3,an_gang_num=2,reward_num = 6},
[2] = {user_id = 10087,user_pos = 2,hu_num = -18,ming_gang_num = 2,an_gang_num=5,reward_num = 2},
[3] = {user_id = 10088,user_pos = 3,hu_num = -17,ming_gang_num = 1,an_gang_num=3,reward_num = 7},
[4] = {user_id = 10089,user_pos = 4,hu_num = 25,ming_gang_num = 0,an_gang_num=1,reward_num = 3}}}--]]
    local posTableX = {}
    if #array.sattle_list == 2 then
        posTableX = {260,710}
    elseif #array.sattle_list == 3 then
        posTableX = {230,596,960}
    elseif #array.sattle_list == 4 then
        posTableX = {0,310,620,930}
    end
    local hunumTable = {}
    local sortTable= clone(array.sattle_list)
    for i=1,#sortTable do
        table.insert(hunumTable,sortTable[i].score)
    end
    table.sort(hunumTable, function(a, b) return a > b end)


    local info = clone(array.sattle_list)
    for i=1,#array.sattle_list do
        local items = lt.ResultTotalEnditems.new(info[i],hunumTable[1])
        items:setPosition(posTableX[i],posY)
        self._Ie_Bg:addChild(items)
    end




end

function GmaeResultTotalEndLayer:onClose()
    self._deleget:closeGmaeResultTotalEndLayer()
end

function GmaeResultTotalEndLayer:onLeave()
    local worldScene = lt.WorldScene.new()
    lt.SceneManager:replaceScene(worldScene)
    lt.NetWork:disconnect()
end

function GmaeResultTotalEndLayer:onShare()
    local shareLayer = lt.GameEndExploitsLayer.new()
    shareLayer:show(self.shareTable)
    shareLayer:setVisible(false)
    lt.UILayerManager:addLayer(shareLayer,true)
end

function GmaeResultTotalEndLayer:onEnter()
    print("GmaeResultTotalEndLayer:onEnter")

end

function GmaeResultTotalEndLayer:onExit()
    print("GmaeResultTotalEndLayer:onExit")
end

return GmaeResultTotalEndLayer