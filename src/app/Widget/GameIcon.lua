
local GameIcon = class("GameIcon", function(smallType)
	return display.newSprite("#common_new_icon.png")
end)

GameIcon.TYPE = {
	EMPTY = 0,
	ITEM = 1,
	EQUIPMENT = 2,
	SERVANT = 3,--英灵
	Rune = 6,--符文
	CHARACTER_SERVANT = 9,


	PLAYER_ITEM = 101,
	PLAYER_EQUIPMENT = 102,

	EMOJI = 1000,

}

GameIcon._type = nil
GameIcon._itemType = nil
GameIcon._realId = nil
GameIcon._modelId   = nil

GameIcon._bgInfoNode = nil
GameIcon._fgInfoNode = nil
GameIcon._countLabel1 = nil -- 表示数量
GameIcon._countLabel2 = nil -- 表示需求

GameIcon._border = nil
GameIcon._baseScale = 1
GameIcon._iconImg = nil
GameIcon._mask = nil -- 选择状态用 遮罩

GameIcon._newEquipIcon = nil
GameIcon._newItemIcon = nil
function GameIcon:ctor()
	self._type = self.TYPE.EMPTY
	self._realId = 0
	self._modelId = 0
	self._unfreezeTime = 0

	self:setNodeEventEnabled(true)
    self:setTouchSwallowEnabled(true)
	self:setCascadeOpacityEnabled(true)
end


function GameIcon:updateBySimpleItemInfo(simpleItemInfo)
	self:updateInfo(simpleItemInfo.type, simpleItemInfo.id)
	self:setNum(simpleItemInfo.count)
end

function GameIcon:updateSimpleItemInfo(simpleItemInfo, params)
	params = params or {}

	self:updateInfo(simpleItemInfo:getType(), simpleItemInfo:getModelId())

	if not params.noCount then
		self:setCount(simpleItemInfo:getCount())
	end
end

function GameIcon:updateRewardInfo(rewardInfo)
	if not rewardInfo or type(rewardInfo) ~= "table" or #rewardInfo < 3 then
		return
	end

	self:updateInfo(rewardInfo[1], rewardInfo[2])
	self:setCount(rewardInfo[3])
end

function GameIcon:setRealScale(scale)
	self:setScale(self._baseScale * scale)
end

