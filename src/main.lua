cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"

Game = {}
require "util.init"
require "manager.init"
require "logic.init"

if CC_SHOW_FPS then
    cc.Director:getInstance():setDisplayStats(true)
end

math.newrandomseed()

local function main()
    -- display.runScene(require("scene.battle"):create(require("tmp"):doBattle()))
    display.runScene(require("scene.demo"):create())
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
