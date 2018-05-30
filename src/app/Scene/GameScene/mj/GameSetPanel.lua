
--设置层
local GameSetPanel = class("GameSetPanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/csb/base/GameFunBtnPanel.csb")
end)


function GameSetPanel:ctor()
	GameSetPanel.super.ctor(self)


	self:getChildByName("Bg_Help_Start"):setVisible(false)
	self:getChildByName("Bg_Help_NoStart"):setVisible(false)
	self:getChildByName("Bg_MaskLead"):setVisible(false)
	self:getChildByName("Bg_MaskGiftLead"):setVisible(false)
	self:getChildByName("Bg_MaskChatLead"):setVisible(false)
	self:getChildByName("Btn_ChatLead"):setVisible(false)
	self:getChildByName("Btn_LeadBg"):setVisible(false)
	self:getChildByName("Panel_RecordCtrl"):setVisible(false)
	self:getChildByName("Node_InviteView"):setVisible(false)
	self:getChildByName("Bg_ShareLayer"):setVisible(false)
	self:getChildByName("Button_Invite"):setVisible(false)

	local ruleBtn = self:getChildByName("Button_GameRule")
	local setBtn = self:getChildByName("Button_More")

	lt.CommonUtil:addNodeClickEvent(setBtn, handler(self, self.onSetClick))
	lt.CommonUtil:addNodeClickEvent(ruleBtn, handler(self, self.onRuleClick))

end

function GameSetPanel:onSetClick(event) 
	local setLayer = lt.SettingLayer.new()
    lt.UILayerManager:addLayer(setLayer, true)
end

function GameSetPanel:onRuleClick(event) 

end

function GameSetPanel:onEnter()   

end

function GameSetPanel:onExit()

end

return GameSetPanel