--[[
	base 为 update实例时 迭代使用
]]
function GameIcon:updateInfo(Type, id, base)
	-- 参数处理
	if not Type then
		self:setEmpty()
		return
	end
	
	if type(Type) == "table" then
		id = Type["id"] or 0
		Type = Type["type"] or self.TYPE.EMPTY
	end

	if self._equipSlotIcon then
		self._equipSlotIcon:removeFromParent()
		self._equipSlotIcon = nil
	end

	if self._equipLevel then
		self._equipLevel:removeFromParent()
		self._equipLevel = nil
	end

	if self._iconDebuffs then
		self._iconDebuffs:removeFromParent()
		self._iconDebuffs = nil
	end

	if self._iconGain then
		self._iconGain:removeFromParent()
		self._iconGain = nil
	end

	if self._newItemIcon then
		self._newItemIcon:removeFromParent()
		self._newItemIcon = nil
	end

	if self._newEquipIcon then
		self._newEquipIcon:removeFromParent()
		self._newEquipIcon = nil
	end

	if self._equipBindIcon then
		self._equipBindIcon:removeFromParent()
		self._equipBindIcon = nil
	end

	if self._itemBindIcon then
		self._itemBindIcon:removeFromParent()
		self._itemBindIcon = nil
	end

	-- 基础道具
	if Type == self.TYPE.ITEM then
		self._itemType = self.TYPE.ITEM
		if not base then
			self._type = self.TYPE.ITEM
		end
		self._modelId = id

		local itemInfo = lt.CacheManager:getItemInfo(self._modelId)
		if itemInfo then
			self:getFgInfoNode():setVisible(true)
			-- 品质底
			local grade = itemInfo:getGrade()
			local qualityName = lt.ResourceManager:getQualityBg(grade)
			local qualityIconName = lt.ResourceManager:getQualityIcon(grade)

			if self._qualityBg then
				self._qualityBg:removeFromParent()
				self._qualityBg = nil
			end

			if self._qualityIcon then
				self._qualityIcon:removeFromParent()
				self._qualityIcon = nil
			end

			self._qualityBg = display.newSprite(qualityName)
			self._qualityBg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
			self:addChild(self._qualityBg)

			if grade > lt.Constants.QUALITY.QUALITY_WHITE then
				self._qualityIcon = display.newSprite(qualityIconName)
				self._qualityIcon:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
				self:addChild(self._qualityIcon)
			end

			-- Icon
			local iconNum = itemInfo:getIconNum()

			if self._iconImg then
				self._iconImg:removeFromParent()
				self._iconImg = nil
			end

			local iconPic = string.format("#%d.png", iconNum)
			self._iconImg = display.newSprite(iconPic)
			self._iconImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
			self:addChild(self._iconImg)
		end
	-- 基础装备
	elseif Type == self.TYPE.EQUIPMENT then
		self._itemType = self.TYPE.EQUIPMENT
		if not base then
			self._type = self.TYPE.EQUIPMENT
		end
		self._modelId = id
		local equipmentInfo = lt.CacheManager:getEquipmentInfo(self._modelId)
		if equipmentInfo then
			local grade = equipmentInfo:getQuality()
			local qualityName = lt.ResourceManager:getQualityBg(grade)
			local qualityIconName = lt.ResourceManager:getQualityIcon(grade)

			if self._qualityBg then
				self._qualityBg:removeFromParent()
				self._qualityBg = nil
			end

			if self._qualityIcon then
				self._qualityIcon:removeFromParent()
				self._qualityIcon = nil
			end
			
			self._qualityBg = display.newSprite(qualityName)
			self._qualityBg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
			self:addChild(self._qualityBg)

			if grade > lt.Constants.QUALITY.QUALITY_WHITE then
				self._qualityIcon = display.newSprite(qualityIconName)
				self._qualityIcon:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
				self:addChild(self._qualityIcon)
			end

			if self._iconImg then
				self._iconImg:removeFromParent()
				self._iconImg = nil
			end


			local iconNum = equipmentInfo:getIconNum()
			local iconPic = string.format("#%d.png", iconNum)
			self._iconImg = display.newSprite(iconPic)
			self._iconImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
			self:addChild(self._iconImg)

			--增益箭头
			self._iconGain = display.newSprite("#common_icon_gain.png")
			self._iconGain:setAnchorPoint(1, 0)
			self._iconGain:setPosition(self:getContentSize().width - 5, 5)
			self._iconGain:setVisible(false)
			self:addChild(self._iconGain,10)

			--减益箭头
			self._iconDebuffs = display.newSprite("#common_icon_debuffs.png")
			self._iconDebuffs:setAnchorPoint(1, 0)
			self._iconDebuffs:setPosition(self:getContentSize().width - 5, 5)
			self._iconDebuffs:setVisible(false)
			self:addChild(self._iconDebuffs,10)


			--判断装备锁，不是自己职业，等级不符合
			local equipWearOccupationArray = equipmentInfo:getOccupationIdArray()
			local occupationId = lt.DataManager:getOccupation()

			for k,v in pairs(equipWearOccupationArray) do

				if occupationId ~= v or lt.DataManager:getPlayerLevel() < equipmentInfo:getRequireLevel() then
					self:selectedAndLock(true)
				end

			end

		end

		-- 不显示数量
		if self._countLabel1 then self._countLabel1:setVisible(false) end
	-- 实例道具
	elseif Type == self.TYPE.PLAYER_ITEM then	
		self._type = self.TYPE.PLAYER_ITEM
		self._realId = id
		local playerItem = lt.DataManager:getPlayerItem(self._realId)
		if playerItem then
			local itemModelId = playerItem:getModelId()

			self:updateInfo(self.TYPE.ITEM, itemModelId, true)
			self._unfreezeTime = playerItem:getUnfreezeTime()

			local tradeFlag = playerItem:getTradeFlag()

			if tradeFlag == 1 then --可交易

				local bindType = playerItem:getBindType()

				if bindType ~= lt.PlayerItem.TYPE.UNFREEZE then
					self._itemBindIcon = display.newSprite("#common_img_can_sale.png")
					self._itemBindIcon:setPosition(16, 60)
					--self._itemBindIcon:setVisible(false)
		    		self:addChild(self._itemBindIcon,10)
				end
			end

		end

		--判断是否新道具(广电版本不显示)
	    local newItemTable = lt.DataManager:getNewItemTable()
		if not lt.Constants.GDZJ and newItemTable and isset(newItemTable, self._realId) then
			self._newItemIcon = display.newSprite("#common_img_newIcon.png")
    		self._newItemIcon:setPosition(44, 40)
    		self._newItemIcon:setVisible(false)
    		self:addChild(self._newItemIcon,10)
		end

	-- 实例装备
	elseif Type == self.TYPE.PLAYER_EQUIPMENT then
		self._type = self.TYPE.PLAYER_EQUIPMENT
		self._realId = id
		local playerEquipment = lt.DataManager:getPlayerEquipment(self._realId)

		if not playerEquipment then
			if base and base.playerEquipment then
				playerEquipment = base.playerEquipment
			else
				playerEquipment = lt.DataManager:getOtherPlayerEquipmentTableById(self._realId)
			end
			
		end

		if playerEquipment then
			local equipmentModelId = playerEquipment:getModelId()
			self:updateInfo(self.TYPE.EQUIPMENT, equipmentModelId, true)
			self:setLevel(playerEquipment:getLevel())
			if playerEquipment:isTreasure() then

		    	local bindType = playerEquipment:getBindType()

				if bindType ~= lt.PlayerItem.TYPE.UNFREEZE then
					self._equipBindIcon = display.newSprite("#common_img_can_sale.png")
					self._equipBindIcon:setPosition(16, 60)
		    		self:addChild(self._equipBindIcon,10)
				end
	    	end
	    	self._unfreezeTime = playerEquipment:getUnfreezeTime()

	    	
		end

		--判断是否新装备(广电版本 不显示)
	    local newEquipmentTable = lt.DataManager:getNewEquipmentTabel()

		if not lt.Constants.GDZJ and newEquipmentTable and isset(newEquipmentTable, self._realId) then
			self._newEquipIcon = display.newSprite("#common_img_newIcon.png")
    		self._newEquipIcon:setPosition(44, 40)
    		self._newEquipIcon:setVisible(false)
    		self:addChild(self._newEquipIcon,10)
		end

		--判断是否已装备(广电版本 不显示)
		local slotTable = lt.DataManager:getPlayerEquipmentSlotTable()
		if not lt.Constants.GDZJ and slotTable then
			for _,slotEquipment in pairs (slotTable) do
				local id = slotEquipment:getId()

				if self._realId == id then
					if self._equipBindIcon then
						self._equipBindIcon:setVisible(false)
					end

					self._equipSlotIcon = display.newSprite("#common_equip_icon.png")
					self._equipSlotIcon:setAnchorPoint(0.5, 0)
		    		self._equipSlotIcon:setPosition(46, 0)
		    		self._equipSlotIcon:setVisible(true)
		    		self:addChild(self._equipSlotIcon,10)
		    		break
				end
			end
		end


		--判断装备锁，不是自己职业，等级不符合
		local equipWearOccupationArray = playerEquipment:getOccupationIdArray()
		local occupationId = lt.DataManager:getOccupation()

		for k,v in pairs(equipWearOccupationArray) do

			if occupationId ~= v or lt.DataManager:getPlayerLevel() < playerEquipment:getRequireLevel() then
				self:selectedAndLock(true)
			end

		end

	end
