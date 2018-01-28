cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"

--全局变量大写
App = {}

--初始化工具库
App.Util = {}
App.Util.bit = require "bit"
App.Util.crypt = require "crypt"
App.Util.md5 = require "md5"
App.Util.mime = require "mime"

--初始化事件分发器
App.EventManager = require("manager.event_handler")

--初始化网络库
require "network.protobuf"
App.NetWork = require("network.network"):init()

--初始化场景管理器
App.SceneManager = require("manager.scene_manager")



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
