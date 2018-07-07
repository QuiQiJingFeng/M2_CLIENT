
-- ################################################## 世界界面(消息界面) ##################################################
-- 此界面只用于 添加游戏内各种提示性消息
local WorldNoticeLayer = class("WorldNoticeLayer", lt.BaseLayer)

function WorldNoticeLayer:ctor()
	--self:setNodeEventEnabled(true)
    WorldNoticeLayer.super.ctor(self)
end

function WorldNoticeLayer:onEnter()   
	self:setTouchEnabled(false)

end

function WorldNoticeLayer:onExit()

end

return WorldNoticeLayer
