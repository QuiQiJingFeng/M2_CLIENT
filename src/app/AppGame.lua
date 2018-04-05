
require("config")
require("cocos.init")
--require("GameConfig")
require("app.Init")

--游戏中玩家登出/换角色(网络不好)
__G__PLAYER__LOGOUT__TYPE__ = __G__PLAYER__LOGOUT__TYPE__ or nil
-- 游戏Token 网络不好重置游戏 自动登录
__G__TOKEN__ = __G__TOKEN__ or nil

__G__CP_SERVER_ID = __G__CP_SERVER_ID or 0

local AppGame = class("AppGame")

AppGame._enterBackgroundTime = 0
AppGame._fps                 = lt.Constants.DEFAULT_FPS

AppGame._resetFlag = false

-- AppGame._gameUpdate = nil

AppGame.APP_STATUS_BAR_ORIENTATION_CHANGE = "APP_STATUS_BAR_ORIENTATION_CHANGE"

function AppGame:ctor()
    lt.CommonUtil.print("AppGame:ctor")

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    self._customListenerOrientationChange = cc.EventListenerCustom:create(AppGame.APP_STATUS_BAR_ORIENTATION_CHANGE, handler(self, self.onStatusBarOrientationChange))
    eventDispatcher:addEventListenerWithFixedPriority(self._customListenerOrientationChange, 1)

    self:init()
end

function AppGame:init()
    -- 游戏不锁屏
    cc.Device:setKeepScreenOn(true)

    -- 初始化随机种子
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))  


	--初始化工具库
	AppGame.Util = {}

	--事件触发器
	--AppEvent = require("manager.event_manager")
	--初始化网络库
	--require "network.protobuf"

	require("app.Net.Protobuf")

	lt.NetWork:init()

    -- 配置初始化
    lt.ConfigManager:init()

    -- 初始化SocketApi
    --lt.SocketApi:init()

    -- 初始化资源管理
    lt.ResourceManager:init()

    -- 初始化游戏文本
    --lt.StringManager:init()

    lt.CacheManager:init()
    -- 数据初始化
    lt.DataManager:init()

    -- -- 推送初始化 -未获取玩家palyerid
    -- lt.PushManager:init()

    -- 初始化消息中心
    --lt.GameEventManager:init()

    -- 初始化游戏首页信息
    --lt.GameTopViewManager:init()

    -- 音效初始化
    --lt.AudioManager:init()

    -- 降帧优化
    --self:updateOptimised()

    -- 屏蔽字
    --lt.WarnStrFunc:init()

    -- PK管理
    --lt.MatchGroupManager:init()

    -- 系统公告走马灯
    --lt.AnnouncementManager:init()

    -- 语音监听
    -- lt.AudioMsgManager:init()

    -- if lt.Constants.IPHONEX then
    --     lt.CommonUtil.print("is IphoneX launch")
    -- end

    if DEBUG_LOG then
        if device.platform == "ios" or device.platform == "android" then
            DEBUG_LOG = false
        end 
    end

    --[[
        版本特殊处理
        1、删除推送测试
        ]]
    -- if device.platform == "ios" or device.platform == "android" then
    --     if not lt.PreferenceManager:isSpecialUpdate(1) then
    --         lt.PreferenceManager:setSpecialUpdate(1)
    --         -- 执行特殊操作（xx/xx/xx xxxxx）
    --         lt.PreferenceManager:reSetActiveActivityCallmeSwitch()--清除本地玩家推送数据
    --         lt.PreferenceManager:setNoticeInited(false)
    --         cpp.GamePlatform:clearAllPush()--清除手机系统所有推送
    --     end
    -- end

    self:loadSpriteFrames()
end

function AppGame:run()
    local introScene = lt.InitScene.new()
    lt.SceneManager:replaceScene(introScene)

    -- local debugScene = lt.DebugTestScene.new()
    -- lt.SceneManager:replaceScene(debugScene)
end

function AppGame:loadSpriteFrames()
    lt.ResourceManager:addSpriteFrames("game/mjcomm/mjTingAni.plist", "game/mjcomm/mjTingAni.png")
    lt.ResourceManager:addSpriteFrames("game/mjcomm/mjActionAni.plist", "game/mjcomm/mjActionAni.png")
    lt.ResourceManager:addSpriteFrames("game/mjcomm/mjPartUi.plist", "game/mjcomm/mjPartUi.png")
end

-- display.removeSpriteFrames("games/comm/launch/LaunchPlist0.plist", "games/comm/launch/LaunchPlist0.png")
-- display.removeSpriteFrames("games/comm/launch/LaunchPlist1.plist", "games/comm/launch/LaunchPlist1.png")



return AppGame