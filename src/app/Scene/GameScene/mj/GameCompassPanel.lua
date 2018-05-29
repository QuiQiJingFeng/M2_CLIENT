
--罗盘层
local GameCompassPanel = class("GameCompassPanel", lt.BaseLayer)

GameCompassPanel.UPDATETIME = 15

function GameCompassPanel:ctor(deleget)
	GameCompassPanel.super.ctor(self)
	self._deleget = deleget

    local gameInfo = lt.DataManager:getGameRoomInfo()
    self._playerNum = 2
    if gameInfo and gameInfo.room_setting and gameInfo.room_setting.seat_num then
        self._playerNum = gameInfo.room_setting.seat_num
    end

	-- if self._playerNum == 2 then
	-- 	self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/2p/MjCardsPanel2p.csb")
	-- elseif self._playerNum == 3 then
	-- 	self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/3p/MjCardsPanel3p.csb")
	-- elseif self._playerNum == 4 then
	-- 	self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjCardsPanel.csb")
	-- end
	
	self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjDirectionPanel.csb")


	self._pleaseOutCardTips = self._rootNode:getChildByName("Sprite_OutCardTips")--请出牌
	self._pleaseOutCardTips:setVisible(false)

	self._curOutCardArrow = self._rootNode:getChildByName("Node_CurOutCardArrow")--
	self._curOutCardArrow:setVisible(false)

	self._nodeCardNum = self._rootNode:getChildByName("Node_CardNum")
	self._nodeOtherNum = self._rootNode:getChildByName("Node_OtherNum")

	self._surCardsNum = lt.CommonUtil:getChildByNames(self._rootNode, "Node_CardNum", "Text_Num")--剩余牌数

	self._surRoomCount = lt.CommonUtil:getChildByNames(self._rootNode, "Node_OtherNum", "Text_Num")--剩余局数

	local nodeClock = lt.CommonUtil:getChildByNames(self._rootNode, "Node_Clock")--中间方向盘
	
	self._timeClock = nodeClock:getChildByName("AtlasLabel_ClockNum")

	self._spriteDnxb = nodeClock:getChildByName("Sprite_Dnxb")--方向旋转

	self:addChild(self._rootNode)

	--self:initGame()
	--self:setSurRoomRound()
	self:configUI()
end

function GameCompassPanel:configUI() 
	local currentGameDirections = nil

	if self._playerNum == 2 then--二人麻将
		currentGameDirections = {2, 4}
	elseif self._playerNum == 3 then
		currentGameDirections = {1, 2, 3}
	elseif self._playerNum == 4 then
		currentGameDirections = {1, 2, 3, 4}
	end

	if not currentGameDirections then
		return
	end

	local nodeClock = lt.CommonUtil:getChildByNames(self._rootNode, "Node_Clock")--中间方向盘
	
	self._nodeGrayDXNB = {}--东南西北的节点

	self._nodeLight = {}--红绿状态的节点

	self._nodeLightDXNB = {}--出牌时亮态东西南北的节点  

	for i=1,4 do
		nodeClock:getChildByName("Node_Light_"..i):setVisible(false)
		nodeClock:getChildByName("Node_DNXB_"..i):setVisible(false)

		local node = self._spriteDnxb:getChildByName("Sprite_Gray_"..i)
		node:setVisible(false)
	end

	for i,direction in ipairs(currentGameDirections) do
		nodeClock:getChildByName("Node_Light_"..direction):setVisible(false)
		nodeClock:getChildByName("Node_DNXB_"..direction):setVisible(true)

		local node = self._spriteDnxb:getChildByName("Sprite_Gray_"..direction)
		node:setVisible(true)

		if not node["originPosX"] then
			node["originPosX"] = node:getPositionX()
		end

		if not node["originPosY"] then
			node["originPosY"] = node:getPositionY()
		end

		local posValue = i
		if self._playerNum == 2 then
			if direction == 2 then
				posValue = lt.Constants.DIRECTION.NAN
			else
				posValue = lt.Constants.DIRECTION.XI
			end
		end

		if not node["posValue"] then
			node["posValue"] = posValue
		end
		self._nodeGrayDXNB[direction] = node

		self._nodeLight[direction] = nodeClock:getChildByName("Node_Light_"..direction)--:getChildByName("Sprite_Light") getChildByName("Sprite_LightRed")
		self._nodeLightDXNB[direction] = nodeClock:getChildByName("Node_DNXB_"..direction)--   

		self._nodeLightDXNB[direction]:getChildByName("Sprite_Dong"):setVisible(false)
		self._nodeLightDXNB[direction]:getChildByName("Sprite_Nan"):setVisible(false)
		self._nodeLightDXNB[direction]:getChildByName("Sprite_Xi"):setVisible(false)
		self._nodeLightDXNB[direction]:getChildByName("Sprite_Bei"):setVisible(false)
	end

	self:resetLightUpdate()
