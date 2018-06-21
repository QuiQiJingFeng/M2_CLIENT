local DDZGameRoomLayer = class("DDZGameRoomLayer", lt.BaseLayer)

local DragCardsView = require("app.Scene.GameScene.ddz.DragCardsView")

local ddzGameFunc = require("app.Scene.GameScene.ddz.ddzGameFunc")

local Card = require("app.Scene.GameScene.ddz.Card")

local ChatLayer = require("app.Scene.GameScene.ChatLayer")
    
table.merge(DDZGameRoomLayer, ddzGameFunc)

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

	-- 点击桌面关闭事件
	self:addNodeClickEvent(gameLayerBg, function()
		self:touchLayer()	
	end, false)
	
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

	self.Node_Players = Node_Players

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

		node.imgBg:setVisible(false)
		node.imgWaitSend:setVisible(false)
		node.imgHead:setVisible(false)
		node.imgDisNet:setVisible(false)
		imgPlaybg:setVisible(false)

		node.imgPlaybg = imgPlaybg
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

	self:addNodeClickEvent(btnFace, function( ... )
		local __ChatLayer = ChatLayer:new()
		lt.UILayerManager:addLayer(__ChatLayer)	
	end)


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
	local chatImgLayer = gameLayer:getChildByName("Node_ChatLayer")
	self.m_tArrNodeChat = {}
	for i = 1, 3 do 
		local nodeChild = chatImgLayer:getChildByName("Node_Chat" ..i)
		-- 背景
		local imgBg = nodeChild:getChildByName("Image_Bg")

		nodeChild.imgBg = imgBg
		-- 聊天文字
		local txtWorld = nodeChild:getChildByName("Text_Word")
		nodeChild.txtWorld = txtWorld
		-- 聊天表情
		local imgFace = nodeChild:getChildByName("Sprit_Expression")
		nodeChild.imgFace = imgFace

		self.m_tArrNodeChat[i] = nodeChild
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

	-- 继续游戏的时候层
	local nodeConGame = gameLayer:getChildByName("Node_TableButtons1")
	local btn_Continue = nodeConGame:getChildByName("Button_Start")
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

	-- 继续游戏按钮, 小局的时候显示
	self:addNodeClickEvent(btn_Continue, function( ... )
		self:sendReadyReq()
	end)
	local btnName = {"Button_One", "Button_Two", "Button_Three", "Button_No"}
	local PointNums = {1, 2, 3, 0}
	local btnPoint = {}
	-- 叫分按钮
	for i = 1, 4 do 
		local btn = nodeDemand:getChildByName(btnName[i])
		self:addNodeClickEvent(btn, function()
			self:sendDemand(PointNums[i])				
		end)
		btnPoint[i] = btn
	end

	self.btnPoint = btnPoint

	local btnName2 = {"Button_Tishi","Button_Pass","Button_Chupai"}

	for i = 1, #btnName2 do 
		local btn = nodePlayOther:getChildByName(btnName2[i])
		self:addNodeClickEvent(btn, function()
			if i == 1 then
				self:tipsCard()		-- 提示牌
			elseif i == 2 then	
				local tSelect = {}	 
				self:sendCardReq(tSelect) -- 过牌
			elseif i == 3 then
				self:sendCardReq(self.GameCardLayer.tSelect) --出牌
			end
		end)

		if i == 3 then
			self.m_btnSendCard2 = btn
		end
	end

	-- 是否叫地主
	local btnName3 = {"Button_Jiao", "Button_Jiao"}
	local btnNums = {true, false}

	for i = 1, #btnName3 do 
		local btn = nodeMainPlay:getChildByName(btnName3[i])
		self:addNodeClickEvent(btn, function()
			self:sendMainReq(btnNums[i])
		end)
	end

	-- 是否加倍
	local btnName4 = {"Button_Jiabei", "Button_Bujiabei"}
	local btnNums = {true, false}

	for i = 1, #btnName4 do 
		local btn = nodeIsDouble:getChildByName(btnName4[i])
		self:addNodeClickEvent(btn, function()
			self:sendDoubleReq(btnNums[i])
		end)
	end	

	-- 抢地主和不抢
	local btnName5 = {"Button_Qiangdizhu", "Button_Buqiang"}
	local btnNums = {true, false}

	for i = 1, #btnName5 do 
		local btn = nodeQiangMain:getChildByName(btnName5[i])
		self:addNodeClickEvent(btn, function()
			self:sendMainReq(btnNums[i])
		end)
	end
		
	-- 出牌
	local btn5 = nodePalyCard:getChildByName("Button_Chupai")
	self:addNodeClickEvent(btn5, function()
		self:sendCardReq(self.GameCardLayer.tSelect)
	end)

	self.m_btnSendCard = btn5


	-- 没有牌大过上家
	local spNoBigger = gameLayer:getChildByName("Sprite_NoBigger")
	-- 必须叫(拿到双王和4个2必须叫3分)
	local spMustThree = gameLayer:getChildByName("Sprite_MustThree")


	self.nodeConGame = nodeConGame 		-- 继续游戏
	self.nodeDemand = nodeDemand		-- 下注
	self.nodePlayOther = nodePlayOther 	-- 其他人打牌， 自己出，或者过
	self.nodeMainPlay = nodeMainPlay	-- 叫庄家
	self.nodeIsDouble = nodeIsDouble	-- 是否加倍
	self.nodePalyCard = nodePalyCard 	-- 出牌(自己牌权)
	self.nodeQiangMain = nodeQiangMain	-- 抢庄
	self.spNoBigger = spNoBigger 		-- 没有牌大过上家
	self.spMustThree = spMustThree 		-- 必须叫(针对经典斗地主)


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

	-- 准备
	self:addNodeClickEvent(btnReady, function( ... )
		self:endClock(2)
		self:sendReadyReq()
	end)

	self:initUIview()
