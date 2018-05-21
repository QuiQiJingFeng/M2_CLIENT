
-- 游戏内缓存数据存放
local CacheManager = {}

CacheManager._winScale = nil

CacheManager._activityTable 				= nil
CacheManager._activityPushTable         	= nil
CacheManager._aggressCrazyDoctorTriggerTable	= nil
CacheManager._aggressCreamBossModelTable 	= nil
CacheManager._aggressCreamBossNpcFlushTable = nil
CacheManager._attackTable					= nil
CacheManager._attackFlyerTable				= nil
CacheManager._bossAudioTable				= nil
CacheManager._equipLevelTable               = nil
CacheManager._equipmentTable				= nil
CacheManager._equipmentSuitTable			= nil
CacheManager._equipmentAdditionalPropertyValuesTable	= nil
CacheManager._equipmentEnchantingPropertyValuesTable	= nil
CacheManager._equipmentLevelPropertyTable	= nil
CacheManager._equipQualityTable             = nil
CacheManager._guideTable					= nil
CacheManager._hitEffectTable				= nil
CacheManager._itemTable  					= nil
CacheManager._sheetTable  					= nil
CacheManager._levelExpTable  				= nil
CacheManager._mazeTriggerArray 				= nil
CacheManager._mazeTriggerTable 				= nil
CacheManager._modelHeroTable				= nil
CacheManager._modelTable					= nil
CacheManager._monsterAttackModelTable 		= nil
CacheManager._monsterAttackNpcFlushTable 	= nil
CacheManager._monsterTable 					= nil
CacheManager._monsterPurificationMonsterTable	= nil
CacheManager._npcTable 						= nil
CacheManager._npcArray 						= nil
CacheManager._paperTable                    = nil
CacheManager._servantCharacterTable			= nil
CacheManager._servantCharacterTypeTable		= nil
CacheManager._servantGrowthFactorTable		= nil
CacheManager._servantTable					= nil
CacheManager._servantUpgradeCostTable		= nil
CacheManager._shopItemTable 				= nil
CacheManager._shopItemArray 				= nil
CacheManager._shopItemIndex 				= nil
CacheManager._skillTable 					= nil
CacheManager._skillHeroTable 				= nil -- 主角技能 id 索引
CacheManager._skillHeroIndexLevelTable 		= nil -- 主角技能 index level 索引
CacheManager._skillServantTable 			= nil -- 主角技能 id 索引
CacheManager._skillServantIndexLevelTable 	= nil -- 主角技能 index level 索引
CacheManager._starTable  					= nil
CacheManager._suitProperiesTable			= nil
CacheManager._ticketTable				    = nil
CacheManager._peaklevelExpTable  			= nil
CacheManager._roleDataTable  				= nil
CacheManager._roleGrowthTable  				= nil
CacheManager._activityRewardTable			= nil --活跃奖励 活跃索引
CacheManager._activityRewardArray			= nil
CacheManager._taskTable						= nil -- 任务索引<任务ID>
CacheManager._peakLevelUpDateTable 			= nil -- 巅峰属性 索引occupation_id
CacheManager._emotionTable					= nil
CacheManager._tipsTable                     = nil
CacheManager._functionOpenTable				= nil
CacheManager._functionOpenArray				= nil
CacheManager._personalityTable 				= nil --个性装饰
CacheManager._personalityArray 				= nil
CacheManager._goodcardInfoTable 			= nil --好人卡信息
CacheManager._goodcardInfoArray 			= nil
CacheManager._goodcardRewardTable 			= nil --好人卡奖励
CacheManager._goodcardRewardArray 			= nil
CacheManager._firstChargeTable              = nil
CacheManager._bagopenCostTable              = nil
CacheManager._equipMakeArray  				= nil --装备打造
CacheManager._equipEnchantCostTable 		= nil --装备附魔消耗
CacheManager._equipConciseCostTable			= nil --装备洗练表
CacheManager._siteStrengthTable				= nil --装备部位强化
CacheManager._siteStrengthArray 			= nil
CacheManager._gemPositionTable 				= nil
CacheManager._gemPositionArray 				= nil
CacheManager._gemComposeTable 				= nil
CacheManager._gemOpenTable 					= nil
CacheManager._gemOpenArray 					= nil
CacheManager._shopClubTable                 = nil
CacheManager._shopFatherClubTable           = nil
CacheManager._lifeSkillExpTable  			= nil
CacheManager._lifeSkillExpArray  			= nil
CacheManager._lifeSkillIndex  				= nil
CacheManager._lifeSkillMakeTable  			= nil
CacheManager._lifeSkillMakeArray  			= nil
CacheManager._lifeSkillUnlockTable  		= nil
CacheManager._lifeSkillUnlockArray  		= nil
CacheManager._lifeSkillUnlockIndex          = nil

CacheManager._runeInfoTable   				= nil
CacheManager._runeOpenTable   				= nil
CacheManager._runeTalentTable   			= nil
CacheManager._runePageOpenTable   			= nil

CacheManager._rouseTable 				    = nil --奋起
CacheManager._doubleExpTable 				= nil --双倍经验

CacheManager._lifeSkillLevelUpCostTable     = nil

CacheManager._seMonsterTable = nil
CacheManager._seMonsterArray = nil

CacheManager._itemComposeTable = nil --道具合成
CacheManager._itemComposeArray = nil

CacheManager._continuousSignTable = nil --连续签到
CacheManager._dailySignTable = nil --每日签到
CacheManager._dailySignTipsTable = nil
CacheManager._dailySignPropertyTable = nil

CacheManager._levelupRewardTable = nil

CacheManager._strongTable = nil
CacheManager._fightRewardTable = nil

CacheManager._growTaskTable = nil
CacheManager._growTaskArray = nil
CacheManager._growTaskSectionTable = nil

CacheManager._eggRewardTable = nil
CacheManager._eggColorRewardTable = nil
CacheManager._goodCardTable = nil
--冲级奖励
CacheManager._levelingRewardTable = nil
CacheManager._redPacketRewardTable = nil
--野外
CacheManager._monsterPurificationFieldTable = nil
CacheManager._monsterPurificationFieldDataTable = nil
CacheManager._monsterPurificationBaseInfoTable = nil

--活跃活动大战场
CacheManager._activityBattlefieldTable = nil
CacheManager._activityBattlefieldIndex = nil

--魔王巢穴
CacheManager._devilNestBossTable = nil
CacheManager._devilNestPropertyTable = nil
--公会boss
CacheManager._guildBossTable = nil
--特殊事件奖励
CacheManager._specialEventRewardTable = nil


--宝石达人
CacheManager._intelligentGemTable = nil

--生活达人
CacheManager._intelligentLifeTable = nil

--英灵达人
CacheManager._intelligentServantTable = nil

--强化达人
CacheManager._intelligentStrengthTable = nil

--好友度
CacheManager._friendShipTable = nil

--赠送好友度道具
CacheManager._sendFriendShipItemTable = nil

--全民答题派对
CacheManager._nationAnswerPartyQuesTable = nil
CacheManager._nationAnswerPartyRewardTable = nil


--公会狂欢
CacheManager._guildCarnivalTable = nil

--英灵羁绊
CacheManager._servantBoundTable 	= nil

--迷宫对话
CacheManager._mazeChatInfoTable 	= nil
CacheManager._mazeChatInfoIdTable	= nil
CacheManager._allMessageNum			= nil

--称号
CacheManager._playerTitleInfoTable 	= nil

--主角天赋
CacheManager._heroTalentTable = nil

--在线有礼 前七天奖励
CacheManager._onlineRewardFristTable = nil

--在线有礼 循环奖励
CacheManager._onlineRewardSecondTable = nil

function CacheManager:init()
	self._winScale = display.size.width / display.size.height *  640 / 960
end

-- 屏幕比例
function CacheManager:getWinScale()
	return math.min(self._winScale, 1)
end

function CacheManager:getOrignalWinScale()
	return self._winScale
end

CacheManager._initIdx = 0
CacheManager.INIT_TABLE = {
	function(self)
		self:getActivityTable()
	end,
	function(self)
		self:getActivityPushTable()
	end,
	function(self)
		self:getAttackHeroTable()
	end,
	function(self)
		self:getAttackTable()
	end,
	function(self)
		self:getActivityRewardTable()
	end,
	function(self)
		self:getAttackFlyerTable()
	end,
	function(self)
		self:getBossAudioTable()
	end,
	function(self)
		self:getBagopenCostTable()
	end,
	function(self)
		self:getWorldMonsterRefreshTable()
	end,
	function(self)
		self:getEquipLevelTable()
	end,
	function(self)
		self:getEquipmentTable()
	end,
	function(self)
		self:getEquipmentAdditionalPropertyValuesTable()
	end,
	function(self)
		self:getEquipmentEnchantingPropertyValuesTable()
	end,
	function(self)
		self:getEquipmentLevelPropertyTable()
	end,
	function(self)
		self:getEquipQualityTable()
	end,
	function(self)
		self:getSiteStrengthTable()
	end,
	function(self)
		self:getGemPositionTable()
	end,
	function(self)
		self:getGuideTable()
	end,
	function(self)
		self:getShopClubTable()
	end,
	function(self)
		self:getHitEffectTable()
	end,
	function(self)
		self:getItemTable()
	end,
	function(self)
		self:getLevelExpTable()
	end,
	function(self)
		self:getModelHeroTable()
	end,
	function(self)
		self:getModelTable()
	end,
	function(self)
		self:getMonsterTable()
	end,
	function(self)
		self:getNpcTable()
	end,
	function(self)
		self:getSkillTable()
	end,
	function(self)
		self:getSkillHeroTable()
	end,
	function(self)
		self:getRoleDataTable()
	end,
	function(self)
		self:getTaskTable()
	end,
	function(self)
		self:getTaskCollectTable()
	end,
	function(self)
		self:getDressTable()
	end,
	function(self)
		self:getWorldMapTable()
	end,
	function(self)
		self:getWorldMapTransferTable()
	end,
	function(self)
		self:getNavigationPointTable()
	end,
	function(self)
		self:getNavigationLineTable()
	end,
	function(self)
		self:getServantTable()
	end,
	function(self)
		self:getServantExchangeTable()
	end,
	function(self)
		self:getServantExpTable()
	end,
	function(self)
		self:getServantCharacterTable()
	end,
	function(self)
		self:getSkillServantTable()
	end,
	function(self)
		self:getRuneInfoTable()
	end,
	function(self)
		self:getRuneTalentTable()
	end,
	function(self)
		self:getAdventureTaskTable()
	end,
	function(self)
		self:getGuildBuildTaskTable()
	end,
	function(self)
		self:getTeamTargetTypeTable()
	end,
	function(self)
		self:getTeamTargetTable()
	end,
}
CacheManager._initCount = #CacheManager.INIT_TABLE
function CacheManager:initData()
	self._initIdx = self._initIdx + 1
	if self._initIdx > self._initCount then
		return true
	end

	local func = self.INIT_TABLE[self._initIdx]
	if func then
		func(self)
	end

	return false, self._initIdx, self._initCount
end

-- ################################################## activityTable ##################################################
function CacheManager:getActivityTable()
	if not self._activityTable then
		self._activityTable = lt.ActivityDao:queryAll()
	end

	return self._activityTable
end

function CacheManager:getActivityInfo(activityId)
	local activityTable = self:getActivityTable()
	return activityTable[activityId]
end

function CacheManager:getActiveActivityPushArray()--活跃活动的推送
 
	if not self._activeActivityPushArray then
		local activityTable = self:getActivityTable()
		self._activeActivityPushArray = {}
		for k,info in pairs(activityTable) do
			if info:getPushSequense() and info:getPushSequense() ~= 0 then
				table.insert(self._activeActivityPushArray, info)
			end
		end

		table.sort(self._activeActivityPushArray, function(a, b)
			return a:getPushSequense() < b:getPushSequense()
		end)
	end
	return self._activeActivityPushArray
end

-- ################################################## 疯狂博士实验室-机关 activityCrazyDoctorTriggerInfo ##################################################
function CacheManager:getActivityCrazyDoctorTriggerTable()
	if not self._activityCrazyDoctorTriggerTable then
		self._activityCrazyDoctorTriggerTable = lt.ActivityCrazyDoctorTriggerDao:queryAll()
	end

	return self._activityCrazyDoctorTriggerTable
end

function CacheManager:getActivityCrazyDoctorTriggerInfo(triggerId)
	local activityCrazyDoctorTriggerTable = self:getActivityCrazyDoctorTriggerTable()
	return activityCrazyDoctorTriggerTable[triggerId]
