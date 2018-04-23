
--设置层
local GameResultPanel = class("GameResultPanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/csb/base/GameResultLayer.csb")
end)

GameResultPanel.POSITION_TYPE = {
	XI = 1, 
	NAN = 2,
	DONG = 3,
	BEI = 4,
}
function GameResultPanel:ctor(deleget)
	GameResultPanel.super.ctor(self)
	self._deleget = deleget

	local gameInfo = lt.DataManager:getGameRoomInfo()
    self._playerNum = 2
    if gameInfo and gameInfo.room_setting and gameInfo.room_setting.seat_num then
        self._playerNum = gameInfo.room_setting.seat_num
    end

	self._resultPanelMask = self:getChildByName("Panel_Mask")

	local buttonList = self:getChildByName("Node_WinOrLost")
	self._resultStartAgainBtn = buttonList:getChildByName("Button_StartAgain")
	self._resultTotalEndBtn = buttonList:getChildByName("Button_TotalResult")
	self._resultWeChatShareBtn = buttonList:getChildByName("Button_WeChatShare")
	self._resultLeaveRoomBtn = buttonList:getChildByName("Button_LeaveRoom")

	lt.CommonUtil:addNodeClickEvent(self._resultStartAgainBtn, handler(self, self.onStartAgainClick))

	local Image_SurplusBg = self:getChildByName("Image_SurplusBg")
	Image_SurplusBg:setVisible(false)

	local Button_SurplusCard = self:getChildByName("Button_SurplusCard")
	Button_SurplusCard:setVisible(false)

	self._rewardCodeBtn = self:getChildByName("Reward_Code_Btn")
	lt.CommonUtil:addNodeClickEvent(self._rewardCodeBtn, handler(self, self.onRewardCodeClick))

    --结算界面
    self:setVisible(false)

    self._allPlayerResultNode = {}
	for i=1,4 do 
		table.insert(self._allPlayerResultNode, self:getChildByName("Node_ScrollNumPos_"..i))
	
		self:getChildByName("Node_ScrollNumPos_"..i):getChildByName("Node_ResultInfoItem"):setVisible(false)

	end

	local currentDiretions = {}

	if self._playerNum == 2 then
		currentDiretions = {2, 4}
	elseif self._playerNum == 3 then
		currentDiretions = {1, 2, 3}
	elseif self._playerNum == 4 then
		currentDiretions = {1, 2, 3, 4}
	end

	self._currentPlayerResultNode = {}--结算
	for i,direction in ipairs(currentDiretions) do
		if self._allPlayerResultNode[direction] then
			self._currentPlayerResultNode[direction] = self._allPlayerResultNode[direction]--方位是死的 2 4 
			self._allPlayerResultNode[direction]:getChildByName("Node_ResultInfoItem"):setVisible(true)
		end
	end
end

function GameResultPanel:onStartAgainClick(event) --继续游戏
	--重新整理界面
	self:setVisible(false)
	self:closeWinAwardCodeLayer()
	self._deleget:initGame()

	local arg = {pos = lt.DataManager:getMyselfPositionInfo().user_pos}--weixin
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.SIT_DOWN, arg)
end

function GameResultPanel:onRewardCodeClick(event) --奖码
 	local awardCards = lt.DataManager:getGameOverInfo().award_list
	if not awardCards then
		return
	end

	if not self._winAwardCodeLayer then
		self._winAwardCodeLayer = lt.WinAwardCodeLayer.new(self)
	    lt.UILayerManager:addLayer(self._winAwardCodeLayer, true)
	else
		self._winAwardCodeLayer:setVisible(true)
	end
end

function GameResultPanel:closeWinAwardCodeLayer(event) --奖码
	if self._winAwardCodeLayer then
		lt.UILayerManager:removeLayer(self._winAwardCodeLayer)
		self._winAwardCodeLayer = nil
	end
end

