
--吃椪杠 事件按钮层
local GameActionBtnsPanel = class("GameActionBtnsPanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjActionBtnsPanel.csb")
end)

GameActionBtnsPanel.POSITION_TYPE = {
    XI = 1, 
    NAN = 2,
    DONG = 3,
    BEI = 4,
}


function GameActionBtnsPanel:ctor(deleget)
	GameActionBtnsPanel.super.ctor(self)
    self._deleget = deleget
	self.m_objCommonUi = {}

    self.m_objCommonUi.m_nodeActionBtns = self:getChildByName("Node_ActionBtns") --吃碰杠胡按钮
    self.m_objCommonUi.m_btnChi =  self.m_objCommonUi.m_nodeActionBtns:getChildByName("Button_Chi") 
    self.m_objCommonUi.m_btnPeng = self.m_objCommonUi.m_nodeActionBtns:getChildByName("Button_Peng")
    self.m_objCommonUi.m_btnGang = self.m_objCommonUi.m_nodeActionBtns:getChildByName("Button_Gang")
    self.m_objCommonUi.m_btnHu = self.m_objCommonUi.m_nodeActionBtns:getChildByName("Button_Hu")
    self.m_objCommonUi.m_btnPass = self.m_objCommonUi.m_nodeActionBtns:getChildByName("Button_Pass")
    self.m_objCommonUi.m_btnTing = self.m_objCommonUi.m_nodeActionBtns:getChildByName("Button_Ting")
    
    self.m_objCommonUi.m_nodeCardsMenu = self:getChildByName("Node_CardsMenu") --吃碰杠胡二级菜单
    self.m_objCommonUi.m_btnMenuPass = self.m_objCommonUi.m_nodeCardsMenu:getChildByName("Button_Pass")
    self.m_objCommonUi.m_imgCardsMenuBg = self.m_objCommonUi.m_nodeCardsMenu:getChildByName("Image_Bg")
    self.m_objCommonUi.m_panelMenuItems = self.m_objCommonUi.m_nodeCardsMenu:getChildByName("Panel_MenuItems")
    self.m_objCommonUi.m_panelMenuItems:removeAllChildren()


    self.m_objCommonUi.m_tArrActionBtn = {}
    if self.m_objCommonUi.m_btnChi then
        table.insert(self.m_objCommonUi.m_tArrActionBtn, self.m_objCommonUi.m_btnChi)
    end
    if self.m_objCommonUi.m_btnPeng then
        table.insert(self.m_objCommonUi.m_tArrActionBtn, self.m_objCommonUi.m_btnPeng)
    end
    if self.m_objCommonUi.m_btnGang then
        table.insert(self.m_objCommonUi.m_tArrActionBtn, self.m_objCommonUi.m_btnGang)
    end
    if self.m_objCommonUi.m_btnHu then
        table.insert(self.m_objCommonUi.m_tArrActionBtn, self.m_objCommonUi.m_btnHu)
    end
    if self.m_objCommonUi.m_btnTing then
        table.insert(self.m_objCommonUi.m_tArrActionBtn, self.m_objCommonUi.m_btnTing)
    end
    if self.m_objCommonUi.m_btnPass then
        table.insert(self.m_objCommonUi.m_tArrActionBtn, self.m_objCommonUi.m_btnPass)
    end

    if self.m_objCommonUi.m_btnMenuPass then
        table.insert(self.m_objCommonUi.m_tArrActionBtn, self.m_objCommonUi.m_btnMenuPass)
    end

    local tArrNodeActionBtnsChildren = self.m_objCommonUi.m_nodeActionBtns:getChildren()
    for i = 1, #tArrNodeActionBtnsChildren do
        tArrNodeActionBtnsChildren[i].orgPos = cc.p(tArrNodeActionBtnsChildren[i]:getPosition())
    end

    for k,node in pairs(self.m_objCommonUi.m_tArrActionBtn) do
        lt.CommonUtil:addNodeClickEvent(node, handler(self, self.onClickCpghEvent))
    end


    self.m_objCommonUi.m_panelCurOutCard = self:getChildByName("Panel_CurOutCard")


    self._specialEventNode = {}
    if self.m_objCommonUi.m_panelCurOutCard then

        for i=1,4 do
            self.m_objCommonUi.m_panelCurOutCard:getChildByName("Node_CurrentOutCard_"..i):setVisible(false)

            local node = self.m_objCommonUi.m_panelCurOutCard:getChildByName("Node_Ani_"..i)
        
            if node then
                node:setVisible(false)
                table.insert(self._specialEventNode, node)
            end
        end
    end

    local shaizi1 = self:getChildByName("Sprite_DicePoint_1")
    local shaizi2 = self:getChildByName("Sprite_DicePoint_2")

    --胡牌提示  self.m_objCommonUi.m_nodeHuCardTips:getChildByName("Button_ToMax")
    self.m_objCommonUi.m_nodeHuCardTips = self:getChildByName("Node_HuCardTips")
    if self.m_objCommonUi.m_nodeHuCardTips then
        self.m_objCommonUi.m_imgHuCardTipsBg = self.m_objCommonUi.m_nodeHuCardTips:getChildByName("Image_Bg")
        self.m_objCommonUi.m_panelHuCardTipsContent = self.m_objCommonUi.m_nodeHuCardTips:getChildByName("Panel_Content")
        self.m_objCommonUi.m_mjTips = self.m_objCommonUi.m_panelHuCardTipsContent:getChildByName("MJ_Tips")
        if self.m_objCommonUi.m_mjTips then
            self.m_objCommonUi.m_iHuTipsScale = self.m_objCommonUi.m_mjTips:getScale() --缩放
            self.m_objCommonUi.m_mjTips = nil
        end
        self.m_objCommonUi.m_btnToMin = self.m_objCommonUi.m_nodeHuCardTips:getChildByName("Button_ToMin")
        self.m_objCommonUi.m_btnToMax = self.m_objCommonUi.m_nodeHuCardTips:getChildByName("Button_ToMax")
    end

    shaizi1:setVisible(false)
    shaizi2:setVisible(false)

    self.m_objCommonUi.m_nodeCardsMenu:setVisible(false)
    self.m_objCommonUi.m_nodeActionBtns:setVisible(false)
    self.m_objCommonUi.m_nodeHuCardTips:setVisible(false)

