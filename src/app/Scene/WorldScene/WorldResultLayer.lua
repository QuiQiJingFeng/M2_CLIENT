
local WorldResultLayer = class("WorldResultLayer", function()
	return display.newLayer()
end)

WorldResultLayer._winScale = lt.CacheManager:getWinScale()

WorldResultLayer._delegate = nil

function WorldResultLayer:ctor(delegate)
	self:setNodeEventEnabled(true)

	self._delegate = delegate

	local maskLayer = lt.MaskLayer.new()
	self:addChild(maskLayer, -1)

	local bgL = display.newSprite("image/ui/battle_info_bg.png")
	bgL:setAnchorPoint(1, 0.5)
	bgL:setPosition(display.cx, display.cy)
	self:addChild(bgL)

	local bgR = display.newSprite("image/ui/battle_info_bg.png")
	bgR:setAnchorPoint(0, 0.5)
	bgR:setFlippedX(true)
	bgR:setPosition(display.cx, display.cy)
	self:addChild(bgR)

	local loseIcon = display.newSprite("#battle_result_lose.png")
	loseIcon:setPosition(display.cx, display.cy + 206)
	self:addChild(loseIcon)

	local info1L = display.newSprite("#battle_label_bg.png")
	info1L:setAnchorPoint(1, 0.5)
	info1L:setPosition(display.cx, display.cy + 116)
	self:addChild(info1L)

	local info1R = display.newSprite("#battle_label_bg.png")
	info1R:setAnchorPoint(0, 0.5)
	info1R:setFlippedX(true)
	info1R:setPosition(display.cx, display.cy + 116)
	self:addChild(info1R)

	self._tips1 = lt.GameLabel.new("", 18, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
	self._tips1:setPosition(display.cx, display.cy + 116)
	self:addChild(self._tips1)

	local iconHeight = 12
	local labelHeight = -66

	local loseRecommend1 = lt.PushButton.new("image/ui/common/touch_rect_80.png", {scale9 = true})
	loseRecommend1:setButtonSize(120, 120)
	loseRecommend1:setPosition(display.cx - 210, display.cy + 20)
	loseRecommend1:onButtonClicked(handler(self, self.onRecommend1))
	self:addChild(loseRecommend1)

	local icon1 = display.newSprite("#result_lose_recommend_1.png")
	icon1:setPosition(0, iconHeight)
	loseRecommend1:addChild(icon1)

	local label1 = lt.GameLabel.newString("STRING_BATTLE_RESULT_RECOMMEND_1", 18, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
	label1:setPosition(0, labelHeight)
	loseRecommend1:addChild(label1)

	local loseRecommend2 = lt.PushButton.new("image/ui/common/touch_rect_80.png", {scale9 = true})
	loseRecommend2:setButtonSize(120, 120)
	loseRecommend2:setPosition(display.cx - 70, display.cy + 20)
	loseRecommend2:onButtonClicked(handler(self, self.onRecommend2))
	self:addChild(loseRecommend2)

	local icon2 = display.newSprite("#result_lose_recommend_2.png")
	icon2:setPosition(0, iconHeight)
	loseRecommend2:addChild(icon2)

	local label2 = lt.GameLabel.newString("STRING_BATTLE_RESULT_RECOMMEND_2", 18, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
	label2:setPosition(0, labelHeight)
	loseRecommend2:addChild(label2)

	local loseRecommend3 = lt.PushButton.new("image/ui/common/touch_rect_80.png", {scale9 = true})
	loseRecommend3:setButtonSize(120, 120)
	loseRecommend3:setPosition(display.cx + 70, display.cy + 20)
	loseRecommend3:onButtonClicked(handler(self, self.onRecommend3))
	self:addChild(loseRecommend3)

	local icon3 = display.newSprite("#result_lose_recommend_3.png")
	icon3:setPosition(0, iconHeight)
	loseRecommend3:addChild(icon3)

	local label3 = lt.GameLabel.newString("STRING_BATTLE_RESULT_RECOMMEND_3", 18, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
	label3:setPosition(0, labelHeight)
	loseRecommend3:addChild(label3)

	local loseRecommend4 = lt.PushButton.new("image/ui/common/touch_rect_80.png", {scale9 = true})
	loseRecommend4:setButtonSize(120, 120)
	loseRecommend4:setPosition(display.cx + 210, display.cy + 20)
	loseRecommend4:onButtonClicked(handler(self, self.onRecommend4))
	self:addChild(loseRecommend4)

	local icon4 = display.newSprite("#result_lose_recommend_4.png")
	icon4:setPosition(0, iconHeight)
	loseRecommend4:addChild(icon4)

	local label4 = lt.GameLabel.newString("STRING_BATTLE_RESULT_RECOMMEND_4", 18, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
	label4:setPosition(0, labelHeight)
	loseRecommend4:addChild(label4)

	local info2L = display.newSprite("#battle_label_bg.png")
	info2L:setAnchorPoint(1, 0.5)
	info2L:setPosition(display.cx, display.cy - 116)
	self:addChild(info2L)

	local info2R = display.newSprite("#battle_label_bg.png")
	info2R:setAnchorPoint(0, 0.5)
	info2R:setFlippedX(true)
	info2R:setPosition(display.cx, display.cy - 116)
	self:addChild(info2R)

	self._tips2 = lt.GameLabel.new("", 18, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
	self._tips2:setPosition(display.cx, display.cy - 116)
	self:addChild(self._tips2)
end

function WorldResultLayer:onEnter()
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))
end

function WorldResultLayer:onExit()
	if self._cityReliveUpdateHandler then
		lt.scheduler.unscheduleGlobal(self._cityReliveUpdateHandler)
		self._cityReliveUpdateHandler = nil
	end

	if self._cityQuitUpdateHandler then
		lt.scheduler.unscheduleGlobal(self._cityQuitUpdateHandler)
		self._cityQuitUpdateHandler = nil
	end

	if self._campReliveUpdateHandler then
		lt.scheduler.unscheduleGlobal(self._campReliveUpdateHandler)
		self._campReliveUpdateHandler = nil
	end

	if self._quitCommitLayer then
		self._quitCommitLayer = nil
	end
end

-- 点击事件
function WorldResultLayer:onTouch(event)
    if event.name == "began" then
    	self:mini()
    	return
    end
end

function WorldResultLayer:updateInfo(params)
	params = params or {}

	local battleAllDead = params.battleAllDead
	local battleAllDeadExtra1 = params.battleAllDeadExtra1

	local buttonY = display.cy - 210

	if battleAllDead and battleAllDeadExtra1 and battleAllDeadExtra1 == 1 then
		-- 超时失败
		self._tips1:setString(lt.StringManager:getString("STRING_BATTLE_RESULT_LOSE_TIPS_3"))

		self._quitBtn = lt.ScaleBMLabelButton.newGray("STRING_BATTLE_RESULT_QUIT", "select_btn.fnt")
		self._quitBtn:setPosition(display.cx, buttonY)
		self._quitBtn:onButtonClicked(handler(self, self.onQuit))
		self:addChild(self._quitBtn)

		self._tips2:setString("")
	else
		local opponent = params.opponent
		if opponent then
			self._tips1:setString(string.format(lt.StringManager:getString("STRING_BATTLE_RESULT_LOSE_TIPS_2"), opponent))
		else
			self._tips1:setString(lt.StringManager:getString("STRING_BATTLE_RESULT_LOSE_TIPS_1"))
		end

		local envType = params.envType or 1
		if envType == lt.Constants.ENV_TYPE.FIELD
		or envType == lt.Constants.ENV_TYPE.CITY
		or envType == lt.Constants.ENV_TYPE.WORLD_BOSS_FIELD
		or envType == lt.Constants.ENV_TYPE.GUILD_BOSS
		or envType == lt.Constants.ENV_TYPE.WORLD_BOSS then
			-- 主城/野外 主城复活/代价复活/等待救援
			local cityReliveBtn = lt.ScaleBMLabelButton.newBlue("STRING_BATTLE_RESULT_RELIVE_CITY", "select_btn.fnt")
			cityReliveBtn:setPosition(display.cx - 200, buttonY)
			cityReliveBtn:onButtonClicked(handler(self, self.onCityRelive))
			self:addChild(cityReliveBtn)

			self._cityCountdown = lt.GameLabel.new("", 18, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
			self._cityCountdown:setPosition(cityReliveBtn:getPositionX(), cityReliveBtn:getPositionY() + 40)
			self:addChild(self._cityCountdown)

			local immediatelyReliveBtn = lt.ScaleBMLabelButton.newYellow("STRING_BATTLE_RESULT_RELIVE_IMMEDIATELY", "select_btn.fnt")
			immediatelyReliveBtn:setPosition(display.cx, buttonY)
			immediatelyReliveBtn:onButtonClicked(handler(self, self.onImmediatelyRelive))
			self:addChild(immediatelyReliveBtn)
			
			-- 复活状况
			self:immediatelyReliveInfo(immediatelyReliveBtn)

			local waitReliveBtn = lt.ScaleBMLabelButton.newYellow("STRING_BATTLE_RESULT_RELIVE_WAIT", "select_btn.fnt")
			waitReliveBtn:setPosition(display.cx + 200, buttonY)
			waitReliveBtn:onButtonClicked(handler(self, self.onMini))
			self:addChild(waitReliveBtn)

			self._tips2:setString(lt.StringManager:getString("STRING_BATTLE_RESULT_LOSE_TIPS_14"))

			self._cityReliveElapse = 0
			self._cityReliveDuration = lt.BattleConfig.RELIVE_CITY_DURATION
			self._cityReliveUpdateHandler = lt.scheduler.scheduleUpdateGlobal(handler(self, self.onCityReliveUpdate))
		elseif envType == lt.Constants.ENV_TYPE.DUNGEON
			or envType == lt.Constants.ENV_TYPE.TRANSCEND then
			-- 主线地下城 退出/代价复活/等待救援
			self._quitBtn = lt.ScaleBMLabelButton.newGray("STRING_BATTLE_RESULT_QUIT", "select_btn.fnt")
			self._quitBtn:setPosition(display.cx - 200, buttonY)
			self._quitBtn:onButtonClicked(handler(self, self.onQuit))
			self:addChild(self._quitBtn)

			self._cityCountdown = lt.GameLabel.new("", 18, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
			self._cityCountdown:setPosition(self._quitBtn:getPositionX(), self._quitBtn:getPositionY() + 40)
			self:addChild(self._cityCountdown)

			local immediatelyReliveBtn = lt.ScaleBMLabelButton.newYellow("STRING_BATTLE_RESULT_RELIVE_IMMEDIATELY", "select_btn.fnt")
			immediatelyReliveBtn:setPosition(display.cx, buttonY)
			immediatelyReliveBtn:onButtonClicked(handler(self, self.onImmediatelyRelive))
			self:addChild(immediatelyReliveBtn)
			
			self:immediatelyReliveInfo(immediatelyReliveBtn)

			local waitReliveBtn = lt.ScaleBMLabelButton.newYellow("STRING_BATTLE_RESULT_RELIVE_WAIT", "select_btn.fnt")
			waitReliveBtn:setPosition(display.cx + 200, buttonY)
			waitReliveBtn:onButtonClicked(handler(self, self.onMini))
			self:addChild(waitReliveBtn)

			self._tips2:setString(lt.StringManager:getString("STRING_BATTLE_RESULT_LOSE_TIPS_14"))

			self._cityQuitEnable = false
			self._cityQuitElapse = 0
			self._cityQuitDuration = 3
			self._cityQuitUpdateHandler = lt.scheduler.scheduleUpdateGlobal(handler(self, self.onCityQuitUpdate))
		elseif envType == lt.Constants.ENV_TYPE.MONSTER_PURIFICATION
			or envType == lt.Constants.ENV_TYPE.PITLORD
			or envType == lt.Constants.ENV_TYPE.GUARD 
			or envType == lt.Constants.ENV_TYPE.TREASURE then

			self._quitBtn = lt.ScaleBMLabelButton.newGray("STRING_BATTLE_RESULT_QUIT", "select_btn.fnt")
			self._quitBtn:setPosition(display.cx - 100, buttonY)
			self._quitBtn:onButtonClicked(handler(self, self.onQuit))
			self:addChild(self._quitBtn)

			self._cityCountdown = lt.GameLabel.new("", 18, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
			self._cityCountdown:setPosition(self._quitBtn:getPositionX(), self._quitBtn:getPositionY() + 40)
			self:addChild(self._cityCountdown)
			
			local waitReliveBtn = lt.ScaleBMLabelButton.newYellow("STRING_BATTLE_RESULT_RELIVE_WAIT", "select_btn.fnt")
			waitReliveBtn:setPosition(display.cx + 100, buttonY)
			waitReliveBtn:onButtonClicked(handler(self, self.onMini))
			self:addChild(waitReliveBtn)

			self._tips2:setString(lt.StringManager:getString("STRING_BATTLE_RESULT_LOSE_TIPS_11"))

			self._cityQuitEnable = false
			self._cityQuitElapse = 0
			self._cityQuitDuration = 3
			self._cityQuitUpdateHandler = lt.scheduler.scheduleUpdateGlobal(handler(self, self.onCityQuitUpdate))
		elseif envType == lt.Constants.ENV_TYPE.ADVENTURE_TRIAL
			or envType == lt.Constants.ENV_TYPE.GUILD_FAM
			or envType == lt.Constants.ENV_TYPE.CREAM_BOSS
			or envType == lt.Constants.ENV_TYPE.MONSTER_ATTACK then

			self._quitBtn = lt.ScaleBMLabelButton.newGray("STRING_BATTLE_RESULT_QUIT", "select_btn.fnt")
			self._quitBtn:setPosition(display.cx - 200, buttonY)
			self._quitBtn:onButtonClicked(handler(self, self.onQuit))
			self:addChild(self._quitBtn)

			self._cityCountdown = lt.GameLabel.new("", 18, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
			self._cityCountdown:setPosition(self._quitBtn:getPositionX(), self._quitBtn:getPositionY() + 40)
			self:addChild(self._cityCountdown)

			local immediatelyReliveBtn = lt.ScaleBMLabelButton.newYellow("STRING_BATTLE_RESULT_RELIVE_IMMEDIATELY", "select_btn.fnt")
			immediatelyReliveBtn:setPosition(display.cx, buttonY)
			immediatelyReliveBtn:onButtonClicked(handler(self, self.onImmediatelyRelive))
			self:addChild(immediatelyReliveBtn)

			self:immediatelyReliveInfo(immediatelyReliveBtn)

			local waitReliveBtn = lt.ScaleBMLabelButton.newYellow("STRING_BATTLE_RESULT_RELIVE_WAIT", "select_btn.fnt")
			waitReliveBtn:setPosition(display.cx + 200, buttonY)
			waitReliveBtn:onButtonClicked(handler(self, self.onMini))
			self:addChild(waitReliveBtn)

			self._tips2:setString(lt.StringManager:getString("STRING_BATTLE_RESULT_LOSE_TIPS_13"))

			self._cityQuitEnable = false
			self._cityQuitElapse = 0
			self._cityQuitDuration = 3
			self._cityQuitUpdateHandler = lt.scheduler.scheduleUpdateGlobal(handler(self, self.onCityQuitUpdate))
		elseif envType == lt.Constants.ENV_TYPE.GUIDE then
			local immediatelyReliveBtn = lt.ScaleBMLabelButton.newYellow("STRING_BATTLE_RESULT_RELIVE_IMMEDIATELY", "select_btn.fnt")
			immediatelyReliveBtn:setPosition(display.cx, buttonY)
			immediatelyReliveBtn:onButtonClicked(handler(self, self.onImmediatelyRelive))
			self:addChild(immediatelyReliveBtn)
		elseif envType == lt.Constants.ENV_TYPE.ARENA_3V3 then
			-- 5S后阵营复活
			self._campReliveBtn = lt.ScaleBMLabelButton.newGray("STRING_BATTLE_RESULT_RELIVE_CAMP", "select_btn.fnt")
			self._campReliveBtn:setPosition(display.cx, buttonY)
			self._campReliveBtn:onButtonClicked(handler(self, self.onCampRelive))
			self:addChild(self._campReliveBtn)

			self._campReliveCountdown = lt.GameLabel.new("", 18, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
			self._campReliveCountdown:setPosition(self._campReliveBtn:getPositionX(), self._campReliveBtn:getPositionY() + 40)
			self:addChild(self._campReliveCountdown)

			self._campReliveEnable = false
			self._campReliveElapse = 0
			self._campReliveDuration = 5
			self._campReliveUpdateHandler = lt.scheduler.scheduleUpdateGlobal(handler(self, self.onCampReliveUpdate))
		elseif envType == lt.Constants.ENV_TYPE.SE_DEBUG then
			local reliveBtn = lt.ScaleBMLabelButton.newBlue("STRING_BATTLE_RESULT_RELIVE_IMMEDIATELY", "select_btn.fnt")
			reliveBtn:setPosition(display.cx - 100, buttonY)
			reliveBtn:onButtonClicked(handler(self, self.onFreeRelive))
			self:addChild(reliveBtn)

			local waitReliveBtn = lt.ScaleBMLabelButton.newYellow("STRING_BATTLE_RESULT_RELIVE_WAIT", "select_btn.fnt")
			waitReliveBtn:setPosition(display.cx + 100, buttonY)
			waitReliveBtn:onButtonClicked(handler(self, self.onMini))
			self:addChild(waitReliveBtn)
		elseif envType == lt.Constants.ENV_TYPE.MAZE then
			local mazeReliveBtn = lt.ScaleBMLabelButton.newBlue("STRING_BATTLE_RESULT_RELIVE_MAZE", "select_btn.fnt")
			mazeReliveBtn:setPosition(display.cx, buttonY)
			mazeReliveBtn:onButtonClicked(handler(self, self.onMazeRelive))
			self:addChild(mazeReliveBtn)
		else
			lt.CommonUtil.print("lack for WorldResultLayer:updateInfo of type "..envType)

			local closeBtn = lt.ScaleBMLabelButton.newBlue("STRING_BATTLE_RESULT_QUIT", "select_btn.fnt")
			closeBtn:setPosition(display.cx, buttonY)
			closeBtn:onButtonClicked(handler(self, self.onClose))
			self:addChild(closeBtn)
		end
	end
end

function WorldResultLayer:onCityReliveUpdate(delta)
	self._cityReliveElapse = self._cityReliveElapse + delta

	if self._cityReliveElapse > self._cityReliveDuration then
		self:onCityRelive()
		return
	end

	-- 倒计时显示
	local cityReliveStr = string.format(lt.StringManager:getString("STRING_BATTLE_RESULT_COUNTDOWN"), math.max(0, self._cityReliveDuration - self._cityReliveElapse))

	self._cityCountdown:setString(cityReliveStr)
end

function WorldResultLayer:onCityQuitUpdate(delta)
	self._cityQuitElapse = self._cityQuitElapse + delta

	if self._cityQuitElapse > self._cityQuitDuration then
		if self._cityQuitUpdateHandler then
			lt.scheduler.unscheduleGlobal(self._cityQuitUpdateHandler)
			self._cityQuitUpdateHandler = nil
		end

		self._cityQuitEnable = true
		self._quitBtn:setButtonImage(lt.PushButton.NORMAL, "#common_btn_blue_new.png")
		self._quitBtn:setButtonImage(lt.PushButton.PRESSED, "#common_btn_blue_new.png")
		self._cityCountdown:setVisible(false)
		return
	end

	-- 倒计时显示
	local cityReliveStr = string.format(lt.StringManager:getString("STRING_BATTLE_RESULT_COUNTDOWN"), math.max(0, self._cityQuitDuration - self._cityQuitElapse))

	self._cityCountdown:setString(cityReliveStr)
end

function WorldResultLayer:onCampReliveUpdate(delta)
	self._campReliveElapse = self._campReliveElapse + delta

	if self._campReliveElapse > self._campReliveDuration then
		if self._campReliveUpdateHandler then
			lt.scheduler.unscheduleGlobal(self._campReliveUpdateHandler)
			self._campReliveUpdateHandler = nil
		end

		self._campReliveEnable = true
		self._campReliveBtn:setButtonImage(lt.PushButton.NORMAL, "#common_btn_yellow_new.png")
		self._campReliveBtn:setButtonImage(lt.PushButton.PRESSED, "#common_btn_yellow_new.png")
		self._campReliveCountdown:setVisible(false)

		self:onCampRelive()
		return
	end

	-- 倒计时显示
	local campReliveStr = string.format(lt.StringManager:getString("STRING_BATTLE_RESULT_COUNTDOWN"), math.max(0, self._campReliveDuration - self._campReliveElapse))

	self._campReliveCountdown:setString(campReliveStr)
end

function WorldResultLayer:onRecommend1()
	self._delegate:onStrongBtn()

	self:mini()
end

function WorldResultLayer:onRecommend2()
	self._delegate:onEquipMake()

	self:mini()
end

function WorldResultLayer:onRecommend3()
	self._delegate:onServant()

	self:mini()
end

function WorldResultLayer:onRecommend4()
	self._delegate:onHeroInfo({panel = lt.HeroInfoLayer.PANEL.STRENGTH})

	self:mini()
end

-- 主城复活
function WorldResultLayer:onCityRelive()
	self:close()

	local worldEntity = lt.EntityManager:queryWorldEntity()
    if worldEntity then
        worldEntity:onCityRelive()
    end
end

function WorldResultLayer:onFreeRelive()
	self:close()

	local worldEntity = lt.EntityManager:queryWorldEntity()
    if worldEntity then
        worldEntity:onFreeRelive()
    end
end

function WorldResultLayer:immediatelyReliveInfo(immediatelyReliveBtn)
	local playerLevel = lt.DataManager:getPlayerLevel()
	local reviveFreeCount = lt.DataManager:getReviveFreeCount()
	local reviveCurCount = lt.DataManager:getReviveCurCount()

	local immediatelyStr = ""
	if playerLevel < lt.BattleConfig.RELIVE_FREE_LEVEL then
		local immediatelyInfo = lt.GameLabel.newString("STRING_BATTLE_RESULT_RELIVE_FREE", 18, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
		immediatelyInfo:setPosition(immediatelyReliveBtn:getPositionX(), immediatelyReliveBtn:getPositionY() + 40)
		self:addChild(immediatelyInfo)
	else
		if reviveCurCount < reviveFreeCount then
			-- 还有免费复活
			local immediatelyStr = lt.StringManager:getFormatString("STRING_BATTLE_RESULT_RELIVE_FREE_TIMES", reviveFreeCount - reviveCurCount, reviveFreeCount)
			local immediatelyInfo = lt.GameLabel.new(immediatelyStr, 18, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
			immediatelyInfo:setPosition(immediatelyReliveBtn:getPositionX(), immediatelyReliveBtn:getPositionY() + 40)
			self:addChild(immediatelyInfo)
		else
			local itemCount = lt.DataManager:getItemCount(lt.Constants.ITEM.REVIVE_COIN)

			local immediatelyInfo1 = lt.GameLabel.newString("STRING_BATTLE_RESULT_RELIVE_USE_ITEM", 18, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
			immediatelyInfo1:setAnchorPoint(0, 0.5)
			self:addChild(immediatelyInfo1)

			local color = lt.Constants.COLOR.WHITE
			if itemCount <= 0 then
				color = lt.Constants.COLOR.RED
			end
			local immediatelyInfo2 = lt.GameLabel.new(itemCount.."/1", 18, color, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
			immediatelyInfo2:setAnchorPoint(0, 0.5)
			self:addChild(immediatelyInfo2)

			local width = immediatelyInfo1:getContentSize().width + immediatelyInfo2:getContentSize().width
			immediatelyInfo1:setPosition(display.cx - width / 2, immediatelyReliveBtn:getPositionY() + 40)
			immediatelyInfo2:setPosition(immediatelyInfo1:getPositionX() + immediatelyInfo1:getContentSize().width, immediatelyInfo1:getPositionY())
		end
	end
end

-- 道具复活
function WorldResultLayer:onImmediatelyRelive()
	-- 判断道具
	local playerLevel     = lt.DataManager:getPlayerLevel()
	local reviveFreeCount = lt.DataManager:getReviveFreeCount()
	local reviveCurCount  = lt.DataManager:getReviveCurCount()

	if playerLevel >= lt.BattleConfig.RELIVE_FREE_LEVEL then
		if reviveCurCount >= reviveFreeCount then
			-- 需要道具
			local itemCount = lt.DataManager:getItemCount(lt.Constants.ITEM.REVIVE_COIN)
			if itemCount <= 0 then
				lt.NoticeManager:addMessageString("STRING_BATTLE_RESULT_RELIVE_ITEM_NOT_ENOUGH")
				return
			end
		end
	end

	local currentTime = lt.CommonUtil:getCurrentTime()
	if self._immediatelyTime then
		if currentTime - self._immediatelyTime < 10 then
			-- 10s内只有一次立即复活有效
			return
		end
	end
	self._immediatelyTime = currentTime

	local worldEntity = lt.EntityManager:queryWorldEntity()
    if worldEntity then
        worldEntity:onImmediatelyRelive()
    end
end

-- 复活点复活
function WorldResultLayer:onCampRelive()
	if not self._campReliveEnable then
		return
	end

	self:close()

	local worldEntity = lt.EntityManager:queryWorldEntity()
    if worldEntity then
        worldEntity:onCampRelive()
    end
end

-- 迷宫起点复活
function WorldResultLayer:onMazeRelive()
	self:close()

	local worldEntity = lt.EntityManager:queryWorldEntity()
    if worldEntity then
        worldEntity:onMazeRelive()
    end
end

-- 最小化
function WorldResultLayer:onMini()
	self:mini()
end

function WorldResultLayer:mini()
	self._delegate:miniWorldResultLayer()
end

function WorldResultLayer:onQuit()
	if not self._cityQuitEnable then
		return
	end

	self._delegate:onBattleQuit()

    self:mini()
end

function WorldResultLayer:onQuitCommit()
	self._quitCommitLayer = nil

	self:onCityRelive()
end

function WorldResultLayer:onQuitCancel()
	self._quitCommitLayer = nil
end

function WorldResultLayer:onClose()
	self:close()
end

function WorldResultLayer:close()
	self._delegate:clearWorldResultLayer()
end

return WorldResultLayer
