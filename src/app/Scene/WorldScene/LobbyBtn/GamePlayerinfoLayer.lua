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
    self._info = info
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

	self._scrollView = self._image_GPSBg:getChildByName("ScrollView")

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

function GamePlayerinfoLayer:UpdateInfo()
	local gameInfo = lt.DataManager:getGameRoomInfo()
	    --虚拟数据
    if #gameInfo.players == 1 then
	    gameInfo.players[1].latitude  = 34.776416
	    gameInfo.players[1].lontitude = 113.624636
	elseif #gameInfo.players == 2 then
		gameInfo.players[1].latitude  = 34.776416
	    gameInfo.players[1].lontitude = 113.624636
	    gameInfo.players[2].latitude  = 34.776488
	    gameInfo.players[2].lontitude = 113.624655
	elseif #gameInfo.players == 3 then
		gameInfo.players[1].latitude  = 34.776416
	    gameInfo.players[1].lontitude = 113.624636
	    gameInfo.players[2].latitude  = 34.776488
	    gameInfo.players[2].lontitude = 113.624655
	    gameInfo.players[3].latitude  = 34.776455
	    gameInfo.players[3].lontitude = 113.624644
	elseif #gameInfo.players == 4 then
		gameInfo.players[1].latitude  = 34.776416
	    gameInfo.players[1].lontitude = 113.624636
	    gameInfo.players[2].latitude  = 34.776417
	    gameInfo.players[2].lontitude = 113.624637
	    gameInfo.players[3].latitude  = 34.776455
	    gameInfo.players[3].lontitude = 113.624644
	    gameInfo.players[4].latitude  = 34.776419
	    gameInfo.players[4].lontitude = 113.624638
	end
	local GpsTable = {}
	for k,v in ipairs(gameInfo.players) do
		if self._info.user_id ~= v.user_id then
			local juli = self:getDistance(self._info.latitude,self._info.lontitude,v.latitude,v.lontitude)
			local interimTable = {}
			table.insert( interimTable, v )
			table.insert( interimTable, juli)
			table.insert( GpsTable, interimTable )
		end
	end
	
	for i=1,#GpsTable do
		local Tt_NickName = self._scrollView:getChildByName("Tt_NickName"..i)
		Tt_NickName:setVisible(true)
		local intNum = math.ceil(GpsTable[i][2])
		if intNum >= 1000 then
			intNum = intNum/1000
			Tt_NickName:setString("距"..GpsTable[i][1].user_name.." "..intNum.."公里")
		else
			Tt_NickName:setString("距"..GpsTable[i][1].user_name.." "..intNum.."米")
		end
		
	end
end

function GamePlayerinfoLayer:rad(d)
    return d * math.pi / 180.0
end
--[[
 * 根据两点的经纬度，计算出其之间的距离（返回单位为km）
 * @param lat1 纬度1
 * @param lng1 经度1
 * @param lat2 纬度2
 * @param lng2 经度2
 * @return --]]

function GamePlayerinfoLayer:getDistance(lat1,lng1,lat2,lng2)
    local dd = 6378.137--地球半径
    local radLat1 = self:rad(lat1)
    local radLat2 = self:rad(lat2)
    local a = radLat1 - radLat2
    local b = self:rad(lng1) - self:rad(lng2)
    local s = 2 * math.asin(math.sqrt(math.pow(math.sin(a/2),2) + 
    math.cos(radLat1)*math.cos(radLat2)*math.pow(math.sin(b/2),2)))

    s = s * dd
    return s * 1000-- 单位米
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

function GamePlayerinfoLayer:Close()
	lt.UILayerManager:removeLayer(self)
end

function GamePlayerinfoLayer:onEnter()

end

function GamePlayerinfoLayer:onExit()
	
end

return GamePlayerinfoLayer