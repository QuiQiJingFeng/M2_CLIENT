local MessageNode = class("MessageNode", function()
	return display.newNode()
end)

MessageNode.ARROW_TYPE = {
    MIDDLE_UP   =  1,--中间朝上
    TOP         =  2,--最上
    MIDDLE_DOWN =  3,--中间朝下
    BOTTOM      =  4,--最底下
}

MessageNode.MORE_TYPE = {
    UP    =  1,--向上
    DOWN  =  2,--向下
}

MessageNode.CHANNEL = {
    WORLD  =  lt.Constants.CHAT_TYPE.WORLD,--世界
    GUILD  =  lt.Constants.CHAT_TYPE.GUILD,--公会
    TEAM   =  lt.Constants.CHAT_TYPE.TEAM --队伍
}

MessageNode.AUTO_TYPE = {
    NOT_AUTO   =  1,--手动
    AUTO       =  2,--自动
}

MessageNode._autoBtnOn = false
MessageNode._autoBtnVisible = true
MessageNode.OTHERS_PARAMS_TYPE = 9999 --获取他人英灵信息，装备信息所填写参数

MessageNode._fixItem = nil
MessageNode._fixMode = true

MessageNode._winScale = lt.CacheManager:getWinScale()

function MessageNode:ctor(delegate)
    self._positionY = {35, 100, 165}

    self._delegate = delegate
    self._unReadNum = 0
    self._lockScreen = false
    self._channel = self.CHANNEL.WORLD
    self._arrowType = self.ARROW_TYPE.MIDDLE_UP
    self._moreType = self.MORE_TYPE.UP
    self._autoType = self.AUTO_TYPE.NOT_AUTO
    self._offsetY = 0

    self:setNodeEventEnabled(true)
    self:setTouchSwallowEnabled(false)

	local chatBgSize = cc.size(370 * self._winScale, 100)
    self._chatBg = lt.GameNewPanel.new(lt.GameNewPanel.TYPE.NEW_BLACK, display.cx, 13, chatBgSize)
    self._chatBg:setAnchorPoint(0.5, 0)
    self:addChild(self._chatBg)

    self._leftBg = display.newScale9Sprite("#ui_message_leftbg.png")
    self._leftBg:setPreferredSize(cc.size(50 * self._winScale,100))
    self._leftBg:setAnchorPoint(0, 0)
    self._leftBg:setPosition(0, 0)
    self._chatBg:addChild(self._leftBg)

    self._moreBtn = lt.ScaleButton.new("#message_icon_arrow.png")
    self._moreBtn:setPosition(self._leftBg:getContentSize().width / 2, 75)
    self._moreBtn:onButtonClicked(handler(self,self.onMore))
    self._leftBg:addChild(self._moreBtn)

    self._worldChatBtn = display.newSprite("#ui_message_talk.png")
    self._worldChatBtn:setTag(1)
    self._worldChatBtn:setPosition(self._leftBg:getContentSize().width / 2, self._positionY[1])
    self._leftBg:addChild(self._worldChatBtn)

    local lblWorld = lt.GameBMLabel.new(lt.StringManager:getString("STRING_MESSAGE_MIC_TIPS_1"), "select_btn.fnt")
    lblWorld:setPosition(self._worldChatBtn:getContentSize().width-10,10)
    self._worldChatBtn:addChild(lblWorld)

    self._guildChatBtn = display.newSprite("#ui_message_talk.png")
    self._guildChatBtn:setTag(2)
    self._guildChatBtn:setPosition(self._worldChatBtn:getPositionX(), self._positionY[2])
    self._guildChatBtn:setVisible(false)
    self._leftBg:addChild(self._guildChatBtn)

    local lblGuild = lt.GameBMLabel.new(lt.StringManager:getString("STRING_MESSAGE_MIC_TIPS_2"), "select_btn.fnt")
    lblGuild:setPosition(self._guildChatBtn:getContentSize().width-10,10)
    self._guildChatBtn:addChild(lblGuild)

    self._teamChatBtn = display.newSprite("#ui_message_talk.png")
    self._teamChatBtn:setTag(3)
    self._teamChatBtn:setPosition(self._guildChatBtn:getPositionX(), self._positionY[3])
    self._teamChatBtn:setVisible(false)
    self._leftBg:addChild(self._teamChatBtn)

    local lblTeam = lt.GameBMLabel.new(lt.StringManager:getString("STRING_MESSAGE_MIC_TIPS_3"), "select_btn.fnt")
    lblTeam:setPosition(self._teamChatBtn:getContentSize().width-10,10)
    self._teamChatBtn:addChild(lblTeam)

    self._arrowBtn = display.newSprite("#ui_message_changebtn.png")
    self._arrowBtn:setPosition(self._chatBg:getContentSize().width - 16,self._chatBg:getContentSize().height + 10)
    self._chatBg:addChild(self._arrowBtn)

    local arrowBtn = cc.ui.UIPushButton.new()
    arrowBtn:setContentSize(cc.size(80,80))
    arrowBtn:setPosition(self._arrowBtn:getContentSize().width/2,self._arrowBtn:getContentSize().height/2)
    arrowBtn:onButtonClicked(handler(self,self.onArrow))
    self._arrowBtn:addChild(arrowBtn)

    self._changeNode = lt.GameNewPanel.new(lt.GameNewPanel.TYPE.NEW_BLACK, display.cx-200, 113, cc.size(50,110))
    self._changeNode:setAnchorPoint(0,0)
    self._changeNode:setVisible(false)
    self:addChild(self._changeNode)

    self._changeBtn1 = lt.ScaleButton.new("#ui_message_talk.png")
    self._changeBtn1:setPosition(self._changeNode:getContentSize().width/2,self._changeNode:getContentSize().height/2-25)
    self._changeBtn1:onButtonClicked(handler(self,self.onChange1))
    self._changeBtn1:setTag(self.CHANNEL.GUILD)
    self._changeBtn1:setGray(true)
    self._changeNode:addChild(self._changeBtn1)

    self._lblChange1 = lt.GameBMLabel.new(lt.StringManager:getString("STRING_MESSAGE_MIC_TIPS_2"), "select_btn.fnt")
    self._lblChange1:setPosition(10,-15)
    self._changeBtn1:addChild(self._lblChange1)

    self._changeBtn2 = lt.ScaleButton.new("#ui_message_talk.png")
    self._changeBtn2:setPosition(self._changeNode:getContentSize().width/2,self._changeNode:getContentSize().height/2+25)
    self._changeBtn2:onButtonClicked(handler(self,self.onChange2))
    self._changeBtn2:setTag(self.CHANNEL.TEAM)
    self._changeBtn2:setGray(true)
    self._changeNode:addChild(self._changeBtn2)

    self._lblChange2 = lt.GameBMLabel.new(lt.StringManager:getString("STRING_MESSAGE_MIC_TIPS_3"), "select_btn.fnt")
    self._lblChange2:setPosition(10,-15)
    self._changeBtn2:addChild(self._lblChange2)

    --聊天内容
    self._chatListView = lt.ListView.new {
        viewRect = cc.rect(50 * self._winScale, 2, chatBgSize.width-50 * self._winScale, self._chatBg:getContentSize().height-6),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
            :onTouch(function(event)
                if event.name == "clicked" then
                    if not event.item then 
                        return 
                    end
                    self:onClickItemCallback(event)
                end

                if event.name == "moved" then
                    local offsetX, offsetY = self._chatListView:getOffset()
                    if self._chatListView:getScrollNode():getCascadeBoundingBox().height > self._chatListView:getViewRect().height + 30 then
                        if offsetY < -10 then
                            self._lockScreen = true
                        end
                    end
                end

                if "began" == event.name then
                    self._y = event.y
                    self._listEnd = false
                end

                if "ended" == event.name then
                    if event.y > self._y then
                        self._listEnd = true
                    end
                end

                if "scrollEnd" == event.name and self._listEnd then
                    if self._chatListView:getScrollNode():getCascadeBoundingBox().height > self._chatListView:getViewRect().height + 30 then
                        if self._lockScreen and self._unReadNum > 0 then
                            self._lockScreen = false
                            self:updateChatList()
                        end
                    end
                end
            end)
            :addTo(self._chatBg)

    local unReadBgSize = cc.size(316,25)
    self._unReadBg = display.newScale9Sprite("image/ui/chat_info_bg.png")
    self._unReadBg:setPreferredSize(unReadBgSize)
    self._unReadBg:setAnchorPoint(0, 0)
    self._unReadBg:setPosition(52, 0)
    self._unReadBg:setVisible(false)
    self._chatBg:addChild(self._unReadBg)

    local refreshButton = lt.PushButton.new()
    refreshButton:setContentSize(unReadBgSize.width,unReadBgSize.height)
    refreshButton:onButtonClicked(handler(self,self.onClickRefreshButton))
    refreshButton:setPosition(unReadBgSize.width/2,unReadBgSize.height/2)
    self._unReadBg:addChild(refreshButton,10)

    self._unReadLabel = lt.GameLabel.new("",lt.Constants.FONT_SIZE4, lt.Constants.DEFAULT_LABEL_COLOR_2, {outline = 1})
    self._unReadLabel:setPosition(unReadBgSize.width / 2 - 12,unReadBgSize.height / 2)
    self._unReadBg:addChild(self._unReadLabel)

    self._iconArrow = display.newSprite("#common_image_downarrow.png")
    self._iconArrow:setPosition(self._unReadLabel:getPositionX()+90,self._unReadLabel:getPositionY())
    self._unReadBg:addChild(self._iconArrow)

    self._autoBtn = lt.ScaleButton.new("image/ui/common/common_btn_small_gray.png",{scale9=true})
    self._autoBtn:setButtonSize(80,45)
    self._autoBtn:setPosition(35,self._chatBg:getContentSize().height + 15)
    self._autoBtn:onButtonClicked(handler(self,self.onAuto))
    self._autoBtn:setVisible(self._autoBtnVisible and self._autoBtnOn)
    self._chatBg:addChild(self._autoBtn)

    self._autoIcon = display.newSprite("#ui_message_not_auto.png")
    self._autoIcon:setPosition(-20,0)
    self._autoBtn:addChild(self._autoIcon)

    self._autoLabel = lt.GameBMLabel.newString("STRING_NOT_AUTO", "select_btn.fnt")
    self._autoLabel:setPosition(10,0)
    self._autoBtn:addChild(self._autoLabel)

    local autoBattle = lt.PreferenceManager:getAutoBattle()
    if autoBattle then
        self._autoType = self.AUTO_TYPE.AUTO
        self._autoIcon:setSpriteFrame(display.newSpriteFrame("ui_message_auto.png"))
        self._autoLabel:setString(lt.StringManager:getString("STRING_AUTO"))
    end

    self._chatList = {}
    self:updateChatTable()
end

function MessageNode:onEnter()
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))

    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_CHAT_RESULT, handler(self, self.onchatResultResponse), "MessageNode:onchatResultResponse")

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.CHAT_SYSTEM, handler(self, self.updateSystemTable), "MessageNode:updateSystemTable")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.CHAT_WORLD, handler(self, self.updateWorldTable), "MessageNode:updateWorldTable")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.CHAT_TEAM, handler(self, self.updateTeamTable), "MessageNode:updateTeamTable")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.CHAT_GUILD, handler(self, self.updateGuildTable), "MessageNode:updateGuildTable")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.CHAT_CURRENT, handler(self, self.updateCurrentTable), "MessageNode:updateCurrentTable")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.TEAM_UPDATE, handler(self, self.updateTeam), "MessageNode:updateTeam")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.AUDIO_CHAT_UPDATE, handler(self, self.onAudioUpdate), "MessageNode:onAudioUpdate")

    -- self._voicingNode = lt.VoicingNode.new()  --引导产生清楚所有的layer 此时 self._voicingNode 对象被释放
    -- lt.UILayerManager:addLayer(self._voicingNode, true)
