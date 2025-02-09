
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
	self._playerposTableX = {}--玩家头像xpos
	self._playerposTableY = {}--玩家头像ypos
	self._PlayHeadTable = {}--玩家头像点击事件


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
		self:getChildByName("Node_Player"..i):getChildByName("Image_HeadBg"):getChildByName("Image_Head"):setTag(i)
		table.insert(self._PlayHeadTable, self:getChildByName("Node_Player"..i):getChildByName("Image_HeadBg"):getChildByName("Image_Head"))--玩家的头像
		table.insert(self._playerposTableX, self:getChildByName("Node_Player"..i):getPositionX())
		table.insert(self._playerposTableY, self:getChildByName("Node_Player"..i):getPositionY())
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
			--lt.CommonUtil:addNodeClickEvent(v, handler(self, self.onSitDownClick))
		else
			v:setVisible(false)
		end
		lt.CommonUtil:addNodeClickEvent(v, handler(self, self.onSitDownClick))
		v:setVisible(false)
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
		playerLogo:getChildByName("Image_Light"):setVisible(false)
		--Image_Light
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

	for k,node in ipairs(self._PlayHeadTable) do
        lt.CommonUtil:addNodeClickEvent(node, handler(self, self.onHeadEvent))
    end

	self._nodePaoLayer = self:getChildByName("Node_PaoLayer")
	self._nodePaoLayer:setVisible(false)
	self._paoBtn = self._nodePaoLayer:getChildByName("Pao_Btn")
	self._notPaoBtn = self._nodePaoLayer:getChildByName("Not_Pao_Btn")

	lt.CommonUtil:addNodeClickEvent(self._paoBtn, handler(self, self.onSelectPaoClick))
	lt.CommonUtil:addNodeClickEvent(self._notPaoBtn, handler(self, self.onSelectNoPaoClick))
end

function GameSelectPosPanel:onHeadEvent(event)
	local pos = lt.DataManager:getPlayerPosByDirection(event:getTag())
	local info = lt.DataManager:getPlayerInfoByPos(pos)

	self._gamePlayerinfoLayer = lt.GamePlayerinfoLayer.new(info)
	self._gamePlayerinfoLayer:UpdateInfo()
	lt.UILayerManager:addLayer(self._gamePlayerinfoLayer,true)
end

function GameSelectPosPanel:onRefreshRoomInfo(msg)
	if self._gamePlayerinfoLayer then
		self._gamePlayerinfoLayer:UpdateInfo()
	end
end

function GameSelectPosPanel:RestartShow()--游戏结束把听牌标识全false
	for pos,playerLogo in ipairs(self._tingLogoArray) do
		playerLogo:setVisible(false)
	end
end

function GameSelectPosPanel:ShowTingBS(direction)--听牌标识
	print("======GameSelectPosPanel:ShowTingBS==>direction",direction)
	dump(self._tingLogoArray)
	for pos,playerLogo in ipairs(self._tingLogoArray) do
		if direction == pos then
			playerLogo:setVisible(true)
			break
		end
	end
end

function GameSelectPosPanel:HideTingBS(direction)--听牌标识
	print("======GameSelectPosPanel:ShowTingBS==>direction",direction)
	dump(self._tingLogoArray)
	for pos,playerLogo in ipairs(self._tingLogoArray) do
		if direction == pos then
			playerLogo:setVisible(false)
			break
		end
	end
end

function GameSelectPosPanel:ShowLightRing(direction)--光圈标识

	dump(self._playerLogoArray)
	for pos,playerLogo in ipairs(self._playerLogoArray) do
		if direction == pos then
			playerLogo:getChildByName("Image_Light"):setVisible(true)
		else
			playerLogo:getChildByName("Image_Light"):setVisible(false)
		end
	end
end

function GameSelectPosPanel:HideReady()
	for pos,playerLogo in ipairs(self._playerLogoArray) do
		playerLogo:getChildByName("Sprite_Ready"):setVisible(false)
	end
end

