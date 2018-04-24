
--座位 玩家头像层
local GameSelectPosPanel = class("GameSelectPosPanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/csb/base/GamePlayerInfo.csb")--背景层--  FriendLayer
end)

GameSelectPosPanel.POSITION_TYPE = {
	XI = 1, 
	NAN = 2,
	DONG = 3,
	BEI = 4,
}

function GameSelectPosPanel:ctor(deleget, cardsPanel)
	GameSelectPosPanel.super.ctor(self)

	self._deleget = deleget
	self._cardsPanel = cardsPanel

    local gameInfo = lt.DataManager:getGameRoomInfo()
    self._playerNum = 2
    if gameInfo and gameInfo.room_setting and gameInfo.room_setting.seat_num then
        self._playerNum = gameInfo.room_setting.seat_num
    end
-- round

-- cur_round

	--玩家界面
	self._tingLogoArray = {}--听牌的logo  
	self._playerLogoArray = {}--玩家的logo  
	self._allPlayerPosArray = {}--玩家座位的logo 
	self._servenPosArray = {}--7个位置的node

	self._currentSitPosArray = {}--玩家入座时的位置
	self._currentPlayerLogArray = {}--玩家打牌中头像


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

	self._nodeNoPlayer = self:getChildByName("Node_NoPlayer")--两个方置 可以用来旋转

	self._handSelect = self._nodeNoPlayer:getChildByName("Node_SitDownTips")
	self._handSelect:setVisible(false)

	for i=1,4 do 
		table.insert(self._tingLogoArray, self:getChildByName("Image_Ting_"..i))
		table.insert(self._playerLogoArray, self:getChildByName("Node_Player"..i))
		table.insert(self._allPlayerPosArray, self._nodeNoPlayer:getChildByName("Button_NoPlayer_"..i))
	end

	for i=1,7 do
		table.insert(self._servenPosArray, self:getChildByName("Node_NoPlayer"):getChildByName("Node_Pos"..i))
	end
	self._sitDownTips = self:getChildByName("Node_NoPlayer"):getChildByName("Node_SitDownTips")
	
	for i,v in ipairs(self._tingLogoArray) do
		v:setVisible(false)
	end

	for i,v in ipairs(self._playerLogoArray) do
		v:setVisible(false)
	end

	for pos,v in ipairs(self._allPlayerPosArray) do--西南

		local worldPos = self._nodeNoPlayer:convertToWorldSpace(cc.p(v:getPosition()))

		if not v["originPosX"] then
			v["originPosX"] = worldPos.x
		end
		if not v["originPosY"] then
			v["originPosY"] = worldPos.y
		end

		local direction = self.POSITION_TYPE.NAN
		if self._playerNum == 2 then
			if pos == self.POSITION_TYPE.XI then--北方
				direction = self.POSITION_TYPE.BEI
				v:setPosition(self._allPlayerPosArray[direction]:getPosition())
			else
				direction = self.POSITION_TYPE.NAN
			end
		else
			direction = pos
		end

		if not v["atDirection"] then
			v["atDirection"] = direction
		end


		if pos <= self._playerNum then
			v:setVisible(true)
			self._currentSitPosArray[pos] = v
			lt.CommonUtil:addNodeClickEvent(v, handler(self, self.onSitDownClick))
		else
			v:setVisible(false)
		end
		v:setTag(pos)
	end

	local currentGameDirections = nil

	if self._playerNum == 2 then--二人麻将
		currentGameDirections = {2, 4}
	elseif self._playerNum == 3 then
		currentGameDirections = {1, 2, 3}
	elseif self._playerNum == 4 then
		currentGameDirections = {1, 2, 3, 4}
	end

	for pos,playerLogo in ipairs(self._playerLogoArray) do
		playerLogo:getChildByName("Fzb_Tips"):setVisible(false)
		playerLogo:getChildByName("Node_Warning"):setVisible(false)
		playerLogo:getChildByName("Sprite_Ready"):setVisible(false)
		playerLogo:setVisible(false)
	end

	if currentGameDirections then
		for i,direction in ipairs(currentGameDirections) do
			local playerLogo = self._playerLogoArray[direction]
			if playerLogo then
				if not playerLogo["originPosX"] then
					playerLogo["originPosX"] = playerLogo:getPositionX()
				end
				
				if not playerLogo["originPosY"] then
					playerLogo["originPosY"] = playerLogo:getPositionY()
				end

				self._currentPlayerLogArray[direction] = playerLogo--方位是死的 2 4 

				playerLogo:getChildByName("Sprite_Zhuang"):setVisible(false)
				playerLogo:getChildByName("Sprite_Disconnect"):setVisible(false)

				--lt.CommonUtil:addNodeClickEvent(playerLogo, handler(self, self.onSitDownClick))
			end
		end
	end
	--self:initGame()