end

function MessageNode:onExit()
    lt.SocketApi:removeEventListenersByTag("MessageNode:onchatResultResponse")

    lt.GameEventManager:removeListener("MessageNode:updateSystemTable")
    lt.GameEventManager:removeListener("MessageNode:updateWorldTable")
    lt.GameEventManager:removeListener("MessageNode:updateTeamTable")
    lt.GameEventManager:removeListener("MessageNode:updateGuildTable")
    lt.GameEventManager:removeListener("MessageNode:updateCurrentTable")
    lt.GameEventManager:removeListener("MessageNode:updateTeam")
    lt.GameEventManager:removeListener("MessageNode:onAudioUpdate")

    if self._voicingNode then
        self._voicingNode:remove()
        self._voicingNode = nil
    end
end

function MessageNode:onClickItemCallback(event)
    self._delegate:onChat()
end

function MessageNode:updateTeam()
    if lt.DataManager:getSelfTeamInfo() then
        self._changeBtn2:setGray(false)
    else
        self._changeBtn2:setGray(true)

        if self._channel == self.CHANNEL.TEAM then
            local oldChannel = self._channel
            local newChannel = self._changeBtn2:getTag()
            self._changeBtn2:setTag(oldChannel)
            self._lblChange2:setString(self:getTitle())
            self._channel = newChannel
            self:changePosition()
        end
    end