function GameSelectPosPanel:againConfigUI()-- 继续游戏 不退程序断线 回到选座界面
	for i,v in ipairs(self._currentSitPosArray) do
		v:setVisible(true)
	end
	self._allPlayerSitOk = false
	self:configPlayer()--初始化玩家头像

	self:clientConnectShowPao()

	if lt.DataManager:isClientConnectAgainPlaying() then
		self:HideReady()
	end

	self:configPlayerProperty()

	-- if lt.DataManager:isClientConnectAgain() then
	-- 	self:configPlayerScore()
	-- end
end

function GameSelectPosPanel:initGame()-- 正常顺序游戏和退程序重连 会走 initGame
	for i,v in ipairs(self._currentSitPosArray) do
		v:setVisible(true)
	end

	self:configRotation()--初始化座位方位
	self:configPlayerScore()
	self:configPlayerProperty()

	self:clientConnectShowPao()
	if lt.DataManager:isClientConnectAgainPlaying() then
		self:HideReady()
	end
end

function GameSelectPosPanel:clientConnectShowPao()
	if lt.DataManager:isClientConnectAgain() then
		local allRoomInfo = lt.DataManager:getPushAllRoomInfo()

		if allRoomInfo.operators then
			for i,operator in ipairs(allRoomInfo.operators) do
				if operator == "PAO" then
					self:showPaoLayer()
					break
				end
			end
		end

		local tingList = allRoomInfo.ting_list or {}
		
		for i,info in ipairs(tingList) do
			local direction = self:getPlayerDirectionByPos(info.user_pos)
			if direction then
				if info.ting then
					self:ShowTingBS(direction)
				else
					self:HideTingBS(direction)
				end
			end
		end
	end
end

function GameSelectPosPanel:showPaoLayer()
	self._nodePaoLayer:setVisible(true)
end

function GameSelectPosPanel:refreshPositionInfo()
	--self:configRotation()--初始化座位方位
	self:configPlayer()
end

function GameSelectPosPanel:configPlayer() --头像 
	
	local gameRoomInfo = lt.DataManager:getGameRoomInfo()
	local allRoomInfo = lt.DataManager:getPushAllRoomInfo()
	
	if lt.DataManager:getMyselfPositionInfo().is_sit then
		for i,v in ipairs(self._currentSitPosArray) do
			v:setVisible(false)
		end		
	end

    for k,playerLogo in pairs(self._currentPlayerLogArray) do
    	playerLogo:setVisible(false)
    end

    local mySelfNode = nil
    for pos,sitNode in ipairs(self._currentSitPosArray) do
    	local player = lt.DataManager:getPlayerInfoByPos(pos)
    	if sitNode.atDirection == self.POSITION_TYPE.NAN then
    		mySelfNode = sitNode
    	end

    	if player then--这个位置有人
    		local playerLog = self._currentPlayerLogArray[sitNode.atDirection]
    		if playerLog then
				local name = playerLog:getChildByName("Text_Name")
				if name then
					name:setString(player.user_name)
				end

				local img = playerLog:getChildByName("Image_HeadBg"):getChildByName("Image_Head")
				--player.user_pic = "http://img1.utuku.china.com/0x0/game/20160718/f2547293-78a9-4e50-a80f-727593f8c19f.jpg"
    			lt.HeadImage:setHeadImg(player, img)

				--playerLog:getChildByName("Sprite_Zhuang"):setVisible(false)
				playerLog:getChildByName("Sprite_Disconnect"):setVisible(false)
				if player.is_sit then
					if player.disconnect then
						playerLog:getChildByName("Sprite_Disconnect"):setVisible(true) --断线标识
					else
						playerLog:getChildByName("Sprite_Disconnect"):setVisible(false) --断线标识
					end
				end

				if player.user_id ~= lt.DataManager:getPlayerInfo().user_id then--别的玩家的头像
					
					if not lt.DataManager:getRePlayState() then--回放
						sitNode:setVisible(false)
					else
						sitNode:setVisible(true)
					end

					self._currentPlayerLogArray[sitNode.atDirection]:setVisible(true)
					if player.is_sit then

	        			self._currentPlayerLogArray[sitNode.atDirection]:getChildByName("Sprite_Ready"):setVisible(true)
	        			
	        			if not lt.DataManager:getRePlayState() then--回放
		        			if not lt.DataManager:isClientConnectAgainPlaying() then--入座界面
		        				local worldPos = self._nodeNoPlayer:convertToWorldSpace(cc.p(sitNode:getPosition()))
			        			self._currentPlayerLogArray[sitNode.atDirection]:setPosition(worldPos.x, worldPos.y)
		        			end
	        			end
	        		else
		        		self._currentPlayerLogArray[sitNode.atDirection]:getChildByName("Sprite_Ready"):setVisible(false)
	        			
		        		if not lt.DataManager:getRePlayState() then--回放
		        			if not lt.DataManager:isClientConnectAgainPlaying() then--入座界面
		        				local worldPos = self._nodeNoPlayer:convertToWorldSpace(cc.p(sitNode:getPosition()))
		        				self._currentPlayerLogArray[sitNode.atDirection]:setPosition(worldPos.x, worldPos.y)
			        		end	
		        		end
					end
				else

					if mySelfNode and player.is_sit then

						if not lt.DataManager:getRePlayState() then--回放
							mySelfNode:setVisible(false)
						else
							mySelfNode:setVisible(true)
						end

						if not lt.DataManager:getRePlayState() then--回放
							if not lt.DataManager:isClientConnectAgainPlaying() then--入座界面
								local worldPos = self._nodeNoPlayer:convertToWorldSpace(cc.p(mySelfNode:getPosition()))
								self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:setPosition(worldPos.x, worldPos.y)
							end
						end


						self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:getChildByName("Sprite_Ready"):setVisible(true)
					
						self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:setVisible(true)
					end

					if gameRoomInfo.cur_round > 0 and lt.DataManager:isClientConnectAgain() and not player.is_sit then--入座界面
						self._deleget:sendAutoSitDown() 
					end
				end
    		end
    	else
    		self._currentPlayerLogArray[sitNode.atDirection]:setVisible(false)
			if not lt.DataManager:getMyselfPositionInfo().is_sit then
				sitNode:setVisible(true)
			end
    	end
    end	
