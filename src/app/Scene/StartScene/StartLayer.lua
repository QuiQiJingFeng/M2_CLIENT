
local StartLayer = class("StartLayer", function()
    return display.newLayer()
end)

StartLayer._winScale = lt.CacheManager:getWinScale()

StartLayer._token = nil
StartLayer._selectServerId = nil

StartLayer._logo = nil
StartLayer._serverBg = nil
StartLayer._serverInfo = nil
StartLayer._startBtn = nil
StartLayer._logoutBtn = nil

StartLayer._loginLayer = nil

StartLayer._waitStop = false

StartLayer._serverResult = false
StartLayer._announcementResult = false

StartLayer._delayInitHandler = nil

StartLayer._quickLoading = nil

function StartLayer:ctor()
    lt.NoticeManager:init(self)
    cpp.SdkService:shared():initSDK()

	self:setNodeEventEnabled(true)

	-- 背景
	local bg = display.newSprite("image/ui/start_bg.jpg")
	bg:setScale(self._winScale)
	bg:setPosition(display.cx, display.cy)
	self:addChild(bg)

    -- 加载纹理
    lt.ResourceManager:addSpriteFrames("image/ui/ui_item_add.plist", "image/ui/ui_item_add.png", true)
    lt.ResourceManager:addSpriteFrames("image/ui/ui_item.plist", "image/ui/ui_item.png", true)
    lt.ResourceManager:addSpriteFrames("image/ui/ui_extra-0.plist", "image/ui/ui_extra-0.png", true)
    lt.ResourceManager:addSpriteFrames("image/ui/ui-0.plist", "image/ui/ui-0.png", true)
    lt.ResourceManager:addSpriteFrames("image/ui/ui-1.plist", "image/ui/ui-1.png", true)
    lt.ResourceManager:addSpriteFrames("image/ui/ui_select.plist", "image/ui/ui_select.png", true)

    -- 加载特效
    lt.ResourceManager:addArmatureFileInfo("effect/ui/uieffect_game_logo.ExportJson")
    lt.ResourceManager:addArmatureFileInfo("effect/ui/uieffect_game_start.ExportJson")
    lt.ResourceManager:addArmatureFileInfo("effect/ui/uieffect_start.ExportJson")

    local armature = ccs.Armature:create("uieffect_start")
    armature:setScale(self._winScale)
    armature:setPosition(display.cx, display.cy)
    armature:getAnimation():playWithIndex(0)
    self:addChild(armature)

    -- logo
    if lt.ConfigManager:getHideLogo() == 0 then
        -- 显示Logo
        local logo = display.newSprite("game_logo.png")
        logo:setScale(self._winScale)
        logo:setPosition(display.cx, display.cy + 172 * self._winScale)
        self:addChild(logo)

        local effect = ccs.Armature:create("uieffect_game_logo")
        effect:setPosition(logo:getContentSize().width / 2, logo:getContentSize().height / 2)
        effect:getAnimation():playWithIndex(0)
        logo:addChild(effect)

        local effect = ccs.Armature:create("uieffect_game_logo")
        effect:setPosition(logo:getContentSize().width / 2, logo:getContentSize().height / 2)
        effect:getAnimation():playWithIndex(1)
        logo:addChild(effect, -1)
    end

    -- 顶部信息
    local topBg = display.newScale9Sprite("image/ui/common_mask_0.png", display.cx, display.top, cc.size(display.width + 2, 22))
    topBg:setAnchorPoint(0.5, 1)
    topBg:setOpacity(80)
    self:addChild(topBg)

    -- 健康公告
    local healthLabel = lt.GameLabel.newString("STRING_HEALTH_TIPS", 14)
    healthLabel:setPosition(topBg:getContentSize().width / 2, topBg:getContentSize().height / 2)
    topBg:addChild(healthLabel)

    -- 底部信息
    local bottomBg = display.newScale9Sprite("image/ui/common_mask_0.png", display.cx, display.bottom, cc.size(display.width + 2, 26))
    bottomBg:setAnchorPoint(0.5, 0)
    bottomBg:setOpacity(160)
    self:addChild(bottomBg)

    -- 版本号
    local versionStr = string.format(lt.StringManager:getString("STRING_GAME_VERSION"), lt.PreferenceManager:getBundleVersion(), lt.PreferenceManager:getResourceVersion())
    if DEBUG_LOG then
        versionStr = versionStr.."L"
    end
    if lt.ConfigManager:isQA() then
        versionStr = versionStr.."Q"
    end

    local versionLabel = lt.GameLabel.new(versionStr, 16)
    versionLabel:setAnchorPoint(1, 0.5)
    versionLabel:setPosition(bottomBg:getContentSize().width - 40, bottomBg:getContentSize().height / 2)
    bottomBg:addChild(versionLabel)

    -- 清理点击事件
    if cc.LuaTouchResetTouches then
        cc.LuaTouchResetTouches()
    end