end

function GameCompassPanel:initGame() --每局结束牌桌清桌 
	if lt.DataManager:isClientConnectAgain() then	
		self:onClientConnectAgain()
		self._nodeCardNum:setVisible(false)
		self._nodeOtherNum:setVisible(true)

		if lt.DataManager:isClientConnectAgainPlaying() then
			self._nodeCardNum:setVisible(true)
			self._nodeOtherNum:setVisible(true)
		end
	else
		self._nodeCardNum:setVisible(false)
		self._nodeOtherNum:setVisible(false)
	end
end

function GameCompassPanel:showCardsNum()
	self._nodeCardNum:setVisible(true)
	self._nodeOtherNum:setVisible(true)
end

function GameCompassPanel:onDealDown(msg)   --发牌13张手牌

	local roomSetting = lt.DataManager:getGameRoomSetInfo()
	if roomSetting then
		if roomSetting.game_type == lt.Constants.GAME_TYPE.HZMJ then
			local allCardsNum = 112
			self._surCardsNum:setString(allCardsNum - 13 * roomSetting.seat_num)
		end
	end

	self:setSurRoomRound(msg.cur_round)
end

function GameCompassPanel:setSurRoomRound(curRound)
	local curRound = curRound or 0	
	
	local surRoomCountStr = ""
	surRoomCountStr = surRoomCountStr..curRound

	local roomSetting = lt.DataManager:getGameRoomSetInfo()
	if roomSetting then
		surRoomCountStr = surRoomCountStr.."/"..roomSetting.round
	end

	self._surRoomCount:setString(surRoomCountStr)
end

function GameCompassPanel:onPushDrawCard(msg)   --通知其他人有人摸牌 
	local surCardsNum = tonumber(self._surCardsNum:getString())
	if surCardsNum and surCardsNum > 0 then
		self._surCardsNum:setString(surCardsNum - 1)
	end
end

function GameCompassPanel:onPushPlayCard(msg)   --通知玩家该出牌了 
	self:resetTimeUpdate(true)--重记倒计时
	self._currentOutPutPlayerPos = msg.user_pos
end

function GameCompassPanel:onRefreshGameOver()   --通知客户端 本局结束 带结算
	-- msg.over_type-- 1 正常结束 2 流局 3 房间解散会发送一个结算
	
	-- msg.award_list
	self._currentOutPutPlayerPos = nil--重置绿红状态
	self:resetLightUpdate()

	self:resetTimeUpdate(false)--重置倒计时
end

function GameCompassPanel:onClientConnectAgain()--  断线重连
	local allRoomInfo = lt.DataManager:getPushAllRoomInfo()

	local gameRoomInfo = lt.DataManager:getGameRoomInfo()
	local curRound = gameRoomInfo.cur_round
	self._surRoomCount:setVisible(true)
	self:setSurRoomRound(curRound)

	local reduceNum = allRoomInfo.reduce_num or 0
	self._surCardsNum:setString(reduceNum)
	-- self._nodeCardNum:setVisible(true)
	-- self._nodeOtherNum:setVisible(true)

	--当前出牌人  指向
	if allRoomInfo.cur_play_pos then
		self:resetTimeUpdate(true)
		self._currentOutPutPlayerPos = allRoomInfo.cur_play_pos
		self:configCurDNXB()
	else
		self:resetTimeUpdate(true) 

		self._currentOutPutPlayerPos = nil--重置绿红状态
		self:resetLightUpdate()
	end
end

function GameCompassPanel:resetTimeUpdate(flag) 
	self._refreshTimeUpdate = flag
	if flag then
		self._time = 0
	end
end

