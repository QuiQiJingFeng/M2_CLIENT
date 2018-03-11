
local pi = math.pi

local debugSEMonsterId = 58

-- ################################################## 世界界面(菜单界面) ##################################################
local WorldMenuLayer = class("WorldMenuLayer", function()
    return cc.CSLoader:createNode("hallcomm/lobby/LobbyLayer1.csb")
end)

WorldMenuLayer._winScale = lt.CacheManager:getWinScale()

WorldMenuLayer._worldLayer = nil

local locationScale = WorldMenuLayer._winScale
if locationScale < 1 then
    locationScale = locationScale * 0.8
end

WorldMenuLayer._rightZoomBtnstatus = 1 --右上角缩放按钮状态 1 伸出 2 缩进

WorldMenuLayer._buttonListArray = nil

function WorldMenuLayer:ctor()
    --self._updateLayer = cc.CSLoader:createNode("games/comm/launch//UpdateLayer.csb")

    local baseLayer = self:getChildByName("Ie_Bg") --csd

    --设置按钮
    local setBtn = baseLayer:getChildByName("Ie_Bg"):getChildByName("Pl_Info"):getChildByName("Bn_Set")

    local createRoomBtn = self:getChildByName("Ie_Bg"):getChildByName("Bn_CreateRoom")
    local joinRoomBtn = self:getChildByName("Ie_Bg"):getChildByName("Bn_JoinRoom")
    
    lt.CommonUtil:addNodeClickEvent(setBtn, handler(self, self.onClickSetBtn))
    lt.CommonUtil:addNodeClickEvent(createRoomBtn, handler(self, self.onClickSetBtn))
    lt.CommonUtil:addNodeClickEvent(joinRoomBtn, handler(self, self.onClickSetBtn))
    -- self:checkRightBtnNode()
    -- self:updateNewFlagInfo()
    --lt.UILayerManager:addLayer(commonAlertLayer, true)
end

function WorldMenuLayer:onClickSetBtn(event)
    local setLayer = lt.SetLayer.new()
    lt.UILayerManager:addLayer(setLayer, true)
end

function WorldMenuLayer:onClickCreateRoomBtn(event)
    local setLayer = lt.SetLayer.new()
    lt.UILayerManager:addLayer(setLayer, true)
end

function WorldMenuLayer:onClickJoinRoomBtn(event)
    local setLayer = lt.SetLayer.new()
    lt.UILayerManager:addLayer(setLayer, true)
end


