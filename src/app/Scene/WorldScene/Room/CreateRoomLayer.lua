

local CreateRoomLayer = class("CreateRoomLayer", lt.BaseLayer, function()
    return cc.CSLoader:createNode("game/common/CreateRoomLayer.csb")
end)


local SelectColor = cc.c3b(38,147, 0)
local NormalColor = cc.c3b(95,95,94)
local TitleColor = cc.c3b(173,63,33)
local FixedTwoOrThreeItemWidth = 250 --三个或两个选项的
local FixedFourItemWidth = 205 --四个选项的
local FixedItemHeight = 70
local FixedMenuItemWidth = 125
local MaxCount = 6--游戏列表最多可放游戏个数
local eWidgetTag = {
    ePay = 0,-- 起始为0 但实际是num+ePay 从1开始
    eRound = 3,-- 起始为3 但实际是num+eRount 从4开始
}
--数据类型
local GameDataType = {
    eOldRule = 1,
    eNewRule = 2,
    ePay = 3,
    eRound = 4,
    ePlayNum = 5,
    eGameId = 6,
    eOldInput = 7,
    eNewInput = 8,
}
--规则按钮类型
local RuleBtnType = {
    eOneOption = 1,--必选单选项
    eMulOption = 2,--必选多选项
    eDisOneMenus = 3,--可选菜单
    eDisOneOption = 4,--可选单选项
    eDisMulOption = 5,--可选多选项
    eDisInput = 6, --插入数值
    eSuppressOneOption = 7, --可隐藏单选项
}



local GameConf = require("app.common.GameConf")

function CreateRoomLayer:ctor()

	CreateRoomLayer.super.ctor(self)

	self.iBaseScore = {1, 2, 3, 5, 8, 10, 20, 30, 50, 100}
	self.g_tEnterData = {}
	local layer = self
    self.bnMark = layer:getChildByName("Ie_Mark")
    local bg = layer:getChildByName("Ie_Bg")
    self.gameSVList = bg:getChildByName("SV_GameList")--游戏列表
    self.gamePanelBg = bg:getChildByName("Ie_InfoBg")--游戏选项底板
    self.ruleSv = self.gamePanelBg:getChildByName("ScrollView_Info")--游戏选项滚动面板
    self.ruleSv.orgPos = cc.p(self.ruleSv:getPositionX(), self.ruleSv:getPositionY()) 
    self.ruleSv.orgSize = self.ruleSv:getContentSize()

    -- 红中规则界面
    self.m_hzmjRule = self.ruleSv:getChildByName("HZMJ_Rule")
    self.m_hzmjRule:setVisible(false)

    self.moreGameSv = self.gamePanelBg:getChildByName("ScrollView_MoreGame")--更多游戏列表
    self.moreGameSv:setSwallowTouches(false)--更多游戏列表
    self.bnClose = bg:getChildByName("Bn_Close")--关闭按钮
    self.bnCreateSure = bg:getChildByName("Bn_CreateSure")--创建房间按钮
    self.createMoneyText = self.bnCreateSure:getChildByName("Tt_GMoney")--创建房间花费




    -- 暂时不需要捕鱼界面
    self.bnInterHLBYGame = bg:getChildByName("Bn_InterHLBYGame")--进入捕鱼游戏宣传界面
    self.bnChangeHLBYGame = bg:getChildByName("Bn_ChangeHLBYMoney")--兑换捕鱼游戏币

	self.bnInterHLBYGame:setVisible(false)
	self.bnChangeHLBYGame:setVisible(false)

    self.roomSettingBg = bg:getChildByName("Ie_RoomSetting")--游戏语音聊天
    --语音聊天
    self.voiceBox = self.roomSettingBg:getChildByName("Ie_VoiceBox")
    self.voiceText = self.voiceBox:getChildByName("Text_Title")
    self.voiceSelectSpr = self.voiceBox:getChildByName("Sprite_Select")
    self.voiceTipBtn = self.voiceBox:getChildByName("Ie_Detail")
    self.voiceTipBtn:setVisible(false)
