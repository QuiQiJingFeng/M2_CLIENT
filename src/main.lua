cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"

--全局变量大写

Game = {}
require "util.init"
Game.SceneManager = require("scene.scene_manager")

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

    Game.SceneManager:runScene("login_scene")
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
