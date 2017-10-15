local prototype = class("prototype_layer", cc.Layer)

function prototype:ctor()
    self:enableNodeEvents()

    if isfunction(self.onCreate) then
        self:onCreate()
    end

    if isfunction(self.registWidgetEvent) then
        self:registWidgetEvent()
    end

    if isfunction(self.onUpdate) then
        self:scheduleUpdate(function(dt)
            self:onUpdate(dt)
        end)
    end
end

function prototype:onEnter()
    printError("没有重载onEnter函数！")
end

function prototype:onExit()
    printError("没有重载onExit函数！")
end

function prototype:onCleanup()
    printError("没有重载onCleanup函数！")
end

return prototype