end

function GameIcon:setNewIconVisible(bool)
	if self._newEquipIcon then self._newEquipIcon:setVisible(bool) end
	if self._newItemIcon then self._newItemIcon:setVisible(bool) end
end

function GameIcon:setEquipmentSlotIconVisible(bool)
	if self._equipSlotIcon then self._equipSlotIcon:setVisible(bool) end
end

function GameIcon:setLockIconVisible(bool)
	if bool then
		self:getLockIcon():setVisible(true)
	else
		if self._lockIcon then
			self._lockIcon:setVisible(false)
		end
	end
end

function GameIcon:getLockIcon()
	if not self._lockIcon then
		self._lockIcon = display.newSprite("#bag_icon_lock.png")
		self._lockIcon:setScale(0.5)
		self._lockIcon:setPosition(40, 40)
		self._lockIcon:setVisible(false)
		self:addChild(self._lockIcon,101)
	end

	return self._lockIcon
end

--增益箭头
function GameIcon:setIconGainVisible(bool)
	if self._iconGain then self._iconGain:setVisible(bool) end
end

--减益箭头
function GameIcon:setIconDebuffsVisible(bool)
	if self._iconDebuffs then self._iconDebuffs:setVisible(bool) end
end

function GameIcon:setCount(count)
	-- 信息节点
	self:getFgInfoNode():setVisible(true)

	if not self._countLabel1 then
		self._countLabel1 = lt.GameBMLabel.new(count, "#fonts/icon_num.fnt")
		self._countLabel1:setAnchorPoint(1, 0)
		self._countLabel1:setAdditionalKerning(-2)
		self._countLabel1:setPosition(self:getContentSize().width - 7, 7)
		self:getFgInfoNode():addChild(self._countLabel1)
	else
		self._countLabel1:setVisible(true)
		self._countLabel1:setString(count)
	end
