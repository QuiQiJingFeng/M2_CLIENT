
local GameRoomLayer = class("GameRoomLayer", lt.BaseLayer)
ENDRONDBS = 1
function GameRoomLayer:ctor()
	GameRoomLayer.super.ctor(self)

 --    local gameInfo = lt.DataManager:getGameRoomInfo()

 --    if gameInfo and gameInfo.room_setting and gameInfo.room_setting.game_type then
 --        gameid = gameInfo.room_setting.game_type
 --    end

	-- required int32 game_type = 1; 	 //游戏的类型
	-- required int32 round = 2;        //游戏的圈数
	-- required int32 pay_type = 3;     //支付类型 房主出资还是平摊
	-- required int32 seat_num = 4;     //游戏的人数
	-- required bool is_friend_room = 5; //是否只让好友进入
	-- required bool is_open_voice = 6; //是否开启语音聊天
	-- required bool is_open_gps = 7;   //是否开启GPS防作弊
	-- repeated int32 other_setting = 8; //具体游戏的设置	
	-- required int32 cur_round = 9;     //当前游戏的局数

	self._gameBgPanel = lt.GameBgPanel.new()--背景层

	self._gameCompassPanel = lt.GameCompassPanel.new(self)--罗盘层

	self._engine = lt.MjEngine:open(self)
	self._showCardsPanel = self._engine:getShowCardsLayer()
	self._gameCompassPanel:addChild(self._showCardsPanel)
	self:setClickEvent()

	self._gameSelectPosPanel = lt.GameSelectPosPanel.new(self, self._gameCompassPanel)--入座 玩家头像
	self._gameSetPanel = lt.GameSetPanel.new(self)--设置
	self._gameRoomInfoPanel = lt.GameRoomInfoPanel.new(self)--房间信息
	self._gameActionBtnsPanel = lt.GameActionBtnsPanel.new(self)--吃碰杠胡过
	self._gameResultPanel = lt.GameResultPanel.new(self, palyerNmu)--结算

	self:addChild(self._gameBgPanel)

	self:addChild(self._gameCompassPanel)

	self:addChild(self._gameSelectPosPanel)
	self:addChild(self._gameSetPanel)
	self:addChild(self._gameRoomInfoPanel)
	self:addChild(self._gameActionBtnsPanel)
	self:addChild(self._gameResultPanel)

    --结算界面
    self._gameResultPanel:setVisible(false)

	self:initGame()
	self.ApplyGameOverPanel = nil
end

function GameRoomLayer:initGame()  
	self._engine:setMingTingConfig()
	self._sendRequest = false
	self._gameSelectPosPanel:initGame()
	self._gameCompassPanel:initGame()

	self:hideHuCardsTipsMj()
	if lt.DataManager:isClientConnectAgain() then
		self:resetCurrentOutPutPlayerPos()
		self._engine:onClientConnectAgain()
		lt.DataManager:clearPushAllRoomInfo()
	end
end

function GameRoomLayer:getotersCard(value)
	local Num = self._engine:getotersCard(value)
    return Num
end

function GameRoomLayer:againConfigUI()  
	self._gameSelectPosPanel:againConfigUI()
	self._gameCompassPanel:initGame()

	self._engine:angainConfigUi()
end

function GameRoomLayer:resetCurrentOutPutPlayerPos()
	local allRoomInfo = lt.DataManager:getPushAllRoomInfo()
	self._currentOutPutPlayerPos = allRoomInfo.cur_play_pos
end

function GameRoomLayer:getCurrentOutPutPlayerPos()
	return self._currentOutPutPlayerPos
end

function GameRoomLayer:onGameConnectAgain()
	self._sendRequest = false
	if not lt.DataManager:isClientConnectAgainPlaying() then--入座界面
		self._gameSelectPosPanel:againConfigUI()
	end	
	self:resetCurrentOutPutPlayerPos()
	self._gameCompassPanel:initGame()
	self._engine:onClientConnectAgain()
	self:hideHuCardsTipsMj()
	lt.DataManager:clearPushAllRoomInfo()
