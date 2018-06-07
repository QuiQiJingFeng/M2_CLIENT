
-- ################################################## 游戏内缓存数据 ##################################################
local DataManager = {}
DataManager._init = false
DataManager._flush = false

DataManager._maxServerIdx           = nil
DataManager._curServerId            = 0
DataManager._serverTable            = nil
DataManager._token                  = nil
DataManager._player                 = nil
DataManager._hero                   = nil
DataManager._skillHeroTable         = nil
DataManager._friendRequestTable     = nil
DataManager._friendRequestSendTable = nil
DataManager._friendTable            = nil

function DataManager:init()
    if self._init then
        return
    end

    self._init = true

    self._caseMonsterKillTable = {}

    -- 登陆

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.REFRESH_ROOM_INFO, handler(self, self.onRefreshRoomInfo), "DataManager.onRefreshRoomInfo")

     --监听客户端断开连接事件
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.WAIT_RECONNECT,handler(self, self.listenNetDisconnect),"DataManager.listenNetDisconnect")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.JOIN_ROOM, handler(self, self.onjoinRoomResponse), "DataManager:onjoinRoomResponse")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_ALL_ROOM_INFO, handler(self, self.onPushAllRoomInfo), "DataManager:onjoinRoomResponse")


    --牌局信息
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_GAME_OVER, handler(self, self.onNoticeGameOver), "DataManager.onNoticeGameOver")


end

function DataManager:onjoinRoomResponse(msg)
    
    print("__________________________", msg.result)
    dump(msg, "msg")
    if msg.result == "success" then
        print("加入房间")
        local gameInfo = lt.DataManager:getGameRoomInfo()
        if not gameInfo or not gameInfo.room_setting or not gameInfo.room_setting.game_type then
            return
        end    
        local scene = cc.Director:getInstance():getRunningScene()
        if scene.__cname ~= "GameScene" then
            local gameScene = lt.GameScene.new()
            lt.SceneManager:replaceScene(gameScene)
        end

        -- local gameInfo = lt.DataManager:getGameRoomInfo()

        -- dump(gameInfo, "gameInfo")
        -- local gameid = 1

        -- if gameInfo and gameInfo.room_setting and gameInfo.room_setting.game_type then
        --     gameid = gameInfo.room_setting.game_type
        -- end

        -- if gameid == 1 then --红中麻将
        --     print("FYD+++++++++切换游戏场景")
        --     local gameScene = lt.GameScene.new()
        --     lt.SceneManager:replaceScene(gameScene)
        -- elseif gameid == 2 then --斗地主
        --     local gameScene = lt.DDZGameScene.new()
        --     lt.SceneManager:replaceScene(gameScene)
        -- end     

    else
        print("加入房间失败")
    end
end

--################################断线重连  加宕机 ##################################

--断线重连   放回房间   onPushAllRoomInfo
function DataManager:getPushAllRoomInfo()
    if not self._pushAllRoomInfo then
        self._pushAllRoomInfo = {}
    end
    return self._pushAllRoomInfo
end

function DataManager:clearPushAllRoomInfo()
    self._pushAllRoomInfo = {}
end

function DataManager:onPushAllRoomInfo(msg)
    dump(msg,"ON PUSH ALL ROOM INFO",100)

    if msg.refresh_room_info then
        self._gameRoomInfo = msg.refresh_room_info
    end

    self._pushAllRoomInfo = msg
    lt.GameEventManager:post(lt.GameEventManager.EVENT.CLIENT_CONNECT_AGAIN)
end

function DataManager:isClientConnectAgain()
    if next(lt.DataManager:getPushAllRoomInfo()) then
        return true
    end
    return false
end

function DataManager:isClientConnectAgainPlaying()
    local allRoomInfo = lt.DataManager:getPushAllRoomInfo()

    if next(allRoomInfo) then
        if allRoomInfo.card_list and next(allRoomInfo.card_list) then
           return true 
        end
    end
    return false
end