end

function GameActionBtnsPanel:onClickCpghEvent(pSender)
    if pSender == self.m_objCommonUi.m_btnChi then
        -- if #pSender.tObjData > 1 then
        --     self:viewChiMenu(pSender.tObjData)
        -- else
        --     self:onChiAction(pSender.tObjData, 1)
        --     self:viewHideActPanelAndMenu()
        -- end
    elseif pSender == self.m_objCommonUi.m_btnPeng then

    	if #pSender.tObjData > 1 then
    		self:viewPengMenu(pSender.tObjData)
    	else
	    	self:onPengAction(pSender.tObjData, 1)
	        self:viewHideActPanelAndMenu()
    	end

    elseif pSender == self.m_objCommonUi.m_btnGang then

        if #pSender.tObjData > 1 then
            self:viewGangMenu(pSender.tObjData)
        elseif pSender.tObjData[1] then
            self:onGangAction(pSender.tObjData[1], 1)
            self:viewHideActPanelAndMenu()
        end

    elseif pSender == self.m_objCommonUi.m_btnTing then
        -- if self.onTingAction then
        --     self:onTingAction()
        -- else
        --     self.m_objCommonUi.m_btnTing:setEnabled(false)
        --     self.m_objCommonUi.m_btnTing:setVisible(false)
        --     self:viewDisableAllActionButtonsByTing()
        --     self:viewHandCardsByTing(self.m_objCommonUi.m_btnTing.tObjData.tObjCards)
        -- end
    elseif pSender == self.m_objCommonUi.m_btnHu then

        if #pSender.tObjData > 1 then
            self:viewHuMenu(pSender.tObjData)
        else
            self:onHuAction(pSender.tObjData, 1)
            self:viewHideActPanelAndMenu()
        end

    elseif pSender == self.m_objCommonUi.m_btnPass then
        if pSender.isPassSendMsg then
            self:onPassAction()
        else
            self:onPassClick()
            --self:refreshHandCards()
            --self.m_objModel.tObjCpghByMoPai = nil
            --重置倒计时
            --self:viewSendCardDelayTime({cTableNumExtra=self.m_objModel:getMeTableNumExtra()})
        end
        --self.m_objModel.m_chiPengGangTing = 0
        self:viewHideActPanelAndMenu()

    elseif pSender == self.m_objCommonUi.m_btnMenuPass then -- 二级菜单的【过】按钮
        if pSender.isPassSendMsg then
            self:onPassAction()
        else
            self:onPassClick()
        end
        self:viewHideActPanelAndMenu()
    -- elseif pSender == self.m_objCommonUi.m_btnToMin then
    --     if #self.m_objModel.m_tArrTingCards > 0 then
    --         self:showHuCardsTipsMj()
    --     else
    --         self:hideHuCardsTipsMj()
    --     end
    -- elseif pSender == self.m_objCommonUi.m_btnToMax then
    --     if #self.m_objModel.m_tArrTingCards > 0 then
    --         self:showHuCardsTipsMj(self.m_objModel.m_tArrTingCards, self.m_objModel.m_tArrTingCardsFan)
    --     else
    --         self:hideHuCardsTipsMj()
    --     end
    end
