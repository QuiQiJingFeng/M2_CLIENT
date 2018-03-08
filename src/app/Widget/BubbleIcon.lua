
local BubbleIcon = class("BubbleIcon", function()
	return display.newNode()
end)


function BubbleIcon:ctor()
    local bgSize = cc.size(200,45)
	self._rightInfoBg = lt.GameInfoBg.new(lt.GameInfoBg.TYPE.GAME_INFO_BG_TYPE_2, bgSize, 0,0)
    self._rightInfoBg:setAnchorPoint(1, 1)
    self:addChild(self._rightInfoBg)
end

function BubbleIcon:updateInfo(bubbleId,bgSize,myself)
	self._rightInfoBg:removeFromParent()

    if bubbleId == 0 then
        local bgSize = cc.size(200,45)
        self._rightInfoBg = lt.GameInfoBg.new(lt.GameInfoBg.TYPE.GAME_INFO_BG_TYPE_2, bgSize, 0,0)
        self._rightInfoBg:setAnchorPoint(1, 1)
        self:addChild(self._rightInfoBg)
        return
    end

	local figureInfo = lt.CacheManager:getFigure(bubbleId)
    if not figureInfo then return end
    local image = figureInfo:getImage()
    local scale9SpriteName = image["sprite"]
    local leftUp = image["leftup"]
    local rightDown = image["rightdown"]
    local imageName = "image/chatbg/"..scale9SpriteName..".png"
    local ownRightUp = image["ownrightup"]
    local rightUp = image["rightup"]

    if not bgSize then
        bgSize = cc.size(200,45)
    end
    local capInsets = cc.rect(10,10,54,10)
    self._rightInfoBg = display.newScale9Sprite(imageName, 0, 0, bgSize, capInsets)
    if myself then
        self._rightInfoBg:setAnchorPoint(1, 1)
    else
        self._rightInfoBg:setAnchorPoint(0, 1)
    end
    self:addChild(self._rightInfoBg)

    if leftUp then
        local leftImageName = "image/chatbg/"..leftUp..".png"
        local leftImage = display.newSprite(leftImageName)
        leftImage:setAnchorPoint(0.5,0.5)
        leftImage:setPosition(bgSize.width - 5,bgSize.height - 5)
        leftImage:setFlippedX(true)
        self._rightInfoBg:addChild(leftImage)
    end

    if rightUp then
        local rightUpImgName = "image/chatbg/"..rightUp..".png"
        local rightUpImg = display.newSprite(rightUpImgName)
        rightUpImg:setAnchorPoint(0.5,0.5)
        rightUpImg:setFlippedX(true)
        rightUpImg:setPosition(15,bgSize.height - 14)
        self._rightInfoBg:addChild(rightUpImg)
    end

    if rightDown then
        local rightImageName = "image/chatbg/"..rightDown..".png"
        local rightImage = display.newSprite(rightImageName)
        rightImage:setAnchorPoint(0.5,0.5)
        rightImage:setPosition(5,15)
        rightImage:setFlippedX(true)
        self._rightInfoBg:addChild(rightImage)
    end

    if ownRightUp then
        local ownRightUpImgName = "image/chatbg/"..ownRightUp..".png"
        local ownRightUpImg = display.newSprite(ownRightUpImgName)
        ownRightUpImg:setAnchorPoint(0.5,0.5)
        ownRightUpImg:setPosition(bgSize.width - 20,bgSize.height - 5)
        self._rightInfoBg:addChild(ownRightUpImg)
    end
end

function BubbleIcon:addNode(node,order)
    if order then
        self._rightInfoBg:addChild(node,order)
    else
        self._rightInfoBg:addChild(node)
    end
end

function BubbleIcon:getContentSize()
    return self._rightInfoBg:getContentSize()
end

return BubbleIcon