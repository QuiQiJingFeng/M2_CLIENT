
local JoinRoomLayer = class("JoinRoomLayer", lt.BaseLayer, function()
    return cc.CSLoader:createNode("game/common/JoinRoomLayer.csb")
end)

function JoinRoomLayer:ctor()
	JoinRoomLayer.super.ctor(self)

	local Ie_Bg = self:getChildByName("Ie_Bg")

	local Ie_RoomNum = Ie_Bg:getChildByName("Ie_RoomNum")

	self._numberNodeArray = {}
	self._numberArray = {}
	for i=1,6 do
		local num = Ie_RoomNum:getChildByName("Ts_RoomNum"..i)
		table.insert(self._numberNodeArray, num)
	end

	for i=1,10 do
		local keyNum = Ie_Bg:getChildByName("Bn_Num"..i)
		keyNum:setTag(i - 1)
		lt.CommonUtil:addNodeClickEvent(keyNum, handler(self, self.onClickNumKey))
	end

	local closeBtn = Ie_Bg:getChildByName("Bn_Close")

	lt.CommonUtil:addNodeClickEvent(closeBtn, handler(self, self.onClose))
	self:configRoomNum()

	--删除 重输入
	local Bn_NumDelete = Ie_Bg:getChildByName("Bn_NumDelete")
	local Bn_NumReset = Ie_Bg:getChildByName("Bn_NumReset")
	lt.CommonUtil:addNodeClickEvent(Bn_NumDelete, handler(self, self.onClickDelete))
	lt.CommonUtil:addNodeClickEvent(Bn_NumReset, handler(self, self.onClickReset))

end

function JoinRoomLayer:onClickNumKey(event)
	if #self._numberArray >= 6 then
		return
	end
	table.insert(self._numberArray, event:getTag())
	self:configRoomNum()
	if #self._numberArray == 6 then
		local roomNum = ""
		for i,v in ipairs(self._numberArray) do
			roomNum = roomNum..v
		end
		print("%%%%%%%%%%%%%%%%%%%%%%%%%%", tonumber(roomNum))
	end
end

function JoinRoomLayer:configRoomNum()

	for i,numNode in ipairs(self._numberNodeArray) do
		if self._numberArray[i] then
			numNode:setString(self._numberArray[i])
		else
			numNode:setString("")
		end
	end
end

function JoinRoomLayer:onClickDelete(event)
	if #self._numberArray > 0 and #self._numberArray < 6 then
		table.remove(self._numberArray, #self._numberArray)
		self:configRoomNum()
	end
end

function JoinRoomLayer:onClickReset(event)
	if #self._numberArray > 0 and #self._numberArray < 6 then
		self._numberArray = {}
		self:configRoomNum()
	end
end

function JoinRoomLayer:onClose(event)
	lt.UILayerManager:removeLayer(self)
end

return JoinRoomLayer