local AuthenticationLayer = class("AuthenticationLayer", lt.BaseLayer,function()
    return cc.CSLoader:createNode("hallcomm/common/Authentication.csb")
end)

function AuthenticationLayer:ctor(info, deleget)
	AuthenticationLayer.super.ctor(self)
	local mainLayer = self:getChildByName("Ie_Bg")
	local mainNode = mainLayer:getChildByName("Ie_WebBg")
	self._name_input = mainNode:getChildByName("name_input")--名字
	self._name_input:setTextColor(cc.c3b(12, 12, 12))

	self._sehnfen_input = mainNode:getChildByName("sehnfen_input")--身份证号
	self._sehnfen_input:setTextColor(cc.c3b(12, 12, 12))

	self._shouji_input = mainNode:getChildByName("shouji_input")--手机号
	self._shouji_input:setTextColor(cc.c3b(12, 12, 12))

	self._yanzheng_input = mainNode:getChildByName("yanzheng_input")--验证码
	self._yanzheng_input:setTextColor(cc.c3b(12, 12, 12))

	local Button_dx = mainNode:getChildByName("Button_dx")--获取验证码
	local Button_sure = mainNode:getChildByName("Button_sure")--获取验证码

	local backBtn = mainLayer:getChildByName("ButtonClose1")
	lt.CommonUtil:addNodeClickEvent(backBtn, handler(self, self.Close))
	lt.CommonUtil:addNodeClickEvent(Button_dx, handler(self, self.Result))
	lt.CommonUtil:addNodeClickEvent(Button_sure, handler(self, self.onSure))
end

function AuthenticationLayer:onSure(event)
	local name_Text = self._name_input:getString()
	local sehnfen_Text = self._sehnfen_input:getString()
	local shouji_Text = self._shouji_input:getString()
	local yanzheng_Text = self._yanzheng_input:getString()
	if name_Text then
		if string.len(shouji_Text) == 11 and type(tonumber(shouji_Text)) == "number" then
			if string.len(sehnfen_Text) == 18 then--and type(tonumber(sehnfen_Text)) == "number" then
				if string.len(yanzheng_Text) == 6 and type(tonumber(yanzheng_Text)) == "number" then
					-- 绑定手机号  invilid_code / success / internal_error
				    local url = string.format("http://%s:%d/operator/check_phone",lt.Constants.HOST,lt.Constants.PORT)
				    local body = lt.DataManager:getAuthData()
				    body.phone = shouji_Text
				    body.code = tonumber(yanzheng_Text)
				    body.id_number = sehnfen_Text
				    body.user_name = name_Text
				    lt.CommonUtil:sendXMLHTTPrequrest("POST",url,body,function(recv_msg) 
				           dump(recv_msg,"FYD====认证结果============>>>>")
				           local msg = json.decode(recv_msg)
				           if msg.result == "success" then
				           		lt.MsgboxLayer:showMsgBox("认证成功", false,function() end, function() end, true, 15)
				           else
				           		lt.MsgboxLayer:showMsgBox("认证失败，请正确填写信息!", false,function() end, function()  end, true, 15)
				           		self._name_input:setText(nil)
								self._sehnfen_input:setText(nil)
								self._shouji_input:setText(nil)
								self._yanzheng_input:setText(nil)
				           end
				    end)
				else
					lt.MsgboxLayer:showMsgBox("请输入正确的验证码", false,function()   end, function()  end, true, 15)
				end
			else
				lt.MsgboxLayer:showMsgBox("请输入正确的身份证号", false,function()   end, function()  end, true, 15)
			end
		else
			lt.MsgboxLayer:showMsgBox("请输入正确的手机号", false,function()  end, function()  end, true, 15)
		end
	end

end

function AuthenticationLayer:Result(event)
	local shouji_Text = self._shouji_input:getString()
	if string.len(shouji_Text) == 11 and type(tonumber(shouji_Text)) == "number" then  
		--获取验证码
		local url = string.format("http://%s:%d/operator/bind_phone",lt.Constants.HOST,lt.Constants.PORT)
	    local body = lt.DataManager:getAuthData()
	    body.phone = shouji_Text
	    lt.CommonUtil:sendXMLHTTPrequrest("POST",url,body,function(recv_msg) 
	       lt.MsgboxLayer:showMsgBox("发送成功", false,function()  print("===1===")  end, function()  print("===2===") end, true, 15)
	    end)
	else
		lt.MsgboxLayer:showMsgBox("请输入正确的手机号", false,function()  print("===1===")  end, function()  print("===2===") end, true, 15)
	end

end

function AuthenticationLayer:Close(event)
	lt.UILayerManager:removeLayer(self)
end

function AuthenticationLayer:onEnter()
	print("==========================AuthenticationLayer:onEnter======================================")
end

function AuthenticationLayer:onExit()

end

return AuthenticationLayer