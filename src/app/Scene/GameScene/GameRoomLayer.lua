
local GameRoomLayer = class("GameRoomLayer", lt.BaseLayer)

GameRoomLayer.POSITION_TYPE = {
	XI = 1, 
	NAN = 2,
	DONG = 3,
	BEI = 4,
}

GameRoomLayer.CARD_TYPE = {
	ZHONG = 0,
	WAN = 1, 
	TIAO = 2,
	TONG = 3,
}


function GameRoomLayer:ctor()
	GameRoomLayer.super.ctor(self)

	local roomInfo = lt.DataManager:getGameRoomInfo()

	-- if roomInfo.game_type == 1 then

	-- end

	self._bgNode = cc.CSLoader:createNode("game/mjcomm/csb/base/GameBg.csb")--背景层

	self._cardsNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/2p/MjCardsPanel2p.csb")--牌面层

	self._playerNode = cc.CSLoader:createNode("game/mjcomm/csb/base/GamePlayerInfo.csb")--入座 玩家头像

	self._setNode = cc.CSLoader:createNode("game/mjcomm/csb/base/GameFunBtnPanel.csb")--设置

	self._infoNode = cc.CSLoader:createNode("game/mjcomm/csb/base/GameTableInfo.csb")--房间信息

	self._actionBtnsPanel = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjActionBtnsPanel.csb")--吃碰杠胡过

	self._resultLayer = cc.CSLoader:createNode("game/mjcomm/csb/base/GameResultLayer.csb")--结算


	self._resultPanelMask = self._resultLayer:getChildByName("Panel_Mask")

	local buttonList = self._resultLayer:getChildByName("Node_WinOrLost")
	self._resultStartAgainBtn = buttonList:getChildByName("Button_StartAgain")
	self._resultTotalEndBtn = buttonList:getChildByName("Button_TotalResult")
	self._resultWeChatShareBtn = buttonList:getChildByName("Button_WeChatShare")
	self._resultLeaveRoomBtn = buttonList:getChildByName("Button_LeaveRoom")

	lt.CommonUtil:addNodeClickEvent(self._resultStartAgainBtn, handler(self, self.onStartAgainClick))

	local Image_SurplusBg = self._resultLayer:getChildByName("Image_SurplusBg")
	Image_SurplusBg:setVisible(false)

	local Button_SurplusCard = self._resultLayer:getChildByName("Button_SurplusCard")
	Button_SurplusCard:setVisible(false)

	--self._actionBtnsPanel:setTouchEnabled(true)
	--self._actionBtnsPanel:setSwallowTouches(true)

	self._setNode:getChildByName("Bg_Help_Start"):setVisible(false)
	self._setNode:getChildByName("Bg_Help_NoStart"):setVisible(false)
	self._setNode:getChildByName("Bg_MaskLead"):setVisible(false)
	self._setNode:getChildByName("Bg_MaskGiftLead"):setVisible(false)
	self._setNode:getChildByName("Bg_MaskChatLead"):setVisible(false)
	self._setNode:getChildByName("Btn_ChatLead"):setVisible(false)
	self._setNode:getChildByName("Btn_LeadBg"):setVisible(false)
	self._setNode:getChildByName("Panel_RecordCtrl"):setVisible(false)
	self._setNode:getChildByName("Node_InviteView"):setVisible(false)
	self._setNode:getChildByName("Bg_ShareLayer"):setVisible(false)
	self._setNode:getChildByName("Button_Invite"):setVisible(false)

	self:addChild(self._bgNode)
	self:addChild(self._cardsNode)
	self:addChild(self._playerNode)
	self:addChild(self._setNode)
	self:addChild(self._infoNode)
	self:addChild(self._actionBtnsPanel)
	self:addChild(self._resultLayer)
	--设置
	local ruleBtn = self._setNode:getChildByName("Button_GameRule")
	local setBtn = self._setNode:getChildByName("Button_More")

	lt.CommonUtil:addNodeClickEvent(setBtn, handler(self, self.onSetClick))
	lt.CommonUtil:addNodeClickEvent(ruleBtn, handler(self, self.onRuleClick))

	--玩家界面
	self._tingLogoArray = {}--听牌的logo  
	self._playerLogoArray = {}--玩家的logo  
	self._allPlayerPosArray = {}--玩家座位的logo 
	self._servenPosArray = {}--7个位置的node
	--[[ 玩家的logo 
		getChildByName("Image_HeadBg"):getChildByName("Image_Head")--玩家的头像
		getChildByName("Sprite_Disconnect")--断线标识
		getChildByName("Text_Name")--名字
		getChildByName("Text_Amount")--99999
		getChildByName("Sprite_Ready")--准备 ok 手势
		
		getChildByName("Image_Light")--头像周围的亮圈
		getChildByName("Sprite_Zhuang")--庄 logo
		
		getChildByName("Node_Warning")--玩家在努力思考中

		getChildByName("Fzb_Tips")--csb 玩家ip及地址

		--座位
		getChildByName("Sprite_Word")--座位 东西南北 1 2 3 4
		
	]]

	self._infoNode:getChildByName("Node_TableInfo"):getChildByName("Text_RoomNo"):setString(lt.DataManager:getGameRoomInfo().room_id)


	self._nodeNoPlayer = self._playerNode:getChildByName("Node_NoPlayer")--两个方置 可以用来旋转

	self._handSelect = self._nodeNoPlayer:getChildByName("Node_SitDownTips")
	self._handSelect:setVisible(false)

	for i=1,4 do 
		table.insert(self._tingLogoArray, self._playerNode:getChildByName("Image_Ting_"..i))
		table.insert(self._playerLogoArray, self._playerNode:getChildByName("Node_Player"..i))
		table.insert(self._allPlayerPosArray, self._nodeNoPlayer:getChildByName("Button_NoPlayer_"..i))
	end

	for i=1,7 do
		table.insert(self._servenPosArray, self._playerNode:getChildByName("Node_NoPlayer"):getChildByName("Node_Pos"..i))
	end
	self._sitDownTips = self._playerNode:getChildByName("Node_NoPlayer"):getChildByName("Node_SitDownTips")
	
	for i,v in ipairs(self._tingLogoArray) do
		v:setVisible(false)
	end

	for i,v in ipairs(self._playerLogoArray) do
		v:setVisible(false)
	end


    --动作按钮 self.m_objCommonUi.m_nodeActionBtns:getChildByName("Button_Ting")

    self.m_objCommonUi = {}


    self.m_objCommonUi.m_nodeActionBtns = self._actionBtnsPanel:getChildByName("Node_ActionBtns") --吃碰杠胡按钮
    self.m_objCommonUi.m_btnChi =  self.m_objCommonUi.m_nodeActionBtns:getChildByName("Button_Chi") 
    self.m_objCommonUi.m_btnPeng = self.m_objCommonUi.m_nodeActionBtns:getChildByName("Button_Peng")
    self.m_objCommonUi.m_btnGang = self.m_objCommonUi.m_nodeActionBtns:getChildByName("Button_Gang")
    self.m_objCommonUi.m_btnHu = self.m_objCommonUi.m_nodeActionBtns:getChildByName("Button_Hu")
    self.m_objCommonUi.m_btnPass = self.m_objCommonUi.m_nodeActionBtns:getChildByName("Button_Pass")
    self.m_objCommonUi.m_btnTing = self.m_objCommonUi.m_nodeActionBtns:getChildByName("Button_Ting")
    self.m_objCommonUi.m_tArrActionBtn = {}
    if self.m_objCommonUi.m_btnChi then
        table.insert(self.m_objCommonUi.m_tArrActionBtn, self.m_objCommonUi.m_btnChi)
    end
    if self.m_objCommonUi.m_btnPeng then
        table.insert(self.m_objCommonUi.m_tArrActionBtn, self.m_objCommonUi.m_btnPeng)
    end
    if self.m_objCommonUi.m_btnGang then
        table.insert(self.m_objCommonUi.m_tArrActionBtn, self.m_objCommonUi.m_btnGang)
    end
    if self.m_objCommonUi.m_btnHu then
        table.insert(self.m_objCommonUi.m_tArrActionBtn, self.m_objCommonUi.m_btnHu)
    end
    if self.m_objCommonUi.m_btnTing then
        table.insert(self.m_objCommonUi.m_tArrActionBtn, self.m_objCommonUi.m_btnTing)
    end
    if self.m_objCommonUi.m_btnPass then
        table.insert(self.m_objCommonUi.m_tArrActionBtn, self.m_objCommonUi.m_btnPass)
    end
    local tArrNodeActionBtnsChildren = self.m_objCommonUi.m_nodeActionBtns:getChildren()
    for i = 1, #tArrNodeActionBtnsChildren do
        tArrNodeActionBtnsChildren[i].orgPos = cc.p(tArrNodeActionBtnsChildren[i]:getPosition())
    end

    for k,node in pairs(self.m_objCommonUi.m_tArrActionBtn) do
    	lt.CommonUtil:addNodeClickEvent(node, handler(self, self.onClickCpghEvent))
    end

    self.m_objCommonUi.m_nodeCardsMenu = self._actionBtnsPanel:getChildByName("Node_CardsMenu") --吃碰杠胡二级菜单
    self.m_objCommonUi.m_btnMenuPass = self.m_objCommonUi.m_nodeCardsMenu:getChildByName("Button_Pass")
    self.m_objCommonUi.m_imgCardsMenuBg = self.m_objCommonUi.m_nodeCardsMenu:getChildByName("Image_Bg")
    self.m_objCommonUi.m_panelMenuItems = self.m_objCommonUi.m_nodeCardsMenu:getChildByName("Panel_MenuItems")
    self.m_objCommonUi.m_panelMenuItems:removeAllChildren()

    self.m_objCommonUi.m_panelCurOutCard = self._actionBtnsPanel:getChildByName("Panel_CurOutCard")
    local shaizi1 = self._actionBtnsPanel:getChildByName("Sprite_DicePoint_1")
    local shaizi2 = self._actionBtnsPanel:getChildByName("Sprite_DicePoint_2")

    --胡牌提示  self.m_objCommonUi.m_nodeHuCardTips:getChildByName("Button_ToMax")
    self.m_objCommonUi.m_nodeHuCardTips = self._actionBtnsPanel:getChildByName("Node_HuCardTips")
    if self.m_objCommonUi.m_nodeHuCardTips then
        self.m_objCommonUi.m_imgHuCardTipsBg = self.m_objCommonUi.m_nodeHuCardTips:getChildByName("Image_Bg")
        self.m_objCommonUi.m_panelHuCardTipsContent = self.m_objCommonUi.m_nodeHuCardTips:getChildByName("Panel_Content")
        self.m_objCommonUi.m_mjTips = self.m_objCommonUi.m_panelHuCardTipsContent:getChildByName("MJ_Tips")
        if self.m_objCommonUi.m_mjTips then
            self.m_objCommonUi.m_iHuTipsScale = self.m_objCommonUi.m_mjTips:getScale() --缩放
            self.m_objCommonUi.m_mjTips = nil
        end
        self.m_objCommonUi.m_btnToMin = self.m_objCommonUi.m_nodeHuCardTips:getChildByName("Button_ToMin")
        self.m_objCommonUi.m_btnToMax = self.m_objCommonUi.m_nodeHuCardTips:getChildByName("Button_ToMax")
    end

    shaizi1:setVisible(false)
    shaizi2:setVisible(false)

    self.m_objCommonUi.m_nodeCardsMenu:setVisible(false)
    self.m_objCommonUi.m_nodeActionBtns:setVisible(false)
    self.m_objCommonUi.m_panelCurOutCard:setVisible(false)
    self.m_objCommonUi.m_nodeHuCardTips:setVisible(false)

    --结算界面
    self._resultLayer:setVisible(false)

    self._allPlayerResultNode = {}
	for i=1,4 do 
		table.insert(self._allPlayerResultNode, self._resultLayer:getChildByName("Node_ScrollNumPos_"..i))
	end

	self:initGame()
	self:configPlayer()--初始化玩家头像
	self:configRotation()--初始化座位方位
	--self._allPlayerCpgInitCards = {}--所有方位的吃椪杠  初始化过的牌
	--self:viewMenuBase()
