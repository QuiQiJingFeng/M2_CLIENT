
--管理新标识
local NewFlagManager = {}

NewFlagManager.TYPE = {
	EMPTY = 0,
    HERO_INFO        = 1,           --玩家信息
    SKILL            = 2,           --技能
    DRESS            = 3,           --时装
    EQUIP_MAKE       = 4,           --打造
    GUILD            = 5,           --工会
    FRIEND           = 7,           --好友

	BAG_NEW_ITEM 	 = 100,			-- 背包新道具
    BAG_PROMOTE      = 11,          -- 背包装备战力提升
	SHILL_LEVEL_UP   = 12,			-- 技能可升级
    SERVANT_SUMMON   = 14,          -- 英灵可以召唤
	TASK_REWARD   	 = 15,			-- 任务奖励可领取
	ACTIVITY 		 = 11,          -- 活动可领奖
	CHAT_MESSAGE     = 16, 			-- 好友新消息
    FRIEND_REQUEST   = 17,          -- 好友申请
    SYSTEM_CHAT      = 18,          -- 系统消息
    RUNE_NEW         = 19,          -- 符文
    SERVANT          = 202,         -- 出战英灵可升级
    FAILED           = 203,         -- 地下城里面挂出来
    REBATE           = 500,         --充值返利可以领取
    GEM_NEW          = 101,         --宝石相关
    WELFARE_NEW      = 102,         --福利相关
    DAILY_SING       = 103,         --每日签到
    SEVEN_DAYS_SING  = 104,         --每周签到
    LEVEL_REWARD     = 105,         --等级奖励
    GROW_TASK        = 106,         --成长任务
    MONTH_CARD       = 200,         --月卡
    LEVELING_REWARD  = 300,         --冲级奖励
    FIGHTING_REWARD  = 301,         --战力奖励

}

NewFlagManager._riskTeamMessageNew = false
NewFlagManager._skillNew = false
NewFlagManager._stallIncomeNew  = false
NewFlagManager._runeBoxNew  = false
NewFlagManager._gemNew  = false
NewFlagManager._chatNew = false
NewFlagManager._friendRequest  = false
NewFlagManager._activityNew = false
NewFlagManager._battleFieldBoxNew = false
NewFlagManager._dressAdditionNew = false
NewFlagManager._guildNew = false
NewFlagManager._mailNew = false
NewFlagManager._monthCardNew = false
NewFlagManager._welfareNew = false
NewFlagManager._dailyReward = false
NewFlagManager._loginReward = false
NewFlagManager._levelReward = false
NewFlagManager._levelingReward = false
NewFlagManager._fightingReward = false
NewFlagManager._growTaskFlag   = false
NewFlagManager._growTaskUpdate = true
NewFlagManager._servantUnlock = false
NewFlagManager._servantAdvance = false
NewFlagManager._systemChat = false
NewFlagManager._runeEquip = false
NewFlagManager._recommendFieldBoss = false
NewFlagManager._morrowGiftPackage = false
NewFlagManager._newServiceRedPackage = false
NewFlagManager._intelligentGem = false
NewFlagManager._intelligentServant = false
NewFlagManager._intelligentLife = false
NewFlagManager._intelligentStrength = false
NewFlagManager._riskActiveRewardFlag = false
NewFlagManager._titleNotice = false
NewFlagManager._specialGiftBagFlag = false
NewFlagManager._firstRechargeFlag = false
NewFlagManager._siteStrengthFlag = false
NewFlagManager._talentSkillFlag = false
NewFlagManager._onlineRewardFlag = false
NewFlagManager._unlockServantTable = {}
NewFlagManager._advanceServantTable = {}

NewFlagManager._wechatActivityFlag        = 0
NewFlagManager._wechatAccumulateLoginFlag = 0
NewFlagManager._wechatFirstChargeFlag     = 0
NewFlagManager._wechatHappyTogetherFlag   = 0
NewFlagManager._wechatPowerFlag           = 0

NewFlagManager._totalChargeFlag         = false -- 累计充值
NewFlagManager._totalCostFlag           = false -- 累计消费
NewFlagManager._backGiftFlag            = false -- 累计充值
NewFlagManager._dailyTotalChargeFlag    = false -- 每日累充

