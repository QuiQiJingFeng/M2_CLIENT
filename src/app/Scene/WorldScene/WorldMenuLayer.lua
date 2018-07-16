
local pi = math.pi

local debugSEMonsterId = 58

-- ################################################## 世界界面(菜单界面) ##################################################
local WorldMenuLayer = class("WorldMenuLayer", lt.BaseLayer,function()
    return cc.CSLoader:createNode("hallcomm/lobby/LobbyLayer1.csb")
end)

-- WorldMenuLayer._winScale = cc.Director:getInstance():getWinSize()
-- WorldMenuLayer._winScale = lt.CacheManager:getWinScale()

WorldMenuLayer._worldLayer = nil

-- local locationScale = WorldMenuLayer._winScale
-- if locationScale < 1 then
--     locationScale = locationScale * 0.8
-- end

WorldMenuLayer._rightZoomBtnstatus = 1 --右上角缩放按钮状态 1 伸出 2 缩进

WorldMenuLayer._buttonListArray = nil

function WorldMenuLayer:ctor()
    WorldMenuLayer.super.ctor(self)
    -- print( kefuBtn, shareBtn, helpBtn, recordBtn)

    local baseLayer = self:getChildByName("Ie_Bg") --csd
    --设置按钮
    local setBtn = baseLayer:getChildByName("Ie_Bg"):getChildByName("Pl_Info"):getChildByName("Bn_Set")
    -- 规则
    local helpBtn = baseLayer:getChildByName("Ie_Bg"):getChildByName("Pl_Info"):getChildByName("Button_Rule")

    -- vip（合作按钮）
    local vipBtn = baseLayer:getChildByName("Ie_Bg"):getChildByName("Pl_Info"):getChildByName("Button_VIP")
    -- 实名认证btn
    local smzBtn = baseLayer:getChildByName("Ie_Bg"):getChildByName("Pl_Info"):getChildByName("Button_Smz")
    -- 战绩
    local recordBtn = baseLayer:getChildByName("Ie_Bg"):getChildByName("Pl_Info"):getChildByName("Button_Rec")
    --个人信息
    local infoBtn= baseLayer:getChildByName("Ie_Bg"):getChildByName("Pl_Info"):getChildByName("Pl_MyInfo"):getChildByName("Ie_HeadBg"):getChildByName("Ie_Shade")
    local Tt_NickName= baseLayer:getChildByName("Ie_Bg"):getChildByName("Pl_Info"):getChildByName("Pl_MyInfo"):getChildByName("Tt_NickName")
    -- ID
    local Tt_UserId= baseLayer:getChildByName("Ie_Bg"):getChildByName("Pl_Info"):getChildByName("Pl_MyInfo"):getChildByName("Tt_UserId")
    -- 名字后面三个点
    local Tt_NickNameDDD= baseLayer:getChildByName("Ie_Bg"):getChildByName("Pl_Info"):getChildByName("Pl_MyInfo"):getChildByName("Tt_NickNameDDD")
    -- 分享btn
    local shareBtn = baseLayer:getChildByName("Ie_Bg"):getChildByName("Bn_Share")
    -- 客服btn
    local kefuBtn = baseLayer:getChildByName("Ie_Bg"):getChildByName("Bn_Kefu")
    -- 充值按钮
    local shopBtn = baseLayer:getChildByName("Ie_Bg"):getChildByName("Pl_Info"):getChildByName("Pl_MyInfo"):getChildByName("Bn_Recharge")

    local loginData = lt.DataManager:getPlayerInfo()
    local count = 0 
    if not loginData.user_name then
        loginData.user_name = " "
    else
        for uchar in string.gfind(loginData.user_name, "([%z\1-\127\194-\244][\128-\191]*)") do   
            if #uchar ~= 1 then  
                count = count +2  
            else  
                count = count +1  
            end  
        end
    end
    if not loginData.user_id then
        loginData.user_id = " "
    end
    Tt_UserId:setString("ID："..loginData.user_id)
    if count <= 8 then --只显示最多8位  
       Tt_NickName:setString(loginData.user_name)
       Tt_NickNameDDD:setVisible(false)
    else
        local nameText = loginData.user_name
        local substring = lt.CommonUtil:GetMaxLenString(nameText,8)
        Tt_NickName:setString(substring)
        Tt_NickNameDDD:setVisible(true)
    end    

    local createRoomBtn = self:getChildByName("Ie_Bg"):getChildByName("Bn_CreateRoom")
    local joinRoomBtn = self:getChildByName("Ie_Bg"):getChildByName("Bn_JoinRoom")
    -- 创建房间
    self.Se_Create = createRoomBtn:getChildByName("Se_Create")
    self.Se_Return = createRoomBtn:getChildByName("Se_Return")
    -- 添加事件
    lt.CommonUtil:addNodeClickEvent(shopBtn, handler(self, self.onClickshopBtn))
    -- lt.CommonUtil:addNodeClickEvent(kefuBtn, handler(self, self.onClickkefuBtn))
    -- lt.CommonUtil:addNodeClickEvent(shareBtn, handler(self, self.onClickshareBtn))
    lt.CommonUtil:addNodeClickEvent(smzBtn, handler(self, self.onClickSMZBtn))
    lt.CommonUtil:addNodeClickEvent(setBtn, handler(self, self.onClickSetBtn))
    lt.CommonUtil:addNodeClickEvent(infoBtn, handler(self, self.onClickinfoBtn))
    lt.CommonUtil:addNodeClickEvent(createRoomBtn, handler(self, self.onClickCreateRoomBtn))
    lt.CommonUtil:addNodeClickEvent(joinRoomBtn, handler(self, self.onClickJoinRoomBtn))
    lt.CommonUtil:addNodeClickEvent(helpBtn, handler(self, self.onClickhelpBtn))
    lt.CommonUtil:addNodeClickEvent(recordBtn, handler(self, self.onClickrecordBtn))
    lt.CommonUtil:addNodeClickEvent(vipBtn, handler(self, self.onClickVIPBtn))

    self.bg_NoData = lt.CommonUtil:getChildByNames(self,"Ie_Bg","Ie_Bg","Ie_MyRoom","Pl_NoData")
    local tb_room_info = lt.CommonUtil:getChildByNames(self,"Ie_Bg","Ie_Bg","Ie_MyRoom","Pl_InfoBg")
    local UITableView = require("app.UI.UITableView")
    self.tb_room_info = UITableView:bindNode(tb_room_info,"app.Scene.WorldScene.WorldMenuLayerRoomItem")
    self:listenRoomListUpdate()
