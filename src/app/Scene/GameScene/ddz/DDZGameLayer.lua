local DDZGameRoomLayer = class("DDZGameRoomLayer", lt.BaseLayer)

function DDZGameRoomLayer:ctor( ... )
	
	-- body
	DDZGameRoomLayer.super.ctor(self)

	local roomInfo = lt.DataManager:getGameRoomInfo()

	self.roomInfo = roomInfo
	dump(roomInfo, "DDZ进入房间的信息roomInfo")

	-- 游戏层，	
	local gameLayer = cc.CSLoader:createNode("games/ddz/GameLayerLandscape.csb")--背景层

	self:addChild(gameLayer)

	self.gameLayer = gameLayer

	-- 桌子背景
	local gameLayerBg = gameLayer:getChildByName("Image_Bg")
	
	self.imgNongMin = {}
	self.imgDiZhu = {}
	for i = 1, 3 do 
		-- 小孩(农民和地主)
		local spPeople = gameLayerBg:getChildByName("Image_Nongmin".. i)
		spPeople:setVisible(false)
		self.imgNongMin[i] = spPeople
		local spLandLoad = gameLayerBg:getChildByName("Image_Dizhu".. i)	
		self.imgDiZhu[i] = spLandLoad
	end
	-- 手牌层
	local Panel_HandCard = gameLayer:getChildByName("Panel_HandCard")
	-- 出牌层
	local Panel_SendCard = gameLayer:getChildByName("Panel_HandCard")
	-- 桌子信息（底牌， 底分）
	local img_tableInfo = gameLayer:getChildByName("Ie_TableInfo")

	-- 经典模式和欢乐模式
	self.txtPlayRule1 = img_tableInfo:getChildByName("Text_PlayRule1")
	-- 几炸封顶
	self.txtPlayRule2 = img_tableInfo:getChildByName("Text_PlayRule2")
	-- 底分
	self.txtPlayRule3 = img_tableInfo:getChildByName("AtlasLabel_Base")
	
	-- 3张底牌
	self.imgBaseCard = {}
	self.imgBaseCard[1] = gameLayer:getChildByName("Image_LandCard1")
	self.imgBaseCard[2] = gameLayer:getChildByName("Image_LandCard2")
	self.imgBaseCard[3] = gameLayer:getChildByName("Image_LandCard3")

	-- rule 
	local Ie_RuleBg = gameLayer:getChildByName("Ie_RuleBg")
	-- 局数
	self.roundIndex = Ie_RuleBg:getChildByName("Al_Ji")
	self.gameNameTxt = Ie_RuleBg:getChildByName("Se_Di")
	-- 房间号：
	self.roomNum = Ie_RuleBg:getChildByName("Al_RoomNo")
	self.roomTxt = Ie_RuleBg:getChildByName("Se_RoomNo")
	-- 电量
	self.batteryTxt = Ie_RuleBg:getChildByName("Se_PhoneBattery")
	-- 时间
	self.nowTimeTxt = Ie_RuleBg:getChildByName("Tt_PhoneTime")
	-- 联网方式
	self.nowNetType = Ie_RuleBg:getChildByName("Se_PhoneNet")
	-- 玩家信息层
	local Node_Players = gameLayer:getChildByName("Node_Players")
	self.playerNodeInfo = {}

	Node_Players:setVisible(true)
	for i = 1, 3 do 
		local node = Node_Players:getChildByName("Node_Player" ..i)
		-- 背景图
		local imgPlaybg = node:getChildByName("Image_PlayerBg")
		node.imgBg = imgPlaybg:getChildByName("Image_HeadBg")
		-- 等待出牌
		node.imgWaitSend = imgPlaybg:getChildByName("Image_SendCard")
		-- 头像
		node.imgHead = imgPlaybg:getChildByName("Image_Head")
		-- 断线标志
		node.imgDisNet = imgPlaybg:getChildByName("Sprite_Disconnect")
		-- 断线提醒（文字）
		if i ~= 2 then -- 自己没有提醒文字， 所以不用去获取， 用的时候需要注意点
			node.imgWaitLongTime = node:getChildByName("Error_BG")
		end
		-- 玩家昵称
		node.txtName = node:getChildByName("Text_Name")
		-- 玩家积分
		node.iAmount = node:getChildByName("AtlasLabel_UserMoneyNum")
		-- pass标志
		node.imgPass = node:getChildByName("Sprite_Pass")
		-- ready 
		node.ready = node:getChildByName("Sprite_PlayReady")
		-- 叫的分（sprite 需要切换图片）
		node.pointDemand = node:getChildByName("Sprite_PointDemand")
		-- 加倍
		node.double = node:getChildByName("Sprite_Double")
		-- 玩家的牌
		node.cardInfo = node:getChildByName("Node_PlayCardInfo")
		-- 上面有剩余的牌数和一张背景图
		node.cardBg = node.cardInfo:getChildByName("Sprite_CardBg")
		node.cardNum = node.cardInfo:getChildByName("Text_CardNum")
		-- 玩家的倒计时
		node.clock = node:getChildByName("Node_Clock")

		self.playerNodeInfo[i] = node
	end

	-- 这个是什么鬼 复盘的时候摆牌的位置？
	-- Node_DragLayer
	local Node_DragLayer = gameLayer:getChildByName("Node_DragLayer")
	-- 退出游戏功能
	local btnBackGame = gameLayer:getChildByName("Bn_GameBack")

	lt.CommonUtil:addNodeClickEvent(btnBackGame, function()
		local gameScene = lt.BaseLayer.new()
		lt.SceneManager:replaceScene(gameScene)
	end)

	-- 游戏规则
	local btnGameRule = gameLayer:getChildByName("Bn_GameRule")
	-- 表情聊天按钮
	local btnFace = gameLayer:getChildByName("Bn_Chat")
	-- Bn_Voice 语音聊天功能
	local btnVoice = gameLayer:getChildByName("Bn_Voice")
	-- 牌层吧
	local cardPanle = gameLayer:getChildByName("Panel_BaseCard")
	-- 结算层
	local resultLayer = gameLayer:getChildByName("Node_ResultLayer")
	-- 游戏帮助层
	local panelHelp = gameLayer:getChildByName("Bg_Help_Start")
	self.panelHelp = panelHelp
	-- 设置按钮
	self.btnSetting = panelHelp:getChildByName("Button_Setting")

	self:addNodeClickEvent(self.btnSetting, function( ... )
		-- 打开设置界面
		self:openSetting()
	end)

	-- 申请解散房间按钮
	self.btnDisband = panelHelp:getChildByName("Button_Disband")
	-- 申请解散房间
	self:addNodeClickEvent(self.btnDisband, function( ... )
		-- 申请解散房间
		self:openDisBandLayer()
	end)

	-- 返回大厅按钮(离开，设置，申请解散房间)
	self.btnBackRoom = panelHelp:getChildByName("Button_Back")
	-- 返回大厅
	self:addNodeClickEvent(self.btnBackRoom, function( ... )
		self:onBackLobby()
	end)

	-- 没有开始的时候的帮助页面(离开，设置，解散房间)
	local btnNoStart = gameLayer:getChildByName("Bg_Help_NoStart")
	self.btnNoStart = btnNoStart
	-- 离开房间
	self.btnNSBackRoom = self.btnNoStart:getChildByName("Button_Back")
	-- 返回大厅
	self:addNodeClickEvent(self.btnNSBackRoom, function( ... )
		self:onBackLobby()
	end)
	-- 解散房间
	self.btnNSDisRoom = btnNoStart:getChildByName("Button_Disband")
	-- 设置
	self.btnNSSetting = btnNoStart:getChildByName("Button_Setting")

	-- 更多设置选项 Bn_More
	self.btnMore = gameLayer:getChildByName("Bn_More")

	--  帮助界面
	lt.CommonUtil:addNodeClickEvent(self.btnMore, function()
		-- 打开帮助界面
		self:openHelpLayer()
	end)

	-- 聊天界面
	local chatLayer = gameLayer:getChildByName("Node_ChatLayer")

	for i = 1, 3 do 
		local nodeChild = chatLayer:getChildByName("Node_Chat" ..i)
		-- 背景
		local imgBg = nodeChild:getChildByName("Image_Bg")
		-- 聊天文字
		local txtWorld = nodeChild:getChildByName("Text_Word")
		-- 聊天表情
		local imgFace = nodeChild:getChildByName("Sprit_Expression")
	end

	-- 结算界面
	local panelResult = gameLayer:getChildByName("Panel_ResultLayer")

	-- 春天界面和动画
	local spSpring = gameLayer:getChildByName("Sprite_Spring") 	
	local spSpringPlist = gameLayer:getChildByName("Particle_Spring")	

	-- 中间等待的动画
	local nodeWaitClock = gameLayer:getChildByName("Node_ReadyClock")
	-- 背景和数字
	nodeWaitClock.bg = nodeWaitClock:getChildByName("Sprite_ClockBg")
	nodeWaitClock.num = nodeWaitClock:getChildByName("AtlasLabel_Num")

	-- 准备按钮
	local btnReady = gameLayer:getChildByName("Button_Ready")

	self.btnReady = btnReady
	-- 准备
	self:addNodeClickEvent(btnReady, function( ... )
		self:sendReadyReq()
	end)

	-- 继续游戏的时候层
	local nodeConGame = gameLayer:getChildByName("Node_TableButtons1")
	-- 叫分的时候显示这个node
	local nodeDemand = gameLayer:getChildByName("Node_TableButtons2")
	-- 别人有打牌(过牌， 提示，出牌)
	local nodePlayOther = gameLayer:getChildByName("Node_TableButtons3")
	-- 叫地主的时候(欢乐斗地主的时候有)
	local nodeMainPlay = gameLayer:getChildByName("Node_TableButtons4")
	-- 是否加倍
	local nodeIsDouble = gameLayer:getChildByName("Node_TableButtons5")
	-- 自己牌权
	local nodePalyCard = gameLayer:getChildByName("Node_TableButtons6")
	-- 抢地主和不抢
	local nodeQiangMain = gameLayer:getChildByName("Node_TableButtons7")
	-- 没有牌大过上家
	local spNoBigger = gameLayer:getChildByName("Sprite_NoBigger")
	-- 必须叫(拿到双王和4个2必须叫3分)
	local spMustThree = gameLayer:getChildByName("Sprite_MustThree")
	-- 微信邀请好友
	local btInvite = gameLayer:getChildByName("Bn_Invite")
	-- 解散房间按钮(已经弃用)
	-- local btnClose = gameLayer:getChildByName("Bn_CloseGame")
	-- btnClose:removeSelf()
	-- 语音说话时候的背景
	local igmVoiceBg = gameLayer:getChildByName("Se_VoiceCutBg")
	-- 感叹号说话时间太短
	local spPrompt = igmVoiceBg:getChildByName("Tt_Prompt")
	-- 说话时候显示的动画和bg
	local imgPlayImg = igmVoiceBg:getChildByName("Se_Bg")
	-- 播放动画的时候
	local aniVoice = imgPlayImg:getChildByName("Ani_Voice")

	-- 正在播放的显示Se_CurVoice
	local spCurVioce = gameLayer:getChildByName("Se_CurVoice")
	local txtCurVoice = spCurVioce:getChildByName("Ani_CurVoice")

	-- 版本号
	local txtVersion = gameLayer:getChildByName("Text_Verson")
	self.txtVersion = txtVersion
	-- 返回大厅按钮(结算时候的吧)
	local btnReturn  = gameLayer:getChildByName("Button_BackLobby")
	self.btnReturn = btnReturn

	lt.CommonUtil:addNodeClickEvent(btnReturn, function()
		local gameScene = lt.BaseLayer.new()
		lt.SceneManager:replaceScene(gameScene)
	end)

	self:initUIview()