--    self.voiceTipBtn.statement = ""
--    self.voiceTipBtn.isBoxPanel = true
    self.voiceBox.orgPos = cc.p(self.voiceBox:getPositionX(), self.voiceBox:getPositionY())
    --好友房   
    self.friendBox = self.roomSettingBg:getChildByName("Ie_FriendRoomBox")
    self.friendText = self.friendBox:getChildByName("Text_Title")
    self.friendSelectSpr = self.friendBox:getChildByName("Sprite_Select")
    self.friendTipBtn = self.friendBox:getChildByName("Ie_Detail")
    self.friendTipBtn.statement = "选中后只有您的好友才能进入房间！"
    self.friendTipBtn.isBoxPanel = true
    self.friendBox.orgPos = cc.p(self.friendBox:getPositionX(), self.friendBox:getPositionY())
    --GPS防作弊  
    self.gpsBox = self.roomSettingBg:getChildByName("Ie_GPSBox")
    self.gpsText = self.gpsBox:getChildByName("Text_Title")
    self.gpsSelectSpr = self.gpsBox:getChildByName("Sprite_Select")
    self.gpsTipBtn = self.gpsBox:getChildByName("Ie_Detail")
    self.gpsTipBtn:setVisible(false)

    -------------------------------------引导界面------------------------------------
    self.nodeGuiLayer = layer:getChildByName("Node_GuiLayer")
    self.nodeGuiLayer:setVisible(false)
    self.imageGpsBg = self.nodeGuiLayer:getChildByName("Image_GpsBG")
    self.imageGpsBg:setVisible(false)
    self.bnGpsOK = self.imageGpsBg:getChildByName("Btn_Ok")

    self.gpsBox.orgPos = cc.p(self.gpsBox:getPositionX(), self.gpsBox:getPositionY())
    lt.CommonUtil:addNodeClickEvent(self.bnClose, function( ... )
    	lt.UILayerManager:removeLayer(self)
    end) 

    lt.CommonUtil:addNodeClickEvent(self.bnCreateSure, function( ... )
    	-- 创建房间
    	self:sendCreateRoom()
    end)

    local size = self.ruleSv:getContentSize()
    self.ruleSv:setInnerContainerSize(cc.size(size.width, size.height))
    self.ruleSv:setScrollBarEnabled(false)
    self.g_tEnterData.iIsFriendRoom = 0--默认不选只让好友进入
    self.g_tEnterData.iIsOpenVoice = 1--开启语音
    self.g_tEnterData.iIsOpenGPS = 0--开启GPS防作弊
    self.startPosY = size.height - 40
    self.startPosX = 155
    self.itemNamePosX = 145
    -- self.dataLocal = true --是否获取本地数据

    self.selectTable = {}
    self:createGameList()--创建房间游戏列表
end


