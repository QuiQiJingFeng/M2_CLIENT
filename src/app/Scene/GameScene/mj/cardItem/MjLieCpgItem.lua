
--设置层
local MjLieCpgItem = class("MjLieCpgItem")

function MjLieCpgItem:ctor(CpgDirection)
	self._rootNode = nil
	if CpgDirection == lt.Constants.DIRECTION.XI then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjLieLeftCpgItem.csb")
	elseif CpgDirection == lt.Constants.DIRECTION.NAN then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjLieDownCpgItem.csb")
		self._rootNode:setScale(1.65)
	elseif CpgDirection == lt.Constants.DIRECTION.DONG then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjLieRightCpgItem.csb")
	elseif CpgDirection == lt.Constants.DIRECTION.BEI then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjLieUpCpgItem.csb")
	end
end

function MjLieCpgItem:getRootNode()
	return self._rootNode
end

function MjLieCpgItem:setPosition(x , y)
	self._rootNode:setPosition(x , y)
end

function MjLieCpgItem:setVisible(bool)
	self._rootNode:setVisible(bool)
end

function MjLieCpgItem:runAction(action)
	self._rootNode:runAction(action)
end

function MjLieCpgItem:setCpgInfo(info)
	self._cpgInfo = info
end

function MjLieCpgItem:getCpgInfo(info)
	return self._cpgInfo
end

function MjLieCpgItem:allCardVisible()
	for i=1,4 do
		self._rootNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Back"):setVisible(false)
	end
end

function MjLieCpgItem:updateInfo(info)

	local value = info.value
	--local gang_type = info.gang_type--1 暗杠 2 明杠 3 碰杠
	local from = info.from
	local type = info.type--<1 吃 2 碰 3 碰杠 4明杠 5 暗杠 6 胡>

	local formDirection = lt.DataManager:getPlayerDirectionByPos(info.from) 

	local cardType = math.floor(value / 10) + 1
	local cardValue = value % 10

	for i=1,5 do
		self._rootNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Back"):setVisible(false)
		self._rootNode:getChildByName("MJ_Cpg_"..i):getChildByName("Image_MaskRed"):setVisible(false)
		--self._rootNode:getChildByName("MJ_Cpg_"..i):getChildByName("Image_Mask"):setVisible(false)
		
		local arrow = self._rootNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Arrow")
		arrow:setVisible(false)
		if formDirection then
			local du = (lt.Constants.DIRECTION.NAN - formDirection) * 90
			arrow:setRotation(du)
		end

		local face = self._rootNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Face")
		face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
		
		local initIndex = nil

		if type == 1 or type == 2 then
			initIndex = 3
		elseif type == 3 or type == 4 then
			initIndex = 4
		elseif type == 5 then
			initIndex = 4
			if i <= 4 then
				self._rootNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Back"):setVisible(true)
				if i == 4 and direction == lt.Constants.DIRECTION.NAN then
					self._rootNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Back"):setVisible(false)
				end
			end
		end
		if initIndex then

			if i <= initIndex then
				self._rootNode:getChildByName("MJ_Cpg_"..i):setVisible(true)
				if formDirection then
					if type == 2 then
						if i == 2 then
							arrow:setVisible(true)
						end
					else
						if i == initIndex and type ~= 5 then
							arrow:setVisible(true)
						end
					end
				end
			else
				self._rootNode:getChildByName("MJ_Cpg_"..i):setVisible(false)
			end
		end
	end 	
end

return MjLieCpgItem