end

function GameSelectPosPanel:configRotation(isClick, CallFunc) 

	local action = self._nodeNoPlayer:getActionByTag(99)
	if action and not action:isDone() then
		return
	end

	--self._nodeNoPlayer:stopAllActions() isRunning
	self._handSelect:setVisible(false)


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
	    	self._deleget:configChatVisible(true)
	    	self:configPlayer()
	    	if CallFunc then
				CallFunc()
			end
	    	return
	    end

	    for i,v in ipairs(self._currentPlayerLogArray) do
			v:setVisible(false)
		end
		
    	local headVisible = function ( )
			self._selectPositionNode:setVisible(false)
			self._deleget:configChatVisible(true)
			self:configPlayer()
			if CallFunc then
				CallFunc()
			end
			--self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:setVisible(true)
			-- self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:getChildByName("Sprite_Ready"):setVisible(true)

			-- local worldPos = self._nodeNoPlayer:convertToWorldSpace(cc.p(self._selectPositionNode:getPosition()))
			-- self._currentPlayerLogArray[self.POSITION_TYPE.NAN]:setPosition(worldPos.x, worldPos.y)
		end

  		--三人
  		if self._playerNum == 3 then
  			local action = cc.RotateBy:create(time, du)
			local action1 = function ( )
				--self._selectPositionNode:runAction(action3)
				for i,v in pairs(self._currentSitPosArray) do
					local action3 = cc.RotateBy:create(time, -du)
					v:runAction(action3)
				end
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
				self:setPlayerDirectionTable()
  			end

			local spawn = cc.Spawn:create(cc.CallFunc:create(action1), action)
			
	  		local sequence = cc.Sequence:create(spawn, cc.CallFunc:create(action2), cc.CallFunc:create(headVisible))
	  		sequence:setTag(99)
  			self._nodeNoPlayer:runAction(sequence)
			--_nodeLightDXNB
		else 
	  		--二 四人
			local action = cc.RotateBy:create(time, du)

			local action2 = function ( )
				
				--self._selectPositionNode:runAction(action3)
				for i,v in pairs(self._allPlayerPosArray) do
					local action3 = cc.RotateBy:create(time, -du)--父节点也进行了旋转所以为负
					v:runAction(action3)
				end

			end

			local action1 = function ( )
				local action4 = cc.RotateBy:create(0.6, du)
				self._cardsPanel._spriteDnxb:runAction(action4)
			end

			local spawn = cc.Sequence:create(cc.CallFunc:create(action1), cc.CallFunc:create(action2), action)
			
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
			self:setPlayerDirectionTable()
			sequence:setTag(99)
	  		self._nodeNoPlayer:runAction(sequence)

  		end

	else
		for i,v in ipairs(self._currentPlayerLogArray) do
			v:setVisible(false)
		end

		local mySelfPosition = lt.DataManager:getMyselfPositionInfo().user_pos

		local du = 0

		local mySelfPositionNode = self._currentSitPosArray[mySelfPosition]

		if mySelfPositionNode then
			du = (mySelfPositionNode.atDirection - self.POSITION_TYPE.NAN) * 90
		end

		if du == 0 then
			self:setPlayerDirectionTable()

			self:configSpriteDnxb()
			self:configPlayer()
			return
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
			self._nodeNoPlayer:setRotation(du)

			for i,v in pairs(self._allPlayerPosArray) do
				v:setRotation(-du)
			end

			--self._cardsPanel._spriteDnxb:setRotation(du)
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

			self:configSpriteDnxb()
		end
		self:setPlayerDirectionTable()
	
		self:configPlayer()
	end