NewFlagManager._check = false
NewFlagManager._checkIndex = 1
NewFlagManager._checkFuncArray = {
    function(self)
        -- 技能升级
        local skillNew = self:checkUpgradeSkill()
        if skillNew == self._skillNew then
            return false
        end

        self._skillNew = skillNew

        return true
    end,
    function(self)
        -- 商店
        local stallIncomeNew = self:checkStallIncomeNew()
        if stallIncomeNew == self._stallIncomeNew then
            return false
        end

        self._stallIncomeNew = stallIncomeNew

        return true
    end,
    function(self)
        -- 符文宝箱
        local runeBoxNew = self:checkRuneBoxNew()
        if runeBoxNew == self._runeBoxNew then
            return false
        end

        self._runeBoxNew = runeBoxNew

        return true
    end,
    function(self)
        -- 宝石穿戴
        local gemNew = self:checkGemNew()
        if gemNew == self._gemNew then
            return false
        end

        self._gemNew = gemNew

        return true
    end,
    function(self)
        -- 聊天
        local chatNew = self:checkNewChatMessage()
        if chatNew == self._chatNew then
            return false
        end

        self._chatNew = chatNew

        return true
    end,
    function(self)
        -- 好友请求
        local friendRequest = self:checkNewRequestMessage()
        if friendRequest == self._friendRequest then
            return false
        end

        self._friendRequest = friendRequest

        return true
    end,
    function(self)
        -- 活动奖励
        local activityNew = self:checkActivityComplete()
        if activityNew == self._activityNew then
            return false
        end

        self._activityNew = activityNew

        return true
    end,
    function(self)
        -- 活动奖励
        local battleFieldBoxNew = self:checkBattleFieldBox()
        if battleFieldBoxNew == self._battleFieldBoxNew then
            return false
        end

        self._battleFieldBoxNew = battleFieldBoxNew

        return true
    end,
    function(self)
        -- 时装
        local dressAdditionNew = self:canUpgradeDressAddition()
        if dressAdditionNew == self._dressAdditionNew then
            return false
        end

        self._dressAdditionNew = dressAdditionNew

        return true
    end,
    function(self)
        -- 公会
        local guildNew = self:hasGuildEvent()
        if guildNew == self._guildNew then
            return false
        end

        self._guildNew = guildNew

        return true
    end,
    function(self)
        -- 邮件
        local mailNew = self:checkNewMail()
        if mailNew == self._mailNew then
            return false
        end

        self._mailNew = mailNew

        return true
    end,
    function(self)
        -- 月卡
        local monthCardNew = self:checkMonthCardReceive()
        if monthCardNew == self._monthCardNew then
            return false
        end

        self._monthCardNew = monthCardNew

        return true
    end,
    function(self)
        -- 福利
        local welfareNew = self:hasNewWelfare()
        if welfareNew == self._welfareNew then
            return false
        end

        self._welfareNew = welfareNew

        return true
    end,
    function(self)
        -- 每日签到
        local dailyReward = self:hasDailyReward()
        if dailyReward == self._dailyReward then
            return false
        end

        self._dailyReward = dailyReward

        return true
    end,
    function(self)
        -- 连续签到
        local loginReward = self:hasLoginReward()
        if loginReward == self._loginReward then
            return false
        end

        self._loginReward = loginReward

        return true
    end,
    function(self)
        -- 等级奖励
        local levelReward = self:hasLevelReward()
        if levelReward == self._levelReward then
            return false
        end

        self._levelReward = levelReward

        return true
    end,
    function(self)
        -- 冲级达人
        local levelingReward = self:checkLevelingReward()
        if levelingReward == self._levelingReward then
            return false
        end

        self._levelingReward = levelingReward

        return true
    end,
    function(self)
        -- 战力达人
        local fightingReward = self:checkFightingReward()
        if fightingReward == self._fightingReward then
            return false
        end

        self._fightingReward = fightingReward

        return true
    end,
    function(self)
        -- 成长任务
        local growTaskFlag = self:checkGrowTaskReward()
        if growTaskFlag == self._growTaskFlag then
            return false
        end

        self._growTaskFlag = growTaskFlag

        return true
    end,
    function(self)
        -- 英灵解锁
        local servantUnlock = self:checkServantUnlock()
        if servantUnlock == self._servantUnlock and not servantUpdate then
            return false
        end

        self._servantUnlock = servantUnlock

        return true
    end,
    function(self)
        -- 英灵进阶
        local servantAdvance = self:checkServantAdvance()
        if servantAdvance == self._servantAdvance then
            return false
        end

        self._servantAdvance = servantAdvance

        return true
    end,
    function(self)
        -- 英灵羁绊
        local servantBound  = self:checkServantBound()
        if servantBound  == self._servantBound then
            return false
        end

        self._servantBound = servantBound

        return true
    end,

    function(self)
        -- 好友里面的系统消息
        local systemChat = self:hasSystemChat()
        if systemChat == self._systemChat then
            return false
        end

        self._systemChat = systemChat

        return true
    end,
    function(self)
        -- 符文有可镶嵌部位
        local runeEquip = self:hasRuneEquip()
        if runeEquip == self._runeEquip then
            return false
        end

        self._runeEquip = runeEquip

        return true
    end,
    function(self)
        --野外boss推荐
        local recommend = self:hasMonsterPurificationField()
        if recommend == self._recommendFieldBoss then
            return false
        end
        self._recommendFieldBoss = recommend
        return true
    end,

    function(self)
        --次日礼包领取奖励和摸头
        local recommend = self:hasMorrowGiftPackage()
        if recommend == self._morrowGiftPackage then
            return false
        end
        self._morrowGiftPackage = recommend
        return true
    end,

    function(self)
        --新服红包
        local recommend = self:hasNewSerViceRedPackage()
        if recommend == self._newServiceRedPackage then
            return false
        end
        self._newServiceRedPackage = recommend
        return true
    end,

    function(self)
        --公会福利
        local recommend = self:hasGuildWelfare()
        if recommend == self._guildWelfare then
            return false
        end
        self._guildWelfare = recommend
        return true
    end,

    function(self)
        --宝石达人
        local intelligentGem = self:hasIntelligentGem()
        if intelligentGem == self._intelligentGem then
            return false
        end
        self._intelligentGem = intelligentGem
        return true
    end,

    function(self)
        --英灵达人
        local intelligentServant = self:hasIntelligentServant()
        if intelligentServant == self._intelligentServant then
            return false
        end
        self._intelligentServant = intelligentServant
        return true
    end,

    function(self)
        --生活达人
        local intelligentLife = self:hasIntelligentLife()
        if intelligentLife == self._intelligentLife then
            return false
        end
        self._intelligentLife = intelligentLife
        return true
    end,

    function(self)
        --强化达人
        local intelligentStrength = self:hasIntelligentStrength()
        if intelligentStrength == self._intelligentStrength then
            return false
        end
        self._intelligentStrength = intelligentStrength
        return true
    end,

    function(self)
        --小队活跃奖励
        local riskActiveRewardFlag = self:hasNewRiskActiveRewardFlag()
        if riskActiveRewardFlag == self._riskActiveRewardFlag then
            return false
        end
        self._riskActiveRewardFlag = riskActiveRewardFlag
        return true
    end,

    function(self)
        --称号小红点
        local titleNotice = self:configPlayerTitle()
        return false
    end, 

    function(self)
        --称号小红点
        local titleNotice = self:hasNewTitle()

        if titleNotice == self._titleNotice then
            return false
        end
        self._titleNotice = titleNotice
        return true
    end, 

    function(self)
        --首冲累冲
        local notice = self:hasFirstRechargeFlag()

        if notice == self._firstRechargeFlag then
            return false
        end
        self._firstRechargeFlag = notice
        return true
    end, 

    function(self)
        --基金
        local notice = self:hasGrowFundFlag()

        if notice == self._growFundFlag then
            return false
        end
        self._growFundFlag = notice
        return true
    end, 

    function(self)
        --特惠礼包小红点
        local notice = self:hasSpecialGiftBag()

        if notice == self._specialGiftBagFlag then
            return false
        end
        self._specialGiftBagFlag = notice
        return true
    end, 

    function(self)
        --部位强化
        local notice = self:checkSiteStrength()

        if notice == self._siteStrengthFlag then
            return false
        end
        self._siteStrengthFlag = notice
        return true
    end,
    function(self)
        --天赋升级
        local notice = self:checkTalentSkill()

        if notice == self._talentSkillFlag then
            return false
        end
        self._talentSkillFlag = notice
        return true
    end, 
    function(self)
        -- 微信活动-是否开启
        local notice = self:checkWechatActivity()
        if notice == self._wechatActivityFlag then
            return false
        end
        self._wechatActivityFlag = notice
        return true
    end,
    function(self)
        -- 微信红包-累计登录
        local notice = self:checkWechatAccumulateLogin()
        if notice == self._wechatAccumulateLoginFlag then
            return false
        end
        self._wechatAccumulateLoginFlag = notice
        return true
    end,
    function(self)
        -- 微信红包-首充红包
        local notice = self:checkWechatFirstCharge()
        if notice == self._wechatFirstChargeFlag then
            return false
        end
        self._wechatFirstChargeFlag = notice
        return true
    end,
    function(self)
        -- 微信红包-一起来嗨
        local notice = self:checkWechatHappyTogether()
        if notice == self._wechatHappyTogetherFlag then
            return false
        end
        self._wechatHappyTogetherFlag = notice
        return true
    end,
    function(self)
        -- 微信红包-战力红包
        local notice = self:checkWechatPower()
        if notice == self._wechatPowerFlag then
            return false
        end
        self._wechatPowerFlag = notice
        return true
    end,
    function(self)
        -- 运营活动-累计充值
        local notice = self:checkTotalCharge()
        if notice == self._totalChargeFlag then
            return false
        end
        self._totalChargeFlag = notice
        return true
    end,
    function(self)
        -- 运营活动-累计消费
        local notice = self:checkTotalCost()
        if notice == self._totalCostFlag then
            return false
        end
        self._totalCostFlag = notice
        return true
    end,
    function(self)
        -- 运营活动-回流礼包
        local notice = self:checkBackGift()
        if notice == self._backGiftFlag then
            return false
        end
        self._backGiftFlag = notice
        return true
    end,
    function(self)
        -- 运营活动-每日累计充值
        local notice = self:checkDailyTotalCharge()
        if notice == self._dailyTotalChargeFlag then
            return false
        end

        self._dailyTotalChargeFlag = notice
        return true
    end,

    function(self)
        -- 女皇的贡品
        local notice = self:checkQueenTribute()
        if notice == self._queenTributeFlag then
            return false
        end

        self._queenTributeFlag = notice
        return true
    end,

    function(self)
        -- 多买多送
        local notice = self:checkMoreAndMoreFlag()
        if notice == self._moreAndMoreFlag then
            return false
        end

        self._moreAndMoreFlag = notice
        return true
    end,

    function(self)
        -- 限时特惠礼包
        local notice = self:checkSpecialFlag()
        if notice == self._specialFlag then
            return false
        end

        self._specialFlag = notice
        return true
    end,

    function(self)
        -- 冒险者宝藏
        local notice = self:checkAdventurerRewardFlag()
        if notice == self._adventurerRewardFlag then
            return false
        end

        self._adventurerRewardFlag = notice
        return true
    end,

    function(self)
        -- 
        local notice = self:checkRiskTeamMessageNew()
        if notice == self._riskTeamMessageNew then
            return false
        end

        self._riskTeamMessageNew = notice
        return true
    end,
    function(self)
        -- 在线有礼
        local notice = self:checkOnlineRewardNew()
        if notice == self._onlineRewardFlag then
            return false
        end

        self._onlineRewardFlag = notice
        return true
    end,


}

function NewFlagManager:init()
    local update = false

    for _,checkFunc in ipairs(self._checkFuncArray) do
        update = checkFunc(self) or update
    end

    if update then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.NEW_FLAG_UPDATE)
    end
end

function NewFlagManager:clear()
end

function NewFlagManager:onUpdate(delta)
    self:update()
end

function NewFlagManager:update()
    -- 2帧检查一次
    self._check = not self._check

    if not self._check then
        return
    end

    local checkFunc = self._checkFuncArray[self._checkIndex]
    if checkFunc then
        if checkFunc(self) then
            lt.GameEventManager:post(lt.GameEventManager.EVENT.NEW_FLAG_UPDATE)
        end
    end

	self._checkIndex = self._checkIndex + 1
    if self._checkIndex > #self._checkFuncArray then
        self._checkIndex = 1
    end
end

function NewFlagManager:getNewFlagByType(type)
    if type == self.TYPE.HERO_INFO then
        return self._gemNew or self._titleNotice
    elseif type == self.TYPE.SKILL then
        return self._skillNew or self._runeEquip
    elseif type == self.TYPE.DRESS then
        return self._dressAdditionNew
    elseif type == self.TYPE.GUILD then
        return self._guildNew or self._guildWelfare
    elseif type == self.TYPE.FRIEND then
        return self._chatNew or self._friendRequest or self._mailNew or self:hasSystemChat() or self._riskActiveRewardFlag or self:checkRiskTeamMessageNew()
    else
		return false
	end
end

function NewFlagManager:checkRiskTeamMessageNew()
    return lt.DataManager:getRiskTeamMessageNew()
end

--运营活动
function NewFlagManager:hasOperationNew()
    return self:hasTotalChargeFlag() or self:hasTotalCostFlag() or self:hasBackGiftFlag() or self:hasDailyTotalChargeFlag() or self:getQueenTributeFlag() == 2 or self:getMoreAndMoreFlag() == 2
end


--累计充值
function NewFlagManager:hasTotalChargeFlag()
    return self._totalChargeFlag
end

function NewFlagManager:checkTotalCharge()
    local batchActivityTable = lt.DataManager:getBatchActivityLogListTable()

    local flag = false

    local currentInfo = nil

    if batchActivityTable and batchActivityTable[lt.Constants.BATCH_ACTIVITY_ID.ACCUMULATIVE_RECHARGE] then
        currentInfo = batchActivityTable[lt.Constants.BATCH_ACTIVITY_ID.ACCUMULATIVE_RECHARGE]
    end

    if not currentInfo then 
        return 
    end

    local stateArray = currentInfo:getStateArray()

    local totalCount = currentInfo:getAmount()
    local currentArray = currentInfo:getActivityRewardArray()

    for i = 1, #currentArray do
        local info = currentArray[i]

        local index = info:getIndex()

        if stateArray and stateArray[index] then
            local state = stateArray[index]
            if state == 1 then
                flag = true
                break
            end
        end
    end

    return flag
end

--累计消费
function NewFlagManager:hasTotalCostFlag()
    return self._totalCostFlag
end

function NewFlagManager:checkTotalCost()
    local batchActivityTable = lt.DataManager:getBatchActivityLogListTable()

    local flag = false

    local currentInfo = nil

    if batchActivityTable and batchActivityTable[lt.Constants.BATCH_ACTIVITY_ID.ACCUMULATIVE_COST] then
        currentInfo = batchActivityTable[lt.Constants.BATCH_ACTIVITY_ID.ACCUMULATIVE_COST]
    end

    if not currentInfo then 
        return 
    end

    local stateArray = currentInfo:getStateArray()

    local totalCount = currentInfo:getAmount()
    local currentArray = currentInfo:getActivityRewardArray()

    for i = 1, #currentArray do
        local info = currentArray[i]

        local index = info:getIndex()

        if stateArray and stateArray[index] then
            local state = stateArray[index]
            if state == 1 then
                flag = true
                break
            end
        end
    end

    return flag
