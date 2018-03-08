
--玩法说明
local EggPlayHelp = class("EggPlayHelp", function()
    return display.newLayer()
end)

EggPlayHelp.HELPTYPE = {
    EggHELP       =    1,
    CrazyDoctor   =    2,
}

EggPlayHelp._winScale = lt.CacheManager:getWinScale()
EggPlayHelp._size = cc.size(460, 540)
local offY = 20
function EggPlayHelp:ctor(type)

    self:setTouchEnabled(true)
    self:setNodeEventEnabled(true)
    self:setTouchSwallowEnabled(true)

    --透明底
    self._bg = lt.GameNewPanel.new(lt.GameNewPanel.TYPE.TRANSPARENT, display.cx, display.cy - 20, self._size)
    self._bg:setScale(self._winScale)
    self:addChild(self._bg)

    self._blackBg = lt.GameNewPanel.new(lt.GameNewPanel.TYPE.NEW_BLACK, 5, 5, cc.size(self._size.width - 10, self._size.height - 10))
    self._blackBg:setAnchorPoint(0, 0)
    self._bg:addChild(self._blackBg)

    self._showing = false

    local labelArray = {}
    local labelHeightAll = 0


    local allLabelNum = 7
    local stringStr = "STRING_EGG_HELP_TIPS"

    if type == self.HELPTYPE.EggHELP then
        allLabelNum = 7
        stringStr = "STRING_EGG_HELP_TIPS"
    elseif type == self.HELPTYPE.CrazyDoctor then
        allLabelNum = 5
        stringStr = "STRING_CRAZY_DOCTOR_HELP_TIPS"
    end

    for i=1,allLabelNum do
        local labelColor = lt.Constants.COLOR.WHITE
        local labelFontSize = 18
        if i == 1 then
            labelColor = lt.Constants.COLOR.QUALITY_ORANGE
            labelFontSize = 20
        end

        local doebleStr1 = lt.GameLabel.new(lt.StringManager:getString(stringStr..i), labelFontSize, labelColor)
        if i ~= 1 then--避免第一行不居中
            doebleStr1:setWidth(420)
        end
        
        table.insert(labelArray, doebleStr1)
        
        labelHeightAll = labelHeightAll + doebleStr1:getContentSize().height
    end


    local bgHeight = labelHeightAll + 20 + allLabelNum * 20

    local posX = 18
    local posY = bgHeight

    self._bg:setPanelSize(cc.size(self._size.width, bgHeight))
    self._blackBg:setPanelSize(cc.size(self._size.width - 10, bgHeight - 10))

    for index,label in pairs(labelArray) do
        if index == 1 then--标题title
            posY = posY - 20 - label:getContentSize().height - offY
            label:setPosition(self._size.width / 2, bgHeight - 20)
        else
            label:setPosition(self._size.width / 2, posY)
            posY = posY - label:getContentSize().height - offY
        end
        label:setAnchorPoint(0.5, 1)
        self._blackBg:addChild(label)   
    end
end

function EggPlayHelp:onEnter()
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        -- 没点击在自身区域 则隐藏
        local rect = self._bg:getCascadeBoundingBox()

        if not cc.rectContainsPoint(rect, cc.p(event.x, event.y)) then
            self:close()
        end

        return false
    end)
end



function EggPlayHelp:show()
    if self._showing then
        return
    end
    lt.UILayerManager:addLayer(self, true)
    self._showing = true
end


function EggPlayHelp:setOffset(x, y)
    if type(x) == "table" then
        y = x.y
        x = x.x
    end

    -- 调整
    x = lt.CommonUtil:fixValue(x, self._bg:getContentSize().width / 2, display.width - self._bg:getContentSize().width / 2)
    y = lt.CommonUtil:fixValue(y, self._bg:getContentSize().height / 2, display.height - self._bg:getContentSize().height / 2)

    self._bg:setPosition(x, y)
end

function EggPlayHelp:setOffsetX(x)
    x = lt.CommonUtil:fixValue(x, self._bg:getContentSize().width / 2, display.width - self._bg:getContentSize().width / 2)

    self._bg:setPositionX(x)
end

function EggPlayHelp:setOffsetY(y)
    y = lt.CommonUtil:fixValue(y, self._bg:getContentSize().height / 2, display.height - self._bg:getContentSize().height / 2)

    self._bg:setPositionY(y)
end



function EggPlayHelp:close()
    lt.UILayerManager:removeLayer(self)
end

return EggPlayHelp