end

function GameActionBtnsPanel:onClickSelectCard(event) --多 选择
	print("__________________________多选择")
	
	dump(event.selectCardData)
	if event.selectCardData then
		if event.selectCardData.card and event.selectCardData.type then
			if event.selectCardData.type == 1 then--吃碰杠胡

			elseif event.selectCardData.type == 2 then
				local arg = {command = "PENG"}
				lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
			elseif event.selectCardData.type == 3 then
				-- local arg = {command = "GANG", card = event.selectCardData.card }
				-- lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)

				self:onGangAction(event.selectCardData.card, 1)

			elseif event.selectCardData.type == 4 then
				local arg = {command = "HU"}
				lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
			end
		end
	else
		print("选择数据出错！！！！！")
	end
	self:viewHideActPanelAndMenu()
end

--发送碰按钮的请求
function GameActionBtnsPanel:onPengAction(tObj, index)
    local arg = {command = "PENG"}
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
end

--发送杠按钮的请求
function GameActionBtnsPanel:onGangAction(tObj, index)
    print("杠的牌@@@@@@@@@@@@@", tObj)
    local arg = {command = "GANG", card = tObj}
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
end

--发送胡按钮的请求
function GameActionBtnsPanel:onHuAction(tObj, index)
    local arg = {command = "HU"}
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
end

--发送过按钮的请求
function GameActionBtnsPanel:onPassAction()
    local arg = {command = "GUO"}
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
end

function GameActionBtnsPanel:onPassClick()

end


function GameActionBtnsPanel:setBtnEnabled(btn, bIsEnable)
    if btn == nil then
        return
    end
    local cDisable = cc.c3b(127, 127, 127)
    local cNormal = cc.c3b(255, 255, 255)

    btn:setVisible(bIsEnable)
    btn:setTouchEnabled(bIsEnable)
    btn:setColor(bIsEnable and cNormal or cDisable)
end

--显示吃碰杠胡按钮  
function GameActionBtnsPanel:viewActionButtons(tObjCpghObj, isPassSendMsg)
    --显示吃碰杠胡按钮

    if self.m_objCommonUi.m_btnChi then
        local isChi = tObjCpghObj.tObjChi ~= nil

        self:setBtnEnabled(self.m_objCommonUi.m_btnChi, isChi)
    end

    if self.m_objCommonUi.m_btnPeng then
        local isPeng = tObjCpghObj.tObjPeng ~= nil
        self:setBtnEnabled(self.m_objCommonUi.m_btnPeng, isPeng)
    end

    if self.m_objCommonUi.m_btnGang then
        local isGang = tObjCpghObj.tObjGang ~= nil
        self:setBtnEnabled(self.m_objCommonUi.m_btnGang, isGang)
    end

    if self.m_objCommonUi.m_btnTing then
        local isTing = tObjCpghObj.tObjTind ~= nil
        self:setBtnEnabled(self.m_objCommonUi.m_btnTing, isTing)
    end

    if self.m_objCommonUi.m_btnHu then
        local isHu = tObjCpghObj.tObjHu ~= nil
        self:setBtnEnabled(self.m_objCommonUi.m_btnHu, isHu)
    end

    self:setBtnEnabled(self.m_objCommonUi.m_btnPass, true)

    self.m_objCommonUi.m_btnPass.isPassSendMsg = isPassSendMsg --是否发请求

    local count = 0
    for k,v in pairs(tObjCpghObj) do
    	print("sdflsj!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!dfjsdjfsldjfsjfljsdfljs", k,tostring(v))
        count = count + 1
    end

    self.m_objCommonUi.m_nodeActionBtns:setVisible(count > 0)

    if count > 0 then --有按钮需要排位置
        local arr = self.m_objCommonUi.m_nodeActionBtns:getChildren()
        local arrBtn = {}
        for i = 1, #arr do
            local isBtn = arr[i]:getDescription() == "Button" 

            if isBtn and arr[i]:isVisible() then
                table.insert(arrBtn, arr[i])
            end
        end

        --按照x轴排序
        local function comps(a,b)
            return a.orgPos.x < b.orgPos.x
        end

        table.sort(arrBtn, comps)

        --从右往左排位置
        local lastX = self.m_objCommonUi.m_btnPass.orgPos.x + self.m_objCommonUi.m_btnPass:getContentSize().width * self.m_objCommonUi.m_btnPass:getScaleX()
        for i = #arrBtn, 1, -1 do
            arrBtn[i]:setPositionX(lastX - (arrBtn[i]:getContentSize().width * arrBtn[i]:getScaleX()))
            lastX = arrBtn[i]:getPositionX()
        end
    end

