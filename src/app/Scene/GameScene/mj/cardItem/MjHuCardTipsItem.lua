
--手牌
local MjHuCardTipsItem = class("MjHuCardTipsItem", function ( )
	return cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjHuCardsTipsItem.csb")
end)

function MjHuCardTipsItem:ctor()

    self._textZhang = self:getChildByName("Text_Zhang")
    self._imageLight = self:getChildByName("Node_41"):getChildByName("Image_Light")
    self._imageLight:setVisible(false)
    self._imageTingSingLight = self:getChildByName("Node_41"):getChildByName("Image_TingSingLight")
    self._imageTingSingLight:setVisible(false)


    self._face = self:getChildByName("Node_41"):getChildByName("Sprite_Face")
    self._imageBg = self:getChildByName("Node_41"):getChildByName("Sprite_Bg")
    --imageBg:setSwallowTouches(false)
end

function MjHuCardTipsItem:setCardBgColor(color) 
    self._imageBg:setSpriteFrame("game/mjcomm/"..color.."/mjLieVerticalFace.png")
end

function MjHuCardTipsItem:setCardIcon(value) 
	local cardType = math.floor(value / 10) + 1
	local cardValue = value % 10
	self._face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")

	self._cardValue = value
end

function MjHuCardTipsItem:getCardValue() 
	return self._cardValue or 0
end

function MjHuCardTipsItem:getCardNum() 
	return self._cardNum or 0
end

function MjHuCardTipsItem:setCardNum(num) 
    self._textZhang:setString(num)
    self._cardNum = num
end

return MjHuCardTipsItem