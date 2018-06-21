
local EVENT_CODE = cc.EventAssetsManagerEx.EventCode

local layer = class("downlaodLayer",function() 
		return cc.Layer:create()
	end)

function layer:ctor(call_back) 
	local bg = cc.CSLoader:createNode("games/comm/launch/LaunchLayer.csb")
	self:addChild(bg)
	local updateLayer = cc.CSLoader:createNode("games/comm/launch/UpdateLayer.csb")
	self:addChild(updateLayer)

	local process = updateLayer:getChildByName("Ie_Bg"):getChildByName("Pl_Update"):getChildByName("LB_Update")
	process:setDirection(ccui.LoadingBarDirection.LEFT)
	process:setPercent(0)
	self.process = process

    self:createAssetsManager()

	self.assets_manager:update()
end

--创建更新器
function layer:createAssetsManager()
    local store_path = cc.FileUtils:getInstance():getWritablePath()
    self.store_path = store_path
    local manifest_path = store_path.."project.manifest"
    self.assets_manager = cc.AssetsManagerEx:create(manifest_path, store_path)
    self.assets_manager:retain()

    --获取本地manifest
    local manifest = self.assets_manager:getLocalManifest()
    local listener = cc.EventListenerAssetsManagerEx:create(self.assets_manager, handler(self,self.onUpdateEvent))
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener, 1)
end

function layer:onUpdateEvent(event)
    local am = self.assets_manager

    local eventCode = event:getEventCode()

    if eventCode == EVENT_CODE.ERROR_NO_LOCAL_MANIFEST then
        print("No local manifest file found, skip assets update.")
    elseif  eventCode == EVENT_CODE.UPDATE_PROGRESSION then
        local assetId = event:getAssetId()
        local percent = event:getPercent()
        local strInfo = ""

        if assetId == cc.AssetsManagerExStatic.VERSION_ID then
            -- strInfo = string.format("Version file: %d%%", percent)
            -- print('version 文件下载成功') 
        elseif assetId == cc.AssetsManagerExStatic.MANIFEST_ID then
            -- strInfo = string.format("Manifest file: %d%%", percent)
            -- print('manifest 文件下载成功')
        else
            self:showProcess(percent)

        end
    elseif eventCode == EVENT_CODE.ERROR_DOWNLOAD_MANIFEST or 
           eventCode == EVENT_CODE.ERROR_PARSE_MANIFEST or 
           eventCode == EVENT_CODE.UPDATE_FAILED then
        self:processError(eventCode)

    elseif eventCode == EVENT_CODE.NEW_VERSION_FOUND then
 

    elseif eventCode == EVENT_CODE.ERROR_UPDATING then
        print("EVENT_CODE.ERROR_UPDATING", event:getAssetId())

    elseif eventCode == EVENT_CODE.ASSET_UPDATED then
        print("EVENT_CODE.ASSET_UPDATED", event:getAssetId())

    elseif eventCode == EVENT_CODE.ERROR_DECOMPRESS then
        --解压失败  -->弹出提示解压失败  -->确定-->退出游戏
        print('FYD-----解压失败')

    elseif eventCode == EVENT_CODE.ALREADY_UP_TO_DATE or eventCode == EVENT_CODE.UPDATE_FINISHED then
        --完成更新
        print('FYD----ALREADY_UP_TO_DATE')
        --plugin_download所依赖的脚本都必须重新加载

        if eventCode == EVENT_CODE.UPDATE_FINISHED then
            --download_scene所依赖的脚本都必须重新加载
            local module_name_list = { 
                    "app.Scene.DownloadScene.downloadLayer",
                    "app.Scene.DownloadScene.downloadScene",
                    "main"
                }
            
            for _, module_name in ipairs(module_name_list) do
                package.loaded[module_name] = nil
            end
            _G["ARRADY_TO_TOP"] = true
            require "main"
        else
            --跳转到登陆界面
            require("app.AppGame").new():run()
            
        end
    end

end
 
function layer:showProcess(progress)
	self.process:setPercent(progress)
end

function layer:processError(eventCode)
    if eventCode == EVENT_CODE.ERROR_DOWNLOAD_MANIFEST then
        --manifest文件下载失败，需要提示用户是否重新下载project.manifest
        self.assets_manager:setState(EVENT_CODE.ALREADY_UP_TO_DATE)
        self.assets_manager:update()
    elseif eventCode == EVENT_CODE.UPDATE_FAILED then
        --部分文件下载成功
        self.assets_manager:downloadFailedAssets()
    else
        DoExit()
    end
end

--[[
        ERROR_NO_LOCAL_MANIFEST = 0, --本地manifest不存在
        ERROR_DOWNLOAD_MANIFEST = 1, --下载manifest失败
        ERROR_PARSE_MANIFEST = 2,    --解析manifest文件失败
        NEW_VERSION_FOUND = 3,  --当远端有新的版本时触发,触发两次(assert.manifest,version.manifest)
        ALREADY_UP_TO_DATE = 4, --当远端版本号小于等于当前版本号的时候触发
        UPDATE_PROGRESSION = 5, --更新中进度进行中
        ASSET_UPDATED = 6,      --新的zip开始下载的时候触发事件
        ERROR_UPDATING = 7,
        UPDATE_FINISHED = 8,    --更新完毕(解压也完毕)时调用 
        UPDATE_FAILED = 9,
        ERROR_DECOMPRESS = 10,  --解压失败  -->源码有修改:解压缩失败应该直接进入游戏，最起码能够保证下次热更可以接到
        NEW_PATCH_FOUND = 11,   --3.10 C++中已经没有这个事件了,但是lua表中并没有删掉
]]

return layer