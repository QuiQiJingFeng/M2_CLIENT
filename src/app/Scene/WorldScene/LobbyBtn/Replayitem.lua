local Replayitem = class("Replayitem", function()
    local root = cc.CSLoader:createNode("game/common/Node_RecordItem.csb")
    local mainLayer = root:getChildByName("Ie_Record")
    mainLayer:removeSelf()
    return mainLayer
end)

function Replayitem:ctor()

	self._tt_RoomNo  = self:getChildByName("Tt_RoomNo")--房号
	self._tt_Time  = self:getChildByName("Tt_Time")--对战时间
	self._bn_Detail = self:getChildByName("Bn_Detail")--查看详情按钮

	lt.CommonUtil:addNodeClickEvent(self._bn_Detail, handler(self, self.onDetail))
	


end

function Replayitem:refreshData(data)
	self.data = data
	if type(self.data.players) ~= "table" then
		self.data.players = json.decode(self.data.players)
	end
	self._tt_RoomNo:setString(self.data.room_id)
	self._tt_Time:setString(self.data.time)
	self._room_id = self.data.room_id
	for i=1,#self.data.players do
		local score = self:getChildByName("Tt_Score"..i)
		local name  = self:getChildByName("Tt_Name"..i)
		score:setString(self.data.players[i].score)
		score:setVisible(true)
		name:setString(self.data.players[i].user_name)
		name:setVisible(true)
	end


end

function Replayitem:onDetail(event)
	--[[
	local body = lt.DataManager:getAuthData()
	body.replay_id = self._replay_id
	body.game_type = self._game_type
	local user_url = "https://replaycord.oss-cn-hongkong.aliyuncs.com/"..self._game_type.."/"..self._replay_id..".txt"

	lt.CommonUtil:sendXMLHTTPrequrest("GET",user_url,body,function(recv_msg)
		print("=============1============")
		local receive = string.split(recv_msg, "\n")
		dump(receive)

	end)--]]

	local body = lt.DataManager:getAuthData()
	body.room_id = self._room_id
	local url = string.format("http://%s:%d/operator/get_replays_by_room_id",lt.Constants.HOST,lt.Constants.PORT)
    lt.CommonUtil:sendXMLHTTPrequrest("POST",url,body,function(recv_msg) 
            if recv_msg then
                recv_msg = json.decode(recv_msg)
                print("====2=2=2=2==")
                dump(recv_msg)
                local ReplayWatchLayer = lt.ReplayWatchLayer.new()
                ReplayWatchLayer:listenRoomListUpdate(recv_msg)
    			lt.UILayerManager:addLayer(ReplayWatchLayer, true)
            else
                print("ERROR,获取失败")
            end
        end)
end

return Replayitem