end

function GameIcon:getCountLabel()
	return self._countLabel1
end

function GameIcon:getCount()
	if self._countLabel1 then
		return tonumber(self._countLabel1:getString())
	end
	return 0
end

--进阶数量显示用于对比需求道具与已有道具数量，当已有数量小于需求数量显示为红色
function GameIcon:setNum(count)
	-- 信息节点
	self:getFgInfoNode():setVisible(true)

	if not self._countLabel1 then
		self._countLabel1 = lt.GameLabel.new(count, 15, lt.Constants.COLOR.WHITE, {outline = 1, outlineColor = lt.Constants.COLOR.DEEP_BLACK})
		self._countLabel1:setAnchorPoint(1, 0)
		self._countLabel1:setAdditionalKerning(-1)
		self._countLabel1:setPosition(self:getContentSize().width - 8, 5)
		self:getFgInfoNode():addChild(self._countLabel1)
	else
		self._countLabel1:setVisible(true)
		self._countLabel1:setString(count)
	end
	local cur = 0
	if self._modelId then
		if self._itemType == self.TYPE.ITEM then
			cur = lt.DataManager:getItemCount(self._modelId)
		elseif self._itemType == self.TYPE.EQUIPMENT then
			cur = lt.DataManager:getEquipmentCount(self._modelId)
		end
	end

	if cur < count then
		self._countLabel1:setTextColor3B(lt.Constants.COLOR.LIGHT_RED)
	else
		self._countLabel1:setTextColor3B(lt.Constants.COLOR.NEW_GREEN)
	end

	if count == 0 then
		self._countLabel1:setVisible(false)
	end
end

--装备强化等级
function GameIcon:setLevel(level)
	if self._equipLevel then
		self._equipLevel:removeFromParent()
		self._equipLevel = nil
	end

    self._equipLevel = lt.GameLabel.new("", 15, lt.Constants.COLOR.NEW_GREEN,{outline = 1,outlineColor = lt.Constants.COLOR.BLACK})
    self._equipLevel:setAnchorPoint(1, 1)
    self._equipLevel:setAdditionalKerning(-1)
    self._equipLevel:setPosition(self:getContentSize().width - 5, self:getContentSize().height - 3)
    self:addChild(self._equipLevel, 100)

    if level <= 0 then
        self._equipLevel:setString("")
    else
    	self._equipLevel:setString("+"..level)
    end
    
end

function GameIcon:setLevelValue(level)
	if self._equipLevel then
		self._equipLevel:removeFromParent()
		self._equipLevel = nil
	end

    self._equipLevel = lt.GameLabel.new("", 15, lt.Constants.COLOR.NEW_GREEN,{outline = 1,outlineColor = lt.Constants.COLOR.BLACK})
    self._equipLevel:setAnchorPoint(1, 1)
    self._equipLevel:setAdditionalKerning(-1)
    self._equipLevel:setPosition(self:getContentSize().width - 5, self:getContentSize().height - 3)
    self:addChild(self._equipLevel, 100)
    
    if level <= 0 then
        self._equipLevel:setString("")
    else
    	self._equipLevel:setString("+"..level)
    end
    
end


function GameIcon:setNeed(need, noCompare)
	if not need or need == 0 then
		return
	end

	local cur = 0

	if self._modelId then
		cur = lt.DataManager:getItemCount(self._modelId)
	end

	-- 信息节点
	self:getFgInfoNode():setVisible(true)

	if not self._countLabel2 then
		self._countLabel2 = lt.GameLabel.new(cur.."/"..need, 15, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.COLOR.DEEP_BLACK})
		self._countLabel2:setAnchorPoint(0.5, 0)
		self._countLabel2:setPosition(self:getContentSize().width / 2, 1)
		-- self._countLabel2:setAdditionalKerning(-1)
		self:getFgInfoNode():addChild(self._countLabel2)
	else
		self._countLabel2:setString(need)
	end

	if not noCompare then -- 显示红绿色
		if cur < need then
			self._countLabel2:setTextColor3B(lt.Constants.COLOR.RED)

			self:setGray(true)
		else
			self._countLabel2:setTextColor3B(lt.Constants.COLOR.WHITE)

			self:setGray(false)
		end
	else -- 显示棕色
		self._countLabel2:setTextColor3B(lt.Constants.COLOR.WHITE)
	end