end

function GameSelectPosPanel:initGame()
	self:configRotation()--初始化座位方位
	self:configPlayer()--初始化玩家头像
	self:configPlayerScore()
end

function GameSelectPosPanel:configPlayer() --头像 
	local gameRoomInfo = lt.DataManager:getGameRoomInfo()
	local allRoomInfo = lt.DataManager:getPushAllRoomInfo()
	
    print("+++++++++++++++++", #self._currentSitPosArray, #gameRoomInfo.players)
    for k,playerLogo in pairs(self._currentPlayerLogArray) do
    	playerLogo:setVisible(false)
    end

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

				--self._currentPlayerLogArray[sitNode.atDirection]:getChildByName("Sprite_Zhuang"):setVisible(false)

				if player.user_id ~= lt.DataManager:getPlayerInfo().user_id then--别的玩家的头像
					sitNode:setVisible(false)
					self._currentPlayerLogArray[sitNode.atDirection]:setVisible(true)
					if player.is_sit then
		        		print("_______11111_________________________", player.user_pos, sitNode.atDirection)
	        			
	        			self._currentPlayerLogArray[sitNode.atDirection]:getChildByName("Sprite_Ready"):setVisible(true)
	        			
	        			if not allRoomInfo.card_list or not next(allRoomInfo.card_list) then--入座界面
		        			local worldPos = self._nodeNoPlayer:convertToWorldSpace(cc.p(sitNode:getPosition()))
		        			self._currentPlayerLogArray[sitNode.atDirection]:setPosition(worldPos.x, worldPos.y)
	        			end
	        		else
	        			print("_______2222_________________________", player.user_pos, sitNode.atDirection)
		        		self._currentPlayerLogArray[sitNode.atDirection]:getChildByName("Sprite_Ready"):setVisible(false)
	        			
		        		if not allRoomInfo.card_list or not next(allRoomInfo.card_list) then--入座界面
	        				local worldPos = self._nodeNoPlayer:convertToWorldSpace(cc.p(sitNode:getPosition()))
	        				self._currentPlayerLogArray[sitNode.atDirection]:setPosition(worldPos.x, worldPos.y)
		        		end	
					end
				else
					print("_______33333_________________________")
					if mySelfNode and player.is_sit then
						print("%%%%%%%%%", player.user_pos, mySelfNode.atDirection)

						if not allRoomInfo.card_list or not next(allRoomInfo.card_list) then--入座界面

							local worldPos = self._nodeNoPlayer:convertToWorldSpace(cc.p(mySelfNode:getPosition()))
						--座位--self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:setVisible(true)
							self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:setPosition(worldPos.x, worldPos.y)
						end

						self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:getChildByName("Sprite_Ready"):setVisible(true)
					
						self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:setVisible(true)
					end

					
				end
    		end
    	else
    		print("没人", pos, sitNode.atDirection, lt.DataManager:getMyselfPositionInfo().is_sit)
    		self._currentPlayerLogArray[sitNode.atDirection]:setVisible(false)
			if not lt.DataManager:getMyselfPositionInfo().is_sit then
				sitNode:setVisible(true)
			end
    		--
    	end
    end	
end

function GameSelectPosPanel:configRotation(isClick) 
	self._handSelect:setVisible(false)

	for i,v in ipairs(self._currentPlayerLogArray) do
		v:setVisible(false)
	end

	if isClick and self._selectPositionNode then
		local temp = self._selectPositionNode.atDirection - self.POSITION_TYPE.NAN
		local du = temp * 90

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

	    local time = 0.5
	    if du == 0 then
	    	time = 0
	    end

    	local headVisible = function ( )
			self._selectPositionNode:setVisible(false)

			self:configPlayer()


			--self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:setVisible(true)
			-- self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:getChildByName("Sprite_Ready"):setVisible(true)

			-- local worldPos = self._nodeNoPlayer:convertToWorldSpace(cc.p(self._selectPositionNode:getPosition()))
			-- self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:setPosition(worldPos.x, worldPos.y)
		end

  		--三人
  		if self._playerNum == 3 then
  			local action = cc.RotateBy:create(time, du)
			local action1 = function ( )
				local action3 = cc.RotateBy:create(time, -du)
				self._selectPositionNode:runAction(action3)
			end

  			local action2 = function ()
  				--3 2   2 1  1 3       1 2  2 3  3 1 

  				for pos,v in ipairs(self._currentSitPosArray) do
  					if self._selectPositionNode.atDirection == self.POSITION_TYPE.XI then
  						
  						if v.atDirection == self.POSITION_TYPE.NAN then
  							local worldPos = self._nodeNoPlayer:convertToNodeSpace(cc.p(self._currentSitPosArray[self.POSITION_TYPE.DONG].originPosX , self._currentSitPosArray[self.POSITION_TYPE.DONG].originPosY))
							v:setPosition(worldPos)
							
							v.atDirection = self.POSITION_TYPE.DONG
						elseif v.atDirection == self.POSITION_TYPE.DONG then

  							local worldPos = self._nodeNoPlayer:convertToNodeSpace(cc.p(self._currentSitPosArray[self.POSITION_TYPE.XI].originPosX , self._currentSitPosArray[self.POSITION_TYPE.XI].originPosY))
							v:setPosition(worldPos)
							print("防腐剂的空间发的开发阶段", self._currentSitPosArray[self.POSITION_TYPE.XI].originPosX , self._currentSitPosArray[self.POSITION_TYPE.XI].originPosY)	
							v.atDirection = self.POSITION_TYPE.XI
  						end

  					elseif self._selectPositionNode.atDirection == self.POSITION_TYPE.DONG then

  						if v.atDirection == self.POSITION_TYPE.NAN then
							local worldPos = self._nodeNoPlayer:convertToNodeSpace(cc.p(self._currentSitPosArray[self.POSITION_TYPE.XI].originPosX , self._currentSitPosArray[self.POSITION_TYPE.XI].originPosY))
							v:setPosition(worldPos)
							v.atDirection = self.POSITION_TYPE.XI
						elseif v.atDirection == self.POSITION_TYPE.XI then
  							local worldPos = self._nodeNoPlayer:convertToNodeSpace(cc.p(self._currentSitPosArray[self.POSITION_TYPE.DONG].originPosX , self._currentSitPosArray[self.POSITION_TYPE.DONG].originPosY))
							v:setPosition(worldPos)

							v.atDirection = self.POSITION_TYPE.DONG
  						end
  					end
  				end
  				self._selectPositionNode.atDirection = self.POSITION_TYPE.NAN
				local worldPos = self._nodeNoPlayer:convertToNodeSpace(cc.p(self._currentSitPosArray[self.POSITION_TYPE.NAN].originPosX, self._currentSitPosArray[self.POSITION_TYPE.NAN].originPosY))
				self._selectPositionNode:setPosition(worldPos)

				for pos,v in ipairs(self._currentSitPosArray) do
					if pos == self.POSITION_TYPE.XI then
  						self._cardsPanel._nodeGrayDXNB[v.atDirection]:setSpriteFrame("game/mjcomm/words/wordGrayXi.png")
  					elseif pos == self.POSITION_TYPE.NAN then
  						self._cardsPanel._nodeGrayDXNB[v.atDirection]:setSpriteFrame("game/mjcomm/words/wordGrayNan.png")
  					
  					elseif pos == self.POSITION_TYPE.DONG then
  						self._cardsPanel._nodeGrayDXNB[v.atDirection]:setSpriteFrame("game/mjcomm/words/wordGrayDong.png")
  					end
  					self._cardsPanel._nodeGrayDXNB[v.atDirection].posValue = pos
				end

  			end
  			
			local spawn = cc.Spawn:create(cc.CallFunc:create(action1), action)
			
	  		local sequence = cc.Sequence:create(spawn, cc.CallFunc:create(action2),  cc.CallFunc:create(headVisible))

  			self._nodeNoPlayer:runAction(sequence)
			--_nodeLightDXNB
		else 
	  		--二 四人
			local action = cc.RotateBy:create(time, du)

			local action2 = function ( )
				local action3 = cc.RotateBy:create(time, -du)--父节点也进行了旋转所以为负
				self._selectPositionNode:runAction(action3)
			end

			local action1 = function ( )
				local action4 = cc.RotateBy:create(time, du)
				self._cardsPanel._spriteDnxb:runAction(action4)
			end

			local spawn = cc.Spawn:create(cc.CallFunc:create(action1), action, cc.CallFunc:create(action2))
			
	  		local sequence = cc.Sequence:create(spawn, cc.CallFunc:create(headVisible))

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

	  		self._nodeNoPlayer:runAction(sequence)

  		end

	else

		local mySelfPosition = lt.DataManager:getMyselfPositionInfo().user_pos

		local du = 0

		local mySelfPositionNode = self._currentSitPosArray[mySelfPosition]

		if mySelfPositionNode then
			du = (mySelfPositionNode.atDirection - self.POSITION_TYPE.NAN) * 90
		end

		local temp = mySelfPositionNode.atDirection - self.POSITION_TYPE.NAN

  		--三人
  		if self._playerNum == 3 then
  			--3 2   2 1  1 3       1 2  2 3  3 1 
  				for pos,v in ipairs(self._currentSitPosArray) do
  					if mySelfPositionNode.atDirection == self.POSITION_TYPE.XI then
  						
  						if v.atDirection == self.POSITION_TYPE.NAN then
  							local worldPos = self._nodeNoPlayer:convertToNodeSpace(cc.p(self._currentSitPosArray[self.POSITION_TYPE.DONG].originPosX , self._currentSitPosArray[self.POSITION_TYPE.DONG].originPosY))
							v:setPosition(worldPos)
							
							v.atDirection = self.POSITION_TYPE.DONG
						elseif v.atDirection == self.POSITION_TYPE.DONG then

  							local worldPos = self._nodeNoPlayer:convertToNodeSpace(cc.p(self._currentSitPosArray[self.POSITION_TYPE.XI].originPosX , self._currentSitPosArray[self.POSITION_TYPE.XI].originPosY))
							v:setPosition(worldPos)
							print("防腐剂的空间发的开发阶段", self._currentSitPosArray[self.POSITION_TYPE.XI].originPosX , self._currentSitPosArray[self.POSITION_TYPE.XI].originPosY)	
							v.atDirection = self.POSITION_TYPE.XI
  						end

  					elseif mySelfPositionNode.atDirection == self.POSITION_TYPE.DONG then

  						if v.atDirection == self.POSITION_TYPE.NAN then
							local worldPos = self._nodeNoPlayer:convertToNodeSpace(cc.p(self._currentSitPosArray[self.POSITION_TYPE.XI].originPosX , self._currentSitPosArray[self.POSITION_TYPE.XI].originPosY))
							v:setPosition(worldPos)
							v.atDirection = self.POSITION_TYPE.XI
						elseif v.atDirection == self.POSITION_TYPE.XI then
  							local worldPos = self._nodeNoPlayer:convertToNodeSpace(cc.p(self._currentSitPosArray[self.POSITION_TYPE.DONG].originPosX , self._currentSitPosArray[self.POSITION_TYPE.DONG].originPosY))
							v:setPosition(worldPos)

							v.atDirection = self.POSITION_TYPE.DONG
  						end
  					end


  				end
		  		local worldPos = self._nodeNoPlayer:convertToNodeSpace(cc.p(self._currentSitPosArray[self.POSITION_TYPE.NAN].originPosX, self._currentSitPosArray[self.POSITION_TYPE.NAN].originPosY))
  				mySelfPositionNode.atDirection = self.POSITION_TYPE.NAN
				mySelfPositionNode:setPosition(worldPos)
			
				for pos,v in ipairs(self._currentSitPosArray) do
  					if pos == self.POSITION_TYPE.XI then
  						self._cardsPanel._nodeGrayDXNB[v.atDirection]:setSpriteFrame("game/mjcomm/words/wordGrayXi.png")
  					elseif pos == self.POSITION_TYPE.NAN then
  						self._cardsPanel._nodeGrayDXNB[v.atDirection]:setSpriteFrame("game/mjcomm/words/wordGrayNan.png")
  					elseif pos == self.POSITION_TYPE.DONG then
  						self._cardsPanel._nodeGrayDXNB[v.atDirection]:setSpriteFrame("game/mjcomm/words/wordGrayDong.png")
  					end
  					self._cardsPanel._nodeGrayDXNB[v.atDirection].posValue = pos
				end

			--_nodeLightDXNB
		else 
			for i,v in pairs(self._allPlayerPosArray) do
				v:setRotation(-du)
			end

			self._nodeNoPlayer:setRotation(du)

			self._cardsPanel._spriteDnxb:setRotation(du)
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
end

function GameSelectPosPanel:configPlayerScore() 

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

function GameSelectPosPanel:getPlayerDirectionByPos(playerPos) 
	for pos,sitNode in ipairs(self._currentSitPosArray) do
		if pos == playerPos then
			return sitNode.atDirection
		end
	end
	return nil
end

function GameSelectPosPanel:onSitDownClick(event) 
	print("**********************************", event:getTag())

	self._selectPositionNode = event

	local arg = {pos = event:getTag()}--weixin
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.SIT_DOWN, arg)
end

