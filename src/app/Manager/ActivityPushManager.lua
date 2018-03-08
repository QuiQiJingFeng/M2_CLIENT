
--管理活动游戏内推送
local ActivityPushManager = {}

ActivityPushManager._treasure = false
ActivityPushManager._guard = false
ActivityPushManager._pk = false

ActivityPushManager._check = false
ActivityPushManager._checkIndex = 1
ActivityPushManager._checkActivityArray = {
    --武道场＞守卫遗迹＞魔王的宝藏＞大于公会秘境＞野外BOSS＞公会活动—怪物侵袭
    --武道场＞守卫遗迹＞魔王的宝藏＞公会秘境＞极限挑战＞公会BOSS＞疯博士实验室＞野外BOSS＞公会活动—怪物侵袭
    function(self)
        -- 魔王宝藏
        if not lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.TREASURE) then
            return false
        end

        
        if lt.DataManager:getTreasurePushFlag() then
        	return false
        end

		local treasure = self:checkTreasure()
  		if not treasure then
  			return false
  		end

        return true
    end,
    function(self)
        -- 守卫遗迹
        if not lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.GUARD) then
            return false
        end

        if lt.DataManager:getGuardPushFlag() then
        	return false
        end

        local guard = self:checkGuard()
  		if not guard then
  			return false
  		end

        return true
    end,
    function(self)
        -- pk
        if not lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.PK_3V3) then
            return false
        end

        if lt.DataManager:getPkPushFlag() then
            return false
        end

        local pk = self:checkPk()
        if not pk then
            return false
        end

        return true
    end,
    function(self)
        -- fieldBoss
        if not lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.FIELD_BOSS) then
            return false
        end

        if lt.DataManager:getFieldBossPushFlag() then
            return false
        end

        local fieldBoss = self:checkBoss()
        if not fieldBoss then
            return false
        end

        return true
    end,
    function(self)
        -- 怪物侵袭
        if not lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.MONSTER_ATTACK) then
            return false
        end

        if lt.DataManager:getMonsterAttackFlag() then
            return false
        end

        local flag = self:checkMonsterAttack()
        if not flag then
            return false
        end

        return true
    end,
    function(self)
        -- 世界boss
        if not lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.WORLD_BOSS) then
            return false
        end

        if lt.DataManager:getWorldBossFlag() then
            return false
        end

        local flag = self:checkWorldBoss()
        if not flag then
            return false
        end

        return true
    end,
    function(self)
        -- 公会boss
        if not lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.GUILD_BOSS) then
            return false
        end

        if lt.DataManager:getGuildBossFlag() then
            return false
        end

        local flag = self:checkGuildBoss()
        if not flag then
            return false
        end

        return true
    end,
    function(self)
        -- 疯狂博士
        if not lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.CRAZY_DOCTOR) then
            return false
        end

        if lt.DataManager:getCrazyDoctorFlag() then
            return false
        end

        local flag = self:checkCrazyDoctor()
        if not flag then
            return false
        end

        return true
    end,
    function(self)
        -- 公会秘境
        if not lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.GUILD_FAM) then
            return false
        end

        if lt.DataManager:getGuildFamFlag() then
            return false
        end

        local flag = self:checkGuildFam()
        if not flag then
            return false
        end

        return true
    end,
    function(self)
        -- 全名答题
        if not lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.ALL_QUESTION) then
            return false
        end

        if lt.DataManager:getQuestionFlag() then
            return false
        end

        local flag = self:checkQuestion()
        if not flag then
            return false
        end

        return true
    end,
}

function ActivityPushManager:init()
    local update = false

    for _,checkFunc in ipairs(self._checkActivityArray) do
        update = checkFunc(self) or update
    end


    if update then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.ACTIVITY_PUSH)
    end
end

function ActivityPushManager:clear()
    
end