end

function MessageNode:onMore()
    if self._moreType == self.MORE_TYPE.UP then
        self._changeNode:setVisible(true)
        self._autoBtnVisible = false
        self._autoBtn:setVisible(self._autoBtnVisible and self._autoBtnOn)
        self._moreBtn:setRotation(180)
        self._moreType = self.MORE_TYPE.DOWN
    else
        self:disableMore()
    end
end

function MessageNode:disableMore()
    self._moreBtn:setRotation(0)
    self._changeNode:setVisible(false)
    self._autoBtnVisible = true
    self._autoBtn:setVisible(self._autoBtnVisible and self._autoBtnOn)
    self._moreType = self.MORE_TYPE.UP
end

function MessageNode:onChange1(event)
    --if true then return end
    local guildId = lt.DataManager:getGuildId()
    if guildId == 0 then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_MESSAGE_GUILD_TITLE"))
        return
    end

    local oldChannel = self._channel
    local newChannel = self._changeBtn1:getTag()
    self._changeBtn1:setTag(oldChannel)
    self._lblChange1:setString(self:getTitle())
    self._channel = newChannel
    self:changePosition()
end

function MessageNode:onChange2(event)
    if not lt.DataManager:getSelfTeamInfo() then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_MESSAGE_TEAM_TITLE"))
        return
    end

    local oldChannel = self._channel
    local newChannel = self._changeBtn2:getTag()
    self._changeBtn2:setTag(oldChannel)
    self._lblChange2:setString(self:getTitle())
    self._channel = newChannel
    self:changePosition()
end

function MessageNode:getTitle()
    if self._channel == self.CHANNEL.WORLD then
        return lt.StringManager:getString("STRING_MESSAGE_MIC_TIPS_1")
    end
    if self._channel == self.CHANNEL.GUILD then
        return lt.StringManager:getString("STRING_MESSAGE_MIC_TIPS_2")
    end
    if self._channel == self.CHANNEL.TEAM then
        return lt.StringManager:getString("STRING_MESSAGE_MIC_TIPS_3")
    end
    return ""
end

function MessageNode:changePosition()
    local currentBtn = self:getCurrentBtn()
    local targetBtn = self:getTargetBtn()
    local tag = targetBtn:getTag()
    currentBtn:setTag(tag)
    currentBtn:setPositionY(self._positionY[tag])
    currentBtn:setVisible(false)
    targetBtn:setTag(1)
    targetBtn:setPositionY(self._positionY[1])
    targetBtn:setVisible(true)
end

function MessageNode:getCurrentBtn()
    if self._worldChatBtn:getTag() == 1 then
        return self._worldChatBtn
    end

    if self._guildChatBtn:getTag() == 1 then
        return self._guildChatBtn
    end

    if self._teamChatBtn:getTag() == 1 then
        return self._teamChatBtn
    end
end

function MessageNode:getTargetBtn()
    if self.CHANNEL.WORLD == self._channel then
        return self._worldChatBtn
    end

    if self.CHANNEL.GUILD == self._channel then
        return self._guildChatBtn
    end

    if self.CHANNEL.TEAM == self._channel then
        return self._teamChatBtn
    end
end

function MessageNode:visibleBtns(visible)
    if self._channel == self.CHANNEL.WORLD then
        self._guildChatBtn:setVisible(visible)
        self._teamChatBtn:setVisible(visible)
    elseif self._channel == self.CHANNEL.GUILD then
        self._worldChatBtn:setVisible(visible)
        self._teamChatBtn:setVisible(visible)
    elseif self._channel == self.CHANNEL.TEAM then
        self._worldChatBtn:setVisible(visible)
        self._guildChatBtn:setVisible(visible)
    end
end

function MessageNode:onAuto()
    if self._autoType == self.AUTO_TYPE.NOT_AUTO then
        self._autoIcon:setSpriteFrame(display.newSpriteFrame("ui_message_auto.png"))
        self._autoLabel:setString(lt.StringManager:getString("STRING_AUTO"))
        lt.PreferenceManager:setAutoBattle(true)
        self._autoType = self.AUTO_TYPE.AUTO

        -- 自动更新设置切换
        lt.GameEventManager:post(lt.GameEventManager.EVENT.AUTO_BATTLE_UPDATE)
    else
        self._autoIcon:setSpriteFrame(display.newSpriteFrame("ui_message_not_auto.png"))
        self._autoLabel:setString(lt.StringManager:getString("STRING_NOT_AUTO"))
        lt.PreferenceManager:setAutoBattle(false)
        self._autoType = self.AUTO_TYPE.NOT_AUTO

        -- 自动更新设置切换
        lt.GameEventManager:post(lt.GameEventManager.EVENT.AUTO_BATTLE_UPDATE)
    end