function GameSelectPosPanel:onSitDownResponse(msg) 
	print("__________________________", msg.result)

    if msg.result == "success" then
	    print("入座成功")
	    self:configRotation(true)
    else
        print("入座失败")
    end
end

function GameSelectPosPanel:onDealDown(msg)   --发牌13张手牌

	for pos,SitPos in pairs(self._currentSitPosArray) do
		SitPos:setVisible(false)
	end

	for pos,playerLog in pairs(self._currentPlayerLogArray) do
		playerLog:setVisible(true)
	end

	for k,v in pairs(self._currentPlayerLogArray) do
		local run = cc.MoveTo:create(1, cc.p(v.originPosX, v.originPosY))
		v:runAction(run)

		v:getChildByName("Sprite_Zhuang"):setVisible(false)
	end

	self._zhuangPos = msg.zpos
	--显示庄家
	self._zhuangDirection = self:getPlayerDirectionByPos(self._zhuangPos)

	if self._zhuangDirection and self._currentPlayerLogArray[self._zhuangDirection] then
		self._currentPlayerLogArray[self._zhuangDirection]:getChildByName("Sprite_Zhuang"):setVisible(true)
	end

end

function GameSelectPosPanel:onPushSitDown(msg) --推送坐下的信息  
	if msg.room_id == lt.DataManager:getGameRoomInfo().room_id then

		local sitList = msg.sit_list or {}

		local isSendSit = false
		local meSelfInfo = lt.DataManager:getMyselfPositionInfo()
		for i,sitPlayer in ipairs(sitList) do
			if lt.DataManager:getPlayerUid() == sitPlayer.user_id and not meSelfInfo.is_sit then
				isSendSit = true
			end
		end

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

		if not self._deleget._gameResultPanel:isVisible() and not isSendSit then--结算界面
			-- 先推onPushSitDown -》再 入座成功 ->rotation->configPlayer

			--其他玩家
			print("其他玩家入座了！！！！！！！！！！！！！！！！！！！！")
			self:configPlayer()--初始化玩家头像
		end

	end