end

function GameSelectPosPanel:setPlayerDirectionTable()
	local directionData = {}
	for pos,sitNode in ipairs(self._currentSitPosArray) do
		directionData[sitNode:getTag()] = sitNode.atDirection
	end
	--全局记录一下位置对应的方位
	lt.DataManager:setPlayerDirectionTable(directionData)
end

function GameSelectPosPanel:configSpriteDnxb()
	for pos,sitNode in ipairs(self._currentSitPosArray) do
		self._cardsPanel._nodeGrayDXNB[sitNode.atDirection].posValue = pos
	end
	self._cardsPanel:resetLightUpdate()
end

function GameSelectPosPanel:configPlayerScore() --初始化和断线重连
	if lt.DataManager:getGameRoomInfo().players then
		for i,v in ipairs(lt.DataManager:getGameRoomInfo().players) do
			local direction = self:getPlayerDirectionByPos(v.user_pos)
			local logoNode = self._currentPlayerLogArray[direction]
			if logoNode then
				logoNode:getChildByName("Text_Amount"):setString(v.score) --99999
			end
		end
	end
end

function GameSelectPosPanel:configPlayerProperty(pos)
	
	local state = lt.DataManager:getGameState()
	if state == lt.Constants.ROOM_STATE.GAME_PREPARE then
		return
	end

	if pos then
		self:configProperty(pos)
	else
		for pos=1,self._playerNum do
			self:configProperty(pos)
		end
	end
end

