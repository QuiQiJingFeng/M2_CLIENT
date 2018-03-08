
-- ################################################## 世界界面(UI界面) ##################################################
-- 此界面只用于 添加UI界面
local WorldUILayer = class("WorldUILayer", lt.BaseLayer)

WorldUILayer._delegate = nil
function WorldUILayer:ctor(delegate)
	self:setTouchEnabled(true)
	--self:setSwallowTouches(true)
	self._delegate = delegate

	-- self._topBanner = lt.TopBannerr.new(self._delegate)
	-- self._topBanner:setVisible(false)
	-- self:addChild(self._topBanner, 10000)
end

function WorldUILayer:clearAllLayers()
	self:removeAllChildren()

	self._topBanner = lt.TopBanner.new(self._delegate)
	self._topBanner:setVisible(false)
	self:addChild(self._topBanner, 10000)
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
	self._topBanner:setVisible(true)
	self._topBanner:setLocalZOrder(zorder + 1)
end

function WorldUILayer:topHide()
	self._topBanner:setVisible(false)
end

-- temp
function WorldUILayer:onDebug()
	-- 增加1级UI界面
	local debugLayer = lt.DebugLayer1.new()
	lt.UILayerManager:addLayer(debugLayer)
end

return WorldUILayer