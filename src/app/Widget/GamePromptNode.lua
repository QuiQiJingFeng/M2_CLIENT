
local GamePromptNode = class("GamePromptNode", function()
	return display.newNode()
end)

function GamePromptNode:ctor(params)

    self:setNodeEventEnabled(true)

    self._heroImage = display.newSprite("image/ui/friend_icon_examhero.png")
    self._heroImage:setFlippedX(true)
    self._heroImage:setScale(0.8)
    self:addChild(self._heroImage)


    local offsetX = params.offsetX or 0
    local offsetY = params.offsetY or 0

    self._dialogImage = display.newSprite("image/ui/friend_icon_dialog.png")
    self._dialogImage:setFlippedX(true)
    self._dialogImage:setPosition(self._heroImage:getPositionX() + offsetX, self._heroImage:getPositionY()+self._heroImage:getContentSize().height/2 + offsetY)
    self:addChild(self._dialogImage)

    local str = params.string or ""
    local infoLabel = lt.GameLabel.new(str,lt.Constants.FONT_SIZE4,lt.Constants.DEFAULT_LABEL_COLOR_2)
    infoLabel:setPosition(self._dialogImage:getContentSize().width / 2, self._dialogImage:getContentSize().height / 2 + 8)
    local width = self._dialogImage:getContentSize().width - 30
    if infoLabel:getContentSize().width > width then
        infoLabel:setWidth(width)
    end
    self._dialogImage:addChild(infoLabel)
end

function GamePromptNode:onExit()
    -- 移除图片
    display.removeSpriteFrameByImageName("image/ui/friend_icon_examhero.png")
    display.removeSpriteFrameByImageName("image/ui/friend_icon_dialog.png")
end

function GamePromptNode:setFlippedX(flipped)
    self._heroImage:setFlippedX(not flipped)
    self._dialogImage:setFlippedX(not flipped)
end

return GamePromptNode