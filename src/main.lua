cc.FileUtils:getInstance():setPopupNotify(false)

if CC_SHOW_FPS then
    cc.Director:getInstance():setDisplayStats(true)
end

local function main()
	--TODO
    -- display.runScene(require("scene.battle"):create(require("tmp"):doBattle()))
    -- display.runScene(require("scene.game_scene"):create())

    --App.SceneManager:runScene("login_scene")
    -- require("app.AppGame").new():run()

    if not _G["ARRADY_TO_TOP"] and (device.platform == "ios" or device.platform == "android") then
        local scene = require("app.Scene.DownloadScene.downloadScene").new()
        local director = cc.Director:getInstance()
        director:replaceScene(scene)
    else
        require("app.AppGame").new():run()
    end


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
