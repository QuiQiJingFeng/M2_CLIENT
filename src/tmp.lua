local logic = Game.logic
local skill_logic = logic.skill

local RATIO_BASE = 10000

local MAX_ROUND_NUM = 100
local MAX_RAGE = 20

local MAX_PA_RANDOM = 200
local MIN_PA_RANDOM = 100
local MAX_MA_RANDOM = 200
local MIN_MA_RANDOM = 100
local MAX_SP_RATIO_RANDOM = 11500
local MIN_SP_RATIO_RANDOM = 8500
local HP_RATIO = 10

local PASSIVE_SKILL_TYPE = {
    CAPTAIN = 1,    --队长技能
    PASSIVE = 2,    --被动技能
}

local PASSIVE_SKILL_ORDER = {
    PASSIVE_SKILL_TYPE.CAPTAIN,
    PASSIVE_SKILL_TYPE.PASSIVE,
}

local ACTIVE_SKILL_TYPE = {
    MAJOR = 1,      --大技能
    MINOR = 2,      --小技能
}

local ACTIVE_SKIL_ORDER = {
    ACTIVE_SKILL_TYPE.MAJOR,
    ACTIVE_SKILL_TYPE.MINOR,
}

local PASSIVE_EFFECT_TYPE = {
    MAX_HP_RATIO = 1,
    MAX_HP_FIXED = 2,
    PA_RATIO = 3,
    PA_FIXED = 4,
    PD_RATIO = 5,
    PD_FIXED = 6,
    MA_RATIO = 7,
    MA_FIXED = 8,
    MD_RATIO = 9,
    MD_FIXED = 10,
    CC_RATIO = 11,
    CT_RATIO = 12,
    HURT_RATIO = 13,
    DAMAGE_RATIO = 14,
}

local BUFF_EFFECT_TYPE = {
    PA_RATIO = 1,
    PA_FIXED = 2,
    PD_RATIO = 3,
    PD_FIXED = 4,
    MA_RATIO = 5,
    MA_FIXED = 6,
    MD_RATIO = 7,
    MD_FIXED = 8,
    CC_RATIO = 9,
    CT_RATIO = 10,
    HURT_RATIO = 11,
    DAMAGE_RATIO = 12,
    DIZZY = 13,
    POISON = 14,
    RESTORE = 15,
}

local ACTIVE_EFFECT_TYPE = {
    PHYSICAL_ATTACK = 1,
    MAGIC_ATTACK = 2,
    RESTORE = 3,
    RESTORE_OVER_MAX = 4,
    REVIVE = 5,
    BUFF = 6,
    DEBUFF = 7,
    PURIFY = 8,
}

-- 每回合阶段列表
local ACTIVE_STAGE_LIST = {
    {
        name = "复活阶段",
        effect_type_list = {
            [ACTIVE_EFFECT_TYPE.REVIVE] = true,
        },
    },
    {
        name = "净化阶段",
        effect_type_list = {
            [ACTIVE_EFFECT_TYPE.PURIFY] = true,
        },
    },
    {
        name = "Buff阶段",
        effect_type_list = {
            [ACTIVE_EFFECT_TYPE.BUFF] = true,
        },
    },
    {
        name = "恢复阶段",
        effect_type_list = {
            [ACTIVE_EFFECT_TYPE.RESTORE] = true,
            [ACTIVE_EFFECT_TYPE.RESTORE_OVER_MAX] = true,
        },
    },
    {
        name = "Debuff阶段",
        effect_type_list = {
            [ACTIVE_EFFECT_TYPE.DEBUFF] = true,
        },
    },
    {
        name = "攻击阶段",
        effect_type_list = {
            [ACTIVE_EFFECT_TYPE.PHYSICAL_ATTACK] = true,
            [ACTIVE_EFFECT_TYPE.MAGIC_ATTACK] = true,
        },
    },
}

local PASSIVE_TARGET_TYPE = {
    ALL_US = 1,
    ALL_ENEMY = 2,
    SELF = 3,
}

local BUFF_TARGET_TYPE = {
    ALL_US = 1,
    ALL_ENEMY = 2,
    SELF = 3,
}

local TARGET_ORDER_TYPE = {
    POS_FRONT = 1,
    POS_BACK = 2,
}

local BUFF_WORK_TIME = {
    BEFORE = 1,
    AFTER = 2,
}

local PROPERTY_TYPE = {
    MAX_HP = 1,
    HP = 2,
    PA = 3,
    PD = 4,
    MA = 5,
    MD = 6,
    CC = 7,
    CT = 8,
    HURT = 9,
    DAMAGE = 10,
}

local function getBuffPropertyValue(buff_effect_type, role)
    local value = 0
    if role.buff_effect_map[buff_effect_type] then
        for _,buff_info in pairs(role.buff_effect_map[buff_effect_type]) do
            value = value + (buff_info.effect_param or 0)
        end
    end
    return value
end