function GameCompassPanel:resetLightUpdate() 
	for dire,v in pairs(self._nodeLight) do
		v:setVisible(false)
	end

	for dire,v in pairs(self._nodeGrayDXNB) do--重置东南西北出牌高亮状态

		if v.posValue then
			local path = "game/mjcomm/words/"--wordGrayBei
			if v.posValue == lt.Constants.DIRECTION.DONG then
				path = path.."wordGrayDong.png"
			elseif v.posValue == lt.Constants.DIRECTION.NAN then
				path = path.."wordGrayNan.png"
			elseif v.posValue == lt.Constants.DIRECTION.XI then
				path = path.."wordGrayXi.png"
			elseif v.posValue == lt.Constants.DIRECTION.BEI then	
				path = path.."wordGrayBei.png"
			end
			v:setSpriteFrame(path)
		end
	end
end

function GameCompassPanel:configCurDNXB() 
	for dire,v in pairs(self._nodeGrayDXNB) do
		if v.posValue then
			local path = "game/mjcomm/words/"--wordGrayBei
			if v.posValue == self._currentOutPutPlayerPos then
				if v.posValue == lt.Constants.DIRECTION.DONG then
					path = path.."wordDong.png"
				elseif v.posValue == lt.Constants.DIRECTION.NAN then
					path = path.."wordNan.png"
				elseif v.posValue == lt.Constants.DIRECTION.XI then
					path = path.."wordXi.png"
				elseif v.posValue == lt.Constants.DIRECTION.BEI then	
					path = path.."wordBei.png"
				end
			else
				if v.posValue == lt.Constants.DIRECTION.DONG then
					path = path.."wordGrayDong.png"
				elseif v.posValue == lt.Constants.DIRECTION.NAN then
					path = path.."wordGrayNan.png"
				elseif v.posValue == lt.Constants.DIRECTION.XI then
					path = path.."wordGrayXi.png"
				elseif v.posValue == lt.Constants.DIRECTION.BEI then	
					path = path.."wordGrayBei.png"
				end
			end
			v:setSpriteFrame(path)
		end
	end
end

function GameCompassPanel:onUpdate(delt) 
	if not self._refreshTimeUpdate then
		return
	end

	if self._currentOutPutPlayerPos then
		self:configCurDNXB()

		local direction = self._deleget:getPlayerDirectionByPos(self._currentOutPutPlayerPos)
		for dire,v in pairs(self._nodeLight) do

			if dire == direction then
				v:setVisible(true)
				if self.UPDATETIME - self._time <= 5 then
					v:getChildByName("Sprite_LightRed"):setVisible(true)
					v:getChildByName("Sprite_Light"):setVisible(false)
				else
					v:getChildByName("Sprite_LightRed"):setVisible(false)
					v:getChildByName("Sprite_Light"):setVisible(true)
				end
			else
				v:setVisible(false)
			end
		end
	else
		self:resetLightUpdate()
	end	

	self._timeClock:setString(self.UPDATETIME - self._time)
	self._time = self._time + delt

	if self._time >= self.UPDATETIME then
		self._time = 0
	end
end

function GameCompassPanel:onEnter()   


	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.DEAL_DOWN, handler(self, self.onDealDown), "GameCompassPanel.onDealDown")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_DRAW_CARD, handler(self, self.onPushDrawCard), "GameCompassPanel.onPushDrawCard")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_PLAY_CARD, handler(self, self.onPushPlayCard), "GameCompassPanel.onPushPlayCard")

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.Game_OVER_REFRESH, handler(self, self.onRefreshGameOver), "GameCompassPanel.onRefreshGameOver")

    --lt.GameEventManager:addListener(lt.GameEventManager.EVENT.CLIENT_CONNECT_AGAIN, handler(self, self.onClientConnectAgain), "GameCompassPanel.onClientConnectAgain")
	local scheduler = cc.Director:getInstance():getScheduler()
	self.schedule_id = scheduler:scheduleScriptFunc(function(dt)
	    self:onUpdate(dt)
	end, 1, false)
	self._time = 0
end

function GameCompassPanel:onExit()
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.DEAL_DOWN, "GameCompassPanel:onDealDown")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_DRAW_CARD, "GameCompassPanel:onPushDrawCard")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_PLAY_CARD, "GameCompassPanel:onPushPlayCard")

    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.Game_OVER_REFRESH, "GameCompassPanel:onRefreshGameOver")
    --lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.CLIENT_CONNECT_AGAIN, "GameCompassPanel:onClientConnectAgain")

    if self.schedule_id then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedule_id)
        self.schedule_id = nil
    end
end

return GameCompassPanel