end

function GameRoomLayer:initGame(type)  
	self:hzmj2p()
	self:configCards()

	self._allPlayerHandCards = {}--所有方位的手牌

	self._allPlayerOutInitCards = {}--所有方位的已经出过的  初始化过的牌

	self._allPlayerCpgCards = {}--所有方位的吃椪杠

	self:configPlayerScore()
end

function GameRoomLayer:hzmj2p()  
	self._currentSitPosArray = {}--玩家入座时的位置
	self._currentPlayerLogArray = {}--玩家打牌中头像

	self._currentPlayerResultNode = {}--结算


	for pos,v in ipairs(self._allPlayerPosArray) do--西南
		if pos == self.POSITION_TYPE.XI or pos == self.POSITION_TYPE.NAN then
			if pos == self.POSITION_TYPE.XI then
				if not v["atDirection"] then
					v["atDirection"] = self.POSITION_TYPE.BEI
				end
				v:setPosition(self._allPlayerPosArray[self.POSITION_TYPE.BEI]:getPosition())
			else
				if not v["atDirection"] then
					v["atDirection"] = self.POSITION_TYPE.NAN
				end
			end
			v:setVisible(true)
			self._currentSitPosArray[pos] = v
			lt.CommonUtil:addNodeClickEvent(v, handler(self, self.onSitDownClick))
		else
			v:setVisible(false)
		end
		v:setTag(pos)
	end


	for pos,playerLogo in ipairs(self._playerLogoArray) do
		playerLogo:getChildByName("Fzb_Tips"):setVisible(false)
		playerLogo:getChildByName("Node_Warning"):setVisible(false)
		playerLogo:getChildByName("Sprite_Ready"):setVisible(false)

		playerLogo:setVisible(false)

		if pos == self.POSITION_TYPE.BEI or pos == self.POSITION_TYPE.NAN then
			if not playerLogo["originPosX"] then
				playerLogo["originPosX"] = playerLogo:getPositionX()
			end
			
			if not playerLogo["originPosY"] then
				playerLogo["originPosY"] = playerLogo:getPositionY()
			end

			self._currentPlayerLogArray[pos] = playerLogo--方位是死的 2 4 

			playerLogo:getChildByName("Sprite_Zhuang"):setVisible(false)
			playerLogo:getChildByName("Sprite_Disconnect"):setVisible(false)

			--lt.CommonUtil:addNodeClickEvent(playerLogo, handler(self, self.onSitDownClick))
		end
	end

	for pos,node in ipairs(self._allPlayerResultNode) do
		if pos == self.POSITION_TYPE.BEI or pos == self.POSITION_TYPE.NAN then
			self._currentPlayerResultNode[pos] = node--方位是死的 2 4 
			node:getChildByName("Node_ResultInfoItem"):setVisible(false)
		else
			node:getChildByName("Node_ResultInfoItem"):setVisible(false)
		end
	end

	local nodeClock = self._cardsNode:getChildByName("Node_Clock")--中间方向盘
	
	self._spriteDnxb = nodeClock:getChildByName("Sprite_Dnxb")--方向旋转


	self._nodeLight = {}--红绿状态的节点

	self._nodeDXNB = {}--东西南北的节点  

	for i=1,4 do
		nodeClock:getChildByName("Node_Light_"..i):setVisible(false)
		nodeClock:getChildByName("Node_DNXB_"..i):setVisible(false)
		if i == 2 or i == 4 then--西南位置 对着这里用南北的ui
			nodeClock:getChildByName("Node_Light_"..i):setVisible(false)
			nodeClock:getChildByName("Node_DNXB_"..i):setVisible(true)
			self._nodeLight[i] = nodeClock:getChildByName("Node_Light_"..i)--:getChildByName("Sprite_Light") getChildByName("Sprite_LightRed")
			self._nodeDXNB[i] = nodeClock:getChildByName("Node_DNXB_"..i)--   

			if i == 2 then
				self._nodeDXNB[i]:getChildByName("Sprite_Dong"):setVisible(false)
				self._nodeDXNB[i]:getChildByName("Sprite_Nan"):setVisible(false)
				self._nodeDXNB[i]:getChildByName("Sprite_Xi"):setVisible(false)
				self._nodeDXNB[i]:getChildByName("Sprite_Bei"):setVisible(false)
			end
			if i == 4 then
				self._nodeDXNB[i]:getChildByName("Sprite_Dong"):setVisible(false)
				self._nodeDXNB[i]:getChildByName("Sprite_Nan"):setVisible(false)
				self._nodeDXNB[i]:getChildByName("Sprite_Xi"):setVisible(false)
				self._nodeDXNB[i]:getChildByName("Sprite_Bei"):setVisible(false)
			end
		end
	end

	self._surCardsNum = self._cardsNode:getChildByName("Node_CardNum"):getChildByName("Text_Num")--剩余牌数

	self._surRoomCount = self._cardsNode:getChildByName("Node_OtherNum"):getChildByName("Text_Num")--剩余局数

	local panelOutCard = self._cardsNode:getChildByName("Panel_OutCard")--出牌

	--panelOutCard:getChildByName("Node_OutCards_2")--自己出的牌

	self._allPlayerOutCards = {}

	for index=1,2 do--两人
		local direction = self.POSITION_TYPE.NAN
		if index == 1 then--北方
			direction = self.POSITION_TYPE.BEI
			
		else
			direction = self.POSITION_TYPE.NAN
		end
		self._allPlayerOutCards[direction] = {}
		local node = panelOutCard:getChildByName("Node_OutCards_"..index)
		if node then
			for i=1,59 do
				table.insert(self._allPlayerOutCards[direction], node:getChildByName("MJ_Out_"..i))
			end
		end
	end

	--panelOutCard:getChildByName("Node_OutCards_1")--对面出的牌

	self._pleaseOutCardTips = self._cardsNode:getChildByName("Sprite_OutCardTips")--请出牌


	local panelVertical = self._cardsNode:getChildByName("Panel_Vertical")--手牌

	self._allPlayerHandCardsNode = {}
	self._allPlayerCpgCardsNode = {}

	-- panelVertical:getChildByName("Node_CpgCards_1")--对面吃碰杠
	-- panelVertical:getChildByName("Node_HandCards_1")--对面手牌 立着

	-- panelVertical:getChildByName("Node_CpgCards_2")--
	-- panelVertical:getChildByName("Node_HandCards_2")-- 

	for index=1,2 do
		local direction = self.POSITION_TYPE.NAN
		if index == 1 then--北方
			direction = self.POSITION_TYPE.BEI
			
		else
			direction = self.POSITION_TYPE.NAN
		end
		self._allPlayerHandCardsNode[direction] = {}
		local node = panelVertical:getChildByName("Node_HandCards_"..index)
		if node then
			for i=1,14 do
				table.insert(self._allPlayerHandCardsNode[direction], node:getChildByName("MJ_Stand_"..i))
			end
		end

		--吃椪杠
		self._allPlayerCpgCardsNode[direction] = {}
		local node = panelVertical:getChildByName("Node_CpgCards_"..index)
		if node then
			for i=1,5 do
				table.insert(self._allPlayerCpgCardsNode[direction], node:getChildByName("Layer_Cpg_"..i))
			end
		end
	end

	self._curOutCardArrow = self._cardsNode:getChildByName("Node_CurOutCardArrow")--
