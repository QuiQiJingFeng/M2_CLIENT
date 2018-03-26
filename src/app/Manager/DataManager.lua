
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
    dump(msg)
    local palyerInfo = self:getPlayerInfo()
    palyerInfo.user_id = msg.user_id
    palyerInfo.user_name = msg.user_name
    palyerInfo.user_pic = msg.user_pic
    palyerInfo.gold_num = msg.gold_num
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

