
--设置层
local ApplyGameOverPanel = class("ApplyGameOverPanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/gwidget/EndRequestLayer.csb")
end)

function ApplyGameOverPanel:ctor()
	ApplyGameOverPanel.super.ctor(self)


	local root = self:getChildByName("Ie_Bg")


	local clockIcon = root:getChildByName("Clock_icon")

	local TtContent = root:getChildByName("Tt_Content")
	TtContent:setString("玩家【".."缺氧123".."】申请解散房间，请等待其他玩家选择（超过2分钟未做选择，则默认同意)")

	local times = root:getChildByName("Se_CutTime"):getChildByName("Al_CutTime")--倒计时
	times:setString("2".."/".."00")
	local a = "30"
	local function update(dt)
		print("=============6666")
		a = tonumber(a)-1
        times:setString(tostring(a))
        if a == 0 then
        	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedule_id)
        	lt.UILayerManager:removeLayer(self)
        end
	end
	local scheduler = cc.Director:getInstance():getScheduler()
	self.schedule_id = scheduler:scheduleScriptFunc(function(dt)
    	update(dt)
    	--cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduler)
    	--if self.schedule_id then
        --cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedule_id)
        --self.schedule_id = nil
        --lt.UILayerManager:removeLayer(self)
        

    --end
	end,1,false)


	local Bn_Cancel = root:getChildByName("Bn_Cancel")--拒绝
	local Bn_Sure = self:getChildByName("Bn_Sure")--同意

	lt.CommonUtil:addNodeClickEvent(Bn_Cancel, handler(self, self.onCancelClick))
	lt.CommonUtil:addNodeClickEvent(Bn_Sure, handler(self, self.onSureClick))

end

function ApplyGameOverPanel:onCancelClick(event) 
	local setLayer = lt.SettingLayer.new()
    lt.UILayerManager:addLayer(setLayer, true)
end

function ApplyGameOverPanel:onSureClick(event) 

end

function ApplyGameOverPanel:onEnter()   

end

function ApplyGameOverPanel:onExit()

end

return ApplyGameOverPanel