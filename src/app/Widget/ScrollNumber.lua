
local ScrollNumber = class("ScrollNumber", ccui.Layout)

--设置数字，iNum 数字  bIsPlay 是否播放动画
function ScrollNumber:setNumber(iNum, bIsPlay, iPointDis)
    local numStr = string.format("%0.2f", iNum) --两位
    iNum = tonumber(numStr)

    self:removeAllChildren(true)

    bIsPlay = bIsPlay or false
    self.m_iNum = iNum

    local bIsHasZf = self.m_sLostPngUrl ~= nil
    local sNum = (iNum == 0 or not bIsHasZf) and ("" .. iNum) or ((iNum < 0) and (iNum) or ("+" .. iNum))
    local iNumLen = string.len(sNum)
    local bIsWin = iNum >= 0
    local sPngUrl = bIsWin and self.m_sWinPngUrl or self.m_sLostPngUrl
    local iPngWidth = bIsWin and self.m_iWinPngWidth or self.m_iLostPngWidth
    local tMapChar2Y = bIsWin and self.m_tMapWinChar2Y or self.m_tMapLostChar2Y
    local iGapY = bIsWin and self.m_iWinGapY or self.m_iLostGapY

    local isHasDian = false
    for i=1, iNumLen do
        local sChar = string.sub(sNum, i, i)
        if sChar == "." then
            isHasDian = true
            break
        end
    end

    if isHasDian then
        if iPointDis == nil then
            iPointDis = -iPngWidth/3
        end
    else
        iPointDis = 0
    end

    self:setContentSize(cc.size(
        iPngWidth * iNumLen + iPointDis,
        iGapY
    ))
    self:setClippingEnabled(true)

    local x = -iPngWidth
    local lastChar = ""
    for i=1, iNumLen do
        local sChar = string.sub(sNum, i, i)
        local intChar = tonumber(sChar)
        intChar = intChar or 0
        local sp = display.newSprite(sPngUrl)
        sp:setAnchorPoint(cc.p(0, 0))
        local intY = bIsPlay and ((sChar == "+" or sChar == "-") and 0 or iGapY) or tMapChar2Y[sChar]
        x = x + iPngWidth
        if lastChar == "." then
            x = x + iPointDis
        end
        
        sp:setPosition(cc.p(x, intY))
        self:addChild(sp)

        if bIsPlay then
            --sp:runAction(cc.Sequence:create(cc.DelayTime:create((i-1) * 0.1), cc.EaseOut:create(cc.MoveTo:create(0.3 * (10 - intChar), cc.p(sp:getPositionX(), tMapChar2Y[sChar])), 1)))
            sp:runAction(cc.Sequence:create(cc.DelayTime:create((i-1) * 0.01), cc.MoveTo:create(0.15 * (10 - intChar), cc.p(sp:getPositionX(), tMapChar2Y[sChar]))))
        end

        lastChar = sChar
    end
end

--获得数字
function ScrollNumber:getNumber()
    return self.m_iNum or 0
end

--创建竖方向的滚动数字，图片格式必须为：从上到下 0-x (x 可以为 0 - 9 之间的数，9 之后的字符 必须为 + 或 - )
--iPngNumCount 字符个数
--sWinNumberPngUrl 正数的图片
--sLostNumberPngUrl 负数的图片（可以不设置，不设置表示数字前没有正负号）
--isHasPoint 是否有小数点，nil 表示没有
function ScrollNumber:create(iPngNumCount, sWinNumberPngUrl, sLostNumberPngUrl, isHasPoint)
    iPngNumCount = iPngNumCount or 11
    if isHasPoint then
        --有小数点，是12张
        iPngNumCount = iPngNumCount + 1
    end
    sWinNumberPngUrl = sWinNumberPngUrl or "nn/nnRoom/nn_win_nums.png"
    sLostNumberPngUrl = sLostNumberPngUrl or "nn/nnRoom/nn_fail_nums.png"

    local obj = ScrollNumber:new()
    obj.m_sWinPngUrl = sWinNumberPngUrl
    obj.m_sLostPngUrl = sLostNumberPngUrl

    local sp = display.newSprite(sWinNumberPngUrl)

    obj.m_iWinPngWidth = sp:getContentSize().width
    obj.m_iWinPngHeight = sp:getContentSize().height
    obj.m_iWinGapY = obj.m_iWinPngHeight / iPngNumCount
    
    local tMapWinChar2Y = {}
    for i = 0, iPngNumCount-1 do
        if i <= 10 then
            tMapWinChar2Y[((i <= 9) and (""..i) or "+")] = -(obj.m_iWinPngHeight - obj.m_iWinGapY * (i + 1))
        elseif i == 11 then
            if isHasPoint then
                tMapWinChar2Y["."] = -(obj.m_iWinPngHeight - obj.m_iWinGapY * (i + 1))
            end
        end
    end
    
    obj.m_tMapWinChar2Y = tMapWinChar2Y

    if sLostNumberPngUrl then
        sp = display.newSprite(sLostNumberPngUrl)

        obj.m_iLostPngWidth = sp:getContentSize().width
        obj.m_iLostPngHeight = sp:getContentSize().height
        obj.m_iLostGapY = obj.m_iLostPngHeight / iPngNumCount

        local tMapLostChar2Y = {}
        for i = 0, iPngNumCount-1 do
            if i <= 10 then
                tMapLostChar2Y[((i <= 9) and (""..i) or "-")] = -(obj.m_iLostPngHeight - obj.m_iLostGapY * (i + 1))
            elseif i == 11 then
                if isHasPoint then
                    tMapLostChar2Y["."] = -(obj.m_iLostPngHeight - obj.m_iLostGapY * (i + 1))
                end
            end
        end
        obj.m_tMapLostChar2Y = tMapLostChar2Y
    end

    return obj
end

return ScrollNumber