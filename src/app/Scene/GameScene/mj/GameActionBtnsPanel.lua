
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
        self.m_objCommonUi.m_btnToMin:setVisible(false)
        self.m_objCommonUi.m_btnToMax = self.m_objCommonUi.m_nodeHuCardTips:getChildByName("Button_ToMax")

        -- if self.m_objCommonUi.m_btnToMin then
        --     table.insert(self.m_objCommonUi.m_tArrActionBtn, self.m_objCommonUi.m_btnToMin)
        -- end

        if self.m_objCommonUi.m_btnToMax then
            table.insert(self.m_objCommonUi.m_tArrActionBtn, self.m_objCommonUi.m_btnToMax)
        end
    end

    shaizi1:setVisible(false)
    shaizi2:setVisible(false)

    for k,node in pairs(self.m_objCommonUi.m_tArrActionBtn) do
        lt.CommonUtil:addNodeClickEvent(node, handler(self, self.onClickCpghEvent))
    end

    self.m_objCommonUi.m_nodeCardsMenu:setVisible(false)
    self.m_objCommonUi.m_nodeActionBtns:setVisible(false)
    self.m_objCommonUi.m_nodeHuCardTips:setVisible(false)

    local rect = cc.rect(0,0,0, 0)
    self._clippingNode = cc.ClippingRectangleNode:create(rect)      
    --self._clippingNode:setPosition(22 * self._winScale, 20 * self._winScale)
    self._clippingNode:setPosition(36, 0)
    self.m_objCommonUi.m_nodeHuCardTips:addChild(self._clippingNode)

    self.m_objCommonUi.m_imgHuCardTipsBg:retain()
    self.m_objCommonUi.m_panelHuCardTipsContent:retain()

    self.m_objCommonUi.m_imgHuCardTipsBg:removeFromParent()
    self.m_objCommonUi.m_panelHuCardTipsContent:removeFromParent()

    self._clippingNode:addChild(self.m_objCommonUi.m_imgHuCardTipsBg)
    self._clippingNode:addChild(self.m_objCommonUi.m_panelHuCardTipsContent)


    self._allHutipsCardNode = {}
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
        self._deleget:checkMyHandTingStatu(true)
        self.m_objCommonUi.m_btnTing:setVisible(false)
        self:viewHideActPanelAndMenu()                  
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
       
        if self.m_objCommonUi.m_btnTing:isVisible() then
            self._deleget:checkMyHandTingStatu(false)
        end
        local isBaoTing = lt.DataManager:isTingPlayerByPos(lt.DataManager:getMyselfPositionInfo().user_pos)

        if isBaoTing then
            self._deleget:autoPutOutCard()
        end

        if pSender.isPassSendMsg then
            self:onPassAction()
        else
            self:onPassClick()
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
    elseif pSender == self.m_objCommonUi.m_btnToMin then
        -- if #self.m_objModel.m_tArrTingCards > 0 then
        --     self:showHuCardsTipsMj()
        -- else
        --     self:hideHuCardsTipsMj()
        -- end
    elseif pSender == self.m_objCommonUi.m_btnToMax then
        self:autoShowHuCardsContent()
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
        local isTing = tObjCpghObj.tObjTing ~= nil
        self:setBtnEnabled(self.m_objCommonUi.m_btnTing, isTing)
    end

    if self.m_objCommonUi.m_btnHu then
        local isHu = tObjCpghObj.tObjHu ~= nil
        self:setBtnEnabled(self.m_objCommonUi.m_btnHu, isHu)
    end
    if tObjCpghObj.tObjHu and lt.DataManager:getGameRoomSetInfo().game_type == lt.Constants.GAME_TYPE.TDH then
        self:setBtnEnabled(self.m_objCommonUi.m_btnPass,false) --推倒胡胡牌不能过
    else
        self:setBtnEnabled(self.m_objCommonUi.m_btnPass, true)
    end
    self.m_objCommonUi.m_btnPass.isPassSendMsg = isPassSendMsg --是否发请求

    local count = 0
    for k,v in pairs(tObjCpghObj) do
    	print("sdflsjGameActionBtnsPanel:viewActionButtons==>tObjCpghObj==>k==>v", k,tostring(v))
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
    panelMenu:removeAllChildren()

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

