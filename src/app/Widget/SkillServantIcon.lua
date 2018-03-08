
-- 英灵技能Icon
local SkillServantIcon = class("SkillServantIcon", function()
	return display.newNode()
end)

SkillServantIcon._skillId = nil

function SkillServantIcon:ctor(skillId)
	local bg = display.newSprite("#common_new_icon.png")
	bg:setScale(66/80)
	self:addChild(bg)

	self:updateInfo(skillId)
end

function SkillServantIcon:updateInfo(skillId)
	if not skillId then
		return
	end

	self._skillId = skillId

	local skillServantInfo = lt.CacheManager:getSkillServantInfo(self._skillId)
	if not skillServantInfo then
		return
	end

	local iconId = skillServantInfo:getIconId()

	local pic = "image/skill/servant/ss"..iconId..".png"
	local icon = display.newSprite(pic)
	icon:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
	self:addChild(icon)

	-- 等级
	local levelStr = string.format("%s%d", lt.StringManager:getString("STRING_COMMON_LEVEL_SIMPLE"), skillServantInfo:getLevel())
	local level = lt.GameLabel.new(levelStr, 14, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
	level:setPosition(self:getContentSize().width / 2+2, self:getContentSize().height / 2 - 20)
	self:addChild(level)
end

function SkillServantIcon:getSkillId()
	return self._skillId
end

return SkillServantIcon