--创建房间游戏列表
function CreateRoomLayer:createGameList(iGameId, index, iGameIds)   
    if self.gameBtnList then 
        for k =1, #self.gameBtnList do
            self.gameBtnList[k]:removeFromParent() 
        end
    end
    if self.moreGameBtnNormal then 
        self.moreGameBtnNormal:removeFromParent()      
    end
    if self.moreGameBtnSelect then 
        self.moreGameBtnSelect:removeFromParent()       
    end
    local currGameList = self:getGameList()

    local iItemHeight = 86--Item高度
    local iItemSpace = 3 --列表间隙
    -- local iItemCount = #currGameList --列表个数
    local iItemCount = #table.keys(currGameList)
    if iItemCount > 8 then --超过 8个游戏，只显示7个，其余收纳在更多游戏中
        iItemCount = 5
    end
    --local iScrollHeight = iItemHeight*8 + iItemSpace*7
    --iItemHeight*8 + iItemSpace*7
    local intSVWidth = self.gameSVList:getContentSize().width --滚动视图的宽度
    local intSVHeight = self.gameSVList:getContentSize().height --滚动视图的高度    
    --    iScrollHeight = iScrollHeight > intSVHeight and iScrollHeight or intSVHeight --滚动视图真实高度
    self.gameSVList:setInnerContainerSize(cc.size(intSVWidth, intSVHeight))
    
    self.gameSVList:setTouchEnabled(false)
    self.gameBtnList = {} --游戏列表
    self.gameBtnNormalList = {} 
    self.gameBtnSelectList = {}
    local intPosY = 0
    -- for var = 1, iItemCount do
	-- dump(currGameList)
    local var = 0

    --[[
	    item 参数：
	    1.gameID
	    2.选中态按钮文字
	    3.未选中态按钮文字
	    4.是否显示新游戏图标（0:不显示  1:显示）
	    5.是否显示免费图标（0:不显示  1:显示）
	    6.打折
	]]

    local selectBtn = nil
    for i , v in pairs(currGameList) do 
    	var = var + 1
        intPosY = intSVHeight - iItemHeight -(var-1)*(iItemSpace + iItemHeight)
        local btnTab = ccui.Button:create("game/common/img/createRoom_btn.png", "game/common/img/createRoom_btn.png", "game/common/img/createRoom_btn.png", 1)        
        -- local btnItem, selectItem = self:createGameMenuItem(currGameList[var])
        local btnItem, selectItem = self:createGameMenuItem(v)
        btnTab:setPosition(70, intPosY)
        btnTab:setAnchorPoint(cc.p(0,0))
        btnTab.gameIds = btnItem.gameIds
        btnTab.index = 0
		btnTab.gameDefaultRule = 0
		btnTab.sale = 0
		btnItem.index = 0
		btnItem.gameDefaultRule = 0
		selectItem.index = 0
		selectItem.gameDefaultRule = 0

        btnItem:setAnchorPoint(cc.p(0,0))
        selectItem:setAnchorPoint(cc.p(0,0))
        selectItem:setPosition(0, -5)
        btnItem:setPosition(0, -5)

        btnTab:addChild(btnItem)
        btnTab:addChild(selectItem)
        self.gameSVList:addChild(btnTab)
        -- self:addGameBtnClickedListener(btnTab, false, self.buttonClicked)
        -- lt.CommonUtil:addNodeClickEvent(btnTab, handler(self, self.gameBtnOnTap))
        lt.CommonUtil:addNodeClickEvent(btnTab, function( )

            if btnTab == selectBtn then
                return
            end
            selectBtn = btnTab
        	self:gameBtnOnTap(i)
        end, false)

        table.insert(self.gameBtnList, btnTab)
        table.insert(self.gameBtnNormalList, btnItem)
        table.insert(self.gameBtnSelectList, selectItem)
    end

    self.gameBtnList[1]:onClick()
end

function CreateRoomLayer:onjoinRoomResponse( tObj )
	dump(tObj, "创建房间返回")

    if tObj.result == "success" then
        self:onClose()
    else
        print("创建房间失败", tObj.result)
    end
end

function CreateRoomLayer:onEnter()   
    print("CreateRoomLayer:onEnter")
    lt.GameEventManager:addListener("create_room", handler(self, self.onjoinRoomResponse), "CreateRoomLayer:onjoinRoomResponse")
end

function CreateRoomLayer:onExit()
    print("CreateRoomLayer:onExit")
    lt.GameEventManager:removeListener("create_room", "CreateRoomLayer:onjoinRoomResponse")
end

function CreateRoomLayer:onClose(event)
	lt.UILayerManager:removeLayer(self)
end

--游戏列表被点击
function CreateRoomLayer:gameBtnOnTap(gameId, index, gameIds)

	local gameList = self:getGameList()

	-- dump(gameList, "gameList")
	-- dump(gameId, "gameId")
	-- dump(gameList[gameId], "gameList[gameId]")

	self.tGamesRuleConfig = gameList[gameId][6]
	

	-- 红中麻将
	if gameId == "HZMJ" then

        -- if self.m_hzmjRule:isVisible() == true then
        --     return
        -- end

		self.m_hzmjRule:setVisible(true)
		-- 设置一下数据
		self:initHZMJRule()
	end

	-- self:createPayPanel()--扣费方式
 --    self:createRoundPanel()--圈数
 --    self:createBasePanel() --底分   
 --    self:createRulePanel()--规则选项
 --    self.optionalPosY  =  self.startPosY 
end


