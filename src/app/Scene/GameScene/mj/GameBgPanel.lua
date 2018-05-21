
--背景层
local GameBgPanel = class("GameBgPanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/csb/base/GameBg.csb")--背景层--  FriendLayer
end)


function GameBgPanel:ctor()
	GameBgPanel.super.ctor(self)
	local bg1 = lt.CommonUtil:getChildByNames(self, "Panel_Bg", "Sprite_Bg_1")
	local bg2 = lt.CommonUtil:getChildByNames(self, "Panel_Bg", "Sprite_Bg_2")
	local Sprite_Word = lt.CommonUtil:getChildByNames(self, "Panel_Bg", "Sprite_Word")
	Sprite_Word:setVisible(false)
end

function GameBgPanel:onEnter()   

end

function GameBgPanel:onExit()

end

return GameBgPanel