end

function GameSelectPosPanel:onNoticePlayerConnectState(msg)   --玩家在线情况
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

function GameSelectPosPanel:onRefreshGameOver()   --结算
	if lt.DataManager:getGameOverInfo().players then
		self._allPlayerGameOverData = {}
		for i,v in ipairs(lt.DataManager:getGameOverInfo().players) do
			local direction = self:getPlayerDirectionByPos(v.user_pos)
			self._allPlayerGameOverData[direction] = v
		end
	end

	self._allPlayerGameOverData = self._allPlayerGameOverData or {}

	for i,v in ipairs(self._allPlayerGameOverData) do
		local direction = self:getPlayerDirectionByPos(v.user_pos)
		local logoNode = self._currentPlayerLogArray[direction]
		if logoNode then
			local scoreText = logoNode:getChildByName("Text_Amount")--99999

			if not self._allPlayerGameOverData[direction].score then
				self._allPlayerGameOverData[direction].score = 0
			end
			scoreText:setString(self._allPlayerGameOverData[direction].score)
		end
	end
end

function GameSelectPosPanel:onRefreshScoreResponse(msg)   --玩家刷新积分（杠）

	if lt.DataManager:getGameOverInfo().players then
		self._allPlayerGameOverData = {}
		for i,v in ipairs(lt.DataManager:getGameOverInfo().players) do
			local direction = self:getPlayerDirectionByPos(v.user_pos)
			self._allPlayerGameOverData[direction] = v
		end
	end
	self._allPlayerGameOverData = self._allPlayerGameOverData or {}

	for k,v in pairs(msg.cur_score_list) do

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
			self._allPlayerGameOverData[direction].score = self._allPlayerGameOverData[direction].score + v.delt_score
			scoreText:setString(self._allPlayerGameOverData[direction].score)
		end
	end
