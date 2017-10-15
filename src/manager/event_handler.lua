Game.manager.event_handler = {}

local handler_id = 0
local handler_map = {}

local event_handler = Game.manager.event_handler
function event_handler:on(event_name, callback)
    if not handler_map[event_name] then
        handler_map[event_name] = {}
    end

    handler_id = handler_id + 1
    handler_map[event_name][handler_id] = {callback = callback}
    return handler_id
end

function event_handler:off(event_name, handler_id)
    local handlers = handler_map[event_name]
    if handlers then
        handlers[handler_id] = nil
    end
end

function event_handler:offAll(event_name)
    handler_map[event_name] = nil
end

function event_handler:emit(event_name, ...)
    local handlers = handler_map[event_name]
    if handlers then
        for _, handler in pairs(handlers) do
            handler.callback(...)
        end
    end
end