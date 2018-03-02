local user = require("logic.user")
local layer = class("login_layer",cc.Layer)

function layer:ctor()
	   local login_btn = ccui.Button:create("btn_0.png", "btn_1.png")
    login_btn:setTitleText("登陆")
    login_btn:setTitleFontSize(28)
    login_btn:addClickEventListener(function(sender)
            AppNet:connect("127.0.0.1",8888,function() 
                AppNet:send({["login"]={account="FYD",token="FYD",login_type="debug"}},function(msg)
                        if msg.result == "success" then
                            local user_id = msg.user_id
                            local reconnect_token = msg.reconnect_token
                            user:init(user_id,reconnect_token)
                            print("登陆成功  user_id="..user_id.." reconnect_token=",reconnect_token)

                            App.SceneManager:runScene("main_scene")
                        else
                            print("登陆失败")
                        end
                    end)
            end)
        end)
    login_btn:setPosition(display.cx,display.cy)
    self:addChild(login_btn)
end

return layer