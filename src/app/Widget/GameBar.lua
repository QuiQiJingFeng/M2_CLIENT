
local GameBar = class("GameBar", function(type)
	return display.newSprite()
end)
GameBar._winScale = lt.CacheManager:getWinScale()
GameBar.TYPE = {
	EXP = 0,
	HERO_CITY = 1,
	SHOP = 2,
	ACTIVITY = 4, -- 活跃活动
}

GameBar._type = nil

GameBar._bg  = nil
GameBar._bar = nil

GameBar._level = nil
GameBar._percent = nil
GameBar._targetLevel = nil
GameBar._targetPercent = nil
GameBar._info = nil
GameBar._scheduleHandle = nil
--[[

	bg 背景图

	bar 进度条
]]

function GameBar:ctor(type)
    self:setNodeEventEnabled(true)

	self._type = type

	if type == self.TYPE.EXP then
		local frame = display.newSpriteFrame("common_exp_bg.png")
		if frame then
			self:setSpriteFrame(frame)
		end

		self._bar = display.newProgressTimer("#common_exp_bar.png", 1)
		self._bar:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self._bar:setMidpoint(cc.p(0,0));
		self._bar:setBarChangeRate(cc.p(1,0));
		self:addChild(self._bar)
	elseif type == self.TYPE.HERO_CITY then
		local frame = display.newSpriteFrame("hero_icon_barbg.png")
		if frame then
			self:setSpriteFrame(frame)
		end

		self._bar = display.newProgressTimer("#hero_icon_bar.png", 1)
		self._bar:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self._bar:setMidpoint(cc.p(0,0));
		self._bar:setBarChangeRate(cc.p(1,0));
		self:addChild(self._bar)
	elseif type == self.TYPE.SHOP then
		local frame = display.newSpriteFrame("shop_icon_exp_back.png")
		if frame then
			self:setSpriteFrame(frame)
		end

		self._bar = display.newProgressTimer("#shop_icon_exp_front.png", 1)
		self._bar:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self._bar:setMidpoint(cc.p(0,0));
		self._bar:setBarChangeRate(cc.p(1,0));
		self:addChild(self._bar)

	elseif type == self.TYPE.ACTIVITY then
		local frame = display.newSpriteFrame("activity_img_progressbg.png")
		if frame then
			self:setSpriteFrame(frame)
		end

		self._bar = display.newProgressTimer("#activity_img_progress.png", 1)
		self._bar:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self._bar:setMidpoint(cc.p(0,0));
		self._bar:setBarChangeRate(cc.p(1,0));
		self:addChild(self._bar)
	end
end

function GameBar:onExit()
	if self._scheduleHandle then
		lt.scheduler.unscheduleGlobal(self._scheduleHandle)
		self._scheduleHandle = nil
	end
end

