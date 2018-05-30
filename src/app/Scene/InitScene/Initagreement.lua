
local Initagreement = class("Initagreement", lt.BaseLayer, function()
    return cc.CSLoader:createNode("games/comm/launch/UserRuleLayer.csb")
end)

function Initagreement:ctor()
    Initagreement.super.ctor(self)
    self._Ie_Bg = self:getChildByName("Ie_Bg")
    self._bn_Sure = self._Ie_Bg:getChildByName("Bn_Sure")
    lt.CommonUtil:addNodeClickEvent(self._bn_Sure, handler(self, self.onSure))
end

function Initagreement:onSure()
    self:removeFromParent()
end

return Initagreement