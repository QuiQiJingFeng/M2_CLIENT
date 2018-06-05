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
		--local result = json.decode(receive)
		--dump(result)
		--dump(receive)
		local bb = {}
		for i=1,#receive do
			local result = json.decode(receive[i])
			table.insert( bb, result )
		end
		local scene = self:getParent():getParent():getParent():getParent()
		local MJplayBackLayer = lt.MJplayBackLayer.new(bb)
    	scene:addChild(MJplayBackLayer)
		--回放的接口
	end)
end
--[[
"<var>" = {
     1  = "{"state":2,"room_setting":{"is_friend_room":false,"game_type":1,"is_open_voice":false,"other_setting":[1,2,1,1,1],"round":4,"is_open_gps":false,"pay_type":1,"seat_num":2},"players":[{"cur_score":4,"score":8,"is_sit":true,"user_id":10134,"user_ip":"::ffff:1.198.29.91","gold_num":-40,"disconnect":false,"user_pos":1,"user_pic":"http:\/\/xxxx.png","user_name":"雀起19736"},{"cur_score":-4,"score":-8,"is_sit":true,"user_id":10138,"user_ip":"::ffff:1.198.29.91","gold_num":0,"disconnect":false,"user_pos":2,"user_pic":"http:\/\/xxxx.png","user_name":"雀起1996"}],"room_id":274277,"cur_round":3}"
     2  = "{"deal_card":{"cards":[4,5,6,7,8,9,23,24,25,26,27,29,29],"user_pos":1,"zpos":1,"random_nums":[5,6],"cur_round":3}}"
     3  = "{"deal_card":{"cards":[1,2,3,11,12,13,14,15,16,17,18,28,28],"user_pos":2,"zpos":1,"random_nums":[5,6],"cur_round":3}}"
     4  = "{"push_draw_card":{"user_id":10134,"user_pos":1,"card":28}}"
     5  = "{"push_draw_card":{"user_id":10134,"user_pos":1}}"
     6  = "{"push_play_card":{"card_stack":{},"user_pos":1,"card_list":[4,5,6,7,8,9,23,24,25,26,27,29,29,28],"user_id":10134,"operator":1}}"
     7  = "{"push_play_card":{"user_id":10134,"user_pos":1,"operator":1}}"
     8  = "{"notice_special_event":{"user_id":10134,"item":{"value":28,"type":6,"from":1},"user_pos":1}}"
     9  = "{"notice_special_event":{"user_id":10134,"item":{"value":28,"type":6,"from":1},"user_pos":1}}"
     10 = "{"notice_game_over":{"players":[{"cur_score":4,"score":12,"user_pos":1,"card_list":[4,5,6,7,8,9,23,24,25,26,27,29,29,28],"user_id":10134},{"cur_score":-4,"score":-12,"user_pos":2,"card_list":[1,2,3,11,12,13,14,15,16,17,18,28,28],"user_id":10138}],"winner_pos":1,"award_list":[26,19,17,3],"over_type":1,"last_round":false,"winner_type":1}}"
     11 = "{"notice_game_over":{"players":[{"cur_score":4,"score":12,"user_pos":1,"card_list":[4,5,6,7,8,9,23,24,25,26,27,29,29,28],"user_id":10134},{"cur_score":-4,"score":-12,"user_pos":2,"card_list":[1,2,3,11,12,13,14,15,16,17,18,28,28],"user_id":10138}],"winner_pos":1,"award_list":[26,19,17,3],"over_type":1,"last_round":false,"winner_type":1}}"
     }
--]]
--[[
"<var>" = {
     1 = {
         "cur_round"    = 1
         "players" = {
             1 = *MAX NESTING*
             2 = *MAX NESTING*
         }
         "room_id"      = 274277
         "room_setting" = {
             "game_type"      = 1
             "is_friend_room" = false
             "is_open_gps"    = false
             "is_open_voice"  = false
             "other_setting" = *MAX NESTING*
             "pay_type"       = 1
             "round"          = 4
             "seat_num"       = 2
         }
         "state"        = 2
     }
     2 = {
         "deal_card" = {
             "cards" = *MAX NESTING*
             "cur_round"   = 1
             "random_nums" = *MAX NESTING*
             "user_pos"    = 1
             "zpos"        = 1
         }
     }
     3 = {
         "deal_card" = {
             "cards" = *MAX NESTING*
             "cur_round"   = 1
             "random_nums" = *REF*
             "user_pos"    = 2
             "zpos"        = 1
         }
     }
     4 = {
         "push_draw_card" = {
             "card"     = 28
             "user_id"  = 10134
             "user_pos" = 1
         }
     }
     5 = {
         "push_draw_card" = {
             "user_id"  = 10134
             "user_pos" = 1
         }
     }
     6 = {
         "push_play_card" = {
             "card_list" = *MAX NESTING*
             "card_stack" = *MAX NESTING*
             "operator"   = 1
             "user_id"    = 10134
             "user_pos"   = 1
         }
     }
     7 = {
         "push_play_card" = {
             "operator" = 1
             "user_id"  = 10134
             "user_pos" = 1
         }
     }
     8 = {
         "notice_special_event" = {
             "item" = *MAX NESTING*
             "user_id"  = 10134
             "user_pos" = 1
         }
     }
     9  = *REF*
     10 = {
         "notice_game_over" = {
             "award_list" = *MAX NESTING*
             "last_round"  = false
             "over_type"   = 1
             "players" = *MAX NESTING*
             "winner_pos"  = 1
             "winner_type" = 1
         }
     }
     11 = *REF*
     12 = {
         "update_cost_gold" = {
             "gold_list" = *MAX NESTING*
         }
     }
     13 = *REF*
 }

--]]

return ReplayWatchitem