end

function MessageNode:reset()
    self._arrowType = self.ARROW_TYPE.BOTTOM 

    self:onArrow()
end

function MessageNode:mini()
    self._arrowType = self.ARROW_TYPE.MIDDLE_DOWN

    self:onArrow()
end

function MessageNode:middle()
    self._arrowType = self.ARROW_TYPE.TOP

    self:onArrow()
end

function MessageNode:onArrow()
    if self._arrowType == self.ARROW_TYPE.MIDDLE_UP then
        self:disableMore()
        local chatBgSize = cc.size(370 * self._winScale, 200)
        self._chatBg:setPreferredSize(chatBgSize)
        self._arrowBtn:setPosition(self._chatBg:getContentSize().width - 16, self._chatBg:getContentSize().height + 11)
        self._arrowBtn:setRotation(180)
        self._autoBtn:setPosition(35,self._chatBg:getContentSize().height + 15)
        self._moreBtn:setVisible(false)
        self:visibleBtns(true)
        self:getCurrentBtn():setPositionY(35)
        self._leftBg:setPreferredSize(cc.size(50 * self._winScale,200))
        self._chatListView:setViewRect(cc.rect(50 * self._winScale, 2, chatBgSize.width-50 * self._winScale, self._chatBg:getContentSize().height-6))
        self._chatListView:addTouchNode()
        self:updateChatList()

        self._arrowType = self.ARROW_TYPE.TOP
    elseif self._arrowType == self.ARROW_TYPE.TOP then
        local chatBgSize = cc.size(370 * self._winScale, 100)
        self._chatBg:setPreferredSize(chatBgSize)
        self._arrowBtn:setPosition(self._chatBg:getContentSize().width - 16, self._chatBg:getContentSize().height + 11)
        self._arrowBtn:setRotation(180)
        self._autoBtn:setPosition(35,self._chatBg:getContentSize().height + 15)
        self._moreBtn:setVisible(true)
        self:visibleBtns(false)
        self:getCurrentBtn():setPositionY(35)
        self._leftBg:setPreferredSize(cc.size(50 * self._winScale,100))
        self._chatListView:setViewRect(cc.rect(50 * self._winScale, 2, chatBgSize.width-50 * self._winScale, self._chatBg:getContentSize().height-6))
        self._chatListView:addTouchNode()
        self:updateChatList()
        
        self._arrowType = self.ARROW_TYPE.MIDDLE_DOWN
    elseif self._arrowType == self.ARROW_TYPE.MIDDLE_DOWN then
        local chatBgSize = cc.size(370 * self._winScale, 50)
        self._chatBg:setPreferredSize(chatBgSize)
        self._arrowBtn:setPosition(self._chatBg:getContentSize().width - 16, self._chatBg:getContentSize().height + 10)
        self._arrowBtn:setRotation(0)
        self._autoBtn:setPosition(35,self._chatBg:getContentSize().height + 15)
        self._moreBtn:setVisible(false)
        self:visibleBtns(false)
        self._leftBg:setPreferredSize(cc.size(50 * self._winScale,50))
        self:getCurrentBtn():setPositionY(30)
        self._chatListView:setViewRect(cc.rect(50 * self._winScale, 2, chatBgSize.width-50 * self._winScale, self._chatBg:getContentSize().height-6))
        self._chatListView:addTouchNode()
        self:updateChatList()
        
        self._arrowType = self.ARROW_TYPE.BOTTOM
    elseif self._arrowType == self.ARROW_TYPE.BOTTOM then
        local chatBgSize = cc.size(370 * self._winScale, 100)
        self._chatBg:setPreferredSize(chatBgSize)
        self._arrowBtn:setPosition(self._chatBg:getContentSize().width - 16, self._chatBg:getContentSize().height + 10)
        self._arrowBtn:setRotation(0)
        self._autoBtn:setPosition(35,self._chatBg:getContentSize().height + 15)
        self._moreBtn:setVisible(true)
        self:visibleBtns(false)
        self:getCurrentBtn():setPositionY(35)
        self._leftBg:setPreferredSize(cc.size(50 * self._winScale,100))
        self._chatListView:setViewRect(cc.rect(50 * self._winScale, 2, chatBgSize.width-50 * self._winScale, self._chatBg:getContentSize().height-6))
        self._chatListView:addTouchNode()
        self:updateChatList()

        self._arrowType = self.ARROW_TYPE.MIDDLE_UP
    end
end

function MessageNode:onClickRefreshButton()
    self._lockScreen = false
    self:updateChatList()
end

