local layer = class("demo_layer", import(".prototype"))

local util = Game.util
local log = util.log

local logic = Game.logic
local login_logic = logic.login

local manager = Game.manager
local network = manager.network
local event_handler = manager.event_handler

function layer:onCreate()

    local sp = cc.Sprite:create("man_1/man_10001.png")
    self:addChild(sp)
    sp:setPosition(cc.p(300,300))
    -- self:createAssetsManager()
    -- print("FYD====>>>更新器开始工作")
    -- self.assets_manager:update()

    local luaj = require "cocos.cocos2d.luaj"
　　local className = "com/common/testJava"
    local args = {1,"2",true,function(params)
        print(tostring(params)) 
    end}
　　local ok,ret = luaj.callStaticMethod(className, "testFunc", args)
　　if not ok then
　　　　print("==== luaj error ==== : ", ret)
　　　　return false
　　else
　　　　print("==== The JNI return is:", ret)
　　　　return ret
　　end
end

--创建更新器   
function layer:createAssetsManager()
    local store_path = cc.FileUtils:getInstance():getWritablePath()
    local manifest_path = store_path .. "project.manifest"
    self.assets_manager = cc.AssetsManagerEx:create(manifest_path, store_path)
    self.assets_manager:retain()

    --获取本地manifest
    local manifest = self.assets_manager:getLocalManifest()
    if manifest then
        cc.UserDefault:getInstance():setStringForKey("version", manifest:getVersion())
    end
    --创建更新器的监听
    local listener = cc.EventListenerAssetsManagerEx:create(self.assets_manager, handler(self,self.onUpdateEvent))
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener, 1)
end

local EVENT_CODE = cc.EventAssetsManagerEx.EventCode
local CONFIG = {
    [EVENT_CODE.ERROR_NO_LOCAL_MANIFEST] = "本地的manifest不存在",
    [EVENT_CODE.ERROR_DOWNLOAD_MANIFEST] = "下载远端manifest失败",
    [EVENT_CODE.ERROR_PARSE_MANIFEST] = "远端manifest json格式有问题",
    [EVENT_CODE.NEW_VERSION_FOUND] = "发现新的版本",
    [EVENT_CODE.ALREADY_UP_TO_DATE] = "当前已经是最新版本",
    [EVENT_CODE.UPDATE_PROGRESSION] = "热更进度事件",
    [EVENT_CODE.ASSET_UPDATED] = "某个zip包下载完毕时触发",
    [EVENT_CODE.ERROR_UPDATING] = "某个文件下载失败",
    [EVENT_CODE.UPDATE_FINISHED] = "更新完毕",
    [EVENT_CODE.UPDATE_FAILED] = "更新失败",
    [EVENT_CODE.ERROR_DECOMPRESS] = "解压失败"
}

function layer:onUpdateEvent(event)
    local eventCode = event:getEventCode()
    print("FYD===>",CONFIG[eventCode])
    if  eventCode == EVENT_CODE.UPDATE_PROGRESSION then
        local assetId = event:getAssetId()
        local percent = event:getPercent()

        if assetId == cc.AssetsManagerExStatic.VERSION_ID then
            -- print('version 文件下载成功') 
        elseif assetId == cc.AssetsManagerExStatic.MANIFEST_ID then
            -- print('manifest 文件下载成功')
        else
            print('资源下载进度 -->',math.ceil(percent))
        end
    elseif eventCode == EVENT_CODE.ASSET_UPDATED then
        print("EVENT_CODE.ASSET_UPDATED", event:getAssetId())
    elseif eventCode == EVENT_CODE.UPDATE_FAILED then
        --对下载失败的文件列表重新下载
        self.assets_manager:downloadFailedAssets()
    elseif eventCode == EVENT_CODE.ALREADY_UP_TO_DATE or eventCode == EVENT_CODE.UPDATE_FINISHED then
        --不需要热更或者热更完毕 进入游戏
    end
end

function layer:onEnter()
end
function layer:onExit()
end
function layer:onCleanup()
end

return layer