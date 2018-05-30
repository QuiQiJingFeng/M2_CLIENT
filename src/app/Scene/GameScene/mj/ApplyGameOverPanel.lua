
--设置层
local ApplyGameOverPanel = class("ApplyGameOverPanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/gwidget/EndRequestLayer.csb")
end)

function ApplyGameOverPanel:ctor(deleget)
	ApplyGameOverPanel.super.ctor(self)

	self._deleget = deleget

	self.root = self:getChildByName("Ie_Bg")


	local clockIcon = self.root:getChildByName("Clock_icon")

	self._applicaContent = self.root:getChildByName("Tt_Content")
	self._nameLableTable= {}
	self._stateLableTable = {}
	for i=1,3 do
		table.insert(self._nameLableTable,self.root:getChildByName("Name_"..i))
		table.insert(self._stateLableTable,self.root:getChildByName("State_"..i))
		self.root:getChildByName("Name_"..i):setVisible(false)
		self.root:getChildByName("State_"..i):setVisible(false)
	end

	self._timeLabel = self.root:getChildByName("Se_CutTime"):getChildByName("Al_CutTime")--倒计时
	self._timeNumber = nil 


	self._bn_Cancel = self.root:getChildByName("Bn_Cancel")--拒绝
	self._bn_Sure = self.root:getChildByName("Bn_Sure")--同意

	lt.CommonUtil:addNodeClickEvent(self._bn_Cancel, handler(self, self.onCancelClick))
	lt.CommonUtil:addNodeClickEvent(self._bn_Sure, handler(self, self.onSureClick))

end
function ApplyGameOverPanel:show(Timeer,nameidText)
	print("[[[[[[[[[[[[")
	dump(nameidText)

	local roomInfo = lt.DataManager:getGameRoomInfo()
	--local loginData = lt.DataManager:getPlayerInfo()
	local needApplyPlayer = {}
	for k, player in ipairs(roomInfo.players) do
		if tonumber(nameidText[1]) ~= player.user_id then
			 table.insert(needApplyPlayer, player)
		else
			self._applicaContent:setString("玩家【"..player.user_name.."】申请解散房间，请等待其他玩家选择（超过2分钟未做选择，则默认同意)")
		end
	end
	print("ffffffffff")
	dump(needApplyPlayer)
	for i,player in ipairs(needApplyPlayer) do
		self._stateLableTable[i]:setTag(player.user_id)
		self._nameLableTable[i]:setString(player.user_name)
		local x =  self._nameLableTable[i]:getContentSize().width+self._nameLableTable[i]:getPositionX() + 10 
		self._stateLableTable[i]:setPositionX(x)
	end

	for i=1,#roomInfo.players-1 do
		self._nameLableTable[i]:setVisible(true)
		self._stateLableTable[i]:setVisible(true)	
	end

	for i,lable in ipairs(self._stateLableTable) do
		print("=======1111111",lable:getTag())
		for k,userId in ipairs(nameidText) do
			print(lable:getTag(),"==========",tonumber(userId))
			if lable:getTag() == tonumber(userId) then
				print("sssssssssssssss")
				lable:setString("玩家同意")
				lable:setColor(cc.c3b(0,255,0))
			end

		end
	end
	self._timeNumber = Timeer

    if #nameidText == #roomInfo.players then
    	local worldScene = lt.WorldScene.new()
    	lt.SceneManager:replaceScene(worldScene)
    end
end 

function ApplyGameOverPanel:onUpdate(dt)
		if not self._timeNumber then
			return
		end
		self._timeNumber = self._timeNumber - 1
		local ff = ""  --剩余分钟拼接字符串
		local ss = ""  --剩余秒拼接字符串
		local t1,t2 = math.modf(self._timeNumber/60);
		local pp = self._timeNumber%60
		if t1 == 0 then
			ff = ""
		else
			ff = t1
		end
		ss = pp
		if ss<60 and ff=="" then
			if ss < 10 then
				self._timeLabel:setString("0"..ss)
			else
				self._timeLabel:setString(ss)
			end
		else
			if ss < 10 then
				self._timeLabel:setString(ff.."/".."0"..ss)
			else
				self._timeLabel:setString(ff.."/"..ss)
			end
		end
		
        
        if self._timeNumber == 0 then
        	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedule_id)
        	lt.UILayerManager:removeLayer(self)
        end
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
	--成功按钮灰掉
	self:buttonNotChick()
end

function ApplyGameOverPanel:buttonNotChick()
	--成功按钮灰掉
	self._bn_Cancel:setEnabled(false)
	self._bn_Sure:setEnabled(false)

end

function ApplyGameOverPanel:onClose()
	self._deleget:onCloseApplyGameOverPanel()
end

function ApplyGameOverPanel:onEnter()   
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.CONFIRM_DISTROY_ROOM, handler(self,self.onConfirmDistroyRoom),"ApplyGameOverPanel:onConfirmDistroyRoom")
	local scheduler = cc.Director:getInstance():getScheduler()
	self.schedule_id = scheduler:scheduleScriptFunc(function(dt)
    	self:onUpdate(dt)
	end,1,false)
end

function ApplyGameOverPanel:onExit()
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.CONFIRM_DISTROY_ROOM, "ApplyGameOverPanel:onConfirmDistroyRoom")
	if self.schedule_id then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedule_id)
	end
end

return ApplyGameOverPanel