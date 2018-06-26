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

local PlatformSDK = require("app.Common.PlatformSDK")
local md5 = require "md5"

local function main()
    if device.platform == "ios" or device.platform == "android" then
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
local sumhexa = function (k)
    k = md5.sum(k)
    return (string.gsub(k, ".", function (c)
           return string.format("%02x", string.byte(c))
         end))
end

local mark_list = {}

function __G__TRACKBACK__(msg)

    local trace_msg = debug.traceback(msg)
    print("----------------------------------------")
    print(trace_msg)
    print("----------------------------------------")
    
    if (device.platform == "ios" or device.platform == "android") then
        local md5code = sumhexa(msg)
        --检查当前的错误,是否已经提交过了,如果已经提交过了则跳过
        if mark_list[md5code] then
            return
        end
        -- 如果没有提交过,先更新最新的提交列表
        local imapServer = "imap.163.com"
        local port = 143
        local user_name = "mengyagame"
        local passwd = "fhqydidxil1zql"
        local emails = PlatformSDK.ReadAllEmailTitle("Email",imapServer,port,user_name,passwd)
        for code in string.gmatch(emails,"LUA_ERROR%[(.-)%]") do
            mark_list[code] = true
        end
        --如果该错误在最新的提交列表中已经存在,则不用重复上报
        if mark_list[md5code] then
            return
        end
        --如果该错误没有在最新的提交列表中,则需要上报
        local smtp = "smtp.163.com"
        local smtp_port = 25
        local smpt_account = "gejinnian212@163.com"
        local smpt_password = "fhqydidxil1zql"
        local target_emal = "mengyagame@163.com"
        
        local title = "LUA_ERROR["..md5code.."]"
        local content = trace_msg
        local config = {smtp,smtp_port,smpt_account,smpt_password,target_emal,title,content}
        local success = PlatformSDK.SendEmail("Email",unpack(config));
        print("SEND EMAIL ",success and "SUCCESS" or "FAILD")
        if success then
            mark_list[md5code] = true
        end
    end
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
