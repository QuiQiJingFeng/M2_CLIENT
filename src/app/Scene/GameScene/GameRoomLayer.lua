
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

	self:addChild(self._bgNode)
	self:addChild(self._cardsNode)
	self:addChild(self._playerNode)
	self:addChild(self._setNode)
	self:addChild(self._infoNode)


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

	--self._selectPosition = self.POSITION_TYPE.NAN
	self:hzmj2p()
	self:configCards()
	self:configPlayer()
	self:configRotation()

end

function GameRoomLayer:hzmj2p()  
	self._currentSitPosArray = {}--玩家入座时的位置
	self._currentPlayerLogArray = {}--玩家打牌中头像

	for pos,v in ipairs(self._allPlayerPosArray) do--西南
		if pos == self.POSITION_TYPE.XI or pos == self.POSITION_TYPE.NAN then
			if pos == self.POSITION_TYPE.XI then
				v:setPosition(self._allPlayerPosArray[self.POSITION_TYPE.BEI]:getPosition())
				v["atDirection"] = self.POSITION_TYPE.BEI
			else
				v["atDirection"] = self.POSITION_TYPE.NAN
			end
			v:setVisible(true)
			v:setTag(pos)
			self._currentSitPosArray[pos] = v
			lt.CommonUtil:addNodeClickEvent(v, handler(self, self.onSitDownClick))
		else
			v:setVisible(false)
		end
	end


	for pos,playerLogo in ipairs(self._playerLogoArray) do
		playerLogo:getChildByName("Fzb_Tips"):setVisible(false)
		playerLogo:getChildByName("Node_Warning"):setVisible(false)

		playerLogo:setVisible(false)

		if pos == self.POSITION_TYPE.BEI or pos == self.POSITION_TYPE.NAN then
			if pos == self.POSITION_TYPE.BEI then
				self._currentPlayerLogArray[self.POSITION_TYPE.XI] = playerLogo
			else
				self._currentPlayerLogArray[pos] = playerLogo
			end
			
			--lt.CommonUtil:addNodeClickEvent(playerLogo, handler(self, self.onSitDownClick))
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
	self._mySelfOutCards = {}
	self._topOutCards = {}
	for i=1,59 do
		table.insert(self._mySelfOutCards,panelOutCard:getChildByName("Node_OutCards_2"):getChildByName("MJ_Out_"..i))
	end
	--panelOutCard:getChildByName("Node_OutCards_1")--对面出的牌

	for i=1,59 do
		table.insert(self._topOutCards,panelOutCard:getChildByName("Node_OutCards_1"):getChildByName("MJ_Out_"..i))
	end

	self._pleaseOutCardTips = self._cardsNode:getChildByName("Sprite_OutCardTips")--请出牌


	local panelVertical = self._cardsNode:getChildByName("Panel_Vertical")--手牌

	self._topCpgCardsNode = {}
	self._topHandCardsNode = {}

	self._mySelfCpgCardsNode = {}
	self._mySelfHandCardsNode = {}

	-- panelVertical:getChildByName("Node_CpgCards_1")--对面吃碰杠
	-- panelVertical:getChildByName("Node_HandCards_1")--对面手牌 立着

	-- panelVertical:getChildByName("Node_CpgCards_2")--
	-- panelVertical:getChildByName("Node_HandCards_2")-- 

	for i=1,5 do
		table.insert(self._topCpgCardsNode, panelVertical:getChildByName("Node_CpgCards_1"):getChildByName("Layer_Cpg_"..i))
		table.insert(self._mySelfCpgCardsNode, panelVertical:getChildByName("Node_CpgCards_2"):getChildByName("Layer_Cpg_"..i))
	end

	for i=1,14 do
		table.insert(self._topHandCardsNode, panelVertical:getChildByName("Node_HandCards_1"):getChildByName("MJ_Stand_"..i))
		table.insert(self._mySelfHandCardsNode, panelVertical:getChildByName("Node_HandCards_2"):getChildByName("MJ_Stand_"..i))
	end

	self._curOutCardArrow = self._cardsNode:getChildByName("Node_CurOutCardArrow")--
