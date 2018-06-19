
local GameEventManager = {}

GameEventManager.EVENT = {
    --客户端自己用的
    REFRESH_POSITION_INFO = "refresh_position_info",
    RECONNECT = "reconnect", --重新连接
    
    WAIT_RECONNECT = "wait_reconnect",  --监听客户端连接断开
    ROOM_LIST_UPDATE =  "room_list_update", --房间列表有更新

    CLIENT_DEAL_DOWN =  "client_deal_down", --发牌

    CLIENT_CONNECT_AGAIN =  "client_connect_again", --重连

    --发送音频
    SEND_AUDIO = "send_audio",
    --接收音频
    NOTICE_SEND_AUDIO = "notice_send_audio",

    --出牌 补花
    NOTICE_SPECIAL_BUFLOWER = "notice_special_buflower",

    --请求
	LOGIN = "login",
    JOIN_ROOM = "join_room",
	CREATE_ROOM = "create_room",
    SIT_DOWN = "sit_down",
    LEAVE_ROOM = "leave_room",--回到大厅
    DISTROY_ROOM = "distroy_room",
    CONFIRM_DISTROY_ROOM = "confirm_distroy_room",
    NOTICE_TOTAL_SATTLE  = "notice_total_sattle",--刷新总结算
    GAME_CMD = "game_cmd",  --[[游戏中的请求 DEAL_FINISH  发牌完毕
PLAY_CARD  出牌
PENG    碰
GANG    杠
GUO     过]]--
    -- GAME_CMD = "game_cmd",  --
    Game_OVER_REFRESH = "game_over_refresh",

    --推送
    PUSH_USER_INFO = "push_user_info",
    REFRESH_ROOM_INFO = "refresh_room_info",
    DEAL_DOWN = "deal_card",--发牌
    PUSH_SIT_DOWN = "push_sit_down",--推送坐下的信息 
    PUSH_DRAW_CARD = "push_draw_card",--通知其他人有人摸牌 
    NOTICE_OTHER_DISTROY_ROOM = "notice_other_distroy_room",--通知有人解散房间
    NOTICE_OTHER_REFUSE = "notice_other_refuse",--如果有人拒绝解散
    NOTICE_PLAYER_DISTROY_ROOM = "notice_player_distroy_room",--如果房间被销毁
    PUSH_PLAY_CARD = "push_play_card",--通知玩家该出牌了 
    NOTICE_PLAY_CARD = "notice_play_card",--通知其他人有人出牌 

    NOTICE_SPECIAL_EVENT = "notice_special_event",  --通知有人吃椪杠胡
    PUSH_PLAYER_OPERATOR_STATE = "push_player_operator_state",--通知客户端当前 碰/杠 状态

    NOTICE_GAME_OVER = "notice_game_over",--通知客户端 本局结束 带结算

    PUSH_ALL_ROOM_INFO = "push_all_room_info",  --获取全部的房间信息

    REFRESH_PLAYER_CUR_SCORE = "refresh_player_cur_score",--牌局中积分发生变化

    NOTICE_PLAYER_CONNECT_STATE = "notice_player_connect_state",--牌局中积分发生变化

    RECONNECT = "reconnect", --重新连接
    
    WAIT_RECONNECT = "wait_reconnect",  --监听客户端连接断开

    -- ddz
    SERVER_SEND_CARD = "ServerSendCard",
    NOTICE_POINT_DEMAND = "NoticePointDemand",
    NOTICE_MAIN_PLAYER = "NoticeMainPlayer",
    SERVER_MAIN_PLAYER = "ServerMainPaleyer",
    NOTICE_SEND_CARD = "NoticeSendCard",
    SERVER_POINT_DEMAND = "ServerPointDemand",
    NOTICE_DDZ_GAMEOVER = "NoticeDDZGameOver",
}

local handler_id = 0
local handler_map = {}

function GameEventManager:addListener(event_name, callback, tag)
    if not handler_map[event_name] then
        handler_map[event_name] = {}
    end

    -- handler_id = handler_id + 1
    -- handler_map[event_name][handler_id] = {callback = callback}
    -- return handler_id

    handler_map[event_name][tag] = {callback = callback}
end

function GameEventManager:removeListener(event_name, tag)
    -- local handlers = handler_map[event_name]
    -- if handlers then
    --     handlers[handler_id] = nil
    -- end

    local handlers = handler_map[event_name]
    if handlers then
        handlers[tag] = nil
    end
end

function GameEventManager:removeAllListener(event_name)
    handler_map[event_name] = nil
end

function GameEventManager:post(event_name, ...)
    local handlers = handler_map[event_name]
    if handlers then
        for _, handler in pairs(handlers) do
            handler.callback(...)
        end
    end
end

return GameEventManager
