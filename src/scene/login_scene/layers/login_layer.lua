local layer = class("login_layer",cc.Layer)

function layer:ctor()
	local title = cc.Label:createWithSystemFont("ZZ登陆系统","Aria",32)
	title:setPosition(display.cx,display.cy*2-100)
	self:addChild(title)

	local account = cc.Label:createWithSystemFont("账户","Aria",20)
	local password = cc.Label:createWithSystemFont("密码","Aria",20)
	account:setPosition(200,display.cy*2-200)
	password:setPosition(200,display.cy*2-250)
	self:addChild(account)
	self:addChild(password)

	local edit_account = cc.EditBox:create(cc.size(200,50), cc.Scale9Sprite:create("btn_test.png"))
	local edit_password = cc.EditBox:create(cc.size(200,50), cc.Scale9Sprite:create("btn_test.png"))
	edit_account:setPosition(350,display.cy*2-200)
	edit_password:setPosition(350,display.cy*2-250)
	self:addChild(edit_account)
	self:addChild(edit_password)

	local register_btn = ccui.Button:create("btn_0.png", "btn_1.png")
    register_btn:setTitleText("注册")
    register_btn:setTitleFontSize(28)
    register_btn:setPosition(250,display.cy*2 - 350)
    register_btn:addClickEventListener(function(sender)
            local xhr = cc.XMLHttpRequest:new()
            xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
            xhr:open("POST", "http://127.0.0.1:3000/register")

            local function onReadyStateChanged()
                if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
                    local response = xhr.response
                    print('FYD++++FYD = ',response)
                else
                    print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
                end
                xhr:unregisterScriptHandler()
            end

            xhr:registerScriptHandler(onReadyStateChanged)
            xhr:send("account="..edit_account:getText().."&".."password="..edit_password:getText())
    end)
    self:addChild(register_btn)

	local login_btn = ccui.Button:create("btn_0.png", "btn_1.png")
    login_btn:setTitleText("登陆")
    login_btn:setTitleFontSize(28)
    login_btn:setPosition(400,display.cy*2 - 350)
    login_btn:addClickEventListener(function(sender)
        print("FYD+++++++登陆")
        self.scene.logic_login:connect()
    end)
    self:addChild(login_btn)
end

return layer