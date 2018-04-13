
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
    local index = math.random(1,99999)
    local account="FHQYDIDXIL"..index

    account = account
    local body = {  
                    account = account,password="123456",user_name="雀起"..index,user_pic="http://xxxx.png",
                    login_type="release",device_id="DDGEXXIKIGGESAE",device_type="MI274",platform="weixin"
                }
    local url = string.format("http://%s:%d/login",lt.Constants.HOST,lt.Constants.PORT)
    lt.CommonUtil:sendXMLHTTPrequrest("POST",url,body,function(recv_msg) 
            if recv_msg then
                recv_msg = json.decode(recv_msg)
                if recv_msg.result == "success" then
                    local user_id = recv_msg.user_id
                    local token = recv_msg.token
                    body = {user_id=user_id,token=token}
                    lt.DataManager:recordAuthData(body)
                    self:onGetUserInfo(body)
                end
            end
        end)
end

function InitLayer:onGetUserInfo(body)
    local url = string.format("http://%s:%d/operator/get_user_info",lt.Constants.HOST,lt.Constants.PORT)
    lt.CommonUtil:sendXMLHTTPrequrest("POST",url,body,function(recv_msg) 
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