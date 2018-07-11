local LobbyHelpLayer = class("LobbyHelpLayer", function()
    return cc.CSLoader:createNode("game/common/LobbyHelpLayer.csb")
end)

function LobbyHelpLayer:ctor()
	self._helpDate = nil
	local mainNode = self:getChildByName("Ie_Bg")
	local Bn_Close = mainNode:getChildByName("Bn_Close")
	
	local Image_RuleBg = mainNode:getChildByName("Image_RuleBg")
	self._scrollView_Info = Image_RuleBg:getChildByName("ScrollView_Info")

	self._menu_GameList = mainNode:getChildByName("Menu_GameList")--滚动列表
	local size = self._menu_GameList:getContentSize()
	self._menu_GameList:setInnerContainerSize(cc.size(size.width,250))--人数 x 80

	self._lowNodeTable = {}
	self._deepNodeTable = {}
	
	local posY = 428--140
	for i=1,5 do
		if i ~= 1 then
			posY = posY-72
		end
		local btnTab = ccui.Button:create("game/common/img/createRoom_btnNormal.png", "game/common/img/createRoom_btnNormal.png", "game/common/img/createRoom_btnNormal.png", 1) 
		btnTab:setPosition(5,posY)
		btnTab:setScale9Enabled(true)
	    btnTab:setAnchorPoint(0,0)
	    btnTab:setScale(0.85)

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
	    			self._texure = ccui.Button:create("game/common/img/createRoom_btnSelect.png", "game/common/img/createRoom_btnSelect.png", "game/common/img/createRoom_btnSelect.png", 1)
	    			self._texure:setPosition(0,0)
	    			self._texure:setScale9Enabled(true)
    			    self._texure:setAnchorPoint(0,0)
    			    self._texure:setScale(1.0)
	    			btnTab:addChild(self._texure)

	    			for k,v in ipairs(self._lowNodeTable) do
	    		    	if k == i then
	    		    		v:setVisible(false)
	    		    		for p,t in ipairs(self._deepNodeTable) do
	    		    			if p == i then
	    		    				t:setVisible(true)
	    		    			else
	    		    				t:setVisible(false)
	    		    			end
	    		    		end
	    		    		
			    		else
			    			v:setVisible(true)
	    		    	end
	    		    end

	    		else
	    			print("=======选中状态======")
	    			self._texure = ccui.Button:create("game/common/img/createRoom_btnSelect.png", "game/common/img/createRoom_btnSelect.png", "game/common/img/createRoom_btnSelect.png", 1)
	    			self._texure:setPosition(0,0)
	    			self._texure:setScale9Enabled(true)
    			    self._texure:setAnchorPoint(0,0)
    			    self._texure:setScale(1.0)
	    			btnTab:addChild(self._texure)
    			end
    				if  not self._helpDate then
	    			    self._helpDate = lt.HelpData.new()
	    				self._helpDate:show(i)
	    				self._scrollView_Info:addChild(self._helpDate)
    				else
    					self._helpDate:show(i)
    				end
					
        	elseif eventType == ccui.TouchEventType.canceled then
            	--print("取消点击")
        	end
		end 
		btnTab:addTouchEventListener(menuZhuCeCallback)
		self._menu_GameList:addChild(btnTab)

		if i == 1 then  --1 红中 2 斗地主  ImageText120 3 商丘麻将  ImageText112 4 飘癞子 ImageText114  5 推倒胡 ImageText6
			local textSpr1 = cc.Sprite:create("games/comm/lobbySpecial/ImageText2.png")--名称
	    	textSpr1:setPosition(btnTab:getContentSize().width/2,btnTab:getContentSize().height/2)
	    	textSpr1:setVisible(false)
	    	btnTab:addChild(textSpr1,1)
	  	    table.insert( self._lowNodeTable, textSpr1 )

	  	    local textSpr = cc.Sprite:create("games/comm/lobbySpecial/ImageText0.png")--名称
	    	textSpr:setPosition(btnTab:getContentSize().width/2,btnTab:getContentSize().height/2)
	    	textSpr:setVisible(true)
	    	btnTab:addChild(textSpr,1)
	  	    table.insert( self._deepNodeTable, textSpr )
		elseif i == 2 then
			local textSpr1 = cc.Sprite:create("games/comm/lobbySpecial/ImageText119.png")--名称
	    	textSpr1:setPosition(btnTab:getContentSize().width/2,btnTab:getContentSize().height/2)
	    	btnTab:addChild(textSpr1,1)
	    	table.insert( self._lowNodeTable, textSpr1 )

	    	local textSpr = cc.Sprite:create("games/comm/lobbySpecial/ImageText120.png")--名称
	    	textSpr:setPosition(btnTab:getContentSize().width/2,btnTab:getContentSize().height/2)
	    	textSpr:setVisible(false)
	    	btnTab:addChild(textSpr,1)
	  	    table.insert( self._deepNodeTable, textSpr )
		elseif i == 3 then
			local textSpr1 = cc.Sprite:create("games/comm/lobbySpecial/ImageText111.png")--名称
	    	textSpr1:setPosition(btnTab:getContentSize().width/2,btnTab:getContentSize().height/2)
	    	btnTab:addChild(textSpr1,1)
	    	table.insert( self._lowNodeTable, textSpr1 )

	    	local textSpr = cc.Sprite:create("games/comm/lobbySpecial/ImageText112.png")--名称
	    	textSpr:setPosition(btnTab:getContentSize().width/2,btnTab:getContentSize().height/2)
	    	textSpr:setVisible(false)
	    	btnTab:addChild(textSpr,1)
	  	    table.insert( self._deepNodeTable, textSpr )
		elseif i == 4 then
			local textSpr1 = cc.Sprite:create("games/comm/lobbySpecial/ImageText113.png")--名称
    		textSpr1:setPosition(btnTab:getContentSize().width/2,btnTab:getContentSize().height/2)
    		btnTab:addChild(textSpr1,1)
    		table.insert( self._lowNodeTable, textSpr1 )

    		local textSpr = cc.Sprite:create("games/comm/lobbySpecial/ImageText114.png")--名称
	    	textSpr:setPosition(btnTab:getContentSize().width/2,btnTab:getContentSize().height/2)
	    	textSpr:setVisible(false)
	    	btnTab:addChild(textSpr,1)
	  	    table.insert( self._deepNodeTable, textSpr )
    	elseif i == 5 then
    		local textSpr1 = cc.Sprite:create("games/comm/lobbySpecial/ImageText7.png")--名称
    		textSpr1:setPosition(btnTab:getContentSize().width/2,btnTab:getContentSize().height/2)
    		btnTab:addChild(textSpr1,1)
    		table.insert( self._lowNodeTable, textSpr1 )

    		local textSpr = cc.Sprite:create("games/comm/lobbySpecial/ImageText6.png")--名称
	    	textSpr:setPosition(btnTab:getContentSize().width/2,btnTab:getContentSize().height/2)
	    	textSpr:setVisible(false)
	    	btnTab:addChild(textSpr,1)
	  	    table.insert( self._deepNodeTable, textSpr )
		end

		if i == 1 then
		    self._texure = ccui.Button:create("game/common/img/createRoom_btnSelect.png", "game/common/img/createRoom_btnSelect.png", "game/common/img/createRoom_btnSelect.png", 1)
		    self._texure:setPosition(0,0)
		    self._texure:setScale9Enabled(true)
	    	self._texure:setAnchorPoint(0,0)
	    	self._texure:setScale(1.0)
		    btnTab:addChild(self._texure)

		    self._helpDate = lt.HelpData.new()
		    self._helpDate:show(5)
		    self._scrollView_Info:addChild(self._helpDate)
	    end
	end
	
	lt.CommonUtil:addNodeClickEvent(Bn_Close, handler(self, self.onclose))
	
end

function LobbyHelpLayer:onclose(event)
	lt.UILayerManager:removeLayer(self)
end

return LobbyHelpLayer