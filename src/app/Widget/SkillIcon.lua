
local SkillIcon = class("SkillIcon", function()

	local sprite = display.newSprite("#common_new_icon.png")

	return sprite
end)

SkillIcon.TYPE = {
	HERO_SKILL   =  1,
	RUNE_SKILL   =  2,
	TALENT_SKILL =  3,
}

function SkillIcon:ctor(scale)

	if scale then
		self:setScale(scale)
	else
		self:setScale(0.8)
	end
	
	self._skillImage = display.newSprite()
	self._skillImage:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
	self:addChild(self._skillImage)

	self._equipSlotIcon = display.newSprite("#common_equip_icon.png")
	self._equipSlotIcon:setAnchorPoint(0.5, 0)
	self._equipSlotIcon:setPosition(46, 0)
	self._equipSlotIcon:setVisible(false)
	self:addChild(self._equipSlotIcon,10)

end

function SkillIcon:updateInfo(type,iconId)

	local pic = "image/skill/hero/bhs"..iconId..".png"

	if type == self.TYPE.HERO_SKILL then
		pic = "image/skill/hero/hs"..iconId..".png"
	elseif type == self.TYPE.RUNE_SKILL then
		pic = "image/skill/hero/ts"..iconId..".png"
	elseif type == self.TYPE.TALENT_SKILL then
		pic = "image/skill/hero/rs"..iconId..".png"
	end

    self._skillImage:setTexture(pic)

end

function SkillIcon:setEquipEd(bool)
	if self._equipSlotIcon then
		self._equipSlotIcon:setVisible(bool)
	end
end

function SkillIcon:setCount(str)

	if not self._countLabel1 then
		self._countLabel1 = lt.GameLabel.new(str,lt.Constants.FONT_SIZE3,lt.Constants.COLOR.WHITE,{outline = true,outlineColor = lt.Constants.COLOR.EQUIP_BLACK})
		self._countLabel1:setAnchorPoint(1, 0)
		self._countLabel1:setPosition(self:getContentSize().width - 7, 7)
		self:addChild(self._countLabel1)
	else
		self._countLabel1:setVisible(true)
		self._countLabel1:setString(str)
	end

end

function SkillIcon:setGray(isGray)
	if isGray then
		for k,v in pairs(self:getChildren()) do
			if tolua.type(v) == "cc.Sprite" or tolua.type(v) == "cc.Scale9Sprite" then
				self:darkNode(v)
			end
		end
	else
		for k,v in pairs(self:getChildren()) do
			if tolua.type(v) == "cc.Sprite" or tolua.type(v) == "cc.Scale9Sprite" then
				self:unDarkNode(v)
			end
		end
	end
end

function SkillIcon:darkNode(node)
    node:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgram:createWithFilenames("shader/normalTexture.vsh","shader/gray.fsh")))
end

function SkillIcon:unDarkNode(node)
	node:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
end

return SkillIcon