end

function GameRoomLayer:configPlayerScore() 

	for direction=1,4 do
		local logoNode = self._currentPlayerLogArray[direction]
		local score = 0
		if self._allPlayerGameOverData then
			if self._allPlayerGameOverData[direction] then
				score = self._allPlayerGameOverData[direction].score
			end
		end
		if logoNode then
			logoNode:getChildByName("Text_Amount"):setString(score) --99999
		end
	end
end

function GameRoomLayer:configPlayer() 
    local gameRoomInfo = lt.DataManager:getGameRoomInfo()

    print("+++++++++++++++++", #self._currentSitPosArray, #gameRoomInfo.players)
    -- for k,playerLogo in pairs(self._currentPlayerLogArray) do
    -- 	playerLogo:setVisible(false)
    -- end

    local mySelfNode = nil
    for pos,sitNode in ipairs(self._currentSitPosArray) do
    	local player = lt.DataManager:getPlayerInfoByPos(pos)
    	print("121212121_____________________________________________", pos, sitNode.atDirection)
    	if sitNode.atDirection == self.POSITION_TYPE.NAN then
    		mySelfNode = sitNode
    	end

    	if player then--这个位置有人
    		print("000000000000000000_______________", pos, sitNode.atDirection)
    		if self._currentPlayerLogArray[sitNode.atDirection] then
				local name = self._currentPlayerLogArray[sitNode.atDirection]:getChildByName("Text_Name")
				if name then
					name:setString(player.user_name)
				end

				self._currentPlayerLogArray[sitNode.atDirection]:getChildByName("Sprite_Zhuang"):setVisible(false)

				if player.user_id ~= lt.DataManager:getPlayerInfo().user_id then--别的玩家的头像
					sitNode:setVisible(false)
					if player.is_sit then
		        		print("_______11111_________________________", player.user_pos, sitNode.atDirection)
	        			self._currentPlayerLogArray[sitNode.atDirection]:setVisible(true)
	        			self._currentPlayerLogArray[sitNode.atDirection]:getChildByName("Sprite_Ready"):setVisible(true)

	        			local worldPos = self._nodeNoPlayer:convertToWorldSpace(cc.p(sitNode:getPosition()))
	        			self._currentPlayerLogArray[sitNode.atDirection]:setPosition(worldPos.x, worldPos.y)
					
	        		else
	        			print("_______2222_________________________", player.user_pos, sitNode.atDirection)
		        		self._currentPlayerLogArray[sitNode.atDirection]:setVisible(true)
		        		self._currentPlayerLogArray[sitNode.atDirection]:getChildByName("Sprite_Ready"):setVisible(false)
	        			local worldPos = self._nodeNoPlayer:convertToWorldSpace(cc.p(sitNode:getPosition()))
	        			self._currentPlayerLogArray[sitNode.atDirection]:setPosition(worldPos.x, worldPos.y)
					end
				else
					print("_______33333_________________________")
					if mySelfNode and player.is_sit then
						print("%%%%%%%%%", player.user_pos, mySelfNode.atDirection)
						local worldPos = self._nodeNoPlayer:convertToWorldSpace(cc.p(mySelfNode:getPosition()))
						--self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:setVisible(true)
						self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:setPosition(worldPos.x, worldPos.y)
						self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:getChildByName("Sprite_Ready"):setVisible(true)
					end

					
				end
    		end
    	else
    		print("没人", pos, lt.DataManager:getMyselfPositionInfo().is_sit)
    		self._currentPlayerLogArray[sitNode.atDirection]:setVisible(false)
			if not lt.DataManager:getMyselfPositionInfo().is_sit then
				sitNode:setVisible(true)
				self._currentPlayerLogArray[sitNode.atDirection]:setVisible(false)
			end
    		--
    	end
    end
end


function GameRoomLayer:configCards() 

	for k,cards in pairs(self._allPlayerOutCards) do
		for i,v in ipairs(cards) do
			v:setVisible(false)
		end
	end


	for direction,cards in pairs(self._allPlayerHandCardsNode) do
		for i,v in ipairs(cards) do
			v:setVisible(false)
			if direction == self.POSITION_TYPE.NAN then
				v:getChildByName("Node_Mj"):getChildByName("Image_MaskRed"):setVisible(false)
				v:getChildByName("Node_Mj"):getChildByName("Image_Mask"):setVisible(false)
				v:getChildByName("Node_Mj"):getChildByName("Sprite_TingArrow"):setVisible(false)

				lt.CommonUtil:addNodeClickEvent(v:getChildByName("Node_Mj"):getChildByName("Image_Bg"), handler(self, self.onClickCard))
			end
		end
	end

	for direction, cards in pairs(self._allPlayerCpgCardsNode) do
		for i,v in ipairs(cards) do
			v:setVisible(false)
		end
	end
end

function GameRoomLayer:configSendCards() --游戏刚开始的发牌

	for pos,SitPos in pairs(self._currentSitPosArray) do
		SitPos:setVisible(false)
	end

	for pos,playerLog in pairs(self._currentPlayerLogArray) do
		playerLog:setVisible(true)
	end

	for k,v in pairs(self._currentPlayerLogArray) do
		local run = cc.MoveTo:create(1, cc.p(v.originPosX, v.originPosY))
		v:runAction(run)
	end

	--_allPlayerCpgCardsNode
	local sendDealFinish = false
	for direction,cards in pairs(self._allPlayerHandCardsNode) do--发牌发13张
		local time = 0.1
		for i=1,13 do
			time = time + 0.1
			if cards[i] then

				if direction == self.POSITION_TYPE.NAN then

					local value = self._allPlayerHandCards[direction][i]--手牌值
					local node = cards[i]:getChildByName("Node_Mj")
					local face = node:getChildByName("Sprite_Face")

					if node and face then
						local cardType = math.floor(value / 10) + 1
						local cardValue = value % 10
						face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
						node:getChildByName("Image_Bg"):setTag(value)
						node:getChildByName("Image_Bg")["CardIndex"] = i
					end
				end

				local func = function( )
					cards[i]:setVisible(true)

					if i == 13 and not sendDealFinish then
						sendDealFinish = true
						local arg = {command = "DEAL_FINISH"}
						lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
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

function GameRoomLayer:configRotation(isClick) 
	self._handSelect:setVisible(false)

	if isClick and self._selectPositionNode then

		local du = (self._selectPositionNode.atDirection - self.POSITION_TYPE.NAN) * 90

	    for i,v in pairs(self._currentSitPosArray) do
	    	local player = lt.DataManager:getPlayerInfoByPos(v:getTag())

	    	local is_sit = false
	    	if player then
	    		is_sit = player.is_sit
	    	end

	    	if v:getTag() ~= self._selectPositionNode:getTag() and not is_sit then
	    		v:setVisible(false)
	    	end
	    end

		local action = cc.RotateBy:create(0.5, du)

		local action2 = function ( )
			local action3 = cc.RotateBy:create(0.5, -du)
			self._selectPositionNode:runAction(action3)
		end

		local action1 = function ( )
			local action4 = cc.RotateBy:create(0.5, du)
			self._spriteDnxb:runAction(action4)
		end

		local headVisible = function ( )
			self._selectPositionNode:setVisible(false)
			self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:setVisible(true)
			-- self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:getChildByName("Sprite_Ready"):setVisible(true)

			-- local worldPos = self._nodeNoPlayer:convertToWorldSpace(cc.p(self._selectPositionNode:getPosition()))
			-- self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:setPosition(worldPos.x, worldPos.y)
		end

		local spawn = cc.Spawn:create(cc.CallFunc:create(action1), action, cc.CallFunc:create(action2))
		
  		local sequence = cc.Sequence:create(spawn, cc.CallFunc:create(headVisible))
  		self._nodeNoPlayer:runAction(sequence)

		local temp = self._selectPositionNode.atDirection - self.POSITION_TYPE.NAN
		for pos,v in ipairs(self._currentSitPosArray) do

			--4 3  3 2 2 1 1 4     4 2 3 1  2 4 1 3   4 1 1 2 2 3 3 4
			if temp > 0 then --顺时针
				if temp == 1 then  --90度旋转 
					v["atDirection"] = v["atDirection"] - temp
					if v["atDirection"] == 0 then
						v["atDirection"] = self.POSITION_TYPE.BEI
					end
				elseif temp == 2 then--180 
					if v["atDirection"] > self.POSITION_TYPE.NAN then
						v["atDirection"] = v["atDirection"] - temp
					else
						v["atDirection"] = v["atDirection"] + temp
					end
				end
			else--逆时针
				if temp == -1 then--90度
					v["atDirection"] = v["atDirection"] - temp
					if v["atDirection"] == 5 then
						v["atDirection"] = self.POSITION_TYPE.XI
					end
				end
			end
		end

	else
		local mySelfPosition = lt.DataManager:getMyselfPositionInfo().user_pos

		local du = 0

		local mySelfPositionNode = self._currentSitPosArray[mySelfPosition]

		if mySelfPositionNode then
			du = (mySelfPositionNode.atDirection - self.POSITION_TYPE.NAN) * 90
		end

		for i,v in pairs(self._allPlayerPosArray) do
			v:setRotation(-du)
		end

		self._nodeNoPlayer:setRotation(du)
		
		self._spriteDnxb:setRotation(du)


		local temp = mySelfPositionNode.atDirection - self.POSITION_TYPE.NAN
		for pos,v in ipairs(self._currentSitPosArray) do

			--4 3  3 2 2 1 1 4     4 2 3 1  2 4 1 3   4 1 1 2 2 3 3 4
			if temp > 0 then --顺时针
				if temp == 1 then  --90度旋转 
					v["atDirection"] = v["atDirection"] - temp
					if v["atDirection"] == 0 then
						v["atDirection"] = self.POSITION_TYPE.BEI
					end
				elseif temp == 2 then--180 
					if v["atDirection"] > self.POSITION_TYPE.NAN then
						v["atDirection"] = v["atDirection"] - temp
					else
						v["atDirection"] = v["atDirection"] + temp
					end
				end
			else--逆时针
				if temp == -1 then--90度
					v["atDirection"] = v["atDirection"] - temp
					if v["atDirection"] == 5 then
						v["atDirection"] = self.POSITION_TYPE.XI
					end
				end
			end
		end

	end
end

function GameRoomLayer:getPlayerDirectionByPos(playerPos) 
	print("玩家所在pos", playerPos)
	for pos,sitNode in ipairs(self._currentSitPosArray) do
		if pos == playerPos then
			print("获得玩家所在方位", sitNode.atDirection)
			return sitNode.atDirection
		end
	end
	return nil
end

function GameRoomLayer:configAllPlayerCards(direction)--吃椪杠 手牌

	if not self._allPlayerCpgCardsNode[direction] then
		return
	end

	local chiPengCount = 0
	local gangCount = 0
	self._allPlayerCpgCards[direction] = self._allPlayerCpgCards[direction] or {}
	for index,CpgNode in ipairs(self._allPlayerCpgCardsNode[direction]) do
		local cardInfo = self._allPlayerCpgCards[direction][index]
		print("666666666666666666666666666666666666")
		dump(tostring(cardInfo))
		if cardInfo then
			local value = cardInfo.value
			local gang_type = cardInfo.gang_type--1 暗杠 2 明杠 3 碰杠
			local from = cardInfo.from
			local type = cardInfo.type--1 碰 2 杠 3 吃

			local formDirection = self:getPlayerDirectionByPos(cardInfo.from) 

			local cardType = math.floor(value / 10) + 1
			local cardValue = value % 10

			local visibleType = 1 --1 碰 2 碰杠 3 明杠 4 暗杠 5 吃

			if type == 2 then
				gangCount = gangCount + 1
				if gang_type == 1 then--暗杠
					visibleType = 4
				elseif gang_type == 2 then--明杠
					visibleType = 3
				elseif gang_type == 3 then--碰杠
					visibleType = 2
				end
			else
				visibleType = 1
				chiPengCount = chiPengCount + 1
			end
			CpgNode:setVisible(true)
			for i=1,5 do
				CpgNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Back"):setVisible(false)
				CpgNode:getChildByName("MJ_Cpg_"..i):getChildByName("Image_MaskRed"):setVisible(false)

				local arrow = CpgNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Arrow")
				arrow:setVisible(false)
				local du = (self.POSITION_TYPE.NAN - formDirection) * 90
				arrow:setRotation(du)

				local face = CpgNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Face")
				face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
				
				local initIndex = nil

				if visibleType == 1 then
					initIndex = 3
				elseif visibleType == 2 or visibleType == 3 then
					initIndex = 4
				elseif visibleType == 4 then
					initIndex = 4
					if i <= 4 then
						CpgNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Back"):setVisible(true)
						if i == 4 and direction == self.POSITION_TYPE.NAN then
							CpgNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Back"):setVisible(false)
						end
					end
				end
				if initIndex then

					if i <= initIndex then
						CpgNode:getChildByName("MJ_Cpg_"..i):setVisible(true)
						if i == initIndex and visibleType ~= 4 then
							arrow:setVisible(true)
						end
					else
						CpgNode:getChildByName("MJ_Cpg_"..i):setVisible(false)
					end
				end
			end 
		else
			CpgNode:setVisible(false)
		end
	end

	if not self._allPlayerHandCardsNode[direction] then
		return
	end
	self._allPlayerHandCards[direction] = self._allPlayerHandCards[direction] or {}


	--local CpgCount = #self._allPlayerCpgCards)[direction]--吃椪杠的个数

	local startIndex = chiPengCount * 3 + gangCount * 3
	print("吃椪杠的个数", chiPengCount, gangCount, startIndex)
	local initIndex = 1
	for i=1,14 do
		if direction ~= self.POSITION_TYPE.NAN then--不是自己
			if i <= startIndex then
				self._allPlayerHandCardsNode[direction][i]:setVisible(false)
			else
				self._allPlayerHandCardsNode[direction][i]:setVisible(true)
			end
		else
			if i <= startIndex then
				self._allPlayerHandCardsNode[direction][i]:setVisible(false)
			else
				local card = self._allPlayerHandCardsNode[direction][i]
				
				if self._allPlayerHandCards[direction][initIndex] and card then
					card:setVisible(true)
					local value = self._allPlayerHandCards[direction][initIndex]--手牌值
					local node = card:getChildByName("Node_Mj")
					local face = node:getChildByName("Sprite_Face")

					if node and face then
						local cardType = math.floor(value / 10) + 1
						local cardValue = value % 10
						face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
						node:getChildByName("Image_Bg"):setTag(value)
						node:getChildByName("Image_Bg")["CardIndex"] = i
					end
					initIndex = initIndex + 1
				else
					if card then
						card:setVisible(face)
					end
				end
			end
		end
	end
end

function GameRoomLayer:checkMyHandStatu() --检测吃椪杠
    local tObjCpghObj = {
        tObjChi = nil,
        tObjPeng = nil,
        tObjGang = nil,
        tObjHu = nil--抢杠胡  自摸
    }
    --检测杠
	local tempHandCards = {}

	for k,v in pairs(self._allPlayerHandCards[self.POSITION_TYPE.NAN]) do
		table.insert(tempHandCards, v)
	end

	local anGangCards = lt.CommonUtil:getCanAnGangCards(tempHandCards) 
	dump(anGangCards)

	local pengGang = lt.CommonUtil:getCanPengGangCards(self._allPlayerCpgCards[self.POSITION_TYPE.NAN], tempHandCards)
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
	print("______fsdfsdf胡牌——————————————————————————", tostring(tempHandCards))
	if lt.CommonUtil:checkIsHu(tempHandCards, true) then
		print("自摸了###########################################")
		tObjCpghObj.tObjHu = {}
	else
		print("没有自摸###########################################")
	end

    --显示吃碰杠胡控件
    self:resetActionButtonsData(tObjCpghObj)--将牌的数据绑定到按钮上
	self:viewActionButtons(tObjCpghObj, false)
end

function GameRoomLayer:onClickCard(event) 


	if self.m_objCommonUi.m_nodeActionBtns:isVisible() then
		print("碰杠胡了不能点牌了")
		return
	end



	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", event:getTag(), event.CardIndex)

	--[[
	出牌处理

	在进入房间的时候记录一下14张牌的原始位置 originpos = {}

	出牌的时候将要出的牌的ui，从手牌里面抽出移动到桌面上该放的位置，
	放完之后再将这张ui的位置设置到originpos[index]对应的位置并隐藏 记录出去牌 outindex


	如果出的这张牌是最后一张则不用挪动其他牌的位置
	如果出的不是最后一张 便利所有手牌ui   

	当 value > getvalue的 indexs

	outindex < index   --这之间的牌统一向左移动一个牌位

	index < outindex --这之间的牌统一向右移动一个牌位
	将摸得牌放到index位置
	这些动作完成之后 将当前手牌排序 然后便利14个手牌ui将手牌值初始化
	]]


	local cardNode = self._allPlayerHandCardsNode[self.POSITION_TYPE.NAN][event.CardIndex]
	if not cardNode then
		return
	end
	local value = event:getTag()
	if self._currentOutPutPlayerPos == lt.DataManager:getMyselfPositionInfo().user_pos then
		print("出牌", value)

		-- local node =  self._allPlayerOutCards[self.POSITION_TYPE.NAN][1]
		-- local face = node:getChildByName("Sprite_Face")

		-- local cardType = math.floor(event:getTag() / 10) + 1
		-- local cardValue = event:getTag() % 10
		-- face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
		-- node:setVisible(true)
		-- node:setTag(event:getTag())
		-- table.remove(self._allPlayerOutCards[self.POSITION_TYPE.NAN], 1)
		-- table.insert(self._allPlayerOutInitCards[self.POSITION_TYPE.NAN], node)

		-- for k,card in pairs(self._mySelfHandCards) do  self._allPlayerHandCards[direction]
		-- 	if card == value then
		-- 		table.remove(self._mySelfHandCards, k)
		-- 		break
		-- 	end
		-- end

		-- self:configAllPlayerCards(pos)
		print("___________________________", value)
		local arg = {command = "PLAY_CARD", card = value}
		lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
	end

	-- if not event.statu or event.statu == 0 then
	-- 	if self._currentMoveCard then
	-- 		local move = cc.MoveBy:create(0.5, cc.p(0, -event:getContentSize().height / 4))
	-- 		self._currentMoveCard:runAction(move)
	-- 		self._currentMoveCard.statu = 0 --静牌
	-- 	end

	-- 	local move = cc.MoveBy:create(0.5, cc.p(0, 40))
	-- 	cardNode:runAction(move)
	-- 	event.statu = 1--待出
	-- 	self._currentMoveCard = event
	-- 	print("________________=====================______________________________________")
	-- elseif event.statu == 1 then--再次点击出牌
	-- 	print("_________________------------------------_____________________________________")
	-- 	local moveBack = cc.MoveBy:create(0.5, cc.p(0, -event:getContentSize().height / 4))


	-- 	local move = cc.MoveTo:create(0.5, ccp(self._allPlayerOutCards[self.POSITION_TYPE.NAN][1]:getPositionX(), self._allPlayerOutCards[self.POSITION_TYPE.NAN][1]:getPositionY()))
	-- 	local scale = cc.ScaleTo:create(0.5, 0.52, 0.52)
	-- 	local spawn = cc.Spawn:create(move, scale)

	-- 	local func = cc.CallFunc:create(
	-- 		function ( )
	-- 			self._currentMoveCard = nil

	-- 			local node =  self._allPlayerOutCards[self.POSITION_TYPE.NAN][1]
	-- 			local face = node:getChildByName("Sprite_Face")

	-- 			local cardType = math.floor(event:getTag() / 10) + 1
	-- 			local cardValue = event:getTag() % 10
	-- 			face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
	-- 			node:setVisible(true)
	-- 			node:setTag(event:getTag())
	-- 			table.remove(self._allPlayerOutCards[self.POSITION_TYPE.NAN], 1)
	-- 			if not self._allPlayerOutInitCards[self.POSITION_TYPE.NAN] then
	-- 				self._allPlayerOutInitCards[self.POSITION_TYPE.NAN] = {}
	-- 			end

	-- 			table.insert(self._allPlayerOutInitCards[self.POSITION_TYPE.NAN], node)
	-- 		end
	-- 		)

	-- 	local seque = cc.Sequence:create(moveBack, spawn, func)
	-- 	cardNode:runAction(seque)
	-- end
end

function GameRoomLayer:onSetClick(event) 

	local setLayer = lt.SettingLayer.new()
    lt.UILayerManager:addLayer(setLayer, true)
end

function GameRoomLayer:onRuleClick(event) 

end

function GameRoomLayer:onSitDownClick(event) 
	print("**********************************", event:getTag())

	self._selectPositionNode = event

	local arg = {pos = event:getTag()}--weixin
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.SIT_DOWN, arg)
end

