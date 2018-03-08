
-- ################################################## 福利 ##################################################
local AnnouncementLayer = class("AnnouncementLayer", lt.CommonInterFaceLayer)

AnnouncementLayer.PANEL_TYPE = {
	INVALID				 = 0,
	ACTIVITY 			 = 1, -- 活动公告
	GAME 		         = 2, -- 游戏公告
}
AnnouncementLayer._winScale = lt.CacheManager:getWinScale()
AnnouncementLayer._delegate = nil
AnnouncementLayer._currentPanelType = AnnouncementLayer.PANEL_TYPE.ACTIVITY
AnnouncementLayer._currentPanel 	= nil
AnnouncementLayer._listBtn = nil
AnnouncementLayer._detailBtn = nil

AnnouncementLayer._size = lt.Constants.UI_NEW_SIZE.FULL

function AnnouncementLayer:ctor(delegate)
	self:setNodeEventEnabled(true)


    self._illustrationArray = {}

	AnnouncementLayer.super.ctor(self)

	self._delegate = delegate

	self:setNewTitleImage("#title_announcement_title.png")

    --self:setTitleImage("#title_strong.png")

    local switchButtonGroup = lt.SwitchButtonGroup.new()

    self._activityBtn = lt.SwitchButton.new("#common_switch_btn_gray_2.png", "#common_switch_btn_blue_2.png", {size=cc.size(468*self._winScale,40*self._winScale)})
    self._activityBtn:setPosition(self._bg:getContentSize().width / 2,self._bg:getContentSize().height - 38)
    self._activityBtn:setAnchorPoint(1,1)
    self._activityBtn:setTag(self.PANEL_TYPE.ACTIVITY)
    self._activityBtn:onButtonClicked(handler(self, self.onClickCallBack))
    self._bg:addChild(self._activityBtn)

    local activityLabel = lt.GameLabel.new(lt.StringManager:getString("STRING_ANNOUNCEMENT_TYPE_ACTIVITY"), lt.Constants.FONT_SIZE4,lt.Constants.COLOR.WHITE,{outline = true,outlineSize = 1,outlineColor = lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
    activityLabel:setPosition(-468 / 2*self._winScale,-40 / 2)
    self._activityBtn:addChild(activityLabel)


    switchButtonGroup:addSwitchButton(self._activityBtn)

    self._gameBtn = lt.SwitchButton.new("#common_switch_btn_gray_1.png", "#common_switch_btn_blue_1.png",  {size=cc.size(468*self._winScale,40*self._winScale)})
    self._gameBtn:setAnchorPoint(0,1)
    self._gameBtn:setTag(self.PANEL_TYPE.GAME)
    self._gameBtn:setPosition(self._bg:getContentSize().width / 2,self._bg:getContentSize().height - 38)
    self._gameBtn:onButtonClicked(handler(self, self.onClickCallBack))
    self._bg:addChild(self._gameBtn)

    local gameLabel = lt.GameLabel.new(lt.StringManager:getString("STRING_ANNOUNCEMENT_TYPE_SYSTEM"), lt.Constants.FONT_SIZE4,lt.Constants.COLOR.WHITE,{outline = true,outlineSize = 1,outlineColor = lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
    gameLabel:setPosition(468 / 2*self._winScale, -40 / 2)
    self._gameBtn:addChild(gameLabel)
    

    switchButtonGroup:addSwitchButton(self._gameBtn)
	

	local leftWhiteBg = lt.GameNewPanel.new(lt.GameNewPanel.TYPE.NEW_WHITE, 7, 7, cc.size(192*self._winScale, 500*self._winScale))
    leftWhiteBg:setAnchorPoint(0, 0)
	self._bg:addChild(leftWhiteBg)

    local listHeight = 492*self._winScale
    local blackBg = lt.GameListBg.new(lt.GameListBg.TYPE.GAME_LIST_BG_TYPE_4, listHeight, leftWhiteBg:getContentSize().width / 2, 5)
    blackBg:setAnchorPoint(0.5, 0)
    leftWhiteBg:addChild(blackBg)


    self._rightWhiteBg = lt.GameNewPanel.new(lt.GameNewPanel.TYPE.BLACK,self._bg:getContentSize().width - 7, 7, cc.size(740*self._winScale, 500*self._winScale))
    self._rightWhiteBg:setAnchorPoint(1, 0)
	self._bg:addChild(self._rightWhiteBg)


    self._titleListView = lt.ListView.new({
        viewRect  = cc.rect(0, 0, 185*self._winScale, 490*self._winScale),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,})
    	self._titleListView:onTouch(function(event)
        if event.name ~= "clicked" then
            return
        end
        
        local item = event.item

        local id = item:getContent().info:getId()
        self:onTitleItem(id)
    end)
    blackBg:addChild(self._titleListView)



    local padding = 7
    -- 公告内容

    self._infoScrollSize = cc.size(720, 490)
    self._infoScroll = lt.ScrollView.new({
                                        viewRect = cc.rect(10, 5, self._infoScrollSize.width * self._winScale, self._infoScrollSize.height* self._winScale),
                                        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL})
    self._infoScroll:setPosition(0, 0)
    self._rightWhiteBg:addChild(self._infoScroll, 2)

    self._infoScrollNode = display.newNode()
    self._infoScrollNode:setPosition(self._infoScroll:getViewRect().x, self._infoScroll:getViewRect().y)
    self._infoScroll:addScrollNode(self._infoScrollNode)

    self._infoNode = display.newNode()
    self._infoNode:setScale(self._winScale)
    self._infoScrollNode:addChild(self._infoNode)

    -- -- 二维码
    self._qrPosTable = {}
    self._qrPosTable[1] = cc.p(self._rightWhiteBg:getContentSize().width - 120 * self._winScale, 116 * self._winScale)
    self._qrPosTable[2] = cc.p(self._rightWhiteBg:getContentSize().width / 2, self._rightWhiteBg:getContentSize().height / 2)

    self._qrBtn = lt.PushButton.new(nil, {scale = 0.35 * self._winScale})
    self._qrBtn:setVisible(false)
    self._qrBtn:setPosition(self._qrPosTable[1])
    self._qrBtn:onButtonClicked(handler(self, self.onQR))
    self._rightWhiteBg:addChild(self._qrBtn, 10)

    self._activityBtn:select()
    self:updateTitleListView()

    self:onTitleItem()

end


function AnnouncementLayer:onEnter()
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NEW_FLAG_UPDATE, handler(self, self.updateNotice), "AnnouncementLayer:updateNotice")
end

function AnnouncementLayer:onExit()
	lt.GameEventManager:removeListener("AnnouncementLayer:updateNotice")

    for _,pic in ipairs(self._illustrationArray) do
        display.removeSpriteFrameByImageName(pic)
    end
end

function AnnouncementLayer:updateNotice()
	
end

function AnnouncementLayer:updateInfo(params)

end

function AnnouncementLayer:onClickCallBack(event)
	local tag = event.target:getTag()

	self._currentPanelType = tag

	self:updateTitleListView()
	self:onTitleItem()
end

function AnnouncementLayer:selectIndex()
	

end

function AnnouncementLayer:updateTitleListView(refresh)
	self._titleListView:removeAllItems()

	local announcementArray = lt.DataManager:getAnnouncementByType(self._currentPanelType)

    for idx,announcement in ipairs(announcementArray) do


        local content = lt.AnnouncementCell.new()
        content:updateInfo(announcement)
        content:setScale(self._winScale)
        content.info = announcement

        local item = self._titleListView:newItem(content)
        item:setItemSize(185 *self._winScale, 72 *self._winScale)

        self._titleListView:addItem(item)

    end

	self._titleListView:reload(refresh)
end

function AnnouncementLayer:onTitleItem(id)

	local allItems = self._titleListView:getAllChildren()

    if not id then

        -- 遍历ListView所有的Item 
        for _, tempItem in ipairs(allItems) do
            if tempItem == self._titleListView:getItemByPos(1) then
                -- 显示选中
                tempItem:getContent():selected()

                local info = tempItem:getContent().info
                self:updateContentNode(info)
            else
                -- 隐藏选中
                tempItem:getContent():unSelect()
            end
        end

        return
    end


	if id then
		-- 遍历ListView所有的Item 
	    for _, tempItem in ipairs(allItems) do
	        local itemId = tempItem:getContent().info:getId()
	        if itemId == id then
	            -- 显示选中
	            
	            tempItem:getContent():selected()
	            self:updateContentNode(tempItem:getContent().info)
	        else
	            -- 隐藏选中
	            tempItem:getContent():unSelect()
	        end
	    end
	end


end

function AnnouncementLayer:updateContentNode(info)
	if not info then
		return
	end

	self._infoNode:removeAllChildren()
	local announcement = info
    local height = 0

    -- 图片
    local illustration = announcement:getIllustration()
    if illustration > 0 then
    	-- 插图
    	local pic = string.format("image/announcement/illustration/announcement_illustration_%d.jpg", illustration)

        table.insert(self._illustrationArray, pic)

    	-- local illustrationBg = display.newSprite("#illustration_bg.png")
    	-- illustrationBg:setAnchorPoint(0.5, 1)
    	-- illustrationBg:setPosition(self._infoScrollSize.width / 2, -height)
    	-- self._infoNode:addChild(illustrationBg)

    	local path = cc.FileUtils:getInstance():fullPathForFilename(pic)
		if io.exists(path) then
			local illustrationPic = display.newSprite(pic)
			illustrationPic:setAnchorPoint(0.5, 1)

	    	illustrationPic:setPosition(self._infoScrollSize.width / 2, -height - 5)
	    	self._infoNode:addChild(illustrationPic)

	    	height = height + illustrationPic:getContentSize().height + 10
		end

    	
    end


    


    -- header
    local header = announcement:getHeader()
    --local headerLabel = self:getRichText(header, {size = 28})
    if header then
    	height = height + 10

    	local headBg = lt.GameInfoBg.new(lt.GameInfoBg.TYPE.GAME_INFO_BG_TYPE_22,cc.size(722,30),self._infoScroll:getViewRect().width / 2, -height)
    	headBg:setAnchorPoint(0.5, 1)
    	self._infoNode:addChild(headBg)

        local headerLabel = lt.GameLabel.new(header, lt.Constants.FONT_SIZE3, lt.Constants.COLOR.WHITE,{outline = true,outlineColor = lt.Constants.COLOR.EQUIP_BLACK})
        headerLabel:setAnchorPoint(0.5, 0.5)
        headerLabel:setPosition(headBg:getContentSize().width / 2, headBg:getContentSize().height / 2)
        headBg:addChild(headerLabel)

        height = height + headBg:getContentSize().height + 10
    end

    -- 分割线
    -- local line = display.newSprite("#announcement_line.png")
    -- line:setPosition(self._infoScrollSize.width / 2, -height)
    -- self._infoNode:addChild(line)

    -- height = height + line:getContentSize().height + 10

    local announcementLabel = self:getRichText(announcement:getText())
    if announcementLabel then
        announcementLabel:setAnchorPoint(cc.p(0, 1))
        announcementLabel:setPosition(0, -height)
        self._infoNode:addChild(announcementLabel)

        height = height + announcementLabel:getContentSize().height + 15
    end

    -- local announcementLabel = lt.GameLabel.new(announcement, 20, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
    -- announcementLabel:setAnchorPoint(0, 1)
    -- announcementLabel:setWidth(self._infoScrollSize.width)
    -- self._infoNode:addChild(announcementLabel, 100)

    -- height = height + announcementLabel:getContentSize().height + 15

    -- 调整
    height = height * self._winScale

    self._infoScrollNode:setContentSize(self._infoScroll:getViewRect().width, height)
    self._infoNode:setPositionY(math.max(height, self._infoScroll:getViewRect().height))
    self._infoScrollNode:setPosition(self._infoScroll:getViewRect().x, (self._infoScroll:getViewRect().height - math.max(height, self._infoScroll:getViewRect().height)) + self._infoScroll:getViewRect().y)

    -- 额外插图
    self._qrBtn:setVisible(false)
    local extraIllustration = announcement:getExtraIllustration()
    if extraIllustration > 0 then
    	-- 插图
    	local pic = string.format("image/announcement/illustration/announcement_illustration_%d.jpg", extraIllustration)

    	local path = cc.FileUtils:getInstance():fullPathForFilename(pic)
		if io.exists(path) then

            table.insert(self._illustrationArray, pic)

			self._qrBtn:setVisible(true)
			self._qrBtn:setButtonImage(lt.PushButton.NORMAL, pic)
		end
    end
end

function AnnouncementLayer:getRichText(str, params)
	params = params or {}
	local fontSize = params.size or 18

    -- 文本裁切处理 <color> </color>
    local clumpheadTab = {} -- 标签头
    local clumptailTab = {} -- 标签尾
    --作用，取出所有格式为[xxxx]的标签头
    for w in string.gfind(str, "%b<>") do 
        if  string.sub(w,2,2) == "/" then-- 去尾
            table.insert(clumptailTab, w)
        else
            table.insert(clumpheadTab, w)
        end
    end

    if #clumpheadTab ~= #clumptailTab then -- 符号不匹配? 错了!
        return
    end

    local splitTable = {}
    for idx,headTab in ipairs(clumpheadTab) do
        local st1, ed1 = string.find(str, headTab)
        if st1 then
            local tailTab = clumptailTab[idx]
            local st2, ed2 = string.find(str, tailTab)
            if not st2 then
                break
            end

            if st1 > 1 then
                -- 之前有普通文本
                local preStr = string.sub(str, 1, st1 - 1)

                table.insert(splitTable, {text = preStr})
            end

            local specialStr = string.sub(str, ed1 + 1, st2 - 1)

            -- 解析headTab
            if headTab == "<color>" then
                table.insert(splitTable, {text = specialStr, color = true})
            elseif headTab == "<br2>" then
                table.insert(splitTable, {br2 = true})
            elseif headTab == "<br>" then
            	table.insert(splitTable, {br = true})
            else
                table.insert(splitTable, {text = specialStr})
            end

            str = string.sub(str, ed2+1)
        else
            break
        end
    end
    if #str > 0 then
        -- 剩余文本
        table.insert(splitTable, {text = str})
    end


    local textLabel = lt.RichText.new()
    textLabel:setSize(cc.size(self._infoScrollSize.width, 10))

    for _,splitInfo in ipairs(splitTable) do
        if splitInfo.br then
    		local br = lt.RichNewLine.new()
	        textLabel:insertElement(br)
    	else
	        local text = splitInfo.text
	        local color = splitInfo.color
	        local fontColor = lt.Constants.COLOR.WHITE

	        if color then
	            fontColor = lt.Constants.COLOR.CITY_CHAT_ORANCE
	        end

	        local strLabel = lt.RichTextText.new(text, fontSize, fontColor)
	        textLabel:insertElement(strLabel)
	    end
    end

    textLabel:formatText()

    return textLabel
end


function AnnouncementLayer:close()
	self._delegate:clearAnnouncementLayer()
end

function AnnouncementLayer:clearCurrentPanel()
	if self._currentPanel then
		self._currentPanelType = self.PANEL_TYPE.INVALID

		self._currentPanel:removeSelf()
		self._currentPanel = nil
	end
end

function AnnouncementLayer:onActivityBtn(event)
	local tag = event.target:getTag()

	if self._currentPanelType == tag then
		return
	end

	self:clearCurrentPanel()

	self._currentPanelType = tag

	self:selectCurrentPanel()

end

function AnnouncementLayer:onQR()
    local duration = 0.15

    if self._qrType == 0 then
        self._qrType = 1

        self._qrBtn:stopAllActions()
        self._qrBtn:runAction(cca.spawn{
                cca.moveTo(duration, self._qrPosTable[2].x, self._qrPosTable[2].y),
                cca.scaleTo(duration, 3 * self._qrBtn:getBaseScale())
            })
    else
        self._qrType = 0

        self._qrBtn:stopAllActions()
        self._qrBtn:runAction(cca.spawn{
                cca.moveTo(duration, self._qrPosTable[1].x, self._qrPosTable[1].y),
                cca.scaleTo(duration, 1 * self._qrBtn:getBaseScale())
            })
    end
end

function AnnouncementLayer:getDelegate()
	return self._delegate
end

function AnnouncementLayer:selectCurrentPanel()
	if self._currentPanelType == self.PANEL_TYPE.FIGHT then

		self._currentPanel = lt.NewServancePanel.new(self)
		self._currentPanel:updateInfo(self._currentPanelType)
		self._currentPanel:setContentSize(cc.size(740*self._winScale, 546*self._winScale))
		self._currentPanel:setAnchorPoint(0, 0)
		self._currentPanel:setPosition(0, 0)
		self._rightWhiteBg:addChild(self._currentPanel)

	elseif self._currentPanelType == self.PANEL_TYPE.LEVELUP then

		self._currentPanel = lt.LevelingRewardPanel.new(self)
		self._currentPanel:updateInfo(self._currentPanelType)
		self._currentPanel:setContentSize(cc.size(740*self._winScale, 546*self._winScale))
		self._currentPanel:setAnchorPoint(0, 0)
		self._currentPanel:setPosition(0, 0)
		self._rightWhiteBg:addChild(self._currentPanel)
		
	end
end

return AnnouncementLayer
