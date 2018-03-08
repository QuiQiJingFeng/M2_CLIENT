local DropItem = class("DropItem", function()
    return display.newSprite("#common_btn_newGray.png")
end)

DropItem._winScale = lt.CacheManager:getWinScale()

function DropItem:ctor(value,string)
    self._value = value
    self._string = string

    local lblTitle = lt.GameLabel.new(string,lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
    lblTitle:setPosition(self:getContentSize().width/2,self:getContentSize().height/2)
    self:addChild(lblTitle)

    self._iconSelect = display.newSprite("#friend_btn_right.png")
    self._iconSelect:setPosition(self:getContentSize().width-20*self._winScale,self:getContentSize().height-20*self._winScale)
    self._iconSelect:setVisible(false)
    self:addChild(self._iconSelect)
end

function DropItem:select()
    if self._iconSelect:isVisible() then
        self._iconSelect:setVisible(false)
    else
        self._iconSelect:setVisible(true)
    end
end

function DropItem:clear()
    self._iconSelect:setVisible(false)
end

function DropItem:isSelected()
    return self._iconSelect:isVisible()
end

function DropItem:getValue()
    return self._value
end

function DropItem:getString()
    return self._string
end


--下拉菜单
local MultipleDropDown = class("MultipleDropDown", function()
	return display.newNode()
end)

MultipleDropDown._winScale = lt.CacheManager:getWinScale()

function MultipleDropDown:ctor()
    self:setTouchEnabled(true)
    self:setNodeEventEnabled(true)
    self:setTouchSwallowEnabled(true)

	self._valueArray = {}
    self._stringArray = {}
	self._alignRight = false
	self._inputBg = lt.GameInfoBg.new(3, cc.size(535*self._winScale, 36))
    self._inputBg:setAnchorPoint(0,0.5)
    self:addChild(self._inputBg)
    self._inputBg:setTouchEnabled(true)
    self._inputBg:setNodeEventEnabled(true)
    self._inputBg:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))

    self._lblTitle = lt.GameLabel.new("",lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
    self._lblTitle:setScale(self._winScale)
    self._lblTitle:setAnchorPoint(0,0.5)
    self._lblTitle:setPosition(10*self._winScale,self._inputBg:getContentSize().height/2)
    self._inputBg:addChild(self._lblTitle)

    local iconDrop = display.newSprite("#stall_icon_drop_down.png")
    iconDrop:setPosition(self._inputBg:getContentSize().width-13*self._winScale, self._inputBg:getContentSize().height/2)
    self._inputBg:addChild(iconDrop)
end

function MultipleDropDown:onExit()
    if self._panel then
        lt.SceneManager:removeLayer(self._panel)
    end
end

function MultipleDropDown:getOffsetY()
    return 0
end

function MultipleDropDown:setSource(stringTable,valueTable)
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
    local totalRow = math.ceil(len / 4)
    local cellHeiht = 56
    local cellWidth = 120
    self._panel = lt.GamePanel.new(lt.GamePanel.TYPE.NEW_BGWHITE,display.cx,display.cy,cc.size(516 * self._winScale, 506 * self._winScale))
    self._panel:setVisible(false)
    lt.SceneManager:addLayer(self._panel)

    local blackBg = lt.GamePanel.new(lt.GamePanel.TYPE.NEW_BLACK,self._panel:getContentSize().width/2,self._panel:getContentSize().height/2,cc.size(500 * self._winScale,  490* self._winScale))
    self._panel:addChild(blackBg)

    self._scrollView = cc.ui.UIScrollView.new({viewRect = cc.rect(0, 90*self._winScale, blackBg:getContentSize().width, blackBg:getContentSize().height - 100*self._winScale), direction = cc.ui.UIScrollView.DIRECTION_VERTICAL})
    blackBg:addChild(self._scrollView)
    self._scrollView:setPosition(0, 0)
    self._scrollView:onScroll(handler(self,self.onItem))

    self._infoNode = display.newNode()
    self._infoNode:setPosition(self._scrollView:getViewRect().x, self._scrollView:getViewRect().y)
    self._scrollView:addScrollNode(self._infoNode)

    local index = 1
    for k,v in pairs(self._stringTable) do
    	local row = math.floor((index-1) / 4)
    	local col = math.floor((index-1) % 4)
    	local item = DropItem.new(k,v)
        item:setScale(self._winScale)
    	item:setAnchorPoint(0,1)
    	item:setPosition(10*self._winScale+cellWidth*col*self._winScale,blackBg:getContentSize().height-100*self._winScale-row*cellHeiht*self._winScale)
    	self._infoNode:addChild(item)

   		self._itemTable[#self._itemTable+1] = item

    	index = index + 1
    end

    self._infoNode:setContentSize(self._scrollView:getViewRect().width,self._scrollView:getViewRect().height)
    self._infoNode:setPosition(self._scrollView:getViewRect().x, self._scrollView:getViewRect().y)

    local btnCancel = lt.ScaleLabelButton.newRed("STRING_COMMON_CANCEL")
    btnCancel:setScale(self._winScale)
    btnCancel:onButtonPressed(handler(self, self.onClickCancel))
    btnCancel:setPosition(blackBg:getContentSize().width/2-150*self._winScale,50*self._winScale)
    blackBg:addChild(btnCancel)

    local btnReset = lt.ScaleLabelButton.newYellow("STRING_RESET")
    btnReset:setScale(self._winScale)
    btnReset:onButtonPressed(handler(self, self.onClickReset))
    btnReset:setPosition(blackBg:getContentSize().width/2,50*self._winScale)
    blackBg:addChild(btnReset)

    local btnCancel = lt.ScaleLabelButton.newYellow("STRING_COMMON_COMMIT")
    btnCancel:setScale(self._winScale)
    btnCancel:onButtonPressed(handler(self, self.onClickOk))
    btnCancel:setPosition(blackBg:getContentSize().width/2+150*self._winScale,50*self._winScale)
    blackBg:addChild(btnCancel)
end

function MultipleDropDown:setCallback(callback)
	self._callback = callback
end


function MultipleDropDown:onTouch(event)
    if not self._panel then
    	return
    end
   	
    if self._panel:isVisible() then
    	self._panel:setVisible(false)
    else
        local ev = {}
        ev.item = self
    	if self._callback then
    		self._callback(ev)
   		end
    	self._panel:setVisible(true)
    end
end

function MultipleDropDown:closeDrop()
    if self._panel then
	   self._panel:setVisible(false)
    end
end

function MultipleDropDown:onItem(event)
    if "clicked" == event.name then
    	for k,v in pairs(self._itemTable) do
            local worldPos = v:getParent():convertToWorldSpace(cc.p(v:getPosition()))
            local worldRect = cc.rect(worldPos.x,worldPos.y,112*self._winScale,44*self._winScale)
            if cc.rectContainsPoint(worldRect, cc.p(event.x, event.y+56)) then
                if self:getCount() >= 5 and not v:isSelected() then
                    lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_STALL_TIPS_96"))
                    return
                end
                v:select()
                if v:isSelected() then
                    self._valueArray[v:getValue()] = self._valueTable[v:getValue()]
                    self._stringArray[v:getValue()] = v:getString()
                else
                    self._valueArray[v:getValue()] = nil
                    self._stringArray[v:getValue()] = nil
                end
            end
        end
    end
end

function MultipleDropDown:getSelectValueArray()
	return self._valueArray
end

function MultipleDropDown:onClickCancel()
    self._panel:setVisible(false)
end

function MultipleDropDown:onClickReset()
    self._lblTitle:setString("")
    self._valueArray = {}
    self._stringArray = {}
    for k,v in pairs(self._itemTable) do
        v:clear()
    end
end

function MultipleDropDown:onClickOk()
    local str = ""
    for k,v in pairs(self._stringArray) do
        str = str .. v .. " "
    end
    self._lblTitle:setString(str)
    self._panel:setVisible(false)
end

function MultipleDropDown:getCount()
    local count = 0
    for k,v in pairs(self._valueArray) do
        count = count + 1
    end
    return count
end

function MultipleDropDown:clear()
    self._valueArray = {}
    self._stringArray = {}
    self._lblTitle:setString("")
    if self._itemTable then
        for k,v in pairs(self._itemTable) do
            v:clear()
        end
    end
end

function MultipleDropDown:setDefaultByValueArray(valueArray)
    for _,v in pairs(valueArray) do
        local key = self:getKey(v)
        if key ~= -1 then
            self._valueArray[key] = v
            self._stringArray[key] = self._stringTable[key]
        end
    end
    local str = ""
    for k,v in pairs(self._stringArray) do
        str = str .. v .. " "
    end
    self._lblTitle:setString(str)

    for k,v in pairs(self._itemTable) do
        if self:exist(v:getValue()) then
            v:select()
        end
    end

end

function MultipleDropDown:exist(key)
    for k,v in pairs(self._valueArray) do
        if key == k then
            return true
        end
    end
    return false
end

function MultipleDropDown:getKey(value)
    for k,v in pairs(self._valueTable) do
        if value == v then
            return k
        end
    end
    return -1
end

return MultipleDropDown