end

function DDZGameRoomLayer:onTime( iPlayExtraNum, callFunc, isReapt)
	local clock = self.playerNodeInfo[iPlayExtraNum].clock
	clock:setVisible(true)
	local clockNum = clock:getChildByName("AtlasLabel_Num") 

	isReapt = isReapt == nil and true or isReapt

	local timeNum = 9
	clockNum:setString(timeNum)

	local defunc = cc.DelayTime:create(1)
	local callback = cc.CallFunc:create(function ( ... )
		timeNum = timeNum - 1

		if timeNum < 3 then
			-- 播放声音
		end 

		if timeNum < 0 then
			if callFunc then
				callFunc(clock)
			end
			if isReapt then
				timeNum = 9
			else
				clock:stopAllActions()
				clock:setVisible(false)
			end
		end

		clockNum:setString(timeNum)
	end)

	local func = cc.RepeatForever:create(cc.Sequence:create(defunc, callback)) 
	clock:runAction(func)
end

function DDZGameRoomLayer:endClock(iPlayExtraNum)
	local clock = self.playerNodeInfo[iPlayExtraNum].clock
	clock:setVisible(false)
	clock:stopAllActions()
end

function DDZGameRoomLayer:endAllClock()
	for i = 1, 3 do 
		self:endClock(i)
	end
end