function GameActionBtnsPanel:showHuCardsTipsMj()
    self.m_objCommonUi.m_nodeHuCardTips:setVisible(true)
    self._clippingNode:setVisible(true)
    self:runEffect()
end

function GameActionBtnsPanel:runEffect()
    self.m_objCommonUi.m_panelHuCardTipsContent:stopAllActions()
    self.m_objCommonUi.m_imgHuCardTipsBg:stopAllActions()

    local contentX = self.m_objCommonUi.m_panelHuCardTipsContent:getContentSize().width
    self.m_objCommonUi.m_panelHuCardTipsContent:setPosition(-contentX, 0)
    local bgX = self.m_objCommonUi.m_imgHuCardTipsBg:getContentSize().width
    self.m_objCommonUi.m_imgHuCardTipsBg:setPosition(-bgX, 0)

    local moveBy1 = cc.MoveBy:create(0.5, ccp(contentX + 20, 0))
    local moveBy2 = cc.MoveBy:create(0.5, ccp(bgX, 0))

    self.m_objCommonUi.m_panelHuCardTipsContent:runAction(moveBy1)
    self.m_objCommonUi.m_imgHuCardTipsBg:runAction(moveBy2)
end

function GameActionBtnsPanel:hideHuCardsTipsMj()
    self.m_objCommonUi.m_nodeHuCardTips:setVisible(false)
end

function GameActionBtnsPanel:hideHuCardsContent()
    self._clippingNode:setVisible(false)
end

function GameActionBtnsPanel:autoShowHuCardsContent()
    if self._clippingNode:isVisible() then
        self._clippingNode:setVisible(false)
    else
        self._clippingNode:setVisible(true)
        self:runEffect()
    end
end

function GameActionBtnsPanel:createMenuItemt()
    local mj = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjHuCardsTipsItem.csb")

    return mj
end

function GameActionBtnsPanel:refreshHuCardNum(info, type)--2 别人出牌  1起拍 3 吃碰杠
    if type == 1 or type == 2 then
        for i,item in ipairs(self._allHutipsCardNode) do
            if item:getCardValue() == info then
                item:setCardNum(item:getCardNum() - 1)
                break
            end
        end
    elseif type == 3 then
        -- info["value"] = msg.item["value"]
        -- info["from"] = msg.item["from"]
        -- info["type"] = msg.item["type"]--<1 吃 2 碰 3 碰杠 4明杠 5 暗杠 6 胡 7听>

        local offNum = 0--吃椪杠少牌处理
        if info["type"] == 1 then

        elseif info["type"] == 2 then
            offNum = 2
        elseif info["type"] == 3 then   
            offNum = 1
        elseif info["type"] == 4 then
            offNum = 3
        elseif info["type"] == 5 then
            offNum = 4
        elseif info["type"] == 7 then --听==出牌

        end
        if offNum ~= 0 then
            for i,item in ipairs(self._allHutipsCardNode) do
                if item:getCardValue() == info["value"] then
                    item:setCardNum(item:getCardNum() - offNum)
                    break
                end
            end
        end
    end
end

