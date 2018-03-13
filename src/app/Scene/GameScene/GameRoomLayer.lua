
local GameRoomLayer = class("GameRoomLayer", lt.BaseLayer)

function GameRoomLayer:ctor()
	GameRoomLayer.super.ctor(self)

	local roomInfo = lt.DataManager:getGameRoomInfo()

	if roomInfo.game_type == 1 then
		
	end

	self._bgNode = cc.CSLoader:createNode("game/mjcomm/csb/base/GameBg.csb")--背景层

	--self._cardsNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/2p/MjCardsPanel2p.csb")--牌面层

	self._playerNode = cc.CSLoader:createNode("game/mjcomm/csb/base/GamePlayerInfo.csb")--入座 玩家头像

	self._setNode = cc.CSLoader:createNode("game/mjcomm/csb/base/GameFunBtnPanel.csb")--设置

	self._infoNode = cc.CSLoader:createNode("game/mjcomm/csb/base/GameTableInfo.csb")--房间信息

	self._setNode:getChildByName("Bg_Help_Start"):setVisible(false)
	self._setNode:getChildByName("Bg_Help_NoStart"):setVisible(false)
	self._setNode:getChildByName("Bg_MaskLead"):setVisible(false)
	self._setNode:getChildByName("Bg_MaskGiftLead"):setVisible(false)
	self._setNode:getChildByName("Bg_MaskChatLead"):setVisible(false)
	self._setNode:getChildByName("Btn_ChatLead"):setVisible(false)
	self._setNode:getChildByName("Btn_LeadBg"):setVisible(false)
	self._setNode:getChildByName("Panel_RecordCtrl"):setVisible(false)
	self._setNode:getChildByName("Node_InviteView"):setVisible(false)
	self._setNode:getChildByName("Bg_ShareLayer"):setVisible(false)

	self:addChild(self._bgNode)
	--self:addChild(self._cardsNode)
	self:addChild(self._playerNode)
	self:addChild(self._setNode)
	self:addChild(self._infoNode)

	--local Ie_Bg = self:getChildByName("Ie_Bg")

end


function GameRoomLayer:onEnter()   
    print("InitLayer:onEnter")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.LOGIN, handler(self, self.onLoginResponse), "InitLayer:onLoginResponse")
end

function GameRoomLayer:onExit()
    print("InitLayer:onExit")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.LOGIN, "InitLayer:onLoginResponse")
end


return GameRoomLayer