end

function GameRoomLayer:sendAutoSitDown() 
	if self._gameResultPanel:isVisible() then
		self._gameResultPanel:onStartAgainClick()
	end
end

function GameRoomLayer:getPlayerDirectionByPos(playerPos) 
	if not playerPos then
		return nil
	end
	return self._gameSelectPosPanel:getPlayerDirectionByPos(playerPos)
end

function GameRoomLayer:resetActionButtonsData(tObjCpghObj)
	self._gameActionBtnsPanel:resetActionButtonsData(tObjCpghObj)
end

function GameRoomLayer:viewActionButtons(tObjCpghObj, isPassSendMsg)
	self._gameActionBtnsPanel:viewActionButtons(tObjCpghObj, isPassSendMsg)
end

function GameRoomLayer:viewHideActPanelAndMenu(tObjCpghObj, isPassSendMsg)
	self._gameActionBtnsPanel:viewHideActPanelAndMenu()
end

--胡牌tips

function GameRoomLayer:refreshHuCardNum(info, type)
	self._gameActionBtnsPanel:refreshHuCardNum(info, type)
end

function GameRoomLayer:showHuCardsTipsMj()
	self._gameActionBtnsPanel:showHuCardsTipsMj()
end

function GameRoomLayer:hideHuCardsTipsMj()
	self._gameActionBtnsPanel:hideHuCardsTipsMj()
end

function GameRoomLayer:hideHuCardsContent()
	self._gameActionBtnsPanel:hideHuCardsContent()
end

function GameRoomLayer:viewHuCardsTipsMenu(canHuCards)
	self._gameActionBtnsPanel:viewHuCardsTipsMenu(canHuCards)
end

function GameRoomLayer:checkMyHandTingStatu(bool)
	self._engine:checkMyHandTingStatu(bool)
end

function GameRoomLayer:checkMyHandButtonActionStatu(handList,state) --检测吃椪杠
	local tObjCpghObj = self._engine:checkMyHandButtonActionStatu(handList,state) 
    --显示吃碰杠胡控件
    self:resetActionButtonsData(tObjCpghObj)--将牌的数据绑定到按钮上
	self:viewActionButtons(tObjCpghObj, false)
end

function GameRoomLayer:showCardsNum() 
	self._gameCompassPanel:showCardsNum()
end

function GameRoomLayer:setClickEvent() 
	self._engine:setClickCardCallBack(handler(self, self.onClickCard))
end

function GameRoomLayer:autoPutOutCard() 
	self._engine:autoPutOutCard()
end

function GameRoomLayer:isVisibleGameActionBtnsPanel() 
	return self._gameActionBtnsPanel.m_objCommonUi.m_nodeActionBtns:isVisible()
end

function GameRoomLayer:onClickCard(value,state) 

	if self._sendRequest then
		return
	end

	if self:isVisibleGameActionBtnsPanel() then
		lt.CommonUtil.print("碰杠胡了不能点牌了")
		return
	end
	if lt.DataManager:getGameRoomSetInfo().game_type == lt.Constants.GAME_TYPE.HZMJ then
		if value == lt.Constants.HONG_ZHONG_VALUE then
			return
		end
	end
	
	if self._currentOutPutPlayerPos and self._currentOutPutPlayerPos == lt.DataManager:getMyselfPositionInfo().user_pos then
		lt.CommonUtil.print("出牌########################", value)
		if not state or state == 1 then
			lt.CommonUtil.print("普通出牌")
			local arg = {command = "PLAY_CARD", card = value}--普通出牌
			self._sendRequest = true
			self._engine:goOutOneHandCardAtDirection(lt.Constants.DIRECTION.NAN, value)
			lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
		elseif state == 2 then
			lt.CommonUtil.print("听牌出牌")
			local arg = {command = "TING_CARD", card = value}--听牌出牌

			self._sendRequest = true
			self._engine:goOutOneHandCardAtDirection(lt.Constants.DIRECTION.NAN, value)

			lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
			local direction = self:getPlayerDirectionByPos(lt.DataManager:getMyselfPositionInfo().user_pos)
			self._gameSelectPosPanel:ShowTingBS(direction)
		end
	else
		lt.CommonUtil.print("不该自己出牌！！！！！！！！！！")
	end
