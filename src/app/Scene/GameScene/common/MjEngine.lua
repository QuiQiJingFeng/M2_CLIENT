--[[
local data = {}
	for i=2,4 do
		self:testConfigOutCardsNodePos(i)
		data["player"..i] = clone(self._allOutCardsNodePos)
	end
    local file = io.open("res/alloutcardpos/positions.json","wb")

    file:write(json.encode(data))
    file:close()

function MjEngine:testConfigOutCardsNodePos(num)
	self._allOutCardsNodePos ={}
	local rootNode = nil
	if num == 2 then
		rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/2p/MjCardsPanel2p.csb")

	elseif num == 3 then
		rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/3p/MjCardsPanel3p.csb")

	elseif num == 4 then
		rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjCardsPanel.csb")
	end

	if not rootNode then
		return
	end

	for i=1,num do
		local cardsNode = lt.CommonUtil:getChildByNames(rootNode, "Panel_OutCard", "Node_OutCards_"..i)
		local posArray = {}
		for index=1, 60 do
			local cardNode = lt.CommonUtil:getChildByNames(cardsNode, "MJ_Out_"..index)
			if not cardNode then
				break
			end

			local x, y = cardNode:getPosition()

			table.insert(posArray, ccp(x, y))
		end
		local direction = 1
		if num == 2 then
			if i == 1 then
				direction = lt.Constants.DIRECTION.BEI
			else
				direction = lt.Constants.DIRECTION.NAN
			end
		else
			direction = i
		end
		self._allOutCardsNodePos[tostring(direction)] = posArray
	end
end

]]



local MjEngine = {}
MjEngine.CARD_TYPE = {
	HAND = 1, 
	CPG = 2,
	OUT = 3,

	LIE_NORMAL = 4,
	LIE_LIGHTHAND = 5,--亮四打一
	LIE_HAND = 6,--回放  明牌
}

MjEngine.CARD_SPECIAL = {
	NORMAL = 0,
	NOT_CAN_CLICK = 1,--不可以点 
	CAN_OUT = 2,--可以出
	NOT_CAN_OUT = 3,--不可以出
}


function MjEngine:open(deleget)
	self._deleget = deleget

    self._gameRoomInfo = lt.DataManager:getGameRoomInfo()
    self._playerNum = 2
    if self._gameRoomInfo and self._gameRoomInfo.room_setting and self._gameRoomInfo.room_setting.seat_num then
        self._playerNum = self._gameRoomInfo.room_setting.seat_num
    end

	self._allPlayerHandCardsNode = {}
	self._allPlayerLightHandCardsNode = {}
	self._allPlayerCpgCardsNode = {}
	self._allPlayerOutCardsNode = {}
	self._allPlayerSpecialOutCardsNode = {}

	self._allPlayerCpgCardsPanel = {}
	self._allPlayerHandCardsPanel = {}
	self._allPlayerOutCardsPanel = {}
	self._allPlayerSpecialOutCardsPanel = {}

	self._allLieFaceCardNode = {}--每局结束 推倒的牌

	self._showCardsLayer = display.newLayer() --cc.Layer:create()
	--self._showCardsLayer:setSwallowTouches(false)

	self._outCardsRootNode = cc.Node:create():setPosition(667, 400)--出牌的父node

	self._huiRootNode = cc.Node:create():setPosition(0, 600)--癞子牌父节点

	self._showCardsLayer:addChild(self._huiRootNode)
	self._showCardsLayer:addChild(self._outCardsRootNode)

	self._allCpgHandPanelPos = {--吃椪杠的父节点的位置
		ccp(205, 410),
		ccp(667, 78),
		ccp(1129, 410),
		ccp(667, 697),
	}

	self._allCpgNodePos = {--吃椪杠左边的起点位置 
		ccp(-30, 172),
		ccp(-627, -60),
		ccp(-30, -217),
		ccp(280, -39),
	}

	self._allHandNodePos = {--手牌左边的起点位置 
		ccp(-30, 200),
		ccp(-632, -60),
		ccp(-30, -210),
		ccp(300, -39),
	}

	self._allOutCardsPanelPos = {--不同玩家人数 不同方位
		[2] = {
			[4] = ccp(0, 153),
			[2] = ccp(0, -140),
		} ,

		[3] = {
			[1] = ccp(-262, 148),
			[2] = ccp(16, -140),
			[3] = ccp(267, 81),
		} ,
		[4] = {
			[1] = ccp(-253, -66),
			[2] = ccp(113, -140),
			[3] = ccp(267, 80),
			[4] = ccp(-54, 173),
		} ,
	}

	self._allSpecialOutCardsPanelPos = {
		ccp(-380, 0),
		ccp(0, -225),
		ccp(385, 0),
		ccp(0, 230),
	}

	self._allOutCardsNodePos = {}--所有方位出的牌的位置 按照ccb资源上的位置

	self:configOutCardsNodePos()

	self._currentGameDirections = nil

	if self._playerNum == 2 then--二人麻将
		self._currentGameDirections = {2, 4}
	elseif self._playerNum == 3 then
		self._currentGameDirections = {1, 2, 3}
	elseif self._playerNum == 4 then
		self._currentGameDirections = {1, 2, 3, 4} 
	end

	for i,direction in ipairs(self._currentGameDirections) do
		self._allPlayerCpgCardsPanel[direction] = cc.Node:create():setPosition(self._allCpgHandPanelPos[direction])
		self._allPlayerHandCardsPanel[direction] = cc.Node:create():setPosition(self._allCpgHandPanelPos[direction])

		self._allPlayerOutCardsPanel[direction] = cc.Node:create():setPosition(self._allOutCardsPanelPos[self._playerNum][direction])
	
		self._allPlayerSpecialOutCardsPanel[direction] = cc.Node:create():setPosition(self._allSpecialOutCardsPanelPos[direction])

		self._showCardsLayer:addChild(self._allPlayerCpgCardsPanel[direction])
		self._showCardsLayer:addChild(self._allPlayerHandCardsPanel[direction])

		self._outCardsRootNode:addChild(self._allPlayerOutCardsPanel[direction])
		self._outCardsRootNode:addChild(self._allPlayerSpecialOutCardsPanel[direction])
	end
	
	self:initDataValue()

	return self
end

function MjEngine:initDataValue()
	self._allPlayerHandCardsValue = {}
	self._allPlayerCpgCardsValue = {}
	self._allPlayerOutCardsValue = {}

	self._allPlayerSpecialOutCardsValue = {}
	self._allPlayerLightHandCardsValue = {}--商丘麻将亮四打一	
	self._allPlayerStandHandCardsValue = {}	
	self._allHandCardsTingValue = {}

	self._isSelectTing = false

	for i,direction in ipairs(self._currentGameDirections) do
		self._allPlayerLightHandCardsValue[direction] = {}
	end

	self._huiCardValue = nil
end

function MjEngine:close()
	self:clearUiData()
	self._showCardsLayer:removeFromParent()
end

function MjEngine:clearUiData()
	self:initDataValue()

	for k,v in pairs(self._allLieFaceCardNode) do
		v:removeFromParent()
	end
	self._allLieFaceCardNode = {}
	lt.DataManager:getTingPlayerInfo(true)

	self._isSelectTing = false
	self._deleget:hideHuCardsTipsMj()
	self._huiRootNode:removeAllChildren()
end

function MjEngine:configOutCardsNodePos()--解析 储存 不同玩家人数 outcard 的位置
	local path = "res/alloutcardpos/positions.json"
	if device.platform == "ios" or device.platform == "android" then
		local writePath = cc.FileUtils:getInstance():getWritablePath()
		path = writePath .. path
	end
	local content = cc.FileUtils:getInstance():getStringFromFile(path)
	local allData = json.decode(content)
	self._allOutCardsNodePos = allData["player"..self._playerNum]
end

function MjEngine:getShowCardsLayer()
	return self._showCardsLayer
end

function MjEngine:angainConfigUi()--继续游戏
	self:clearUiData()
	self._showCardsLayer:setVisible(false)
end

function MjEngine:sendCards(msg, pos)--发牌 13张

	local direction = lt.DataManager:getPlayerDirectionByPos(pos)

	self._showCardsLayer:setVisible(true)
	local cards = msg.cards or {}

	local fourCardList = msg.four_card_list or {}

	self:setHuiCardValue(msg.huicard)

	if direction then--and lt.DataManager:getRePlayState()
		self._allPlayerHandCardsValue[direction] = cards
		
		self._allPlayerStandHandCardsValue[direction] = {}

		self._allPlayerLightHandCardsValue[direction] = {}

		for i,cardItem in pairs(fourCardList) do
			local dire = lt.DataManager:getPlayerDirectionByPos(cardItem.user_pos)
			self._allPlayerLightHandCardsValue[dire] = cardItem.cards or {}
		end

		local tempFourCardList = clone(self._allPlayerLightHandCardsValue[direction])

		for i,card in ipairs(cards) do

			local isStandHandCard = true
			for k,v in ipairs(tempFourCardList) do
				if v == card then
					isStandHandCard = false
					table.remove(tempFourCardList, k)
					break
				end
			end

			if isStandHandCard then
				table.insert(self._allPlayerStandHandCardsValue[direction], card)
			end
		end

		self:sortHandValue(direction)

		local sortFun = function(a, b)
			return a < b
		end
		table.sort(self._allPlayerLightHandCardsValue[direction], sortFun)

		self:sendCardsEffect()
	end