function GameRoomLayer:onStartAgainClick(event) --继续游戏
	--重新整理界面
	self._resultLayer:setVisible(false)
	for i,v in ipairs(self._allLieFaceCardNode) do
		v:removeFromParent()
	end
	self._allLieFaceCardNode = {}

	self:initGame()

	--self._selectPositionNode = nil
	local arg = {pos = lt.DataManager:getMyselfPositionInfo().user_pos}--weixin
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.SIT_DOWN, arg)
end

function GameRoomLayer:onSitDownResponse(msg) 
	print("__________________________", msg.result)
    if msg.result == "success" then
	    print("入座成功")
	    self:configRotation(true)
    else
        print("入座失败")
    end
end

function GameRoomLayer:onDealDown(msg)   --发牌13张手牌

	self._allPlayerHandCards[self.POSITION_TYPE.NAN] = {}

	self._zhuangPos = msg.zpos

	--显示庄家

	for pos,SitPos in pairs(self._currentSitPosArray) do
		if pos == self._zhuangPos then
			self._zhuangDirection =  SitPos.atDirection
		end

		if self._zhuangDirection and self._currentPlayerLogArray[self._zhuangDirection] then
			self._currentPlayerLogArray[self._zhuangDirection]:getChildByName("Sprite_Zhuang"):setVisible(true)
		end
	end

	for i,card in ipairs(msg.cards) do
		table.insert(self._allPlayerHandCards[self.POSITION_TYPE.NAN], card)

	end
	local sortFun = function(a, b)
		return a < b
	end

	table.sort(self._allPlayerHandCards[self.POSITION_TYPE.NAN], sortFun)

	--播放筛子动画
	local action_node = cc.CSLoader:createNode("game/mjcomm/csb/base/ShaiZiAni.csb")
	self:addChild(action_node)
	local tlAct = cc.CSLoader:createTimeline("game/mjcomm/csb/base/ShaiZiAni.csb")
	action_node:getChildByName("pointNum_1"):setVisible(false)
	action_node:getChildByName("pointNum_2"):setVisible(false)

	local func = function ( frame )
		local event = frame:getEvent()
		if event == "END" then
			local random1 = math.random(1,6)
			local random2 = math.random(1,6)

			local num1 = "game/mjcomm/animation/aniShaiZi/aniShaiZi_"..random1..".png"
			local num2 = "game/mjcomm/animation/aniShaiZi/aniShaiZi_"..random2..".png"
			action_node:getChildByName("action_1"):setVisible(false)
			action_node:getChildByName("action_2"):setVisible(false)
			action_node:getChildByName("pointNum_1"):setVisible(true)
			action_node:getChildByName("pointNum_2"):setVisible(true)
			action_node:getChildByName("pointNum_1"):setSpriteFrame(num1)
			action_node:getChildByName("pointNum_2"):setSpriteFrame(num2)


    		local delay = cc.DelayTime:create(0.5)

    		local removeShaiZi = function( )
    			action_node:removeFromParent()
    		end


    		local func1 = cc.CallFunc:create(removeShaiZi)

    		local func2 = cc.CallFunc:create(handler(self, self.configSendCards))--发牌


      		local sequence = cc.Sequence:create(delay, func1, func2)
      		self:runAction(sequence)

		end
	end
	
 	action_node:runAction(tlAct)
	tlAct:gotoFrameAndPlay(0, false)
    tlAct:clearFrameEventCallFunc() 
    tlAct:setFrameEventCallFunc(func)
