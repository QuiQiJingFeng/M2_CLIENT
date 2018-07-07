
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

	require("app.Net.Protobuf")

	lt.NetWork:init()

    -- 初始化资源管理
    lt.ResourceManager:init()

    -- 数据初始化
    lt.DataManager:init()

    -- 音效初始化
    lt.AudioManager:init()

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

    lt.ResourceManager:addSpriteFrames("hallcomm/preserve/comm/CommPlist.plist", "hallcomm/preserve/comm/CommPlist.png")

    lt.ResourceManager:addSpriteFrames("hallcomm/lobby/LobbyPlist1.plist", "hallcomm/lobby/LobbyPlist1.png")
    lt.ResourceManager:addSpriteFrames("hallcomm/lobby/LobbyPlist2.plist", "hallcomm/lobby/LobbyPlist2.png")

    lt.ResourceManager:addSpriteFrames("hallcomm/common/CommonPlist0.plist", "hallcomm/common/CommonPlist0.png")
    lt.ResourceManager:addSpriteFrames("hallcomm/common/CommonPlist1.plist", "hallcomm/common/CommonPlist1.png")

    lt.ResourceManager:addSpriteFrames("games/hzmj/game_1.plist", "games/hzmj/game_1.png")
end

-- display.removeSpriteFrames("games/comm/launch/LaunchPlist0.plist", "games/comm/launch/LaunchPlist0.png")
-- display.removeSpriteFrames("games/comm/launch/LaunchPlist1.plist", "games/comm/launch/LaunchPlist1.png")



return AppGame