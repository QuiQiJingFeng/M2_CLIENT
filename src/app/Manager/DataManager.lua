
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

function DataManager:getGameRoomInfo()
    if not self._gameRoomInfo then
        self._gameRoomInfo = {}
    end
    return self._gameRoomInfo
end

function DataManager:onRefreshRoomInfo(msg)
    dump(msg)

    local gameRoomInfo = self:getGameRoomInfo()
    gameRoomInfo.room_id = msg.room_id
    gameRoomInfo.game_type = msg.game_type

    gameRoomInfo.players = {}

    for i,player in ipairs(msg.players) do
        local info = {}
        info.user_id = player.user_id
        info.user_name = player.user_name
        info.user_pic = player.user_pic
        info.user_ip = player.user_ip
        table.insert(gameRoomInfo.players, info)
    end
    gameRoomInfo.round = msg.round
    gameRoomInfo.pay_type = msg.pay_type
    gameRoomInfo.seat_num = msg.seat_num
    gameRoomInfo.is_friend_room = msg.is_friend_room
    gameRoomInfo.is_open_voice = msg.is_open_voice
    gameRoomInfo.is_open_gps = msg.is_open_gps

    --other_setting
end


return DataManager