function CreateRoomLayer:initHZMJRule( ... )

	-- 当前选中的数据
	self.selectTable = {}
    self.selectTable.other_setting = {0, 0, 0, 0}
	if not self.tGamesRuleConfig then
		dump(self.tGamesRuleConfig, "self.tGamesRuleConfig")
		return
	end

	-- 游戏设置项[数组]
	-- [1] 奖码的个数
	-- [2] 七对胡牌
	-- [3] 喜分
	-- [4] 一码不中当全中

    

	local payTable = {}
	local roundTable = {}
	local playNumTable = {}
	local jiangNum = {}
	local playRule = {}
	local payType = {1, 2, 3}
	local roundType = {4, 8, 16}
    local playNumType = {4, 3, 2}
	local jiangType = {2, 4, 6}
	local ruleType = {0, 0, 0}

	for i = 1, 3 do 
		local payPanel = self.m_hzmjRule:getChildByName("Panel_Pay".. i)	
		payPanel.selectNode = payPanel:getChildByName("Image_Select")
		payPanel._textNode = payPanel:getChildByName("Text_Pay")

		payTable[i] = payPanel
		lt.CommonUtil:addNodeClickEvent(payPanel, function( ... )
	    	for i, v in pairs(payTable) do 
	    		if v == payPanel then
	    			v.selectNode:setVisible(true)
	    			v._textNode:setColor(SelectColor)
	    			self.selectTable.pay = payType[i]
	    		else
	    			v.selectNode:setVisible(false)
	    			v._textNode:setColor(NormalColor)
	    		end
	    	end
	    end, false)
	

		local roundPalel = 	self.m_hzmjRule:getChildByName("Panel_Round".. i)
		roundPalel.selectNode = roundPalel:getChildByName("Image_Select")	
		roundPalel._textNode = roundPalel:getChildByName("Text_Pay")
		roundTable[i] = roundPalel

		lt.CommonUtil:addNodeClickEvent(roundPalel, function( ... )
	    	for i, v in pairs(roundTable) do 
	    		if v == roundPalel then
	    			v.selectNode:setVisible(true)
	    			v._textNode:setColor(SelectColor)
	    			self.selectTable.round = roundType[i]
	    		else
	    			v.selectNode:setVisible(false)
	    			v._textNode:setColor(NormalColor)
	    		end
	    	end
	    end, false)

		local playNumPalel = self.m_hzmjRule:getChildByName("Panel_PlayNum".. i)
		playNumPalel.selectNode = playNumPalel:getChildByName("Image_Select")	
		playNumPalel._textNode = playNumPalel:getChildByName("Text_Pay")
		playNumTable[i] = playNumPalel

		lt.CommonUtil:addNodeClickEvent(playNumPalel, function( ... )
	    	for i, v in pairs(playNumTable) do 
	    		if v == playNumPalel then
	    			v.selectNode:setVisible(true)
	    			v._textNode:setColor(SelectColor)
	    			self.selectTable.playNum = playNumType[i]
	    		else
	    			v.selectNode:setVisible(false)
	    			v._textNode:setColor(NormalColor)
	    		end
	    	end
	    end, false)


	    local jiangPalel = self.m_hzmjRule:getChildByName("Panel_Jiang".. i)
		jiangPalel.selectNode = jiangPalel:getChildByName("Image_Select")
		jiangPalel.selectNode:setVisible(false)	
		jiangPalel._textNode = jiangPalel:getChildByName("Text_Pay")
		jiangNum[i] = jiangPalel

		lt.CommonUtil:addNodeClickEvent(jiangPalel, function( ... )
	    	for i, v in pairs(jiangNum) do 
	    		if v == jiangPalel then
	    			v.selectNode:setVisible(true)
	    			v._textNode:setColor(SelectColor)
	    			self.selectTable.other_setting[1] = jiangType[i]
	    		else
	    			v.selectNode:setVisible(false)
	    			v._textNode:setColor(NormalColor)
	    		end
	    	end
	    end, false)


		local rulePalel = self.m_hzmjRule:getChildByName("Panel_Play".. i)
		rulePalel.selectNode = rulePalel:getChildByName("Image_Select")
		rulePalel.selectNode:setVisible(false)
		rulePalel._textNode = rulePalel:getChildByName("Text_Pay")	
		playRule[i] = rulePalel
		rulePalel.isSelect = false

		lt.CommonUtil:addNodeClickEvent(rulePalel, function( ... )
			if playRule[i].isSelect == false then
				playRule[i].isSelect = true
				playRule[i].selectNode:setVisible(true)	
				self.selectTable.other_setting[i+1] = 1
				playRule[i]._textNode:setColor(SelectColor)
			else
                dump(self.selectTable)
				self.selectTable.other_setting[i+1] = 0
				playRule[i].isSelect = false
				playRule[i].selectNode:setVisible(false)
				playRule[i]._textNode:setColor(NormalColor)	
			end
	    end, false)
	end
    dump(self.selectTable, "self.selectTable")



	local delBtn = self.m_hzmjRule:getChildByName("Image_Del")
	local addBtn = self.m_hzmjRule:getChildByName("Image_Add")
	local baseScore = self.m_hzmjRule:getChildByName("Image_TimeCell"):getChildByName("baseText")

	local baseIndex = 1;

	baseScore:setString(1)
	baseScore.baseNums = 1


	-- 上面配置
	local iTableBase = self.iBaseScore

	lt.CommonUtil:addNodeClickEvent(addBtn, function( ... )
		if baseIndex == #iTableBase then
			return
		end
		baseIndex = baseIndex + 1

		if baseIndex > #iTableBase then
			baseIndex = #iTableBase
		end
		baseScore.baseNums = iTableBase[baseIndex]
		baseScore:setString(baseScore.baseNums)
	end)

	lt.CommonUtil:addNodeClickEvent(delBtn, function( ... )
		if baseIndex == 1 then
			return
		end
		baseIndex = baseIndex - 1

		if baseIndex < 1 then
			baseIndex = 1
		end
		baseScore.baseNums = iTableBase[baseIndex]
		baseScore:setString(baseScore.baseNums)
	end)

	payTable[1]:onClick()
	roundTable[1]:onClick()
	playNumTable[1]:onClick()
	jiangNum[1]:onClick()

	-- 全部选择
	playRule[1]:onClick()
	playRule[2]:onClick()
	playRule[3]:onClick()