function MessageNode:updateChatList()
    self._unReadBg:setVisible(false)
    self._unReadNum = 0

    self._chatListView:removeAllItems()
    self._fixItem = nil

    local chatCount = math.min(#self._chatList, 10)
    local height = self._chatListView:getViewRect().height
    for i=1,chatCount do
        local chatInfo = self._chatList[i]
        local content = lt.MessageCell.new()
        content:setScale(self._winScale)
        content:updateInfo(chatInfo,handler(self,self.tipsShowRcihTest))
        local item = self._chatListView:newItem(content)
        local customSize = content:getCustomSize()
        item:setItemSize(customSize.width * self._winScale,  (customSize.height + 3) * self._winScale)
        self._chatListView:addItem(item)
        height = height - customSize.height
    end

    if height > 0 then -- fix if no item can not click
        self._fixMode = true

        local content = display.newNode()
        self._fixItem = self._chatListView:newItem(content)
        self._fixItem:setItemSize(350 * self._winScale, height)
        self._chatListView:addItem(self._fixItem)
    else
        self._fixMode = false
    end

    self._chatListView:reload()
    transition.stopTarget(self._chatListView.scrollNode)
    self._chatListView:scrollTo(0,0)
end

function MessageNode:pushPopChatList(push, pop)
    self._unReadBg:setVisible(false)
    self._unReadNum = 0

    if self._fixItem then
        self._chatListView:removeItem(self._fixItem)
        self._fixItem = nil
    end

    if push then
        local chatInfo = self._chatList[#self._chatList]
        local content = lt.MessageCell.new()
        content:setScale(self._winScale)
        content:updateInfo(chatInfo,handler(self,self.tipsShowRcihTest))
        local item = self._chatListView:newItem(content)
        local customSize = content:getCustomSize()
        item:setItemSize(customSize.width * self._winScale,  customSize.height + 3)
        self._chatListView:addItem(item)
    end

    if pop then
        local firstItem = self._chatListView:getFirstItem()
        if firstItem then
            self._chatListView:removeItem(firstItem)
        end
    end

    if self._fixMode then
        local viewHeight = self._chatListView:getViewRect().height
        local itemHeight = 0
        local allItems = self._chatListView:getAllChildren()
        for _,item in ipairs(allItems) do
            local width, height = item:getItemSize()

            itemHeight = itemHeight + height

            if itemHeight > viewHeight then
                break
            end
        end

        if itemHeight < viewHeight then
            self._fixMode = true
            
            local content = display.newNode()
            self._fixItem = self._chatListView:newItem(content)
            self._fixItem:setItemSize(350 * self._winScale,  viewHeight - itemHeight)
            self._chatListView:addItem(self._fixItem)
        else
            self._fixMode = false
        end
    end

    self._chatListView:reload()
    transition.stopTarget(self._chatListView.scrollNode)
    self._chatListView:scrollTo(0, 0)
end

function MessageNode:updateChatTable(chatInfo)
    local push = false
    local pop  = false
    if chatInfo then
        if #self._chatList >= 10 then
            table.remove(self._chatList,1)

            pop = true
        end
        table.insert(self._chatList, chatInfo)

        push = true
    end
    if self._lockScreen == false then
        self:pushPopChatList(push, pop)
    else
        self._unReadNum = self._unReadNum + 1
        self._unReadBg:setVisible(true)
        self._unReadLabel:setString(string.format(lt.StringManager:getString("STRING_MESSAGE_TIPS_2"),self._unReadNum))
        self._iconArrow:setPositionX(self._unReadLabel:getPositionX()+self._unReadLabel:getContentSize().width/2+24)
    end
end

function MessageNode:onTouch(event)
    local name, x, y = event.name, event.x, event.y
    local contentSize = self._worldChatBtn:getContentSize()
    local worldChatPos = self._worldChatBtn:getParent():convertToWorldSpace(cc.p(self._worldChatBtn:getPosition()))
    local rect1 = cc.rect(worldChatPos.x-contentSize.width/2, worldChatPos.y - contentSize.height/2 - 15, contentSize.width + 15, contentSize.height)

    local guildChatPos = self._guildChatBtn:getParent():convertToWorldSpace(cc.p(self._guildChatBtn:getPosition()))
    local rect2 = cc.rect(guildChatPos.x-contentSize.width/2, guildChatPos.y - contentSize.height/2 - 15, contentSize.width + 15, contentSize.height)

    local teamChatPos = self._teamChatBtn:getParent():convertToWorldSpace(cc.p(self._teamChatBtn:getPosition()))
    local rect3 = cc.rect(teamChatPos.x-contentSize.width/2, teamChatPos.y - contentSize.height/2 - 15, contentSize.width + 15, contentSize.height)

    --if device.platform ~= "windows" then
        if name == "began" then
            self:disableMore()

            if cc.rectContainsPoint(rect1, cc.p(x, y)) or cc.rectContainsPoint(rect2, cc.p(x, y)) or cc.rectContainsPoint(rect3, cc.p(x, y)) then
                local channel = nil
                --判断有没有被禁言
                if lt.DataManager:getPlayer():getUnfreezeSpeechTime() > lt.CommonUtil:getCurrentTime() then
                    lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_MESSAGE_CANT_CHAT"))
                    return false
                end

                if cc.rectContainsPoint(rect1, cc.p(x, y)) then
                    if not self._worldChatBtn:isVisible() then
                        return false
                    end

                    --判断聊天等级
                    if lt.DataManager:getPlayer():getLevel() < lt.Constants.WORLD_CHAT_LEVEL then
                        local strInfo = string.format(lt.StringManager:getString("STRING_MESSAGE_CHAT_LEVEL_LESS"),lt.Constants.WORLD_CHAT_LEVEL)
                        lt.NoticeManager:addMessage(strInfo)
                        return false
                    end
                    --判断银币
                    local coin = lt.DataManager:getPlayer():getCoin()
                    if coin < lt.Constants.WORLD_CHAT_COST then
                        local needNum = lt.Constants.WORLD_CHAT_COST - coin
                        lt.CommonCoinFastExchange:show(lt.Constants.CURRENCY_TYPE.COIN, needNum, nil,lt.Constants.CURRENCY_EXCHANGE_TYPE_FLAG,nil,{delegate = self._delegate})
                        return false
                    end

                    -- 判断上次发言
                    local currentTime = lt.CommonUtil:getCurrentTime()
                    local padTime = currentTime - lt.DataManager:getChatWorldTime()
                    local chatCd = lt.Constants.WORLD_CHAT_TIME

                    if math.abs(padTime)  < chatCd then
                        local time = chatCd - padTime

                        lt.NoticeManager:addMessage(string.format(lt.StringManager:getString("STRING_MESSAGE_MESSAGE_TIME_LESS"),time))
                        return false
                    end

                    channel = lt.Constants.CHAT_TYPE.WORLD
                end    
                if cc.rectContainsPoint(rect2, cc.p(x, y)) then
                    if not self._guildChatBtn:isVisible() then
                        return false
                    end

                    --判断有没有工会
                    local guildId = lt.DataManager:getPlayer():getGuildId()
                    if not guildId or guildId == 0 then
                        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_MESSAGE_GUILD_TITLE"))
                        return false
                    end
                    channel = lt.Constants.CHAT_TYPE.GUILD
                end

                if cc.rectContainsPoint(rect3, cc.p(x, y)) then
                    if not self._teamChatBtn:isVisible() then
                        return false
                    end

                    --判断有没有队伍
                    if not lt.DataManager:getSelfTeamInfo() then
                        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_MESSAGE_TEAM_TITLE"))
                        return false
                    end
                    channel = lt.Constants.CHAT_TYPE.TEAM
                end

                if not channel then
                    return false
                end

                lt.AudioManager:pauseMusic()
                self._startTalk = true
                self._positionBegin = cc.p(x,y)
                lt.AudioMsgManager:startRecord(channel,lt.DataManager:getPlayer(),0)
                --self._voicingNode:showVoicing()

                self._voicingNode = lt.VoicingNode.new()
                lt.UILayerManager:addLayer(self._voicingNode, true)
                self._voicingNode:showVoicing()
            else
                return false
            end
            return true
        end
        if name == "moved" then
            --self._voicingNode:hide()

            if not self._startTalk then
                if self._voicingNode then
                    self._voicingNode:remove()
                    self._voicingNode = nil
                end
                return
            end
            if cc.rectContainsPoint(rect1, cc.p(x, y)) or cc.rectContainsPoint(rect2, cc.p(x, y)) or cc.rectContainsPoint(rect3, cc.p(x, y)) then
                self._positionBegin = cc.p(x,y)
                --self._voicingNode:showVoicing()
                if self._voicingNode then
                    self._voicingNode:showVoicing()
                end
            else
                --self._voicingNode:showCancel()
                if self._voicingNode then
                    self._voicingNode:showCancel()
                end
            end
        end


        -- must the begin point and current point in Button Sprite
        if name == "ended" then
            if self._startTalk then
                lt.AudioManager:resumeMusic()
            end
            self._startTalk = false
            --self._voicingNode:hide()
            if self._voicingNode then
                self._voicingNode:remove()
                self._voicingNode = nil
            end

            local player = lt.DataManager:getPlayer()
            local offsetX = x - self._positionBegin.x
            local offsetY = y - self._positionBegin.y
            if offsetX > 20 or offsetX < -20  or offsetY > 20 or offsetY < -20 then
                lt.CommonUtil.print("talk moved")
                --self._gotyeNode:stopTalk(player:getId(),player:getName(),player:getAvatarId(),true,player:getOccupationId(),player:getBubbleId())
                lt.AudioMsgManager:stopRecord(true)
            else
                lt.CommonUtil.print("talk ended")
                --self._gotyeNode:stopTalk(player:getId(),player:getName(),player:getAvatarId(),false,player:getOccupationId(),player:getBubbleId())
                lt.AudioMsgManager:stopRecord(false)
            end
        end

        if name == "cancelled" then
            if self._startTalk then
                lt.AudioManager:resumeMusic()
            end
            self._startTalk = false
            --self._voicingNode:hide()

            if self._voicingNode then
                self._voicingNode:remove()
                self._voicingNode = nil
            end

            lt.CommonUtil.print("talk moved")
            --local player = lt.DataManager:getPlayer()
            --self._gotyeNode:stopTalk(player:getId(),player:getName(),player:getAvatarId(),true,player:getOccupationId(),player:getBubbleId())
            lt.AudioMsgManager:stopRecord(true)
        end
    --end
end

function MessageNode:onchatResultResponse(event)
    local data = event.data
    local code = data.code
    lt.CommonUtil.print("MessageNode:onchatResultResponse========="..code)
    if not self:isVisible() then
        return
    end

    if code == lt.SocketConstants.CODE_INVALID_PARAM then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_SHOP_TIPS_34"))
        return
    end

    if code == lt.SocketConstants.CODE_LEVEL_NOT_REACHED then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_SHOP_TIPS_34"))
        return
    end

    if code == lt.SocketConstants.CODE_COIN_NOT_ENOUGH then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_ERROR_SILVER_NOT_ENOUGH"))
        return
    end

    if code == lt.SocketConstants.CODE_CHAT_TOO_FREQUENTLY then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_MESSAGE_CHAT_FREQUENTLY"))
        return
    end

    if code == lt.SocketConstants.CODE_CODE_PLAYER_WERE_FREEZED_SPEECH_ENUM then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_MESSAGE_CANT_CHAT"))
        return
    end

    if code == lt.SocketConstants.CODE_QUESTION_ALREDY_ANSWERED then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_ACTIVITY_QUESTION_18"))
        return
    end

    if code == lt.SocketConstants.CODE_QUESTION_ALREDY_ANSWERED_BY_ASKER then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_ACTIVITY_QUESTION_19"))
        return
    end

    if code == lt.SocketConstants.CODE_PLAYER_NOT_IN_SEPT then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_MESSAGE_GUILD_TITLE"))
        return
    end

    if code == lt.SocketConstants.CODE_CHAT_NOT_IN_TEAM then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_MESSAGE_TEAM_TITLE"))
        return
    end

    if code == lt.SocketConstants.CODE_MESSAGE_TOO_LONG then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_MESSAGE_MAXLEN"))
        return
    end

    if code == 0 then
        -- 记录发言时间
        if data.channel == lt.Constants.CHAT_TYPE.WORLD  then
            lt.DataManager:setChatWorldTime(lt.CommonUtil:getCurrentTime())
            lt.NoticeManager:addMessage(string.format(lt.StringManager:getString("STRING_COST_COIN"),lt.Constants.WORLD_CHAT_COST))
        end
    end
end

function MessageNode:updateSystemTable(params)
    local chatInfo = params.chatInfo
    self:updateChatTable(chatInfo)
end

function MessageNode:updateWorldTable(params)
    if params.isAudio then
        return
    end
    local chatInfo = params.chatInfo
    if lt.PreferenceManager:getChannelWorld() then
        self:updateChatTable(chatInfo)
    end
end

function MessageNode:updateTeamTable(params)
    if params.isAudio then
        return
    end
    local chatInfo = params.chatMessageInfo
    local subType = chatInfo:getSubType()
    if subType == lt.Constants.CHAT_SUB_TYPE.INVITE_ROOM then
        if lt.PreferenceManager:getChannelInvite() then
            self:updateChatTable(chatInfo)
        end
    else
        if lt.PreferenceManager:getChannelTeam() then
            self:updateChatTable(chatInfo)
        end
    end
end

function MessageNode:updateGuildTable(params)
    if params.isAudio then
        return
    end
    local chatInfo = params.chatInfo
    if lt.PreferenceManager:getChannelGuild() then
        self:updateChatTable(chatInfo)
    end
end

function MessageNode:updateCurrentTable(params)
    if params.isAudio then
        return
    end
    local chatInfo = params.chatInfo
    if lt.PreferenceManager:getChannelCurrent() then
        self:updateChatTable(chatInfo)
    end
end

function MessageNode:onAudioUpdate(params)
    local chatInfo = params.chatInfo
    local channel = chatInfo:getChannel()
    if channel == lt.Constants.CHAT_TYPE.WORLD and lt.PreferenceManager:getChannelWorld() then
        self:updateChatTable(chatInfo)
        return
    end

    if channel == lt.Constants.CHAT_TYPE.TEAM and lt.PreferenceManager:getChannelTeam() then
        self:updateChatTable(chatInfo)
        return
    end

    if channel == lt.Constants.CHAT_TYPE.GUILD and lt.PreferenceManager:getChannelGuild() then
        self:updateChatTable(chatInfo)
        return
    end

    if channel == lt.Constants.CHAT_TYPE.CURRENT and lt.PreferenceManager:getChannelCurrent() then
        self:updateChatTable(chatInfo)
        return
    end
end

function MessageNode:tipsShowRcihTest(sender)
    local itemInfo = json.decode(sender)

    local itemType = itemInfo["itemType"]
    local id = itemInfo["id"]
    local modelId = itemInfo["modelId"]
    local playerId = itemInfo["playerId"]

    if itemType < 0 then --show people info
        if playerId == lt.DataManager:getPlayerId() then
            return
        end
        self._clickId = playerId
        local playerIdArray =  {}
        playerIdArray[#playerIdArray + 1] = playerId

        lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SIMPLE_PLAYER_INFO_UPDATE, handler(self, self.updateSimplePlayerInfo), "MessageNode:updateSimplePlayerInfo")

        lt.DataManager:requestSimplePlayerInfo(playerIdArray)
        
    end

    if itemType == lt.GameIcon.TYPE.ITEM then
        self:getTipsItem():setVisible(true)
        self:getTipsItem():updateInfo(lt.TipsItem.TYPE.ITEM,modelId)
    elseif itemType == lt.GameIcon.TYPE.EQUIPMENT then
        local playerEquipmentInfo = lt.DataManager:getOtherPlayerEquipmentTableById(id)
        if playerEquipmentInfo then
            self:getTipsEquipment():setVisible(true)
            self:getTipsEquipment():updateInfo(lt.TipsEquipment.TYPE.PLAYER_EQUIPMENT_COMPARE,id,{playerEquipment = playerEquipmentInfo})
        else
            lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_PLAYER_EQUIPMENT_INFO, handler(self, self.onGetPlayerEquipmentInfoResponse), "MessageNode:onGetPlayerEquipmentInfoResponse")
            lt.SocketApi:getPlayerEquipmentInfo(playerId,id,self.OTHERS_PARAMS_TYPE)
        end

    elseif itemType == lt.GameIcon.TYPE.CHARACTER_SERVANT then
        local playerServant = lt.DataManager:getOtherPlayerServant(id)
        if playerServant then
            local params = {}
            params.itemId = playerServant:getId()
            --lt.ServantCompareLayer:show(params)
        else
            lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_PLAYER_SERVANT_INFO, handler(self, self.onGetOtherPlayerServantInfoResponse), "MessageNode:onGetOtherPlayerServantInfoResponse")
            lt.SocketApi:getPlayerServantInfo(playerId,id,self.OTHERS_PARAMS_TYPE)
        end
    end