function GameSelectPosPanel:configProperty(pos)

	local direc = self:getPlayerDirectionByPos(pos)
	if not direc or not self._currentPlayerLogArray[direc] then
		return
	end

	local paoList = lt.DataManager:getPaoPlayerInfo()
	local yingKouList = lt.DataManager:getYingkouPlayerInfo()

	local posX = 0
	local posY = 50
	local offY = 0
	local offX = 0
	if direc == lt.Constants.DIRECTION.NAN then
		posY = -50
		offX = 60
	elseif direc == lt.Constants.DIRECTION.DONG then
		offY = 30
	elseif direc == lt.Constants.DIRECTION.BEI then
		posY = -50
		offX = 60
	elseif direc == lt.Constants.DIRECTION.XI then
		offY = 30
	end

	local contentNode = self._currentPlayerLogArray[direc]:getChildByTag(888)
	if contentNode then
		contentNode:removeFromParent()
	end
	contentNode = cc.Node:create()
	contentNode:setPosition(0, 0)
	contentNode:setTag(888)
	self._currentPlayerLogArray[direc]:addChild(contentNode)
	
	local isPao = false
	local isYingkou = false
	for k,v in pairs(paoList) do
		if v.user_pos == pos and v.pao then
			isPao = true
			break
		end
	end
	for k,v in pairs(yingKouList) do
		if v.user_pos == pos and v.kou then
			isYingkou = true
			break
		end
	end
	if isPao then
		local tipIcon = ccui.ImageView:create("game/mjcomm/part/pao1Tip.png",1)
		tipIcon:setAnchorPoint(0.5,0.5)
		tipIcon:setPosition(posX, posY)
		contentNode:addChild(tipIcon)
		posY = posY + offY
		posX = posX + offX
	end

	if isYingkou then
		local tipIcon = ccui.ImageView:create("game/mjcomm/part/yingkouTip.png",1)
		tipIcon:setAnchorPoint(0.5,0.5)
		tipIcon:setPosition(posX, posY)
		contentNode:addChild(tipIcon)
		posY = posY + offY
		posX = posX + offX
	end	
end

function GameSelectPosPanel:getPlayerDirectionByPos(playerPos) 
	for pos,sitNode in ipairs(self._currentSitPosArray) do
		if sitNode:getTag() == playerPos then
			return sitNode.atDirection
		end
	end
	return nil
end

function GameSelectPosPanel:onSelectPaoClick(event) 
	self._nodePaoLayer:setVisible(false)
	local arg = {command = "PAO", pao_num = 1}
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
end

function GameSelectPosPanel:onSelectNoPaoClick(event) 
	self._nodePaoLayer:setVisible(false)
	local arg = {command = "PAO", pao_num = 0}
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
end

function GameSelectPosPanel:onSitDownClick(event) 
	print("GameSelectPosPanel:onSitDownClick==>event:getTag()",event:getTag())
	if lt.DataManager:getRePlayState() then
		self._selectPositionNode = event

		local info = lt.DataManager:getPlayerInfoByPos(event:getTag())

		if info then
			lt.DataManager:setMyselfPositionInfo(info)

			local function func()
				self._deleget:CreateReplay()
				self._deleget:ReplayUIshow()
				--lt.MJplayBackLayer:Start()--启动定时器
			end
			self:configRotation(true, func)
		else

		end

	else
		self._selectPositionNode = event

		local arg = {pos = event:getTag()}--weixin
	    lt.NetWork:sendTo(lt.GameEventManager.EVENT.SIT_DOWN, arg)
	end
end

function GameSelectPosPanel:onSitDownResponse(msg) 

    if msg.result == "success" then
	    self:configRotation(true)
    else
    	lt.PromptPanel:showPrompt(lt.Constants.PROMPT[msg.result])
    end
end

function GameSelectPosPanel:onPushSitDown(msg) --推送坐下的信息  
	if msg.room_id == lt.DataManager:getGameRoomInfo().room_id then

		local sitList = msg.sit_list or {}

		--是不是自己发送的入座协议 走了configRotation(true)
		local isSendSit = false
		local meSelfInfo = lt.DataManager:getMyselfPositionInfo()
		if meSelfInfo and not meSelfInfo.is_sit then
			for i,sitPlayer in ipairs(sitList) do
				if lt.DataManager:getPlayerUid() == sitPlayer.user_id and not meSelfInfo.is_sit then
					isSendSit = true
					break
				end
			end			
		end

		for i,player in ipairs(lt.DataManager:getGameRoomInfo().players) do

			player.is_sit = false
			for k,sitPlayer in ipairs(sitList) do

				if player.user_id == sitPlayer.user_id then
					player.is_sit = true
					player.disconnect = false
					player.user_pos = sitPlayer.user_pos
					break
				end
			end
		end

		if not self._deleget._gameResultPanel:isVisible() then--结算界面
			-- 先推onPushSitDown -》再 入座成功 ->rotation->configPlayer

			print("玩家入座了！！！！！！！！！！！！！！！！！！！！")
			
			if #sitList == self._playerNum then--最后一个玩家入座的状态在发牌时
				self._allPlayerSitOk = true
			else
				self._allPlayerSitOk = false
			end

			if not isSendSit then--不是自己点击入座导致的
				self:configPlayer()--初始化玩家
			end
		end
	end