local function getPropertyValue(property_type, role)
    if property_type == PROPERTY_TYPE.MAX_HP then
        local hp = role.hp
        local passive_ratio = role.passive_effect_map[PASSIVE_EFFECT_TYPE.MAX_HP_RATIO]
        local passive_fixed = role.passive_effect_map[PASSIVE_EFFECT_TYPE.MAX_HP_FIXED]

        return math.ceil((hp + passive_fixed) * (1 + passive_ratio / RATIO_BASE))
    elseif property_type == PROPERTY_TYPE.PA then
        local pa = math.random(role.min_pa + MIN_PA_RANDOM, role.max_pa + MAX_PA_RANDOM)
        local passive_ratio = role.passive_effect_map[PASSIVE_EFFECT_TYPE.PA_RATIO]
        local passive_fixed = role.passive_effect_map[PASSIVE_EFFECT_TYPE.PA_FIXED]
        local buff_ratio = getBuffPropertyValue(BUFF_EFFECT_TYPE.PA_RATIO, role)
        local buff_fixed = getBuffPropertyValue(BUFF_EFFECT_TYPE.PA_FIXED, role)

        return (pa + passive_fixed + buff_fixed) * (1 + (passive_ratio + buff_ratio) / RATIO_BASE)
    elseif property_type == PROPERTY_TYPE.PD then
        local pd = role.pd
        local passive_ratio = role.passive_effect_map[PASSIVE_EFFECT_TYPE.PD_RATIO]
        local passive_fixed = role.passive_effect_map[PASSIVE_EFFECT_TYPE.PD_FIXED]
        local buff_ratio = getBuffPropertyValue(BUFF_EFFECT_TYPE.PD_RATIO, role)
        local buff_fixed = getBuffPropertyValue(BUFF_EFFECT_TYPE.PD_FIXED, role)

        return (pd + passive_fixed + buff_fixed) * (1 + (passive_ratio + buff_ratio) / RATIO_BASE)
    elseif property_type == PROPERTY_TYPE.MA then
        local ma = math.random(role.min_ma + MIN_MA_RANDOM, role.max_ma + MAX_MA_RANDOM)
        local passive_ratio = role.passive_effect_map[PASSIVE_EFFECT_TYPE.MA_RATIO]
        local passive_fixed = role.passive_effect_map[PASSIVE_EFFECT_TYPE.MA_FIXED]
        local buff_ratio = getBuffPropertyValue(BUFF_EFFECT_TYPE.MA_RATIO, role)
        local buff_fixed = getBuffPropertyValue(BUFF_EFFECT_TYPE.MA_FIXED, role)

        return (ma + passive_fixed + buff_fixed) * (1 + (passive_ratio + buff_ratio) / RATIO_BASE)
    elseif property_type == PROPERTY_TYPE.MD then
        local md = role.md
        local passive_ratio = role.passive_effect_map[PASSIVE_EFFECT_TYPE.MD_RATIO]
        local passive_fixed = role.passive_effect_map[PASSIVE_EFFECT_TYPE.MD_FIXED]
        local buff_ratio = getBuffPropertyValue(BUFF_EFFECT_TYPE.MD_RATIO, role)
        local buff_fixed = getBuffPropertyValue(BUFF_EFFECT_TYPE.MD_FIXED, role)

        return (md + passive_fixed + buff_fixed) * (1 + (passive_ratio + buff_ratio) / RATIO_BASE)
    elseif property_type == PROPERTY_TYPE.CC then
        local cc = role.cc
        local passive_ratio = role.passive_effect_map[PASSIVE_EFFECT_TYPE.CC_RATIO]
        local buff_ratio = getBuffPropertyValue(BUFF_EFFECT_TYPE.CC_RATIO, role)

        return (cc + passive_ratio + buff_ratio) / RATIO_BASE
    elseif property_type == PROPERTY_TYPE.CT then
        local ct = role.ct
        local passive_ratio = role.passive_effect_map[PASSIVE_EFFECT_TYPE.CT_RATIO]
        local buff_ratio = getBuffPropertyValue(BUFF_EFFECT_TYPE.CT_RATIO, role)

        return (ct + passive_ratio + buff_ratio) / RATIO_BASE
    elseif property_type == PROPERTY_TYPE.HURT then
        local passive_ratio = role.passive_effect_map[PASSIVE_EFFECT_TYPE.HURT_RATIO]
        local buff_ratio = getBuffPropertyValue(BUFF_EFFECT_TYPE.HURT_RATIO, role)

        return (passive_ratio + buff_ratio) / RATIO_BASE
    elseif property_type == PROPERTY_TYPE.DAMAGE then
        local passive_ratio = role.passive_effect_map[PASSIVE_EFFECT_TYPE.DAMAGE_RATIO]
        local buff_ratio = getBuffPropertyValue(BUFF_EFFECT_TYPE.DAMAGE_RATIO, role)

        return (passive_ratio + buff_ratio) / RATIO_BASE
    end

    return 0
end

local function isDizzy(role)
    local dizzy_buff = role.buff_effect_map[BUFF_EFFECT_TYPE.DIZZY]
    if dizzy_buff and #dizzy_buff > 0 then
        return true
    end
    return false
end

local function initPlayer(player)
    printLog("BATTLE", "初始化玩家数据：%s", player.uid)
    for pos,role in ipairs(player.role_list) do
        role.uid = player.uid
        role.pos = pos
        role.is_captain = pos == 1

        -- 将skill_id转换成skill_config
        role.captain_skill = skill_logic:getPassiveSkillConfig(role.captain)
        role.passive_skill = skill_logic:getPassiveSkillConfig(role.passive)
        role.major_skill = skill_logic:getActiveSkillConfig(role.major)
        role.minor_skill = skill_logic:getActiveSkillConfig(role.minor)

        -- 被动效果map
        role.passive_effect_map = {}
        for _,effect_type in pairs(PASSIVE_EFFECT_TYPE) do
            role.passive_effect_map[effect_type] = 0
        end

        -- Buff效果map
        role.buff_effect_map = {}

        -- 怒气值
        role.rage = 0

        -- 状态
        role.is_dead = role.hp == 0
    end

    player.sp_ratio = math.random(MIN_SP_RATIO_RANDOM, MAX_SP_RATIO_RANDOM) / RATIO_BASE
    printLog("BATTLE", "团队先攻修正值：%f", player.sp_ratio)
