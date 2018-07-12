local GameRuleLayer = class("GameRuleLayer", function()
	return cc.CSLoader:createNode("games/ddz/GameRuleLayer.csb")--背景层
end)


function GameRuleLayer:ctor()
	self.blackBg = self:getChildByName("Ie_Mark")
	-- 
	self.Bg = self:getChildByName("Ie_Bg")

	self.ruleBg =  self.Bg:getChildByName("Ie_RuleBg")	
	-- 房间设置层
	self.gameLayer = self.ruleBg:getChildByName("LV_GameRule")	
	-- 游戏规则层
	self.roomLayer = self.ruleBg:getChildByName("Pl_RoomRule")	
	-- btn  切换到玩法
	self.btnRoomRule = self.ruleBg:getChildByName("Bn_RoomRule")	
	-- 玩法选中
	self.btnCheckRoomRule = self.ruleBg:getChildByName("Ie_CheckRoomRule")	
	-- btn  切换到房间设置
	self.btnGameRule = self.ruleBg:getChildByName("Bn_GameRule")	
	-- 房间设置的选中
	self.btnCheckGameRule = self.ruleBg:getChildByName("Ie_CheckGameRule")	
	
	lt.CommonUtil:addNodeClickEvent(self.blackBg, function()
		self:close()
	end, false)

	lt.CommonUtil:addNodeClickEvent(self.btnRoomRule, function()
		self:showGameRule()
	end, false)

	lt.CommonUtil:addNodeClickEvent(self.btnGameRule, function()
		self:showGameSetting()
	end, false)
end

function GameRuleLayer:initGameSetting( otherSetting )
	self.otherSetting = otherSetting
	dump(self.otherSetting, "|self.otherSetting")
	self:showGameRule()
end


function GameRuleLayer:showGameSetting( ... )

	self.gameLayer:setVisible(true)
	self.roomLayer:setVisible(false)

	self.btnRoomRule:setVisible(true)
	self.btnCheckRoomRule:setVisible(false)	

	self.btnGameRule:setVisible(false)
	self.btnCheckGameRule:setVisible(true)

end

function GameRuleLayer:showGameRule( ... )
	self.gameLayer:setVisible(false)
	self.roomLayer:setVisible(true)

	self.btnRoomRule:setVisible(false)
	self.btnCheckRoomRule:setVisible(true)	

	self.btnGameRule:setVisible(true)
	self.btnCheckGameRule:setVisible(false)

	self:initGameRuleList()
end

function GameRuleLayer:initGameRuleList( ... )

	dump(self.otherSetting, "self.otherSetting")

	if not self.otherSetting then
		return
	end

	-- "room_setting" = {
	--     "game_type"      = 2
	--     "is_friend_room" = false
	--     "is_open_gps"    = false
	--     "is_open_voice"  = false
	--     "other_setting" = {
	--         1 = 1
	--         2 = 1
	--         3 = 3
	--         4 = 0
	--         5 = 0
	--     }
	--     "pay_type"       = 1
	--     "round"          = 6
	--     "seat_num"       = 3
	-- }
	
	local pointPay = self.roomLayer:getChildByName("Ie_PayCheck")
	local PointRound = self.roomLayer:getChildByName("Ie_RoundCheck")
	local PointPlay = self.roomLayer:getChildByName("Ie_PlayCheck")
	local round = {6, 12, 20}
	local Play = {1, 2}
	
	local PayName = {"Ie_Pay1", "Ie_Pay2", "Ie_Pay3"}
	local RoundName = {"Ie_Round1", "Ie_Round2", "Ie_Round3"}
	local PlayName = {"Ie_Play1", "Ie_Play2"}

	for i, v in pairs(PayName) do 
		local btn = self.roomLayer:getChildByName(v)

		-- 出资方式
		if self.otherSetting.pay_type == i then
			local px, py = btn:getPosition()
			pointPay:setPosition(px, py)
		end
	end

	for i, v in pairs(RoundName) do 
		local btn = self.roomLayer:getChildByName(v)

		-- 出资方式
		if self.otherSetting.round == round[i] then
			local px, py = btn:getPosition()
			PointRound:setPosition(px, py)
		end
	end


	local txtBaseNum = self.roomLayer:getChildByName("Text_BaseScore")
	txtBaseNum:setString(self.otherSetting.other_setting[1])

	for i, v in pairs(PlayName) do 
		local btn = self.roomLayer:getChildByName(v)

		-- 出资方式
		if self.otherSetting.other_setting[2] == Play[i] then
			local px, py = btn:getPosition()
			PointPlay:setPosition(px, py)
		end
	end
end


function GameRuleLayer:close( ... )
	self:removeFromParent()
end


return GameRuleLayer