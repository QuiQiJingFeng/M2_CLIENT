
local PropertyGraphNode = class("PropertyGrapthNode", function()
    return display.newNode()
end)

PropertyGraphNode.MAX_VALUE = 200

PropertyGraphNode._drawNode = nil
PropertyGraphNode._drawNode2 = nil

PropertyGraphNode._radius = 50

pi = math.pi
PropertyGraphNode._centerPoint = cc.p(0, 0)
PropertyGraphNode._waterPoint  = cc.p(string.format("%.2f", PropertyGraphNode._radius * math.cos( pi * 1 / 10)),  string.format("%.2f", PropertyGraphNode._radius * math.sin( pi * 1 / 10)))
PropertyGraphNode._firePoint   = cc.p(string.format("%.2f", PropertyGraphNode._radius * math.cos( pi * 5 / 10)),  string.format("%.2f", PropertyGraphNode._radius * math.sin( pi * 5 / 10)))
PropertyGraphNode._lightPoint  = cc.p(string.format("%.2f", PropertyGraphNode._radius * math.cos( pi * 9 / 10)),  string.format("%.2f", PropertyGraphNode._radius * math.sin( pi * 9 / 10)))
PropertyGraphNode._darkPoint   = cc.p(string.format("%.2f", PropertyGraphNode._radius * math.cos( pi * 13 / 10)), string.format("%.2f", PropertyGraphNode._radius * math.sin( pi * 13 / 10)))
PropertyGraphNode._windPoint   = cc.p(string.format("%.2f", PropertyGraphNode._radius * math.cos( pi * 17 / 10)), string.format("%.2f", PropertyGraphNode._radius * math.sin( pi * 17 / 10)))

function PropertyGraphNode:ctor(scale)
    if not scale then
        scale = 1
    end

    self._backgroundGraph = display.newSprite("#common_property_bg.png")
    self._backgroundGraph:setScale(scale)
    self:addChild(self._backgroundGraph)

    local radius = 80 * scale
    local offset = 8

    -- 五边形
    self._pentagon = display.newSprite("#common_property_pentagon.png")
    self._pentagon:setScale(scale)
    self._pentagon:setPosition(0, -offset)
    self:addChild(self._pentagon)

    -- 5属性Icon

    local waterPoint = cc.p(string.format("%.2f", radius * math.cos( pi * 1 / 10)),  string.format("%.2f", radius * math.sin( pi * 1 / 10)) - offset)
    local firePoint  = cc.p(string.format("%.2f", radius * math.cos( pi * 5 / 10)),  string.format("%.2f", radius * math.sin( pi * 5 / 10)) - offset)
    local lightPoint = cc.p(string.format("%.2f", radius * math.cos( pi * 9 / 10)),  string.format("%.2f", radius * math.sin( pi * 9 / 10)) - offset)
    local darkPoint  = cc.p(string.format("%.2f", radius * math.cos( pi * 13 / 10)), string.format("%.2f", radius * math.sin( pi * 13 / 10)) - offset)
    local windPoint  = cc.p(string.format("%.2f", radius * math.cos( pi * 17 / 10)), string.format("%.2f", radius * math.sin( pi * 17 / 10)) - offset)

    local waterIcon = display.newSprite("#common_property_icon_water.png")
    waterIcon:setPosition(waterPoint)
    self:addChild(waterIcon)

    local fireIcon  = display.newSprite("#common_property_icon_fire.png")
    fireIcon:setPosition(firePoint)
    self:addChild(fireIcon)

    local lightIcon = display.newSprite("#common_property_icon_light.png")
    lightIcon:setPosition(lightPoint)
    self:addChild(lightIcon)

    local darkIcon  = display.newSprite("#common_property_icon_dark.png")
    darkIcon:setPosition(darkPoint)
    self:addChild(darkIcon)

    local windIcon  = display.newSprite("#common_property_icon_wind.png")
    windIcon:setPosition(windPoint)
    self:addChild(windIcon)
end

