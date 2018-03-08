--扭蛋机界面
local EggRewardLayer = class("EggRewardLayer", function()
    return display.newColorLayer(cc.c4b(0, 0, 0, 255))
end)

EggRewardLayer._winScale = math.min(lt.CacheManager:getWinScale(), display.size.width / display.size.height *  640 / 1136) 

--EggRewardLayer._winScale = display.size.width / display.size.height *  640 / 1136
--EggRewardLayer._winScale =  math.min(display.width / lt.Constants.BGWIDTH, display.height / lt.Constants.BGHEIGHT)

EggRewardLayer._bg = nil
EggRewardLayer._panelSize = cc.size(363,280)

EggRewardLayer._callback = nil
EggRewardLayer._delegate = nil

local colorMaskBackSize = {width = display.width + 450, height = display.height - 205}

local redMaskBackSize = {width = display.width + 450, height = display.height - 440}

local EGG_POOL_REFRESH_TYPE = {
                                OPEN_EGG_REFRESH = 0,
                                CLICK_BTN_REFRESH = 1,
                                SYSTEM_AUTO_REFRESH = 2,
                            }
local AUTO_TIME = 11
function EggRewardLayer:ctor(delegate, params)--params 用于其他界面跳转到扭蛋机界面 数据改变切回去的数据刷新
    --ui_battle_pvr/battle_result_bg.png
    self._delegate = delegate

    if params then
        self._params = params
    end

    --标题背景
    self._bg = display.newSprite("image/ui/egg_bg.jpg")
    self._bg:setScale(self._winScale)
    self._bg:setPosition(display.cx, display.cy)
    self:addChild(self._bg)

    self:setTouchEnabled(true)
    self:setNodeEventEnabled(true)
    self:setTouchSwallowEnabled(true)
    if not self._nodeMask then--出蛋时候的遮罩层
        self._nodeMask = display.newLayer()
        self._nodeMask:setTouchEnabled(true)
        self._nodeMask:setNodeEventEnabled(true)
        self._nodeMask:setTouchSwallowEnabled(true)
        self._nodeMask:setVisible(false)
        self:addChild(self._nodeMask, 110)

        --遮罩背景
        self.maskBack = display.newScale9Sprite("#egg_bg.png", 0, 0, cc.size(redMaskBackSize.width, redMaskBackSize.height)) 

        --setCapInsets(CCRectMake(0,0,571,26))
        --local maskBack = display.newSprite("#egg_bg.png")
        self.maskBack:setPosition(display.cx , display.cy)
        self.maskBack:setScale(self._winScale)
        self._nodeMask:addChild(self.maskBack)

        --遮罩上面上的描述
        self._maskDes1 = display.newSprite("#egg_lbl_chance.png")
        self._maskDes1:setPosition(colorMaskBackSize.width / 2, colorMaskBackSize.height - 40) 
        self.maskBack:addChild(self._maskDes1)

        self._maskDes2 = display.newSprite("#egg_lbl_congratulation.png")
        self._maskDes2:setPosition(redMaskBackSize.width / 2, redMaskBackSize.height - 40) 
        self.maskBack:addChild(self._maskDes2)

        self.timeLabel = lt.GameBMLabel.new("","#fonts/egg_font.fnt")
        self.timeLabel:setPosition(colorMaskBackSize.width / 2, colorMaskBackSize.height - 100)
        self.maskBack:addChild(self.timeLabel)
        self._maskDes1:setVisible(false)
        self._maskDes2:setVisible(false)
        self.timeLabel:setVisible(false)
        self.maskBack:setVisible(false)
    end

    --关闭按钮
    local closeBtn = lt.ScaleButton.new("#egg_btn_close.png", {scale = self._winScale})
    closeBtn:setPosition(self._bg:getContentSize().width - 45, self._bg:getContentSize().height - 35)
    closeBtn:onButtonClicked(handler(self, self.onClose))
    self._bg:addChild(closeBtn)
    --扭蛋按钮背景
    -- local circleBg = display.newSprite("#egg_btn_circle_bg.png")
    -- circleBg:setPosition(self._bg:getContentSize().width - 180,self._bg:getContentSize().height - 300)
    -- self._bg:addChild(circleBg)

    --扭蛋池值
    self._diamondPoolLabel = lt.GameBMLabel.new("","#fonts/egg_font.fnt")
    self._diamondPoolLabel:setAnchorPoint(0, 0.5)
    self._diamondPoolLabel:setScale(0.7)
    self._diamondPoolLabel:setPosition(self._bg:getContentSize().width - 355,self._bg:getContentSize().height - 35)
    self._bg:addChild(self._diamondPoolLabel)

    --剩余道具的总数
    self._allItemNumLabel = lt.GameBMLabel.new("","#fonts/egg_red_font.fnt")
    self._allItemNumLabel:setAnchorPoint(0, 1)
    self._allItemNumLabel:setPosition(240 , 620)
    self._bg:addChild(self._allItemNumLabel)

    --箭头
    -- local arrowIcon = display.newSprite("#egg_icon_arrow.png")
    -- arrowIcon:setPosition(self._bg:getContentSize().width - 350, self._bg:getContentSize().height - 290)
    -- self._bg:addChild(arrowIcon)

    --扭蛋机代币
    local eggInfo = lt.CacheManager:getItemInfo(lt.Constants.ITEM.EGG_COIN)
    if eggInfo then
        self.eggCoinIcon = lt.GameIcon.new()
        self.eggCoinIcon:setPosition(self._bg:getContentSize().width  - 305, self._bg:getContentSize().height - 450)
        self._bg:addChild(self.eggCoinIcon)
        self.eggCoinIcon:updateInfo(lt.GameIcon.TYPE.ITEM, lt.Constants.ITEM.EGG_COIN)
        self.eggCoinBtn = cc.ui.UIPushButton.new()
        self.eggCoinBtn:setPosition(self.eggCoinIcon:getContentSize().width/2,self.eggCoinIcon:getContentSize().height/2)
        self.eggCoinBtn:setContentSize(self.eggCoinIcon:getContentSize().width, self.eggCoinIcon:getContentSize().height)
        self.eggCoinBtn:setTag(lt.Constants.ITEM.EGG_COIN)
        self.eggCoinBtn:onButtonClicked(handler(self, self.onClickAddEggCoin))
        self.eggCoinIcon:addChild(self.eggCoinBtn)
    end
    local currentItemCount = lt.DataManager:getItemCount(lt.Constants.ITEM.EGG_COIN)
    self._eggCoinNumLable = lt.GameBMLabel.new("x"..currentItemCount,"#fonts/egg_font.fnt")
    self._eggCoinNumLable:setAnchorPoint(0, 0.5)
    self._eggCoinNumLable:setPosition(self._bg:getContentSize().width  - 250, self._bg:getContentSize().height - 470)
    self._bg:addChild(self._eggCoinNumLable)

    --扭蛋补充按钮
    self.refreshBtn = lt.ScaleButton.new("#common_btn_blue_new.png")
    self.refreshBtn:setPosition(150 , 53)
    self.refreshBtn:onButtonClicked(handler(self, self.eggRefresh))
    self._bg:addChild(self.refreshBtn)
    
    local desLabel = lt.GameLabel.new(lt.StringManager:getString("STRING_EGG_REFRESH_REWARD"),lt.Constants.FONT_SIZE4,lt.Constants.COLOR.WHITE,{outline = true, outlineColor = lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
    desLabel:setAnchorPoint(0.5, 0.5)
    desLabel:setPosition(self.refreshBtn:getContentSize().width / 2, self.refreshBtn:getContentSize().height / 2)
    self.refreshBtn:addChild(desLabel)

    --问号 
    local helpBtn = lt.ScaleButton.new("#common_btn_help.png")
    helpBtn:setPosition(250, 52)
    helpBtn:onButtonClicked(handler(self, self.eggHelp))
    self._bg:addChild(helpBtn)

    --奖励列表
    local listBgSize = cc.size(280, 500)

    self._eggListView = lt.ListView.new({
        viewRect  = cc.rect(0, 0, 265* self._winScale, 495 * self._winScale),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,})
    --self._eggListView:onTouch(handler(self, self.clickEggItem))
    self._eggListView:onTouch(function(event)
        if event.name ~= "clicked" then
            return
        end
        self:clickEggItem(event)
    end)

    self._contentNode = display.newNode()
    self._contentNode:setContentSize(280*self._winScale, 500 * self._winScale)
    self._contentNode:setAnchorPoint(0, 0)
    local worldPos = self.refreshBtn:getParent():convertToWorldSpace(cc.p(self.refreshBtn:getPosition()))
    self._contentNode:setPosition(worldPos.x - 126 * self._winScale, worldPos.y + 36 * self._winScale)

    self:addChild(self._contentNode)

    self._contentNode:addChild(self._eggListView)
    --self._eggListView:setAnchorPoint(0,0)
    self._eggListView:setPosition(0, 0)
    self:updateEggList()

    --特效背景
    local effectBgName = "ui_effect_thomas_bf"
    local armatureBgFile = "effect/ui/"..effectBgName..".ExportJson"

    if not lt.ResourceManager:isArmatureLoaded(effectBgName) then
        lt.ResourceManager:addArmature(effectBgName, armatureBgFile)
    end

    self._effectBg1 = ccs.Armature:create(effectBgName)--背景 常驻特效 滚动的文字 0
    self._effectBg1:getAnimation():playWithIndex(0)
    self._effectBg1:setPosition(self._bg:getContentSize().width / 2 - 24, self._bg:getContentSize().height / 2)
    self._bg:addChild(self._effectBg1)     

    self._effectBg2 = ccs.Armature:create(effectBgName)--背景 未点击时的常驻特效 1  点击时 2
    self._effectBg2:setPosition(self._bg:getContentSize().width / 2 - 24, self._bg:getContentSize().height / 2)
    self._bg:addChild(self._effectBg2)     

    self._effectBg3 = ccs.Armature:create(effectBgName)--点击时特效  可以点击时等待阶段3 先播放4再向服务器requst 数据回来再5
    self._effectBg3:setPosition(self._bg:getContentSize().width / 2 - 24, self._bg:getContentSize().height / 2)
    self._bg:addChild(self._effectBg3)     

    --扭蛋按钮 egg_btn_circle_bg
    local eggBtn = lt.PushButton.new("image/ui/common/touch_rect_80.png")
    eggBtn:setButtonSize(145, 145)
    eggBtn:setPosition(self._bg:getContentSize().width - 225, self._bg:getContentSize().height - 300)
    eggBtn:onButtonClicked(handler(self, self.eggStart))
    self._bg:addChild(eggBtn)

    --替换图片
    local replaceBg = display.newSprite("image/ui/egg_replace_bg.png")
    replaceBg:setPosition(530, 415)
    self._bg:addChild(replaceBg)

    --奖池面板
    local eggPollBtn = lt.PushButton.new("image/ui/common/touch_rect_80.png", {scale9 = true, scale = self._winScale})
    eggPollBtn:setButtonSize(660, 50)
    eggPollBtn:onButtonClicked(handler(self, self.onClickEggPool))
    eggPollBtn:setPosition(self._bg:getContentSize().width / 2 + 93, display.height - 30)
    self._bg:addChild(eggPollBtn)
    self._rewardPoolPanel = display.newLayer()
    self._rewardPoolPanel:setTouchEnabled(true)
    self._rewardPoolPanel:setNodeEventEnabled(true)
    self._rewardPoolPanel:setTouchSwallowEnabled(true)
    self._rewardPoolPanel:setVisible(false)
    self:addChild(self._rewardPoolPanel)
    local worldPos = eggPollBtn:getParent():convertToWorldSpace(cc.p(eggPollBtn:getPosition()))
    local poolBg = display.newSprite("#egg_pool_bg2.png")--背景板
    poolBg:setAnchorPoint(0.5, 1)
    poolBg:setScale(self._winScale)
    poolBg:setPosition(self._rewardPoolPanel:getContentSize().width / 2, worldPos.y - 25 * self._winScale)
    self._rewardPoolPanel:addChild(poolBg)

    local poolTitleBg = display.newSprite("#egg_pool_bg1.png")
    poolTitleBg:setPosition(poolBg:getContentSize().width / 2, poolBg:getContentSize().height  - 30)
    poolBg:addChild(poolTitleBg)

    local poolTitle = display.newSprite("#egg_pool_title.png")
    poolTitle:setPosition(poolBg:getContentSize().width / 2, poolBg:getContentSize().height  - 30)
    poolBg:addChild(poolTitle)


    local poolTitleBg = display.newSprite("#egg_pool_value.png")
    poolTitleBg:setPosition(poolBg:getContentSize().width / 2, poolBg:getContentSize().height  - 70)
    poolBg:addChild(poolTitleBg)


    local propertyBg = lt.GameInfoBg.new(lt.GameInfoBg.TYPE.GAME_INFO_BG_TYPE_15, cc.size(270, 30), 0, 0)
    propertyBg:setAnchorPoint(0.5, 1)
    propertyBg:setPosition(poolBg:getContentSize().width / 2, poolBg:getContentSize().height - 100)
    poolBg:addChild(propertyBg)

    self.poolVelueLabel = lt.GameBMLabel.new("","#fonts/egg_font.fnt")
    self.poolVelueLabel:setAnchorPoint(0, 0.5)
    self.poolVelueLabel:setScale(0.5)
    self.poolVelueLabel:setPosition(107, propertyBg:getContentSize().height / 2 - 2)
    propertyBg:addChild(self.poolVelueLabel)

    local diamondIcon = display.newSprite("#common_diamond.png")
    diamondIcon:setScale(0.8)
    diamondIcon:setPosition(80, propertyBg:getContentSize().height / 2)
    propertyBg:addChild(diamondIcon)

    local newNameTitle = lt.GameLabel.new(lt.StringManager:getString("STRING_EGG_GAIN_NAME"),lt.Constants.FONT_SIZE4,lt.Constants.COLOR.WHITE,{outline = true, outlineColor = lt.Constants.COLOR.BLACK})
    newNameTitle:setAnchorPoint(0.5, 0.5)
    newNameTitle:setPosition(poolBg:getContentSize().width / 2, poolBg:getContentSize().height / 2)
    poolBg:addChild(newNameTitle)
    self._gain_reward_name = {}
    for i=1,3 do
        local nameLabel = lt.GameLabel.new("",lt.Constants.FONT_SIZE4,lt.Constants.COLOR.BLACK,{outline = false, outlineColor = lt.Constants.COLOR.BLACK})
        nameLabel:setAnchorPoint(0, 0.5)
        nameLabel:setPosition(20, 120 - (i -1) * 40)
        poolBg:addChild(nameLabel)

        local diamondIcon = display.newSprite("#common_diamond.png")
        diamondIcon:setScale(0.8)
        diamondIcon:setPosition(190, 120 - (i -1) * 40)
        poolBg:addChild(diamondIcon)

        local valueLabel = lt.GameLabel.new("",lt.Constants.FONT_SIZE4,lt.Constants.COLOR.BLACK,{outline = false, outlineColor = lt.Constants.COLOR.BLACK})
        valueLabel:setAnchorPoint(0, 0.5)
        valueLabel:setPosition(220, 120 - (i -1) * 40)
        poolBg:addChild(valueLabel)
        self._gain_reward_name[i] = {name = nameLabel, value = valueLabel}
    end
    --self:clickEggItem()
    --扭蛋里面的icon
    self._itemIconList = {}
    self._eggArray = {}
    self._openState = true

    local value = lt.DataManager:getEggDiamond().newValue
    self._diamondPoolLabel:setString(value)
    self:refreshEggCoinAdd()
    self:refreshBgEffect()
end

function EggRewardLayer:updateTime(maxTime)
    self.timeLabel:setVisible(true)
    local  time = lt.CommonUtil:getCurrentTime() + maxTime
    if self._updateHandler then
        lt.scheduler.unscheduleGlobal(self._updateHandler)
        self._updateHandler = nil
    end

    local currentTime = lt.CommonUtil:getCurrentTime()

    local deltaTime = time - currentTime
    
    if time > 0 then
        if deltaTime > 0 then
            -- 开启倒计时
            self._timeValue = deltaTime
            self._updateHandler = lt.scheduler.scheduleUpdateGlobal(handler(self, self.onUpdate))
        else

        end
    end
end

function EggRewardLayer:onUpdate(delta)
    if self.is_color_egg == 0 then
        if self._updateHandler then
            lt.scheduler.unscheduleGlobal(self._updateHandler)
            self._updateHandler = nil
        end
        return
    end

    self._timeValue = self._timeValue - delta

    if self._timeValue <= 0 then
        if self._updateHandler then
            lt.scheduler.unscheduleGlobal(self._updateHandler)
            self._updateHandler = nil
        end

        -- 倒计时结束
        if self.isSelect then
            return
        else
            self:eggOpenClick()--随机一个蛋
        end
        return
    end

    -- 倒计时显示
    local tm = os.date("!*t", self._timeValue)
    local str = ""
    if tm.sec < 10 then
        str = "0"..tm.sec
    else
        str = tm.sec
    end
    self.timeLabel:setString(str)
    --self.timeLabel:setString(lt.CommonUtil:getFormatCountDown(self._timeValue, 10))
end

function EggRewardLayer:clearTipsItem()
    if self._tipsItem then
        lt.UILayerManager:removeLayer(self._tipsItem)
        self._tipsItem = nil
    end
end

function EggRewardLayer:clickEggItem(event)
    for k,v in pairs(self._iconArray) do
        local worldPos = v:getParent():convertToWorldSpace(cc.p(v:getPosition()))
        local worldRect = cc.rect(worldPos.x, worldPos.y, 80 * self._winScale, 80 * self._winScale)
        local pos = event.item:convertToWorldSpace(cc.p(event.point.x, event.point.y))
        if cc.rectContainsPoint(worldRect, pos) then
            if v:getModelId() > 0 and v:getItemType() == lt.GameIcon.TYPE.ITEM then
                local height = 420

                local itemType = v:getItemType()
                local itemModelId = v:getModelId()
                self._tipsItem = lt.TipsItem.new(self)
                lt.UILayerManager:addLayer(self._tipsItem, true)
                self._tipsItem:setMaskLayerEnabled(true)
                self._tipsItem:updateInfo(lt.TipsItem.TYPE.ITEM, itemModelId)
                --local itemSize = self._tipsItem:getContentSize()
                --self._tipsItem:setPosition(itemSize.width-300,height/2-itemSize.height/2)
                break
            end
        end
    end

    -- local allItems = self._eggListView:getAllChildren()

    -- if not id then
    --     -- 遍历ListView所有的Item 
    --     for _, tempItem in ipairs(allItems) do
    --         if tempItem == self._eggListView:getItemByPos(1) then
    --             -- 显示选中
    --             self._selectItem = tempItem
    --             tempItem:getContent():setSelected(true)
    --         else
    --             -- 隐藏选中
    --             tempItem:getContent():setSelected(false)
    --         end
    --     end

    --     return
    -- end

    -- -- 遍历ListView所有的Item 
    -- for _, tempItem in ipairs(allItems) do
    --     local itemId = tempItem:getContent().info:getItemId()
    --     if itemId == id then
    --       -- 显示选中

    --       tempItem:getContent():setSelected(true)
    --     else
    --       -- 隐藏选中
    --       tempItem:getContent():setSelected(false)
    --     end
    -- end

end

function EggRewardLayer:updateEggList(refresh, refreshType)
    self._eggListView:removeAllItems()
    self._iconArray = {}
    local eggArray = lt.DataManager:getEggArray()

    local eggInfoTable = lt.CacheManager:getEggRewardTable()
    local eggInfoArray = lt.CommonUtil:getArrayFromTable(eggInfoTable)
    table.sort(eggInfoArray, function(info1, info2)
        if info1._category < info2._category then
            return true
        end
    end)
    local newItemList = {}
    local index = 0
    for i = 1, #eggInfoArray do--将奖励类型一样的筛选出来
        local isSame = false
        local eggInfo = eggInfoArray[i]
        -- if #newItemList <= 0 then
        --   newItemList[i] = eggInfo
        -- end

        for k,item in ipairs(newItemList) do
            if eggInfo:getCategory() == item:getCategory() then
                isSame = true
                item._costNum = (item._costNum or 1) + 1
                for i,v in ipairs(eggArray) do
                    if eggInfo:getId() == v then --为妞过的序号
                        item._costNum = item._costNum - 1
                        if item._costNum <= 0 then
                            item._costNum = 0
                        end
                    end
                end
            end  
        end
        if not isSame then
            eggInfo._costNum = 1
            --eggInfo._idArray = 
            index = index + 1
            newItemList[index] = eggInfo
            for i,v in ipairs(eggArray) do
                if eggInfo:getId() == v then --为妞过的序号
                    eggInfo._costNum = eggInfo._costNum - 1
                    if eggInfo._costNum <= 0 then
                        eggInfo._costNum = 0
                    end
                end
            end
        end
    end

    for row = 1, #newItemList + 1 do
        local eggInfo = nil
        if row == 1 then
            local colorEggInfo = lt.CacheManager:getItemInfo(648)
            colorEggInfo._costNum = 1
            for i,v in ipairs(eggArray) do
                if v == 20 then
                    colorEggInfo._costNum = 0
                end
            end

            colorEggInfo._index = 20
            
            colorEggInfo.getCategory = function (  )
                return 0
            end
            colorEggInfo.getId = function (  )
                return 20
            end
            colorEggInfo.getItemType = function (  )
                return 1
            end
            colorEggInfo.getItemId = function (  )
                return 648
            end

            colorEggInfo.getCount = function (  )
                return 1
            end
            eggInfo = colorEggInfo
        else
            eggInfo = newItemList[row - 1]
        end

        local content = lt.EggRewardCell.new()
        content:setScale(self._winScale)
        content:updateInfo(row, eggInfo)
        --content.info = eggInfo
        local itemIcon = content._infoNode:getChildByTag(100)
        local item = self._eggListView:newItem(content)
        item:setItemSize(270 *self._winScale, 110 * self._winScale + (self._winScale - 1) * 25)

        item:setTag(eggInfo:getItemId())
        self._eggListView:addItem(item)
        self._iconArray[#self._iconArray + 1] = itemIcon
    end
    local allEggItem = #eggInfoArray - #eggArray + 1
    self._allItemNumLabel:setString(allEggItem)

    self._eggListView:reload(refresh)

    if not refreshType then
        return
    end
    if refreshType == EGG_POOL_REFRESH_TYPE.CLICK_BTN_REFRESH then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_EGG_REFRESH_TIPS_3"))
    elseif refreshType == EGG_POOL_REFRESH_TYPE.SYSTEM_AUTO_REFRESH then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_EGG_REFRESH_TIPS_2"))
    end
end

function EggRewardLayer:eggStart()--点击旋转按钮

    local itemInfo = lt.CacheManager:getItemInfo(lt.Constants.ITEM.EGG_COIN)
    if not itemInfo then
        return
    end

    local currentItemCount = lt.DataManager:getItemCount(lt.Constants.ITEM.EGG_COIN)
    if currentItemCount <= 0 then
        local accessMethodInfo = itemInfo:getAccessMethod()
        local shopIdArray = accessMethodInfo["shop"] or {}
        self._delegate:onQuickShopBuy({shopArray = shopIdArray, modelId = lt.Constants.ITEM.EGG_COIN, refreshLayer = self, flag = 1})
        --lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_ITEM_LIMIT"))
        return
    end

    if lt.DataManager:checkBagFree() then
        -- 提示
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_SHOPCLUB_BAG_MAX_CANT_MAKE"))
        return
    end
    self._nodeMask:setVisible(true)--显示遮罩
    self._effectBg2:getAnimation():playWithIndex(2)
    ---音效
    local soundName = "ui/audio_turn_egg_clicked"
    lt.AudioManager:playSound(soundName)

    lt.SocketApi:eggStart()
    self._effectBg3:getAnimation():playWithIndex(4)
    self._effectBg3:getAnimation():setMovementEventCallFunc(function(armature, movementType, movementId)
            if movementId == "keyon0" and (movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete) then--播放前半段
                
            elseif movementId == "keyon1" and (movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete) then--播放后半段
                self:eggEffectPlay()--处理蛋的特效
            end  
        end)
end

function EggRewardLayer:onEggStart(event)--扭蛋数据
    local scEggStart = event.data
    if scEggStart.code ~= lt.SocketConstants.CODE_OK then
        self._nodeMask:setVisible(false)
        return
    end
    self:refreshEggCoinAdd()
    self.modelId = nil
    self.itemType = nil
    self.count = 0
    self.is_color_egg = nil
    self.is_color_egg = scEggStart.is_color_egg
    local itemArray = scEggStart.gain_item_array

    if self.is_color_egg ~= 1 then --不是彩蛋
        for i,item in ipairs(itemArray) do
            -- lt.NoticeManager:addGainItemMessage(type, modelId, count)
            self.itemType = item.type
            self.modelId = item.model_id
            self.count = item.count
        end

        if self._params and self._params.flag and self._params.itemModelId == self.modelId then
        --if self._params and self._params.itemModelId == self.modelId and self._params.refreshLayer then--刷新跳转到扭蛋机的界面
            --self._params.refreshLayer:onRefreshItem(self._params.flag)
            lt.GameEventManager:post(lt.GameEventManager.EVENT.SHOP_CLUB_ITEM_REFRESH, {flag = self._params.flag})
        end
    end

    -- self.is_color_egg = 1
    -- self.modelId = lt.Constants.ITEM.DIAMOND

    -- local eggInfo = lt.CacheManager:getItemInfo(self.modelId)
    -- if not eggInfo then
    --     self._nodeMask:setVisible(false)
    --     return
    -- end

    self._effectBg3:getAnimation():playWithIndex(5)--播放另一半
end

function EggRewardLayer:chatSystem()--获得的物品在系统广播
    local chatInfo = lt.Chat.new()
    chatInfo:setChannel(lt.Constants.CHAT_TYPE.SYSTEM)
    chatInfo:setSenderName("system")
    chatInfo:setSendTime(lt.CommonUtil:getCurrentTime())
    chatInfo:setMessage("")
    local subContent = {}
    
    subContent["item_type"] = self.itemType
    subContent["model_id"] = self.modelId
    subContent["size"] = self.count
    chatInfo:setSubContent(json.encode(subContent))
    chatInfo:setSubType(lt.Constants.CHAT_SUB_TYPE.GET_ITEM)
    lt.DataManager:addSystemChatInfo(chatInfo)
    lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_SYSTEM,{chatInfo=chatInfo})
end

function EggRewardLayer:eggEffectPlay()--扭蛋的特效处理
    self._effectBg3:getAnimation():playWithIndex(6)
    self._openState = true--彩蛋是否打开了 遮罩的显示
    self.isSelect = false--彩蛋是否被选择了 倒计时
    local eggInfo = lt.CacheManager:getItemInfo(self.modelId)
    local effectName = nil
    if self.is_color_egg  == 0 then --0是红蛋，1是彩蛋
        effectName = "ui_effect_thomas_red_egg"
    else
        effectName = "ui_effect_thomas_color_egg"
    end

    local armatureFile = "effect/ui/"..effectName..".ExportJson"

    if not lt.ResourceManager:isArmatureLoaded(effectName) then
        lt.ResourceManager:addArmature(effectName, armatureFile)
    end

    if self.is_color_egg  == 0 then
        self._nodeMask:setLocalZOrder(300)--红蛋时遮罩层级在蛋的上面
        --colorMaskBackSize
        self.maskBack:setCapInsets(cc.size(0, 0, redMaskBackSize.width, redMaskBackSize.height))
        self.maskBack:setContentSize(cc.size(redMaskBackSize.width, redMaskBackSize.height))
        self._eggArray = {}
        local redEgg = ccs.Armature:create(effectName)
        redEgg:getAnimation():playWithIndex(0)
        
        redEgg:getAnimation():setMovementEventCallFunc(function(armature, movementType, movementId)
            if movementId == "redeggout" and (movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete) then
                --音效
                local soundName = "ui/audio_egg_opening"
                lt.AudioManager:playSound(soundName)
                self.isSelect = true
                self.maskBack:setVisible(true)
                self._maskDes1:setVisible(false)
                self._maskDes2:setVisible(true)
                self.timeLabel:setVisible(false)
                local shopIcon = lt.GameIcon.new()
                shopIcon:setAnchorPoint(0.5 ,0.5)
                shopIcon:setPosition(redMaskBackSize.width / 2, redMaskBackSize.height / 2)--display.cx, display.cy
                self.maskBack:addChild(shopIcon,100)--加在遮罩上
                if self.modelId then
                    shopIcon:updateInfo(lt.GameIcon.TYPE.ITEM, self.modelId)
                    --shopIcon:setCount(self.count)
                end
                table.insert(self._itemIconList, shopIcon)

                local nameLabel = lt.GameLabel.new(eggInfo:getName().."x"..self.count, lt.Constants.FONT_SIZE4,lt.Constants.COLOR.WHITE,{outline = true, outlineColor = lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
                nameLabel:setPosition(redMaskBackSize.width / 2, redMaskBackSize.height / 2 - 60)
                self.maskBack:addChild(nameLabel)
                table.insert(self._itemIconList, nameLabel)

                lt.NoticeManager:addGainItemMessage(self.itemType, self.modelId, self.count)
                self._openState = false
            end
        end)
        redEgg:setPosition(display.cx, display.cy)
        redEgg:setScale(self._winScale)
        self:addChild(redEgg, 200)

        local whiteLight = ccs.Armature:create(effectName)
        whiteLight:getAnimation():playWithIndex(1)
        whiteLight:setPosition(display.cx, display.cy)
        whiteLight:setScale(self._winScale)
        self:addChild(whiteLight, 400)--在遮罩物品的上面
        self._eggArray[#self._eggArray + 1] = redEgg
        self._eggArray[#self._eggArray + 1] = whiteLight
    else
        self._eggArray = {}
        local colorEgg_1 = ccs.Armature:create(effectName)
        colorEgg_1:setPosition(display.cx, display.cy)
        colorEgg_1:setScale(self._winScale)
        colorEgg_1:getAnimation():playWithIndex(0)
        colorEgg_1:getAnimation():setMovementEventCallFunc(function(armature, movementType, movementId)
            if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
                armature:removeFromParent()
                self._nodeMask:setLocalZOrder(110)--彩蛋时遮罩层级在蛋的下面
                --colorMaskBackSize
                self.maskBack:setCapInsets(cc.size(0, 0, colorMaskBackSize.width, colorMaskBackSize.height))
                self.maskBack:setContentSize(cc.size(colorMaskBackSize.width, colorMaskBackSize.height))
                self.maskBack:setVisible(true)
                self._maskDes1:setVisible(true)
                self._maskDes2:setVisible(false)
                self.timeLabel:setVisible(true)
                self:updateTime(AUTO_TIME)--倒计时开始计时
                for i = 1, 3 do
                    local colorEggeffect = ccs.Armature:create(effectName)
                    colorEggeffect:setPosition(display.cx + (i - 2)*260, display.cy - 35)
                    colorEggeffect:setScale(self._winScale)
                    colorEggeffect:getAnimation():playWithIndex(1)
                    self:addChild(colorEggeffect, 200)

                    local eggBtn = lt.PushButton.new("image/ui/common/touch_rect_80.png", {scale9 = true, scale = self._winScale})
                    eggBtn:setButtonSize(155, 205)
                    eggBtn:setTag(i)
                    eggBtn:onButtonClicked(handler(self, self.eggOpenClick))
                    colorEggeffect:addChild(eggBtn)

                    self._eggArray[#self._eggArray + 1] = colorEggeffect
                end
            end
        end)
        self:addChild(colorEgg_1, 200)
    end                
end

function EggRewardLayer:eggOpenClick(event)--彩蛋的点击处理
    if not self.is_color_egg or self.is_color_egg == 0 then
        return
    end
    if self.isSelect then
        return
    end
    self.isSelect = true
    
    if event then--点击性的选择
        self._selectEggTag = event.target:getTag()
    end

    --发送获取彩蛋奖励的消息
    lt.SocketApi:eggGetReward()
end

function EggRewardLayer:onEggGetReward(event)--彩蛋的奖励信息
    local scEggReward = event.data
    if scEggReward.code ~= lt.SocketConstants.CODE_OK then
        self._nodeMask:setVisible(false)
        return
    end
    local itemArray = scEggReward.gain_item_array
    for i,item in ipairs(itemArray) do
        -- lt.NoticeManager:addGainItemMessage(type, modelId, count)
        self.itemType = item.type
        self.modelId = item.model_id
        self.count = item.count
    end

    if self.modelId == lt.Constants.ITEM.DIAMOND then
        self._currentGainValue = lt.DataManager:getEggDiamond().oldValue--起暂时不改变奖池的作用
    end
    self:refreshEggPool()

    -- if self._params and self._params.itemModelId == self.modelId and self._params.refreshLayer then--刷新跳转到扭蛋机的界面
    --     self._params.refreshLayer:onRefreshItem(self._params.flag)
    -- end

    self:openColorEgge()--开彩蛋
end

function EggRewardLayer:openColorEgge( )
    local tag = 1
    if self._selectEggTag then--点击性的
        tag = self._selectEggTag
    else
        tag = math.random(1, 3)
    end
    local random = nil
    local colorRewardList = lt.CacheManager:getEggColorRewardTable()
    local function randomTag( )
        random = math.random(1, 3)
        if colorRewardList[random]:getItemId() == self.modelId then
            randomTag()
        end
    end
    randomTag()--随机值
    local randomPosition = false--是否随机了位置
    local position = {}
    for m = 1,3 do 
        position[m] = { x = display.cx - (2 - m) * 260, y = display.height - 360}
    end

    for i = 1, 3 do
        if i == tag then
            --音效
            local soundName = "ui/audio_egg_opening"
            lt.AudioManager:playSound(soundName)
            self._eggArray[i]:getAnimation():playWithIndex(2)
            self._eggArray[i]:getAnimation():setMovementEventCallFunc(function(armature, movementType, movementId)
                if movementId == "coloreggopen" and (movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete) then

                    --显示
                    -- self._maskDes1:setVisible(false)
                    -- self._maskDes2:setVisible(true)
                    self.timeLabel:setVisible(false)
                    local shopIcon = lt.GameIcon.new()
                    shopIcon:setAnchorPoint(0.5 ,0.5)
                    shopIcon:setPosition(position[i].x, position[i].y)--display.cx, display.cy
                    self:addChild(shopIcon,400)
                    if self.modelId then
                        shopIcon:updateInfo(lt.GameIcon.TYPE.ITEM, self.modelId)
                        --shopIcon:setCount(self.count)
                    end
                    table.insert(self._itemIconList, shopIcon)

                    local eggInfo = lt.CacheManager:getItemInfo(self.modelId)
                    local namStr = eggInfo:getName().."x"..self.count
                    if self.modelId == lt.Constants.ITEM.DIAMOND then
                        self.count = lt.DataManager:getEggDiamond().oldValue
                        namStr = eggInfo:getName()
                    end

                    local nameLabel = lt.GameLabel.new(namStr, lt.Constants.FONT_SIZE4,lt.Constants.COLOR.WHITE,{outline = true, outlineColor = lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
                    nameLabel:setPosition(position[i].x, position[i].y - 130 * self._winScale)
                    self:addChild(nameLabel, 400)
                    table.insert(self._itemIconList, nameLabel)
                    --if self.modelId ~= lt.Constants.ITEM.Z_CURRENCY then
                    lt.NoticeManager:addGainItemMessage(self.itemType, self.modelId, self.count)--飘字
                    --end
                    
                    for j = 1 , 3 do
                        if j ~= tag then
                            self._eggArray[j]:runAction(
                                cca.seq{
                                    cca.delay(2),
                                    cca.cb(function ( )
                                        --音效
                                        local soundName = "ui/audio_egg_opening"
                                        lt.AudioManager:playSound(soundName)
                                        self._eggArray[j]:getAnimation():playWithIndex(2)
                                    end)
                                })
                        end
                    end
                end
            end)
        else
            self._eggArray[i]:getAnimation():setMovementEventCallFunc(function(armature, movementType, movementId)
                if movementId == "coloreggopen" and (movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete) then
                    --显示
                    local info = nil
                    lt.CommonUtil.print("GainEggRandomIndex____", random)
                    if not randomPosition then--随机了一个奖励
                        randomPosition = true
                        info = colorRewardList[random]
                    else
                        local selectIndex = nil
                        for index,itemInfo in ipairs(colorRewardList) do
                            if itemInfo:getItemId() == self.modelId then
                                selectIndex = index
                            end
                        end
                        info = colorRewardList[6 - selectIndex - random]
                    end
                    
                    local shopIcon = lt.GameIcon.new()
                    shopIcon:setAnchorPoint(0.5 ,0.5)
                                      
                    shopIcon:setPosition(position[i].x, position[i].y)
                    self:addChild(shopIcon, 400)
                    if info:getItemId() then
                        shopIcon:updateInfo(lt.GameIcon.TYPE.ITEM, info:getItemId())
                        --shopIcon:setCount(info.count)
                    end
                    shopIcon:setGray(true) 
                    table.insert(self._itemIconList, shopIcon)

                    local count = info:getCount()
                    local namStr = info:getName().."x"..count
                    if not count or count == 0 then
                        count = lt.DataManager:getEggDiamond().newValue
                        namStr = info:getName()
                    end

                    local nameLabel = lt.GameLabel.new(namStr, lt.Constants.FONT_SIZE4,lt.Constants.COLOR.WHITE,{outline = true, outlineColor = lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
                    nameLabel:setPosition(position[i].x, position[i].y - 130 * self._winScale)
                    self:addChild(nameLabel, 400)
                    table.insert(self._itemIconList, nameLabel)

                    self._openState = false
                end
            end)
        end
    end
end

function EggRewardLayer:onMaskTouch(event)
    --event.targe
    if self._openState == true then
        return
    end

    if not self._eggArray or not self._itemIconList then
        return
    end

    self._openState = true
    for i,v in pairs(self._itemIconList) do
        v:removeFromParent()
    end
    for i,v in pairs(self._eggArray) do--清除蛋的特效
        v:removeFromParent()
    end

    self._itemIconList = {}
    self._eggArray = {}
    self.maskBack:setVisible(false)
    self._nodeMask:setVisible(false)
    self._maskDes1:setVisible(false)
    self._maskDes2:setVisible(false)
    self.timeLabel:setVisible(false)
    local eggArray = lt.DataManager:getEggArray()
    if #eggArray <=0  then
        self:updateEggList(true, EGG_POOL_REFRESH_TYPE.SYSTEM_AUTO_REFRESH)
    else
        self:updateEggList(true)
    end

    local value = lt.DataManager:getEggDiamond().newValue
    self._diamondPoolLabel:setString(value)
    self:refreshBgEffect()
    --self:chatSystem()
    self.modelId = nil
    self.itemType = nil
    self.is_color_egg = nil
    self._currentGainValue = nil--获得钻石大奖时的奖池值
    self._selectEggTag = nil
    self:refreshEggPool()
end

function EggRewardLayer:onEggRefresh(event)
    self:updateEggList(false, EGG_POOL_REFRESH_TYPE.CLICK_BTN_REFRESH)
end

function EggRewardLayer:refreshEggPool()--如果中大奖保存大奖的数量，当玩家关闭开蛋界面在用最新值,待扭蛋数据赋值之后再刷
    self:runAction(
        cca.seq{
            cca.delay(0.1),
            cca.cb(function ( )
                    if self.is_color_egg == 1 and self.modelId == lt.Constants.ITEM.DIAMOND then
                        self._diamondPoolLabel:setString(self._currentGainValue)
                    else
                        local value = lt.DataManager:getEggDiamond().newValue
                        self._diamondPoolLabel:setString(value)
                    end
            end)
        })
end

function EggRewardLayer:refreshBgEffect()
    local currentItemCount = lt.DataManager:getItemCount(lt.Constants.ITEM.EGG_COIN)
    if currentItemCount <= 0 then
        self._effectBg3:getAnimation():playWithIndex(6)
    else
        self._effectBg3:getAnimation():playWithIndex(3)
    end
    self._effectBg2:getAnimation():playWithIndex(1)
end

function EggRewardLayer:refreshEggCoinAdd()
    local currentItemCount = lt.DataManager:getItemCount(lt.Constants.ITEM.EGG_COIN)
    self._eggCoinNumLable:setString("x"..currentItemCount)
    if currentItemCount <= 0 then
        self.eggCoinIcon:setAdded()
    else
        self.eggCoinIcon:setUnAdded()
    end
end

function EggRewardLayer:onShopClubItemRefresh()
    self:onRefreshItem()
end

function EggRewardLayer:onRefreshItem()--通用的获取途径中购买回调刷新
    self:refreshBgEffect()
    self:refreshEggCoinAdd()
end

function EggRewardLayer:onClickEggPool()--点击奖池查看获奖名单
    lt.SocketApi:getEggRewardLogList()
end

function EggRewardLayer:onEggRewardLogList(event)--最近获得最是大奖的名单
    local scEggRewardLogList = event.data --egg_reward_log_array
    self._rewardPoolPanel:setVisible(true)
    local value = lt.DataManager:getEggDiamond().newValue
    self.poolVelueLabel:setString(value)
    for i=1,3 do 
        self._gain_reward_name[i].name:setString(lt.StringManager:getString("STRING_EGG_GAIN_NAME_NONE"))
        self._gain_reward_name[i].value:setString(0)
    end

    if not scEggRewardLogList then
    else
        table.sort(scEggRewardLogList.egg_reward_log_array,function(a, b)
            return a.update_time > b.update_time
        end)
        local index = 0
        for _,playerInfo in ipairs(scEggRewardLogList.egg_reward_log_array) do
            index = index + 1
            self._gain_reward_name[index].name:setString(playerInfo.player_name)
            self._gain_reward_name[index].value:setString(playerInfo.diamond)
        end
    end
end

function EggRewardLayer:eggRefresh()
    local eggArray = lt.DataManager:getEggArray()
    -- local eggInfoTable = lt.CacheManager:getEggRewardTable()

    -- local eggInfoArray = lt.CommonUtil:getArrayFromTable(eggInfoTable)
    if #eggArray <= 0 then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_EGG_REFRESH_TIPS_1"))
        return
    end

    local stringInfo = lt.StringManager:getString("STRING_EGG_REFRESH_TIPS_4")

    local isSureLayer = lt.CommonCommitLayer.new(function()
        lt.SocketApi:eggRefresh()
    end, nil, nil)
    isSureLayer:setMessage(stringInfo)
    lt.UILayerManager:addLayer(isSureLayer, true)
end

function EggRewardLayer:onClickAddEggCoin(event)
    local id = event.target:getTag()
    self._delegate:onItemAccessMethod({itemId = id, refreshLayer = self, flag = 1})
end

function EggRewardLayer:eggHelp()--

	-- local tipsLayer = lt.CommonTipsLayer.new()
	-- local helpStr = ""
 --    for i=1,7 do
 --        helpStr = helpStr..lt.StringManager:getString("STRING_EGG_HELP_TIPS"..i).."\n\n"
 --    end
 --    tipsLayer:setWidth(380)--280--220
 --    tipsLayer:setLableWidth(320)
 --    tipsLayer:addString(helpStr):show()
 --    tipsLayer:setOffset(300, 200)	
    local helpTipsLayer = lt.EggPlayHelp.new(lt.EggPlayHelp.HELPTYPE.EggHELP)
    lt.UILayerManager:addLayer(helpTipsLayer, true)
end

function EggRewardLayer:onPoolPanelTouch()--
    self._rewardPoolPanel:setVisible(false)
end

function EggRewardLayer:onClose()
    if self._delegate then
        self._delegate:clearEggRewardLayer()
    end
end

function EggRewardLayer:onEnter()
    self._nodeMask:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onMaskTouch))
    self._rewardPoolPanel:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onPoolPanelTouch))
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_EGG_START, handler(self, self.onEggStart), "EggRewardLayer:onEggStart")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_EGG_REFRESH, handler(self, self.onEggRefresh), "EggRewardLayer:onEggRefresh")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_EGG_REWARD_LOG_LIST, handler(self, self.onEggRewardLogList), "EggRewardLayer:onEggRewardLogList")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PLAYER_EGG_POOL_REFRESH, handler(self, self.refreshEggPool), "EggRewardLayer:refreshEggPool")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_EGG_GET_REWARD, handler(self, self.onEggGetReward), "EggRewardLayer:onEggGetReward")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SHOP_CLUB_ITEM_REFRESH, handler(self, self.onShopClubItemRefresh), "EggRewardLayer:onShopClubItemRefresh")

    lt.AudioManager:preloadSound("ui/audio_turn_egg_clicked")
    lt.AudioManager:preloadSound("ui/audio_egg_opening")

    -- self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --   -- 没点击在自身区域 则隐藏

    --   local rect = self._bg:getCascadeBoundingBox()
    --   if not cc.rectContainsPoint(rect, cc.p(event.x, event.y)) then
    --     self:close()

    --   end

    --   return false
    -- end)
    -- 载入特效
    -- lt.ResourceManager:addArmature("openChest_1", "effect/ui/openChest_1.ExportJson")
    -- lt.ResourceManager:addArmature("openChest_2", "effect/ui/openChest_2.ExportJson")
    -- lt.ResourceManager:addArmature("openChest_3", "effect/ui/openChest_3.ExportJson")
