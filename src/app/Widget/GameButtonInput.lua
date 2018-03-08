--点击输入框
local GameButtonInput = class("GameButtonInput", function()
    return display.newNode()
end)

GameButtonInput._winScale = lt.CacheManager:getWinScale()
GameButtonInput._size = cc.size(200,40)

-- 自定义输入回调
GameButtonInput._listener = nil

GameButtonInput._inputEnd  = false

GameButtonInput._delayHandler = nil
--默认50个字
GameButtonInput._maxLength = 60
GameButtonInput._isWarnStr = true

function GameButtonInput:ctor(params)
    self:setNodeEventEnabled(true)
    
    params = params or {}

    if params.listener then
        self._listener = params.listener
    end

    if params and params.size then
        self._size = params.size
    end

    local inputButton = lt.PushButton.new()
    inputButton:setContentSize(self._size)
    inputButton:onButtonPressed(handler(self, self.onClickLock))
    self:addChild(inputButton)

    self._inputButton = inputButton

    local rect = cc.rect(0,0,self._size.width - 4,self._size.height)
    local clipNode = display.newClippingRegionNode(rect)

    clipNode:setPosition(-self._size.width / 2, -self._size.height / 2 + 5)
    self:addChild(clipNode)


    self._signatureLabel = lt.GameLabel.new("", lt.Constants.FONT_SIZE4*self._winScale, lt.Constants.DEFAULT_LABEL_COLOR_2)
    self._signatureLabel:setAnchorPoint(0, 1)
    self._signatureLabel:setPosition(5, self._size.height - 15)
    clipNode:addChild(self._signatureLabel)

    --换行
    if params and params.changeLine then
        self._signatureLabel:setDimensions(self._size.width - 15,0)
        self._signatureLabel:setLineBreakWithoutSpace(true)
    end

    --最大字数
    if params and params.maxLength then
        self._maxLength = params.maxLength
    end

    self._placeHolder = lt.GameLabel.new("", lt.Constants.FONT_SIZE4*self._winScale, lt.Constants.COLOR.PLACEHOLDER)
    self._placeHolder:setAnchorPoint(0, 1)
    self._placeHolder:setPosition(5, self._size.height - 15)
    clipNode:addChild(self._placeHolder)

    --Placeholder
    if params and params.placeHolder then
        self._placeHolder:setString(params.placeHolder)
    end
    --warnStr
    if params.isWarnStr ~= nil then
        self._isWarnStr = params.isWarnStr
    end
end

function GameButtonInput:onExit()
    if self._delayHandler then
        lt.scheduler.unscheduleGlobal(self._delayHandler)
        self._delayHandler = nil
    end
end

function GameButtonInput:onUpdate(dt)
    if self._inputEnd and self._inputBox then
        self._inputBox:removeSelf()
        self._inputBox = nil
    end
end

function GameButtonInput:getInputBox()
    return self._inputBox
end

function GameButtonInput:onClickLock()
    lt.CommonUtil.print("GameButtonInput:onClickLock")
    if self._delayHandler then
        -- 停止删除回调
        lt.scheduler.unscheduleGlobal(self._delayHandler)
        self._delayHandler = nil
    end

    if not self._inputBox then
        self._inputBox = lt.GameInput.new({
            image = display.newScale9Sprite(),
            size = self._size,
            listener = handler(self, self.onEdit),
            isWarnStr = self._isWarnStr
        })
        self._inputBox:setMaxLength(self._maxLength)
        self._inputBox:setFont(lt.Constants.FONT, 22)
        self._inputBox:setFontSize(22)
        self._inputBox:setFontColor(lt.Constants.DEFAULT_LABEL_COLOR_2)
        self._inputBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
        self:addChild(self._inputBox)
        self._inputBox:touchDownAction(self._inputBox, ccui.TouchEventType.ended)
    end

    self._inputEnd  = false
end

function GameButtonInput:onEdit(event)
    -- lt.CommonUtil.printf(" GameButtonInput:onEdit %s", event)
    local str = self._signatureLabel:getString()
    if event == "began" then
        self._placeHolder:setVisible(false)
        self._inputBox:setText(self._signatureLabel:getString())
        self._signatureLabel:setVisible(false) 
    elseif event == "changed" then

    elseif event == "return" then
        -- 延迟删除
        self._delayHandler = lt.scheduler.performWithDelayGlobal(function()
            self._inputBox:removeSelf()
            self._inputBox = nil

            self._delayHandler = nil
        end, 0)
    elseif event == "ended" then
        --local text = self._inputBox:getText()
        local text = string.trim(self._inputBox:getText())--过滤两边空格
        self._signatureLabel:setVisible(true)
        self._signatureLabel:setString(text)

        if text == "" then
            self._placeHolder:setVisible(true)
        end
    end

    if self._listener then
        self._listener(event, editbox)
    end
end

function GameButtonInput:hidePlaceHolder()
    self._placeHolder:setVisible(false)
end

function GameButtonInput:getString()
    return self._signatureLabel:getString()
end

function GameButtonInput:getText()
    return self._signatureLabel:getString()
end

function GameButtonInput:setText(text)
    return self._signatureLabel:setString(text)
end

function GameButtonInput:setString(text)
    return self._signatureLabel:setString(text)
end

function GameButtonInput:setVisible(bool)
    if bool then
        self._inputButton:setTouchEnabled(true)
    else
        self._inputButton:setTouchEnabled(false)
    end
end

return GameButtonInput