function PropertyGraphNode:setValue(fire, water, wind, light, dark)
    if self._drawNode then
        self._drawNode:removeFromParent()
    end

    fire  = math.max(0, fire);
    water = math.max(0, water);
    wind  = math.max(0, wind);
    light = math.max(0, light);
    dark  = math.max(0, dark);

    if fire == 0 and water == 0 and wind == 0 and light == 0 and dark == 0 then
        return
    end
    
    local maxValue = math.max(self.MAX_VALUE, fire, water, wind, light, dark)

    local firePoint  = cc.pMul(self._firePoint,  fire  / maxValue)
    local waterPoint = cc.pMul(self._waterPoint, water / maxValue)
    local windPoint  = cc.pMul(self._windPoint,  wind  / maxValue)
    local lightPoint = cc.pMul(self._lightPoint, light / maxValue)
    local darkPoint  = cc.pMul(self._darkPoint,  dark  / maxValue)

    local colorFill = cc.c4f(20/255, 163/255, 1, 0.5)
    local colorEdge = cc.c4f(64/255, 1, 1, 1)

    self._drawNode = display.newDrawNode()
    self._drawNode:drawTriangle(self._centerPoint, firePoint,  waterPoint, colorFill)
    self._drawNode:drawTriangle(self._centerPoint, waterPoint, windPoint,  colorFill)
    self._drawNode:drawTriangle(self._centerPoint, windPoint,  darkPoint, colorFill)
    self._drawNode:drawTriangle(self._centerPoint, darkPoint, lightPoint,  colorFill)
    self._drawNode:drawTriangle(self._centerPoint, lightPoint,  firePoint,  colorFill)
    
    local radius = 0.5
    self._drawNode:drawSegment(firePoint,  waterPoint, radius, colorEdge)
    self._drawNode:drawSegment(waterPoint, windPoint, radius, colorEdge)
    self._drawNode:drawSegment(windPoint,  darkPoint, radius, colorEdge)
    self._drawNode:drawSegment(darkPoint, lightPoint, radius, colorEdge)
    self._drawNode:drawSegment(lightPoint, firePoint, radius, colorEdge)

    self._drawNode:setPosition(self._pentagon:getContentSize().width/2, self._pentagon:getContentSize().height/2 - 5)
    self._pentagon:addChild(self._drawNode)
end

function PropertyGraphNode:setValue2(fire, water, wind, light, dark)
    if self._drawNode2 then
        self._drawNode2:removeFromParent()
    end

    fire  = math.max(0, fire);
    water = math.max(0, water);
    wind  = math.max(0, wind);
    light = math.max(0, light);
    dark  = math.max(0, dark);

    if fire == 0 and water == 0 and wind == 0 and light == 0 and dark == 0 then
        return
    end

    local maxValue = math.max(self.MAX_VALUE, fire, water, wind, light, dark)

    local firePoint  = cc.pMul(self._firePoint,  fire  / maxValue)
    local waterPoint = cc.pMul(self._waterPoint, water / maxValue)
    local windPoint  = cc.pMul(self._windPoint,  wind  / maxValue)
    local lightPoint = cc.pMul(self._lightPoint, light / maxValue)
    local darkPoint  = cc.pMul(self._darkPoint,  dark  / maxValue)

    local colorFill = cc.c4f(251/255, 51/255, 41/255, 0.5)
    local colorEdge = cc.c4f(169/255, 0, 54/255, 1)

    self._drawNode2 = display.newDrawNode()
    self._drawNode2:drawTriangle(self._centerPoint, firePoint,  waterPoint, colorFill)
    self._drawNode2:drawTriangle(self._centerPoint, waterPoint, windPoint,  colorFill)
    self._drawNode2:drawTriangle(self._centerPoint, windPoint,  darkPoint, colorFill)
    self._drawNode2:drawTriangle(self._centerPoint, darkPoint, lightPoint,  colorFill)
    self._drawNode2:drawTriangle(self._centerPoint, lightPoint,  firePoint,  colorFill)
    
    local radius = 0.5
    self._drawNode2:drawSegment(firePoint,  waterPoint, radius, colorEdge)
    self._drawNode2:drawSegment(waterPoint, windPoint, radius, colorEdge)
    self._drawNode2:drawSegment(windPoint,  darkPoint, radius, colorEdge)
    self._drawNode2:drawSegment(darkPoint, lightPoint, radius, colorEdge)
    self._drawNode2:drawSegment(lightPoint, firePoint, radius, colorEdge)

    self._drawNode2:setPosition(self._pentagon:getContentSize().width/2, self._pentagon:getContentSize().height/2 - 5)
    self._pentagon:addChild(self._drawNode2, 2)
end

return PropertyGraphNode