end

function GameRoomLayer:configPlayer() 
    local gameRoomInfo = lt.DataManager:getGameRoomInfo()

    print("++++++++++++++++++++++++++++444444444444444444444444444444444")

    for i,v in pairs(self._currentSitPosArray) do--如果有玩家退房
    	if v:getChildByTag(1111) then
    		v:getChildByTag(1111):setString("")
    	end

    	if v:getChildByTag(2222) then
    		v:getChildByTag(2222):setString("")
    	end
    end

    for i,player in ipairs(gameRoomInfo.players) do

        -- info.user_id = 
        -- info.user_name = player.user_name
        -- info.user_pic = player.user_pic
        -- info.user_ip = player.user_ip
        -- info.user_pos = player.user_pos

		if self._currentPlayerLogArray[player.user_pos] then
			local name = self._currentPlayerLogArray[player.user_pos]:getChildByName("Text_Name")
			if name then
				name:setString(player.user_name)
			end
		end

		local sitNode = self._currentSitPosArray[player.user_pos]


        if sitNode then

        	if not sitNode:getChildByTag(1111) then
	        	local label = cc.Label:createWithSystemFont("" , "", 24)
	        	label:setTag(1111)
	        	sitNode:addChild(label)
        	end

        	if not sitNode:getChildByTag(2222) then
	        	local label = cc.Label:createWithSystemFont("准备OK" , "", 24)
	        	label:setTag(2222)
	        	sitNode:addChild(label)
        	end
        	if player.is_sit then
        		sitNode:getChildByTag(1111):setString(player.user_name)
        		sitNode:setVisible(true)
        		sitNode:getChildByTag(2222):setVisible(true)
        	else
        		sitNode:getChildByTag(2222):setVisible(false)
        		if player.user_id ~= lt.DataManager:getPlayerInfo().user_id then
        			sitNode:getChildByTag(1111):setString(player.user_name)
        		end
        	end
        end

     end
end


function GameRoomLayer:configCards() 

	for i,v in ipairs(self._topOutCards) do
		v:setVisible(false)
	end

	for i,v in ipairs(self._topCpgCardsNode) do
		v:setVisible(false)
	end

	for i,v in ipairs(self._topHandCardsNode) do
		v:setVisible(false)
	end

	for i,v in ipairs(self._mySelfOutCards) do
		v:setVisible(false)
	end

	for i,v in ipairs(self._mySelfCpgCardsNode) do
		v:setVisible(false)
	end
	
	for i,v in ipairs(self._mySelfHandCardsNode) do
		v:setVisible(false)
	end
end

function GameRoomLayer:configSendCards() --游戏刚开始的发牌

	for pos,SitPos in pairs(self._currentSitPosArray) do
		SitPos:setVisible(false)
	end

	for pos,playerLog in pairs(self._currentPlayerLogArray) do
		playerLog:setVisible(true)
		playerLog:getChildByName("Sprite_Zhuang"):setVisible(false)
	end

	-- self._topCpgCardsNode = {}
	-- self._topHandCardsNode = {}

	-- for i,v in ipairs(self._topHandCardsNode) do
	-- 	v:setVisible(true)
	-- end

	for i=1,13 do--发牌发13张
		if self._topHandCardsNode[i] then
			self._topHandCardsNode[i]:setVisible(true)
		end
	end

	-- self._mySelfCpgCardsNode = {}
	-- self._mySelfHandCardsNode = {}

	if self._currentPlayerLogArray[self._zhuangPos] then
		self._currentPlayerLogArray[self._zhuangPos]:getChildByName("Sprite_Zhuang"):setVisible(true)
	end

	for index,value in ipairs(self._mySelfHandCards) do
		local node = nil
		
		if self._mySelfHandCardsNode[index]:getChildByName("Node_Mj") then
			if self._mySelfHandCardsNode[index]:getChildByName("Node_Mj"):getChildByName("Sprite_Face") then
				node = self._mySelfHandCardsNode[index]:getChildByName("Node_Mj"):getChildByName("Sprite_Face")
			end
		end		

		if node then

			local cardType = math.floor(value / 10) + 1
			local cardValue = value % 10
			node:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
			self._mySelfHandCardsNode[index]:setVisible(true)

		end

	end