end


function CreateRoomLayer:getGameList( ... )
	return GameConf.GameIDList
end
--创建游戏按钮
function CreateRoomLayer:createGameMenuItem(item, isMore)
    --[[
        item 参数：
        1.gameID
        2.选中态按钮文字
        3.未选中态按钮文字
        4.是否显示新游戏图标（0:不显示  1:显示）
        5.是否显示免费图标（0:不显示  1:显示）
        6.房间规则配置表
        -- 7.字体缩放
        -- 8.未开启
        -- 9.列表ID
        -- 10.默认规则
        11.打折
    ]]

    -- dump(item, "item")
    --isMore 是否收纳在更多游戏中
    local btn = cc.CSLoader:createNode("game/common/CreateRoomMenuBtnItem.csb")
    btn.img_bg = btn:getChildByName("Image_Bg")     
    btn.img_free = btn.img_bg:getChildByName("Image_Free")--免费标签
    btn.img_new = btn.img_bg:getChildByName("Image_New")--新游戏标签
    btn.img_noOpen = btn.img_bg:getChildByName("Image_NoOpen")--未开启游戏标签
    btn.spr_name = btn.img_bg:getChildByName("Sprite_Name")--游戏名称
    btn.img_sale = btn.img_bg:getChildByName("Image_Sale")--打折
    btn.img_bg.gameIds = item[1]
    btn.gameIds = item[1]
    btn.isFree = false
    btn.isNew = false
    local scale = item[7] and item[7] or 1 --字体缩放
    btn.spr_name:setScale(scale)
    if  item[3] and item[3] ~= "" then --各个平台有游戏名称资源，率先使用
        local namePath = string.format("games/comm/lobbySpecial/%s.png", item[3])
        local pngName = cc.SpriteFrameCache:getInstance():getSpriteFrame(namePath)
        if pngName then
            btn.spr_name:setSpriteFrame(pngName)
        elseif cc.FileUtils:getInstance():isFileExist(namePath) then
            --放在非plist里
            btn.spr_name:setTexture(namePath)
        end
    else
        if commGamePngNormal and cc.FileUtils:getInstance():isFileExist(commGamePngNormal) then 
            btn.spr_name:setTexture(commGamePngNormal)
        end
    end   
    if item[4] and item[4] == 1 and not isMore then --显示新游戏标签
        btn.img_new:setVisible(true)
        btn.isNew = true
    else --不显示新游戏标签
        btn.img_new:setVisible(false)
        btn.isNew = false
    end
    if item[5] and item[5] == 1 then --显示免费标签
        btn.img_free:setVisible(true)
        btn.isFree = true
    else --不显示免费标签
        btn.img_free:setVisible(false)
        btn.isFree = false
    end
    --是否未开启
    -- if item[8] and item[8] == 1 then
    --     btn.img_noOpen:setVisible(true)
    -- else
    --     btn.img_noOpen:setVisible(false)
    -- end
    --打折
    -- if item[11] and item[11] ~= 1 then
    --     btn.img_sale:setVisible(true)
    --     btn.sale = item[11]
    -- else
    --     btn.img_sale:setVisible(false)
    --     btn.sale = 1
    -- end
    -- -- end
    
    local selectBtn = cc.CSLoader:createNode("game/common/CreateRoomMenuSelectItem.csb")
    selectBtn.img_bg = selectBtn:getChildByName("Image_Bg") 
    selectBtn.img_free = selectBtn.img_bg:getChildByName("Image_Free")--免费标签
    selectBtn.img_new = selectBtn.img_bg:getChildByName("Image_New")--新游戏标签
    selectBtn.spr_name = selectBtn.img_bg:getChildByName("Sprite_Name")--游戏名称
    selectBtn.img_sale = selectBtn.img_bg:getChildByName("Image_Sale")--打折
    selectBtn.spr_name:setScale(scale)
    selectBtn.img_bg.gameIds = item[1]
    selectBtn.gameIds = item[1]
    -- if dzqp.g_hlbyGameId and item[1][1] == dzqp.g_hlbyGameId then --捕鱼选项特殊处理        
    --     selectBtn.img_bg:loadTexture("game/common/hlby/hlby_menu_btn_2.png",1)
    --     selectBtn.img_free:setVisible(false)
    --     selectBtn.img_new:setVisible(false)
    --     selectBtn.img_sale:setVisible(false)
    --     local pngName = cc.SpriteFrameCache:getInstance():getSpriteFrame("game/common/hlby/hlby_menu_title_1.png")
    --     if pngName then
    --         selectBtn.spr_name:setSpriteFrame(pngName)
    --     end
    -- else
        if item[2] and item[2] ~= "" then 
            local namePath = string.format("games/comm/lobbySpecial/%s.png", item[2])
            local pngName = cc.SpriteFrameCache:getInstance():getSpriteFrame(namePath)
            if pngName then
                selectBtn.spr_name:setSpriteFrame(pngName)
            elseif cc.FileUtils:getInstance():isFileExist(namePath) then
                --放在非plist里
                selectBtn.spr_name:setTexture(namePath)
            end
        else
            -- if commGamePngSelect and cc.FileUtils:getInstance():isFileExist(commGamePngSelect) then 
            --     selectBtn.spr_name:setTexture(commGamePngSelect)
            -- end
        end
        if item[4] and item[4] == 1 and not isMore then --显示新游戏标签
            selectBtn.img_new:setVisible(true)
        else --不显示新游戏标签
            selectBtn.img_new:setVisible(false)
        end
        if item[5] and item[5] == 1 then --显示免费标签
            selectBtn.img_free:setVisible(true)
        else --不显示免费标签
            selectBtn.img_free:setVisible(false)
        end        
        --打折
        if item[11] and item[11] ~= 1 then
            selectBtn.img_sale:setVisible(true)
            selectBtn.sale = item[11]
        else
            selectBtn.img_sale:setVisible(false)
            selectBtn.sale = 1
        end
    -- end
    return btn, selectBtn
