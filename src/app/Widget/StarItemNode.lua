
-- 进阶界面的道具条
local StarItemNode = class("StarItemNode", function()
    return display.newNode()
end)

-- 参数是数组, 每个元素是一个table {itemId=1, itemCount=5}
function StarItemNode:ctor(itemArray)
    local itemCount = #itemArray

    for i=1,itemCount do
        local itemSprite = display.newSprite("image/ui/hero/star.png")
        itemSprite:setAnchorPoint(0.5, 0.5)
        itemSprite:setPosition((i - 3) * 90, 0)
        self:addChild(itemSprite)
    end
end

return StarItemNode
