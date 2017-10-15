local layer = class("battle_layer", import(".prototype"))

local util = Game.util
local helper = util.helper
local color = util.color
local log = util.log

local logic = Game.logic
local skill_logic = logic.skill
local battle_logic = logic.battle

local role = require("module.role")

-- 回合间隔
local ROUND_DURATION = 0.3

-- 交换出手方间隔
local SWITCH_DURATION = 2

-- 同一方各个角色行动间隔
local ACTION_DURATION = 0.2


local offset_x1 = 80
local offset_x2 = 180
local offset_y = 150
local offset_attack = 100
local l_pos = {
    cc.p(display.cx - offset_x1 - 30, display.cy - 300),
    cc.p(display.cx - offset_x1 - 50, display.cy - 300 - offset_y),
    cc.p(display.cx - offset_x1 - 70, display.cy - 300 + offset_y),
    cc.p(display.cx - offset_x2 - 30, display.cy - 300 + 10),
    cc.p(display.cx - offset_x2 - 50, display.cy - 300 - offset_y + 10),
    cc.p(display.cx - offset_x2 - 70, display.cy - 300 + offset_y + 10),
}

local l_attack_pos = {
    cc.pAdd(l_pos[1], cc.p(offset_attack, 0)),
    cc.pAdd(l_pos[2], cc.p(offset_attack, 0)),
    cc.pAdd(l_pos[3], cc.p(offset_attack, 0)),
    cc.pAdd(l_pos[4], cc.p(offset_attack, 0)),
    cc.pAdd(l_pos[5], cc.p(offset_attack, 0)),
    cc.pAdd(l_pos[6], cc.p(offset_attack, 0)),
}

local r_pos = {
    cc.p(display.cx + offset_x1 + 30, display.cy - 300),
    cc.p(display.cx + offset_x1 + 50, display.cy - 300 - offset_y),
    cc.p(display.cx + offset_x1 + 70, display.cy - 300 + offset_y),
    cc.p(display.cx + offset_x2 + 30, display.cy - 300 + 10),
    cc.p(display.cx + offset_x2 + 50, display.cy - 300 - offset_y + 10),
    cc.p(display.cx + offset_x2 + 70, display.cy - 300 + offset_y + 10),
}

local r_attack_pos = {
    cc.pAdd(r_pos[1], cc.p(-offset_attack, 0)),
    cc.pAdd(r_pos[2], cc.p(-offset_attack, 0)),
    cc.pAdd(r_pos[3], cc.p(-offset_attack, 0)),
    cc.pAdd(r_pos[4], cc.p(-offset_attack, 0)),
    cc.pAdd(r_pos[5], cc.p(-offset_attack, 0)),
    cc.pAdd(r_pos[6], cc.p(-offset_attack, 0)),
}

local l_avg_pos = {
    cc.p(display.cx - offset_x1, display.cy - 300),
    cc.p(display.cx - offset_x1 - 20, display.cy - 300),
    cc.p(display.cx - offset_x1 - 40, display.cy - 300),
}
local r_avg_pos = {
    cc.p(display.cx + offset_x1, display.cy - 300),
    cc.p(display.cx + offset_x1 + 20, display.cy - 300),
    cc.p(display.cx + offset_x1 + 40, display.cy - 300),
}

function layer:onCreate()
    self.round = 0

    self.background = helper:createCSNode("battlefield.csb", true)
        :addTo(self)

    self.player1_roles = {}
    self.player2_roles = {}
    for i=1,6 do
        self.player1_roles[i] = role:create():addTo(self):move(l_pos[i])
        self.player2_roles[i] = role:create():addTo(self):move(r_pos[i]):scale(-1, 1)
    end

    self:scheduleUpdate(function(dt)
        self:onUpdate(dt)
    end)
end

function layer:onExit()
end

function layer:onCleanup()
end

function layer:onUpdate(dt)
    for _,role in ipairs(self.player1_roles) do
        self:adjustZOrderByPosY(role)
    end
    for _,role in ipairs(self.player2_roles) do
        self:adjustZOrderByPosY(role)
    end
end

