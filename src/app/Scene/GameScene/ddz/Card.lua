-- 纸牌初始化方法

local Card = {}

-- ["DDZ"] = {
-- 		103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 120, 
-- 		203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 220, 
-- 		303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 320, 
-- 		403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 420, 
-- 		124, 125
-- 	}
-- @param  iCard 具体牌值
-- @param  isMain 是否是地主
function Card:createCard(iCard, isMain)

	if not iCard then return false end


	local iCardType = iCard / 100
	local iCardValue = iCard % 100


	if iCardType < 1 or iCardType > 5 or iCardValue < 3 or iCardValue > 20 then
		print(string.format("ERROR: Card:createCard = %d, iCardType = [%d] iCardValue= [%d] ", iCard, iCardType, iCardValue))
		return false
	end

	-- 大小王坐标
	local wangPos = cc.p(104.00, 95.00)
	local wangLogoPos = cc.p(30.00, 155.00)

	-- 纸牌坐标
	local numPos = cc.p(30.00, 180.00)
	local smFlowPos = cc.p(30.00, 125.00)
	local bigFlowPos = cc.p(90.00, 80.00)

	local resPath = "games/ddz/ddz_game/card/"

	-- 牌面
	local spCard = display.newSprite(resPath.."paimian.png")

	-- 大小王
	if iCardType == 5 then
		local wangLogoSp = display.newSprite(resPath.."pwang%d.png", iCardValue)
		wangLogoSp:addTo(spCard)
		wangLogoSp:setPosition(wangLogoPos)
		local wangSp = display.newSprite(resPath.."PokerIndex%d.png", iCardValue)
		wangSp:addTo(spCard)
		wangSp:setPosition(wangPos)

	else
		local numSp = display.newSprite(resPath.."PokerIndex"..iCardValue.. (iCardType % 2 == 0 and "r" or "b") .. ".png")
		numSp:addTo(spCard)
		numSp:setPosition(numPos)

		local smFlowSp = display.newSprite(resPath.."pokerColorX".. iCardType .. ".png")
		smFlowSp:addTo(spCard)
		smFlowSp:setPosition(smFlowPos)

		local bigFlowSp = display.newSprite(resPath.."pokerColor" .. iCardType .. ".png")
		bigFlowSp:addTo(spCard)
		bigFlowSp:setPosition(smFlowPos)

	end


	-- isMain  地主标志， 后期在调

	return spCard
end





return Card