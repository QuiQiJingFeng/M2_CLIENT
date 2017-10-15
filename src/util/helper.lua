Game.util.helper = {}

local helper = Game.util.helper
function helper:createCSNode(node_path, bind_animation)
    local node = cc.CSLoader:createNode(node_path)
    node.node_path = node_path

    if bind_animation then
        node.timeline = cc.CSLoader:createTimeline(node.node_path)
        node:runAction(node.timeline)

        -- 播放动画并设置回调
        function node:play(name, is_loop, callfunc)
            is_loop = checkbool(is_loop)
            self.timeline:play(name, is_loop)

            if isfunction(callfunc) then
                self.timeline:setLastFrameCallFunc(function()
                    callfunc(name, is_loop)
                end)
            else
                self.timeline:clearLastFrameCallFunc()
            end

            return self
        end

        -- 帧事件回调
        local frame_event_cb_id = 0
        local frame_event_cb_map = {}
        local frameEventCallFunc = function(frame)
            local event_name = frame:getEvent()
            for _,info in ipairs(frame_event_cb_map[event_name] or {}) do
                info.callfunc(frame, unpack(info.params))
            end
            frame_event_cb_map[event_name] = nil
            if table.empty(frame_event_cb_map) then
                node.timeline:clearFrameEventCallFunc()
            end
        end
        -- 注册回调
        function node:onFrameEvent(event_name, callfunc, ...)
            if isfunction(callfunc) then
                if table.empty(frame_event_cb_map) then
                    self.timeline:setFrameEventCallFunc(frameEventCallFunc)
                end
                frame_event_cb_id = frame_event_cb_id + 1
                frame_event_cb_map[event_name] = frame_event_cb_map[event_name] or {}
                table.insert(frame_event_cb_map[event_name], { frame_event_cb_id = frame_event_cb_id, callfunc = callfunc, params = {...}})
                return frame_event_cb_id
            end
        end
        -- 注销回调
        function node:clearFrameEventCallFunc(event_name, frame_event_cb_id)
            local callfunc_list = frame_event_cb_map[event_name] or {}
            for index,info in ipairs(callfunc_list) do
                if info.frame_event_cb_id == frame_event_cb_id then
                    table.remove(callfunc_list, index)
                    if #callfunc_list == 0 then
                        callfunc_list = nil
                        if table.empty(frame_event_cb_map) then
                            self.timeline:clearFrameEventCallFunc()
                        end
                    end
                    return true
                end
            end
            return false
        end
    end

    return node
end