end

function GameIcon:setCompare(need)
	if not need or need == 0 then
		return
	end

	local cur = 0

	if self._modelId then
		cur = lt.DataManager:getItemCount(self._modelId)
	end

	self:getFgInfoNode():setVisible(true)

	if not self._countLabel1 then
		self._countLabel1 = lt.GameLabel.new("", 15, lt.Constants.COLOR.NEW_GREEN, {outline = 1,outlineColor = lt.Constants.COLOR.DEEP_BLACK})
		self._countLabel1:setAnchorPoint(1, 0)
		self._countLabel1:setAdditionalKerning(-1)
		self._countLabel1:setPosition(self:getContentSize().width - 8, 5)
		self:getFgInfoNode():addChild(self._countLabel1)
	end
	self._countLabel1:setString(cur)

	if cur < need then
		self._countLabel1:setTextColor3B(lt.Constants.COLOR.NEW_RED)
	else
		self._countLabel1:setTextColor3B(lt.Constants.COLOR.NEW_GREEN)
	end
end

function GameIcon:showItemBindIcon()
	if not self._itemBindIcon then
		self._itemBindIcon = display.newSprite("#common_img_can_sale.png")
		self._itemBindIcon:setPosition(16, 60)
		self:addChild(self._itemBindIcon,10)
	end
	self._itemBindIcon:setVisible(true)
end

function GameIcon:showEquipBindIcon()
	if not self._equipBindIcon then
		self._equipBindIcon = display.newSprite("#common_img_can_sale.png")
		self._equipBindIcon:setPosition(16, 60)
		self:addChild(self._equipBindIcon,10)
	end
	self._equipBindIcon:setVisible(true)
end

function GameIcon:hideEquipBindIcon()
	if self._equipBindIcon then
		self._equipBindIcon:setVisible(false)
	end
end

function GameIcon:setEmpty()
	self._type = self.TYPE.EMPTY
	self._id = 0
	self._modelId = 0

	if self._bgInfoNode then self._bgInfoNode:setVisible(false) end
	if self._fgInfoNode then self._fgInfoNode:setVisible(false) end
	if self._iconImg then self._iconImg:setVisible(false) end
	if self._qualityBg then self._qualityBg:setVisible(false) end
	if self._qualityIcon then self._qualityIcon:setVisible(false) end
	if self._equipLevel then self._equipLevel:setVisible(false) end
	if self._equipSlotIcon then self._equipSlotIcon:setVisible(false) end
	if self._iconDebuffs then self._iconDebuffs:setVisible(false) end
	if self._iconGain then self._iconGain:setVisible(false) end
	if self._newEquipIcon then self._newEquipIcon:setVisible(false) end
	if self._newItemIcon then self._newItemIcon:setVisible(false) end
	if self._selectImg then self._selectImg:setVisible(false) end
	if self._equipBindIcon then self._equipBindIcon:setVisible(false) end
	if self._itemBindIcon then self._itemBindIcon:setVisible(false) end
	if self._lockIcon then self._lockIcon:setVisible(false) end
	if self._addIcon then self._addIcon:setVisible(false) end
	if self._noticeFlag then self._noticeFlag:setVisible(false) end
	if self._countLabel1 then self._countLabel1:setVisible(false) end
end

function GameIcon:setQualityBgVisible(bool)
	if self._qualityBg then
		self._qualityBg:setVisible(bool)
	end
end

function GameIcon:getFgInfoNode()
	if not self._fgInfoNode then
		self._fgInfoNode = display.newNode()
		self._fgInfoNode:setCascadeOpacityEnabled(true)
		self._fgInfoNode:setPosition(0, 0)
		self:addChild(self._fgInfoNode, 1000)
	end

	return self._fgInfoNode
end

-- 选择用遮罩
function GameIcon:selected(noFlag)
	if not self._mask then
		self._mask = display.newSprite("#common_icon_mask.png")
		self._mask:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self:addChild(self._mask, 5)

		if not noFlag then
			local flag = display.newSprite("#common_icon_selected.png")

			flag:setPosition(self._mask:getContentSize().width / 2, self._mask:getContentSize().height / 2)
			self._mask:addChild(flag)
		end
	end

	self._mask:setVisible(true)
end

