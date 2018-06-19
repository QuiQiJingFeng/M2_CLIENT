
--设置层
local MjLieOutFaceItem = class("MjLieOutFaceItem")

function MjLieOutFaceItem:ctor(CpgDirection)
	self._rootNode = nil
	if CpgDirection == lt.Constants.DIRECTION.XI then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjLieLeftOutFaceItem.csb")
	elseif CpgDirection == lt.Constants.DIRECTION.NAN then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjLieDownOutFaceItem.csb")
	elseif CpgDirection == lt.Constants.DIRECTION.DONG then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjLieRightOutFaceItem.csb")
	elseif CpgDirection == lt.Constants.DIRECTION.BEI then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjLieUpOutFaceItem.csb")
	end

	self._faceValue = self._rootNode:getChildByName("Sprite_Face")
	self._backBg = self._rootNode:getChildByName("Sprite_Back")
	self._redMask = self._rootNode:getChildByName("Image_MaskRed")
	self._lightMask = self._rootNode:getChildByName("Image_Light")
	self._tingSing = self._rootNode:getChildByName("Image_TingSing")
	self._tingLightMask = self._rootNode:getChildByName("Image_TingSingLight")

	self:showNormal()
end

function MjLieOutFaceItem:getRootNode()
	return self._rootNode
end

function MjLieOutFaceItem:setAnchorPoint(x, y)
	self._rootNode:setAnchorPoint(x, y)
end

function MjLieOutFaceItem:setValue(value)
	self._cardValue = value
end

function MjLieOutFaceItem:getValue()
	return self._cardValue
end

function MjLieOutFaceItem:setPosition(pos)
	self._rootNode:setPosition(pos)
end

function MjLieOutFaceItem:setVisible(bool)
	self._rootNode:setVisible(bool)
end

function MjLieOutFaceItem:runAction(action)
	self._rootNode:runAction(action)
end

function MjLieOutFaceItem:showNormal()
	self._backBg:setVisible(false)
	self._redMask:setVisible(false)
	self._lightMask:setVisible(false)
	self._tingSing:setVisible(false)
	self._tingLightMask:setVisible(false)
end

function MjLieOutFaceItem:showRedMask()
	self:showNormal()
	self._redMask:setVisible(true)
end

function MjLieOutFaceItem:setCardIcon(value)
	local cardType = math.floor(value / 10) + 1
	local cardValue = value % 10
	self._faceValue:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
end

return MjLieOutFaceItem