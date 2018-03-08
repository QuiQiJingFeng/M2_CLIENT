local DropItem = class("DropItem", lt.ServantCharacterIcon)

DropItem._winScale = lt.CacheManager:getWinScale()

function DropItem:ctor()
    self._iconSelect = display.newSprite("#friend_btn_right.png")
    self._iconSelect:setPosition(self:getContentSize().width-20*self._winScale,self:getContentSize().height-20*self._winScale)
    self._iconSelect:setVisible(false)
    self:addChild(self._iconSelect,100)
end

function DropItem:updateInfo(id)
    DropItem.super.updateInfo(self,id)
    local servantCharacterInfo = lt.CacheManager:getServantCharacter(id)
    self._value = id
    self._string = servantCharacterInfo:getName()
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


--特性列表框,不通用
local RichMultiDropDown = class("RichMultiDropDown", function()
	return display.newNode()
end)

RichMultiDropDown._winScale = lt.CacheManager:getWinScale()

function RichMultiDropDown:ctor()
    self:setTouchEnabled(true)
    self:setNodeEventEnabled(true)
    self:setTouchSwallowEnabled(true)

	self._valueArray = {}
    self._stringArray = {}
	self._alignRight = false
	self._inputBg = lt.GameInfoBg.new(3, cc.size(500*self._winScale, 36))
    self._inputBg:setAnchorPoint(0,0.5)
    self:addChild(self._inputBg)
    self._inputBg:setTouchEnabled(true)
    self._inputBg:setNodeEventEnabled(true)
    self._inputBg:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))

    self._lblTitle = lt.GameLabel.new("",lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
    self._lblTitle:setScale(self._winScale)
    self._lblTitle:setAnchorPoint(0,0.5)
    self._lblTitle:setPosition(10*self._winScale,self._inputBg:getContentSize().height/2)
    self._lblTitle:setDimensions(490*self._winScale,30)
    self._inputBg:addChild(self._lblTitle)

    local iconDrop = display.newSprite("#stall_icon_drop_down.png")
    iconDrop:setPosition(self._inputBg:getContentSize().width-13*self._winScale, self._inputBg:getContentSize().height/2)
    self._inputBg:addChild(iconDrop)


    local servantCharacterTable = lt.CacheManager:getServantCharacterTable()
    local newServantCharacterTable = {}
    local len = 0
    for k,v in pairs(servantCharacterTable) do
        newServantCharacterTable[#newServantCharacterTable+1] = v
    end
    local totalRow = math.ceil(len / 5)
    local cellHeiht = 90
    local cellWidth = 90
    self._panel = lt.GamePanel.new(lt.GamePanel.TYPE.NEW_BGWHITE,display.cx,display.cy,cc.size(516 * self._winScale, 516 * self._winScale))
    self._panel:setVisible(false)
    lt.SceneManager:addLayer(self._panel)

    local blackBg = lt.GamePanel.new(lt.GamePanel.TYPE.NEW_BLACK,self._panel:getContentSize().width/2,self._panel:getContentSize().height/2,cc.size(500 * self._winScale,  500* self._winScale))
    self._panel:addChild(blackBg)

    local whiteBg = lt.GamePanel.new(lt.GamePanel.TYPE.NEW_WHITE,blackBg:getContentSize().width/2,blackBg:getContentSize().height/2+20*self._winScale,cc.size(492 * self._winScale,  380* self._winScale))
    blackBg:addChild(whiteBg)

    self._lblTips = lt.GameLabel.new("",lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2,{outline=1})
    self._lblTips:setScale(self._winScale)
    self._lblTips:setAnchorPoint(0,0.5)
    self._lblTips:setPosition(15*self._winScale,blackBg:getContentSize().height - 30*self._winScale)
    self._lblTips:setDimensions(490*self._winScale,35)
    blackBg:addChild(self._lblTips)

    self._scrollView = cc.ui.UIScrollView.new({viewRect = cc.rect(0, 10*self._winScale, whiteBg:getContentSize().width, whiteBg:getContentSize().height - 20*self._winScale), direction = cc.ui.UIScrollView.DIRECTION_VERTICAL})
    whiteBg:addChild(self._scrollView)
    self._scrollView:setPosition(0, 0)
    self._scrollView:onScroll(handler(self,self.onItem))

    self._infoNode = display.newNode()
    self._infoNode:setPosition(self._scrollView:getViewRect().x, self._scrollView:getViewRect().y)
    self._scrollView:addScrollNode(self._infoNode)


    table.sort(newServantCharacterTable, function(servant1,servant2)
        return servant1:getId() < servant2:getId()
    end )


    self._itemTable = {}
    local index = 1
    for k,v in pairs(newServantCharacterTable) do
        local row = math.floor((index-1) / 5)
        local col = math.floor((index-1) % 5)
        local itemIcon = DropItem.new()
        itemIcon:setScale(self._winScale)
        itemIcon:updateInfo(v:getId())
        itemIcon:setAnchorPoint(0,1)
        itemIcon:setPosition(30*self._winScale+cellWidth*col*self._winScale,whiteBg:getContentSize().height-20*self._winScale-row*cellHeiht*self._winScale)
        self._infoNode:addChild(itemIcon)

        self._itemTable[#self._itemTable+1] = itemIcon

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

function RichMultiDropDown:onExit()
    if self._panel then
        lt.SceneManager:removeLayer(self._panel)
    end
end

function RichMultiDropDown:getOffsetY()
    return 0
end

function RichMultiDropDown:setCallback(callback)
	self._callback = callback
end


function RichMultiDropDown:onTouch(event)
    if not self._panel then
    	return
    end
   	
    if self._panel:isVisible() then
        local ev = {}
        ev.item = self
        ev.visible = false
        if self._callback then
            self._callback(ev)
        end
    	self._panel:setVisible(false)
    else
        local ev = {}
        ev.item = self
        ev.visible = true
    	if self._callback then
    		self._callback(ev)
   		end
    	self._panel:setVisible(true)
    end
end

function RichMultiDropDown:closeDrop()
    if self._panel then
	   self._panel:setVisible(false)
    end
end

function RichMultiDropDown:onItem(event)
    if "clicked" == event.name then
    	for k,v in pairs(self._itemTable) do
            local worldPos = v:getParent():convertToWorldSpace(cc.p(v:getPosition()))
            local worldRect = cc.rect(worldPos.x,worldPos.y-45*self._winScale,112*self._winScale,90*self._winScale)
            if cc.rectContainsPoint(worldRect, cc.p(event.x, event.y+56)) then
                if self:getCount() >= 16 and not v:isSelected() then
                    lt.TipsLayer:tipsOn(lt.StringManager:getString("STRING_STALL_TIPS_86"))
                    return
                end
                v:select()

                if v:isSelected() then
                    table.insert(self._valueArray,1,v:getValue())
                    table.insert(self._stringArray,1,v:getString()) 
                else
                    local idx = self:getIndexOfArray(v:getValue())
                    table.remove(self._valueArray,idx)
                    table.remove(self._stringArray,idx)
                end
                local str = ""
                for k,v in pairs(self._stringArray) do
                    str = str .. v .. " "
                end
                self._lblTips:setString(str)
            end
        end
    end
end

function RichMultiDropDown:getIndexOfArray(value)
    for k,v in pairs(self._valueArray) do
        if v == value then
            return k
        end
    end
end

function RichMultiDropDown:getSelectValueArray()
	return self._valueArray
end

function RichMultiDropDown:onClickCancel()
    local ev = {}
    ev.item = self
    ev.visible = false
    if self._callback then
        self._callback(ev)
    end
    self._panel:setVisible(false)
end

function RichMultiDropDown:onClickReset()
    self._lblTitle:setString("")
    self._lblTips:setString("")
    self._valueArray = {}
    self._stringArray = {}
    for k,v in pairs(self._itemTable) do
        v:clear()
    end
end

function RichMultiDropDown:onClickOk()
    local str = ""
    for k,v in pairs(self._stringArray) do
        str = str .. v .. " "
    end
    self._lblTitle:setString(str)
    local ev = {}
    ev.item = self
    ev.visible = false
    if self._callback then
        self._callback(ev)
    end
    self._panel:setVisible(false)
end

function RichMultiDropDown:getCount()
    return #self._valueArray
end

function RichMultiDropDown:clear()
    self._valueArray = {}
    self._stringArray = {}
    self._lblTitle:setString("")
    self._lblTips:setString("")
    if self._itemTable then
        for k,v in pairs(self._itemTable) do
            v:clear()
        end
    end
end

function RichMultiDropDown:setDefaultByCharacterArray(characterArray)
    for _,id in pairs(characterArray) do
        table.insert(self._valueArray,1,id)
        self:initString(id)
    end
end

function RichMultiDropDown:initString(id)
    for _,item in pairs(self._itemTable) do
        if item:getValue() == id then
            table.insert(self._stringArray,1,item:getString()) 
            item:select()
        end
    end

    local str = ""
    for k,v in pairs(self._stringArray) do
        str = str .. v .. " "
    end
    self._lblTips:setString(str)
    self._lblTitle:setString(str)
end

return RichMultiDropDown
