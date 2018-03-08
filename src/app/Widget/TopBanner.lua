
local TopBanner = class("TopBanner", function()
	return display.newNode()
end)

TopBanner._winScale = lt.CacheManager:getWinScale()

TopBanner._diamondLabel = nil
TopBanner._coinLabel    = nil
TopBanner._coinPadding  = 65
TopBanner._bgPadding    = 20 * TopBanner._winScale
TopBanner._delegate = nil
function TopBanner:ctor(delegate,params)
	self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
	self._delegate = delegate
	params = params or {}	


	local posX = 300*self._winScale
	local paddingX = 160*self._winScale

	local posY = display.top - 23

	self._commonBg = display.newSprite("#city_img_coin.png")
	self._conmonBgSize = self._commonBg:getContentSize()

	local pos_x = self._conmonBgSize.width / 2

	--银币
	self._silverBg = display.newScale9Sprite("#city_img_coin.png", 0, 0,self._conmonBgSize)
	self._silverBg:setAnchorPoint(0, 0.5)
	self._silverBg:setScale(self._winScale)
	self._silverBg:setPosition(display.left + posX * self._winScale,posY)
	self:addChild(self._silverBg)

	local silverIcon = display.newSprite("#common_coin_silver.png")
	silverIcon:setPosition(5, self._silverBg:getContentSize().height / 2 + 3)
	self._silverBg:addChild(silverIcon)

	self._silverLabel = lt.GameBMLabel.new(1, "#fonts/ui_num_19.fnt")
	self._silverLabel:setPosition(self._silverBg:getContentSize().width / 2, self._silverBg:getContentSize().height / 2 )
	self._silverLabel:setAdditionalKerning(-2)
	self._silverBg:addChild(self._silverLabel)

	local addIcon = display.newSprite("#city_img_add.png")
	addIcon:setPosition(self._silverBg:getContentSize().width - 15, self._silverBg:getContentSize().height / 2 + 2)
	self._silverBg:addChild(addIcon)

	-- 金币
	self._goldBg = display.newScale9Sprite("#city_img_coin.png", 0, 0, self._conmonBgSize)
	self._goldBg:setScale(self._winScale)
	self._goldBg:setAnchorPoint(0, 0.5)
	self._goldBg:setPosition(self._silverBg:getPositionX() + self._silverBg:getContentSize().width + self._bgPadding, posY)
	self:addChild(self._goldBg)

	local goldIcon = display.newSprite("#common_coin_gold.png")
	goldIcon:setPosition(5, self._goldBg:getContentSize().height / 2 + 3)
	self._goldBg:addChild(goldIcon)

	self._goldLabel = lt.GameBMLabel.new(1, "#fonts/ui_num_19.fnt")
	self._goldLabel:setPosition(self._goldBg:getContentSize().width / 2, self._goldBg:getContentSize().height / 2)
	self._goldLabel:setAdditionalKerning(-2)
	self._goldBg:addChild(self._goldLabel)

	local addIcon = display.newSprite("#city_img_add.png")
	addIcon:setPosition(self._goldBg:getContentSize().width - 15, self._goldBg:getContentSize().height / 2 + 2)
	self._goldBg:addChild(addIcon)

	-- 钻石
	self._diamondBg = display.newScale9Sprite("#city_img_coin.png", 0, 0, self._conmonBgSize)
	self._diamondBg:setScale(self._winScale)
	self._diamondBg:setAnchorPoint(0, 0.5)
	self._diamondBg:setPosition(self._goldBg:getPositionX() + self._goldBg:getContentSize().width + self._bgPadding, posY)
	self:addChild(self._diamondBg)

	local diamondIcon = display.newSprite("#common_diamond.png")
	diamondIcon:setPosition(5, self._diamondBg:getContentSize().height / 2 + 4)
	self._diamondBg:addChild(diamondIcon)

	self._diamondLabel = lt.GameBMLabel.new(0, "#fonts/ui_num_19.fnt")
	self._diamondLabel:setPosition(self._diamondBg:getContentSize().width / 2, self._diamondBg:getContentSize().height / 2)
	self._diamondLabel:setAdditionalKerning(-2)
	self._diamondBg:addChild(self._diamondLabel)

	local addIcon = display.newSprite("#city_img_add.png")
	addIcon:setPosition(self._diamondBg:getContentSize().width - 15, self._diamondBg:getContentSize().height / 2 + 2)
	self._diamondBg:addChild(addIcon)

	self:updateInfo()
end

function TopBanner:onEnter()
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PLAYER_COIN_REFRESH, handler(self, self.updateInfo), "TopBanner:updateInfo")
end

function TopBanner:onExit()
	lt.GameEventManager:removeListener("TopBanner:updateInfo")
end

function TopBanner:onTouch(event)
	local name, x, y = event.name, event.x, event.y

    local point = cc.p(x, y)

    if self._silverBg:getCascadeBoundingBox():containsPoint(point) then
        self:onSilver()
    elseif self._goldBg:getCascadeBoundingBox():containsPoint(point) then
	    self:onGold()
	elseif self._diamondBg:getCascadeBoundingBox():containsPoint(point) then
        self:onDiamond()
	end
end

function TopBanner:updateInfo()
	local player = lt.DataManager:getPlayer()
	if not player then
		return
	end

	self._silverLabel:setString(player:getCoin())
	self._goldLabel:setString(player:getGold())
	self._diamondLabel:setString(player:getDiamond())
end

function TopBanner:onDiamond()
	if self._delegate then
		local worldMenuLayer = self._delegate:getWorldMenuLayer()
		worldMenuLayer:onShopClub({panel = lt.ShopClubLayer.PANEL.CHARGE})
	end
end

function TopBanner:getCommonCoinExchangeLayer()
	if not self._commonCoinExchangeLayer then
		self._commonCoinExchangeLayer = lt.CommonCoinExchangeLayer.new(self)
		lt.UILayerManager:addLayer(self._commonCoinExchangeLayer,true)
	end

	return self._commonCoinExchangeLayer
end

function TopBanner:clearCommonCoinExchangeLayer()
	if self._commonCoinExchangeLayer then
        lt.UILayerManager:removeLayer(self._commonCoinExchangeLayer)
        self._commonCoinExchangeLayer = nil
    end
end

function TopBanner:onGold()
	self:getCommonCoinExchangeLayer():updateInfo(lt.Constants.CURRENCY_TYPE.GOLD)
end

function TopBanner:onSilver()
	self:getCommonCoinExchangeLayer():updateInfo(lt.Constants.CURRENCY_TYPE.COIN)
end

return TopBanner