end

function GameSelectPosPanel:onDealDown(msg)   --发牌13张手牌
	self._nodePaoLayer:setVisible(false)
	self:HideReady()
	--进入游戏之中后 隐藏邀请按钮
	
	lt.GameEventManager:post(lt.GameEventManager.EVENT.HIDE_INVITE_BTN)

	for pos,SitPos in pairs(self._currentSitPosArray) do
		SitPos:setVisible(false)
	end

	for pos,playerLog in pairs(self._currentPlayerLogArray) do
		playerLog:setVisible(true)
	end

	for k,v in pairs(self._currentPlayerLogArray) do
		print("++++++++++++++++++++++++++++++位置", v.originPosX, v.originPosY)
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
	lt.DataManager:setGameState(lt.Constants.ROOM_STATE.GAME_PLAYING)
	
	self:configPlayerProperty()
end

function GameSelectPosPanel:onNoticePao(msg) 
	if not lt.DataManager:getRePlayState() then
		self._nodePaoLayer:setVisible(true)
	end
end

function GameSelectPosPanel:pushPlayerPao(msg) 
	local paoList = lt.DataManager:getPaoPlayerInfo()
	table.insert(paoList, msg)
	self:configPlayerProperty(msg.user_pos)
end

function GameSelectPosPanel:onNoticeYingKou(msg)
	
	
	local yingKouList = lt.DataManager:getYingkouPlayerInfo()

	local info = {}
	info["user_pos"] = msg.user_pos
	info["kou"] = true
	table.insert(yingKouList, info)

	self:configPlayerProperty(msg.user_pos)
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

function GameSelectPosPanel:onRefreshScoreResponse(msg)   --玩家刷新积分（杠,hu）

	for k,v in pairs(msg.cur_score_list) do

		local direction = self:getPlayerDirectionByPos(v.user_pos)
		local logoNode = self._currentPlayerLogArray[direction]
		if logoNode then
			local scoreText = logoNode:getChildByName("Text_Amount")--99999
			scoreText:setString(v.score)
		end
	end
end

function GameSelectPosPanel:onRefreshGameOver()   --结算
	self._allPlayerSitOk = false
	if lt.DataManager:getGameOverInfo().players then
		for i,v in ipairs(lt.DataManager:getGameOverInfo().players) do
			local direction = self:getPlayerDirectionByPos(v.user_pos)
			local logoNode = self._currentPlayerLogArray[direction]
			if logoNode then
				local scoreText = logoNode:getChildByName("Text_Amount")--99999

				scoreText:setString(v.score)
			end
		end
	end

end

function GameSelectPosPanel:onClientConnectAgain() 
	self:configPlayerScore()

	-- local allRoomInfo = lt.DataManager:getPushAllRoomInfo()

	-- self._zhuangPos = allRoomInfo.zpos:
	-- --显示庄家
	-- self._zhuangDirection = self._deleget:getPlayerDirectionByPos(self._zhuangPos)

	-- if self._zhuangDirection and self._currentPlayerLogArray[self._zhuangDirection] then
	-- 	self._currentPlayerLogArray[self._zhuangDirection]:getChildByName("Sprite_Zhuang"):setVisible(true)
	-- end
end