end

--回流礼包
function NewFlagManager:hasBackGiftFlag()
    return self._backGiftFlag
end

function NewFlagManager:checkBackGift()
    local rewardArray = lt.DataManager:getBackFlowRewardTable()

    local batchActivityTable = lt.DataManager:getBatchActivityTable()

    local flag = false

    local backGiftInfo = nil
    local serviceType = 0
    if batchActivityTable and batchActivityTable[lt.Constants.BATCH_ACTIVITY_ID.BACK_GIFT] then
        backGiftInfo = batchActivityTable[lt.Constants.BATCH_ACTIVITY_ID.BACK_GIFT]
        serviceType = backGiftInfo:getServiceType()
    end


    if serviceType ~= 2 then
        return
    end

    local rewardInfoTable = lt.DataManager:getBackFlowTable()

    -- if rewardInfoTable and rewardInfoTable[id] then
    --     isReceive = rewardInfoTable[id]:getIsReceive()
    -- end

    for _,v in pairs(rewardInfoTable) do
        local isReceive = v:getIsReceive()
        if isReceive and isReceive == 0 then
            flag = true
            break
        end
    end

    return flag
end

--每日累计充值
function NewFlagManager:hasDailyTotalChargeFlag()
    return self._dailyTotalChargeFlag
end

function NewFlagManager:checkDailyTotalCharge()
    local batchActivityTable = lt.DataManager:getBatchActivityLogListTable()

    local flag = false

    local currentInfo = nil

    if batchActivityTable and batchActivityTable[lt.Constants.BATCH_ACTIVITY_ID.DAILY_TOTAL_CHARGE] then
        currentInfo = batchActivityTable[lt.Constants.BATCH_ACTIVITY_ID.DAILY_TOTAL_CHARGE]
    end

    if not currentInfo then 
        return 
    end

    local stateArray = currentInfo:getStateArray()

    local totalCount = currentInfo:getAmount()
    local currentArray = currentInfo:getActivityRewardArray()

    for i = 1, #currentArray do
        local info = currentArray[i]

        local index = info:getIndex()

        if stateArray and stateArray[index] then
            local state = stateArray[index]
            if state == 1 then
                flag = true
                break
            end
        end
    end

    return flag
end

-- 好友新消息
function NewFlagManager:hasNewChatMessage()
    return self._chatNew
end

function NewFlagManager:checkNewChatMessage()
    local recentContactTable = lt.DataManager:getRecentContactTable()

	if next(recentContactTable) == nil then
        return false
    else
        for id,contactInfo in pairs(recentContactTable) do
            if contactInfo:getHasNewMessage() == 1 then
                return true
            end
        end
        return false
	end
end

-- 好友新消息
function NewFlagManager:hasSystemChat()
    return lt.DataManager:getSystemChat()
end

-- 好友请求
function NewFlagManager:hasNewRequestMessage()
    return self._friendRequest
end

function NewFlagManager:checkNewRequestMessage()
    local requestTable = lt.DataManager:getFriendRequestTable()

    return not lt.CommonUtil:isTableEmpty(requestTable)
end

--活动可领取奖励
function NewFlagManager:hasActivityReward()
    return self:hasActivityComplete() or self:hasBattleFieldBox() or self._recommendFieldBoss
end

function NewFlagManager:hasActivityComplete()
    return self._activityNew
end

function NewFlagManager:checkActivityComplete()
    --活跃度大于等于30的时候 或者 完成活动可以领取奖励
    local player = lt.DataManager:getPlayer()
    if not player then
        return
    end

    local activityBoxInfo = lt.DataManager:getPlyActiveBoxInfo()
    if not activityBoxInfo then 
        return
    end

    local currentTime = lt.CommonUtil:getCurrentTime()

    local idx = 0

    for i = 1, 4 do
        local posTime = activityBoxInfo:getPosTime(i)

        if posTime > currentTime then
            idx = idx + 1
        end

        if posTime > 0 and posTime < currentTime then
            return true
        end
    end

    local activityPoint = player:getTotalActiveDegree()
    if idx ~= 4 and activityPoint >= lt.Constants.ACTIVITY_OPEN_BOX_POINT then
        return true
    end

    --判断任务完成后有没有领取奖励
    local finishFlag = 1
    local activityTable = lt.CacheManager:getActivityTable()

    local taskInfo = nil
    for k,info in pairs(activityTable) do
        local activityTag = info:getTag()
        local allExeclCount = info:getExecLimit()
        local currentTimes = 0
        local id = info:getId()

        if id == lt.Constants.ACTIVITY.ADVENTURE_TASK then
            taskInfo = lt.DataManager:getActivityAdventureTask()
            if taskInfo then
                currentTimes = taskInfo:getAllCount()
            end

        elseif id == lt.Constants.ACTIVITY.ADVENTURE_TRIAL then
            taskInfo = lt.DataManager:getActivityAdventureTrail()
            if taskInfo then
                currentTimes = taskInfo:getAllRound()
            end

        elseif id == lt.Constants.ACTIVITY.MONSTER_PURIFICATION then
            taskInfo = lt.DataManager:getActivityMonsterPurification()
            if taskInfo then
                currentTimes = taskInfo:getAllCount()
            end

        elseif id == lt.Constants.ACTIVITY.PITLORD then
            taskInfo = lt.DataManager:getActivityPitlordTask()
            if taskInfo then
                currentTimes = taskInfo:getAllCount()
            end

        elseif id == lt.Constants.ACTIVITY.TREASURE then
            taskInfo = lt.DataManager:getActivityTreasureTask()
            if taskInfo then
                currentTimes = taskInfo:getAllCount()
            end

        elseif id == lt.Constants.ACTIVITY.GUARD then
            taskInfo = lt.DataManager:getActivityGuard()
            if taskInfo then
                currentTimes = taskInfo:getAllCount()
            end
        elseif id == lt.Constants.ACTIVITY.GUILD_FAM then
            taskInfo = lt.DataManager:getActivityGuildFam()
            if taskInfo then
                currentTimes = taskInfo:getAllCount()
            end
            
        end

        if taskInfo then
            if currentTimes >= allExeclCount and allExeclCount ~= 0 then
                local finishedReward =  info:getFinishedReward()
                if finishedReward == 1 then
                    local finishFlag = taskInfo:getFinishedReceiveFlag()
                    if finishFlag == 0 then
                        return true
                    end
                end
            end
        end
    end

    return false
end

-- 战场可宝箱
function NewFlagManager:hasBattleFieldBox()
    return self._battleFieldBoxNew
end

function NewFlagManager:checkBattleFieldBox()
    local daily3V3RewardReceiveArray = lt.DataManager:getDaily3V3RewardReceiveArray()
    for idx,daily3V3RewardReceive in ipairs(daily3V3RewardReceiveArray) do
        local status = daily3V3RewardReceive.status
        if status == 1 then
            return true
        end
    end

    return false
end

--英灵可解锁
function NewFlagManager:hasServantUnlock()
    return self._servantUnlock
end

function NewFlagManager:checkServantUnlock()
    local unlock = false
    local unlockTable = {}

    local servantExchangeArray = lt.CacheManager:getServantExchangeArray()
    for _,servantExchange in pairs(servantExchangeArray) do
        if servantExchange:getUnlock() ~= 1 then
            local itemId    = servantExchange:getItemId()
            local itemCount = servantExchange:getItemSize()
            local selfCount = lt.DataManager:getItemCount(itemId)

            if selfCount >= itemCount then
                unlock = true   

                local category = servantExchange:getCategory()
                unlockTable[category] = true      
            end
        end
    end
    return unlock, unlockTable
end

--英灵可进阶
function NewFlagManager:hasServantAdvance()
    return self._servantAdvance
end

function NewFlagManager:checkServantAdvance()
    local advance = false
    local advanceTable = {}

    local playerServantTable = lt.DataManager:getServantTable()--玩家的英灵

    for _,playerServant in pairs(playerServantTable) do
        local modelId = playerServant:getModelId()
        local servantInfo = lt.CacheManager:getServantInfo(modelId)
        if servantInfo then
            if servantInfo:getAdvanceFlag() == 1 then --阶级不是最高
                local count = lt.DataManager:getItemCount(servantInfo:getItemId())
                if count >= servantInfo:getItemSize() then
                    advance = true

                    local category = servantInfo:getCategory()
                    advanceTable[category] = true
                end
            end
        end
    end

    return advance, advanceTable
end

--英灵可羁绊
function NewFlagManager:hasServantBound()
    return self._servantBound
end