end

function GameRoomLayer:sendDealFinish()--发牌动画执行完成
	local arg = {command = "DEAL_FINISH"}
	lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
	self:showCardsNum()
end

function GameRoomLayer:onDealDown(msg)--发牌
	-- --显示庄家
	-- self._zhuangDirection = self._deleget:getPlayerDirectionByPos(self._zhuangPos)

	-- if self._zhuangDirection and self._currentPlayerLogArray[self._zhuangDirection] then
	-- 	self._currentPlayerLogArray[self._zhuangDirection]:getChildByName("Sprite_Zhuang"):setVisible(true)
	-- end
    if lt.DataManager:getRePlayState() then
    	for i=1,#msg do

    		for k,v in pairs(msg[i]) do
    			--local direction = self:getPlayerDirectionByPos(v.user_pos)
    			--self._engine:sendCards(v.cards, direction, v.four_card_list) 
    			self._engine:sendCards(v, v.user_pos)
    		end
    	end
    else
    	self._zhuangPos = msg.zpos

		--播放筛子动画
		local action_node = cc.CSLoader:createNode("game/mjcomm/csb/base/ShaiZiAni.csb")
		self:addChild(action_node)
		local tlAct = cc.CSLoader:createTimeline("game/mjcomm/csb/base/ShaiZiAni.csb")
		action_node:getChildByName("pointNum_1"):setVisible(false)
		action_node:getChildByName("pointNum_2"):setVisible(false)

		local func = function ( frame )
			local event = frame:getEvent()
			if event == "END" then
				local random1 = msg.random_nums[1]
				local random2 = msg.random_nums[2]

				local num1 = "game/mjcomm/animation/aniShaiZi/aniShaiZi_"..random1..".png"
				local num2 = "game/mjcomm/animation/aniShaiZi/aniShaiZi_"..random2..".png"
				action_node:getChildByName("action_1"):setVisible(false)
				action_node:getChildByName("action_2"):setVisible(false)
				action_node:getChildByName("pointNum_1"):setVisible(true)
				action_node:getChildByName("pointNum_2"):setVisible(true)
				action_node:getChildByName("pointNum_1"):setSpriteFrame(num1)
				action_node:getChildByName("pointNum_2"):setSpriteFrame(num2)


	    		local delay = cc.DelayTime:create(1)

	    		local removeShaiZi = function( )
	    			action_node:removeFromParent()
	    		end

	    		local sendCards = function( )
	    			--self._engine:sendCards(msg.cards, lt.Constants.DIRECTION.NAN, msg.four_card_list)
	    			self._engine:sendCards(msg, msg.user_pos)
	    		end

	    		local func1 = cc.CallFunc:create(removeShaiZi)

	    		local func2 = cc.CallFunc:create(sendCards)--发牌


	      		local sequence = cc.Sequence:create(delay, func1, func2)
	      		self:runAction(sequence)

			end
		end
		
	 	action_node:runAction(tlAct)
		tlAct:gotoFrameAndPlay(0, false)
	    tlAct:clearFrameEventCallFunc() 
	    tlAct:setFrameEventCallFunc(func)
	    self._gameSelectPosPanel:HideReady()
	end
end