end

-- 计算战力
local function calcFightingCapacity(player)
    printLog("BATTLE", "计算战斗力：%s", player.uid)
    local fc = 0
    for index,role in ipairs(player.role_list) do
        role.fc = math.ceil(role.hp / HP_RATIO + ((role.max_pa + role.min_pa + role.max_ma + role.min_ma) / 2) * (role.cc * role.ct + 1 - role.cc) + role.pd + role.md)
        fc = fc + role.fc
        printLog("BATTLE", "位置：%d, 战力：%d", role.pos, role.fc)
    end

    player.fc = fc
    printLog("BATTLE", "团队战斗力：%d", player.fc)
end

-- 计算先攻值
local function calcSpeed(player)
    printLog("BATTLE", "计算先攻值", player.uid)
    local sp = 0
    for index,role in ipairs(player.role_list) do
        role.sp = math.ceil(role.fc * role.sp_ratio)
        sp = sp + role.sp
        printLog("BATTLE", "位置：%d, 先攻值：%d", role.pos, role.sp)
    end

    player.sp = sp * player.sp_ratio
    printLog("BATTLE", "团队先攻值：%d", player.sp)
end

-- 计算血量上限
local function calcMaxHP(player)
    for index,role in ipairs(player.role_list) do
        role.max_hp = getPropertyValue(PROPERTY_TYPE.MAX_HP, role)
        role.hp = role.max_hp
    end
end

-- 根据速度值获取攻击顺序
local function getAttackOrderList(role_list)
    local order_list = {}

    for index,role in ipairs(role_list) do
        if not role.is_dead then
            if #order_list == 0 then
                table.insert(order_list, index)
            else
                local sp = tonumber(role.sp) or 0
                for order_index,order_role_index in ipairs(order_list) do
                    local order_sp = tonumber(role_list[order_role_index].sp) or 0
                    if order_sp < sp then
                        table.insert(order_list, order_index, index)
                        break
                    elseif order_index == #order_list then
                        table.insert(order_list, index)
                        break
                    end
                end
            end
        end
    end

    return order_list
end

-- 获取技能目标
local function getPassiveTargetList(skill_config, attacker, us, enemy)
    local target_list = {}

    if skill_config then
        local target_type = skill_config.target_type
        if target_type == PASSIVE_TARGET_TYPE.ALL_US then
            printLog("BATTLE", "技能目标：我方全体")
            target_list = us.role_list
        elseif target_type == PASSIVE_TARGET_TYPE.ALL_ENEMY then
            printLog("BATTLE", "技能目标：敌方全体")
            target_list = enemy.role_list
        elseif target_type == PASSIVE_TARGET_TYPE.SELF then
            printLog("BATTLE", "技能目标：自身")
            table.insert(target_list, attacker)
        end
    end
            
    return target_list
end

local function checkHp(role)
    if role.hp <= 0 then
        role.is_dead = true
        role.buff_effect_map = {}
        role.rage = 0
    end
end

local function checkWinner(us, enemy)
    local is_all_dead = true
    for i,role in ipairs(enemy.role_list) do
        role.is_done = false

        if not role.is_dead then
            is_all_dead = false
        end
    end

    if is_all_dead then
        return us
    end
end

-- 释放被动技能
local function doPassiveSkill(skill_config, attacker, target_list, skill_list)
    if not skill_config then
        return
    end

    if not attacker then
        return
    end

    if not target_list or #target_list == 0 then
        return
    end

    skill_list = skill_list or {}
    skill_list[skill_config.skill_id] = true

    for _,target in ipairs(target_list) do
        local effect_type = skill_config.effect_type
        local effect_param = skill_config.effect_param or 0

        printLog("BATTLE", "发动方位置：%d, 目标位置：%d, 效果类型：%d, 原数值：%d, 效果参数：%d", attacker.pos, target.pos, effect_type, target.passive_effect_map[effect_type], effect_param)
        target.passive_effect_map[effect_type] = target.passive_effect_map[effect_type] + effect_param
    end

    if skill_config.additional_id and not skill_list[skill_config.additional_id] then
        local additional_skill_config = skill_logic:getPassiveSkillConfig(skill_config.additional_id)
        if additional_skill_config then
            doPassiveSkill(additional_skill_config, attacker, target_list, skill_list)
        end
    end
end

