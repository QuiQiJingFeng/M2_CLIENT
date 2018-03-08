
local NoticeManager = {}

NoticeManager._displayDelegate = nil

NoticeManager._addNoticeArray = {}
NoticeManager._updateNoticeArray = {}
NoticeManager._keepNoticeTable = {}

NoticeManager._addNoticeItemArray = {}
NoticeManager._updateNoticeItemArray = {}

NoticeManager._addElapse   = 0
NoticeManager._addInterval = 0.5
NoticeManager._updateHandler = nil
NoticeManager._updateItemHandler = nil

function NoticeManager:init(displayDelegate)
	self._displayDelegate = displayDelegate

	self._addNoticeArray = {}
	self._updateNoticeArray = {}

	self._addNoticeItemArray = {}
	self._updateNoticeItemArray = {}

	self._addRunindHorseArray = {}

	lt.ResourceManager:addArmature("ui_effect_drop_item_0", "effect/ui/ui_effect_drop_item_0.ExportJson")
	lt.ResourceManager:addArmature("ui_effect_drop_item_1", "effect/ui/ui_effect_drop_item_1.ExportJson")
end

function NoticeManager:clearAll()

	if not self._updateNoticeArray then
		return
	end

	for _, _cell in pairs(self._updateNoticeArray) do
		_cell:stopAllActions()
		_cell:removeFromParent()
	end
	self:clear()
end

function NoticeManager:clear()
	if self._updateHandler then
		lt.scheduler.unscheduleGlobal(self._updateHandler)
		self._updateHandler = nil
	end
	if self._updateItemHandler then
		lt.scheduler.unscheduleGlobal(self._updateItemHandler)
		self._updateItemHandler = nil
	end
	self._displayDelegate = nil

	self._addNoticeArray = nil
	self._updateNoticeArray = nil

	self._addNoticeItemArray = nil
	self._updateNoticeItemArray = nil

	self._addRunindHorseArray = nil

	lt.ResourceManager:removeArmature("ui_effect_drop_item_0", "effect/ui/ui_effect_drop_item_0.ExportJson")
	lt.ResourceManager:removeArmature("ui_effect_drop_item_1", "effect/ui/ui_effect_drop_item_1.ExportJson")
end

function NoticeManager:addNotice(noticeInfo)
	table.insert(self._addNoticeArray, noticeInfo)

	if not self._updateHandler then
		self._updateHandler = lt.scheduler.scheduleUpdateGlobal(handler(self, self.onUpdate))

		self._addElapse = self._addInterval
	end
end

function NoticeManager:addNoticeItem(itemType,itemId)
	if itemType == lt.GameIcon.TYPE.ITEM then
		local itemInfo = lt.CacheManager:getItemInfo(itemId)
		if itemInfo then
			if itemInfo:getType() == lt.Constants.ITEM_TYPE.VALUE then
				return
			end

			if itemInfo:getGrade() < lt.Constants.QUALITY.QUALITY_PURPLE then
				return
			end
		else
			return
		end
    else
    	local equipmentInfo = lt.CacheManager:getEquipmentInfo(itemId)
    	if equipmentInfo then
			if equipmentInfo:getQuality() < lt.Constants.QUALITY.QUALITY_PURPLE then
				return
			end
    	else
    		return
    	end
    end

	table.insert(self._addNoticeItemArray, {type=itemType,id=itemId})
	if not self._updateItemHandler then
		lt.AudioManager:preloadSound("ui/audio_drop_equip")
		self._updateItemHandler = lt.scheduler.scheduleUpdateGlobal(handler(self, self.onUpdateItem))
	end
end

function NoticeManager:addRunningHorse(chatInfo)
	table.insert(self._addRunindHorseArray, chatInfo)

	if not self._updateRunningHandler then
		self._updateRunningHandler = lt.scheduler.scheduleUpdateGlobal(handler(self, self.onUpdateRunning))
	end
end

function NoticeManager:addMessageString(key)
	self:addMessage(lt.StringManager:getString(key))
end

function NoticeManager:addMessage(message)
	self:addNotice({type = lt.NoticeCell.TYPE.MESSAGE, message = message})
end

function NoticeManager:addRichMessage(richMessage)
	self:addNotice({type = lt.NoticeCell.TYPE.RICH_MESSAGE, richMessage = richMessage})
end

