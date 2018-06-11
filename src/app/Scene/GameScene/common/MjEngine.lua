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
}

function MjEngine:open(deleget)
	self._deleget = deleget

    self._gameRoomInfo = lt.DataManager:getGameRoomInfo()
    self._playerNum = 2
    if self._gameRoomInfo and self._gameRoomInfo.room_setting and self._gameRoomInfo.room_setting.seat_num then
        self._playerNum = self._gameRoomInfo.room_setting.seat_num
    end

	self._allPlayerHandCardsNode = {}
	self._allPlayerCpgCardsNode = {}
	self._allPlayerOutCardsNode = {}

	self._allPlayerHandCardsValue = {}
	self._allPlayerCpgCardsValue = {}
	self._allPlayerOutCardsValue = {}

	self._allPlayerCpgCardsPanel = {}
	self._allPlayerHandCardsPanel = {}
	self._allPlayerOutCardsPanel = {}


	self._allLieFaceCardNode = {}

	self._showCardsLayer = display.newLayer() --cc.Layer:create()
	--self._showCardsLayer:setSwallowTouches(false)

	self._outCardsNode = cc.Node:create():setPosition(667, 400)--出牌的父node
	self._showCardsLayer:addChild(self._outCardsNode)

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
	ccp(314, -39),
	}

	self._allHandNodePos = {--手牌左边的起点位置 
	ccp(-16, 151),
	ccp(-632, -60),
	ccp(-15, -210),
	ccp(300, -37),
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
	
		self._showCardsLayer:addChild(self._allPlayerCpgCardsPanel[direction])
		self._outCardsNode:addChild(self._allPlayerOutCardsPanel[direction])
		self._showCardsLayer:addChild(self._allPlayerHandCardsPanel[direction])
	end
	
	return self
end

function MjEngine:close()
	self:clearData()
	self._showCardsLayer:removeFromParent()
end

function MjEngine:configOutCardsNodePos()
	local path = "res/alloutcardpos/positions.json"
	if device.platform == "ios" or device.platform == "android" then
		local writePath = cc.FileUtils:getInstance():getWritablePath()
		path = writePath .. path
	end
	local content = cc.FileUtils:getInstance():getStringFromFile(path)
	local allData = json.decode(content)
	self._allOutCardsNodePos = allData["player"..self._playerNum]
end

function MjEngine:clearData()

	-- self._allPlayerOutCardsNode = {}
	-- self._allPlayerHandCardsNode = {}
	-- self._allPlayerCpgCardsNode = {}


	self._allPlayerHandCardsValue = {}
	self._allPlayerCpgCardsValue = {}
	self._allPlayerOutCardsValue = {}

	for k,v in pairs(self._allLieFaceCardNode) do
		v:removeFromParent()
	end

	self._allLieFaceCardNode = {}
end

function MjEngine:getShowCardsLayer()
	return self._showCardsLayer
end

function MjEngine:angainConfigUi()--继续游戏
	self:clearData()
	self._showCardsLayer:setVisible(false)
end

function MjEngine:sendCards(cards)--发牌 13张
	self._showCardsLayer:setVisible(true)
	cards = cards or {}
	self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN] = self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN] or {}
	for i,card in ipairs(cards) do
		table.insert(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN], card)

	end
	local sortFun = function(a, b)
		return a < b
	end

	table.sort(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN], sortFun)

	self:sendCardsEffect()
end

function MjEngine:sendCardsEffect()
	local sendDealFinish = false

	for i,direction in ipairs(self._currentGameDirections) do
		self._allPlayerHandCardsValue[direction] = self._allPlayerHandCardsValue[direction] or {}
		for i=1, 13 do
			if direction ~= lt.Constants.DIRECTION.NAN then
				self._allPlayerHandCardsValue[direction][i] = 99
			end
		end
		self:configAllPlayerCards(direction, true, true, true)
	end

	for k,cards in pairs(self._allPlayerHandCardsNode) do
		for i,v in ipairs(cards) do
			v:setVisible(false)
		end
	end

	for direction,cards in pairs(self._allPlayerHandCardsNode) do--发牌发13张
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

