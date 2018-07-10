
--手牌
local MjStandFaceItem = class("MjStandFaceItem")

function MjStandFaceItem:ctor(handDirection)
	self._rootNode = nil
	if handDirection == lt.Constants.DIRECTION.XI then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjStandSideLeftItem.csb")
	elseif handDirection == lt.Constants.DIRECTION.NAN then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjStandFaceItem.csb")
	elseif handDirection == lt.Constants.DIRECTION.DONG then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjStandSideRightItem.csb")
	elseif handDirection == lt.Constants.DIRECTION.BEI then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjStandBackItem.csb")
	end
	if handDirection == lt.Constants.DIRECTION.NAN then
		local rootNode = self._rootNode:getChildByName("Node_Mj")
		self._imageBg = lt.CommonUtil:getChildByNames(rootNode, "Image_Bg")--点击事件层

		self._faceValue = lt.CommonUtil:getChildByNames(rootNode, "Sprite_Face")--牌值
		self._backBg = lt.CommonUtil:getChildByNames(rootNode, "Sprite_Back")--牌反面
		self._blackMask = lt.CommonUtil:getChildByNames(rootNode, "Image_Mask")--
		self._redMask = lt.CommonUtil:getChildByNames(rootNode, "Image_MaskRed")--
		self._tingIcon = lt.CommonUtil:getChildByNames(rootNode, "Sprite_TingArrow")--听牌
		self._lightMask = rootNode:getChildByName("Image_Light")
		self:showNormal()
		self._bgn = lt.CommonUtil:getChildByNames(rootNode,"Sprite_Bg")
	else
		self._bgq = self._rootNode:getChildByName("Sprite_Bg")
	end
	--self:setCardBgColor(3,handDirection)
end

function MjStandFaceItem:setCardBgColor(direction)--设置牌背面颜色
	local xuanzhonMjcolor = lt.PreferenceManager:getMJcolor() --记录选中麻将颜色
	if xuanzhonMjcolor == 0 then
		xuanzhonMjcolor = 1
	end

	local color = "cardBgGreen"
	if xuanzhonMjcolor == 1 then
		color = "cardBgGreen"  --绿
	elseif xuanzhonMjcolor == 2 then
		color = "cardBgBlue"   --蓝
	elseif xuanzhonMjcolor == 3 then
		color = "cardBgYellow" --黄
	end

	if direction == lt.Constants.DIRECTION.NAN then
		self._bgn:setSpriteFrame("game/mjcomm/"..color.."/mjStandFace.png")
	elseif direction == lt.Constants.DIRECTION.XI then
		self._bgq:setSpriteFrame("game/mjcomm/"..color.."/mjStandSide.png")
	elseif direction == lt.Constants.DIRECTION.DONG then --
		self._bgq:setSpriteFrame("game/mjcomm/"..color.."/mjStandSide.png")
	elseif direction == lt.Constants.DIRECTION.BEI then
		self._bgq:setSpriteFrame("game/mjcomm/"..color.."/mjStandBack.png")
	end
end

function MjStandFaceItem:getRootNode() 
	return self._rootNode
end

function MjStandFaceItem:setPosition(x , y)
	self._rootNode:setPosition(x , y)
end

function MjStandFaceItem:setOrginPosition(x , y)
	self._orginPos = ccp(x, y)
end

function MjStandFaceItem:getPosition()
	return self._rootNode:getPosition()
end

function MjStandFaceItem:setScale(scale)
	self._rootNode:setScale(scale)
end

function MjStandFaceItem:setVisible(bool)
	self._rootNode:setVisible(bool)
end

function MjStandFaceItem:runAction(action)
	self._rootNode:runAction(action)
end

function MjStandFaceItem:isVisible()
	return self._rootNode:isVisible()
end

function MjStandFaceItem:addNodeClickEvent(callBack) 
	if self._imageBg then
		self._callBack = callBack
		lt.CommonUtil:addNodeClickEvent(self._imageBg, handler(self, self.onClickCard))
	end
end

function MjStandFaceItem:onClickCard(event) 
	if self._callBack then
		self._callBack(self, self._imageBg:getTag())
	end
end

function MjStandFaceItem:setTag(tag) 
	if self._imageBg then
		self._imageBg:setTag(tag)
	end
end

function MjStandFaceItem:getTag() 
	return self._imageBg:getTag()
end

function MjStandFaceItem:setSelectState(bool) 
	if self._imageBg then
		self._imageBg["SelectState"] = bool
		if bool == true then
			self._rootNode:setPositionY(self._orginPos.y + 30)
		end
	end
end

function MjStandFaceItem:getSelectState() 
	if self._imageBg then
		return self._imageBg["SelectState"]
	end
end

function MjStandFaceItem:setCardIcon(value) 
	local cardType = math.floor(value / 10) + 1
	local cardValue = value % 10
	self._faceValue:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
end

function MjStandFaceItem:setCardSpecial(specialClick) 
	self._specialClick = specialClick
end

function MjStandFaceItem:getCardSpecial() 
	return self._specialClick
end

function MjStandFaceItem:showNormal() 
	self._backBg:setVisible(false)
	self._blackMask:setVisible(false)
	self._redMask:setVisible(false)
	self._tingIcon:setVisible(false)
	self._lightMask:setVisible(false)
end

function MjStandFaceItem:showTing() 
	self._tingIcon:setVisible(true)
end

function MjStandFaceItem:hideTing() 
	self._tingIcon:setVisible(false)
end

function MjStandFaceItem:showRedMask() 
	self._redMask:setVisible(true)
end

function MjStandFaceItem:showBlackMask() 
	self._blackMask:setVisible(true)
end

function MjStandFaceItem:showLightMask()
	self:showNormal()
	self._lightMask:setVisible(true)
end

return MjStandFaceItem