end

function StartLayer:onEnter()
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SOCKET_CONNECT_SUCCESS, handler(self, self.onConnectSuccess), "StartLayer:onConnectSuccess")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.SOCKET_CONNECT_FAIL, handler(self, self.onConnectFail), "StartLayer:onConnectFail")

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.LOGIN_RESULT, handler(self, self.onLoginResponse), "StartLayer:onLoginResponse")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.FLUSH_RESULT, handler(self, self.onFlushResponse), "StartLayer:onFlushResponse")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.WAITING_LOGIN, handler(self, self.onWaitingLogin), "StartLayer:onWaitingLogin")

    self._delayInitHandler = lt.scheduler.performWithDelayGlobal(handler(self, self.init), 0)

    -- 开始背景音乐
    lt.AudioManager:playMusic("g_bg_1")

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    self._listener1 = cc.EventListenerCustom:create("onLoginSuccess", handler(self, self.onLoginSuccess))
    eventDispatcher:addEventListenerWithFixedPriority(self._listener1, -200)
    self._listener2 = cc.EventListenerCustom:create("onLoginError", handler(self, self.onLoginError))
    eventDispatcher:addEventListenerWithFixedPriority(self._listener2, -200)
    self._listener3 = cc.EventListenerCustom:create("QRCODE_SCAN", handler(self, self.onQRCodeScan))
    eventDispatcher:addEventListenerWithFixedPriority(self._listener3, -200)

    self._listener4 = cc.EventListenerCustom:create("onOrderSuccess", handler(self, self.onOrderSuccess))
    eventDispatcher:addEventListenerWithFixedPriority(self._listener4, -200)
    self._listener5 = cc.EventListenerCustom:create("onOrderError", handler(self, self.onOrderError))
    eventDispatcher:addEventListenerWithFixedPriority(self._listener5, -200)

    -- 丫丫语音退出房间
    if device.platform == "ios" or device.platform == "android" then
        cpp.SdkService:shared():exitRoom()
    end
end

function StartLayer:onExit()
    -- 移除纹理
    display.removeSpriteFrameByImageName("image/ui/start_bg.jpg")
    display.removeSpriteFrameByImageName("game_logo.png")
    if self._quickLoadingPic then
        display.removeSpriteFrameByImageName(self._quickLoadingPic)
    end
    lt.ResourceManager:removeSpriteFrames("image/ui/ui_select.plist", "image/ui/ui_select.png")

    -- 移除特效
    lt.ResourceManager:removeArmatureFileInfo("effect/ui/uieffect_game_logo.ExportJson")
    lt.ResourceManager:removeArmatureFileInfo("effect/ui/uieffect_game_start.ExportJson")
    lt.ResourceManager:removeArmatureFileInfo("effect/ui/uieffect_start.ExportJson")

    lt.LSdkManager:clearDelegate()

    lt.GameEventManager:removeListener("StartLayer:onConnectSuccess")
    lt.GameEventManager:removeListener("StartLayer:onConnectFail")

    lt.GameEventManager:removeListener("StartLayer:onLoginResponse")
    lt.GameEventManager:removeListener("StartLayer:onFlushResponse")

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:removeEventListener(self._listener1)
    eventDispatcher:removeEventListener(self._listener2)
    eventDispatcher:removeEventListener(self._listener3)

    eventDispatcher:removeEventListener(self._listener4)
    eventDispatcher:removeEventListener(self._listener5)

    if self._delayInitHandler then
        lt.scheduler.unscheduleGlobal(self._delayInitHandler)
        self._delayInitHandler = nil
    end

    if self._delayHandler then
        lt.scheduler.unscheduleGlobal(self._delayHandler)
        self._delayHandler = nil
    end
    lt.NoticeManager:clearAll()
end

-- 游戏资源检查完毕
function StartLayer:checkResourceCallBack()
    self._infoBg:setVisible(false)

    -- 游戏初始化
    self:init()
end

function StartLayer:init()
    self._delayInitHandler = nil
    if __G__PLAYER__LOGOUT__TYPE__ and __G__PLAYER__LOGOUT__TYPE__ > 0 then--玩家设置界面登出或者换角色
        if __G__PLAYER__LOGOUT__TYPE__ == 1 then--登出
            self:getStartBtn():setVisible(true)
        else
            self:login(__G__TOKEN__)
        end
    else
        lt.LSdkManager:setDelegate(self)

        if __G__TOKEN__ then
            -- 重置自动登录
            self:login(__G__TOKEN__)
        else
            self:getStartBtn():setVisible(true)
        end
    end
end

