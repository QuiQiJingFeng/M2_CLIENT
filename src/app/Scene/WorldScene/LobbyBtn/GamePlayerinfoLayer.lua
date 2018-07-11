local GamePlayerinfoLayer = class("GamePlayerinfoLayer", lt.BaseLayer,function()
    return cc.CSLoader:createNode("game/mjcomm/gwidget/PlayerInfoLayer.csb")
end)

function GamePlayerinfoLayer:ctor(info)
	GamePlayerinfoLayer.super.ctor(self)
	--[[
	"cur_score"  = 0
    "disconnect" = false
    "gold_num"   = 0--钱
    "is_sit"     = true
    "score"      = 0
    "user_id"    = 12253
    "user_ip"    = "171.8.222.187"
    "user_name"  = "雀起84209"
    "user_pic"   = "http://xxxx.png"
    "user_pos"   = 1
    --]]
	local mainLayer = self:getChildByName("Ie_Bg")
	local Tt_NickName = mainLayer:getChildByName("Tt_NickName")--名字
	Tt_NickName:setString(info.user_name)
	local Tt_Ip = mainLayer:getChildByName("Tt_Ip")--ip
	Tt_Ip:setString("IP: "..info.user_ip)
	local Tt_Id = mainLayer:getChildByName("Tt_Id")--id
	Tt_Id:setString("ID: "..info.user_id)
	local Txt_Pos = mainLayer:getChildByName("Txt_Pos")--位置

	local Btn_Gps = mainLayer:getChildByName("Btn_Gps")--gps按钮

	self._image_GPSBg = mainLayer:getChildByName("Image_GPSBg")
	self._image_GPSBg:setVisible(false)

	local Ie_Head = mainLayer:getChildByName("Ie_Head")
	local BG16 = Ie_Head:getChildByName("BG16")--头像

	local Text_Money = mainLayer:getChildByName("Text_Money")
	Text_Money:setString("金币: "..info.gold_num)

	local Image_Money = mainLayer:getChildByName("Image_Money")
	Image_Money:setVisible(false)

	lt.CommonUtil:addNodeClickEvent(Btn_Gps, handler(self, self.onGpsClickEvent))

	local Ie_Mark = self:getChildByName("Ie_Mark")
    lt.CommonUtil:addNodeClickEvent(Ie_Mark, handler(self, self.onCloseClickEvent),false)
    lt.CommonUtil:addNodeClickEvent(mainLayer, handler(self, self.onClosemainNodeClickEvent),false)

end

function GamePlayerinfoLayer:onClosemainNodeClickEvent(event)
	self._image_GPSBg:setVisible(false)
end

function GamePlayerinfoLayer:onCloseClickEvent(event)
	self:Close()
end

function GamePlayerinfoLayer:onGpsClickEvent(event)
	self._image_GPSBg:setVisible(true)
end

function GamePlayerinfoLayer:onCancel(event)
	lt.NetWork:sendTo(lt.GameEventManager.EVENT.LEAVE_ROOM)
end

function GamePlayerinfoLayer:Close()
	lt.UILayerManager:removeLayer(self)
end

function GamePlayerinfoLayer:onBackLobbyResponse(msg)
	if msg.result == "success" then
    	local worldScene = lt.WorldScene.new()
        lt.SceneManager:replaceScene(worldScene)
    end
end

function GamePlayerinfoLayer:onEnter()

end

function GamePlayerinfoLayer:onExit()
	
end

return GamePlayerinfoLayer