function DDZGameRoomLayer:judgeSelectCard(iNowType, arg_value)
	self.iNowType = iNowType
	self.iNowValue = arg_value
	-- 如果是自己出牌， 根据值和value 显示下按钮的高亮和灰暗

	-- self.iTablePlayer = pos
	-- self.cTableCardType = tObj.cCardType
	-- self.cTableCardValue = tObj.cCardValue

	print("iNowType, arg_value, self.cTableCardType, cTableCardValue", iNowType, arg_value, self.cTableCardType, self.cTableCardValue)


	if iNowType == -1 then
		self.m_btnSendCard2:setBright(false)
		self.m_btnSendCard:setBright(false)	

		self.m_btnSendCard2:setEnabled(false)
		self.m_btnSendCard:setEnabled(false)	
	else
		-- 别人牌权
		if self.iTablePlayer ~= 2 and self.iTablePlayer ~= 0 then
			-- 炸弹
			if (self.iNowType == 161 or self.iNowType == 162) then 
				-- 桌子上面现在是炸弹, 必须大过炸弹才能ok
				if self.cTableCardType == 161 and self.iNowValue < self.cTableCardValue then
					self.m_btnSendCard2:setBright(false)
					self.m_btnSendCard:setBright(false)	

					self.m_btnSendCard2:setEnabled(false)
					self.m_btnSendCard:setEnabled(false)
				else -- 桌子上面现在不是炸弹, 必须可以出
					self.m_btnSendCard2:setBright(true)
					self.m_btnSendCard:setBright(true)

					self.m_btnSendCard2:setEnabled(true)
					self.m_btnSendCard:setEnabled(true)	
				end
			elseif  self.iNowType == self.cTableCardType and self.cTableCardValue < self.iNowValue  then
				self.m_btnSendCard2:setBright(true)
				self.m_btnSendCard:setBright(true)

				self.m_btnSendCard2:setEnabled(true)
				self.m_btnSendCard:setEnabled(true)	

			else

				self.m_btnSendCard2:setBright(false)
				self.m_btnSendCard:setBright(false)	

				self.m_btnSendCard2:setEnabled(false)
				self.m_btnSendCard:setEnabled(false)	
			end
		else
			self.m_btnSendCard2:setBright(true)
			self.m_btnSendCard:setBright(true)

			self.m_btnSendCard2:setEnabled(true)
			self.m_btnSendCard:setEnabled(true)		
		end
	end
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

	-- 当前桌面上出牌的人
	self.iTablePlayer = 0
	-- 叫分数
	self.iDemandpoint = {-1, -1, -1}
	-- 上一圈出的牌的
	self.t_SendCards = {{}, {}, {}}
	self.t_nodeSendCards = {{}, {}, {}}

	self.iHandCardNums = {0, 0, 0}


	self.cTableCardType = 0
	self.cTableCardValue = 0

	dump(self.roomInfo, "self.roomInfo")
	-- 是否显示准备按钮
	-- 开始游戏之后就统一是申请解散和设置界面
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
		local node = self.playerNodeInfo[pos]
		node:setVisible(true)
		node.imgBg:setVisible(true)
		node.imgWaitSend:setVisible(false)
		node.imgHead:setVisible(true)
		node.imgDisNet:setVisible(false)
		node.imgPlaybg:setVisible(true)
	
		if v.is_sit then
			self.playerNodeInfo[pos].ready:setVisible(true)
		end
		self.imgNongMin[pos]:setVisible(true)
	end

	self.btnReady:setVisible(bIfReady == false)
	self.GameCardLayer = DragCardsView:new()

	self.GameCardLayer:initCtrl(self)
	self:addChild(self.GameCardLayer)

	self:test()

	if bIfReady == false then
		local onTime = 10
		self:onTime(2, function( node )
			node:stopAllActions()
			self:onBackLobby()
		end, false)	
	end
end