function NewFlagManager:checkServantBound()

    local boundNotice = false
    local boundTable = {}

    if lt.DataManager:getPlayerLevel() < lt.Constants.SERVANT_BOUND_OPEN_LEVEL then
        return bound, boundTable
    end

    local playerServantTable = lt.DataManager:getServantTable()--玩家的英灵
    local boundDataTabel = lt.DataManager:getServantBoundList()

    for _,playerServant in pairs(playerServantTable) do
        local modelId = playerServant:getModelId()
        local servantInfo = lt.CacheManager:getServantInfo(modelId)
        if servantInfo then
            local boundTypeTable = json.decode(servantInfo:getBoundType())--该英灵的羁绊类型
            local boundData = boundDataTabel[playerServant:getId()] or {}--服务器中这个英灵所有的羁绊数据
            for k,boundType in pairs(boundTypeTable) do

                local nextBoundData = nil
                if boundData[boundType] then--如果该羁绊类型已解锁
                    local boundId = boundData[boundType].boundId
                    nextBoundData = lt.CacheManager:getServantBoundInfoByTypeOrLevel(boundType, boundId+1)--获取下一级
                else--还没有羁绊解锁
                    if lt.CacheManager:getServantBoundInfoByTypeOrLevel(boundType) then--羁绊表里有该羁绊类型
                        for k,bound in pairs(lt.CacheManager:getServantBoundInfoByTypeOrLevel(boundType)) do
                            if bound:getLevel() == 1 then
                                nextBoundData = bound
                            end
                        end                    
                    end    
                end

                if nextBoundData then--
                    if nextBoundData:getRequireLevel() <= playerServant:getLevel() then--等级满足
                        local currentItemCount = lt.DataManager:getItemCount(nextBoundData:getItemId())
                        if currentItemCount >= nextBoundData:getItemSize() then--消耗满足

                            local unlock = false--解锁么
                            local stateOk = false--品阶达到了么
                            for k,requireModelId in pairs(nextBoundData:getRequireServant()) do
                                unlock = false
                                stateOk = false
                                local requireServantInfo = lt.CacheManager:getServantInfo(requireModelId)
                                for k,playerSer in pairs(playerServantTable) do--从玩家英灵中找要求的英灵是否满足
                                    local servant = lt.CacheManager:getServantInfo(playerSer:getModelId())
                                    if servant:getCategory() == requireServantInfo:getCategory() then--玩家已拥有该英灵
                                        unlock = true
                                        if playerSer:getModelId() >= requireServantInfo:getId() then--满足需求英灵条件
                                            stateOk = true
                                        end
                                        break
                                    end
                                end

                                if not unlock or not stateOk then
                                    break
                                end
                            end

                            if unlock and stateOk then
                                boundNotice = true
                                boundTable[servantInfo:getCategory()] = true
                            end
                        end
                    end
                end
            end
        end
    end

    return boundNotice, boundTable
end

function NewFlagManager:hasNewWelfare()
    return self._dailyReward or self._loginReward or self._levelReward or self._growFundFlag or self._onlineRewardFlag
end

-- 每日签到
function NewFlagManager:hasDailyReward()
    local player = lt.DataManager:getPlayer()
    if not player then
        return
    end

    local dailySigninLogListTable = lt.DataManager:getDailySigninLogListTable()
    local weekDay = lt.CommonUtil:getCurrentWeekDay()

    if isset(dailySigninLogListTable, weekDay) then
        local info = dailySigninLogListTable[weekDay]
        local isReceive = info:getIsReceive()

        if isReceive == 2 then
            return true
        end
    end

    return false
end

-- 连续签到
function NewFlagManager:hasLoginReward()
    local player = lt.DataManager:getPlayer()
    if not player then
        return false
    end

    local table = lt.DataManager:getDeleteActivityInfoTable()

    if table[lt.Constants.ACTIVITY_ID.SEVENDAYSSIGN] and table[lt.Constants.ACTIVITY_ID.SEVENDAYSSIGN] == 2 then
        return false
    end

    local count = player:getSerialSigninReceiveCount()


    if count > 7 then
        return false
    end

    --0 可领取 -- 1已领取
    local flag = player:getSerialSigninState()

    if flag == 0 then
        return true
    end

    return false
end

function NewFlagManager:hasLevelReward()--等级奖励
    local player = lt.DataManager:getPlayer()
    if not player then
        return
    end

    local table = lt.DataManager:getDeleteActivityInfoTable()

    if table[lt.Constants.ACTIVITY_ID.LEVELUP] and table[lt.Constants.ACTIVITY_ID.LEVELUP] == 2 then
        return false
    end
    
    local levelupRewardTable = lt.CacheManager:getLevelupRewardTable()

    local flag = false
    for _,levelupInfo in pairs(levelupRewardTable) do
        local level = levelupInfo:getLevel()

        local upgradeInfo = lt.DataManager:getUpgradeRewardLogListInfo(level)
        if not upgradeInfo then
            break
        end

        local isReceive = upgradeInfo:getIsReceive()

        --0:未达到  1：可领取，2：已领取
        if isReceive == 1 then
            return true
        end
    end

    return flag
end

-- 新邮件
function NewFlagManager:hasNewMail()
    return self._mailNew
end

function NewFlagManager:checkNewMail()
    local mailTable = lt.DataManager:getMailTable()
    if not mailTable then
        return false
    end

    for _,mail in pairs(mailTable) do
        if mail:getStatus() == 0 then
            return true
        end
    end
    return false
end

-- 商店刷新
function NewFlagManager:hasStallIncomeNew()
    return self._stallIncomeNew
end

function NewFlagManager:checkStallIncomeNew()
    local finishedRecordTable = lt.DataManager:getPlayerTradingFinishedRecordTable()
    for _,tradingOrder in pairs(finishedRecordTable) do
        if tradingOrder:getType() == 0 then
            return true
        else
            local currentTime = lt.CommonUtil:getCurrentTime()
            if currentTime > tradingOrder:getDealTime() + 86400 then
               return true
            end
        end
    end

    return false
end

-- 符文宝箱
function NewFlagManager:hasRuneBoxNew()
    return self._runeBoxNew
end

function NewFlagManager:checkRuneBoxNew()
    local player = lt.DataManager:getPlayer()
    if not player then
        return false
    end

    if player:getLevel() < lt.Constants.RUNE_BOX_OPEN_LEVEL then
        return false
    end

    local playerRuneBox = lt.DataManager:getRuneBox(1)
    if not playerRuneBox then
        return true
    end

    if playerRuneBox:getFreeCount() == 0 then
        return true
    end

    local curTime = lt.CommonUtil:getCurrentTime()
    if curTime - playerRuneBox:getRefreshTime() >= 86400*2 then
        return true
    end

    return false
end

function NewFlagManager:hasDownMenuNew()
    return self._skillNew or self._gemNew or self._titleNotice or self._guildNew or self._runeEquip 
    or self._dressAdditionNew or self._guildWelfare or self._friendRequest or self:hasSystemChat() 
    or self._chatNew or self._mailNew

end

-- 宝石可装备
function NewFlagManager:hasGemNew()
    return self._gemNew
end

function NewFlagManager:checkGemNew()
    local playerLevel = lt.DataManager:getPlayerLevel()
    if not playerLevel then
        return
    end

    for j = 1, 10 do
        local position = j
        local positionInfo = lt.DataManager:getPositionStrengthInfoByPosition(position)

        if not positionInfo then return end

        for i = 1, 3 do
            local stoneId = positionInfo:getStoneById(i)
            local stoneSequence = positionInfo:getStoneSequenceByIdx(i)

            local gemOpenInfo = lt.CacheManager:getGemOpenTableByPositionAndSize(j, i)
            local level = gemOpenInfo:getLevel()

            if stoneSequence == 0 then

                if playerLevel >= level then
                    return true
                end

            else

                local selectGemArray = self:getCurrentGemTable(j)
                if stoneId > 0 then

                    local level =  0

                    local info = lt.CacheManager:getGemTable(j,stoneId)
                    if info then

                        level = info:getLevel()

                        for i = 1,#selectGemArray do
                            local modelId = selectGemArray[i]:getItemInfo():getModelId()
                            local gemInfo = lt.CacheManager:getGemTable(position,modelId)

                            local bagLevel = gemInfo:getLevel()
                            
                            if bagLevel > level then
                                return true
                            end
                        end
                    end
                else

                    if #selectGemArray > 0 then
                        return true
                    end

                end

            end

        end
    end

    return false
end

