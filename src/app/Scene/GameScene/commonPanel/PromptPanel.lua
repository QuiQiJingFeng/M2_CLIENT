
local PromptPanel = class("PromptPanel")

function PromptPanel:ctor()

    self.label = label
end

function PromptPanel:showPrompt(msg)
    local layer = lt.BaseLayer.new()
    local label = ccui.Text:create(msg, "arial", 36)
    label:setTextColor({ r = 255, g = 235, b = 0, a = 255 })
    label:ignoreContentAdaptWithSize(false)
    label:setContentSize(620, 36)
    label:setTextHorizontalAlignment(1)
    label:setPosition(display.width * 0.5, display.height * 0.7)
    layer:addChild(label)
    lt.UILayerManager:addLayer(layer,true)

    local duration = 2
    local mv = cc.MoveTo:create(duration,cc.p(display.width * 0.5,display.height * 0.8))
    local faceout = cc.FadeOut:create(duration)
    local spawn = cc.Spawn:create(mv,faceout)
    label:runAction(spawn)
end

return PromptPanel