end

function GameRoomLayer:configRotation(isClick) 
	self._handSelect:setVisible(false)

	if isClick then
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


		local du = (self._selectPositionNode.atDirection - self.POSITION_TYPE.NAN) * 90
		local action = cc.RotateBy:create(0.5, du)

		local action2 = function ( )
			local action3 = cc.RotateBy:create(0.5, -du)
			self._selectPositionNode:runAction(action3)
		end

		local action1 = function ( )
			local action4 = cc.RotateBy:create(0.5, du)
			self._spriteDnxb:runAction(action4)
		end

		local spawn = cc.Spawn:create(cc.CallFunc:create(action1), action, cc.CallFunc:create(action2))
		self._nodeNoPlayer:runAction(spawn)
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



		local PosNum = #self._currentSitPosArray--不是数组

		if PosNum == 2 then--两个方向
			offPos = 2
		elseif PosNum == 3 or PosNum == 4 then
			offPos = 1
		end

		for pos,v in pairs(self._currentSitPosArray) do
			if pos == mySelfPosition then
				v["atDirection"] = self.POSITION_TYPE.NAN
			end

			local x = pos - mySelfPosition

			v["atDirection"] = self.POSITION_TYPE.NAN + x * offPos
		end

	end
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
	dump(msg)

	self._mySelfHandCards = {}

	self._zhuangPos = msg.zpos

	for i,card in ipairs(msg.cards) do
		table.insert(self._mySelfHandCards, card)

	end
	local sortFun = function(a, b)
		return a < b
	end

	table.sort( self._mySelfHandCards, sortFun)


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

    		local func2 = cc.CallFunc:create(handler(self, self.configSendCards))


      		local sequence = cc.Sequence:create(delay, func1, func2)
      		self:runAction(sequence)

		end
	end
	
 	action_node:runAction(tlAct)
	tlAct:gotoFrameAndPlay(0, false)
    tlAct:clearFrameEventCallFunc() 
    tlAct:setFrameEventCallFunc(func)
end

function GameRoomLayer:onPushSitDown(msg) --推送坐下的信息  
	dump(msg)

	if msg.room_id == lt.DataManager:getGameRoomInfo().room_id then

		local sitList = msg.sit_list or {}

		for i,player in ipairs(lt.DataManager:getGameRoomInfo().players) do

			for k,sitPlayer in ipairs(sitList) do
				if player.user_id == sitPlayer.user_id then
					player.is_sit = true
					player.user_pos = sitPlayer.user_pos
				end
			end
		end
	end
	lt.GameEventManager:post(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO)
end

function GameRoomLayer:onPushDrawCard(msg)   --通知其他人有人摸牌 
	dump(msg)
end

function GameRoomLayer:onPushPlayCard(msg)   --通知玩家该出牌了 
	dump(msg)
end

function GameRoomLayer:onNoticePlayCard(msg)   --通知其他人有人出牌 
	dump(msg)
end

function GameRoomLayer:onNoticePengCard(msg)   --通知其他人有人碰牌 
	dump(msg)
end

function GameRoomLayer:onNoticeGangCard(msg)   --通知其他人有人杠牌 
	dump(msg)
end

function GameRoomLayer:onPushPlayerOperatorState(msg)   --通知客户端当前 碰/杠 状态
	dump(msg)
end

function GameRoomLayer:onNoticeGameOver(msg)   --通知客户端 本局结束 带结算
	dump(msg)
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
end


return GameRoomLayer