
-- 英灵卡牌(大)
local ServantCardL = class("ServantCardL", function()
	return display.newNode()
end)

ServantCardL.TYPE = {
	BASE   = 0, -- 基础
	PLAYER = 1, -- 玩家卡牌
}

ServantCardL.SIZE = lt.Constants.SERVANT_SIZE.L

ServantCardL._type    = nil
ServantCardL._realId  = nil
ServantCardL._modelId = nil

ServantCardL._qualityBg = nil

ServantCardL._figurePic = nil

function ServantCardL:ctor(empty)
	self:setNodeEventEnabled(true)

	if empty then
		-- 空卡牌
		self._qualityBg = display.newScale9Sprite("#servant_quality.png", 0, 0, self.SIZE)
		self:addChild(self._qualityBg)

		-- 法阵
		local magic = display.newSprite("image/ui/common/common_magic_front.png")
		magic:setScale(0.28)
		magic:setPosition(self._qualityBg:getContentSize().width / 2, self._qualityBg:getContentSize().height / 2)
		self._qualityBg:addChild(magic)
	end
end

function ServantCardL:onExit()
	if self._figurePic then
		-- 移除原画
		cc.Director:getInstance():getTextureCache():removeTextureForKey(self._figurePic)
		self._figurePic = nil
	end
end

function ServantCardL:updateInfo(type, info)
	self._type = type

	if self._type == self.TYPE.BASE then

	elseif self._type == self.TYPE.PLAYER then
		-- 实例
		local playerServant = info

		self._realId  = playerServant:getId()
		self._modelId = playerServant:getModelId()

		if self._qualityBg then
			self._qualityBg:removeFromParent()

			if self._figurePic then
				-- 移除原画
				cc.Director:getInstance():getTextureCache():removeTextureForKey(self._figurePic)
				self._figurePic = nil
			end
		end

		-- 品质背景
		self._qualityBg = display.newScale9Sprite("#servant_quality.png", 0, 0, self.SIZE)
		self:addChild(self._qualityBg)

		-- 原画
		local figureId = playerServant:getFigureId()
		self._figurePic = string.format("image/servant/picl/servantl%d.jpg", figureId)
		local figure = display.newSprite(self._figurePic)
		figure:setPosition(self._qualityBg:getContentSize().width / 2, self._qualityBg:getContentSize().height / 2)
		self._qualityBg:addChild(figure)
	end
end

function ServantCardL:getRealId()
	return self._realId
end

function ServantCardL:getModelId()
	return self._modelId
end

return ServantCardL
