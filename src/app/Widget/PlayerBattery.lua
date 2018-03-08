
local PlayerBattery = class("PlayerBattery", function()
	return display.newNode()
end)
PlayerBattery._winScale = lt.CacheManager:getWinScale()

PlayerBattery._scheduleHandle = nil

PlayerBattery._netLevel = nil
PlayerBattery._updateHandler = nil
PlayerBattery._delegate = nil
function PlayerBattery:ctor(delegate)
    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:setNodeEventEnabled(true)
    self._delegate = delegate

    local expBg = display.newSprite("#city_img_sign_bg.png")
    expBg:setAnchorPoint(0,1)
    self:addChild(expBg)

    -- 电量
    local batteryBg = display.newSprite("image/ui/battery_1.png")
    batteryBg:setAnchorPoint(0, 0.5)
    batteryBg:setPosition(10, expBg:getContentSize().height / 2)
    expBg:addChild(batteryBg)


    self._battery = display.newProgressTimer("image/ui/battery_2.png", 1)
    self._battery:setPosition(batteryBg:getContentSize().width / 2, batteryBg:getContentSize().height / 2)
    self._battery:setMidpoint(cc.p(0,0))
    self._battery:setBarChangeRate(cc.p(1,0))
    self._battery:setPercentage(0)
    batteryBg:addChild(self._battery)

    -- 信号标志
    self._netFlag = display.newSprite("image/net/team_wifi_1.png")
    self._netFlag:setAnchorPoint(0, 0.5)
    --self._netFlag:setScale(0.55)
    self._netFlag:setPosition(55, expBg:getContentSize().height / 2)
    expBg:addChild(self._netFlag)

    -- 服务器时间
    self._timeLabel = lt.GameLabel.new("-:-", 13, lt.Constants.COLOR.WHITE)
    self._timeLabel:setAnchorPoint(0, 0.5)
    self._timeLabel:setPosition(90, expBg:getContentSize().height / 2)
    expBg:addChild(self._timeLabel, 200)

    --频道
    self._lineLabel = lt.GameLabel.new("", 13, lt.Constants.COLOR.WHITE)
    self._lineLabel:setPosition(156, expBg:getContentSize().height / 2)
    expBg:addChild(self._lineLabel, 200)

    local blueLine1 = display.newSprite("#city_icon_blue.png")
    blueLine1:setAnchorPoint(0, 0.5)
    blueLine1:setPosition(186, expBg:getContentSize().height / 2)
    expBg:addChild(blueLine1)

    local propertyLable = lt.GameLabel.new(lt.StringManager:getString("STRING_SERVER_PROPERTY_TODAY"), 13, lt.Constants.COLOR.WHITE)
    propertyLable:setAnchorPoint(0, 0.5)
    propertyLable:setPosition(195, expBg:getContentSize().height / 2)
    expBg:addChild(propertyLable)

    -- 今日元素属性
    local serverPropertyButton = lt.PushButton.new("image/ui/common/touch_rect_80.png")
    serverPropertyButton:setPosition(230, expBg:getContentSize().height / 2 + 17)
    serverPropertyButton:onButtonClicked(handler(self, self.onServerProperty))
    --serverPropertyButton:setOpacity(0)
    expBg:addChild(serverPropertyButton)

    self._serverPropertyIcon = lt.PropertyIcon.new()
    self._serverPropertyIcon:setScale(0.5)
    self._serverPropertyIcon:setPosition(260, expBg:getContentSize().height / 2)
    expBg:addChild(self._serverPropertyIcon)

    local blueLine2 = display.newSprite("#city_icon_blue.png")
    blueLine2:setAnchorPoint(0, 0.5)
    blueLine2:setPosition(275, expBg:getContentSize().height / 2)
    expBg:addChild(blueLine2)

    -- ping
    -- self._netPing = lt.GameLabel.new("1000", 10, cc.c3b(0x44, 0xf8, 0xfe))
    -- self._netPing:setAnchorPoint(1, 0.5)
    -- self._netPing:setPosition(expBg:getContentSize().width - 84, expBg:getContentSize().height / 2)
    -- expBg:addChild(self._netPing, 200)

    self:updateInfo()
end

function PlayerBattery:onEnter()
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SERVER_PARAMS_UPDATE, handler(self, self.onServerParamsUpdate), "PlayerBattery:onServerParamsUpdate")

    self._updateHandler = lt.scheduler.scheduleGlobal(handler(self, self.updateInfo), 1)
end

function PlayerBattery:onExit()

    if self._updateHandler then
        lt.scheduler.unscheduleGlobal(self._updateHandler)
        self._updateHandler = nil
    end

    lt.GameEventManager:removeListener("PlayerBattery:onServerParamsUpdate")
end

function PlayerBattery:onServerProperty()

    if self._delegate then
        self._delegate:onServerProperty()
    end
end

function PlayerBattery:onServerParamsUpdate()
    if self._serverPropertyIcon then
        self._serverPropertyIcon:update(lt.DataManager:getServerProperty())
    end
end

function PlayerBattery:updateInfo()
    -- 时间
    local time = lt.CommonUtil:getFormatDay(nil, 11)
    self._timeLabel:setString(time)

    -- 线路
    local player = lt.DataManager:getPlayer()
    local worldMapId  = player:getWorldMapId()
    local worldMapKey = player:getWorldMapKey()
    local worldMap = lt.CacheManager:getWorldMap(worldMapId)
    if worldMap then
        local worldMapType = worldMap:getType()
        if worldMapType == lt.Constants.ENV_TYPE.CITY
        or worldMapType == lt.Constants.ENV_TYPE.FIELD
        or worldMapType == lt.Constants.ENV_TYPE.FISHING
        or worldMapType == lt.Constants.ENV_TYPE.NATION_ANSWER_PARTY then
            self._lineLabel:setString(lt.StringManager:getFormatString("STRING_GAME_LINE", worldMapKey))
        elseif worldMapType == lt.Constants.ENV_TYPE.GUILD then
            self._lineLabel:setString(lt.StringManager:getString("STRING_GAME_GUILD"))
        else
            self._lineLabel:setString(lt.StringManager:getString("STRING_GAME_DUNGEON"))
        end
    else
        self._lineLabel:setString("")
    end

    -- 电量
    if device.platform == "ios" or device.platform == "android" then
        local batteryLevel = cpp.ExtraAPI:getBatteryLevel()
        if batteryLevel == -1 then
            -- 电量未知
            self._battery:setPercentage(0)
        else
            self._battery:setPercentage(batteryLevel * 100)
        end
    end

    -- 信号
    local playerNetEnv = lt.DataManager:getSelfNetEnv()
    if playerNetEnv then
        local netLevel = playerNetEnv:getNetLevel()
        if netLevel == 0 then
            netLevel = 3
        end

        if not self._netLevel or self._netLevel ~= netLevel then
            local netFlagPic = string.format("image/net/team_wifi_%d.png", netLevel)
            self._netFlag:setTexture(netFlagPic)
        end
    end

    -- ping
    if self._netPing then
        self._netPing:setString(string.format("%.0f", lt.SocketManager:getAlivePing()))
    end

    if self._serverPropertyIcon then
        self._serverPropertyIcon:update(lt.DataManager:getServerProperty())
    end
end


return PlayerBattery
