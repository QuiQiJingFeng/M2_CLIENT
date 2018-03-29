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
    self.roomNameLabel:setString("红中麻将")
   
    self.roomNumberLabel = cc.Label:createWithSystemFont("", "Helvetica", 20.0)
    self.roomNumberLabel:setColor(txtColor)
    self.roomNumberLabel:setOpacity(txtOpacity)
    self.roomNumberLabel:setAnchorPoint(cc.p(0.5, 0.5))
    self.roomNumberLabel:setPosition(cc.p(135, 40))
    self.roomNumberLabel:setAlignment(cc.TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    self:addChild(self.roomNumberLabel)
    self.roomNumberLabel:setString("747088\n(房主)")

    local btnPath = "hallcomm/lobby/img/myRoom_btn2.png"                              
    self.btn = ccui.Button:create(btnPath, btnPath, btnPath, 1)
    self.btn:setPosition(350, 40)           
    self:addChild(self.btn)

 
    self.stateLabel = cc.Label:createWithSystemFont("", "Helvetica", 20.0)
    self.stateLabel:setAnchorPoint(cc.p(0.5, 0.5))
    self.stateLabel:setPosition(cc.p(245, 40))
    self.stateLabel:setOpacity(txtOpacity)
    self.stateLabel:setAlignment(cc.TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    self:addChild(self.stateLabel)
    self.stateLabel:setString("未开始\n(剩余27分钟)")

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

--return cell size
function UITableViewItem:refreshData(data)
	
end


return UITableViewItem