local UITableViewItem = class("UITableViewItem",function() 
		return ccui.ImageView:create("res/hallcomm/lobby/img/myRoom_bg1.png")
	end)

function UITableViewItem:ctor()
    self:setScale9Enabled(true)
    self:setContentSize(cc.size(400,70))

    local txtColor = cc.c3b(255,255,255)
    local txtOpacity = 255
    self.roomNameLabel = cc.Label:createWithSystemFont("", "Helvetica", 20.0)        
    self.roomNameLabel:setColor(txtColor)
    self.roomNameLabel:setOpacity(txtOpacity)
    self.roomNameLabel:setAnchorPoint(cc.p(0.5, 0.5))
    self.roomNameLabel:setAlignment(cc.TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    self.roomNameLabel:setPosition(cc.p(50, 40))
    self:addChild(self.roomNameLabel)
    
   
    self.roomNumberLabel = cc.Label:createWithSystemFont("", "Helvetica", 20.0)
    self.roomNumberLabel:setColor(txtColor)
    self.roomNumberLabel:setOpacity(txtOpacity)
    self.roomNumberLabel:setAnchorPoint(cc.p(0.5, 0.5))
    self.roomNumberLabel:setPosition(cc.p(135, 40))
    self.roomNumberLabel:setAlignment(cc.TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    self:addChild(self.roomNumberLabel)
    

    local btnPath = "hallcomm/lobby/img/myRoom_btn2.png"                              
    self.btn = ccui.Button:create(btnPath, btnPath, btnPath, 1)
    self.btn:setPosition(350, 40)           
    self:addChild(self.btn)


    lt.CommonUtil:addNodeClickEvent(self.btn, handler(self,self.onJoinRoom), true)

 
    self.stateLabel = cc.Label:createWithSystemFont("", "Helvetica", 20.0)
    self.stateLabel:setAnchorPoint(cc.p(0.5, 0.5))
    self.stateLabel:setPosition(cc.p(245, 40))
    self.stateLabel:setOpacity(txtOpacity)
    self.stateLabel:setAlignment(cc.TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    self:addChild(self.stateLabel)
    self.stateLabel:setColor(cc.c3b(255,100,100))
    

    self.arrowSpr = display.newSprite()
    local selectPath = "hallcomm/lobby/img/img_ArrowToZhanji.png"
    local pngName = cc.SpriteFrameCache:getInstance():getSpriteFrame(selectPath)
    if pngName then
        self.arrowSpr:setSpriteFrame(pngName)
    elseif cc.FileUtils:getInstance():isFileExist(selectPath) then
        self.arrowSpr:setTexture(selectPath)
    end
    local bnSize = self.btn:getContentSize()
    local bnPosx, bnPosy = self.btn:getPosition() 
    self.arrowSpr:setPosition(bnPosx + bnSize.width/2 + 10, bnPosy)
    self.arrowSpr:setVisible(false)
    self.arrowSpr:setRotation(180)
    self:addChild(self.arrowSpr) 
end

function UITableViewItem:onJoinRoom()
	local room_id = self.data.room_id
	local arg = {room_id = room_id}
    lt.CommonUtil:sepecailServerLogin(room_id,function(result) 
           if result ~= "success" then
                print("connect failed")
                return
            end
            lt.NetWork:sendTo(lt.GameEventManager.EVENT.JOIN_ROOM, arg)
        end)

	
end

--return cell size
function UITableViewItem:refreshData(data)
    self.data = data

	self.roomNameLabel:setString(lt.LanguageString:getString("STRING_GAME_NAME_"..data.game_type))

	local str = data.room_id
	if lt.DataManager:getPlayerUid() == data.owner_id then
		str = str .. lt.Constants.TEXTS[1]
	end
	self.roomNumberLabel:setString(str)
	if data.state == lt.Constants.ROOM_STATE.GAME_PREPARE then
        lt.CommonUtil:show(self.btn)
		local minites = math.floor((data.expire_time - os.time()) / 60)
		if minites > 0 then
			self.stateLabel:setString(string.format(lt.Constants.TEXTS[2],minites))
		else
			self.stateLabel:setString(lt.Constants.TEXTS[4])
			lt.CommonUtil:hide(self.btn)
		end
		
	elseif data.state == lt.Constants.ROOM_STATE.GAME_PLAYING then
		self.stateLabel:setString(lt.Constants.TEXTS[3])
		lt.CommonUtil:show(self.btn)
	elseif data.state == lt.Constants.ROOM_STATE.GAME_OVER then
		self.stateLabel:setString(lt.Constants.TEXTS[4])
		lt.CommonUtil:hide(self.btn)
    else
       self.stateLabel:setString(lt.Constants.TEXTS[4])
        lt.CommonUtil:hide(self.btn) 
	end

	


end


return UITableViewItem