function DDZGameRoomLayer:test( ... )


	-- self:endClock(2)

	-- local handCards = {105, 105, 105, 105, 107, 108, 107, 107, 107, 108, 108, 108, 109, 109, 109}

	-- self.GameCardLayer:refreshCardList(handCards)
	-- self.GameCardLayer:refreshCardNode(true)

	-- local msg = 
	-- {
	-- 	cCardNum = 1,
	-- 	cCardType = 162,		
	-- 	cCardValue = 125,
	-- 	cCards =  
	-- 	{ 
	-- 		124, 
	-- 		125,			
	-- 		-- 103, 103, 104, 104, 103, 104, 105,106
	-- 		-- 103,
	-- 		-- 104,
	-- 		-- 306,
	-- 		-- 305,
	-- 		-- 107,
	-- 		-- 108,
	-- 		-- 109,
	-- 		-- 110,
	-- 		-- 111,
	-- 		-- 112,
	-- 		-- 113,
	-- 	},
	-- 	cLestCardNum = 19,
	-- 	userExtra = 2,
	-- }
	-- self:setMyExtraNum(3)
	-- -- [LUA-print] - "NoticeSendCardmasg = " = {
	-- -- [LUA-print] -     "cCardNum"     = 1
	-- -- [LUA-print] -     "cCardType"    = 101
	-- -- [LUA-print] -     "cCardValue"   = 4
	-- -- [LUA-print] -     "cCards" = {
	-- -- [LUA-print] -         1 = 204
	-- -- [LUA-print] -     }
	-- -- [LUA-print] -     "cLestCardNum" = 19
	-- -- [LUA-print] -     "userExtra"    = 2
	-- -- [LUA-print] - }

	-- self:noticeSendCard(msg)


	-- local msg1 = 
	-- {
	-- 	user_pos = 3,

	-- 	userCardNum = {
	-- 		0, 0, 0
	-- 	},

	-- }

	-- self:pushPlayCard(msg1)


	
	


	-- self.t_SendCards = {
	-- 	{104, 104, 104, 104, 104, 104,104, 104, 104,104, 104, 104,},
	-- 	{104, 104, 104, 104, 104, 104,104, 104, 104,104, 104, 104,},
	-- 	{104, 104, 104, 104, 104, 104,104, 104, 104,104, 104, 104,},
	-- }

	-- self:refreshSendCard(1)
	-- self:refreshSendCard(2)
	-- self:refreshSendCard(3)
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

function DDZGameRoomLayer:noticePointDemand( tObj )
	dump(tObj, "noticePointDemand")

	local iPos = self:s2cPlayerPos(tObj.userExtra)
	self.iDemandpoint[iPos] = tObj.userDemand
	self:endClock(iPos)

	-- 显示分数

	-- 记录下分数

end



function DDZGameRoomLayer:noticeMainPlayer( tObj )
	dump(tObj, "noticeMainPlayer")

	local pos = self:s2cPlayerPos(tObj.userExtra)
	dump(pos, "地主的pos")

	self.iHandCardNums[pos] = 20
	dump(self.iHandCardNums, 'self.iHandCardNums')

	for i = 1, 3 do 
		self.playerNodeInfo[i].cardNum:setString(self.iHandCardNums[i])
	end

	self.imgDiZhu[pos]:setVisible(true)
	self.imgNongMin[pos]:setVisible(false)

	if pos == 2 then
		self.GameCardLayer:addCard(tObj.baseCard)
	end


	-- 刷新顶上面的牌
	self.baseCard = tObj.baseCard
	for i = 1, 3 do 
		local cardNum = self.baseCard[i]
		local card = Card:createCard(cardNum)
		self.imgBaseCard[i]:addChild(card)
		local size = self.imgBaseCard[i]:getContentSize()
		card:setPosition(size.width/2, size.height/2)
		card:setScale(0.27, 0.3)
	end


end

function DDZGameRoomLayer:touchLayer( ... )
	-- 判断设置界面是否打开?
	self.GameCardLayer:touchLayer()
end

function DDZGameRoomLayer:serverMainPlayer( tObj )
	dump(tObj, "serverMainPlayer")
	local pos = self:s2cPlayerPos(tObj.userExtra)
	-- 显示农民界面
	self.imgDiZhu[pos]:setVisible(true)
	self.imgNongMin[pos]:setVisible(false)

end
function DDZGameRoomLayer:noticeSendCard( tObj )
	dump(tObj, "noticeSendCard")
	local pos = self:s2cPlayerPos(tObj.userExtra)

	self:endClock(pos)

	self.nodePalyCard:setVisible(false)
	self.nodePlayOther:setVisible(false)

	self.t_SendCards[pos] = tObj.cCards
	self:refreshSendCard(pos)
	self.playerNodeInfo[pos].imgPass:setVisible(false)	
	self.playerNodeInfo[pos].cardNum:setString(tObj.cLestCardNum)


	if pos == 2 then
		self.GameCardLayer:removeCard(tObj.cCards)
	end

	-- 过。
	if tObj.cCardNum == 0 then
		self.playerNodeInfo[pos].imgPass:setVisible(true)	
	else
		self.iTablePlayer = pos
		self.cTableCardType = tObj.cCardType
		self.cTableCardValue = tObj.cCardValue
	end