end

function EggRewardLayer:onExit()
    lt.SocketApi:removeEventListenersByTag("EggRewardLayer:onEggStart")
    lt.SocketApi:removeEventListenersByTag("EggRewardLayer:onEggRefresh")
    lt.SocketApi:removeEventListenersByTag("EggRewardLayer:onEggRewardLogList")
    lt.GameEventManager:removeListener("EggRewardLayer:refreshEggPool")
    lt.SocketApi:removeEventListenersByTag("EggRewardLayer:onEggGetReward")
    lt.GameEventManager:removeListener("EggRewardLayer:onShopClubItemRefresh")
    -- 移除图片
    display.removeSpriteFrameByImageName("image/ui/egg_bg.jpg")
    
    lt.AudioManager:unloadSound("ui/audio_turn_egg_clicked")
    lt.AudioManager:unloadSound("ui/audio_egg_opening")
    -- 释放特效
    -- lt.ResourceManager:removeArmature("openChest_1", "effect/ui/openChest_1.ExportJson")
    -- lt.ResourceManager:removeArmature("openChest_2", "effect/ui/openChest_2.ExportJson")
    -- lt.ResourceManager:removeArmature("openChest_3", "effect/ui/openChest_3.ExportJson")

    if self._updateHandler then
        lt.scheduler.unscheduleGlobal(self._updateHandler)
        self._updateHandler = nil
    end
end

return EggRewardLayer