local LobbyHezuo = class("LobbyHezuo", function ( ... )
	return cc.CSLoader:createNode("hallcomm/lobby/LobbyHeZuo.csb")
end)

function LobbyHezuo:ctor( ... )
	local BG_Mark = self:getChildByName("BG_Mark")
	local Text_WX = self:getChildByName("Ie_BG"):getChildByName("Text_WX")
	local Button_Close = self:getChildByName("Ie_BG"):getChildByName("Button_Close")
	local Button_Copy = self:getChildByName("Ie_BG"):getChildByName("Image_17")

	lt.CommonUtil:addNodeClickEvent(Text_WX, handler(self, self.onClose))
	lt.CommonUtil:addNodeClickEvent(Button_Close, handler(self, self.onClose))
	lt.CommonUtil:addNodeClickEvent(Button_Copy, handler(self, self.onCopy))

	self.Ie_BG1 = self:getChildByName("Ie_BG1")
	local Ie_Btn = self.Ie_BG1:getChildByName("Image_17")
	self.Ie_BG1:setVisible(false)
	-- 确定按钮
	lt.CommonUtil:addNodeClickEvent(Ie_Btn, handler(self, self.onClose))

end
function LobbyHezuo:onCopy( ... )
	self.Ie_BG1:setVisible(true)
end

function LobbyHezuo:onClose( ... )
	self:removeSelf()
end
function LobbyHezuo:onEnter( ... )
	
end

function LobbyHezuo:onExit( ... )
	
end

return LobbyHezuo