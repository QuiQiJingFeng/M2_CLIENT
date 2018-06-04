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
	self._menu_GameList:setInnerContainerSize(cc.size(size.width,320))--人数 x 80

	--local posy = {425,340,255,170,85,0}
	local posY = 160

	for i=1,4 do
		if i ~= 1 then
			posY = posY+85
		end
		local btnTab = ccui.Button:create("game/common/img/createRoom_btnNormal.png", "game/common/img/createRoom_btnNormal.png", "game/common/img/createRoom_btnNormal.png", 1) 
		btnTab:setPosition(5,posY)
		btnTab:setScale9Enabled(true)
	    btnTab:setAnchorPoint(0,0)
	    btnTab:setScale(0.85)

	    if i == 4 then
	    	self._texure = ccui.Button:create("game/common/img/createRoom_btnSelect.png", "game/common/img/createRoom_btnSelect.png", "game/common/img/createRoom_btnSelect.png", 1)
	    	self._texure:setPosition(0,0)
	    	self._texure:setScale9Enabled(true)
    		self._texure:setAnchorPoint(0,0)
    		self._texure:setScale(1.0)
	    	btnTab:addChild(self._texure)

	    	self._helpDate = lt.HelpData.new()
	    	self._helpDate:show(4)
	    	self._scrollView_Info:addChild(self._helpDate)
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
	    			self._texure = ccui.Button:create("game/common/img/createRoom_btnSelect.png", "game/common/img/createRoom_btnSelect.png", "game/common/img/createRoom_btnSelect.png", 1)
	    			self._texure:setPosition(0,0)
	    			self._texure:setScale9Enabled(true)
    			    self._texure:setAnchorPoint(0,0)
    			    self._texure:setScale(1.0)
	    			btnTab:addChild(self._texure)

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
    				--[[ --内容      
    			    local _Text = ccui.Text:create();
    				_Text:setFontSize(30)
    				_Text:setString("fgsdgdsgdfsgfdsgsdfgsdfgdfsgfsdgdfssdfgsdfgsdfgsdfgfsdgsdfgdfsgdfsdfsgdfs")
					self._scrollView_Info:addChild(_Text)
					--]]
				--[[
				local text = lt.LanguageString:getString("LOBBYHELP_1")
       	 		local line = ccui.Text:create()
        		line:setFontSize(25)
        		line:setFontName("font/fzcy.TTF")
        		--local color = string.split(content.fontColor, ",")
        	  	--line:setTextColor(cc.c4b(tonumber(color[1]), tonumber(color[2]), tonumber(color[3]), 255))
        		line:ignoreContentAdaptWithSize(false)
        		line:setTextAreaSize(cc.size(1080, 0))
        		line:setString(text)
        		line:setContentSize(cc.size(1080, line:getVirtualRendererSize().height))
        		self.contentList:pushBackCustomItem(line)--]]
				


	    		
    			
        	elseif eventType == ccui.TouchEventType.canceled then
            	--print("取消点击")
        	end
		end 
		btnTab:addTouchEventListener(menuZhuCeCallback)
		self._menu_GameList:addChild(btnTab)





		local textSpr = cc.Sprite:create("games/comm/lobbySpecial/ImageText0.png")--名称
    	textSpr:setPosition(100,45)
    	btnTab:addChild(textSpr,1)
	end

	
	


	
	lt.CommonUtil:addNodeClickEvent(Bn_Close, handler(self, self.onclose))
	
end

function LobbyHelpLayer:onSure(event)
	--接口
end
function LobbyHelpLayer:onClickNumKey(event)
	
	
end

function LobbyHelpLayer:onReset(event)
	
end

function LobbyHelpLayer:onDele(event)
	
end

function LobbyHelpLayer:onclose(event)
	lt.UILayerManager:removeLayer(self)
end

return LobbyHelpLayer