end

-- sendReadyReq
-- @param pos in index
function DDZGameRoomLayer:sendReadyReq( pos )

	-- dump(lt.MsgboxLayer, "lt.MsgboxLayer")

	-- print(lt.MsgboxLayer, "lt.MsgboxLayer")
	-- dump(lt)

	-- local msgBoxLayer = lt.MsgboxLayer:showMsgBox()
	-- self:addChild(msgBoxLayer, 100)

	-- local sureFunc = function()
	-- 	print("这个是确定按钮")
	-- end
	-- local cancelFunc = function()
	-- 	print("这个是取消按钮")
	-- 	self:onBackLobby()
	-- end

	-- local isOneBtn = false
	-- local isCloselayer = false
	-- local iClockTime = 10
	-- msgBoxLayer:showMsgBox("这个是显示信息", isOneBtn, sureFunc, cancelFunc, isCloselayer, iClockTime)

	-- msgBoxLayer:showMsgBox()

	print("sendReady ")
	local arg = {pos = self:getMyExtraNum()}
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.SIT_DOWN, arg)
end
	
-- 添加事件
function DDZGameRoomLayer:addNodeClickEvent(node, func, isScale )
	lt.CommonUtil:addNodeClickEvent(node, func, isScale)
end

-- 打开设置按钮
function DDZGameRoomLayer:openSetting( ... )