end

function MessageNode:updateSimplePlayerInfo()
    lt.GameEventManager:removeListener("MessageNode:updateSimplePlayerInfo")

    if not self._clickId then return end
    local playerDetailInfo = lt.DataManager:getMultiPlayerInfo(self._clickId)

    self._friendtipsLayer = lt.FriendTipsLayer.new(playerDetailInfo,handler(self, self.selectBtnCallBack),lt.FriendTipsLayer.TYPE.WORLD)
    self._friendtipsLayer:setPosition(20,0)
    lt.UILayerManager:addLayer(self._friendtipsLayer,true)
end

function MessageNode:onGetOtherPlayerServantInfoResponse(event)
    lt.SocketApi:removeEventListenersByTag("MessageNode:onGetOtherPlayerServantInfoResponse")
    local s2cGetPlayerServantInfo = event.data
    lt.CommonUtil.print("onGetPlayerServantInfoResponse code " .. s2cGetPlayerServantInfo.code)

    if s2cGetPlayerServantInfo.code == lt.SocketConstants.CODE_INVALID_PARAM then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_ERROR_NOT_FOUND"))
        return
    end

    local otherPlayerServantTable = lt.DataManager:getOtherPlayerServantTable()
    local playerServantInfo = lt.PlayerServant.new(s2cGetPlayerServantInfo.servant_info)
    otherPlayerServantTable[playerServantInfo:getId()] = playerServantInfo
    
    local params = {}
    params.itemId = playerServantInfo:getId()
    --lt.ServantCompareLayer:show(params)

    