end

-- ################################################## activityPushTable ##################################################
function CacheManager:getActivityPushTable()
	if not self._activityPushTable then
		self._activityPushTable = lt.ActivityPushDao:queryAll()
	end

	return self._activityPushTable
end

-- ################################################## 活跃活动-魔物入侵 aggressCreamBossModelTable aggressCreamBossNpcFlushTable ##################################################
function CacheManager:getAggressCreamBossModelTable()
	if not self._aggressCreamBossModelTable then
		self._aggressCreamBossModelTable = lt.AggressCreamBossModelDao:queryAll()
	end

	return self._aggressCreamBossModelTable
end

function CacheManager:getAggressCreamBossModel(monsterId)
	local aggressCreamBossModelTable = self:getAggressCreamBossModelTable()
	return aggressCreamBossModelTable[monsterId]
end

function CacheManager:getAggressCreamBossNpcFlushTable()
	if not self._aggressCreamBossNpcFlushTable then
		self._aggressCreamBossNpcFlushTable = lt.AggressCreamBossNpcFlushDao:queryAll()
	end

	return self._aggressCreamBossNpcFlushTable
end

function CacheManager:getAggressCreamBossNpcFlush(npcId)
	local aggressCreamBossNpcFlushTable = self:getAggressCreamBossNpcFlushTable()
	return aggressCreamBossNpcFlushTable[npcId]
end

-- ################################################## 活跃活动-怪物侵袭 monsterAttackModelTable monsterAttackNpcFlushTable ##################################################
function CacheManager:getMonsterAttackModelTable()
	if not self._monsterAttackModelTable then
		self._monsterAttackModelTable = lt.MonsterAttackModelDao:queryAll()
	end

	return self._monsterAttackModelTable
end

function CacheManager:getMonsterAttackModel(monsterId)
	local monsterAttackModelTable = self:getMonsterAttackModelTable()
	return monsterAttackModelTable[monsterId]
end

function CacheManager:getMonsterAttackNpcFlushTable()
	if not self._monsterAttackNpcFlushTable then
		self._monsterAttackNpcFlushTable = lt.MonsterAttackNpcFlushDao:queryAll()
	end

	return self._monsterAttackNpcFlushTable
end

function CacheManager:getMonsterAttackNpcFlush(npcId)
	local monsterAttackNpcFlushTable = self:getMonsterAttackNpcFlushTable()
	return monsterAttackNpcFlushTable[npcId]
end

--[[ ################################################## attackHeroInfo ##################################################
	普攻表-主角
	table[id] = attackInfo
	]]
function CacheManager:getAttackHeroTable()
	if not self._attackHeroTable then
		self._attackHeroTable = lt.AttackHeroDao:queryAll()
	end

	return self._attackHeroTable
end

function CacheManager:getAttackHeroInfo(occupationId)
	local attackHeroTable = self:getAttackHeroTable()
	return attackHeroTable[occupationId]
end

--[[ ################################################## attackInfo ##################################################
	普攻表-怪物
	table[id] = attackInfo
	]]
function CacheManager:getAttackTable()
	if not self._attackTable then
		self._attackTable = lt.AttackDao:queryAll()
	end

	return self._attackTable
end

function CacheManager:getAttackInfo(modelId)
	local attackTable = self:getAttackTable()
	return attackTable[modelId]
end

--[[ ################################################## 活跃奖励 activityReward ##################################################
	活跃奖励表
	table[actPoint] = activityRewardInfo
	]]
function CacheManager:getActivityRewardTable()
	if not self._activityRewardTable then
		self._activityRewardTable,self._activityRewardArray = lt.ActivityRewardDao:queryAll()
	end

	return self._activityRewardTable
end

function CacheManager:getActivityRewardArray()
	if not self._activityRewardArray then
		self:getActivityRewardTable()
	end

	return self._activityRewardArray
end

function CacheManager:getActivityRewardInfo(actPoint)
	local activityRewardTable = self:getActivityRewardTable()
	return activityRewardTable[actPoint]
end

--[[ ################################################## 普攻飞行物 attackFlyer ##################################################
	普攻飞行物表
	table[id] = attackInfo
	]]
function CacheManager:getAttackFlyerTable()
	if not self._attackFlyerTable then
		self._attackFlyerTable = lt.AttackFlyerDao:queryAll()
	end

	return self._attackFlyerTable
end

function CacheManager:getAttackFlyer(id)
	local attackFlyerTable = self:getAttackFlyerTable()
	return attackFlyerTable[id]
end

--[[ ################################################## baoopenCost ##################################################
	地下城区域
	结构 table[bagsize] = bagopenCostInfo
	]]
function CacheManager:getBagopenCostTable()
	if not self._bagopenCostTabel then
		self._bagopenCostTabel = lt.BagopenCostDao:queryAll()
	end

	return self._bagopenCostTabel
end

function CacheManager:getBagopenCostBySize(size)
	local bagopenCostTabel = self:getBagopenCostTable()

	return bagopenCostTabel[size]
end

-- ################################################## bossAudio ##################################################
function CacheManager:getBossAudioTable()
	if not self._bossAudioTable then
		self._bossAudioTable = lt.BossAudioDao:queryAll()
	end

	return self._bossAudioTable
end

function CacheManager:getBossAudio(modelId)
	local bossAudioTable = self:getBossAudioTable()
	return bossAudioTable[modelId]
end

-- ################################################## worldMonsterRefresh ##################################################
function CacheManager:getWorldMonsterRefreshTable()
	if not self._worldMonsterRefreshTable then
		self._worldMonsterRefreshTable, self._worldMonsterRefreshArray = lt.WorldMonsterRefreshDao:queryAll()
	end

	return self._worldMonsterRefreshTable
end

function CacheManager:getWorldMonsterRefreshArray(worldMapId)
	if not self._worldMonsterRefreshArray then
		self:getWorldMonsterRefreshTable()
	end

	return self._worldMonsterRefreshArray[worldMapId] or {}
end

--[[ ################################################## equipLevel ##################################################
	强化等级判断
	结构 table[type][level] = equipLevel
	]]
function CacheManager:getEquipLevelTable()
	if not self._equipLevelTable then
		self._equipLevelTable = lt.EquipLevelDao:queryAll()
	end

	return self._equipLevelTable
end

function CacheManager:getEquipLevel(equipType, level)
	local equipLevelTable = self:getEquipLevelTable()
	if not isset(equipLevelTable, equipType) then
		return nil
	else
		return equipLevelTable[equipType][level]
	end
end

--[[ ################################################## equipmentInfo ##################################################
	装备表
	结构 table[id] = equipmentInfo
	]]
function CacheManager:getEquipmentTable()--装备表
	if not self._equipmentTable then
		self._equipmentTable, self._equipmentSuitTable = lt.EquipmentDao:queryAll()
	end

	return self._equipmentTable
end

function CacheManager:getEquipmentSuitTable()
	if not self._equipmentSuitTable then
		self:getEquipmentTable()
	end

	return self._equipmentSuitTable
end

function CacheManager:getEquipmentInfo(equipmentId)
	local equipmentTable = self:getEquipmentTable()

	return equipmentTable[equipmentId]
end

function CacheManager:getEquipmentSuitInfo(suitId)
	local equipmentSuitTable = self:getEquipmentSuitTable()
	return equipmentSuitTable[suitId]
end

