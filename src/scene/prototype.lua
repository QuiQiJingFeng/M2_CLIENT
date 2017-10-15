local prototype = class("prototype_scene", cc.Scene)

local NORMAL_LAYER_ZORDER = 10

function prototype:ctor(...)
    self:enableNodeEvents()

    self.layer_map = {}

    if isfunction(self.onCreate) then
        self:onCreate(...)
    end

    if isfunction(self.onUpdate) then
        self:scheduleUpdate(function(dt)
            self:onUpdate(dt)
        end)
    end
end

function prototype:showLayer(l_name, ...)
    if l_name then
        local layer = self.layer_map[l_name]
        if layer then
            self:reorderChild(layer, NORMAL_LAYER_ZORDER)
        else
            layer = require(string.format("layer.%s", l_name)):create()
            self.layer_map[l_name] = layer
            self:addChild(layer, NORMAL_LAYER_ZORDER)
        end

        layer:show(...)
        return layer
    end
end

function prototype:showNotice()

end

return prototype