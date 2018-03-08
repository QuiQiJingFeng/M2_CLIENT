--数字键盘
local NumberKeyBoard = class("NumberKeyBoard", function()
    return display.newNode()
end)

NumberKeyBoard._winScale = lt.CacheManager:getWinScale()
NumberKeyBoard._numberMode = true -- 清除所有内容后为0 默认开启

function NumberKeyBoard:ctor()
    self:setNodeEventEnabled(true)
    self:setTouchSwallowEnabled(false)

    self._number = ""
    self._min = 0
    self._enabled = true
    self._alignLeft = false

    self._maskLayer = display.newLayer()
    self._maskLayer:setVisible(false)
    self:addChild(self._maskLayer)
    self._maskLayer:setNodeEventEnabled(true)
    self._maskLayer:setTouchSwallowEnabled(true)
    self._maskLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if self._number == "" then
            self:closePanel()
            return false
        end

        if not self._uncheck then
            local num = tonumber(self._number)
            if num < self._min then
                self._number = self._min
            end
            if self._max and num > self._max then
                self._number = self._max
            end
            self._lblText:setString(self._number)
        end
        self:closePanel()
        local ev = {}
        ev.item = self
        ev.visible = false
        if self._callback then
            self._callback(ev)
        end
        self._number = ""
        return false
    end)

	self._inputBg = lt.GameInfoBg.new(3, cc.size(124, 36))
    self:addChild(self._inputBg)
    self._inputBg:setTouchEnabled(true)
    self._inputBg:setNodeEventEnabled(true)
    self._inputBg:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))

    self._lblText = lt.GameLabel.new("",lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2,{outline=1})
    self._lblText:setPosition(self._inputBg:getContentSize().width/2,self._inputBg:getContentSize().height/2-1)
    self._inputBg:addChild(self._lblText)

    self._panel = display.newSprite("image/ui/common/keyboard_bg.png")
    self._panel:setAnchorPoint(0.5, 0)
    self._panel:setVisible(false)
    self:addChild(self._panel)

    for i=1,9 do
        local row = math.ceil(i / 3) - 1
        local col = (i+2) % 3

        local scaleButton = lt.ScaleButton.new("#common_btn_small.png")
        scaleButton:setTag(i)
        scaleButton:onButtonPressed(handler(self, self.onNumber))
        scaleButton:setPosition(48+col*72,self._panel:getContentSize().height-46-row*72)
        self._panel:addChild(scaleButton)

        local lblNumber = lt.GameLabel.new(i,34, lt.Constants.DEFAULT_LABEL_COLOR_2,{outline=1})
        lblNumber:setPosition(scaleButton:getContentSize().width/2,scaleButton:getContentSize().height/2)
        scaleButton:addChild(lblNumber)
    end

    for i=1,3 do
        local scaleButton = lt.ScaleButton.new("#common_btn_big.png")
        scaleButton:setTag(i)
        scaleButton:onButtonPressed(handler(self, self.onFunction))
        scaleButton:setPosition(self._panel:getContentSize().width-68,self._panel:getContentSize().height-46-(i-1)*72)
        self._panel:addChild(scaleButton)

        if i == 1 then
            local iconDelete = display.newSprite("#common_btn_delete.png")
            iconDelete:setPosition(scaleButton:getContentSize().width/2,scaleButton:getContentSize().height/2)
            scaleButton:addChild(iconDelete)
        elseif i == 2 then
            local lblNumber = lt.GameLabel.new("0",34, lt.Constants.DEFAULT_LABEL_COLOR_2,{outline=1})
            lblNumber:setPosition(scaleButton:getContentSize().width/2,scaleButton:getContentSize().height/2)
            scaleButton:addChild(lblNumber)
        else
            local lblOk = lt.GameLabel.newString("STRING_COMMON_OK",34, lt.Constants.DEFAULT_LABEL_COLOR_2,{outline=1})
            lblOk:setPosition(scaleButton:getContentSize().width/2,scaleButton:getContentSize().height/2)
            scaleButton:addChild(lblOk)
        end

    end