local times = 3
--断线重连
function DataManager:listenNetDisconnect()
    print("连接断开事件触发")
    times = times - 1
    if times < 0 then
        lt.MsgboxLayer:showMsgBox("网络连接断开,是否重新连接", false, function()
            times = 3
            self:listenNetDisconnect()
        end, function() end, true)
        return
    end
    local scene = cc.Director:getInstance():getRunningScene()
    if scene.__cname == "GameScene" then
        --断线重连  只能发生在gamescene的时候
        local room_id = self._gameRoomInfo.room_id
        if room_id then
            lt.CommonUtil:sepecailServerLogin(room_id,function(result) 
                if result == "success" then
                    self._pushAllRoomInfo = {}
                    local arg = {room_id = room_id}
                    lt.NetWork:sendTo(lt.GameEventManager.EVENT.JOIN_ROOM, arg)
                end
            end)
        end
    end
end
                                                                 

function DataManager:reset()
    lt.CommonUtil.print("DataManager:reset")
    for i,v in pairs(self) do
        if type(v) ~= "function" then
            self[i] = nil
        end
    end

    self._init = true
    self._flush = false

    self._curServerId = 0
end

--[[ ################################################## server ##################################################
    服务器
    ]]


function DataManager:getPlayerInfo()
    if not self._playerInfo then
        self._playerInfo = {}
    end
    return self._playerInfo
end

function DataManager:getPlayerUid()
    return self._playerInfo.user_id
end

function DataManager:getPlayerName()
    return self._playerInfo.user_name
end

-- 记录下登陆 房间服务器的令牌
function DataManager:recordAuthData(data)
    self._auth_data = data
end

function DataManager:getAuthData()
    return {user_id = self._auth_data.user_id,token=self._auth_data.token}
end

function DataManager:onPushUserInfo(msg)
    local palyerInfo = self:getPlayerInfo()
    table.merge(palyerInfo,msg)
    -->通知大厅更新显示数据
    lt.GameEventManager:post(lt.GameEventManager.EVENT.ROOM_LIST_UPDATE)
end

--[[################################牌局游戏信息################################]]
function DataManager:getGameRoomInfo(flag)
    if not self._gameRoomInfo or flag then
        self._gameRoomInfo = {}
    end
    return self._gameRoomInfo
end

function DataManager:onRefreshRoomInfo(msg)
    --dump(msg,"FYD===onRefreshRoomInfo",11)
    self._gameRoomInfo = msg

    lt.GameEventManager:post(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO)

    --room_setting  other_setting 
    -- 游戏设置项[数组]
    -- [1] 底分
    -- [2] 奖码的个数
    -- [3] 七对胡牌
    -- [4] 喜分
    -- [5] 一码不中当全中


end

function DataManager:getGameRoomSetInfo()
    if self._gameRoomInfo then
        return self._gameRoomInfo.room_setting
    end
    return nil    
end

function DataManager:getMyselfPositionInfo()
    for i,player in ipairs(self:getGameRoomInfo().players) do
        if player.user_id == self:getPlayerUid() then
            return player
        end
    end
    print("房间数据出错！！！！！！！！")
    return nil
end

function DataManager:getPlayerInfoByPos(pos)
    for i,player in ipairs(self:getGameRoomInfo().players) do
        if player.user_pos == pos then
            return player
        end
    end
    return nil
end

function DataManager:setPlayerDirectionTable(directions)
    self._playerDirectionTable = directions
end

function DataManager:getPlayerDirectionByPos(pos)
    self._playerDirectionTable = self._playerDirectionTable or {}
    return self._playerDirectionTable[pos]
end

function DataManager:getGameOverInfo(flag)
    if not self._gameOverInfo or flag then
        self._gameOverInfo = {}
    end
    return self._gameOverInfo
end

function DataManager:onNoticeGameOver(msg)   --通知客户端 本局结束 带结算

    self._gameOverInfo = {}
    if msg.players then
        for k,v in ipairs(msg.players) do
            if v.card_list then
                table.sort(v.card_list, function(a, b)
                    return a < b
                end)
            end 
        end
    end
    self._gameOverInfo = msg
    -- self._gameOverInfo["winner_pos"] = msg.winner_pos
    -- self._gameOverInfo["winner_type"] = msg.winner_type or 1 --自摸 1 抢杠 2
    -- self._gameOverInfo["last_round"] = msg.last_round
    -- self._gameOverInfo["players"] = msg.players

    lt.GameEventManager:post(lt.GameEventManager.EVENT.Game_OVER_REFRESH)

-- players
-- over_type
-- award_list
-- winner_type
-- last_round
-- winner_pos

end


return DataManager