end
function DDZGameRoomLayer:serverPointDemand( tObj )
	dump(tObj, "serverPointDemand")

	local pos = self:s2cPlayerPos(tObj.userExtra)

	if pos == 2 then
		self.nodeDemand:setVisible(true)
	end
	self:onTime(pos)

	local roomInfo = self.roomInfo

	local ruleType = {
		ROOM_TIME = 1, 	-- 底分
		ROOM_TYPE = 2,	-- 1，经典， 2欢乐
		BOOM_NUM = 3,	-- 几炸封顶
	}

	-- 经典斗地主
	if roomInfo.room_setting.other_setting[ruleType.ROOM_TYPE] == 1 then

		if tObj.userNowDemand == 1 then		-- 只能叫2分和3分
			self.btnPoint[1]:setEnabled(false)
			self.btnPoint[1]:setBright(false)

			self.btnPoint[2]:setEnabled(true)
			self.btnPoint[2]:setBright(true)

			self.btnPoint[3]:setEnabled(true)
			self.btnPoint[3]:setBright(true)
		elseif tObj.userNowDemand == 2 then  -- 只能叫三分或者不叫
			self.btnPoint[1]:setEnabled(false)
			self.btnPoint[2]:setEnabled(false)
			-- 设置灰色
			self.btnPoint[1]:setBright(false)
			self.btnPoint[2]:setBright(false)

			self.btnPoint[3]:setEnabled(true)
			self.btnPoint[3]:setBright(true)
		end
	else --欢乐斗地主  （分下看谁是第个叫分的人, 看是不是自己，暂时不考虑）
		-- 抢地主
		-- self.nodeQiangMain:setVisible(true)
		-- 叫地主和不叫
		-- self.nodeMainPlay:setVisible(true)
	end

end
function DDZGameRoomLayer:noticeDDZGameOver( tObj )
	dump(tObj, "noticeDDZGameOver")




	
end

function DDZGameRoomLayer:onDealDown( tObj )
	dump(tObj, "onDealDown")
	self.bGameStart = true

	local cardList = {}
	local cardNum = 1

	for i, v in pairs(tObj.cards) do 
		if v ~= 0 then
			cardList[cardNum] = v
			cardNum = cardNum + 1
		end
	end
	self.GameCardLayer:refreshCardList(cardList)
	self.GameCardLayer:refreshCardNode(true)

	-- 别人的牌， 和底牌显示
	self.imgBaseCard[1]:setVisible(true)
	self.imgBaseCard[2]:setVisible(true)
	self.imgBaseCard[3]:setVisible(true)

	self.playerNodeInfo[1]:setVisible(true)
	self.playerNodeInfo[3]:setVisible(true)

	-- 别人的牌
	self.playerNodeInfo[1].cardBg:setVisible(true)
	self.playerNodeInfo[3].cardBg:setVisible(true)

	self.playerNodeInfo[1].cardInfo:setVisible(true)
	self.playerNodeInfo[3].cardInfo:setVisible(true)

	-- 牌数
	self.playerNodeInfo[1].cardNum:setVisible(true)
	self.playerNodeInfo[1].cardNum:setString(1)
	self.playerNodeInfo[3].cardNum:setVisible(true)
	self.playerNodeInfo[3].cardNum:setString(1)

	local cardNum = 1
	local seqFunc = cc.Sequence:create(cc.DelayTime:create(0.05), cc.CallFunc:create(function ( ... )
		cardNum = cardNum + 1
		if cardNum > 17 then
			self.playerNodeInfo[1]:stopAllActions()
			return
		end

		self.playerNodeInfo[1].cardNum:setString(cardNum)
		self.playerNodeInfo[3].cardNum:setString(cardNum)
	end))

	self.playerNodeInfo[1].cardNum:runAction(cc.RepeatForever:create(seqFunc))
	
	-- 把手隐藏掉
	for i = 1, 3 do 
		self.playerNodeInfo[i].ready:setVisible(false)
	end
	self.iHandCardNums = {17, 17, 17}
