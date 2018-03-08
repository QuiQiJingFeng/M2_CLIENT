--表情
local Emoji = class("Emoji", function()
	return display.newNode()
end)

function Emoji:ctor(id,animation)
    local skeletonAnimation = lt.SkeletonAnimation.new("emoji/emoji_"..id)
    self:addChild(skeletonAnimation)
    if animation then
        skeletonAnimation:setAnimation(0, "stand0", true)
    end
end

function Emoji:getContentSize()
    return cc.size(44,44)
end

return Emoji
