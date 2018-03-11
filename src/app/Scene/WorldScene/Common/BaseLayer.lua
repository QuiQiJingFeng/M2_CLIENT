local BaseLayer = class("BaseLayer", function()
	return display.newLayer()
end)

function BaseLayer:ctor(deleget)
	--self:setNodeEventEnabled(true)

    local function onNodeEvent(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end
    self:registerScriptHandler(onNodeEvent)    
end

function BaseLayer:onEnter()   

end

function BaseLayer:onExit()

end

return BaseLayer