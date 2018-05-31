local LobbyNoticeMsgBoxLayer = class("LobbyNoticeMsgBoxLayer", function()
    return cc.CSLoader:createNode("hallcomm/lobby/LobbyNoticeMsgBox.csb")
end)

function LobbyNoticeMsgBoxLayer:ctor()
	local mainLayer = self:getChildByName("Ie_Bg")
	--返回按钮
	local backBtn = mainLayer:getChildByName("Bn_Sure")
	local ScrollView_Notice = mainLayer:getChildByName("ScrollView_Notice")
	local Tt_Countent = ScrollView_Notice:getChildByName("Tt_Countent")
	Tt_Countent:setString("")
	

	lt.CommonUtil:addNodeClickEvent(backBtn, handler(self, self.onBack))
end

function LobbyNoticeMsgBoxLayer:onBack(event)
	lt.UILayerManager:removeLayer(self)
end

return LobbyNoticeMsgBoxLayer