function MjEngine:configAllPlayerCards(direction, refreshCpg, refreshHand, refreshOut)--吃椪杠 手牌 出的牌  用于刷牌
	
	-- if refreshCpg and refreshHand and refreshOut then
	-- 	self:clearDesktop()
	-- elseif then

	-- end
	
	local cpgOffX = 0
	local cpgOffY = 0
	if direction == lt.Constants.DIRECTION.XI then
		cpgOffY = -114
	elseif direction == lt.Constants.DIRECTION.NAN then
		cpgOffX = 264
	elseif direction == lt.Constants.DIRECTION.DONG then
		cpgOffY = 114
	elseif direction == lt.Constants.DIRECTION.BEI then
		cpgOffX = -135
	end

	local handOffX = 0
	local handOffY = 0
	if direction == lt.Constants.DIRECTION.XI then
		handOffY = -27
	elseif direction == lt.Constants.DIRECTION.NAN then
		handOffX = 88
	elseif direction == lt.Constants.DIRECTION.DONG then
		handOffY = 27
	elseif direction == lt.Constants.DIRECTION.BEI then
		handOffX = -46
	end

	self._allPlayerCpgCardsValue[direction] = self._allPlayerCpgCardsValue[direction] or {}
	self._allPlayerHandCardsValue[direction] = self._allPlayerHandCardsValue[direction] or {}

	local cpgNumber = #self._allPlayerCpgCardsValue[direction]
	local handNumber = #self._allPlayerHandCardsValue[direction]

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

		for i,v in ipairs(self._allPlayerHandCardsNode[direction]) do
			v:setVisible(false)
		end
		local isSpaceLastCard = false
		if handNumber % 3 == 2 then-- == 2时 该出牌了 最后一张牌要间隔
			isSpaceLastCard = true
		end

		for i,info in ipairs(self._allPlayerHandCardsValue[direction]) do
			local node = self._allPlayerHandCardsNode[direction][i]

			if direction == lt.Constants.DIRECTION.DONG then
				cardZorder = cardZorder - 1
			else
				cardZorder = cardZorder + 1
			end

			if node then
				self:updateCardsNode(node, self.CARD_TYPE.HAND, direction, info)
			else
				node = self:createCardsNode(self.CARD_TYPE.HAND, direction, info)
				table.insert(self._allPlayerHandCardsNode[direction], node)
				self._allPlayerHandCardsPanel[direction]:addChild(node:getRootNode(), cardZorder)
			end

			local x = self._allCpgNodePos[direction].x
			local y = self._allCpgNodePos[direction].y

			if cpgNumber and cpgNumber > 0 then--有吃椪杠存在

				if direction == lt.Constants.DIRECTION.NAN or direction == lt.Constants.DIRECTION.DONG then--锚点和初始化方向导致不同情况
					node:setPosition(x + cpgNumber*cpgOffX + (i-1)*handOffX, y + cpgNumber*cpgOffY+(i-1)*handOffY)
				else
					node:setPosition(x + (cpgNumber - 1)*cpgOffX + i*handOffX, y + (cpgNumber - 1)*cpgOffY + i*handOffY)
				end
			else
				x = self._allHandNodePos[direction].x
				y = self._allHandNodePos[direction].y

				node:setPosition(x + (i-1)*handOffX, y + (i-1)*handOffY)
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
			--设置手牌的初始状态
			node:setOrginPosition(node:getPosition())
			node:setSelectState(false)
			node:setVisible(true)
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
		end
	end
end

--所有牌的变化
function MjEngine:updateNanHandCardValue(direction, handList)--通知自己出牌的时候会把手牌和吃椪杠的牌发过来
	self._allPlayerHandCardsValue[direction] = handList
end

function MjEngine:updateNanCpgCardValue(direction, cpgList)
	self._allPlayerCpgCardsValue[direction] = cpgList
end

--单张牌的变化
function MjEngine:goOutOneHandCardAtDirection(direction, value)--出了一张牌
	 
	 if direction == lt.Constants.DIRECTION.NAN then
		self._allPlayerHandCardsValue[direction] = self._allPlayerHandCardsValue[direction] or {}

		for index,card in pairs(self._allPlayerHandCardsValue[direction]) do
			if card == value then
				table.remove(self._allPlayerHandCardsValue[direction], index)
				break
			end
		end

	 else
	 	table.remove(self._allPlayerHandCardsValue[direction], 1)
	 end

	 self:sortHandValue(direction)

	self._allPlayerOutCardsValue[direction] = self._allPlayerOutCardsValue[direction] or {}
	table.insert(self._allPlayerOutCardsValue[direction], value)
