
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
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_USER_INFO, handler(self, self.onPushUserInfo), "DataManager.onPushUserInfo")

     --监听客户端断开连接事件
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.WAIT_RECONNECT,handler(self, self.listenNetDisconnect),"DataManager.listenNetDisconnect")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.RECONNECT,handler(self, self.reConnectSuccess),"DataManager.reConnectSuccess")
end

function DataManager:reConnectSuccess(recv_msg)
    --更新玩家的token
    self:saveToken(recv_msg.reconnect_token)
    --重新连接成功 则重置连接次数
    self:updateDisconnectTimes(true)
end

function DataManager:listenNetDisconnect()
    --断线重连
    local times = self:updateDisconnectTimes()
    if times <= 3 then
        lt.NetWork:reconnect("127.0.0.1", 8888, function() 
            local reconnect_token = self:getReconnectToken()
            local user_id = self:getPlayerUid()
            if not user_id or reconnect_token then
                error("not user_id or reconnect_token")
            end
            lt.NetWork:sendTo({[lt.GameEventManager.EVENT.RECONNECT] = {token = msg.reconnect_token}})
        end)
    else
        print("弹框: 网络断开")
    end
end

--FYD 记录下玩家的重连token
function DataManager:saveToken(token)
    self._reconnect_token = token 
end

--FYD 获取玩家的重连token
function DataManager:getReconnectToken()
    return self._reconnect_token
end

--FYD 更新重连的次数
function DataManager:updateDisconnectTimes(is_reset)
    if not self._reconnect_times or is_reset then
        self._reconnect_times = 0
    end
    self._reconnect_times = self._reconnect_times + 1
    return self._reconnect_times
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

function DataManager:onPushUserInfo(msg)
    local palyerInfo = self:getPlayerInfo()
    table.merge(palyerInfo,msg)
end

function DataManager:getGameRoomInfo(flag)
    if not self._gameRoomInfo or flag then
        self._gameRoomInfo = {}
    end
    return self._gameRoomInfo
end

function DataManager:onRefreshRoomInfo(msg)
    dump(msg)
    self._gameRoomInfo = msg

    lt.GameEventManager:post(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO)

    --other_setting
end

function DataManager:getMyselfPositionInfo()
    for i,player in ipairs(self:getGameRoomInfo().players) do
        if player.user_id == self:getPlayerUid() then
            return player
        end
    end
end

function DataManager:getPlayerInfoByPos(pos)
    for i,player in ipairs(self:getGameRoomInfo().players) do
        if player.user_pos == pos then
            return player
        end
    end
    return nil
end

return DataManager

