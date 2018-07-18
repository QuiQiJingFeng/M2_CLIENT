local FzbLayer = class("FzbLayer", lt.BaseLayer,function()
    return cc.CSLoader:createNode("game/mjcomm/csb/base/GameFzbConfirm.csb")
end)

function FzbLayer:ctor(info,msg,deleget)
	FzbLayer.super.ctor(self)
	self._deleget = deleget

	local offsetY = 0
	--#msg 最多6个
	if #msg > 2 then
		local a = #msg - 2 
		offsetY = 180*a
	end

	local mainLayer = self:getChildByName("Ie_Bg")
	self._svContent = mainLayer:getChildByName("SV_Content")
	self._text_Clock = mainLayer:getChildByName("Text_Clock")--倒计时

	local Node_Button = mainLayer:getChildByName("Node_Button")
	local Bn_Sure = Node_Button:getChildByName("Bn_Sure") --确定加入
	local Bn_Cancel = Node_Button:getChildByName("Bn_Cancel")--离开

	--IP
	for i=2,10 do
		local Image_IpSame = self._svContent:getChildByName("Image_IpSame_"..i)
		Image_IpSame:setVisible(false)
	end

	local Image_IpSame_1 = self._svContent:getChildByName("Image_IpSame_1")
	if #info == 0 then
		Image_IpSame_1:setVisible(false)
	end

	--3ren--Image_IpSame_1:setPosition(352.34,438.79)--312.34  408.79
	if #info == 3 then
		Image_IpSame_1:setPosition(352.34,438.79+offsetY)
	elseif #info == 4 then
		Image_IpSame_1:setPosition((352.34+120),438.79+offsetY)
	elseif #info == 2 then
		Image_IpSame_1:setPosition(312.34,438.79+offsetY)
	end
	if #info == 2 then
		for i=1,#info do
			local playerNode = cc.CSLoader:createNode("game/mjcomm/csb/base/GameFzbHead.csb")
			if i == 1 then
				playerNode:setPosition(50,380+offsetY)
			else
				playerNode:setPosition(170,380+offsetY)
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
				playerNode:setPosition(0,380+offsetY)
			else
				playerNode:setPosition((i-1)*120,380+offsetY)
			end
			self._svContent:addChild(playerNode)
			local mainLayer = playerNode:getChildByName("Node_Player")
			local Text_Name = mainLayer:getChildByName("Text_Name")
			Text_Name:setString(info[i].user_name)
			--local Image_HeadBg = mainLayer:getChildByName("Image_HeadBg")
			--local Image_Head = Image_HeadBg:getChildByName("Image_Head")
		end
	end

	local GPSposY = {200,20,-160,-340,-520,-700}
	local GPSNodeposY = {}
	if #msg == 4 then
		 GPSNodeposY = {605,425,245,65}
	elseif #msg == 3 then
		 GPSNodeposY = {425,245,65}
	elseif #msg == 2 then
		 GPSNodeposY = {245,65}
	elseif #msg == 1 then
		 GPSNodeposY = {245}
	elseif #msg == 5 then
		 GPSNodeposY = {785,605,425,245,65}
	elseif #msg == 6 then
		 GPSNodeposY = {965,785,605,425,245,65}
	end
	--GPS
	for i=1,10 do
		local Image_LocSame = self._svContent:getChildByName("Image_LocSame_"..i)
		Image_LocSame:setVisible(false)
	end

	self._svContent:setInnerContainerSize(cc.size(1029,537+offsetY))--2 537
	for i=1,#msg do
		local Image_LocSame = self._svContent:getChildByName("Image_LocSame_"..i)
		local Text_LocSame = Image_LocSame:getChildByName("Text_LocSame")
		Image_LocSame:setPosition(Image_LocSame:getPositionX(),GPSNodeposY[i])--Image_LocSame:getPositionY())
		Image_LocSame:setVisible(true)
		for j=1,2 do
			---[[
			local intNum = math.ceil(msg[i][3])
			if intNum >= 1000 then
				local intNum = intNum/1000
				Text_LocSame:setString("相距小于"..intNum.."公里")
			else
				Text_LocSame:setString("相距小于"..intNum.."米")
			end--]]
			local playerNode = cc.CSLoader:createNode("game/mjcomm/csb/base/GameFzbHead.csb")
			if j == 1 then
				playerNode:setPosition(50,GPSposY[i]+offsetY)
			else
				playerNode:setPosition(170,GPSposY[i]+offsetY)
			end
			self._svContent:addChild(playerNode)
			local mainLayer = playerNode:getChildByName("Node_Player")
			local Text_Name = mainLayer:getChildByName("Text_Name")
			Text_Name:setString(msg[i][j].user_name)
		end
	end


	lt.CommonUtil:addNodeClickEvent(Bn_Sure, handler(self, self.onSure))
	lt.CommonUtil:addNodeClickEvent(Bn_Cancel, handler(self, self.onCancel))
end

function FzbLayer:onSure(event)
	self:Close()
end

function FzbLayer:onCancel(event)
	print("FzbLayer:onCancel(event)==>LEAVE_ROOM")
	lt.NetWork:sendTo(lt.GameEventManager.EVENT.LEAVE_ROOM)
end

function FzbLayer:Close()
	print("FYD====>>>CLOSE")
	self._deleget:closeFzbLayer()
end

function FzbLayer:onEnter()
	print("==========================FzbLayer:onEnter======================================")

end

function FzbLayer:onExit()

end

return FzbLayer