end

function GameRoomLayer:onClickSelectCard(event) --多 选择
	print("__________________________多选择")
	
	dump(event.selectCardData)
	if event.selectCardData then
		if event.selectCardData.card and event.selectCardData.type then
			if event.selectCardData.type == 1 then--吃碰杠胡

			elseif event.selectCardData.type == 2 then
				local arg = {command = "PENG"}
				lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
			elseif event.selectCardData.type == 3 then
				-- local arg = {command = "GANG", card = event.selectCardData.card }
				-- lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)

				self:onGangAction(event.selectCardData.card, 1)

			elseif event.selectCardData.type == 4 then
				local arg = {command = "HU"}
				lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
			end
		end
	else
		print("选择数据出错！！！！！")
	end
	self:viewHideActPanelAndMenu()
end

function GameRoomLayer:onPushSitDown(msg) --推送坐下的信息  

	if msg.room_id == lt.DataManager:getGameRoomInfo().room_id then

		local sitList = msg.sit_list or {}

		for i,player in ipairs(lt.DataManager:getGameRoomInfo().players) do
			player.is_sit = false
			for k,sitPlayer in ipairs(sitList) do
				if player.user_id == sitPlayer.user_id then
					player.is_sit = true
					player.user_pos = sitPlayer.user_pos
					break
				end
			end
		end
	end
	if not self._resultLayer:isVisible() then
		lt.GameEventManager:post(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO)
	end
end

function GameRoomLayer:onPushDrawCard(msg)   --通知其他人有人摸牌 

	--检测是否胡牌

	if not msg.user_pos or not msg.card then
		print("摸牌出错！！！！！！！！！！！")
		return
	end

	if lt.DataManager:getMyselfPositionInfo().user_pos == msg.user_pos then 

		--检测自己的手牌情况  --吃椪杠胡
		--self:checkMyHandStatu()
		self._ischeckMyHandStatu = true
	end

	-- local value = msg.card
	-- print("!!!!!!!!!!!!!!!!!",  msg.user_pos)
	-- if lt.DataManager:getMyselfPositionInfo().user_pos == msg.user_pos then

	-- else
	-- 	local direction = self:getPlayerDirectionByPos(msg.user_pos)
	-- 	if direction and self._allPlayerHandCardsNode[direction] then
	-- 		self._allPlayerHandCardsNode[direction][14]:setVisible(true)
	-- 	end

	-- end
end

