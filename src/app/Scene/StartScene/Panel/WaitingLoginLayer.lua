
local WaitingLoginLayer = class("WaitingLoginLayer", function()
	return display.newLayer()
end)

WaitingLoginLayer._updateHandler = nil

WaitingLoginLayer._delegate = nil

function WaitingLoginLayer:ctor(delegate)
	self._delegate = delegate

	self:setNodeEventEnabled(true)

	-- 提示框
    local bg = lt.GamePanel.new(lt.GamePanel.TYPE.NEW_BGWHITE, display.cx, display.cy, cc.size(395, 245))
    self:addChild(bg, 10)

    local blackBg = lt.GamePanel.new(lt.GamePanel.TYPE.NEW_BLACK, bg:getContentSize().width/2, 5, cc.size(384, 195))
    blackBg:setAnchorPoint(0.5,0)
    bg:addChild(blackBg)

    local whiteBg = lt.GamePanel.new(lt.GamePanel.TYPE.NEW_WHITE, blackBg:getContentSize().width/2, 4, cc.size(376, 186))
    whiteBg:setAnchorPoint(0.5,0)
    blackBg:addChild(whiteBg)

    local padding = 7

    local iconAlert = display.newSprite("image/ui/common/common_icon_alert.png")
    iconAlert:setAnchorPoint(0,1)
    iconAlert:setPosition(20, bg:getContentSize().height+7)
    bg:addChild(iconAlert)

    local title = lt.GameLabel.newString("STRING_WAITING_LOGIN_TITLE", 20, lt.Constants.DEFAULT_LABEL_COLOR_2, {outline = true})
    title:setAnchorPoint(0, 0.5)
    title:setPosition(100, bg:getContentSize().height - 32)
    bg:addChild(title)

    -- 服务器
    local serverTitle = lt.GameLabel.newString("STRING_WAITING_SERVER", 18, lt.Constants.DEFAULT_LABEL_COLOR_2)
    serverTitle:setAnchorPoint(1, 0.5)
    serverTitle:setPosition(whiteBg:getContentSize().width / 2 - 40, whiteBg:getContentSize().height - padding - 26)
    whiteBg:addChild(serverTitle)

    self._serverBg = display.newScale9Sprite("image/ui/common/common_label_bg_2.png", whiteBg:getContentSize().width / 2 + 60, whiteBg:getContentSize().height - padding - 26, cc.size(120, 28))
    whiteBg:addChild(self._serverBg)

    self._serverLabel = lt.GameLabel.new("", 18, lt.Constants.DEFAULT_LABEL_COLOR_2, {outline = true})
    -- self._serverLabel:setPosition(self._serverBg:getContentSize().width / 2, self._serverBg:getContentSize().height / 2)
    self._serverBg:addChild(self._serverLabel)

    self._waitCount = lt.GameLabel.new("", 18, lt.Constants.DEFAULT_LABEL_COLOR_2)
    self._waitCount:setPosition(whiteBg:getContentSize().width / 2, whiteBg:getContentSize().height - padding - 66)
    whiteBg:addChild(self._waitCount)

    local waitTimeTitle = lt.GameLabel.newString("STRING_WAITING_TIME", 18, lt.Constants.DEFAULT_LABEL_COLOR_2)
    waitTimeTitle:setAnchorPoint(1, 0.5)
    waitTimeTitle:setPosition(whiteBg:getContentSize().width / 2 - 40, whiteBg:getContentSize().height - padding - 96)
    whiteBg:addChild(waitTimeTitle)

    self._waitTime = lt.GameLabel.new("XXXXXXXXX", 18, lt.Constants.DEFAULT_LABEL_COLOR_2)
    self._waitTime:setPosition(whiteBg:getContentSize().width / 2 + 60, whiteBg:getContentSize().height - padding - 96)
    whiteBg:addChild(self._waitTime)

    -- 停止排队
    local stopBtn = lt.ScaleLabelButton.newYellow("STRING_WAITING_QUIT")
    stopBtn:setPosition(bg:getContentSize().width / 2, 54)
    stopBtn:onButtonClicked(handler(self, self.onWaitingStop))
    bg:addChild(stopBtn, 20)
end

function WaitingLoginLayer:onEnter()
	self._updateHandler = lt.scheduler.scheduleGlobal(handler(self, self.onUpdate), 5)

	lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_LOGIN_WAITING_COUNT, handler(self, self.onLoginWaitingCount), "WaitingLoginLayer:onLoginWaitingCount")
end

function WaitingLoginLayer:onExit()
	if self._updateHandler then
		lt.scheduler.unscheduleGlobal(self._updateHandler)
		self._updateHandler = nil
	end

	lt.SocketApi:removeEventListenersByTag("WaitingLoginLayer:onLoginWaitingCount")
end

function WaitingLoginLayer:onUpdate(delta)
	-- 请求最新排队人数
	lt.SocketApi:getLoginWaitingCount()
end

function WaitingLoginLayer:updateInfo(params)
	params = params or {}

	-- 服务器信息
	local serverInfo = lt.DataManager:getCurServer()
	if serverInfo then
		self._serverLabel:setString(serverInfo:getName())
		self._serverBg:setPreferredSize(cc.size(self._serverLabel:getContentSize().width + 16, 28))
		self._serverLabel:setPosition(self._serverBg:getContentSize().width / 2, self._serverBg:getContentSize().height / 2)
	else
		self._serverLabel:setString("-")
	end

	-- 等待人数
	local waitCount = params.waitCount or 1
	self._waitCount:setString(string.format(lt.StringManager:getString("STRING_WAITING_COUNT"), waitCount))

	-- 等待时间
	local waitTime = params.waitTime or 0
	self._waitTime:setString(lt.CommonUtil:getFormatCountDown(waitTime, 11))
end

function WaitingLoginLayer:onLoginWaitingCount(event)
	local s2cLoginWaitingCount = event.data
	local code = s2cLoginWaitingCount.code
	lt.CommonUtil.printf("s2cLoginWaitingCount code %d", code)

	if code ~= lt.SocketConstants.CODE_OK then
		return
	end

	-- 等待人数
	local waitCount = s2cLoginWaitingCount.wait_count or 1
	self._waitCount:setString(string.format(lt.StringManager:getString("STRING_WAITING_COUNT"), waitCount))

	-- 等待时间
	local waitTime = s2cLoginWaitingCount.waitTime or 0
	self._waitTime:setString(lt.CommonUtil:getFormatCountDown(waitTime, 11))
end

function WaitingLoginLayer:onWaitingStop()
	self._delegate:onWaitingStop()
end

return WaitingLoginLayer