function StartLayer:onAutoLoginSuccess(responseJson)
    lt.CommonUtil.print("StartLayer:onAutoLoginSuccess "..responseJson)
    lt.SocketLoading:socketLoadingOff()

    local response = json.decode(responseJson)

    local status = response.status or -1
    if checknumber(status) == 0 then
        -- 注册成功
        lt.CommonUtil.print("AutoLoginSuccess")

        local data = response.data

        local uid   = data.uid
        local token = data.token

        self:login(token)
    else
        lt.CommonUtil.print("LoginSuccessError", status,response.desc)

        lt.TipsLayer:tipsOn(response.desc)
        -- 显示开始按钮
        self:getStartBtn():setVisible(true)
    end
end

function StartLayer:onAutoLoginFail(code)
    lt.SocketLoading:socketLoadingOff()
    
    lt.CommonUtil.print("StartLayer:onAutoLoginFail", code)

    if network.isInternetConnectionAvailable() then
        -- 一时不好
        lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_LOGIN_AUTO_FAIL"))

        -- 自动登录失败 手动登录
        self:getStartBtn():setVisible(true)
    else
        -- 无网络
        lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_ERROR_NETWORK_NO"))
        
        self:getStartBtn():setVisible(true)
    end
end

function StartLayer:onStart()
    self:start()
end

function StartLayer:start()
    if not self._token then
        local result = cpp.SdkService:shared():login()

        -- sdk 无处理 自己的登录界面
        if not result then
            if device.platform == "windows" and not lt.ConfigManager:isSimulator() then 
            -- if true then 
                self:getQRLoginLayer():updateInfo()
            else
                self:getLoginLayer():activate()
            end
        end
        return
    end

    if not self._selectServerId then
        return
    end

    if not self._serverResult then
        return
    end

    if not self._announcementResult then
        return
    end

    -- 判断服务器状态
    local serverInfo = lt.DataManager:getServerInfo(self._selectServerId)
    if not serverInfo then
        return
    end

    local currTime = lt.CommonUtil:getCurrentTime()
    local diffTime = currTime - serverInfo:getOpenTime()
    if diffTime < 0 then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_SERVER_NOT_OPEN"))
        return
    end

    if serverInfo:getState() == lt.ServerInfo.STATE.MAINTENANCE then
        -- 维护中
        lt.AlertLayer:alertOnString("STRING_SERVER_MAINTENANCE", handler(self, self.reloadServerList))
        return
    end

    self:connect()
end

function StartLayer:reloadServerList()
    lt.HttpApi:getServerList(handler(self, self.onReloadServerListSuccess))
end

function StartLayer:onReloadServerListSuccess(responseJson)
    local response = json.decode(responseJson)
    if response then
        -- 获取到服务器信息
        for _,scServerInfo in ipairs(response) do
            local serverInfo = lt.ServerInfo.new(scServerInfo)
            lt.DataManager:setServerInfo(serverInfo)
        end
    else
        lt.CommonUtil.printf("getServerListSuccessError %s", responseJson)
    end
end

function StartLayer:onLoginSuccess(event)
    local dataString = event:getDataString()
    local dataArray = string.split(dataString,"_")
    local accessToken = dataArray[1]
    local thirdPartyId = dataArray[2]
    local extra = dataArray[3]

    lt.HttpApi:thirdPartyLogin(accessToken, thirdPartyId, extra, handler(self, self.onAutoLoginSuccess), handler(self, self.onAutoLoginFail))

    lt.SocketLoading:socketLoadingOn()

    -- 清理点击事件
    if cc.LuaTouchResetTouches then
        cc.LuaTouchResetTouches()
    end
end

function StartLayer:onLoginError(event)
    lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_LOGIN_FAIL"))
end

function StartLayer:onLogout()
    self._token = nil

    lt.LSdkManager:logout(1)

    self._isConnected = false
end

function StartLayer:logout()
    -- 服务器信息
    self._token = nil
    self._isConnected = false
    
    self:getServerInfo():setVisible(false)
    self:getLogoutBtn():setVisible(false)

    if self._selectLayer then
        self._selectLayer:setVisible(false)
    end

    if self._serverLayer then
        self._serverLayer:setVisible(false)
    end

    if tonumber(__G__CP_SERVER_ID) ~= 1 then
        self:getAnnouncementBtn():setVisible(false)

        if (device.platform == "ios" or device.platform == "mac") and cpp.ZCZBar then
            self:getQRScanBtn():setVisible(false)
        end
    end
end

function StartLayer:autoLogin(token)
    self:login(token)
end

function StartLayer:login(token)
    if device.platform == "mac" then
        -- token = "zwjnnew1"
        -- token = "100-5980553"
        -- token = "100-7188881"
        -- token = "100-7195870"
    end
    if self._token == token then
        -- 已经登录过了? 2次获得token
        return
    end

    self._token = token

    -- 设置Token
    lt.DataManager:setToken(token)

    -- 服务器信息
    self:getServerInfo():setVisible(true)

    -- 按钮
    self:getStartBtn():setVisible(true)
    self:getLogoutBtn():setVisible(true)
    if tonumber(__G__CP_SERVER_ID) ~= 1 then
        self:getAnnouncementBtn():setVisible(true)

        if (device.platform == "ios" or device.platform == "mac") and cpp.ZCZBar then
            self:getQRScanBtn():setVisible(true)
        end
    end

    -- 获取服务器信息
    lt.HttpApi:getServerList(handler(self, self.onGetServerListSuccess), handler(self, self.onGetServerListFail))

    lt.SocketLoading:socketLoadingOn()
