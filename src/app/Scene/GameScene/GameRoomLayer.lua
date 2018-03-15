
local GameRoomLayer = class("GameRoomLayer", lt.BaseLayer)

GameRoomLayer.POSITION_TYPE = {
	XI = 1, 
	NAN = 2,
	DONG = 3,
	BEI = 4,
}

-- GameRoomLayer.POSITION_EXCHANGE = {
-- 	1 = 3,
-- 	2 = 4,
-- 	3 = 1,
-- 	4 = 2,
-- }


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

	--local Ie_Bg = self:getChildByName("Ie_Bg")

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
	self._nodeNoPlayer = self._playerNode:getChildByName("Node_NoPlayer")--两个方置 可以用来旋转

	self._handSelect = self._nodeNoPlayer:getChildByName("Node_SitDownTips")

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

end

function GameRoomLayer:hzmj2p()  

	for i=1,4 do--西南

		if i == self.POSITION_TYPE.XI then
			self._allPlayerPosArray[i]:setVisible(true)
			self._allPlayerPosArray[i]:setPosition(self._allPlayerPosArray[self.POSITION_TYPE.BEI]:getPosition())
			self._allPlayerPosArray[i]["atDirection"] = 4
		end

		if i == self.POSITION_TYPE.NAN then
			self._allPlayerPosArray[i]:setVisible(true)
			self._allPlayerPosArray[i]["atDirection"] = 2
		end

		if i == 3 or i == 4 then
			self._allPlayerPosArray[i]:setVisible(false)
		end
		self._allPlayerPosArray[i]:setTag(i)
		lt.CommonUtil:addNodeClickEvent(self._allPlayerPosArray[i], handler(self, self.onSitDownClick))
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

	self._topCpgCards = {}
	self._topHandCards = {}

	self._mySelfCpgCards = {}
	self._mySelfHandCards = {}

	-- panelVertical:getChildByName("Node_CpgCards_1")--对面吃碰杠
	-- panelVertical:getChildByName("Node_HandCards_1")--对面手牌 立着

	-- panelVertical:getChildByName("Node_CpgCards_2")--
	-- panelVertical:getChildByName("Node_HandCards_2")-- 

	for i=1,5 do
		table.insert(self._topCpgCards, panelVertical:getChildByName("Node_CpgCards_1"):getChildByName("Layer_Cpg_"..i))
		table.insert(self._mySelfCpgCards, panelVertical:getChildByName("Node_CpgCards_2"):getChildByName("Layer_Cpg_"..i))
	end

	for i=1,14 do
		table.insert(self._topHandCards, panelVertical:getChildByName("Node_HandCards_1"):getChildByName("MJ_Stand_14"..i))
		table.insert(self._mySelfHandCards, panelVertical:getChildByName("Node_HandCards_2"):getChildByName("MJ_Stand_14"..i))
	end

	self._curOutCardArrow = self._cardsNode:getChildByName("Node_CurOutCardArrow")--
end

function GameRoomLayer:configCards() 

	for i,v in ipairs(self._mySelfOutCards) do
		v:setVisible(false)
	end

	for i,v in ipairs(self._topOutCards) do
		v:setVisible(false)
	end

	for i,v in ipairs(self._topCpgCards) do
		v:setVisible(false)
	end

	for i,v in ipairs(self._topHandCards) do
		v:setVisible(false)
	end

	for i,v in ipairs(self._mySelfCpgCards) do
		v:setVisible(false)
	end
	
	for i,v in ipairs(self._mySelfHandCards) do
		v:setVisible(false)
	end
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
	    self._handSelect:setVisible(false)
	    for i,v in ipairs(self._allPlayerPosArray) do
	    	if v:getTag() ~= self._selectPositionNode:getTag() then
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
        print("入座失败")
    end
end

function GameRoomLayer:onDealDown(msg)   --发13张手牌
	dump(msg)
end

function GameRoomLayer:onPushSitDown(msg) --推送坐下的信息  
	dump(msg)
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
end


return GameRoomLayer