-- 获取技能目标
local function getActiveTargetList(skill_config, attacker, us, enemy)
    local active_target_list = {}

    if skill_config then
        local effect_type = skill_config.effect_type
        local target_num = skill_config.target_num or 1
        local target_order = skill_config.target_order
        if effect_type == ACTIVE_EFFECT_TYPE.PHYSICAL_ATTACK or effect_type == ACTIVE_EFFECT_TYPE.MAGIC_ATTACK then
            printLog("BATTLE", "技能目标：敌方未死亡的单位")
            for i,role in ipairs(enemy.role_list) do
                -- 未死亡
                if not role.is_dead then
                    table.insert(active_target_list, role)
                end
            end
        elseif effect_type == ACTIVE_EFFECT_TYPE.RESTORE or effect_type == ACTIVE_EFFECT_TYPE.RESTORE_OVER_MAX then
            printLog("BATTLE", "技能目标：我方未死亡、未满血的单位")
            for i,role in ipairs(us.role_list) do
                -- 未死亡，未满血
                if not role.is_dead and role.hp < role.max_hp then
                    table.insert(active_target_list, role)
                end
            end
        elseif effect_type == ACTIVE_EFFECT_TYPE.REVIVE then
            printLog("BATTLE", "技能目标：我方已死亡的单位")
            for i,role in ipairs(us.role_list) do
                -- 已死亡
                if role.is_dead then
                    table.insert(active_target_list, role)
                end
            end
        elseif effect_type == ACTIVE_EFFECT_TYPE.PURIFY then
            printLog("BATTLE", "技能目标：我方有可净化Buff的单位")
            for i,role in ipairs(us.role_list) do
                -- 未死亡，有可净化BUFF
                for _,buff_list in pairs(role.buff_effect_map) do
                    local has_found = false
                    for index=#buff_list,1,-1 do
                        local buff_info = buff_list[index]
                        if buff_info.could_purify then
                            table.insert(active_target_list, role)
                            has_found = true
                            break
                        end
                    end
                    if has_found then
                        break
                    end
                end
            end
        elseif effect_type == ACTIVE_EFFECT_TYPE.BUFF or effect_type == ACTIVE_EFFECT_TYPE.DEBUFF then
            printLog("BATTLE", "技能目标：无")
        else
            printError("未知的技能类型")
        end

        if target_num < #active_target_list then
            -- 排序
            table.sort(active_target_list, function(a, b)
                -- 优先排序
                if target_order == TARGET_ORDER_TYPE.POS_FRONT then
                    if a.pos <= 3 and b.pos > 3 then
                        return true
                    elseif b.pos <= 3 and a.pos > 3 then
                        return false
                    end
                elseif target_order == TARGET_ORDER_TYPE.POS_BACK then
                    if a.pos <= 3 and b.pos > 3 then
                        return false
                    elseif b.pos <= 3 and a.pos > 3 then
                        return true
                    end
                end

                -- 血量排序
                if effect_type == ACTIVE_EFFECT_TYPE.PHYSICAL_ATTACK or 
                    effect_type == ACTIVE_EFFECT_TYPE.MAGIC_ATTACK or
                    effect_type == ACTIVE_EFFECT_TYPE.RESTORE then
                    return a.hp < b.hp
                end

                -- 位置排序
                return a.pos < b.pos
            end)

            -- 修正目标数量
            for index = #active_target_list, target_num + 1, -1 do
                table.remove(active_target_list, index)
            end
        end
    end

    return active_target_list
end

