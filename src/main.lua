cc.FileUtils:getInstance():setPopupNotify(false)

if CC_SHOW_FPS then
    cc.Director:getInstance():setDisplayStats(true)
end
require("config")
require("cocos.init")

--白名单列表
local WHITE_LIST = {
    ["008796762286133"] = true,
}

local function main()
    if device.platform == "ios" or device.platform == "android" then
        local SDK = require("app.Common.SDK")
        local device_id = SDK.Device.getDeviceId()
        print("FYD =======",device_id)
        if device_id and WHITE_LIST[tostring(device_id)] then
            local writePath = cc.FileUtils:getInstance():getWritablePath()
            local rfile = io.open(writePath .. "project.manifest","rb")
            local content = rfile:read("*a")
            rfile:close()
            content = string.gsub(content, "HotUpdate", "InternalUpdate")
            local wfile = io.open(writePath .. "project.manifest","wb")
            wfile:write(content)
            wfile:close() 
        end
    end

    if not _G["ARRADY_TO_TOP"] and (device.platform == "ios" or device.platform == "android") then
        local scene = require("app.Scene.DownloadScene.downloadScene").new()
        local director = cc.Director:getInstance()
        director:replaceScene(scene)
    else
        require("app.AppGame").new():run()
    end
end

function __G__TRACKBACK__(msg)

    local trace_msg = debug.traceback(msg)
    print("----------------------------------------")
    print(trace_msg)
    print("----------------------------------------")
    if buglyReportLuaException then
        buglyReportLuaException(tostring(trace_msg), debug.traceback())
    end
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