end

function GameSelectPosPanel:onClientConnectAgain() 
	self:configPlayerScore()

	-- local allRoomInfo = lt.DataManager:getPushAllRoomInfo()

	-- self._zhuangPos = allRoomInfo.zpos

	-- --显示庄家
	-- self._zhuangDirection = self._deleget:getPlayerDirectionByPos(self._zhuangPos)

	-- if self._zhuangDirection and self._currentPlayerLogArray[self._zhuangDirection] then
	-- 	self._currentPlayerLogArray[self._zhuangDirection]:getChildByName("Sprite_Zhuang"):setVisible(true)
	-- end
end


function GameSelectPosPanel:onEnter()   
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.DEAL_DOWN, handler(self, self.onDealDown), "GameSelectPosPanel:onDealDown")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SIT_DOWN, handler(self, self.onSitDownResponse), "GameSelectPosPanel:onSitDownResponse")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_SIT_DOWN, handler(self, self.onPushSitDown), "GameSelectPosPanel:onPushSitDown")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO, handler(self, self.configPlayer), "GameSelectPosPanel:configPlayer")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_PLAYER_CONNECT_STATE, handler(self, self.onNoticePlayerConnectState), "GameSelectPosPanel:onNoticePlayerConnectState")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.REFRESH_PLAYER_CUR_SCORE, handler(self, self.onRefreshScoreResponse), "GameSelectPosPanel:onRefreshScoreResponse")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.Game_OVER_REFRESH, handler(self, self.onRefreshGameOver), "GameSelectPosPanel:onRefreshGameOver")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.CLIENT_CONNECT_AGAIN, handler(self, self.onClientConnectAgain), "GameSelectPosPanel.onClientConnectAgain")
end

function GameSelectPosPanel:onExit()
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.DEAL_DOWN, "GameSelectPosPanel:onDealDown")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_SIT_DOWN, "GameSelectPosPanel:onPushSitDown")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.SIT_DOWN, "GameSelectPosPanel:onSitDownResponse")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO, "GameSelectPosPanel:configPlayer")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_PLAYER_CONNECT_STATE, "GameSelectPosPanel:onNoticePlayerConnectState")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.REFRESH_PLAYER_CUR_SCORE, "GameSelectPosPanel:onRefreshScoreResponse")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.Game_OVER_REFRESH, "GameSelectPosPanel:onRefreshGameOver")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.CLIENT_CONNECT_AGAIN, "GameSelectPosPanel:onClientConnectAgain")

end

return GameSelectPosPanel