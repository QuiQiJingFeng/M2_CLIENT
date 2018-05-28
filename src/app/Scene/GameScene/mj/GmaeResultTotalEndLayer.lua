
local GmaeResultTotalEndLayer = class("GmaeResultTotalEndLayer", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/gwidget/TotalResultLayer.csb")
end)
local posY = 80
-- 1334  
function GmaeResultTotalEndLayer:ctor()
	GmaeResultTotalEndLayer.super.ctor(self)

	self._Ie_Bg = self:getChildByName("Ie_Bg")
    self._Bn_Close = self._Ie_Bg:getChildByName("Bn_Close")

    lt.CommonUtil:addNodeClickEvent(self._Bn_Close, handler(self, self.onClose))
    --self:show(info)
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
        posTableX = {380,810}
    elseif #array.sattle_list == 3 then
        posTableX = {230,596,960}
    elseif #array.sattle_list == 4 then
        posTableX = {0,310,620,930}
    end
    local hunumTable = {}
    local sortTable= clone(array.sattle_list)
    for i=1,#sortTable do
        if not sortTable[i].score then
        end
        table.insert(hunumTable,sortTable[i].score)
    end
    table.sort(hunumTable, function(a, b) return a > b end)
    dump(hunumTable)


    local info = clone(array.sattle_list)

    for i=1,#array.sattle_list do
        local items = lt.ResultTotalEnditems.new(info[i],hunumTable[1])
        print(posTableX[i])
        print(posY)
        items:setPosition(posTableX[i],posY)
        self._Ie_Bg:addChild(items)
    end




end

function GmaeResultTotalEndLayer:onClose()
    lt.UILayerManager:removeLayer(self)
end

function GmaeResultTotalEndLayer:onEnter()
    print("GmaeResultTotalEndLayer:onEnter")

end

function GmaeResultTotalEndLayer:onExit()
    print("GmaeResultTotalEndLayer:onExit")
end

return GmaeResultTotalEndLayer