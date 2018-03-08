
-- 英灵卡牌(中)
local ServantCardM = class("ServantCardM", function()
	return display.newNode()
end)

ServantCardM.TYPE = {
	BASE   = 0, -- 基础
	PLAYER = 1, -- 玩家卡牌
}

ServantCardM.SIZE = lt.Constants.SERVANT_SIZE.M

ServantCardM._type    = nil
ServantCardM._realId  = nil
ServantCardM._modelId = nil

ServantCardM._qualityBg = nil
ServantCardM._newFlag   = nil

function ServantCardM:ctor(empty)
	if empty then
		self:setEmpty()
	end
end

function ServantCardM:setEmpty()
	if self._qualityBg then
		self._qualityBg:removeSelf()
	end

	self._qualityBg = display.newScale9Sprite("#servant_quality.png", 0, 0, self.SIZE)
	self:addChild(self._qualityBg)

	-- 法阵
	local magic = display.newSprite("image/ui/common/common_magic_front.png")
	magic:setScale(0.28)
	magic:setPosition(self._qualityBg:getContentSize().width / 2, self._qualityBg:getContentSize().height / 2)
	self._qualityBg:addChild(magic)
end

function ServantCardM:updateInfo(type, info, params)
	self._type = type

	if not self._type then
		self:setEmpty()
	elseif self._type == self.TYPE.BASE then

	elseif self._type == self.TYPE.PLAYER then
		params = params or {}
		
		-- 实例
		local playerServant = info

		self._realId  = playerServant:getId()
		self._modelId = playerServant:getModelId()

		-- 品质背景
		if self._qualityBg then
			self._qualityBg:removeFromParent()
		end

		self._qualityBg = display.newScale9Sprite("#servant_quality.png", 0, 0, self.SIZE)
		self:addChild(self._qualityBg)

		-- 原画
		local figureId = playerServant:getFigureId()
		local pic    = string.format("image/servant/picm/servantm%d.jpg", figureId)
		local figure = display.newSprite(pic)
		figure:setPosition(self._qualityBg:getContentSize().width / 2, self._qualityBg:getContentSize().height / 2)
		self._qualityBg:addChild(figure)

		-- 元素
		local property     = playerServant:getProperty()
		local propertyIcon = lt.PropertyIcon.new(property)
		propertyIcon:setPosition(self._qualityBg:getContentSize().width - 22, self._qualityBg:getContentSize().height - 22)
		self._qualityBg:addChild(propertyIcon)

		-- 信息底板
		local infoBg = display.newSprite("#servant_info_bg.png")
		infoBg:setAnchorPoint(0.5, 0)
		infoBg:setPosition(self._qualityBg:getContentSize().width / 2, 7)
		self._qualityBg:addChild(infoBg)

		-- 名称
		-- local name      = playerServant:getName()
		-- local nameLabel = lt.GameLabel.new(name, 20, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
		-- nameLabel:setPosition(self._qualityBg:getContentSize().width / 2, 44)
		-- self._qualityBg:addChild(nameLabel)

		local bpTitle = display.newSprite("#common_label_bp.png")
		bpTitle:setAnchorPoint(0, 0.5)
		bpTitle:setPosition(12, 44)
		self._qualityBg:addChild(bpTitle)

		local fightPower = playerServant:getFightPower()
		local bpLabel = lt.GameBMLabel.new(fightPower, "#fonts/ui_num_11.fnt")
		bpLabel:setAnchorPoint(0, 0.5)
		bpLabel:setPosition(bpTitle:getPositionX() + bpTitle:getContentSize().width + 8, bpTitle:getPositionY() - 1)
		self._qualityBg:addChild(bpLabel)

		-- local fightPowerLabel = lt.GameLabel.new(name, 20, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
		-- fightPowerLabel:setPosition(self._qualityBg:getContentSize().width / 2, 44)
		-- self._qualityBg:addChild(fightPowerLabel)

		-- 等级
		local levelPic = "#common_label_lv.png"
		if lt.Constants.GDZJ then
			levelPic = "#common_label_lv_gd.png"
		end
		local levelLabelT = display.newSprite(levelPic)
		levelLabelT:setScale(17/22)
		levelLabelT:setAnchorPoint(0, 0.5)
		levelLabelT:setPosition(12, 20)
		self._qualityBg:addChild(levelLabelT)

		local level = playerServant:getLevel()
		local levelLabel = lt.GameBMLabel.new(level, "#fonts/ui_num_10.fnt")
		levelLabel:setScale(17/22)
		levelLabel:setAnchorPoint(0, 0.5)
		levelLabel:setPosition(levelLabelT:getPositionX() + levelLabelT:getContentSize().width * levelLabelT:getScale(), levelLabelT:getPositionY() - 1)
		self._qualityBg:addChild(levelLabel)

		-- 星级
		local star = playerServant:getStar()
		local star1 = math.floor((star + 1) / 2)
		local star2 = star % 2

		for i=1,5 do
			local starBg = display.newSprite("#common_star_empty_1.png")
			starBg:setScale(0.38)
			starBg:setPosition(90 + 19 * (i - 1), 22)
			self._qualityBg:addChild(starBg, 5 - i)

			if star1 >= i then
				if star1 > i or star2 == 0 then
					-- 满星
					local starF = display.newSprite("#common_star_4.png")
					starF:setPosition(starBg:getContentSize().width / 2, starBg:getContentSize().height / 2)
					starBg:addChild(starF)
				else
					-- 半星
					local starF = display.newSprite("#common_star_4_half.png")
					starF:setPosition(starBg:getContentSize().width / 2, starBg:getContentSize().height / 2)
					starBg:addChild(starF)
				end
			end
		end

		-- 上阵标记
		local slot = playerServant:getEquipSlot()
		if slot ~= 0 then
			local formationPic = "#servant_label_ready.png"
			if lt.Constants.GDZJ then
				formationPic = "#servant_label_ready_gd.png"
			end
			local formationFlag = display.newSprite(formationPic)
			formationFlag:setPosition(42, self._qualityBg:getContentSize().height - 12)
			self._qualityBg:addChild(formationFlag, 100)
		end
	end
end

function ServantCardM:getRealId()
	return self._realId
end

function ServantCardM:getModelId()
	return self._modelId
end

function ServantCardM:setNew(show)
	if lt.Constants.GDZJ then
		return
	end

	if show then
		if not self._newFlag then
			self._newFlag = display.newSprite("#common_img_newIcon.png")
			self._newFlag:setPosition(42, self._qualityBg:getContentSize().height - 12)
			self._qualityBg:addChild(self._newFlag, 100)
		end
	else
		if self._newFlag then
			self._newFlag:removeSelf()
			self._newFlag = nil
		end
	end
end

return ServantCardM