end

function WorldMenuLayer:onEnter()
    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%++++++++")
    lt.AudioManager:playMusic("hallcomm/sound/lobby/", "bg_music", true)

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.ROOM_LIST_UPDATE, handler(self, self.listenRoomListUpdate), "WorldMenuLayer.listenRoomListUpdate")
end

-- 实名认证界面
function WorldMenuLayer:onClickSMZBtn()
    local AuthenticationLayer = lt.AuthenticationLayer.new()
    lt.UILayerManager:addLayer(AuthenticationLayer, true)
end

-- vip界面
function WorldMenuLayer:onClickVIPBtn()
    -- LobbyHeZuo
    print("vip界面")
    local layer = lt.LobbyHezuo:new()
    lt.UILayerManager:addLayer(layer, true)
end


-- 监听事件
function WorldMenuLayer:listenRoomListUpdate()

    local body = lt.DataManager:getAuthData()
    local url = string.format("http://%s:%d/operator/get_room_list",lt.Constants.HOST,lt.Constants.PORT)
    lt.CommonUtil:sendXMLHTTPrequrest("POST",url,body,function(recv_msg) 
            local info = json.decode(recv_msg)
            print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%", recv_msg)
            if info.room_id and info.state <= 2 then
                lt.CommonUtil:show(self.Se_Return)
                lt.CommonUtil:hide(self.Se_Create)
            else
                lt.CommonUtil:hide(self.Se_Return)
                lt.CommonUtil:show(self.Se_Create)   
            end

            if info.room_list and #info.room_list > 0 then
                lt.CommonUtil:hide(self.bg_NoData)
                self.tb_room_info:setData(info.room_list,0,10)
            end



            --如果没有在房间当中并且剪切板中有房间号,那么可以加入
            local clipstr = lt.SDK.Device.getClipFromBoard()
            if not clipstr or clipstr == "" then
                return
            end
            local room_id = string.match(clipstr, "房号：%[(%d+)%]")
            if not room_id then
                return
            end
            local msg = string.format("检测到剪切板中房间号为%d,是否加入房间？",room_id)
            lt.MsgboxLayer:showMsgBox(msg, false, function()
                local arg = {room_id = room_id}
                lt.CommonUtil:sepecailServerLogin(room_id,function(result) 
                    if result ~= "success" then
                        lt.PromptPanel:showPrompt(lt.Constants.PROMPT[result])
                        return
                    end
                    lt.NetWork:sendTo(lt.GameEventManager.EVENT.JOIN_ROOM, arg)
                end)
            end, function()
                lt.SDK.Device.copyToClipBoard("")
            end, true)


            
        end)