end

function MjEngine:getOneHandCardAtDirection(direction, value)--起了一张牌
	value = value or 99
	table.insert(self._allPlayerHandCardsValue[direction], value)
end

function MjEngine:getOneCpgAtDirection(direction, info)
	 table.insert(self._allPlayerCpgCardsValue[direction], info)
end

function MjEngine:sortHandValue(direction)

	if self._gameRoomInfo and self._gameRoomInfo.room_setting then

		local settingInfo = self._gameRoomInfo.room_setting
		if settingInfo.game_type == lt.Constants.GAME_TYPE.HZMJ then

			local tempHandCards = clone(self._allPlayerHandCardsValue[direction])
			local temp = {}

			local i = 1
			while i <= #tempHandCards do
				if tempHandCards[i] == lt.Constants.HONG_ZHONG_VALUE then
					table.insert(temp, tempHandCards[i])
					table.remove(tempHandCards, i)
				else
					i = i + 1
				end
			end

			table.sort( tempHandCards, function(a, b)
				return a < b
			end )

			for i,v in ipairs(temp) do
				table.insert(tempHandCards, v, 1)
			end

			self._allPlayerHandCardsValue[direction] = tempHandCards
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
			node:addNodeClickEvent(handler(self, self.onClickCard))
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
		node:setCardValue(value)
		node:setTag(value)
		node:showNormal()
	elseif cardType == self.CARD_TYPE.CPG then
		node:updateInfo(info)
		node:setCpgInfo(info)

	elseif cardType == self.CARD_TYPE.OUT then 
		local value = info--手牌值
		node:setCardValue(value)
		node:setValue(value)
		node:showNormal()
	end	

end

function MjEngine:createLieFaceItemByDirection(direction, info)

	local path = nil
	local lieFaceNode = nil
	if direction == lt.Constants.DIRECTION.BEI then
		path = "game/mjcomm/csb/mjui/green/MjLieUpFaceItem.csb"
	elseif direction == lt.Constants.DIRECTION.XI then
		path = "game/mjcomm/csb/mjui/green/MjLieLeftFaceItem.csb"
	elseif direction == lt.Constants.DIRECTION.DONG then
		path = "game/mjcomm/csb/mjui/green/MjLieRightFaceItem.csb"
	end
	if path then
		lieFaceNode = cc.CSLoader:createNode(path)
	end

	if lieFaceNode then
		local face = lieFaceNode:getChildByName("Sprite_Face")
		local Sprite_Back = lieFaceNode:getChildByName("Sprite_Back")
		Sprite_Back:setVisible(false)

		local Image_MaskRed = lieFaceNode:getChildByName("Image_MaskRed")
		Image_MaskRed:setVisible(false)

		local Sprite_Arrow = lieFaceNode:getChildByName("Sprite_Arrow")
		Sprite_Arrow:setVisible(false)
		
		value = info
		local cardType = math.floor(value / 10) + 1
		local cardValue = value % 10
		face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
	end

    return lieFaceNode
end

function MjEngine:checkMyHandStatu()
    local tObjCpghObj = {
        tObjChi = nil,
        tObjPeng = nil,
        tObjGang = nil,
        tObjHu = nil--抢杠胡  自摸
    }
    --检测杠
	local tempHandCards = clone(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN])

	local anGangCards = lt.CommonUtil:getCanAnGangCards(tempHandCards) 
	dump(anGangCards)

	local pengGang = lt.CommonUtil:getCanPengGangCards(self._allPlayerCpgCardsValue[lt.Constants.DIRECTION.NAN], tempHandCards)
	dump(pengGang)

	if #anGangCards > 0 or #pengGang > 0 then
		tObjCpghObj.tObjGang = {}
	end

	for i,v in ipairs(anGangCards) do
		table.insert(tObjCpghObj.tObjGang, v)
	end

	for i,v in ipairs(pengGang) do
		table.insert(tObjCpghObj.tObjGang, v)
	end

	--检测胡
	if self:checkIsHu(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN]) then
		print("自摸了###########################################")
		tObjCpghObj.tObjHu = {}
	else
		print("没有自摸###########################################")
	end

 --    --显示吃碰杠胡控件
 --    self:resetActionButtonsData(tObjCpghObj)--将牌的数据绑定到按钮上
	-- self:viewActionButtons(tObjCpghObj, false)

	return tObjCpghObj