function layer:show(player1, player2)
    self.player1 = player1
    self.player2 = player2

    for _,role_info in ipairs(player1.role_list) do
        self.player1_roles[role_info.pos]:init(role_info.rid):play("stand_loop", true)
        self.player1_roles[role_info.pos].hp = role_info.hp
        self.player1_roles[role_info.pos].rage = role_info.rage
        self.player1_roles[role_info.pos].init_pos = l_pos[role_info.pos]
        self.player1_roles[role_info.pos].attack_pos = l_attack_pos[role_info.pos]
    end
    for _,role_info in ipairs(player2.role_list) do
        self.player2_roles[role_info.pos]:init(role_info.rid):play("stand_loop", true)
        self.player2_roles[role_info.pos].hp = role_info.hp
        self.player2_roles[role_info.pos].rage = role_info.rage
        self.player2_roles[role_info.pos].init_pos = r_pos[role_info.pos]
        self.player2_roles[role_info.pos].attack_pos = r_attack_pos[role_info.pos]
    end

    battle_logic:nextState()
end

function layer:adjustZOrderByPosY(node, pos)
    node:setLocalZOrder(1000 - (pos or node:getPositionY()))
end

function layer:isLeftPlayer(uid)
    return self.player1.uid == uid
end

function layer:getRole(uid, pos)
    if self:isLeftPlayer(uid) then
        return self.player1_roles[pos]
    else
        return self.player2_roles[pos]
    end
end

function layer:showDialog()
    battle_logic:nextState()
end

function layer:showBattleRound()
    local round_label = cc.Label:createWithTTF(string.format("第%d回合", battle_logic.round_num), "fonts/general.ttf", 30)
        :move(display.center)
        :addTo(self)
    self:adjustZOrderByPosY(round_label, 0)
    
    round_label:runAction(cc.Sequence:create(   cc.Spawn:create({
                                                    cc.MoveBy:create(ROUND_DURATION, cc.p(0, 300)),
                                                    cc.FadeOut:create(ROUND_DURATION),
                                                    cc.ScaleBy:create(ROUND_DURATION, 1.5),
                                                }), 
                                                cc.CallFunc:create(function()
                                                    round_label:removeFromParent(true)
                                                    battle_logic:nextState()
                                                end)))

end

function layer:showSkill(action_list)
    self.background:play("move_left", false)
    local actions = {}
    for i,action_data in ipairs(action_list) do
        action_data.skill_config = skill_logic:getActiveSkillConfig(action_data.skill_id)
        local animation_config = skill_logic:getAnimationConfig(action_data.skill_config.animation_id)
        
        table.insert(actions, cc.DelayTime:create(ACTION_DURATION))
        table.insert(actions, cc.CallFunc:create(function()
            self:doSkillProcess(animation_config, action_data)
        end))
    end
        
    table.insert(actions, cc.DelayTime:create(SWITCH_DURATION))
    table.insert(actions, cc.CallFunc:create(function()
        battle_logic:nextState()
    end))
    self:runAction(transition.sequence(actions))
end

function layer:showBuffSettlement(buff_settlement_list)
    -- if #buff_settlement_list > 0 then
    -- else
        battle_logic:nextState()
    -- end
end

function layer:showHpChange(role, skill_data)
    local hp_change_label = cc.Label:createWithTTF(tostring(skill_data.hp_change), "fonts/general.ttf", 30)
        :move(cc.pAdd(cc.p(0, 50), role.init_pos))
        :addTo(self)
    if skill_data.hp_change < 0 then
        hp_change_label:setColor(color.RED)
    else
        hp_change_label:setColor(color.GREEN)
    end
    self:adjustZOrderByPosY(hp_change_label)
    
    local duration = 1
    hp_change_label:runAction(cc.Sequence:create(  cc.Spawn:create({
                                                    cc.MoveBy:create(duration, cc.p(0, 300)),
                                                    cc.FadeOut:create(duration),
                                                    cc.ScaleBy:create(duration, 1.5),
                                                }), 
                                                cc.CallFunc:create(function()
                                                    hp_change_label:removeFromParent(true)
                                                end)))
end

function layer:getAvgPosByTargets(uid, target_skill_list)
    local col_1 = false
    local col_2 = false

    for i,target_skill_data in ipairs(target_skill_list) do
        if i <= 3 then
            col_1 = true
        else
            col_2 = true
        end
    end

    local index = 0
    if col_1 and col_2 then
        index = 2
    elseif col_1 then
        index = 1
    else
        index = 3
    end

    if self:isLeftPlayer(self.player1.uid) then
        return r_avg_pos[index]
    else
        return l_avg_pos[index]
    end
