
--设置层
local ApplyGameOverPanel = class("ApplyGameOverPanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/gwidget/EndRequestLayer.csb")
end)

function ApplyGameOverPanel:ctor()
	ApplyGameOverPanel.super.ctor(self)


	self.root = self:getChildByName("Ie_Bg")


	local clockIcon = self.root:getChildByName("Clock_icon")
--[[
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
	end,1,false)--]]


	local Bn_Cancel = self.root:getChildByName("Bn_Cancel")--拒绝
	local Bn_Sure = self.root:getChildByName("Bn_Sure")--同意

	lt.CommonUtil:addNodeClickEvent(Bn_Cancel, handler(self, self.onCancelClick))
	lt.CommonUtil:addNodeClickEvent(Bn_Sure, handler(self, self.onSureClick))

end
function ApplyGameOverPanel:show(Timeer,nameText)
	print("[[[[[[[[[[[[")
	dump(nameText)
	print(#nameText)
	local TtContent = self.root:getChildByName("Tt_Content")
	local Tt_Content_1 = self.root:getChildByName("Tt_Content_1")
	local oo = ""
	if #nameText ~= 1 then
       for i=2,#nameText do
       	--table.insert(oo,nameText[i])       
       	oo = oo..nameText[i]..","
       end
       Tt_Content_1:setString("玩家【"..oo.."】同意解散房间")
	end
	TtContent:setString("玩家【"..nameText[1].."】申请解散房间，请等待其他玩家选择（超过2分钟未做选择，则默认同意)")

	local times = self.root:getChildByName("Se_CutTime"):getChildByName("Al_CutTime")--倒计时
	--times:setString("2".."/".."00")
	local timeNumber = Timeer --传过来的倒计时
	local function update(dt)
		timeNumber = timeNumber - 1
		local ff = ""  --剩余分钟拼接字符串
		local ss = ""  --剩余秒拼接字符串
		local t1,t2 = math.modf(timeNumber/60);
		local pp = timeNumber%60
		if t1 == 0 then
			ff = ""
		else
			ff = t1
		end
		ss = pp
		if ss<60 and ff=="" then
			if ss < 10 then
				times:setString("0"..ss)
			else
				times:setString(ss)
			end
		else
			if ss < 10 then
				times:setString(ff.."/".."0"..ss)
			else
				times:setString(ff.."/"..ss)
			end
		end
		
        
        if timeNumber == 0 then
        	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedule_id)
        	lt.UILayerManager:removeLayer(self)
        end
	end
	local scheduler = cc.Director:getInstance():getScheduler()
	self.schedule_id = scheduler:scheduleScriptFunc(function(dt)
    	update(dt)
	end,1,false)
end 

function ApplyGameOverPanel:onCancelClick(event) 
	local arg = {confirm = false}
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.CONFIRM_DISTROY_ROOM,arg)
	--local setLayer = lt.SettingLayer.new()
    --lt.UILayerManager:addLayer(setLayer, true)
end

function ApplyGameOverPanel:onSureClick(event) 
	local arg = {confirm = true}
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.CONFIRM_DISTROY_ROOM,arg)
end

function ApplyGameOverPanel:onConfirmDistroyRoom(msg)
	--lt.UILayerManager:removeLayer(self)
	print("====1=1=1=1==1=1=1==1=")
	dump(msg)
	--if msg.result == "success" then
	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedule_id)
	lt.UILayerManager:removeLayer(self)
	--end
end

function ApplyGameOverPanel:onEnter()   
	print("=========111111111",lt.GameEventManager.EVENT.CONFIRM_DISTROY_ROOM)
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.CONFIRM_DISTROY_ROOM, handler(self,self.onConfirmDistroyRoom),"ApplyGameOverPanel:onConfirmDistroyRoom")
end

function ApplyGameOverPanel:onExit()
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.CONFIRM_DISTROY_ROOM, "ApplyGameOverPanel:onConfirmDistroyRoom")
end

return ApplyGameOverPanel