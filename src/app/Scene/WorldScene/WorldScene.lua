
-- 游戏场景
local WorldScene = class("WorldScene", function()
    return display.newScene("WorldScene")
end)

WorldScene._worldLayer   	= nil -- 主世界(场景世界)
WorldScene._worldMenuLayer 	= nil -- 游戏菜单界面
WorldScene._worldUILayer 	= nil -- 游戏UI界面

WorldScene._worldLoadingLayer = nil

function WorldScene:ctor()

    self._worldMenuLayer = lt.WorldMenuLayer.new()
    self:addChild(self._worldMenuLayer)

    self._worldUILayer = lt.WorldUILayer.new(self)
    self._worldUILayer:setVisible(false)
    self:addChild(self._worldUILayer)

    self._worldNoticeLayer = lt.WorldNoticeLayer.new()
    self:addChild(self._worldNoticeLayer)

    -- self._worldLayer:setWorldMenuLayer(self._worldMenuLayer)
    -- self._worldLayer:setWorldUILayer(self._worldUILayer)
    -- self._worldMenuLayer:setWorldLayer(self._worldLayer)

    --self:loadingOn()

    lt.UILayerManager:setWorldMenuLayer(self._worldMenuLayer)
    lt.UILayerManager:setWorldUILayer(self._worldUILayer)

    lt.DataManager:clearGameData()
end

function WorldScene:getWorldLayer()
	return self._worldLayer
end

function WorldScene:getWorldMenuLayer()
	return self._worldMenuLayer
end

function WorldScene:getWorldUILayer()
	return self._worldUILayer
end

function WorldScene:loadingOn()
	-- if not self._worldLoadingLayer then
	-- 	self._worldLoadingLayer = lt.WorldLoadingLayer.new()
	-- 	self:addChild(self._worldLoadingLayer, lt.Constants.ZORDER.LOADING)
	-- end
end

function WorldScene:loadingOff()
	-- if self._worldLoadingLayer then
	-- 	self._worldLoadingLayer:removeSelf()
	-- 	self._worldLoadingLayer = nil
	-- end
end

return WorldScene
