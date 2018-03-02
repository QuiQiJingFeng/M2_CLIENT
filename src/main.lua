cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"

--全局变量大写
App = {}

--初始化工具库
App.Util = {}

App.Configuration = require("manager.configuration")
App.Configuration:Init()



--初始化场景管理器
App.SceneManager = require("manager.scene_manager")


--事件触发器
AppEvent = require("manager.event_manager")
--初始化网络库
require "network.protobuf"
AppNet = require("network.network"):init()

--TODO
-- require "manager.init"
-- require "logic.init"

if CC_SHOW_FPS then
    cc.Director:getInstance():setDisplayStats(true)
end

math.newrandomseed()

local function main()
	--TODO
    -- display.runScene(require("scene.battle"):create(require("tmp"):doBattle()))
    -- display.runScene(require("scene.game_scene"):create())

    App.SceneManager:runScene("login_scene")
end

function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print(debug.traceback(msg))
    print("----------------------------------------")

    return msg
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
