
--背景层
local GameBgPanel = class("GameBgPanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/csb/base/GameBg.csb")--背景层--  FriendLayer
end)


function GameBgPanel:ctor()
	GameBgPanel.super.ctor(self)
	self._bg1 = lt.CommonUtil:getChildByNames(self, "Panel_Bg", "Sprite_Bg1_1")--绿
	self._bg2 = lt.CommonUtil:getChildByNames(self, "Panel_Bg", "Sprite_Bg1_2")

	self._bg1_2 = lt.CommonUtil:getChildByNames(self, "Panel_Bg", "Sprite_Bg2_1")--蓝
	self._bg2_2 = lt.CommonUtil:getChildByNames(self, "Panel_Bg", "Sprite_Bg2_2")

	self._bg1_3 = lt.CommonUtil:getChildByNames(self, "Panel_Bg", "Sprite_Bg3_1")--红
	self._bg2_3 = lt.CommonUtil:getChildByNames(self, "Panel_Bg", "Sprite_Bg3_2")

	local Sprite_Word = lt.CommonUtil:getChildByNames(self, "Panel_Bg", "Sprite_Word")
	Sprite_Word:setVisible(false)
end

function GameBgPanel:setRoomBg(id)
	if id == 1 then
		self._bg1:setVisible(true)
		self._bg2:setVisible(true)
		self._bg1_2:setVisible(false)
		self._bg2_2:setVisible(false)
		self._bg1_3:setVisible(false)
		self._bg2_3:setVisible(false)
	elseif id == 2 then
		self._bg1:setVisible(false)
		self._bg2:setVisible(false)
		self._bg1_2:setVisible(true)
		self._bg2_2:setVisible(true)
		self._bg1_3:setVisible(false)
		self._bg2_3:setVisible(false)
	elseif id == 3 then
		self._bg1:setVisible(false)
		self._bg2:setVisible(false)
		self._bg1_2:setVisible(false)
		self._bg2_2:setVisible(false)
		self._bg1_3:setVisible(true)
		self._bg2_3:setVisible(true)
	end
end

function GameBgPanel:onEnter()   

end

function GameBgPanel:onExit()

end

return GameBgPanel