end

function NumberKeyBoard:onEnter()
    local worldPos = self:getParent():convertToWorldSpace(cc.p(self:getPositionX(),self:getPositionY()))
    self._maskLayer:setPosition(self:getPositionX()-worldPos.x,self._inputBg:getContentSize().height/2-worldPos.y)
    self._nodeIndex = lt.UIManager:addNode(self)
end

function NumberKeyBoard:onExit()
    lt.UIManager:removeNode(self)
end

function NumberKeyBoard:setNumberMode(numberMode)
    self._numberMode = numberMode
end

function NumberKeyBoard:getNodeIndex()
    return self._nodeIndex
end

function NumberKeyBoard:setPosition(x,y)
    self._inputBg:setPosition(x, y)
    self._panel:setPosition(self._inputBg:getPositionX(),self._inputBg:getPositionY()+15)
    if self._alignLeft then
        self._panel:setPositionX(self._inputBg:getPositionX()-self._inputBg:getContentSize().width/2)
    end
end
    
function NumberKeyBoard:getPositionX()
    return self._inputBg:getPositionX()
end

function NumberKeyBoard:getPositionY()
    return self._inputBg:getPositionY()
end

function NumberKeyBoard:getPosition()
    return self._inputBg:getPosition()
end

function NumberKeyBoard:setSize(size)
    if not size.width or not size.height then
        return
    end

    local originText = self:getText()
    self._inputBg:removeFromParent()

    self._inputBg = lt.GameInfoBg.new(3, cc.size(size.width, size.height))
    self:addChild(self._inputBg)
    self._inputBg:setTouchEnabled(true)
    self._inputBg:setNodeEventEnabled(true)
    self._inputBg:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))

    self._lblText = lt.GameLabel.new("",lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2,{outline=1})
    self._lblText:setString(originText)
    self._lblText:setPosition(self._inputBg:getContentSize().width/2,self._inputBg:getContentSize().height/2-1)
    self._inputBg:addChild(self._lblText)
end

function NumberKeyBoard:setListener(listener)
	self._listener = listener
end

function NumberKeyBoard:setCallback(callback)
    self._callback = callback
end

function NumberKeyBoard:setCallback2(callback)
    self._callback2 = callback
end

function NumberKeyBoard:uncheck()
    self._uncheck = true
end

function NumberKeyBoard:onTouch(event) 
    if not self._enabled then
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
        self._number = ""
    else
        ev.visible = true
        if self._callback then
            self._callback(ev)
        end
        lt.UIManager:reorder(self)
    end
end

function NumberKeyBoard:closePanel()
    if self._panel then
        self._panel:setVisible(false)
        self._maskLayer:setVisible(false)
    end
end

function NumberKeyBoard:openPanel()
    if self._panel then
        self._panel:setVisible(true)
        self._maskLayer:setVisible(true)
    end
end

function NumberKeyBoard:setMin(min)
    if min < 0 then
        return
    end
    self._min = min
end

function NumberKeyBoard:setMax(max)
    self._max = max
end

function NumberKeyBoard:setEnabled(enabled)
    self._enabled = enabled
end

function NumberKeyBoard:onNumber(event)
    local number = event.target:getTag()

    if self._numberMode then
        -- 数字输入
        if self._number == "0" then
            self._number = ""
        end
        self._number = self._number..number

        self._clear = false

        if self._number ~= "" then
            local num = tonumber(self._number)
            if self._max and num > self._max then
                self._number = self._max
                if self._callback2 then
                    self._callback2()
                    self._clear = true
                end
            end
        end
    else
        -- 普通输入(文本)
        self._number = self._number..number

        self._clear = false
    end

    if self._lblPlaceHolder then
        self._lblPlaceHolder:setVisible(false)
    end
    
    self._lblText:setString(self._number)

    local event = {}
    event.name = "edit"
    event.item = self
    if self._listener then
        self._listener(event)
        if self._clear then
            self._number = ""
        end
    end
