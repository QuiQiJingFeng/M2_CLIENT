Game.logic.skill = { handler = {} }

local manager = Game.manager
local config = manager.config

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

local skill = Game.logic.skill
local handler = skill.handler

function skill:getBuffConfig(buff_id)
    if buff_id then
        return config.buff[buff_id]
    end
end

function skill:getActiveSkillConfig(skill_id)
    if skill_id then
        return config.active[skill_id]
    end
end

function skill:getPassiveSkillConfig(skill_id)
    if skill_id then
        return config.passive[skill_id]
    end
end

function skill:getAnimationConfig(animation_id)
    if animation_id then
        return config.animation[animation_id]
    end
end

function skill:getSkillProcess(animation_config)
    if animation_config.animation_type == ACTIVE_EFFECT_TYPE.PHYSICAL_ATTACK then
        return require("skill_process.physical")
    elseif skill_config.effect_type == ACTIVE_EFFECT_TYPE.MAGIC_ATTACK then
        return require("skill_process.magic")
    elseif skill_config.effect_type == ACTIVE_EFFECT_TYPE.RESTORE
        or skill_config.effect_type == ACTIVE_EFFECT_TYPE.RESTORE_OVER_MAX then
        return require("skill_process.restore")
    elseif skill_config.effect_type == ACTIVE_EFFECT_TYPE.REVIVE then
        return require("skill_process.revive")
    else
        return require("skill_process.magic")
    end
end