end

function MjEngine:sendCardsEffect()
	local sendDealFinish = false

	for i,direction in ipairs(self._currentGameDirections) do
		self._allPlayerStandHandCardsValue[direction] = self._allPlayerStandHandCardsValue[direction] or {}
		if not lt.DataManager:getRePlayState() then
			local standCardNum = 13 - #self._allPlayerLightHandCardsValue[direction]
			for i=1, standCardNum do
				if direction ~= lt.Constants.DIRECTION.NAN then
					self._allPlayerStandHandCardsValue[direction][i] = 99
				end
			end
			for i=1,13 do
				if direction ~= lt.Constants.DIRECTION.NAN then
					self._allPlayerHandCardsValue[direction] = self._allPlayerHandCardsValue[direction] or {}
					self._allPlayerHandCardsValue[direction][i] = 99
				end
			end
		end
		self:configAllPlayerCards(direction, true, true, true, true)
	end

	local tempAllPlayerHandCardsNode = {}

	for k,cards in pairs(self._allPlayerLightHandCardsNode) do
		tempAllPlayerHandCardsNode[k] = tempAllPlayerHandCardsNode[k] or {}
		for i,v in ipairs(cards) do
			table.insert(tempAllPlayerHandCardsNode[k], v)
			v:setVisible(false)
		end
	end

	for k,cards in pairs(self._allPlayerHandCardsNode) do
		tempAllPlayerHandCardsNode[k] = tempAllPlayerHandCardsNode[k] or {}
		for i,v in ipairs(cards) do
			v:setVisible(false)
			table.insert(tempAllPlayerHandCardsNode[k], v)
		end
	end

	if lt.DataManager:getRePlayState() then --回放发牌走这里
		for direction,cards in pairs(tempAllPlayerHandCardsNode) do--发牌发13张
			for i=1,13 do
				if cards[i] then
					cards[i]:setVisible(true)
				end
			end
		end	
		self._deleget:sendDealFinish()
		sendDealFinish = true

	else
		for direction,cards in pairs(tempAllPlayerHandCardsNode) do--发牌发13张
			local time = 0.1
			for i=1,13 do
				time = time + 0.1
				if cards[i] then
					local func = function( )
						cards[i]:setVisible(true)

						if i == 13 and not sendDealFinish then
							self._deleget:sendDealFinish()
							sendDealFinish = true
						end
					end
					local delay = cc.DelayTime:create(time)

					local func1 = cc.CallFunc:create(func)
					local sequence = cc.Sequence:create(delay, func1)
					cards[i]:runAction(sequence)
				end
			end
		end	
	end
end

function MjEngine:configHuiCard()
	self._huiRootNode:removeAllChildren()

	if self._huiCardValue then
		local huiNode = self:createCardsNode(self.CARD_TYPE.OUT, lt.Constants.DIRECTION.NAN, self._huiCardValue)
		if huiNode then
			huiNode:setAnchorPoint(0.5, 0.5)
			huiNode:showLightMask()
			self._huiRootNode:addChild(huiNode:getRootNode())
		end
		huiNode:setPosition(ccp(50, 0))

		local badHuiValue = 0

		if self._huiCardValue % 10 == 1 then
			badHuiValue = math.floor(self._huiCardValue / 10) + 9
		else
			badHuiValue = self._huiCardValue  - 1
		end

		local badHuiNode = self:createCardsNode(self.CARD_TYPE.OUT, lt.Constants.DIRECTION.NAN, badHuiValue)
		if badHuiNode then
			badHuiNode:setAnchorPoint(0.5, 0.5)
			badHuiNode:showRedMask()
			self._huiRootNode:addChild(badHuiNode:getRootNode())
		end
		badHuiNode:setPosition(ccp(130, 0))
	end
end

