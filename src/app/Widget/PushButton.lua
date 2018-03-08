
local PushButton = class("PushButton", cc.ui.UIPushButton)

PushButton._pressDelay = 0.3
PushButton._pressInterval = 0.1
PushButton._longPress = false

PushButton._schedulerHandler = nil
PushButton._longPressCallBack = nil

function PushButton:ctor(images, options)
    options = options or {}

    local size = options.size
    if size then
        options.scale9 = true
    end

	PushButton.super.ctor(self, images, options)

    if size then
        self:setButtonSize(size.width, size.height)
    end

    -- 按键音
    self.super.onButtonClicked(self, function()
        lt.AudioManager:buttonClicked()
    end)
end

function PushButton:setPressInterval(interval)
    self._pressInterval = interval
end

function PushButton:schedulePress()
    self._pressedSchedule = nil

    if not self._longPressCallBack then
        return
    end

    self._longPress = true
    self._schedulerHandler = lt.scheduler.scheduleGlobal(self._longPressCallBack, self._pressInterval)
end

-- 重写 onButtonClicked 涉及到长摁
function PushButton:onButtonClicked(callback)
    self:addButtonClickedEventListener(function(event)
        if self._longPress then
            self._longPress = false
            return
        end

        callback(event)
    end)
    return self
end

function PushButton:onButtonLongPressed(callback)
    self._longPressCallBack = callback

    self:onButtonPressed(function()
        if not self._pressedSchedule then
            self._pressedSchedule = lt.scheduler.performWithDelayGlobal(handler(self, self.schedulePress), self._pressDelay)
        end
    end)

    self:onButtonRelease(function()
        if self._pressedSchedule then
            lt.scheduler.unscheduleGlobal(self._pressedSchedule)
            self._pressedSchedule = nil
        end

        if self._schedulerHandler then
            lt.scheduler.unscheduleGlobal(self._schedulerHandler)
            self._schedulerHandler = nil
        end
    end)
end

return PushButton