end

function GameActionBtnsPanel:resetActionButtonsData(tObjCpghObj)
    if self.m_objCommonUi.m_btnChi then
        self.m_objCommonUi.m_btnChi.tObjData = tObjCpghObj.tObjChi
    end
    if self.m_objCommonUi.m_btnPeng then
        self.m_objCommonUi.m_btnPeng.tObjData = tObjCpghObj.tObjPeng
    end
    if self.m_objCommonUi.m_btnGang then
    self.m_objCommonUi.m_btnGang.tObjData = tObjCpghObj.tObjGang
    end
    if self.m_objCommonUi.m_btnTing then
        self.m_objCommonUi.m_btnTing.tObjData = tObjCpghObj.tObjTing
    end
    if self.m_objCommonUi.m_btnHu then
        self.m_objCommonUi.m_btnHu.tObjData = tObjCpghObj.tObjHu
    end

    -- --判断是不是自摸胡，按钮显示不一样
    -- local isZm = self.m_objModel:getIsMeCurMo()
    -- local huBtnSkin = (isZm and not self.m_objModel:getMjConfig().isZmShowHuBtnAndAni) and "game/mjcomm/button/btnZm.png" or "game/mjcomm/button/btnHu.png"
    -- self.m_objCommonUi.m_btnHu:loadTextureNormal(huBtnSkin, 1)
    -- self.m_objCommonUi.m_btnHu:loadTexturePressed(huBtnSkin, 1)
    -- self.m_objCommonUi.m_btnHu:loadTextureDisabled(huBtnSkin, 1)
end