ActivityPushManager._elapse =0
ActivityPushManager._interval = 3
function ActivityPushManager:onUpdate(delta)
    -- self:update()

    self._elapse = self._elapse + delta
    if self._elapse < self._interval then
        return
    end
    self._elapse = 0
    --武道场＞守卫遗迹＞魔王的宝藏＞公会秘境＞极限挑战＞全名答题>公会BOSS＞疯博士实验室＞野外BOSS＞公会活动—怪物侵袭
    local checkIndex = nil
    if not lt.DataManager:getPkPushFlag() then
        if lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.PK_3V3) then
            if self:checkPk() then
                
                lt.DataManager:setPkPushFlag(true)
                checkIndex = 3
            end
        end
    end
    if not lt.DataManager:getGuardPushFlag() then
        if lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.GUARD) then
            if self:checkGuard() then
                
                lt.DataManager:setGuardPushFlag(true)
                if not checkIndex then
                    checkIndex = 2
                end
            end
        end
    end
    if not lt.DataManager:getTreasurePushFlag() then
        if lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.TREASURE) then
            if self:checkTreasure() then
                
                lt.DataManager:setTreasurePushFlag(true)
                if not checkIndex then
                    checkIndex = 1
                end
            end
        end
    end

    if not lt.DataManager:getGuildFamFlag() then
        if lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.GUILD_FAM) then
            if self:checkGuildFam() then
                
                lt.DataManager:setGuildFamFlag(true)
                if not checkIndex then
                    checkIndex = 5
                end
            end
        end
    end

    if not lt.DataManager:getWorldBossFlag() then --极限挑战
        if lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.WORLD_BOSS) then
            if self:checkWorldBoss() then
                lt.DataManager:setWorldBossFlag(true)
                if not checkIndex then
                    checkIndex = 7
                end
            end
        end
    end

    if not lt.DataManager:getQuestionFlag() then --全名答题
        if lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.ALL_QUESTION) then
            if self:checkQuestion() then
                lt.DataManager:setQuestionFlag(true)
                if not checkIndex then
                    checkIndex = 10
                end
            end
        end
    end

    if not lt.DataManager:getGuildBossFlag() then --公会boss
        if lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.GUILD_BOSS) then
            if self:checkGuildBoss() then
                
                lt.DataManager:setGuildBossFlag(true)
                if not checkIndex then
                    checkIndex = 8
                end
            end
        end
    end

    if not lt.DataManager:getCrazyDoctorFlag() then --疯博士实验室
        if lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.CRAZY_DOCTOR) then
            if self:checkCrazyDoctor() then
                
                lt.DataManager:setCrazyDoctorFlag(true)
                if not checkIndex then
                    checkIndex = 9
                end
            end
        end
    end

    if not lt.DataManager:getFieldBossPushFlag() then
        if lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.FIELD_BOSS) then
            if self:checkBoss() then
                lt.DataManager:setFieldBossPushFlag(true)
                if not checkIndex then
                    checkIndex = 4
                end
            end
        end
    end

    if not lt.DataManager:getMonsterAttackFlag() then
        if lt.DataManager:getActivityPushSwitch(lt.Constants.ACTIVITY.MONSTER_ATTACK) then
            if self:checkMonsterAttack() then
                lt.DataManager:setMonsterAttackFlag(true)
                if not checkIndex then
                    checkIndex = 6
                end
            end
        end
    end

    if checkIndex then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.ACTIVITY_PUSH,{pushId = checkIndex})
    end
end

function ActivityPushManager:update()
    -- 2帧检查一次
    self._check = not self._check

    if not self._check then
        return
    end

    local checkFunc = self._checkActivityArray[self._checkIndex]
    if checkFunc then
        if checkFunc(self) then
            lt.GameEventManager:post(lt.GameEventManager.EVENT.ACTIVITY_PUSH,{pushId = self._checkIndex})
        end
    end

	self._checkIndex = self._checkIndex + 1
    if self._checkIndex > #self._checkActivityArray then
        self._checkIndex = 1
    end
end

