local FzbLayer = class("FzbLayer", lt.BaseLayer,function()
    return cc.CSLoader:createNode("game/mjcomm/csb/base/GameFzbConfirm.csb")
end)

function FzbLayer:ctor(info)
	FzbLayer.super.ctor(self)
	local mainLayer = self:getChildByName("Ie_Bg")
	self._svContent = mainLayer:getChildByName("SV_Content")
	self._text_Clock = mainLayer:getChildByName("Text_Clock")--倒计时

	local Node_Button = mainLayer:getChildByName("Node_Button")
	local Bn_Sure = Node_Button:getChildByName("Bn_Sure") --确定加入
	local Bn_Cancel = Node_Button:getChildByName("Bn_Cancel")--离开
	for i=2,10 do
		local Image_IpSame = self._svContent:getChildByName("Image_IpSame_"..i)
		Image_IpSame:setVisible(false)
	end

	local Image_IpSame_1 = self._svContent:getChildByName("Image_IpSame_1")
	--3ren--Image_IpSame_1:setPosition(352.34,438.79)--312.34  408.79
	if #info == 3 then
		Image_IpSame_1:setPosition(352.34,438.79)
	elseif #info == 4 then
		Image_IpSame_1:setPosition((352.34+120),438.79)
	elseif #info == 2 then
		Image_IpSame_1:setPosition(312.34,438.79)
	end
	if #info == 2 then
		for i=1,#info do
			local playerNode = cc.CSLoader:createNode("game/mjcomm/csb/base/GameFzbHead.csb")
			if i == 1 then
				playerNode:setPosition(50,380)
			else
				playerNode:setPosition(170,380)
			end
			self._svContent:addChild(playerNode)
			local mainLayer = playerNode:getChildByName("Node_Player")
			local Text_Name = mainLayer:getChildByName("Text_Name")
			Text_Name:setString(info[i].user_name)
			--local Image_HeadBg = mainLayer:getChildByName("Image_HeadBg")
			--local Image_Head = Image_HeadBg:getChildByName("Image_Head")
		end
	else
		for i=1,#info do
			local playerNode = cc.CSLoader:createNode("game/mjcomm/csb/base/GameFzbHead.csb")
			if i == 1 then
				playerNode:setPosition(0,380)
			else
				playerNode:setPosition((i-1)*120,380)
			end
			self._svContent:addChild(playerNode)
			local mainLayer = playerNode:getChildByName("Node_Player")
			local Text_Name = mainLayer:getChildByName("Text_Name")
			Text_Name:setString(info[i].user_name)
			--local Image_HeadBg = mainLayer:getChildByName("Image_HeadBg")
			--local Image_Head = Image_HeadBg:getChildByName("Image_Head")
		end
	end
	--local playerNode = cc.CSLoader:createNode("game/mjcomm/csb/base/GameFzbHead.csb")

	lt.CommonUtil:addNodeClickEvent(Bn_Sure, handler(self, self.onSure))
	lt.CommonUtil:addNodeClickEvent(Bn_Cancel, handler(self, self.onCancel))
end

function FzbLayer:onSure(event)
	self:Close()
end

function FzbLayer:onCancel(event)
	lt.NetWork:sendTo(lt.GameEventManager.EVENT.LEAVE_ROOM)
end


function FzbLayer:Close()
	print("FYD====>>>CLOSE")
	lt.UILayerManager:removeLayer(self)
end

function FzbLayer:onBackLobbyResponse(msg)
	if msg.result == "success" then
    	local worldScene = lt.WorldScene.new()
        lt.SceneManager:replaceScene(worldScene)
    end
end

function FzbLayer:onEnter()
	print("==========================FzbLayer:onEnter======================================")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.LEAVE_ROOM, handler(self, self.onBackLobbyResponse), "FzbLayer.onBackLobbyResponse")
end

function FzbLayer:onExit()
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.LEAVE_ROOM, "FzbLayer.onBackLobbyResponse")
end

return FzbLayer