function GameResultPanel:onRefreshScoreResponse(msg)   --玩家刷新积分（杠）
	self:setVisible(true)
	self._resultPanelMask:setVisible(false)
	self._resultStartAgainBtn:setVisible(false)
	self._resultTotalEndBtn:setVisible(false)
	self._resultWeChatShareBtn:setVisible(false)
	self._resultLeaveRoomBtn:setVisible(false)
	self._rewardCodeBtn:setVisible(false)

	for k,v in pairs(self._currentPlayerResultNode) do
		v:getChildByName("Node_ResultInfoItem"):setVisible(false)
	end

	for k,v in pairs(msg.cur_score_list) do
		local direction = self._deleget:getPlayerDirectionByPos(v.user_pos)
		local node = self._currentPlayerResultNode[direction] 
		if node and v.delt_score ~= 0 then
			local scrollNumber = node:getChildByTag(100)
			if not scrollNumber then
				scrollNumber = lt.ScrollNumber:create(12, "games/bj/game/part/numWin.png", "games/bj/game/part/numLost.png")
				scrollNumber:setTag(100)
				node:addChild(scrollNumber)
			end
			scrollNumber:setVisible(true)
			scrollNumber:setNumber(v.delt_score)


			local func = function( )
				--scrollNumber:removeFromParent()
				scrollNumber:setVisible(false)
			end
			local delay = cc.DelayTime:create(1)

			local func1 = cc.CallFunc:create(func)
			local sequence = cc.Sequence:create(delay, func1)
			node:runAction(sequence)
		end
	end
end

function GameResultPanel:onRefreshGameOver()   --通知客户端 本局结束 带结算
	-- msg.over_type-- 1 正常结束 2 流局 3 房间解散会发送一个结算
	
	-- msg.award_list

 	local awardCards = lt.DataManager:getGameOverInfo().award_list
	if awardCards then
		if not self._winAwardCodeLayer then
			self._winAwardCodeLayer = lt.WinAwardCodeLayer.new(self)
		    lt.UILayerManager:addLayer(self._winAwardCodeLayer, true)
		end
	end

	local gameOverInfo = lt.DataManager:getGameOverInfo()
	self:setVisible(true)
	self._resultPanelMask:setVisible(true)
	self._rewardCodeBtn:setVisible(true)

	local winner_pos = gameOverInfo.winner_pos
	local winner_type = gameOverInfo.winner_type or 1 --自摸 1 抢杠 2
	local last_round = gameOverInfo.last_round

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

	self._allLieFaceCardNode = {}
	if gameOverInfo.players then
		for k,v in ipairs(gameOverInfo.players) do
			local direction = self._deleget:getPlayerDirectionByPos(v.user_pos)

			local node = self._currentPlayerResultNode[direction] 
			if node then
				local resultInfoItem = node:getChildByName("Node_ResultInfoItem")
				local winOrLostIcon = resultInfoItem:getChildByName("Sprite_WinOrLost")
				local imageBg = resultInfoItem:getChildByName("Image_Bg")
				local scrollView = resultInfoItem:getChildByName("ScrollView")
				scrollView:setVisible(false)
				imageBg:setVisible(true)
				local desText = imageBg:getChildByName("Text_Info1")

				desText:setVisible(true)

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
						node:addChild(scrollNumber)
						scrollNumber:setTag(100)
					end
					scrollNumber:setVisible(true)
					scrollNumber:setNumber(v.cur_score)

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

function GameResultPanel:onEnter()   
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.Game_OVER_REFRESH, handler(self, self.onRefreshGameOver), "GameResultPanel.onRefreshGameOver")

	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.REFRESH_PLAYER_CUR_SCORE, handler(self, self.onRefreshScoreResponse), "GameResultPanel.onRefreshScoreResponse")

end

function GameResultPanel:onExit()
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.Game_OVER_REFRESH, "GameResultPanel:onRefreshGameOver")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.REFRESH_PLAYER_CUR_SCORE, "GameResultPanel:onRefreshScoreResponse")
end

return GameResultPanel