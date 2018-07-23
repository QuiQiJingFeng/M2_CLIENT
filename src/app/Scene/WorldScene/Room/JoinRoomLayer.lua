
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
	local getLatitude = function(call_back)
        return call_back(json.encode({latitude=0,lontitude=0}))
    end
    if device.platform == "ios" or device.platform == "android" then
        getLatitude = lt.SDK.AppActivity.start
    end

    getLatitude(function(msg) --GPS
        print("FYD=====gps>>LUA ",msg)
        local result = json.decode(msg)
        --result.lontitude --经度
        --result.latitude -- 维度
        --result.addr --地址
        local url = string.format("http://%s:%d/operator/update_gps",lt.Constants.HOST,lt.Constants.PORT)
        local body = lt.DataManager:getAuthData()
        body.latitude = result.latitude -- 维度
        body.lontitude = result.lontitude --经度
        lt.CommonUtil:sendXMLHTTPrequrest("POST",url,body,function(recv_msg) 
        	recv_msg = json.decode(recv_msg)
            if recv_msg.result == "success" then
            	table.insert(self._numberArray, event:getTag())
				self:configRoomNum()
				if #self._numberArray == 6 then
					local roomNum = ""
					for i,v in ipairs(self._numberArray) do
						roomNum = roomNum..v
					end
					dump(roomNum, "roomNum")

					lt.CommonUtil:sepecailServerLogin(roomNum,function(result) 

						dump(result, "result")
			            if result ~= "success" then
			                print("connect failed")
			                return
			            end
			            local arg = {room_id = roomNum}--weixin
						lt.NetWork:sendTo(lt.GameEventManager.EVENT.JOIN_ROOM, arg)

						print("%%%%%%%%%%%%%%%%%%%%%%%%%%", tonumber(roomNum))
					end, function( result )
						dump(result, "ERRresult")
						local this = self
						this._numberArray = {}
						this:configRoomNum()				

						-- 没有此房间
						if result == "no_server_info" then
							lt.MsgboxLayer:showMsgBox(string.format("加入失败, 房间%d不存在", roomNum), true, function()
								-- this._numberArray = {}
								-- this:configRoomNum()				
					        end, function() end, true)

						-- 人数已满
						elseif result == "no_position" then
							lt.MsgboxLayer:showMsgBox(string.format("加入失败, 房间%d人数已满", roomNum), true, function()
					        end, function() end, true)
					    elseif result == "no_position" then
									    	
						end
					end)
				end
            end
        end)
    end)


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



function JoinRoomLayer:onEnter()   
    print("JoinRoomLayer:onEnter")
end

function JoinRoomLayer:onExit()
    print("JoinRoomLayer:onExit")
end

function JoinRoomLayer:onClose(event)
	lt.UILayerManager:removeLayer(self)
end

return JoinRoomLayer