end
-- 申请解散房间
function DDZGameRoomLayer:openDisBandLayer( ... )



end

function DDZGameRoomLayer:onBackLobby()
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.LEAVE_ROOM)
end

function DDZGameRoomLayer:getPlayerInfo( ... )
	return lt.DataManager:getGameRoomInfo()
end


function DDZGameRoomLayer:openHelpLayer( ... )

	-- 开始游戏之后就统一是申请解散和设置界面
	local loginData = self:getPlayerInfo()
	dump(loginData)
	self.roomInfo.owner = loginData.iUserID
	dump(self.roomInfo, "self.roomInfo")

	if self.roomInfo.owner == loginData.iUserID and self.bGameStart == false then
		--房主专用界面		
		self.btnNoStart:setVisible(true)
		self.panelHelp:setVisible(false)
	else

		if self.bGameStart == true then
			self.btnBackRoom:setVisible(false)
			self.btnDisband:setVisible(true)
		else
			self.btnBackRoom:setVisible(true)
			self.btnDisband:setVisible(false)
		end
		--进入房间的人用的界面
		self.btnNoStart:setVisible(false)
		self.panelHelp:setVisible(true)
	end
end

function DDZGameRoomLayer:closeHelpLayer()
	self.btnNoStart:setVisible(false)
	self.panelHelp:setVisible(false)
