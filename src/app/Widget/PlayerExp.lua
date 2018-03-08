
local PlayerExp = class("PlayerExp", function()
	return display.newNode()
end)
PlayerExp._winScale = lt.CacheManager:getWinScale()


PlayerExp._type = nil

PlayerExp._bg  = nil
PlayerExp._bar = nil

PlayerExp._level = nil
PlayerExp._percent = nil
PlayerExp._targetLevel = nil
PlayerExp._targetPercent = nil
PlayerExp._info = nil
PlayerExp._scheduleHandle = nil
--[[

	bg 背景图

	bar 进度条
]]

PlayerExp._netLevel = nil
PlayerExp._updateHandler = nil

function PlayerExp:ctor()
    self:setNodeEventEnabled(true)

    local expWidth = display.width
    local size = cc.size(display.width,5)
    local expBg = display.newScale9Sprite("#common_bar_expbg.png", 0, 0, size)
    expBg:setAnchorPoint(0,0)
    self:addChild(expBg)


    self._bar = display.newProgressTimer("image/ui/common/common_bar_exp.png", 1)
    self._bar:setPosition(0, 0)
    self._bar:setAnchorPoint(0, 0)
    self._bar:setMidpoint(cc.p(0,0))
    self._bar:setBarChangeRate(cc.p(1,0))
    self._bar:setScaleX(expWidth)
    expBg:addChild(self._bar)

    for i = 1, 9 do
    	local sprite = display.newSprite("#common_bar_blackline.png")
    	expBg:addChild(sprite)
    	sprite:setAnchorPoint(0,0)
    	sprite:setPositionX(expWidth/10 * i)
    end

    self._levelLable = lt.GameLabel.new("", 10, lt.Constants.DEFAULT_LABEL_COLOR_2, {outline = 1})
    self._levelLable:setAnchorPoint(0,0)
    self._levelLable:setPosition(5,-2)
    expBg:addChild(self._levelLable,200)

    self._expLable = lt.GameLabel.new("", 10, lt.Constants.DEFAULT_LABEL_COLOR_2, {outline = 1})
    self._expLable:setAnchorPoint(0,0)
    self._expLable:setPositionY(self._levelLable:getPositionY())
    expBg:addChild(self._expLable,200)

    local expPercentBg = display.newSprite("#common_bar_exp_percent.png")
    expPercentBg:setAnchorPoint(0, 0)
    expPercentBg:setPosition(0, 5)
    self:addChild(expPercentBg)

    if lt.Constants.IPHONEX then
        expPercentBg:setPositionX(lt.Constants.IPHONEX_PADDING)
    end

    self._percentLable = lt.GameLabel.new("", 13, lt.Constants.COLOR.RUNE_GREEN)
    self._percentLable:setAnchorPoint(0, 0.5)
    self._percentLable:setPosition(2, expPercentBg:getContentSize().height / 2)
    expPercentBg:addChild(self._percentLable,200)

    self:updateInfo()
end

function PlayerExp:onEnter()
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PLAYER_UPDATE_EXP, handler(self, self.updateInfo), "PlayerExp:updateInfo1")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PLAYER_LEVEL_UP, handler(self, self.updateInfo), "PlayerExp:updateInfo2")
end

function PlayerExp:onExit()
	lt.GameEventManager:removeListener("PlayerExp:updateInfo1")
    lt.GameEventManager:removeListener("PlayerExp:updateInfo2")
end

function PlayerExp:updateInfo()
    local player = lt.DataManager:getPlayer()
	if not player then
        return
    end

	local playerLevel = lt.DataManager:getPlayerLevel()

	local percent = 0
    local newExpStr = ""


	local currentExp = player:getExp()
	local curLevelExpInfo = lt.CacheManager:getLevelExpInfo(playerLevel)

	
	if curLevelExpInfo then
		local maxExp = curLevelExpInfo:getExpTotal()
		local exp = curLevelExpInfo:getExp()
		local baseExp = math.max(currentExp - (maxExp - exp), 0)

		percent = baseExp / exp * 100
        newExpStr = baseExp.."/"..exp
	end



	--percent = lt.CommonUtil:fixValue(percent, 0, 100)
	self._bar:setPercentage(percent)

	local a,b = math.modf(percent)

    --local realPercent = a.."."..math.floor(b * 10).."%"

    local realPercent = string.format("%.2f", percent)

	self._percentLable:setString("EXP  "..realPercent.."%")

	

	-- local levelStr = string.format(lt.StringManager:getString("STRING_COMMON_PLAYER_LV"), playerLevel)
	-- local peakLevel = player:getExtremeLevel()
	-- if peakLevel > 0 then
	-- 	levelStr = levelStr.."(+"..peakLevel..")"
	-- end


 --    --2016、12、12改为显示多少/多少

	-- local expStr = string.format(lt.StringManager:getString("STRING_COMMON_PLAYER_EXP_FLOOR"), newExpStr)
	-- self._levelLable:setString(levelStr)
	-- self._expLable:setPositionX(self._levelLable:getPositionX() + self._levelLable:getContentSize().width + 5)
	-- self._expLable:setString(expStr)

end

return PlayerExp
