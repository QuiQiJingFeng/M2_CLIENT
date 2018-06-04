
local ReplayView = class("ReplayView", function()
    return cc.CSLoader:createNode("game/common/RecordLayer.csb")
end)

function ReplayView:ctor()
	local mainLayer = self:getChildByName("Ie_Bg")
	self._shuruLayer = self:getChildByName("recordCodeLayer")
	self._shuruLayer:setVisible(false)--这个不使用;直接false掉
	
	--返回按钮
	local backBtn = mainLayer:getChildByName("Bn_Close")
	self._svButton = mainLayer:getChildByName("SV_Button")
	self._svButton:setScrollBarEnabled(false)
	self._scrollView = mainLayer:getChildByName("ScrollView")

	self._bn_WatchOthers = mainLayer:getChildByName("Bn_WatchOthers")--观看他人回放
	self._bn_PageUp = mainLayer:getChildByName("Bn_PageUp")--前一天
	self._bn_PageDown = mainLayer:getChildByName("Bn_PageDown")--后一天

	local UITableView = require("app.UI.UITableView")
	self._zj_room_info = UITableView:bindNode(self._scrollView,"app.Scene.WorldScene.LobbyBtn.Replayitem")
    self:listenRoomListUpdate()
	
	---[[
	local size = self._svButton:getContentSize()

	self._svButton:setInnerContainerSize(cc.size(200*10,size.height))
	--self._scrollView:setInnerContainerSize(cc.size(1000,580))--单个145 x cell数量 
	--games/comm/lobbySpecial/
	local TabPosX = 0
	for i=1,10 do
		if i > 1 then
			TabPosX = TabPosX+200
		end
		print("=====1=1=1=1=1=",i,TabPosX)
		local btnTab = ccui.Button:create("game/common/img/record_button_1.png", "game/common/img/record_button_1.png", "game/common/img/record_button_1.png", 1)
    	btnTab:setScale9Enabled(true)
    	btnTab:setAnchorPoint(0,0)
    	btnTab:setPosition(TabPosX,0)--img_nn.png

    	if i == 1 then--最近游戏
			self._texure = ccui.Button:create("game/common/img/record_button_2.png", "game/common/img/record_button_2.png", "game/common/img/record_button_2.png", 1)
	    	self._texure:setPosition(0,0)
	    	self._texure:setScale9Enabled(true)
    		self._texure:setAnchorPoint(0,0)
    		self._texure:setScale(1.0)
	    	btnTab:addChild(self._texure)

		end

    	local function menuZhuCeCallback(sender,eventType)
	        if eventType == ccui.TouchEventType.began then
            	--print("按下按钮")
        	elseif eventType == ccui.TouchEventType.moved then
            	--print("按下按钮移动")
        	elseif eventType == ccui.TouchEventType.ended then
            	print("放开按钮")
            	print("===========",i)
	        	if self._texure ~= nil then
			        self._texure:removeFromParent() 
			        print("=======选中状态======")
	    			self._texure = ccui.Button:create("game/common/img/record_button_2.png", "game/common/img/record_button_2.png", "game/common/img/record_button_2.png", 1)
	    			self._texure:setPosition(0,0)
	    			self._texure:setScale9Enabled(true)
    			    self._texure:setAnchorPoint(0,0)
    			    self._texure:setScale(1.0)
	    			btnTab:addChild(self._texure)

	    		else
	    			print("=======选中状态======")
	    			self._texure = ccui.Button:create("game/common/img/record_button_2.png", "game/common/img/record_button_2.png", "game/common/img/record_button_2.png", 1)
	    			self._texure:setPosition(0,0)
	    			self._texure:setScale9Enabled(true)
    			    self._texure:setAnchorPoint(0,0)
    			    self._texure:setScale(1.0)
	    			btnTab:addChild(self._texure)
    			end
    			--[[
	    		local posY = 60-- 最后一个是60 每加一个+145
	    		for i=1,4 do
	    			if i ~= 1 then
	    				posY = posY +145
	    			end
	    			local Replayitem = lt.Replayitem.new()
	    			Replayitem:setPosition(520,posY)
	    			self._scrollView:addChild(Replayitem)
	    		end
	    		--]]
    			
        	elseif eventType == ccui.TouchEventType.canceled then
            	--print("取消点击")
        	end
		end 
		btnTab:addTouchEventListener(menuZhuCeCallback)
    	self._svButton:addChild(btnTab,2)

    	local textSpr = cc.Sprite:create("games/comm/lobbySpecial/ImageText0.png")--名称
    	textSpr:setPosition(100,45)
    	btnTab:addChild(textSpr,1)

	end
	
--]]

	

	lt.CommonUtil:addNodeClickEvent(self._bn_WatchOthers, handler(self, self.onWatchOthers))
	lt.CommonUtil:addNodeClickEvent(self._bn_PageUp, handler(self, self.onPageUp))
	lt.CommonUtil:addNodeClickEvent(self._bn_PageDown, handler(self, self.onPageDown))
	lt.CommonUtil:addNodeClickEvent(backBtn, handler(self, self.onBack))
end

function ReplayView:onWatchOthers(event)
	local ReplaycodeLayer = lt.ReplaycodeLayer.new()
	lt.UILayerManager:addLayer(ReplaycodeLayer)
end

function ReplayView:onPageUp(event)

end

function ReplayView:onPageDown(event)

end

function ReplayView:onBack(event)
	lt.UILayerManager:removeLayer(self)
end

function ReplayView:listenRoomListUpdate()
	print("=========发送成功==========")
	lt.CommonUtil:searchReplays("2018-06-04","2018-06-30",nil,nil,function(result)
		print("==========返回成功=============")
		if result then
			dump(result)
			self._zj_room_info:setData(result.replays,0,20,10)
		end
	end)
end

function ReplayView:onEnter()   
end

function ReplayView:onExit()

end

return ReplayView