end

-- local CommGameImg = {
--     -- HZMJ = {"ddz", "ddz"}, --斗地主
--     -- [173] = {"ddz","hlddz"},--欢乐斗地主
--     -- [136] = {"gdy", "gdy"},--干瞪眼
--     -- [114] = {"jzd","jzd"},--尖子顶
--     -- [232] = {"mlnn","mlnn"},--牛牛
--     -- [123] = {"pdk","pdk"},--跑得快
--     -- [127] = {"srddz2","srddz2"},--四人斗地主
--     -- [137] = {"sss","sss"},--十三张
--     -- [108] = {"tdh","tdh"},--推到胡
--     -- [134] = {"hzmj","hzmj"},--紅中麻將
--     HZMJ = {"hzmj","hzmj"},--紅中麻將
-- }
-- --获取公共游戏资源目录
-- function CreateRoomLayer:getCommGameImgByGameID(gameId)
--     if CommGameImg[(gameId)] then 
--         return "games/"..CommGameImg[(gameId)][1].."/game/"..CommGameImg[(gameId)][2].."GameNameSelect.png",
--         "games/"..CommGameImg[(gameId)][1].."/game/"..CommGameImg[(gameId)][2].."GameNameNormal.png"
--     end
--     return false, false
-- end

function CreateRoomLayer:sendCreateRoom( ... )

	local tempTable  = {}

    tempTable.game_type = 1
	tempTable.pay_type =  self.selectTable.pay
	tempTable.round = self.selectTable.round
	tempTable.seat_num = self.selectTable.playNum

	tempTable.other_setting = {}
	for i = 0, #self.selectTable.other_setting do
		tempTable.other_setting[i] = self.selectTable.other_setting[i]
	end

    tempTable.is_friend_room = false
    tempTable.is_open_voice = false
    tempTable.is_open_gps = false

    dump(tempTable, "tempTable")

    local msg = {[lt.GameEventManager.EVENT.CREATE_ROOM] = tempTable}
	-- 发送消息
	lt.NetWork:send(msg)
