
local GameRoomLayer = class("GameRoomLayer", lt.BaseLayer)

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
	self._gamePlayCardsPanel = lt.GamePlayCardsPanel.new(self)--牌面层
	self._gameSelectPosPanel = lt.GameSelectPosPanel.new(self, self._gamePlayCardsPanel)--入座 玩家头像
	self._gameSetPanel = lt.GameSetPanel.new(self)--设置
	self._gameRoomInfoPanel = lt.GameRoomInfoPanel.new(self)--房间信息
	self._gameActionBtnsPanel = lt.GameActionBtnsPanel.new(self)--吃碰杠胡过
	self._gameResultPanel = lt.GameResultPanel.new(self, palyerNmu)--结算

	self:addChild(self._gameBgPanel)
	self:addChild(self._gamePlayCardsPanel)
	self:addChild(self._gameSelectPosPanel)
	self:addChild(self._gameSetPanel)
	self:addChild(self._gameRoomInfoPanel)
	self:addChild(self._gameActionBtnsPanel)
	self:addChild(self._gameResultPanel)

    --结算界面
    self._gameResultPanel:setVisible(false)

	self:initGame()
end

function GameRoomLayer:initGame()  
	self._gameSelectPosPanel:initGame()
	self._gamePlayCardsPanel:initGame()
end

function GameRoomLayer:againConfigUI()  
	self._gameSelectPosPanel:againConfigUI()
	self._gamePlayCardsPanel:initGame()
end

function GameRoomLayer:getPlayerDirectionByPos(playerPos) 
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

function GameRoomLayer:onGameCMDResponse(msg)   --游戏请求

end

function GameRoomLayer:onGameConnectAgain()
	local allRoomInfo = lt.DataManager:getPushAllRoomInfo()
	if not allRoomInfo.card_list or not next(allRoomInfo.card_list) then--入座界面
		self._gameSelectPosPanel:againConfigUI()
	end	

	self._gamePlayCardsPanel:initGame()
end

function GameRoomLayer:onEnter()   
    print("GameRoomLayer:onEnter")
    
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.GAME_CMD, handler(self, self.onGameCMDResponse), "GameRoomLayer.onGameCMDResponse")

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.CLIENT_CONNECT_AGAIN, handler(self, self.onGameConnectAgain), "GameRoomLayer.onGameConnectAgain")

end

function GameRoomLayer:onExit()
    print("GameRoomLayer:onExit")
   
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.GAME_CMD, "GameRoomLayer:onGameCMDResponse")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.CLIENT_CONNECT_AGAIN, "GameRoomLayer:onGameConnectAgain")
end


return GameRoomLayer