function NoticeManager:addSimpleItemMessage(simpleItemInfo, params)
	local type  = simpleItemInfo:getType()
	local id    = simpleItemInfo:getModelId()
	local count = simpleItemInfo:getCount()

	self:addGainItemMessage(type, id, count, params)
end

function NoticeManager:addGainItemMessage(type, id, count, params)
	params = params or {}

	local richMessage = {}
	local ignoreChat = params.ignoreChat or false
	local gradeColor = lt.Constants.COLOR.GREEN

	local itemInfo = lt.CacheManager:getItemInfo(id)
	
	if type == 1 then
		local itemInfo = lt.CacheManager:getItemInfo(id)
		if itemInfo then
			local quality = itemInfo:getGrade()
			gradeColor = lt.UIMaker:getGradeColor(quality)
		end
    elseif type == 2 then
    	local equipmentInfo = lt.CacheManager:getEquipmentInfo(id)
    	if equipmentInfo then
			local quality = equipmentInfo:getQuality() 
			gradeColor = lt.UIMaker:getGradeColor(quality)
    	end
    elseif type == 4 then
    	local runeInfo = lt.CacheManager:getRuneInfo(id)
    	if runeInfo then
    		local level = runeInfo:getLevel()
			gradeColor = lt.UIMaker:getGradeColor(level)
    	end
    end



	if type == 1 then
		-- 道具
		local itemInfo = lt.CacheManager:getItemInfo(id)

		local itemType = itemInfo:getType()
		--if itemType == 6 then
			-- 值类型道具
			if id == lt.Constants.ITEM.COMPETION_SCORE and count < 0 then
				-- 特殊 竞技积分小于0时 表示今日积分已达上限
				if count == -1 then
					-- 武道场
					table.insert(richMessage, {message = lt.StringManager:getString("STRING_GAIN_TIPS_SPECIAL_1")})
					ignoreChat = true
				end
			else
				-- table.insert(richMessage, {message = lt.StringManager:getString("STRING_GAIN_TIPS_2")})
				-- table.insert(richMessage, {message = count, color = lt.Constants.COLOR.CITY_CHAT_GREEN})
				-- table.insert(richMessage, {message = itemInfo:getName()})
				table.insert(richMessage, {message = string.format(lt.StringManager:getString("STRING_GAIN_TIPS_1"), count)})
				table.insert(richMessage, {message = itemInfo:getName(), color = gradeColor})
			end
		--else
			-- 其他道具种类
			-- table.insert(richMessage, {message = string.format(lt.StringManager:getString("STRING_GAIN_TIPS_1"), count)})
			-- table.insert(richMessage, {message = itemInfo:getName(), color = gradeColor})
		--end
	elseif type == 2 then
		-- 装备
		local equipmentInfo = lt.CacheManager:getEquipmentInfo(id)

		table.insert(richMessage, {message = string.format(lt.StringManager:getString("STRING_GAIN_TIPS_1"), count)})
		table.insert(richMessage, {message = equipmentInfo:getName(), color = gradeColor})
	elseif type == 4 or type == 6 then
		--符文
		local runeInfo = lt.CacheManager:getRuneInfo(id)

		table.insert(richMessage, {message = string.format(lt.StringManager:getString("STRING_GAIN_TIPS_1"), count)})
		table.insert(richMessage, {message = runeInfo:getName(), color = gradeColor})
		
	elseif type == 9 then --金币
		type = lt.GameIcon.TYPE.ITEM
		id = lt.Constants.ITEM.GOLD

		local itemInfo = lt.CacheManager:getItemInfo(id)
		table.insert(richMessage, {message = lt.StringManager:getString("STRING_GAIN_TIPS_2")})
		table.insert(richMessage, {message = count, color = lt.Constants.COLOR.CITY_CHAT_GREEN})
		table.insert(richMessage, {message = itemInfo:getName()})

	elseif type == 10 then--银币
		type = lt.GameIcon.TYPE.ITEM
		id = lt.Constants.ITEM.COIN

		local itemInfo = lt.CacheManager:getItemInfo(id)
		table.insert(richMessage, {message = lt.StringManager:getString("STRING_GAIN_TIPS_2")})
		table.insert(richMessage, {message = count, color = lt.Constants.COLOR.CITY_CHAT_GREEN})
		table.insert(richMessage, {message = itemInfo:getName()})
	elseif type == 11 then--钻石
		type = lt.GameIcon.TYPE.ITEM
		id = lt.Constants.ITEM.DIAMOND

		local itemInfo = lt.CacheManager:getItemInfo(id)
		table.insert(richMessage, {message = lt.StringManager:getString("STRING_GAIN_TIPS_2")})
		table.insert(richMessage, {message = count, color = lt.Constants.COLOR.CITY_CHAT_GREEN})
		table.insert(richMessage, {message = itemInfo:getName()})

	elseif type == 15 then--工会积分
		type = lt.GameIcon.TYPE.ITEM
		id = lt.Constants.ITEM.GUILD_SCORE

		local itemInfo = lt.CacheManager:getItemInfo(id)
		table.insert(richMessage, {message = lt.StringManager:getString("STRING_GAIN_TIPS_2")})
		table.insert(richMessage, {message = count, color = lt.Constants.COLOR.CITY_CHAT_GREEN})
		table.insert(richMessage, {message = itemInfo:getName()})

	elseif type == 16 then--精力
		type = lt.GameIcon.TYPE.ITEM
		id = lt.Constants.ITEM.ENERGY

		local itemInfo = lt.CacheManager:getItemInfo(id)
		table.insert(richMessage, {message = lt.StringManager:getString("STRING_GAIN_TIPS_2")})
		table.insert(richMessage, {message = count, color = lt.Constants.COLOR.CITY_CHAT_GREEN})
		table.insert(richMessage, {message = itemInfo:getName()})
	elseif type == 18 then--Zbi
		type = lt.GameIcon.TYPE.ITEM
		id = lt.Constants.ITEM.Z_CURRENCY

		local itemInfo = lt.CacheManager:getItemInfo(id)
		table.insert(richMessage, {message = lt.StringManager:getString("STRING_GAIN_TIPS_2")})
		table.insert(richMessage, {message = count, color = lt.Constants.COLOR.CITY_CHAT_GREEN})
		table.insert(richMessage, {message = itemInfo:getName()})
	elseif type == 19 then--历练积分
		type = lt.GameIcon.TYPE.ITEM
		id = lt.Constants.ITEM.EXPERIENCE_SCORE

		local itemInfo = lt.CacheManager:getItemInfo(id)
		table.insert(richMessage, {message = lt.StringManager:getString("STRING_GAIN_TIPS_2")})
		table.insert(richMessage, {message = count, color = lt.Constants.COLOR.CITY_CHAT_GREEN})
		table.insert(richMessage, {message = itemInfo:getName()})
	elseif type == 20 then--符文碎片
		type = lt.GameIcon.TYPE.ITEM
		id = lt.Constants.ITEM.RUNE_PIECE

		local itemInfo = lt.CacheManager:getItemInfo(id)
		table.insert(richMessage, {message = lt.StringManager:getString("STRING_GAIN_TIPS_2")})
		table.insert(richMessage, {message = count, color = lt.Constants.COLOR.CITY_CHAT_GREEN})
		table.insert(richMessage, {message = itemInfo:getName()})

	end

	self:addRichMessage(richMessage)

	if ignoreChat then
		return
	end
	if id == lt.Constants.ITEM.EXP then
		return
	end
	local chatInfo = lt.Chat.new()
	chatInfo:setChannel(lt.Constants.CHAT_TYPE.SYSTEM)
	chatInfo:setSenderName("system")
	chatInfo:setSendTime(lt.CommonUtil:getCurrentTime())
	chatInfo:setMessage("")
	local subContent = {}
	subContent["item_type"] = type
	subContent["model_id"] = id
	subContent["size"] = count
	chatInfo:setSubContent(json.encode(subContent))
	chatInfo:setSubType(lt.Constants.CHAT_SUB_TYPE.GET_ITEM)
	lt.DataManager:addSystemChatInfo(chatInfo)
	lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_SYSTEM,{chatInfo=chatInfo})