end

function CreateRoomLayer:buttonClicked(pSender)

	print("点击事件")
	return
    -- -- self:removeStatementPanel()
    -- if pSender == self.bnClose then
    --    -- self:exit()
    -- -- 遮罩事件
    -- elseif pSender == self.bnMark then
    --    -- self:exit()
    -- elseif pSender == self.bnCreateSure then
    --     -- self:removeDisOneMenu() 
    --     -- self:sendCreateRoom()
    -- elseif pSender == self.baseDelBtn then 
    --     -- self:removeDisOneMenu()
    --     -- self:baseBtnOnTap(0)
    -- elseif pSender == self.baseAddBtn then 
    --     -- self:removeDisOneMenu()
    --     -- self:baseBtnOnTap(1)
    -- elseif pSender.gameIds then
    --     -- self:removeDisOneMenu() 
    --     -- if not pSender.isMoreGame then  
    --         -- self:gameBtnOnTap(pSender.gameIds[1], pSender.index, pSender.gameIds)
    --     -- else
    --         -- if pSender.isNoOpen then --游戏未开启
    --             -- self:setMsgBox("游戏即将开启，敬请期待！", nil, nil, true)
    --         -- else
    --             -- self:rightMoreGameOnTap(pSender.gameIds, pSender.index)
    --         -- end
    --     -- end   
    -- elseif pSender.valueInputAdd then 
    --     self:valueAddOptionOnTap(pSender)
    -- elseif pSender.valueInputDel then
    --     self:valueDelOptionOnTap(pSender)
    -- elseif pSender == self.voiceBox then
    --     self:voiceBtnOnTap(pSender)
    -- elseif pSender == self.friendBox then
    --     self:friendBtnOnTap(pSender)
    -- elseif pSender == self.gpsBox then
    --     self:gpsBtnOnTap(pSender) 
    -- elseif pSender == self.moreGameBtn then --更多游戏
    --         -- self.bnCreateSure:setVisible(false)
    --         -- self.bnInterHLBYGame:setVisible(false)
    --         -- self.bnChangeHLBYGame:setVisible(false)
    --         -- self:showMoreGamePanel()
    -- elseif pSender == self.bnInterHLBYGame then
    --     -- self:hlbyGameSkip()
    -- elseif pSender == self.bnChangeHLBYGame then
    --     -- self:openChangeViewLayer()
    -- elseif pSender == self.bnGpsOK then
    --     -- self.nodeGuiLayer:setVisible(false)
    -- elseif pSender.statement then--感叹号
    --     self:showIconStatement(pSender)
    -- else        
    --     self:gameRuleBtnOnTap(pSender)
    -- end
end

return CreateRoomLayer