-- 释放主动技能
local function doActiveSkill(skill_config, attacker, target_list)
    if not skill_config then
        return
    end

    if not attacker then
        return
    end

    if not target_list or #target_list == 0 then
        return
    end

    local skill_id = skill_config.skill_id
    local effect_type = skill_config.effect_type
    local effect_param = skill_config.effect_param or 0
    local rage = skill_config.rage or 0

    local old_rage = attacker.rage
    attacker.rage = math.min(attacker.rage + rage, MAX_RAGE)
    printLog("BATTLE", "发动方位置：%d，原怒气值：%d，最终怒气值：%d", attacker.pos, old_rage, attacker.rage)

    local attacker_data = {}
    attacker_data.uid = attacker.uid
    attacker_data.pos = attacker.pos
    attacker_data.rage = attacker.rage

    local target_skill_list = {}
    for _,target in ipairs(target_list) do
        local target_skill_data = {}
        target_skill_data.uid = target.uid
        target_skill_data.pos = target.pos
        if effect_type == ACTIVE_EFFECT_TYPE.PHYSICAL_ATTACK then
            local attacker_pa = getPropertyValue(PROPERTY_TYPE.PA, attacker)
            local attacker_damage = getPropertyValue(PROPERTY_TYPE.DAMAGE, attacker)

            local target_pd = getPropertyValue(PROPERTY_TYPE.PD, target)
            local target_hurt = getPropertyValue(PROPERTY_TYPE.HURT, target)

            local attacker_cc = getPropertyValue(PROPERTY_TYPE.CC, attacker)
            local attacker_ct = getPropertyValue(PROPERTY_TYPE.CT, attacker)
            local random_cc = math.random(RATIO_BASE) / RATIO_BASE

            local damage = (attacker_pa - target_pd) * effect_param / RATIO_BASE
            damage = damage * (1 + attacker_damage)
            damage = damage * (1 + target_hurt)

            damage = math.max(1, damage)

            if random_cc <= attacker_cc then
                damage = damage * attacker_ct
            end
            damage = math.ceil(damage)

            target.hp = math.max(0, target.hp - damage)
            checkHp(target)

            printLog("BATTLE", "物理攻击，技能ID：%d，技能参数：%d，物攻：%d，伤害加成：%f，物防：%d，受伤加成：%f，暴击率：%f，暴击判定值：%f，暴击倍数：%f，最终伤害值：%d，目标最终血量：%d", 
                skill_id, effect_param, attacker_pa, attacker_damage, target_pd, target_hurt, attacker_cc, random_cc, attacker_ct, damage, target.hp)
            
            -- 增加怒气
            local old_rage = target.rage
            target.rage = math.min(target.rage + target.rage_add, MAX_RAGE)
            printLog("BATTLE", "目标位置：%d，效果类型：%d，效果参数：%d，原怒气值：%d，最终怒气值：%d", 
                target.pos, effect_type, effect_param, old_rage, target.rage)

            target_skill_data.hp_change = -damage
            target_skill_data.hp = target.hp
            target_skill_data.rage = target.rage

        elseif effect_type == ACTIVE_EFFECT_TYPE.MAGIC_ATTACK then
            local attacker_ma = getPropertyValue(PROPERTY_TYPE.MA, attacker)
            local attacker_damage = getPropertyValue(PROPERTY_TYPE.DAMAGE, attacker)

            local target_md = getPropertyValue(PROPERTY_TYPE.MD, target)
            local target_hurt = getPropertyValue(PROPERTY_TYPE.HURT, target)

            local attacker_cc = getPropertyValue(PROPERTY_TYPE.CC, attacker)
            local attacker_ct = getPropertyValue(PROPERTY_TYPE.CT, attacker)
            local random_cc = math.random(RATIO_BASE) / RATIO_BASE

            local damage = (attacker_ma - target_md) * effect_param / RATIO_BASE
            damage = damage * (1 + attacker_damage)
            damage = damage * (1 + target_hurt)

            damage = math.max(1, damage)

            if random_cc <= attacker_cc then
                damage = damage * attacker_ct
            end
            damage = math.ceil(damage)

            target.hp = math.max(0, target.hp - damage)
            checkHp(target)

            printLog("BATTLE", "魔法攻击，技能ID：%d，技能参数：%d，魔攻：%d，伤害加成：%f，魔防：%d，受伤加成：%f，暴击率：%f，暴击判定值：%f，暴击倍数：%f，最终伤害值：%d，目标最终血量：%d", 
                skill_id, effect_param, attacker_ma, attacker_damage, target_md, target_hurt, attacker_cc, random_cc, attacker_ct, damage, target.hp)
            
            -- 增加怒气
            local old_rage = target.rage
            target.rage = math.min(target.rage + target.rage_add, MAX_RAGE)
            printLog("BATTLE", "目标位置：%d，效果类型：%d，效果参数：%d，原怒气值：%d，最终怒气值：%d", 
                target.pos, effect_type, effect_param, old_rage, target.rage)

            target_skill_data.hp_change = -damage
            target_skill_data.hp = target.hp
            target_skill_data.rage = target.rage

        elseif effect_type == ACTIVE_EFFECT_TYPE.RESTORE then
            local attacker_ma = getPropertyValue(PROPERTY_TYPE.MA, attacker)
            local restore = math.ceil(attacker_ma * effect_param / RATIO_BASE)
            target.hp = math.min(target.hp + restore, target.max_hp)
            checkHp(target)
            printLog("BATTLE", "恢复，技能ID：%d，技能参数：%d，魔攻：%d，最终恢复值：%d，目标最终血量：%d", 
                skill_id, effect_param, attacker_ma, restore, target.hp)

            target_skill_data.hp_change = restore
            target_skill_data.hp = target.hp

        elseif effect_type == ACTIVE_EFFECT_TYPE.RESTORE_OVER_MAX then
            local attacker_ma = getPropertyValue(PROPERTY_TYPE.MA, attacker)
            local restore = math.ceil(attacker_ma * effect_param / RATIO_BASE)
            target.hp = target.hp + restore
            checkHp(target)
            printLog("BATTLE", "恢复（可超上限），技能ID：%d，技能参数：%d，魔攻：%d，最终恢复值：%d，目标最终血量：%d", 
                skill_id, effect_param, attacker_ma, restore, target.hp)

            target_skill_data.hp_change = restore
            target_skill_data.hp = target.hp

        elseif effect_type == ACTIVE_EFFECT_TYPE.REVIVE then
            local attacker_ma = getPropertyValue(PROPERTY_TYPE.MA, attacker)
            local restore = math.ceil(attacker_ma * effect_param / RATIO_BASE)
            target.hp = math.min(target.hp + restore, target.max_hp)
            checkHp(target)
            printLog("BATTLE", "复活，技能ID：%d，技能参数：%d，魔攻：%d，最终恢复值：%d，目标最终血量：%d", 
                skill_id, effect_param, attacker_ma, restore, target.hp)

            target_skill_data.hp_change = restore
            target_skill_data.hp = target.hp

        elseif effect_type == ACTIVE_EFFECT_TYPE.PURIFY then
            local purify_list = {}
            printLog("BATTLE", "净化，技能ID：%d，目标位置：%d", skill_id, target.pos)
            for effect_type,buff_list in pairs(target.buff_effect_map) do
                for index=#buff_list,1,-1 do
                    local buff_info = buff_list[index]
                    if buff_info.could_purify then
                        table.remove(buff_list, index)
                        table.insert(purify_list, buff_info.buff_id)
                    end
                end
            end

            target_skill_data.purify_list = purify_list
        elseif effect_type == ACTIVE_EFFECT_TYPE.BUFF then
        elseif effect_type == ACTIVE_EFFECT_TYPE.DEBUFF then
        end
        table.insert(target_skill_list, target_skill_data)
    end

    return attacker_data, target_skill_list
end

