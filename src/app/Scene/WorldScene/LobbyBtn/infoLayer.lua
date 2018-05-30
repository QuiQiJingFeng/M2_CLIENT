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

	local loginData = lt.DataManager:getPlayerInfo()
	if not loginData.user_name then
		loginData.user_name = " "
	end
	if not loginData.user_id then
		loginData.user_id = " "
	end
	Tt_NickName:setString(loginData.user_name)
	Tt_Id:setString(loginData.user_id)
	dump(loginData)
	lt.CommonUtil:addNodeClickEvent(backBtn, handler(self, self.onBack))
end

function lobbyInfoLayer:onBack(event)
	lt.UILayerManager:removeLayer(self)
end

return lobbyInfoLayer