
local pi = math.pi

local debugSEMonsterId = 58

-- ################################################## 世界界面(菜单界面) ##################################################
local WorldMenuLayer = class("WorldMenuLayer", function()
    return cc.CSLoader:createNode("hallcomm/lobby/LobbyLayer1.csb")
end)

WorldMenuLayer._winScale = lt.CacheManager:getWinScale()

WorldMenuLayer._worldLayer = nil

local locationScale = WorldMenuLayer._winScale
if locationScale < 1 then
    locationScale = locationScale * 0.8
end

WorldMenuLayer._rightZoomBtnstatus = 1 --右上角缩放按钮状态 1 伸出 2 缩进

WorldMenuLayer._buttonListArray = nil

function WorldMenuLayer:ctor()
    --self._updateLayer = cc.CSLoader:createNode("games/comm/launch//UpdateLayer.csb")

    local baseLayer = self:getChildByName("Ie_Bg") --csd

    --设置按钮
    local setBtn = baseLayer:getChildByName("Ie_Bg"):getChildByName("Pl_Info"):getChildByName("Bn_Set")
    --个人信息
    local infoBtn= baseLayer:getChildByName("Ie_Bg"):getChildByName("Pl_Info"):getChildByName("Pl_MyInfo"):getChildByName("Ie_HeadBg"):getChildByName("Ie_Shade")

    local createRoomBtn = self:getChildByName("Ie_Bg"):getChildByName("Bn_CreateRoom")
    local joinRoomBtn = self:getChildByName("Ie_Bg"):getChildByName("Bn_JoinRoom")
    
    self.Se_Create = createRoomBtn:getChildByName("Se_Create")
    self.Se_Return = createRoomBtn:getChildByName("Se_Return")


    lt.CommonUtil:addNodeClickEvent(setBtn, handler(self, self.onClickSetBtn))
    lt.CommonUtil:addNodeClickEvent(infoBtn, handler(self, self.onClickinfoBtn))
    lt.CommonUtil:addNodeClickEvent(createRoomBtn, handler(self, self.onClickCreateRoomBtn))
    lt.CommonUtil:addNodeClickEvent(joinRoomBtn, handler(self, self.onClickJoinRoomBtn))
    -- self:checkRightBtnNode()
    -- self:updateNewFlagInfo()
    --lt.UILayerManager:addLayer(commonAlertLayer, true)


    self.bg_NoData = lt.CommonUtil:getChildByNames(self,"Ie_Bg","Ie_Bg","Ie_MyRoom","Pl_NoData")

    local tb_room_info = lt.CommonUtil:getChildByNames(self,"Ie_Bg","Ie_Bg","Ie_MyRoom","Pl_InfoBg")

    local UITableView = require("app.UI.UITableView")
    self.tb_room_info = UITableView:bindNode(tb_room_info,"app.Scene.WorldScene.WorldMenuLayerRoomItem")

    self:listenRoomListUpdate()

end

function WorldMenuLayer:onEnter()
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.ROOM_LIST_UPDATE, handler(self, self.listenRoomListUpdate), "WorldMenuLayer.listenRoomListUpdate")
end

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
        end)
end

function WorldMenuLayer:onClickSetBtn(event)
    -- local setLayer = lt.SetLayer.new()
    -- lt.UILayerManager:addLayer(setLayer, true)
    local callBack = function(str) 
        print("FYD===>>",str)
    end
    lt.Luaj.callStaticMethod("com/mengya/common/PlatformSDK", "registerCallBack",{callBack},"(I)V")
    local path = cc.FileUtils:getInstance():getWritablePath() .. "/res/games/bj/game_1.png"
    local data = {0,"萌芽娱乐","畅玩麻将体验","https://mengyagame.com",path}
    local ok,ret = lt.Luaj.callStaticMethod("com/mengya/wechat/WechatDelegate", "wxshareURL",data,"(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
    if not ok then
        print("FYD ERROR: SIGNIN FAILED ",ret)
    end
end

function WorldMenuLayer:onClickinfoBtn(event)
    print("------------gerenxinxi")
     local lobbyInfoLayer = lt.lobbyInfoLayer.new()
     lt.UILayerManager:addLayer(lobbyInfoLayer, true)
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