-- 获取Buff目标
local function getBuffTargetList(skill_config, attacker, us, enemy, active_target_list)
    local buff_target_list = {}

    if skill_config then
        -- 获取Buff目标
        local buff_target_type = skill_config.buff_target
        local buff_num = skill_config.buff_num or 1
        if buff_target_type == BUFF_TARGET_TYPE.ALL_US then
            printLog("BATTLE", "技能Buff目标：我方全体")
            buff_target_list = us.role_list
        elseif buff_target_type == BUFF_TARGET_TYPE.ALL_ENEMY then
            printLog("BATTLE", "技能Buff目标：敌方全体")
            buff_target_list = enemy.role_list
        elseif buff_target_type == BUFF_TARGET_TYPE.SELF then
            printLog("BATTLE", "技能Buff目标：自身")
            table.insert(buff_target_list, attacker)
        else
            printLog("BATTLE", "技能Buff目标：与技能目标一致")
            buff_target_list = active_target_list
        end
    end

    return buff_target_list
end

-- 释放Buff
local function doBuff(buff_config, probability, attacker, target_list)
    if not buff_config then
        return
    end

    if not attacker then
        return
    end

    if not target_list or #target_list == 0 then
        return
    end
    local buff_id = buff_config.buff_id or 0
    local group_id = buff_config.group_id or 0
    local effect_type = buff_config.effect_type
    local effect_param = buff_config.effect_param or 0
    local effect_round = buff_config.effect_round or 1
    local could_purify = buff_config.could_purify == true

    local probability = probability or 0

    local target_buff_list = {}
    for _,target in ipairs(target_list) do
        local random_probability = math.random(RATIO_BASE)
        if random_probability <= probability then
            printLog("BATTLE", "附加Buff，发动方位置：%d，目标位置：%d，BuffID：%d，附加概率：%d，附加盘定制：%d，效果类型：%d，效果参数：%d", attacker.pos, target.pos, buff_id, probability, random_probability, effect_type, effect_param)

            for effect_type,buff_list in pairs(target.buff_effect_map) do
                for index=#buff_list,1,-1 do
                    local buff_info = buff_list[index]
                    if buff_info.group_id == group_id then
                        table.remove(buff_list, index)
                    end
                end
            end

            local buff_info = {
                buff_id = buff_id,
                group_id = group_id,
                effect_type = effect_type,
                effect_param = effect_param,
                effect_round = effect_round,
                could_purify = could_purify,
            }
            target.buff_effect_map[effect_type] = target.buff_effect_map[effect_type] or {}
            table.insert(target.buff_effect_map[effect_type], buff_info)

            local target_buff_data = {}
            target_buff_data.uid = target.uid
            target_buff_data.pos = target.pos
            table.insert(target_buff_list, target_buff_data)
        else
            printLog("BATTLE", "附加Buff失败，发动方位置：%d，目标位置：%d，BuffID：%d，附加概率：%d，附加盘定制：%d", attacker.pos, target.pos, buff_id, probability, random_probability)
        end
    end

    return target_buff_list
end

-- 结算Buff
local function doBuffSettlement(player)
    printLog("BATTLE", "----------结算Buff----------")
    local buff_settlement_list = {}
    for _,role in ipairs(player.role_list) do
        -- 恢复Buff
        if role.buff_effect_map[BUFF_EFFECT_TYPE.RESTORE] then
            for _,restore_buff_info in ipairs(role.buff_effect_map[BUFF_EFFECT_TYPE.RESTORE]) do
                local buff_id = restore_buff_info.buff_id
                local effect_param = restore_buff_info.effect_param or 0
                local attacker_max_hp = getPropertyValue(PROPERTY_TYPE.MAX_HP, role)
                local restore = math.ceil(attacker_max_hp * effect_param / RATIO_BASE)
                role.hp = math.min(role.hp + restore, role.max_hp)
                checkHp(role)
                printLog("BATTLE", "恢复Buff，位置：%d，BuffID：%d，技能参数：%d，血量上限：%d，最终恢复值：%d，目标最终血量：%d", 
                    role.pos, buff_id, effect_param, attacker_max_hp, restore, role.hp)

                local buff_settlement_data = {}
                buff_settlement_data.uid = role.uid
                buff_settlement_data.pos = role.pos
                buff_settlement_data.buff_id = buff_id
                buff_settlement_data.type = BUFF_EFFECT_TYPE.POISON
                buff_settlement_data.hp_change = restore
                buff_settlement_data.hp = role.hp
                table.insert(buff_settlement_list, buff_settlement_data)
            end
        end

        -- 中毒Buff
        if role.buff_effect_map[BUFF_EFFECT_TYPE.POISON] then
            for _,poison_buff_info in ipairs(role.buff_effect_map[BUFF_EFFECT_TYPE.POISON]) do
                local buff_id = poison_buff_info.buff_id
                local effect_param = poison_buff_info.effect_param or 0
                local attacker_max_hp = getPropertyValue(PROPERTY_TYPE.MAX_HP, role)
                local poison = math.ceil(attacker_max_hp * effect_param / RATIO_BASE)
                role.hp = math.max(role.hp - poison, 0)
                checkHp(role)
                printLog("BATTLE", "中毒Buff，位置：%d，BuffID：%d，技能参数：%d，血量上限：%d，中毒伤害：%d，目标最终血量：%d", 
                    role.pos, buff_id, effect_param, attacker_max_hp, poison, role.hp)

                local buff_settlement_data = {}
                buff_settlement_data.uid = role.uid
                buff_settlement_data.pos = role.pos
                buff_settlement_data.buff_id = buff_id
                buff_settlement_data.hp_change = -poison
                buff_settlement_data.hp = role.hp
                table.insert(buff_settlement_list, buff_settlement_data)
            end
        end

        -- 所有Buff持续回合减一，并删除失效的Buff
        for effect_type,buff_list in pairs(role.buff_effect_map) do
            for index=#buff_list,1,-1 do
                local buff_info = buff_list[index]
                local buff_id = buff_info.buff_id
                local effect_round = buff_info.effect_round

                if effect_round > 0 then
                    buff_info.effect_round = effect_round - 1
                    printLog("BATTLE", "Buff持续时间，位置：%d，BuffID：%d，剩余回合：%d", role.pos, buff_id, buff_info.effect_round)
                else
                    table.remove(buff_list, index)
                    printLog("BATTLE", "Buff失效，位置：%d，BuffID：%d", role.pos, buff_id)
                end
            end
        end
    end
    return buff_settlement_list
