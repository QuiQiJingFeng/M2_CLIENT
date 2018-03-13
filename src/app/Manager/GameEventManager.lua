
local GameEventManager = {}

GameEventManager.EVENT = {
	LOGIN = "login",
	JOIN_ROOM = "join_room",
    PUSH_USER_INFO = "push_user_info",
    REFRESH_ROOM_INFO = "refresh_room_info",
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
