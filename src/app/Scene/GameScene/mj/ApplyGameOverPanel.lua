
--设置层
local ApplyGameOverPanel = class("ApplyGameOverPanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/gwidget/EndRequestLayer.csb")
end)

function ApplyGameOverPanel:ctor()
	ApplyGameOverPanel.super.ctor(self)


	local root = self:getChildByName("Ie_Bg")


	local clockIcon = root:getChildByName("Clock_icon")

	local TtContent = root:getChildByName("Tt_Content")



	local  = lt.CommonUtil:getChildByNames(root, "Se_CutTime", "")



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

function ApplyGameOverPanel:onSetClick(event) 
	local setLayer = lt.SettingLayer.new()
    lt.UILayerManager:addLayer(setLayer, true)
end

function ApplyGameOverPanel:onRuleClick(event) 

end

function ApplyGameOverPanel:onEnter()   

end

function ApplyGameOverPanel:onExit()

end

return ApplyGameOverPanel