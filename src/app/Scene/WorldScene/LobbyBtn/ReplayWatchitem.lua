local ReplayWatchitem = class("ReplayWatchitem", function()
    local root = cc.CSLoader:createNode("game/common/Node_RecordDetaileItem.csb")
    local mainLayer = root:getChildByName("Ie_Record")
    mainLayer:removeSelf()
    return mainLayer
end)

function ReplayWatchitem:ctor()

	self._tt_No  = self:getChildByName("Tt_No")--序号
	local BG4_2  = self:getChildByName("BG4_2")
	self.tt_RoundID  = self:getChildByName("Tt_RoundID")--回放码
	self._tt_Time  = self:getChildByName("Tt_Time")--对战时间
	self._tt_No:setVisible(true)
	BG4_2:setVisible(true)
	self.tt_RoundID:setVisible(true)
	self._tt_Time:setVisible(true)


	local Bn_Share  = self:getChildByName("Bn_Share")--分享按钮
	local Bn_Detail  = self:getChildByName("Bn_Detail")--回放按钮
	Bn_Share:setVisible(true)
	Bn_Detail:setVisible(true)


	lt.CommonUtil:addNodeClickEvent(Bn_Share, handler(self, self.onShare))
	lt.CommonUtil:addNodeClickEvent(Bn_Detail, handler(self, self.onDetail))

end

function ReplayWatchitem:refreshData(data)
	self._data = data
	dump(self._data)
	if type(self._data.players) ~= "table" then
		self._data.players = json.decode(self._data.players)
	end
	self._tt_No:setString("序号: "..self._data.xuhao)
	self.tt_RoundID:setString("回放码: "..self._data.replay_id)
	self._tt_Time:setString("对战时间: "..self._data.time)

	self._replay_id = self._data.replay_id
	self._game_type = self._data.game_type

	for i=1,#self._data.players do
		local score = self:getChildByName("Tt_Score"..i)
		local name  = self:getChildByName("Tt_Name"..i)
		score:setString(self._data.players[i].score)
		score:setVisible(true)
		name:setString(self._data.players[i].user_name)
		name:setVisible(true)
	end


end

function ReplayWatchitem:onClose(event)
	lt.UILayerManager:removeLayer(self)
end

function ReplayWatchitem:onShare(event)

	local callBack = function(str) 
        print("FYD===>>",str)
    end
    --[[分享url接口暂时放这
    local data = {0,"萌芽娱乐","畅玩麻将体验","https://mengyagame.com",""}
    --local ok,ret = lt.Luaj.callStaticMethod("com/mengya/wechat/WechatDelegate", "wxshareURL",data,"(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
    lt.Luaj.callStaticMethod("com/mengya/common/PlatformSDK", "registerCallBack",{callBack},"(I)V")    
    local ok,ret = lt.Luaj.callStaticMethod("com/mengya/wechat/WechatDelegate", "wxshareURL",data,"(Ljava/lang/String;)V")
	--]]
	local WXShareLayer = lt.WXShareLayer.new()
    lt.UILayerManager:addLayer(WXShareLayer, true)
end

function ReplayWatchitem:onDetail(event)
	local body = lt.DataManager:getAuthData()
	body.replay_id = self._replay_id
	body.game_type = self._game_type
	local user_url = "https://replaycord.oss-cn-hongkong.aliyuncs.com/"..self._game_type.."/"..self._replay_id..".txt"

	lt.CommonUtil:sendXMLHTTPrequrest("GET",user_url,body,function(recv_msg)
		local receive = string.split(recv_msg, "\n")
		dump(receive)
		--回放的接口
	end)
end

return ReplayWatchitem