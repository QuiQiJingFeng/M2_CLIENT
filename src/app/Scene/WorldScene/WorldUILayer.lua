
-- ################################################## 世界界面(UI界面) ##################################################
-- 此界面只用于 添加UI界面
local WorldUILayer = class("WorldUILayer", lt.BaseLayer)

WorldUILayer._delegate = nil
function WorldUILayer:ctor(delegate)
	 WorldUILayer.super.ctor(self)
	self:setTouchEnabled(true)
	--self:setSwallowTouches(true)
	self._delegate = delegate
end

function WorldUILayer:clearAllLayers()
	self:removeAllChildren()
end

function WorldUILayer:onEnter()
    self:setTouchEnabled(false)
    
    lt.UILayerManager:setWorldUILayer(self)
end

function WorldUILayer:onExit()
    lt.UILayerManager:clearWorldUILayer()
end

function WorldUILayer:updateInfo()
	-- 更新货币
	lt.CommonUtil.printf("更新货币")
end

function WorldUILayer:topShow(zorder)
	zorder = zorder or 10000
end

function WorldUILayer:topHide()

end

-- temp
function WorldUILayer:onDebug()
	-- 增加1级UI界面
	local debugLayer = lt.DebugLayer1.new()
	lt.UILayerManager:addLayer(debugLayer)
end

return WorldUILayer