end
	
-- 初始化游戏界面
function DDZGameRoomLayer:initUIview( )

	-- 设置玩家人数(取座位号用)
	self:setPlayNum(3)
	self:setGameInfo(self.roomInfo)
	self.bGameStart = false

	dump(self.roomInfo, "self.roomInfo")
	-- 是否显示准备按钮
	-- 开始游戏之后就统一是申请解散和设置界面
	-- local loginData = self:getPlayerInfo()
	local loginData = lt.DataManager:getPlayerInfo()
	dump(loginData, "loginData")

	local bIfReady = false
	local iUserPost = 0

	dump(self.roomInfo.players)

	for i, v in pairs(self.roomInfo.players) do 
		if loginData.user_id == v.user_id then -- 不是自己， 就看下是否准备了
			bIfReady = v.is_sit
			iUserPost = v.user_pos
			break
		end
	end

	-- 设置自己的座位号
	self:setMyExtraNum(iUserPost)

	for i, v in pairs(self.roomInfo.players) do
		local pos = self:s2cPlayerPos(v.user_pos)
		self.playerNodeInfo[pos]:setVisible(true)
	
		if v.is_sit then
			self.playerNodeInfo[pos].ready:setVisible(true)
		end
		self.imgNongMin[pos]:setVisible(true)
	end

	self.btnReady:setVisible(bIfReady == false)
end
	
-- 设置一下自己的座位号(根据id 得出 座位号中的人在自己的方位)
function DDZGameRoomLayer:setMyExtraNum( iPost )
	self.meExtraNum = iPost
	print("self.meExtraNum  = ", self.meExtraNum)
end

function DDZGameRoomLayer:getMyExtraNum( ... )
	print("getMyExtraNum  = ", self.meExtraNum)
	return self.meExtraNum or 1 
end

function DDZGameRoomLayer:setPlayNum( num )
	self.iMaxPlayerNum = num
end

-- 斗地主是3
function DDZGameRoomLayer:getPlayNum( ... )
	return 3   
end

-- 转换成是谁在操作，可根据服务器获取
function DDZGameRoomLayer:s2cPlayerPos(iPost)

	local meExtraNum = self:getMyExtraNum()
	local iPlayerNum = self:getPlayNum()

	local diff = iPost - meExtraNum + 2

	if diff <= 0 then
		diff = iPlayerNum
	end

	if diff > iPlayerNum then
		diff = 1
	end


	return diff
end


