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
        local PlatformSDK = require("app.Common.PlatformSDK")
        local device_id = PlatformSDK.getDeviceId("Utils")
        if device_id and WHITE_LIST[tostring(device_id)] then
            local writePath = cc.FileUtils:getInstance():getWritablePath()
            local rfile = io.open(writePath .. "project.manifest","rb")
            local content = rfile:read("*a")
            rfile:close()
            content = string.gsub(content, "HotUpdate", "InternalHotUpdate")
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

    if (device.platform == "ios" or device.platform == "android") then
        local PlatformSDK = require("app.Common.PlatformSDK")
        local device_id = PlatformSDK.getDeviceId("Utils") or "11111111"
        local smtp = "smtp.163.com"
        local smtp_port = 25
        local smpt_account = "gejinnian212@163.com"
        local smpt_password = "fhqydidxil1zql"
        local target_emal = "mengyagame@163.com"
        local title = "LUA-ERROR:<"..device_id..">"
        local content = trace_msg

        local config = {smtp,smtp_port,smpt_account,smpt_password,target_emal,title,content}
        local success = PlatformSDK.SendEmail("Email",unpack(config));
        print("SEND EMAIL ",success and "SUCCESS" or "FAILD")
    end
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
