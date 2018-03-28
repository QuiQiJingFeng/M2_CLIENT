
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
		local arg = {room_id = roomNum}--weixin
		lt.NetWork:sendTo(lt.GameEventManager.EVENT.JOIN_ROOM, arg)

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

function JoinRoomLayer:onjoinRoomResponse(msg)
	
	print("__________________________", msg.result)
	dump(msg, "msg")
    if msg.result == "success" then
    	print("加入房间")

    	local gameInfo = lt.DataManager:getGameRoomInfo()

    	dump(gameInfo, "gameInfo")
    	local gameid = 1

    	if gameInfo and gameInfo.room_setting and gameInfo.room_setting.game_type then
    		gameid = gameInfo.room_setting.game_type
    	end

    	if gameid == 1 then --红中麻将
			local gameScene = lt.GameScene.new()
	        lt.SceneManager:replaceScene(gameScene)
    	elseif gameid == 2 then --斗地主
    		local gameScene = lt.DDZGameScene.new()
	        lt.SceneManager:replaceScene(gameScene)
    	end		

    else
        print("加入房间失败")
    end
end

function JoinRoomLayer:onEnter()   
    print("JoinRoomLayer:onEnter")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.JOIN_ROOM, handler(self, self.onjoinRoomResponse), "JoinRoomLayer:onjoinRoomResponse")
end

function JoinRoomLayer:onExit()
    print("JoinRoomLayer:onExit")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.JOIN_ROOM, "JoinRoomLayer:onjoinRoomResponse")
end

function JoinRoomLayer:onClose(event)
	lt.UILayerManager:removeLayer(self)
end

return JoinRoomLayer