end

function MjEngine:getAllCanHuCards(HandCards)
	local canHuCards = {}
	local allCardsValue = lt.DataManager:getGameAllCardsValue()

	for i,card in ipairs(allCardsValue) do
		if self:checkIsHu(HandCards, card) then
			table.insert(canHuCards, card)
		end
	end

	return canHuCards
end

function MjEngine:checkIsHu(HandCards, card)
	local tempHandCards = clone(HandCards)
	local config = nil--config.isQiDui,config.huiCard,config.hiPoint
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
		    config = {}
			config.isQiDui = (settingInfo.other_setting[3] == 1)  and true or false
			config.huiCard = 35
			config.hiPoint = (settingInfo.other_setting[4] == 1)  and true or false

		elseif settingInfo.game_type == lt.Constants.GAME_TYPE.SQMJ then

		end
	end
	
	if config then
		return lt.CommonUtil:checkIsHu(tempHandCards, card, config)
	end
	return false
end

function MjEngine:setClickCardCallBack(callBack)
	self._clickCardCallback = callBack
end

function MjEngine:onClickCard(cardNode, value)

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

	if not self._deleget:getCurrentOutPutPlayerPos() or self._deleget:getCurrentOutPutPlayerPos() ~= lt.DataManager:getMyselfPositionInfo().user_pos then
		self:configAllPlayerCards(lt.Constants.DIRECTION.NAN, false, true, false)--原来选中的牌回归原位
		cardNode:showRedMask()
		self:showRedMaskOutCards(value)
		return
	end

	if not cardNode:getSelectState() then

		self:configAllPlayerCards(lt.Constants.DIRECTION.NAN, false, true, false)--原来选中的牌回归原位
		--从出的牌中筛选出将要出的牌
		self:showRedMaskOutCards(value)

		cardNode:setSelectState(true)
		print("出列！！！！！！！！！！", value) 


		--检测听牌列表
		local tempHandCards = clone(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN])

		for i,v in ipairs(tempHandCards) do
			if v == value then
				table.remove(tempHandCards, i)
				break
			end
		end
		local canHuCards = self:getAllCanHuCards(tempHandCards)
		print("胡牌tips", #canHuCards)
		if #canHuCards > 0 then
			self._deleget:showHuCardsTipsMj()
			self._deleget:viewHuCardsTipsMenu(canHuCards)
		else
			self._deleget:hideHuCardsTipsMj()
		end
		
	else
		for k,outCardsNode in pairs(self._allPlayerOutCardsNode) do
			for i,v in ipairs(outCardsNode) do
				v:showNormal()
			end	
		end

		self._deleget:hideHuCardsTipsMj()

		if self._clickCardCallback then
			print("点击出牌", value)
			self._clickCardCallback(value)
		end
	end
end

function MjEngine:showRedMaskOutCards(value)--
	for k,outCardsNode in pairs(self._allPlayerOutCardsNode) do
		for i,v in ipairs(outCardsNode) do
			v:showNormal()
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

			--推到手牌
			if direction ~= lt.Constants.DIRECTION.NAN and self._allPlayerHandCardsNode[direction] then--手牌
				local index = 1
				for i,node in ipairs(self._allPlayerHandCardsNode[direction]) do
					if node:isVisible() then

						local value = nil
						if v.card_list[index] then
							local lieFaceNode = self:createLieFaceItemByDirection(direction, v.card_list[index])
							lieFaceNode:setPosition(node:getPosition())
							--local root = node:getParent()
							self._allPlayerHandCardsPanel[direction]:addChild(lieFaceNode)
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

function MjEngine:noticeSpecialEvent(msg)-- 有人吃椪杠胡
	local direction = lt.DataManager:getPlayerDirectionByPos(msg.user_pos)
	if not direction then
		return
	end

	local info = nil
	if msg.item then
		info = {}
		info["value"] = msg.item["value"]
		info["from"] = msg.item["from"]
		info["type"] = msg.item["type"]--<1 吃 2 碰 3 碰杠 4明杠 5 暗杠 6 胡>

		local formDirection = lt.DataManager:getPlayerDirectionByPos(msg.item["from"])
		local outValue = self._allPlayerOutCardsValue[formDirection][#self._allPlayerOutCardsValue[formDirection]]

		if outValue and outValue == msg.item["value"] then
 			table.remove(self._allPlayerOutCardsValue[formDirection], #self._allPlayerOutCardsValue[formDirection])

 			--self._allPlayerOutCardsNode[formDirection][#self._allPlayerOutCardsNode]:removeFromParent()
			--table.remove(self._allPlayerOutCardsNode[formDirection], #self._allPlayerOutCardsNode)
			self:configAllPlayerCards(formDirection, false, false, true)
		end
	end

	if not msg.item["type"] then
		return
	end

	local offNum = 0--吃椪杠少牌处理
	if direction ~= lt.Constants.DIRECTION.NAN then
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
		end

		for i=1,offNum do
			if #self._allPlayerHandCardsValue[direction] > 0 then
				table.remove(self._allPlayerHandCardsValue[direction], 1)
			end
		end
	end

	if msg.item["type"] ~= 6 then
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
	end	
	self:configAllPlayerCards(direction, true, true, false)

end

function MjEngine:onClientConnectAgain()--  断线重连
	local allRoomInfo = lt.DataManager:getPushAllRoomInfo()

	--handle_nums
	--自己的手牌
	self._allPlayerHandCardsValue = {}

	if allRoomInfo.card_list then
		self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN] = {}

		for i,card in ipairs(allRoomInfo.card_list) do
			table.insert(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN], card)

		end
		local sortFun = function(a, b)
			return a < b
		end

		table.sort(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN], sortFun)
	end

	if allRoomInfo.handle_nums then--handle_num

		for i,info in ipairs(allRoomInfo.handle_nums) do

			local direction = lt.DataManager:getPlayerDirectionByPos(info.user_pos)
			print("乐山大佛见识到了积分楼上的", direction, info.user_pos)
			if direction ~= lt.Constants.DIRECTION.NAN then--不是自己
				self._allPlayerHandCardsValue[direction] = {}
				for i=1,info.handle_num do
					table.insert(self._allPlayerHandCardsValue[direction], 99)
				end
			end
		end
	end

	--所有玩家吃椪杠的牌  
	self._allPlayerCpgCardsValue = {}
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
	self._allPlayerOutCardsValue = {}
	
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

	local putOutType = 0 --  1摸牌出牌  2 碰牌出牌 

	if allRoomInfo.cur_play_pos and allRoomInfo.cur_play_pos == lt.DataManager:getMyselfPositionInfo().user_pos  then
		if allRoomInfo.card then--如果有card则说明是摸牌出牌,否则是碰牌出牌
			putOutType = 1
		else
			putOutType = 2
		end
	end

	if putOutType == 1 then
	    --检测杠
		local tempHandCards = clone(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN])

		local anGangCards = lt.CommonUtil:getCanAnGangCards(tempHandCards) 

		local pengGang = lt.CommonUtil:getCanPengGangCards(self._allPlayerCpgCardsValue[lt.Constants.DIRECTION.NAN], tempHandCards)

		if #anGangCards > 0 or #pengGang > 0 then
			tObjCpghObj.tObjGang =  tObjCpghObj.tObjGang or {}
		end

		for i,v in ipairs(anGangCards) do
			table.insert(tObjCpghObj.tObjGang, v)
		end

		for i,v in ipairs(pengGang) do
			table.insert(tObjCpghObj.tObjGang, v)
		end

		--检测胡
		if self:checkIsHu(self._allPlayerHandCardsValue[lt.Constants.DIRECTION.NAN]) then
			tObjCpghObj.tObjHu = {}
		else
			print("没有自摸###########################################")
		end			
	end

    --显示吃碰杠胡控件
    self._deleget:viewHideActPanelAndMenu()
    self._deleget:resetActionButtonsData(tObjCpghObj)--将牌的数据绑定到按钮上
    self._deleget:viewActionButtons(tObjCpghObj, true)

	for i,direction in ipairs(self._currentGameDirections) do
		self:configAllPlayerCards(direction, true, true, true)
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