end


function DDZGameRoomLayer:noticeFastSPake( tObj )
	-- 这个是自己发言的
	local idx = self:s2cPlayerPos(tObj.user_pos)
	self.m_tArrNodeChat[idx]:setVisible(true)

	dump(tObj, "noticeFastSPake")
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
                self.m_tArrNodeChat[idx].imgFace:setSpriteFrame(frame)
                self.m_tArrNodeChat[idx].imgFace:setVisible(true)
            -- 快捷
            elseif intIndex > 101 and intIndex < 102 + #tDDZFastInfo then

                self.m_tArrNodeChat[idx].imgFace:setVisible(false) 

                intIndex = intIndex-101   

				self.m_tArrNodeChat[idx].txtWorld:setVisible(true) 
				self.m_tArrNodeChat[idx].txtWorld:setString(tDDZFastInfo[intIndex])

				self.m_tArrNodeChat[idx].imgBg:setContentSize(self.m_tArrNodeChat[idx].txtWorld:getContentSize().width+20, self.m_tArrNodeChat[idx].imgBg:getContentSize().height)
				self.m_tArrNodeChat[idx].imgBg:setVisible(true)
                --播放说话音效
                local iChatStrIdx = -1
                for var = 1, #tDDZFastInfo do
                    if var == intIndex then
                        iChatStrIdx = var - 1
                        break
                    end
                end
            end
            local function funHideChat()
                self.m_tArrNodeChat[idx].imgBg:setVisible(false)
                self.m_tArrNodeChat[idx].txtWorld:setVisible(false)
                self.m_tArrNodeChat[idx].imgFace:setVisible(false)
            end

            self:stopAction(self["m_chatPaoPaoListener_"..idx])
            self["m_chatPaoPaoListener_"..idx] = performWithDelay(self, funHideChat, 3)
            return
        end
    end
end

-- 通知出牌
function DDZGameRoomLayer:pushPlayCard( tObj )
	dump(tObj, "DDZGameRoomLayer:pushPlayCard")

	self.m_iSelectHint = 0

	self.GameCardLayer:unSelectAllCard()

	local iPos = self:s2cPlayerPos(tObj.user_pos)
	local pos1 = self:s2cPlayerPos(1)
	local pos2 = self:s2cPlayerPos(2)
	local pos3 = self:s2cPlayerPos(3)

	self.playerNodeInfo[pos1].cardNum:setString(tObj.userCardNum[1])
	self.playerNodeInfo[pos2].cardNum:setString(tObj.userCardNum[2])
	self.playerNodeInfo[pos3].cardNum:setString(tObj.userCardNum[3])


	local vis = self.playerNodeInfo[3]:isVisible()
	local vis1 = self.playerNodeInfo[3].cardNum:isVisible()
	local vis2 = self.playerNodeInfo[3].cardBg:isVisible()

	print("vis, vis1, vis2", vis, vis1, vis2)
	self.bCanSendCard = false

	if self.iTablePlayer == iPos then
		self.t_SendCards = {{},{},{},}
		self:refreshSendCard(1)
		self:refreshSendCard(2)
		self:refreshSendCard(3)
	else
		self.t_SendCards[iPos] = {}
		self:refreshSendCard(iPos)
	end

	local bMustPass = false

	if iPos == 2 then
		self.bCanSendCard = true
		self.m_btnSendCard2:setBright(false)
		self.m_btnSendCard:setBright(false)	

		self.m_btnSendCard2:setEnabled(false)
		self.m_btnSendCard:setEnabled(false)	
		if self.iTablePlayer == 2 or self.iTablePlayer == 0 then
			self.nodePalyCard:setVisible(true)
		else
			-- 不是自己牌权, 查看是否有能打过的牌，没有的话不让出牌
			local bigger = self:tipsBiggerCard()

			if bigger == false then
				bMustPass = true
				self.spNoBigger:setVisible(true)
				-- self.spNoBigger:setZorder(199)
				self.spNoBigger:retain()
				self.spNoBigger:removeFromParent()
				self.GameCardLayer:addChild(self.spNoBigger)

				print("self.spNoBigger:getPosition()", self.spNoBigger:getPosition())

				local func1 = cc.FadeOut:create(3)
				-- local func2 = cc.FadeIn:create(1)

				-- self.spNoBigger:runAction(cc.RepeatForever:create(cc.Sequence:create(func1, func2)))
				self.spNoBigger:runAction(func1)
			end
			self.nodePlayOther:setVisible(true)
		end
	end

	if bMustPass then

	else
		self:onTime(iPos)
	end