end

function NoticeManager:onUpdate(delta)
	local addNoticeCount = #self._addNoticeArray
	local updateNoticeCount = #self._updateNoticeArray

	if addNoticeCount == 0 and updateNoticeCount == 0 then
		-- 停止回调
		lt.scheduler.unscheduleGlobal(self._updateHandler)
		self._updateHandler = nil
		return
	end

	-- 添加操作
	self._addElapse = self._addElapse + delta
	if self._addElapse > self._addInterval then
		if addNoticeCount > 0 then
			-- 生成通知条
			local noticeInfo = self._addNoticeArray[1]
			table.remove(self._addNoticeArray, 1)

			if self._displayDelegate then
				local noticeCell = lt.NoticeCell.new(noticeInfo)
				self._displayDelegate:addChild(noticeCell)

				table.insert(self._updateNoticeArray, noticeCell)
			end

			self._addElapse = 0
		end
	end

	-- 更新操作
	updateNoticeCount = #self._updateNoticeArray
	if updateNoticeCount > 0 then
		local j = 0 -- 超过滞留线的数量
		for i=updateNoticeCount,1,-1 do
			local noticeCell = self._updateNoticeArray[i]
			local isFloat = noticeCell:onUpdate(delta, j)
			if isFloat then
				j = j + 1
			end
		end

		local firstNoticeCell = self._updateNoticeArray[1]
		if firstNoticeCell:isWaitingForClear() then
			firstNoticeCell:removeFromParent()
			table.remove(self._updateNoticeArray, 1)
		end
	end
