
-- 二维码登陆界面
local QRLoginLayer = class("QRLoginLayer", function()
	return display.newLayer()
end)

QRLoginLayer._connect = false
QRLoginLayer._delegate = nil

function QRLoginLayer:ctor(delegate)
	self:setNodeEventEnabled(true)
    
    self._delegate = delegate
    
	local bgSize = cc.size(330, 360)
	local bg = display.newScale9Sprite("#ui_qr_info_bg.png", display.cx, display.cy - 100, bgSize)
	self:addChild(bg)

	-- 二维码区域
	self._loadingIcon = display.newSprite("#ui_qr_icon_refresh.png")
	self._loadingIcon:setPosition(bgSize.width / 2, bgSize.height - 110)
	bg:addChild(self._loadingIcon)

	self._qrcodeNode = display.newNode()
	self._qrcodeNode:setPosition(bgSize.width / 2, bgSize.height - 110)
	self._qrcodeNode:setVisible(false)
	bg:addChild(self._qrcodeNode)

	-- 富文本
	local richText = lt.RichText.new()
	richText:setPosition(bgSize.width / 2, 112)
	richText:setAutoSize(true, bgSize.width - 60)
	bg:addChild(richText)

	local richTextText1 = lt.RichTextText.new(lt.StringManager:getString("STRING_QR_LOGON_TIPS_1"), 20, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
	richText:insertElement(richTextText1)

	local richTextImage = lt.RichTextImage.new("image/ui/ui_qr_btn_scan.png")
	richText:insertElement(richTextImage)

	local richTextText2 = lt.RichTextText.new(lt.StringManager:getString("STRING_QR_LOGON_TIPS_2"), 20, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
	richText:insertElement(richTextText2)

	local refreshIcon = display.newSprite("#ui_qr_icon_refresh.png")
	refreshIcon:setPosition(bgSize.width / 2 - 48, 40)
	bg:addChild(refreshIcon)

	local refreshButton = lt.ScaleButton.new("#ui_qr_btn_refresh.png")
	refreshButton:setPosition(bgSize.width / 2 + 20, 40)
	refreshButton:onButtonClicked(handler(self, self.onRefresh))
	bg:addChild(refreshButton, 100)
end

function QRLoginLayer:onEnter()
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SOCKET_CONNECT_SUCCESS, handler(self, self.onConnectSuccess), "QRLoginLayer:onConnectSuccess")

    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_PC_KEEP_ALIVE, handler(self, self.onPcKeepAlive), "QRLoginLayer:onPcKeepAlive")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_PC_REGISTER, handler(self, self.onPcRegister), "QRLoginLayer:onPcRegister")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_PC_NOTIFY_ACCOUNT_SCAN, handler(self, self.onPcNotifyAccountScan), "QRLoginLayer:onPcNotifyAccountScan")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_PC_NOTIFY_ACCOUNT_LOGIN, handler(self, self.onPcNotifyAccountLogin), "QRLoginLayer:onPcNotifyAccountLogin")
end

function QRLoginLayer:onExit()
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SOCKET_CONNECT_SUCCESS, handler(self, self.onConnectSuccess), "QRLoginLayer:onConnectSuccess")

    lt.SocketApi:removeEventListenersByTag("QRLoginLayer:onPcKeepAlive")
    lt.SocketApi:removeEventListenersByTag("QRLoginLayer:onPcRegister")
    lt.SocketApi:removeEventListenersByTag("QRLoginLayer:onPcNotifyAccountScan")
    lt.SocketApi:removeEventListenersByTag("QRLoginLayer:onPcNotifyAccountLogin")

    -- 断开连接
    lt.SocketManager:_disconnect(lt.SocketManager.LOGIN_CONNINDEX)

    if self._keepAliveHandle then
    	lt.scheduler.unscheduleGlobal(self._keepAliveHandle)
    end
end

function QRLoginLayer:onConnectSuccess(params)
    if not params or params.connIndex ~= lt.SocketManager.LOGIN_CONNINDEX then
        return
    end

    self._connect = true

    -- 开启心跳(服务器30S 客户端20S)
    if not self._keepAliveHandle then
    	self._keepAliveHandle = lt.scheduler.scheduleGlobal(handler(self, self.onKeepAlive), 20)
    end

    -- 连接建立完成 请求UID
    self:refresh()
end

function QRLoginLayer:onKeepAlive(delta)
	lt.SocketApi:pcKeepAlive()
end

function QRLoginLayer:onPcKeepAlive(event)
	local s2cPcKeepAlive = event.data
	--print("s2cPcKeepAlive content\n"..tostring(s2cPcKeepAlive))
end

function QRLoginLayer:updateInfo()
	self._loadingIcon:runAction(cca.loop(cca.rotateBy(2, 360)))

	-- 准备建立链接
	lt.SocketManager:_connect(lt.SocketManager.LOGIN_CONNINDEX, GAME_CENTER_DOMAIN, GAME_CENTER_IP, GAME_CENTER_PORT)
end

function QRLoginLayer:onRefresh()
	self:refresh()
end

function QRLoginLayer:refresh()
	if not self._connect then
		return
	end

	-- pc端注册
	lt.SocketApi:pcRegister()
end

function QRLoginLayer:onPcRegister(event)
	local s2cPcRegister = event.data
	local code = s2cPcRegister.code
	lt.CommonUtil.print("s2cPcRegister code "..code)
	lt.CommonUtil.print("s2cPcRegister content\n"..tostring(s2cPcRegister))

	if code ~= lt.SocketConstants.CODE_OK then
		return
	end

	local url = s2cPcRegister.url or ""
	-- 生成二维码
	if qr and qr.QRGenerator and qr.QRGenerator.generatorQRNode then
		lt.CommonUtil.print("生成二维码")
		self._loadingIcon:setVisible(false)
		self._qrcodeNode:setVisible(true)
		self._qrcodeNode:removeAllChildren()

        local gameIcon = display.newSprite("game_icon.png")
        self._qrcodeNode:addChild(gameIcon, 10)
        
        local drawNode = qr.QRGenerator:generatorQRNode(url, 7);
        if drawNode then
            local size = drawNode:getContentSize()
            drawNode:setScale(180/size.width)
        
            drawNode:setPosition(- 90, - 90)
            self._qrcodeNode:addChild(drawNode)
        end
    else
    	-- 当前平台不支持二维码生成
    	lt.CommonUtil.print("当前平台不支持二维码生成")
    end

end

function QRLoginLayer:onPcNotifyAccountScan(event)
    local s2cPcNotifyAccountScan = event.data
    --print("s2cPcNotifyAccountScan content\n"..tostring(s2cPcNotifyAccountScan))
    lt.NoticeManager:addMessageString("STRING_QR_LOGON_SCAN_SUCCESS")
end

function QRLoginLayer:onPcNotifyAccountLogin(event)
    local s2cPcNotifyAccountLogin = event.data

    local token = s2cPcNotifyAccountLogin.token
    self._delegate:login(token)
    
    self:close()
end

function QRLoginLayer:close()
	self._delegate:clearQRLoginLayer()
end

return QRLoginLayer