function ActivityPushManager:checkTreasure()

	local activityOpenTable = lt.DataManager:getActivityOpenTable()

    local playerLevel = lt.DataManager:getPlayerLevel()

    local activityInfo = lt.CacheManager:getActivityInfo(lt.Constants.ACTIVITY.TREASURE)

    local levelMin = activityInfo:getOpenLevelMin()

    if playerLevel < levelMin then
        return false
    end

    local allExeclCount = activityInfo:getExecLimit()

    local taskInfo =  lt.DataManager:getActivityTreasureTask()

    local currentTimes = 0
    if taskInfo then

        currentTimes = taskInfo:getAllCount()

    end

    if currentTimes >= allExeclCount and allExeclCount ~= 0 then --已经完成的活动
        return false
    end


	local treasureFlag = activityOpenTable[lt.Constants.ACTIVITY.TREASURE] or 1

	if treasureFlag == 0 then
		return true
	end

	return false

end

function ActivityPushManager:checkGuard()

	local activityOpenTable = lt.DataManager:getActivityOpenTable()

    local activityInfo = lt.CacheManager:getActivityInfo(lt.Constants.ACTIVITY.GUARD)

    local playerLevel = lt.DataManager:getPlayerLevel()

    local levelMin = activityInfo:getOpenLevelMin()

    if playerLevel < levelMin then
        return false
    end

    local allExeclCount = activityInfo:getExecLimit()

    local taskInfo =  lt.DataManager:getActivityGuard()

    local currentTimes = 0
    if taskInfo then
        currentTimes = taskInfo:getAllCount()
    end

    if currentTimes >= allExeclCount and allExeclCount ~= 0 then --已经完成的活动
        return false
    end


	local guardFlag = activityOpenTable[lt.Constants.ACTIVITY.GUARD] or 1

	if guardFlag == 0 then
		return true
	end

	return false
end

function ActivityPushManager:checkPk()

    local activityInfo = lt.CacheManager:getActivityInfo(lt.Constants.ACTIVITY.PK_3V3)

    local playerLevel = lt.DataManager:getPlayerLevel()

    local levelMin = activityInfo:getOpenLevelMin()

    if playerLevel < levelMin then
        return false
    end

    local pkOpenInfo = lt.DataManager:getDaily3V3FlushTime()

    if not pkOpenInfo then
        return
    end

    local isOpenDay = pkOpenInfo:isOpenDay()
    local finishTime = pkOpenInfo:getFinishTime()

    if isOpenDay and finishTime > 0 then
        return true
    end

    return false
end

function ActivityPushManager:checkGuildFam()

    local guildId = lt.DataManager:getGuildId()

    if guildId <= 0 then
        return false
    end

    local activityOpenTable = lt.DataManager:getActivityOpenTable()

    local activityInfo = lt.CacheManager:getActivityInfo(lt.Constants.ACTIVITY.GUILD_FAM)

    local playerLevel = lt.DataManager:getPlayerLevel()

    local levelMin = activityInfo:getOpenLevelMin()

    if playerLevel < levelMin then
        return false
    end

    local allExeclCount = activityInfo:getExecLimit()

    local taskInfo =  lt.DataManager:getActivityGuildFam()

    local currentTimes = 0
    if taskInfo then
        currentTimes = taskInfo:getAllCount()
    end

    if currentTimes >= allExeclCount and allExeclCount ~= 0 then --已经完成的活动
        return false
    end


    local guildFlag = activityOpenTable[lt.Constants.ACTIVITY.GUILD_FAM] or 1

    if guildFlag == 0 then
        return true
    end

    return false
end

function ActivityPushManager:checkBoss()--野外boss

    local activityInfo = lt.CacheManager:getActivityInfo(lt.Constants.ACTIVITY.FIELD_BOSS)

    local playerLevel = lt.DataManager:getPlayerLevel()

    local levelMin = activityInfo:getOpenLevelMin()

    if playerLevel < levelMin then
        return false
    end

    local bossId = lt.DataManager:getCurrentFieldBossId()

    if not bossId then return false end

    local fieldBossInfo = lt.DataManager:getMonsterPurificationField(bossId)
    local level = fieldBossInfo:getMonsterLevel()

    local finishTime = fieldBossInfo:getFinishTime()
    
    if finishTime > 0 then
        return true
    end

    return false