function CacheManager:getEquipmentOccupationTable()
	if not self._equipmentOccupationTable then
		self._equipmentOccupationTable = {}
		local equipmentTable = self:getEquipmentTable()
		for _, equipmentInfo in pairs(equipmentTable) do
			if equipmentInfo:getQuality() == lt.Constants.QUALITY.QUALITY_ORANGE then
				local arr = self._equipmentOccupationTable[equipmentInfo:getType()]
				if arr then
					arr[#arr+1] = equipmentInfo
				else
					arr = {}
					arr[#arr+1] = equipmentInfo
					self._equipmentOccupationTable[equipmentInfo:getType()] = arr
				end
			end 
		end
	end

	return self._equipmentOccupationTable
end

function CacheManager:getEquipmentInfoByOccupationAndLevel(level,equipType,occupation)
	local equipmentOccupationTable = self:getEquipmentOccupationTable()
	local arr = equipmentOccupationTable[equipType]
	if not arr then
		return nil
	end

	local levelMin = level
	local levelMax = level + 10

	for _, equipmentInfo in pairs(arr) do
		if equipmentInfo:belongOccupation(occupation) and equipmentInfo:getRequireLevel() >= levelMin and equipmentInfo:getRequireLevel() < levelMax then
			return equipmentInfo
		end
	end

	return nil
end

--[[ ################################################## equipmentAdditionalPropertyValuesTable ##################################################
	装备附魔表
	结构 table[additionalPropertyValueId][propertyType] = equipmentAdditionalPropertyValues
	]]
function CacheManager:getEquipmentAdditionalPropertyValuesTable()
	if not self._equipmentAdditionalPropertyValuesTable then
		self._equipmentAdditionalPropertyValuesTable = lt.EquipmentAdditionalPropertyValuesDao:queryAll()
	end

	return self._equipmentAdditionalPropertyValuesTable
end

function CacheManager:getEquipmentAdditionalPropertyValues(additionalPropertyValueId, propertyType)
	local equipmentAdditionalPropertyValuesTable = self:getEquipmentAdditionalPropertyValuesTable()
	if not isset(equipmentAdditionalPropertyValuesTable, additionalPropertyValueId) then
		return nil
	else
		return equipmentAdditionalPropertyValuesTable[additionalPropertyValueId][propertyType]
	end
end

function CacheManager:getEquipmentAdditionalPropertyValuesById(additionalPropertyValueId)
	local equipmentAdditionalPropertyValuesTable = self:getEquipmentAdditionalPropertyValuesTable()
	return equipmentAdditionalPropertyValuesTable[additionalPropertyValueId]
end

--[[ ################################################## equipmentEnchantingPropertyValuesTable ##################################################
	装备附魔表
	结构 table[enchantingPropertyValueId][propertyType] = equipmentEnchantingPropertyValues
	]]
function CacheManager:getEquipmentEnchantingPropertyValuesTable()
	if not self._equipmentEnchantingPropertyValuesTable then
		self._equipmentEnchantingPropertyValuesTable = lt.EquipmentEnchantingPropertyValuesDao:queryAll()
	end

	return self._equipmentEnchantingPropertyValuesTable
end

function CacheManager:getEquipmentEnchantingPropertyValues(enchantingPropertyValueId, propertyType, flag)
	local equipmentEnchantingPropertyValuesTable = self:getEquipmentEnchantingPropertyValuesTable()
	if not isset(equipmentEnchantingPropertyValuesTable, enchantingPropertyValueId) then
		return nil
	else
		return equipmentEnchantingPropertyValuesTable[enchantingPropertyValueId][propertyType][flag]
	end
end

function CacheManager:getEquipmentEnchantingPropertyValuesById(enchantingPropertyValueId)
	local equipmentEnchantingPropertyValuesTable = self:getEquipmentEnchantingPropertyValuesTable()
	return equipmentEnchantingPropertyValuesTable[enchantingPropertyValueId]
end

--[[ ################################################## equipmentLevelPropertyTable ##################################################
	装备强化属性表
	结构 table[level] = equipmentLevelProperty
	]]
function CacheManager:getEquipmentLevelPropertyTable()
	if not self._equipmentLevelPropertyTable then
		self._equipmentLevelPropertyTable = lt.EquipmentLevelPropertyDao:queryAll()
	end

	return self._equipmentLevelPropertyTable
end

function CacheManager:getEquipmentLevelProperty(level)
	local equipmentLevelPropertyTable = self:getEquipmentLevelPropertyTable()
	return equipmentLevelPropertyTable[level]
end

--[[ ################################################## equipQuality ##################################################
	装备品质判断
	结构 table[quality] = equipQuality
	]]
function CacheManager:getEquipQualityTable()
	if not self._equipQualityTable then
		self._equipQualityTable = lt.EquipQualityDao:queryAll()
	end

	return self._equipQualityTable
end

function CacheManager:getEquipQuality(quality)
	local equipQualityTable = self:getEquipQualityTable()
	return equipQualityTable[quality]
end

function CacheManager:getEquipQualityByLevel(quality,level)
	local equipQualityTable = self:getEquipQualityTable()
	return equipQualityTable[quality][level]
end

--[[ ################################################## equipMakeTable ##################################################
	装备打造表
	结构 table[level][occupation] = equipMakeInfo
	]]
function CacheManager:getEquipMakeArray()
	if not self._equipMakeArray then
		self._equipMakeArray = lt.EquipMakeDao:queryAll()
	end

	return self._equipMakeArray
end

function CacheManager:getEquipMakeByLevelAndOccupation(level,occupation)
	local equipMakeArray = self:getEquipMakeArray()
	return equipMakeArray[level][occupation]
end


--[[ ################################################## equipEnchantTable ##################################################
	装备附魔消耗
	结构 table[level] = equipEnchantInfo
	]]
function CacheManager:getEquipEnchantCostTable()
	if not self._equipEnchantCostTable then
		self._equipEnchantCostTable = lt.EquipEnchantCostDao:queryAll()
	end

	return self._equipEnchantCostTable
end

function CacheManager:getEquipEnchantCostByLevel(level)
	local equipEnchantCostTable = self:getEquipEnchantCostTable()
	return equipEnchantCostTable[level]
end

--[[ ################################################## equipConciseTable ##################################################
	装备洗练消耗
	结构 table[level] = equipConciseInfo
	]]
function CacheManager:getEquipConciseCostTable()
	if not self._equipConciseCostTable then
		self._equipConciseCostTable = lt.EquipConciseCostDao:queryAll()
	end

	return self._equipConciseCostTable
end

function CacheManager:getEquipConciseCostByLevel(level)
	local equipConciseCostTable = self:getEquipConciseCostTable()
	return equipConciseCostTable[level]
end

--[[ ################################################## siteStrengthTable ##################################################
	装备部位强化
	结构 table[position][level] = siteStrengthInfo
	]]
function CacheManager:getSiteStrengthTable()
	if not self._siteStrengthTable or not self._siteStrengthPositionTable then
		self._siteStrengthTable, self._siteStrengthPositionTable = lt.SiteStrengthDao:queryAll()
	end


	return self._siteStrengthTable, self._siteStrengthPositionTable
end

function CacheManager:getSiteStrengthTableByPosition(position)
	local siteStrengthTable, siteStrengthPositionTable = self:getSiteStrengthTable()

	return siteStrengthPositionTable[position]
end

function CacheManager:getSiteStrengthTableByPositionAndLevel(position,order,level)
	local siteStrengthTable = self:getSiteStrengthTable()

	if not siteStrengthTable[position] then
		return nil
	else
		return siteStrengthTable[position][order][level]
	end
end

--[[ ################################################## gem宝石相关 ##################################################
	装备部位
	结构 table[position]= gemInfo
	]]
function CacheManager:getGemPositionTable()

	if not self._gemPositionTable then
		self._gemPositionTable, self._gemPositionArray = lt.GemPositionDao:queryAll()
	end

	return self._gemPositionTable, self._gemPositionArray
end

function CacheManager:getGemTable(position,itemId)
	local gemPositionTable,gemPositionArray = self:getGemPositionTable()

	return gemPositionTable[position][itemId]
end

--宝石合成
function CacheManager:getGemComposeTable()

	if not self._gemComposeTable then
		self._gemComposeTable = lt.GemComposeDao:queryAll()
	end

	return self._gemComposeTable
end

function CacheManager:getGemComposeInfoById(id)
	local composeTable = self:getGemComposeTable()
	return composeTable[id]
end

--宝石开启
function CacheManager:getGemOpenTable()

	if not 	self._gemOpenTable then
		self._gemOpenTable, self._gemOpenArray = lt.GemOpenDao:queryAll()
	end

	return self._gemOpenTable
end

function CacheManager:getGemOpenTableByPositionAndSize(position, size)
	local gemOpenTable = self:getGemOpenTable()
	return gemOpenTable[position][size]
end

-- ################################################## 引导 ##################################################
function CacheManager:getGuideTable()
	if not self._guideTable then
		self._guideTable, self._dungeonGuideTable, self._layerGuideTable, self._taskGuideTable, self._levelGuideTable, self._taskCompleteGuideTable, self._functionGuideTable, self._specialGuideTable = lt.GuideDao:queryAll()
	end

	return self._guideTable
end

function CacheManager:getGuideInfo(guideId)
	local guideTable = self:getGuideTable()
	return guideTable[guideId]
end

function CacheManager:getDungeonGuide(dungeonMapId)
	if not self._dungeonGuideTable then
		self:getGuideTable()
	end

	return self._dungeonGuideTable[dungeonMapId] or {}
end

function CacheManager:getLayerGuide(layerIdx)
	if not self._layerGuideTable then
		self:getGuideTable()
	end

	return self._layerGuideTable[layerIdx]
end

function CacheManager:getTaskGuide(taskId)
	if not self._taskGuideTable then
		self:getGuideTable()
	end

	return self._taskGuideTable[taskId]
end

function CacheManager:getLevelGuide(level)
	if not self._levelGuideTable then
		self:getGuideTable()
	end

	return self._levelGuideTable[level]
end

function CacheManager:getTaskCompleteGuide(taskId)
	if not self._taskCompleteGuideTable then
		self:getGuideTable()
	end

	return self._taskCompleteGuideTable[taskId]
end

function CacheManager:getFunctionGuide(functionId)
	if not self._functionGuideTable then
		self:getGuideTable()
	end

	return self._functionGuideTable[functionId]
end

function CacheManager:getSpecialGuide(specialIdx)
	if not self._specialGuideTable then
		self:getGuideTable()
	end

	return self._specialGuideTable[specialIdx]
end

-- ################################################## 商会 shopClub ##################################################
function CacheManager:getShopClubTable()
	if not self._shopClubTable then
		self._shopFatherClubTable, self._shopClubTable = lt.ShopClubDao:queryAll()
	end

	return self._shopFatherClubTable, self._shopClubTable
end

function CacheManager:getShopClubByFatherCategory(fatherCategory)

	local shopFatherClubTable = self:getShopClubTable()
	return shopFatherClubTable[fatherCategory]
end

function CacheManager:getShopClubByFatherCategoryAndChildCategory(fatherCategory,childCategory)
	local _,shopClubTable  = self:getShopClubTable()
	return shopClubTable[fatherCategory][childCategory]
end


--[[ ################################################## hitEffect ##################################################
	受击特效
	结构 table[id] = hitEffect
	]]
function CacheManager:getHitEffectTable()
	if not self._hitEffectTable then
		self._hitEffectTable = lt.HitEffectDao:queryAll()
	end

	return self._hitEffectTable
end

function CacheManager:getHitEffect(hitEffectId)
	local hitEffectTable = self:getHitEffectTable(hitEffectId)
	return hitEffectTable[hitEffectId]
end

--[[ ################################################## itemInfo ##################################################
	结构 table[id] = itemInfo
	]]
function CacheManager:getItemTable()
	if not self._itemTable then
		self._itemTable = lt.ItemDao:queryAll()
	end

	return self._itemTable
end

function CacheManager:getItemInfo(itemId)
	local itemTable = self:getItemTable()

	return itemTable[itemId]
end

function CacheManager:getSheetTable()
	if not self._sheetTable then
		self._sheetTable = {}
		local itemTable = self:getItemTable()
		for _,item in pairs(itemTable) do
			if item:getTradeType() == lt.StallList.TRADETYPE.SHEET then
				local typeValue = item:getTypeValue()
	            local iEquipType = typeValue["position"]
	            local level = typeValue["level"]
	            local arr = self._sheetTable[iEquipType]
	            if arr then
	            	arr[level] = item
	            else
	            	self._sheetTable[iEquipType] = {[level] = item}
	            end
			end
		end
	end
	return self._sheetTable
end

function CacheManager:getSheet(equipType,level)
	local sheetTable = self:getSheetTable()
	local arr = sheetTable[equipType]
	if not arr then
		return nil
	end
	return arr[level]
end

function CacheManager:getCharacterItemTable()
	if not self._characterItemTable then
		self._characterItemTable = {}
		local itemTable = self:getItemTable()
		for _,item in pairs(itemTable) do
			if item:getType() == lt.Constants.ITEM_TYPE.CHARACTER_SCROLL then
				local arr = self._characterItemTable[item:getGrade()]
				if arr then
					arr[#arr+1] = item
				else
					arr = {}
					arr[#arr+1] = item
					self._characterItemTable[item:getGrade()] = arr
				end
			end
		end
		for _,arr in pairs(self._characterItemTable) do
			table.sort(arr, function(item1, item2)
				return item1:getId() < item2:getId()
			end)
		end
	end
	return self._characterItemTable
end

function CacheManager:getCharacterItemArray(characterType)
	local characterItemTable = self:getCharacterItemTable()
	return characterItemTable[characterType]
end

--[[ ################################################## levelExpInfo ##################################################
	结构:   table[level] = levelExpInfo
	]]
function CacheManager:getLevelExpTable()
	if not self._levelExpTable then
		self._levelExpTable = lt.LevelExpDao:queryAll()
	end

	return self._levelExpTable
end

function CacheManager:getLevelExpInfo(level)
	local levelExpTable = self:getLevelExpTable()

	return levelExpTable[level]
end

--[[ ################################################## levelExpInfo ##################################################
	主角经验表--巅峰等级
	结构:   table[level] = peaklevelExpTable
	]]
function CacheManager:getPeakLevelExpTable()
	if not self._peaklevelExpTable then
		self._peaklevelExpTable = lt.PeakLevelExpDao:queryAll()
	end

	return self._peaklevelExpTable
end

function CacheManager:getPeakLevelExpInfo(level)
	local peaklevelExpTable = self:getPeakLevelExpTable()

	return peaklevelExpTable[level]
end

-- ################################################## 迷宫 Maze ##################################################
-- ############################## 迷宫任务 MazeTaskInfo ##############################
function CacheManager:getMazeTaskTable()
	if not self._mazeTaskTable then
		self._mazeTaskTable = lt.MazeTaskDao:queryAll()
	end

	return self._mazeTaskTable
end

function CacheManager:getMazeTaskInfo(targetId)
	local mazeTaskTable = self:getMazeTaskTable()

	return mazeTaskTable[targetId]
end

-- ############################## 迷宫机关 MazeTriggerInfo ##############################
function CacheManager:getMazeTriggerTable()
	if not self._mazeTriggerTable then
		self._mazeTriggerTable, self._mazeTriggerArray = lt.MazeTriggerDao:queryAll()
	end

	return self._mazeTriggerTable
end

function CacheManager:getMazeTrigger(triggerId)
	local mazeTriggerTable = self:getMazeTriggerTable()

	return mazeTriggerTable[triggerId]
end

function CacheManager:getMazeTriggerArray(mapId)
	if not self._mazeTriggerArray then
		self:getMazeTriggerTable()
	end

	return self._mazeTriggerArray[mapId] or {}
end

--对话
function CacheManager:getMazeChatInfoTable()
	if not self._mazeChatInfoTable then
		self._mazeChatInfoTable, self._mazeChatInfoIdTable, self._allMessageNum = lt.MazeChatDao:queryAll()
	end

	return self._mazeChatInfoTable
end

function CacheManager:getMazeChatInfoByType(type)
	if not self._mazeChatInfoTable then
		self:getMazeChatInfoTable()
	end

	return self._mazeChatInfoTable[type]
end

function CacheManager:getMazeChatInfoByTypeId(type, id)
	if not self._mazeChatInfoIdTable then
		self:getMazeChatInfoTable()
	end

	return self._mazeChatInfoIdTable[type][id]
end

function CacheManager:getAllMessageNum()
	if not self._allMessageNum then
		self:getMazeChatInfoTable()
	end

	return self._allMessageNum
end

--[[ ################################################## peaklevelUpDate ##################################################
	主角成长表--巅峰升级属性
	结构:   table[occupation_id] = peaklevelUpDateTable
	]]
function CacheManager:getPeakLevelUpDateTable()
	if not self._peakLevelUpDateTable then
		self._peakLevelUpDateTable = lt.PeakLevelUpDateDao:queryAll()
	end

	return self._peakLevelUpDateTable
end

function CacheManager:getPeakLevelUpDateInfo(occupationId)
	local peaklevelUpDateTable = self:getPeakLevelUpDateTable()

	return peaklevelUpDateTable[occupationId]
end

--[[ ################################################## modelHeroInfo ##################################################
	模型表-主角
	结构:   table[id] = modelId
	]]
function CacheManager:getModelHeroTable()
	if not self._modelHeroTable then
		self._modelHeroTable = lt.ModelHeroDao:queryAll()
	end

	return self._modelHeroTable
end

function CacheManager:getModelHeroInfo(occupationId, sex)
	local modelHeroTable = self:getModelHeroTable()

	if not isset(modelHeroTable, occupationId) then
		return nil
	end

	return modelHeroTable[occupationId][sex]
end

--[[ ################################################## modelInfo ##################################################
	模型表(怪物/英灵)
	结构:   table[id] = modelId
	]]
function CacheManager:getModelTable()
	if not self._modelTable then
		self._modelTable = lt.ModelDao:queryAll()
	end

	return self._modelTable
end

function CacheManager:getModelInfo(modelId)
	local modelTable = self:getModelTable()
	return modelTable[modelId]
end

--[[ ################################################## monsterInfo ##################################################
	怪物表
	结构:   table[id] = monsterInfo
	]]
function CacheManager:getMonsterTable()
	if not self._monsterTable then
		self._monsterTable = lt.MonsterDao:queryAll()
	end

	return self._monsterTable
end

function CacheManager:getMonsterInfo(monsterId)
	local monsterTable = self:getMonsterTable()
	return monsterTable[monsterId]
end

function CacheManager:setMonsterInfo(monsterInfo)
	local monsterTable = self:getMonsterTable()
	monsterTable[monsterInfo:getId()] = monsterInfo
end

-- ################################################## monsterPurificationMonster ##################################################
function CacheManager:getMonsterPurificationMonsterTable( ... )
	if not self._monsterPurificationMonsterTable then
		self._monsterPurificationMonsterTable = lt.MonsterPurificationMonsterDao:queryAll()
	end

	return self._monsterPurificationMonsterTable
end

function CacheManager:getMonsterPurificationMonster(monsterId)
	local monsterPurificationMonsterTable = self:getMonsterPurificationMonsterTable()
	return monsterPurificationMonsterTable[monsterId]
end

function CacheManager:getMonsterPurificationFieldTable()--野外
	if not self._monsterPurificationFieldTable then
		self._monsterPurificationFieldTable = lt.MonsterPurificationFieldDao:queryAll()
	end

	return self._monsterPurificationFieldTable
end

function CacheManager:getMonsterPurificationFieldMonster(id)--野外
	local monsterPurificationFieldTable = self:getMonsterPurificationFieldTable()
	return monsterPurificationFieldTable[id]
end

function CacheManager:getMonsterPurificationFieldDataTable()--野外
	if not self._monsterPurificationFieldDataTable then
		self._monsterPurificationFieldDataTable = lt.MonsterPurificationFieldDataDao:queryAll()
	end

	return self._monsterPurificationFieldDataTable
end

function CacheManager:getMonsterPurificationFieldDataMonster(id)--野外
	local monsterPurificationFieldDataTable = self:getMonsterPurificationFieldDataTable()
	return monsterPurificationFieldDataTable[id]
end

function CacheManager:getMonsterPurificationBaseInfoTable()--野外
	if not self._monsterPurificationBaseInfoTable then
		self._monsterPurificationBaseInfoTable = lt.MonsterPurificationMonsterBaseInfoDao:queryAll()
	end

	return self._monsterPurificationBaseInfoTable
end

function CacheManager:getMonsterPurificationMonsterBaseInfo()--野外
	local monsterPurificationFieldDataTable = self:getMonsterPurificationBaseInfoTable()
	local playerLevel = lt.DataManager:getPlayerLevel()
	for i,info in ipairs(monsterPurificationFieldDataTable) do

		local min = json.decode(info:getLevelInterval())[1]
		local max = json.decode(info:getLevelInterval())[2]

		if playerLevel >= min and playerLevel <= max then
			return info
		end
	end

	return nil
end


--[[ ################################################## 公会boss ##################################################]]
function CacheManager:getGuildBossTable()
	if not self._guildBossTable then
		self._guildBossTable = lt.GuildBossDao:queryAll()
	end

	return self._guildBossTable
end

function CacheManager:getGuildBossById(id)
	local guildBossTable = self:getGuildBossTable()
	return guildBossTable[id]
end

function CacheManager:getGuildBossInfoTable()
	if not self._guildBossInfoTable then
		self._guildBossInfoTable = lt.GuildBossInfoDao:queryAll()
	end

	return self._guildBossInfoTable
end

function CacheManager:getGuildBossInfoBy(round, level)--波数和服务器等级
	local guildBossTable = self:getGuildBossInfoTable()
	local guildBossInfo = nil
    for k,guildBoss in pairs(guildBossTable) do
    	if guildBoss:getRound() == round then
    		local levelLimite = json.decode(guildBoss:getLevelArray())
    		if levelLimite[1] <= level and levelLimite[2] >= level then
    			guildBossInfo = guildBoss
    			break
    		end
    	end
    end

	return guildBossInfo
end

function CacheManager:getGuildWelfareTable()--公会福利
	if not self._GuildWelfareTable then
		self._GuildWelfareTable = lt.GuildWelfareDao:queryAll()
	end

	return self._GuildWelfareTable
end

function CacheManager:getGuildWelfareInfoBy(id)--

end

-- ################################################## 特殊事件info #############
function CacheManager:getSpecialEventRewardTable()
	if not self._specialEventRewardTable then
		self._specialEventRewardTable = lt.SpecialEventDao:queryAll()
	end

	return self._specialEventRewardTable
end

function CacheManager:getSpecialEventRewardTableByType(type)
	local specialEventRewardTable = self:getSpecialEventRewardTable()
	local tableInfo = {}
	for k,v in pairs(specialEventRewardTable) do
		if v:getRewardId() == type then
			tableInfo[v:getGiftId()] = v
		end
	end
	return tableInfo
end

function CacheManager:getMorrowGiftTalkTable()
	if not self._morrowGiftTalkTable then
		self._morrowGiftTalkTable = lt.MorrowGiftTalkDao:queryAll()
	end

	return self._morrowGiftTalkTable
end

-- ################################################## 全民答题派对 #############
function CacheManager:getNationAnswerPartyQuesTable()
	if not self._nationAnswerPartyQuesTable then
		self._nationAnswerPartyQuesTable = lt.NationAnswerPartyQuesDao:queryAll()
	end

	return self._nationAnswerPartyQuesTable
end

function CacheManager:getNationAnswerPartyQuesByType(type)
	local nationAnswerPartyQuesTable = self:getNationAnswerPartyQuesTable()

	return nationAnswerPartyQuesTable[type]
end

function CacheManager:getNationAnswerPartyRewardTable()
	if not self._nationAnswerPartyRewardTable then
		self._nationAnswerPartyRewardTable = lt.NationAnswerPartyRewardDao:queryAll()
	end

	return self._nationAnswerPartyRewardTable
end

function CacheManager:getNationAnswerPartyRewardByType(index)
	local nationAnswerPartyRewardTable = self:getNationAnswerPartyRewardTable()
	local info = nil

	local player = lt.DataManager:getPlayer()
	local level = player:getLevel()
	for k,v in pairs(nationAnswerPartyRewardTable) do
		local levelLimite =	json.decode(v:getlLevel())
		if levelLimite[1] <= level and levelLimite[2] >= level and v:getAnswerCount() == index then
			info = v
			break
		end
	end

	return info
end

--[[ ################################################## npcInfo ##################################################
	Npc表
	]]
function CacheManager:getNpcTable()
	if not self._npcTable then
		self._npcTable, self._npcArray = lt.NpcDao:queryAll()
	end

	return self._npcTable
end

function CacheManager:getNpcInfo(npcId)
	local npcTable = self:getNpcTable()

	return npcTable[npcId]
end

function CacheManager:getNpcArray(worldMapId)
	if not self._npcArray then
		self:getNpcTable()
	end

	return self._npcArray[worldMapId] or {}
end

--[[ ################################################## paper ##################################################
	图纸
	结构 table[id] = paper
	]]
function CacheManager:getPaperTable()
	if not self._paperTable then
		self._paperTable = lt.PaperDao:queryAll()
	end

	return self._paperTable
end

function CacheManager:getPaper(id)
	local paperTable = self:getPaperTable()
	return paperTable[id]
end

--[[ ################################################## skillInfo ##################################################
	技能
	结构 table[id] = skillInfo
	]]
function CacheManager:getSkillTable()
	if not self._skillTable then
		self._skillTable = lt.SkillDao:queryAll()
	end

	return self._skillTable
end

function CacheManager:getSkillInfo(skillId)
	local skillTable = self:getSkillTable()

	return skillTable[skillId]
end

--[[ ################################################## skillHeroInfo ##################################################
	技能

	skillHeroTable
	结构 table[id] = skillHeroInfo
	
	用于查询同类型技能升级
	skillHeroIndexLevelTable
	结构 table[index][level] = skillHeroInfo
	]]
function CacheManager:getSkillHeroTable()
	if not self._skillHeroTable then
		self._skillHeroTable, self._skillHeroIndexLevelTable = lt.SkillHeroDao:queryAll()
	end

	return self._skillHeroTable
end

function CacheManager:getSkillHeroTableByOccupation(occupation)
	if not self._skillHeroOccupationTable then
		self._skillHeroOccupationTable = {}
		local skillHeroTable = self:getSkillHeroTable()
		for _,skillHero in pairs(skillHeroTable) do
			local arr = self._skillHeroOccupationTable[skillHero:getOccupation()]
			if arr then
				arr[skillHero:getId()] = skillHero
			else
				arr = {}
				arr[skillHero:getId()] = skillHero
				self._skillHeroOccupationTable[skillHero:getOccupation()] = arr
			end
		end
	end
	return self._skillHeroOccupationTable[occupation]
end

function CacheManager:getSkillHeroInfo(skillId)
	local skillHeroTable,skillHeroIndexLevelTable = self:getSkillHeroTable()

	return skillHeroTable[skillId]
end

function CacheManager:getSkillHeroInfoByLevel(skillId, level)
	if not self._skillHeroIndexLevelTable then
		self:getSkillHeroTable()
	end

	local skillInfo = self:getSkillHeroInfo(skillId)

	local skillIdx = skillInfo:getIndex()

	return self._skillHeroIndexLevelTable[skillIdx][level]
end

function CacheManager:getSkillHeroTableByIndex(index)
	local skillHeroTable = self:getSkillHeroTable()

	local info = nil
	for _,skillInfo in pairs(skillHeroTable) do
		if skillInfo:getIndex() == index then
			info = skillInfo
			break
		end
	end

	return info
end

--[[ ################################################## suitProperies ##################################################
	传送阵
	结构:   table[id] = suitProperies
	]]
function CacheManager:getSuitProperiesTable()
	if not self._suitProperiesTable then
		self._suitProperiesTable = lt.SuitProperiesDao:queryAll()
	end

	return self._suitProperiesTable
end

function CacheManager:getSuitProperies(suitId)
	local suitProperiesTable = self:getSuitProperiesTable()
	return suitProperiesTable[suitId]
end

--[[ ################################################## ticket ##################################################
	工匠券
	结构 table[level] = artisanCertificate
	]]
function CacheManager:getTicketTable()
	if not self._ticketTable then
		self._ticketTable = lt.ArtisanCertificateDao:queryByType(1)
	end

	return self._ticketTable
end

function CacheManager:getTicket(level)
	local ticketTable = self:getTicketTable()

	return ticketTable[level]
end

--[[ ################################################## roleDataInfo ##################################################
	角色数据表
	结构:   table[id] = roleDataInfo
	]]

	--_roleDataTable
function CacheManager:getRoleDataTable()
	if not self._roleDataTable then
		self._roleDataTable = lt.RoleDataDao:queryAll()
	end

	return self._roleDataTable
end

function CacheManager:getRoleData(occupationId)
	local roleDataTable = self:getRoleDataTable()

	return roleDataTable[occupationId]
end

--[[ ################################################## roleGrowthInfo ##################################################
	主角成长表
	结构:   table[id] = roleGrowthInfo
	]]
function CacheManager:getRoleGrowthTable()
	if not self._roleGrowthTable then
		self._roleGrowthTable = lt.RoleGrowthDao:queryAll()
	end

	return self._roleGrowthTable
end


function CacheManager:getRoleGrowthByOccupationId(occupationId)
	local roleGrowthArrayTable = self:getRoleGrowthTable()

	return roleGrowthArrayTable[occupationId]
end

---- ################################################## 功能开启 FunctionOpen ##################################################
function CacheManager:getFunctionOpenTable()
	if not self._functionOpenTable then
		self._functionOpenTable, self._functionOpenArray = lt.FunctionOpenDao:queryAll()
	end

	return self._functionOpenTable
end

function CacheManager:getFunctionOpenArray()
	if not self._functionOpenArray then
		self:getFunctionOpenTable()
	end

	return self._functionOpenArray
end

function CacheManager:getFunctionOpen(id)
	local functionOpenTable = self:getFunctionOpenTable()
	return functionOpenTable[id]
end

---- ################################################## taskInfo ##################################################
function CacheManager:getTaskTable()
	if not self._taskTable then
		self._taskTable = lt.TaskDao:queryAll()
	end

	return self._taskTable
end

function CacheManager:getTaskInfo(taskId)
	local taskTable = self:getTaskTable()

	return taskTable[taskId]
end

--[[ ################################################## taskCollect ##################################################
	任务采集表
	]]
function CacheManager:getTaskCollectTable()
	if not self._taskCollectTable then
		self._taskCollectTable, self._taskCollectArray = lt.TaskCollectDao:queryAll()
	end

	return self._taskCollectTable
end

function CacheManager:getTaskCollectArray()
	if not self._taskCollectArray then
		self:getTaskCollectTable()
	end

	return self._taskCollectArray
end

function CacheManager:getTaskCollect(id)
	local taskCollectTable = self:getTaskCollectTable()

	return taskCollectTable[id]
end

function CacheManager:getTaskCollectArrayByMapId(mapId)
	local taskCollectArray = self:getTaskCollectArray()
	return taskCollectArray[mapId] or {}
end

---- ################################################## emotionInfo ##################################################
function CacheManager:getEmotionTable()
	if not self._emotionTable then
		self._emotionTable = lt.EmotionDao:queryAll()
	end

	return self._emotionTable
end

function CacheManager:isEmotionLoop(figureId, emotionId)
	local emotionTable = self:getEmotionTable()

	if not isset(emotionTable, figureId) then
		return false
	end

	return emotionTable[figureId][emotionId] or false
end

---- ################################################## tips ##################################################
--小贴士
function CacheManager:getTipsTable()
	if not self._tipsTable then
		self._tipsTable = lt.TipsDao:queryAll()
	end

	return self._tipsTable
end

function CacheManager:getTips(level)
	local tipsTable = self:getTipsTable()
	local tipsArray = {}
	for k,tips in pairs(tipsTable) do
		if level >= tips:getLevelMin() and level <= tips:getLevelMax() then
			tipsArray[#tipsArray+1] = tips
		end
	end

	if #tipsArray > 0 then
		local tips = tipsArray[math.random(#tipsArray)]
		return tips:getTips()
	end

	return ""
	
end

---- ################################################## dress ##################################################
function CacheManager:getDressTable()
	if not self._dressTable then
		self._dressTable = lt.DressDao:queryAll()

		self._dressTypeSexTable = {}
		self._dressFigureIdTable = {}
		for _,dressInfo in pairs(self._dressTable) do
			local arr1 = self._dressTypeSexTable[dressInfo:getType()]
			if arr1 then
				local arr2 = arr1[dressInfo:getSex()]
				if arr2 then
					arr2[#arr2+1] = dressInfo
				else
					arr2 = {}
					arr2[#arr2+1] = dressInfo
					arr1[dressInfo:getSex()] = arr2
				end
			else
				local arr2 = {}
				arr2[#arr2+1] = dressInfo
				local arr1 = {}
				arr1[dressInfo:getSex()] = arr2
				self._dressTypeSexTable[dressInfo:getType()] = arr1
			end

			self._dressFigureIdTable[dressInfo:getFigureId()] = dressInfo
		end
	end

	return self._dressTable
end

function CacheManager:getDressTableByTypeAndSex(type,sex)
	if not self._dressTypeSexTable then
		self:getDressTable()
	end
	local arr1 = self._dressTypeSexTable[type]
	if not arr1 then
		return nil
	end

	return arr1[sex]
end

function CacheManager:getDressTableByFigureId(figureId)
	if not self._dressFigureIdTable then
		self:getDressTable()
	end
	local dressInfo = self._dressFigureIdTable[figureId]
	if not dressInfo then
		return nil
	end

	return dressInfo
end

function CacheManager:getDress(id)
	local dressTable = self:getDressTable()
	return dressTable[id]
end

function CacheManager:getDressCostTable()
	if not self._dressCostTable then
		self._dressCostTable,self._dressCostArray = lt.DressCostDao:queryAll()
	end

	return self._dressCostTable,self._dressCostArray
end

function CacheManager:getDressArray(dressId)
	local dressCostTable,dressCostArray = self:getDressCostTable()
	local dressArray = dressCostArray[dressId]
	return dressArray
end

function CacheManager:getDressCost(dressId,timeLimit)
	local dressCostTable = self:getDressCostTable()
	return dressCostTable[dressId][timeLimit]
end

function CacheManager:getDressSexTable()
	if not self._dressSexTable then
		self._dressSexTable = {}
		local dressTable = self:getDressTable()
		for _,dressInfo in pairs(dressTable) do
			local arr = self._dressSexTable[dressInfo:getSex()]
			if arr then
				local originInfo = arr[dressInfo:getType()]
				if not originInfo then
					arr[dressInfo:getType()] = dressInfo
				else
					if dressInfo:getId() < originInfo:getId() then
						arr[dressInfo:getType()] = dressInfo
					end
				end
			else
				arr = {}
				arr[dressInfo:getType()] = dressInfo
				self._dressSexTable[dressInfo:getSex()] = arr
			end
		end
	end
	return self._dressSexTable
end

function CacheManager:getDressTableBySexAndOccupation(sex,occupation)
	local dressSexTable = self:getDressSexTable()
	local resultArray = {}
	local arr = dressSexTable[sex]
	for _,dressInfo in pairs(arr) do
		if dressInfo:getOccupation() == occupation then
			resultArray[#resultArray+1] = dressInfo
		end
	end

	return resultArray
end

function CacheManager:getWeaponTable()--武器特效表
	if not self._weaponTable then
		self._weaponTable = lt.WeaponDao:queryAll()
	end
	return self._weaponTable
end

function CacheManager:getWeaponOccupationTable()
	if not self._weaponOccupationTable then
		self._weaponOccupationTable = {}
		local weaponTable = self:getWeaponTable()
		for _,weaponInfo in pairs(weaponTable) do
			local arr = self._weaponOccupationTable[weaponInfo:getOccupation()]
			if arr then
				arr[#arr+1] = weaponInfo
			else
				arr = {}
				arr[#arr+1] = weaponInfo
				self._weaponOccupationTable[weaponInfo:getOccupation()] = arr
			end
		end
	end
	return self._weaponOccupationTable
end

function CacheManager:getWeaponTableByOccupation(occupation)
	local weaponOccupationTable = self:getWeaponOccupationTable()
	return weaponOccupationTable[occupation]
end

function CacheManager:getWeapon(id)
	local weaponTable = self:getWeaponTable()
	return weaponTable[id]
end

function CacheManager:getFigureTable()
	if not self._figureTable then
		self._figureTable = lt.FigureDao:queryAll()
	end
	return self._figureTable
end

function CacheManager:getFigure(id)
	local figureTable = self:getFigureTable()
	return figureTable[id]
end

function CacheManager:getFigureTypeSexTable()
	if not self._figureTypeSexTable then
		self._figureTypeSexTable = {}
		local figureTable = self:getFigureTable()
		for _,figure in pairs(figureTable) do
			local arr1 = self._figureTypeSexTable[figure:getType()]
			if arr1 then
				local arr2 = arr1[figure:getSex()]
				if arr2 then
					local arr3 = arr2[figure:getOccupation()]
					if arr3 then
						arr3[#arr3+1] = figure
					else
						arr3 = {}
						arr3[#arr3+1] = figure
						arr2[figure:getOccupation()] = arr3
					end
				else
					local arr3 = {}
					arr3[#arr3+1] = figure
					arr2 = {}
					arr2[figure:getOccupation()] = arr3
					arr1[figure:getSex()] = arr2
				end
			else
				local arr3 = {}
				arr3[#arr3+1] = figure
				local arr2 = {}
				arr2[figure:getOccupation()] = arr3
				arr1 = {}
				arr1[figure:getSex()] = arr2
				self._figureTypeSexTable[figure:getType()] = arr1
			end
		end
	end
	return self._figureTypeSexTable
end

function CacheManager:getFigureTableByTypeAndSex(Type,sex,occupation)
	local figureTypeSexTable = self:getFigureTypeSexTable()
	local arr1 = figureTypeSexTable[Type]
	if not arr1 then
		return {}
	end

	local arr2 = arr1[sex]
	if not arr2 then
		return {}
	end

	return arr2[occupation]
end

function CacheManager:getDressAdditionTable()
	if not self._dressAdditionTable then
		self._dressAdditionTable = lt.DressAdditionDao:queryAll()
	end
	return self._dressAdditionTable
end

function CacheManager:getDressAddition(level)
	local dressAdditionTable = self:getDressAdditionTable()
	return dressAdditionTable[level]
end

function CacheManager:getDressAdditionMaxLevel()
	local dressAdditionTable = self:getDressAdditionTable()
	return #dressAdditionTable
end

---- ################################################## dailyReward ##################################################
function CacheManager:getDailyRewardTable()
	if true then return {} end

	if not self._dailyRewardTable then
		self._dailyRewardTable = lt.DailyRewardDao:queryAll()
	end

	return self._dailyRewardTable
end

function CacheManager:getDailyReward(id)
	local dailyRewardTable = self:getDailyRewardTable()
	return dailyRewardTable[id]
end

---- ################################################## loginReward ##################################################
function CacheManager:getLoginRewardTable()
	if not self._loginRewardTable then
		self._loginRewardTable = lt.LoginRewardDao:queryAll()
	end

	return self._loginRewardTable
end

function CacheManager:getLoginReward(id)
	local loginRewardTable = self:getLoginRewardTable()
	return loginRewardTable[id]
end


---- ################################################## personality ##################################################



---- ################################################## firstCharge ##################################################
function CacheManager:getFirstChargeTable()
	if not self._firstChargeTable then
		self._firstChargeTable = lt.FirstChargeDao:queryAll()
	end

	return self._firstChargeTable
end

function CacheManager:getFirstCharge(id)
	local firstCharge = self:getFirstChargeTable()
	return firstCharge[id]
end

---- ################################################## stallSearchTable ##################################################
function CacheManager:getStallSearchTable(itemName)
	return lt.StallSearchDao:queryByName(itemName)
end


---- ################################################## worldMap ##################################################
function CacheManager:getWorldMapTable()
	if not self._worldMapTable then
		self._worldMapTable, self._worldMapArray, self._worldDungeonMapArray = lt.WorldMapDao:queryAll()
	end

	return self._worldMapTable
end

function CacheManager:getWorldMapArray(worldClassId)
	if not self._worldMapArray then
		self:getWorldMapTable()
	end

	return self._worldMapArray[worldClassId] or {}
end

function CacheManager:getWorldMap(worldMapId)
	local worldMapTable = self:getWorldMapTable()

	return worldMapTable[worldMapId]
end

function CacheManager:getWorldDungeonMapArray(worldMapId)
	if not self._worldDungeonMapArray then
		self:getWorldMapTable()
	end

	return self._worldDungeonMapArray[worldMapId] or {}
end

---- ################################################## worldMapTransfer ##################################################
function CacheManager:getWorldMapTransferTable()
	if not self._worldMapTransferTable then
		self._worldMapTransferTable, self._worldMapTransferArray = lt.WorldMapTransferDao:queryAll()
	end

	return self._worldMapTransferTable
end

function CacheManager:getWorldMapTransferArray(worldMapId)
	if not self._worldMapTransferArray then
		self:getWorldMapTransferTable()
	end

	return self._worldMapTransferArray[worldMapId] or {}
end

function CacheManager:getWorldMapTransfer(worldMapTransferId)
	local worldMapTransferTable = self:getWorldMapTransferTable()

	return worldMapTransferTable[worldMapTransferId]
end

---- ################################################## navigationPoint ##################################################
function CacheManager:getNavigationPointTable()
	if not self._navigationPointTable then
		self._navigationPointTable, self._navigationPointArray = lt.NavigationPointDao:queryAll()
	end

	return self._navigationPointTable
end

function CacheManager:getNavigationPointArray(worldMapId)
	if not self._navigationPointArray then
		self:getNavigationPointTable()
	end

	return self._navigationPointArray[worldMapId] or {}
end

function CacheManager:getNavigationPoint(navigationPointId)
	local navigationPointTable = self:getNavigationPointTable()
	return navigationPointTable[navigationPointId]
end

---- ################################################## navigationLine ##################################################
function CacheManager:getNavigationLineTable()
	if not self._navigationLineTable then
		self._navigationLineTable, self._navigationLineArray = lt.NavigationLineDao:queryAll()
	end

	return self._navigationLineTable
end

function CacheManager:getNavigationLineArray(worldMapId)
	if not self._navigationLineArray then
		self:getNavigationLineTable()
	end

	return self._navigationLineArray[worldMapId] or {}
end

---- ################################################## servant ##################################################
function CacheManager:getServantTable()
	if not self._servantTable then
		self._servantTable, self._servantCategoryTable = lt.ServantDao:queryAll()
	end
	return self._servantTable
end

function CacheManager:getServantCategoryTable()
	if not self._servantCategoryTable then
		self._servantTable, self._servantCategoryTable = lt.ServantDao:queryAll()
	end
	return self._servantCategoryTable
end
	
function CacheManager:getServantInfo(id)
	local servantTable = self:getServantTable()
	return servantTable[id]
end

function CacheManager:getServantInfoByCategory(category)
	local servantTable = self:getServantCategoryTable()
	
	return servantTable[category]
end

function CacheManager:getServantExchangeArray()
	if not self._servantExchangeArray then
		self._servantExchangeArray,self._servantExchangeTable = lt.ServantExchangeDao:queryAll()
	end
	return self._servantExchangeArray
end

function CacheManager:getServantExchangeByCategory(category)
	local servantExchangeArray = self:getServantExchangeArray()
	return servantExchangeArray[category]
end

function CacheManager:getServantExchangeTable()
	if not self._servantExchangeTable then
		self._servantExchangeArray,self._servantExchangeTable = lt.ServantExchangeDao:queryAll()
	end
	return self._servantExchangeTable
end

function CacheManager:getServantExchange(id)
	local servantExchangeTable = self:getServantExchangeTable()
	return servantExchangeTable[id]
end

function CacheManager:getServantExpTable()
	if not self._servantExpTable then
		self._servantExpTable = lt.ServantExpDao:queryAll()
	end
	return self._servantExpTable
end

function CacheManager:getServantExp(level)
	local servantExpTable = self:getServantExpTable()
	return servantExpTable[level]
end

function CacheManager:getServantCharacterTable()
	if not self._servantCharacterTable then
		self._servantCharacterTable,self._servantCharacterTypeTable = lt.ServantCharacterDao:queryAll()
	end
	return self._servantCharacterTable
end

function CacheManager:getServantCharacter(id)
	local servantCharacterTable = self:getServantCharacterTable()
	return servantCharacterTable[id]
end

function CacheManager:getServantCharacterTypeTable()
	if not self._servantCharacterTypeTable then
		self:getServantCharacterTable()
	end
	return self._servantCharacterTypeTable
end

function CacheManager:getServantCharacterByType(characterType)
	local servantCharacterTypeTable = self:getServantCharacterTypeTable()
	return servantCharacterTypeTable[characterType]
end

function CacheManager:getSkillServantTable()
	if not self._skillServantTable then
		self._skillServantTable,self._skillServantIndexLevelTable = lt.SkillServantDao:queryAll()
	end
	return self._skillServantTable
end

function CacheManager:getSkillServantInfo(id)
	local skillServantTable = self:getSkillServantTable()
	return skillServantTable[id]
end

function CacheManager:getServantUpgradeTable()
	if not self._servantUpgradeTable then
		self._servantUpgradeTable = lt.ServantUpgradeDao:queryAll()
	end
	return self._servantUpgradeTable
end

function CacheManager:getServantUpgrade(itemId)
	local servantUpgrade = self:getServantUpgradeTable()
	return servantUpgrade[itemId]
end

function CacheManager:getServantSkillUpgradeTable()
	if not self._servantSkillUpgradeTable then
		self._servantSkillUpgradeTable = lt.ServantSkillUpgradeDao:queryAll()
	end
	return self._servantSkillUpgradeTable
end

function CacheManager:getServantSkillUpgrade(level)
	local servantSkillUpgradeTable = self:getServantSkillUpgradeTable()
	return servantSkillUpgradeTable[level]
end

function CacheManager:getServantBoundInfoByTypeOrLevel(type, level) --羁绊类型 羁绊的等级
	local servantBound = self:getServantBoundTable()
	if level then
		return servantBound[type][level]
	end
	return servantBound[type]
end

function CacheManager:getServantBoundTable()
	if not self._servantBoundTable then
		self._servantBoundTable = lt.ServantBoundDao:queryAll()
	end
	return self._servantBoundTable
end

function CacheManager:getServantBoundPropertyAddTable(modelId, servantId)
	local servantInfo = lt.CacheManager:getServantInfo(modelId)
    if not servantInfo then
        return
    end
	local boundTypeTable = json.decode(servantInfo:getBoundType())--所有的羁绊类型

	local boundDataTabel = lt.DataManager:getServantBoundList()
    -- local playerServantInfo = lt.DataManager:getServant(modelId)
    -- local boundData = {}--服务器中这个英灵所有的羁绊数据
    -- if playerServantInfo then
    --     boundData = boundDataTabel[playerServantInfo:getId()] or {}
    -- end

    local boundData = {}--服务器中这个英灵所有的羁绊数据
    boundData = boundDataTabel[servantId] or {}
    local propertyAddTable= {}
    for k,boundType in pairs(boundTypeTable) do
    	if boundData[boundType] then
		    local boundId = boundData[boundType].boundId
            local servantBound = self:getServantBoundInfoByTypeOrLevel(boundType, boundId)
            if servantBound then
			    for k,v in pairs(servantBound:getPropertyArray()) do
					if k == lt.Constants.ATTRIBUTE.FIRE then
						if not propertyAddTable[lt.Constants.ATTRIBUTE.FIRE] then
							propertyAddTable[lt.Constants.ATTRIBUTE.FIRE] = 0
						end
						propertyAddTable[lt.Constants.ATTRIBUTE.FIRE] = propertyAddTable[lt.Constants.ATTRIBUTE.FIRE] + v
					elseif k == lt.Constants.ATTRIBUTE.WATER then
						if not propertyAddTable[lt.Constants.ATTRIBUTE.WATER] then
							propertyAddTable[lt.Constants.ATTRIBUTE.WATER] = 0
						end
						propertyAddTable[lt.Constants.ATTRIBUTE.WATER] = propertyAddTable[lt.Constants.ATTRIBUTE.WATER] + v
					elseif k == lt.Constants.ATTRIBUTE.WIND then
						if not propertyAddTable[lt.Constants.ATTRIBUTE.WIND] then
							propertyAddTable[lt.Constants.ATTRIBUTE.WIND] = 0
						end
						propertyAddTable[lt.Constants.ATTRIBUTE.WIND] = propertyAddTable[lt.Constants.ATTRIBUTE.WIND] + v
					elseif k == lt.Constants.ATTRIBUTE.LIGHT then
						if not propertyAddTable[lt.Constants.ATTRIBUTE.LIGHT] then
							propertyAddTable[lt.Constants.ATTRIBUTE.LIGHT] = 0
						end
						propertyAddTable[lt.Constants.ATTRIBUTE.LIGHT] = propertyAddTable[lt.Constants.ATTRIBUTE.LIGHT] + v
					elseif k == lt.Constants.ATTRIBUTE.DARK then
						if not propertyAddTable[lt.Constants.ATTRIBUTE.DARK] then
							propertyAddTable[lt.Constants.ATTRIBUTE.DARK] = 0
						end
						propertyAddTable[lt.Constants.ATTRIBUTE.DARK] = propertyAddTable[lt.Constants.ATTRIBUTE.DARK] + v
					end
				end
            end
    	end
    end

    return propertyAddTable
end

function CacheManager:getServantBoundPropertyByType(type, level)
	local servantBound = self:getServantBoundInfoByTypeOrLevel(type, level)
	
	local propertyAddTable= {}


	return self._servantBoundTable
end

---- ################################################## lifeSkill ##################################################
function CacheManager:getLifeSkillTable()

	if not self._lifeSkillExpTable then
		self._lifeSkillExpTable, self._lifeSkillExpArray, self._lifeSkillIndex = lt.LifeSkillExpDao:queryAll()
	end

	return self._lifeSkillExpTable, self._lifeSkillExpArray, self._lifeSkillIndex
end

function CacheManager:getLifeSkillBySkillId(skillId)
	local lifeSkillExpTable, lifeSkillExpArray , lifeSkillIndex = self:getLifeSkillTable()

	return lifeSkillIndex[skillId] or {}
end

function CacheManager:getLifeSkillBySkillIdAndLevel(skillId,level)
	local lifeSkillExpTable, lifeSkillExpArray , lifeSkillIndex = self:getLifeSkillTable()

	return lifeSkillExpTable[skillId][level] or {}
end

---- ################################################## lifeSkillMake ##################################################
function CacheManager:getLifeSkillMakeTable()

	if not self._lifeSkillMakeTable then
		self._lifeSkillMakeTable, self._lifeSkillMakeArray, self._lifeSkillMakeIndex = lt.LifeSkillMakeDao:queryAll()
	end

	return self._lifeSkillMakeTable, self._lifeSkillMakeArray, self._lifeSkillMakeIndex
end

function CacheManager:getLifeSkillRewardTableBySkillId(skillId)
	local lifeSkillMakeTable, lifeSkillMakeArray , lifeSkillIndex = self:getLifeSkillMakeTable()

	return lifeSkillIndex[skillId] or {}
end

function CacheManager:getLifeSkillMakeBySkillIdAndLevel(skillId, level)
	local lifeSkillMakeTable, lifeSkillMakeArray , lifeSkillIndex = self:getLifeSkillMakeTable()

	return lifeSkillMakeTable[skillId][level] or {}
end

---- ################################################## lifeSkillUnlock ##################################################

function CacheManager:getLifeSkillUnlockTable()
	if not self._lifeSkillUnlockTable then
		self._lifeSkillUnlockTable, self._lifeSkillUnlockArray, self._lifeSkillUnlockIndex = lt.LifeSkillUnlockDao:queryAll()
	end

	return self._lifeSkillUnlockTable, self._lifeSkillUnlockArray, self._lifeSkillUnlockIndex
end

function CacheManager:getLifeSkillUnlockArrayBySkillId(skillId)
	local lifeSkillUnlockTable, lifeSkillUnlockArray, lifeSkillUnlockIndex = self:getLifeSkillUnlockTable()

	return lifeSkillUnlockTable[skillId]
end

function CacheManager:getLifeSkillUnlockArrayBySkillIdAndLevel(skillId, level)
	local lifeSkillUnlockTable, lifeSkillUnlockArray, lifeSkillUnlockIndex = self:getLifeSkillUnlockTable()

	return lifeSkillUnlockIndex[skillId][level]
end


---- ################################################## lifeSkillLevelUpCost ##################################################
function CacheManager:getLifeSkillLevelUpCostTable()
	if not self._lifeSkillLevelUpCostTable then
		self._lifeSkillLevelUpCostTable = lt.LifeSkillLevelUpCostDao:queryAll()
	end

	return self._lifeSkillLevelUpCostTable
end

function CacheManager:getLifeSkillLevelUpCostInfoByTypeAndLevel(type, level)
	local lifeSkillLevelUpCostTable = self:getLifeSkillLevelUpCostTable()

	return lifeSkillLevelUpCostTable[type][level]
end

---- ################################################## alchemyAward ##################################################
function CacheManager:getAlchemyAwardTable()
	if not self._alchemyAwardTable then
		self._alchemyAwardTable = lt.AlchemyAwardDao:queryAll()
	end

	return self._alchemyAwardTable
end

function CacheManager:getAlchemyAwardTableByLevel(level)
	local alchemyAwardTable = self:getAlchemyAwardTable()
	local tempTable = {}
	for _,alchemyAward in pairs(alchemyAwardTable) do
		local jsonObj = json.decode(alchemyAward:getLevel())
		if jsonObj and #jsonObj == 2 then
			local levelMin = tonumber(jsonObj[1])
			local levelMax = tonumber(jsonObj[2])
			if level >= levelMin and level <= levelMax then
				tempTable[#tempTable+1] = alchemyAward
			end
		end 
	end

	local awardTable = {}
	local randomIdexTable = {}
	if #tempTable >= 11 then
		for i=1,#tempTable do
			randomIdexTable[i] = i
		end

		for i=1,11 do
			local index = math.random(1, #randomIdexTable)
			local alchemyAward = tempTable[randomIdexTable[index]]
			awardTable[i] = {id=alchemyAward:getItemId(),size=alchemyAward:getItemSize()}
			table.remove(randomIdexTable ,index)
		end
	else
		for i=1,11 do
			local index = math.random(1, #tempTable)
			local alchemyAward = tempTable[index]
			awardTable[i] = {id=alchemyAward:getItemId(),size=alchemyAward:getItemSize()}
		end
	end
	return awardTable
end

---- ################################################## 符文相关 ##################################################
function CacheManager:getRuneInfoTable()

	if not self._runeInfoTable then
		self._runeInfoTable = lt.RuneInfoDao:queryAll()
	end

	return self._runeInfoTable
end

function CacheManager:getRuneInfo(id)
	local runeInfoTable = self:getRuneInfoTable()

	return runeInfoTable[id]
end



---- ################################################## 符文开启 ##################################################
function CacheManager:getRuneOpenTable()

	if not self._runeOpenTable then
		self._runeOpenTable = lt.RuneOpenDao:queryAll()
	end

	return self._runeOpenTable
end

function CacheManager:getRuneOpen(id)
	local runeOpenTable = self:getRuneOpenTable()

	return runeOpenTable[id]
end

---- ################################################## 符文天赋 ##################################################
function CacheManager:getRuneTalentTable()

	if not self._runeTalentTable then
		self._runeTalentTable, self._runeTalentIndexTable = lt.RuneTalentDao:queryAll()
	end

	return self._runeTalentTable, self._runeTalentIndexTable
end

function CacheManager:getRuneTalentInfoByIndexAndLevel(index,level)
	local runeTalentTable, runeTalentIndexTable = self:getRuneTalentTable()

	return runeTalentIndexTable[index][level]
end

function CacheManager:getRuneTalentInfo(id)
	local runeTalentTable = self:getRuneTalentTable()

	return runeTalentTable[id]
end

function CacheManager:getRuneTalentInfoByIndex(index)
	local runeInfoTable = self:getRuneTalentTable()

	local info = nil
	for _,runeInfo in pairs(runeInfoTable) do
		if runeInfo:getIndex() == index then
			info = runeInfo
			break
		end
	end

	return info
end

---- ################################################## 符文页开启 ##################################################
function CacheManager:getRunePageOpenTable()

	if not self._runePageOpenTable then
		self._runePageOpenTable = lt.RunePageOpenDao:queryAll()
	end

	return self._runePageOpenTable
end

function CacheManager:getRunePageOpenInfo(id)
	local runePageOpenTable = self:getRunePageOpenTable()

	return runePageOpenTable[id]
end

---- ################################################## 奋起 ##################################################
function CacheManager:getRouseTable()

	if not self._rouseTable then
		self._rouseTable = lt.RouseDao:queryAll()
	end

	return self._rouseTable
end

function CacheManager:getRouseInfoByLevel(level)
	local rouseTable = self:getRouseTable()

	return rouseTable[level]
end

---- ################################################## 双倍经验 ##################################################
function CacheManager:getDoubleExpTable()

	if not self._doubleExpTable then
		self._doubleExpTable = lt.DoubleExpDao:queryAll()
	end

	return self._doubleExpTable
end

function CacheManager:getDoubleExpInfoByLevel(level)
	local doubleTable = self:getDoubleExpTable()

	return doubleTable[level]
end

---- ################################################## alchemyLevel ##################################################
function CacheManager:getAlchemyLevelTable()
	if not self._alchemyLevelTable then
		self._alchemyLevelTable = lt.AlchemyLevelDao:queryAll()
	end

	return self._alchemyLevelTable
end

function CacheManager:getAlchemyLevel(alchemyLevel)
	local alchemyLevelTable = self:getAlchemyLevelTable()
	return alchemyLevelTable[alchemyLevel]
end

---- ################################################## alchemyTask ##################################################
function CacheManager:getAlchemyTaskTable()
	if not self._alchemyTaskTable then
		self._alchemyTaskTable = lt.AlchemyTaskDao:queryAll()
	end

	return self._alchemyTaskTable
end

function CacheManager:getAlchemyTask(level,alchemyLevel)
	local alchemyTaskTable = self:getAlchemyTaskTable()
	for _,alchemyTask in pairs(alchemyTaskTable) do
		local jsonObj = json.decode(alchemyTask:getLevel())
		if jsonObj and #jsonObj == 2 then
			local levelMin = tonumber(jsonObj[1])
			local levelMax = tonumber(jsonObj[2])
			if level >= levelMin and level <= levelMax and alchemyTask:getAlchemyLevel() == alchemyLevel then
				return alchemyTask
			end
		end
	end
	return nil
end

---- ################################################## runeBoxCost ##################################################
function CacheManager:getRuneBoxCostTable()
	if not self._runeBoxCostTable then
		self._runeBoxCostTable = lt.RuneBoxCostDao:queryAll()
	end

	return self._runeBoxCostTable
end

function CacheManager:getRuneBoxCost(currencyType,awardType)
	local runeBoxCostTable = self:getRuneBoxCostTable()
	local arr = runeBoxCostTable[currencyType]
	if not arr then
		return nil
	end
	return arr[awardType]
end

---- ################################################## SEMonster ##################################################
function CacheManager:getSEMonsterTable()
	if not self._seMonsterTable then
		self._seMonsterTable, self._seMonsterArray = lt.SEMonsterDao:queryAll()
	end

	return self._seMonsterTable
end

function CacheManager:getSEMonster(id)
	local seMonsterTable = self:getSEMonsterTable()
	return seMonsterTable[id]
end

function CacheManager:getSEMonsterArray()
	if not self._seMonsterArray then
		self:getSEMonsterTable()
	end

	return self._seMonsterArray
end

---- ################################################## AdventureTask 冒险任务 ##################################################
function CacheManager:getAdventureTaskTable()
	if not self._adventureTaskTable then
		self._adventureTaskTable = lt.AdventureTaskDao:queryAll()
	end

	return self._adventureTaskTable
end

function CacheManager:getAdventureTask(id)
	local adventureTaskTable = self:getAdventureTaskTable()
	return adventureTaskTable[id]
end

---- ################################################## GuildBuildTask 公会建设 ##################################################
function CacheManager:getGuildBuildTaskTable()
	if not self._guildBuildTaskTable then
		self._guildBuildTaskTable = lt.GuildBuildTaskDao:queryAll()
	end

	return self._guildBuildTaskTable
end

function CacheManager:getGuildBuildTask(id)
	local guildBuildTaskTable = self:getGuildBuildTaskTable()
	return guildBuildTaskTable[id]
end

---- ################################################## 深渊领主 ##################################################
function CacheManager:getPitlordBossFlushTable()
	if not self._pitlordBossFlushTable then
		self._pitlordBossFlushTable = lt.PitlordBossFlushDao:queryAll()
	end

	return self._pitlordBossFlushTable
end

function CacheManager:getPitlordBossFlush(elementId,sequence)
	local pitlordBossFlushTable = self:getPitlordBossFlushTable()
	local arr = pitlordBossFlushTable[elementId]
	if arr then
		return arr[sequence]
	end
	return nil
end

function CacheManager:getPitlordBossModelTable()
	if not self._pitlordBossModelTable then
		self._pitlordBossModelTable = lt.PitlordBossModelDao:queryAll()
	end

	return self._pitlordBossModelTable
end

function CacheManager:getPitlordBossModel(monsterId)
	local pitlordBossModelTable = self:getPitlordBossModelTable()
	return pitlordBossModelTable[monsterId]
end

---- ################################################## 魔王的宝藏 ##################################################
function CacheManager:getTreasureBossModelTable()
	if not self._treasureBossModelTable then
		self._treasureBossModelTable = lt.TreasureBossModelDao:queryAll()
	end

	return self._treasureBossModelTable
end

function CacheManager:getTreasureBossModel(monsterId)
	local treasureBossModelTable = self:getTreasureBossModelTable()
	return treasureBossModelTable[monsterId]
end

function CacheManager:getTreasureRewardTable()
	if not self._treasureRewardTable then
		self._treasureRewardTable = lt.TreasureRewardDao:queryAll()
	end

	return self._treasureRewardTable
end

function CacheManager:getTreasureReward(level)
	local treasureRewardTable = self:getTreasureRewardTable()
	for _,treasureReward in pairs(treasureRewardTable) do
		if level >= treasureReward:getLevelMin() and level <= treasureReward:getLevelMax() then
			return treasureReward
		end
	end

	return nil
end

---- ################################################## 道具合成 ##################################################
function CacheManager:getItemComposeTable()
	if not self._itemComposeTable then
		self._itemComposeTable = lt.ItemComposeDao:queryAll()
	end

	return self._itemComposeTable
end

function CacheManager:getItemComposeInfo(id)
	local itemComposeTable = self:getItemComposeTable()
	return itemComposeTable[id]
end

---- ################################################## 连续签到 ##################################################

function CacheManager:getContinuousSignTable()
	if not self._continuousSignTable then
		self._continuousSignTable = lt.ContinuousSignDao:queryAll()
	end

	return self._continuousSignTable
end

function CacheManager:getContinuousSignInfo(id)
	local continuousSignTable = self:getContinuousSignTable()
	return continuousSignTable[id]
end

---- ################################################## 每日签到 ##################################################

function CacheManager:getDailySignTable()
	if not self._dailySignTable then
		self._dailySignTable = lt.DailySignDao:queryAll()
	end

	return self._dailySignTable
end

function CacheManager:getDailySignInfo(id)
	local dailySignTable = self:getDailySignTable()
	return dailySignTable[id]
end

---- ################################################## 每日签到小贴士 ##################################################

function CacheManager:getDailySignTipsTable()
	if not self._dailySignTipsTable then
		self._dailySignTipsTable = lt.DailySignTipsDao:queryAll()
	end

	return self._dailySignTipsTable
end

function CacheManager:getDailySignTipsInfo(id)
	local dailySignTipsTable = self:getDailySignTipsTable()
	return dailySignTipsTable[id]
end

---- ################################################## 每日签到属性日 ##################################################

function CacheManager:getDailySignPropertyTable()
	if not self._dailySignPropertyTable then
		self._dailySignPropertyTable = lt.DailySignPropertyDao:queryAll()
	end

	return self._dailySignPropertyTable
end

function CacheManager:getDailySignPropertyInfo(id)
	local dailySignPropertyTable = self:getDailySignPropertyTable()
	return dailySignPropertyTable[id]
end

---- ################################################## 升级奖励 ##################################################

function CacheManager:getLevelupRewardTable()
	if not self._levelupRewardTable then
		self._levelupRewardTable = lt.LevelupRewardDao:queryAll()
	end

	return self._levelupRewardTable
end

function CacheManager:getLevelupRewardInfo(level)
	local levelupRewardTable = self:getLevelupRewardTable()
	return levelupRewardTable[level]
end


function CacheManager:getStrongTable()
	if not self._strongTable then
		self._strongTable = lt.StrongDao:queryAll()
	end

	return self._strongTable
end

function CacheManager:getStrongInfoByType(type)
	local strongTable = self:getStrongTable()

	if strongTable[type] then
		return strongTable[type]
	else
		return nil
	end

end

--成长任务
function CacheManager:getGrowTaskTable()
	if not self._growTaskTable then
		self._growTaskTable, self._growTaskArray, self._growTaskSectionTable = lt.GrowTaskDao.queryAll()
	end

	return self._growTaskTable, self._growTaskArray, self._growTaskSectionTable
end

function CacheManager:getGrowTaskBySection(section)
	local growTaskTable, growTaskArray, growTaskSectionTable = self:getGrowTaskTable()

	return growTaskSectionTable[section]
end

function CacheManager:getGrowTask(id)
	local growTaskTable = self:getGrowTaskTable()

	return growTaskTable[id]
end

--扭蛋机
function CacheManager:getEggRewardTable()
	if not self._eggRewardTable then
		self._eggRewardTable = lt.EggRewardDao:queryAll()
	end
	return self._eggRewardTable
end

function CacheManager:getEggRewardInfoByType(type)
	local eggRewardTable = self:getEggRewardTable()

	if eggRewardTable[type] then
		return eggRewardTable[type]
	else
		return nil
	end

end

function CacheManager:getEggColorRewardTable()
	if not self._eggColorRewardTable then
		self._eggColorRewardTable = lt.EggColorRewardDao:queryAll()
	end
	return self._eggColorRewardTable
end

function CacheManager:getEggColorRewardInfoByType(type)
	local eggRewardTable = self:getEggColorRewardTable()

	if eggRewardTable[type] then
		return eggRewardTable[type]
	else
		return nil
	end
end

function CacheManager:getGoodCardTable()--好人卡
	if not self._goodCardTable then
		self._goodCardTable = lt.GainGoodCardListDao:queryAll()
	end
	return self._goodCardTable
end

function CacheManager:getGoodCardInfoByType(type)
	local goodCardTable = self:getGoodCardTable()

	if goodCardTable[type] then
		return goodCardTable[type]
	else
		return nil
	end
end
---- ################################################## 战力达人 ##################################################

function CacheManager:getFightRewardTable()
	if not self._fightRewardTable then
		self._fightRewardTable = lt.FightRewardDao:queryAll()
	end

	return self._fightRewardTable
end

--冲级奖励

function CacheManager:getLevelingRewardTable()
	if not self._levelingRewardTable then
		self._levelingRewardTable = lt.LevelingRewardDao:queryAll()
	end

	return self._levelingRewardTable
end

--红包奖励
function CacheManager:getRedPacketRewardTable()
	if not self._redPacketRewardTable then
		self._redPacketRewardTable = lt.ActivityRedPacketRewardDao:queryAll()
	end

	return self._redPacketRewardTable
end

-- ################################################## PVP奖励 ##################################################
function CacheManager:getPkSegmentTable()
	if not self._pkSegmentTable then
		self._pkSegmentTable = lt.PkSegmentDao:queryAll()
	end

	return self._pkSegmentTable
end

function CacheManager:getPkSegment(segmentId, segmentStarLevel)
	local pkSegmentTable = self:getPkSegmentTable()

	if not isset(pkSegmentTable, segmentId) then
		return nil
	end

	return pkSegmentTable[segmentId][segmentStarLevel]
end

-- ################################################## 组队目标 ##################################################
function CacheManager:getTeamTargetTypeTable()
	if not self._teamTargetTypeTable then
		self._teamTargetTypeTable = lt.TeamTargetTypeDao:queryAll()
	end
	return self._teamTargetTypeTable
end

function CacheManager:getTeamTargetType(type)
	local teamTargetTypeTable = self:getTeamTargetTypeTable()
	return teamTargetTypeTable[type]
end

function CacheManager:getTeamTargetTable()
	if not self._teamTargetTable then
		self._teamTargetTable, self._teamTargetArray = lt.TeamTargetDao:queryAll()
	end

	return self._teamTargetTable
end

function CacheManager:getTeamTargetArray()
	if not self._teamTargetArray then
		self:getTeamTargetTable()
	end

	return self._teamTargetArray
end

function CacheManager:getTeamTargetPitlord(key)
	local teamTargetArray = self:getTeamTargetArray()
	for _,teamTarget in ipairs(teamTargetArray) do
		if teamTarget:getType() == 4 and teamTarget:getKey() == key then
			return teamTarget
		end
	end

	return nil
end

function CacheManager:getTeamTargetDungeon(key)
	local teamTargetArray = self:getTeamTargetArray()
	for _,teamTarget in ipairs(teamTargetArray) do
		if teamTarget:getType() == 5 and teamTarget:getKey() == key then
			return teamTarget
		end
	end

	return nil
end

function CacheManager:getTeamTargetTranscend(key)
	local teamTargetArray = self:getTeamTargetArray()
	for _,teamTarget in ipairs(teamTargetArray) do
		if teamTarget:getType() == 6 and teamTarget:getKey() == key then
			return teamTarget
		end
	end

	return nil
end

function CacheManager:getTeamTargetMonsterPurification(key)
	local teamTargetArray = self:getTeamTargetArray()
	for _,teamTarget in ipairs(teamTargetArray) do
		if teamTarget:getType() == 7 and teamTarget:getKey() == key then
			return teamTarget
		end
	end

	return nil
end

function CacheManager:getTeamTarget(targetId)
	local teamTargetTable = self:getTeamTargetTable()
	return teamTargetTable[targetId]
end

-- ################################################## 活跃活动大战场 ##################################################
function CacheManager:getActivityBattlefieldTable()
	if not self._activityBattlefieldTable then
		self._activityBattlefieldTable, self._activityBattlefieldIndex = lt.ActivityBattlefieldDao:queryAll()
	end

	return self._activityBattlefieldTable, self._activityBattlefieldIndex
end

function CacheManager:getActivityBattlefieldInfoBySegmentId(segmentId)
	local activityBattlefieldTable,activityBattlefieldIndex = self:getActivityBattlefieldTable()

	return activityBattlefieldIndex[segmentId]

end

-- ################################################## 魔王巢穴 ##################################################
function CacheManager:getDevilNestBossTable()
	if not self._devilNestBossTable then
		self._devilNestBossTable = lt.DevilNestBossDao:queryAll()
	end

	return self._devilNestBossTable
end

function CacheManager:getDevilNestBossInfo(id)
	local devilNestBossTable = self:getDevilNestBossTable()

	return devilNestBossTable[id]
end


function CacheManager:getDevilNestPropertyTable()
	if not self._devilNestPropertyTable then
		self._devilNestPropertyTable = lt.DevilNestPropertyDao:queryAll()
	end

	return self._devilNestPropertyTable
end

function CacheManager:getDevilNestPropertyInfo(level)
	local devilNestPropertyTable = self:getDevilNestPropertyTable()

	return devilNestPropertyTable[level]
end

-- ################################################## 宝石达人 ##################################################

function CacheManager:getIntelligentGemTable()
	if not self._intelligentGemTable then
		self._intelligentGemTable = lt.IntelligentGemDao:queryAll()
	end

	return self._intelligentGemTable
end

-- ################################################## 英灵达人 ##################################################

function CacheManager:getIntelligentServantTable()
	if not self._intelligentServantTable then
		self._intelligentServantTable = lt.IntelligentServantDao:queryAll()
	end

	return self._intelligentServantTable
end

-- ################################################## 生活达人 ##################################################

function CacheManager:getIntelligentLifeTable()
	if not self._intelligentLifeTable then
		self._intelligentLifeTable = lt.IntelligentLifeDao:queryAll()
	end

	return self._intelligentLifeTable
end


-- ################################################## 强化达人 ##################################################

function CacheManager:getIntelligentStrengthTable()
	if not self._intelligentStrengthTable then
		self._intelligentStrengthTable = lt.IntelligentStrengthDao:queryAll()
	end

	return self._intelligentStrengthTable
end


-- ################################################## 好友度 ##################################################
function CacheManager:getFriendShipTable()
	if not self._friendShipTable then
		self._friendShipTable = lt.FriendShipDao:queryAll()
	end

	return self._friendShipTable
end

function CacheManager:getFriendShipInfoByPoint(point)
	local friendShipTable = self:getFriendShipTable()

	local info = nil
	for k,v in pairs(friendShipTable) do
		local range = v:getRange()

		local min = range[1]
		local max = range[2]

		if point >= min and point <= max then
			info = v
			break
		end

	end

	return info
end

-- ################################################## 好友度道具 ##################################################
function CacheManager:getSendFriendShipItemTable()
	if not self._sendFriendShipItemTable then
		self._sendFriendShipItemTable = lt.SendFriendShipItemDao:queryAll()
	end

	return self._sendFriendShipItemTable
end

-- ################################################## 公会狂欢 ##################################################
function CacheManager:getGuildCarnivalTable()
	if not self._guildCarnivalTable then
		self._guildCarnivalTable = lt.GuildCarnivalDao:queryAll()
	end

	return self._guildCarnivalTable
end

-- ################################################## 称号 ##################################################
function CacheManager:getPlayerTitleInfoTable()
	if not self._playerTitleInfoTable then
		self._playerTitleInfoTable = lt.PlayerTitleDao:queryAll()
	end

	return self._playerTitleInfoTable
end

function CacheManager:getPlayerTitleInfoById(id)
	if not self._playerTitleInfoTable then
		self:getPlayerTitleInfoTable()
	end

	return self._playerTitleInfoTable[id]
end

-- ################################################## 冒险小队活跃奖励 ##################################################
function CacheManager:getRiskTeamActiveRewardInfoTable()
	if not self._riskTeamActiveRewardInfoTable then
		self._riskTeamActiveRewardInfoTable = lt.RiskTeamActiveRewardDao:queryAll()
	end

	return self._riskTeamActiveRewardInfoTable
end

function CacheManager:getRiskTeamActiveRewardInfoById(id)
	if not self._riskTeamActiveRewardInfoTable then
		self:getRiskTeamActiveRewardInfoTable()
	end

	return self._riskTeamActiveRewardInfoTable[id]
end

-- ################################################## 主角天赋 ##################################################
function CacheManager:getHeroTalentTable()
	if not self._heroTalentTable then
		self._heroTalentTable, self._heroTalentIndexTable = lt.HeroTalentDao:queryAll()
	end

	return self._heroTalentTable, self._heroTalentIndexTable
end

function CacheManager:getHeroTalentInfo(id)
	local heroTalentTable, _ = self:getHeroTalentTable()
	return heroTalentTable[id]
end

function CacheManager:getHeroTalentIndexInfo(skillType, index)
	local heroTalentTable, heroTalentIndexTable = self:getHeroTalentTable()

	return heroTalentIndexTable[skillType][index]
end

function CacheManager:getHeroTalentLevelTable()
	local talentTable = self:getHeroTalentTable()

	local talentLevelTable = {}

	local occupationId = lt.DataManager:getOccupation()

	for id,talentInfo in ipairs(talentTable) do
		
		local occupation = talentInfo:getOccupation()
		local level = talentInfo:getLevel()

		if occupation == occupationId then

			if not isset(talentLevelTable, level) then
	            talentLevelTable[level] = {}
	        end

			table.insert(talentLevelTable[level], talentInfo)
		end

	end

	return talentLevelTable

end

-- ################################################## 兑换天赋 ##################################################
function CacheManager:getHeroExchangeTalentTable()
	if not self._heroExchangeTalentTable then
		self._heroExchangeTalentTable,self._heroExchangeTalentIndexTable = lt.HeroExchangeTalentDao:queryAll()
	end

	return self._heroExchangeTalentTable,self._heroExchangeTalentIndexTable
end

function CacheManager:getHeroExchangeTalentTableInfo(type,times)
	local table1, table2 = self:getHeroExchangeTalentTable()

	return table2[type][times]
end

-- ################################################## 天赋被动技能 ##################################################
function CacheManager:getTalentPassiveSkillTable()
	if not self._talentPassiveSkillTable then
		self._talentPassiveSkillTable, self._talentPassiveSkillIndexLevelTable = lt.TalentPassiveSkillDao:queryAll()
	end

	return self._talentPassiveSkillTable, self._talentPassiveSkillIndexLevelTable
end

function CacheManager:getTalentPassiveSkillInfo(skillId)
	local talentPassiveSkillTable, talentPassiveSkillIndexLevelTable = self:getTalentPassiveSkillTable()

	return talentPassiveSkillTable[skillId]
end

function CacheManager:getTalentPassiveSkillByLevel(skillId, level)
	if not self._talentPassiveSkillIndexLevelTable then
		self:getTalentPassiveSkillTable()
	end

	local skillInfo = self:getTalentPassiveSkillInfo(skillId)

	local skillIdx = skillInfo:getIndex()

	return self._talentPassiveSkillIndexLevelTable[skillIdx][level]
end

function CacheManager:getTalentPassiveSkillByIndexAndLevel(index, level)
	local talentPassiveSkillTable, talentPassiveSkillIndexLevelTable = self:getTalentPassiveSkillTable()

	return talentPassiveSkillIndexLevelTable[index][level]
end


function CacheManager:getTalentPassiveSkillTableByIndex(index)
	local talentPassiveSkillTable = self:getTalentPassiveSkillTable()

	local info = nil
	for _,skillInfo in pairs(talentPassiveSkillTable) do
		if skillInfo:getIndex() == index then
			info = skillInfo
			break
		end
	end

	return info
end

-- ################################################## 在线有礼 ##################################################
function CacheManager:getOnlineRewardFristTable()
	if not self._onlineRewardFristTable then
		self._onlineRewardFristTable = lt.OnlineRewardFristDao:queryAll()
	end

	return self._onlineRewardFristTable
end

function CacheManager:getOnlineRewardSecondTable()
	if not self._onlineRewardSecondTable then
		self._onlineRewardSecondTable = lt.OnlineRewardSecondDao:queryAll()
	end

	return self._onlineRewardSecondTable
end


return CacheManager