function GameSelectPosPanel:createChatNotice(direc)
	local node = cc.Node:create()
	local chatPanel = nil
	if direc == lt.Constants.DIRECTION.NAN then
		chatPanel = ccui.ImageView:create("game/mjcomm/part/bgPaoPaoLeft.png",1)
		chatPanel:setAnchorPoint(0,0)
		node:setPosition(-40, 40)
	elseif direc == lt.Constants.DIRECTION.DONG then
		chatPanel = ccui.ImageView:create("game/mjcomm/part/bgPaoPaoRight.png",1)
		chatPanel:setAnchorPoint(1,0)
		node:setPosition(40, 40)
	elseif direc == lt.Constants.DIRECTION.BEI then
		chatPanel = ccui.ImageView:create("game/mjcomm/part/bgPaoPaoLeft.png",1)
		chatPanel:setAnchorPoint(0,0)
		chatPanel:setScaleY(-1)
		node:setPosition(-40, -40)
	elseif direc == lt.Constants.DIRECTION.XI then
		chatPanel = ccui.ImageView:create("game/mjcomm/part/bgPaoPaoRight.png",1)
		chatPanel:setAnchorPoint(1,0)
		chatPanel:setScaleX(-1)
		node:setPosition(-40, 40)
	end
	chatPanel:setScale9Enabled(true)

	local textWord = cc.Label:createWithSystemFont("", "Helvetica", 28)
	local spritExpression = display.newSprite("#game/zpcomm/img/ButtonChatIcon1.png")
	textWord:setTag(1)
	spritExpression:setTag(2)
	chatPanel:setTag(3)

	node:addChild(chatPanel)
	node:addChild(textWord)
	node:addChild(spritExpression)
	return node
end

function GameSelectPosPanel:onNoticeFastSpake(tObj)
	dump(tObj, "noticeFastSPake")
	local idx = self:getPlayerDirectionByPos(tObj.user_pos)

	if not self._currentPlayerLogArray[idx] then
		return
	end
	local contentNode = self._currentPlayerLogArray[idx]:getChildByTag(666)
	if not contentNode then
		contentNode = self:createChatNotice(idx)
		if not contentNode then
			return
		end
		self._currentPlayerLogArray[idx]:addChild(contentNode)
		contentNode:setTag(666)
	end

	local imgFace = nil
	local txtWorld = nil
	local imgBg = nil

	txtWorld = contentNode:getChildByTag(1)
	imgFace = contentNode:getChildByTag(2)
	imgBg = contentNode:getChildByTag(3)
	if not txtWorld or not imgFace or not imgBg then
		return
	end

	local strChat = tObj.fast_index
	local tDDZFastInfo =  {
		"快点啊,都等的我花儿都谢了！",
        "别吵了,专心玩游戏！",
        "你是妹妹还是哥哥啊？",
        "大家好,很高兴见到各位！",
        "又断线了,网络怎么这么差！",
        "和你合作真是太愉快了。",
        "下次再玩吧,我要走了。",
        "不要走,决战到天亮。",
        "我们交个朋友吧,告诉我你的联系方法。",
        "各位,真不好意思,我要离开会。",
        "你的牌打的太好了！",
        "再见了,我会想念大家的！",
	}
    -- 快捷和表情
    if string.find(strChat,"/00") ~= nil and string.len(strChat) > 3 then
        local intIndex = tonumber( string.sub(strChat,4) )
        if intIndex ~= nil then           
            -- 表情
            if intIndex > 1 and intIndex < 31 then  
                intIndex = intIndex - 1    
                local strSprite = string.format("game/zpcomm/img/ButtonChatIcon%d.png",intIndex) 
                local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(strSprite)
                imgFace:setSpriteFrame(frame)
                imgFace:setVisible(true)
                txtWorld:setVisible(false)

				imgBg:setCapInsets(cc.size(0, 0, imgFace:getBoundingBox().width + 10, imgFace:getBoundingBox().height + 30))

                imgBg:setContentSize(cc.size(imgFace:getBoundingBox().width + 10, imgFace:getBoundingBox().height + 30))

            -- 快捷
            elseif intIndex > 101 and intIndex < 102 + #tDDZFastInfo then

                imgFace:setVisible(false) 

                intIndex = intIndex-101   

				txtWorld:setVisible(true) 
				txtWorld:setString(tDDZFastInfo[intIndex])
				imgBg:setCapInsets(cc.size(0, 0, txtWorld:getContentSize().width+30, txtWorld:getContentSize().height + 30))
				imgBg:setContentSize(cc.size(txtWorld:getContentSize().width+30, txtWorld:getContentSize().height + 30))
                --播放说话音效
                local iChatStrIdx = -1
                for var = 1, #tDDZFastInfo do
                    if var == intIndex then
                        iChatStrIdx = var - 1
                        break
                    end
                end
                lt.AudioManager:playFastChatSound(iChatStrIdx, tObj.user_pos)
            end
            local width = imgBg:getContentSize().width / 2
            local height = imgBg:getContentSize().height / 2 + 8
			if idx == lt.Constants.DIRECTION.NAN then
			elseif idx == lt.Constants.DIRECTION.DONG then
				width = -width
			elseif idx == lt.Constants.DIRECTION.BEI then
				height = -height
			elseif idx == lt.Constants.DIRECTION.XI then

			end
            txtWorld:setPosition(width, height)
            imgFace:setPosition(width, height)
            contentNode:setVisible(true)

            local function funHideChat()
                contentNode:setVisible(false)
                txtWorld:setVisible(false)
                imgFace:setVisible(false)
            end
            if self["m_chatPaoPaoListener_"..idx] then
            	lt.scheduler.unscheduleGlobal(self["m_chatPaoPaoListener_"..idx])
            end
            
            self["m_chatPaoPaoListener_"..idx] = lt.scheduler.performWithDelayGlobal(funHideChat, 3)
        end
    end