--右上角按钮状态
function WorldMenuLayer:checkRightBtnNode(flag)

    if self._rightZoomBtnstatus == 1 then
        self._zoomImage:setFlippedX(true)
    else
        self._zoomImage:setFlippedX(false)
    end

    self:clearAllNotice()
    self:clearAllBtn()
    self._rightBtnNode:removeAllChildren()
    local currentRightBtnArray = {}

    local secondArray = {}
    --活动
    if lt.DataManager:isActivityFuncOpen() then
        self._activityBtn = lt.ScaleButton.new("#city_icon_activity.png",{scale = self._winScale})
        --self._activityBtn:setPosition(display.width - 185*self._winScale, display.top - 38*self._winScale)
        self._activityBtn:onButtonClicked(handler(self, self.onActivity))
        self._rightBtnNode:addChild(self._activityBtn)

        currentRightBtnArray[#currentRightBtnArray + 1] = self._activityBtn
    end

    --第二排按钮
    -- local firstCharge = lt.ScaleButton.new("#city_icon_first_charge.png",{scale = self._winScale})
    -- --firstCharge:setPosition(display.width - 185*self._winScale, display.top - 110*self._winScale)
    -- self._rightBtnNode:addChild(firstCharge)
    -- secondArray[#secondArray + 1] = firstCharge

    --变强按钮
    if lt.DataManager:getPlayerLevel() >= 10 then 
        self._strongBtn = lt.ScaleButton.new("#city_icon_strong.png",{scale = self._winScale})
        --firstCharge:setPosition(display.width - 185*self._winScale, display.top - 110*self._winScale)
        self._strongBtn:onButtonClicked(handler(self, self.onStrongBtn))
        self._rightBtnNode:addChild(self._strongBtn)
        secondArray[#secondArray + 1] = self._strongBtn
    end

    if lt.DataManager:getBattlePointRewardFlag() ~= 1 or 
        lt.DataManager:checkActivityOpen(lt.Constants.ACTIVITY_ID.LEVELING_REWARD) 
        or lt.DataManager:getPaperBagTable().is_closed == 0
        or lt.DataManager:getStoneRewardIsFinished() ~= 1 
        or lt.DataManager:getServantRewardIsFinished() ~= 1 
        or lt.DataManager:getLifeRewardIsFinished() ~= 1 
        or lt.DataManager:getStrengthRewardIsFinished() ~= 1 then

        self._newServanceBtn = lt.ScaleButton.new("#city_icon_new_servance.png",{scale = self._winScale})
        self._newServanceBtn:onButtonClicked(handler(self, self.onNewServanceBtn))
        self._rightBtnNode:addChild(self._newServanceBtn)
        secondArray[#secondArray + 1] = self._newServanceBtn
    end

    --首冲累冲
    self._rechargeBtn = nil
    local rechargeTable = lt.DataManager:getRechargeLogTable()
    local finish = rechargeTable.finishFlag--//0:未结束 1：结束保留界面  2：结束删除界面
    if finish and finish == 0 or finish == 1 then
        self._rechargeBtn = lt.ScaleButton.new("#city_icon_first_charge.png",{scale = self._winScale})
        self._rechargeBtn:onButtonClicked(handler(self, self.onRechargeBtn))
        self._rightBtnNode:addChild(self._rechargeBtn)
        secondArray[#secondArray + 1] = self._rechargeBtn
    end

    --特惠礼包
    self._specialGiftBagBtn = nil
    if lt.NewFlagManager:getSpecialGiftBagFlag() then
        self._specialGiftBagBtn = lt.ScaleButton.new("#city_icon_gift.png",{scale = self._winScale})
        self._specialGiftBagBtn:onButtonClicked(handler(self, self.onSpecialGiftBagBtn))
        self._rightBtnNode:addChild(self._specialGiftBagBtn)
        secondArray[#secondArray + 1] = self._specialGiftBagBtn
    end

    --次日礼包
    self._morrowRewardBtn = nil
    local morrowRewardTable = lt.DataManager:getMorrowRewardTable()
    local isOpen = morrowRewardTable.is_open
    local receive_state = morrowRewardTable.receive_state
    receive_state = receive_state or 0
    if isOpen and isOpen == 1 and receive_state == 0 then
        self._morrowRewardBtn = lt.ScaleButton.new("#city_icon_info.png",{scale = self._winScale})
        self._morrowRewardBtn:onButtonClicked(handler(self, self.getMorrowGiftLayer))
        self._rightBtnNode:addChild(self._morrowRewardBtn)
        secondArray[#secondArray + 1] = self._morrowRewardBtn
    end

    --运营活动
    self._operationBtn = nil

    local operationFlag = lt.DataManager:isOperationOpen()

    if operationFlag then
        print("有活动")
        self._operationBtn = lt.ScaleButton.new("#city_icon_batch.png",{scale = self._winScale})
        self._operationBtn:onButtonClicked(handler(self, self.onOperationBtn))
        self._rightBtnNode:addChild(self._operationBtn)
        secondArray[#secondArray + 1] = self._operationBtn

        self._operationEffect = ccs.Armature:create("uieffect_new_icon")
        self._operationEffect:setPosition(20, 25)
        self._operationEffect:getAnimation():playWithIndex(0)
        self._operationEffect:setVisible(false)
        self._operationBtn:addChild(self._operationEffect)
    end

    -- 微信活动
    self._wechatActivityBtn = nil
    self._wechatActivityEffect = nil
    if lt.DataManager:isBatchActivityValidWechat() then
        self._wechatActivityBtn = lt.ScaleButton.new("#city_icon_wechat.png",{scale = self._winScale})
        self._wechatActivityBtn:onButtonClicked(handler(self, self.onWechatActivityBtn))
        self._rightBtnNode:addChild(self._wechatActivityBtn)
        secondArray[#secondArray + 1] = self._wechatActivityBtn

        self._wechatActivityEffect = ccs.Armature:create("uieffect_new_icon")
        self._wechatActivityEffect:setPosition(20, 25)
        self._wechatActivityEffect:getAnimation():playWithIndex(0)
        self._wechatActivityEffect:setVisible(false)
        self._wechatActivityBtn:addChild(self._wechatActivityEffect)
    end


    --福利
    self._welfareBtn = lt.ScaleButton.new("#city_icon_welfare.png",{scale = self._winScale})
    self._welfareBtn:onButtonClicked(handler(self, self.onWelfare))
    self._rightBtnNode:addChild(self._welfareBtn)
    
    currentRightBtnArray[#currentRightBtnArray + 1] = self._welfareBtn

    if self._rightZoomBtnstatus == 2 then
        for i = 1, #currentRightBtnArray do
            currentRightBtnArray[i]:setPosition(display.width - 115*self._winScale, display.top - 38*self._winScale)
            currentRightBtnArray[i]:runAction(cc.EaseBackOut:create(cca.moveTo(0.2, display.width - 185*self._winScale - (i - 1) * 70*self._winScale, display.top - 38*self._winScale)))
        end

        for i = 1, #secondArray do
            secondArray[i]:setVisible(false)
            --secondArray[i]:runAction(cc.EaseBackOut:create(cca.moveTo(0.2, display.width - 185*self._winScale - (i - 1) * 70*self._winScale, display.top - 110*self._winScale)))
        end

        self:updateNewFlagInfo()
        return
    end

    --摆摊

    local playerLevel = lt.DataManager:getPlayerLevel()
    if playerLevel >= lt.Constants.STALL_OPEN_LEVEL then

        self._stallBtn = lt.ScaleButton.new("#city_icon_stall.png",{scale = self._winScale})
        self._stallBtn:setVisible(false)
        self._stallBtn:onButtonClicked(handler(self, self.onStall))
        self._rightBtnNode:addChild(self._stallBtn)
        self._stallBtn:setVisible(true)

        currentRightBtnArray[#currentRightBtnArray + 1] = self._stallBtn
    end

    --商会按钮
    if lt.DataManager:isStallFuncOpen() then

        self._shopClubBtn = lt.ScaleButton.new("#city_icon_shopclub.png",{scale = self._winScale})
        --self._shopClubBtn:setPosition(positionX, self._activityBtn:getPositionY())
        self._shopClubBtn:onButtonClicked(handler(self, self.onShopClub))
        self._rightBtnNode:addChild(self._shopClubBtn)

        currentRightBtnArray[#currentRightBtnArray + 1] = self._shopClubBtn
    end

    --排行
    if lt.DataManager:isRankFuncOpen() then
        self._rankBtn = lt.ScaleButton.new("#city_icon_rank.png",{scale = self._winScale})
        --self._rankBtn:setPosition(self._shopClubBtn:getPositionX() - 70*self._winScale, self._activityBtn:getPositionY())
        self._rankBtn:onButtonClicked(handler(self, self.onRankBtn))
        self._rightBtnNode:addChild(self._rankBtn)

        currentRightBtnArray[#currentRightBtnArray + 1] = self._rankBtn
    end

    --扭蛋机
    local playerLevel = lt.DataManager:getPlayerLevel()
    if playerLevel >= lt.Constants.EGG_OPEN_LEVEL then
        self._eggBtn = lt.ScaleButton.new("#city_icon_egg.png",{scale = self._winScale})
        --self._rankBtn:setPosition(self._shopClubBtn:getPositionX() - 70*self._winScale, self._activityBtn:getPositionY())
        self._eggBtn:onButtonClicked(handler(self, self.onEggRewardLayer))
        self._rightBtnNode:addChild(self._eggBtn)
        currentRightBtnArray[#currentRightBtnArray + 1] = self._eggBtn
    end

    --扭蛋机
    local playerLevel = lt.DataManager:getPlayerLevel()
    if playerLevel >= lt.Constants.EGG_OPEN_LEVEL then
        self._eggBtn = lt.ScaleButton.new("#city_icon_egg.png",{scale = self._winScale})
        --self._rankBtn:setPosition(self._shopClubBtn:getPositionX() - 70*self._winScale, self._activityBtn:getPositionY())
        self._eggBtn:onButtonClicked(handler(self, self.onLimiteEggRewardLayer))
        self._rightBtnNode:addChild(self._eggBtn)
        currentRightBtnArray[#currentRightBtnArray + 1] = self._eggBtn
    end

    if flag then
        for i = 1, #currentRightBtnArray do
            currentRightBtnArray[i]:setPosition(display.width - 185*self._winScale - (i - 1) * 70*self._winScale, display.top - 38*self._winScale)
            --currentRightBtnArray[i]:runAction(cc.EaseBackOut:create(cca.moveTo(0.2, display.width - 185*self._winScale - (i - 1) * 70*self._winScale, display.top - 38*self._winScale)))
            
        end

        for i = 1, #secondArray do
            secondArray[i]:setPosition(display.width - 185*self._winScale - (i - 1) * 70*self._winScale, display.top - 110*self._winScale)
            --secondArray[i]:runAction(cc.EaseBackOut:create(cca.moveTo(0.2, display.width - 185*self._winScale - (i - 1) * 70*self._winScale, display.top - 110*self._winScale)))
        end
    else
        for i = 1, #currentRightBtnArray do
            currentRightBtnArray[i]:setPosition(display.width - 115*self._winScale, display.top - 38*self._winScale)
            currentRightBtnArray[i]:runAction(cc.EaseBackOut:create(cca.moveTo(0.2, display.width - 185*self._winScale - (i - 1) * 70*self._winScale, display.top - 38*self._winScale)))
            
        end

        for i = 1, #secondArray do
            secondArray[i]:setPosition(display.width - 115*self._winScale, display.top - 110*self._winScale)
            secondArray[i]:runAction(cc.EaseBackOut:create(cca.moveTo(0.2, display.width - 185*self._winScale - (i - 1) * 70*self._winScale, display.top - 110*self._winScale)))
        end
    end

    self:updateNewFlagInfo()
end

function WorldMenuLayer:updateNewFlagInfo()
    if self._activityBtn then
        if lt.NewFlagManager:hasActivityReward() then
            self:getActivityNotice()
        else
            self:clearActivityNotice()
        end
    end

    if self._strongBtn then
        if lt.NewFlagManager:hasGrowTaskReward() then
            self:getGrowTaskNotice()
        else
            self:clearGrowTaskNotice()
        end
    end

    if self._welfareBtn then
        if lt.NewFlagManager:hasNewWelfare() then
            self:getWelfareNotice()
        else
            self:clearWelfareNotice()
        end
    end

    if self._newServanceBtn then --新服
        if lt.NewFlagManager:hasLevelingReward() or lt.NewFlagManager:hasFightingReward() or lt.NewFlagManager:getNewSerViceRedPackage() 
            or lt.NewFlagManager:getIntelligentNew()
            then
            self:getNewServanceNotice()
        else
            self:clearNewServanceNotice()
        end
    end

    if self._morrowRewardBtn then --次日礼包
        if lt.NewFlagManager:getMorrowGiftPackage() then
            self:getMorrowRewardNotice()
        else
            self:clearMorrowRewardNotice()
        end
    end

    if self._stallBtn then
        if lt.NewFlagManager:hasStallIncomeNew() then
            self:getStallNotice()
        else
            self:clearStallNotice()
        end
    end

    if self._shopClubBtn then
        if lt.NewFlagManager:checkRuneBoxNew() or lt.NewFlagManager:hasMonthCardReceive() then
            self:getShopNotice():setVisible(true)
        else
            self:getShopNotice():setVisible(false)
        end
    end

    -- if self._friendBtn then
    --     if lt.NewFlagManager:hasNewChatMessage() or lt.NewFlagManager:hasNewRequestMessage() or 
    --     lt.NewFlagManager:hasNewMail() or lt.NewFlagManager:hasSystemChat() then --好友新消息或者好友新请求
    --         self:getFriendNotice()
    --     else
    --         self:clearFriendNotice()
    --     end
    -- end

    --提升按钮
    if self._promoteBtn then
        local promoteLevel = 0
        if lt.NewFlagManager:canUpgradeSkill() then
            promoteLevel = promoteLevel + 1
        end
        if lt.NewFlagManager:hasGemNew() then
            promoteLevel = promoteLevel + 1
        end
        if lt.NewFlagManager:hasSiteStrengthNew() then
            promoteLevel = promoteLevel + 1
        end
        if lt.NewFlagManager:canUpgradeTalentSkill() then
            promoteLevel = promoteLevel + 1
        end

        if promoteLevel > 0 then
            self._promoteBtn:setVisible(true)

            if promoteLevel > self._promoteLevel then
                self._promoteEffect:setVisible(true)
            end
        else
            self._promoteBtn:setVisible(false)
            self._promoteEffect:setVisible(false)
        end

        self._promoteLevel = promoteLevel
    end

    --扩展菜单里面小红点
    if lt.NewFlagManager:hasDownMenuNew() then
        self:getDownMenuNotice()
    else
        self:clearDownMenuNotice()
    end

    if self._menuBtnArray then
        for _,menuBtn in ipairs(self._menuBtnArray) do
            local tag = menuBtn:getTag()
            if lt.NewFlagManager:getNewFlagByType(tag) then
                menuBtn.notice:setVisible(true)
            else
                menuBtn.notice:setVisible(false)
            end
        end
    end

    --英灵小红点  
    if self._servantBtn then
        if lt.NewFlagManager:hasServantUnlock() or lt.NewFlagManager:hasServantAdvance() or lt.NewFlagManager:hasServantBound() then
            self:getServantNotice()
        else
            self:clearServantNotice()
        end
    end

    --首冲累冲
    if self._rechargeBtn then
        if lt.NewFlagManager:getFirstRechargeFlag() then
            self:getRechargeNotice()
        else
            self:clearRechargeNotice()
        end
    end

    --特惠礼包
    if self._specialGiftBagBtn then
        if not lt.NewFlagManager:getSpecialGiftBagFlag() then
            self:checkRightBtnNode(true)
        end
    else
        if lt.NewFlagManager:getSpecialGiftBagFlag() then
            self:checkRightBtnNode(true)
        end
    end

    -- 微信活动
    if self._wechatActivityBtn then
        if not lt.DataManager:isBatchActivityValidWechat() then
            -- 活动都关闭了
            lt.CommonUtil.print("活动都关闭了")
            self:checkRightBtnNode(true)
        else
            if self._wechatActivityEffect then
                if lt.NewFlagManager:getWechatActivity() == 2 then
                    self._wechatActivityEffect:setVisible(true)
                else
                    self._wechatActivityEffect:setVisible(false)
                end
            end
        end
    else
        if lt.DataManager:isBatchActivityValidWechat() then
            -- 活动开启了
            lt.CommonUtil.print("活动开启了")
            self:checkRightBtnNode(true)
        end
    end

    --运营活动
    if self._operationBtn then
        if not lt.DataManager:isOperationOpen() then
            -- 活动都关闭了
            lt.CommonUtil.print("活动都关闭了")
            self:checkRightBtnNode(true)
        else
            if self._operationEffect then
                if lt.NewFlagManager:hasOperationNew() then
                    self._operationEffect:setVisible(true)
                else
                    self._operationEffect:setVisible(false)
                end
            end
        end
    else
        if lt.DataManager:isOperationOpen() then
            -- 活动开启了
            lt.CommonUtil.print("活动开启了")
            self:checkRightBtnNode(true)
        end
    end


end

function WorldMenuLayer:getDownMenuNotice()
    if not self._downMenuNotice then
        self._downMenuNotice = ccs.Armature:create("uieffect_new_icon")
        self._downMenuNotice:getAnimation():playWithIndex(0)
        self._downMenuNotice:setPosition(20*self._winScale,20*self._winScale)
        self._downMenuBtn:addChild(self._downMenuNotice)
    end
    return self._downMenuNotice
end

function WorldMenuLayer:clearDownMenuNotice()
    if self._downMenuNotice then
        self._downMenuNotice:removeFromParent()
        self._downMenuNotice = nil
    end
end

function WorldMenuLayer:getStallNotice()
    if not self._stallNotice then
        self._stallNotice = ccs.Armature:create("uieffect_new_icon")
        self._stallNotice:getAnimation():playWithIndex(0)
        self._stallNotice:setPosition(25*self._winScale,25*self._winScale)
        self._stallBtn:addChild(self._stallNotice)
    end
    return self._stallNotice
end

function WorldMenuLayer:clearStallNotice()
    if self._stallNotice then
        self._stallNotice:removeFromParent()
        self._stallNotice = nil
    end
end

function WorldMenuLayer:getShopNotice()
    if not self._shopNotice then
        self._shopNotice = ccs.Armature:create("uieffect_new_icon")
        self._shopNotice:getAnimation():playWithIndex(0)
        self._shopNotice:setPosition(25*self._winScale,25*self._winScale)
        self._shopClubBtn:addChild(self._shopNotice)
    end
    return self._shopNotice
end

function WorldMenuLayer:clearShopNotice()
    if self._shopNotice then
        self._shopNotice:removeFromParent()
        self._shopNotice = nil
    end
end

function WorldMenuLayer:getFriendNotice()
    if not self._friendNotice then
        self._friendNotice = ccs.Armature:create("uieffect_new_icon")
        self._friendNotice:getAnimation():playWithIndex(0)
        self._friendNotice:setPosition(25*self._winScale,25*self._winScale)
        self._friendBtn:addChild(self._friendNotice)
    end
    return self._friendNotice
end

function WorldMenuLayer:clearFriendNotice()
    if self._friendNotice then
        self._friendNotice:removeFromParent()
        self._friendNotice = nil
    end
end

function WorldMenuLayer:getActivityNotice()
    if not self._activityNotice then
        self._activityNotice = ccs.Armature:create("uieffect_new_icon")
        self._activityNotice:getAnimation():playWithIndex(0)
        self._activityNotice:setPosition(25*self._winScale,25*self._winScale)
        self._activityBtn:addChild(self._activityNotice)
    end
    return self._activityNotice
end

function WorldMenuLayer:clearActivityNotice()
    if self._activityNotice then
        self._activityNotice:removeFromParent()
        self._activityNotice = nil
    end
end

function WorldMenuLayer:getGrowTaskNotice()
    if not self._growTaskNotice then
        self._growTaskNotice = ccs.Armature:create("uieffect_new_icon")
        self._growTaskNotice:getAnimation():playWithIndex(0)
        self._growTaskNotice:setPosition(25*self._winScale,25*self._winScale)
        self._strongBtn:addChild(self._growTaskNotice)
    end
    return self._growTaskNotice
end

function WorldMenuLayer:clearGrowTaskNotice()
    if self._growTaskNotice then
        self._growTaskNotice:removeFromParent()
        self._growTaskNotice = nil
    end
end

function WorldMenuLayer:getWelfareNotice()
    if not self._welfareNotice then
        self._welfareNotice = ccs.Armature:create("uieffect_new_icon")
        self._welfareNotice:getAnimation():playWithIndex(0)
        self._welfareNotice:setPosition(25*self._winScale,25*self._winScale)
        self._welfareBtn:addChild(self._welfareNotice)
    end
    return self._welfareNotice
end

function WorldMenuLayer:clearWelfareNotice()
    if self._welfareNotice then
        self._welfareNotice:removeFromParent()
        self._welfareNotice = nil
    end
end

function WorldMenuLayer:getNewServanceNotice()
    if not self._newServanceNotice then
        self._newServanceNotice = ccs.Armature:create("uieffect_new_icon")
        self._newServanceNotice:getAnimation():playWithIndex(0)
        self._newServanceNotice:setPosition(25*self._winScale,25*self._winScale)
        self._newServanceBtn:addChild(self._newServanceNotice)
    end
    return self._newServanceNotice
end

function WorldMenuLayer:clearNewServanceNotice()
    if self._newServanceNotice then
        self._newServanceNotice:removeFromParent()
        self._newServanceNotice = nil
    end
end

function WorldMenuLayer:getMorrowRewardNotice()
    if not self._morrowRewardNotice then
        self._morrowRewardNotice = ccs.Armature:create("uieffect_new_icon")
        self._morrowRewardNotice:getAnimation():playWithIndex(0)
        self._morrowRewardNotice:setPosition(25*self._winScale,25*self._winScale)
        if self._morrowRewardBtn and self._morrowRewardNotice then
            self._morrowRewardBtn:addChild(self._morrowRewardNotice)
        end
    end
    return self._morrowRewardNotice
end

function WorldMenuLayer:clearMorrowRewardNotice()
    if self._morrowRewardNotice then
        self._morrowRewardNotice:removeFromParent()
        self._morrowRewardNotice = nil
    end
end

function WorldMenuLayer:getServantNotice()--英灵
    if not self._servantNotice then
        self._servantNotice = ccs.Armature:create("uieffect_new_icon")
        self._servantNotice:getAnimation():playWithIndex(0)
        self._servantNotice:setPosition(25*self._winScale,25*self._winScale)
        self._servantBtn:addChild(self._servantNotice)
    end
    return self._servantNotice
end

function WorldMenuLayer:clearServantNotice()
    if self._servantNotice then
        self._servantNotice:removeFromParent()
        self._servantNotice = nil
    end
end

function WorldMenuLayer:getRechargeNotice()--首冲 累冲

    if not self._rechargeNotice then
        self._rechargeNotice = ccs.Armature:create("uieffect_new_icon")
        self._rechargeNotice:getAnimation():playWithIndex(0)
        self._rechargeNotice:setPosition(25*self._winScale,25*self._winScale)
        self._rechargeBtn:addChild(self._rechargeNotice)
    end
    return self._rechargeNotice
end

function WorldMenuLayer:clearRechargeNotice()
    
    if self._rechargeNotice then
        self._rechargeNotice:removeFromParent()
        self._rechargeNotice = nil
    end
end

function WorldMenuLayer:clearAllBtn()
    if self._stallBtn then
        self._stallBtn:removeFromParent()
        self._stallBtn = nil
    end

    if self._shopClubBtn then
        self._shopClubBtn:removeFromParent()
        self._shopClubBtn = nil
    end

    if self._welfareBtn then
        self._welfareBtn:removeFromParent()
        self._welfareBtn = nil
    end


    if self._activityBtn then
        self._activityBtn:removeFromParent()
        self._activityBtn = nil
    end

    if self._rechargeBtn then
        self._rechargeBtn:removeFromParent()
        self._rechargeBtn = nil
    end
end

function WorldMenuLayer:clearAllNotice()
    self:clearStallNotice()
    self:clearShopNotice()
    self:clearFriendNotice()
    self:clearActivityNotice()
    self:clearWelfareNotice()
    self:clearGrowTaskNotice()
    self:clearNewServanceNotice()
    self:clearMorrowRewardNotice()
    self:clearServantNotice()
    self:clearRechargeNotice()
end

function WorldMenuLayer:setWorldLayer(worldLayer)
    self._worldLayer = worldLayer
end

WorldMenuLayer._menuBtnTable = nil
WorldMenuLayer.menuVisible = false
WorldMenuLayer._duration = 0.3
WorldMenuLayer._btnHeight = 68

WorldMenuLayer.DURATION_TIME = {0.08,0.09,0.15,0.2,0.3,0.4,0.45}


function WorldMenuLayer:onDownMenuBtn()
    if not self._menuBtnArray then
        -- 首次打开
        self._menuVisible = true

        self._downMenuBtn:setButtonImage(cc.ui.UIPushButton.NORMAL,"#city_icon_arrow_up.png")

        self:createMenuBtn()

        self._controlNode:setVisible(false)
        self:hideBattleMenu()
        self:hideRightInfoPanel()
    else
        self._menuVisible = not self._menuVisible

        self:updateMenuBtn()

        if self._menuVisible then
            self._downMenuBtn:setButtonImage(cc.ui.UIPushButton.NORMAL,"#city_icon_arrow_up.png")

            self._controlNode:setVisible(false)
            self:hideBattleMenu()
            self:hideRightInfoPanel()
        else
            self._downMenuBtn:setButtonImage(cc.ui.UIPushButton.NORMAL,"#city_icon_arrow_down.png")

            self._controlNode:setVisible(true)
            self:updateBattleMenu()
            self:updateRightInfoPanel()
        end
    end
end



WorldMenuLayer.MENU_TYPE = {
    HERO    =    1,   --角色
    SKILL   =    2,   --技能
    DRESS   =    3,   --时装
    MAKE    =    4,   --打造
    GUILD   =    5,   --帮会
    SET     =    6,   --设置
    FRIEND  =    7,   --好友
}

function WorldMenuLayer:createMenuBtn(force)

    if self._menuBtnArray then
        for _,menuBtn in ipairs(self._menuBtnArray) do
            menuBtn:removeFromParent()
        end
    end

    self._menuBtnArray = {}

    -- 角色(始终存在)
    local roleBtn = lt.ScaleButton.new("#city_icon_role_info.png", {scale = self._winScale})
    roleBtn:setTag(self.MENU_TYPE.HERO)
    roleBtn:onButtonClicked(handler(self, self.onMenuBtnClicked))
    self._rightInfoNode1:addChild(roleBtn)

    self:createNotice(self.MENU_TYPE.HERO, roleBtn)

    table.insert(self._menuBtnArray, roleBtn)

    -- 技能按钮
    if lt.DataManager:isSkillFuncOpen() then
        local skillBtn = lt.ScaleButton.new("#city_icon_skill.png", {scale = self._winScale})
        skillBtn:setTag(self.MENU_TYPE.SKILL)
        skillBtn:onButtonClicked(handler(self, self.onMenuBtnClicked))
        self._rightInfoNode1:addChild(skillBtn)

        self:createNotice(self.MENU_TYPE.SKILL, skillBtn)

        table.insert(self._menuBtnArray, skillBtn)
    end

    -- 时装
    if lt.DataManager:isDressFuncOpen() then
        local dressBtn = lt.ScaleButton.new("#city_icon_dress.png", {scale = self._winScale})
        dressBtn:setTag(self.MENU_TYPE.DRESS)
        dressBtn:onButtonClicked(handler(self, self.onMenuBtnClicked))
        self._rightInfoNode1:addChild(dressBtn)

        self:createNotice(self.MENU_TYPE.DRESS, dressBtn)

        table.insert(self._menuBtnArray, dressBtn)
    end

    -- 打造
    if lt.DataManager:isMakeFuncOpen() then
        local makeBtn = lt.ScaleButton.new("#city_icon_equip_make.png", {scale = self._winScale})
        makeBtn:setTag(self.MENU_TYPE.MAKE)
        makeBtn:onButtonClicked(handler(self, self.onMenuBtnClicked))
        self._rightInfoNode1:addChild(makeBtn)

        self:createNotice(self.MENU_TYPE.MAKE, makeBtn)

        table.insert(self._menuBtnArray, makeBtn)
    end

    -- 公会
    if lt.DataManager:isGuildFuncOpen() then
        local guildBtn = lt.ScaleButton.new("#city_icon_guild.png", {scale = self._winScale})
        guildBtn:setTag(self.MENU_TYPE.GUILD)
        guildBtn:onButtonClicked(handler(self, self.onMenuBtnClicked))
        self._rightInfoNode1:addChild(guildBtn)

        self:createNotice(self.MENU_TYPE.GUILD, guildBtn)

        table.insert(self._menuBtnArray, guildBtn)
    end

    -- 设置(始终存在)
    local setBtn = lt.ScaleButton.new("#city_icon_set.png", {scale = self._winScale})
    setBtn:setTag(self.MENU_TYPE.SET)
    setBtn:onButtonClicked(handler(self, self.onMenuBtnClicked))
    self._rightInfoNode1:addChild(setBtn)

    table.insert(self._menuBtnArray, setBtn)

    self:createNotice(self.MENU_TYPE.SET, setBtn)

    
    --好友
    local friendBtn = lt.ScaleButton.new("#city_icon_friend.png",{scale = self._winScale})
    friendBtn:setTag(self.MENU_TYPE.FRIEND)
    friendBtn:onButtonClicked(handler(self, self.onMenuBtnClicked))
    self._rightInfoNode1:addChild(friendBtn,-1)

    table.insert(self._menuBtnArray, friendBtn)

    self:createNotice(self.MENU_TYPE.FRIEND, friendBtn)

    -- 定位
    for idx,menuBtn in ipairs(self._menuBtnArray) do
        local value = idx%7
        if value == 0 then
            value = 1
        end

        menuBtn:setPosition(display.width + 135 * self._winScale - math.floor(idx / 7) * 100, display.top - (188 + value * self._btnHeight) * self._winScale)
    end

    self:updateMenuBtn(force)
end

function WorldMenuLayer:updateMenuBtn(force)
    for idx,menuBtn in ipairs(self._menuBtnArray) do
        menuBtn:stopAllActions()
        local value = idx%7
        if value == 0 then
            value = 1
        end

        if self._menuVisible then
            if force then
                menuBtn:setPosition(display.width - 35 * self._winScale -  math.floor(idx / 7) * 75, display.top - (188 + value * self._btnHeight) * self._winScale)
            else
                menuBtn:runAction(cc.EaseBackOut:create(cca.moveTo(self.DURATION_TIME[idx], display.width - 35*self._winScale-  math.floor(idx / 7) * 75, menuBtn:getPositionY())))
            end
        else
            menuBtn:setPosition(display.width + 135 * self._winScale, display.top - (188 + value * self._btnHeight) * self._winScale)
        end
    end
end

function WorldMenuLayer:createNotice(type, button)
    local notice = ccs.Armature:create("uieffect_new_icon")
    notice:getAnimation():playWithIndex(0)
    notice:setPosition(20, 20)
    notice:setVisible(false)
    button:addChild(notice,100)
    
    button.notice = notice
    if lt.NewFlagManager:getNewFlagByType(type) then
        notice:setVisible(true)
    end
end

function WorldMenuLayer:onMenuBtnClicked(event)
    local tag = event.target:getTag()

    if tag == self.MENU_TYPE.HERO then
        self:onHeroInfo()
    elseif tag == self.MENU_TYPE.SKILL then
        self:onSkill()
    elseif tag == self.MENU_TYPE.DRESS then
        self:onDress()
    elseif tag == self.MENU_TYPE.MAKE then
        self:onEquipMake()
    elseif tag == self.MENU_TYPE.GUILD then
        self:onGuild()
    elseif tag == self.MENU_TYPE.SET then
        self:onSetLayer()
    elseif tag == self.MENU_TYPE.FRIEND then
        self:onFriendBtn()
    end
end

--左上角头像信息
function WorldMenuLayer:initHeroHeadInfo()
    local player = lt.DataManager:getPlayer()
    local hero = lt.DataManager:getHero()
    local occupationId = hero:getOccupation()
    if not player or not hero then
        return
    end

    --底部经验
    self._expBar = lt.PlayerExp.new()
    self._expBar:setPositionX(0)
    self:addChild(self._expBar,100)
    
    --左上头像
    local heroInfoBg = lt.PushButton.new("image/ui/common/touch_rect_80.png", {scale = self._winScale})
    heroInfoBg:setPosition(40 * self._winScale, display.top - 71 * self._winScale)
    heroInfoBg:onButtonClicked(handler(self, self.onHeroInfo))
    self:addChild(heroInfoBg,1000)

    local imageBg = display.newSprite("#city_img_bg.png")
    heroInfoBg:addChild(imageBg)

    local sex = hero:getSex()
    local info = lt.CacheManager:getModelHeroInfo(occupationId, sex)

    local id = info:getId()

    if id ~= 1 and id ~= 3 and id ~= 6 and id ~= 8 then--临时限制
        id = 1
    end

    local file = string.format("model/hmodel_%d", id)

    self._figure = lt.SkeletonAnimation.new(file)
    self._figure:setAnimation(0, "stand", true)
    self._figure:setScale(0.8)
    heroInfoBg:addChild(self._figure)

    self._figureState = 0

    --玩家名字
    local nameBg = display.newSprite("#city_img_name_bg.png")
    nameBg:setAnchorPoint(0, 1)
    nameBg:setPosition(52 * self._winScale + heroInfoBg:getContentSize().width, display.top - 33 * self._winScale)
    self:addChild(nameBg)

    self._teamLeaderFlag = display.newSprite("#main_team_leader_flag.png")
    self._teamLeaderFlag:setPosition(34, 11)
    self._teamLeaderFlag:setVisible(false)
    nameBg:addChild(self._teamLeaderFlag)

    self._playerLevelLabel = lt.GameLabel.new(lt.DataManager:getPlayerLevel(), 16, lt.Constants.DEFAULT_LABEL_COLOR_2)
    self._playerLevelLabel:setAnchorPoint(1, 0)
    self._playerLevelLabel:setPosition(60, 0)
    nameBg:addChild(self._playerLevelLabel)

    self._nameLabel = lt.GameLabel.new(lt.DataManager:getPlayer():getName(), 16, lt.Constants.DEFAULT_LABEL_COLOR_2)
    self._nameLabel:setAnchorPoint(0.5, 0)
    self._nameLabel:setPosition(nameBg:getContentSize().width / 2 + 10, 0)
    nameBg:addChild(self._nameLabel)

    --玩家血条
    local hpBg = display.newSprite("#city_img_hp_bg.png")
    hpBg:setAnchorPoint(0,1)
    hpBg:setPosition(74*self._winScale, nameBg:getPositionY() - nameBg:getContentSize().height)
    self:addChild(hpBg)

    self._hpBar = display.newProgressTimer("#city_img_hp_bar.png", 1)
    self._hpBar:setPosition(hpBg:getContentSize().width / 2, hpBg:getContentSize().height / 2)
    self._hpBar:setMidpoint(cc.p(0, 0))
    self._hpBar:setBarChangeRate(cc.p(1,0))
    self._hpBar:setPercentage(100)
    hpBg:addChild(self._hpBar)

    self._hpLabel = lt.GameBMLabel.new("0/0", "#fonts/ui_num_5_12.fnt")
    self._hpLabel:setPosition(72, hpBg:getContentSize().height / 2)
    self._hpLabel:setAdditionalKerning(-1)
    hpBg:addChild(self._hpLabel)

    local mpBg = display.newSprite("#city_img_mp_bg.png")
    mpBg:setAnchorPoint(0, 1)
    mpBg:setPosition(hpBg:getPositionX(), hpBg:getPositionY() - hpBg:getContentSize().height)
    self:addChild(mpBg)

    self._mpBar = display.newProgressTimer("#city_img_mp_bar.png", 1)
    self._mpBar:setPosition(mpBg:getContentSize().width / 2, mpBg:getContentSize().height / 2)
    self._mpBar:setMidpoint(cc.p(0, 0))
    self._mpBar:setBarChangeRate(cc.p(1, 0))
    self._mpBar:setPercentage(100)
    mpBg:addChild(self._mpBar)

    self._mpLabel = lt.GameBMLabel.new("0/0", "#fonts/ui_num_5_12.fnt")
    self._mpLabel:setPosition(72, mpBg:getContentSize().height / 2)
    self._mpLabel:setAdditionalKerning(-1)
    mpBg:addChild(self._mpLabel)

    -- Buff区域
    self._buffNode = display.newNode()
    self._buffNode:setPosition(80*self._winScale, mpBg:getPositionY() - 16* self._winScale)
    self:addChild(self._buffNode)

    self._buffDisplayArray = {}

    local buffBtn = lt.PushButton.new("image/ui/common/touch_rect_80.png", {scale9 = true, scale = self._winScale})
    buffBtn:setButtonSize(150, 60)
    buffBtn:setPosition((80 + 75) * self._winScale, mpBg:getPositionY() - (-10 + 30) * self._winScale)
    buffBtn:onButtonClicked(handler(self, self.onBuffList))
    self:addChild(buffBtn)

    self._servantBtn = lt.ScaleButton.new("#city_img_servent_bg.png")
    self._servantBtn:setPosition(269*self._winScale, display.top - 58*self._winScale)
    self._servantBtn:onButtonClicked(handler(self,self.onServant))
    self:addChild(self._servantBtn)

    self._servantImage = display.newSprite()
    self._servantImage:setScale(0.6)
    self._servantBtn:addChild(self._servantImage)

    self._servantLevelBg = display.newSprite("#city_img_servent_level_bg.png")
    self._servantLevelBg:setPosition(14, -16)
    self._servantBtn:addChild(self._servantLevelBg)

    self._servantLevel = lt.GameLabel.new("", 12, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
    self._servantLevel:setPosition(self._servantLevelBg:getContentSize().width / 2 + 2, self._servantLevelBg:getContentSize().height / 2)
    self._servantLevelBg:addChild(self._servantLevel)


    local battleServant = lt.DataManager:getBattleServant()

    -- local servantImg = nil
    
    -- -- if battleServant then
    -- --     servantImg = display.newSprite("#city_img_servant.png")
    -- -- else
    -- --     servantImg = display.newSprite("#city_img_servant.png")
    -- -- end

    -- servantBg:addChild(servantImg)

end

function WorldMenuLayer:updateInfo()
    -- 主角技能
    self:updateSkillInfo()

    self:setAutoBtn(true)

    -- 功能开启
    self:updateFunctionOpenNode()

    -- IphoneX适配
    self:iphoneXSupport()
end

function WorldMenuLayer:setAutoBtn(visible, temp)
    if visible then
        -- -- 等级大于5级/引导已经触发 开启自动战斗
        -- if lt.DataManager:getPlayerLevel() >= lt.Constants.GUIDE_AUTO_BATTLE_LEVEL and not lt.GuideManager:_checkSpecialGuide(lt.GuideInfo.SPECIAL_IDX.AUTO_BATTLE) then
        --     self._messageNode:setAutoBtnOn()
        -- else
        --     self._messageNode:setAutoBtnOff(temp)
        -- end

        self._messageNode:setAutoBtnOn()
    else
        self._messageNode:setAutoBtnOff(temp)
    end
end

-- 按钮按下
function WorldMenuLayer:buttonPressed(button)
    if not button then
        return
    end

    -- 缩放
    button:stopAllActions()
    button:runAction(cca.seq{cca.scaleTo(0.08, 0.9 * self._winScale)})
end

-- 按钮松开
function WorldMenuLayer:buttonRelease(button)
    if not button then
        return
    end

    -- 缩放
    button:stopAllActions()
    button:runAction(cca.seq{
            cca.scaleTo(0.08, 1.1 * self._winScale),
            cca.scaleTo(0.04, 1 * self._winScale),
        })
end

-- 按钮点击
function WorldMenuLayer:buttonClicked(button)
    if not button then
        return
    end

    -- 缩放
    button:stopAllActions()
    button:runAction(cca.seq{
            cca.scaleTo(0.08, 0.9 * self._winScale),
            cca.scaleTo(0.08, 1.1 * self._winScale),
            cca.scaleTo(0.04, 1 * self._winScale),
        })

end

-- 获得
function WorldMenuLayer:getControlButton()
    local controlButton = self._controlButton

    -- 非长按只能取一次
    if self._controlButton ~= lt.Constants.CONTROL_BUTTON_ATTACK_START then
        self._controlButton = lt.Constants.CONTROL_INVALID
    end

    return controlButton
end

-- ############################## 界面监听回调 ##############################


-- ############################## UI功能 ##############################
-- ##### 打开次级UI界面 隐藏当前界面 #####
function WorldMenuLayer:showWorldMenuLayer()
    self:setVisible(true)
end

function WorldMenuLayer:hideWorldMenuLayer()
    self:setVisible(false)
end

-- 清理战斗结果相关信息
function WorldMenuLayer:clearBattleResult(deep)
    self:clearGuardRewardLayer()
    self:clearTreasureResultLayer()
    self:clearBattleAllDead()
    self:clearCoinCountdown()
    self:clearRoundNode()
    self:clearFloorNode()
    self:clearDungeonElapse()
    self:clearBattleVictory()
    self:clearCrazyDoctorResultLayer()

    if deep then
        self:clearPKResultLayer()
        self:hideBossInfoNode()
    end
end


-- ##### 背包界面 #####
function WorldMenuLayer:onBag(params)
    params = params or {}
    if params.clearPre then
        self:clearBagLayer()
    end

    --打开背包的时候如果有快捷使用界面关闭界面
    lt.DataManager:clearNewItemArray()
    self:clearCommonGetItemLayer()

    self:getBagLayer():updateInfo(params)
end

function WorldMenuLayer:getBagLayer()
    if not self._bagLayer then
        self._bagLayer = lt.BagLayer.new(self)
        lt.UILayerManager:addLayer(self._bagLayer)
    end

    return self._bagLayer
end

function WorldMenuLayer:clearBagLayer()
    if self._bagLayer then
        lt.UILayerManager:removeLayer(self._bagLayer)
        self._bagLayer = nil
    end
end

-- ##### 扭蛋机界面 #####
function WorldMenuLayer:onEggRewardLayer(params)
    if not self._eggRewardLayer then
        self._eggRewardLayer = lt.EggRewardLayer.new(self, params)

        lt.UILayerManager:addLayer(self._eggRewardLayer,false,{noTop = true})
    end
end

function WorldMenuLayer:clearEggRewardLayer()
    if self._eggRewardLayer then
        lt.UILayerManager:removeLayer(self._eggRewardLayer)
        self._eggRewardLayer = nil
    end
end

return WorldMenuLayer
