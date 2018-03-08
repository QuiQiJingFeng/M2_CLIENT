
local StartScene = class("StartScene", function()
    return display.newScene("StartScene")
end)
StartScene._worldLoadingLayer = nil
function StartScene:ctor()
    if __G__PLAYER__LOGOUT__TYPE__ then--玩家设置界面登出或者换角色
        if __G__PLAYER__LOGOUT__TYPE__ == 2 then--换角色
            self:loadingOn()
        end
    end
    local startLayer = lt.StartLayer.new()
    self:addChild(startLayer)
end

function StartScene:loadingOn()
    if not self._worldLoadingLayer then
        self._worldLoadingLayer = lt.WorldLoadingLayer.new()
        self:addChild(self._worldLoadingLayer, lt.Constants.ZORDER.LOADING)
    end
end

function StartScene:loadingOff()
    if self._worldLoadingLayer then
        self._worldLoadingLayer:removeSelf()
        self._worldLoadingLayer = nil
    end
end

return StartScene