end

function StartLayer:getServerListAgain()
    -- 获取服务器信息
    lt.HttpApi:getServerList(handler(self, self.onGetServerListSuccess), handler(self, self.onGetServerListFail))

    lt.SocketLoading:socketLoadingOn()
end

function StartLayer:getServerListCancel()
    -- 注销
    self:onLogout()

    if self._quickLoading then
        self._quickLoading:setVisible(false)
    end
end

function StartLayer:onGetServerListSuccess(responseJson)
    self._serverResult = true

    local response = json.decode(responseJson)
    if response then
        -- 获取到服务器信息
        lt.CommonUtil.print("getServerListSuccess")

        for _,scServerInfo in ipairs(response) do
            local serverInfo = lt.ServerInfo.new(scServerInfo)
            lt.DataManager:setServerInfo(serverInfo)
        end

        -- 设置默认服务器
        local selectServer = nil
        local defaultServerId = lt.PreferenceManager:getDefaultServerId(self._token)
        if defaultServerId ~= -1 then
            -- 存在默认服务器
            selectServer = lt.DataManager:getServerInfo(defaultServerId)
        end
        if not selectServer then
            selectServer = lt.DataManager:getDefaultServerInfo()
        end

        if not selectServer then
            -- 一个服务器都没有!
            lt.SocketLoading:socketLoadingOff()

            lt.TipsLayer:tipsOnString("STRING_GET_SERVER_EMPTY")

            -- 前往获得游戏公告
            self._announcementResult = false
            lt.HttpApi:getAnnouncement(handler(self, self.onGetAnnouncementSuccess), handler(self, self.onGetAnnouncementFail))
            return
        end

        self:updateServerInfo(selectServer)

        self._selectServerId = selectServer:getIndex()

        if not lt.PreferenceManager:getInitGameInfo() then
            -- 尚未初始个人数据
            lt.HttpApi:getloginedserver(self._token)
        end

        if __G__PLAYER__LOGOUT__TYPE__ and __G__PLAYER__LOGOUT__TYPE__ > 0 then--玩家设置界面登出或者换角色
            lt.SocketLoading:socketLoadingOff()

            self._announcementResult = true
            lt.HttpApi:getAnnouncement(handler(self, self.onGetAnnouncementSuccess), handler(self, self.onGetAnnouncementFail))
            
            if __G__PLAYER__LOGOUT__TYPE__ == 1 then
                -- 登出重新走登陆流程
            elseif __G__PLAYER__LOGOUT__TYPE__ == 2 then
                if __G__TOKEN__ then
                    -- 存在token自动进入游戏
                    self:start()
                end
            end
        else
            -- 前往获得游戏公告
            self._announcementResult = false
            lt.HttpApi:getAnnouncement(handler(self, self.onGetAnnouncementSuccess), handler(self, self.onGetAnnouncementFail))
        end
    else
        lt.CommonUtil.printf("getServerListSuccessError %s", responseJson)
    end
end

function StartLayer:onGetServerListFail(code)
    lt.CommonUtil.printf("StartLayer:onGetServerListFail %d", code)

    lt.SocketLoading:socketLoadingOff()

    if network.isInternetConnectionAvailable() then
        lt.CommitNewLayer:commitOnString("STRING_GET_SERVER_FAIL", handler(self, self.getServerListAgain), handler(self, self.getServerListCancel))
    else
        -- 无网络
        lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_ERROR_NETWORK_NO"))

        self:getServerListCancel()
    end
end