function NewFlagManager:getCurrentGemTable(position)
    local allItem = lt.DataManager:getAllItemArray()

    local gemPositionTable,gemPositionArray = lt.CacheManager:getGemPositionTable()


    local currentGemPositionIdArray = {}
    for i = 1,#gemPositionArray do
        if gemPositionArray[i]:getPosition() == position then
            currentGemPositionIdArray[#currentGemPositionIdArray + 1] = gemPositionArray[i]:getItemId()
        end
    end

    local selectGemTable = {}
    for id,itemInfo in pairs(allItem) do
        local itemModelId = itemInfo:getModelId()

        for i = 1,#currentGemPositionIdArray do
            local itemId = currentGemPositionIdArray[i]
            if itemModelId == itemId then
                selectGemTable[id] = itemInfo
            end
        end
    end

    local gemArray = lt.CommonUtil:getArrayFromTable(selectGemTable)

    table.sort(gemArray, function(info1, info2)
        if info1:getModelId() > info2:getModelId() then
            return true
        end
    end)

    return gemArray
end

--部位强化
function NewFlagManager:hasSiteStrengthNew()
    return self._siteStrengthFlag
end

function NewFlagManager:getItemIdArray(equipMakeInfo)

    local itemIdArray = {}
    for i = 1, 3 do
        if equipMakeInfo:getMaterialId(i) and equipMakeInfo:getMaterialId(i) ~= 0 then
            itemIdArray[#itemIdArray + 1] = equipMakeInfo:getMaterialId(i)
        end
    end

    return itemIdArray
end

function NewFlagManager:getItemSizeArray(equipMakeInfo)

    local itemSizeArray = {}
    for i = 1, 3 do
        if equipMakeInfo:getMaterialSize(i) and equipMakeInfo:getMaterialSize(i) ~= 0 then
            itemSizeArray[#itemSizeArray + 1] = equipMakeInfo:getMaterialSize(i)
        end
    end

    return itemSizeArray
end

function NewFlagManager:checkSiteStrength()
    

    if not lt.DataManager:isSiteFuncOpen() then
        return
    end

    local currentTable = {}

    for position = 1, 10 do

        currentTable[position] = 1

        local positionInfo = lt.DataManager:getPositionStrengthInfoByPosition(position)
        local level = 0
        local order = 0
        if positionInfo then
            level = positionInfo:getLevel()
            order = positionInfo:getOrder()
        end

        local nextLevel = level + 1
        local nextOrder = order
        if nextLevel % 5 == 0 then
            nextOrder = nextOrder + 1
            nextLevel = 0
        end

        if nextOrder > 16 then
            nextOrder = 16
        end

        -- 下级强化
        local nextSiteStrengthInfo = lt.CacheManager:getSiteStrengthTableByPositionAndLevel(position, nextOrder, nextLevel)
        if nextSiteStrengthInfo then
            -- 强化材料
            local needIdArray = self:getItemIdArray(nextSiteStrengthInfo)
            local needIdSizeArray = self:getItemSizeArray(nextSiteStrengthInfo)
            local ownIdSizeArray = {}

            for i = 1, #needIdArray do
                local id = needIdArray[i]
                local ownCount = lt.DataManager:getItemCount(id)

                ownIdSizeArray[#ownIdSizeArray + 1] = ownCount

            end

            for i = 1, #ownIdSizeArray do
                if ownIdSizeArray[i] < needIdSizeArray[i] then
                    currentTable[position] = 0
                end
            end
        else
            currentTable[position] = 0
        end

    end

    -- if playerLevel >= 55 then
    --     if totalLevel < 150 then
    --         return true
    --     end
    -- elseif playerLevel >= 50 then
    --     if totalLevel < 100 then
    --         return true
    --     end
    -- elseif playerLevel >= 45 then
    --     if totalLevel < 75 then
    --         return true
    --     end
    -- elseif playerLevel >= 40 then
    --     if totalLevel < 60 then
    --         return true
    --     end
    -- elseif playerLevel >= 10 then
    --     if totalLevel < 50 then
    --         return true
    --     end
    -- end

    local flag = false
    for i,v in ipairs(currentTable) do
        if v > 0 then
            flag = true
        end
    end

    return flag
end

-- 天赋升级
function NewFlagManager:canUpgradeTalentSkill()
    return self._talentSkillFlag
end

function NewFlagManager:checkTalentSkill()
    local playerLevel = lt.DataManager:getPlayerLevel()

    if playerLevel < 20 then
        return
    end

    local talentTable = lt.CacheManager:getHeroTalentTable()

    local currentPoint = lt.DataManager:getTalentCount()

    local flag = false

    for id,talentInfo in pairs(talentTable) do
        
        local occupationId = talentInfo:getOccupation()
        if occupationId == lt.DataManager:getOccupation() then
            local level = talentInfo:getLevel()
            local cost = talentInfo:getCost()
            local requireCost = talentInfo:getRequireCost()
            local totalLevel = talentInfo:getTotalLevel()
            local perIndex = talentInfo:getSkillIndex()
            local id = talentInfo:getId()
            local preId = talentInfo:getPreId()
            local needLevel = talentInfo:getSkillLevel()
            local currentLevel = lt.DataManager:getCurrentTalentLevel(id)
            local costTalentPoint = 0 
            local talentPageTable = lt.DataManager:getTalentPageListTable()

            if talentPageTable and talentPageTable[lt.DataManager:getCurrentTalentPage()] then
                currentTalentPageInfo = talentPageTable[lt.DataManager:getCurrentTalentPage()]
                costTalentPoint = currentTalentPageInfo:getCostTalent()
            end
            if playerLevel > level and currentLevel < totalLevel and requireCost <= costTalentPoint then
                if preId > 0 then
                    local preLevel = lt.DataManager:getCurrentTalentLevel(preId)

                    if preLevel >= needLevel then

                        if currentPoint >= cost then
                            flag = true
                            break
                        end

                    end
                else

                    if currentPoint >= cost then
                        flag = true
                        break
                    end
                end
            end
        end

    end


    return flag

end

-- 技能升级
function NewFlagManager:canUpgradeSkill()
    return self._skillNew
end

function NewFlagManager:checkUpgradeSkill()
    if not lt.DataManager:isSkillFuncOpen() then
        return false
    end

    for i=1,4 do
        if self:checkUpgradeSkillByIdx(i) then
            return true
        end
    end

    return false
end

function NewFlagManager:checkUpgradeSkillByIdx(idx)
    local player = lt.DataManager:getPlayer()
    if not player then
        return false
    end

    local hero = lt.DataManager:getHero()
    if not hero then
        return false
    end

    local occupationId = player:getOccupationId()
    local skillIndexArray = lt.DataManager:getNewSkillHeroTable()
    local skillHeroInfo = skillIndexArray[idx]

    if not skillHeroInfo then
        return false
    end

    local skillIndex = skillHeroInfo:getIndex()
    local skillId = skillHeroInfo:getSkillId()

    local skillInfo = lt.CacheManager:getSkillHeroInfo(skillId)
    if not skillInfo then
        return false
    end

    local nextSkillInfo = lt.CacheManager:getSkillHeroInfoByLevel(skillId, skillInfo:getLevel()+1)
    if nextSkillInfo then
        if player:getCoin() >= nextSkillInfo:getCost() and player:getLevel() >= nextSkillInfo:getLevelRequire() then
            return true
        end
    end

    return false
end

-- 时装
function NewFlagManager:canUpgradeDressAddition()
    local playerDressAddition = lt.DataManager:getDressAddition()
    if not playerDressAddition then
        return false
    end

    local level = playerDressAddition:getLevel()
    local totalExp = 0
    local preDressAddition = lt.CacheManager:getDressAddition(level-1)
    if preDressAddition then
        totalExp = preDressAddition:getTotalExp()
    end

    local dressAddition = lt.CacheManager:getDressAddition(level)
    if not dressAddition then
        return false
    end

    local curExp = playerDressAddition:getValue() - totalExp
    if curExp >= dressAddition:getExp() then
        return true
    end

    return false
end

-- 公会事件
function NewFlagManager:hasGuildEvent()
    return self:hasGuildApply() or self:hasGuildAnnex()
end

function NewFlagManager:hasGuildApply()

    local guildId = lt.DataManager:getGuildId()
    if guildId == 0 then
        return false
    end

    local guildRequestTable = lt.DataManager:getGuildRequestTable()
    if not guildRequestTable then
        return false
    end
    local count = 0
    for _,guildRequest in pairs(guildRequestTable) do
        count = count + 1
    end
    if count == 0 then
        return false
    end
    local member = lt.DataManager:getMember(lt.DataManager:getPlayerId())
    local guildInfo = lt.DataManager:getPlayerGuild()
    if member and guildInfo then
        local authArray = guildInfo:getAuthArray(member:getOfficeLevel())
        if authArray then
            if authArray[lt.Constants.GUILD_AUTH_ID.JOIN] == 1 then
                return true
            end
        end
    end
    return false
end

function NewFlagManager:hasGuildAnnex()

    local guildId = lt.DataManager:getGuildId()
    if guildId == 0 then
        return false
    end

    local guildAnnexable = lt.DataManager:getGuildAnnexTable()
    if not guildAnnexable then
        return false
    end
    local count = 0
    for _,guildRequest in pairs(guildAnnexable) do
        count = count + 1
    end
    if count == 0 then
        return false
    end
    local member = lt.DataManager:getMember(lt.DataManager:getPlayerId())
    local guildInfo = lt.DataManager:getPlayerGuild()
    if member and guildInfo then
        local authArray = guildInfo:getAuthArray(member:getOfficeLevel())
        if authArray then
            if authArray[lt.Constants.GUILD_AUTH_ID.MERGE] == 1 then
                return true
            end
        end
    end
    return false
end

--月卡可领取
function NewFlagManager:hasMonthCardReceive()
    return self._monthCardNew
end

function NewFlagManager:checkMonthCardReceive()
    local player = lt.DataManager:getPlayer()
    if not player then
        return
    end

    local cardFlag = false

    local yearCardFlag = player:getYearCardFlag()

    if yearCardFlag == 1 then --有年卡时候

        local info = lt.DataManager:getCardReceiveLogInfo(0)

        if info then
            local flag = info:getFlag()

            if flag == 0 then
                cardFlag = true
            end
        end
    end

    local time = 0
    local info = lt.DataManager:getCardLogValidTime(1)

    if info then
        time = info:getValidTime()
    end

    local currentTime = lt.CommonUtil:getCurrentTime()


    if time > currentTime then
        local info = lt.DataManager:getCardReceiveLogInfo(1)

        if info then
            local flag = info:getFlag()

            if flag == 0 then
                cardFlag = true
            end
        end
    end

    return cardFlag

end

--成长任务奖励可领取
function NewFlagManager:setGrowTaskUpdate(growTaskUpdate)
    self._growTaskUpdate = growTaskUpdate
end

function NewFlagManager:hasGrowTaskReward()
    return self._growTaskFlag
end

function NewFlagManager:checkGrowTaskReward()
    if not self._growTaskUpdate then
        return self._growTaskFlag
    end
    self._growTaskUpdate = false

    local table = lt.DataManager:getDeleteActivityInfoTable()

    if table[lt.Constants.ACTIVITY_ID.GROW_TASK] and table[lt.Constants.ACTIVITY_ID.GROW_TASK] == 2 then
        return false
    end

    local taskTable = lt.DataManager:getNewbieTaskTable()

    for _,taskInfo in pairs(taskTable) do
        local isDone    = taskInfo:getIsDone()
        local isReceive = taskInfo:getIsReceive()

        if isDone == 1 and isReceive == 0 then
            return true
        end
    end

    for i = 1, 7 do
        if lt.DataManager:getGrowTaskTable(i) then
            return true
        end
    end

    return false
end

--冲级奖励
function NewFlagManager:hasLevelingReward()
    return self._levelingReward
end

function NewFlagManager:checkLevelingReward()

    if not lt.DataManager:checkActivityOpen(lt.Constants.ACTIVITY_ID.LEVELING_REWARD) then
        return
    end

    local table = lt.DataManager:getDeleteActivityInfoTable()


    if table[lt.Constants.ACTIVITY_ID.LEVELING_REWARD] and table[lt.Constants.ACTIVITY_ID.LEVELING_REWARD] == 2 then
        return false
    end

    local levelingTable = lt.CacheManager:getLevelingRewardTable()

    local levelTable = lt.DataManager:getPromoteRewardList()



    local numTable = lt.DataManager:getPromoteRewardReceiveTimesTable()


    for _,rewardInfo in pairs(levelingTable) do
        local level = rewardInfo:getLevel()
        local allNum = rewardInfo:getReceiveTimes()
        
        local realInfo = levelTable[level]

        if realInfo then
            local isreceive = realInfo:getIsReceive()

            if isreceive == 1 then
                local receiveNum = 0
                if numTable[level] then
                    receiveNum = numTable[level]
                end

                local num = allNum - receiveNum

                if num > 0 then
                    return true
                end
            end
        end
    end

    return false
    
end

--战力达人
function NewFlagManager:hasFightingReward()
    return self._fightingReward
end

function NewFlagManager:checkFightingReward()
    local player = lt.DataManager:getPlayer()
    local hero = lt.DataManager:getHero()

    if lt.DataManager:getBattlePointRewardFlag() == 1 then
        return
    end

    if not player or not hero then
        return
    end

    local fightPower = hero:getFightPower()

    local fightRewardTable = lt.CacheManager:getFightRewardTable()

    local rewardTable = lt.DataManager:getBattlePointRewardTable()

    local numTable = lt.DataManager:getBattlePointRewardReceiveTable()

    for fightNum,rewardInfo in pairs(fightRewardTable) do
        local id = rewardInfo:getId()
        local allNum = rewardInfo:getReceiveTimes()
        if fightPower >= fightNum then
            if rewardTable[id] then
                local isreceive = rewardTable[id]:getIsReceive()
                if isreceive == 1 then
                    return true
                end
            else
                local receiveNum = 0
                if numTable[id] then
                    receiveNum = numTable[id]
                end
                
                local leaveNum = allNum - receiveNum
                if leaveNum > 0 then
                    return true
                end
            end
        end

    end

    return false

end

--符文可镶嵌
function NewFlagManager:hasRuneEquip()
    local player = lt.DataManager:getPlayer()
    if not player then return end

    local playerLevel = player:getLevel()

    if playerLevel < lt.Constants.RUNE_LEVEL then
        return false
    end

    local page = lt.DataManager:getPlayer():getCurrentRunePage()
    local runeListTable = lt.DataManager:getRuneListTableByPage(page)

    if not runeListTable then
        return false
    end

    for k,v in pairs(runeListTable) do
        local modelId = v:getModelId()

        if modelId == 0 then
            return true
        end

    end

    return false
end
--可推荐的野外boss
function NewFlagManager:hasMonsterPurificationField()
    local monsterPurificationArray = lt.DataManager:getMonsterPurificationFieldTable()
    if not monsterPurificationArray then
        return false
    end
    local playerLevel = lt.DataManager:getPlayerLevel()
    for k,v in pairs(monsterPurificationArray) do
        if playerLevel >= v:getLocalWorldMapLevel() and v:getMonsterLevel() > playerLevel - 20 then--有可以推荐的野外boss
            if v:getFinishTime() ~= 0 then--0表示没有怪物被击杀或者还未刷出  1表示怪物正在进行中
                return true
            end
        end
    end
    return false
end

--次日礼包 可领取或者 可摸头 _morrowGiftPackage
function NewFlagManager:getMorrowGiftPackage()
    return self._morrowGiftPackage
end

function NewFlagManager:hasMorrowGiftPackage()
    local morrowRewardTable = lt.DataManager:getMorrowRewardTable()
    
    local isOpen = morrowRewardTable.is_open
    local receiveTime = morrowRewardTable.receive_time
    local fondleCount = morrowRewardTable.fondle_count
    local nextFondleTime = morrowRewardTable.next_fondle_time
    local receiveState = morrowRewardTable.receive_state
    receiveState = receiveState or 0

    if not isOpen or isOpen == 0 then
        return false
    end

    if receiveState ~= 0 then
        return false
    end

    local currentTime = lt.CommonUtil:getCurrentTime()

    if nextFondleTime <= currentTime and fondleCount < 2 then
        return true
    end
    if receiveTime <= currentTime then
        return true
    end
    return false
end

--新服 红包可领取
function NewFlagManager:getNewSerViceRedPackage()
    return self._newServiceRedPackage
end

function NewFlagManager:hasNewSerViceRedPackage()

    if lt.DataManager:getPaperBagTable().is_closed ~= 0 then-- 0 开启 1 关闭
        return false
    end

    local currentDay = lt.DataManager:getPaperBagTable().cur_day_index--当前是开服第几天
    if currentDay < 7 then 
        return false
    elseif currentDay >= 7 and currentDay < 13 then--第一波可领
        local info1 = lt.DataManager:getPaperBagTable().data_array[6]
        if info1.received == 1 then --0 未 1已领      
            return false
        end
        return true
    else
        local info1 = lt.DataManager:getPaperBagTable().data_array[6]
        local info2 = lt.DataManager:getPaperBagTable().data_array[12]

        if info1 and info1.received == 1 and info2 and info2.received == 1 then --0 未 1已领
            return false
        end 
        return true
    end
end

--公会福利红点
function NewFlagManager:getGuildWelfare()
    return self._guildWelfare
end

function NewFlagManager:hasGuildWelfare()
    local guildId = lt.DataManager:getGuildId()
    if guildId == 0 then
        return false
    end

    local welfareArray = lt.CacheManager:getGuildWelfareTable()
    local notice = false
    for k,info in pairs(welfareArray) do
        notice = false
        local type = info:getId()
        local activityInfo = lt.CacheManager:getActivityInfo(type)
        if activityInfo then
            local playerLevel = lt.DataManager:getPlayerLevel()
            local levelMin = activityInfo:getOpenLevelMin()
            if lt.DataManager:getPlayerLevel() >= activityInfo:getOpenLevelMin() then
                local openTime = activityInfo:getDailyOpenTime()
                local endTime = activityInfo:getDailyCloseTime()
                local curWeek = lt.CommonUtil:getCurrentWeekDay()
                local tm = lt.CommonUtil:getTM()
                local currentTime = lt.CommonUtil:getCurrentTime()
                local isWeekSame = false

                for k,week in pairs(activityInfo:getOpenWeekDay()) do
                    if week == curWeek then
                        isWeekSame = true
                        break
                    end
                end

                if isWeekSame == true then
                    local openTm = clone(tm)
                    openTm.hour = openTime.hour
                    openTm.min  = openTime.min
                    openTm.sec  = 0
                    local openTimestamp = lt.CommonUtil:getOSTime(openTm)

                    local endTm = clone(tm)
                    endTm.hour = endTime.hour
                    endTm.min  = endTime.min
                    endTm.sec  = 0
                    local endTimestamp = lt.CommonUtil:getOSTime(endTm)

                    if currentTime >= openTimestamp and currentTime < endTimestamp then
                        notice = true
                    else
                        notice = false
                    end               
                end
            end

            if notice == true then--等级 时间检测通过
                if type == lt.Constants.ACTIVITY.GUILD_BUILD then--公会建设
                    local activityTask = lt.DataManager:getActivityGuildBuildTask()
                    if activityTask then--已接受公会建设任务activityTask:getExistFlag()
                        if activityTask:getCurCount() >= activityInfo:getExecLimit() then
                            notice = false
                        end
                    end
                elseif type == lt.Constants.ACTIVITY.GUILD_FAM then--公会秘境
                    local taskInfo =  lt.DataManager:getActivityGuildFam()
                    if taskInfo then
                        if taskInfo:getAllCount() >= activityInfo:getExecLimit() then
                            notice = false
                        end
                    end
                elseif type == lt.Constants.ACTIVITY.GUILD_BOSS then--公会boss 
                    local bossList = lt.DataManager:getActivityGuildBossList()
                    local allKilled = true
                    for k,boss in pairs(bossList) do
                        if boss.killed ~= 1 then--有没有被击杀的boss
                            allKilled = false
                            break
                        end
                    end

                    if allKilled == true then
                        notice = false
                    end
                elseif type == lt.Constants.ACTIVITY.MONSTER_ATTACK then--怪物侵袭
                    if not lt.DataManager:hasMonsterAttack() then
                        notice = false
                    end

                elseif type == lt.Constants.ACTIVITY.GUILD_HAPPY then--公会狂欢

                    local openTable = lt.DataManager:getActivityFlushTimeTable()

                    local guildHappyOpendInfo = openTable[lt.Constants.ACTIVITY.GUILD_HAPPY]
                    notice = false
                    if guildHappyOpendInfo then
                        local isOpenDay = guildHappyOpendInfo:isOpenDay()
                        local finishTime = guildHappyOpendInfo:getFinishTime()

                        if isOpenDay and finishTime > 0 and lt.DataManager:getHasJoinGuildPartyValue() < 1 then
                            notice = true
                        end
                    end
                end
            end
        end
        if notice == true then
            break
        end
    end
    return notice
end

--宝石达人小红点
function NewFlagManager:hasIntelligentGem()
    local player = lt.DataManager:getPlayer()
    local hero = lt.DataManager:getHero()

    if lt.DataManager:getStoneRewardIsFinished() == 1 then
        return
    end

    if not player or not hero then
        return
    end

    local currentLevel = lt.DataManager:getCurrentGemLevel()

    local intelligentGemTable = lt.CacheManager:getIntelligentGemTable()

    local rewardTable = lt.DataManager:getStoneRewardLogListTable()

    local numTable = lt.DataManager:getStoneReceiveTimesInfo()

    for id,rewardInfo in pairs(intelligentGemTable) do
        local id = rewardInfo:getId()
        local allNum = rewardInfo:getReceiveTimes()
        local level = rewardInfo:getLevel()
        if currentLevel >= level then
            if rewardTable[id] then
                local isreceive = rewardTable[id]:getIsReceive()
                if isreceive == 1 then
                    return true
                end
            else
                local receiveNum = 0 
                if numTable then
                    receiveNum = numTable:getRewardById(id)
                end
                
                local leaveNum = allNum - receiveNum
                if leaveNum > 0 then
                    return true
                end
            end
        end

    end

    return false
end

--英灵达人小红点
function NewFlagManager:hasIntelligentServant()
    local player = lt.DataManager:getPlayer()
    local hero = lt.DataManager:getHero()

    if lt.DataManager:getServantRewardIsFinished() == 1 then
        return
    end

    if not player or not hero then
        return
    end

    local currentPower = lt.DataManager:getPlayer():getHero():getServantBattlePoint()

    local intelligentServantTable = lt.CacheManager:getIntelligentServantTable()

    local rewardTable = lt.DataManager:getServantRewardLogListTable()

    local numTable = lt.DataManager:getServantReceiveTimesInfo()


    for id,rewardInfo in pairs(intelligentServantTable) do
        local id = rewardInfo:getId()
        local allNum = rewardInfo:getReceiveTimes()
        local fightPower = rewardInfo:getNeedFight()



        if currentPower >= fightPower then
            if rewardTable[id] then
                local isreceive = rewardTable[id]:getIsReceive()
                if isreceive == 1 then
                    return true
                end
            else
                local receiveNum = 0 
                if numTable then
                    receiveNum = numTable:getRewardById(id)
                end

                
                local leaveNum = allNum - receiveNum
                if leaveNum > 0 then
                    return true
                end
            end
        end

    end

    return false
end

--生活达人小红点
function NewFlagManager:hasIntelligentLife()
    local player = lt.DataManager:getPlayer()
    local hero = lt.DataManager:getHero()

    if lt.DataManager:getLifeRewardIsFinished() == 1 then
        return
    end

    if not player or not hero then
        return
    end

    local currentLevel = lt.DataManager:getCurrentLifeSkillLevel()

    local intelligentLifeTable = lt.CacheManager:getIntelligentLifeTable()

    local rewardTable = lt.DataManager:getLifeRewardLogListTable()

    local numTable = lt.DataManager:getLifeReceiveTimesInfo()

    for id,rewardInfo in pairs(intelligentLifeTable) do
        local id = rewardInfo:getId()
        local allNum = rewardInfo:getReceiveTimes()
        local level = rewardInfo:getLevel()
        if currentLevel >= level then
            if rewardTable[id] then
                local isreceive = rewardTable[id]:getIsReceive()
                if isreceive == 1 then
                    return true
                end
            else
                local receiveNum = 0 
                if numTable then
                    receiveNum = numTable:getRewardById(id)
                end
                
                local leaveNum = allNum - receiveNum
                if leaveNum > 0 then
                    return true
                end
            end
        end

    end

    return false
end

function NewFlagManager:getIntelligentGem()
    return self._intelligentGem
end

function NewFlagManager:getIntelligentServant()
    return self._intelligentServant
end

function NewFlagManager:getIntelligentLife()
    return self._intelligentLife
end

function NewFlagManager:getIntelligentStrength()
    return self._intelligentStrength
end

function NewFlagManager:getIntelligentNew()
    return self._intelligentGem or self._intelligentServant or self._intelligentLife or self._intelligentStrength
end

--强化达人小红点
function NewFlagManager:hasIntelligentStrength()
    local player = lt.DataManager:getPlayer()
    local hero = lt.DataManager:getHero()

    if lt.DataManager:getStrengthRewardIsFinished() == 1 then
        return
    end

    if not player or not hero then
        return
    end

    local currentLevel = lt.DataManager:getCurrentSiteStrengthlLevel()

    local intelligentStrengthTable = lt.CacheManager:getIntelligentStrengthTable()

    local rewardTable = lt.DataManager:getStrengthRewardLogListTable()

    local numTable = lt.DataManager:getStrengthReceiveTimesInfo()

    for id,rewardInfo in pairs(intelligentStrengthTable) do
        local id = rewardInfo:getId()
        local allNum = rewardInfo:getReceiveTimes()
        local level = rewardInfo:getLevel()
        if currentLevel >= level then
            if rewardTable[id] then
                local isreceive = rewardTable[id]:getIsReceive()
                if isreceive == 1 then
                    return true
                end
            else
                local receiveNum = 0 
                if numTable then
                    receiveNum = numTable:getRewardById(id)
                end
                
                local leaveNum = allNum - receiveNum
                if leaveNum > 0 then
                    return true
                end
            end
        end

    end

    return false
end

--小队活跃奖励小红点
function NewFlagManager:getNewRiskActiveRewardFlag()
    return self._riskActiveRewardFlag
end

function NewFlagManager:hasNewRiskActiveRewardFlag()

    local riskTeam = lt.DataManager:getRiskTeam()

    if not riskTeam then
        return false
    end

    local rewardInfoTable =  lt.CacheManager:getRiskTeamActiveRewardInfoTable()
    local collectiveActive = lt.DataManager:getCollectiveActiveTable()

    for k,info in pairs(rewardInfoTable) do
        local state = collectiveActive[info:getId()] or 0--value:0 不可领取 1：可领取  2：已领取
        if state == 1 then
            return true
        end
    end    
    return false
end

--称号小红点
function NewFlagManager:hasNewTitle()
    local allNotice = lt.PreferenceManager:getPlayerTitleNotice()

    for k,v in pairs(allNotice) do
        if v then
            return true
        end
    end
    return false
end

function NewFlagManager:configPlayerTitle()--整理title
--称号小红点
--[[
获取所有已拥有的title -》 然后跟本地储存的数据比较 筛选出最新的new -》本地储存当前时刻已拥有的title  
]]--
    local titleTable = lt.DataManager:getAllTitleTable()

    local preferenceTitleTable = lt.PreferenceManager:getPlayerTitleTable()

    if preferenceTitleTable == nil  then-- {}--第一次 将数据保存到本地
        local firstInitData = {}
        for titleID,info in pairs(titleTable) do
            if info then
                local tempInfo = {}
                tempInfo["name"] = info.name
                tempInfo["expireTime"] = info.expireTime
                firstInitData[tostring(titleID)] = tempInfo--储存当前时刻已拥有的title
            end
        end
        lt.PreferenceManager:resetPlayerTitle(firstInitData)--重设
        preferenceTitleTable = firstInitData
    end

    local isResetPreferData = false

    local tempTitleTable = {}
    local currentID = {}
    for titleID,info in pairs(titleTable) do
        if info then
            local tempInfo = {}
            tempInfo["name"] = info.name
            tempInfo["expireTime"] = info.expireTime
            tempTitleTable[tostring(titleID)] = tempInfo--储存当前时刻已拥有的title
            currentID[tostring(titleID)] = 1
            local temp = preferenceTitleTable[tostring(titleID)]
            if temp then--该title已经有了
                if info.name ~= temp.name then--更新了
                    lt.GameEventManager:post(lt.GameEventManager.EVENT.PLAYER_TITLE)

                    local equipTitle = lt.DataManager:getEquipTitle()

                    if equipTitle and equipTitle.titleId == titleID then
                        lt.SocketApi:equipTitle(titleID, info.name)
                    end

                    if titleID == lt.Constants.PLAYER_TITLE_TYPE.GUILD_TITLE then--这个需要清除公会聊天记录
                        lt.DataManager:clearChatGuildTable()
                    end

                    isResetPreferData = true
                end
            else
                lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_PLAYER_INFO_24")..info.name)
                lt.PreferenceManager:setPlayerTitleNotice(titleID, true)
                isResetPreferData = true
            end
        end
    end

    for titleID,info in pairs(preferenceTitleTable) do
        if not currentID[titleID] then
            if titleID == tostring(lt.Constants.PLAYER_TITLE_TYPE.GUILD_TITLE) then--这个需要清除公会聊天记录
                lt.DataManager:clearChatGuildTable()
            end

            lt.NoticeManager:addMessage(info.name..lt.StringManager:getString("STRING_PLAYER_INFO_25"))
            lt.PreferenceManager:setPlayerTitleNotice(titleID, false)--取消new
            lt.GameEventManager:post(lt.GameEventManager.EVENT.PLAYER_TITLE)
            isResetPreferData = true
        end
    end
    if isResetPreferData then
        lt.PreferenceManager:resetPlayerTitle(tempTitleTable)--重设
    end
end

--首冲累冲
function NewFlagManager:getFirstRechargeFlag()
    return self._firstRechargeFlag
end

function NewFlagManager:hasFirstRechargeFlag()
    local rechargeLogTable = lt.DataManager:getRechargeLogTable()
    --rechargeLogTable.firstRechargeReceiveFlag = 1
    if rechargeLogTable.finishFlag then  --//0:未结束 1：结束保留界面  2：结束删除界面
        if rechargeLogTable.finishFlag ~= 2 then
            if rechargeLogTable.firstRechargeFlag == 1 and rechargeLogTable.firstRechargeReceiveFlag == 0 then--首冲 已充值  未领取并且
                return true
            end

            if rechargeLogTable.firstRechargeReceiveFlag ~= 0 then --首冲已领取
                local rechargeReceiveLog = lt.DataManager:getRechargeLogTable().accumulateRechargeReceiveArray--累冲所有领取情况
                local currentId = lt.DataManager:getRechargeLogTable().accumulateRechargeRewardId--当前达到的id

                for id,receiveLog in pairs(rechargeReceiveLog) do-- receiveLog 0 未领取 1 已领取
                    if id <= currentId then
                        if receiveLog == 0 then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

--成长基金
function NewFlagManager:getGrowFundFlag()
    return self._growFundFlag
end

function NewFlagManager:hasGrowFundFlag()
    local receiveStateTable = lt.DataManager:getGrowUpFundInfo().receiveStateTable or {}
    for id,info in pairs(receiveStateTable) do
        for k,state in pairs(info) do--0:不可领取 1：可领取 2 已领取 
            if state == 1 then
                return true
            end
        end
    end

    return false
end

--特惠礼包
function NewFlagManager:getSpecialGiftBagFlag()
    return self._specialGiftBagFlag
end

function NewFlagManager:hasSpecialGiftBag()
    local currentTime = lt.CommonUtil:getCurrentTime()
    for k,info in pairs(lt.DataManager:getSpecialGiftPackDataList()) do
        if info.createTime + 86400 > currentTime and info.status == 0 then
            return true
        end
    end

    return false
end

-- 微信红包
function NewFlagManager:getWechatActivity()
    return self._wechatActivityFlag
end

function NewFlagManager:checkWechatActivity()
    return math.max(self:getWechatAccumulateLogin(), self:getWechatFirstCharge(), self:getWechatHappyTogether(), self:getWechatPower())
end

-- 微信红包-累积登陆(0 关闭 1 开启 2 有奖励)
function NewFlagManager:getWechatAccumulateLogin()
    return self._wechatAccumulateLoginFlag
end

function NewFlagManager:checkWechatAccumulateLogin()
    local valid, batchActivity = lt.DataManager:isBatchActivityValidAccumulateLogin()
    if not valid then
        return 0
    end

    local playerLevel = lt.DataManager:getPlayerLevel()
    local currentDay = lt.DataManager:getActivityAccumulateLoginCount()
    local mstActivityAccumulateLoginArray = lt.DataManager:getMstActivityAccumulateLoginArray()
    for _,mstActivityAccumulateLogin in ipairs(mstActivityAccumulateLoginArray) do
        -- 判断是否已经领取
        local rewardId = mstActivityAccumulateLogin:getId()
        local activityRewardLog = lt.DataManager:getActivityRewardLog(lt.Constants.BATCH_ACTIVITY_ID.ACCUMULATE_LOGIN, rewardId)
        if not activityRewardLog then
            -- 尚未领取
            local targetLevel = mstActivityAccumulateLogin:getLevel()
            local targetDay  = mstActivityAccumulateLogin:getDays()

            if playerLevel >= targetLevel and currentDay >= targetDay then
                return 2
            end
        end
    end

    return 1
end

-- 微信红包-首充红包
function NewFlagManager:getWechatFirstCharge()
    return self._wechatFirstChargeFlag
end

function NewFlagManager:checkWechatFirstCharge()
    local valid, batchActivity = lt.DataManager:isBatchActivityValidFirstCharge()
    if not valid then
        return 0
    end

    local startTime = batchActivity:getStartTime()
    local endTime   = batchActivity:getEndTime()
    local currentDay = lt.DataManager:getActivityFirstChargeLoginCount()
    local mstActivityFirstChargeArray = lt.DataManager:getMstActivityFirstChargeArray()
    local hasCharge = false
    for _,mstActivityFirstCharge in ipairs(mstActivityFirstChargeArray) do
        -- 判断是否已经领取
        local rewardId = mstActivityFirstCharge:getId()
        local activityRewardLog = lt.DataManager:getActivityRewardLog(lt.Constants.BATCH_ACTIVITY_ID.FIRST_CHARGE, rewardId)
        if not activityRewardLog then
            -- 尚未领取
            local targetDay = mstActivityFirstCharge:getDays()
            local amount = mstActivityFirstCharge:getAmount()
            if currentDay >= targetDay and lt.DataManager:overChargeOrder(amount, startTime, endTime) then
                -- 已经充值
                return 2
            end
        else
            hasCharge = true
        end
    end

    if batchActivity and batchActivity:isEnd() and not hasCharge then
        -- 活动结束没充值 就不显示
        return 0
    else
        return 1
    end
end

-- 微信红包-一起来嗨
function NewFlagManager:getWechatHappyTogether()
    return self._wechatHappyTogetherFlag
end

function NewFlagManager:checkWechatHappyTogether()
    local valid, batchActivity = lt.DataManager:isBatchActivityValidHappyTogether()
    if not valid then
        return 0
    end

    local mstActivityHappyTogether = lt.DataManager:getFirstMstActivityHappyTogether()
    if not mstActivityHappyTogether then
        return 1
    end

    -- 判断是否已经领取
    local startTime = batchActivity:getStartTime()
    local endTime   = batchActivity:getEndTime()
    local rewardId = mstActivityHappyTogether:getId()
    local activityRewardLog = lt.DataManager:getActivityRewardLog(lt.Constants.BATCH_ACTIVITY_ID.HAPPY_TOGETHER, rewardId)
    if not activityRewardLog then
        -- 尚未领取
        local amount = mstActivityHappyTogether:getAmount()
        if lt.DataManager:hasChargeOrder(amount, startTime, endTime) then
            -- 已经充值
            return 2
        end
    end

    return 1
end

-- 微信红包-战力红包
function NewFlagManager:getWechatPower()
    return self._wechatPowerFlag
end

function NewFlagManager:checkWechatPower()
    local valid, batchActivity = lt.DataManager:isBatchActivityValidPower()
    if not valid then
        return 0
    end

    local startTime = batchActivity:getStartTime()
    local endTime   = batchActivity:getEndTime()
    local currentPower = lt.DataManager:getHero():getFightPower()
    local mstActivityPowerArray = lt.DataManager:getMstActivityPowerArray()
    for amount,mstActivityPowerArray2 in pairs(mstActivityPowerArray) do
        if lt.DataManager:hasChargeOrder(amount, startTime, endTime) then
            -- 存在这个金额的充值
            for _,mstActivityPower in ipairs(mstActivityPowerArray2) do
                local rewardId = mstActivityPower:getId()
                local activityRewardLog = lt.DataManager:getActivityRewardLog(lt.Constants.BATCH_ACTIVITY_ID.POWER, rewardId)
                if not activityRewardLog then
                    -- 尚未领取
                    local targetPower  = mstActivityPower:getPower()
                    if currentPower >= targetPower then
                        return 2
                    end
                end
            end
        end
    end

    return 1
end

-- 女皇的贡品 (0 关闭 1 开启 2 有奖励)
function NewFlagManager:getQueenTributeFlag()
    return self._queenTributeFlag
end

function NewFlagManager:checkQueenTribute()

    local valid, batchActivity = lt.DataManager:isBatchActivityValidQueenTribute()
    if not valid then
        return 0
    end

    local array = lt.DataManager:getQueenTributeRewardArray()
    local tributeRewardLog = lt.DataManager:getQueenTributeRewardLogInfo()
    local finishedCount = lt.DataManager:getQueenTributeSubmitCount()

    local queenTributeCircleInfo = lt.DataManager:getQueenTributeTable()

    for k,CircleInfo in pairs(queenTributeCircleInfo) do
        local currentItemCount = lt.DataManager:getItemCount(CircleInfo:getValue())
        if currentItemCount >= CircleInfo:getCount() and (not CircleInfo:getFinished() or CircleInfo:getFinished() ~= 1) then
            return 2
        end
    end

    for k,info in pairs(array) do
        if finishedCount >= info:getSubmitFrequency() and not tributeRewardLog[info:getId()] then
            return 2
        end
    end

    return 1
end 

-- 多买多送 (0 关闭 1 开启 2 有奖励)
function NewFlagManager:getMoreAndMoreFlag()
    return self._moreAndMoreFlag
end

function NewFlagManager:checkMoreAndMoreFlag()

    local valid, batchActivity = lt.DataManager:isBatchActivityValidMoreAndMore()
    if not valid then
        return 0
    end

    local currentInfo = lt.DataManager:getBatchActivityLogListTable()[lt.Constants.BATCH_ACTIVITY_ID.MORE_AND_MORE]

    local currentArray = currentInfo:getActivityRewardArray()
    local amount = currentInfo:getAmount() or 0

    for k,rewardInfo in pairs(currentArray) do
        if not currentInfo:getStateArray()[rewardInfo:getIndex()] or currentInfo:getStateArray()[rewardInfo:getIndex()] ~= 2 then
            if amount >= rewardInfo:getAmount() then
                --isReceive = 0
                return 2
            end
        end
    end
    return 1
end

-- 限时特惠礼包 (0 关闭 1 开启 2 有奖励)
function NewFlagManager:getSpecialFlag()
    return self._specialFlag
end

function NewFlagManager:checkSpecialFlag()

    local valid, batchActivity = lt.DataManager:isBatchActivityValidSpecialPacket()
    if not valid then
        return 0
    end

    return 1
end

-- 冒险者宝藏 (0 关闭 1 开启 2 有奖励)
function NewFlagManager:getAdventurerRewardFlag()
    return self._adventurerRewardFlag
end

function NewFlagManager:checkAdventurerRewardFlag()

    local valid, batchActivity = lt.DataManager:isBatchActivityValidAdventurer()
    if not valid then
        return 0
    end

    return 1
end

function NewFlagManager:checkOnlineRewardNew()
    local rewardInfo = lt.DataManager:getOnlineRewardInfo()

    local currentTargetTime = rewardInfo:getCurrentTargetTime()

    if not currentTargetTime then return end

    local currentTime = lt.CommonUtil:getCurrentTime()

    if currentTime > currentTargetTime then
        return true
    end

    return false
end

return NewFlagManager