end

function NumberKeyBoard:onFunction(event)
    local tag = event.target:getTag()
    if self._lblPlaceHolder then
        self._lblPlaceHolder:setVisible(false)
    end
    if tag == 1 then -- delete
        self._number = string.sub(self._number, 0, string.len(self._number)-1) 
        if self._numberMode then
            if self._number == "" then
                self._number = "0"
            end
            -- self._number = tonumber(self._number)
        else
        
        end

        self._lblText:setString(self._number)

        local event = {}
        event.name = "edit"
        event.item = self
        if self._listener then
            self._listener(event)
        end
        return
    end

    if tag == 2 then -- number 0
        if self._numberMode then
            -- 数字输入
            
            if self._number == "0" or self._number == 0 then
                self._number = ""
            end
            self._number = self._number.."0"
            self._clear = false

            local num = tonumber(self._number)
            if self._max and num > self._max then
                self._number = self._max
                if self._callback2 then
                    self._callback2()
                    self._clear = true
                end
            end
        else
            -- 普通输入(文本)
            self._number = self._number.."0"
            self._clear = false
        end
        
        self._lblText:setString(self._number)

        local event = {}
        event.name = "edit"
        event.item = self
        if self._listener then
            self._listener(event)
            if self._clear then
                self._number = ""
            end
        end
        return
    end

    if tag == 3 then -- ok
        if self._numberMode then
            -- 数字输入
            local num = tonumber(self._number)
            if num == nil then
                num = 0
                self._number = "0"
            end
            if not self._uncheck then
                if num < self._min then
                    self._number = self._min
                end
                if self._max and num > self._max then
                    self._number = self._max
                end

                self._lblText:setString(self._number)

            end
        else
            -- 普通输入(文本)
        end
        self:closePanel()

        local event = {}
        event.name = "end"
        event.item = self
        if self._listener then
            self._listener(event)
        end

        local ev = {}
        ev.item = self
        ev.visible = false
        if self._callback then
            self._callback(ev)
        end
        self._number = ""
        return
    end
end

function NumberKeyBoard:setText(text,notclearnum)
	self._lblText:setString(text)
    if not notclearnum then
        self._number = ""
    end
end

function NumberKeyBoard:setPlaceHolder(text)
    if not self._lblPlaceHolder then
        self._lblPlaceHolder = lt.GameLabel.new(text,lt.Constants.FONT_SIZE4, lt.Constants.DEFAULT_LABEL_COLOR_2,{outline=1})
        self._lblPlaceHolder:setPosition(self._inputBg:getContentSize().width/2,self._inputBg:getContentSize().height/2-1)
        self._inputBg:addChild(self._lblPlaceHolder)
    else
        self._lblPlaceHolder:setVisible(true)
    end
end

function NumberKeyBoard:getText()
	return self._lblText:getString()
end

function NumberKeyBoard:setNumber(number)
    self._number = number
end

function NumberKeyBoard:getNumber()
    return self._number
end

function NumberKeyBoard:setFontColor(color3b)
    self._lblText:setTextColor3B(color3b)
end

function NumberKeyBoard:getOffsetY()
    if self._panel then
        return self._panel:getContentSize().height + 15
    end
end

function NumberKeyBoard:flipY()
    self._panel:setFlippedY(true)
    self._panel:setAnchorPoint(0.5, 1)
    self._panel:setPosition(self._inputBg:getPositionX(),self._inputBg:getPositionY()-15)
    for k,v in pairs(self._panel:getChildren()) do
        v:setPositionY(v:getPositionY()-35)
    end
    if self._alignLeft then
        self._panel:setPositionX(self._inputBg:getPositionX()-self._inputBg:getContentSize().width/2)
    end
end

function NumberKeyBoard:alignLeft()
    self._alignLeft = true
    self._panel:setPositionX(self._inputBg:getPositionX()-self._inputBg:getContentSize().width/2)
end

return NumberKeyBoard