end

-- 被动技能阶段
local function doPassiveStage(us, enemy)
    for _,role in ipairs(us.role_list) do
        for _,passive_skill_type in ipairs(PASSIVE_SKILL_ORDER) do
            local skill_config
            if passive_skill_type == PASSIVE_SKILL_TYPE.CAPTAIN and role.is_captain then
                skill_config = role.captain_skill
            elseif passive_skill_type == PASSIVE_SKILL_TYPE.PASSIVE then
                skill_config = role.passive_skill
            end

            if skill_config then
                printLog("BATTLE", "发动方位置：%d，类型：%d，被动技能ID：%d", role.pos, passive_skill_type, skill_config.skill_id)
                local target_list = getPassiveTargetList(skill_config, role, us, enemy)
                printLog("BATTLE", "目标数量：%d", #target_list)
                if #target_list > 0 then
                    doPassiveSkill(skill_config, role, target_list)
                end
            end
        end
    end
end

-- 主动技能阶段
local function doActiveStage(us, enemy)
    local action_list = {}
    for _, active_stage_info in ipairs(ACTIVE_STAGE_LIST) do
        printLog("BATTLE", "----------%s----------", active_stage_info.name)
        local order_list = getAttackOrderList(us.role_list)
        for _,role_index in ipairs(order_list) do
            local attacker = us.role_list[role_index]
            if not attacker.is_done and not isDizzy(attacker) then
                for _,active_skill_type in ipairs(ACTIVE_SKIL_ORDER) do
                    local skill_config
                    if active_skill_type == ACTIVE_SKILL_TYPE.MAJOR then
                        skill_config = attacker.major_skill
                    elseif active_skill_type == ACTIVE_SKILL_TYPE.MINOR then
                        skill_config = attacker.minor_skill
                    end

                    if skill_config and active_stage_info.effect_type_list[skill_config.effect_type] and (attacker.rage + skill_config.rage) > 0 then
                        printLog("BATTLE", "发动方位置：%d，类型：%d，主动技能ID：%d", attacker.pos, active_skill_type, skill_config.skill_id)
                        local active_target_list = getActiveTargetList(skill_config, attacker, us, enemy)
                        if #active_target_list > 0 then
                            local action_data = {}
                            action_data.skill_id = skill_config.skill_id
                            action_data.buff_id = skill_config.buff_id
                            printLog("BATTLE", "目标数量：%d", #active_target_list)
                            local buff_config = skill_logic:getBuffConfig(skill_config.buff_id)
                            local buff_target_list = {}
                            if buff_config then
                                buff_target_list = getBuffTargetList(skill_config, attacker, us, enemy, active_target_list)
                                printLog("BATTLE", "附加Buff：%d, 目标数量：%d", skill_config.buff_id, #buff_target_list)
                            end

                            if #buff_target_list > 0 and skill_config.buff_work_time == BUFF_WORK_TIME.BEFORE then
                                action_data.target_buff_list = doBuff(buff_config, skill_config.buff_probability, attacker, buff_target_list)
                            end

                            action_data.attacker_data, action_data.target_skill_list = doActiveSkill(skill_config, attacker, active_target_list)

                            if #buff_target_list > 0 and skill_config.buff_work_time == BUFF_WORK_TIME.AFTER then
                                action_data.target_buff_list = doBuff(buff_config, skill_config.buff_probability, attacker, buff_target_list)
                            end

                            attacker.is_done = true
                            table.insert(action_list, action_data)
                            break
                        else
                            printLog("BATTLE", "目标数量不足")
                        end
                    end
                end
            end
        end
    end
    return action_list
end

local function recordPlayerInfo(player)
    local player_info = {}

    player_info.uid = player.uid
    player_info.name = player.name
    player_info.role_list = {}
    for i,role_info in ipairs(player.role_list) do
        table.insert(player_info.role_list, {
            pos = role_info.pos,
            rid = role_info.rid,
            wid = role_info.wid,
            max_hp = role_info.max_hp,
            hp = role_info.hp,
            captain = role_info.captain,
            passive = role_info.passive,
            major = role_info.major,
            minor = role_info.minor,
        })
    end

    return player_info
end

local battle = {}
function battle:doBattle(player1, player2)
    local player1 = {
        uid = "U1",
        name = "玩家1",
        role_list = {
            { rid = 1, wid = 1, max_hp = 2000, hp = 2000, max_pa = 200, min_pa = 200, max_ma = 200, min_ma = 200, pd = 200, md = 200, cc = 4000, ct = 15000, sp_ratio = 4, rage_add = 2, major = 1201011, minor = 1301011, },
            { rid = 1, wid = 1, max_hp = 2000, hp = 2000, max_pa = 200, min_pa = 200, max_ma = 200, min_ma = 200, pd = 200, md = 200, cc = 4000, ct = 15000, sp_ratio = 3, rage_add = 2, major = 1201011, minor = 1301011, },
            { rid = 1, wid = 1, max_hp = 1000, hp = 1000, max_pa = 100, min_pa = 100, max_ma = 100, min_ma = 100, pd = 100, md = 100, cc = 2000, ct = 15000, sp_ratio = 2, rage_add = 1, major = 1201011, minor = 1301011, },
            { rid = 2, wid = 1, max_hp = 1000, hp = 1000, max_pa = 100, min_pa = 100, max_ma = 100, min_ma = 100, pd = 100, md = 100, cc = 2000, ct = 15000, sp_ratio = 2, rage_add = 1, major = 1202011, minor = 1302011, },
            { rid = 2, wid = 1, max_hp = 1000, hp = 1000, max_pa = 100, min_pa = 100, max_ma = 100, min_ma = 100, pd = 100, md = 100, cc = 2000, ct = 15000, sp_ratio = 2, rage_add = 1, major = 1202011, minor = 1302011, },
            { rid = 2, wid = 1, max_hp = 1000, hp = 1000, max_pa = 100, min_pa = 100, max_ma = 100, min_ma = 100, pd = 100, md = 100, cc = 2000, ct = 15000, sp_ratio = 2, rage_add = 1, major = 1202011, minor = 1302011, },
        },
    }
    local player2 = {
        uid = "U2",
        name = "玩家2",
        role_list = {
            { rid = 3, wid = 1, max_hp = 2000, hp = 2000, max_pa = 200, min_pa = 200, max_ma = 200, min_ma = 200, pd = 200, md = 200, cc = 4000, ct = 15000, sp_ratio = 3, rage_add = 2, major = 1201011, minor = 1301011, },
            { rid = 3, wid = 1, max_hp = 2000, hp = 2000, max_pa = 200, min_pa = 200, max_ma = 200, min_ma = 200, pd = 200, md = 200, cc = 4000, ct = 15000, sp_ratio = 3, rage_add = 2, major = 1201011, minor = 1301011, },
            { rid = 3, wid = 1, max_hp = 1000, hp = 1000, max_pa = 100, min_pa = 100, max_ma = 100, min_ma = 100, pd = 100, md = 100, cc = 2000, ct = 15000, sp_ratio = 2, rage_add = 1, major = 1201011, minor = 1301011, },
            { rid = 4, wid = 1, max_hp = 1000, hp = 1000, max_pa = 100, min_pa = 100, max_ma = 100, min_ma = 100, pd = 100, md = 100, cc = 2000, ct = 15000, sp_ratio = 2, rage_add = 1, major = 1202011, minor = 1302011, },
            { rid = 4, wid = 1, max_hp = 1000, hp = 1000, max_pa = 100, min_pa = 100, max_ma = 100, min_ma = 100, pd = 100, md = 100, cc = 2000, ct = 15000, sp_ratio = 2, rage_add = 1, major = 1202011, minor = 1302011, },
            { rid = 4, wid = 1, max_hp = 1000, hp = 1000, max_pa = 100, min_pa = 100, max_ma = 100, min_ma = 100, pd = 100, md = 100, cc = 2000, ct = 15000, sp_ratio = 2, rage_add = 1, major = 1202011, minor = 1302011, },
        },
    }

    -- 初始化玩家数据
    printLog("BATTLE", "==========初始化==========")
    initPlayer(player1)
    initPlayer(player2)

    -- 计算被动技能
    printLog("BATTLE", "==========计算被动==========")
    doPassiveStage(player1, player2)
    doPassiveStage(player2, player1)

    -- 计算战力
    printLog("BATTLE", "==========计算战力==========")
    calcFightingCapacity(player1)
    calcFightingCapacity(player2)

    -- 计算血量上限
    printLog("BATTLE", "==========计算血量上限==========")
    calcMaxHP(player1)
    calcMaxHP(player2)

    -- 计算先攻值
    printLog("BATTLE", "==========计算先攻值==========")
    calcSpeed(player1)
    calcSpeed(player2)

    -- 判断先后手
    printLog("BATTLE", "==========判定先后手==========")
    local first, second = player1, player2
    if player2.sp > player1.sp then
        first, second = player2, player1
    end
    printLog("BATTLE", "先手：%s", first.uid)
    printLog("BATTLE", "后手：%s", second.uid)

    -- 记录玩家数据
    local battle_data = {}
    battle_data.player1 = recordPlayerInfo(player1)
    battle_data.player2 = recordPlayerInfo(player2)
    battle_data.round_list = {}

    -- 循环回合
    local winner
    for round_num = 1, MAX_ROUND_NUM do
        printLog("BATTLE", "==========第%d回合==========", round_num)
        local round_data = {}
        table.insert(battle_data.round_list, round_data)

        round_data[1] = {}
        round_data[1].action_list = doActiveStage(first, second)
        round_data[1].buff_settlement_list = doBuffSettlement(first)
        winner = checkWinner(first, second)
        if winner then
            break
        end

        printLog("BATTLE", "交换出手方")

        round_data[2] = {}
        round_data[2].action_list = doActiveStage(second, first)
        round_data[2].buff_settlement_list = doBuffSettlement(second)
        winner = checkWinner(second, first)
        if winner then
            break
        end
    end

    printLog("BATTLE", "==========结算==========")
    if not winner then
        print("BATTLE", "未分出胜负，默认挑战方胜利")
        winner = player1
    end
    printLog("BATTLE", "胜利方：%s", winner.uid)

    return battle_data
end

return battle