function GameRoomLayer:onPushPlayCard(msg)   --通知玩家该出牌了 
	self._currentOutPutPlayerPos = msg.user_pos

	msg.card_list = msg.card_list or {}
	msg.peng_list = msg.peng_list or {}
	msg.gang_list = msg.gang_list or {}

	if msg.user_pos ==  lt.DataManager:getMyselfPositionInfo().user_pos then--自己

		self._allPlayerHandCards[self.POSITION_TYPE.NAN] = {}

		self._allPlayerCpgCards[self.POSITION_TYPE.NAN] = {}

		--摸牌 ->出牌
		local newCard = nil

		if msg.operator == 2 then--     还有没有摸牌不能胡牌
			print("碰出牌")
			self._ischeckMyHandStatu = false
			for i,card in ipairs(msg.card_list) do
				table.insert(self._allPlayerHandCards[self.POSITION_TYPE.NAN], card)
			end
		else
			self._ischeckMyHandStatu = true
			newCard = msg.card_list[#msg.card_list]--摸到的牌
			for i,card in ipairs(msg.card_list) do
				if i ~= #msg.card_list then
					table.insert(self._allPlayerHandCards[self.POSITION_TYPE.NAN], card)
				end
			end
		end

		if msg.card_stack then
			for i,cardInfo in ipairs(msg.card_stack) do--吃椪杠

				local info = {}
				info["value"] = cardInfo.value
				info["gang_type"] = cardInfo.gang_type
				info["from"] = cardInfo.from
				info["type"] = cardInfo.type

				table.insert(self._allPlayerCpgCards[self.POSITION_TYPE.NAN], info)
			end
		end

		local sortFun = function(a, b)
			return a < b
		end

		table.sort( self._allPlayerHandCards[self.POSITION_TYPE.NAN], sortFun)
		if newCard then
			table.insert(self._allPlayerHandCards[self.POSITION_TYPE.NAN], newCard)--将新摸得牌放到最后14号位
		end
		print("________________________________________")
		self:configAllPlayerCards(self.POSITION_TYPE.NAN)

		if self._ischeckMyHandStatu then--杠地开花
			self:checkMyHandStatu()
			self._ischeckMyHandStatu = false
		end

	else--不是本人
		if msg.operator == 1 then--     还有没有摸牌不能胡牌
			local direction = self:getPlayerDirectionByPos(msg.user_pos)
			if direction and self._allPlayerHandCardsNode[direction] then
				self._allPlayerHandCardsNode[direction][14]:setVisible(true)
			end
		end
	end
end

function GameRoomLayer:onNoticePlayCard(msg)   --通知其他人有人出牌 

	local value = msg.card
	local direction = self:getPlayerDirectionByPos(msg.user_pos) 
	if not direction then
		return 
	end

	if msg.user_pos ==  lt.DataManager:getMyselfPositionInfo().user_pos then--自己

		self._allPlayerHandCards[direction] = self._allPlayerHandCards[direction] or {}

		for index,card in pairs(self._allPlayerHandCards[direction]) do
			if card == value then
				table.remove(self._allPlayerHandCards[direction], index)
				break
			end
		end

		self:configAllPlayerCards(self.POSITION_TYPE.NAN)
	else
		local direction = self:getPlayerDirectionByPos(msg.user_pos)
		if direction and self._allPlayerHandCardsNode[direction] then
			self._allPlayerHandCardsNode[direction][14]:setVisible(false)
		end
		
	end
	
	if self._allPlayerOutCards[direction] then
		local node =  self._allPlayerOutCards[direction][1]
		local face = node:getChildByName("Sprite_Face")

		local cardType = math.floor(value / 10) + 1
		local cardValue = value % 10
		face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
		node:setVisible(true)
		node:setTag(value)
		table.remove(self._allPlayerOutCards[direction], 1)

		if not self._allPlayerOutInitCards[direction] then
			self._allPlayerOutInitCards[direction] = {}
		end

		table.insert(self._allPlayerOutInitCards[direction], node)
	end

end

function GameRoomLayer:onNoticePengCard(msg)   --通知其他人有人碰牌 

	local direction = self:getPlayerDirectionByPos(msg.user_pos) 
	if not direction then
		return
	end

	local info = nil
	if msg.item then
		info = {}
		info["value"] = msg.item["value"]
		info["gang_type"] = msg.item["gang_type"]
		info["from"] = msg.item["from"]
		info["type"] = msg.item["type"]

	end

	if not self._allPlayerCpgCards[direction] then
		self._allPlayerCpgCards[direction] = {}
	end
	if info then
		table.insert(self._allPlayerCpgCards[direction], info)

		self:configAllPlayerCards(direction)
	end
end

function GameRoomLayer:onNoticeGangCard(msg)   --通知其他人有人杠牌 
	local direction = self:getPlayerDirectionByPos(msg.user_pos) 
	if not direction then
		return
	end

	local info = nil
	if msg.item then
		info = {}
		info["value"] = msg.item["value"]
		info["gang_type"] = msg.item["gang_type"]
		info["from"] = msg.item["from"]
		info["type"] = msg.item["type"]

	end

	if not self._allPlayerCpgCards[direction] then
		self._allPlayerCpgCards[direction] = {}
	end

	if info then
		local change = false
		for k,v in pairs(self._allPlayerCpgCards[direction]) do
			if v.value == info.value then--之前是碰  变成了回头杠
				change = true
				self._allPlayerCpgCards[direction][k] = info
				break
			end
		end

		if not change then
			table.insert(self._allPlayerCpgCards[direction], info)
		end

		self:configAllPlayerCards(direction)
	end
end

function GameRoomLayer:onPushPlayerOperatorState(msg)   --通知客户端当前 碰/杠 状态

	if msg.user_pos ==  lt.DataManager:getMyselfPositionInfo().user_pos then--自己


		-- if msg.card then--要吃椪杠的牌
		-- 	tabel.insert(data, msg.card)
		-- end

		--我的吃碰杠通知
        local tObjCpghObj = {
            tObjChi = nil,
            tObjPeng = nil,
            tObjGang = nil,
            tObjHu = nil--抢杠胡
        }
        if msg.operator_list then
	        for k,state in pairs(msg.operator_list) do

	        	if state == "PENG" then
	        		tObjCpghObj.tObjPeng = {}

	        		--table.insert(tObjCpghObj.tObjPeng, msg.card)
	        	elseif state == "GANG" then
	        		if msg.card then
	        			tObjCpghObj.tObjGang = {}
	        			table.insert(tObjCpghObj.tObjGang, msg.card)
	        		end
	        	elseif state == "HU" then--抢杠胡
	        		tObjCpghObj.tObjHu = {}

	        	end
	        end
        end

        --显示吃碰杠胡控件
        self:resetActionButtonsData(tObjCpghObj)--将牌的数据绑定到按钮上
        self:viewActionButtons(tObjCpghObj, true)
	end
end

function GameRoomLayer:setBtnEnabled(btn, bIsEnable)
    if btn == nil then
        return
    end
    local cDisable = cc.c3b(127, 127, 127)
    local cNormal = cc.c3b(255, 255, 255)

    btn:setVisible(bIsEnable)
    btn:setTouchEnabled(bIsEnable)
    btn:setColor(bIsEnable and cNormal or cDisable)
end

--显示吃碰杠胡按钮
function GameRoomLayer:viewActionButtons(tObjCpghObj, isPassSendMsg)
    --显示吃碰杠胡按钮

    if self.m_objCommonUi.m_btnChi then
        local isChi = tObjCpghObj.tObjChi ~= nil

        self:setBtnEnabled(self.m_objCommonUi.m_btnChi, isChi)
    end

    if self.m_objCommonUi.m_btnPeng then
        local isPeng = tObjCpghObj.tObjPeng ~= nil
        self:setBtnEnabled(self.m_objCommonUi.m_btnPeng, isPeng)
    end

    if self.m_objCommonUi.m_btnGang then
        local isGang = tObjCpghObj.tObjGang ~= nil
        self:setBtnEnabled(self.m_objCommonUi.m_btnGang, isGang)
    end

    if self.m_objCommonUi.m_btnTing then
        local isTing = tObjCpghObj.tObjTind ~= nil
        self:setBtnEnabled(self.m_objCommonUi.m_btnTing, isTing)
    end

    if self.m_objCommonUi.m_btnHu then
        local isHu = tObjCpghObj.tObjHu ~= nil
        self:setBtnEnabled(self.m_objCommonUi.m_btnHu, isHu)
    end

    self:setBtnEnabled(self.m_objCommonUi.m_btnPass, true)

    self.m_objCommonUi.m_btnPass.isPassSendMsg = isPassSendMsg --是否发请求

    local count = 0
    for k,v in pairs(tObjCpghObj) do
    	print("sdflsj!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!dfjsdjfsldjfsjfljsdfljs", k,tostring(v))
        count = count + 1
    end

    self.m_objCommonUi.m_nodeActionBtns:setVisible(count > 0)

    if count > 0 then --有按钮需要排位置
        local arr = self.m_objCommonUi.m_nodeActionBtns:getChildren()
        local arrBtn = {}
        for i = 1, #arr do
            local isBtn = arr[i]:getDescription() == "Button" 

            if isBtn and arr[i]:isVisible() then
                table.insert(arrBtn, arr[i])
            end
        end

        --按照x轴排序
        local function comps(a,b)
            return a.orgPos.x < b.orgPos.x
        end

        table.sort(arrBtn, comps)

        --从右往左排位置
        local lastX = self.m_objCommonUi.m_btnPass.orgPos.x + self.m_objCommonUi.m_btnPass:getContentSize().width * self.m_objCommonUi.m_btnPass:getScaleX()
        for i = #arrBtn, 1, -1 do
            arrBtn[i]:setPositionX(lastX - (arrBtn[i]:getContentSize().width * arrBtn[i]:getScaleX()))
            lastX = arrBtn[i]:getPositionX()
        end
    end

end

function GameRoomLayer:resetActionButtonsData(tObjCpghObj)
    if self.m_objCommonUi.m_btnChi then
        self.m_objCommonUi.m_btnChi.tObjData = tObjCpghObj.tObjChi
    end
    if self.m_objCommonUi.m_btnPeng then
        self.m_objCommonUi.m_btnPeng.tObjData = tObjCpghObj.tObjPeng
    end
    if self.m_objCommonUi.m_btnGang then
    self.m_objCommonUi.m_btnGang.tObjData = tObjCpghObj.tObjGang
    end
    if self.m_objCommonUi.m_btnTing then
        self.m_objCommonUi.m_btnTing.tObjData = tObjCpghObj.tObjTing
    end
    if self.m_objCommonUi.m_btnHu then
        self.m_objCommonUi.m_btnHu.tObjData = tObjCpghObj.tObjHu
    end

    -- --判断是不是自摸胡，按钮显示不一样
    -- local isZm = self.m_objModel:getIsMeCurMo()
    -- local huBtnSkin = (isZm and not self.m_objModel:getMjConfig().isZmShowHuBtnAndAni) and "game/mjcomm/button/btnZm.png" or "game/mjcomm/button/btnHu.png"
    -- self.m_objCommonUi.m_btnHu:loadTextureNormal(huBtnSkin, 1)
    -- self.m_objCommonUi.m_btnHu:loadTexturePressed(huBtnSkin, 1)
    -- self.m_objCommonUi.m_btnHu:loadTextureDisabled(huBtnSkin, 1)
end

function GameRoomLayer:onClickCpghEvent(pSender)
    if pSender == self.m_objCommonUi.m_btnChi then
        -- if #pSender.tObjData > 1 then
        --     self:viewChiMenu(pSender.tObjData)
        -- else
        --     self:onChiAction(pSender.tObjData, 1)
        --     self:viewHideActPanelAndMenu()
        -- end
    elseif pSender == self.m_objCommonUi.m_btnPeng then

    	if #pSender.tObjData > 1 then
    		self:viewPengMenu(pSender.tObjData)
    	else
	    	self:onPengAction(pSender.tObjData, 1)
	        self:viewHideActPanelAndMenu()
    	end

    elseif pSender == self.m_objCommonUi.m_btnGang then

        if #pSender.tObjData > 1 then
            self:viewGangMenu(pSender.tObjData)
        elseif pSender.tObjData[1] then
            self:onGangAction(pSender.tObjData[1], 1)
            self:viewHideActPanelAndMenu()
        end

    elseif pSender == self.m_objCommonUi.m_btnTing then
        -- if self.onTingAction then
        --     self:onTingAction()
        -- else
        --     self.m_objCommonUi.m_btnTing:setEnabled(false)
        --     self.m_objCommonUi.m_btnTing:setVisible(false)
        --     self:viewDisableAllActionButtonsByTing()
        --     self:viewHandCardsByTing(self.m_objCommonUi.m_btnTing.tObjData.tObjCards)
        -- end
    elseif pSender == self.m_objCommonUi.m_btnHu then

        if #pSender.tObjData > 1 then
            self:viewHuMenu(pSender.tObjData)
        else
            self:onHuAction(pSender.tObjData, 1)
            self:viewHideActPanelAndMenu()
        end

    elseif pSender == self.m_objCommonUi.m_btnPass then
        if pSender.isPassSendMsg then
            self:onPassAction()
        else
            self:onPassClick()
            --self:refreshHandCards()
            --self.m_objModel.tObjCpghByMoPai = nil
            --重置倒计时
            --self:viewSendCardDelayTime({cTableNumExtra=self.m_objModel:getMeTableNumExtra()})
        end
        --self.m_objModel.m_chiPengGangTing = 0
        self:viewHideActPanelAndMenu()

    elseif pSender == self.m_objCommonUi.m_btnMenuPass then -- 二级菜单的【过】按钮
        if pSender.isPassSendMsg then
            self:onPassAction()
        else
            self:onPassClick()
        end
        self:viewHideActPanelAndMenu()
    -- elseif pSender == self.m_objCommonUi.m_btnToMin then
    --     if #self.m_objModel.m_tArrTingCards > 0 then
    --         self:showHuCardsTipsMj()
    --     else
    --         self:hideHuCardsTipsMj()
    --     end
    -- elseif pSender == self.m_objCommonUi.m_btnToMax then
    --     if #self.m_objModel.m_tArrTingCards > 0 then
    --         self:showHuCardsTipsMj(self.m_objModel.m_tArrTingCards, self.m_objModel.m_tArrTingCardsFan)
    --     else
    --         self:hideHuCardsTipsMj()
    --     end
    end
end


function GameRoomLayer:viewMenuBase(tObj, iType)
    self:viewHideActPanelAndMenu()
    
    -- tObj = {5, 16}
    -- iType = 3
    --显示二级菜单  getTouchEndPosition  getTouchBeganPosition
    local panelMenu = self.m_objCommonUi.m_panelMenuItems
    local iStartX = 0
    local iGap = 10
    local iPanelMenuWidth = 0
    for i = 1, #tObj do
        local uiItem = self:createMenuItem()
        uiItem:setScale(0.65)
		local value = tObj[i]

        local face = uiItem:getChildByName("Node_Mj"):getChildByName("Sprite_Face")
        local imageBg = uiItem:getChildByName("Node_Mj"):getChildByName("Image_Bg")
        imageBg.selectCardData = {card = value, type = iType}

		local cardType = math.floor(value / 10) + 1
		local cardValue = value % 10
		face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")

		panelMenu:addChild(uiItem)

		uiItem:setPosition(cc.p(iStartX, panelMenu:getContentSize().height/2 - uiItem:getBoundingBox().height/2))
		iStartX = iStartX + uiItem:getBoundingBox().width + iGap
		iPanelMenuWidth = iPanelMenuWidth + uiItem:getBoundingBox().width

		lt.CommonUtil:addNodeClickEvent(imageBg, handler(self, self.onClickSelectCard))
    end

    --添加

    iPanelMenuWidth = iPanelMenuWidth + (#tObj - 1) * iGap

    --胡牌提示滚动面板的实际尺寸
    local panelSize = cc.size(iPanelMenuWidth, panelMenu:getContentSize().height)
    --胡牌提示滚动面板的滚动尺寸
    panelMenu:setInnerContainerSize(panelSize)
    -- if panelSize.width > 300 then --长度超过了 x 就设置成x，同时允许滚动
    --     panelSize.width = 300
    --     self:setHuTipsScrollBarEnabled(panelMenu, true)
    -- else --否则有足够的空间，不需要滚动
    --     self:setHuTipsScrollBarEnabled(panelMenu, false)
    -- end
    panelMenu:setContentSize(panelSize)

    --背景变化
    local imgMenuBg = self.m_objCommonUi.m_imgCardsMenuBg
    imgMenuBg:setContentSize(cc.size(-panelMenu:getPositionX() + panelMenu:getContentSize().width + iGap, imgMenuBg:getContentSize().height))

    self.m_objCommonUi.m_nodeCardsMenu:setVisible(true)







end

--显示吃的二级菜单
function GameRoomLayer:viewChiMenu(tObj)
    self:viewMenuBase(tObj, 1)
end

--显示碰的二级菜单
function GameRoomLayer:viewPengMenu(tObj)
    self:viewMenuBase(tObj, 2)
end

--显示杠的二级菜单
function GameRoomLayer:viewGangMenu(tObj)
    self:viewMenuBase(tObj, 3)
end

--显示胡的二级菜单
function GameRoomLayer:viewHuMenu(tObj)
    self:viewMenuBase(tObj, 4)
end

function GameRoomLayer:viewHideActPanelAndMenu()
    self.m_objCommonUi.m_nodeActionBtns:setVisible(false)
    self.m_objCommonUi.m_nodeCardsMenu:setVisible(false)
end

function GameRoomLayer:createMenuItem()
    local mj = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjStandFaceItem.csb")

    return mj
end
	
function GameRoomLayer:createLieFaceItemByDirection(direction)

	local path = nil
	local mj = nil
	if direction == self.POSITION_TYPE.BEI then
		path = "game/mjcomm/csb/mjui/green/MjLieUpFaceItem.csb"
	elseif direction == self.POSITION_TYPE.XI then
		path = "game/mjcomm/csb/mjui/green/MjLieLeftFaceItem.csb"
	elseif direction == self.POSITION_TYPE.DONG then
		path = "game/mjcomm/csb/mjui/green/MjLieRightFaceItem.csb"
	end
	if path then
		mj = cc.CSLoader:createNode(path)
	end
    return mj
end

--发送碰按钮的请求
function GameRoomLayer:onPengAction(tObj, index)
	local arg = {command = "PENG"}
	lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
end

--发送杠按钮的请求
function GameRoomLayer:onGangAction(tObj, index)
	print("杠的牌@@@@@@@@@@@@@", tObj)
	local arg = {command = "GANG", card = tObj}
	lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
end

--发送胡按钮的请求
function GameRoomLayer:onHuAction(tObj, index)
	local arg = {command = "HU"}
	lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
end

--发送过按钮的请求
function GameRoomLayer:onPassAction()
	local arg = {command = "GUO"}
	lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
end

function GameRoomLayer:onPassClick()

end

function GameRoomLayer:onNoticeGameOver(msg)   --通知客户端 本局结束 带结算
	-- msg.over_type-- 1 正常结束 2 流局 3 房间解散会发送一个结算
	
	-- msg.award_list

	self._resultLayer:setVisible(true)
	local winner_pos = msg.winner_pos
	local winner_type = msg.winner_type or 1 --自摸 1 抢杠 2
	local last_round = msg.last_round

	if last_round then
		self._resultStartAgainBtn:setVisible(false)
		self._resultTotalEndBtn:setVisible(true)
		self._resultWeChatShareBtn:setVisible(false)
		self._resultLeaveRoomBtn:setVisible(false)
	else
		self._resultStartAgainBtn:setVisible(true)
		self._resultTotalEndBtn:setVisible(false)
		self._resultWeChatShareBtn:setVisible(false)
		self._resultLeaveRoomBtn:setVisible(false)
	end

	if not winner_pos then
		print("没有输赢!!!!!")
	end

	self._allPlayerGameOverData = {}
	self._allLieFaceCardNode = {}
	if msg.players then
		for k,v in ipairs(msg.players) do
			local direction = self:getPlayerDirectionByPos(v.user_pos)
			self._allPlayerGameOverData[direction] = v

			if v.card_list then
				table.sort(v.card_list, function(a, b)
					return a < b
				end)
			end 


			--推到手牌
			if direction ~= self.POSITION_TYPE.NAN and self._allPlayerHandCardsNode[direction] then--手牌
				local index = 1
				for i,node in ipairs(self._allPlayerHandCardsNode[direction]) do
					if node:isVisible() then
						local posRightNode = node:getChildByName("Node_PosRight")
						local lieFaceNode = self:createLieFaceItemByDirection(direction)
						if lieFaceNode then 
							local face = lieFaceNode:getChildByName("Sprite_Face")
							local Sprite_Back = lieFaceNode:getChildByName("Sprite_Back")
							Sprite_Back:setVisible(false)

							local value = nil
							if v.card_list[index] then
								value = v.card_list[index]
								local cardType = math.floor(value / 10) + 1
								local cardValue = value % 10
								face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")

								posRightNode:setVisible(true)
								posRightNode:addChild(lieFaceNode)
								table.insert(self._allLieFaceCardNode, lieFaceNode)
								index = index + 1
							end
						end
					end
				end
			end


			local node = self._currentPlayerResultNode[direction] 
			if node then
				local resultInfoItem = node:getChildByName("Node_ResultInfoItem")
				local winOrLostIcon = resultInfoItem:getChildByName("Sprite_WinOrLost")
				local imageBg = resultInfoItem:getChildByName("Image_Bg")
				local scrollView = resultInfoItem:getChildByName("ScrollView")
				scrollView:setVisible(false)

				local desText = imageBg:getChildByName("Text_Info1")
				desText:setString("")
				if winner_type == 1 then--自摸
					desText:setString("[自摸]")
				elseif winner_type == 2 then
					desText:setString("[抢杠胡]")
				end

				if not winner_pos then--流局
					winOrLostIcon:setSpriteFrame("game/mjcomm/words/wordResultLiuJu.png")
					resultInfoItem:setVisible(true)
				else

					local scrollNumber = node:getChildByTag(100)
					if not scrollNumber then
						scrollNumber = lt.ScrollNumber:create(12, "games/bj/game/part/numWin.png", "games/bj/game/part/numLost.png")
					end
					scrollNumber:setVisible(true)
					scrollNumber:setNumber(v.cur_score)
					node:addChild(scrollNumber)

					if winner_pos == v.user_pos then--是自己赢了
						resultInfoItem:setVisible(true)
						winOrLostIcon:setSpriteFrame("game/mjcomm/words/wordResultHuPai.png")
					else
						resultInfoItem:setVisible(false)
					end
				end

			end
		end
	end

	-- user_id
	-- user_pos
	-- cur_score
	-- score
	-- card_list
end

function GameRoomLayer:onRefreshScoreResponse(msg)   --玩家刷新积分（杠）

	self._allPlayerGameOverData = self._allPlayerGameOverData or {}
	for k,v in pairs(msg.cur_score_list) do

		local node = self._currentPlayerResultNode[v.user_pos] 
		if node and v.delt_score ~= 0 then
			local scrollNumber = node:getChildByTag(100)
			if not scrollNumber then
				scrollNumber = lt.ScrollNumber:create(12, "games/bj/game/part/numWin.png", "games/bj/game/part/numLost.png")
			end
			scrollNumber:setVisible(true)
			scrollNumber:setNumber(v.delt_score)
			node:addChild(scrollNumber)

			local func = function( )
				scrollNumber:setVisible(false)
			end
			local delay = cc.DelayTime:create(0.5)

			local func1 = cc.CallFunc:create(func)
			local sequence = cc.Sequence:create(delay, func1)
			node:runAction(sequence)
		end

		local direction = self:getPlayerDirectionByPos(v.user_pos)
		local logoNode = self._currentPlayerLogArray[direction]
		if logoNode then
			local scoreText = logoNode:getChildByName("Text_Amount")--99999

			if not self._allPlayerGameOverData[direction] then
				self._allPlayerGameOverData[direction] = {}
			end

			if not self._allPlayerGameOverData[direction].score then
				self._allPlayerGameOverData[direction].score = 0
			end
			scoreText:setString(self._allPlayerGameOverData[direction].score + v.delt_score)
		end
	end


end

function GameRoomLayer:onNoticePlayerConnectState(msg)   --玩家在线情况
	local direction = self:getPlayerDirectionByPos(msg.user_pos)
	local logoNode = self._currentPlayerLogArray[direction]
	if logoNode then
		if msg.is_connect then
			logoNode:getChildByName("Sprite_Disconnect"):setVisible(false) --断线标识
		else
			logoNode:getChildByName("Sprite_Disconnect"):setVisible(true) --断线标识
		end
	end

end

function GameRoomLayer:onGameCMDResponse(msg)   --游戏请求

end

function GameRoomLayer:onEnter()   
    print("GameRoomLayer:onEnter")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SIT_DOWN, handler(self, self.onSitDownResponse), "GameRoomLayer:onSitDownResponse")

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.DEAL_DOWN, handler(self, self.onDealDown), "GameRoomLayer.onDealDown")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_SIT_DOWN, handler(self, self.onPushSitDown), "GameRoomLayer.onPushSitDown")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_DRAW_CARD, handler(self, self.onPushDrawCard), "GameRoomLayer.onPushDrawCard")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_PLAY_CARD, handler(self, self.onPushPlayCard), "GameRoomLayer.onPushPlayCard")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_PLAY_CARD, handler(self, self.onNoticePlayCard), "GameRoomLayer.onNoticePlayCard")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_PENG_CARD, handler(self, self.onNoticePengCard), "GameRoomLayer.onNoticePengCard")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_GANG_CARD, handler(self, self.onNoticeGangCard), "GameRoomLayer.onNoticeGangCard")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_PLAYER_OPERATOR_STATE, handler(self, self.onPushPlayerOperatorState), "GameRoomLayer.onPushPlayerOperatorState")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_GAME_OVER, handler(self, self.onNoticeGameOver), "GameRoomLayer.onNoticeGameOver")

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO, handler(self, self.configPlayer), "GameRoomLayer.configPlayer")

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.GAME_CMD, handler(self, self.onGameCMDResponse), "GameRoomLayer.onGameCMDResponse")

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.REFRESH_PLAYER_CUR_SCORE, handler(self, self.onRefreshScoreResponse), "GameRoomLayer.onRefreshScoreResponse")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_PLAYER_CONNECT_STATE, handler(self, self.onNoticePlayerConnectState), "GameRoomLayer.onNoticePlayerConnectState")
end

function GameRoomLayer:onExit()
    print("GameRoomLayer:onExit")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.SIT_DOWN, "GameRoomLayer:onSitDownResponse")

    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.DEAL_DOWN, "GameRoomLayer:onDealDown")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_SIT_DOWN, "GameRoomLayer:onPushSitDown")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_DRAW_CARD, "GameRoomLayer:onPushDrawCard")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_PLAY_CARD, "GameRoomLayer:onPushPlayCard")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_PLAY_CARD, "GameRoomLayer:onNoticePlayCard")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_PENG_CARD, "GameRoomLayer:onNoticePengCard")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_GANG_CARD, "GameRoomLayer:onNoticeGangCard")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_PLAYER_OPERATOR_STATE, "GameRoomLayer:onPushPlayerOperatorState")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_GAME_OVER, "GameRoomLayer:onNoticeGameOver")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO, "GameRoomLayer:configPlayer")

    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.GAME_CMD, "GameRoomLayer:onGameCMDResponse")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.REFRESH_PLAYER_CUR_SCORE, "GameRoomLayer:onRefreshScoreResponse")
 	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_PLAYER_CONNECT_STATE, "GameRoomLayer:onNoticePlayerConnectState")
end


return GameRoomLayer