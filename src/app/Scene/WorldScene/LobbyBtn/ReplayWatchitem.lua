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
        print("FYD----->>>",self._data.players)
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
	--local user_url = "https://replaycord.oss-cn-hongkong.aliyuncs.com/"..self._game_type.."/"..self._replay_id..".txt"
    local user_url = "https://replaycord.oss-cn-hongkong.aliyuncs.com/".."all".."/"..self._replay_id..".txt"

	lt.CommonUtil:sendXMLHTTPrequrest("GET",user_url,body,function(recv_msg)
		local receive = string.split(recv_msg, "\n")
		local ReplayAllTable = {}
        local ReplayOneTable = {}
        ---[[
		for i=1,#receive do
            receive[i] = string.gsub(receive[i],'\\','')
			local result = json.decode(receive[i])
            if i == 1 then
                local info = clone(result)
                --table.insert(ReplayOneTable, info )
                ReplayOneTable = info
            end
			table.insert( ReplayAllTable, result )
		end--]]
		-- local scene = self:getParent():getParent():getParent():getParent()
		-- local MJplayBackLayer = lt.MJplayBackLayer.new(bb)
  --   	scene:addChild(MJplayBackLayer)
---[[   
        print("打印输出")
        dump(receive)
        local name = ""
        local bs = false
        local allEventData = {} --最后的保存
        local ReplayTable = {}
        local ReplayConf = require("app/Scene/GameScene/mj/ReplayConf")
        for k,v in ipairs(receive) do
            bs = false
            local func = string.gmatch(v,'{"(.-)":')
            local event_name = func()
            local value = ReplayConf[event_name]
            if value then
                if not ReplayTable[event_name] then
                   ReplayTable[event_name] = {}
               end
            end
            if value then
                if value.data_manager == "insert" then
                    table.insert(ReplayTable[event_name],v)
                elseif value.data_manager == "onlyone" then
                    table.insert(ReplayTable[event_name],v)
                elseif value.filter_str == "card" then 
                    if string.find(v,'"card"') then
                        bs = true
                    end
                elseif value.filter_str == "card_list" then
                    if string.find(v,'"card_list"') then
                        bs = true
                    end
                end
            end

            for k2,v2 in pairs(ReplayTable) do
                    if event_name ~= k2 then
                        if ReplayConf[k2].data_manager == "insert" then
                            local upvalue = ReplayConf:processinsertData(ReplayTable[k2])
                            table.insert(allEventData,upvalue)
                            ReplayTable[k2] = nil
                        end
                    end
            end

            for k3,v3 in pairs(ReplayTable) do
                    if event_name ~= k3 then
                        if ReplayConf[k3].data_manager == "onlyone" then
                            local upvalue = ReplayConf:processinsertDataOne(ReplayTable[k3])
                            table.insert(allEventData,upvalue)
                            ReplayTable[k3] = nil
                        end
                    end
            end

            if bs then
               table.insert(allEventData, v)
            end
        end

        dump(ReplayOneTable)
        --table.insert(allEventData,1,ReplayOneTable)
        print("[[[[[[[[[")
        dump(allEventData)
        lt.DataManager:setReplayDataDispose(allEventData)--把回放数据先维护起来


        lt.GameEventManager:post(lt.GameEventManager.EVENT.REFRESH_ROOM_INFO,ReplayOneTable)--先把房间信息发送出去

        lt.DataManager:setRePlayState(true)--设置为回放状态

        print("====xxxxxx",lt.DataManager:getRePlayState())

        --数据整合之后
        local scene = cc.Director:getInstance():getRunningScene()
        if scene.__cname ~= "GameScene" then
            local gameScene = lt.GameScene.new()
            lt.SceneManager:replaceScene(gameScene)
        end

        end)
        
end

return ReplayWatchitem



--[[
        local ReplayerTbale = {}
        local tempIndex = 2

        local config = {

                ["deal_card"] = {"evnet_name" = "deal_card", "data_manager" = "insert"},--data_manager insert onlyone 
                ["push_draw_card"] = {"evnet_name" = "push_draw_card", "filter_str" = "card"},
                ["push_play_card"] = {"evnet_name" = "push_play_card", "filter_str" = "card_list"}

                ["notice_special_event"] = {"evnet_name" = "notice_special_event", "data_manager" = "onlyone"}
        }

                local dealCardInfo = {}
                local conf = require("hongzhong/conf")
                register("push_draw_card","card")
                conf.process = function(filter)
                    post()
                end


                "merge_data"
                local filters ={["push_draw_card"="card"]}
                local pre_merge_data = nil
                for k,v in pairs(value) do
             
                    local info = {}

                    if string.find(v,filters[k]) then
                         conf.process()
                    end

                    if k == register_key then
                        if filters[k] == "merge_data" then
                            pre_merge_data = {[k]={}}
                            table.insert(pre_merge_data[k],v);
                        end
                    end
                    if pre_merge_data and not pre_merge_data[k] then
                        for k,v in pairs(pre_merge_data) do
                           conf.process(v)
                        end
                        pre_merge_data = nil
                    end


        --数据整合之后
        local scene = cc.Director:getInstance():getRunningScene()
        if scene.__cname ~= "GameScene" then
            local gameScene = lt.GameScene.new()
            lt.SceneManager:replaceScene(gameScene)
        end

		--回放的接口
	end)
end
local func = string.gmatch('{"deal_card":{"cards":[4,5,6,7','{"(.+)":')
local event_name = func()[1]--]]

--[[
"<var>" = 
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