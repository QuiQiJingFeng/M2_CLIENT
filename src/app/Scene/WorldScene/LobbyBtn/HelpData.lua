local HelpData = class("HelpData", lt.BaseLayer)

function HelpData:ctor()
	print("==========HelpData========",id)
	self._rootNode = nil
	
	--[[
	local rootNode = nil
	local rootNode = cc.CSLoader:createNode("hallcomm/Help_1.csb")
	self:addChild(rootNode)
	local RuleList = rootNode:getChildByName("RuleList")
	local Text_1 = RuleList:getChildByName("Text_1")
	dump(Text_1:getString())--]]
	---[[
	
	
	--]]
end

function HelpData:show(id)
	if self._rootNode then
		self._rootNode:removeFromParent()
	end

	if id == 1 then --1 红中 2 斗地主 3 商丘麻将 4 飘癞子 5 推倒胡
		self._rootNode = cc.CSLoader:createNode("hallcomm/Help_3.csb")
	elseif id == 2 then--
		self._rootNode = cc.CSLoader:createNode("hallcomm/Help_4.csb")
	elseif id == 3 then
		self._rootNode = cc.CSLoader:createNode("hallcomm/Help_1.csb")
	elseif id == 4 then
		self._rootNode = cc.CSLoader:createNode("hallcomm/Help_5.csb")
	elseif id == 5 then
		self._rootNode = cc.CSLoader:createNode("hallcomm/Help_2.csb")
	end
	self:addChild(self._rootNode)

end

function HelpData:onEnter()   


end

function HelpData:onExit()

end


return HelpData