--下拉按钮菜单
local DropButton = class("DropButton", function()
	return display.newNode()
end)

DropButton._winScale = lt.CacheManager:getWinScale()

function DropButton:ctor(red,params)
    self:setTouchEnabled(true)
    self:setNodeEventEnabled(true)
    self:setTouchSwallowEnabled(true)
    
	self._value = -1
	self._alignRight = false
    self._column = 1
    self._changeIcon = false
    self._iconAlignRight = false
    self._enable = true

    if params and params.iconAlignRight then
        self._iconAlignRight = params.iconAlignRight
    end

    if params and params.yellow then
        self._inputBg = display.newScale9Sprite("#equip_img_autobg.png", 5, 5, cc.size(200,60))
        if params.size then
            self._inputBg:setPreferredSize(params.size)
        end
    else
        if red then
            self._inputBg = display.newSprite("#common_btn_yellow_new.png")
        else
            self._inputBg = display.newSprite("#common_btn_newGray.png")
        end
    end

    self._inputBg:setScale(self._winScale)
    self:addChild(self._inputBg)
    self._inputBg:setTouchEnabled(true)
    self._inputBg:setNodeEventEnabled(true)
    self._inputBg:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))

    self._node = display.newNode()
    self._node:setPosition(self._inputBg:getContentSize().width/2,self._inputBg:getContentSize().height/2)
    self._inputBg:addChild(self._node)

    self._lblTitle = lt.GameLabel.new("",lt.Constants.FONT_SIZE4, lt.Constants.COLOR.WHITE,{outline = true,outlineColor = lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
    self._lblTitle:setPosition(-10,0)
    self._node:addChild(self._lblTitle)

    self._iconDrop = display.newSprite("#stall_icon_drop_down.png")
    self._iconDrop:setAnchorPoint(0,0.5)
    
    if self._iconAlignRight then
        self._lblTitle:setPosition(0,0)
        self._iconDrop:setPosition(self._inputBg:getContentSize().width-32*self._winScale,self._inputBg:getContentSize().height/2)
        self._inputBg:addChild(self._iconDrop)
    else
        self._iconDrop:setPosition(self._lblTitle:getContentSize().width/2,0)
        self._node:addChild(self._iconDrop)
    end
end

function DropButton:setColumn(col)
    if col <= 1 then
        return
    end
    self._column = col
end

function DropButton:setIcon(upIcon,downIcon)
    self._upIcon = upIcon
    self._downIcon = downIcon

    local frame = display.newSpriteFrame(self._upIcon)
    if frame then
        self._iconDrop:setSpriteFrame(frame)
    end
end

function DropButton:setDefaultByString(str)
    local key = -1
    for k,v in pairs(self._stringTable) do
        if v == str then
            key = k
            break
        end
    end
    if self._valueTable then
        self._value = self._valueTable[key]
    else
        self._value = key
    end
    self._lblTitle:setString(str)
    if not self._iconAlignRight then
        self._iconDrop:setPosition(self._lblTitle:getPositionX()+self._lblTitle:getContentSize().width/2,0)
    end
end

function DropButton:setDefaultByValue(value)
    self._value = value
    self._lblTitle:setString(self._stringTable[value])
    if not self._iconAlignRight then
        self._iconDrop:setPosition(self._lblTitle:getPositionX()+self._lblTitle:getContentSize().width/2,0)
    end

    if self._upIcon and self._value == 1 then
        local frame = display.newSpriteFrame(self._upIcon)
        if frame then
            self._iconDrop:setSpriteFrame(frame)
        end
    end

    if self._downIcon and self._value == 2 then
        local frame = display.newSpriteFrame(self._downIcon)
        if frame then
            self._iconDrop:setSpriteFrame(frame)
        end
    end
end

function DropButton:setSource(stringTable,valueTable)
	self._stringTable = stringTable
	self._valueTable = valueTable

	if not self._stringTable then
    	return
    end
    self._itemTable = {}
    local len = 0
    for k,v in pairs(self._stringTable) do
    	len = len + 1
    end
    local totalRow = math.ceil(len / self._column)
    local cellHeiht = 60
    local cellWidth = 120*self._winScale
    self._panel = lt.GamePanel.new(lt.GamePanel.TYPE.NEW_BLACK,0,0,cc.size((10+self._column*cellWidth), (totalRow*cellHeiht+8) * self._winScale))
    self._panel:setAnchorPoint(0,1)
    self._panel:setPosition(self._inputBg:getPositionX()-self._inputBg:getContentSize().width/2-9,self._inputBg:getPositionY()-self._inputBg:getContentSize().height/2+15)
    if self._alignRight then
    	self._panel:setPosition(self._inputBg:getPositionX()-312*self._winScale,self._inputBg:getPositionY()-15*self._winScale)
    end
    self._panel:setVisible(false)
    self:addChild(self._panel)

    local index = 1
    for k,v in pairs(self._stringTable) do
    	local row = math.floor((index-1) / self._column)
    	local col = math.floor((index-1) % self._column)
    	local item = display.newSprite("#common_btn_blue_new.png")
        item:setScale(self._winScale)
    	item:setAnchorPoint(0,1)
    	item:setPosition(10*self._winScale+cellWidth*col,self._panel:getContentSize().height-6*self._winScale-row*cellHeiht*self._winScale)
    	self._panel:addChild(item)

    	local lblTitle = lt.GameLabel.new(v,lt.Constants.FONT_SIZE4, lt.Constants.COLOR.WHITE,{outline=true,outlineColor=lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
		lblTitle:setPosition(item:getContentSize().width/2,item:getContentSize().height/2)
		item:addChild(lblTitle)

        if self._upIcon and index == 1 then
            local upIcon = display.newSprite("#"..self._upIcon)
            upIcon:setPosition(lblTitle:getPositionX()+lblTitle:getContentSize().width/2+12*self._winScale,lblTitle:getPositionY())
            item:addChild(upIcon)

            lblTitle:setPositionX(lblTitle:getPositionX()-upIcon:getContentSize().width/2)
            upIcon:setPositionX(upIcon:getPositionX()-upIcon:getContentSize().width/2)
        end

        if self._downIcon and index == 2 then
            local downIcon = display.newSprite("#"..self._downIcon)
            downIcon:setPosition(lblTitle:getPositionX()+lblTitle:getContentSize().width/2+12*self._winScale,lblTitle:getPositionY())
            item:addChild(downIcon)

            lblTitle:setPositionX(lblTitle:getPositionX()-downIcon:getContentSize().width/2)
            downIcon:setPositionX(downIcon:getPositionX()-downIcon:getContentSize().width/2)
        end

		item:setTag(k)
		item:setTouchEnabled(true)
    	item:setNodeEventEnabled(true)
   		item:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onItem))

   		self._itemTable[#self._itemTable+1] = item

    	index = index + 1
    end
end

function DropButton:onEnter()
    self._nodeIndex = lt.UIManager:addNode(self)
end

function DropButton:onExit()
    lt.UIManager:removeNode(self)
end

function DropButton:getNodeIndex()
    return self._nodeIndex
end

function DropButton:closePanel()
    if self._panel then
        self._panel:setVisible(false)
    end
end

function DropButton:openPanel()
    if self._panel then
        self._panel:setVisible(true)
    end
end

function DropButton:setAlignRight()
	self._alignRight = true
	if self._panel then
		self._panel:setPosition(self._inputBg:getPositionX()-312,self._inputBg:getPositionY()-15*self._winScale)
	end
end

function DropButton:setCallback(callback)
	self._callback = callback
end

function DropButton:getOffsetY()
    if self._panel then
        return self._panel:getContentSize().height
    end
end

function DropButton:onTouch(event)
    if not self._enable then
        return
    end

    if not self._panel then
    	return
    end
    
    if self._panel:isVisible() then
    	self._panel:setVisible(false)
    else
        local ev = {}
        ev.item = self
        ev.name = "began"
        if self._callback then
            self._callback(ev)
        end
    	self._panel:setVisible(true)
        lt.UIManager:reorder(self)
    end
end

function DropButton:closeDrop()
    if self._panel then
	   self._panel:setVisible(false)
    end
end

function DropButton:onItem(event)
	for k,v in pairs(self._itemTable) do
        local worldPos = v:getParent():convertToWorldSpace(cc.p(v:getPosition()))
        local worldRect = cc.rect(worldPos.x,worldPos.y,112*self._winScale,44*self._winScale)
        if cc.rectContainsPoint(worldRect, cc.p(event.x, event.y+56)) then
            local key = v:getTag()
            if not self._valueTable then
            	self._value = key
            else
            	self._value = self._valueTable[key]
            end
            self._lblTitle:setString(self._stringTable[key])

            if self._upIcon and self._value == 1 then
                local frame = display.newSpriteFrame(self._upIcon)
                if frame then
                    self._iconDrop:setSpriteFrame(frame)
                end
            end

            if self._downIcon and self._value == 2 then
                local frame = display.newSpriteFrame(self._downIcon)
                if frame then
                    self._iconDrop:setSpriteFrame(frame)
                end
            end
            if not self._iconAlignRight then
                self._iconDrop:setPosition(self._lblTitle:getPositionX()+self._lblTitle:getContentSize().width/2,0)
            end

            self._panel:setVisible(false)
            local ev = {}
            ev.item = self
            ev.visible = false
            ev.name = "clicked"
            if self._callback then
                self._callback(ev)
            end
        end
    end
end

function DropButton:setEnable(enable)
    if not enable then
        self._iconDrop:setVisible(false)
    end
    self._enable = enable
end

function DropButton:getSelectValue()
	return self._value
end

function DropButton:getSelectString()
	return self._lblTitle:getString()
end

function DropButton:clear()
    self._value = -1
    self._lblTitle:setString("")
end

return DropButton
