
local ReplayView = class("ReplayView", function()
    return cc.CSLoader:createNode("game/common/RecordLayer.csb")
end)

function ReplayView:ctor()
	local mainLayer = self:getChildByName("Ie_Bg")
	self._shuruLayer = self:getChildByName("recordCodeLayer")
	self._shuruLayer:setVisible(false)--这个不使用;直接false掉
	local x = lt.Constants.GAME_TYPE
	local gameNum = 1
	for k,v in pairs(x) do
		gameNum = gameNum+1
	end
	print(gameNum)
	self._days = 86400 --一天的秒数

	self._TabCell = 1 --当前cell所在的位置，初始是1

	self.times = os.time()--当前时间
	self.currentlyTime = self.times -- 目前时间是变化的
	--返回按钮
	local backBtn = mainLayer:getChildByName("Bn_Close")
	self._svButton = mainLayer:getChildByName("SV_Button")
	self._svButton:setScrollBarEnabled(false)
	self._scrollView = mainLayer:getChildByName("ScrollView")

	self._bn_WatchOthers = mainLayer:getChildByName("Bn_WatchOthers")--观看他人回放
	self._bn_PageUp = mainLayer:getChildByName("Bn_PageUp")--前一天
	self._bn_PageUp:setVisible(false)
	self._bn_PageDown = mainLayer:getChildByName("Bn_PageDown")--后一天
	self._bn_PageDown:setVisible(false)

	local UITableView = require("app.UI.UITableView")
	self._zj_room_info = UITableView:bindNode(self._scrollView,"app.Scene.WorldScene.LobbyBtn.Replayitem")
    --self:listenRoomListUpdate()
	
	---[[
	local size = self._svButton:getContentSize()
	self._svButton:setInnerContainerSize(cc.size(200*gameNum,size.height))
	--self._scrollView:setInnerContainerSize(cc.size(1000,580))--单个145 x cell数量 
	--games/comm/lobbySpecial/
	local TabPosX = 0
	for i=1,gameNum do
		if i > 1 then
			TabPosX = TabPosX+200
		end
		print("self._svButtoncellNum=",i,TabPosX)
		local btnTab = ccui.Button:create("game/common/img/record_button_1.png", "game/common/img/record_button_1.png", "game/common/img/record_button_1.png", 1)
    	btnTab:setScale9Enabled(true)
    	btnTab:setAnchorPoint(0,0)
    	btnTab:setPosition(TabPosX,0)

    	if i == 1 then--最近游戏
			self._texure = ccui.Button:create("game/common/img/record_button_2.png", "game/common/img/record_button_2.png", "game/common/img/record_button_2.png", 1)
	    	self._texure:setPosition(0,0)
	    	self._texure:setScale9Enabled(true)
    		self._texure:setAnchorPoint(0,0)
    		self._texure:setScale(1.0)
	    	btnTab:addChild(self._texure)
	    	self:listenRoomListUpdate()
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
    			self._TabCell = i --给当前cell赋值
    			if i == 1 then
    				self._bn_PageUp:setVisible(false)
					self._bn_PageDown:setVisible(false)
    				self:listenRoomListUpdate()
    			else
    				self._bn_PageUp:setVisible(true)
					self._bn_PageDown:setVisible(true)
    				self:listenRoomListUpdatetype(i-1,self.currentlyTime)
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
    	if i == 1 then
	    	local textSpr = cc.Sprite:create("games/comm/lobbySpecial/ImageText998.png")--最近战绩 
	    	textSpr:setPosition(100,45)
	    	btnTab:addChild(textSpr,1)
    	elseif i == 2 then
    		local textSpr = cc.Sprite:create("games/comm/lobbySpecial/ImageText0.png")--红中麻将  --按照游戏类型
	    	textSpr:setPosition(100,45)
	    	btnTab:addChild(textSpr,1)
    	elseif i == 3 then
    		local textSpr = cc.Sprite:create("games/comm/lobbySpecial/ImageText120.png")--斗地主
	    	textSpr:setPosition(100,45)
	    	btnTab:addChild(textSpr,1)
    	elseif i == 4 then
    		local textSpr = cc.Sprite:create("games/comm/lobbySpecial/ImageText112.png")--商丘麻将
	    	textSpr:setPosition(100,45)
	    	btnTab:addChild(textSpr,1)
    	elseif i == 5 then
    		local textSpr = cc.Sprite:create("games/comm/lobbySpecial/ImageText6.png")--推倒胡
	    	textSpr:setPosition(100,45)
	    	btnTab:addChild(textSpr,1)
    	elseif i == 6 then
    		local textSpr = cc.Sprite:create("games/comm/lobbySpecial/ImageText114.png")--飘癞子
	    	textSpr:setPosition(100,45)
	    	btnTab:addChild(textSpr,1)
    	end

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

function ReplayView:onPageUp(event)--前一天
	self.currentlyTime = self.currentlyTime - self._days
	self:listenRoomListUpdatetype(self._TabCell-1,self.currentlyTime)
end

function ReplayView:onPageDown(event)--后一天
	self.currentlyTime = self.currentlyTime + self._days
	self:listenRoomListUpdatetype(self._TabCell-1,self.currentlyTime)
end

function ReplayView:onBack(event)
	lt.UILayerManager:removeLayer(self)
end

function ReplayView:listenRoomListUpdatetype(type,times)--选择其他
	print("=========发送成功type==========")
	local oldtime = os.date("%Y-%m-%d",times)
	local newtime = os.date("%Y-%m-%d %H:%M:%S",times)
	print("单个游戏开始时间",oldtime)
	print("单个游戏结束时间",newtime)
	lt.CommonUtil:searchReplays(oldtime,newtime,nil,type,function(result)
		print("==========返回成功type=============")
		if result then
			dump(result)
			self._zj_room_info:setData(result.replays,15,15,10)
		end
	end)


end



function ReplayView:listenRoomListUpdate()--第一次进入
	local times = os.time()
	local zhous = 604800 --一周的秒数
	local news = times-zhous
	local timeold  = os.date("%Y-%m-%d",news)
	local timenew  = os.date("%Y-%m-%d %H:%M:%S",times)
	print("最近游戏开始时间",timeold)
	print("最近游戏结束时间",timenew)
	print("=========发送成功==========")
	lt.CommonUtil:searchReplays(timeold,timenew,nil,nil,function(result)
		print("==========返回成功=============")
		if result then
			dump(result)
			self._zj_room_info:setData(result.replays,15,15,10)
		end
	end)
end

function ReplayView:onEnter()   
end

function ReplayView:onExit()

end

return ReplayView