function DDZGameRoomLayer:setGameInfo( roomInfo1 )


	local ruleType = {
		ROOM_TIME = 1, 	-- 底分
		ROOM_TYPE = 2,	-- 1，经典， 2欢乐
		BOOM_NUM = 3,	-- 几炸封顶
	}

	local roomInfo = clone(roomInfo1)
	dump(roomInfo, "setGameInfo")
	local iMaxRound = roomInfo.room_setting.round
	local iRoundIndex = roomInfo.room_setting.cur_Round or 0

	local txt = iRoundIndex .. "/" .. iMaxRound
	self.roundIndex:setString(txt)
	self.roundIndex:setVisible(true)
	self.roomNum:setString(roomInfo.room_id)

	-- 经典斗地主
	if roomInfo.room_setting.other_setting[ruleType.ROOM_TYPE] == 1 then
		self.txtPlayRule1:setString("经典玩法")
	else -- 欢乐斗地主
		self.txtPlayRule1:setString("欢乐玩法")
	end
	local str = roomInfo.room_setting.other_setting[ruleType.BOOM_NUM] == 3  and "三" or 
				roomInfo.room_setting.other_setting[ruleType.BOOM_NUM] == 4  and "四" or 
				roomInfo.room_setting.other_setting[ruleType.BOOM_NUM] == 5  and "五" or "三"
	str = str .. "炸封顶"
	-- 几炸封顶
	self.txtPlayRule2:setString(str)
	-- 1固定是底分
	self.txtPlayRule3:setString(roomInfo.room_setting.other_setting[ruleType.ROOM_TIME])
end


function DDZGameRoomLayer:onBackLobbyResponse( msg )
	-- 离开房间，看当前人是不是房主， 房主的话就要求一个弹窗， 返回大厅， 房间依然保留
	if msg.result == "success" then
    	local worldScene = lt.WorldScene.new()
        lt.SceneManager:replaceScene(worldScene)
    end
end

function DDZGameRoomLayer:onPushSitDown( msgData )
	dump(msgData, "onPushSitDown")
	-- get下是谁坐下了
	for i = 1, 3 do 
		self.playerNodeInfo[i].ready:setVisible(false)
	end
	for i , v in pairs(msgData.sit_list) do 
		local pos = self:s2cPlayerPos(v.user_pos)
		self.playerNodeInfo[pos].ready:setVisible(true)
	end
end

function DDZGameRoomLayer:onSitDownResponse( msgData )

	dump(msgData,"onSitDownResponse")

	self.btnReady:setVisible(false)
	self.playerNodeInfo[2].ready:setVisible(true)
end

function DDZGameRoomLayer:refreshPlayerConfig( msgData )

	self.roomInfo = self:getPlayerInfo()
	local loginData = lt.DataManager:getPlayerInfo()

	for i, v in pairs(self.roomInfo.players) do 
		if loginData.user_id == v.user_id then -- 不是自己， 就看下是否准备了
			bIfReady = v.is_sit
			iUserPost = v.user_pos
			break
		end
	end

	for i = 1, 3 do 
		local pos = self:s2cPlayerPos(i)
		self.playerNodeInfo[pos]:setVisible(false)
		self.imgNongMin[pos]:setVisible(false)
	end

	for i, v in pairs(self.roomInfo.players) do
		local pos = self:s2cPlayerPos(v.user_pos)
		self.playerNodeInfo[pos]:setVisible(true)
		self.playerNodeInfo[pos].ready:setVisible(v.is_sit)
		self.imgNongMin[pos]:setVisible(true)
	end
	self.btnReady:setVisible(bIfReady == false)
end



function DDZGameRoomLayer:onEnter() 
    -- 离开房间
   	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.LEAVE_ROOM, handler(self, self.onBackLobbyResponse), "DDZGameRoomLayer:onBackLobbyResponse")
    -- 坐下按钮
   	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SIT_DOWN, handler(self, self.onSitDownResponse), "DDZGameRoomLayer:onSitDownResponse")

   	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_SIT_DOWN, handler(self, self.onPushSitDown), "DDZGameRoomLayer:onPushSitDown")

   	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO, handler(self, self.refreshPlayerConfig), "DDZGameRoomLayer:refreshPlayerConfig")

end


function DDZGameRoomLayer:onExit()
	print("DDZGameRoomLayer:onExit")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.LEAVE_ROOM, "DDZGameRoomLayer:onBackLobbyResponse")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.SIT_DOWN, "DDZGameRoomLayer:onBackDownResponse")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_SIT_DOWN, "DDZGameRoomLayer:onPushSitDown")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO, "DDZGameRoomLayer:refreshPlayerConfig")

end




return DDZGameRoomLayer