end

function NoticeManager:onUpdateItem(delta)
	local addNoticeItemCount = #self._addNoticeItemArray
	local updateNoticeItemCount = #self._updateNoticeItemArray

	if addNoticeItemCount == 0 and updateNoticeItemCount == 0 then
		lt.scheduler.unscheduleGlobal(self._updateItemHandler)
		self._updateItemHandler = nil
		lt.AudioManager:unloadSound("ui/audio_drop_equip")
		return
	end

	if addNoticeItemCount > 0 and updateNoticeItemCount == 0 then
		local simpleItem = self._addNoticeItemArray[1]
		table.remove(self._addNoticeItemArray, 1)
	
		if self._displayDelegate then
			local noticeItem = lt.NoticeItem.new(simpleItem)
			noticeItem:setPosition(display.cx-100,display.cy+180)
			self._displayDelegate:addChild(noticeItem, 10)

			if simpleItem.type == lt.GameIcon.TYPE.EQUIPMENT then
				--音效
				local soundName = "ui/audio_drop_equip"
	    		lt.AudioManager:playSound(soundName)
			end

			table.insert(self._updateNoticeItemArray, noticeItem)
		end
	end

	if updateNoticeItemCount > 0 then
		for i=updateNoticeItemCount,1,-1 do
			local noticeItem = self._updateNoticeItemArray[i]
			noticeItem:onUpdate(delta)
		end

		local firstNoticeItem = self._updateNoticeItemArray[1]
		if firstNoticeItem:isWaitingForClear() then
			firstNoticeItem:removeFromParent()
			table.remove(self._updateNoticeItemArray, 1)
		end
	end
end