function GameActionBtnsPanel:viewHuCardsTipsMenu(tObj)

    dump(tObj, "viewHuCardsTipsMenu")
    
    local panelMenu = self.m_objCommonUi.m_panelHuCardTipsContent

    panelMenu:removeAllChildren()
    
    self._allHutipsCardNode = {}

    local iStartX = 0
    local iGap = 10
    local iPanelMenuWidth = 0

    for i = 1, #tObj do
        local uiItem = lt.MjHuCardTipsItem.new()

        local value = tObj[i]
        local num = self._deleget:getotersCard(value)
        uiItem:setCardIcon(value)
        uiItem:setCardNum(num)

        panelMenu:addChild(uiItem)
        uiItem:setPosition(cc.p(iStartX, panelMenu:getContentSize().height/2 - uiItem:getBoundingBox().height/2))
        iStartX = iStartX + uiItem:getBoundingBox().width + iGap
        iPanelMenuWidth = iPanelMenuWidth + uiItem:getBoundingBox().width

        table.insert(self._allHutipsCardNode, uiItem)
    end

    --添加

    iPanelMenuWidth = iPanelMenuWidth + (#tObj - 1) * iGap

    --胡牌提示滚动面板的实际尺寸
    local panelSize = cc.size(iPanelMenuWidth, panelMenu:getContentSize().height)
    --胡牌提示滚动面板的滚动尺寸
    panelMenu:setInnerContainerSize(panelSize)
    if panelSize.width > 350 then --长度超过了 x 就设置成x，同时允许滚动
        panelSize.width = 350
        self:setHuTipsScrollBarEnabled(panelMenu, true)
    else --否则有足够的空间，不需要滚动
        self:setHuTipsScrollBarEnabled(panelMenu, false)
    end
    panelMenu:setContentSize(panelSize)

    --背景变化
    local imgMenuBg = self.m_objCommonUi.m_imgHuCardTipsBg
    imgMenuBg:setContentSize(cc.size(panelSize.width + 4 * iGap - 5, imgMenuBg:getContentSize().height))

    local rect = cc.rect(0, -(imgMenuBg:getContentSize().height + 10) / 2, panelSize.width + 4 * iGap + 20, imgMenuBg:getContentSize().height + 10)
    self._clippingNode:setClippingRegion(rect)
    
end

--胡牌提示滚动条设置
function GameActionBtnsPanel:setHuTipsScrollBarEnabled(uiScrollBar, isEnabled, iDisY)
    uiScrollBar:setScrollBarEnabled(isEnabled)
    if uiScrollBar:isScrollBarEnabled() then
        uiScrollBar:setScrollBarAutoHideTime(1)
        uiScrollBar:setScrollBarColor(cc.c3b(255, 255, 255))
        local p = uiScrollBar:getScrollBarPositionFromCornerForHorizontal()
        p.y = 0
        if iDisY then
            p.y = p.y + iDisY 
        end
        uiScrollBar:setScrollBarPositionFromCornerForHorizontal(p)
        uiScrollBar:setScrollBarWidth(4)
    end
    uiScrollBar:setTouchEnabled(isEnabled)
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
    elseif msg.item["type"] == 7 then
        path = "game/mjcomm/animation/aniTing/aniTing_11.png"--wordZm
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
        local sequence = cc.Sequence:create(delay, func1,nil)
        light:runAction(sequence)
    end
end

function GameActionBtnsPanel:onNoticeSpecialBuFlowerEvent(msg)  
    if not msg or not msg.user_pos or not msg.card then
        return
    end
    local direction = self._deleget:getPlayerDirectionByPos(msg.user_pos) 
    if not direction or not self._specialEventNode[direction] then
        return
    end
--user_pos   card

    self._specialEventNode[direction]:setVisible(true)
    local light = self._specialEventNode[direction]:getChildByName("Sprite_Light")
    local word = self._specialEventNode[direction]:getChildByName("Sprite_Word")

    local path = "game/mjcomm/animation/aniWord/wordLai.png"

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

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_SPECIAL_BUFLOWER, handler(self, self.onNoticeSpecialBuFlowerEvent), "GameActionBtnsPanel.onNoticeSpecialBuFlowerEvent")
end

function GameActionBtnsPanel:onExit()
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_SPECIAL_EVENT, "GameActionBtnsPanel:onNoticeSpecialEvent")

    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_SPECIAL_BUFLOWER, "GameActionBtnsPanel:onNoticeSpecialBuFlowerEvent")
end

return GameActionBtnsPanel