end

function WorldMenuLayer:onClickSetBtn(event)
    local setLayer = lt.SetLayer.new()
    lt.UILayerManager:addLayer(setLayer, true)
end

function WorldMenuLayer:onClickhelpBtn(event)
    local LobbyHelpLayer = lt.LobbyHelpLayer.new()
    lt.UILayerManager:addLayer(LobbyHelpLayer, true)
end

function WorldMenuLayer:onClickrecordBtn(event)
    local ReplayView = lt.ReplayView.new()
    lt.UILayerManager:addLayer(ReplayView, true)
end

function WorldMenuLayer:onClickmergeBtn(event)
    local MergeLayer = lt.MergeLayer.new()
    lt.UILayerManager:addLayer(MergeLayer, true)
end

function WorldMenuLayer:onClicklobbyNoticeMsgBoxBtn(event)--公告注销
    local LobbyNoticeMsgBoxLayer = lt.LobbyNoticeMsgBoxLayer.new()
    lt.UILayerManager:addLayer(LobbyNoticeMsgBoxLayer, true)
end

function WorldMenuLayer:onClickshopBtn(event)
    local ShopLayer = lt.ShopLayer.new()
    lt.UILayerManager:addLayer(ShopLayer, true)
end

function WorldMenuLayer:onClickkefuBtn(event)
    local KefuLayer = lt.KefuLayer.new()
    lt.UILayerManager:addLayer(KefuLayer, true)
end

function WorldMenuLayer:onClickshareBtn(event)
    local WXShareLayer = lt.WXShareLayer.new()
    lt.UILayerManager:addLayer(WXShareLayer, true)
end

function WorldMenuLayer:onClickinfoBtn(event) 
    ---[[--头像
    local url = "http://neoimaging.beareyes.com.cn/png2/ni_png_2_1518.png"
    local uid = "123456"
    local HeadLayer = lt.HeadImage.new(url,uid,64,697,1)
    lt.UILayerManager:addLayer(HeadLayer, true)--]]
    ---[[
    local lobbyInfoLayer = lt.lobbyInfoLayer.new()
    lt.UILayerManager:addLayer(lobbyInfoLayer, true)--]]
end

function WorldMenuLayer:onClickCreateRoomBtn(event)
    local setLayer = lt.CreateRoomLayer.new()
    lt.UILayerManager:addLayer(setLayer, true)
end

function WorldMenuLayer:onClickJoinRoomBtn(event)
    local setLayer = lt.JoinRoomLayer.new()
    lt.UILayerManager:addLayer(setLayer, true)
end

return WorldMenuLayer
