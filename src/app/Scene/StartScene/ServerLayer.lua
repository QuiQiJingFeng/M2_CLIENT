
-- ################################################## 服务器选择界面 ##################################################
-- 服务器大类区分
local ServerClassCell = class("ServerClassCell", function()
    return display.newSprite("#common_tab_gray_1.png")
end)

ServerClassCell.TYPE = {
    CHARACTER = 0,  -- 已有角色
    RECOMMEND = 1,  -- 推荐
    GROUP     = 2,  -- 服务器群组
    DEBUG     = 99, -- 测试
}

ServerClassCell._type   = nil
ServerClassCell._zoneId = nil

function ServerClassCell:ctor(type, params)
    self._type = type

    local str = ""
    if type == self.TYPE.CHARACTER then
        str = lt.StringManager:getString("STRING_SERVER_CHARACTER")
    elseif type == self.TYPE.RECOMMEND then
        str = lt.StringManager:getString("STRING_SERVER_RECOMMEND")
    elseif type == self.TYPE.GROUP then
        self._zoneId = params.id or 1

        -- str = string.format(lt.StringManager:getString("STRING_SERVER_GROUP"), (self._idx - 1) * 10 + 1, self._idx * 10)
        str = params.name
    elseif type == self.TYPE.DEBUG then
        str = lt.StringManager:getString("STRING_SERVER_DEBUG")
    end

    local name = lt.GameLabel.new(str, lt.Constants.FONT_SIZE4, lt.Constants.COLOR.WHITE, {outline = true,outlineSize=1,outlineColor=lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
    name:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
    self:addChild(name)
end

function ServerClassCell:selected()
    self:setSpriteFrame("common_tab_yellow_1.png")
end

function ServerClassCell:unselected()
    self:setSpriteFrame("common_tab_gray_1.png")
end

function ServerClassCell:getType()
    return self._type
end

function ServerClassCell:getZoneId()
    return self._zoneId
end

-- 服务器类
local ServerCell = class("ServerCell", function()
	return lt.GameListCell.new(lt.GameListCell.TYPE.GAME_LIST_CELL_TYPE_1,310)
end)

ServerCell._serverId = nil

function ServerCell:updateInfo(serverInfo, token, preSelect)
	self._serverId = serverInfo:getIndex()

    local state = serverInfo:getState()

    local nameLabel = lt.GameLabel.new(serverInfo:getName(), 18, lt.Constants.COLOR.WHITE,{outline=true,outlineColor=lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
    nameLabel:setAnchorPoint(0,0.5)
    nameLabel:setPosition(70, self:getContentSize().height / 2+25)
    self:addChild(nameLabel)

    -- 判断这个服务器是否存在账号
    local playerArray = lt.PreferenceManager:getLoginPlayerArray(token, self._serverId)
    if #playerArray > 0 then
        local iconFigure = display.newSprite("#select_icon_figure.png")
        iconFigure:setPosition(nameLabel:getPositionX()+185,self:getContentSize().height / 2)
        self:addChild(iconFigure)
    end

    local stateStr = "#select_icon_green.png"
    if state == lt.ServerInfo.STATE.HOT then
        stateStr = "#select_icon_orange.png"
    elseif state == lt.ServerInfo.STATE.MAINTENANCE then
        stateStr = "#select_icon_gray.png"
    end

    local currTime = lt.CommonUtil:getCurrentTime()
    local diffTime = currTime - serverInfo:getOpenTime()
    if diffTime < 7*86400 and diffTime > 0 then
        local iconNew = display.newSprite("#common_img_newIcon.png")
        iconNew:setPosition(25,self:getContentSize().height-10)
        self:addChild(iconNew,10)
    end

    if diffTime > -3*86400 and diffTime < 0 then
        stateStr = "#select_icon_gray.png"
        local timeLabel = lt.GameLabel.new(lt.CommonUtil:getFormatDay(serverInfo:getOpenTime(),3), 18, lt.Constants.COLOR.QUALITY_BLUE)
        timeLabel:setPosition(nameLabel:getPositionX()+160, nameLabel:getPositionY())
        self:addChild(timeLabel)
    end

    local iconState = display.newSprite(stateStr)
    iconState:setPosition(40, nameLabel:getPositionY())
    self:addChild(iconState)
    
end

function ServerCell:getServerId()
	return self._serverId
end

-- 服务器类(带角色)
local ServerCharacterCell = class("ServerCharacterCell", function()
    return lt.GameListCell.new(lt.GameListCell.TYPE.GAME_LIST_CELL_TYPE_1, 640)
end)

ServerCharacterCell._serverId = nil

function ServerCharacterCell:updateInfo(serverInfo, token)
    self._serverId = serverInfo:getIndex()

    local state = serverInfo:getState()
    if state == lt.ServerInfo.STATE.NORMAL then
        local iconNormal = display.newSprite("#select_icon_green.png")
        iconNormal:setPosition(40, self:getContentSize().height / 2 + 25)
        self:addChild(iconNormal)
    elseif state == lt.ServerInfo.STATE.HOT then
        local iconHot = display.newSprite("#select_icon_orange.png")
        iconHot:setPosition(40, self:getContentSize().height / 2 + 25)
        self:addChild(iconHot)
    elseif state == lt.ServerInfo.STATE.MAINTENANCE then
        local iconMaintenance = display.newSprite("#select_icon_gray.png")
        iconMaintenance:setPosition(40, self:getContentSize().height / 2 + 25)
        self:addChild(iconMaintenance)
    end

    local nameLabel = lt.GameLabel.new(serverInfo:getName(), 18, lt.Constants.COLOR.WHITE,{outline=true,outlineColor=lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
    nameLabel:setAnchorPoint(0,0.5)
    nameLabel:setPosition(80, self:getContentSize().height / 2+25)
    self:addChild(nameLabel)

    local playerArray = lt.PreferenceManager:getLoginPlayerArray(token, self._serverId)
    local i = 0
    for _,loginPlayer in pairs(playerArray) do
        --左上头像
        local heroInfoBg = display.newSprite("image/ui/common/touch_rect_80.png")
        heroInfoBg:setScale(0.8)
        heroInfoBg:setPosition(self:getContentSize().width - 40 - i*100, self:getContentSize().height-15)
        self:addChild(heroInfoBg)

        local info = lt.CacheManager:getModelHeroInfo(loginPlayer.occupation_id, loginPlayer.sex)
        if info then
            local id = info:getId()

            if id ~= 1 and id ~= 6 and id ~= 8 then--临时限制
                id = 1
            end

            local file = string.format("model/hmodel_%d", id)

            local figure = lt.SkeletonAnimation.new(file)
            figure:setAnimation(0, "stand", true)
            figure:setScale(0.9)
            heroInfoBg:addChild(figure)

            local occupationIcon = lt.SmallOccupationIcon.new(loginPlayer.occupation_id)
            occupationIcon:setPosition(figure:getPositionX()-25,figure:getPositionY()-53)
            heroInfoBg:addChild(occupationIcon)

            local levelLabel = lt.GameLabel.new("Lv."..loginPlayer.level, 22, lt.Constants.DEFAULT_LABEL_COLOR_2,{outline=true})
            levelLabel:setAnchorPoint(0,0.5)
            levelLabel:setPosition(occupationIcon:getPositionX()+20, occupationIcon:getPositionY())
            heroInfoBg:addChild(levelLabel)

            i = i + 1
        end
    end
    
end

function ServerCharacterCell:getServerId()
    return self._serverId
end

-- 服务器选择界面
local ServerLayer = class("ServerLayer", lt.CommonInterFaceLayer2)

ServerLayer._winScale = lt.CacheManager:getWinScale()
ServerLayer.SIZE      = cc.size(930, 560)

ServerLayer._delegate = nil
ServerLayer._token    = nil

ServerLayer._selectClassCell = nil
ServerLayer._serverArray = nil
ServerLayer._serverTable = nil
ServerLayer._debugServerArray = nil

ServerLayer._type   = nil
ServerLayer._zoneId = nil

function ServerLayer:ctor(delegate)
    self.super.ctor(self)
	self._delegate = delegate

	self:setNodeEventEnabled(true)

    local maskLayer = lt.MaskLayer.new()
    self:addChild(maskLayer, -1)

    self:setTitle(lt.StringManager:getString("STRING_SERVER_LIST"))

    self:setNewTitleImage("#title_server_title.png")

    local serverClassBgSize = cc.size(180 * self._winScale, 548 * self._winScale)
    local leftBg = lt.GameListBg.new(lt.GameListBg.TYPE.GAME_LIST_BG_TYPE_4,548*self._winScale,6,6)
    leftBg:setAnchorPoint(0,0)
    self._bg:addChild(leftBg)

    -- 服务器大类列表
    self._serverClassList = lt.ListView.new {
            viewRect = cc.rect(2, 0, serverClassBgSize.width, serverClassBgSize.height-2),
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
                :onTouch(function( event )
                    if event.name ~= "clicked" then
                        return
                    end

                    self:onServerClass(event.item:getContent())
                end)
    leftBg:addChild(self._serverClassList)

    local iconFluent = display.newSprite("#select_icon_green.png")
    iconFluent:setPosition(self._bg:getContentSize().width/2+120*self._winScale,self._bg:getContentSize().height-55*self._winScale)
    self._bg:addChild(iconFluent)

    local lblFluent = lt.GameLabel.new(lt.StringManager:getString("STRING_SERVER_FLUENT"),lt.Constants.FONT_SIZE3,lt.Constants.DEFAULT_LABEL_COLOR_2,{outline=true})
    lblFluent:setPosition(iconFluent:getPositionX()+45*self._winScale,iconFluent:getPositionY())
    self._bg:addChild(lblFluent)

    local iconFull = display.newSprite("#select_icon_orange.png")
    iconFull:setPosition(lblFluent:getPositionX()+55*self._winScale,lblFluent:getPositionY())
    self._bg:addChild(iconFull)

    local lblFull = lt.GameLabel.new(lt.StringManager:getString("STRING_SERVER_FULL"),lt.Constants.FONT_SIZE3,lt.Constants.DEFAULT_LABEL_COLOR_2,{outline=true})
    lblFull:setPosition(iconFull:getPositionX()+45*self._winScale,iconFull:getPositionY())
    self._bg:addChild(lblFull)

    local iconMaintance = display.newSprite("#select_icon_gray.png")
    iconMaintance:setPosition(lblFull:getPositionX()+55*self._winScale,lblFull:getPositionY())
    self._bg:addChild(iconMaintance)

    local lblMaintance = lt.GameLabel.new(lt.StringManager:getString("STRING_SERVER_MAINTANCE"),lt.Constants.FONT_SIZE3,lt.Constants.DEFAULT_LABEL_COLOR_2,{outline=true})
    lblMaintance:setPosition(iconMaintance:getPositionX()+55*self._winScale,iconMaintance:getPositionY())
    self._bg:addChild(lblMaintance)

    local listBgSize = cc.size(658 * self._winScale, 510 * self._winScale)
    local listBg = lt.GameNewPanel.new(lt.GameNewPanel.TYPE.NEW_WHITE,self._bg:getContentSize().width-6,6,listBgSize)
    listBg:setAnchorPoint(1,0)
    self._bg:addChild(listBg)

    local serverBg = display.newSprite("image/ui/server_bg.jpg")
    serverBg:setScale(self._winScale)
    serverBg:setAnchorPoint(1,0.5)
    serverBg:setPosition(listBg:getContentSize().width-2,listBg:getContentSize().height/2)
    listBg:addChild(serverBg)

    -- 服务器列表
    self._serverList = lt.ListView.new {
            viewRect = cc.rect(0, 5, listBgSize.width, listBgSize.height-6),
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
            col = 2}
                :onTouch(function( event )
                    if event.name ~= "clicked" then
                        return
                    end

                    self:onServerCell(event.item:getContent())
                end)
    listBg:addChild(self._serverList)
end

function ServerLayer:onExit()
    display.removeSpriteFrameByImageName("image/ui/server_bg.jpg")
end

function ServerLayer:updateInfo(token)
    lt.NoticeManager:clearAll()
    lt.NoticeManager:init(self)
	self:setVisible(true)

    self._token = token
    self:updateClassList(true)
end

function ServerLayer:updateClassList(default)
    self._selectClassCell = nil

    self._serverClassList:removeAllItems()

    -- 已有角色
    local characterClass = ServerClassCell.new(ServerClassCell.TYPE.CHARACTER)
    characterClass:setScale(self._winScale)

    local item = self._serverClassList:newItem(characterClass)
    item:setItemSize(202 * self._winScale, 74 * self._winScale)
    self._serverClassList:addItem(item)

    -- 推荐
    local recommendClass = ServerClassCell.new(ServerClassCell.TYPE.RECOMMEND)
    recommendClass:setScale(self._winScale)

    local item = self._serverClassList:newItem(recommendClass)
    item:setItemSize(202 * self._winScale, 74 * self._winScale)
    self._serverClassList:addItem(item)

    self._serverArray, self._debugServerArray = lt.DataManager:getServerArray()
    self._serverTable = {}
    for _,serverInfo in ipairs(self._serverArray) do
        while true do
            if serverInfo:getHideFlag() then
                -- 测试区 不可见
                break
            end

            local zoneId = serverInfo:getZoneId()
            if not isset(self._serverTable, zoneId) then
                self._serverTable[zoneId] = {}
                self._serverTable[zoneId]["id"]          = zoneId
                self._serverTable[zoneId]["name"]        = serverInfo:getZoneName()
                self._serverTable[zoneId]["serverArray"] = {}
            end

            local serverArray = self._serverTable[zoneId]["serverArray"]

            serverArray[#serverArray + 1] =  serverInfo
            break
        end
    end


    -- 正常区服
    for zoneId, zoneInfo in pairs(self._serverTable) do
        local groupClass = ServerClassCell.new(ServerClassCell.TYPE.GROUP, zoneInfo)
        groupClass:setScale(self._winScale)

        local item = self._serverClassList:newItem(groupClass)
        item:setItemSize(202 * self._winScale, 74 * self._winScale)
        self._serverClassList:addItem(item)
    end

    -- 是否有测试服
    local debugServerCount = #self._debugServerArray
    if debugServerCount > 0 then
        local debugClass = ServerClassCell.new(ServerClassCell.TYPE.DEBUG)
        debugClass:setScale(self._winScale)

        local item = self._serverClassList:newItem(debugClass)
        item:setItemSize(202 * self._winScale, 74 * self._winScale)
        self._serverClassList:addItem(item)
    end

    self._serverClassList:reload()

    if default then
        -- 默认选择推荐
        self._selectClassCell = recommendClass
        self._selectClassCell:selected()

        self._type = ServerClassCell.TYPE.RECOMMEND

        self:updateServerList()
    end
end

function ServerLayer:onServerClass(serverClassCell)
    if self._selectClassCell then
        self._selectClassCell:unselected()
    end

    self._selectClassCell = serverClassCell
    self._selectClassCell:selected()

    self._type   = self._selectClassCell:getType()
    self._zoneId = self._selectClassCell:getZoneId()

    self:updateServerList()
end

function ServerLayer:updateServerList()
    self._serverList:removeAllItems()

    local currTime = lt.CommonUtil:getCurrentTime()

    if not self._type then
        self._serverList:reload()
        return
    end

    if self._type == ServerClassCell.TYPE.CHARACTER then
        ---- 已有角色列表
        self._serverList:setCol(1)

        local lastServerId = lt.PreferenceManager:getDefaultServerId(self._token)
        local serverInfo1 = lt.DataManager:getServerInfo(lastServerId)
        if serverInfo1 then
            local serverCharacterCell1 = ServerCharacterCell.new()
            serverCharacterCell1:setScale(self._winScale)
            serverCharacterCell1:updateInfo(serverInfo1, self._token)
            serverCharacterCell1:setScale(self._winScale)

            local item1 = self._serverList:newItem(serverCharacterCell1)
            item1:setItemSize(616 * self._winScale, 114 * self._winScale)
            self._serverList:addItem(item1)
        end

        for _,serverInfo in ipairs(self._serverArray) do
            while true do
                local playerArray = lt.PreferenceManager:getLoginPlayerArray(self._token, serverInfo:getIndex())

                if #playerArray == 0 or serverInfo:getIndex() == lastServerId then
                    break
                end

                local serverCharacterCell = ServerCharacterCell.new()
                serverCharacterCell:setScale(self._winScale)
                serverCharacterCell:updateInfo(serverInfo, self._token)
                serverCharacterCell:setScale(self._winScale)

                local item = self._serverList:newItem(serverCharacterCell)
                item:setItemSize(616 * self._winScale, 114 * self._winScale)
                self._serverList:addItem(item)

                break
            end
        end

    elseif self._type == ServerClassCell.TYPE.RECOMMEND then
        ---- 推荐列表
        self._serverList:setCol(2)

        -- 上次选择
        local defaultServerId = lt.PreferenceManager:getDefaultServerId(self._token)
        local defaultServerInfo = lt.DataManager:getServerInfo(defaultServerId)
        local serverCount = 0

        local serverSum = #self._serverArray
        for i=serverSum,1,-1 do
            local serverInfo = self._serverArray[i]
            local diffTime = currTime - serverInfo:getOpenTime()
            if diffTime < 7*86400 and diffTime > 0 and not serverInfo:getHideFlag() then
                local serverCell = ServerCell.new()
                serverCell:setScale(self._winScale)
                serverCell:updateInfo(serverInfo, self._token)
                serverCell:setScale(self._winScale)

                local item = self._serverList:newItem(serverCell)
                item:setItemSize(336 * self._winScale, 114 * self._winScale)
                self._serverList:addItem(item)
            end
        end

    elseif self._type == ServerClassCell.TYPE.GROUP then
        ---- 区服组
        self._serverList:setCol(2)

        if not self._zoneId then
            self._serverList:reload()
            return
        end

        local serverArray = self._serverTable[self._zoneId]["serverArray"]

        table.sort(serverArray, function(a, b)
            return a:getOpenTime() > b:getOpenTime()
        end)

        for _,serverInfo in ipairs(serverArray) do
            local serverCell = ServerCell.new()
            serverCell:setScale(self._winScale)
            serverCell:updateInfo(serverInfo, self._token)
            serverCell:setScale(self._winScale)

            local item = self._serverList:newItem(serverCell)
            item:setItemSize(336 * self._winScale, 114 * self._winScale)
            self._serverList:addItem(item)
        end
    elseif self._type == ServerClassCell.TYPE.DEBUG then
        -- 测试
        self._serverList:setCol(2)
    end


    self._serverList:reload()
end

function ServerLayer:onServerCell(serverCell)
    local serverId = serverCell:getServerId()

    local serverInfo = lt.DataManager:getServerInfo(serverId)
    local currTime = lt.CommonUtil:getCurrentTime()
    local diffTime = currTime - serverInfo:getOpenTime()
    if diffTime > -3*86400 and diffTime < 0 then
        --lt.NoticeManager:init(self)
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_SERVER_NOT_OPEN"))
        return
    end

    self._delegate:updateServerInfo(serverInfo)
    self:close()
end

function ServerLayer:onClose()
	self:close()
end

function ServerLayer:close()
    lt.NoticeManager:clearAll()
    lt.NoticeManager:init(self:getParent())
	self:setVisible(false)
end

return ServerLayer