--添加用遮罩
function GameIcon:setAdded()
	if not self._added then
		self._added = display.newSprite("#common_icon_mask.png")
		self._added:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self:addChild(self._added, 100)

		local flag = display.newSprite("#team_plus.png")

		flag:setPosition(self._added:getContentSize().width / 2, self._added:getContentSize().height / 2)
		self._added:addChild(flag)

	end
	self._added:setVisible(true)
end

function GameIcon:setAddedNoMask()
	if not self._addedNoMask then
		self._addedNoMask = display.newSprite("#team_plus.png")
		self._addedNoMask:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self:addChild(self._addedNoMask, 100)

	end
	self._addedNoMask:setVisible(true)
end

function GameIcon:setUnAdded()
	if self._added then
		self._added:setVisible(false)
	end
end

function GameIcon:setLight()
	local equipmentInfo = lt.CacheManager:getEquipmentInfo(self._modelId)
	if self._iconImg and equipmentInfo then
		local iconNum = equipmentInfo:getIconNum()
		local iconPic = string.format("image/equipment/light/%d.png", iconNum)
		local iconLight = display.newSprite(iconPic)
		iconLight:setPosition(self._iconImg:getContentSize().width/2,self._iconImg:getContentSize().height/2)
		self._iconImg:addChild(iconLight,-1)
	end
end

-- 新版本使用遮罩 + 锁
function GameIcon:selectedAndLock()
	if not self._selectImg then
		self._selectImg = display.newSprite("#common_icon_mask.png")
		self._selectImg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self:addChild(self._selectImg, 5)


		local flag = display.newSprite("#bag_icon_lock.png")
		flag:setPosition(self._selectImg:getContentSize().width / 2, self._selectImg:getContentSize().height / 2)
		flag:setScale(0.5)
		self._selectImg:addChild(flag)

	end

	self._selectImg:setVisible(true)
end

function GameIcon:unselectedAndUnlock()
	if self._selectImg then
		self._selectImg:setVisible(false)
	end
end

function GameIcon:unselected()
	if self._mask then self._mask:setVisible(false) end
end

function GameIcon:setAddIconVisible(bool)
	if bool then
		self:getAddIcon():setVisible(true)
	else
		if self._addIcon then
			self._addIcon:setVisible(false)
		end
	end
end

function GameIcon:getAddIcon()
	if not self._addIcon then
		self._addIcon = display.newSprite("#team_plus.png")
		self._addIcon:setPosition(40, 40)
		self._addIcon:setVisible(false)
		self:addChild(self._addIcon)
	end

	return self._addIcon
end

function GameIcon:setNewFlagVisible(bool)
	if self._noticeFlag then

		self._noticeFlag:getAnimation():playWithIndex(0)
		self._noticeFlag:setVisible(bool)

	end
end

function GameIcon:getType()
	return self._type
end

function GameIcon:getItemType()
	return self._itemType
end

function GameIcon:getModelId()
	return self._modelId
end

function GameIcon:getRealId()
	return self._realId
end

function GameIcon:setRealId()
	self._realId = 0
end

function GameIcon:isFrozen()
	local diffTime = self._unfreezeTime - lt.CommonUtil:getCurrentTime()
	if diffTime > 0 then
		self:setGray(true)
		return true
	end
	return false
end

function GameIcon:getFreezeTimeString()
	local diffTime = self._unfreezeTime - lt.CommonUtil:getCurrentTime()
	if diffTime <= 0 then
		return ""
	end
	local d = math.floor(diffTime/(3600*24))
	local h = math.floor((diffTime-d*24*3600)/3600)
	local m = math.floor((diffTime - h*3600 - d*24*3600)/60)
	return string.format(lt.StringManager:getString("STRING_STALL_TIPS_34"),d,h,m)
end

function GameIcon:setGray(isGray)
	if isGray then
		for k,v in pairs(self:getChildren()) do
			if tolua.type(v) == "cc.Sprite" or tolua.type(v) == "cc.Scale9Sprite" then
				self:darkNode(v)
			end
		end
	else
		for k,v in pairs(self:getChildren()) do
			if tolua.type(v) == "cc.Sprite" or tolua.type(v) == "cc.Scale9Sprite" then
				self:unDarkNode(v)
			end
		end
	end
end

function GameIcon:darkNode(node)
	node:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgram:createWithFilenames("shader/normalTexture.vsh","shader/gray.fsh")))
end

function GameIcon:unDarkNode(node)
	node:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
end

function GameIcon:setOpacity(opacity)
	if self._iconImg then self._iconImg:setOpacity(opacity) end
end

return GameIcon