end

function GameSelectPosPanel:onEnter()   
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.DEAL_DOWN, handler(self, self.onDealDown), "GameSelectPosPanel:onDealDown")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SIT_DOWN, handler(self, self.onSitDownResponse), "GameSelectPosPanel:onSitDownResponse")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_SIT_DOWN, handler(self, self.onPushSitDown), "GameSelectPosPanel:onPushSitDown")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO, handler(self, self.refreshPositionInfo), "GameSelectPosPanel:refreshPositionInfo")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_PLAYER_CONNECT_STATE, handler(self, self.onNoticePlayerConnectState), "GameSelectPosPanel:onNoticePlayerConnectState")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.REFRESH_PLAYER_CUR_SCORE, handler(self, self.onRefreshScoreResponse), "GameSelectPosPanel:onRefreshScoreResponse")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.Game_OVER_REFRESH, handler(self, self.onRefreshGameOver), "GameSelectPosPanel:onRefreshGameOver")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.CLIENT_CONNECT_AGAIN, handler(self, self.onClientConnectAgain), "GameSelectPosPanel:onClientConnectAgain")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_PAO, handler(self, self.onNoticePao), "GameSelectPosPanel.onNoticePao")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_FAST_SPAKE, handler(self, self.onNoticeFastSpake), "GameSelectPosPanel:onNoticeFastSpake")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO, handler(self, self.onRefreshRoomInfo), "GameSelectPosPanel.onRefreshRoomInfo")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_YING_KOU, handler(self, self.onNoticeYingKou), "GameSelectPosPanel.onNoticeYingKou")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_PLAYER_PAO, handler(self, self.pushPlayerPao), "GameSelectPosPanel.pushPlayerPao")
end

function GameSelectPosPanel:onExit()
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.DEAL_DOWN, "GameSelectPosPanel:onDealDown")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_SIT_DOWN, "GameSelectPosPanel:onPushSitDown")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.SIT_DOWN, "GameSelectPosPanel:onSitDownResponse")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO, "GameSelectPosPanel:refreshPositionInfo")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_PLAYER_CONNECT_STATE, "GameSelectPosPanel:onNoticePlayerConnectState")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.REFRESH_PLAYER_CUR_SCORE, "GameSelectPosPanel:onRefreshScoreResponse")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.Game_OVER_REFRESH, "GameSelectPosPanel:onRefreshGameOver")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.CLIENT_CONNECT_AGAIN, "GameSelectPosPanel:onClientConnectAgain")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_PAO, "GameSelectPosPanel.onNoticePao")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_FAST_SPAKE, "GameSelectPosPanel:onNoticeFastSpake")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO, "GameSelectPosPanel.onRefreshRoomInfo")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_YING_KOU, "GameSelectPosPanel.onNoticeYingKou")
		lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_PLAYER_PAO, "GameSelectPosPanel.pushPlayerPao")
end

return GameSelectPosPanel