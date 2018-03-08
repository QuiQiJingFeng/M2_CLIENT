--下拉菜单
local DropDown = class("DropDown", function()
	return display.newNode()
end)

DropDown._winScale = lt.CacheManager:getWinScale()

function DropDown:ctor()
    self:setNodeEventEnabled(true)
    self:setTouchSwallowEnabled(false)
    
	self._value = -1
	self._alignRight = false
    self._column = 3

    self._maskLayer = display.newLayer()
    self._maskLayer:setVisible(false)
    self:addChild(self._maskLayer)
    self._maskLayer:setNodeEventEnabled(true)
    self._maskLayer:setTouchSwallowEnabled(true)
    self._maskLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        self:closePanel()
        local ev = {}
        ev.item = self
        ev.visible = false
        if self._callback then
            self._callback(ev)
        end
        return false
    end)

	self._inputBg = lt.GameInfoBg.new(3, cc.size(124*self._winScale, 36))
    self:addChild(self._inputBg)
    self._inputBg:setTouchEnabled(true)
    self._inputBg:setNodeEventEnabled(true)
    self._inputBg:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))

    self._lblTitle = lt.GameLabel.new("",lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2, {outline=1})
    self._lblTitle:setPosition(self._inputBg:getContentSize().width/2-5*self._winScale,self._inputBg:getContentSize().height/2)
    self._inputBg:addChild(self._lblTitle)

    local iconDrop = display.newSprite("#stall_icon_drop_down.png")
    iconDrop:setPosition(self._inputBg:getContentSize().width-13*self._winScale, self._inputBg:getContentSize().height/2)
    self._inputBg:addChild(iconDrop)
end

function DropDown:onEnter()
    local worldPos = self:getParent():convertToWorldSpace(cc.p(self:getPositionX(),self:getPositionY()))
    self._maskLayer:setPosition(self:getPositionX()-worldPos.x,self._inputBg:getContentSize().height/2-worldPos.y)
    self._nodeIndex = lt.UIManager:addNode(self)
end

function DropDown:onExit()
    lt.UIManager:removeNode(self)
end

function DropDown:getNodeIndex()
    return self._nodeIndex
end

function DropDown:setColumn(col)
    if col <= 3 then
        return
    end
    self._column = col
end

function DropDown:setSource(stringTable,valueTable)
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
    local cellHeiht = 56
    local cellWidth = 120
    self._panel = lt.GamePanel.new(lt.GamePanel.TYPE.NEW_BLACK,0,0,cc.size((10+self._column*cellWidth)* self._winScale, (totalRow*cellHeiht+8) * self._winScale))
    self._panel:setAnchorPoint(0,1)
    self._panel:setPosition(self._inputBg:getPositionX()-68*self._winScale,self._inputBg:getPositionY()-10*self._winScale)
    if self._alignRight then
    	self._panel:setPosition(self._inputBg:getPositionX()-312*self._winScale,self._inputBg:getPositionY()-10*self._winScale)
    end
    self._panel:setVisible(false)
    self:addChild(self._panel)

    local index = 1
    for k,v in pairs(self._stringTable) do
    	local row = math.floor((index-1) / self._column)
    	local col = math.floor((index-1) % self._column)
    	local item = display.newSprite("#common_btn_newGray.png")
        item:setScale(self._winScale)
    	item:setAnchorPoint(0,1)
    	item:setPosition(7*self._winScale+cellWidth*col*self._winScale,self._panel:getContentSize().height-6*self._winScale-row*cellHeiht*self._winScale)
    	self._panel:addChild(item)

    	local lblTitle = lt.GameLabel.new(v,lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2, {outline=1})
		lblTitle:setPosition(item:getContentSize().width/2,item:getContentSize().height/2)
		item:addChild(lblTitle)

		item:setTag(k)
		item:setTouchEnabled(true)
    	item:setNodeEventEnabled(true)
   		item:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onItem))

   		self._itemTable[#self._itemTable+1] = item

    	index = index + 1
    end
end

function DropDown:setAlignRight()
	self._alignRight = true
	if self._panel then
		self._panel:setPosition(self._inputBg:getPositionX()-312*self._winScale,self._inputBg:getPositionY()-10*self._winScale)
	end
end

function DropDown:setCallback(callback)
	self._callback = callback
end

function DropDown:getOffsetY()
    if self._panel then
        return self._panel:getContentSize().height
    end
end

function DropDown:onTouch(event)
    if not self._panel then
    	return
    end
   	local ev = {}
    ev.item = self
    
    if self._panel:isVisible() then
    	self:closePanel()
        ev.visible = false
        if self._callback then
            self._callback(ev)
        end
    else
        ev.visible = true
        if self._callback then
            self._callback(ev)
        end
    	lt.UIManager:reorder(self)
    end
end

function DropDown:closePanel()
    if self._panel then
        self._panel:setVisible(false)
        self._maskLayer:setVisible(false)
    end
end

function DropDown:openPanel()
    if self._panel then
        self._panel:setVisible(true)
        self._maskLayer:setVisible(true)
    end
end

function DropDown:onItem(event)
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
            self:closePanel()
            local ev = {}
            ev.item = self
            ev.visible = false
            if self._callback then
                self._callback(ev)
            end
        end
    end
end

function DropDown:getSelectValue()
	return self._value
end

function DropDown:getSelectString()
	return self._lblTitle:getString()
end

function DropDown:setDefaultByValue(value)
    self._value = value
    local key
    if not self._valueTable then
        key = value
    else
        for k,v in pairs(self._valueTable) do
            if value == v then
                key = k
                break
            end
        end
    end
    self._lblTitle:setString(self._stringTable[key])
end

function DropDown:setDefaultByString(str)
    self._lblTitle:setString(str)
    local key
    for k,v in pairs(self._stringTable) do
        if v == str then
            key = k
            break
        end
    end

    if not self._valueTable then
        self._value = key
    else
        self._value = self._valueTable[key]
    end
end

function DropDown:clear()
    self._value = -1
    self._lblTitle:setString("")
end

return DropDown
