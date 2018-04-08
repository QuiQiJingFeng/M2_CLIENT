
local InitLayer = class("InitLayer", lt.BaseLayer, function()
    return cc.CSLoader:createNode("games/comm/launch/LaunchLayer.csb")
end)

function InitLayer:ctor()
    InitLayer.super.ctor(self)
    self._rootNode = self
    self._loginLayer = cc.CSLoader:createNode("games/comm/launch/LoginLayer.csb")
    self._rootNode:addChild(self._loginLayer)

    local Pl_Bg = self._loginLayer:getChildByName("Pl_Bg")
    self._loginBtn = Pl_Bg:getChildByName("Bn_Login")

    self:RegisterWidgetEvent()
end

function InitLayer:onLogin()
    local body = {  
                    account="FHQYDIDXIL1",password="123456",user_name="惊风",user_pic="http://xxxx.png",
                    login_type="release",device_id="DDGEXXIKIGGESAE",device_type="MI274",platform="weixin"
                }
    lt.CommonUtil:sendXMLHTTPrequrest("POST","http://127.0.0.1:3000/login",body,function(recv_msg) 

            if recv_msg then
                recv_msg = json.decode(recv_msg)
                if recv_msg.result == "success" then
                    local user_id = recv_msg.user_id
                    local token = recv_msg.token
                    lt.DataManager:recordToken(token)
                    body = {user_id=user_id,token=token}
                    self:onGetUserInfo(body)
                end
            end
        end)

end

function InitLayer:onGetUserInfo(body)
    lt.CommonUtil:sendXMLHTTPrequrest("POST","http://127.0.0.1:3000/operator/get_user_info",body,function(recv_msg) 
            if recv_msg then
                recv_msg = json.decode(recv_msg)
                local worldScene = lt.WorldScene.new()
                lt.SceneManager:replaceScene(worldScene)
                lt.DataManager:onPushUserInfo(recv_msg)
            end
        end)
end

function InitLayer:RegisterWidgetEvent()
    lt.CommonUtil:addNodeClickEvent(self._loginBtn, handler(self, self.onLogin))
end

return InitLayer