local lobbyInfoLayer = class("lobbyInfoLayer", function()
    return cc.CSLoader:createNode("hallcomm/common/PlayerInfoLayer.csb")
end)

function lobbyInfoLayer:ctor()
	local mainLayer = self:getChildByName("Ie_Bg")
	--返回按钮
	local backBtn = mainLayer:getChildByName("Button_ClosePlayerInfoLayer")
	local Tt_NickName = mainLayer:getChildByName("Tt_NickName")
	local Tt_Id = mainLayer:getChildByName("Tt_Id")
	local Tt_Ip = mainLayer:getChildByName("Tt_Ip")
	-- 历史记录
	local txtGoldNum = mainLayer:getChildByName("Text_GameGold")
	local img_smz = mainLayer:getChildByName("img_smz")
	local infoImg = mainLayer:getChildByName("Ie_Head"):getChildByName("BG16")

	dump(loginData, "loginData")
	-- [LUA-print] -     "adress"    = ""
	-- [LUA-print] -     "gold_num"  = 100
	-- [LUA-print] -     "is_check"  = true
	-- [LUA-print] -     "result"    = "success"
	-- [LUA-print] -     "sex"       = 0
	-- [LUA-print] -     "user_id"   = 10095
	-- [LUA-print] -     "user_ip"   = "171.8.222.136"
	-- [LUA-print] -     "user_name" = "feng84331"
	-- [LUA-print] -     "user_pic"  = "http://img1.utuku.china.com/0x0/game/20160718/f2547293-78a9-4e50-a80f-727593f8c19f.jpg"

	local loginData = lt.DataManager:getPlayerInfo()
	img_smz:setVisible(loginData.is_check)
	if not loginData.user_name then
		loginData.user_name = " "
	end
	if not loginData.user_id then
		loginData.user_id = " "
	end
	txtGoldNum:setString("金币数："..loginData.gold_num)
	Tt_Ip:setString("IP:".. loginData.user_ip)
	Tt_NickName:setString(loginData.user_name)
	Tt_Id:setString("ID:" .. loginData.user_id)
	lt.HeadImage:setHeadImg(loginData, infoImg)
	lt.CommonUtil:addNodeClickEvent(backBtn, handler(self, self.onBack))
end

function lobbyInfoLayer:onBack(event)
	lt.UILayerManager:removeLayer(self)
end

return lobbyInfoLayer