
local SettingLayer = class("SettingLayer", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/gwidget/GameSetLayer.csb")--  FriendLayer
end)

function SettingLayer:ctor()
	SettingLayer.super.ctor(self)

	self._scrollView = self:getChildByName("ScrollView")

	local dissolveRoom = self._scrollView:getChildByName("Btn_DissolveRoom")

	local backLobby = self._scrollView:getChildByName("Btn_BackLobby")

    local btnClose = self._scrollView:getChildByName("Btn_Close")


	lt.CommonUtil:addNodeClickEvent(dissolveRoom, handler(self, self.onDissolveRoom))
	lt.CommonUtil:addNodeClickEvent(backLobby, handler(self, self.onBackLobby))
    lt.CommonUtil:addNodeClickEvent(btnClose, handler(self, self.onClose))
end

function SettingLayer:onDissolveRoom()
    
end

function SettingLayer:onClose()
    lt.UILayerManager:removeLayer(self)
end


function SettingLayer:onBackLobby()
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.LEAVE_ROOM)
end

function SettingLayer:onBackLobbyResponse(msg)
	print("+++++++++++++++++++++++++++++++", msg.result)
    if msg.result == "success" then
    	local worldScene = lt.WorldScene.new()
        lt.SceneManager:replaceScene(worldScene)
        lt.NetWork:disconnect()
    end
end

function SettingLayer:onEnter()   
    print("SettingLayer:onEnter")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.LEAVE_ROOM, handler(self, self.onBackLobbyResponse), "SettingLayer:onBackLobbyResponse")


    local function onTouchBegan(touch,event)

        local iBeginPx = touch:getLocation().x
        local iBeginPY = touch:getLocation().y
        local worldPos = self:convertToWorldSpace(cc.p(self._scrollView:getPosition()))
        local worldRect = cc.rect(worldPos.x - self._scrollView:getContentSize().width, worldPos.y-self._scrollView:getContentSize().height, self._scrollView:getContentSize().width, self._scrollView:getContentSize().height)
        if not cc.rectContainsPoint(worldRect, cc.p(iBeginPx, iBeginPY)) then
            self:onClose()
        end

        return false
    end

    local onTouchEnded = function ( )
        -- body
    end

    self._listener = lt.CommonUtil:createEventListenerTouchOneByOne(self, onTouchBegan, onTouchEnded)

end

function SettingLayer:onExit()
    print("SettingLayer:onExit")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.LEAVE_ROOM, "SettingLayer:onBackLobbyResponse")
    lt.CommonUtil:removeEventListenerTouchOneByOne(self, self._listener)
end

return SettingLayer