end

function MessageNode:onGetPlayerEquipmentInfoResponse(event)
    lt.SocketApi:removeEventListenersByTag("MessageNode:onGetPlayerEquipmentInfoResponse")
    local s2cGetPlayerEquipmentInfo = event.data
    lt.CommonUtil.print("onGetPlayerEquipmentInfoResponse code " .. s2cGetPlayerEquipmentInfo.code)
    if s2cGetPlayerEquipmentInfo.code == lt.SocketConstants.CODE_INVALID_PARAM then
        return
    end

    if s2cGetPlayerEquipmentInfo.code == 0 then
        local otherPlayerEquipmentTable = lt.DataManager:getOtherPlayerEquipmentTable()
        local playerEquipmentInfo = lt.PlayerEquipment.new(s2cGetPlayerEquipmentInfo.equipment_info)
        otherPlayerEquipmentTable[playerEquipmentInfo:getId()] = playerEquipmentInfo
        self:getTipsEquipment():setVisible(true)
        self:getTipsEquipment():updateInfo(lt.TipsEquipment.TYPE.PLAYER_EQUIPMENT_COMPARE,playerEquipmentInfo:getId(),{playerEquipment = playerEquipmentInfo})
        
    end
end

function MessageNode:selectBtnCallBack(type,info)
    local playerId = lt.DataManager:getPlayer():getId()
    local playerInfo = info

    self._playerInfo = info


    --判断是否在战斗中打开聊天界面
    if self._battleFlag then
        if type == lt.Constants.FRIEND_TIPS_TYPE.DELETEFRIEND then --删除好友
            local friendId = info:getId()
            self:deleteFriend(friendId)
            self:hide()
        elseif type == lt.Constants.FRIEND_TIPS_TYPE.ADDFRIEND then --添加好友
            local friendId = info:getId()
            self:addFriend(friendId)
            self:hide()
        else
            lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_27"))
            return
        end

        return
    end


    if type == lt.Constants.FRIEND_TIPS_TYPE.FRIENDINFO then

        local playerId = info:getId()

        local idArray = {}
        idArray[#idArray + 1] = playerId

        lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SIMPLE_PLAYER_INFO_UPDATE, handler(self, self.updateSimplePlayerDetailInfo), "MessageLayer:updateSimplePlayerDetailInfo")

        lt.DataManager:requestSimplePlayerInfo(idArray)



    elseif type == lt.Constants.FRIEND_TIPS_TYPE.SENDMESSAGE then --发送消息
        local id = info:getId()

        self._delegate:onFriend({info = info, handler = handler(self, self.gotyeNodeShow)})
        self:gotyeNodeHide()

    elseif type == lt.Constants.FRIEND_TIPS_TYPE.SHOWSPACE then --查看好友空间
        local friendId = info:getId()

        local idArray = {}
        idArray[#idArray + 1] = friendId

        local friendDetailInfo = lt.DataManager:getMultiPlayerInfo(friendId)


        self._delegate:onFriendSpaceLayer({type = lt.Constants.ZONE_TYPE.OTHERS,info = friendDetailInfo,handler = handler(self, self.gotyeNodeShow)})
        self:gotyeNodeHide()

    elseif type == lt.Constants.FRIEND_TIPS_TYPE.GIVEGIFT then --赠送礼物
        local friendGiveGiftPanel = lt.FriendGiveGiftPanel.new(self._delegate)
        friendGiveGiftPanel:updateInfo(info,self)
        lt.UILayerManager:addLayer(friendGiveGiftPanel)
    elseif type == lt.Constants.FRIEND_TIPS_TYPE.DELETEFRIEND then --删除好友
        local friendId = info:getId()
        self:deleteFriend(friendId)
        self:hide()
    elseif type == lt.Constants.FRIEND_TIPS_TYPE.ADDFRIEND then --添加好友
        local friendId = info:getId()
        self:addFriend(friendId)
        self:hide()
    elseif type == lt.Constants.FRIEND_TIPS_TYPE.PK then
        local friendId = self._playerInfo:getId()

        local status = self._playerInfo:getStatus()

        if status == 0 then
            -- 离线
            lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_PK_PLAYER_STATUS_0"))
            return
        elseif status == 1 then
            -- 空闲(可切磋)
        elseif status == 2 then
            -- 房间中
            lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_PK_PLAYER_STATUS_0"))
            return
        elseif status == 3 then
            -- 战斗中
            lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_PK_PLAYER_STATUS_0"))
            return
        else
            return
        end
    end
end

function MessageNode:getTipsEquipment()
    if not self._tipsEquipment then
        self._tipsEquipment = lt.TipsEquipment.new(self)
        lt.UILayerManager:addLayer(self._tipsEquipment,true)
    end

    return self._tipsEquipment
end

function MessageNode:clearTipsEquipment()
    if self._tipsEquipment then
        lt.UILayerManager:removeLayer(self._tipsEquipment)
        self._tipsEquipment = nil
    end
end

function MessageNode:getTipsItem()
    if not self._tipsItem then
        self._tipsItem = lt.TipsItem.new(self)
        lt.UILayerManager:addLayer(self._tipsItem,true)
    end

    return self._tipsItem
end

function MessageNode:clearTipsItem()
    if self._tipsItem then
        lt.UILayerManager:removeLayer(self._tipsItem)
        self._tipsItem = nil
    end
end

function MessageNode:setAutoBtnOn()
    self._autoBtnOn = true

    self._autoBtn:setVisible(self._autoBtnVisible and self._autoBtnOn)
end

function MessageNode:setAutoBtnOff(temp)
    self._autoBtnOn = false

    self._autoBtn:setVisible(self._autoBtnVisible and self._autoBtnOn)

    if not temp and self._autoType == self.AUTO_TYPE.AUTO then
        self:onAuto()
    end
end

function MessageNode:disableAutoBtn()
    if self._autoType == self.AUTO_TYPE.AUTO then
        self:onAuto()
    end
end

return MessageNode
