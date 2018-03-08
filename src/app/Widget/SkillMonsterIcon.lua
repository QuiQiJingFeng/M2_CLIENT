
-- 怪物技能Icon
local SkillMonsterIcon = class("SkillMonsterIcon", function()
	return display.newSprite("#common_icon_bg_big.png")
end)

SkillMonsterIcon._skillId = nil

function SkillMonsterIcon:ctor(skillId)
	self:updateInfo(skillId)
end

function SkillMonsterIcon:updateInfo(skillId)
	if not skillId then
		return
	end

	self._skillId = skillId

	local skillInfo = lt.CacheManager:getSkillInfo(self._skillId)
	if not skillInfo then
		return
	end

	local iconId = skillInfo:getIconId()
	if iconId > 0 then
		local pic = "image/skill/monster/ms"..iconId..".png"
		local icon = display.newSprite(pic)
		icon:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self:addChild(icon)
	end
end

function SkillMonsterIcon:getSkillId()
	return self._skillId
end

return SkillMonsterIcon