function MjEngine:configAllPlayerCards(direction, refreshCpg, refreshHand, refreshOut, refreshSpeicalOut)--吃椪杠 手牌 出的牌  用于刷牌

	local cpgOffX = 0
	local cpgOffY = 0

	local handOffX = 0
	local handOffY = 0

	local lieHandOffX = 0
	local lieHandOffY = 0

	local cpgHandSpaceX = 0
	local cpgHandSpaceY = 0

	if direction == lt.Constants.DIRECTION.XI then
		cpgOffY = -114

		lieHandOffY = -32

		if lt.DataManager:getRePlayState() then 
			handOffY = -32
		else
			handOffY = -27
		end

		cpgHandSpaceY = -10

	elseif direction == lt.Constants.DIRECTION.NAN then
		cpgOffX = 264
		lieHandOffX = 88
		handOffX = 88
		cpgHandSpaceX = 0
	elseif direction == lt.Constants.DIRECTION.DONG then
		cpgOffY = 114
		lieHandOffY = 35
		if lt.DataManager:getRePlayState() then 
			handOffY = 35
		else
			handOffY = 27
		end
		cpgHandSpaceY = 0

	elseif direction == lt.Constants.DIRECTION.BEI then
		cpgOffX = -135
		lieHandOffX = -42
		if lt.DataManager:getRePlayState() then 
			handOffX = -42
		else
			handOffX = -45
		end
		cpgHandSpaceX = -10
	end


	self._allPlayerCpgCardsValue[direction] = self._allPlayerCpgCardsValue[direction] or {}
	self._allPlayerStandHandCardsValue[direction] = self._allPlayerStandHandCardsValue[direction] or {}
	self._allPlayerLightHandCardsValue[direction] = self._allPlayerLightHandCardsValue[direction] or {}
	
	local cpgNumber = #self._allPlayerCpgCardsValue[direction] or 0
	local lightHandNumber = #self._allPlayerLightHandCardsValue[direction] or 0
	local handNumber = #self._allPlayerStandHandCardsValue[direction] or 0

	--吃椪杠
	if refreshCpg then
	 	if not self._allPlayerCpgCardsNode[direction] then
			self._allPlayerCpgCardsNode[direction] = {}
		end

		for i,v in ipairs(self._allPlayerCpgCardsNode[direction]) do
			v:setVisible(false)
		end

		for i,info in ipairs(self._allPlayerCpgCardsValue[direction]) do
			
			local node = self._allPlayerCpgCardsNode[direction][i]
			if node then
				self:updateCardsNode(node, self.CARD_TYPE.CPG, direction, info)
			else
				node = self:createCardsNode(self.CARD_TYPE.CPG, direction, info)
				table.insert(self._allPlayerCpgCardsNode[direction], node)
				self._allPlayerCpgCardsPanel[direction]:addChild(node:getRootNode())
			end

			local x = self._allCpgNodePos[direction].x
			local y = self._allCpgNodePos[direction].y
			node:setPosition(x + (i - 1)*cpgOffX, y + (i - 1)*cpgOffY)

			node:setVisible(true)
		end
	end

	--手牌
	if refreshHand then
		local cardZorder = 0

		if not self._allPlayerHandCardsNode[direction] then
			self._allPlayerHandCardsNode[direction] = {}
		end

		if not self._allPlayerLightHandCardsNode[direction] then
			self._allPlayerLightHandCardsNode[direction] = {}
		end

		for i,v in ipairs(self._allPlayerHandCardsNode[direction]) do
			v:setVisible(false)
		end


		for i,v in ipairs(self._allPlayerLightHandCardsNode[direction]) do
			v:setVisible(false)
		end


		local isSpaceLastCard = false
		if (handNumber + lightHandNumber) % 3 == 2 then-- == 2时 该出牌了 最后一张牌要间隔
			isSpaceLastCard = true
		end

		--明着的手牌
		for i,info in ipairs(self._allPlayerLightHandCardsValue[direction]) do

			local node = self._allPlayerLightHandCardsNode[direction][i]

			if direction == lt.Constants.DIRECTION.DONG then
				cardZorder = cardZorder - 1
			else
				cardZorder = cardZorder + 1
			end

			if node then
				self:updateLieHandCardsNode(node, direction, info, self.CARD_TYPE.LIE_LIGHTHAND)
			else
				node = self:createLieFaceItemByDirection(direction, info, self.CARD_TYPE.LIE_LIGHTHAND)
				self._allPlayerHandCardsPanel[direction]:addChild(node:getRootNode(), cardZorder)

				table.insert(self._allPlayerLightHandCardsNode[direction], node)
			end

			node:setVisible(true)

			local x = self._allCpgNodePos[direction].x
			local y = self._allCpgNodePos[direction].y

			if cpgNumber and cpgNumber > 0 then--有吃椪杠存在

				if direction == lt.Constants.DIRECTION.NAN or direction == lt.Constants.DIRECTION.DONG then--锚点和初始化方向导致不同情况
					node:setPosition(x + cpgNumber*cpgOffX + (i-1)*lieHandOffX, y + cpgNumber*cpgOffY+(i-1)*lieHandOffY)
				else
					node:setPosition(x + (cpgNumber - 1)*cpgOffX + cpgHandSpaceX + i*lieHandOffX, y + (cpgNumber - 1)*cpgOffY + cpgHandSpaceY + i*lieHandOffY)
				end
			else
				x = self._allHandNodePos[direction].x
				y = self._allHandNodePos[direction].y

				node:setPosition(x + (i-1)*lieHandOffX, y + (i-1)*lieHandOffY)
			end

			--设置手牌的初始状态
			node:setOrginPosition(node:getPosition())
			node:setSelectState(false)
		end

		--暗着的手牌
		for i,info in ipairs(self._allPlayerStandHandCardsValue[direction]) do

			local node = self._allPlayerHandCardsNode[direction][i]

			if direction == lt.Constants.DIRECTION.DONG then
				cardZorder = cardZorder - 1
			else
				cardZorder = cardZorder + 1
			end

			if node then

				if direction ~= lt.Constants.DIRECTION.NAN then
					if lt.DataManager:getRePlayState() then
						self:updateLieHandCardsNode(node, direction, info, self.CARD_TYPE.LIE_HAND)
					else
						self:updateCardsNode(node, self.CARD_TYPE.HAND, direction, info)
					end
				else
					self:updateCardsNode(node, self.CARD_TYPE.HAND, direction, info)
				end
			else
				if lt.DataManager:getRePlayState() then

					if direction ~= lt.Constants.DIRECTION.NAN then
						node = self:createLieFaceItemByDirection(direction,info,self.CARD_TYPE.LIE_HAND)
						self._allPlayerHandCardsPanel[direction]:addChild(node:getRootNode(), cardZorder)
					else
						node = self:createCardsNode(self.CARD_TYPE.HAND, direction, info)
						self._allPlayerHandCardsPanel[direction]:addChild(node:getRootNode(), cardZorder)
					end

					table.insert(self._allPlayerHandCardsNode[direction], node)
				else
					node = self:createCardsNode(self.CARD_TYPE.HAND, direction, info)
					table.insert(self._allPlayerHandCardsNode[direction], node)
					self._allPlayerHandCardsPanel[direction]:addChild(node:getRootNode(), cardZorder)

				end
			end
			
			local x = self._allCpgNodePos[direction].x
			local y = self._allCpgNodePos[direction].y

			if cpgNumber and cpgNumber > 0 then--有吃椪杠存在

				if direction == lt.Constants.DIRECTION.NAN or direction == lt.Constants.DIRECTION.DONG then--锚点和初始化方向导致不同情况
					
					if lightHandNumber > 0 then
						node:setPosition(x + cpgNumber*cpgOffX + (lightHandNumber - 1)*lieHandOffX + i*handOffX, y + cpgNumber*cpgOffY+ (lightHandNumber - 1)*lieHandOffY + i*handOffY)
					else
						node:setPosition(x + cpgNumber*cpgOffX + (i - 1)*handOffX, y + cpgNumber*cpgOffY+ (i - 1)*handOffY)
					end
				else
					node:setPosition(x + (cpgNumber - 1)*cpgOffX + cpgHandSpaceX + lightHandNumber*lieHandOffX + i*handOffX, y + (cpgNumber - 1)*cpgOffY + cpgHandSpaceY + lightHandNumber*lieHandOffY + i*handOffY)
				end
			else
				x = self._allHandNodePos[direction].x
				y = self._allHandNodePos[direction].y

				if lightHandNumber > 0 then
					node:setPosition(x + (lightHandNumber - 1)*lieHandOffX + i*handOffX, y + (lightHandNumber - 1)*lieHandOffY + i*handOffY)
				else
					node:setPosition(x + (i - 1)*handOffX, y + (i - 1)*handOffY)
				end
			end

			if isSpaceLastCard and i == handNumber then
				local x, y = node:getPosition()
				if direction == lt.Constants.DIRECTION.XI then
					node:setPosition(x, y - 10)
				elseif direction == lt.Constants.DIRECTION.NAN then
					node:setPosition(x + 20, y)
				elseif direction == lt.Constants.DIRECTION.DONG then
					node:setPosition(x, y + 10)

				elseif direction == lt.Constants.DIRECTION.BEI then
					node:setPosition(x - 15, y)					
				end
			end

			node:setVisible(true)
			if not lt.DataManager:getRePlayState() and direction == lt.Constants.DIRECTION.NAN then
				
				--设置手牌的初始状态
				node:setOrginPosition(node:getPosition())
				node:setSelectState(false)
			end
		end
	end

	--出牌
	if refreshOut then
		local cardZorder = 0
		if not self._allPlayerOutCardsNode[direction] then
			self._allPlayerOutCardsNode[direction] = {}
		end

		for i,v in ipairs(self._allPlayerOutCardsNode[direction]) do
			v:setVisible(false)
		end

		self._allPlayerOutCardsValue[direction] = self._allPlayerOutCardsValue[direction] or {}
		for i,info in ipairs(self._allPlayerOutCardsValue[direction]) do
			local node = self._allPlayerOutCardsNode[direction][i]

			if direction == lt.Constants.DIRECTION.DONG or direction == lt.Constants.DIRECTION.BEI then
				cardZorder = cardZorder - 1
			else
				cardZorder = cardZorder + 1
			end

			if node then
				self:updateCardsNode(node, self.CARD_TYPE.OUT, direction, info)
			else
				node = self:createCardsNode(self.CARD_TYPE.OUT, direction, info)
				table.insert(self._allPlayerOutCardsNode[direction], node)
				self._allPlayerOutCardsPanel[direction]:addChild(node:getRootNode(), cardZorder)
			end
			node:setPosition(self._allOutCardsNodePos[tostring(direction)][i])
			node:setVisible(true)
			if info == 99 then
				node:BackBg(true)
			end
		end
	end

	-- self._allPlayerSpecialOutCardsValue = {
	-- 	[1] = {25},
	-- 	[2] = {1,2,3,4},
	-- 	[3] = {41,45,48},
	-- 	[4] = {11}
	-- }
	-- refreshSpeicalOut = true

	if refreshSpeicalOut then

		local cardZorder = 0
		if not self._allPlayerSpecialOutCardsNode[direction] then
			self._allPlayerSpecialOutCardsNode[direction] = {}
		end

		for i,v in ipairs(self._allPlayerSpecialOutCardsNode[direction]) do
			v:setVisible(false)
		end

		self._allPlayerSpecialOutCardsValue[direction] = self._allPlayerSpecialOutCardsValue[direction] or {}
		
		local spaceOffX = 100
		local spaceOffY = 80

		local startX = 0
		local startY = 0

		if #self._allPlayerSpecialOutCardsValue[direction] % 2 == 0 then--偶数个
			if direction == lt.Constants.DIRECTION.XI or direction == lt.Constants.DIRECTION.DONG then
				startY = (#self._allPlayerSpecialOutCardsValue[direction] / 2 - 1)*spaceOffY + spaceOffY/2
			else
				startX = (#self._allPlayerSpecialOutCardsValue[direction] / 2 - 1)*spaceOffX + spaceOffX/2
			end				
		else
			if direction == lt.Constants.DIRECTION.XI or direction == lt.Constants.DIRECTION.DONG then
				startY = math.floor(#self._allPlayerSpecialOutCardsValue[direction] / 2)*spaceOffY
			else
				startX = math.floor(#self._allPlayerSpecialOutCardsValue[direction] / 2)*spaceOffX
			end		
		end 

		for i,info in ipairs(self._allPlayerSpecialOutCardsValue[direction]) do
			local node = self._allPlayerSpecialOutCardsNode[direction][i]

			if node then
				self:updateCardsNode(node, self.CARD_TYPE.OUT, direction, info)
			else
				node = self:createCardsNode(self.CARD_TYPE.OUT, direction, info)
				node:setScale(0.8)
				node:setAnchorPoint(0.5, 0.5)

				table.insert(self._allPlayerSpecialOutCardsNode[direction], node)
				self._allPlayerSpecialOutCardsPanel[direction]:addChild(node:getRootNode(), cardZorder)
			end

			if direction == lt.Constants.DIRECTION.XI then
				node:setPosition(ccp(startX, startY - (i-1)*spaceOffY))
			elseif direction == lt.Constants.DIRECTION.NAN then
				node:setPosition(ccp(-startX + (i-1)*spaceOffX, startY))
			elseif direction == lt.Constants.DIRECTION.DONG then
				node:setPosition(ccp(startX, -startY + (i-1)*spaceOffY))
			elseif direction == lt.Constants.DIRECTION.BEI then
				node:setPosition(ccp(startX - (i-1)*spaceOffX, startY))
			end

			node:setVisible(true)
		end
	end

end

--所有牌的变化
function MjEngine:updateNanHandCardValue(direction, handList, fourCardList)--通知自己出牌的时候会把手牌和吃椪杠的牌发过来
	fourCardList = fourCardList or {}
	for k,v in pairs(fourCardList) do
		local direction = lt.DataManager:getPlayerDirectionByPos(v.user_pos)
		self._allPlayerLightHandCardsValue[direction] = v.cards or {}
	end

	local tempFourCardList = clone(self._allPlayerLightHandCardsValue[direction])
	self._allPlayerStandHandCardsValue[direction] = {}
	for i,card in ipairs(handList) do
		local isHandCard = true
		for k,v in ipairs(tempFourCardList) do
			if card == v then
				isHandCard = false
				table.remove(tempFourCardList, k)
				break
			end
		end

		if isHandCard then
			table.insert(self._allPlayerStandHandCardsValue[direction], card)
		end 
	end

	self._allPlayerHandCardsValue[direction] = handList
end

function MjEngine:updateNanCpgCardValue(direction, cpgList)
	self._allPlayerCpgCardsValue[direction] = cpgList
end

function MjEngine:updateLightCardValue(fourCardList)--四打一
	fourCardList = fourCardList or {}

	--亮四打一
	if fourCardList then
		for i,fourCardItem in pairs(fourCardList) do
			local dire = lt.DataManager:getPlayerDirectionByPos(fourCardItem.user_pos)
			self._allPlayerLightHandCardsValue[dire] = fourCardItem.cards
		end
	end
end

function MjEngine:goOutOneHandSpecialCardAtDirection(direction, value)--出了一张特殊 补花 飘癞子
	self._allPlayerSpecialOutCardsValue[direction] = self._allPlayerSpecialOutCardsValue[direction] or {}

	table.insert(self._allPlayerSpecialOutCardsValue[direction], value)
end

function MjEngine:goOutOneLightHandCardAtDirection(direction, value)--出了一张牌
	self._allPlayerLightHandCardsValue[direction] = self._allPlayerLightHandCardsValue[direction] or {}
	local isFind = false
	for index,card in pairs(self._allPlayerLightHandCardsValue[direction]) do
		if card == value then
			table.remove(self._allPlayerLightHandCardsValue[direction], index)
			isFind = true
			break
		end
	end
	return isFind
end

function MjEngine:goOutOneStandHandCardAtDirection(direction, value)--出了一张牌
	self._allPlayerStandHandCardsValue[direction] = self._allPlayerStandHandCardsValue[direction] or {}
	local isFind = false
	for index,card in pairs(self._allPlayerStandHandCardsValue[direction]) do
		if card == value then
			table.remove(self._allPlayerStandHandCardsValue[direction], index)
			isFind = true
			break
		end
	end
	return isFind
end

function MjEngine:replayGoOutOneHandCard(direction, value)--回放出了一张牌
	if #self._allPlayerLightHandCardsValue[direction] >= 4 then
		local isRemove = self:goOutOneLightHandCardAtDirection(direction, value)

		if not isRemove then
			self:goOutOneStandHandCardAtDirection(direction, value)
		end
	else
		self:goOutOneStandHandCardAtDirection(direction, value)
	end

	for i,v in ipairs(self._allPlayerHandCardsValue[direction]) do
		if v == value then
			table.remove(self._allPlayerHandCardsValue[direction], i)
			break
		end
	end
end

function MjEngine:goOutOneHandCard(direction, value)--出了一张牌
	if #self._allPlayerLightHandCardsValue[direction] >= 4 then
			
		if direction == lt.Constants.DIRECTION.NAN then
			local isRemove = self:goOutOneLightHandCardAtDirection(direction, value)

			if not isRemove then
				self:goOutOneStandHandCardAtDirection(direction, value)
			end
		else
			local isRemove = self:goOutOneLightHandCardAtDirection(direction, value)
			if not isRemove then
				table.remove(self._allPlayerStandHandCardsValue[direction], 1)
			end
		end
	else
		if direction == lt.Constants.DIRECTION.NAN then
			self:goOutOneStandHandCardAtDirection(direction, value)
		else
			table.remove(self._allPlayerStandHandCardsValue[direction], 1)
		end
	end
end

--单张牌的变化
function MjEngine:goOutOneHandCardAtDirection(direction, value)--出了一张牌
	self._allHandCardsTingValue = {} 
	if lt.DataManager:getRePlayState() then
		self:replayGoOutOneHandCard(direction, value)
	else
		self:goOutOneHandCard(direction, value)

		if direction == lt.Constants.DIRECTION.NAN then
			for i,v in ipairs(self._allPlayerHandCardsValue[direction]) do
				if v == value then
					table.remove(self._allPlayerHandCardsValue[direction], i)
					break
				end
			end
		else
			table.remove(self._allPlayerHandCardsValue[direction], 1)
		end
	end

	self:sortHandValue(direction)
end

--out牌
function MjEngine:getOneOutCardAtDirection(direction, value, isSpecialCard)
	if not isSpecialCard then
		local specialRefresh = false
		for i,v in ipairs(lt.Constants.ADD_CARD_VALUE_TABLE3) do
			if value == v then--补花	
				specialRefresh = true
				break
			end
		end
		if specialRefresh then
			self:goOutOneHandSpecialCardAtDirection(direction, value)
		else
			self._allPlayerOutCardsValue[direction] = self._allPlayerOutCardsValue[direction] or {}
			table.insert(self._allPlayerOutCardsValue[direction], value)
		end
	else
		self:goOutOneHandSpecialCardAtDirection(direction, value)
	end
end

function MjEngine:getOneHandCardAtDirection(direction, value)--起了一张牌
	self._tingOutCardValue = value
	value = value or 99
	self._allPlayerStandHandCardsValue[direction] = self._allPlayerStandHandCardsValue[direction] or {}
	table.insert(self._allPlayerStandHandCardsValue[direction], value)
end

function MjEngine:getOneCpgAtDirection(direction, info)
	self._allPlayerCpgCardsValue[direction] = self._allPlayerCpgCardsValue[direction] or {}
	 table.insert(self._allPlayerCpgCardsValue[direction], info)
end

function MjEngine:sortHandValue(direction)

	if self._gameRoomInfo and self._gameRoomInfo.room_setting then

		local settingInfo = self._gameRoomInfo.room_setting
		if settingInfo.game_type == lt.Constants.GAME_TYPE.HZMJ then

			local tempHandCards = clone(self._allPlayerStandHandCardsValue[direction])
			local temp = {}

			local i = 1
			while i <= #tempHandCards do
				if tempHandCards[i] == lt.Constants.HONG_ZHONG_VALUE then
					local tempCard = tempHandCards[i]
					table.insert(temp, tempCard)
					table.remove(tempHandCards, i)
				else
					i = i + 1
				end
			end

			table.sort( tempHandCards, function(a, b)
				return a < b
			end )

			for i,v in ipairs(temp) do
				table.insert(tempHandCards, 1, v)
			end

			self._allPlayerStandHandCardsValue[direction] = tempHandCards
		else
			local sortFun = function(a, b)
				return a < b
			end
			table.sort(self._allPlayerStandHandCardsValue[direction], sortFun)
		end
	end
end

--创建牌node
function MjEngine:createCardsNode(cardType, direction, info)
	--direction 上北下南左西右东  type==1 手牌 2 吃椪杠的牌 3 出的牌

	if not cardType or not direction then
		return
	end

	local node = nil 
	if cardType == self.CARD_TYPE.HAND then
		node = lt.MjStandFaceItem.new(direction)

		if self._clickCardCallback and direction == lt.Constants.DIRECTION.NAN then
			node:addNodeClickEvent(handler(self, self.onClickHandCard))
		end

	elseif cardType == self.CARD_TYPE.CPG then
		node = lt.MjLieCpgItem.new(direction)
	elseif cardType == self.CARD_TYPE.OUT then
		node = lt.MjLieOutFaceItem.new(direction)
	end

	if node then
		self:updateCardsNode(node, cardType, direction, info)
	end

	return node
end

function MjEngine:updateCardsNode(node, cardType, direction, info)
	if cardType == self.CARD_TYPE.HAND and direction == lt.Constants.DIRECTION.NAN then
		local value = info--手牌值
		node:setCardIcon(value)
		node:setTag(value)
		node:showNormal()
		
		if self._huiCardValue and value == self._huiCardValue then
			if lt.DataManager:getGameRoomSetInfo().game_type == lt.Constants.GAME_TYPE.HZMJ then
				node:showRedMask()
			elseif lt.DataManager:getGameRoomSetInfo().game_type == lt.Constants.GAME_TYPE.PLZ then
				node:showLightMask()
			end
		end

		local isTing = false
		if self._allHandCardsTingValue and #self._allHandCardsTingValue >= 1 then
			for i=1,#self._allHandCardsTingValue do
				if self._allHandCardsTingValue[i] == info then
					isTing = true
					break
				end
			end
		end

		if #self._allPlayerLightHandCardsValue[direction] >= 4 then
			if not self:isFlower(value) then
				node:showBlackMask() 
			end
		end

		if isTing then
			node:showTing()
		else
			if #self._allHandCardsTingValue > 0 and self._isSelectTing then
				node:showBlackMask()
			end 
		end

		local isBaoTing = lt.DataManager:isTingPlayerByPos(lt.DataManager:getPlayerPosByDirection(direction))
		if isBaoTing then
			node:hideTing()
			node:showBlackMask()
		end

	elseif cardType == self.CARD_TYPE.CPG then
		node:updateInfo(info)
		node:setCpgInfo(info)

	elseif cardType == self.CARD_TYPE.OUT then 
		local value = info--手牌值
		node:setCardIcon(value)
		node:setValue(value)
		node:showNormal()

		if value == self._huiCardValue then
			node:showLightMask()
		end
	end	

end

function MjEngine:updateLieHandCardsNode(node, direction, info, type)
	if node then
		node:setCardIcon(info)
		node:setTag(info)
		node:showNormal()

		if type == self.CARD_TYPE.LIE_LIGHTHAND and direction == lt.Constants.DIRECTION.NAN then

			if #self._allPlayerLightHandCardsValue[direction] < 4 then
				if not self:isFlower(info) then
					node:showBlackMask() 
				end
			end

			local isTing = false
			if self._allHandCardsTingValue and #self._allHandCardsTingValue >= 1 then
				for i=1,#self._allHandCardsTingValue do
					if self._allHandCardsTingValue[i] == info then
						isTing = true
						break
					end
				end
			end
			if isTing then
				node:showTing()
			else
				if #self._allHandCardsTingValue > 0 and self._isSelectTing then
					node:showBlackMask()
				end 
			end

			local isBaoTing = lt.DataManager:isTingPlayerByPos(lt.DataManager:getPlayerPosByDirection(direction))

			if isBaoTing then
				node:hideTing()
				node:showBlackMask()
			end
		end
	end
end

function MjEngine:createLieFaceItemByDirection(direction, info, type)

	local lieFaceNode = lt.MjLieFaceItem.new(direction)
	if lieFaceNode then
		if direction == lt.Constants.DIRECTION.NAN then

			if self._clickCardCallback and direction == lt.Constants.DIRECTION.NAN then
				lieFaceNode:addNodeClickEvent(handler(self, self.onClickLightHandCard))
			end
			lieFaceNode:setScale(2.0)
		end
		self:updateLieHandCardsNode(lieFaceNode, direction, info, type)
	end

    return lieFaceNode
end

function MjEngine:isFlower(value)
	if value >= lt.Constants.ADD_CARD_VALUE_TABLE3[1] and value <= lt.Constants.ADD_CARD_VALUE_TABLE3[#lt.Constants.ADD_CARD_VALUE_TABLE3] then
		return true
	end	
	return false
end

function MjEngine:exitHuiNum(HandCards)
	local num = 0
	for k,v in pairs(HandCards) do
		if v == self._huiCardValue then
			num = num + 1
		end
	end
	return num
end

function MjEngine:checkMyHandButtonActionStatu(handList,state, tObjCpghObj)

	local isTing = lt.DataManager:isTingPlayerByPos(lt.DataManager:getMyselfPositionInfo().user_pos)

	if self._isNeedBaoTing == 1 then
		--牌上显示听字
		if isTing then
			self:checkMyHandTingStatu()
		end
	else
		self:checkMyHandTingStatu()
	end

    if not tObjCpghObj then
	    tObjCpghObj = {
	        tObjChi = nil,
	        tObjPeng = nil,
	        tObjGang = nil,
	        tObjHu = nil,--抢杠胡  自摸
	        tObjTing = nil --听牌
	    }
    end

    local isCanHu = false
    local isCanGang = false

    if state then
	    --检测杠
		local tempHandCards = clone(handList)

		local anGangCards = lt.CommonUtil:getCanAnGangCards(tempHandCards) 

		local pengGang = lt.CommonUtil:getCanPengGangCards(self._allPlayerCpgCardsValue[lt.Constants.DIRECTION.NAN], tempHandCards)

		if #anGangCards > 0 or #pengGang > 0 then
			tObjCpghObj.tObjGang = tObjCpghObj.tObjGang or {}

			isCanGang = true
		end

		for i,v in ipairs(anGangCards) do
			table.insert(tObjCpghObj.tObjGang, v)
		end

		for i,v in ipairs(pengGang) do
			table.insert(tObjCpghObj.tObjGang, v)
		end

		--检测胡
		if self:checkIsHu(handList) then
			lt.CommonUtil.print("自摸了###########################################")
			tObjCpghObj.tObjHu = {}
			isCanHu = true
		else
			isCanHu = false
			lt.CommonUtil.print("没有自摸###########################################")
		end
	end

	--检测听牌
	local isBaoTing = lt.DataManager:isTingPlayerByPos(lt.DataManager:getMyselfPositionInfo().user_pos)
	lt.CommonUtil.print("当前玩家有没有报听",isBaoTing)

	--不同麻将的报听玩法处理

	if isBaoTing then--报听了   不再弹出听牌的按钮
		if not isCanHu and not isCanGang then
			self:autoPutOutCard()--听过牌的人检测过后会再动打出去
		end
	else--没报听
		if self._isNeedBaoTing == 1 then --需要报听 
			if isCanHu then--不报听不能胡
				tObjCpghObj.tObjHu = nil
			end

			local isCardTing = false
			if self:isCanTingCard() then--检测是否可以报听
				isCardTing = true
			end

		    if isCardTing then
		    	tObjCpghObj.tObjTing = {}
		    end
		else--不抱听
		end
	end

	return tObjCpghObj
end

function MjEngine:autoPutOutCard()--自动出牌
	if self._clickCardCallback and self._tingOutCardValue then
		local function func()
		   local statee = 1
		   self._clickCardCallback(self._tingOutCardValue,statee)			
		end
		local delay = cc.DelayTime:create(1)
		local func1 = cc.CallFunc:create(func)
		local sequence = cc.Sequence:create(delay, func1)
		self._deleget:runAction(sequence)

	end
end

function MjEngine:isCanTingCard() --是否可以听牌 仅仅为了显示听的按钮

	local isCanTing = false 
	for key,value in pairs(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN]) do
		local isTing = self:isCanTingByCard(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN], value)--出一张手牌是否可以听
		if isTing then
			--table.insert(self._allHandCardsTingValue,value)
			--handNode:showTing()--显示听得标志
			if self._gameRoomInfo.room_setting.game_type == lt.Constants.GAME_TYPE.SQMJ then
				for i,v in ipairs(self._allPlayerStandHandCardsValue[lt.Constants.DIRECTION.NAN]) do
					if value == v then
						isCanTing = true
						break
					end
				end
			else
				isCanTing = true
			end

			if isCanTing then
				break
			end
		end
	end
	--local istingInfo = lt.DataManager:isTingPlayerByPos(lt.DataManager:getMyselfPositionInfo().user_pos)
	lt.CommonUtil.print("检测显示听按钮", isCanTing)
	return isCanTing
end

function MjEngine:getotersCard(value)--胡牌的番

	local otherCardNum = 0
	local CardNum = 0

	for i,Cards in pairs(self._allPlayerCpgCardsValue) do
		for k,info in pairs(Cards) do
			-- info["value"] = msg.item["value"]
			-- info["from"] = msg.item["from"]
			-- info["type"] = msg.item["type"]--<1 吃 2 碰 3 碰杠 4明杠 5 暗杠 6 胡 7听>

			if info["value"] == value then
				if info["type"] == 2 then
					CardNum = CardNum + 3
				elseif info["type"] == 3 or info["type"] == 4 or info["type"] == 5 then
					CardNum = CardNum + 4
				end
			end
		end
	end

	for i,Cards in pairs(self._allPlayerOutCardsValue) do
		for k,info in pairs(Cards) do
			if info == value then
				CardNum = CardNum + 1
			end
		end
	end

	for i,Cards in pairs(self._allPlayerSpecialOutCardsValue) do
		for k,info in pairs(Cards) do
			if info == value then
				CardNum = CardNum + 1
			end
		end
	end

	for i,Cards in pairs(self._allPlayerLightHandCardsValue) do
		for k,info in pairs(Cards) do
			if info == value then
				CardNum = CardNum + 1
			end
		end
	end

	for i,info in ipairs(self._allPlayerStandHandCardsValue[lt.Constants.DIRECTION.NAN]) do
		if info == value then
			CardNum = CardNum + 1
		end
	end
	otherCardNum = 4 - CardNum

	lt.CommonUtil.print("otherCardNum==>otherCardNum",otherCardNum)
    return otherCardNum
end
function MjEngine:getAllCanHuCards(tempHandCards, value)
	lt.CommonUtil.print("=============getAllCanHuCards============",value)

	if value then
		for i,v in ipairs(tempHandCards) do
			if v == value then
				table.remove(tempHandCards, i)
				break
			end
		end
	end

	local canHuCards = {}
	local allCardsValue = lt.DataManager:getGameAllCardsValue()

	for i,card in ipairs(allCardsValue) do
		if self:checkIsHu(tempHandCards, card) then
			table.insert(canHuCards, card)
		end
	end

	return canHuCards
end

function MjEngine:isCanTingByCard(tempHandCards, value)--出一张手牌是否可以听
    local allCardsValueTable = clone(tempHandCards)
	for i,v in ipairs(allCardsValueTable) do
		if v == value then
			table.remove(allCardsValueTable, i)
			break
		end
	end

	local allCardsValue = lt.DataManager:getGameAllCardsValue()

	for i,card in ipairs(allCardsValue) do
		if self:checkIsHu(allCardsValueTable, card) then
			return true
		end
	end

	return false
end

function MjEngine:checkIsHu(HandCards, card)

	local tempHandCards = clone(HandCards)
	local config = {}--config.isQiDui,config.huiCard,config.hiPoint,config.hiPoint.shiShanYao
	if self._gameRoomInfo and self._gameRoomInfo.room_setting then

		local settingInfo = self._gameRoomInfo.room_setting
		if settingInfo.game_type == lt.Constants.GAME_TYPE.HZMJ then
			--room_setting  other_setting 
		    -- 游戏设置项[数组]
		    -- [1] 底分
		    -- [2] 奖码的个数
		    -- [3] 七对胡牌
		    -- [4] 喜分
		    -- [5] 一码不中当全中
		    
			config.isQiDui = (settingInfo.other_setting[3] == 1)  and true or false
			config.huiCard = 35
			config.hiPoint = (settingInfo.other_setting[4] == 1)  and true or false

		elseif settingInfo.game_type == lt.Constants.GAME_TYPE.SQMJ then
			for i,card in ipairs(tempHandCards) do
				if self:isFlower(card) then
					return false
				end
			end
		elseif settingInfo.game_type == lt.Constants.GAME_TYPE.TDH then
			-- 游戏设置项[数组]
		    -- [1] 底分
		    -- [2] 听牌
		    -- [3] 只可自摸胡
		    -- [4] 大胡平胡
		    config = {}
		    config.isQiDui = true
			config.shiShanYao = (settingInfo.other_setting[4] == 1)  and true or false
		
		elseif settingInfo.game_type == lt.Constants.GAME_TYPE.PLZ then

			local num = self:exitHuiNum(tempHandCards)
			if num >= 2 then
				return false
			end

			if num == 1 and card == self._huiCardValue then
				return false
			end

			config.huiCard = self._huiCardValue
		end
	end

	return lt.CommonUtil:checkIsHu(tempHandCards, card, config)
end

function MjEngine:checkMyHandTingStatu(isSelectTing)
	self._isSelectTing = isSelectTing
	local isting = lt.DataManager:isTingPlayerByPos(lt.DataManager:getMyselfPositionInfo().user_pos)
	if isting then
		return
	end
	for key,value in pairs(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN]) do
		local isTing = self:isCanTingByCard(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN], value)--出一张手牌是否可以听
		if isTing then
			table.insert(self._allHandCardsTingValue,value)
		end
	end
	self:configAllPlayerCards(lt.Constants.DIRECTION.NAN, false, true, false, false)	
end

function MjEngine:setClickCardCallBack(callBack)
	self._clickCardCallback = callBack
end

function MjEngine:onClickHandCard(cardNode, value)
	lt.CommonUtil.print("MjEngine:onClickHandCard")
	if lt.DataManager:getRePlayState() then
		return
	end

	if #self._allPlayerLightHandCardsValue[lt.Constants.DIRECTION.NAN] >= 4 and not self:isFlower(value) then
		return
	end

	if self._deleget:isVisibleGameActionBtnsPanel() then
		return
	end

	if lt.DataManager:getGameRoomSetInfo().game_type == lt.Constants.GAME_TYPE.HZMJ then
		if value == lt.Constants.HONG_ZHONG_VALUE then
			return
		end
	end

	if not self._deleget then
		return
	end

	local isTing = lt.DataManager:isTingPlayerByPos(lt.DataManager:getMyselfPositionInfo().user_pos)--报过了
	if isTing then
		return
	end

	local isClickTing = false
	for i,v in ipairs(self._allHandCardsTingValue) do
		if v == value then
			isClickTing = true
			break
		end
	end

	if not isClickTing and #self._allHandCardsTingValue > 0 and self._isSelectTing then
		return
	end

	if not self._deleget:getCurrentOutPutPlayerPos() or self._deleget:getCurrentOutPutPlayerPos() ~= lt.DataManager:getMyselfPositionInfo().user_pos then
		self:configAllPlayerCards(lt.Constants.DIRECTION.NAN, false, true, false, false)--原来选中的牌回归原位
		cardNode:showRedMask()
		self:showRedMaskOutCards(value)
		return
	end

	if not cardNode:getSelectState() then

		self:configAllPlayerCards(lt.Constants.DIRECTION.NAN, false, true, false, false)--原来选中的牌回归原位
		--从出的牌中筛选出将要出的牌
		self:showRedMaskOutCards(value)
		cardNode:setSelectState(true)
		lt.CommonUtil.print("onClickHandCard==>出列！！！！！！！！！！", value) 


		--检测听牌列表
		local tempHandCards = clone(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN])

		local canHuCards = self:getAllCanHuCards(tempHandCards, value)
		lt.CommonUtil.print("onClickHandCard==>胡牌tips", #canHuCards)
		if #canHuCards > 0 then
			self._deleget:showHuCardsTipsMj()
			self._deleget:viewHuCardsTipsMenu(canHuCards)
		else
			self._deleget:hideHuCardsTipsMj()
		end
		
	else
		for k,outCardsNode in pairs(self._allPlayerOutCardsNode) do--筛选出来的选中的牌的状态重置
			for i,v in ipairs(outCardsNode) do
				v:hidRedMask()
			end	
		end

		self._deleget:hideHuCardsContent()

		if self._clickCardCallback then
			local state = 1
			if isClickTing and self._isSelectTing then
				state = 2
			end
			self._clickCardCallback(value, state)
			
		end
	end
end

function MjEngine:onClickLightHandCard(cardNode, value)
	if lt.DataManager:getRePlayState() then
		return
	end

	if self._deleget:isVisibleGameActionBtnsPanel() then
		return
	end

	if not self._deleget then
		return
	end

	if #self._allPlayerLightHandCardsValue[lt.Constants.DIRECTION.NAN] < 4 and not self:isFlower(value) then
		return
	end

	local isTing = lt.DataManager:isTingPlayerByPos(lt.DataManager:getMyselfPositionInfo().user_pos)--报过了
	if isTing then
		return
	end

	local isClickTing = false
	for i,v in ipairs(self._allHandCardsTingValue) do
		if v == value then
			isClickTing = true
			break
		end
	end

	if not isClickTing and #self._allHandCardsTingValue > 0 and self._isSelectTing then
		return
	end

	if not self._deleget:getCurrentOutPutPlayerPos() or self._deleget:getCurrentOutPutPlayerPos() ~= lt.DataManager:getMyselfPositionInfo().user_pos then
		self:configAllPlayerCards(lt.Constants.DIRECTION.NAN, false, true, false, false)--原来选中的牌回归原位
		cardNode:showRedMask()
		self:showRedMaskOutCards(value)
		return
	end

	if not cardNode:getSelectState() then

		self:configAllPlayerCards(lt.Constants.DIRECTION.NAN, false, true, false, false)--原来选中的牌回归原位
		--从出的牌中筛选出将要出的牌
		self:showRedMaskOutCards(value)

		cardNode:setSelectState(true)
		lt.CommonUtil.print("onClickLightHandCard==>出列！！！！！！！！！！", value) 


		--检测听牌列表
		local tempHandCards = clone(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN])

		local canHuCards = self:getAllCanHuCards(tempHandCards, value)
		lt.CommonUtil.print("onClickLightHandCard==>胡牌tips", #canHuCards)
		if #canHuCards > 0 then
			self._deleget:showHuCardsTipsMj()
			self._deleget:viewHuCardsTipsMenu(canHuCards)
		else
			self._deleget:hideHuCardsTipsMj()
		end
		
	else
		for k,outCardsNode in pairs(self._allPlayerOutCardsNode) do
			for i,v in ipairs(outCardsNode) do
				v:hidRedMask()
			end	
		end

		--self._deleget:hideHuCardsContent()

		if self._clickCardCallback then
			local state = 1
			if isClickTing and self._isSelectTing then
				state = 2
			end
			self._clickCardCallback(value, state)
			
		end
	end
end

function MjEngine:showRedMaskOutCards(value)--
	for k,outCardsNode in pairs(self._allPlayerOutCardsNode) do
		for i,v in ipairs(outCardsNode) do
			if v:getValue() ~= 99 then
				v:showNormal()
			end
			if v.getValue and v:getValue() == value then
				v:showRedMask()
			end
		end	
	end
end

function MjEngine:gameOverShow()--游戏结束 推到牌
	for dire,CPGNodes in pairs(self._allPlayerCpgCardsNode) do
		for index,node in ipairs(CPGNodes) do
			local info = node:getCpgInfo()

			-- local value = info.value
			-- --local gang_type = info.gang_type--1 暗杠 2 明杠 3 碰杠
			-- local from = info.from
			-- local type = info.type--<1 吃 2 碰 3 碰杠 4明杠 5 暗杠 6 胡>
			if info and info.type == 5 then
				node:allCardVisible()
			end
		end
	end

	local gameOverInfo = lt.DataManager:getGameOverInfo()

	local winner_pos = gameOverInfo.winner_pos
	local winner_type = gameOverInfo.winner_type or 1 --自摸 1 抢杠 2
	local last_round = gameOverInfo.last_round

	if gameOverInfo.players then
		for k,v in ipairs(gameOverInfo.players) do
			local direction = lt.DataManager:getPlayerDirectionByPos(v.user_pos)


			if not lt.DataManager:getRePlayState() then

				--推到手牌
				if direction ~= lt.Constants.DIRECTION.NAN and self._allPlayerHandCardsNode[direction] then--手牌
					local index = 1
					for i,node in ipairs(self._allPlayerHandCardsNode[direction]) do
						if node:isVisible() then
							local cardZorder = 0
							if direction == lt.Constants.DIRECTION.DONG then
								cardZorder = cardZorder - 1
							else
								cardZorder = cardZorder + 1
							end

							local value = nil
							if v.card_list[index] then
								local lieFaceNode = self:createLieFaceItemByDirection(direction, v.card_list[index], self.CARD_TYPE.LIE_HAND)
								lieFaceNode:setPosition(node:getPosition())
								--local root = node:getParent()
								self._allPlayerHandCardsPanel[direction]:addChild(lieFaceNode:getRootNode(), cardZorder)
								table.insert(self._allLieFaceCardNode, lieFaceNode)
								index = index + 1
							end
							node:setVisible(false)

							--
						end
					end
				end
			end


		end
	end		

end

function MjEngine:noticeSpecialEvent(msg)-- 有人吃椪杠胡听

	local direction = lt.DataManager:getPlayerDirectionByPos(msg.user_pos)
	if not direction then
		return
	end

	if not msg.item["type"] then
		return
	end

	local offNum = 0--吃椪杠少牌处理
	if msg.item["type"] == 1 then
		offNum = 2
	elseif msg.item["type"] == 2 then
		offNum = 2
	elseif msg.item["type"] == 3 then	
		offNum = 1
	elseif msg.item["type"] == 4 then
		offNum = 3
	elseif msg.item["type"] == 5 then
		offNum = 4
	elseif msg.item["type"] == 7 then --听
		offNum = 1
	end

	--刷新胡牌面板
	self._deleget:refreshHuCardNum(msg.item, 3)

	--听牌出牌进行单独处理
	if msg.item["type"] ~= 6 and msg.item["type"] ~= 7 then
		local info = nil
		if msg.item then
			info = {}
			info["value"] = msg.item["value"]
			info["from"] = msg.item["from"]
			info["type"] = msg.item["type"]--<1 吃 2 碰 3 碰杠 4明杠 5 暗杠 6 胡 7听>

			local formDirection = lt.DataManager:getPlayerDirectionByPos(msg.item["from"])
			local outValue = self._allPlayerOutCardsValue[formDirection][#self._allPlayerOutCardsValue[formDirection]]

			if outValue and outValue == msg.item["value"] then
				lt.CommonUtil.print("MjEngine:noticeSpecialEvent==>outValue存在等于msg.item.value==>走了这里")
	 			table.remove(self._allPlayerOutCardsValue[formDirection], #self._allPlayerOutCardsValue[formDirection])

				self:configAllPlayerCards(formDirection, false, false, true, false)
			end
		end

		if not self._allPlayerCpgCardsValue[direction] then
			self._allPlayerCpgCardsValue[direction] = {}
		end

		if info then
			if msg.item["type"] == 3 then
				local change = false
				for k,v in ipairs(self._allPlayerCpgCardsValue[direction]) do
					if v.value == info.value then--之前是碰  变成了回头杠
						change = true
						self._allPlayerCpgCardsValue[direction][k] = info
						break
					end
				end
			else
				table.insert(self._allPlayerCpgCardsValue[direction], info)
			end
		end

		if lt.DataManager:getRePlayState() then
			local removeNum = 0

			if #self._allPlayerLightHandCardsValue[direction] > 0 then
				local n = 1
				while (n <= #self._allPlayerLightHandCardsValue[direction]) do
					if self._allPlayerLightHandCardsValue[direction][n] == msg.item["value"] and removeNum < offNum then
						table.remove(self._allPlayerLightHandCardsValue[direction], n)
						removeNum = removeNum + 1
					else
						n = n + 1
					end
				end
			end

			if removeNum < offNum then
				local n = 1
				while (n <= #self._allPlayerStandHandCardsValue[direction]) do
					if self._allPlayerStandHandCardsValue[direction][n] == msg.item["value"] and removeNum < offNum then
						table.remove(self._allPlayerStandHandCardsValue[direction], n)
						removeNum = removeNum + 1
					else
						n = n + 1
					end
				end
			end

			local a = 1
			local allRemoveNum = 0
			while (a <= #self._allPlayerHandCardsValue[direction]) do
				if self._allPlayerHandCardsValue[direction][a] == msg.item["value"] and allRemoveNum < offNum then
					table.remove(self._allPlayerStandHandCardsValue[direction], a)
					allRemoveNum = allRemoveNum + 1
				else
					a = a + 1
				end
			end
		else
			if direction ~= lt.Constants.DIRECTION.NAN then
				local removeNum = 0
				if #self._allPlayerLightHandCardsValue[direction] > 0 then
					local n = 1
					while (n <= #self._allPlayerLightHandCardsValue[direction]) do
						if self._allPlayerLightHandCardsValue[direction][n] == msg.item["value"] and removeNum < offNum then
							table.remove(self._allPlayerLightHandCardsValue[direction], n)
							removeNum = removeNum + 1
						else
							n = n + 1
						end
					end
				end

				local newOffNum = offNum - removeNum
				if newOffNum > 0 then
					for i=1,newOffNum do
						if #self._allPlayerStandHandCardsValue[direction] > 0 then
							table.remove(self._allPlayerStandHandCardsValue[direction], 1)
						end
					end
				end

				for i=1,offNum do
					if #self._allPlayerHandCardsValue[direction] > 0 then
						table.remove(self._allPlayerHandCardsValue[direction], 1)
					end
				end

			else
				local removeNum = 0

				if #self._allPlayerLightHandCardsValue[direction] > 0 then
					local n = 1
					while (n <= #self._allPlayerLightHandCardsValue[direction]) do
						if self._allPlayerLightHandCardsValue[direction][n] == msg.item["value"] and removeNum < offNum then
							table.remove(self._allPlayerLightHandCardsValue[direction], n)
							removeNum = removeNum + 1
						else
							n = n + 1
						end
					end
				end

				if removeNum < offNum then
					local n = 1
					while (n <= #self._allPlayerStandHandCardsValue[direction]) do
						if self._allPlayerStandHandCardsValue[direction][n] == msg.item["value"] and removeNum < offNum then
							table.remove(self._allPlayerStandHandCardsValue[direction], n)
							removeNum = removeNum + 1
						else
							n = n + 1
						end
					end
				end

				local a = 1
				local allRemoveNum = 0
				while (a <= #self._allPlayerHandCardsValue[direction]) do
					if self._allPlayerHandCardsValue[direction][a] == msg.item["value"] and allRemoveNum < offNum then
						table.remove(self._allPlayerHandCardsValue[direction], a)
						allRemoveNum = allRemoveNum + 1
					else
						a = a + 1
					end
				end			
			end
		end
	end

	--听牌处理
	if msg.item["type"] == 7 then
		local directionn = lt.DataManager:getPlayerDirectionByPos(msg.item["from"])
		lt.CommonUtil.print("noticeSpecialEvent==>推倒胡收到听牌的消息",msg.item["value"],directionn)

		local tingInfo = lt.DataManager:getTingPlayerInfo()

    	local isExit = false
    	for k,v in pairs(tingInfo) do
    		if v.user_pos == msg.item["from"] then
    			v.ting = true
    			isExit = true
    		end
    	end
    	if not isExit then
    		local info = {}
			info["user_pos"] = msg.item["from"]
			info["ting"] = true
			table.insert( tingInfo, info )
    	end

		lt.CommonUtil.print("noticeSpecialEvent==>",tingInfo)

		if self._isNeedBaoTing then
			if not self._isAnTing then--明听发的不走这里
				if lt.DataManager:getRePlayState() and msg.item["value"] then--不是回放在 点击牌的时候加
					
					self:goOutOneHandCardAtDirection(direction, msg.item["value"])
				end
			end
		end
	end

	self:configAllPlayerCards(direction, true, true, true, false)--4 false --> true 

end

function MjEngine:setHuiCardValue(huiValue)
	if lt.DataManager:getGameRoomSetInfo().game_type == lt.Constants.GAME_TYPE.HZMJ then
		self._huiCardValue = lt.Constants.HONG_ZHONG_VALUE
	elseif lt.DataManager:getGameRoomSetInfo().game_type == lt.Constants.GAME_TYPE.PLZ then
		self._huiCardValue = huiValue
		self:configHuiCard()
	end
end

function MjEngine:onClientConnectAgain()--  断线重连
	local allRoomInfo = lt.DataManager:getPushAllRoomInfo()

	self:initDataValue()

	--handle_nums
	--自己的手牌

	--亮四打一
	if allRoomInfo.four_card_list then
		for i,fourCardItem in ipairs(allRoomInfo.four_card_list) do
			local dire = lt.DataManager:getPlayerDirectionByPos(fourCardItem.user_pos)
			self._allPlayerLightHandCardsValue[dire] = fourCardItem.cards or {}
		end
	end

	if allRoomInfo.card_list then
		self._allPlayerStandHandCardsValue[lt.Constants.DIRECTION.NAN] = {}

		local tempFourCardList = clone(self._allPlayerLightHandCardsValue[lt.Constants.DIRECTION.NAN])

		for i,card in ipairs(allRoomInfo.card_list) do
			local isHandCard = true

			for k,v in ipairs(tempFourCardList) do
				if card == v then
					isHandCard = false
					table.remove(tempFourCardList, k)
					break
				end
			end

			if isHandCard then
				table.insert(self._allPlayerStandHandCardsValue[lt.Constants.DIRECTION.NAN], card)
			end 
		end

		self:sortHandValue(lt.Constants.DIRECTION.NAN)

		self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN] = allRoomInfo.card_list
	end

	if allRoomInfo.handle_nums then--handle_num

		for i,info in ipairs(allRoomInfo.handle_nums) do

			local direction = lt.DataManager:getPlayerDirectionByPos(info.user_pos)
			if direction ~= lt.Constants.DIRECTION.NAN then--不是自己
				self._allPlayerStandHandCardsValue[direction] = {}
				self._allPlayerHandCardsValue[direction] = {}
				local handNum = info.handle_num - #self._allPlayerLightHandCardsValue[direction]

				for i=1,info.handle_num do
					if i <= handNum then
						table.insert(self._allPlayerStandHandCardsValue[direction], 99)
					end
					table.insert(self._allPlayerHandCardsValue[direction], 99)
				end
			end
		end
	end

	--所有玩家吃椪杠的牌  
	if allRoomInfo.card_stack then
		for i,cardStack in ipairs(allRoomInfo.card_stack) do
			local direction = lt.DataManager:getPlayerDirectionByPos(cardStack.user_pos)
			self._allPlayerCpgCardsValue[direction]	= {}

			cardStack.item = cardStack.item or {}
			for k,stack in ipairs(cardStack.item) do
				local info = {}
				info["value"] = stack["value"]
				info["from"] = stack["from"]
				info["type"] = stack["type"]--<1 吃 2 碰 3 碰杠 4明杠 5 暗杠 6 胡>
				table.insert(self._allPlayerCpgCardsValue[direction], info)
			end
		end
	end

	--所有出的牌
	if allRoomInfo.put_cards then
		for i,info in ipairs(allRoomInfo.put_cards) do
			if info.user_pos then
				local direction = lt.DataManager:getPlayerDirectionByPos(info.user_pos)
				self._allPlayerOutCardsValue[direction]	= {}
				if info.cards then
					for k,value in ipairs(info.cards) do
						table.insert(self._allPlayerOutCardsValue[direction], value)
					end
				end
			end		
		end
	end

	--补的花 飘的癞子
	if allRoomInfo.mark_list then
		for i,cardItem in ipairs(allRoomInfo.mark_list) do
			local direction = lt.DataManager:getPlayerDirectionByPos(cardItem.user_pos)
			self._allPlayerSpecialOutCardsValue[direction] = cardItem.cards
		end
	end

	--癞子
	self:setHuiCardValue(allRoomInfo.huicard)

    --当前事件  

	--我的吃碰杠通知
    local tObjCpghObj = {
        tObjChi = nil,
        tObjPeng = nil,
        tObjGang = nil,
        tObjHu = nil--抢杠胡
    }

	if allRoomInfo.operators then
		local operatorList = {}
		for i,operator in ipairs(allRoomInfo.operators) do
			if operator == "CHI" or  operator == "PENG" or operator == "GANG" or operator == "HU" then
				table.insert(operatorList, operator)
			elseif operator == "DEAL_FINISH" then
				local arg = {command = "DEAL_FINISH"}
				lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)

			elseif operator == "PLAY_CARD" then

			end
		end
        for k,state in pairs(operatorList) do
        	if state == "CHI" then
        		tObjCpghObj.tObjChi = {}
        		table.insert(tObjCpghObj.tObjChi, allRoomInfo.put_card)
        	elseif state == "PENG" then
        		tObjCpghObj.tObjPeng = {}

        		--table.insert(tObjCpghObj.tObjPeng, msg.card)
        	elseif state == "GANG" then
        		if allRoomInfo.put_card then
        			tObjCpghObj.tObjGang = {}
        			table.insert(tObjCpghObj.tObjGang, allRoomInfo.put_card)
        		end
        	elseif state == "HU" then--抢杠胡
        		tObjCpghObj.tObjHu = {}
        	end
        end
	end

    --当前事件  
 --    local putOutType = 0 --  1摸牌出牌  2 碰牌出牌 

	-- if allRoomInfo.cur_play_operator then
	-- 	if allRoomInfo.cur_play_operator == "WAIT_PLAY_CARD" then	
	-- 		putOutType = 1
	-- 	elseif allRoomInfo.cur_play_operator == "WAIT_PLAY_CARD_FROM_PENG" then
	-- 		putOutType = 2
	-- 	end
	-- end	

	local state = 0 --  1摸牌出牌  2 碰牌出牌 

	if allRoomInfo.cur_play_pos and allRoomInfo.cur_play_pos == lt.DataManager:getMyselfPositionInfo().user_pos  then
		if allRoomInfo.card then--如果有card则说明是摸牌出牌,否则是碰牌出牌
			state = true
		else
			state = false
		end
	end

	if allRoomInfo.cur_play_pos == lt.DataManager:getMyselfPositionInfo().user_pos then--该自己出牌才检查
		local isTing = lt.DataManager:isTingPlayerByPos(lt.DataManager:getMyselfPositionInfo().user_pos)
		if isTing then
			self._tingOutCardValue = allRoomInfo.card_list[#allRoomInfo.card_list]
			--self:autoPutOutCard()
		end	

		if self._isNeedBaoTing == 1 then
			--牌上显示听字
			if isTing then
				self:checkMyHandTingStatu()
			end
		else
			self:checkMyHandTingStatu()
		end

	   tObjCpghObj = self:checkMyHandButtonActionStatu(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN], state, tObjCpghObj)
	end

	allRoomInfo.ting_list = allRoomInfo.ting_list or {}
	for k,v in pairs(allRoomInfo.ting_list) do --断线回来如何听过牌则显示玩家面前的听杠子
        if v.ting == true then
        	local direction = lt.DataManager:getPlayerDirectionByPos(v.user_pos)
        	self._deleget:ShowTingGang(direction)
        end
    end

    --显示吃碰杠胡控件
    self._deleget:viewHideActPanelAndMenu()
    self._deleget:resetActionButtonsData(tObjCpghObj)--将牌的数据绑定到按钮上
    self._deleget:viewActionButtons(tObjCpghObj, true)
    
	for i,direction in ipairs(self._currentGameDirections) do
		self:configAllPlayerCards(direction, true, true, true, true)
	end
end

function MjEngine:setMingTingConfig()
	self._isNeedBaoTing = 0

	 --1 暗听 0明听
	if lt.DataManager:getGameRoomSetInfo().game_type == lt.Constants.GAME_TYPE.TDH then
		self._isNeedBaoTing = lt.DataManager:getGameRoomSetInfo().other_setting[2]

		local setisTing = lt.DataManager:getGameRoomSetInfo().other_setting[5]
		if setisTing == 1 then
			self._isAnTing = true --暗听
		else
			self._isAnTing = false--明听
		end
	elseif lt.DataManager:getGameRoomSetInfo().game_type == lt.Constants.GAME_TYPE.SQMJ then
		self._isNeedBaoTing = 1

		local setisTing = lt.DataManager:getGameRoomSetInfo().other_setting[13]
		if setisTing == 1 then
			self._isAnTing = true --暗听
		else
			self._isAnTing = false--明听
		end
	end
end

function MjEngine:setEngineConfig()
	--在检测胡牌之前不同玩法的条件设置 当条件满足了在check是否可以胡牌

	--红中玩法 +-可胡七对  +-喜分 +-一码不中当全中


	--商丘麻将  +-带风牌 +-带跑 

	-- 癞子牌
	self.__config.huiCard = nil

	-- 是否限制只能一个癞子胡牌 飘癞子
	self.__config.isOnlyOneHuiCardHu = false

	-- 明听还是暗听 默认是暗听  报停出的那张牌看不见
	self.__config.isMingTing = false

	-- 胡牌是否必须听牌
	self.__config.isHuMustTing = true

	-- 听牌时候是否可以杠
	self.__config.isGangAfterTing = true


	-- -- 是否可以七对胡
	-- self.__config.isQiDui = false

	-- -- 抢杠胡
	-- self.__config.isQiangGangHu = true

	-- -- 四癞子胡牌 喜分
	-- self.__config.isHiPoint = nil
end

--设置列表
function MjEngine:setConfig(config)
	self.__config = {}
	for k,v in pairs(config) do
		self.__config[k] = v
	end
end

return MjEngine