function GameBar:updateInfo(params)
	if self._type == self.TYPE.EXP then
		local level   = 1
		local percent = 0

		if params and params.level then
			level = params.level
		end

		if params and params.exp and params.type then
			-- 计算
			local curExp = params.exp
			local type = params.type

			local curCardExpInfo = lt.CacheManager:getCardExpInfoByLevel(level)
			if curCardExpInfo then
				local maxExp = curCardExpInfo:getTotalExp(type)
				local exp = curCardExpInfo:getExp(type)

				local baseExp = math.max(curExp - (maxExp - exp), 0)

				percent = baseExp / exp * 100
			end
		end

		percent = lt.CommonUtil:fixValue(percent, 0, 100)

		if params.refresh then
			self._targetLevel = math.max(level, self._level or 1)
			self._targetPercent = percent

			if self._scheduleHandle then
				lt.scheduler.unscheduleGlobal(self._scheduleHandle)
				self._scheduleHandle = nil
			end
			self._scheduleHandle = lt.scheduler.scheduleUpdateGlobal(handler(self, self.update))
		else
			self._bar:setPercentage(percent)

			self._level = level
			self._percent = percent

			if not self._info then
				self._info = lt.GameLabel.new(string.format("Lv.%d(%.1f%%)", level, percent), 16, lt.Constants.COLOR.WHITE, {outline = 1, outlineColor = lt.Constants.COLOR.BROWN, outlineSize = 1})
				self._info:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
				self:addChild(self._info, 10)
			else
				self._info:setString(string.format("Lv.%d(%.1f%%)", level, percent))
			end
		end
	elseif self._type == self.TYPE.HERO_CITY then
		local level   = 1
		local percent = 0
		--普通等级经验
		if params and params.level then
			level = params.level
		end

		if params and params.exp then
			-- 计算
			local curExp = params.exp

			local curLevelExpInfo = lt.CacheManager:getLevelExpInfo(level)
			if curLevelExpInfo then
				local maxExp = curLevelExpInfo:getExpTotal()
				local exp = curLevelExpInfo:getExp()
				local baseExp = math.max(curExp - (maxExp - exp), 0)

				percent = baseExp / exp * 100
			end
		end

		--巅峰等级经验
		if params and params.peakLevel then
			level = params.peakLevel
		end

		if params and params.peakExp then
			-- 计算
			local curExp = params.peakExp

			
			local curLevelExpInfo = lt.CacheManager:getPeakLevelExpInfo(level)
			if curLevelExpInfo then
				local maxExp = curLevelExpInfo:getExpTotal()

				local exp = curLevelExpInfo:getExp()

				local baseExp = math.max(curExp - (maxExp - exp), 0)

				percent = baseExp / exp * 100
			end
		end

		percent = lt.CommonUtil:fixValue(percent, 0, 100)
		self._bar:setPercentage(percent)

        local a,b = math.modf(percent)

        local realPercent = a.."."..math.floor(b * 10).."%"



		-- if not self._info then
		-- 	self._info = lt.GameBMLabel.new(realPercent, "#fonts/ui_font_2.fnt")
		-- 	self._info:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2 - 1)
		-- 	self:addChild(self._info, 10)
		-- else
		-- 	self._info:setString(realPercent)
		-- end
	elseif self._type == self.TYPE.SHOP then
		local level   = 1
		local percent = 0
		local strInfo = ""
		if params and params.level then
			level = params.level
		end

		if params and params.exp then
			-- 计算
			local curExp = params.exp

			local currVipInfo = lt.CacheManager:getVipInfoByLevel(level)
			local currExp = currVipInfo:getRechargeDiamond()
			local nextVipInfo = lt.CacheManager:getVipInfoByLevel(level+1)
			if nextVipInfo then
				local nextExp = nextVipInfo:getRechargeDiamond()
				local exp = nextExp - currExp
				local baseExp = curExp - currExp
				strInfo = baseExp.."/"..exp
				percent = baseExp / exp * 100
			else
				strInfo = "MAX"
				percent = 100
			end
		end

		percent = lt.CommonUtil:fixValue(percent, 0, 100)
		self._bar:setPercentage(percent)

		if not self._info then
			self._info = lt.GameBMLabel.new(strInfo, "#fonts/ui_num_2.fnt")
			self._info:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2 - 1)
			self:addChild(self._info, 10)
		else
			self._info:setString(strInfo)
		end
	elseif self._type == self.TYPE.ACTIVITY then
		local maxExp = 110
		local strInfo = 0
		if params and params.exp then
			local curExp = params.exp
			percent = curExp / maxExp * 100
			strInfo = curExp
		end
		percent = lt.CommonUtil:fixValue(percent, 0, 100)
		self._bar:setPercentage(percent)

		self._infoBg = display.newSprite("#activity_img_numbg.png")

		self._infoBg:setPosition(self:getContentSize().width*percent/100,self:getContentSize().height / 2)
		if percent >= 98 then
			self._infoBg:setPosition(self:getContentSize().width*percent/100 - 13,self:getContentSize().height / 2)
		end

		if percent == 0 then
			self._infoBg:setPosition(self:getContentSize().width*percent/100 + 13,self:getContentSize().height / 2)
		end

		self:addChild(self._infoBg,10)

		
		local numLabel = lt.GameBMLabel.new(strInfo, "#fonts/ui_num_8.fnt")
		numLabel:setPosition(self._infoBg:getContentSize().width / 2, self._infoBg:getContentSize().height / 2 - 2)
		--numLabel:setAdditionalKerning(-5)
		self._infoBg:addChild(numLabel)
	end
end

function GameBar:update(dt)
	local speed = 80

	local percent = self._percent + speed * dt

	if percent >= self._targetPercent then
		if self._level >= self._targetLevel then
			self._level = self._targetLevel
			percent = self._targetPercent

			if self._scheduleHandle then
				lt.scheduler.unscheduleGlobal(self._scheduleHandle)
				self._scheduleHandle = nil
			end
		else
			if percent >= 100 then
				percent = 0
				self._level = self._targetLevel
			end
		end
	end

	self._percent = percent

	self._bar:setPercentage(self._percent)
	self._info:setString(string.format("Lv.%d(%.1f%%)", self._level, self._percent))
end

return GameBar