end

function DDZGameRoomLayer:onEnter() 
    -- 离开房间
   	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.LEAVE_ROOM, handler(self, self.onBackLobbyResponse), "DDZGameRoomLayer.onBackLobbyResponse")
    -- 坐下按钮
   	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SIT_DOWN, handler(self, self.onSitDownResponse), "DDZGameRoomLayer.onSitDownResponse")
   	-- 坐下推送
   	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_SIT_DOWN, handler(self, self.onPushSitDown), "DDZGameRoomLayer.onPushSitDown")
   	-- 刷新玩家信息
   	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO, handler(self, self.refreshPlayerConfig), "DDZGameRoomLayer.refreshPlayerConfig")

  	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.DEAL_DOWN, handler(self, self.onDealDown), "DDZGameRoomLayer.onDealDown")
	-- 发牌通知
   	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SERVER_SEND_CARD, handler(self, self.serverSendCard), "DDZGameRoomLayer.ServerSendCard")
   	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_POINT_DEMAND, handler(self, self.noticePointDemand), "DDZGameRoomLayer.NoticePointDemand")
   	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_MAIN_PLAYER, handler(self, self.noticeMainPlayer), "DDZGameRoomLayer.NoticeMainPlayer")
   	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SERVER_MAIN_PLAYER, handler(self, self.serverMainPlayer), "DDZGameRoomLayer.ServerMainPlayer")
   	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_SEND_CARD, handler(self, self.noticeSendCard), "DDZGameRoomLayer.NoticeSendCard")
   	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SERVER_POINT_DEMAND, handler(self, self.serverPointDemand), "DDZGameRoomLayer.ServerPointDemand")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_DDZ_GAMEOVER, handler(self, self.noticeDDZGameOver), "DDZGameRoomLayer.NoticeDDZGameOver")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_PLAY_CARD, handler(self, self.pushPlayCard), "DDZGameRoomLayer.pushPlayCard")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_FAST_SPAKE, handler(self, self.noticeFastSPake), "DDZGameRoomLayer.noticeFastSPake")


	

end


function DDZGameRoomLayer:onExit()
	print("DDZGameRoomLayer.onExit")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.LEAVE_ROOM, "DDZGameRoomLayer.onBackLobbyResponse")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.SIT_DOWN, "DDZGameRoomLayer.onBackDownResponse")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_SIT_DOWN, "DDZGameRoomLayer.onPushSitDown")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.REFRESH_POSITION_INFO, "DDZGameRoomLayer.refreshPlayerConfig")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.SERVER_SEND_CARD, "DDZGameRoomLayer.ServerSendCard")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_POINT_DEMAND, "DDZGameRoomLayer.NoticePointDemand")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_MAIN_PLAYER, "DDZGameRoomLayer.NoticeMainPlayer")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.SERVER_MAIN_PLAYER, "DDZGameRoomLayer.ServerMainPlayer")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_SEND_CARD, "DDZGameRoomLayer.NoticeSendCard")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.SERVER_POINT_DEMAND, "DDZGameRoomLayer.ServerPointDemand")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_DDZ_GAMEOVER, "DDZGameRoomLayer.NoticeDDZGameOver")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.DEAL_DOWN, "DDZGameRoomLayer.onDealDown")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_PLAY_CARD, "DDZGameRoomLayer.pushPlayCard")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_FAST_SPAKE, "DDZGameRoomLayer.noticeFastSPake")

end




return DDZGameRoomLayer