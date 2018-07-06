
--手牌
local MjLieFaceItem = class("MjLieFaceItem")

function MjLieFaceItem:ctor(handDirection)
	self._rootNode = nil
	if handDirection == lt.Constants.DIRECTION.XI then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjLieLeftFaceItem.csb")
	elseif handDirection == lt.Constants.DIRECTION.NAN then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjLieDownFaceItem.csb")
	elseif handDirection == lt.Constants.DIRECTION.DONG then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjLieRightFaceItem.csb")
	elseif handDirection == lt.Constants.DIRECTION.BEI then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjLieUpFaceItem.csb")
	end

	self._faceIcon = self._rootNode:getChildByName("Sprite_Face")
	self._spriteBack = self._rootNode:getChildByName("Sprite_Back")

	self._imageMaskRed = self._rootNode:getChildByName("Image_MaskRed")
	self._imageBg = self._rootNode:getChildByName("Image_Bg")
	self._blackMask = self._rootNode:getChildByName("Image_Mask")

	self._spriteArrow = self._rootNode:getChildByName("Sprite_Arrow")

	self._tingIcon = self._rootNode:getChildByName("Sprite_TingArrow")

	self:showNormal()
end

function MjLieFaceItem:getRootNode() 
	return self._rootNode
end

function MjLieFaceItem:setScale(scale) 
	self._rootNode:setScale(scale)
end

function MjLieFaceItem:removeFromParent() 
	self._rootNode:removeFromParent()
end

function MjLieFaceItem:setPosition(x , y)
	self._rootNode:setPosition(x , y)
end

function MjLieFaceItem:setOrginPosition(x , y)
	self._orginPos = ccp(x, y)
end

function MjLieFaceItem:getPosition()
	return self._rootNode:getPosition()
end

function MjLieFaceItem:setVisible(bool)
	self._rootNode:setVisible(bool)
end

function MjLieFaceItem:runAction(action)
	self._rootNode:runAction(action)
end

function MjLieFaceItem:isVisible()
	return self._rootNode:isVisible()
end

function MjLieFaceItem:addNodeClickEvent(callBack) 
	if self._imageBg then
		self._callBack = callBack
		lt.CommonUtil:addNodeClickEvent(self._imageBg, handler(self, self.onClickCard))
	end
end

function MjLieFaceItem:onClickCard(event) 
	if self._callBack then
		self._callBack(self, self._imageBg:getTag())
	end
end

function MjLieFaceItem:setTag(tag) 
	if self._imageBg then
		self._imageBg:setTag(tag)
	end
end

function MjLieFaceItem:getTag() 
	return self._imageBg:getTag()
end

function MjLieFaceItem:setSelectState(bool) 
	if self._imageBg then
		self._imageBg["SelectState"] = bool
		if bool == true then
			self._rootNode:setPositionY(self._orginPos.y + 30)
		end
	end
end

function MjLieFaceItem:getSelectState() 
	if self._imageBg then
		return self._imageBg["SelectState"]
	end
end

function MjLieFaceItem:setCardIcon(value) 
	local cardType = math.floor(value / 10) + 1
	local cardValue = value % 10
	self._faceIcon:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
end

function MjLieFaceItem:setCardSpecial(specialClick) 
	self._specialClick = specialClick
end

function MjLieFaceItem:getCardSpecial() 
	return self._specialClick
end

function MjLieFaceItem:showNormal() 
	self._spriteBack:setVisible(false)
	self._imageMaskRed:setVisible(false)
	self._spriteArrow:setVisible(false)
	self._blackMask:setVisible(false)
	if self._tingIcon then
		self._tingIcon:setVisible(false)
	end
end

function MjLieFaceItem:showTing() 
	if self._tingIcon then
		self._tingIcon:setVisible(true)
	end
end

function MjLieFaceItem:hideTing() 
	if self._tingIcon then
		self._tingIcon:setVisible(false)
	end
end

function MjLieFaceItem:showRedMask()
	self:showNormal()
	self._imageMaskRed:setVisible(true)
end

function MjLieFaceItem:showBlackMask() 
	self:showNormal()
	self._blackMask:setVisible(true)
end

return MjLieFaceItem