function GameActionBtnsPanel:viewMenuBase(tObj, iType)
    self:viewHideActPanelAndMenu()
    
    -- tObj = {5, 16}
    -- iType = 3
    --显示二级菜单  getTouchEndPosition  getTouchBeganPosition
    local panelMenu = self.m_objCommonUi.m_panelMenuItems
    local iStartX = 0
    local iGap = 10
    local iPanelMenuWidth = 0
    for i = 1, #tObj do
        local uiItem = self:createMenuItem()
        uiItem:setScale(0.65)
		local value = tObj[i]

        local face = uiItem:getChildByName("Node_Mj"):getChildByName("Sprite_Face")
        local imageBg = uiItem:getChildByName("Node_Mj"):getChildByName("Image_Bg")
        imageBg.selectCardData = {card = value, type = iType}

		local cardType = math.floor(value / 10) + 1
		local cardValue = value % 10
		face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")

		panelMenu:addChild(uiItem)

		uiItem:setPosition(cc.p(iStartX, panelMenu:getContentSize().height/2 - uiItem:getBoundingBox().height/2))
		iStartX = iStartX + uiItem:getBoundingBox().width + iGap
		iPanelMenuWidth = iPanelMenuWidth + uiItem:getBoundingBox().width

		lt.CommonUtil:addNodeClickEvent(imageBg, handler(self, self.onClickSelectCard))
    end

    --添加

    iPanelMenuWidth = iPanelMenuWidth + (#tObj - 1) * iGap

    --胡牌提示滚动面板的实际尺寸
    local panelSize = cc.size(iPanelMenuWidth, panelMenu:getContentSize().height)
    --胡牌提示滚动面板的滚动尺寸
    panelMenu:setInnerContainerSize(panelSize)
    -- if panelSize.width > 300 then --长度超过了 x 就设置成x，同时允许滚动
    --     panelSize.width = 300
    --     self:setHuTipsScrollBarEnabled(panelMenu, true)
    -- else --否则有足够的空间，不需要滚动
    --     self:setHuTipsScrollBarEnabled(panelMenu, false)
    -- end
    panelMenu:setContentSize(panelSize)

    --背景变化
    local imgMenuBg = self.m_objCommonUi.m_imgCardsMenuBg
    imgMenuBg:setContentSize(cc.size(-panelMenu:getPositionX() + panelMenu:getContentSize().width + iGap, imgMenuBg:getContentSize().height))

    self.m_objCommonUi.m_nodeCardsMenu:setVisible(true)

end

--显示吃的二级菜单
function GameActionBtnsPanel:viewChiMenu(tObj)
    self:viewMenuBase(tObj, 1)
end

--显示碰的二级菜单
function GameActionBtnsPanel:viewPengMenu(tObj)
    self:viewMenuBase(tObj, 2)
end

--显示杠的二级菜单
function GameActionBtnsPanel:viewGangMenu(tObj)
    self:viewMenuBase(tObj, 3)
end

--显示胡的二级菜单
function GameActionBtnsPanel:viewHuMenu(tObj)
    self:viewMenuBase(tObj, 4)
end

function GameActionBtnsPanel:viewHideActPanelAndMenu()
    self.m_objCommonUi.m_nodeActionBtns:setVisible(false)
    self.m_objCommonUi.m_nodeCardsMenu:setVisible(false)
end

function GameActionBtnsPanel:createMenuItem()
    local mj = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjStandFaceItem.csb")

    return mj
end

function GameActionBtnsPanel:onNoticeSpecialEvent(msg)
    if not msg then
        return
    end
    local direction = self._deleget:getPlayerDirectionByPos(msg.user_pos) 
    if not direction or not self._specialEventNode[direction] then
        return
    end

    if not msg.item["type"] then
        return
    end
    self._specialEventNode[direction]:setVisible(true)
    local light = self._specialEventNode[direction]:getChildByName("Sprite_Light")
    local word = self._specialEventNode[direction]:getChildByName("Sprite_Word")

    local path = "game/mjcomm/animation/aniWord/wordChi.png"
    if msg.item["type"] == 1 then --<1 吃 2 碰 3 碰杠 4明杠 5 暗杠 6 胡>
        path = "game/mjcomm/animation/aniWord/wordChi.png"
    elseif msg.item["type"] == 2 then
        path = "game/mjcomm/animation/aniWord/wordPeng.png"
    elseif msg.item["type"] == 3 then
        path = "game/mjcomm/animation/aniWord/wordGang.png"
    elseif msg.item["type"] == 4 then
        path = "game/mjcomm/animation/aniWord/wordGang.png"
    elseif msg.item["type"] == 5 then
        path = "game/mjcomm/animation/aniWord/wordGang.png"
    elseif msg.item["type"] == 6 then
        path = "game/mjcomm/animation/aniWord/wordHu.png"--wordZm
    end
    word:setSpriteFrame(path)
    
    for i=1,12 do

        local delay = cc.DelayTime:create(0.1 * i)

        local func1 = cc.CallFunc:create(function()
            local framePath = "game/mjcomm/animation/aniActionLight/aniAction_"..i..".png"
            light:setSpriteFrame(framePath)
            if i == 12 then
                self._specialEventNode[direction]:setVisible(false)
            end
        end)
        local sequence = cc.Sequence:create(delay, func1)
        light:runAction(sequence)
    end
end

function GameActionBtnsPanel:onEnter()   
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_SPECIAL_EVENT, handler(self, self.onNoticeSpecialEvent), "GameActionBtnsPanel.onNoticeSpecialEvent")
end

function GameActionBtnsPanel:onExit()
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_SPECIAL_EVENT, "GameActionBtnsPanel:onNoticeSpecialEvent")
end

return GameActionBtnsPanel