end

function layer:doSkillProcess(animation_config, action_data)
    local move = animation_config.move
    local move_type = animation_config.move_type
    local move_speed = animation_config.move_speed
    local attack = animation_config.attack

    local props_ready_file = animation_config.props_ready_file
    local props_flying_file = animation_config.props_flying_file
    local props_end_file = animation_config.props_end_file

    local multi_props = animation_config.multi_props
    local flying_beg = animation_config.flying_beg
    local flying_end = animation_config.flying_end
    local flying_line = animation_config.flying_line
    local flying_speed = animation_config.flying_speed

    local hurt_effect_file = animation_config.hurt_effect_file

    local attacker_data = action_data.attacker_data
    local target_skill_list = action_data.target_skill_list
    local target_buff_list = action_data.target_buff_list

    local attacker_role = self:getRole(attacker_data.uid, attacker_data.pos)

    local hurt_func = function(target_skill_data)
        local target_role = self:getRole(target_skill_data.uid, target_skill_data.pos)
        if hurt_effect_file then
            target_role:onFrameEvent("hurt_light", function()
                local hurt_effect = helper:createCSNode(string.format("%s.csb", hurt_effect_file), true)
                    :move(cc.pAdd(target_role.init_pos, cc.p(0, 50)))
                    :addTo(self)
                self:adjustZOrderByPosY(hurt_effect, target_role.init_pos.y)
                hurt_effect:play("hurt", false, function()
                    hurt_effect:removeFromParent(true)
                end)
            end)
        end

        target_role:onFrameEvent("hurt_info", function()
            target_role.hp = target_skill_data.hp
            target_role.rage = target_skill_data.rage
            self:showHpChange(target_role, target_skill_data)
        end)

        target_role:play("injured", false, function()
            if target_skill_data.hp > 0 then
                target_role:play("stand_loop", true)
            else
                target_role:play("die", false)
            end
        end)
    end

    local ready_effect
    if props_ready_file then
        --有飞行道具准备动作
        attacker_role:onFrameEvent("ready", function()
            local target_skill_data = target_skill_list[1]
            local target_role = self:getRole(target_skill_data.uid, target_skill_data.pos)
            local pos = attacker_role.init_pos
            if flying_beg == 1 then
                local attack_node = attacker_role.role_node:getChildByName("attack_node")
                pos = cc.pAdd(cc.p(attack_node:getPosition()), attacker_role.init_pos)
            elseif flying_beg == 20 then
                local injured_node = target_role.role_node:getChildByName("injured_node")
                pos = cc.pAdd(cc.p(injured_node:getPosition()), target_role.init_pos)
            elseif flying_beg == 21 then
                pos = self:getAvgPosByTargets(attacker_data.uid, target_skill_list)
            end
            ready_effect = helper:createCSNode(string.format("%s.csb", props_ready_file), true)
            ready_effect:move(pos)
            ready_effect:addTo(self)
            ready_effect:play("play", true)
            self:adjustZOrderByPosY(ready_effect, 0)
        end)
    end

    if props_flying_file then
        --有飞行道具
        attacker_role:onFrameEvent("sprint", function()
            if ready_effect then
                ready_effect:removeFromParent(true)
            end

            -- 多个飞行道具
            local props_list = {}
            for i=1,multi_props and #target_skill_list or 1 do
                local target_skill_data = target_skill_list[i]
                local target_role = self:getRole(target_skill_data.uid, target_skill_data.pos)
                local beg_pos = attacker_role.init_pos
                if flying_beg == 1 then
                    local attack_node = attacker_role.role_node:getChildByName("attack_node")
                    beg_pos = cc.pAdd(cc.p(attack_node:getPosition()), attacker_role.init_pos)
                elseif flying_beg == 20 then
                    local injured_node = target_role.role_node:getChildByName("injured_node")
                    beg_pos = cc.pAdd(cc.p(injured_node:getPosition()), target_role.init_pos)
                elseif flying_beg == 21 then
                    beg_pos = self:getAvgPosByTargets(attacker_data.uid, target_skill_list)
                end

                local end_pos = attacker_role.init_pos
                if flying_end == 1 then
                    local attack_node = attacker_role.role_node:getChildByName("attack_node")
                    end_pos = cc.pAdd(cc.p(attack_node:getPosition()), attacker_role.init_pos)
                elseif flying_end == 20 then
                    local injured_node = target_role.role_node:getChildByName("injured_node")
                    end_pos = cc.pAdd(cc.p(injured_node:getPosition()), target_role.init_pos)
                elseif flying_end == 21 then
                    end_pos = self:getAvgPosByTargets(attacker_data.uid, target_skill_list)
                end

                props_list[i] = helper:createCSNode(string.format("%s.csb", props_flying_file), true)
                props_list[i]:move(beg_pos)
                props_list[i]:addTo(self)
                props_list[i]:play("play", true)
                local rotation = 0
                if beg_pos.x > end_pos.x then
                    rotation = cc.pGetAngleByPos(beg_pos, end_pos)
                else
                    props_list[i]:scale(-1, 1)
                    rotation = cc.pGetAngleByPos(end_pos, beg_pos)
                end
                props_list[i]:setRotation(rotation)
                self:adjustZOrderByPosY(props_list[i], 0)

                local actions = {}
                local finish_callback = function()
                    if props_end_file then
                        local end_effect = helper:createCSNode(string.format("%s.csb", props_end_file), true)
                            :move(end_pos)
                            :addTo(self)
                        self:adjustZOrderByPosY(end_effect, 0)
                        end_effect:play("play", false, function()
                            end_effect:removeFromParent(true)
                        end)
                    end

                    if multi_props then
                        hurt_func(target_skill_data)
                    else
                        for i,target_skill_data in ipairs(target_skill_list) do
                            hurt_func(target_skill_data)
                        end
                    end

                    props_list[i]:removeFromParent(true)
                end

                local flying_duration = cc.pGetDistance(beg_pos,end_pos) / flying_speed
                if flying_line == 1 then
                    table.insert(actions, cc.MoveTo:create(flying_duration, end_pos))
                elseif flying_line == 2 then
                    if beg_pos.x > end_pos.x then
                        props_list[i]:setRotation(rotation + 20)
                        table.insert(actions, cc.Spawn:create({ cc.JumpTo:create(flying_duration, end_pos, 50, 1),
                                                                cc.RotateBy:create(flying_duration, -40)}))
                    else
                        props_list[i]:setRotation(rotation - 20)
                        table.insert(actions, cc.Spawn:create({ cc.JumpTo:create(flying_duration, end_pos, 50, 1),
                                                                cc.RotateBy:create(flying_duration, 40)}))
                    end
                end
                table.insert(actions, cc.CallFunc:create(finish_callback))
                props_list[i]:runAction(transition.sequence(actions))
            end
        end)
    else
        --没有飞行道具
        attacker_role:onFrameEvent("hurt", function()
            local target_skill_data = target_skill_list[1]
            hurt_func(target_skill_data)
        end)
    end

    --攻击动作
    local attack_func = function()
        attacker_role:play(attack, false, function()
            if move and move_type then
                attacker_role:play("move", true)
                if move_type == 1 then
                    local actions = {}
                    table.insert(actions, cc.MoveTo:create(0.2, attacker_role.init_pos))
                    table.insert(actions, cc.CallFunc:create(function()
                        attacker_role:play("stand_loop", true)
                    end))
                    attacker_role:runAction(transition.sequence(actions))
                end
            else
                attacker_role:play("stand_loop", true)
            end
        end)
    end

    --移动动作
    if move and move_type then
        attacker_role:play("move", true)

        local actions = {}
        if move_type == 1 then
            local target_skill_data = target_skill_list[1]
            local target_role = self:getRole(target_skill_data.uid, target_skill_data.pos)

            local beg_pos = attacker_role.init_pos
            local end_pos = target_role.attack_pos
            local move_duration = cc.pGetDistance(beg_pos, end_pos) / move_speed
            table.insert(actions, cc.MoveTo:create(move_duration, end_pos))
        elseif move_type == 2 then
            local beg_pos = attacker_role.init_pos
            local end_pos = self:getAvgPosByTargets(attacker_data.uid, target_skill_list)
            local move_duration = cc.pGetDistance(beg_pos, end_pos) / move_speed
            table.insert(actions, cc.MoveTo:create(move_duration, end_pos))
        end

        table.insert(actions, cc.CallFunc:create(function()
            attack_func()
        end))
        attacker_role:runAction(transition.sequence(actions))
    else
        attack_func()
    end
end

return layer