function NoticeManager:onUpdateRunning(delta)
	local addNoticeCount = #self._addRunindHorseArray

	if addNoticeCount == 0 then
		-- 停止回调
		lt.scheduler.unscheduleGlobal(self._updateRunningHandler)
		self._updateRunningHandler = nil
		return
	end

	if not self._displayDelegate then
		return
	end

	if self._displayDelegate:getRunningHorseVisible() then
		return
	end
	-- 添加操作
	local noticeInfo = self._addRunindHorseArray[1]
	self._displayDelegate:runningHorse(noticeInfo, #self._addRunindHorseArray)
	table.remove(self._addRunindHorseArray, 1)
end
-- ############################## 弹幕管理 ############################## 
--[[
	类型：所有聊天频道、英灵评论                   
]]--
NoticeManager.BARRAGE_SHOW_TYPE = {
	CHAT_CHANEL = 1,
	SERVANT_COMMENT = 2,
}
function NoticeManager:configBarrageText(info, showType, displayDelegate)--初始化弹幕   例如英灵评论有记录的 info传数组   没有即时的一条传nil或者{}
	showType = showType or self.BARRAGE_SHOW_TYPE.CHAT_CHANEL
	self._barrageTextDelegate = self._barrageTextDelegate or displayDelegate
	if self._barrageTextDelegate then
		self._barrageTextDelegate:runningBarrage(info)
	end
	self._currentBarrageShopType = showType

	self._initBarrageText = true
end

function NoticeManager:isInitBarrageText()
	return self._initBarrageText
end

function NoticeManager:getCurrentBarrageShowType()
	return self._currentBarrageShopType or self.BARRAGE_SHOW_TYPE.CHAT_CHANEL
end

function NoticeManager:setCurrentBarrageShowType(showType)
	if not self._barrageTextDelegate then
		return
	end

	if self:getCurrentBarrageShowType() ~= showType then
		self._barrageTextDelegate:resetBarrageText()
	end
	self._currentBarrageShopType = showType
end

function NoticeManager:addBarrageText(message, channel, subType)
	if not self._barrageTextDelegate then
		return
	end

	if channel and subType then
	    if channel == lt.Constants.CHAT_TYPE.WORLD or channel == lt.Constants.CHAT_TYPE.TRUMPET then
            auto = lt.PreferenceManager:getAutoBarrageWorld()
        elseif channel == lt.Constants.CHAT_TYPE.TEAM then
            auto = lt.PreferenceManager:getAutoBarrageTeam()
        elseif channel == lt.Constants.CHAT_TYPE.GUILD then
            auto = lt.PreferenceManager:getAutoBarrageGuild()
        elseif channel == lt.Constants.CHAT_TYPE.CURRENT then
            auto = lt.PreferenceManager:getAutoBarrageCurrent()
        end

        if not auto then
            return
        end

	    if channel == lt.Constants.CHAT_TYPE.WORLD or channel == lt.Constants.CHAT_TYPE.TEAM or channel == lt.Constants.CHAT_TYPE.GUILD or 
	    	channel == lt.Constants.CHAT_TYPE.CURRENT or channel == lt.Constants.CHAT_TYPE.TRUMPET then--频道
	        if lt.NoticeManager:getCurrentBarrageShowType() ~= lt.NoticeManager.BARRAGE_SHOW_TYPE.SERVANT_COMMENT then-- 非英灵品论
	            if subType == lt.Constants.CHAT_SUB_TYPE.NONE or subType == lt.Constants.CHAT_SUB_TYPE.LINK_LINE or subType == lt.Constants.CHAT_SUB_TYPE.AUDIO then
	                if self:getCurrentBarrageShowType() == self.BARRAGE_SHOW_TYPE.SERVANT_COMMENT then
						self._barrageTextDelegate:addBarrageMessage(message)
					else
						self._barrageTextDelegate:addChatBarrageMessage(message)
					end
	            end
	        end
	    end
    else
        if self:getCurrentBarrageShowType() == self.BARRAGE_SHOW_TYPE.SERVANT_COMMENT then
			self._barrageTextDelegate:addBarrageMessage(message)
		else
			self._barrageTextDelegate:addChatBarrageMessage(message)
		end
	end

end

function NoticeManager:closeBarrageText()
	if self._barrageTextDelegate then
		self._barrageTextDelegate:stopBarrageRunning()
	end
end

-- ############################## Boss速度线 ############################## 
function NoticeManager:onBossEndLine()
	if self._displayDelegate then
		self._displayDelegate:onBossEndLine()
	end
end

-- ############################## 人物升级效果 ############################## 
function NoticeManager:onPlayerLevelUp()
	if self._displayDelegate then
		self._displayDelegate:onPlayerLevelUp()
	end
end

-- ############################## 任务完成效果 ############################## 
function NoticeManager:onTaskComplete(taskId)
	if self._displayDelegate and self._displayDelegate.onTaskComplete then
		self._displayDelegate:onTaskComplete(taskId)
	end
end

-- ############################## 领取特殊事件(迷宫)效果 ############################## 
function NoticeManager:onMazeTask()
	if self._displayDelegate then
		self._displayDelegate:onMazeTask()
	end
end

-- 迷宫任务完成
function NoticeManager:onMazeComplete(mazeName)
	if self._displayDelegate and self._displayDelegate.onMazeComplete then
		self._displayDelegate:onMazeComplete(mazeName)
	end
end

-- ############################## 传送效果 ############################## 
function NoticeManager:onDelayWorldTransfer()
	if self._displayDelegate then
		self._displayDelegate:showTransfer()
	end
end

function NoticeManager:clearDelayWorldTransfer()
	if self._displayDelegate then
		self._displayDelegate:hideTransfer()
	end
end

-- ############################## 任务自定义行为 ############################## 
function NoticeManager:onTaskCustom(customIdx, duration)
	if self._displayDelegate then
		self._displayDelegate:showTaskCustom(customIdx, duration)
	end
end

function NoticeManager:clearTaskCustom()
	if self._displayDelegate then
		self._displayDelegate:hideTaskCustom()
	end
end

-- ############################## BossWarning ############################## 
function NoticeManager:onBossWarning()
	if self._displayDelegate then
		self._displayDelegate:bossWarning()
	end
end

function NoticeManager:onBossAppear()
	if self._displayDelegate then
		self._displayDelegate:bossAppear()
	end
end

return NoticeManager
