
local GamePrompt = class("GamePrompt", function()
    return lt.GamePanel.new(lt.GamePanel.TYPE.NEW_BGWHITE, display.cx, -50, cc.size(280, 66))
end)

function GamePrompt:ctor(stringInfo)
    --灰色背景
    self._blackBg = lt.GamePanel.new(lt.GamePanel.TYPE.NEW_BLACK, 6, 6, cc.size(268, 54))
    self._blackBg:setAnchorPoint(0, 0)
    self:addChild(self._blackBg)

    --白色背景
    self._rightWhiteBg = lt.GamePanel.new(lt.GamePanel.TYPE.NEW_WHITE, 3, 3, cc.size(262,48))
    self._rightWhiteBg:setAnchorPoint(0,0)
    self._blackBg:addChild(self._rightWhiteBg)

    local stringInfo = stringInfo or ""

    self._lblTips = lt.GameLabel.new(stringInfo,lt.Constants.FONT_SIZE2, lt.Constants.DEFAULT_LABEL_COLOR_2, {outline = 1})
    self._lblTips:setPosition(self._blackBg:getContentSize().width/2,self._blackBg:getContentSize().height/2)
    self._blackBg:addChild(self._lblTips)
end

return GamePrompt