
local InitLayer = class("InitLayer", lt.BaseLayer, function()
    return cc.CSLoader:createNode("games/comm/launch/LaunchLayer.csb")
end)

function InitLayer:ctor()
    InitLayer.super.ctor(self)
    self._rootNode = self
    self._loginLayer = cc.CSLoader:createNode("games/comm/launch/LoginLayer.csb")
    self._rootNode:addChild(self._loginLayer)

    local Pl_Bg = self._loginLayer:getChildByName("Pl_Bg")
    self._bn_Rule = Pl_Bg:getChildByName("Bn_Rule")

    lt.CommonUtil:addNodeClickEvent(self._bn_Rule, handler(self, self.onRule))

    self._loginBtn = Pl_Bg:getChildByName("Bn_Login")

    self:RegisterWidgetEvent()
end

function InitLayer:onAndroidWechatLogin(call_back)

    lt.SDK.WechatDelegate.signIn(function(msg)
            data = json.decode(msg)
            dump(data,"FYD--->>>登陆")
            if data.action == "AUTH" then
            if data.result == "success" then
                local user_url = "https://api.weixin.qq.com/sns/userinfo?access_token=%s&openid=%s"
                user_url = string.format(user_url,data.access_token,data.openid) 
                lt.CommonUtil:sendXMLHTTPrequrest("GET",user_url,nil,function(recv_msg)
                    local temp = json.decode(recv_msg)
                    local body = {}
                    body.user_name = temp.nickname
                    body.user_pic = temp.headimgurl
                    body.account = data.openid
                    body.unionid = temp.unionid
                    body.password = data.access_token
                    body.login_type="release"
                    body.platform="weixin"
                    body.device_id = lt.SDK.Device.getDeviceId()
                    body.device_type = lt.SDK.Device.getDeviceType()
                    call_back(body)
                end) 
            else
                lt.PromptPanel:showPrompt("微信授权失败")
            end
        end 
        end)
end

function InitLayer:requestLogin(body)
    print("BODY 000>>>",json.encode(body))

    local url = string.format("http://%s:%d/login",lt.Constants.HOST,lt.Constants.PORT)
    lt.CommonUtil:sendXMLHTTPrequrest("POST",url,body,function(recv_msg) 
        print("玩家信息", recv_msg)
        self._logining = nil
            if recv_msg then
                recv_msg = json.decode(recv_msg)
                if recv_msg.result == "success" then
                    local user_id = recv_msg.user_id
                    local token = recv_msg.token
                    body = {user_id=user_id,token=token}

                    dump(body, "现在的token")

                    lt.DataManager:recordAuthData(body)
                    InitLayer:onGetUserInfo(body)
                else
                    lt.PromptPanel:showPrompt(lt.Constants.PROMPT[recv_msg.result])
                end
            end
        end)
end

function InitLayer:onLogin()

    if self._logining then
        return
    end

    self._logining = true

    if device.platform == "android" then
        self:onAndroidWechatLogin(function(body) 
                self:requestLogin(body)
            end)
    -- elseif device.platform == "ios" then

    else
        local index = math.random(1,99999)
        local account="FHQYDIDXIL"..index
        account = account
        local body = {  
                        account = account,password="123456",user_name="雀起"..index,user_pic="http://xxxx.png",
                        login_type="release",device_id="DDGEXXIKIGGESAE",device_type="MI274",platform="mengya"
                    }
        self:requestLogin(body)
    end
end

function InitLayer:onRule()
    local Initagreement = lt.Initagreement.new()
    self:addChild(Initagreement)
end

function InitLayer:onGetUserInfo(body)
    local url = string.format("http://%s:%d/operator/get_user_info",lt.Constants.HOST,lt.Constants.PORT)
    lt.CommonUtil:sendXMLHTTPrequrest("POST",url,body,function(recv_msg) 
            if recv_msg then
                recv_msg = json.decode(recv_msg)
                lt.DataManager:onPushUserInfo(recv_msg)
                local worldScene = lt.WorldScene.new()
                lt.SceneManager:replaceScene(worldScene)
                
            end
        end)
end

function InitLayer:RegisterWidgetEvent()
    lt.CommonUtil:addNodeClickEvent(self._loginBtn, handler(self, self.onLogin))
end

return InitLayer