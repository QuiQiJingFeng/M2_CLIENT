
-- 登陆账号
local LoginPanel = class("LoginPanel", function()
	return display.newLayer()
end)

LoginPanel._winScale = lt.CacheManager:getWinScale()
LoginPanel._size = cc.size(524, 580)
LoginPanel._loginLayer = nil

LoginPanel._inputBox1 = nil
LoginPanel._inputBox2 = nil

function LoginPanel:ctor(loginLayer)
	self._loginLayer = loginLayer
    self:setNodeEventEnabled(true)

	self._bg = lt.GamePanel.new(lt.GamePanel.TYPE.NEW_BLACK, display.cx, display.cy, self._size)
	self._bg:setScale(self._winScale)
    self:addChild(self._bg, 10)

    local close = lt.ScaleButton.new("#start_btn_back.png", {scale = self._winScale})
    close:setPosition(64, self._bg:getContentSize().height - 68)
    close:onButtonClicked(handler(self, self.onClose))
    self._bg:addChild(close, 100)

    local paddingWidth  = 18
    local paddingHeight = 21

    local inputBg1 = display.newScale9Sprite("#start_p_gray.png", self._bg:getContentSize().width / 2, self._bg:getContentSize().height / 2 + 95, cc.size(448, 64))
    self._bg:addChild(inputBg1)

    self._inputBox1 = lt.GameInput.new({
		image = display.newScale9Sprite(),
        size = cc.size(408, 32),
        x = inputBg1:getContentSize().width / 2,
        y = inputBg1:getContentSize().height / 2,
        warningTips = true,
        warningStr = lt.StringManager:getString("STRING_SELECT_HAS_WARNING_STR")
    })
    self._inputBox1:setMaxLength(16)
    self._inputBox1:setFont(lt.Constants.FONT, 20)
    self._inputBox1:setFontColor(lt.Constants.DEFAULT_LABEL_COLOR_2)
    self._inputBox1:setPlaceHolder(lt.StringManager:getString("STRING_START_1"))
    self._inputBox1:setPlaceholderFont(lt.Constants.FONT, 20)
    self._inputBox1:setPlaceholderFontColor(lt.Constants.DEFAULT_LABEL_COLOR_2)
    self._inputBox1:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    inputBg1:addChild(self._inputBox1)

    local inputBg2 = display.newScale9Sprite("#start_p_gray.png", self._bg:getContentSize().width / 2, self._bg:getContentSize().height / 2, cc.size(448, 64))
    self._bg:addChild(inputBg2)

    self._inputBox2 = lt.GameInput.new({
		image = display.newScale9Sprite(),
        size = cc.size(408, 32),
        x = inputBg2:getContentSize().width / 2,
        y = inputBg2:getContentSize().height / 2
    })
    self._inputBox2:setMaxLength(16)
    self._inputBox2:setFont(lt.Constants.FONT, 20)
    self._inputBox2:setFontColor(lt.Constants.DEFAULT_LABEL_COLOR_2)
    self._inputBox2:setPlaceHolder(lt.StringManager:getString("STRING_START_2"))
    self._inputBox2:setPlaceholderFont(lt.Constants.FONT, 20)
    self._inputBox2:setPlaceholderFontColor(lt.Constants.DEFAULT_LABEL_COLOR_2)
    self._inputBox2:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    self._inputBox2:setInputMode(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    -- self._inputBox2:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    inputBg2:addChild(self._inputBox2)

    local loginBtn = lt.PushButton.new("#start_p_green.png", {scale9 = true})
    loginBtn:setButtonSize(448, 64)
    loginBtn:setPosition(self._bg:getContentSize().width / 2, self._bg:getContentSize().height / 2 - 95)
    loginBtn:onButtonClicked(handler(self, self.onLogin))
    self._bg:addChild(loginBtn)

    local login = lt.GameLabel.newString("STRING_START_LOGIN", 30)
    login:setPosition(loginBtn:getContentSize().width / 2, loginBtn:getContentSize().height / 2)
    loginBtn:addChild(login)
end

function LoginPanel:visible(bVisible)
	self:setVisible(bVisible)
	self._inputBox1:setVisible(bVisible)
	self._inputBox2:setVisible(bVisible)
end

function LoginPanel:onClose()
	self:visible(false)

	self._loginLayer:setVisible(true)
end

function LoginPanel:onLogin()
	local loginName = self._inputBox1:getText()
	local password = self._inputBox2:getText()

	if loginName == "" or password == "" then
		lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_START_3"))
		return
	end

	local find1 = string.find(loginName, "[^a-zA-Z0-9_]")
	local find2 = string.find(password, "[^a-zA-Z0-9_]")

	if find1 or find2 then
		lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_START_4"))
		return
	end

	local len1 = string.len(loginName)
	if len1 < 6 or len1 > 16 then
		lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_START_5"))
		return
	end
	local len2 = string.len(password)
	if len2 < 6 or len2 > 16 then
		lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_START_6"))
		return
	end

	-- 发送
	lt.HttpApi:login(loginName, password, handler(self, self.onLoginSuccess), handler(self, self.onLoginFail))
end

function LoginPanel:onLoginSuccess(responseJson)
	local response = json.decode(responseJson)

	local status = response.status or -1
	if checknumber(status) == 0 then
		-- 注册成功
		lt.CommonUtil.print("LoginSuccess")

		-- 记录到本地
		local loginName = self._inputBox1:getText()
		local password = self._inputBox2:getText()
		lt.PreferenceManager:setLoginInfo(loginName, password)

		local data = response.data

		local uid = data.uid
		local token = data.token

		self:visible(false)
		self._loginLayer:onToken(token)
	else
		lt.CommonUtil.print("LoginSuccessError", status)
		local desc = response.desc or ""
		lt.TipsLayer:tipsOn(desc)
	end
end

function LoginPanel:onLoginFail(code)
	lt.CommonUtil.print("LoginPanel:onLoginFail", code)

	if network.isInternetConnectionAvailable() then
		-- 无网络
        lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_LOGIN_FAIL"))
	else
		-- 无网络
        lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_ERROR_NETWORK_NO"))
	end
end

-- 注册账号
local RegisterPanel = class("RegisterPanel", function()
	return display.newLayer()
end)

RegisterPanel._winScale = lt.CacheManager:getWinScale()
RegisterPanel._size = cc.size(524, 580)
RegisterPanel._loginLayer = nil

RegisterPanel._inputBox1 = nil
RegisterPanel._inputBox2 = nil

function RegisterPanel:ctor(loginLayer)
	self._loginLayer = loginLayer
    self:setNodeEventEnabled(true)

	self._bg = lt.GamePanel.new(lt.GamePanel.TYPE.NEW_BLACK, display.cx, display.cy, self._size)
	self._bg:setScale(self._winScale)
    self:addChild(self._bg, 10)

    local close = lt.ScaleButton.new("#start_btn_back.png", {scale = self._winScale})
    close:setPosition(64, self._bg:getContentSize().height - 68)
    close:onButtonClicked(handler(self, self.onClose))
    self._bg:addChild(close, 100)

    local paddingWidth  = 18
    local paddingHeight = 21

    local inputBg1 = display.newScale9Sprite("#start_p_gray.png", self._bg:getContentSize().width / 2, self._bg:getContentSize().height / 2 + 95, cc.size(448, 64))
    self._bg:addChild(inputBg1)

    self._inputBox1 = lt.GameInput.new({
		image = display.newScale9Sprite(),
        size = cc.size(408, 32),
        x = inputBg1:getContentSize().width / 2,
        y = inputBg1:getContentSize().height / 2,
        warningTips = true,
        warningStr = lt.StringManager:getString("STRING_SELECT_HAS_WARNING_STR")
    })
    self._inputBox1:setMaxLength(16)
    self._inputBox1:setFont(lt.Constants.FONT, 20)
    self._inputBox1:setFontColor(lt.Constants.DEFAULT_LABEL_COLOR_2)
    self._inputBox1:setPlaceHolder(lt.StringManager:getString("STRING_START_1"))
    self._inputBox1:setPlaceholderFont(lt.Constants.FONT, 20)
    self._inputBox1:setPlaceholderFontColor(lt.Constants.DEFAULT_LABEL_COLOR_2)
    self._inputBox1:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    inputBg1:addChild(self._inputBox1)

    local inputBg2 = display.newScale9Sprite("#start_p_gray.png", self._bg:getContentSize().width / 2, self._bg:getContentSize().height / 2, cc.size(448, 64))
    self._bg:addChild(inputBg2)

    self._inputBox2 = lt.GameInput.new({
		image = display.newScale9Sprite(),
        size = cc.size(408, 32),
        x = inputBg2:getContentSize().width / 2,
        y = inputBg2:getContentSize().height / 2
    })
    self._inputBox2:setMaxLength(16)
    self._inputBox2:setFont(lt.Constants.FONT, 20)
    self._inputBox2:setFontColor(lt.Constants.DEFAULT_LABEL_COLOR_2)
    self._inputBox2:setPlaceHolder(lt.StringManager:getString("STRING_START_2"))
    self._inputBox2:setPlaceholderFont(lt.Constants.FONT, 20)
    self._inputBox2:setPlaceholderFontColor(lt.Constants.DEFAULT_LABEL_COLOR_2)
    self._inputBox2:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    self._inputBox2:setInputMode(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    -- self._inputBox2:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    inputBg2:addChild(self._inputBox2)

    local registerBtn = lt.PushButton.new("#start_p_blue.png", {scale9 = true})
    registerBtn:setButtonSize(448, 64)
    registerBtn:setPosition(self._bg:getContentSize().width / 2, self._bg:getContentSize().height / 2 - 95)
    registerBtn:onButtonClicked(handler(self, self.onRegister))
    self._bg:addChild(registerBtn)

    local register = lt.GameLabel.newString("STRING_START_REGISTER", 30)
    register:setPosition(registerBtn:getContentSize().width / 2, registerBtn:getContentSize().height / 2)
    registerBtn:addChild(register)
end

function RegisterPanel:visible(bVisible)
	self:setVisible(bVisible)
	self._inputBox1:setVisible(bVisible)
	self._inputBox2:setVisible(bVisible)
end

function RegisterPanel:onClose()
	self:visible(false)

	self._loginLayer:setVisible(true)
end

function RegisterPanel:onRegister()
	local loginName = self._inputBox1:getText()
	local password = self._inputBox2:getText()

	if loginName == "" or password == "" then
		lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_START_3"))
		return
	end

	local find1 = string.find(loginName, "[^a-zA-Z0-9_]")
	local find2 = string.find(password, "[^a-zA-Z0-9_]")

	if find1 or find2 then
		lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_START_4"))
		return
	end

	local len1 = string.len(loginName)
	if len1 < 6 or len1 > 16 then
		lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_START_5"))
		return
	end
	local len2 = string.len(password)
	if len2 < 6 or len2 > 16 then
		lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_START_6"))
		return
	end

	-- 发送
	lt.HttpApi:register(loginName, password, handler(self, self.onRegisterSuccess), handler(self, self.onRegisterFail))
end

function RegisterPanel:onRegisterSuccess(responseJson)
	dump(responseJson, "responseJson")
	local response = json.decode(responseJson)

	local status = response.status or -1
	if checknumber(status) == 0 then
		-- 注册成功
		lt.CommonUtil.print("RegisterSuccess")

		-- 记录到本地
		local loginName = self._inputBox1:getText()
		local password = self._inputBox2:getText()
		lt.PreferenceManager:setLoginInfo(loginName, password)

		local data = response.data

		local uid = data.uid
		local token = data.token

		self:visible(false)
		self._loginLayer:onToken(token)
	else
		lt.CommonUtil.print("RegisterSuccessError", status)
		local desc = response.desc or ""
		lt.TipsLayer:tipsOn(desc)
	end
end

function RegisterPanel:onRegisterFail(code)
	lt.CommonUtil.print("RegisterPanel:onRegisterFail", code)

	if network.isInternetConnectionAvailable() then
		-- 无网络
        lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_REGISTER_FAIL"))
	else
		-- 无网络
        lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_ERROR_NETWORK_NO"))
	end
end

-- 登陆主页
local LoginLayer = class("LoginLayer", lt.ActivateLayer)

LoginLayer._winScale = lt.CacheManager:getWinScale()
LoginLayer._size = cc.size(524, 580)

LoginLayer._startLayer = nil
LoginLayer._loginName = nil
LoginLayer._password = nil

LoginLayer._userInfo = nil
LoginLayer._userLabel = nil
LoginLayer._loginBtn = nil
LoginLayer._registerBtn = nil

LoginLayer._loginPanel = nil
LoginLayer._registerPanel = nil

function LoginLayer:ctor(level, startLayer)
	self._startLayer = startLayer

	self.super.ctor(self, level, {noMask = 1})
    self:setNodeEventEnabled(true)
    self:setBaseScale(self._winScale)

	self._bg = lt.GamePanel.new(lt.GamePanel.TYPE.NEW_BLACK, display.cx, display.cy, self._size)
    self._bg:setScale(0)
    self:addChild(self._bg, 10)

    local close = lt.ScaleButton.new("#start_btn_back.png", {scale = self._winScale})
    close:setPosition(64, self._bg:getContentSize().height - 68)
    close:onButtonClicked(handler(self, self.onClose))
    self:addInfoChild(close, 100)

    local paddingWidth  = 18
    local paddingHeight = 21

    self._userInfo = lt.PushButton.new("#start_p_gray.png", {scale9 = true})
    self._userInfo:setButtonSize(448, 64)
    self._userInfo:setPosition(self._bg:getContentSize().width / 2, self._bg:getContentSize().height / 2 + 95)
    self._userInfo:onButtonClicked(handler(self, self.onLogout))
    self._bg:addChild(self._userInfo)

    self._userLabel = lt.GameLabel.new("", 30)
    self._userLabel:setPosition(self._userInfo:getContentSize().width / 2, self._userInfo:getContentSize().height / 2)
    self._userInfo:addChild(self._userLabel)

    self._loginBtn = lt.PushButton.new("#start_p_green.png", {scale9 = true})
    self._loginBtn:setButtonSize(448, 64)
    self._loginBtn:setPosition(self._bg:getContentSize().width / 2, self._bg:getContentSize().height / 2)
    self._loginBtn:onButtonClicked(handler(self, self.onLogin))
    self._bg:addChild(self._loginBtn)

    local login = lt.GameLabel.newString("STRING_START_LOGIN", 30)
    login:setPosition(self._loginBtn:getContentSize().width / 2, self._loginBtn:getContentSize().height / 2)
    self._loginBtn:addChild(login)

    self._registerBtn = lt.PushButton.new("#start_p_blue.png", {scale9 = true})
    self._registerBtn:setButtonSize(448, 64)
    self._registerBtn:setPosition(self._bg:getContentSize().width / 2, self._bg:getContentSize().height / 2 - 95)
    self._registerBtn:onButtonClicked(handler(self, self.onRegister))
    self._bg:addChild(self._registerBtn)

    local register = lt.GameLabel.newString("STRING_START_REGISTER", 30)
    register:setPosition(self._registerBtn:getContentSize().width / 2, self._registerBtn:getContentSize().height / 2)
    self._registerBtn:addChild(register)

    if device.platform == "mac" then
	    -- 开发人员用
	    local auto1 = lt.ScaleLabelButton.newSmallBlue("T1")
	    auto1:setPosition(self._bg:getContentSize().width / 2 - 180, 60)
	    auto1:onButtonClicked(function()
	    	lt.HttpApi:login("zwjnnew1", "111111", handler(self, self.onDefaultLoginSuccess), handler(self, self.onDefaultLoginFail))
	    end)
	    self._bg:addChild(auto1)

	    local auto2 = lt.ScaleLabelButton.newSmallBlue("T2")
	    auto2:setPosition(self._bg:getContentSize().width / 2 - 60, 60)
	    auto2:onButtonClicked(function()
	    	lt.HttpApi:login("zwjnnew2", "111111", handler(self, self.onDefaultLoginSuccess), handler(self, self.onDefaultLoginFail))
	    end)
	    self._bg:addChild(auto2)

	    local auto3 = lt.ScaleLabelButton.newSmallBlue("T3")
	    auto3:setPosition(self._bg:getContentSize().width / 2 + 60, 60)
	    auto3:onButtonClicked(function()
	    	lt.HttpApi:login("zwjnew3", "111111", handler(self, self.onDefaultLoginSuccess), handler(self, self.onDefaultLoginFail))
	    end)
	    self._bg:addChild(auto3)

	    local auto3 = lt.ScaleLabelButton.newSmallBlue("T4")
	    auto3:setPosition(self._bg:getContentSize().width / 2 + 180, 60)
	    auto3:onButtonClicked(function()
	    	lt.HttpApi:login("zwjnew4", "111111", handler(self, self.onDefaultLoginSuccess), handler(self, self.onDefaultLoginFail))
	    end)
	    self._bg:addChild(auto3)
    end
end

function LoginLayer:activateBegin()
	-- 判断是否已有用户
	local loginName, password = lt.PreferenceManager:getLoginInfo()
	if loginName ~= "" and password ~= "" then
		self._loginName = loginName
		self._password = password

		self._userInfo:setVisible(true)
		self._userLabel:setString(self._loginName)
	else
		self._loginName = nil
		self._password = nil

		self._userInfo:setVisible(false)
	end
end

function LoginLayer:onLogout()
	self._loginName = nil
	self._password = nil

	self._userInfo:setVisible(false)
end

function LoginLayer:onLogin()
	if not self._loginName or not self._password then
		-- 弹出登陆页面
		self:setVisible(false)
		self:getLoginPanel():visible(true)
		return
	end

	-- 发送
	lt.HttpApi:login(self._loginName, self._password, handler(self, self.onDefaultLoginSuccess), handler(self, self.onDefaultLoginFail))
end

function LoginLayer:onDefaultLoginSuccess(responseJson)
	local response = json.decode(responseJson)

	local status = response.status or -1
	if checknumber(status) == 0 then
		-- 注册成功
		lt.CommonUtil.print("DefaultLoginSuccess")


		local data = response.data

		local uid = data.uid
		local token = data.token

		self:setVisible(false)
		self:onToken(token)
	else
		lt.CommonUtil.print("LoginSuccessError", status, response.desc)
		
		-- 注销这个账号
		lt.PreferenceManager:setLoginInfo("", "")

		self._loginName = nil
		self._password = nil

		self._userInfo:setVisible(false)
	end
end

function LoginLayer:onDefaultLoginFail(code)
	lt.CommonUtil.print("LoginPanel:onDefaultLoginFail", code)

	if network.isInternetConnectionAvailable() then
		-- 无网络
        lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_LOGIN_FAIL"))
	else
		-- 无网络
        lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_ERROR_NETWORK_NO"))
	end
end

function LoginLayer:onRegister()
	-- 弹出注册
	self:setVisible(false)
	self:getRegisterPanel():visible(true)
end

function LoginLayer:onToken(token)
	self._startLayer:login(token)
end

function LoginLayer:getLoginPanel()
	if not self._loginPanel then
		self._loginPanel = LoginPanel.new(self)
        display.getRunningScene():addChild(self._loginPanel)
	end

	return self._loginPanel
end

function LoginLayer:getRegisterPanel()
	if not self._registerPanel then
		self._registerPanel = RegisterPanel.new(self)
        display.getRunningScene():addChild(self._registerPanel, 520)
	end

	return self._registerPanel
end

return LoginLayer
