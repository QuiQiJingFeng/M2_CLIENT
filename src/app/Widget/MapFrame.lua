
local MapFrame = class("MapFrame", function()
    return display.newNode()
end)

function MapFrame:ctor(rowCount, colCount, tileSzie)
    for i=0,rowCount do
        local line = display.newLine({{0, i * tileSzie}, {colCount * tileSzie, i * tileSzie}}, {borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0), borderWidth = 1})
        self:addChild(line)
    end

    for i=0,colCount do
        local line = display.newLine({{i * tileSzie, 0}, {i * tileSzie, rowCount * tileSzie}}, {borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0), borderWidth = 1})
        self:addChild(line)
    end
end

return MapFrame