function StartLayer:onGetAnnouncementSuccess(responseJson)
    self._announcementResult = true

    lt.SocketLoading:socketLoadingOff()

    local response = json.decode(responseJson)
    if response then
        -- 清理公告
        lt.DataManager:clearAnnouncement()

        local announcementArray = response.announcement or {}
        for _,scAnnouncement in ipairs(announcementArray) do
            local announcement = lt.Announcement.new(scAnnouncement)
            lt.DataManager:setAnnouncement(announcement)
        end

        -- 排序公告
        lt.DataManager:sortAnnouncementArray()

        if not __G__PLAYER__LOGOUT__TYPE__ then--玩家登出或者更换角色时不主动显示
            if tonumber(__G__CP_SERVER_ID) ~= 1 then
                -- 非审核服显示公告
                self:getAnnouncementLayer():updateInfo()
            end
        end

        local webrechargeArray = response.webrecharge or {}
        lt.DataManager:clearWebChargeArray()
        local webChargeArray = lt.DataManager:getWebChargeArray()
        for _,channelId in ipairs(webrechargeArray) do
            webChargeArray[#webChargeArray+1] = channelId
        end

    else
        lt.CommonUtil.printf("getAnnouncementSuccessError %s", responseJson)
    end
end

-- 公告界面
function StartLayer:getAnnouncementLayer()
    if not self._announcementLayer then
        self._announcementLayer = lt.AnnouncementLayer.new(self)
        lt.SceneManager:addLayer(self._announcementLayer)
    end

    return self._announcementLayer
end

function StartLayer:clearAnnouncementLayer()
    if self._announcementLayer then
        lt.SceneManager:removeLayer(self._announcementLayer)
        self._announcementLayer = nil
    end
end

function StartLayer:onGetAnnouncementFail(code)
    lt.CommonUtil.printf("StartLayer:onGetAnnouncementFail %d", code)
    self._announcementResult = true

    lt.SocketLoading:socketLoadingOff()
end

function StartLayer:onServerStart(serverId)
    self:selectServer(serverId)

    self:connect()
end

StartLayer._isConnected = false
StartLayer._returnFromSelectLayer = false
StartLayer._timeLimite = true
function StartLayer:connect()
    if self._isConnected and self._returnFromSelectLayer then--如果是从选人界面回来的 再次点击
        self:getSelectLayer():updateInfo(true)
        self:getServerLayer():setVisible(false)
        return
    end

    if self._isConnected then
        -- self:getSelectLayer():updateInfo(true)
        -- self:getServerLayer():setVisible(false)
        if self._timeLimite  == false then
            -- 连接完毕 登陆用户
            lt.CommonUtil.print("first SocketApi:login error !!!!!!!!!!!!!!!!!")
            lt.SocketApi:login(self._token,true)--避免连接成功登陆不成功而无法再次登录
            return
        else
            return
        end
    end

    if not self._selectServerId then
        return
    end

    local serverInfo = lt.DataManager:getServerInfo(self._selectServerId)
    if not serverInfo then
        return
    end

    local domain = serverInfo:getUrl()
    local ip     = serverInfo:getIp()
    local port   = serverInfo:getPort()

    --添加一个限制 如果连接成功而没有login成功 需要等1s之后可以再登录
    if not self._delayHandler then
        self._delayHandler = lt.scheduler.performWithDelayGlobal(function()
            self._timeLimite = false
            lt.scheduler.unscheduleGlobal(self._delayHandler)
            self._delayHandler = nil
        end, 1)
    end
    self._timeLimite = true
    lt.SocketApi:connect(domain, ip, port)

    lt.SocketLoading:socketLoadingOn()
end

function StartLayer:onConnectSuccess(params)
    if not params or params.connIndex ~= lt.SocketManager.DEFAULT_CONNINDEX then
        return
    end

    if self._isConnected then
        return
    end

    local contentStatus = lt.SocketManager:getContentStatus()
    if contentStatus ~= lt.SocketManager.CONTENT_STATUS.ALIVE then
        return
    end

    self._isConnected = true

    -- 设为默认服务器
    lt.PreferenceManager:setDefaultServerId(self._token, self._selectServerId)

    -- 连接完毕 登陆用户
    lt.SocketApi:login(self._token,true)
end

function StartLayer:onConnectFail()
    local contentStatus = lt.SocketManager:getContentStatus()
    if contentStatus ~= lt.SocketManager.CONTENT_STATUS.DISCONNECT then
        return
    end

    lt.SocketLoading:socketLoadingOff()

    if self._waitStop then
        self._waitStop = false
        return
    end

    -- 连接服务器失败
    lt.TipsLayer:tipsOnString("STRING_ERROR_NETWORK_SERVER")

    if self._quickLoading then
        self._quickLoading:setVisible(false)
    end
end

function StartLayer:onLoginResponse(params)
    -- 拉取数据
    lt.SocketLoading:socketLoadingOff()

    local playerArray = lt.DataManager:getLoginPlayerArray()
    local loginId = lt.PreferenceManager:getLoginId(lt.DataManager:getToken())
    --local unfreezeAccountTime = params.unfreezeAccountTime - lt.CommonUtil:getCurrentTime()
    local currentPlayer = nil
    for k,player in pairs(playerArray) do
        if player.id ==  loginId then--找出当前的角色id
            currentPlayer = player
        end
    end
    if currentPlayer then
        local offTime = currentPlayer.unfreeze_account_time - lt.CommonUtil:getCurrentTime()--封号
        self:getSelectLayer():updateInfo(true, currentPlayer.unfreeze_account_time)
        -- if #playerArray == 0 or (__G__PLAYER__LOGOUT__TYPE__ and __G__PLAYER__LOGOUT__TYPE__ == 2) or offTime > 0 then
        --     self:getSelectLayer():updateInfo(true, currentPlayer.unfreeze_account_time)
        -- else
        --     lt.SocketApi:flush(loginId)
        -- end
    else
        self:getSelectLayer():updateInfo(true)
        -- if #playerArray == 0 or (__G__PLAYER__LOGOUT__TYPE__ and __G__PLAYER__LOGOUT__TYPE__ == 2) then
        --     self:getSelectLayer():updateInfo(true)
        -- else
        --     lt.SocketApi:flush(loginId)
        -- end
    end
end

function StartLayer:getSelectLayer()
    if not self._selectLayer then
        self._selectLayer = lt.SelectLayer.new(self)
        self:addChild(self._selectLayer,30)
    end
    display.getRunningScene():loadingOff()
    self._selectLayer:setVisible(true)
    self._selectLayer:configInfo()
    return self._selectLayer
end

function StartLayer:onFlushResponse(params)
    local code = params.code
    lt.CommonUtil.printf("StartLayer:onFlushResponse %d", code)
    lt.SocketLoading:socketLoadingOff()

    if code == lt.SocketConstants.CODE_OK then
        -- 正式进入游戏 注册TOKEN
        __G__TOKEN__ = self._token
        __G__PLAYER__LOGOUT__TYPE__ = nil
        
        local player = lt.DataManager:getPlayer()
        if device.platform == "ios" or device.platform == "android" then
            -- sdk 登录
            local playerId = 0
            local playerName = ""
            local playerLevel = 1
            local createTime = 0
            if player then
                playerId = player:getId()
                playerName = player:getName()
                playerLevel = player:getLevel()
                createTime  = player:getCreateTime()
            end
            local serverId = lt.DataManager:getCurServerId()
            local serverName = ""
            local serverInfo = lt.DataManager:getServerInfo(serverId)
            if serverInfo then
                serverName = serverInfo:getName()
            end

            if cpp.SdkService:shared().setCreateTime then
                cpp.SdkService:shared():setCreateTime(createTime)
            end
            
            cpp.SdkService:shared():sendGameInfo(playerId , playerName, playerLevel, serverId, serverName)
        end

        -- 注册个人信息到本地
        lt.PreferenceManager:setDefaultGameInfo()
        lt.PreferenceManager:setLoginPlayerInfo()
        -- 注册个人信息到中心机
        lt.HttpApi:loginStatistics()

        -- 亲加登录游戏
        local loginName = lt.DataManager:getLoginName()
        lt.AudioMsgManager:cpLogin(loginName)

        -- if player and player:getWorldMapId() == lt.Constants.GUIDE_MAP then

        -- 判定条件改为 第一个引导是否触发
        if not lt.GuideManager:isGuideTriggeredById(100) then
            -- 还在引导地图 进入故事模式
            local storyScene = lt.StoryScene.new()
            lt.SceneManager:replaceScene(storyScene)
        else
            -- 正常游戏
            local worldScene = lt.WorldScene.new()
            lt.SceneManager:replaceScene(worldScene)
        end
    elseif code == lt.SocketConstants.CODE_REFLUSH then
        local loginId = lt.PreferenceManager:getLoginId(lt.DataManager:getToken())
        lt.SocketApi:flush(loginId)
    else
        -- 数据拉取失败
        lt.CommonUtil.print("FLUSH ERROR")
    end
end

function StartLayer:getStartBtn()
    if not self._startBtn then
        -- 开始
        self._startBtn = lt.PushButton.new("image/ui/common/touch_rect_80.png", {scale = self._winScale, scale9 = true})
        self._startBtn:setButtonSize(200, 100)
        self._startBtn:pos(display.cx, display.cy - 240 * self._winScale)
        self._startBtn:onButtonClicked(handler(self, self.onStart))
        self:addChild(self._startBtn, 20)

        local bg = display.newSprite("#start_btn_bg.png")
        self._startBtn:addChild(bg)

        local armature = ccs.Armature:create("uieffect_game_start")
        armature:getAnimation():playWithIndex(1)
        self._startBtn:addChild(armature)
    end

    return self._startBtn
end

function StartLayer:getLogoutBtn()
    if not self._logoutBtn then
        -- 开始
        self._logoutBtn = lt.ScaleLabelButton.newYellow("STRING_START_LOGOUT", {scale = self._winScale});
        self._logoutBtn:pos(display.right - 80, display.bottom + 80)
        self._logoutBtn:onButtonClicked(handler(self, self.onLogout))
        self:addChild(self._logoutBtn)
    end

    return self._logoutBtn
end

function StartLayer:getAnnouncementBtn()
    if not self._announcementBtn then
        -- 开始
        self._announcementBtn = lt.ScaleLabelButton.newYellow("STRING_START_ANNOUNCEMENT", {scale = self._winScale});
        self._announcementBtn:setPosition(display.right - 80, display.bottom + 160)
        self._announcementBtn:onButtonClicked(handler(self, self.onAnnouncement))
        self:addChild(self._announcementBtn)
    end

    return self._announcementBtn
end

function StartLayer:onAnnouncement()
    if tonumber(__G__CP_SERVER_ID) ~= 1 then
        -- 非审核服显示公告
        self:getAnnouncementLayer():updateInfo()
    end
end

function StartLayer:getServerInfo()
    if not self._serverBg then
        self._serverBg = lt.ScaleButton.new("#start_server_bg.png", {scale = self._winScale})
        self._serverBg:setPosition(display.cx, display.cy - 110 * self._winScale)
        self._serverBg:onButtonClicked(handler(self, self.onServer))
        self:addChild(self._serverBg)

        self._serverInfo = display.newNode()
        self._serverInfo:setPosition(self._serverBg:getContentSize().width / 2, self._serverBg:getContentSize().height / 2)
        self._serverBg:addChild(self._serverInfo)
    end

    return self._serverBg
end

function StartLayer:updateServerInfo(serverInfo)
    if not serverInfo or serverInfo:getIndex() == self._selectServerId then
        return
    end

    lt.SocketApi:disconnect()
    self._isConnected = false

    lt.DataManager:setCurServerId(serverInfo:getIndex())
    self._selectServerId = serverInfo:getIndex()

    self:getServerInfo()

    self._serverInfo:removeAllChildren()

    local state = serverInfo:getState()
    local stateStr = "#select_icon_green.png"
    if state == lt.ServerInfo.STATE.HOT then
        stateStr = "#select_icon_orange.png"
    elseif state == lt.ServerInfo.STATE.MAINTENANCE then
        stateStr = "#select_icon_gray.png"
    end

    local iconState = display.newSprite(stateStr)
    iconState:setPosition(-120, self._serverInfo:getContentSize().height / 2)
    self._serverInfo:addChild(iconState)

    local label = lt.GameLabel.new(serverInfo:getName(), 21, lt.Constants.COLOR.WHITE, {outline = true, outlineColor=lt.Constants.DEFAULT_LABEL_COLOR_2})
    self._serverInfo:addChild(label)

    -- 点击选服
    local tips = display.newSprite("#start_label_server.png")
    tips:setAnchorPoint(0, 0.5)
    tips:setPosition(105, 0)
    self._serverInfo:addChild(tips)
end

function StartLayer:onServer()
    if not self._serverResult then
        return
    end

    self:getServerLayer():updateInfo(self._token)
end

function StartLayer:getServerLayer()
    if not self._serverLayer then
        self._serverLayer = lt.ServerLayer.new(self)
        self:addChild(self._serverLayer,30)
    end
    self._serverLayer:setVisible(true)
    return self._serverLayer
end

function StartLayer:selectServer(selectServerId)
    local serverInfo = lt.DataManager:getServerInfo(selectServerId)
    if not serverInfo then
        return
    end

    self._selectServerId = selectServerId

    self:updateServerInfo(serverInfo)
end

function StartLayer:getLoginLayer()
    if not self._loginLayer then
        self._loginLayer = lt.LoginLayer.new(1, self)
        display.getRunningScene():addChild(self._loginLayer)
    end

    return self._loginLayer
end

function StartLayer:onWaitingLogin(params)
    lt.SocketLoading:socketLoadingOff()

    -- 出现等待
    local waitCount = params.waitCount

    lt.CommonUtil.printf("排队 %d", waitCount)
    self:getWaitingLoginLayer():updateInfo({waitCount = waitCount})
end

function StartLayer:getWaitingLoginLayer()
    if not self._waitingLoginLayer then
        self._waitingLoginLayer = lt.WaitingLoginLayer.new(self)
        display.getRunningScene():addChild(self._waitingLoginLayer)
    end

    return self._waitingLoginLayer
end

-- 排队取消(断开连接)
function StartLayer:onWaitingStop()
    self._waitStop = true

    lt.SocketApi:disconnect()

    self:clearWaitingLoginLayer()
end

function StartLayer:clearWaitingLoginLayer()
    if self._waitingLoginLayer then
        self._waitingLoginLayer:removeSelf()
        self._waitingLoginLayer = nil
    end
end

function StartLayer:isfromSelectLayer()--是否是从选人界面回来的
    self._returnFromSelectLayer = true
end

function StartLayer:getQRLoginLayer()
    if not self._qrloginLayer then
        self._qrloginLayer = lt.QRLoginLayer.new(self)
        display.getRunningScene():addChild(self._qrloginLayer, 1)
    end

    return self._qrloginLayer
end

function StartLayer:clearQRLoginLayer()
    if self._qrloginLayer then
        self._qrloginLayer:removeFromParent()
        self._qrloginLayer = nil
    end
end

function StartLayer:getQRScanBtn()
    if not self._qrscanBtn then
        -- 开始
        self._qrscanBtn = lt.ScaleButton.new("#ui_qr_btn_scan.png", {scale = self._winScale});
        self._qrscanBtn:setPosition(display.right - 80, display.top - 64)
        self._qrscanBtn:onButtonClicked(handler(self, self.onQRScan))
        self:addChild(self._qrscanBtn)
    end

    return self._qrscanBtn
end

function StartLayer:onQRScan()
    if tonumber(__G__CP_SERVER_ID) ~= 1 then
        -- 非审核使用二维码扫描
        if cpp.ZCZBar then
            cpp.ZCZBar:getInstance():scanQRCode()
        else
            lt.CommonUtil.print("当前平台不支持二维码扫描")
        end
    end
end

function StartLayer:onQRCodeScan(event)
    local qrcodestring = event:getDataString()
    lt.CommonUtil.print("qrcodestring "..qrcodestring)
    self:_QRCodeScanCallback(qrcodestring)
end

function StartLayer:_QRCodeScanCallback(qrcodestring)
    lt.CommonUtil.print("StartLayer:_QRCodeScanCallback")
    if not self._token then
        return
    end

    -- 字符串截取判断回调类型
    local subStr = string.sub(qrcodestring, 1, 4)
    if subStr == "PCP:" then
        -- 支付回调
        local encodeStr = string.sub(qrcodestring, 5)
        local payJson = cpp.Utils:aesDecode(encodeStr, GAME_URL_KEY_1)
        local payParams = json.decode(payJson) or {}
        if next(payParams) == nil then
            -- 没有参数 解析出错
            lt.CommonUtil.print("没有参数 解析出错")
            return
        end

        -- 继续支付
        local serverId      = payParams.sid
        local playerId      = payParams.pid
        local shopItemId    = payParams.siid
        local shopItemName  = payParams.sina
        local deviceId      = payParams.did
        local token         = payParams.token
        local channelId     = payParams.cid
        local currencyCount = payParams.ccount
        local productId     = payParams.prid
        if not serverId or not playerId or not shopItemId or not shopItemName or not deviceId or not token or not channelId or not currencyCount or not productId then
            -- 参数不齐
            lt.CommonUtil.print("参数不齐")
            return
        end

        if token ~= self._token then
            lt.NoticeManager:addMessageString("STRING_QR_PAY_ERROR_TOKEN_NOT_MATCH")
            return
        end

        -- 生成订单Id
        local billNo = lt.DataManager:getFixBillNo(serverId, playerId)

        lt.SocketManager:setHeartbeat(15)
        lt.SystemLoading:show()

        local extra = shopItemId.."_"..serverId.."_"..deviceId.."_"..shopItemName.."_"..token.."_"..channelId
        lt.CommonUtil.print("billNo:"..billNo.." extra:"..extra)

        cpp.SdkService:shared():pay(serverId, currencyCount, 1, billNo, productId, extra)
    else
        lt.HttpApi:pcLogin(qrcodestring, self._token, handler(self, self.onQRCodeScanSuccess), handler(self, self.onQRCodeScanFail))
    end
end

function StartLayer:onOrderSuccess(event)
    lt.SystemLoading:hide()
    lt.SocketManager:resetHeartbeat()
end

function StartLayer:onOrderError(event)
    local code = event:getDataString()
    if code ~= "" then
        code = tonumber(code)
    end

    lt.SystemLoading:hide()
    lt.SocketManager:resetHeartbeat()
    lt.CommonUtil.print("StartLayer:onOrderError "..code)
end

function StartLayer:onQRCodeScanSuccess(responseJson)
    lt.CommonUtil.print(responseJson, "onQRCodeScanSuccess responseJson")
    local response = json.decode(responseJson)

    local status = response.status or -1
    if checknumber(status) == 0 then
        local code = response.code or -1
        if code == 0 then
            -- 注册成功
            local callback = response.callback or ""
            self:getQRLoginCommitLayer():updateInfo(callback, self._token)
        else
            lt.CommonUtil.print("onQRCodeScanSuccess", code, response.msg)
        end
    else
        lt.CommonUtil.print("onQRCodeScanSuccess", status, response.desc)
    end
end

function StartLayer:onQRCodeScanFail(responseJson)
    -- dump(responseJson, "onQRCodeScanFail responseJson")
    lt.NoticeManager:addMessageString("STRING_QR_LOGON_SCAN_FAIL")
end

function StartLayer:getQRLoginCommitLayer()
    if not self._qrloginCommitLayer then
        self._qrloginCommitLayer = lt.QRLoginCommitLayer.new(self)
        display.getRunningScene():addChild(self._qrloginCommitLayer, 1)
    end

    return self._qrloginCommitLayer
end

function StartLayer:clearQRLoginCommitLayer()
    if self._qrloginCommitLayer then
        self._qrloginCommitLayer:removeFromParent()
        self._qrloginCommitLayer = nil
    end
end

return StartLayer