function GameRoomLayer:onPushDrawCard(msg)--通知有人摸牌

	local direction = self:getPlayerDirectionByPos(msg.user_pos)
	self._engine:getOneHandCardAtDirection(direction, msg.card)--起了一张牌
	self._engine:configAllPlayerCards(direction, false, true, false, false)

	if lt.DataManager:getMyselfPositionInfo().user_pos == msg.user_pos then 

		--检测自己的手牌情况  --吃椪杠胡
		--self:checkMyHandStatu()
		self._ischeckMyHandStatu = true

		self:refreshHuCardNum(msg.card, 1)
	end
end

function GameRoomLayer:onPushPlayCard(msg)--通知该出牌
	self._currentOutPutPlayerPos = msg.user_pos
	msg.card_list = msg.card_list or {}

	local direction = self:getPlayerDirectionByPos(msg.user_pos)
	if msg.user_pos ==  lt.DataManager:getMyselfPositionInfo().user_pos then--自己
		self._sendRequest = false
		local handList = {}
		local cpgList = {}
		--摸牌 ->出牌
		local newCard = nil
		
		if msg.operator == 2 then--     还有没有摸牌不能胡牌
			lt.CommonUtil.print("碰出牌")
			self._ischeckMyHandStatu = false
			for i,card in ipairs(msg.card_list) do
				table.insert(handList, card)
			end
		else
			self._ischeckMyHandStatu = true
			newCard = msg.card_list[#msg.card_list]--摸到的牌
			for i,card in ipairs(msg.card_list) do
				if i ~= #msg.card_list then
					table.insert(handList, card)
				end
			end
		end

		if msg.card_stack then
			for i,cardInfo in ipairs(msg.card_stack) do--吃椪杠

				local info = {}
				info["value"] = cardInfo.value
				info["from"] = cardInfo.from
				info["type"] = cardInfo.type

				table.insert(cpgList, info)
			end
		end

		local sortFun = function(a, b)
			return a < b
		end

		table.sort(handList, sortFun)
		if newCard then
			table.insert(handList, newCard)--将新摸得牌放到最后14号位
		end

		self._engine:updateNanHandCardValue(lt.Constants.DIRECTION.NAN, handList, msg.four_card_list)
		self._engine:updateNanCpgCardValue(lt.Constants.DIRECTION.NAN, cpgList)
		self._engine:configAllPlayerCards(lt.Constants.DIRECTION.NAN, true, true, false, false)
		
		self:checkMyHandButtonActionStatu(handList, self._ischeckMyHandStatu)--暗杠  回头杠 胡 听
		self._ischeckMyHandStatu = false

	else--不是本人

		self._engine:updateLightCardValue(msg.four_card_list)
		self._engine:configAllPlayerCards(direction, false, true, false, false)
	end
	
	self._gameSelectPosPanel:ShowLightRing(direction)
end

function GameRoomLayer:onNoticePlayCard(msg)--通知其他人有人出牌
	self._currentOutPutPlayerPos = nil

	local value = msg.card
	local direction = self:getPlayerDirectionByPos(msg.user_pos) 
	if not direction or not value then
		return 
	end

	local specialRefresh = false
	if value then

		for i,v in ipairs(lt.Constants.ADD_CARD_VALUE_TABLE3) do
			if value == v then--补花	
				local info = {
					user_pos = msg.user_pos,
					card = msg.card
				}
				specialRefresh = true
				-- if msg.user_pos ~= lt.DataManager:getMyselfPositionInfo().user_pos then
				-- 	self._engine:goOutOneHandSpecialCardAtDirection(direction, value)
				-- end
				lt.GameEventManager:post(lt.GameEventManager.EVENT.NOTICE_SPECIAL_BUFLOWER, info)
				break
			end
		end
	end

	--把这张牌加到out  先通知noticeSpecial 再 NoticePlayCard
	self._engine:getOneOutCardAtDirection(direction, value, specialRefresh)
	
	if msg.user_pos ~= lt.DataManager:getMyselfPositionInfo().user_pos then
		self:refreshHuCardNum(msg.card, 2)
	end

	--其他玩家从手牌中去掉  （自己的在点击牌出牌的时候处理）
	if lt.DataManager:getRePlayState() then
		self._engine:goOutOneHandCardAtDirection(direction, value)
	else
		if msg.user_pos ~= lt.DataManager:getMyselfPositionInfo().user_pos then
			self._engine:goOutOneHandCardAtDirection(direction, value)
		end
	end

	self._engine:configAllPlayerCards(direction, false, true, true, specialRefresh)
end

function GameRoomLayer:onPushPlayerOperatorState(msg)--通知客户端当前 碰/杠 状态

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

function GameRoomLayer:onRefreshGameOver(msg)--通知客户端 本局结束 带结算
	-- msg.over_type-- 1 正常结束 2 流局 3 房间解散会发送一个结算
	
	-- msg.award_list
	self._gameSelectPosPanel:RestartShow()
	self._currentOutPutPlayerPos = nil--重置绿红状态

	self._engine:gameOverShow()
end

function GameRoomLayer:onNoticeSpecialEvent(msg)--通知有人吃椪杠胡。。。。

	if self:isVisibleGameActionBtnsPanel() then
		self._gameActionBtnsPanel.m_objCommonUi.m_nodeActionBtns:setVisible(false)
	end
	if msg.item["type"] == 7 then --如果是听牌则刷新其他人的听牌杠标识
		local direction = lt.DataManager:getPlayerDirectionByPos(msg.user_pos)
		self:ShowTingGang(direction)
	end
	self._engine:noticeSpecialEvent(msg)
end

function GameRoomLayer:ShowTingGang(direction)
	self._gameSelectPosPanel:ShowTingBS(direction)
end

function GameRoomLayer:onGameCMDResponse(msg)   --游戏请求

end

function GameRoomLayer:onGamenoticeOtherDistroyRoom(msg)--通知有人解散房间
	local loginData = lt.DataManager:getPlayerInfo()
	local aa = os.date("%Y.%m.%d.%H:%M:%S",msg.distroy_time)
	local timeer = os.time()
	local other_time = msg.distroy_time - timeer - 2 --和服务端时间有延迟，所以减去俩秒
	if not self.ApplyGameOverPanel then
		self.ApplyGameOverPanel = lt.ApplyGameOverPanel.new(self)
		self.ApplyGameOverPanel:show(other_time,msg.confirm_map)
		dump(msg.confirm_map[1])
		if loginData.user_id ==  msg.confirm_map[1] then --代表是申请人，直接置灰
			self.ApplyGameOverPanel:buttonNotChick()
		end
		lt.UILayerManager:addLayer(self.ApplyGameOverPanel,true)
	else
		self.ApplyGameOverPanel:show(other_time,msg.confirm_map)
	end	
end
function GameRoomLayer:onCloseApplyGameOverPanel()
	lt.UILayerManager:removeLayer(self.ApplyGameOverPanel)
	self.ApplyGameOverPanel = nil
end
function GameRoomLayer:onGamenoticeOtherRefuse(msg)--如果有人拒绝解散
	local canclePlayer = lt.DataManager:getPlayerInfoByPos(msg.user_pos)
	local loginData = lt.DataManager:getPlayerInfo()
	--if loginData.user_id ~=  msg.user_id then  --让所有人都知道所以注释掉这句
		local name = ""
		if canclePlayer then
			name = canclePlayer.user_name
		end

		local text = string.format(lt.LanguageString:getString("PLAYER_NOT_GREEN_OVER"), name)
	    lt.MsgboxLayer:showMsgBox(text,true, handler(self, self.onCloseApplyGameOverPanel),nil, true)
	--end
end

function GameRoomLayer:CloseRoom()
	local worldScene = lt.WorldScene.new()
    lt.SceneManager:replaceScene(worldScene)
    lt.NetWork:disconnect()
end

function GameRoomLayer:onGamenoticePlayerDistroyRoom(msg)--
	if ENDRONDBS ~= 2 then
		local text = "房间已被解散"
		lt.MsgboxLayer:showMsgBox(text,true, handler(self, self.CloseRoom),nil, true)
	end
end

--回放
function GameRoomLayer:CreateReplay()--
	self._rePlayManager = lt.MJplayBackManager:CreateReplay()
end

function GameRoomLayer:ReplayUIshow()
	self._gameSetPanel:onTouchReplayUIShow()
end

function GameRoomLayer:ReplayStopReplay()
	self._rePlayManager:StopReplay()
end

function GameRoomLayer:ReplayStarReplay()
	self._rePlayManager:StarReplay()
end

function GameRoomLayer:ReplayaddSpeed()
	self._rePlayManager:addSpeed()
end

function GameRoomLayer:ReplaysurSpeed()
	self._rePlayManager:surSpeed()
end

function GameRoomLayer:onEnter()   
    lt.CommonUtil.print("GameRoomLayer:onEnter")
    
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.GAME_CMD, handler(self, self.onGameCMDResponse), "GameRoomLayer.onGameCMDResponse")

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.CLIENT_CONNECT_AGAIN, handler(self, self.onGameConnectAgain), "GameRoomLayer.onGameConnectAgain")

    --通知有人解散房间
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_OTHER_DISTROY_ROOM, handler(self, self.onGamenoticeOtherDistroyRoom), "GameRoomLayer.onGamenoticeOtherDistroyRoom")
    --如果有人拒绝解散
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_OTHER_REFUSE, handler(self, self.onGamenoticeOtherRefuse), "GameRoomLayer.onGamenoticeOtherRefuse")
    --如果房间被销毁
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_PLAYER_DISTROY_ROOM, handler(self, self.onGamenoticePlayerDistroyRoom), "GameRoomLayer.onGamenoticePlayerDistroyRoom")

	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.DEAL_DOWN, handler(self, self.onDealDown), "GameRoomLayer.onDealDown")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_DRAW_CARD, handler(self, self.onPushDrawCard), "GameRoomLayer.onPushDrawCard")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_PLAY_CARD, handler(self, self.onPushPlayCard), "GameRoomLayer.onPushPlayCard")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_PLAY_CARD, handler(self, self.onNoticePlayCard), "GameRoomLayer.onNoticePlayCard")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_PLAYER_OPERATOR_STATE, handler(self, self.onPushPlayerOperatorState), "GameRoomLayer.onPushPlayerOperatorState")

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.Game_OVER_REFRESH, handler(self, self.onRefreshGameOver), "GameRoomLayer.onRefreshGameOver")

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_SPECIAL_EVENT, handler(self, self.onNoticeSpecialEvent), "GameRoomLayer.onNoticeSpecialEvent")
end

function GameRoomLayer:onExit()
    lt.CommonUtil.print("GameRoomLayer:onExit")
   
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.GAME_CMD, "GameRoomLayer:onGameCMDResponse")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.CLIENT_CONNECT_AGAIN, "GameRoomLayer:onGameConnectAgain")

    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_OTHER_DISTROY_ROOM, "GameRoomLayer:onGamenoticeOtherDistroyRoom")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_OTHER_REFUSE, "GameRoomLayer:onGamenoticeOtherRefuse")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_PLAYER_DISTROY_ROOM, "GameRoomLayer:onGamenoticePlayerDistroyRoom")

	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.DEAL_DOWN, "GameRoomLayer:onDealDown")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_DRAW_CARD, "GameRoomLayer:onPushDrawCard")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_PLAY_CARD, "GameRoomLayer:onPushPlayCard")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_PLAY_CARD, "GameRoomLayer:onNoticePlayCard")

    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_PLAYER_OPERATOR_STATE, "GameRoomLayer:onPushPlayerOperatorState")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.Game_OVER_REFRESH, "GameRoomLayer:onRefreshGameOver")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_SPECIAL_EVENT, "GameRoomLayer:onNoticeSpecialEvent")
end

return GameRoomLayer