end

function ActivityPushManager:checkMonsterAttack()

    local guildId = lt.DataManager:getGuildId()

    if guildId <= 0 then
        return false
    end

    local flag = lt.DataManager:hasMonsterAttack()
    
    return flag
end

function ActivityPushManager:checkQuestion()

    local activityOpenTable = lt.DataManager:getActivityOpenTable()

    local activityInfo = lt.CacheManager:getActivityInfo(lt.Constants.ACTIVITY.ALL_QUESTION)

    local playerLevel = lt.DataManager:getPlayerLevel()

    local levelMin = activityInfo:getOpenLevelMin()

    if playerLevel < levelMin then
        return false
    end


    local questionFlag = activityOpenTable[lt.Constants.ACTIVITY.ALL_QUESTION] or 1

    if questionFlag == 0 then
        return true
    end

    return false
end

function ActivityPushManager:checkWorldBoss()

    local activityOpenTable = lt.DataManager:getActivityOpenTable()

    local activityInfo = lt.CacheManager:getActivityInfo(lt.Constants.ACTIVITY.WORLD_BOSS)

    local playerLevel = lt.DataManager:getPlayerLevel()

    local levelMin = activityInfo:getOpenLevelMin()

    if playerLevel < levelMin then
        return false
    end

    local allExeclCount = activityInfo:getExecLimit()

    local taskInfo =  lt.DataManager:getActivityWorldBoss()

    local currentTimes = 0
    if taskInfo then
        currentTimes = taskInfo:getAllCount()
    end

    if currentTimes >= allExeclCount and allExeclCount ~= 0 then --已经完成的活动
        return false
    end

    local worldBossInfo = lt.DataManager:onGetActivityWorldBossInfo()

    local killedCount = 0
    if worldBossInfo then
        killedCount = worldBossInfo:getCurKilledCount()
    end

    if killedCount > 0 then
        return false
    end

    local worldBossFlag = activityOpenTable[lt.Constants.ACTIVITY.WORLD_BOSS] or 1

    if worldBossFlag == 0 then
        return true
    end

    return false
end

function ActivityPushManager:checkGuildBoss()

    local guildId = lt.DataManager:getGuildId()

    if guildId <= 0 then
        return false
    end

    local activityOpenTable = lt.DataManager:getActivityOpenTable()

    local activityInfo = lt.CacheManager:getActivityInfo(lt.Constants.ACTIVITY.GUILD_BOSS)

    local playerLevel = lt.DataManager:getPlayerLevel()

    local levelMin = activityInfo:getOpenLevelMin()

    if playerLevel < levelMin then
        return false
    end


    local guildBossList = lt.DataManager:getActivityGuildBossList()

    local killTime = 0
    for _,guildBossInfo in ipairs(guildBossList) do
        local killed = guildBossInfo.killed

        if killed == 1 then
            killTime = killTime + 1
        end

    end

    if killTime >= 3 then
        return false
    end


    local guildBossFlag = activityOpenTable[lt.Constants.ACTIVITY.GUILD_BOSS] or 1

    if guildBossFlag == 0 then
        return true
    end

    return false
end

function ActivityPushManager:checkCrazyDoctor()

    local activityOpenTable = lt.DataManager:getActivityOpenTable()

    local activityInfo = lt.CacheManager:getActivityInfo(lt.Constants.ACTIVITY.CRAZY_DOCTOR)

    local playerLevel = lt.DataManager:getPlayerLevel()

    local levelMin = activityInfo:getOpenLevelMin()

    if playerLevel < levelMin then
        return false
    end


    local crazyDoctorFlag = activityOpenTable[lt.Constants.ACTIVITY.CRAZY_DOCTOR] or 1

    if crazyDoctorFlag == 0 then
        return true
    end

    return false
end

return ActivityPushManager