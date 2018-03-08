
-- ################################################## 游戏内缓存数据 ##################################################
local DataManager = {}
DataManager._init = false
DataManager._flush = false

DataManager._maxServerIdx           = nil
DataManager._curServerId            = 0
DataManager._serverTable            = nil
DataManager._token                  = nil
DataManager._player                 = nil
DataManager._hero                   = nil
DataManager._skillHeroTable         = nil
DataManager._friendRequestTable     = nil
DataManager._friendRequestSendTable = nil
DataManager._friendTable            = nil
DataManager._guildEventTable        = nil
DataManager._guildAnnexTable        = nil
DataManager._guildActivityTable     = nil
DataManager._guildHouseEventTable   = nil
DataManager._guildTable             = nil
DataManager._guildImpeach           = nil
DataManager._guildItemDistributionTable  = nil
DataManager._guildMaterialTable     = nil
DataManager._guildMemberTable       = nil
DataManager._guildRequestTable      = nil
DataManager._guildResourceEquipmentTable = nil
DataManager._guildResourceItemTable = nil
DataManager._guildTaskTable         = nil
DataManager._guildTaskStatusTable   = nil
DataManager._guildBoomPoint         = 0 -- 公会繁荣度
DataManager._recentContactTable     = nil --最近联系人
DataManager._itemTable              = nil
DataManager._itemModelTable         = nil
DataManager._equipmentTable         = nil
DataManager._equipmentModelTable    = nil
DataManager._itemBuyCountTable      = nil
DataManager._servantTable           = nil
DataManager._otherPlayerServantTable = nil --其它玩家的英灵信息
DataManager._servantJudgeThumbList = nil --英灵点赞信息
DataManager._servantBoundList = nil --英灵羁绊信息
DataManager._rankTable              = nil
DataManager._slotTable              = nil
DataManager._suitTable              = nil
DataManager._allTradingTable        = nil -- 所有交易道具列表
DataManager._playerDressTable       = nil
DataManager._playerGuild            = nil
DataManager._playerTradingTable     = nil -- 摊位
DataManager._playerTradingRecordTable = nil -- 交易记录
DataManager._playerTradingFinishedRecordTable = nil -- 提取交易记录
DataManager._playerTradingFocusTable = nil -- 交易关注
DataManager._otherPlayerEquipmentTable = nil -- 其他玩家装备信息
DataManager._playerActivityTable    = nil -- 活动信息
DataManager._mailTable              = nil
DataManager._lastSendBug            = nil
DataManager._chatTable = nil              --聊天
DataManager._storageTable = nil       -- 仓库
DataManager._currentActPoint = nil --当前活跃点数
DataManager._actPointRewardTable = nil --活跃奖励table
-- 新获得道具有关
DataManager._newItemTable = nil
DataManager._newEquipmentTable = nil
--气泡头像数据
DataManager._decorationListTable = nil

--部位强化列表
DataManager._positionStrengthTable       = nil

--装备带的天赋技能
DataManager._playerEquipmentTalentTable = nil

-- 当前世界地图ID
DataManager._worldMapId  = 0
DataManager._worldMapKey = 0

-- 多人信息
DataManager._multiPlayerInfoTable = nil
DataManager._multiInfoRequestTable = nil

-- 任务
DataManager._playerTaskTable = nil

-- 玩家网络情况
DataManager._playerNetEnvTable = nil

-- 登陆后玩家状态(nil 默认 0=>空闲 1=》房间 2=》战斗)
DataManager._loginTeamStatus = nil

-- 引导
DataManager._guideTable = nil

-- 福利
DataManager._playerSignInfo = nil

-- 功能开启
DataManager._functionOpenTable = nil
DataManager._funcOpenQueue = nil -- 功能开启提示

DataManager._historyTable = nil

--空间新消息初始化为0
DataManager._newNotifications = 0

--player世界发言时间初始化为0
DataManager._chatWorldTime = 0
DataManager._chatTrumpetTime = 0

--世界聊天默认选择频道
DataManager._chatChannel = lt.Constants.CHAT_TYPE.WORLD
--委托任务访问NPC
DataManager._currentDelegateId = 0
DataManager._currentNPCId = 0

-- 公告
DataManager._announcementTable = nil
DataManager._announcementArray = nil

-- 启用网页充值
DataManager._webchargeArray = nil

--商城返利信息
DataManager._consumptionInfoArray = nil

--生活技能信息
DataManager._lifeSkillTable = nil

DataManager._combineItemTable = {}

DataManager._playerAlchemy = nil

--药剂相关
DataManager._pharmacyColumnDisplayInfo = nil

DataManager._plyActivityBoxInfo = nil

DataManager._lastGuildChatTime = nil

--符文数据
DataManager._runeListTable  = nil
DataManager._runeBagListTable = nil
DataManager._runePageListTable = nil
DataManager._runeBoxTable = nil

--服务器等级
DataManager._serverLevel = nil
DataManager._leftDayCount = nil
DataManager._openDayCount = nil
DataManager._isStopLevel = nil
DataManager._offlineDoubleExp = nil

-- 游戏参数
DataManager._serverProperty = lt.Constants.PROPERTY.NIL

DataManager._weaponTable = nil
DataManager._figureTable = nil
DataManager._dressAddition = nil

DataManager._newItemArray = nil
DataManager._equipmentAutoDecomposeInfo = nil

--活动推送flag
DataManager._treasurePushFlag = false
DataManager._guardPushFlag = false
DataManager._pk = false
DataManager._riskTeamMessageNew = false

DataManager._caseMonsterKillTable = nil

DataManager._cpServerId = "0"

function DataManager:init()
    if self._init then
        return
    end

    self._init = true

    self._caseMonsterKillTable = {}

    -- 登陆
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_LOGIN, handler(self, self.onLoginResponse), "DataManager.onLoginResponse")

    -- 登录玩家的信息
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_LOGIN_PLAYER, handler(self, self.onGetLoginPlayerResponse), "DataManager.onGetLoginPlayerResponse")

    -- 监听flush数据的事件
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_FLUSH, handler(self, self.onFlushResponse), "DataManager.onFlushResponse")
    -- 常量表商城表
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_SHOP_LIST, handler(self, self.onGetShopListResponse), "DataManager.onGetShopListResponse")
    -- 全局参数
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_SERVER_GLOBAL_PARM, handler(self, self.onGetServerGlobalParm), "DataManager.onGetServerGlobalParm")
    -- 复活相关
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_REVIVE_COUNT, handler(self, self.onReviveCount), "DataManager.onReviveCount")
    -- 玩家
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_PLAYER, handler(self, self.onGetPlayerResponse), "DataManager.onGetPlayerResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_3V3_INFO, handler(self, self.onUpdate3V3Info), "DataManager.onUpdate3V3Info")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_AUTO_MATCH_STATE, handler(self, self.onUpdateAutoMatchState), "DataManager.onUpdateAutoMatchState")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_BLOOD_POOL, handler(self, self.onUpdateBloodPool), "DataManager.onUpdateBloodPool")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_NOTIFY_DAILY_COMPETITIVE_SCORE_INFO, handler(self, self.onNotifyDailyCompetitiveScoreInfo), "DataManager.onNotifyDailyCompetitiveScoreInfo")
    -- 英雄
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_HERO, handler(self, self.onGetHeroResponse), "DataManager.onGetHeroResponse")

    --技能最新
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_NEW_SKILL_HERO_LIST, handler(self, self.onGetNewSkillHeroResponse), "DataManager.onGetNewSkillHeroResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_NEW_SKILL_HERO_LIST, handler(self, self.onUpdateNewSkillHeroResponse), "DataManager.onUpdateNewSkillHeroResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_TALENT_PAGE_LIST, handler(self, self.onGetTalentPageListResponse), "DataManager.onGetTalentPageListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_TALENT_PAGE_LIST, handler(self, self.onUpdateTalentPageListResponse), "DataManager.onUpdateTalentPageListResponse")

    --天赋
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_TALENT, handler(self, self.onGetTalentResponse), "DataManager.onGetTalentResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_HERO_TALENT_LIST, handler(self, self.onGetHeroTalentListResponse), "DataManager.onGetHeroTalentListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_HERO_TALENT_LIST, handler(self, self.onUpdateHeroTalentListResponse), "DataManager.onUpdateHeroTalentListResponse")

    -- 英灵
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_SERVANT_LIST, handler(self, self.onGetServantListResponse), "DataManager.onGetServantListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_SERVANT_LIST, handler(self, self.onUpdateServantListResponse), "DataManager.onUpdateServantListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_SERVANT_JUDGE_THUMB_LIST, handler(self, self.getServantJudgeThumbListResponse), "DataManager.getServantJudgeThumbListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_SERVANT_BOUND_LIST, handler(self, self.onGetServantBoundListResponse), "DataManager.onGetServantBoundListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_SERVANT_BOUND_LIST, handler(self, self.onUpdateServantBoundListResponse), "DataManager.onUpdateServantBoundListResponse")
    
    --申请入队
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_REQUEST_ENTER_TEAM, handler(self, self.onRequestEnterTeamResponse), "DataManager.onRequestEnterTeamResponse")
    
    --邀请入队
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_INVITE_ENTER_TEAM, handler(self, self.onInviteEnterTeamResponse), "DataManager.onInviteEnterTeamResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_ASK_ENTER_TEAM, handler(self, self.onAskEnterResponse), "DataManager.onAskEnterResponse")

    -- 组队回复
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_ASK_ENTER_TEAM_REJECTED, handler(self, self.onAskEnterTeamRejected), "DataManager.onAskEnterTeamRejected")

    -- 邀请入会
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_JOIN_GUILD_REQUEST, handler(self, self.onGetJoinGuildResponse), "DataManager.onGetJoinGuildResponse")

    --公会狂欢
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_GUILD_CRAZY_PARTY_INFO, handler(self, self.onGetJoinGuildPartyInfoResponse), "DataManager.onGetJoinGuildPartyInfoResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_GUILD_CRAZY_PARTY_JOIN, handler(self, self.onGetJoinGuildPartyJoinResponse), "DataManager.onGetJoinGuildPartyJoinResponse")

    --活跃活动大战场
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_EXCHANGE_SEASON_COUNT_INFO, handler(self, self.onGetExchangeSeasonCountInfoResponse), "DataManager.onGetExchangeSeasonCountInfoResponse")

    -- 道具
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_USE_ITEM, handler(self, self.onUseItemResponse), "DataManager.onUseItemResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ITEM_LIST, handler(self, self.onGetItemListResponse), "DataManager.onGetItemListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_ITEM_LIST, handler(self, self.onUpdateItemListResponse), "DataManager.onUpdateItemListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_SHOP_BUY_ITEM_COUNT, handler(self, self.onGetShopBuyItemCountResponse), "DataManager.onGetShopBuyItemCountResponse")
    -- 装备
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_EQUIPMENT_LIST, handler(self, self.onGetEquipmentListResponse), "DataManager.onGetEquipmentListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_EQUIPMENT_LIST, handler(self, self.onUpdateEquipmentListResponse), "DataManager.onUpdateEquipmentListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_EQUIPMENT_SLOT, handler(self, self.onGetEquipmentSlotResponse), "DataManager.onGetEquipmentSlotResponse")

    -- 生活技能
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_LIFE_SKILL_LIST, handler(self, self.onGetLifeSkillListResponse), "DataManager.onGetLifeSkillListResponse")

    -- 符文
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_RUNE_LIST, handler(self, self.onGetRuneListResponse), "DataManager.onGetRuneListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_RUNE_LIST, handler(self, self.onUpdateRuneListResponse), "DataManager.onUpdateRuneListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_RUNE_BAG_LIST, handler(self, self.onGetBagRuneListResponse), "DataManager.onGetBagRuneListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_RUNE_BAG_LIST, handler(self, self.onUpdateBagRuneListResponse), "DataManager.onUpdateBagRuneListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_RUNE_PAGE_LIST, handler(self, self.onGetRunePageListResponse), "DataManager.onGetRunePageListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_RUNE_PAGE_LIST, handler(self, self.onUpdateRunePageListResponse), "DataManager.onUpdateRunePageListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_RUNE_BOX_LIST, handler(self, self.onGetRuneBoxListResponse), "DataManager.onGetRuneBoxListResponse")
    
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_RUNE_EQUIP, handler(self, self.onRuneEquipResponse), "DataManager:onRuneEquipResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_RUNE_UNEQUIP, handler(self, self.onRuneUnEquipResponse), "DataManager:onRuneUnEquipResponse")
    -- 服务器等级
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_SERVER_LEVEL, handler(self, self.onGetServerLevelResponse), "DataManager.onGetServerLevelResponse")

    -- 离线双倍经验
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_NOTIFY_OFFLINE_DOUBLE_EXP, handler(self, self.onNotifyOfflineDoubleExpResponse), "DataManager.onNotifyOfflineDoubleExpResponse")

    -- 临时背包
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_TEMP_BAG_LIST, handler(self, self.onGetTempBagListResponse), "DataManager.onGetTempBagListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_TEMP_BAG_LIST, handler(self, self.onUpdateTempBagListResponse), "DataManager.onUpdateTempBagListResponse")

    -- 部位强化表
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_POSITION_STRENGTHEN_LIST, handler(self, self.onGetPositionStrengthResponse), "DataManager.onGetPositionStrengthResponse")

    -- 月卡相关
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_CARD_LOG_LIST, handler(self, self.onGetCardLogListResponse), "DataManager.onGetCardLogListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_CARD_RECEIVE_LOG_LIST, handler(self, self.onGetCardReceiveLogListResponse), "DataManager.onGetCardReceiveLogListResponse")

    -- 仓库
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_STORAGE_BAG_LIST, handler(self, self.onGetStorageBagListResponse), "DataManager.onGetStorageBagListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_STORAGE_BAG_LIST, handler(self, self.onUpdateStorageBagListResponse), "DataManager.onUpdateStorageBagListResponse")
    
    -- 好友
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_FRIEND_LIST, handler(self, self.onGetFriendListResponse), "DataManager.onGetFriendListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_FRIEND_LIST, handler(self, self.onUpdateFriendListResponse), "DataManager.onUpdateFriendListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_CHAT, handler(self, self.onChatResponse), "DataManager.onChatResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_REQUEST_FRIEND, handler(self, self.onRequestFriendResponse), "DataManager.onRequestFriendResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_REMOVE_FRIEND, handler(self, self.onRemoveFriendResponse), "DataManager:onRemoveFriendResponse")
    
    --成长任务
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_NEWBIE_GUIDE_TASK_LIST, handler(self, self.onGetNewBieTaskListResponse), "DataManager.onGetNewBieTaskListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_NEWBIE_GUIDE_TASK_LIST, handler(self, self.onUpdateNewBieTaskListResponse), "DataManager.onUpdateNewBieTaskListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_NEWBIE_GUIDE_SECTION_RECEIVE, handler(self, self.onGetNewbieGuildSectionReceiveResponse), "DataManager.onGetNewbieGuildSectionReceiveResponse")

    --战力达人
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_BATTLE_POINT_REWARD_LOG_LIST, handler(self, self.onGetBattlePointRewardLogListResponse), "DataManager.onGetBattlePointRewardLogListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_BATTLE_POINT_REWARD_LOG_LIST, handler(self, self.onUpBattlePointRewardLogListResponse), "DataManager.onUpBattlePointRewardLogListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_BATTLE_POINT_REWARD_RECEIVE_TIMES, handler(self, self.onGetBattlePointRewardReceiveResponse), "DataManager.onGetBattlePointRewardReceiveResponse")

    --魔王巢穴
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_DEVIL_NEST_LIST, handler(self, self.onGetDevilNestListResponse), "DataManager.onGetDevilNestListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_DEVIL_NEST_RANK_LIST, handler(self, self.onGetDevilNestRankListResponse), "DataManager.onGetDevilNestRankListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_DEVIL_NEST_EXTRA_LIST, handler(self, self.onGetDevilNestExtraListResponse), "DataManager.onGetDevilNestExtraListResponse")


    --红包
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_PAPER_BAG_LIST, handler(self, self.onGetPaperBagResponse), "DataManager.onGetPaperBagResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_PAPER_BAG_LIST, handler(self, self.onUpdatePaperBagResponse), "DataManager.onUpdatePaperBagResponse")

    --福利活动删除相关
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_DELETE_ACTIVITY_INFO, handler(self, self.onGetDeleteActivityInfoResponse), "DataManager.onGetDeleteActivityInfoResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_OPEN_SERVER_ACTIVITY_TIME_INFO, handler(self, self.onGetOpenServerActivityTimeInfoResponse), "DataManager.onGetOpenServerActivityTimeInfoResponse")

    --最近联系人
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_RECENT_CONTACT_PLAYERS, handler(self, self.onGetRecentContactPlayersResponse), "DataManager.onGetRecentContactPlayersResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_RECENT_CONTACT_PLAYERS, handler(self, self.onUpdateRecentContactPlayersResponse), "DataManager.onUpdateRecentContactPlayersResponse")
    -- 邮件
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_MAIL_LIST, handler(self, self.onGetMailListResponse), "DataManager.onGetMailListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_MAIL_LIST, handler(self, self.onUpdateMailListResponse), "DataManager.onUpdateMailListResponse")
    
    --头像气泡
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_DECORATION_LIST, handler(self, self.onGetDecorationListResponse), "DataManager.onGetDecorationListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_DECORATION_LIST, handler(self, self.onUpdataDecorationListResponse), "DataManager.onUpdataDecorationListResponse")

    -- 交易
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_PLAYER_TRADING_ITEM_LIST, handler(self, self.onGetPlayerTradingItemListResponse), "DataManager.onGetPlayerTradingItemListResponse")

    --商城充值返利
    --lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVITY_CONSUMPTION_INFO, handler(self, self.onGetConsumptionResponse), "DataManager.onGetConsumptionResponse")
    
    --好人卡
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_EXCHANGE_GOODMAN_POINT_INFO, handler(self, self.onGetExchangeGoodmanPointInfo), "DataManager.onGetExchangeGoodmanPointInfo")

    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GAIN_GOODMAN_POINT, handler(self, self.onGainGoodmanPoint), "DataManager.onGainGoodmanPoint")

    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_EXCHANGE_POINT_INFO, handler(self, self.onGetExchangePointInfo), "DataManager.onGetExchangePointInfo")

    --自动分解
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_EQUIPMENT_AUTO_DECOMPOSE, handler(self, self.onEquipmentAutoDecompose), "DataManager.onEquipmentAutoDecompose")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_AUTO_DECOMPOSE_LIST, handler(self, self.onGetAutoDecomposeList), "DataManager.onGetAutoDecomposeList")

    --药剂
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_PHARMACY_COLUMN_DISPLAY, handler(self, self.onGetPharmacyColumnDisplay), "DataManager.onGetPharmacyColumnDisplay")

    --活动相关
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_LIVENESS_ACTIVITY_LIST, handler(self, self.onGetLivenessActivityList), "DataManager.onGetLivenessActivityList")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_LIVENESS_ACTIVITY_LIST, handler(self, self.onUpdateLivenessActivityList), "DataManager.onUpdateLivenessActivityList")

    --限时活动开启
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVITY_LIVENESS_TIME, handler(self, self.onGetActivityLivenessTime), "DataManager.onGetActivityLivenessTime")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_ACTIVITY_LIVENESS_TIME, handler(self, self.onUpdateActivityLivenessTime), "DataManager.onUpdateActivityLivenessTime")

    -- 活动任务
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_ACTIVITY_TASK_PROGRESS, handler(self, self.onActivityTaskProgress), "DataManager.onActivityTaskProgress")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_RECEIVE_ACTIVITY_TASK, handler(self, self.onReceiveActivityTask), "DataManager.onReceiveActivityTask")

    -- 活动-冒险任务
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_ACTIVITY_TASK2_PROGRESS, handler(self, self.onActivityTask2Progress), "DataManager.onActivityTask2Progress")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_DO_ADVENTURE_TASK, handler(self, self.onDoAdventureTaskResponse), "DataManager:onDoAdventureTaskResponse")

    -- 活动-魔物净化
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVITY_MONSTER_PURIFICATION_ELEMENT, handler(self, self.onGetMonsterPurificationElement), "DataManager.onGetMonsterPurificationElement")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVITY_WORLD_BOSS_FLUSH, handler(self, self.onGetMonsterPurificationFieldElement), "DataManager.onGetMonsterPurificationFieldElement")
    
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_MONSTER_PURIFICATION_KILL_INFO, handler(self, self.onMonsterPurificationKillInfo), "DataManager.onMonsterPurificationKillInfo")

    -- 活动-深渊领主
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVITY_PITLORD, handler(self, self.onGetActivityPitlord), "DataManager.onGetActivityPitlord")

    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVITY_TREASURE, handler(self, self.onGetActivityTreasure), "DataManager.onGetActivityTreasure")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVITY_TREASURE_RESULT, handler(self, self.onGetActivityTreasureResult), "DataManager.onGetActivityTreasureResult")

    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVITY_REWARD_LIST, handler(self, self.onGetActivityRewardList), "DataManager.onGetActivityRewardList")

    --活跃活动
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVE_BOX, handler(self, self.onGetActiveBox), "DataManager.onGetActiveBox")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_ACTIVITY_TASK3_PROGRESS, handler(self, self.onActivityTask3Progress), "DataManager.onActivityTask3Progress")
    -- 活动-讨饭精英
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVITY_CREAM_BOSS_FLUSH, handler(self, self.onGetActivityCreamBossFlush), "DataManager.onGetActivityCreamBossFlush")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_ACTIVITY_CREAM_BOSS_FLUSH, handler(self, self.onUpdateActivityCreamBossFlush), "DataManager.onUpdateActivityCreamBossFlush")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_DELETE_ACTIVITY_CREAM_BOSS_FLUSH, handler(self, self.onDeleteActivityCreamBossFlush), "DataManager.onDeleteActivityCreamBossFlush")

    -- 队伍信息
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_TEAM_STATUS, handler(self, self.onUpdateTeamStatus), "DataManager:onUpdateTeamStatus")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_EXIT_TEAM, handler(self, self.onExitTeam), "DataManager:onExitTeam")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_KICK_FROM_TEAM, handler(self, self.onKickFromTeam), "DataManager:onKickFromTeam")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_TRANSFER_TEAM_HOST, handler(self, self.onTransferTeamHost), "DataManager:onTransferTeamHost")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_TEAM_REQUESTING_ENTER_PLAYERS, handler(self, self.onGetTeamRequestingEnterPlayers), "DataManager:onGetTeamRequestingEnterPlayers")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_REQUESTING_ENTER_TEAM_REJECTED, handler(self, self.onRequestingEnterTeamRejected), "DataManager:onRequestingEnterTeamRejected")

    -- 世界事件
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_WORLD_EVENT, handler(self, self.onWorldEvent), "DataManager.onWorldEvent")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_PLAYERS, handler(self, self.onGetPlayers), "DataManager.onGetPlayers")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_MONSTERS, handler(self, self.onGetMonsters), "DataManager.onGetMonsters")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_MONSTER_EVENT, handler(self, self.onMonsterEvent), "DataManager.onMonsterEvent")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_REFRESH_MONSTERS, handler(self, self.onRefreshMonsters), "DataManager.onRefreshMonsters")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_KILL_DUNGEON_MONSTER, handler(self, self.onKillMonster), "DataManager.onKillMonster")

    -- 血量同步事件
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_PLAYER_HEALTH_POINT, handler(self, self.onUpdatePlayerHealthPoint), "DataManager.onUpdatePlayerHealthPoint")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_HEALTH_UPDATE_EVENT, handler(self, self.onHealthUpdateEvent), "DataManager.onHealthUpdateEvent")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_HIT_DUNGEON_MONSTER, handler(self, self.onHitBattleMonster), "DataManager.onHitBattleMonster")

    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_HIT_MONSTER, handler(self, self.onHitMonster), "DataManager.onHitMonster")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_TRIGGER_BOSS_BATTLE, handler(self, self.onTriggerBossBattle), "DataManager.onTriggerBossBattle")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_CHANGE_THREAT_TARGET, handler(self, self.onChangeThreatTarget), "DataManager.onChangeThreatTarget")

    -- 掉落接口
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_ON_BATTLE_DROP_ITEM, handler(self, self.onBattleDropItem), "DataManager.onBattleDropItem")
    
    -- 其他人信息
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_SIMPLE_PLAYER_INFO, handler(self, self.onGetSimplePlayerInfo), "DataManager.onGetSimplePlayerInfo")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_TEAM_SIMPLE_PLAYER_INFO, handler(self, self.onUpdateSimplePlayerInfo), "DataManager.onUpdateSimplePlayerInfo")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_PVP_ONLINE_STATUS, handler(self, self.onPvpOnlineStatus), "DataManager.onPvpOnlineStatus")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_PLAYER_STATUS_UPDATE, handler(self, self.onPlayerStatusUpdate), "DataManager.onPlayerStatusUpdate")

    -- 答题推送
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_LIVENESS_ACTIVITY_QUESTION_HELP_ANSWERED, handler(self, self.onLivenessActivityQuestionHelpAnswered), "DataManager.onLivenessActivityQuestionHelpAnswered")

    --空间新消息
    --lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_PLAYER_ZONE_DATA, handler(self, self.onUpdataPlayerZoneDataResponse), "DataManager.onUpdataPlayerZoneDataResponse")

    -- 任务
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_TASK, handler(self, self.onGetTaskResponse), "DataManager:onGetTaskResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_MAIN_TASK, handler(self, self.onGetMainTaskResponse), "DataManager:onGetMainTaskResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_CUR_TASK_LIST, handler(self, self.onGetCurTaskListResponse), "DataManager:onGetCurTaskListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_CUR_TASK_LIST, handler(self, self.onUpdateCurTaskListResponse), "DataManager:onUpdateCurTaskListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_DO_THE_TASK, handler(self, self.onDoTheTaskResponse), "DataManager:onDoTheTaskResponse")

    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_REWARD_NOTIFY, handler(self, self.onRewardNotifyResponse), "DataManager:onRewardNotifyResponse")

    -- 网络状态
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_PLAYER_UPDATE_NETWORK_ENV, handler(self, self.onUpdateNetworkResponse), "DataManager.onUpdateNetworkResponse")
    --拿不到玩家player数据
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_NEED_RELOGIN, handler(self, self.onNeedReloginResponse), "DataManager.onNeedReloginResponse")

    -- 时装
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_DRESS_LIST, handler(self, self.onGetDressListResponse), "DataManager.onGetDressListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_DRESS_LIST, handler(self, self.onUpdateDressListResponse), "DataManager.onUpdateDressListResponse")

    -- 引导
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_GUIDE_PROGRESS_LIST, handler(self, self.onGetGuideProgressListResponse), "DataManager.onGetGuideProgressListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_GUIDE_PROGRESS_LIST, handler(self, self.onUpdateGuideProgressListResponse), "DataManager.onUpdateGuideProgressListResponse")

    -- 福利
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_DAILY_SIGNIN_LOG_LIST, handler(self, self.onGetDailySigninLogListResponse), "DataManager.onGetDailySigninLogListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_DAILY_SIGNIN_LOG_LIST, handler(self, self.onUpdateDailySigninLogListResponse), "DataManager.onUpdateDailySigninLogListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_UPGRADE_REWARD_LOG_LIST, handler(self, self.onGetUpgradeRewardLogListResponse), "DataManager.onGetUpgradeRewardLogListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_UPGRADE_REWARD_LOG_LIST, handler(self, self.onUpdateUpgradeRewardLogListResponse), "DataManager.onUpdateUpgradeRewardLogListResponse")

    --扭蛋机
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_EGG_DIAMOND, handler(self, self.onGetEggDiamond), "DataManager.onGetEggDiamond")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_EGG, handler(self, self.onGetEgg), "DataManager.onGetEgg")

    --冲级奖励
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_PROMOTE_REWARD_LOG_LIST, handler(self, self.onGetPromoteRewardResponse), "DataManager.onGetPromoteRewardResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_PROMOTE_REWARD_LOG_LIST, handler(self, self.onUpdatePromoteRewardResponse), "DataManager.onUpdatePromoteRewardResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_PROMOTE_REWARD_RECEIVE_TIMES, handler(self, self.onGetPromoteRewardReceiveTimesResponse), "DataManager.onGetPromoteRewardReceiveTimesResponse")

    -- 功能开启
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_FUNCTION_OPEN_LIST, handler(self, self.onGetFunctionOpenList), "DataManager.onGetFunctionOpenList")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_FUNCTION_OPEN_LIST, handler(self, self.onUpdateFunctionOpenList), "DataManager.onUpdateFunctionOpenList")

    -- 公会委托
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_GUILD_INFO, handler(self, self.onGetGuildInfoResponse), "GuildLayer:onGetGuildInfoResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_GUILD_INFO, handler(self, self.onUpdateGuildInfoResponse), "GuildLayer:onUpdateGuildInfoResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_GUILD_LIST, handler(self, self.onUpdateGuildListResponse), "GuildLayer:onUpdateGuildListResponse")

    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_GUILD_TASK_STATUS_LIST, handler(self, self.onGetGuildTaskStatusList), "DataManager.onGetGuildTaskStatusList")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_GUILD_TASK_STATUS_LIST, handler(self, self.onUpdateGuildTaskStatusList), "DataManager.onUpdateGuildTaskStatusList")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_DO_GUILD_TASK_NPC, handler(self, self.onDoGuildTaskNpc), "DataManager.onDoGuildTaskNpc")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_JOIN_GUILD_REQUESTER_LIST, handler(self, self.onGetGuildRequestListResponse), "DataManager:onGetGuildRequestListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_GUILD_ANNEX_REQUEST_LIST, handler(self, self.onGetGuildAnnexRequestListResponse), "DataManager.onGetGuildAnnexRequestListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_NOTIFY_BOOM_CONTRIBUTION, handler(self, self.onNotifyBoomContribution), "DataManager.onNotifyBoomContribution")
    --公会boss
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_PLAYER_GUILD_BOSS_LIST, handler(self, self.onGetPlayerGuildBossList), "DataManager.onGetPlayerGuildBossList")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVITY_GUILD_BOSS_LIST, handler(self, self.onRequestGuildBossList), "DataManager.onRequestGuildBossList")

    -- 公会繁荣度
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_KICKED_OUT, handler(self, self.onKickedOut), "DataManager.onKickedOut")

    -- 炼金术
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ALCHEMY, handler(self, self.onGetAlchemyResponse), "DataManager.onGetAlchemyResponse")

    -- 摆摊奖励
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_PLAYER_TRADING_FINISHED_RECORDS, handler(self, self.onGetFinishedTradingRecordsResponse), "DataManager.onGetFinishedTradingRecordsResponse")

    -- 武器特效
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_WEAPON_LIST, handler(self, self.onGetWeaponListResponse), "DataManager.onGetWeaponListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_WEAPON_LIST, handler(self, self.onUpdateWeaponListResponse), "DataManager.onUpdateWeaponListResponse")

    -- 头像气泡
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_FIGURE_LIST, handler(self, self.onGetFigureListResponse), "DataManager.onGetFigureListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_FIGURE_LIST, handler(self, self.onUpdateFigureListResponse), "DataManager.onUpdateFigureListResponse")

    -- 颜值
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_DRESS_ADDITION, handler(self, self.onGetDressAdditionResponse), "DataManager.onGetDressAdditionResponse")

    -- 获得经验
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_NOTIFY_EXP_INCREASE, handler(self, self.onGetExpResponse), "DataManager.onGetExpResponse")

    -- 好友里面的系统消息
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_SYSTEM_EVENT, handler(self, self.onGetSystemEventResponse), "DataManager.onGetSystemEventResponse")

    -- 新地图
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ENTERED_MAP, handler(self, self.onGetEnteredMap), "DataManager.onGetEnteredMap")

    -- 持续性Buff
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_BUFF, handler(self, self.onGetBuff), "DataManager.onGetBuff")

    -- 3V3宝箱
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_FLUSH_TIME, handler(self, self.onGetFlushTime), "DataManager.onGetFlushTime")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_NOTIFY_DAILY_3V3_REWARD_RECEIVE_INFO, handler(self, self.onNotifyDaily3V3RewardReceiveInfo), "DataManager.onNotifyDaily3V3RewardReceiveInfo")

    --次日礼包
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_MORROW_REWARD, handler(self, self.onGetMorrowReward), "DataManager.onGetMorrowReward")

    --自己领取红包的Id
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_RECEIVED_RED_PACKET_LOG, handler(self, self.onReceiveRedPacketLog), "DataManager.onReceiveRedPacketLog")

    --世界boss信息
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVITY_ULTIMATE_CHALLENGE, handler(self, self.onGetActivityUltimateChallenge), "DataManager.onGetActivityUltimateChallenge")

    --宝石达人
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_STONE_REWARD_LOG_LIST, handler(self, self.onGetStoneRewardLogListResponse), "DataManager.onGetStoneRewardLogListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_STONE_REWARD_LOG_LIST, handler(self, self.onUpdateStoneRewardLogListResponse), "DataManager.onUpdateStoneRewardLogListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_STONE_REWARD_RECEIVE_TIMES, handler(self, self.onGetStoneRewardReceiveTimesResponse), "DataManager.onGetStoneRewardReceiveTimesResponse")

    --全民答题
    --答题的开启 进程 。。。。
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVITY_ANSWER_PARTY_INFO, handler(self, self.onGetActivityAnswerPartyInfo), "DataManager.onGetActivityAnswerPartyInfo")
    --答题结束的结算
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_NOTIFY_ANSWER_PARTY_REWARD_ACCUMULATIVE, handler(self, self.onNotifyAnswerPartyRewardAccumulative), "DataManager.onNotifyAnswerPartyRewardAccumulative")
    -- 当期学霸雕塑
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVITY_ANSWER_PARTY_BEST_PLAYER, handler(self, self.onGetActivityAnswerPartyBestPlayer), "DataManager.onGetActivityAnswerPartyBestPlayer")

    --英灵达人
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_SERVANT_REWARD_LOG_LIST, handler(self, self.onGetServantRewardLogListResponse), "DataManager.onGetServantRewardLogListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_SERVANT_REWARD_LOG_LIST, handler(self, self.onUpdateServantRewardLogListResponse), "DataManager.onUpdateServantRewardLogListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_SERVANT_REWARD_RECEIVE_TIMES, handler(self, self.onGetServantRewardReceiveTimesResponse), "DataManager.onGetServantRewardReceiveTimesResponse")

    --生活达人
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_LIFE_REWARD_LOG_LIST, handler(self, self.onGetLifeRewardLogListResponse), "DataManager.onGetServantRewardLogListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_LIFE_REWARD_LOG_LIST, handler(self, self.onUpdateLifeRewardLogListResponse), "DataManager.onUpdateServantRewardLogListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_LIFE_REWARD_RECEIVE_TIMES, handler(self, self.onGetLifeRewardReceiveTimesResponse), "DataManager.onGetLifeRewardReceiveTimesResponse")

    --强化达人
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_STRENGTH_REWARD_LOG_LIST, handler(self, self.onGetStrengthRewardLogListResponse), "DataManager.onGetStrengthRewardLogListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_STRENGTH_REWARD_LOG_LIST, handler(self, self.onUpdateStrengthRewardLogListResponse), "DataManager.onUpdateStrengthRewardLogListResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_STRENGTH_REWARD_RECEIVE_TIMES, handler(self, self.onGetStrengthRewardReceiveTimesResponse), "DataManager.onGetStrengthRewardReceiveTimesResponse")

    -- 战队
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_RISK_TEAM_INFO, handler(self, self.onGetRiskTeamInfo), "DataManager.onGetRiskTeamInfo")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_RISK_TEAM_INFO, handler(self, self.onUpdateRiskTeamInfo), "DataManager.onUpdateRiskTeamInfo")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_EXIT_RISK_TEAM_SUCCESS, handler(self, self.onExitRiskTeamSuccess), "DataManager.onExitRiskTeamSuccess")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_RISK_TEAM_DELETED, handler(self, self.onRiskTeamDeleted), "DataManager.onRiskTeamDeleted")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_NOTIFY_RISK_TEAM_NAME_CHANGED, handler(self, self.onNotifyRiskTeamNameChanged), "DataManager.onNotifyRiskTeamNameChanged")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_TEAM_CHAT_MESSAGES, handler(self, self.onGetTeamChatMessageResponse), "DataManager:onGetTeamChatMessageResponse")
    -- 迷宫
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_MAZE_TRIGGER_ANSWER, handler(self, self.onMazeTriigerAnswer), "DataManager.onMazeTriigerAnswer")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_SPECIAL_EVENT_MAZE, handler(self, self.onGetSpecialEventMaze), "DataManager.onGetSpecialEventMaze")

    --拉取离线好友系统消息
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_SYSTEM_EVENT_LIST, handler(self, self.onGetSystemEventListResponse), "DataManager.onGetSystemEventListResponse")

    --称号
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_TITLE, handler(self, self.onTitleInfo), "DataManager.onTitleInfo")

    --回流礼包
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_BACK_FLOW_GAG_ARRAY, handler(self, self.onGetBackFlowGagArray), "DataManager.onGetBackFlowGagArray")

    --在线礼包
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ONLINE_REWARD, handler(self, self.onGetOnlineReward), "DataManager.onGetOnlineReward")


    --玩家从开服到现在充值数
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_TOTAL_RECHARGE_AMOUNT, handler(self, self.getTotalRechargeAmount), "DataManager.getTotalRechargeAmount")

    --首冲 累冲
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_RECHARGE_LOG, handler(self, self.getRechargeLog), "DataManager.getRechargeLog")

    --特惠礼包
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_MASTER_SPECIAL_GIFT_PACK_LIST, handler(self, self.getMasterSpecialGiftPackList), "DataManager.getMasterSpecialGiftPackList")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_SPECIAL_GIFT_PACK_LIST, handler(self, self.getSpecialGiftPackList), "DataManager.getSpecialGiftPackList")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_SPECIAL_GIFT_PACK_LIST, handler(self, self.updateSpecialGiftPackList), "DataManager.updateSpecialGiftPackList")

    --基金
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_GROW_UP_RUND, handler(self, self.getGrowUpFund), "DataManager.getGrowUpFund")

    --冒险小队活跃
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_COLLECTIVE_ACTIVE, handler(self, self.getCollectiveActive), "DataManager.getCollectiveActive")

    ---- 运营活动
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_BATCH_ACTIVITY, handler(self, self.onGetBatchActivity), "DataManager.onGetBatchActivity")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVITY_REWARD_LOG_LIST, handler(self, self.onGetActivityRewardLogList), "DataManager.onGetGetActivityRewardLogList")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_ACTIVITY_REWARD_LOG_LIST, handler(self, self.onUpdateActivityRewardLogList), "DataManager.onUpdateActivityRewardLogList")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_CHARGE_ORDER_LIST, handler(self, self.onGetChargeOrderList), "DataManager.onGetChargeOrderList")

    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_BATCH_ACTIVITY_LOG_ARRAY, handler(self, self.onGetBatchActivityLogArray), "DataManager.onGetBatchActivityLogArray")



    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_MST_ACTIVITY_SPECIAL_PACKET_LIST, handler(self, self.getMstActivitySpecialPacketList), "DataManager.getMstActivitySpecialPacketList")


    -- 累积登陆
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_MST_ACTIVITY_ACCUMULATE_LOGIN_LIST, handler(self, self.onGetMstActivityAccumulateLoginList), "DataManager.onGetMstActivityAccumulateLoginList")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_LOGIN_REWARD_LOG_LIST, handler(self, self.onGetLoginRewardLogList), "DataManager.onGetLoginRewardLogList")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_ACTIVITY_ACCUMULATE_LOGIN_LIST, handler(self, self.onGetActivityAccumulateLoginList), "DataManager.onGetActivityAccumulateLoginList")
    -- 首冲红包    
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_MST_ACTIVITY_FIRST_CHARGE_LIST, handler(self, self.onGetMstActivityFirstChargeList), "DataManager.onGetMstActivityFirstChargeList")
    -- 一起来嗨
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_MST_ACTIVITY_HAPPY_TOGETHER_LIST, handler(self, self.onGetMstActivityHappyTogetherList), "DataManager.onGetMstActivityHappyTogetherList")
    -- 战力红包
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_MST_ACTIVITY_POWER_LIST, handler(self, self.onGetMstActivityPowerList), "DataManager.onGetMstActivityPowerList")

    --女皇的贡品
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_MST_ACTIVITY_QUEEN_TRIBUTE_REWARD_LIST, handler(self, self.getMstActivityQueenTributeRewardList), "DataManager.getMstActivityQueenTributeRewardList")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_QUEEN_TRIBUTE, handler(self, self.getQueenTribute), "DataManager.getQueenTribute")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_GET_QUEEN_TRIBUTE_REWARD_LOG_LIST, handler(self, self.getQueenTributeRewardLogList), "DataManager.getQueenTributeRewardLogList")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_UPDATE_QUEEN_TRIBUTE_REWARD_LOG_LIST, handler(self, self.updateQueenTributeRewardLogList), "DataManager.updateQueenTributeRewardLogList")

    --cross server proto
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_CROSS_TEST, handler(self, self.onCrossTest), "DataManager.onCrossTest")
end                                                                      

function DataManager:reset()
    lt.CommonUtil.print("DataManager:reset")
    for i,v in pairs(self) do
        if type(v) ~= "function" then
            self[i] = nil
        end
    end

    self._init = true
    self._flush = false

    self._curServerId = 0
end

--[[ ################################################## server ##################################################
    服务器
    ]]
function DataManager:setCpServerId(cpServerId)
    self._cpServerId = cpServerId
end

function DataManager:getCpServerId()
    return self._cpServerId
end

function DataManager:getCurServer()
    return self:getServerInfo(self._curServerId)
end

function DataManager:getCurServerId()
    return self._curServerId
end

function DataManager:setCurServerId(serverId)
    self._curServerId = serverId
end

function DataManager:getServerTable()
    if not self._serverTable then
        self._serverTable = {}
    end

    return self._serverTable
end

-- 获得分组服务器
function DataManager:getServerArray()
    local serverTable = self:getServerTable()
    local serverArray = {}
    local debugServerArray = {}

    for _,serverInfo in pairs(serverTable) do
        serverArray[#serverArray + 1] = serverInfo
    end

    table.sort( serverArray, function( serverInfo1, serverInfo2 )
        return serverInfo1:getIndex() < serverInfo2:getIndex()
    end )

    return serverArray, debugServerArray
end

function DataManager:setServerInfo(serverInfo)
    local serverTable = self:getServerTable()

    local index = serverInfo:getIndex()
    serverTable[index] = serverInfo

    if not self._maxServerIdx then
        if serverInfo:getState() ~= lt.ServerInfo.STATE.WAIT and lt.CommonUtil:getCurrentTime() >= serverInfo:getOpenTime() then
            self._maxServerIdx = index
        end
    else
        if lt.CommonUtil:getCurrentTime() >= serverInfo:getOpenTime() then
            self._maxServerIdx = math.max(self._maxServerIdx, index)
            if self:isSpecialIndex(self._maxServerIdx) then --由于ios第一个区开了测试服的原因
                self._maxServerIdx = index
            end
        end
    end
end

function DataManager:isSpecialIndex(index) --ios服务器第一个区用了测试服开区，测试服的index最大
    return index == tonumber(30029999)
end

function DataManager:getServerInfo(serverId)
    local serverTable = self:getServerTable()

    return serverTable[serverId]
end

function DataManager:getDefaultServerInfo()
    if not self._maxServerIdx then
        return nil
    else
        return self:getServerInfo(self._maxServerIdx)
    end
end

--[[ ################################################## 亲加登录账号 ##################################################
    ]]
function DataManager:getLoginName(playerId)
    if playerId then
        return self._curServerId.."_"..playerId
    end
    return self._curServerId.."_"..self:getPlayerId()
end

--[[ ################################################## 订单号 ##################################################
    ]]
function DataManager:getBillNo()
    local fix = self:getLoginName()
    return fix.."_"..os.time()
end

-- Pc充值生成订单号
function DataManager:getFixBillNo(serverId, playerId)
    return serverId.."_"..playerId.."_"..os.time()
end

--[[ ################################################## token ##################################################
    服务器
    ]]
function DataManager:setToken(token)
    self._token = token
end

function DataManager:getToken()
    return self._token
end

--[[ ################################################## login player array ##################################################
    服务器
    ]]
function DataManager:getLoginPlayerArray()
    if not self._loginPlayerArray then
        self._loginPlayerArray = {}
    end
    return self._loginPlayerArray
end

--[[ ################################################## login ##################################################
    登陆
    ]]
function DataManager:onLoginResponse(event)
    local s2cLogin = event.data
    local code = s2cLogin.code

    lt.CommonUtil.print("s2cLogin content\n"..tostring(s2cLogin))

    self._worldChatRoomId = s2cLogin.audio_chat_room_id

    if code == lt.SocketConstants.CODE_WAITING_LOGIN then
        -- 排队
        local waitCount = s2cLogin.wait_count
        lt.GameEventManager:post(lt.GameEventManager.EVENT.WAITING_LOGIN, {waitCount = waitCount})
        return
    elseif code == lt.SocketConstants.CODE_KICKED_BY_OTHER_DEVICE_LOGIN then
        -- 重复登陆
        lt.Game:reLoginReset()
        return
    elseif code == lt.SocketConstants.CODE_USER_FREEZED then
        local unfreezeAccountTime = s2cLogin.unfreeze_account_time

        -- 账户冻结
        lt.Game:userFreezedReset(unfreezeAccountTime)
        return
    end

    local needSetLoginId = true
    self._loginPlayerArray = {}
    local loginPlayerArray = self:getLoginPlayerArray()
    for _,loginPlayer in ipairs(s2cLogin.player_array) do
        if loginPlayer.id == lt.PreferenceManager:getLoginId(self._token) then
            needSetLoginId = false
        end
        loginPlayerArray[#loginPlayerArray+1] = loginPlayer
    end
    table.sort(loginPlayerArray, function(player1, player2)
        return player1.id < player2.id
    end)

    if needSetLoginId then
        local csLoginPlayer = loginPlayerArray[1]
        if csLoginPlayer then
            lt.PreferenceManager:setLoginId(self._token, csLoginPlayer.id)
        end
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.LOGIN_RESULT)

    lt.PreferenceManager:setLoginPlayerInfo()
end

function DataManager:onGetLoginPlayerResponse(event)
    local s2cGetLoginPlayer = event.data
    lt.CommonUtil.printf("s2cGetLoginPlayer")

    local orginArray = self:getLoginPlayerArray()
    local originCount = #orginArray
    self._loginPlayerArray = {}
    local loginPlayerArray = self:getLoginPlayerArray()
    for _,loginPlayer in ipairs(s2cGetLoginPlayer.player_array) do
        loginPlayerArray[#loginPlayerArray+1] = loginPlayer

    end

    local count = #loginPlayerArray

    if count == 0 then
        lt.PreferenceManager:setLoginId(self._token, 0)
        lt.PreferenceManager:setLoginPlayerInfo()
        return
    end

    table.sort(loginPlayerArray, function(player1, player2)
        return player1.id < player2.id
    end)

    if count == originCount then
        return
    end

    local csLoginPlayer = loginPlayerArray[1]
    if csLoginPlayer then
        lt.PreferenceManager:setLoginId(self._token, csLoginPlayer.id)
    end

    lt.PreferenceManager:setLoginPlayerInfo()
end

function DataManager:getLoginId()
    return self._loginId
end

function DataManager:getWorldChatRoomId()
    return self._worldChatRoomId
end

function DataManager:getTeamChatRoomId()
    local team = self:getSelfTeamInfo()
    if not team then
        return 0
    end
    return team:getId()
end

function DataManager:getTeamAudioRoomId()
    local team = self:getSelfTeamInfo()
    if not team then
        return 0
    end
    return self:getCurServerId().."_"..team:getId()
end

function DataManager:getGuildChatRoomId()
    local player = self:getPlayer()
    if not player then
        return 0
    end
    return player:getGuildId()
end

function DataManager:getCurrentChatRoomId()
    local worldMapId = self:getWorldMapId()
    if not worldMapId then
        return 0
    end
    return worldMapId
end

function DataManager:resetLoginTeamStatus()
    self._loginTeamStatus = nil
end

function DataManager:getLoginTeamStatus()
    return self._loginTeamStatus
end

-- ################################################## 公告 ##################################################
function DataManager:getAnnouncementTable()
    if not self._announcementTable then
        self._announcementTable = {}
    end

    return self._announcementTable
end

function DataManager:getAnnouncementArray()
    if not self._announcementArray then
        self._announcementArray = {}
        self._announcementArray[lt.Announcement.TYPE.SYSTEM] = {}
        self._announcementArray[lt.Announcement.TYPE.ACTIVITY] = {}
    end

    return self._announcementArray
end

function DataManager:setAnnouncement(announcement)
    local announcementTable = self:getAnnouncementTable()
    local announcementArray = self:getAnnouncementArray()

    local id = announcement:getId()
    local type = announcement:getType()

    announcementTable[id] = announcement

    if not isset(announcementArray, type) then
        announcementArray[type] = {}
    end

    table.insert(announcementArray[type], announcement)
end

function DataManager:getAnnouncementByType(type)
    local announcementArray = self:getAnnouncementArray()

    return announcementArray[type] or {}
end

function DataManager:getAnnouncement(announcementId)
    local announcementTable = self:getAnnouncementTable()

    return announcementTable[announcementId]
end

function DataManager:clearAnnouncement()
    self._announcementTable = {}
    self._announcementArray = {}
end

function DataManager:sortAnnouncementArray()
    local announcementArray = self:getAnnouncementArray()
    for type,announcementArray2 in pairs(announcementArray) do
        table.sort( announcementArray2, function( announcement1, announcement2 )
            return announcement1:getSort() < announcement2:getSort()
        end )
    end
end

-- ################################################## 网页充值 ##################################################
function DataManager:getWebChargeArray()
    if not self._webchargeArray then
        self._webchargeArray = {}
    end
    return self._webchargeArray
end

function DataManager:clearWebChargeArray()
    self._webchargeArray = {}
end

function DataManager:openWebCharge()
    local channelId = lt.ConfigManager:getChannelId()
    local webchargeArray = self:getWebChargeArray()
    for _,channel in pairs(webchargeArray) do
        if channel == channelId then
            return true
        end
    end
    return false
end

-- ################################################## flush ##################################################
function DataManager:onFlushResponse(event)
    local s2cFlush = event.data
    local code = s2cFlush.code
    lt.CommonUtil.printf("s2cFlush code %d", code)

    local flag = s2cFlush.flag

    if code == lt.SocketConstants.CODE_OK then
        lt.CommonUtil.print("FLUSH OK")
        self._flush = true
    else
        lt.CommonUtil.print("FLUSH ERROR")
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.FLUSH_RESULT, {code = code, flag = flag})

    --拉取离线系统消息

    local updateTime = lt.ChatManager:getChatUpdateTime(1)

    if updateTime == 0 then
        updateTime = lt.CommonUtil:getCurrentTime()
    end
    local count = 30

    lt.SocketApi:getSystemEventList(updateTime,count)

    --拉取离线战队消息
    local riskTeam = self:getRiskTeam()
    if riskTeam then
        local teamId = riskTeam:getId()
        local count = 30
        local updateTime = lt.ChatManager:getChatTeamRiskUpdateTime(teamId)

        if updateTime == 0 then
            updateTime = lt.CommonUtil:getCurrentTime()
        end

        -- 获取聊天记录
        lt.SocketApi:getTeamChatMessages(teamId,updateTime,count)
    end

    --test cross server proto
    --lt.SocketApi:crossTest(12345)

end

function DataManager:isFlush()
    return self._flush
end

-- ################################################## 游戏参数 ##################################################
function DataManager:onGetServerGlobalParm(event)
    local s2cGetServerGlobalParm = event.data
    local code = s2cGetServerGlobalParm.code
    lt.CommonUtil.print("s2cGetServerGlobalParm code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- 当前服务器元素
    self._serverProperty = s2cGetServerGlobalParm.server_element_id

    lt.GameEventManager:post(lt.GameEventManager.EVENT.SERVER_PARAMS_UPDATE)
end

function DataManager:getServerProperty()
    return self._serverProperty
end

-- ################################################## 常量表商城表 ##################################################
function DataManager:onGetShopListResponse(event)
    local s2cGetShopList = event.data
    lt.CommonUtil.print("s2cGetShopList OK")

    self._shopItemTable = {}
    self._shopItemArray = {}
    self._shopItemIndex = {}

    for _,s2cShopItem in ipairs(s2cGetShopList.shop_array) do
        local shopItem = lt.ShopItem.new()
        shopItem:initWithRow(s2cShopItem)
        self._shopItemTable[shopItem:getId()] = shopItem
        local shopType = shopItem:getShopType()
        if not isset(self._shopItemArray, shopType) then
            self._shopItemArray[shopType] = {}
        end
        self._shopItemArray[shopType][#self._shopItemArray[shopType]+1] = shopItem

        -- 用作普通道具和商品道具的索引
        if shopType ~= 3 then
            -- 普通商品
            local itemType = shopItem:getShopType()
            if itemType == 1 then
                -- 砖石商城道具
                local itemId = shopItem:getItemId()
                self._shopItemIndex[itemId] = shopItem
            end
        end
    end
end

function DataManager:getShopItemTable()
    return self._shopItemTable or {}, self._shopItemArray or {}, self._shopItemIndex or {}
end

function DataManager:getShopItemArray()
    return self._shopItemArray or {}
end

function DataManager:getShopItemById(id)
    local shopItemTable = self:getShopItemTable()

    return shopItemTable[id]
end

-- ################################################## 复活相关 ##################################################
function DataManager:onReviveCount(event)
    local s2cReviveCount = event.data
    local code = s2cReviveCount.code
    lt.CommonUtil.print("s2cReviveCount code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cReviveCount content\n"..tostring(s2cReviveCount))

    self._reviveFreeCount = s2cReviveCount.free_count
    self._reviveCurCount = s2cReviveCount.cur_count
end

function DataManager:getReviveFreeCount()
    return self._reviveFreeCount
end

function DataManager:getReviveCurCount()
    return self._reviveCurCount
end

--[[ ################################################## player ##################################################
    玩家
    ]]
function DataManager:onGetPlayerResponse(event)
    local s2cGetPlayer = event.data
    local code = s2cGetPlayer.code
    lt.CommonUtil.print("s2cGetPlayer code " .. code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cGetPlayer content\n"..tostring(s2cGetPlayer))

    local csPlayer = s2cGetPlayer.player
    local player = lt.Player.new(csPlayer)

    local playerLevelUp = false
    local playerCoinRefresh = false
    local playerRuneCoinRefresh = false
    local energyRefresh = false
    local saveGameInfo = false
    local playerNameChange = false
    local guildCheck = false
    local diamondAdd = false

    if self._player then
        if player:getLevel() > self._player:getLevel() or player:getExtremeLevel() > self._player:getExtremeLevel() then
            playerLevelUp = true

            saveGameInfo = true
        end

        if player:getCoin() ~= self._player:getCoin() or player:getGold() ~= self._player:getGold() or player:getDiamond() ~= self._player:getDiamond() then
            --银币/金币/钻石刷新
            playerCoinRefresh = true
        end

        if player:getDiamond() - self._player:getDiamond() > 0 then
            diamondAdd = true
        end

        if player:getName() ~= self._player:getName() then
            playerNameChange = true
        end


        if player:getRuneCoin() ~= self._player:getRuneCoin() then
            --符文碎片刷新

            playerRuneCoinRefresh = true
        end

        if player:getEnergy() ~= self._player:getEnergy() then

            energyRefresh = true
        end

        if player:getGuildId() ~= self._player:getGuildId() then
            guildCheck = true
        end
    end

    self._player = player

    -- 玩家数据更新
    lt.GameEventManager:post(lt.GameEventManager.EVENT.PLAYER_UPDATE)

    if playerLevelUp then
        -- 升级
        lt.GameEventManager:post(lt.GameEventManager.EVENT.PLAYER_LEVEL_UP)

        local level = self._player:getLevel()

        -- sdk 升级
        if device.platform == "ios" or device.platform == "android" then
            local serverId = self:getCurServerId()
            local serverName = ""
            local serverInfo = self:getServerInfo(serverId)
            if serverInfo then
                serverName = serverInfo:getName()
            end
            cpp.SdkService:shared():levelUp(self._player:getId() , self._player:getName(), level, serverId, serverName)
        end
        
        -- 升级引导
        lt.GuideManager:checkLevelGuide(level)
    end

    if playerCoinRefresh then
        --货币刷新
        lt.GameEventManager:post(lt.GameEventManager.EVENT.PLAYER_COIN_REFRESH)
    end

    if diamondAdd then
        --钻石增加
        lt.GameEventManager:post(lt.GameEventManager.EVENT.DIAMOND_ADD)
    end

    if playerRuneCoinRefresh then
        --符文碎片刷新
        lt.GameEventManager:post(lt.GameEventManager.EVENT.PLAYER_RUNE_COIN_REFRESH)
    end

    if energyRefresh then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_ENERGY)
    end

    if saveGameInfo then
        -- 保存本地数据
        lt.PreferenceManager:setDefaultGameInfo()
    end

    if playerNameChange then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.NAME_EXCHANGE)

        -- 修改队伍中自己的名字
        if self._teamInfo then
            local serverId = self:getCurServerId()
            local playerId = self:getPlayerId()
            local playerName = self:getPlayerName()

            local teamPlayer = self._teamInfo:getTeamPlayer(serverId, playerId)
            if teamPlayer then
                teamPlayer:setPlayerName(playerName)
            end

            -- 队伍更新
            lt.GameEventManager:post(lt.GameEventManager.EVENT.TEAM_UPDATE, {status = 1})
        end
    end

    if guildCheck then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.GUILD_CHECK)
    end
end

function DataManager:onUpdate3V3Info(event)
    local s2cUpdate3V3Info = event.data
    local code = s2cUpdate3V3Info.code
    lt.CommonUtil.print("s2cUpdate3V3Info code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    if not self._player then
        return
    end

    -- lt.CommonUtil.print("s2cUpdate3V3Info content\n"..tostring(s2cUpdate3V3Info))

    local competitionScore           = s2cUpdate3V3Info.competition_score
    local accumulateCompetitionScore = s2cUpdate3V3Info.accumulate_competition_score
    local segmentId                  = s2cUpdate3V3Info.segment_id
    local segmentStarLevel           = s2cUpdate3V3Info.segment_star_level

    local preSegmentId        = self._player:getSegmentId()
    local preSegmentStarLevel = self._player:getSegmentStarLevel()

    self._player:setCompetitionScore(competitionScore)
    self._player:setAccumulateCompetitionScore(accumulateCompetitionScore)
    self._player:setSegmentId(segmentId)
    self._player:setSegmentStarLevel(segmentStarLevel)

    self._segmentChangeInfo = {preSegmentId = preSegmentId, preSegmentStarLevel = preSegmentStarLevel, segmentId = segmentId, segmentStarLevel = segmentStarLevel}

    -- 竞技段位更新
    lt.GameEventManager:post(lt.GameEventManager.EVENT.ARENA_3V3_UPDATE, {self._segmentChangeInfo})
end

function DataManager:getSegmentChangeInfo()
    return self._segmentChangeInfo
end

function DataManager:clearSegmentChangeInfo()
    self._segmentChangeInfo = nil
end

function DataManager:onUpdateAutoMatchState(event)
    local s2cUpdateAutoMatchState = event.data
    local code = s2cUpdateAutoMatchState.code
    lt.CommonUtil.print("s2cUpdateAutoMatchState code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end
    -- lt.CommonUtil.print("s2cUpdateAutoMatchState content\n"..tostring(s2cUpdateAutoMatchState))

    local targetId       = s2cUpdateAutoMatchState.target_id
    local autoMatchState = s2cUpdateAutoMatchState.auto_match_state

    self._player:setTargetId(targetId)
    self._player:setAutoMatchState(autoMatchState)

    lt.GameEventManager:post(lt.GameEventManager.EVENT.TEAM_UPDATE, {status = 1})
end

function DataManager:onUpdateBloodPool(event)
    local s2cUpdateBloodPool = event.data
    local code = s2cUpdateBloodPool.code
    -- lt.CommonUtil.print("s2cUpdateBloodPool code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cUpdateBloodPool content\n"..tostring(s2cUpdateBloodPool))

    local bloodPool = s2cUpdateBloodPool.blood_pool

    self._player:setBloodPool(bloodPool)

    lt.GameEventManager:post(lt.GameEventManager.EVENT.BLOOD_POOL_REFRESH)
end

DataManager._dailyCompetitiveScoreTable = nil

function DataManager:onNotifyDailyCompetitiveScoreInfo(event)
    local s2cNotifyDailyCompetitiveScoreInfo = event.data
    local code = s2cNotifyDailyCompetitiveScoreInfo.code
    lt.CommonUtil.print("s2cNotifyDailyCompetitiveScoreInfo code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cNotifyDailyCompetitiveScoreInfo content\n"..tostring(s2cNotifyDailyCompetitiveScoreInfo))

    self._dailyCompetitiveScoreTable = {}
    local s2cDailyCompetitiveScoreArray = s2cNotifyDailyCompetitiveScoreInfo.daily_competitive_score_array
    for _,s2cDailyCompetitiveScore in ipairs(s2cDailyCompetitiveScoreArray) do
        local id    = s2cDailyCompetitiveScore.id
        local value = s2cDailyCompetitiveScore.value
        local limit = s2cDailyCompetitiveScore.limit_value

        self._dailyCompetitiveScoreTable[id] = {value = value, limit = limit}
    end
end

function DataManager:getDailyCompetitiveScore(id)
    if not self._dailyCompetitiveScoreTable then
        return {}
    end

    return self._dailyCompetitiveScoreTable[id] or {}
end

function DataManager:isSelfPlayer(serverId, playerId)
    if not serverId or not playerId then
        return false
    end

    local selfServerId = self:getCurServerId()
    local selfPlayerId = self:getPlayerId()

    return selfServerId == serverId and selfPlayerId == playerId
end

function DataManager:getPlayer()
    return self._player
end

function DataManager:getPlayerId()
    if self._player then
        return self._player:getId()
    else
        return 0 
    end
end

function DataManager:getPlayerName()
    if self._player then
        return self._player:getName()
    else
        return ""
    end
end

function DataManager:getPlayerLevel()
    if self._player then
        return self._player:getLevel()
    else
        return 0 
    end
end

function DataManager:getVipLevel()
    if self._player then
        return self._player:getVipLevel()
    else
        return 0 
    end
end

function DataManager:getDiamond()
    if self._player then
        return self._player:getDiamond()
    else
        return 0 
    end
end
function DataManager:getGold()
    if self._player then
        return self._player:getGold()
    else
        return 0 
    end
end

function DataManager:getCoin()
    if self._player then
        return self._player:getCoin()
    else
        return 0 
    end
end

function DataManager:getGuildScore()
    if self._player then
        return self._player:getGuildScore()
    else
        return 0 
    end
end

function DataManager:getCompetitionScore()
    if self._player then
        return self._player:getCompetitionScore()
    else
        return 0 
    end
end

function DataManager:getRiskScore()
    if self._player then
        return self._player:getRiskScore()
    else
        return 0 
    end
end

function DataManager:getExperienceScore()
    if self._player then
        return self._player:getExperienceScore()
    else
        return 0 
    end
end

function DataManager:getGoodManPoint()
    if self._player then
        return self._player:getGoodManPoint()
    else
        return 0 
    end
end

function DataManager:getEnergy()
    if self._player then
        return self._player:getEnergy()
    else
        return 0 
    end
end

function DataManager:getHonorScore()
    if self._player then
        return self._player:getHonorScore()
    else
        return 0 
    end
end

function DataManager:getAccumulatePoint(modelId)
    if not self._player then
        return 0 
    end

    if modelId == lt.Constants.ITEM.COIN then
        return self._player:getAccumulateCoin()

    elseif modelId == lt.Constants.ITEM.GOLD then
        return self._player:getAccumulateGold()

    elseif modelId == lt.Constants.ITEM.GUILD_SCORE then
        return self._player:getAccumulateGuildScore()

    elseif modelId == lt.Constants.ITEM.COMPETION_SCORE then
        return self._player:getAccumulateCompetitionScore()

    elseif modelId == lt.Constants.ITEM.RISK_SCORE then
        return self._player:getAccumulateRiskScore()

    elseif modelId == lt.Constants.ITEM.EXPERIENCE_SCORE then
        return self._player:getAccumulateExperienceScore()
    
    elseif modelId == lt.Constants.ITEM.GOODMAN_SCORE then
        return self._player:getAccumulateGoodmanPoint()
    end

    return 0
end

function DataManager:getGuildId()
    if self._player then
        return self._player:getGuildId()
    else
        return 0
    end
end

--[[ ################################################## playerHero ##################################################
    玩家英雄
    ]]
function DataManager:onGetHeroResponse(event)
    local s2cGetHero = event.data
    local code = s2cGetHero.code
    lt.CommonUtil.print("s2cGetHero code "..code)
    
    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cGetHero content\n"..tostring(s2cGetHero))

    local scHero = s2cGetHero.hero

    local levelUp = false
    if not self._hero then
        self._hero = lt.Hero.new(scHero, self:getPlayerId())
    else
        local preLevel = self._hero:getLevel()

        self._hero:update(scHero)

        local curLevel = self._hero:getLevel()

        if curLevel > preLevel then
            levelUp = true
        end
    end

    -- 玩家数据更新
    lt.GameEventManager:post(lt.GameEventManager.EVENT.HERO_UPDATE, {levelUp = levelUp})
end

function DataManager:getHero()
    return self._hero
end

function DataManager:getOccupation()
    return self._hero:getOccupation()
end

function DataManager:getSex()
    return self._hero:getSex()
end

--[[ ################################################## skillNew ##################################################
    最新技能
    ]]
function DataManager:getNewSkillHeroTable()
    if not self._newSkillHeroTable then
        self._newSkillHeroTable = {}
    end

    return self._newSkillHeroTable
end

function DataManager:getNewSkillHeroIndexTable()
    if not self._newSkillHeroIndexTable then
        self._newSkillHeroIndexTable = {}
    end

    return self._newSkillHeroIndexTable
end

function DataManager:getNewSkillIdHeroTable()
    if not self._newSkillIdHeroTable then
        self._newSkillIdHeroTable = {}
    end

    return self._newSkillIdHeroTable
end

function DataManager:onGetNewSkillHeroResponse(event)
    local s2cOnGetNewSkillHeroResponse = event.data
    lt.CommonUtil.print("s2cOnGetNewSkillHeroResponse OK")

    local addSkillHeroArray = s2cOnGetNewSkillHeroResponse.add_skill_hero_array

    local newSkillHeroTable = self:getNewSkillHeroTable()

    local newSkillIdHeroTable = self:getNewSkillIdHeroTable()

    local newSkillHeroIndexTable = self:getNewSkillHeroIndexTable()

    for _,s2cNewSkillInfo in ipairs(addSkillHeroArray) do
        local newSkillInfo = lt.NewSkillInfo.new(s2cNewSkillInfo)

        local sequence = newSkillInfo:getSequence()
        local index = newSkillInfo:getIndex()
        local skillId  = newSkillInfo:getSkillId()

        newSkillHeroTable[sequence] = newSkillInfo
        newSkillHeroIndexTable[index] = newSkillInfo
        newSkillIdHeroTable[skillId] = newSkillInfo

    end
end

function DataManager:onUpdateNewSkillHeroResponse(event)
    local s2cOnUpdateNewSkillHeroResponse = event.data
    lt.CommonUtil.print("s2cOnUpdateNewSkillHeroResponse OK")
    
    local addSkillHeroArray = s2cOnUpdateNewSkillHeroResponse.add_skill_hero_array
    
    local newSkillHeroTable = self:getNewSkillHeroTable()

    local newSkillHeroIndexTable = self:getNewSkillHeroIndexTable()

    local newSkillIdHeroTable = self:getNewSkillIdHeroTable()

    for _,s2cNewSkillInfo in ipairs(addSkillHeroArray) do

        local newSkillInfo = lt.NewSkillInfo.new(s2cNewSkillInfo)

        local sequence = newSkillInfo:getSequence()

        local index = newSkillInfo:getIndex()

        local skillId  = newSkillInfo:getSkillId()

        newSkillHeroTable[sequence] = newSkillInfo

        newSkillHeroIndexTable[index] = newSkillInfo

        newSkillIdHeroTable[skillId] = newSkillInfo

    end

    local setSkillHeroArray = s2cOnUpdateNewSkillHeroResponse.set_skill_hero_array

    for _,s2cNewSkillInfo in ipairs(setSkillHeroArray) do

        local newSkillInfo = lt.NewSkillInfo.new(s2cNewSkillInfo)

        local sequence = newSkillInfo:getSequence()

        local index = newSkillInfo:getIndex()

        local skillId  = newSkillInfo:getSkillId()

        newSkillHeroTable[sequence] = newSkillInfo

        newSkillHeroIndexTable[index] = newSkillInfo

        newSkillIdHeroTable[skillId] = newSkillInfo

    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.SKILL_UPDATE)
end

--[[ ################################################## skillNew ##################################################
    天赋页
    ]]
function DataManager:getCurrentTalentPage()
    local player = self:getPlayer()
    return player:getCurrentTalentPage()
end


function DataManager:getTalentPageListTable()
    if not self._talentPageListTable then
        self._talentPageListTable = {}
    end

    return self._talentPageListTable
end

function DataManager:onGetTalentPageListResponse(event)
    local s2cOnGetTalentPageListResponse = event.data

    lt.CommonUtil.print("s2cOnGetTalentPageListResponse success")

    local talentPageListTable = self:getTalentPageListTable()

    local addTalentPageArray = s2cOnGetTalentPageListResponse.add_talent_page_array

    for _,s2cTalentPage in ipairs(addTalentPageArray) do
        local talentPageInfo = lt.PlayerTalentPage.new(s2cTalentPage)

        local page = talentPageInfo:getPage()

        talentPageListTable[page] = talentPageInfo
    end

end

function DataManager:onUpdateTalentPageListResponse(event)

    local s2cOnUpdateTalentPageListResponse = event.data

    lt.CommonUtil.print("s2cOnUpdateTalentPageListResponse success")

    local talentPageListTable = self:getTalentPageListTable()

    local addTalentPageArray = s2cOnUpdateTalentPageListResponse.add_talent_page_array

    for _,s2cTalentPage in ipairs(addTalentPageArray) do
        local talentPageInfo = lt.PlayerTalentPage.new(s2cTalentPage)

        local page = talentPageInfo:getPage()

        talentPageListTable[page] = talentPageInfo
    end

    local talentPageListTable = self:getTalentPageListTable()

    local setTalentPageArray = s2cOnUpdateTalentPageListResponse.set_talent_page_array

    for _,s2cTalentPage in ipairs(setTalentPageArray) do
        local talentPageInfo = lt.PlayerTalentPage.new(s2cTalentPage)

        local page = talentPageInfo:getPage()

        talentPageListTable[page] = talentPageInfo
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.SKILL_UPDATE)
end

--[[ ################################################## skillNew ##################################################
    最新天赋
    ]]
function DataManager:getCurrentTalentLevel(talentId)
    local talentListTable = self:getTalentListTable()

    local currentTalentListTable = talentListTable[self:getCurrentTalentPage()]

    local currentNum = 0

    if currentTalentListTable and currentTalentListTable[talentId] then
        currentNum = currentTalentListTable[talentId]:getLevel()
    end

    return currentNum
end

function DataManager:getTalent()
    return self._talent or nil
end

function DataManager:getTalentCount()
    local talentCount = 0

    local talentInfo = self:getTalent()

    if not talentInfo then
        return 0
    end

    local talentAllPoint = talentInfo:getTalent()

    local talentPageTable = self:getTalentPageListTable()

    local currentTalentPageInfo = nil

    if talentPageTable and talentPageTable[lt.DataManager:getCurrentTalentPage()] then
        currentTalentPageInfo = talentPageTable[lt.DataManager:getCurrentTalentPage()]
    else
        return 0
    end

    local costTalentPoint = currentTalentPageInfo:getCostTalent()

    local talentCount = talentAllPoint - costTalentPoint

    return talentCount
end

function DataManager:getCurrentMaxTalentCount()

    local talentInfo = self:getTalent()
    local itemExchangeNum = 0
    local num = 0
    if talentInfo then
        itemExchangeNum = talentInfo:getItemTimes()
        num = talentInfo:getCoinTimes()
    end

    local levelUpNum = 0

    local playerLevel = self:getPlayerLevel()

    if playerLevel >= 20 then

        levelUpNum = playerLevel - 19
    end

    if levelUpNum > 50 then
        levelUpNum = 50
    end

    local maxPointNum = itemExchangeNum + num + levelUpNum

    return maxPointNum
end

function DataManager:onGetTalentResponse(event)
    local s2cOnGetTalentResponse = event.data

    lt.CommonUtil.print("s2cOnGetTalentResponse code ")

    local talent = s2cOnGetTalentResponse.talent

    self._talent = lt.Talent.new(talent)

    lt.GameEventManager:post(lt.GameEventManager.EVENT.TALENT_REFRESH)
end


function DataManager:getTalentListTable()
    if not self._talentListTable then
        self._talentListTable = {}
    end

    return self._talentListTable
end

function DataManager:getTalentListTableByPage(page)

    local talentListTable = self:getTalentListTable()

    if talentListTable[page] then
        return talentListTable[page]
    else
        return {}
    end
end

function DataManager:onGetHeroTalentListResponse(event)
    local s2cOnGetHeroTalentListResponse = event.data

    lt.CommonUtil.print("s2cOnGetHeroTalentListResponse code ")

    local talentListTable = self:getTalentListTable()

    local addTalentArray = s2cOnGetHeroTalentListResponse.add_talent_array

    for _,s2cTalentInfo in ipairs(addTalentArray) do
        local talentInfo = lt.HeroTalent.new(s2cTalentInfo)
        local page = talentInfo:getPage()
        local talentId = talentInfo:getTalentId()

        if not isset(talentListTable, page) then
            talentListTable[page] = {}
        end

        talentListTable[page][talentId] = talentInfo
    end

end

function DataManager:onUpdateHeroTalentListResponse(event)
    local s2cOnUpdateHeroTalentListResponse = event.data

    lt.CommonUtil.print("s2cOnUpdateHeroTalentListResponse code ")

    local talentListTable = self:getTalentListTable()

    local addTalentArray = s2cOnUpdateHeroTalentListResponse.add_talent_array

    for _,s2cTalentInfo in ipairs(addTalentArray) do
        local talentInfo = lt.HeroTalent.new(s2cTalentInfo)
        local page = talentInfo:getPage()
        local talentId = talentInfo:getTalentId()

        if not isset(talentListTable, page) then
            talentListTable[page] = {}
        end

        talentListTable[page][talentId] = talentInfo
    end

    local setTalentArray = s2cOnUpdateHeroTalentListResponse.set_talent_array

    for _,s2cTalentInfo in ipairs(setTalentArray) do
        local talentInfo = lt.HeroTalent.new(s2cTalentInfo)
        local page = talentInfo:getPage()
        local talentId = talentInfo:getTalentId()

        if not isset(talentListTable, page) then
            talentListTable[page] = {}
        end

        talentListTable[page][talentId] = talentInfo
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.SKILL_UPDATE)
end
--[[ ################################################## playerBag ##################################################
    玩家背包（无实例 只有接口）
    ]]
-- 获取背包中装备数量
function DataManager:getBagSize()
    local sizeEquipment = self:getBagSizeEquipment()
    local sizeItem      = self:getBagSizeItem()

    return sizeEquipment + sizeItem
end

function DataManager:getBagCapacity()
    return self:getPlayer():getBagCapacity()
end

-- 获得背包剩余空间
function DataManager:getBagFreeSize()
    local bagCapacity = self:getBagCapacity()
    local bagSize     = self:getBagSize()
    local freeSize = bagCapacity - bagSize

    return math.max(0, freeSize)
end

function DataManager:getBagSizeEquipment()
    local equipmentTable = self:getEquipmentTable()
    local count = 0
    for _,playerEquipment in pairs(equipmentTable) do
        -- 排除装备中的
        if playerEquipment then
            count = count + 1
        end
    end

    return count
end

-- 获取背包中道具数量
function DataManager:getBagSizeItem()
    local itemTable = self:getItemTable()
    local count = 0
    for _,playerItem in pairs(itemTable) do
        count = count + 1
    end
    
    return count
end

--[[ ################################################## playerEquipment ##################################################
    玩家装备
    结构 table[equipmentid] = playerEquipment
    结构 table[equipmentModelId] = {equipmentid, ...}
    ]]
function DataManager:getEquipmentTable()
    if not self._equipmentTable then
        self._equipmentTable = {}
    end

    return self._equipmentTable
end

function DataManager:getEquipmentModelTable()
    if not self._equipmentModelTable then
        self._equipmentModelTable = {}
    end

    return self._equipmentModelTable
end

function DataManager:getNewEquipmentTabel()
    if not self._newEquipmentTable then
        self._newEquipmentTable = {}
    end

    return self._newEquipmentTable
end

function DataManager:clearNewEquipmentTabel()
    self._newEquipmentTable = {}
end

function DataManager:getPlayerEquipmentTable()
    local playerEquipmentTable = {}

    local equipmentTable = self:getEquipmentTable()
    for k,v in pairs(equipmentTable) do
        playerEquipmentTable[k] = v
    end
    local slotArray = self:getPlayerEquipmentSlotTable()
    for k,v in pairs(slotArray) do
        playerEquipmentTable[v:getId()] = v
    end
    local storageArray = self:getStorageAllEquipmentTable()
    for k,v in pairs(storageArray) do
        playerEquipmentTable[v:getId()] = v
    end

    --临时装备
    local tempEquipTable = self:getTempEquipTable()
    for k,v in pairs(tempEquipTable) do
        playerEquipmentTable[v:getId()] = v
    end

    return playerEquipmentTable
end

function DataManager:onGetEquipmentListResponse(event)
    local s2cGetEquipmentList = event.data
    lt.CommonUtil.print("s2cGetEquipmentList code", s2cGetEquipmentList.code)

    --print("andykktest "..tostring(s2cGetEquipmentList))

    -- 道具列表
    local equipmentTable = self:getEquipmentTable()
    local equipmentModelTable = self:getEquipmentModelTable()
    local scEquipmentArray = s2cGetEquipmentList.equipment_array
    for _,scEquipment in ipairs(scEquipmentArray) do
        local playerEquipment = lt.PlayerEquipment.new(scEquipment)

        local id = playerEquipment:getId()

        local modelId = playerEquipment:getModelId()

        equipmentTable[id] = playerEquipment

        if not isset(equipmentModelTable, modelId) then
            equipmentModelTable[modelId] = {}
        end

        equipmentModelTable[modelId][id] = 1
    end
end

function DataManager:onUpdateEquipmentListResponse(event)
    local s2cUpdateEquipmentList = event.data
    lt.CommonUtil.print("s2cUpdateEquipmentList code " .. s2cUpdateEquipmentList.code)

    local equipmentTable = self:getEquipmentTable()
    local equipmentModelTable = self:getEquipmentModelTable()

    local newItemArray = self:getNewItemArray()--新装备比身上战力高的自动弹框的array

    local equipmentAdd = false

    local popFlag = false

    local scAddEquipmentArray = s2cUpdateEquipmentList.add_equipment_array
    for _, scEquipment in ipairs(scAddEquipmentArray) do
        local playerEquipment = lt.PlayerEquipment.new(scEquipment)

        local id = playerEquipment:getId()
        local modelId = playerEquipment:getModelId()

        equipmentTable[id] = playerEquipment

        if not isset(equipmentModelTable, modelId) then
            equipmentModelTable[modelId] = {}
        end
 
        --新装备
        local newEquipmentTabel = self:getNewEquipmentTabel()
        newEquipmentTabel[id] = true

        equipmentModelTable[modelId][id] = 1

        -- 装备增加标记
        equipmentAdd = true

        local equipmentInfo = playerEquipment:getEquipmentInfo()

        local equipmentFightNum = playerEquipment:getBattlePoint()

        local occupationArray = equipmentInfo:getOccupationIdArray()

        local occupationId = self:getHero():getOccupation()
        local playerLevel = self:getPlayer():getLevel()

        local equipmentSlotTable = self:getPlayerEquipmentSlotTable()

        for i = lt.Constants.EQUIPMENT_TYPE.WEAPON, lt.Constants.EQUIPMENT_TYPE.ORNAMENT do
            local type = i
            if type == equipmentInfo:getType() then
                

                local fightNum = 0
                if equipmentSlotTable[type] then
                    fightNum = equipmentSlotTable[type]:getBattlePoint()
                    
                end

                for i = 1, #occupationArray do

                    if occupationId == occupationArray[i] then

                        if equipmentFightNum > fightNum then
                            local requireLevel = playerEquipment:getRequireLevel()

                            if playerLevel >= requireLevel then
                                lt.CommonUtil.print("符合条件")
                                playerEquipment.itemType = 2
                                newItemArray[#newItemArray + 1] = playerEquipment

                                popFlag = true
                            end
                        end
                    end
                end
            end
        end
    end

    local scAddEquipmentArray2 = s2cUpdateEquipmentList.add_equipment_array_2
    for _, scEquipment in ipairs(scAddEquipmentArray2) do
        -- 卸下装备走这里 防止new标记
        local playerEquipment = lt.PlayerEquipment.new(scEquipment)

        local id = playerEquipment:getId()
        local modelId = playerEquipment:getModelId()

        equipmentTable[id] = playerEquipment

        if not isset(equipmentModelTable, modelId) then
            equipmentModelTable[modelId] = {}
        end

        -- 装备增加标记
        equipmentAdd = true
    end

    local scSetEquipmentArray = s2cUpdateEquipmentList.set_equipment_array
    for _, scEquipment in ipairs(scSetEquipmentArray) do
        local playerEquipment = lt.PlayerEquipment.new(scEquipment)

        local id = playerEquipment:getId()
        local modelId = playerEquipment:getModelId()



        equipmentTable[id] = playerEquipment
        
        if not isset(equipmentModelTable, modelId) then
            equipmentModelTable[modelId] = {}
        end

        equipmentModelTable[modelId][id] = 1
    end

    local scDelEquipmentIdArray = s2cUpdateEquipmentList.del_equipment_id_array
    for _, id in ipairs(scDelEquipmentIdArray) do
        equipmentTable[id] = nil
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.BAG_EQUIPMENT_REFRESH, {refresh = true})

    if equipmentAdd then
        -- 背包容量引导
        lt.GuideManager:checkSpecialGuide(lt.GuideInfo.SPECIAL_IDX.BAG_FULL)
    end

    if popFlag then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.NEW_ITEM_FLAG)
    end
end

function DataManager:onGetEquipmentSlotResponse(event)
    local s2cUpdateEquipmentSlot = event.data
    lt.CommonUtil.print("s2cUpdateEquipmentSlot code "..s2cUpdateEquipmentSlot.code)

    local weaponUpdate = false

    local equipmentSlot = lt.PlayerEquipmentSlot.new(s2cUpdateEquipmentSlot.equipment_slot)
    
    self._slotTable = {}
    if equipmentSlot:getWeapon() ~= nil then
        local weapon = lt.PlayerEquipment.new(equipmentSlot:getWeapon())
        weapon:setSelfUnlock()
        if weapon:getId() == 0 then
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.WEAPON] = nil
        else
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.WEAPON] = weapon
        end

        weaponUpdate = true
    end

    if equipmentSlot:getExclusive() ~= nil then
        local exclusive = lt.PlayerEquipment.new(equipmentSlot:getExclusive())
        exclusive:setSelfUnlock()
        if exclusive:getId() == 0 then
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.ASSISTANT] = nil
        else
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.ASSISTANT] = exclusive
        end
        
        weaponUpdate = true
    end
    
    if equipmentSlot:getHelmet() ~= nil then 
        local helmet = lt.PlayerEquipment.new(equipmentSlot:getHelmet())
        if helmet:getId() == 0 then
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.HELMET] = nil
        else
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.HELMET] = helmet
        end
    end
    if equipmentSlot:getClothes() ~= nil then 
        local clothes = lt.PlayerEquipment.new(equipmentSlot:getClothes())
        if clothes:getId() == 0 then
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.CLOTHES] = nil
        else
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.CLOTHES] = clothes
        end
    end
    if equipmentSlot:getTrousers() ~= nil then
        local trousers = lt.PlayerEquipment.new(equipmentSlot:getTrousers())
        if trousers:getId() == 0 then
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.TROUSERS] = nil
        else
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.TROUSERS] = trousers
        end
    end
    if equipmentSlot:getShoes() ~= nil then 
        local shoes = lt.PlayerEquipment.new(equipmentSlot:getShoes())
        if shoes:getId() == 0 then
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.SHOES] = nil
        else
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.SHOES] = shoes
        end
    end
    if equipmentSlot:getNecklace() ~= nil then 
        local necklace = lt.PlayerEquipment.new(equipmentSlot:getNecklace())
        if necklace:getId() == 0 then
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.NECKLACE] = nil
        else
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.NECKLACE] = necklace
        end
    end
    if equipmentSlot:getRing() ~= nil then
        local ring = lt.PlayerEquipment.new(equipmentSlot:getRing())
        if ring:getId() == 0 then
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.RING] = nil
        else
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.RING] = ring
        end
    end
    if equipmentSlot:getOrnament() ~= nil then
        local ornament = lt.PlayerEquipment.new(equipmentSlot:getOrnament())
        if ornament:getId() == 0 then
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.BELT] = nil
        else
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.BELT] = ornament
        end
    end
    if equipmentSlot:getHoly() ~= nil then 
        local holy = lt.PlayerEquipment.new(equipmentSlot:getHoly())
        if holy:getId() == 0 then
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.ORNAMENT] = nil
        else
            self._slotTable[lt.Constants.EQUIPMENT_TYPE.ORNAMENT] = holy
        end
    end

    self:calPlayerEquipmentSuit()
    
    lt.GameEventManager:post(lt.GameEventManager.EVENT.EQUIPMENT_SOLT_UPDATE)

    if weaponUpdate then
        lt.PreferenceManager:setWeaponInfo()
        lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_RUNE_SKILL)
    end
end

function DataManager:getEquipment(equipmentId)
    local equipmentTable = self:getEquipmentTable()
    return equipmentTable[equipmentId]
end

function DataManager:getPlayerEquipment(equipmentId)
    local playerEquipmentTable = self:getPlayerEquipmentTable()
    return playerEquipmentTable[equipmentId]
end

function DataManager:getAllEquipmentArray(calJudge)
    local equipmentArray = {}
    for _,playerEquipment in pairs(self._equipmentTable) do
        if calJudge then
            -- 计算评价
            playerEquipment:calJudge()
        end

        equipmentArray[#equipmentArray + 1] = playerEquipment
    end

    return equipmentArray
end

function DataManager:getAllEquipmentCount()
    local equipmentTable = self:getEquipmentTable()

    return lt.CommonUtil:calcHashTableLength(equipmentTable)
end

function DataManager:getPlayerEquipmentSlotTable()
    return self._slotTable or {}
end

function DataManager:getEquipmentCount(itemModelId)
    local count = 0
    local equipmentTable1 = self:getEquipmentTable()
    for k,v in pairs(equipmentTable1) do
        if v:getModelId() == itemModelId then
            count = count + 1
        end
    end
    local equipmentTable2 = self:getPlayerEquipmentSlotTable()
    for k,v in pairs(equipmentTable2) do
        if v:getModelId() == itemModelId then
            count = count + 1
        end
    end
    return count
end

-- 计算套装情况
function DataManager:calPlayerEquipmentSuit()
    self._suitTable = {}

    local slotTable = self:getPlayerEquipmentSlotTable()
    for slot,playerEquipment in pairs(slotTable) do
        local suitId = playerEquipment:getSuitId()

        if suitId ~= 0 then
            local modelId = playerEquipment:getModelId()

            if not isset(self._suitTable, suitId) then
                self._suitTable[suitId] = {}
            end

            self._suitTable[suitId][modelId] = true
        end
    end
end

function DataManager:getSuitTable()
    return self._suitTable or {}
end

function DataManager:getEquipmentSlot(type)
    local equipmentSlotTable = self:getPlayerEquipmentSlotTable()
    return equipmentSlotTable[type]
end

function DataManager:getPlayerEquipmentTalentTable(otherPlayerEquipmentInfo)
    local playerEquipmentTalentTable = {}

    local equipmentSlot = nil

    if otherPlayerEquipmentInfo then                                                                                                                            
        equipmentSlot = otherPlayerEquipmentInfo:getWearEquipTable()
    else
        equipmentSlot = self:getPlayerEquipmentSlotTable()
    end

    for type,playerEquipment in pairs(equipmentSlot) do
        -- 技能
        local extraSkillArray = playerEquipment:getAdditionalSkillsArray()

        if #extraSkillArray > 0 then

            for _,info in ipairs(extraSkillArray) do

                -- position = type
                -- table.insert(position, type)

                local id    = info.id
                local value = info.value
                local realSkillId = id
                if playerEquipmentTalentTable[id] then
                    -- playerEquipmentTalentTable[id] = playerEquipmentTalentTable[id] + value
                    local playerEquipmentTalent = playerEquipmentTalentTable[id]
                    playerEquipmentTalent.value = playerEquipmentTalent.value + value
                    table.insert(playerEquipmentTalent.position, type)
                else
                    playerEquipmentTalentTable[id] = {id = id, value = value, position={type}}
                end
            end

        end
    end

    return playerEquipmentTalentTable
end

function DataManager:getPlayerEquipmentTalentById(id,otherPlayerEquipmentInfo)
    local playerEquipmentTalentTable = self:getPlayerEquipmentTalentTable(otherPlayerEquipmentInfo)

    if playerEquipmentTalentTable[id] then
        return playerEquipmentTalentTable[id]
    else
        return nil
    end
end

--判断符文里面有没有当前符文
function DataManager:getRuneListTableHasCurrentRune(index)
    local runeTable = self:getRuneListTableByPage(self:getPlayer():getCurrentRunePage())

    local runeLevel = 0
    local runeSequence = nil

    for _,info in pairs(runeTable) do
        local equipModelId = info:getModelId()

        if equipModelId > 0 then
            local runeTalentInfo = lt.CacheManager:getRuneTalentInfo(equipModelId)

            if runeTalentInfo then
                local playerIndex = runeTalentInfo:getIndex()

                if index == playerIndex then

                    local playerRuneInfo = lt.CacheManager:getRuneInfo(equipModelId)

                    runeLevel = playerRuneInfo:getLevel()
                    runeSequence = playerRuneInfo:getSequence()

                end
            end

        end
    end

    return runeLevel, runeSequence

end

--[[ ################################################## tempbaglist ##################################################
    临时背包
    ]]
function DataManager:getTempbagTable()
    if not self._tempbagTable then
        self._tempbagTable = {}
    end

    return self._tempbagTable
end

function DataManager:getTempItemTable()
    if not self._tempItemTable then
        self._tempItemTable = {}
    end

    return self._tempItemTable
end

function DataManager:getTempEquipTable()
    if not self._tempEquipTable then
        self._tempEquipTable = {}
    end

    return self._tempEquipTable
end

function DataManager:onGetTempBagListResponse(event)
    local s2cOnGetTempBagList = event.data
    lt.CommonUtil.print("s2cOnGetTempBagList code "..s2cOnGetTempBagList.code)

    local tembagTable = self:getTempbagTable()

    local tempItemTable = self:getTempItemTable()
    local tempEquipTable = self:getTempEquipTable()

    local itemArray = s2cOnGetTempBagList.item_array

    for _,scItem in ipairs(itemArray) do
        local playerItem = lt.PlayerItem.new(scItem)
        playerItem.type = lt.GameIcon.TYPE.PLAYER_ITEM
        local id = playerItem:getId()
        local modelId = playerItem:getModelId()

        tembagTable[id] = playerItem
        tempItemTable[id] = playerItem
    end

    local equipArray = s2cOnGetTempBagList.equipment_array

    for _,scEquip in ipairs(equipArray) do
        local playerEquipment = lt.PlayerEquipment.new(scEquip)
        playerEquipment.type = lt.GameIcon.TYPE.PLAYER_EQUIPMENT
        local id = playerEquipment:getId()

        tembagTable[id] = playerEquipment
        tempEquipTable[id] = playerEquipment
    end
end

function DataManager:onUpdateTempBagListResponse(event)
    local s2conUpdateTempBagList = event.data
    lt.CommonUtil.print("s2conUpdateTempBagList code "..s2conUpdateTempBagList.code)

    local tembagTable = self:getTempbagTable()

    local tempItemTable = self:getTempItemTable()
    local tempEquipTable = self:getTempEquipTable()

    local flag = false

    local addItemArray = s2conUpdateTempBagList.add_item_array

    for _,scaddItem in ipairs(addItemArray) do
        local playerItem = lt.PlayerItem.new(scaddItem)
        playerItem.type = lt.GameIcon.TYPE.PLAYER_ITEM
        local id = playerItem:getId()
        local modelId = playerItem:getModelId()

        tembagTable[id] = playerItem
        tempItemTable[id] = playerItem

        flag = true
    end

    local setItemArray = s2conUpdateTempBagList.set_item_array

    for _,scsetItem in ipairs(setItemArray) do
        local playerItem = lt.PlayerItem.new(scsetItem)
        playerItem.type = lt.GameIcon.TYPE.PLAYER_ITEM
        local id = playerItem:getId()
        local modelId = playerItem:getModelId()

        tembagTable[id] = playerItem
        tempItemTable[id] = playerItem
    end

    local delItemArray = s2conUpdateTempBagList.del_item_id_array
    for _,id in ipairs(delItemArray) do

        tembagTable[id] = nil
        tempItemTable[id] = nil
    end

    local addEquipArray = s2conUpdateTempBagList.add_equipment_array
    for _,scaddEquip in ipairs(addEquipArray) do
        local playerEquipment = lt.PlayerEquipment.new(scaddEquip)
        local id = playerEquipment:getId()
        playerEquipment.type = lt.GameIcon.TYPE.PLAYER_EQUIPMENT

        tembagTable[id] = playerEquipment
        tempEquipTable[id] = playerEquipment
        flag = true
    end

    local setEquipArray = s2conUpdateTempBagList.set_equipment_array
    for _,scsetEquip in ipairs(setEquipArray) do
        local playerEquipment = lt.PlayerEquipment.new(scsetEquip)
        local id = playerEquipment:getId()
        playerEquipment.type = lt.GameIcon.TYPE.PLAYER_EQUIPMENT
        
        tembagTable[id] = playerEquipment
        tempEquipTable[id] = playerEquipment
    end

    local delEquipArray = s2conUpdateTempBagList.del_equipment_id_array

    for _,id in ipairs(delEquipArray) do

        tembagTable[id] = nil
        tempEquipTable[id] = nil
    end

    if flag then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.TEMP_BAG_ADDITEM)
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.TEMP_BAG_UPDATE)
end

-- ################################################## 生活技能 LifeSkill ##################################################
function DataManager:getLifeSkillTable()
    if not self._lifeSkillTable then
        self._lifeSkillTable = {}
    end

    return self._lifeSkillTable
end

function DataManager:getLifeSkillInfoBySkillId(skillId)
    local table = self:getLifeSkillTable()

    return table[skillId]
end

function DataManager:onGetLifeSkillListResponse(event)
    local s2cOnGetLifeSkillListResponse = event.data

    lt.CommonUtil.print("s2cOnGetLifeSkillListResponse code ===="..s2cOnGetLifeSkillListResponse.code)

    local lifeSkillArray = s2cOnGetLifeSkillListResponse.life_skill_array
    local lifeSkillTable = self:getLifeSkillTable()

    for _,s2cLifeSkill in ipairs(lifeSkillArray) do
        local lifeSkillInfo = lt.LifeSkillInfo.new(s2cLifeSkill)
        local skillId = lifeSkillInfo:getSkillId()
        lifeSkillTable[skillId] = lifeSkillInfo
    end
end

--[[ ################################################## 好友 playerFriend ##################################################
    玩家好友
    结构 table[id] = playerFriend
    ]]
function DataManager:getFriendTable()
    if not self._friendTable then
        self._friendTable = {}
    end

    return self._friendTable
end

function DataManager:getFriendById(friendId)
    local friendTable = self:getFriendTable()
    return friendTable[friendId]
end

function DataManager:getFriendRequestTable()
    if not self._friendRequestTable then
        self._friendRequestTable = {}
    end

    return self._friendRequestTable
end

function DataManager:onGetFriendListResponse(event)
    local s2cGetFriendList = event.data
    local code = s2cGetFriendList.code
    lt.CommonUtil.printf("s2cGetFriendList code %d", code)

    -- 好友列表
    local friendTable = self:getFriendTable()
    local playerId = self:getPlayerId()
    local scfriendArray = s2cGetFriendList.friend_array
    for _,scFriend in ipairs(scfriendArray) do
        local playerFriend = lt.PlayerFriend.new(scFriend)
        local playerFriendId = playerFriend:getId()

        if playerFriendId ~= playerId then
            friendTable[playerFriendId] = playerFriend
        end
    end

    -- 好友请求
    local friendRequestTable = self:getFriendRequestTable()
    local scfriendRequestArray = s2cGetFriendList.friend_request_array
    for _,scFriendRequest in ipairs(scfriendRequestArray) do
        local playerFriendRequest = lt.PlayerFriendRequest.new(scFriendRequest)

        friendRequestTable[playerFriendRequest:getId()] = playerFriendRequest
    end

    -- 好友请求通知
    --lt.GameTopViewManager:checkFriendRequest()
end

function DataManager:setPlayerFriendOnLineTime(playerFriendId, time)
    if not self._playerFriendOnLineTimeTable then
        self._playerFriendOnLineTimeTable = {}
    end

    self._playerFriendOnLineTimeTable[playerFriendId] = time
end

function DataManager:getPlayerFriendOnLineTime(playerFriendId)
    if not self._playerFriendOnLineTimeTable then
        self._playerFriendOnLineTimeTable = {}
    end

    return self._playerFriendOnLineTimeTable[playerFriendId] or 0
end

function DataManager:onUpdateFriendListResponse(event)
    local s2cUpdateFriendList = event.data
    lt.CommonUtil.print("onUpdateFriendListResponse")

    -- 好友
    local friendTable = self:getFriendTable()
    local playerId = self:getPlayerId()

    local scAddFriendArray = s2cUpdateFriendList.add_friend_array
    local friendAdd = false
    local friendUpdate = 0
    local friendId = nil
    local friendName = nil
    for _,scFriend in ipairs(scAddFriendArray) do
        local playerFriend = lt.PlayerFriend.new(scFriend)
        local playerFriendId = playerFriend:getId()

        if playerFriendId ~= playerId then
            friendTable[playerFriend:getId()] = playerFriend
            friendAdd = true
            friendUpdate = 2
            friendId = playerFriend:getId()
            friendName = playerFriend:getName()
            -- 去除已经添加的
            local friendRequestSendTable = self:getFriendRequestSendTable()
            friendRequestSendTable[playerFriend:getId()] = nil
        end
    end
    if friendAdd then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.FRIEND_ADD)
        lt.CommonUtil.print("addFrriend")
        if friendId then
            -- local strInfo = lt.StringManager:getString("STRING_FRIEND_ADD_FRIEND")
            -- lt.SocketApi:chat(lt.Constants.CHAT_TYPE.FRIEND,friendId, strInfo)
        end
    end
    local scSetFriendArray = s2cUpdateFriendList.set_friend_array
    for _,scFriend in ipairs(scSetFriendArray) do
        local playerFriend = lt.PlayerFriend.new(scFriend)

        local playerFriendId = playerFriend:getId()
        -- 是否上线
        local prePlayerFriend = friendTable[playerFriendId]
        if prePlayerFriend then
            local currentTime = lt.CommonUtil:getCurrentTime()
            local preTime     = self:getPlayerFriendOnLineTime(playerFriendId)
            if currentTime - preTime > 300 then
                self:setPlayerFriendOnLineTime(playerFriendId, currentTime)

                -- 好友上线
                if prePlayerFriend:getStatus() == 0 and playerFriend:getStatus() ~= 0 then
                    lt.GameTopViewManager:friendOnline(playerFriendId)
                end
            end
        end

        friendTable[playerFriendId] = playerFriend
        friendUpdate = math.max(friendUpdate, 1)
    end
    local scDelFriendIdArray = s2cUpdateFriendList.del_friend_id_array
    for _,scFriendId in ipairs(scDelFriendIdArray) do
        lt.CommonUtil.print("delFrriend")
        friendTable[scFriendId] = nil
        friendUpdate = 2
        lt.GameEventManager:post(lt.GameEventManager.EVENT.FRIEND_DELETE)
        lt.ChatManager:clearChatMessage(scFriendId)
    end

    if friendUpdate == 2 then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.FRIEND_UPDATE)
    elseif friendUpdate == 1 then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.FRIEND_UPDATE)
    end

    -- 好友请求
    local friendRequestTable = self:getFriendRequestTable()
    local scAddFriendRequestArray = s2cUpdateFriendList.add_friend_request_array
    for _,scFriend in ipairs(scAddFriendRequestArray) do
        local playerFriend = lt.PlayerFriend.new(scFriend)
        friendRequestTable[playerFriend:getId()] = playerFriend

        -- 有新的好友请求
        lt.GameEventManager:post(lt.GameEventManager.EVENT.FRIEND_REQUEST)
    end
    local scSetFriendRequestArray = s2cUpdateFriendList.set_friend_request_array
    for _,scFriend in ipairs(scSetFriendRequestArray) do
        local playerFriend = lt.PlayerFriend.new(scFriend)
        friendRequestTable[playerFriend:getId()] = playerFriend
    end
    local scDelFriendRequestIdArray = s2cUpdateFriendList.del_friend_request_id_array
    for _,scFriendRequestId in ipairs(scDelFriendRequestIdArray) do
        friendRequestTable[scFriendRequestId] = nil

        -- 好友请求处理了
        lt.GameEventManager:post(lt.GameEventManager.EVENT.FRIEND_REQUEST)
    end
end

function DataManager:onRequestFriendResponse(event)
    local s2cOnRequestFriendResponse = event.data
    local code = s2cOnRequestFriendResponse.code
    lt.CommonUtil.print("s2cOnRequestFriendResponse code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        if code == lt.SocketConstants.CODE_REQUEST_FRIEND_ALREADY_EXISTS then
        else
            if code == lt.SocketConstants.CODE_ADD_FRIEND_MAX_MYSELF_COUNT then
                lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_FRIEND_COUNT_ISMAX"))
            elseif code == lt.SocketConstants.CODE_ADD_FRIEND_MAX_OPPOSITE_COUNT then
                lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_FRIEND_PEOPLE_COUNT_ISMAX"))
            end
            return
        end
    end

    local idStringPair = s2cOnRequestFriendResponse.player_array

    for i,v in ipairs(idStringPair) do
        local id = v.id
        local value = v.value
        local strInfo = string.format(lt.StringManager:getString("STRING_FRIEND_INFO_19"),value)
        lt.NoticeManager:addMessage(strInfo)
    end
end

function DataManager:onRemoveFriendResponse(event)
    local s2cOnRemoveFriendResponse = event.data

    lt.CommonUtil.print("s2cOnRemoveFriendResponse code ", s2cOnRemoveFriendResponse.code)

    --好友删除统一处理
    local idStringPair = s2cOnRemoveFriendResponse.player_array

    for i,v in ipairs(idStringPair) do
        
        local id = v.id
        local value = v.value
        local strInfo = string.format(lt.StringManager:getString("STRING_FRIEND_INFO_26"),value)
        lt.NoticeManager:addMessage(strInfo)
    end
end

--记录自己上次世界发言时间
function DataManager:setChatWorldTime(time)
    self._chatWorldTime = time
end

function DataManager:getChatWorldTime()
    return self._chatWorldTime
end

function DataManager:setChatTrumpetTime(time)
    self._chatTrumpetTime = time
end

function DataManager:getChatTrumpetTime()
    return self._chatTrumpetTime
end

--记录上次选择世界聊天频道
function DataManager:setChatChannel(channel)
    self._chatChannel = channel
end

function DataManager:getChatChannel()
    return self._chatChannel
end

function DataManager:getChatSystemTable()
    if not self._chatSystemTable then
        self._chatSystemTable = {}
    end

    return self._chatSystemTable
end

function DataManager:addSystemChatInfo(chatInfo)
    local chatSystemTable = self:getChatSystemTable()
    chatSystemTable[#chatSystemTable+1] = chatInfo
    if #chatSystemTable > 30 then
        table.remove(chatSystemTable,1)
    end
end

function DataManager:getChatWorldTable()
    if not self._chatWorldTable then
        self._chatWorldTable = {}
    end
    return self._chatWorldTable
end

function DataManager:addWorldChatInfo(chatInfo)

    local chatWorldTable = self:getChatWorldTable()
    chatWorldTable[#chatWorldTable+1] = chatInfo
    if #chatWorldTable > 30 then
        table.remove(chatWorldTable,1)
    end
end

function DataManager:getChatGuildTable()
    if not self._chatGuildTable then
        self._chatGuildTable = {}
    end

    return self._chatGuildTable
end

function DataManager:clearChatGuildTable()
    self._chatGuildTable = {}
end

function DataManager:addGuildChatInfo(chatInfo)
    local chatGuildTable = self:getChatGuildTable()
    chatGuildTable[#chatGuildTable+1] = chatInfo
    if #chatGuildTable > 30 then
        table.remove(chatGuildTable,1)
    end
end

function DataManager:getChatTeamTable()
    if not self._chatTeamTable then
        self._chatTeamTable = {}
    end

    return self._chatTeamTable
end

function DataManager:addTeamChatInfo(chatInfo)
    local chatTeamTable = self:getChatTeamTable()
    chatTeamTable[#chatTeamTable+1] = chatInfo
    if #chatTeamTable > 30 then
        table.remove(chatTeamTable,1)
    end
end

function DataManager:getChatCurrentTable()
    if not self._chatCurrentTable then
        self._chatCurrentTable = {}
    end

    return self._chatCurrentTable
end

function DataManager:addCurrentChatInfo(chatInfo)
    local chatCurrentTable = self:getChatCurrentTable()
    chatCurrentTable[#chatCurrentTable+1] = chatInfo
    if #chatCurrentTable > 30 then
        table.remove(chatCurrentTable,1)
    end
end

function DataManager:getChatFriendTable()
    if not self._chatFriendTable then
        self._chatFriendTable = {}
    end

    return self._chatFriendTable
end

function DataManager:getChatFriendTableById(senderId)
    local chatFriendTable = self:getChatFriendTable()

    return chatFriendTable[senderId]
end

function DataManager:getChatAnswerPartyTable()
    if not self._chatAnswerPartyTable then
        self._chatAnswerPartyTable = {}
    end

    return self._chatAnswerPartyTable
end

function DataManager:addAnswerPartyChatInfo(chatInfo)
    local chatTable = self:getChatAnswerPartyTable()
    chatTable[#chatTable+1] = chatInfo
    if #chatTable >= 9 then
        table.remove(chatTable,1)
    end
end

function DataManager:clearChatAnswerPartyTable()
    self._chatAnswerPartyTable = {}
end

function DataManager:setChatAnswerPartyIndex(index)
    self._answerPartyIndex = index
end

function DataManager:getChatAnswerPartyIndex()
    return self._answerPartyIndex or 0
end

function DataManager:getRunningNoticeChatInfo()--跑马灯公告
    if not self._chatrunningNoticeTable then
        self._chatrunningNoticeTable = {}
    end

    return self._chatrunningNoticeTable
end

function DataManager:addRunningNoticeChatInfo(chatInfo)
    local chatrunningNoticeTable = self:getRunningNoticeChatInfo()
    chatrunningNoticeTable[1] = chatInfo
    chatrunningNoticeTable[#chatrunningNoticeTable+1] = chatInfo
    -- if #chatrunningNoticeTable > 30 then
    --     table.remove(chatrunningNoticeTable,1)
    -- end
end

function DataManager:onChatResponse(event)
    local s2cOnChatResponse = event.data
    lt.CommonUtil.print("DataManager.s2cOnChatResponse code==== " .. s2cOnChatResponse.code)
    -- lt.CommonUtil.print("DataManager.s2cOnChatResponse content\n" .. tostring(s2cOnChatResponse))

    local chatFriendTable = self:getChatFriendTable()
    if s2cOnChatResponse.code == 0 then
        local chatInfo = lt.Chat.new()
        chatInfo:initWithRow(s2cOnChatResponse)
        local channel = chatInfo:getChannel()
        local senderName = chatInfo:getSenderName()
        local subType = chatInfo:getSubType()
        local isAudio = chatInfo:getIsAudio()
        local senderId = chatInfo:getSenderId()

        -- if isAudio and senderId == self:getPlayerId() then
        --     local ownChatInfo = lt.AudioMsgManager:getChatInfoByLoaclId(chatInfo:getLocalAudioId())
        --     if ownChatInfo then
        --         ownChatInfo:setMessage(chatInfo:getMessage())
        --         lt.GameEventManager:post(lt.GameEventManager.EVENT.AUDIO_CHAT_UPDATE,{chatInfo=ownChatInfo})
        --     end

        --     if channel == lt.Constants.CHAT_TYPE.ANSWER_PARTY then--世界答题语音跟翻译一起
        --         self:addAnswerPartyChatInfo(chatInfo)
        --         lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_ANSWER_PARTY,{chatInfo=chatInfo})
        --     end

        --     if channel == lt.Constants.CHAT_TYPE.TRUMPET then--喇叭
        --         lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_TRUMPET,{chatInfo=chatInfo})
        --         chatInfo:setChannel(lt.Constants.CHAT_TYPE.WORLD)
        --         self:addWorldChatInfo(chatInfo)
        --         lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_WORLD,{chatInfo=chatInfo})
        --     end

        --     return
        -- end

        if isAudio then--语音的处理 自动播放
            lt.AudioMsgManager:dealMessage(chatInfo)
        else--打字的处理   弹幕的形式
            if channel and subType then
                if lt.NoticeManager:isInitBarrageText() then--是否初始化了弹幕层

                    for i=1,30 do
                        lt.NoticeManager:addBarrageText(chatInfo, channel, subType)
                    end

                    
                end
            end
        end

        if subType == lt.Constants.CHAT_SUB_TYPE.RED_PACKET then
            lt.GameEventManager:post(lt.GameEventManager.EVENT.RED_PACKET,{chatInfo=chatInfo})
        end

        if subType == lt.Constants.CHAT_SUB_TYPE.RUNNIND_NOTICE then--跑马灯公告

            self:addRunningNoticeChatInfo(chatInfo)

            lt.GameEventManager:post(lt.GameEventManager.EVENT.RED_PACKET,{chatInfo=chatInfo})
        end

        if channel == lt.Constants.CHAT_TYPE.SYSTEM then
            self:addSystemChatInfo(chatInfo)
            lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_SYSTEM,{chatInfo=chatInfo})
            --钻石大奖跑马灯
            if subType == lt.Constants.CHAT_SUB_TYPE.EGG then
                local sunContent = json.decode(chatInfo:getSubContent())
                local modelId = sunContent["item_id"]
                --modelId = lt.Constants.ITEM.DIAMOND
                if modelId == lt.Constants.ITEM.DIAMOND then
                    local size = sunContent["item_size"]
                    local playerName = sunContent["player_name"]

                    local str = string.format(lt.StringManager:getString("STRING_GAIN_TIPS_EGG_3"), size)
                    chatInfo:setMessage(playerName..lt.StringManager:getString("STRING_GAIN_TIPS_EGG_2")..str..lt.StringManager:getString("STRING_GAIN_TIPS_EGG_4"))
                    lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_TRUMPET,{chatInfo=chatInfo})
                end
            end

            --战队创建跑马灯
            if subType == lt.Constants.CHAT_SUB_TYPE.CREATE_RISK_TEAM then

                local sunContent = json.decode(chatInfo:getSubContent())
                local playerName = sunContent["player_name"] or ""
                local name    =   sunContent["name"] or ""
                local prefix    =   sunContent["prefix"] or ""
                local memberCount    =   sunContent["member_count"]

                local num = lt.StringManager:getString(lt.StringManager:getCHSNumberString(memberCount)) or ""
                local teamName = prefix..num..name
                local runningMessage = playerName..lt.StringManager:getString("STRING_CHAT_BATTLE_TEAM_1")..teamName..lt.StringManager:getString("STRING_CHAT_BATTLE_TEAM_2")

                chatInfo:setMessage(runningMessage)
                lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_TRUMPET,{chatInfo=chatInfo})
            end

        elseif channel == lt.Constants.CHAT_TYPE.WORLD then

            self:addWorldChatInfo(chatInfo)
            lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_WORLD,{chatInfo=chatInfo})


        elseif channel == lt.Constants.CHAT_TYPE.TEAM then

            self:addTeamChatInfo(chatInfo)
            lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_TEAM,{chatMessageInfo = chatInfo})

        elseif channel == lt.Constants.CHAT_TYPE.GUILD then

            self:addGuildChatInfo(chatInfo)
            lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_GUILD,{chatInfo=chatInfo})

        elseif channel == lt.Constants.CHAT_TYPE.CURRENT then
            
            self:addCurrentChatInfo(chatInfo)
            lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_CURRENT,{chatInfo=chatInfo})

        elseif channel == lt.Constants.CHAT_TYPE.TRUMPET then--喇叭
            lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_TRUMPET,{chatInfo=chatInfo})

            chatInfo:setChannel(lt.Constants.CHAT_TYPE.WORLD)
            self:addWorldChatInfo(chatInfo)
            lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_WORLD,{chatInfo=chatInfo})

        elseif channel == lt.Constants.CHAT_TYPE.FRIEND then

            local chatMessageInfo = lt.ChatMessage.new()
            chatMessageInfo:initWithRow(s2cOnChatResponse)
            local senderId = chatMessageInfo:getSenderId()
            local message = chatMessageInfo:getMessage()

            lt.ChatManager:insertChatInfo(chatMessageInfo)
            local updateTime = chatMessageInfo:getSendTime()
            lt.ChatManager:insertChatUpdateTime(senderId,updateTime)

            chatFriendTable[senderId] = chatMessageInfo
            lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_FRIEND,{chatMessageInfo = chatMessageInfo})
        elseif channel == lt.Constants.CHAT_TYPE.RISK_TEAM then

            local chatMessageInfo = lt.ChatMessage.new()
            chatMessageInfo:initWithRow(s2cOnChatResponse)


            local riskTeamId = self:getRiskTeam():getId()
            chatMessageInfo:setReceiverId(riskTeamId)
            lt.ChatManager:insertChatTeamInfo(chatMessageInfo)

            local updateTime = chatMessageInfo:getSendTime()
            lt.ChatManager:insertChatTeamRiskUpdateTime(riskTeamId,updateTime)

            self:setRiskTeamMessageNew(true)

            lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_RISK_TEAM,{chatMessageInfo = chatMessageInfo})
        elseif channel == lt.Constants.CHAT_TYPE.ANSWER_PARTY then
            self:addAnswerPartyChatInfo(chatInfo)
            lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_ANSWER_PARTY,{chatInfo=chatInfo})
        end
    end
end

function DataManager:isFriend(friendId)
    local friendTable = self:getFriendTable()
    return isset(friendTable, friendId)
end

function DataManager:getFriend(friendId)
    local friendTable = self:getFriendTable()
    return friendTable[friendId]
end

function DataManager:getFirstFriendRequest()
    local friendRequestTable = self:getFriendRequestTable()

    return lt.CommonUtil:getCellAtIndexInHashTable(friendRequestTable, 1)
end

-- 好友发送请求
function DataManager:getFriendRequestSendTable()
    if not self._friendRequestSendTable then
        self._friendRequestSendTable = {}
    end

    return self._friendRequestSendTable
end

function DataManager:sendFriendRequest(playerId)
    local friendRequestSendTable = self:getFriendRequestSendTable()
    friendRequestSendTable[playerId] = 1
end

function DataManager:hasSendFriendRequest(playerId)
    local friendRequestSendTable = self:getFriendRequestSendTable()
    return isset(friendRequestSendTable, playerId)
end

function DataManager:getRecentContactTable()
    if not self._recentContactTable then
        self._recentContactTable = {}
    end

    return self._recentContactTable
end


function DataManager:getRecentContactById(id)
    local recentContactTable = self:getRecentContactTable()
    return recentContactTable[id]
end

--最近联系人
function DataManager:onGetRecentContactPlayersResponse(event)
    local s2cOnGetRecentContactPlayersResponse = event.data
    lt.CommonUtil.print("s2cOnGetRecentContactPlayersResponse code "..s2cOnGetRecentContactPlayersResponse.code)

    local s2cRecentContactTable = s2cOnGetRecentContactPlayersResponse.contact_player_array
    local recentContactTable = self:getRecentContactTable()
    for _,recentContact in ipairs(s2cRecentContactTable) do
        local recentContactInfo = lt.Contact.new(recentContact)
        local id = recentContactInfo:getId()
        recentContactTable[id] = recentContactInfo
    end
end


--刷新最近联系人
function DataManager:onUpdateRecentContactPlayersResponse(event)
    local s2cOnUpdateRecentContactPlayersResponse = event.data
    lt.CommonUtil.print("s2cOnUpdateRecentContactPlayersResponse code "..s2cOnUpdateRecentContactPlayersResponse.code)

    local s2cAddContactArray = s2cOnUpdateRecentContactPlayersResponse.add_contact_player_array
    local recentContactTable = self:getRecentContactTable()
    for _,sccontact in ipairs(s2cAddContactArray) do
        local contactInfo = lt.Contact.new(sccontact)
        local id = contactInfo:getId()
        recentContactTable[id] = contactInfo
    end

    local s2cSetContactArray = s2cOnUpdateRecentContactPlayersResponse.set_contact_player_array
    for _,sccontact in ipairs(s2cSetContactArray) do
        local contactInfo = lt.Contact.new(sccontact)
        local id = contactInfo:getId()
        recentContactTable[id] = contactInfo
    end

    local s2cDelContactPlayerIdArray = s2cOnUpdateRecentContactPlayersResponse.del_contact_player_id_array

    for _,id in ipairs(s2cDelContactPlayerIdArray) do
        recentContactTable[id] = nil
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.RECENT_CONTACT_UPDATE)
    

end

-- ################################################## 成长任务 ##################################################

function DataManager:getNewbieTaskTable()
    if not self._newbieTaskTable then
        self._newbieTaskTable = {}
    end

    return self._newbieTaskTable
end

function DataManager:onGetNewBieTaskListResponse(event)
    local s2cOnGetNewBieTaskListResponse = event.data

    lt.CommonUtil.print("s2cOnGetNewBieTaskListResponse code ======"..s2cOnGetNewBieTaskListResponse.code)

    local newbieGuildTaskList = s2cOnGetNewBieTaskListResponse.newbie_guide_task_list

    local newbieTaskTable = self:getNewbieTaskTable()


    for _,scNewbieGuildTask in ipairs(newbieGuildTaskList) do
        local newbieTaskInfo = lt.NewbieGuildTask.new(scNewbieGuildTask)
        local id = newbieTaskInfo:getAchievementId()

        newbieTaskTable[id] = newbieTaskInfo
    end
end

function DataManager:onUpdateNewBieTaskListResponse(event)
    local s2cOnUpdateNewBieTaskListResponse = event.data

    lt.CommonUtil.print("s2cOnUpdateNewBieTaskListResponse code ======"..s2cOnUpdateNewBieTaskListResponse.code)

    local newbieGuildTaskList = s2cOnUpdateNewBieTaskListResponse.newbie_guide_task_list

    local newbieTaskTable = self:getNewbieTaskTable()


    for _,scNewbieGuildTask in ipairs(newbieGuildTaskList) do
        local newbieTaskInfo = lt.NewbieGuildTask.new(scNewbieGuildTask)
        local id = newbieTaskInfo:getAchievementId()

        newbieTaskTable[id] = newbieTaskInfo
    end

    lt.NewFlagManager:setGrowTaskUpdate(true)
end

function DataManager:getNewbieGuildSectionReceiveTable()
    if not self._newbieGuildSectionReceiveTable then
        self._newbieGuildSectionReceiveTable = {}
    end

    return self._newbieGuildSectionReceiveTable
end

function DataManager:onGetNewbieGuildSectionReceiveResponse(event)

    local s2cOnGetNewbieGuildSectionReceiveResponse = event.data
    lt.CommonUtil.print("s2cOnGetNewbieGuildSectionReceiveResponse code "..s2cOnGetNewbieGuildSectionReceiveResponse.code)

    local table = s2cOnGetNewbieGuildSectionReceiveResponse.newbie_guide_section_receive_array

    local newbieGuildSectionReceiveTable = self:getNewbieGuildSectionReceiveTable()


    for _,s2cSectionInfo in ipairs(table) do
        local IdValuePair = lt.IdValuePair.new(s2cSectionInfo)
        local id = IdValuePair:getId()
        local value = IdValuePair:getValue()

        newbieGuildSectionReceiveTable[id] = value
    end

    lt.NewFlagManager:setGrowTaskUpdate(true)
end

function DataManager:getGrowTaskTable(currentSection)
    local receiveTable = self:getNewbieGuildSectionReceiveTable()
    if not receiveTable then
        return false
    end

    local value = receiveTable[currentSection] or 0

    if value == 1 then
        -- 已完成
        return false
    end

    local taskTable = self:getNewbieTaskTable()
    if not taskTable then
        return false
    end

    local sectionArray = lt.CacheManager:getGrowTaskBySection(currentSection)
    for _,sectionInfo in ipairs(sectionArray) do
        local id = sectionInfo:getId()
        local taskInfo = taskTable[id]
        if not taskInfo then
            return false
        end

        if taskInfo:getIsDone() == 0 then
            return false
        end
    end

    return true
end

-- ################################################## 战力达人 ##################################################

function DataManager:getBattlePointRewardTable()
    if not self._battlePointRewardTable then
        self._battlePointRewardTable = {}
    end

    return self._battlePointRewardTable
end

function DataManager:getBattlePointRewardFlag()
    return self._battlePointRewardFlag
end

function DataManager:onGetBattlePointRewardLogListResponse(event)

    local s2cOnGetBattlePointRewardLogListResponse = event.data


    local battlePointRewardList = s2cOnGetBattlePointRewardLogListResponse.battle_point_reward_list
    local battlePointListTable = self:getBattlePointRewardTable()
    

    for _,scBattlePoint in ipairs(battlePointRewardList) do
        local battlePointInfo = lt.BattlePointReward.new(scBattlePoint)

        local id = battlePointInfo:getBattlePointId()

        battlePointListTable[id] = battlePointInfo
    end

    self._battlePointRewardFlag = s2cOnGetBattlePointRewardLogListResponse.is_finished --0:活动未结束  1:活动已结束
    
end

function DataManager:onUpBattlePointRewardLogListResponse(event)
    local s2cOnUpBattlePointRewardLogListResponse = event.data

    local battlePointAddRewardList = s2cOnUpBattlePointRewardLogListResponse.add_battle_point_reward_list
    local battlePointListTable = self:getBattlePointRewardTable()
    

    for _,scBattlePoint in ipairs(battlePointAddRewardList) do
        local battlePointInfo = lt.BattlePointReward.new(scBattlePoint)
        local id = battlePointInfo:getBattlePointId()

        battlePointListTable[id] = battlePointInfo
    end

    local battlePointSetRewardList = s2cOnUpBattlePointRewardLogListResponse.set_battle_point_reward_list
    for _,scBattlePoint in ipairs(battlePointSetRewardList) do
        local battlePointInfo = lt.BattlePointReward.new(scBattlePoint)
        local id = battlePointInfo:getBattlePointId()

        battlePointListTable[id] = battlePointInfo
    end
end

function DataManager:getBattlePointRewardReceiveTable()
    if not self._battlePointRewardReceiveTable then
        self._battlePointRewardReceiveTable = {}
    end

    return self._battlePointRewardReceiveTable
end

function DataManager:onGetBattlePointRewardReceiveResponse(event)
    local s2cOnGetBattlePointRewardReceiveResponse = event.data

    local id1 = s2cOnGetBattlePointRewardReceiveResponse.battle_point_id_1
    local id2 = s2cOnGetBattlePointRewardReceiveResponse.battle_point_id_2
    local id3 = s2cOnGetBattlePointRewardReceiveResponse.battle_point_id_3
    local id4 = s2cOnGetBattlePointRewardReceiveResponse.battle_point_id_4
    local id5 = s2cOnGetBattlePointRewardReceiveResponse.battle_point_id_5
    local id6 = s2cOnGetBattlePointRewardReceiveResponse.battle_point_id_6

    local battlePointRewardTable = self:getBattlePointRewardReceiveTable()

    battlePointRewardTable[1] = id1
    battlePointRewardTable[2] = id2
    battlePointRewardTable[3] = id3
    battlePointRewardTable[4] = id4
    battlePointRewardTable[5] = id5
    battlePointRewardTable[6] = id6
end

-- ################################################## 红包 ##################################################
function DataManager:getPaperBagTable()
    if not self._paperBagReceiveTable then
        self._paperBagReceiveTable = {}
    end

    return self._paperBagReceiveTable
end

function DataManager:onGetPaperBagResponse(event)
    local s2cOnGetPaperBagResponse = event.data

    local paperBagReceiveTable = self:getPaperBagTable()
    lt.CommonUtil.print("s2cOnGetPaperBagResponse")
    local array = {} 
    for k,info in ipairs(s2cOnGetPaperBagResponse.data_array) do
        if info.day_index then
            if not array[info.day_index] then
                array[info.day_index] = {}
            end
            array[info.day_index]["day_index"] = info.day_index
            array[info.day_index]["coin"] = info.coin
            array[info.day_index]["received"] = info.received
        end
    end

    paperBagReceiveTable.data_array = array
    paperBagReceiveTable.is_closed = s2cOnGetPaperBagResponse.is_closed or 1 --1:活动关闭  0:未关闭
    paperBagReceiveTable.total_receive_coin = s2cOnGetPaperBagResponse.total_receive_coin
    paperBagReceiveTable.cur_day_index = s2cOnGetPaperBagResponse.cur_day_index
end

function DataManager:onUpdatePaperBagResponse(event)
    local s2cOnGetPaperBagResponse = event.data
    lt.CommonUtil.print("s2conUpdatePaperBagResponse")
    local paperBagReceiveTable = self:getPaperBagTable()

    for k,info in ipairs(s2cOnGetPaperBagResponse.set_data_array) do
        if not paperBagReceiveTable.data_array[info.day_index] then
            paperBagReceiveTable.data_array[info.day_index] = {}
        end

        paperBagReceiveTable.data_array[info.day_index].day_index = info.day_index
        paperBagReceiveTable.data_array[info.day_index].coin = info.coin
        paperBagReceiveTable.data_array[info.day_index].received = info.received
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_PAPER_BAG_LIST)
end


--[[ ################################################## 公会 guild ##################################################
    公会
    结构 table[id] = guild
    ]]
function DataManager:getGuildTable()
    if not self._guildTable then
        self._guildTable = {}
    end

    return self._guildTable
end

function DataManager:getGuildInfo(id)
    local guildTable = self:getGuildTable()
    return guildTable[id]
end

function DataManager:setPlayerGuild(guildInfo)
    self._playerGuild = lt.GuildInfo.new(guildInfo)
end

function DataManager:getPlayerGuild()
    return self._playerGuild
end

function DataManager:getMemberTable()
    if not self._guildMemberTable then
        self._guildMemberTable = {}
    end

    return self._guildMemberTable
end

function DataManager:resetGuildMemberTable()
    self._guildMemberTable = {}
end

function DataManager:getMember(playerId)
    local memberTable = self:getMemberTable()
    return memberTable[playerId]
end

function DataManager:getGuildEventTable()
    if not self._guildEventTable then
        self._guildEventTable = {}
    end

    return self._guildEventTable
end

function DataManager:resetGuildEventTable()
    self._guildEventTable = {}
end

function DataManager:getGuildRequestTable()
    if not self._guildRequestTable then
        self._guildRequestTable = {}
    end

    return self._guildRequestTable
end

function DataManager:resetGuildRequestTable()
    self._guildRequestTable = {}
end

function DataManager:setGuildImpeach(guildImpeach)
    self._guildImpeach = guildImpeach
end

function DataManager:getGuildImpeach()
    return self._guildImpeach
end

function DataManager:getGuildAnnexTable()
    if not self._guildAnnexTable then
        self._guildAnnexTable = {}
    end
    return self._guildAnnexTable
end

function DataManager:resetGuildAnnexTable()
    self._guildAnnexTable = {}
end

function DataManager:onGetGuildInfoResponse(event)--
    local s2cGetGuildInfo = event.data
    lt.CommonUtil.print("onGetGuildInfoResponse code " .. s2cGetGuildInfo.code)

    self:setPlayerGuild(s2cGetGuildInfo.guild)

    self:resetGuildMemberTable()
    local guildMemberTable = self:getMemberTable()
    for _,member in ipairs(s2cGetGuildInfo.guild_member_array) do
        local guildMember = lt.GuildMemberInfo.new(member)
        guildMemberTable[guildMember:getPlayerId()] = guildMember
    end

    self:resetGuildEventTable()
    local guildEventTable = self:getGuildEventTable()
    for _,event in ipairs(s2cGetGuildInfo.guild_event_array) do
       local guildEvent = lt.GuildEventInfo.new(event)
       guildEventTable[#guildEventTable+1] = guildEvent
    end

    self:resetGuildTaskTable()
    local guildTaskTable = self:getGuildTaskTable()
    for _,task in ipairs(s2cGetGuildInfo.guild_task_array) do
        local guildTask = lt.GuildTask.new(task)
        guildTaskTable[guildTask:getTaskId()] = guildTask
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.GUILD_UPDATE)
end

function DataManager:onUpdateGuildInfoResponse(event)
    local s2cUpdateGuildInfo = event.data
    lt.CommonUtil.print("onUpdateGuildInfoResponse code " .. s2cUpdateGuildInfo.code)

    if s2cUpdateGuildInfo:HasField('guild') then 
        self:setPlayerGuild(s2cUpdateGuildInfo.guild)
    end

    local guildMemberTable = self:getMemberTable()
    for _,member in ipairs(s2cUpdateGuildInfo.add_guild_member_array) do
        local guildMember = lt.GuildMemberInfo.new(member)
        guildMemberTable[guildMember:getPlayerId()] = guildMember
    end

    for _,member in ipairs(s2cUpdateGuildInfo.set_guild_member_array) do
        local guildMember = lt.GuildMemberInfo.new(member)
        guildMemberTable[guildMember:getPlayerId()] = guildMember
    end

    for _,playerId in ipairs(s2cUpdateGuildInfo.del_guild_member_id_array) do
        guildMemberTable[playerId] = nil
    end

    local guildEventTable = self:getGuildEventTable()
    for _,event in ipairs(s2cUpdateGuildInfo.add_guild_event_array) do
       local guildEvent = lt.GuildEventInfo.new(event)
       guildEventTable[#guildEventTable+1] = guildEvent
    end

    local guildTaskTable = self:getGuildTaskTable()
    for _,task in ipairs(s2cUpdateGuildInfo.add_guild_task_array) do
        local guildTask = lt.GuildTask.new(task)
        guildTaskTable[guildTask:getTaskId()] = guildTask
    end

    for _,task in ipairs(s2cUpdateGuildInfo.set_guild_task_array) do
        local guildTask = lt.GuildTask.new(task)
        guildTaskTable[guildTask:getTaskId()] = guildTask
    end

    for _,id in ipairs(s2cUpdateGuildInfo.del_guild_task_id_array) do
        guildTaskTable[id] = nil
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.GUILD_UPDATE)
end

function DataManager:onUpdateGuildListResponse(event)
    local s2cUpdateGuildList = event.data
    lt.CommonUtil.print("onUpdateGuildListResponse code " .. s2cUpdateGuildList.code)

    local guildTable = self:getGuildTable()
    for _,guild in ipairs(s2cUpdateGuildList.add_guild_array) do
        local guildInfo = lt.GuildInfo.new(guild)
        if guildInfo then
            guildTable[guildInfo:getId()] = guildInfo
        end
    end

    for _,guild in ipairs(s2cUpdateGuildList.set_guild_array) do
        local guildInfo = lt.GuildInfo.new(guild)
        if guildInfo then
            guildTable[guildInfo:getId()] = guildInfo
        end
    end

    for _,guildId in ipairs(s2cUpdateGuildList.del_guild_id_array) do
        if self:getPlayer() and self:getPlayer():getGuildId() then--你的会长解散公会你还在公会界面
            if lt.DataManager:getPlayer():getGuildId() == guildId then
                -- 公会解散
                lt.GameEventManager:post(lt.GameEventManager.EVENT.CLOSE_GUILD_LAYER)
                lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_GUILD_DELETE_TIPS"))--提示会长刚刚解散了公会
                --lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_PLAYER_INFO_18"))--提示称号已失效
                --lt.GameEventManager:post(lt.GameEventManager.EVENT.PLAYER_TITLE)--刷新玩家称号

                -- 判断深处公会地图状态
                lt.GameEventManager:post(lt.GameEventManager.EVENT.GUILD_EXIT)
            end
        end
        
        guildTable[guildId] = nil
    end

    for _,guildId in ipairs(s2cUpdateGuildList.add_request_join_guild_id_array) do
        local guildInfo = self:getGuildInfo(guildId)

        if guildInfo then
            guildInfo:setRequested(true)
        end
    end 

    for _,guildId in ipairs(s2cUpdateGuildList.add_request_annex_guild_id_array) do
        local guildInfo = self:getGuildInfo(guildId)
        if guildInfo then
            guildInfo:setAnnexRequested(true)
        end
    end 
    lt.GameEventManager:post(lt.GameEventManager.EVENT.GUILD_UPDATE_LIST)
end

function DataManager:onGetGuildRequestListResponse(event)
    local s2cGetGuildRequestList = event.data
    lt.CommonUtil.print("onGetGuildRequestListResponse code " .. s2cGetGuildRequestList.code)

    self:resetGuildRequestTable()
    local guildRequestTable = self:getGuildRequestTable()
    for _,request in ipairs(s2cGetGuildRequestList.requester_array) do
        local guildRequest = lt.GuildRequestInfo.new(request)
        guildRequestTable[guildRequest:getId()] = guildRequest
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.GUILD_REQUEST_LITST)
end

function DataManager:onGetGuildAnnexRequestListResponse(event)
    local s2cGetGuildAnnexList = event.data
    lt.CommonUtil.print("onGetGuildAnnexRequestListResponse code " .. s2cGetGuildAnnexList.code)

    self:resetGuildAnnexTable()
    local guildAnnexTable = self:getGuildAnnexTable()

    for _,guild in ipairs(s2cGetGuildAnnexList.request_guild_array) do
         local guildInfo = lt.GuildInfo.new(guild)
         guildAnnexTable[guildInfo:getId()] = guildInfo
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.GUILD_ANNEX_LITST) 
end

function DataManager:onKickedOut(event)
    -- local s2cKickedOut = event.data
    -- lt.CommonUtil.print("onKickedOut code " .. s2cKickedOut.code)

    lt.GameEventManager:post(lt.GameEventManager.EVENT.GUILD_KICKED_OUT) 
end

function DataManager:getGuildActivityTable()
    if not self._guildActivityTable then
        self._guildActivityTable = {}
    end
    return self._guildActivityTable
end

function DataManager:getGuildActivity(id)
    local guildActivityTable = self:getGuildActivityTable()
    return guildActivityTable[id]
end

function DataManager:getGuildTaskTable()
    if not self._guildTaskTable then
        self._guildTaskTable = {}
    end
    return self._guildTaskTable
end

function DataManager:getGuildTask(id)
    local guildTaskTable = self:getGuildTaskTable()
    return guildTaskTable[id]
end

function DataManager:resetGuildTaskTable()
    self._guildTaskTable = {}
end

function DataManager:getGuildTaskStatusTable()
    if not self._guildTaskStatusTable then
        self._guildTaskStatusTable = {}
    end
    return self._guildTaskStatusTable
end

function DataManager:getGuildTaskStatus(id)
    local guildTaskStatusTable = self:getGuildTaskStatusTable()
    return guildTaskStatusTable[id]
end

function DataManager:onGetGuildTaskStatusList(event)
    local s2cGetGuildTaskStatusList = event.data
    lt.CommonUtil.print("onGetGuildTaskStatusList code " .. s2cGetGuildTaskStatusList.code)

    local guildTaskStatusTable = self:getGuildTaskStatusTable()
    for _,taskStatus in ipairs(s2cGetGuildTaskStatusList.task_status_array) do
        local guildTaskStatus = lt.GuildTaskStatus.new(taskStatus)
        guildTaskStatusTable[guildTaskStatus:getTaskId()] = guildTaskStatus
        local guildDelegate = lt.CacheManager:getGuildDelegate(guildTaskStatus:getTaskId())
        if guildDelegate then
            if guildDelegate:getType() == lt.Constants.GUILD_DELEGATE_TYPE.ACCESS_NPC then
                if guildTaskStatus:getStatus() == 1 then
                    self:setCurrentDelegateId(guildTaskStatus:getTaskId())
                    self:setCurrentNPCId(guildDelegate:getNPCId())
                end
            end
        end
    end
end

function DataManager:onUpdateGuildTaskStatusList(event)
    local s2cUpdateGuildTaskStatusList = event.data
    lt.CommonUtil.print("onUpdateGuildTaskStatusList code " .. s2cUpdateGuildTaskStatusList.code)

    local guildTaskStatusTable = self:getGuildTaskStatusTable()
    for _,taskStatus in ipairs(s2cUpdateGuildTaskStatusList.set_task_status_array) do
        local guildTaskStatus = lt.GuildTaskStatus.new(taskStatus)
        guildTaskStatusTable[guildTaskStatus:getTaskId()] = guildTaskStatus
        local guildDelegate = lt.CacheManager:getGuildDelegate(guildTaskStatus:getTaskId())
        if guildDelegate then
            if guildDelegate:getType() == lt.Constants.GUILD_DELEGATE_TYPE.ACCESS_NPC then
                if guildTaskStatus:getStatus() == 1 then
                    self:setCurrentDelegateId(guildTaskStatus:getTaskId())
                    self:setCurrentNPCId(guildDelegate:getNPCId())
                end
            end
        end
    end
end

function DataManager:onDoGuildTaskNpc(event)
    local s2cDoGuildTaskNpc = event.data
    lt.CommonUtil.print("onDoGuildTaskNpc code " .. s2cDoGuildTaskNpc.code)

    if s2cDoGuildTaskNpc.code ~= lt.SocketConstants.CODE_OK then
        return
    end

    self:setCurrentDelegateId(0)
    self:setCurrentNPCId(0)
end

function DataManager:getPlayerGuildBossList()--每个玩家的boss 每个玩家的挑战冷却时间不一样
    if not self._playerGuildBossList then
        self._playerGuildBossList = {}
    end
    return self._playerGuildBossList
end

function DataManager:onGetPlayerGuildBossList(event)
    local s2cGetPlayerGuildBossList = event.data
    lt.CommonUtil.print("s2cGetPlayerGuildBossList OK")
    -- lt.CommonUtil.print("s2cGetPlayerGuildBossList content\n"..tostring(s2cGetPlayerGuildBossList))

    local playerGuildBossList = self:getPlayerGuildBossList()
    local scAddGuildBossArray = s2cGetPlayerGuildBossList.add_data_array or {}
    for _, scGuildBoss in ipairs(scAddGuildBossArray) do
        local guildBoss = {}
        guildBoss.player_id = scGuildBoss.player_id
        guildBoss.boss_index = scGuildBoss.boss_index
        guildBoss.guild_id = scGuildBoss.guild_id
        guildBoss.player_name = scGuildBoss.player_name
        guildBoss.hurt = scGuildBoss.hurt
        guildBoss.update_time = scGuildBoss.update_time
        playerGuildBossList[scGuildBoss.boss_index] = guildBoss
    end

    local scSetGuildBossArray = s2cGetPlayerGuildBossList.set_data_array or {}
    for _, scGuildBoss in ipairs(scSetGuildBossArray) do
        local guildBoss = {}
        guildBoss.player_id = scGuildBoss.player_id
        guildBoss.boss_index = scGuildBoss.boss_index
        guildBoss.guild_id = scGuildBoss.guild_id
        guildBoss.player_name = scGuildBoss.player_name
        guildBoss.hurt = scGuildBoss.hurt
        guildBoss.update_time = scGuildBoss.update_time
        playerGuildBossList[scGuildBoss.boss_index] = guildBoss
    end
end

--公会boss
function DataManager:getActivityGuildBossList()
    if not self._activityGuildBossList then
        self._activityGuildBossList = {}
    end
    return self._activityGuildBossList
end

function DataManager:onRequestGuildBossList(event)
    local s2cGetActivityGuildBossList= event.data
    lt.CommonUtil.print("s2cGetActivityGuildBossList OK")
    -- lt.CommonUtil.print("s2cGetActivityGuildBossList content\n"..tostring(s2cGetActivityGuildBossList))

    local activityGuildBossList = lt.DataManager:getActivityGuildBossList()
    local scAddGuildBossArray = s2cGetActivityGuildBossList.add_data_array or {}
    for _, scGuildBoss in ipairs(scAddGuildBossArray) do
        local guildBoss = {}
        guildBoss.guild_id = scGuildBoss.guild_id
        guildBoss.boss_index = scGuildBoss.boss_index
        guildBoss.boss_id = scGuildBoss.boss_id
        guildBoss.killed = scGuildBoss.killed
        guildBoss.cost_time = scGuildBoss.cost_time
        guildBoss.level = scGuildBoss.level
        activityGuildBossList[scGuildBoss.boss_index] = guildBoss
    end

    local scSetGuildBossArray = s2cGetActivityGuildBossList.set_data_array or {}
    for _, scGuildBoss in ipairs(scSetGuildBossArray) do
        local guildBoss = {}
        guildBoss.guild_id = scGuildBoss.guild_id
        guildBoss.boss_index = scGuildBoss.boss_index
        guildBoss.boss_id = scGuildBoss.boss_id
        guildBoss.killed = scGuildBoss.killed
        guildBoss.cost_time = scGuildBoss.cost_time
        guildBoss.level = scGuildBoss.level
        activityGuildBossList[scGuildBoss.boss_index] = guildBoss
    end
end

function DataManager:setCurrentDelegateId(delegateId)
    self._currentDelegateId = delegateId
end

function DataManager:getCurrentDelegateId()
    return self._currentDelegateId
end

function DataManager:setCurrentNPCId(npcId)
    self._currentNPCId = npcId
end

function DataManager:getCurrentNPCId()
    return self._currentNPCId
end

-- 公会材料仓库
function DataManager:getGuildMaterialTable()
    if not self._guildMaterialTable then
        self._guildMaterialTable = {}
    end
    return self._guildMaterialTable
end

function DataManager:getGuildMaterial(itemId)
    local guildMaterailTable = self:getGuildMaterialTable()
    return guildMaterailTable[itemId]
end

-- 公会资源仓库中的道具
function DataManager:getGuildResourceItemTable()
    if not self._guildResourceItemTable then
        self._guildResourceItemTable = {}
    end
    return self._guildResourceItemTable
end

function DataManager:getGuildResourceItem(itemId)
    local guildResourceItemTable = self:getGuildResourceItemTable()
    return guildResourceItemTable[itemId]
end

-- 公会资源仓库中的装备
function DataManager:getGuildResourceEquipmentTable()
    if not self._guildResourceEquipmentTable then
        self._guildResourceEquipmentTable = {}
    end
    return self._guildResourceEquipmentTable
end

function DataManager:getGuildResourceEquipment(equipmentId)
    local guildResourceEquipmentTable = self:getGuildResourceEquipmentTable()
    return guildResourceEquipmentTable[equipmentId]
end

function DataManager:getGuildHouseEventTable()
    if not self._guildHouseEventTable then
        self._guildHouseEventTable = {}
    end
    return self._guildHouseEventTable
end

function DataManager:getGuildItemDistributionTable()
    if not self._guildItemDistributionTable then
        self._guildItemDistributionTable = {}
    end
    return self._guildItemDistributionTable
end

function DataManager:getGuildDistribution(itemType,itemId)
    local guildItemDistributionTable = self:getGuildItemDistributionTable()
    for _,guildItemDistribution in pairs(guildItemDistributionTable) do
        if guildItemDistribution:getItemType() == itemType and guildItemDistribution:getItemId() == itemId then
            return guildItemDistribution
        end
    end
    return nil
end

--工会答题推送
function DataManager:onLivenessActivityQuestionHelpAnswered()
    lt.GameEventManager:post(lt.GameEventManager.EVENT.QUESTION_ANSWERED)
end

function DataManager:onNotifyBoomContribution(event)
    local s2cNotifyBoomContribution = event.data
    lt.CommonUtil.print("s2cNotifyBoomContribution content\n"..tostring(s2cNotifyBoomContribution))

    local boomPoint = s2cNotifyBoomContribution.boom_point

    if not self._playerGuild then
        return
    end

    self._playerGuild:setBoomPoint(boomPoint)
end

--空间新消息推送
function DataManager:onUpdataPlayerZoneDataResponse(event)
    local scOnUpdataPlayerZoneDataResponse = event.data
    lt.CommonUtil.print("scOnUpdataPlayerZoneDataResponse code ===="..scOnUpdataPlayerZoneDataResponse.code)

    local playerId = self:getPlayerId()


    if scOnUpdataPlayerZoneDataResponse.player_id == playerId then
        if scOnUpdataPlayerZoneDataResponse:HasField('set_zone_data') then
            local sczoneData = scOnUpdataPlayerZoneDataResponse.set_zone_data
            
            local zoneDataInfo = lt.ZoneData.new(sczoneData)

            self._newNotifications = zoneDataInfo:getNotifications()
        end
    end

end

function DataManager:getPlayerZoneNewNotifications()
    return self._newNotifications
end

function DataManager:hasNewZoneData()
    local newNotifications = self:getPlayerZoneNewNotifications() or 0

    if newNotifications > 0 then
        return true
    end

    return false
end

--[[ ################################################## 英灵 playerServant ##################################################
    玩家英灵
    结构 table[servantId] = playerServant
    ]]
function DataManager:getServantTable()
    if not self._servantTable then
        self._servantTable = {}
    end

    return self._servantTable
end

function DataManager:getOtherPlayerServantTable()
    if not self._otherPlayerServantTable then
        self._otherPlayerServantTable = {}
    end

    return self._otherPlayerServantTable
end

function DataManager:getServantJudgeThumbList()
    if not self._servantJudgeThumbList then
        self._servantJudgeThumbList = {}
    end

    return self._servantJudgeThumbList
end

function DataManager:getServantCount()
    local servantTable = self:getServantTable()

    return lt.CommonUtil:calcHashTableLength(servantTable)
end

function DataManager:getServant(modelId)
    local servantTable = self:getServantTable()
    for _,playerServant in pairs(servantTable) do
        if playerServant:getModelId() == modelId then
            return playerServant
        end
    end

    return nil
end

function DataManager:getOtherPlayerServant(servantId)
    local otherPlayerServantTable = self:getOtherPlayerServantTable()
    return otherPlayerServantTable[servantId]
end

-- 排序(通用英灵) 上阵 > 战力 > 等级 > 元素 > ID
function DataManager:_servantSort1(playerServant1, playerServant2)
    local slot1 = playerServant1:getEquipSlot()
    local slot2 = playerServant2:getEquipSlot()

    if slot1 ~= 0 and slot2 == 0 then
        return true
    elseif slot1 == 0 and slot2 ~= 0 then
        return false
    else
        local fightPower1 = playerServant1:getFightPower()
        local fightPower2 = playerServant2:getFightPower()
        if fightPower1 > fightPower2 then
            return true
        elseif fightPower1 == fightPower2 then
            local level1 = playerServant1:getLevel()
            local level2 = playerServant2:getLevel()

            if level1 > level2 then
                return true
            elseif level1 == level2 then
                local property1 = playerServant1:getProperty()
                local property2 = playerServant2:getProperty()

                if property1 < property2 then
                    return true
                elseif property1 == property2 then
                    local modelId1 = playerServant1:getModelId()
                    local modelId2 = playerServant2:getModelId()

                    if modelId1 < modelId2 then
                        return true
                    elseif modelId1 == modelId2 then
                        local star1 = playerServant1:getStar()
                        local star2 = playerServant2:getStar()

                        if star1 > star2 then
                            return true
                        -- elseif star1 == star2 then
                        --     local characterCount1 = playerServant1:getCharacterCount()
                        --     local characterCount2 = playerServant2:getCharacterCount()

                        --     return characterCount1 > characterCount2
                        end
                    end
                end
            end
        end
    end

    return false
end

-- 排序(英灵合成) 上阵 > 等级 > 元素 > 模型ID > 星级 > 特性数
function DataManager:_servantSort2(playerServant1, playerServant2)
    local slot1 = playerServant1:getEquipSlot()
    local slot2 = playerServant2:getEquipSlot()

    if slot1 ~= 0 and slot2 == 0 then
        return true
    elseif slot1 == 0 and slot2 ~= 0 then
        return false
    else
        local level1 = playerServant1:getLevel()
        local level2 = playerServant2:getLevel()

        if level1 > level2 then
            return true
        elseif level1 == level2 then
            local property1 = playerServant1:getProperty()
            local property2 = playerServant2:getProperty()

            if property1 < property2 then
                return true
            elseif property1 == property2 then
                local modelId1 = playerServant1:getModelId()
                local modelId2 = playerServant2:getModelId()

                if modelId1 < modelId2 then
                    return true
                elseif modelId1 == modelId2 then
                    local star1 = playerServant1:getStar()
                    local star2 = playerServant2:getStar()

                    if star1 > star2 then
                        return true
                    -- elseif star1 == star2 then
                    --     local characterCount1 = playerServant1:getCharacterCount()
                    --     local characterCount2 = playerServant2:getCharacterCount()

                    --     return characterCount1 > characterCount2
                    end
                end
            end
        end
    end

    return false
end

function DataManager:getServantArray(property, sortType)
    local servantTable = self:getServantTable()
    local servantArray = {}

    for _,playerServant in pairs(servantTable) do
        local selfProperty = playerServant:getProperty()

        if not property or property == 0 or selfProperty == property then
            servantArray[#servantArray + 1] =  playerServant
        end
    end

    sortType = sortType or 1
    if sortType == 1 then
        table.sort( servantArray, handler(self, self._servantSort1))
    elseif sortType == 2 then
        table.sort( servantArray, handler(self, self._servantSort2))
    end

    return servantArray
end

function DataManager:onGetServantListResponse(event)
    local s2cGetServantList = event.data
    lt.CommonUtil.print("s2cGetServantList code "..s2cGetServantList.code)
    -- lt.CommonUtil.print("s2cGetServantList code "..tostring(s2cGetServantList))

    -- 英灵列表
    local servantTable = self:getServantTable()

    local scServantArray = s2cGetServantList.servant_array
    for _,scServant in ipairs(scServantArray) do
        local playerServant = lt.PlayerServant.new(scServant,true)

        local id = playerServant:getId()

        servantTable[id] = playerServant

        if playerServant:getEquipSlot() == 1 then
            self._battleServant = playerServant
        end
    end
end

function DataManager:onUpdateServantListResponse(event)
    local s2cUpdateServantList = event.data
    lt.CommonUtil.print("s2cUpdateServantList code " .. s2cUpdateServantList.code)

    --print("s2cUpdateServantList content\n" .. tostring(s2cUpdateServantList))

    local servantTable = self:getServantTable()

    local updateServantIdArray = {}
    local scAddServantArray = s2cUpdateServantList.add_servant_array
    for _, scServant in ipairs(scAddServantArray) do
        local playerServant = lt.PlayerServant.new(scServant,true)

        local id = playerServant:getId()

        servantTable[id] = playerServant

        local updateBattle = false
        if self._battleServant and self._battleServant:getId() == playerServant:getId() and playerServant:getEquipSlot() == 0 then
            self._battleServant = nil

            updateBattle = true
        end

        if playerServant:getEquipSlot() == 1 then
            self._battleServant = playerServant

            updateBattle = true
        end

        if updateBattle then
            lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_BATTLE_SERVANT)
        end
    end

    local updateBattle = false
    local scSetServantArray = s2cUpdateServantList.set_servant_array
    for _, scServant in ipairs(scSetServantArray) do
        local id = scServant.id

        local playerServant = nil
        if isset(servantTable, id) then
            playerServant = servantTable[id]
            playerServant:update(scServant, true)
        else
            playerServant = lt.PlayerServant.new(scServant,true)
            servantTable[id] = playerServant
        end
        
        if self._battleServant and self._battleServant:getId() == playerServant:getId() and playerServant:getEquipSlot() == 0 then
            self._battleServant = nil

            updateBattle = true
        end

        if playerServant:getEquipSlot() == 1 then
            self._battleServant = playerServant

            updateBattle = true
        end
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.SERVANT_UPDATE)

    if updateBattle then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_BATTLE_SERVANT)
    end
end

function DataManager:getServantJudgeThumbListResponse(event) --英灵评论点赞
    local s2cServantJUDGETHUMBList = event.data
    lt.CommonUtil.print("s2cServantJUDGETHUMBList OK")
    --lt.CommonUtil.print("s2cServantJUDGETHUMBList code " .. s2cServantJUDGETHUMBList.code)
    local servantJudgeThumbList = self:getServantJudgeThumbList()
    if not event.data then
        return
    end

    if s2cServantJUDGETHUMBList.add_data_array then
        for k,v in ipairs(s2cServantJUDGETHUMBList.add_data_array) do
            servantJudgeThumbList[v.judge_id] = v.thumbed--0:未 1:已
        end
    end

    if s2cServantJUDGETHUMBList.set_data_array then
        for k,v in ipairs(s2cServantJUDGETHUMBList.set_data_array) do
            servantJudgeThumbList[v.judge_id] = v.thumbed--0:未 1:已
        end
    end
end

function DataManager:getServantBoundList()--英灵羁绊信息
    if not self._servantBoundList then
        self._servantBoundList = {}
    end

    return self._servantBoundList
end

function DataManager:onGetServantBoundListResponse(event) --英灵羁绊信息
    local s2cServantBoundList = event.data
    lt.CommonUtil.print("s2cServantBoundList OK")
    
    local servantBoundList = self:getServantBoundList()
    if not event.data then
        return
    end
    if s2cServantBoundList.data_array then
        for k,v in pairs(s2cServantBoundList.data_array) do
            if v.servant_id then
                if not servantBoundList[v.servant_id] then
                    servantBoundList[v.servant_id] = {}
                end

                local info = {}
                info["servantId"] = v.servant_id
                info["boundType"] = v.bound_type
                info["boundId"] = v.bound_id
                servantBoundList[v.servant_id][v.bound_type] = info--
            end
        end
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.SERVANT_BOUND_UPDATE)
end

function DataManager:onUpdateServantBoundListResponse(event) --更新英灵羁绊信息 解锁 升级
     local s2cServantBoundList = event.data
    lt.CommonUtil.print("onUpdateServantBoundListResponse")
    local servantBoundList = self:getServantBoundList()
    if not event.data then
        return
    end

    if s2cServantBoundList.add_data_array then
        for k,v in pairs(s2cServantBoundList.add_data_array) do
            if v.servant_id then
                if not servantBoundList[v.servant_id] then
                    servantBoundList[v.servant_id] = {}
                end

                local info = {}
                info["servantId"] = v.servant_id
                info["boundType"] = v.bound_type
                info["boundId"] = v.bound_id
                servantBoundList[v.servant_id][v.bound_type] = info--
            end
        end
    end  
    
    if s2cServantBoundList.set_data_array then
        for k,v in pairs(s2cServantBoundList.set_data_array) do
            if v.servant_id then
                if not servantBoundList[v.servant_id] then
                    servantBoundList[v.servant_id] = {}
                end

                local info = {}
                info["servantId"] = v.servant_id
                info["boundType"] = v.bound_type
                info["boundId"] = v.bound_id
                servantBoundList[v.servant_id][v.bound_type] = info--
            end
        end
    end  
    
    lt.GameEventManager:post(lt.GameEventManager.EVENT.SERVANT_BOUND_UPDATE)
end

function DataManager:getBattleServant() --出战中的英灵
    return self._battleServant
end
--[[ ################################################## playerItem ##################################################
    玩家道具
    结构 table[]
    结构 table[itemModelId] = {itemId = 1, ...}
    ]]
--使用道具监听
function DataManager:onUseItemResponse(event)
    local s2cUseItem = event.data
    local code = s2cUseItem.code
    lt.CommonUtil.print("DataManager s2cUseItem code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        if code == lt.SocketConstants.CODE_OVER_MAX_BAG_SIZE then
            lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_SHOPCLUB_BAG_MAX_CANT_MAKE"))

        elseif code == lt.SocketConstants.CODE_LEVEL_NOT_REACHED then
            lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_ERROR_LEVEL_NOT_ENOUGH"))

        elseif code == lt.SocketConstants.CODE_DOUBLE_EXP_POOL_ENOUGH then
            lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_DOUBLE_EXP_MAX"))

        elseif code == lt.SocketConstants.CODE_OVER_BUY_ITEM_COUNT_LIMIT then
            lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_ERROR_OVER_MAX_LIMIT"))

        elseif code == lt.SocketConstants.CODE_DOUEXP_MAX then

            lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_ERROR_DOUBLE_MAX"))
        end

        return
    end

    local id = s2cUseItem.id

    if id ~= 0 then
        local itemInfo = lt.CacheManager:getItemInfo(id)

        local typeValue = itemInfo:getTypeValue()
        local itemType = itemInfo:getType()

        if itemType == lt.Constants.ITEM_TYPE.BLOOD then

            local value = typeValue["valuel"]

            local str1 = lt.StringManager:getString("STRING_MEDICAMENT_STRING_9")
            local str2 = value
            local str3 = lt.StringManager:getString("STRING_MEDICAMENT_STRING_10")
            lt.NoticeManager:addRichMessage({{message = str1, color = lt.Constants.COLOR.WHITE, outline = true},{message = str2, color = lt.Constants.COLOR.GREEN, outline = true},{message = str3, color = lt.Constants.COLOR.WHITE, outline = true}})
            return
        end

        if itemType == lt.Constants.ITEM_TYPE.CARD_INFO then
            if id == 195 then
                lt.NoticeManager:addMessage(lt.StringManager:getString("SHOP_CLUB_USE_MONTH_CARD"))
            elseif id == 196 then
                lt.NoticeManager:addMessage(lt.StringManager:getString("SHOP_CLUB_USE_YEAR_CARD"))
            end
        end

    end

    local itemArray = s2cUseItem.gain_item_array or {}
    for i,item in ipairs(itemArray) do
        local type = item.type
        local modelId = item.model_id
        local count = item.count
        lt.NoticeManager:addGainItemMessage(type, modelId, count)
    end

    local gainItemArray = {}
    for _,gainItem in ipairs(s2cUseItem.gain_item_array_2) do
        local item = {}
        item.type = lt.GameIcon.TYPE.ITEM
        item.modelId = gainItem.model_id
        item.fromId = gainItem.type
        item.count = gainItem.count
        gainItemArray[#gainItemArray+1] = item
    end

    for _,item in pairs(gainItemArray) do
        local runeInfo = lt.CacheManager:getRuneInfo(item.fromId)
        if runeInfo then
            lt.NoticeManager:addRichMessage({{message = runeInfo:getName(), color = lt.Constants.COLOR.GREEN,outline=true},
                                            {message = lt.StringManager:getString("STRING_RUNE_BOX_TIPS_4"), color = lt.Constants.COLOR.WHITE},
                                            {message = item.count, color = lt.Constants.COLOR.QUALITY_GREEN,outline=true},
                                            {message = lt.StringManager:getString("STRING_CHIP"), color = lt.Constants.COLOR.WHITE}})
        end
    end
end

function DataManager:getItemTable()
    if not self._itemTable then
        self._itemTable = {}
    end

    return self._itemTable
end

function DataManager:getCombineItemTable() --用来判断是否可以合并的table
    if not self._combineItemTable then
        self._combineItemTable = {}
    end

    return self._combineItemTable
end

function DataManager:showItemCombine(itemModelId)
    local combineItemTable = self:getCombineItemTable()
    local realTable = combineItemTable[itemModelId]
    if not realTable then
        return false
    end
    local tempTable = {}
    for _,playerItem in pairs(realTable) do
        tempTable[playerItem:getBindType()] = 1
    end
    local i = 0
    for k,v in pairs(tempTable) do
        i = i+1
    end
    if i > 1 then
        return true
    end
    return false
end

function DataManager:getItemModelTable()
    if not self._itemModelTable then
        self._itemModelTable = {}
    end

    return self._itemModelTable
end

function DataManager:getPlayerItemTable()
    local playerItemTable = {}

    local itemTable = self:getItemTable()
    for k,v in pairs(itemTable) do
        playerItemTable[k] = v
    end

    local storageArray = self:getStorageAllItemTable()
    for k,v in pairs(storageArray) do
        playerItemTable[v:getId()] = v
    end

    local tempItemTable = self:getTempItemTable()
    for k,v in pairs(tempItemTable) do
        playerItemTable[v:getId()] = v
    end

    return playerItemTable
end

function DataManager:getGemListTable()
    local gemListTable = {}
    local allitemTable = self:getAllItemArray()

    for k,itemInfo in pairs(allitemTable) do

        local typeValue = itemInfo:getTypeValue()

        if typeValue ~= 0 then
            local value = tonumber(typeValue["valuel"])
            if value == lt.Constants.GEM_TYPE_VALUE then
                gemListTable[itemInfo:getId()] = itemInfo
            end
        end
    end

    return gemListTable
end

function DataManager:getPlayerItem(itemId)
    local itemTable = self:getPlayerItemTable()
    return itemTable[itemId]
end

function DataManager:getNewItemTable()
    if not self._newItemTable then
        self._newItemTable = {}
    end

    return self._newItemTable
end

function DataManager:clearNewItemTable()
    self._newItemTable = {}
end

function DataManager:getNewItemArray()
    if not self._newItemArray then
        self._newItemArray = {}
    end

    return self._newItemArray
end

function DataManager:removeItemArray()
    local itemArray = self:getNewItemArray()

    if #itemArray == 0 then
        return
    end

    table.remove(itemArray, 1)

end

function DataManager:clearNewItemArray()
    self._newItemArray = {}
end

function DataManager:onGetItemListResponse(event)
    local s2cGetItemList = event.data
    lt.CommonUtil.print("s2cGetItemList code "..s2cGetItemList.code)

    -- 道具列表
    self._itemTable = {}
    self._itemModelTable = {}
    self._combineItemTable = {}
    local itemTable = self:getItemTable()
    local itemModelTable = self:getItemModelTable()
    local itemCombineTable = self:getCombineItemTable()

    local scItemArray = s2cGetItemList.item_array
    for _,scItem in ipairs(scItemArray) do
        local playerItem = lt.PlayerItem.new(scItem)

        local id = playerItem:getId()
        local modelId = playerItem:getModelId()

        itemTable[id] = playerItem

        if not isset(itemModelTable, modelId) then
            itemModelTable[modelId] = {}
        end

        itemModelTable[modelId][id] = true

        local combineTable = itemCombineTable[modelId]
        if not combineTable then
            combineTable = {}
            combineTable[playerItem:getId()] = playerItem
            itemCombineTable[modelId] = combineTable
        else
            combineTable[playerItem:getId()] = playerItem
        end
    end
end

DataManager.POTION_TABLE = {
    [lt.Constants.ITEM.POTION_1] = true,
    [lt.Constants.ITEM.POTION_2] = true,
    [lt.Constants.ITEM.POTION_3] = true,
    [lt.Constants.ITEM.POTION_4] = true,
    [lt.Constants.ITEM.POTION_5] = true,
    [lt.Constants.ITEM.POTION_6] = true,
}

-- 进背包弹窗 3, 4宝箱类型 5包裹类道具 13任务道具 15特殊抽奖类道具 18双倍经验道具,20,21
DataManager.POP_ITEM_TYPE_TABLE = {
    [lt.Constants.ITEM_TYPE.TREASURE]       = true,
    [lt.Constants.ITEM_TYPE.PACKAGE]        = true,
    [lt.Constants.ITEM_TYPE.TASK]           = true,
    [lt.Constants.ITEM_TYPE.SPCIAL_REWARD]  = true,
    [lt.Constants.ITEM_TYPE.DOUBLE_EXP]     = true,
    [lt.Constants.ITEM_TYPE.RUNE_REWARD]    = true,
    [lt.Constants.ITEM_TYPE.CONSUME]        = true,
    [lt.Constants.ITEM_TYPE.EQUIP_REWARD]   = true,
    [lt.Constants.ITEM_TYPE.CARD_INFO]      = true,
}

function DataManager:onUpdateItemListResponse(event)
    local s2cUpdateItemList = event.data
    local code = s2cUpdateItemList.code
    lt.CommonUtil.print("s2cUpdateItemList code " .. code)
    -- lt.CommonUtil.print("s2cUpdateItemList content\n" .. tostring(s2cUpdateItemList))

    local itemTable = self:getItemTable()
    local itemModelTable = self:getItemModelTable()
    local itemCombineTable = self:getCombineItemTable()

    local newItemArray = self:getNewItemArray()

    local potionUpdate = false
    local itemAdd = false

    local popFlag = false

    local scAddItemArray = s2cUpdateItemList.add_item_array
    for _, scItem in ipairs(scAddItemArray) do
        local playerItem = lt.PlayerItem.new(scItem)

        local id = playerItem:getId()
        local modelId = playerItem:getModelId()

        itemTable[id] = playerItem

        if not isset(itemModelTable, modelId) then
            itemModelTable[modelId] = {}
        end

        if lt.CommonUtil:isTableEmpty(itemIdTable) then
            -- 新道具
            local newItemTable = self:getNewItemTable()
            newItemTable[id] = true
        end

        itemModelTable[modelId][id] = true

        local combineTable = itemCombineTable[modelId]
        if not combineTable then
            combineTable = {}
            itemCombineTable[modelId] = combineTable
        end
        combineTable[id] = playerItem

        if isset(self.POTION_TABLE, modelId) then
            potionUpdate = true
        end

        --判断第一次进背包弹框
        -- 4宝箱类型 5包裹类道具 13任务道具 15特殊抽奖类道具 18双倍经验道具
        local type = playerItem:getType()
        if isset(self.POP_ITEM_TYPE_TABLE, type) then
            local size = playerItem:getSize()
            for i = 1, size do
                playerItem.itemType = 1
                table.insert(newItemArray, playerItem)
            end
            popFlag = true
        end

        itemAdd = true
    end

    --仓库装备取回
    local scAddItemArray2 = s2cUpdateItemList.add_item_array_2
    for _, scItem in ipairs(scAddItemArray2) do
        local playerItem = lt.PlayerItem.new(scItem)
  
        local id = playerItem:getId()
        local modelId = playerItem:getModelId()

        itemTable[id] = playerItem

        if not isset(itemModelTable, modelId) then
            itemModelTable[modelId] = {}
        end
        itemModelTable[modelId][id] = true

        local combineTable = itemCombineTable[modelId]
        if not combineTable then
            combineTable = {}
            itemCombineTable[modelId] = combineTable
        end
        combineTable[id] = playerItem

        if isset(self.POTION_TABLE, modelId) then
            potionUpdate = true
        end

        itemAdd = true
    end

    local scSetItemArray = s2cUpdateItemList.set_item_array
    for _, scItem in ipairs(scSetItemArray) do
        local playerItem = lt.PlayerItem.new(scItem)

        local id = playerItem:getId()
        local modelId = playerItem:getModelId()

        local prePlayerItem = itemTable[id]
        local preItemCount  = 0

        if prePlayerItem then
           preItemCount = prePlayerItem:getSize()
        end

        itemTable[id] = playerItem        

        if not isset(itemModelTable, modelId) then
            itemModelTable[modelId] = {}
        end

        -- 进背包弹框
        local type = playerItem:getType()
        if isset(self.POP_ITEM_TYPE_TABLE, type) then
            local newItemCount = playerItem:getSize()
            if newItemCount > preItemCount then
                local addCount = newItemCount - preItemCount
                for i = 1, addCount do
                    playerItem.itemType = 1
                    table.insert(newItemArray, playerItem)
                end
                popFlag = true
            end
        end

        itemModelTable[modelId][id] = true

        local combineTable = itemCombineTable[modelId]
        if not combineTable then
            combineTable = {}
            itemCombineTable[modelId] = combineTable
        end
        combineTable[id] = playerItem

        if isset(self.POTION_TABLE, modelId) then
            potionUpdate = true
        end
    end

    local scDelItemIdArray = s2cUpdateItemList.del_item_id_array
    for _, id in ipairs(scDelItemIdArray) do
        local playerItem = itemTable[id]
        itemTable[id] = nil

        local modelId = playerItem:getModelId()
        local itemIdTable = itemModelTable[modelId]
        if itemIdTable then
            itemIdTable[id] = nil
        end

        local combineTable = itemCombineTable[modelId]
        if combineTable then
            combineTable[id] = nil
        end
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.BAG_ITEM_REFRESH, {refresh = true})

    if potionUpdate then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.POTION_UPDATE)
    end

    if itemAdd then
        -- 背包容量引导
        lt.GuideManager:checkSpecialGuide(lt.GuideInfo.SPECIAL_IDX.BAG_FULL)
    end

    if popFlag then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.NEW_ITEM_FLAG)
    end
end

function DataManager:getItem(itemId)
    local itemTable = self:getItemTable()
    return itemTable[itemId]
end

function DataManager:getBagAllItemCount()
    -- 装备数量
    local allEquipmentCount = self:getAllEquipmentCount()

    -- 道具数量
    local allItemCount = self:getAllItemCount()

    return allEquipmentCount + allItemCount
end

function DataManager:getAllItemCount()
    local itemTable = self:getItemTable()

    return lt.CommonUtil:calcHashTableLength(itemTable)
end

--判断背包有没有满 true=>满 false=>空  size 不足几格
function DataManager:checkBagFree(size)
    size = size or 0
    local maxBagSlot = self:getPlayer():getBagSize()
    local currentSlot = self:getBagAllItemCount()
    if currentSlot >= maxBagSlot - size then
        return true
    end

    return false
end

function DataManager:getAllItemArray()
    local itemTable = self:getItemTable()
    local itemModelTable = self:getItemModelTable()

    local itemModelIdArray = {}
    for itemModelId,_ in pairs(itemModelTable) do
        itemModelIdArray[#itemModelIdArray + 1] = itemModelId
    end

    local itemArray = {}
    for _,itemModelId in ipairs(itemModelIdArray) do
        local itemIdTable = itemModelTable[itemModelId]

        -- 需要从大到小排序
        -- 略

        for id,_ in pairs(itemIdTable) do
            if isset(itemTable, id) then
                itemArray[#itemArray + 1] = itemTable[id]
            else
                itemIdTable[id] = nil
            end
        end
    end
    return itemArray
end

function DataManager:getItemArray(itemModelId)
    local itemTable = self:getItemTable()
    local itemModelTable = self:getItemModelTable()

    if not isset(itemModelTable, itemModelId) then
        return {}
    end

    local itemIdTable = itemModelTable[itemModelId]
    local itemArray = {}
    for id,_ in pairs(itemIdTable) do
        if isset(itemTable, id) then
            itemArray[#itemArray + 1] = itemTable[id]
        else
            itemIdTable[id] = nil
        end
    end

    return itemArray
end

function DataManager:getItemCount(itemModelId)
    if itemModelId == lt.Constants.ITEM.DIAMOND then
        return self:getDiamond()
    end

    if itemModelId == lt.Constants.ITEM.COIN then
        return self:getCoin()
    end

    if itemModelId == lt.Constants.ITEM.GOLD then
        return self:getGold()
    end

    if itemModelId == lt.Constants.ITEM.GUILD_SCORE then
        return self:getGuildScore()
    end

    if itemModelId == lt.Constants.ITEM.COMPETION_SCORE then
        return self:getCompetitionScore()
    end

    if itemModelId == lt.Constants.ITEM.RISK_SCORE then
        return self:getRiskScore()
    end

    if itemModelId == lt.Constants.ITEM.EXPERIENCE_SCORE then
        return self:getExperienceScore()
    end

    if itemModelId == lt.Constants.ITEM.GOODMAN_SCORE then
        return self:getGoodManPoint()
    end

    if itemModelId == lt.Constants.ITEM.ENERGY then
        return self:getEnergy()
    end

    if itemModelId == lt.Constants.ITEM.HONOR_SCORE then
        return self:getHonorScore()
    end

    local itemArray = self:getItemArray(itemModelId)
    local itemCount = 0
    for _,playerItem in ipairs(itemArray) do
        itemCount = itemCount + playerItem:getSize()
    end

    return itemCount
end

function DataManager:getItemBySize(itemModelId, size)
    local itemArray = self:getItemArray(itemModelId)

    table.sort(itemArray, function(playerItem1, playerItem2)
        return playerItem1:getSize() < playerItem2:getSize()
    end)

    local returnArray = {}
    for _,playerItem in pairs(itemArray) do
        if size < 0 then
            break
        end

        returnArray[#returnArray + 1] = playerItem:getId()
        size = size - playerItem:getSize()
    end

    return returnArray
end

function DataManager:getItemBuyCountTable() 
    if not self._itemBuyCountTable then
        self._itemBuyCountTable = {}
    end
    return self._itemBuyCountTable
end

function DataManager:onGetShopBuyItemCountResponse(event)
    local s2cGetShopBuyItemCount = event.data
    lt.CommonUtil.print("s2cGetShopBuyItemCount code " .. s2cGetShopBuyItemCount.code)

    local itemBuyCountTable = self:getItemBuyCountTable()
    local dataTable = s2cGetShopBuyItemCount.data_array
    for _,v in ipairs(dataTable) do
        itemBuyCountTable[v.shop_item_id] = v.baught_count
    end
end

function DataManager:getItemArrayByType(itemType)
    local itemTable = self:getItemTable()
    local itemArray = {}

    for _,playerItem in pairs(itemTable) do
        local type = playerItem:getType()

        if type == itemType then
            itemArray[#itemArray + 1] = playerItem
        end
    end

    return itemArray
end

--[[ ################################################## rank ##################################################
    排行榜
    结构 table[]
    ]]


function DataManager:getRankTable()
    if not self._rankTable then
        self._rankTable = {}
    end
    return self._rankTable
end

function DataManager:resetRankTable()
    self._rankTable = {}
end

--[[ ################################################## storageBag ##################################################
    玩家仓库
    结构 table[]
    ]]

function DataManager:getStorageBagNum()
    return self._storageBagNum
end

function DataManager:getStorageTable()
    if not self._storageTable then
        self._storageTable = {}
    end

    return self._storageTable
end

function DataManager:getStorageAllItemTable()
    if not self._storageAllItemTable then
        self._storageAllItemTable = {}
    end

    return self._storageAllItemTable
end

function DataManager:getStorageItemById(id)
    local storageAllItemTable = self:getStorageAllItemTable()
    return storageAllItemTable[id]
end

function DataManager:getStorageAllEquipmentTable()
    if not self._storageAllEquipmentTable then
        self._storageAllEquipmentTable = {}
    end

    return self._storageAllEquipmentTable
end

function DataManager:getStorageEquipmentById(id)
    local storageAllEquipmentTable = self:getStorageAllEquipmentTable()
    return storageAllEquipmentTable[id]
end

function DataManager:getStorageBagByIndex(index)
    local storageTable = self:getStorageTable()
    return storageTable[index]
end

function DataManager:onGetStorageBagListResponse(event)
    local s2cGetStorageBagList = event.data
    lt.CommonUtil.print("s2cGetStorageBagList code " .. s2cGetStorageBagList.code)

    local storageTable = self:getStorageTable()
    local scStorageBagArray = s2cGetStorageBagList.storage_bag_array

    local storageAllItemTable = self:getStorageAllItemTable()
    local storageAllEquipmentTable = self:getStorageAllEquipmentTable()

    self._storageBagNum = #scStorageBagArray

    for _,scStorageBag in ipairs(scStorageBagArray) do
        local storageBagInfo = lt.StorageBag.new(scStorageBag)
        local index = storageBagInfo:getIndex()
        storageTable[index] = storageBagInfo

        local storageItemArray = storageBagInfo:getItemArray()
        for _,itemInfo in pairs(storageItemArray) do
            local id = itemInfo:getId()
            storageAllItemTable[id] = itemInfo
        end

        local storageEquipArray = storageBagInfo:getEquipmentArray()

        for _,equipInfo in pairs(storageEquipArray) do
            local id = equipInfo:getId()
            storageAllEquipmentTable[id] = equipInfo
        end

 
    end
end

function DataManager:onUpdateStorageBagListResponse(event)
    local s2cUpdateStorageList = event.data
    lt.CommonUtil.print("s2cUpdateStorageList code " .. s2cUpdateStorageList.code)

    local index = s2cUpdateStorageList.bag_index
    local storageBag = self:getStorageBagByIndex(index)

   
    local itemArray = storageBag:getItemArray()
    local equipmentArray = storageBag:getEquipmentArray()

    local storageAllItemTable = self:getStorageAllItemTable()
    local storageAllEquipmentTable = self:getStorageAllEquipmentTable()

    local scAddItemArray = s2cUpdateStorageList.add_item_array
    for _,scAddItem in ipairs(scAddItemArray) do
        local playerItem = lt.PlayerItem.new(scAddItem)
        local id = playerItem:getId()
        itemArray[id] = playerItem
        storageAllItemTable[id] = playerItem
    end

    local scSetItemArray = s2cUpdateStorageList.set_item_array
    for  _,scSetItem in ipairs(scSetItemArray) do
        local playerItem = lt.PlayerItem.new(scSetItem)
        local id = playerItem:getId()
        itemArray[id] = playerItem
        storageAllItemTable[id] = playerItem
    end

    local scDelItemIdArray = s2cUpdateStorageList.del_item_id_array
    for  _,id in ipairs(scDelItemIdArray) do
        itemArray[id] = nil
        storageAllItemTable[id] = nil
    end


    local scAddEquipmentArray = s2cUpdateStorageList.add_equipment_array
    for _,scAddEquipment in ipairs(scAddEquipmentArray) do
        local playerEquipment = lt.PlayerEquipment.new(scAddEquipment)
        local id = playerEquipment:getId()
        equipmentArray[id] = playerEquipment
        storageAllEquipmentTable[id] = playerEquipment
    end

    local scSetEquipmentArray = s2cUpdateStorageList.set_equipment_array
    for _,scSetEquipment in ipairs(scSetEquipmentArray) do
        local playerEquipment = lt.PlayerEquipment.new(scSetEquipment)
        local id = playerEquipment:getId()
        equipmentArray[id] = playerEquipment
        storageAllEquipmentTable[id] = playerEquipment
    end

    local scDelEquipmentIdArray = s2cUpdateStorageList.del_equipment_id_array
    for _,id in ipairs(scDelEquipmentIdArray) do
         equipmentArray[id] = nil
         storageAllEquipmentTable[id] = nil
    end

end
--[[ ################################################## playerDecoration ##################################################
    玩家头像气泡
    结构 table[]
    ]]
function DataManager:getDecorationListTabel()
    if not self._decorationListTable then
        self._decorationListTable = {}
    end
    return self._decorationListTable
end


function DataManager:onGetDecorationListResponse(event)
    local s2cOnGetDecotationListResponse = event.data
    lt.CommonUtil.print("s2cOnGetDecotationListResponse code "..s2cOnGetDecotationListResponse.code)

    local decorationListTable = self:getDecorationListTabel()

    local decotationArray = s2cOnGetDecotationListResponse.decoration_array

    for _,scDecotation in ipairs(decotationArray) do
        local decotationInfo = lt.Decoration.new(scDecotation)
        local id = decotationInfo:getId()
        decorationListTable[id] = decotationInfo
    end
end


function DataManager:onUpdataDecorationListResponse(event)
    local s2cOnUpdataDecorationListResponse = event.data
    lt.CommonUtil.print("s2cOnUpdataDecorationListResponse code "..s2cOnUpdataDecorationListResponse.code)
    local decorationListTable = self:getDecorationListTabel()
    local addDecorationArray = s2cOnUpdataDecorationListResponse.add_decoration_array

    --添加个性设置
    for _,scDecotation in ipairs(addDecorationArray) do
        local decotationInfo = lt.Decoration.new(scDecotation)
        local id = decotationInfo:getId()
        lt.CommonUtil.print("decotationInfo:getIsEquipped()========"..decotationInfo:getIsEquipped())
        decorationListTable[id] = decotationInfo
    end

    --修改个性设置
    local setDecorationArray = s2cOnUpdataDecorationListResponse.set_decoration_array
    for _,scDecotation in ipairs(setDecorationArray) do
        local decotationInfo = lt.Decoration.new(scDecotation)
        local id = decotationInfo:getId()
        lt.CommonUtil.print("decotationInfo:getIsEquipped()========"..decotationInfo:getIsEquipped())
        decorationListTable[id] = decotationInfo
    end

end

--################################################## Consumption ##################################################
--充值返利
function DataManager:getConsumptionRewardIdArray()
    if not self._consumptionRewardIdArray then
        self._consumptionRewardIdArray = {}
    end

    return self._consumptionRewardIdArray
end


function DataManager:getConsumptionInfoArray()

    if not self._consumptionInfoArray then
        self._consumptionInfoArray  = {}
    end

    return self._consumptionInfoArray
end

function DataManager:onGetConsumptionResponse(event)
    local s2cOnGetConsumptionResponse = event.data

    lt.CommonUtil.print("s2cOnGetConsumptionResponse code ========"..s2cOnGetConsumptionResponse.code)

    local dataArray = s2cOnGetConsumptionResponse.data_array
    
    self._consumptionInfoArray  = {}
    local consumptionInfoArray = self:getConsumptionInfoArray()

    for _,s2cConsumptionInfo in ipairs(dataArray) do
        local consumptionInfo = lt.ConsumptionInfo.new(s2cConsumptionInfo)
        consumptionInfoArray[#consumptionInfoArray + 1] = consumptionInfo
    end
    

    self._consumptionRewardIdArray = s2cOnGetConsumptionResponse.rewarded_id_array

end

--[[ ################################################## playerMail ##################################################
    玩家邮件
    结构 table[]
    ]]
function DataManager:getMailTable()
    if not self._mailTable then
        self._mailTable = {}
    end

    return self._mailTable
end

function DataManager:onGetMailListResponse(event)
    local s2cGetMailList = event.data
    lt.CommonUtil.print("s2cGetMailList code " .. s2cGetMailList.code)

    -- 邮件列表
    local mailTable = self:getMailTable()

    local scMailArray = s2cGetMailList.mail_array
    for _,scMail in ipairs(scMailArray) do
        local playerMail = lt.PlayerMail.new(scMail)
        mailTable[playerMail:getId()] = playerMail
    end
end

function DataManager:onUpdateMailListResponse(event)
    local s2cUpdateMailList = event.data
    lt.CommonUtil.print("s2cUpdateMailList code " .. s2cUpdateMailList.code)

    local mailTable = self:getMailTable()

    -- 新增邮件
    local scAddMailArray = s2cUpdateMailList.add_mail_array
    for _,scMail in ipairs(scAddMailArray) do
        local playerMail = lt.PlayerMail.new(scMail)
        mailTable[playerMail:getId()] = playerMail
    end

    -- 修改邮件
    local scSetMailArray = s2cUpdateMailList.set_mail_array
    for _,scMail in ipairs(scSetMailArray) do
        local playerMail = lt.PlayerMail.new(scMail)
        mailTable[playerMail:getId()] = playerMail
    end

    -- 删除邮件
    local scDeltMailIdArray = s2cUpdateMailList.del_mail_id_array
    for _,mailId in ipairs(scDeltMailIdArray) do
        mailTable[mailId] = nil
    end
end

function DataManager:getMail(mailId)
    local mailTable = self:getMailTable()
    return mailTable[mailId]
end

-- Bug提交
function DataManager:getLastSendBug()
    if not self._lastSendBug then
        self._lastSendBug = 0
    end

    return self._lastSendBug
end

function DataManager:setLastSendBug(time)
    self._lastSendBug = time
end

--[[ ################################################## playerActivity ##################################################
   ]]
function DataManager:getCurrentActPoint()
    return self._currentActPoint
end

function DataManager:getPlayerActivityTable()
    if not self._playerActivityTable then
        self._playerActivityTable = {}
    end
    return self._playerActivityTable
end

function DataManager:getActPointRewardTable()
    if not self._actPointRewardTable then
        self._actPointRewardTable = {}
    end
    return self._actPointRewardTable
end

function DataManager:onGetLivenessActivityList(event)
    local s2cGetLivenessActivityList = event.data
    lt.CommonUtil.print("s2cGetLivenessActivityList code " .. s2cGetLivenessActivityList.code)

    local activityArray = s2cGetLivenessActivityList.activity_array
    local playerActivityTable = self:getPlayerActivityTable()
    for i,v in ipairs(activityArray) do
        local playerActivity = lt.PlayerActivity.new(v)
        playerActivityTable[playerActivity:getActivityId()] = playerActivity
    end

    local actPoint = s2cGetLivenessActivityList.act_point

    self._currentActPoint = actPoint


    local actPointRewardArray = s2cGetLivenessActivityList.act_point_reward_array
    local actPointRewardTable = self:getActPointRewardTable()
    for k,v in ipairs(actPointRewardArray) do
        local actPointRewardInfo = lt.ActivityActPointReward.new(v)
        local actPoint = actPointRewardInfo:getActPoint()
        actPointRewardTable[actPoint] = actPointRewardInfo
    end
    
end

function DataManager:onUpdateLivenessActivityList(event)
    local s2cUpdateLivenessActivityList = event.data
    lt.CommonUtil.print("s2cUpdateLivenessActivityList code " .. s2cUpdateLivenessActivityList.code)

    local playerActivityTable = self:getPlayerActivityTable()
    local addActivityArray = s2cUpdateLivenessActivityList.add_activity_array
    for i,v in ipairs(addActivityArray) do
        local playerActivity = lt.PlayerActivity.new(v)
        playerActivityTable[playerActivity:getActivityId()] = playerActivity
    end

    local setActivityArray = s2cUpdateLivenessActivityList.set_activity_array
    for i,v in ipairs(setActivityArray) do
        local playerActivity = lt.PlayerActivity.new(v)
        playerActivityTable[playerActivity:getActivityId()] = playerActivity
    end

    local delActivityIdArray = s2cUpdateLivenessActivityList.del_activity_id_array
    for i,v in ipairs(delActivityIdArray) do
        playerActivityTable[v] = nil
    end


    if s2cUpdateLivenessActivityList:HasField('act_point') then

        local actPoint = s2cUpdateLivenessActivityList.act_point
 
        self._currentActPoint = actPoint
    end

    
    local scActPointRewardArray = s2cUpdateLivenessActivityList.set_act_point_reward_array
    local actPointRewardTable = self:getActPointRewardTable()

    for k,scActPointReward in ipairs(scActPointRewardArray) do
        local actPointRewardInfo = lt.ActivityActPointReward.new(scActPointReward)
        local actPoint = actPointRewardInfo:getActPoint()
        actPointRewardTable[actPoint] = actPointRewardInfo
    end
end

function DataManager:getPlayerActivity(activityId)
    local playerActivityTable = self:getPlayerActivityTable()
    return playerActivityTable[activityId]
end

function DataManager:setTreasurePushFlag(bool)
    self._treasurePushFlag = bool
end

function DataManager:getTreasurePushFlag()
    return self._treasurePushFlag
end

function DataManager:setGuardPushFlag(bool)
    self._guardPushFlag = bool
end

function DataManager:getGuardPushFlag()
    return self._guardPushFlag
end

function DataManager:setPkPushFlag(bool)
    self._pk = bool
end

function DataManager:getPkPushFlag()
    return self._pk
end

function DataManager:setFieldBossPushFlag(bool)
    self._fieldBoss = bool
end

function DataManager:getFieldBossPushFlag()
    return self._fieldBoss
end

function DataManager:setGuildFamFlag(bool)
    self._guildFam = bool
end

function DataManager:getGuildFamFlag()
    return self._guildFam
end

function DataManager:setMonsterAttackFlag(bool)
    self._monsterAttackFlag = bool
end

function DataManager:getMonsterAttackFlag()
    return self._monsterAttackFlag
end

function DataManager:setWorldBossFlag(bool)
    self._worldBossFlag = bool
end

function DataManager:getWorldBossFlag()
    return self._worldBossFlag
end

function DataManager:setQuestionFlag(bool)
    self._questionFlag = bool
end

function DataManager:getQuestionFlag()
    return self._questionFlag
end

function DataManager:setGuildBossFlag(bool)
    self._guildBossFlag = bool
end

function DataManager:getGuildBossFlag()
    return self._guildBossFlag
end

function DataManager:setCrazyDoctorFlag(bool)
    self._crazyDoctor = bool
end

function DataManager:getCrazyDoctorFlag()
    return self._crazyDoctor
end

function DataManager:getCurrentFieldBossId()
    local bossOpenTable = lt.DataManager:getMonsterPurificationFieldTable()
    local bossOpenArray = lt.CommonUtil:getArrayFromTable(bossOpenTable)
    local playerLevel = self:getPlayerLevel()
    table.sort(bossOpenArray,function(info1,info2)

        return info1:getMonsterLevel() > info2:getMonsterLevel()

    end)

    local currentLevel = 0
    local bossId = nil

    for i = 1, #bossOpenArray do
        local level = bossOpenArray[i]:getMonsterLevel()

        if playerLevel >= level then
            currentLevel = level
            bossId = bossOpenArray[i]:getBossId()
            break
        end 

    end

    return bossId
end

function DataManager:getActivityOpenTable()
    if not self._activityOpenTable then
        self._activityOpenTable = {}
    end

    return self._activityOpenTable
end


function DataManager:onGetActivityLivenessTime(event) --限时活动
    local s2cOnGetAcitivityLivenessTimeResponse = event.data

    local code = s2cOnGetAcitivityLivenessTimeResponse.code

    lt.CommonUtil.print("s2cOnGetAcitivityLivenessTimeResponse code=========="..code)

    local timeArray = s2cOnGetAcitivityLivenessTimeResponse.time_array

    local activityOpenTable = self:getActivityOpenTable()

    for k,v in ipairs(timeArray) do

        local idValuePair = lt.IdValuePair.new(v)
        local id = idValuePair:getId()
        local value = idValuePair:getValue()

        activityOpenTable[id] = value
    end

end

function DataManager:onUpdateActivityLivenessTime(event) --限时活动

    local s2cOnUpdateActivityLivenessTimeResponse = event.data

    local code = s2cOnUpdateActivityLivenessTimeResponse.code

    lt.CommonUtil.print("s2cOnUpdateActivityLivenessTimeResponse code=========="..code)

    local timeArray = s2cOnUpdateActivityLivenessTimeResponse.set_time_array

    local activityOpenTable = self:getActivityOpenTable()

    for k,v in ipairs(timeArray) do

        local idValuePair = lt.IdValuePair.new(v)
        local id = idValuePair:getId()
        local value = idValuePair:getValue()
        
        activityOpenTable[id] = value
    end
end

---- ################################################## 任务处理 ##################################################
function DataManager:checkMonsterKill(monsterId)
    if not monsterId then
        return
    end

    for taskType,checkInfo in pairs(self._caseMonsterKillTable) do
        local _monsterId = checkInfo.monsterId
        if _monsterId == monsterId then
            local curCount  = checkInfo.cur or 0
            local allCount  = checkInfo.all or 0
            local type      = checkInfo.type or 0

            curCount = curCount + 1
            checkInfo.cur = curCount

            if type == lt.Constants.TASK_TARGET_TYPE.COMPLETE_DUNGEON then
                if curCount > allCount then
                    -- 请求更新数据
                    lt.SocketApi:getTask(taskType)
                end
            else
                if curCount > allCount then
                    -- 击杀超过需求2只
                    if (curCount - allCount) % 3 == 0 then
                        -- 请求更新数据
                        lt.SocketApi:getTask(taskType)
                    end
                end
            end
        end
    end
end

function DataManager:onGetTaskResponse(event)
    local s2cGetTask = event.data
    local code = s2cGetTask.code
    lt.CommonUtil.print("s2cGetTask code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end
end

---- ################################################## 主线任务 ##################################################
function DataManager:getPlayerTaskTable()
    if not self._playerTaskTable then
        self._playerTaskTable = {}
    end

    return self._playerTaskTable
end

function DataManager:onGetMainTaskResponse(event)
    local s2cGetMainTask = event.data
    local code = s2cGetMainTask.code
    lt.CommonUtil.print("s2cGetMainTask code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end
    
    -- lt.CommonUtil.print("s2cGetMainTask content\n "..tostring(s2cGetMainTask))

    local s2cPlyMainTask = s2cGetMainTask.main_task
    self._mainTask = lt.PlayerMainTask.new(s2cPlyMainTask)

    local playerTaskTable = self:getPlayerTaskTable()
    playerTaskTable[-1] = self._mainTask

    local taskId = self._mainTask:getTaskId()
    local taskIdArray = {taskId}
    lt.GameEventManager:post(lt.GameEventManager.EVENT.TASK_UPDATE, {taskIdArray = taskIdArray})

    if self._mainTask:getTargetType() == lt.Constants.TASK_TARGET_TYPE.KILL_MONSTER 
    or self._mainTask:getTargetType() == lt.Constants.TASK_TARGET_TYPE.COMPLETE_DUNGEON then
        self._caseMonsterKillTable[1] = {monsterId = self._mainTask:getTargetContent().monsterId or 0, cur = self._mainTask:getCurCount(), all = self._mainTask:getAllCount(), task = self._mainTask, type = self._mainTask:getTargetType()}
    else
        self._caseMonsterKillTable[1] = nil
    end
end

function DataManager:getMainTask()
    return self._mainTask
end

function DataManager:onGetCurTaskListResponse(event)
    local s2cGetCurTaskList = event.data
    local code = s2cGetCurTaskList.code
    lt.CommonUtil.print("s2cGetCurTaskList code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cGetCurTaskList content\n "..tostring(s2cGetCurTaskList))

    local playerTaskTable = self:getPlayerTaskTable()
    local scCurTaskArray = s2cGetCurTaskList.cur_task_array or {}
    for _,scCurTask in ipairs(scCurTaskArray) do
        local playerTask = lt.PlayerTask.new(scCurTask)

        local taskId = playerTask:getTaskId()
        playerTaskTable[taskId] = playerTask
    end
end

function DataManager:onUpdateCurTaskListResponse(event)
    local s2cUpdateCurTaskList = event.data
    local code = s2cUpdateCurTaskList.code
    lt.CommonUtil.print("s2cUpdateCurTaskList code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cUpdateCurTaskList content\n "..tostring(s2cUpdateCurTaskList))

    local taskIdArray = {}

    local playerTaskTable = self:getPlayerTaskTable()
    local scAddCurTaskArray = s2cUpdateCurTaskList.add_cur_task_array
    for _,scCurTask in ipairs(scAddCurTaskArray) do
        local playerTask = lt.PlayerTask.new(scCurTask)

        local taskId = playerTask:getTaskId()
        playerTaskTable[taskId] = playerTask

        table.insert(taskIdArray, taskId)
    end

    local scSetCurTaskArray = s2cUpdateCurTaskList.set_cur_task_array
    for _,scCurTask in ipairs(scSetCurTaskArray) do
        local playerTask = lt.PlayerTask.new(scCurTask)

        local taskId = playerTask:getTaskId()
        playerTaskTable[taskId] = playerTask

        table.insert(taskIdArray, taskId)
    end

    local scDelCurTaskArray = s2cUpdateCurTaskList.del_cur_task_array
    for _,scCurTask in ipairs(scDelCurTaskArray) do
        local taskId = scCurTask.task_id

        playerTaskTable[taskId] = nil
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.TASK_UPDATE, {taskIdArray = taskIdArray})
end

function DataManager:getPlayerTask(taskId)
    local playerTaskTable = self:getPlayerTaskTable()
    return playerTaskTable[taskId]
end

function DataManager:onDoTheTaskResponse(event)
    local s2cDoTheTask = event.data
    local code = s2cDoTheTask.code
    lt.CommonUtil.print("s2cDoTheTask code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cDoTheTask content\n"..tostring(s2cDoTheTask))

    local taskId = s2cDoTheTask.task_id
    
    local isDone = s2cDoTheTask.is_done
    if isDone == 1 then
        -- 任务完成特效
        lt.NoticeManager:onTaskComplete(taskId)
    end
    
    -- 任务引导(完成后出发的)
    lt.GuideManager:checkTaskCompleteGuide(taskId)
end

function DataManager:onRewardNotifyResponse(event)
    local s2cRewardNotify = event.data
    -- lt.CommonUtil.print("s2cRewardNotify content\n"..tostring(s2cRewardNotify))

    local type = s2cRewardNotify.type or 0
    if type == 1 then
        -- 迷宫完成
        lt.NoticeManager:addMessageString("STRING_MAZE_TARGET_COMPLETE")
    end

    local scGainItemArray = s2cRewardNotify.gain_item_array
    for _,scGainItem in ipairs(scGainItemArray) do
        local simpleItemInfo = lt.SimpleItemInfo.new(scGainItem)
        lt.NoticeManager:addSimpleItemMessage(simpleItemInfo)
    end
end

function DataManager:hasTask()
    local playerTaskTable = self:getPlayerTaskTable()
    for _,playerTask in pairs(playerTaskTable) do
        if not playerTask:isDown() then
            return true
        end
    end

    -- 冒险试炼
    local activityAdventureTrail = self:getActivityAdventureTrail()
    if activityAdventureTrail and activityAdventureTrail:getExistFlag() then
        return true
    end

    -- 冒险任务
    local activityAdventureTask = self:getActivityAdventureTask()
    if activityAdventureTask and activityAdventureTask:getExistFlag() then
        return true
    end

    return false
end

-- ################################################## 冒险试炼/冒险任务 ##################################################
function DataManager:getActivityTaskTable(taskType)
    if not self._activityTaskTable then
        self._activityTaskTable = {}
    end

    if not isset(self._activityTaskTable, taskType) then
        self._activityTaskTable[taskType] = {}
    end

    return self._activityTaskTable[taskType]
end

function DataManager:_getActivityTask(taskType, taskId)
    local activityTaskTable = self:getActivityTaskTable(taskType)
    return activityTaskTable[taskId]
end

-- 获得 冒险试炼 信息
function DataManager:getActivityAdventureTrail()
    return self:_getActivityTask(1, lt.Constants.ACTIVITY.ADVENTURE_TRIAL)
end

-- 获得 冒险任务 信息
function DataManager:getActivityAdventureTask()
    return self:_getActivityTask(2, lt.Constants.ACTIVITY.ADVENTURE_TASK)
end

-- 获得 公会建设 信息
function DataManager:getActivityGuildBuildTask()
    return self:_getActivityTask(2, lt.Constants.ACTIVITY.GUILD_BUILD)
end

-- 获得 魔物净化 信息
function DataManager:getActivityMonsterPurification()
    return self:_getActivityTask(3, lt.Constants.ACTIVITY.MONSTER_PURIFICATION)
end

-- 获得 深渊领主 信息
function DataManager:getActivityPitlordTask()
    return self:_getActivityTask(3, lt.Constants.ACTIVITY.PITLORD)
end

--获得 魔王的宝藏 信息
function DataManager:getActivityTreasureTask()
    return self:_getActivityTask(3, lt.Constants.ACTIVITY.TREASURE)
end

-- 获得 守卫遗迹 信息
function DataManager:getActivityGuard()
    return self:_getActivityTask(3, lt.Constants.ACTIVITY.GUARD)
end

-- 获得 工会秘境 信息
function DataManager:getActivityGuildFam()
    return self:_getActivityTask(3, lt.Constants.ACTIVITY.GUILD_FAM)
end

-- 获得 世界答题 信息
function DataManager:getActivityWorldAnswer()
    return self:_getActivityTask(3, lt.Constants.ACTIVITY.WORLD_ANSWER)
end

-- 获得 极限挑战 信息
function DataManager:getActivityWorldBoss()
    return self:_getActivityTask(3, lt.Constants.ACTIVITY.WORLD_BOSS)
end

-- 获得 魔物入侵 信息
function DataManager:getActivityCreamBoss()
    return self:_getActivityTask(3, lt.Constants.ACTIVITY.CREAM_BOSS)
end

-- 冒险试炼任务
function DataManager:onActivityTaskProgress(event)
    local s2cActivityTaskProgress = event.data
    local code = s2cActivityTaskProgress.code
    lt.CommonUtil.print("s2cActivityTaskProgress code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cActivityTaskProgress content\n"..tostring(s2cActivityTaskProgress))

    local status = 0
    local activityTaskTable = self:getActivityTaskTable(1)
    local scActivityTaskAddList = s2cActivityTaskProgress.add_task_list
    for _,scActivityTask in ipairs(scActivityTaskAddList) do
        local activityTask = lt.ActivityTask.new(scActivityTask)
        local taskId = activityTask:getTaskId()
        local preActivityTask = activityTaskTable[taskId]
        activityTaskTable[taskId] = activityTask

        if preActivityTask and preActivityTask:getReceiveTaskFlag() == 0 and activityTask:getReceiveTaskFlag() == 1 then
            status = 1
        end
    end

    local scActivityTaskSetList = s2cActivityTaskProgress.set_task_list
    for _,scActivityTask in ipairs(scActivityTaskSetList) do
        local activityTask = lt.ActivityTask.new(scActivityTask)
        local taskId = activityTask:getTaskId()
        local preActivityTask = activityTaskTable[taskId]
        activityTaskTable[taskId] = activityTask

        if preActivityTask and preActivityTask:getReceiveTaskFlag() == 0 and activityTask:getReceiveTaskFlag() == 1 then
            status = 1
        end
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.TASK_UPDATE, {adventureTrial = true, status = status})
end

function DataManager:onReceiveActivityTask(event)
    local s2cReceiveActivityTask = event.data
    local code = s2cReceiveActivityTask.code
    lt.CommonUtil.print("s2cReceiveActivityTask code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        local taskType = s2cReceiveActivityTask.task_type
        local taskId   = s2cReceiveActivityTask.task_id

        if code == lt.SocketConstants.CODE_LEVEL_NOT_REACHED then
            if taskType == 1 then 
                if taskId == lt.Constants.ACTIVITY.ADVENTURE_TRIAL then
                    lt.NoticeManager:addMessageString("STRING_ERROR_10010_2")
                end
            end
        elseif code == lt.SocketConstants.CODE_TEAM_PLAYER_COUNT_ERR then
            if taskType == 1 then 
                if taskId == lt.Constants.ACTIVITY.ADVENTURE_TRIAL then
                    -- 冒险试炼
                    local activityInfo = lt.CacheManager:getActivityInfo(taskId)
                    if activityInfo then
                        local teamPlayerMin = activityInfo:getTeamPlayerMin()
                        lt.NoticeManager:addMessage(lt.StringManager:getFormatString("STRING_ERROR_11083", teamPlayerMin))
                    end
                end
            end
        elseif code == lt.SocketConstants.CODE_TASK_COUNT_IS_OVER then
            lt.NoticeManager:addMessageString("STRING_ERROR_11139")
        end
        return
    end

    -- lt.CommonUtil.print("s2cReceiveActivityTask content\n"..tostring(s2cReceiveActivityTask))
end

--[[
    冒险任务/公会建设

    2017/6/26 高瑞&夏伟定义:
    定义 CurCount 从1~10 表示当前正在进行的序号
    定义 AllCount 从0~ 表示当前已经完成的任务
    所以第一组数据为 CurCount:1 AllCount:0
]]
function DataManager:onActivityTask2Progress(event)
    local s2cActivityTask2Progress = event.data
    local code = s2cActivityTask2Progress.code
    lt.CommonUtil.print("s2cActivityTask2Progress code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cActivityTask2Progress content\n"..tostring(s2cActivityTask2Progress))

    local adventureTaskUpdate = false
    local guildBuildTaskUpdate = false

    local preAdventureTask = self:getActivityAdventureTask()

    local activityTaskTable = self:getActivityTaskTable(2)

    local scActivityTaskList = s2cActivityTask2Progress.add_activity_task_list
    for _,scActivityTask in ipairs(scActivityTaskList) do
        local activityTask = lt.ActivityTask2.new(scActivityTask)
        local taskId = activityTask:getTaskId()

        activityTaskTable[taskId] = activityTask

        if taskId == lt.Constants.ACTIVITY.ADVENTURE_TASK then
            adventureTaskUpdate = true
        elseif taskId == lt.Constants.ACTIVITY.GUILD_BUILD then
            guildBuildTaskUpdate = true
        end
    end

    local scActivityTaskList = s2cActivityTask2Progress.set_activity_task_list
    for _,scActivityTask in ipairs(scActivityTaskList) do
        local activityTask = lt.ActivityTask2.new(scActivityTask)
        local taskId = activityTask:getTaskId()

        activityTaskTable[taskId] = activityTask

        if taskId == lt.Constants.ACTIVITY.ADVENTURE_TASK then
            adventureTaskUpdate = true
        elseif taskId == lt.Constants.ACTIVITY.GUILD_BUILD then
            guildBuildTaskUpdate = true
        end
    end

    local adventureTaskRound20Ask = false
    local adventureTaskRound10Stop = false
    if adventureTaskUpdate then
        -- 冒险任务更新
        local newAdventureTask = self:getActivityAdventureTask()
        if preAdventureTask and newAdventureTask and preAdventureTask:getAllCount() == (lt.Constants.ADVENTURE_TASK_MAX_ROUND_HIGH - 1) and newAdventureTask:getAllCount() == lt.Constants.ADVENTURE_TASK_MAX_ROUND_HIGH then
            -- 20轮已满
            adventureTaskRound20Ask = true
        end

        if preAdventureTask and newAdventureTask and preAdventureTask:getCurCount() == 10 and newAdventureTask:getCurCount() == 1 then
            -- 10轮已满
            adventureTaskRound10Stop = true
        end
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.TASK_UPDATE, {adventureTaskUpdate = adventureTaskUpdate, adventureTaskRound20Ask = adventureTaskRound20Ask, adventureTaskRound10Stop = adventureTaskRound10Stop, guildBuildTaskUpdate = guildBuildTaskUpdate})

    -- 怪物击杀关心(掉线数据异常处理)
    if adventureTaskUpdate then
        -- 冒险任务
        local adventureTask = self:getActivityAdventureTask()
        if adventureTask and adventureTask:getTargetType() == lt.Constants.TASK_TARGET_TYPE.KILL_MONSTER then
            self._caseMonsterKillTable[2] = {monsterId = self._mainTask:getTargetContent().monsterId or 0, cur = adventureTask:getCurCount(), all = adventureTask:getAllCount(), task = adventureTask}
        else
            self._caseMonsterKillTable[2] = nil
        end
    end

    if guildBuildTaskUpdate then
        -- 公会建设
        local guildBuildTask = lt.DataManager:getActivityGuildBuildTask()
        if guildBuildTask and guildBuildTask:getTargetType() == lt.Constants.TASK_TARGET_TYPE.KILL_MONSTER then
            self._caseMonsterKillTable[3] = {monsterId = self._mainTask:getTargetContent().monsterId or 0, cur = guildBuildTask:getCurCount(), all = guildBuildTask:getAllCount(), task = guildBuildTask}
        else
            self._caseMonsterKillTable[3] = nil
        end
    end
end

function DataManager:onActivityTask3Progress(event)
    local  s2cActivityTask3Progress = event.data
    local code = s2cActivityTask3Progress.code

    lt.CommonUtil.print("s2cActivityTask3Progress code "..code)

    local activityTaskTable = self:getActivityTaskTable(3)
    local scAddTaskList = s2cActivityTask3Progress.add_task_list
    for _,scActivityTask in ipairs(scAddTaskList) do
        local activityTask = lt.ActivityTask3.new(scActivityTask)
        activityTaskTable[activityTask:getTaskId()] = activityTask
    end

    local scSetTaskList = s2cActivityTask3Progress.set_task_list
    for _,scActivityTask in ipairs(scSetTaskList) do
        local activityTask = lt.ActivityTask3.new(scActivityTask)
        activityTaskTable[activityTask:getTaskId()] = activityTask
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.TASK_UPDATE)
end

function DataManager:onDoAdventureTaskResponse(event)
    local s2cDoAdventureTask = event.data
    local code = s2cDoAdventureTask.code
    lt.CommonUtil.print("s2cDoAdventureTask code "..code)
end

-- ################################################## 活动-魔物入侵/怪物侵袭 CreamBoss MonsterAttack ##################################################
function DataManager:getCreamBossTable()
    if not self._creamBossTable then
        self._creamBossTable = {}
    end

    return self._creamBossTable
end

function DataManager:getCreamBossArray(worldMapId)
    local creamBossArray = {}

    local creamBossTable = self:getCreamBossTable()
    for _,activityCreamBoss in pairs(creamBossTable) do
        if activityCreamBoss:isExist() and activityCreamBoss:getMapId() == worldMapId then
            creamBossArray[#creamBossArray + 1] = activityCreamBoss
        end
    end

    return creamBossArray
end

function DataManager:getCreamBoss(npcId)
    local creamBossTable = self:getCreamBossTable()
    return creamBossTable[npcId]
end

function DataManager:hasCreamBoss()
    local creamBossTable = self:getCreamBossTable()
    for _,activityCreamBoss in pairs(creamBossTable) do
        if activityCreamBoss:isExist() then
            return true
        end
    end

    return false
end

function DataManager:getCreamBossWorldMapIdTable()
    local createBossWorldMapIdTable = {}

    local creamBossTable = self:getCreamBossTable()
    for _,activityCreamBoss in pairs(creamBossTable) do
        if activityCreamBoss:isExist() then
            createBossWorldMapIdTable[activityCreamBoss:getMapId()] = true
        end
    end

    return createBossWorldMapIdTable
end

function DataManager:getMonsterAttackTable()
    if not self._monsterAttackTable then
        self._monsterAttackTable = {}
    end

    return self._monsterAttackTable
end

function DataManager:getMonsterAttackArray(worldMapId)
    local monsterAttackArray = {}

    local monsterAttackTable = self:getMonsterAttackTable()
    for _,activityCreamBoss in pairs(monsterAttackTable) do
        if activityCreamBoss:isExist() and activityCreamBoss:getMapId() == worldMapId then
            monsterAttackArray[#monsterAttackArray + 1] = activityCreamBoss
        end
    end

    return monsterAttackArray
end

function DataManager:getMonsterAttack(npcId)
    local monsterAttackTable = self:getMonsterAttackTable()
    return monsterAttackTable[npcId]
end

function DataManager:hasMonsterAttack()
    local monsterAttackTable = self:getMonsterAttackTable()
    for _,activityCreamBoss in pairs(monsterAttackTable) do
        if activityCreamBoss:isExist() then
            return true
        end
    end

    return false
end

function DataManager:getMonsterAttackCount()
    local count = 0

    local monsterAttackTable = self:getMonsterAttackTable()
    for _,activityCreamBoss in pairs(monsterAttackTable) do
        if activityCreamBoss:isExist() then
            count = count + 1
        end
    end

    return count
end

function DataManager:onGetActivityCreamBossFlush(event)
    local s2cGetActivityCreamBossFlush = event.data
    lt.CommonUtil.print("s2cGetActivityCreamBossFlush OK")
    -- lt.CommonUtil.print("s2cGetActivityCreamBossFlush content\n"..tostring(s2cGetActivityCreamBossFlush))

    local activityId = s2cGetActivityCreamBossFlush.activity_id
    local scAddBossArray = s2cGetActivityCreamBossFlush.add_boss_array

    if activityId == lt.Constants.ACTIVITY.CREAM_BOSS then
        -- 魔物入侵
        local creamBossTable = self:getCreamBossTable()
        for _,scCmnActivityCreamBossFlush in ipairs(scAddBossArray) do
            local activityCreamBoss = lt.ActivityCreamBoss.new(scCmnActivityCreamBossFlush)
            local npcId = activityCreamBoss:getNpcId()
            creamBossTable[npcId] = activityCreamBoss
        end
    elseif activityId == lt.Constants.ACTIVITY.MONSTER_ATTACK then
        -- 怪物侵袭 
        local monsterAttackTable = self:getMonsterAttackTable()
        for _,scCmnActivityCreamBossFlush in ipairs(scAddBossArray) do
            local activityCreamBoss = lt.ActivityCreamBoss.new(scCmnActivityCreamBossFlush)
            local npcId = activityCreamBoss:getNpcId()
            monsterAttackTable[npcId] = activityCreamBoss
        end
    end

    if self._flush then
        if activityId == lt.Constants.ACTIVITY.CREAM_BOSS then
            local mapIdTable = {}
            local creamBossTable = self:getCreamBossTable()
            for _,activityCreamBoss in pairs(creamBossTable) do
                if activityCreamBoss:isExist() then
                    local mapId = activityCreamBoss:getMapId()
                    mapIdTable[mapId] = true
                end
            end

            local mapStr = ""
            local idx = 0
            for mapId,_ in pairs(mapIdTable) do
                if idx > 0 then
                    mapStr = mapStr..","
                end

                local worldMap = lt.CacheManager:getWorldMap(mapId)
                if worldMap then
                    mapStr = mapStr .. worldMap:getTitle()
                end

                idx = idx + 1
            end
            if idx > 0 then
                local tips1 = lt.StringManager:getString("STRING_ACTIVITY_CREAM_BOSS_REFRESH_1")
                local tips2 = lt.StringManager:getString("STRING_ACTIVITY_CREAM_BOSS_REFRESH_2")
                local chatInfo = lt.Chat.new()
                chatInfo:setChannel(lt.Constants.CHAT_TYPE.SYSTEM)
                chatInfo:setSenderName("system")
                chatInfo:setSendTime(lt.CommonUtil:getCurrentTime())
                chatInfo:setMessage({{message = tips1},{message = mapStr,color = lt.Constants.COLOR.GREEN},{message = tips2}})
                chatInfo:setSubType(lt.Constants.CHAT_SUB_TYPE.NORMAL)
                self:addSystemChatInfo(chatInfo)
                lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_SYSTEM, {chatInfo=chatInfo})
            end
        elseif activityId == lt.Constants.ACTIVITY.MONSTER_ATTACK then
            local exist = false
            local monsterAttackTable = self:getMonsterAttackTable()
            for _,activityCreamBoss in pairs(monsterAttackTable) do
                if activityCreamBoss:isExist() then
                    exist = true
                end
            end

            if exist then
                local tips = lt.StringManager:getString("STRING_ACTIVITY_MONSTER_ATTACK_REFRESH")
                local chatInfo = lt.Chat.new()
                chatInfo:setChannel(lt.Constants.CHAT_TYPE.GUILD)
                chatInfo:setSendTime(lt.CommonUtil:getCurrentTime())
                chatInfo:setMessage(tips)
                chatInfo:setSubType(lt.Constants.CHAT_SUB_TYPE.NORMAL)
                self:addGuildChatInfo(chatInfo)
                lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_GUILD, {chatInfo=chatInfo})
            end
        end

        -- 数据刷新
        lt.GameEventManager:post(lt.GameEventManager.EVENT.CREAM_BOSS_REFRESH, {activityId = activityId})
    end
end

function DataManager:onUpdateActivityCreamBossFlush(event)
    local s2cUpdateActivityCreamBossFlush = event.data
    lt.CommonUtil.print("s2cUpdateActivityCreamBossFlush OK")
    -- lt.CommonUtil.print("s2cUpdateActivityCreamBossFlush content\n"..tostring(s2cUpdateActivityCreamBossFlush))

    local activityId = s2cUpdateActivityCreamBossFlush.activity_id
    local scSetBossArray = s2cUpdateActivityCreamBossFlush.set_boss_array

    if activityId == lt.Constants.ACTIVITY.CREAM_BOSS then
        -- 魔物入侵
        local creamBossTable = self:getCreamBossTable()
        for _,scCmnActivityCreamBossFlush in ipairs(scSetBossArray) do
            local activityCreamBoss = lt.ActivityCreamBoss.new(scCmnActivityCreamBossFlush)
            local npcId = activityCreamBoss:getNpcId()
            creamBossTable[npcId] = activityCreamBoss
        end
    elseif activityId == lt.Constants.ACTIVITY.MONSTER_ATTACK then
        -- 怪物侵袭
        local monsterAttackTable = self:getMonsterAttackTable()
        for _,scCmnActivityCreamBossFlush in ipairs(scSetBossArray) do
            local activityCreamBoss = lt.ActivityCreamBoss.new(scCmnActivityCreamBossFlush)
            local npcId = activityCreamBoss:getNpcId()
            monsterAttackTable[npcId] = activityCreamBoss
        end

        -- 本次击杀提示
        local killerStrs = ""
        local scKillPlayerArray = s2cUpdateActivityCreamBossFlush.kill_player_array
        for i,killerStr in ipairs(scKillPlayerArray) do
            if i > 1 then
                killerStrs = killerStrs .. ","
            end

            killerStrs = killerStrs..killerStr
        end
        local tips = lt.StringManager:getString("STRING_ACTIVITY_MONSTER_ATTACK_KILL")
        local chatInfo = lt.Chat.new()
        chatInfo:setChannel(lt.Constants.CHAT_TYPE.GUILD)
        chatInfo:setSendTime(lt.CommonUtil:getCurrentTime())
        chatInfo:setMessage({{message = killerStrs, color = lt.Constants.COLOR.BLUE},{message = tips}})
        chatInfo:setSubType(lt.Constants.CHAT_SUB_TYPE.NORMAL)
        self:addGuildChatInfo(chatInfo)
        lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_GUILD, {chatInfo=chatInfo})

        -- 全部击杀提示
        local allKilled = true
        for _,activityCreamBoss in pairs(monsterAttackTable) do
            if activityCreamBoss:isExist() then
                allKilled = false
                break
            end
        end
        if allKilled then
            local tips = lt.StringManager:getString("STRING_ACTIVITY_MONSTER_ATTACK_ALL_KILL")
            local chatInfo = lt.Chat.new()
            chatInfo:setChannel(lt.Constants.CHAT_TYPE.GUILD)
            chatInfo:setSendTime(lt.CommonUtil:getCurrentTime())
            chatInfo:setMessage(tips)
            chatInfo:setSubType(lt.Constants.CHAT_SUB_TYPE.NORMAL)
            self:addGuildChatInfo(chatInfo)
            lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_GUILD, {chatInfo=chatInfo})
        end
    end

    -- 数据更新
    lt.GameEventManager:post(lt.GameEventManager.EVENT.CREAM_BOSS_UPDATE, {activityId = activityId})
end

function DataManager:onDeleteActivityCreamBossFlush(event)
    local s2cDeleteActivityCreamBossFlush = event.data
    lt.CommonUtil.print("s2cDeleteActivityCreamBossFlush OK")

    local activityId = s2cDeleteActivityCreamBossFlush.activity_id

    if activityId == lt.Constants.ACTIVITY.CREAM_BOSS then
        self._creamBossTable = {}
    elseif activityId == lt.Constants.ACTIVITY.MONSTER_ATTACK then
        self._monsterAttackTable = {}
    end

    -- 数据清理
    lt.GameEventManager:post(lt.GameEventManager.EVENT.CREAM_BOSS_DELETE, {activityId = activityId})
end

function DataManager:setLastGuildChatTime(time)
    self._lastGuildChatTime = time
end

function DataManager:getLastGuildChatTime()
    return self._lastGuildChatTime
end
-- ################################################## 魔物净化 MonsterPurification ##################################################
function DataManager:getMonsterPurificationTable()
    if not self._monsterPurificationTable then
        self._monsterPurificationTable = {}
    end

    return self._monsterPurificationTable
end

function DataManager:getMonsterPurificationFieldTable()
    if not self._monsterPurificationFieldTable then
        self._monsterPurificationFieldTable = {}
    end

    return self._monsterPurificationFieldTable
end

function DataManager:onGetMonsterPurificationElement(event)
    local s2cGetMonsterPurificationElement = event.data
    local code = s2cGetMonsterPurificationElement.code
    lt.CommonUtil.print("s2cGetMonsterPurificationElement code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    --lt.CommonUtil.print("s2cGetMonsterPurificationElement content\n"..tostring(s2cGetMonsterPurificationElement))
    
    local monsterPurificationTable = self:getMonsterPurificationTable()
    local activityInfoArray = s2cGetMonsterPurificationElement.activityInfo or {}
    for _,scActivityMonsterPurification in ipairs(activityInfoArray) do
        local activityMonsterPurification = lt.ActivityMonsterPurification.new(scActivityMonsterPurification)
        monsterPurificationTable[activityMonsterPurification:getSequenceId()] = activityMonsterPurification
    end
end

function DataManager:onGetMonsterPurificationFieldElement(event)
    local s2cGetMonsterPurificationFieldElement = event.data
    lt.CommonUtil.print("s2cGetMonsterPurificationFieldElement")

    --lt.CommonUtil.print("s2cGetMonsterPurificationFieldElement content\n"..tostring(s2cGetMonsterPurificationFieldElement))

    local monsterPurificationTable = self:getMonsterPurificationFieldTable()
    local activityInfoArray = s2cGetMonsterPurificationFieldElement.add_boss_array or {}
    for _,scActivityMonsterPurification in pairs(activityInfoArray) do
        if scActivityMonsterPurification.boss_id then

            local activityMonsterPurification = lt.ActivityMonsterPurificationField.new(scActivityMonsterPurification)
            monsterPurificationTable[activityMonsterPurification:getBossId()] = activityMonsterPurification
        end
    end

    if s2cGetMonsterPurificationFieldElement.set_boss_array then
        for _,scActivityMonsterPurification in pairs(s2cGetMonsterPurificationFieldElement.set_boss_array) do
            if scActivityMonsterPurification.boss_id then
                local activityMonsterPurification = lt.ActivityMonsterPurificationField.new(scActivityMonsterPurification)
                monsterPurificationTable[activityMonsterPurification:getBossId()] = activityMonsterPurification
            end
        end
    end
    lt.GameEventManager:post(lt.GameEventManager.EVENT.ACTIVITY_WORLD_BOSS_FLUSH)
end

function DataManager:getMonsterPurification(sequenceId)
    local monsterPurificationTable = self:getMonsterPurificationTable()
    return monsterPurificationTable[sequenceId]
end

function DataManager:getMonsterPurificationField(bossId)
    local monsterPurificationTable = self:getMonsterPurificationFieldTable()
    return monsterPurificationTable[bossId]
end

function DataManager:getMonsterPurificationKillTable(flag)
    if not self._monsterPurificationKillTable or flag then
        self._monsterPurificationKillTable = {}
    end

    return self._monsterPurificationKillTable
end

function DataManager:onMonsterPurificationKillInfo(event)
    local s2cGetMonsterPurificationElement = event.data

    lt.CommonUtil.print("s2cMonsterPurificationKillInfo ok")

    local monsterPurificationTable = self:getMonsterPurificationKillTable(true)
    local activityInfoArray = s2cGetMonsterPurificationElement.sequence_id_array or {}
    for _,sequence in ipairs(activityInfoArray) do
        monsterPurificationTable[sequence] = sequence
    end
end

-- ################################################## 深渊领主 ##################################################
function DataManager:getActivityPitlordTable()
    if not self._activityPitlordTable then
        self._activityPitlordTable = {}
    end

    return self._activityPitlordTable
end

function DataManager:onGetActivityPitlord(event)
    local s2cGetActivityPitlord = event.data
    lt.CommonUtil.print("s2cGetActivityPitlord code 0")
    
    self._activityPitlordTable = {}
    local activityPitlordTable = self:getActivityPitlordTable()
    local scBossFushArray = s2cGetActivityPitlord.boss_flush_array or {}
    for _,scBossFlush in ipairs(scBossFushArray) do
        local activityPitlord = lt.ActivityPitlord.new(scBossFlush)
        activityPitlordTable[activityPitlord:getSequenceId()] = activityPitlord
    end
end

function DataManager:getActivityPitlord(sequenceId)
    local activityPitlordTable = self:getActivityPitlordTable()
    return activityPitlordTable[sequenceId]
end

-- ################################################## 魔王宝藏 ##################################################
function DataManager:onGetActivityTreasure(event)
    local s2cGetActivityTreasure = event.data
    lt.CommonUtil.print("s2cGetActivityTreasure code 0")

    local scBossFlush = s2cGetActivityTreasure.boss_flush
    self._activityTreasure = lt.ActivityTreasure.new(scBossFlush)
end

function DataManager:getActivityTreasure()
    return self._activityTreasure
end

function DataManager:onGetActivityTreasureResult(event)
    local s2cGetActivityTreasureResult = event.data
    lt.CommonUtil.print("s2cGetActivityTreasureResult code 0")

    local params = {}
    params.result = s2cGetActivityTreasureResult
    lt.GameEventManager:post(lt.GameEventManager.EVENT.ACTIVITY_TREASURE_RESULT,params)
end

-- ################################################## 守卫遗迹奖励 ##################################################
function DataManager:onGetActivityRewardList(event)
    local s2cGetActivityRewardList = event.data
    lt.CommonUtil.print("s2cGetActivityRewardList code 0==="..tostring(s2cGetActivityRewardList))

    local params = {}

    params.rewardList = s2cGetActivityRewardList.reward_list
    params.getType = s2cGetActivityRewardList.get_type

    lt.GameEventManager:post(lt.GameEventManager.EVENT.ACTIVITY_REWARD,params)

end

-- ################################################## 活跃活动 ##################################################

function DataManager:getPlyActiveBoxInfo()
    return self._plyActivityBoxInfo
end

function DataManager:onGetActiveBox(event)
    local s2cOnGetActiveBox = event.data

    lt.CommonUtil.print("s2cOnGetActiveBox code===="..s2cOnGetActiveBox.code)

    self._plyActivityBoxInfo = lt.PlyActiveBox.new(s2cOnGetActiveBox.active_box)


end
--游戏内的活动提示开关
function DataManager:getActivityPushSwitch(type)----type 活动类别  Constants.ACTIVITY
    local preferenceTable = lt.PreferenceManager:getActiveActivityPushTable()

    local activityInfo =  lt.CacheManager:getActivityInfo(type)

    if not activityInfo then
        return false
    end

    if preferenceTable[tostring(type)] == nil then
        if activityInfo:getPushIsPush() == 1 then--默认不
            return false
        elseif activityInfo:getPushIsPush() == 2 then--默认是
            return true
        else--0 没有提示权限
            return false
        end
    else
        return preferenceTable[tostring(type)]
    end
end

--游戏外的活动推送开关
function DataManager:getActivityCallmeSwitch(type)----type 活动类别  Constants.ACTIVITY
    local preferenceTable = lt.PreferenceManager:getActiveActivityCallmeTable()

    local activityInfo =  lt.CacheManager:getActivityInfo(type)

    if not activityInfo then
        return false
    end

    if preferenceTable[tostring(type)] == nil then
        if activityInfo:getPushCallMe() == 1 then--默认不
            return false
        elseif activityInfo:getPushCallMe() == 2 then--默认是
            return true
        else--0 没有提示权限
            return false
        end
    else
        return preferenceTable[tostring(type)]
    end
end

--[[ ################################################## trading ##################################################
    交易相关
    ]]

function DataManager:getAllTradingTable()
    if not self._allTradingTable then
        self._allTradingTable = {}
    end

    return self._allTradingTable
end

function DataManager:getPlayerTradingTable()
    if not self._playerTradingTable then
        self._playerTradingTable = {}
    end
    return self._playerTradingTable
end

function DataManager:getPlayerTradingRecordTable()
    if not self._playerTradingRecordTable then
        self._playerTradingRecordTable = {}
    end
    return self._playerTradingRecordTable
end

function DataManager:clearPlayerTradingFinishedRecordTable()
    self._playerTradingFinishedRecordTable = {}
end

function DataManager:getPlayerTradingFinishedRecordTable()
    if not self._playerTradingFinishedRecordTable then
        self._playerTradingFinishedRecordTable = {}
    end
    return self._playerTradingFinishedRecordTable
end

function DataManager:getPlayerTradingFocusTable(clear)
    if not self._playerTradingFocusTable or clear then
        self._playerTradingFocusTable = {}
    end
    return self._playerTradingFocusTable
end

function DataManager:getOtherPlayerEquipmentTable()
    if not self._otherPlayerEquipmentTable then
        self._otherPlayerEquipmentTable = {}
    end
    return self._otherPlayerEquipmentTable
end

function DataManager:getOtherPlayerEquipmentTableById(id)
    local otherPlayerEquipmentTable = self:getOtherPlayerEquipmentTable()
    return otherPlayerEquipmentTable[id]
end

function DataManager:onGetAllTradingItemListResponse(event)
    local s2cGetAllTradingItemList = event.data
    lt.CommonUtil.print("s2cGetAllTradingItemList code " .. s2cGetAllTradingItemList.code)

    -- lt.CommonUtil.print("s2cGetAllTradingItemList content\n"..tostring(s2cGetAllTradingItemList))

    --print("______dsfsdfsdfdsfdsfs_________________________", #s2cGetAllTradingItemList.trading_item_array, s2cGetAllTradingItemList.batch_id)


    if  s2cGetAllTradingItemList.batch_id and s2cGetAllTradingItemList.batch_id == 1 then
        self._allTradingTable = {}
    end

    local scTradingItemArray = s2cGetAllTradingItemList.trading_item_array
    for _,scTradingItem in ipairs(scTradingItemArray) do
        local tradingOrder = lt.TradingOrder.new(scTradingItem)

        if not self._allTradingTable[tradingOrder:getServerId()] then
            self._allTradingTable[tradingOrder:getServerId()] = {}
        end
        self._allTradingTable[tradingOrder:getServerId()][tradingOrder:getSn()] = tradingOrder
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.GET_TRADING_LIST)
end

function DataManager:getCurrentPageTradingTable(clear)
    if not self._currentPageTradingTable or clear then
        self._currentPageTradingTable = {}
    end

    return self._currentPageTradingTable
end

function DataManager:getCurrentPageTradingInfo(serverId, sn)
    local allTradingTable = self:getCurrentPageTradingTable()

    if not allTradingTable[serverId] then
        allTradingTable[serverId] = {}
    end

    return allTradingTable[serverId][sn]
end

function DataManager:onGetPlayerTradingItemListResponse(event)
    local s2cGetPlayerTradingItemList = event.data
    lt.CommonUtil.print("s2cGetPlayerTradingItemList code " .. s2cGetPlayerTradingItemList.code)

    self._playerTradingTable = {}
    local scTradingItemArray = s2cGetPlayerTradingItemList.trading_item_array
    for _,scTradingItem in ipairs(scTradingItemArray) do
        local tradingOrder = lt.TradingOrder.new(scTradingItem)
        self._playerTradingTable[tradingOrder:getSn()] = tradingOrder
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.STALL_SALE_LIST)
end

function DataManager:onGetFinishedTradingRecordsResponse(event)
   local scGetFinishedTradingRecords = event.data
   lt.CommonUtil.print("scGetFinishedTradingRecords code " .. scGetFinishedTradingRecords.code)
   local orderTable = scGetFinishedTradingRecords.finished_trading_order_array

   self:clearPlayerTradingFinishedRecordTable()
   local finishedRecordTable = self:getPlayerTradingFinishedRecordTable()
   for _,order in ipairs(orderTable) do
        local tradingOrder = lt.TradingOrder.new(order)
        finishedRecordTable[tradingOrder:getSn()] = tradingOrder

        local treasureType = tradingOrder:getType()


    end
    lt.GameEventManager:post(lt.GameEventManager.EVENT.STALL_INCOME)

    if scGetFinishedTradingRecords:HasField('gain_item') then
        local item = scGetFinishedTradingRecords.gain_item
        local chatInfo = lt.Chat.new()
        chatInfo:setChannel(lt.Constants.CHAT_TYPE.SYSTEM)
        chatInfo:setSenderName("system")
        chatInfo:setSendTime(lt.CommonUtil:getCurrentTime())
        chatInfo:setMessage("")
        local subContent = {}
        subContent["item_type"] = item.type
        subContent["model_id"] = item.model_id
        subContent["size"] = item.count
        chatInfo:setSubContent(json.encode(subContent))
        chatInfo:setSubType(lt.Constants.CHAT_SUB_TYPE.TRADE_NORMAl)
        self:addSystemChatInfo(chatInfo)
        lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_SYSTEM,{chatInfo=chatInfo})

        for _,order in ipairs(orderTable) do
            local tradingOrder = lt.TradingOrder.new(order)
            local treasureType = tradingOrder:getType()

            if treasureType == 1 then
                -- local systemChatMessage = {}
                -- systemChatMessage.sender_id = 1
                -- systemChatMessage.receiver_id = self:getPlayerId()
                -- local itemModelId = lt.CacheManager:getItemInfo()
                -- local name = tradingOrder:getItemName()
                -- local dealTime = tradingOrder:getDealTime()

                -- systemChatMessage.message = string.format(lt.StringManager:getString("STRING_FRIEND_TIPS_6"),name)
                -- systemChatMessage.send_time = tradingOrder:getOnsaleTime()
                -- systemChatMessage.id = 1
                -- systemChatMessage.sub_type = 0
                -- systemChatMessage.sub_param = 0
                -- systemChatMessage.sub_content = 0

                -- local info = lt.ChatMessage.new()
                -- info:initWithRow(systemChatMessage)

                -- lt.ChatManager:insertChatInfo(info)
                -- self:setSystemChat(true)
            end
        end
    end
  
end

function DataManager:setSystemChat(bool)

    self._systemChat = bool

end

function DataManager:getSystemChat()
    return self._systemChat
end

function DataManager:getPlayerTradingOrder(sn)
    local playerTradingTable = self:getPlayerTradingTable()
    return playerTradingTable[sn]
end

function DataManager:getTradingOrder(serverId, sn)
    local allTradingTable = self:getAllTradingTable()

    if not allTradingTable[serverId] then
        allTradingTable[serverId] = {}
    end

    return allTradingTable[serverId][sn]
end

function DataManager:getPlayerTradingRecord(serverId, sn)
    local playerTradingRecordTable = self:getPlayerTradingRecordTable()

    if not playerTradingRecordTable[serverId] then
        playerTradingRecordTable[serverId] = {}
    end

    return playerTradingRecordTable[serverId][sn]
end

function DataManager:getPlayerTradingFinishedRecord(sn)
    local playerTradingFinishedRecordTable = self:getPlayerTradingFinishedRecordTable()
    return playerTradingFinishedRecordTable[sn]
end

function DataManager:getPlayerTradingFocus(serverId, sn)
    local playerTradingFocusTable = self:getPlayerTradingFocusTable()

    if not playerTradingFocusTable[serverId] then
        playerTradingFocusTable[serverId] = {}
    end

    return playerTradingFocusTable[serverId][sn]
end

function DataManager:getOtherPlayerEquipment(equipmentId)
     local otherPlayerEquipmentTable = self:getOtherPlayerEquipmentTable()
     return otherPlayerEquipmentTable[equipmentId]
end

function DataManager:setStallActionArray(actionArray)
    self._actionArray = actionArray
end

function DataManager:getStallActionArray()
    if not self._actionArray then
        self._actionArray = {tab=1}
    end
    return self._actionArray
end

-- ################################################## 组队信息 ##################################################
DataManager._teamInfo     = nil -- 当前组队信息
DataManager._isTeamHost   = false -- 是否为队长
DataManager._isTeamFollow = false -- 是否跟随队长

function DataManager:_playerPairInArray(playerPair, playerPairArray)
    local serverId = playerPair.serverId
    local playerId = playerPair.playerId

    for _,tempPlayerPair in ipairs(playerPairArray) do
        local tempServerId = tempPlayerPair.serverId
        local tempPlayerId = tempPlayerPair.playerId
        if serverId == tempServerId and playerId == tempPlayerId then
            return true
        end
    end

    return false
end

--[[
    状态字
    1   => 更新
    2   => 有人入队
    3   => 有人离队
    4   => 新建队伍
    5   => 自己离队
]]
function DataManager:onUpdateTeamStatus(event)
    local s2cUpdateTeamStatus = event.data
    lt.CommonUtil.print("s2cUpdateTeamStatus OK")
	-- lt.CommonUtil.print("s2cUpdateTeamStatus content\n"..tostring(s2cUpdateTeamStatus))

    local existTeam = s2cUpdateTeamStatus.exist_team == 1
    if existTeam then
        local scTeam = s2cUpdateTeamStatus.team_info

        -- 带有详细信息的房间
        local teamInfo = lt.TeamInfo.new(scTeam)

        -- 判断是否是房主
        local selfPlayerId = self:getPlayerId()
        local teamPlayerArray = teamInfo:getTeamPlayerArray()
        for _,teamPlayer in ipairs(teamPlayerArray) do
            if teamPlayer:getPlayerId() == selfPlayerId then
                self._isTeamHost   = teamPlayer:isHost()
                self._isTeamFollow = teamPlayer:isFollow()
                break
            end
        end

        local status = 0
        local teamHostChange = false
        if self._teamInfo then
            -- 队伍数据更新
            local prePlayerCount = self._teamInfo:getPlayerCount()
            local curPlayerCount = teamInfo:getPlayerCount()

            if curPlayerCount > prePlayerCount then
                -- 加入队伍
                status = 2

                local preTeamPlayerPairArray = self._teamInfo:getTeamPlayerPairArray()
                local curTeamPlayerPairArray = teamInfo:getTeamPlayerPairArray()

                for _,playerPair in ipairs(curTeamPlayerPairArray) do
                    if not self:_playerPairInArray(playerPair, preTeamPlayerPairArray) then
                        -- 加入的玩家Id
                        local serverId = playerPair.serverId
                        local playerId = playerPair.playerId
                        local teamPlayer = teamInfo:getTeamPlayer(serverId, playerId)

                        lt.NoticeManager:addRichMessage({{message = teamPlayer:getPlayerName(), color = lt.Constants.COLOR.BLUE, outline = true}, {message = lt.StringManager:getString("STRING_TEAM_PLAYER_ENTER_TEAM"), outline = true}})
                    end
                end
            elseif curPlayerCount < prePlayerCount then
                -- 离开队伍
                status = 3

                local preTeamPlayerPairArray = self._teamInfo:getTeamPlayerPairArray()
                local curTeamPlayerPairArray = teamInfo:getTeamPlayerPairArray()

                for _,playerPair in ipairs(preTeamPlayerPairArray) do
                    if not self:_playerPairInArray(playerPair, curTeamPlayerPairArray) then
                        -- 离开的玩家Id
                        local serverId = playerPair.serverId
                        local playerId = playerPair.playerId
                        local teamPlayer = self._teamInfo:getTeamPlayer(serverId, playerId)

                        lt.NoticeManager:addRichMessage({{message = teamPlayer:getPlayerName(), color = lt.Constants.COLOR.BLUE, outline = true}, {message = lt.StringManager:getString("STRING_TEAM_PLAYER_EXIT_TEAM"), outline = true}})
                    end
                end
            else
                -- 更新
                status = 1

                -- 设定离线在线状态
                local teamPlayerArray = teamInfo:getTeamPlayerArray()
                for _,teamPlayer in ipairs(teamPlayerArray) do
                    local serverId = teamPlayer:getServerId()
                    local playerId = teamPlayer:getPlayerId()
                    local status   = teamPlayer:getStatus()

                    local simplePlayerInfo = self:getSimplePlayerInfo(serverId, playerId)
                    if simplePlayerInfo then
                        if status > 0 then
                            status = 1
                        end

                        simplePlayerInfo:setStatus(status)
                    end
                end
            end

            -- 判断队长是否变化
            local preTeamHostPlayer = self._teamInfo:getTeamHostPlayer()
            local newTeamHostPlayer = teamInfo:getTeamHostPlayer()

            if preTeamHostPlayer:getServerId() ~= newTeamHostPlayer:getServerId() or preTeamHostPlayer:getPlayerId() ~= newTeamHostPlayer:getPlayerId() then
                teamHostChange = true
            end
        else
            -- 之前没有队伍
            if self._flush then
                if self._isTeamHost then
                    -- 是队长提示创建队伍成功
                    lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_TEAM_CREATE_SUCCESS_TIPS"))
                else
                    lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_TEAM_JOIN_SUCCESS_TIPS"))
                end
            end

            -- 新建队伍
            status = 4

            -- 刷新队友实例
            local playerIdArray = teamInfo:getTeamPlayerIdArray()
            local playerPairArray = teamInfo:getTeamPlayerPairArray()
            lt.GameEventManager:post(lt.GameEventManager.EVENT.SIMPLE_PLAYER_INFO_UPDATE, {playerIdArray = playerIdArray, playerPairArray = playerPairArray})
        end

        self._teamInfo = teamInfo

        -- 存在临时对 不更新信息
        if self._tempTeamInfo then
        else
            self._teamPlayerPairArray = self._teamInfo:getTeamPlayerPairArray()
        end

        lt.GameEventManager:post(lt.GameEventManager.EVENT.TEAM_UPDATE, {status = status, teamHostChange = teamHostChange})
    else
        if self:hasTeam() then
            self:clearSelfTeamInfo()
        end
    end
end

-- 优先级(临时 > 固定)
function DataManager:getSelfTeamInfo()
    return self._tempTeamInfo or self._teamInfo
end

function DataManager:setTempTeamInfo(tempTeamInfo)
    -- self._isTeamHost   = false
    -- self._isTeamFollow = false

    self._tempTeamInfo = tempTeamInfo
    self._teamPlayerPairArray = self._tempTeamInfo:getTeamPlayerPairArray()

    lt.GameEventManager:post(lt.GameEventManager.EVENT.TEAM_UPDATE, {status = 4})
end

function DataManager:clearTempTeamInfo()
    if self._tempTeamInfo then
        -- self._isTeamHost   = false
        -- self._isTeamFollow = false

        self._tempTeamInfo = nil
        self._teamPlayerPairArray = nil

        if self._teamInfo then
            -- 重置信息
            self._teamPlayerPairArray = self._teamInfo:getTeamPlayerPairArray()
        end

        lt.GameEventManager:post(lt.GameEventManager.EVENT.TEAM_UPDATE, {status = 5})
    end
end

function DataManager:getSelfTeamPlayerCount()
    local teamInfo = self:getSelfTeamInfo()
    if not teamInfo then
        return 0
    end

    return teamInfo:getPlayerCount()
end

function DataManager:isTeammate(serverId, playerId)
    if not self._teamPlayerPairArray then
        return false
    end

    if not playerId then
        playerId = serverId
        serverId = self:getCurServerId()
    end

    return self:_playerPairInArray({serverId = serverId, playerId = playerId}, self._teamPlayerPairArray)
end

function DataManager:isEnemy(serverId, playerId)
    return lt.MatchGroupManager:isPK() and not self:isTeammate(serverId, playerId)
end

function DataManager:getTeamPlayerPairArray()
    return self._teamPlayerPairArray or {}
end

function DataManager:clearSelfTeamInfo()
    self._isTeamHost = false
    self._isTeamFollow = false
    
    self._teamInfo = nil
    self._teamPlayerPairArray = nil

    lt.GameEventManager:post(lt.GameEventManager.EVENT.TEAM_UPDATE, {status = 5})

    if self._teamRequestingEnterPlayers and #self._teamRequestingEnterPlayers > 0 then
        self._teamRequestingEnterPlayers = nil

        lt.GameEventManager:post(lt.GameEventManager.EVENT.TEAM_REQUEST_UPDATE)
    end
end

function DataManager:hasTeam()
    return self:getSelfTeamInfo() ~= nil
end

function DataManager:isTeamHost()
    if self._tempTeamInfo then
        return false
    end

    return self._isTeamHost
end

function DataManager:isTeamFollow()
    if self._tempTeamInfo then
        return false
    end

    return self._isTeamFollow
end


function DataManager:onExitTeam(event)
    local s2cExitTeam = event.data
    local code = s2cExitTeam.code
    lt.CommonUtil.print("s2cExitTeam code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    local isDismissed = s2cExitTeam.is_dismissed
    if isDismissed == 1 then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_TEAM_QUIT_DISMISSED"))
    end

    -- 清理队伍数据
    self:clearSelfTeamInfo()
end

function DataManager:onKickFromTeam(event)
    local s2cKickFromTeam = event.data
    local code = s2cKickFromTeam.code
    lt.CommonUtil.print("s2cKickFromTeam code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    local playerId = s2cKickFromTeam.player_id
    if playerId == lt.DataManager:getPlayerId() then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_TEAM_KICK"))

        -- 清理队伍数据
        self:clearSelfTeamInfo()
    end
end

function DataManager:onTransferTeamHost(event)
    local s2cTransferTeamHost = event.data
    local code = s2cTransferTeamHost.code
    lt.CommonUtil.print("s2cTransferTeamHost code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- 清理申请
    if self._teamRequestingEnterPlayers and #self._teamRequestingEnterPlayers > 0 then
        self._teamRequestingEnterPlayers = nil

        lt.GameEventManager:post(lt.GameEventManager.EVENT.TEAM_REQUEST_UPDATE)
    end
end

-- 获得请求成员
DataManager._teamRequestingEnterPlayers = nil

function DataManager:onGetTeamRequestingEnterPlayers(event)
    local s2cGetTeamRequestingEnterPlayers = event.data
    local code = s2cGetTeamRequestingEnterPlayers.code
    lt.CommonUtil.print("s2cGetTeamRequestingEnterPlayers code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    self._teamRequestingEnterPlayers = {}
    local s2cPlayerInfoArray = s2cGetTeamRequestingEnterPlayers.player_info_array
    for _,scTeamPlayer in ipairs(s2cPlayerInfoArray) do
        local teamPlayer = lt.TeamPlayer.new(scTeamPlayer, true)
        table.insert(self._teamRequestingEnterPlayers, teamPlayer)
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.TEAM_REQUEST_UPDATE)
end

function DataManager:getTeamMaxPlayerLevel()
    local teamInfo = self:getSelfTeamInfo()
    if teamInfo then
        return teamInfo:getMaxPlayerLevel()
    end

    return self:getPlayerLevel()
end

function DataManager:getTeamRequestingEnterPlayers()
    return self._teamRequestingEnterPlayers or {}
end

function DataManager:removeTeamRequestingEnterPlayer(playerId)
    local teamRequestingEnterPlayers = self:getTeamRequestingEnterPlayers()

    for idx,teamPlayer in ipairs(teamRequestingEnterPlayers) do
        if teamPlayer:getPlayerId() == playerId then
            table.remove(teamRequestingEnterPlayers, idx)
            return
        end
    end
end

function DataManager:onRequestingEnterTeamRejected(event)
    local s2cRequestingEnterTeamRejected = event.data
    local code = s2cRequestingEnterTeamRejected.code
    lt.CommonUtil.print("s2cRequestingEnterTeamRejected code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    local playerName = s2cRequestingEnterTeamRejected.player_name
    lt.NoticeManager:addRichMessage({{message = playerName, color = lt.Constants.COLOR.BLUE, outline = true}, {message = lt.StringManager:getString("STRING_TEAM_APPLY_REJECTED"), outline = true}})
end

--申请入队
function DataManager:onRequestEnterTeamResponse(event)
    local s2cOnRequestEnterTeamResponse = event.data
    local code = s2cOnRequestEnterTeamResponse.code
    lt.CommonUtil.print("s2cOnRequestEnterTeamResponse code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        if code == lt.SocketConstants.CODE_TEAM_DOES_NOT_EXISTS then
            lt.NoticeManager:addMessageString("STRING_FRIEND_INFO_30")
        
        elseif code == lt.SocketConstants.CODE_TEAM_PLAYER_FULL then
            lt.NoticeManager:addMessageString("STRING_FRIEND_INFO_31")
        
        elseif code == lt.SocketConstants.CODE_TEAM_LEVEL_NOT_MATCHED then
            lt.NoticeManager:addMessageString("STRING_FRIEND_INFO_32")

        elseif code == lt.SocketConstants.CODE_NO_GUILD_CAN_NOT_JOIN then
            lt.NoticeManager:addMessageString("STRING_ERROR_11147")

        elseif code == lt.SocketConstants.CODE_NOT_IN_SAME_GUILD_CAN_NOT_JOIN then
            lt.NoticeManager:addMessageString("STRING_ERROR_11148")

        end
    end

    -- 发送消息
    lt.GameEventManager:post(lt.GameEventManager.EVENT.REQUEST_ENTER_TEAM,{code = code})
end

--邀请入队
function DataManager:onInviteEnterTeamResponse(event)
    local s2cOnInviteEnterTeamResponse = event.data
    local code = s2cOnInviteEnterTeamResponse.code
    lt.CommonUtil.print("s2cOnInviteEnterTeamResponse code ===="..code)

    if code ~= lt.SocketConstants.CODE_OK then
        if code == lt.SocketConstants.CODE_PLAYER_IS_OFFLINE then--对方不在线
            lt.NoticeManager:addMessageString("STRING_FRIEND_INFO_21")

        elseif code == lt.SocketConstants.CODE_ALL_IN_TEAM then --对方有队伍
            lt.NoticeManager:addMessageString("STRING_FRIEND_INFO_22")

        elseif code == lt.SocketConstants.CODE_NO_GUILD_CAN_NOT_INVITE then -- 未加入公会，无法邀请
            lt.NoticeManager:addMessageString("STRING_ERROR_11145")

        elseif code == lt.SocketConstants.CODE_NOT_IN_SAME_GUILD then -- 不是同一公会，无法邀请
            lt.NoticeManager:addMessageString("STRING_ERROR_11146_1")

        elseif code == lt.SocketConstants.CODE_TEAM_ERR_PLAYER_IN_COPY then -- 不是同一公会，无法邀请
            lt.NoticeManager:addMessageString("STRING_ERROR_11149")
            
        end
    end

    -- 发送消息
    lt.GameEventManager:post(lt.GameEventManager.EVENT.INVITE_ENTER_TEAM,{code = code})
end

--获取别人邀请你入队的table
function DataManager:getAskEnterTeamTable()
    if not self._askEnterTeamTable then
        self._askEnterTeamTable = {}
    end

    return self._askEnterTeamTable
end

function DataManager:removeAskEnterTeamById(id)
    local table = self:getAskEnterTeamTable()
    for k,v in pairs(table) do
        if k == id then
            table[k] = nil
        end
    end

end

--别人收到邀请信息
function DataManager:onAskEnterResponse(event)
    local s2cOnAskEnterResponse = event.data

    local askEnterInfo = lt.AskEnterTeam.new(s2cOnAskEnterResponse)

    local playerId = askEnterInfo:getPlayerId()
    local AskEnterTeamTable = self:getAskEnterTeamTable()

    AskEnterTeamTable[playerId] = askEnterInfo

    lt.GameEventManager:post(lt.GameEventManager.EVENT.ASK_ENTER_TEAM,{info = askEnterInfo})
end

--组队收到的拒绝信息
function DataManager:onAskEnterTeamRejected(event)
    local s2cOnAskEnterTeamRejected = event.data

    local rejectedInfo = lt.RejectTeam.new(s2cOnAskEnterTeamRejected)

    lt.GameEventManager:post(lt.GameEventManager.EVENT.REJECTED_TEAM,{info = rejectedInfo})
end

--收到的邀请入会
function DataManager:onGetJoinGuildResponse(event)
    local s2cOnGetJoinGuildResponse = event.data

    local joinGuildInfo = lt.AskJoinGuild.new(s2cOnGetJoinGuildResponse)

    lt.GameEventManager:post(lt.GameEventManager.EVENT.ASK_ENTER_GUILD,{info = joinGuildInfo})
end


function DataManager:setWorldContent(content)
    self._worldContent = content
end

function DataManager:getWorldContent()
    return self._worldContent
end


function DataManager:setWorldMapId(worldMapId)
    self._worldMapId = worldMapId
end

function DataManager:getWorldMapId()
    return self._worldMapId
end

function DataManager:setWorldMapKey(worldMapKey)
    self._worldMapKey = worldMapKey
end

function DataManager:getWorldMapKey()
    return self._worldMapKey
end

-- ############################## 公会狂欢 ##############################
function DataManager:getJoinGuildPartyArray()
    if not self._joinGuildPartyArray then
        self._joinGuildPartyArray = {}
    end

    return self._joinGuildPartyArray
end

function DataManager:setHasJoinGuildPartyValue(value)
    self._hasJoinGuildPartyValue = value
end

function DataManager:getHasJoinGuildPartyValue()
    return self._hasJoinGuildPartyValue or 0
end

function DataManager:onGetJoinGuildPartyInfoResponse(event)

    local s2cOnGetJoinGuildPartyInfoResponse = event.data


    self._joinGuildPartyArray = {}

    local array = s2cOnGetJoinGuildPartyInfoResponse.player_info_array
    
    for id,info in ipairs(array) do

        local joinGuildPartyInfo = lt.JoinGuildPartyInfo.new(info)
        self._joinGuildPartyArray[id] = joinGuildPartyInfo
    end


    lt.GameEventManager:post(lt.GameEventManager.EVENT.GUILD_CARNIVAL_REFRESH)
end

function DataManager:onGetJoinGuildPartyJoinResponse(event)

    local s2cOnGetJoinGuildPartyJoinResponse = event.data

    self._hasJoinGuildPartyValue =  s2cOnGetJoinGuildPartyJoinResponse.is_join
end

-- ############################## 世界 ##############################
function DataManager:analysisS2CWorldEvent(scWorldEvent)
    local event = {}
    event.serverId          = scWorldEvent.player_pair.server_id
    event.playerId          = scWorldEvent.player_pair.player_id
    event.status            = scWorldEvent.status
    event.x                 = scWorldEvent.x
    event.y                 = scWorldEvent.y
    event.direction         = scWorldEvent.direction

    if scWorldEvent:HasField("content") then
        event.params = json.decode(scWorldEvent.content)
    else
        event.params = {}
    end
    if scWorldEvent:HasField("int_value") then
        event.int_value = scWorldEvent.int_value
    end
    if scWorldEvent:HasField("int_value_2") then
        event.int_value_2 = scWorldEvent.int_value_2
    end
    if scWorldEvent:HasField("float_value") then
        event.float_value = scWorldEvent.float_value
    end
    if scWorldEvent:HasField("float_value_2") then
        event.float_value_2 = scWorldEvent.float_value_2
    end
    if scWorldEvent:HasField("bool_value") then
        event.bool_value = scWorldEvent.bool_value
    end
    if scWorldEvent:HasField("bool_value_2") then
        event.bool_value_2 = scWorldEvent.bool_value_2
    end
    if scWorldEvent:HasField("extra") then
        event.extra = scWorldEvent.extra
    end
    if scWorldEvent:HasField("combo") then
        event.combo = scWorldEvent.combo
    end

    -- event.params.direction  = event.direction

    return event
end

function DataManager:onWorldEvent(event)
    local s2cWorldEvent = event.data
    local code = s2cWorldEvent.code

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    local worldMapId = s2cWorldEvent.world_map_id
    if worldMapId ~= self._worldMapId then
        -- 不是当前地图过滤
        return
    end
    
    -- lt.CommonUtil.print("s2cWorldEvent content\n"..tostring(s2cWorldEvent))

    local eventArray = {}
    local scWorldEventArray = s2cWorldEvent.event_array
    for _,scWorldEvent in ipairs(scWorldEventArray) do
        local event = self:analysisS2CWorldEvent(scWorldEvent)
        table.insert(eventArray, event)
    end

    lt.MultiEventManager:onWorldEvent(eventArray)
end

function DataManager:onGetPlayers(event)
    local s2cGetPlayers = event.data
    local code = s2cGetPlayers.code

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end
    
    -- lt.CommonUtil.print("s2cGetPlayers content\n"..tostring(s2cGetPlayers))
    
    local worldMapId = s2cGetPlayers.world_map_id
    if worldMapId ~= self._worldMapId then
        -- 不是当前地图过滤
        return
    end

    local eventArray = {}
    local scWorldEventArray = s2cGetPlayers.event_array
    for _,scWorldEvent in ipairs(scWorldEventArray) do
        local event = self:analysisS2CWorldEvent(scWorldEvent)
        table.insert(eventArray, event)
    end

    lt.MultiEventManager:onWorldEvent(eventArray)
end

function DataManager:getTempMonsterTable()
    if not self._tempMonsterTable then
        self._tempMonsterTable = {}
    end

    return self._tempMonsterTable
end

function DataManager:clearTempMonsterTable()
    self._tempMonsterTable = {}
end

function DataManager:setTempMonsterInfo(monsterInfo)
    local tempMonsterTable = self:getTempMonsterTable()
    tempMonsterTable[monsterInfo:getId()] = monsterInfo
end

function DataManager:getTempMonsterInfo(monsterId)
    local tempMonsterTable = self:getTempMonsterTable()
    return tempMonsterTable[monsterId]
end

function DataManager:analysisS2CMonsterEvent(scMonsterEvent)
    local event = {}
    event.worldMonsterId    = scMonsterEvent.world_monster_id
    event.monsterId         = scMonsterEvent.monster_id
    event.monsterIndex      = scMonsterEvent.monster_index
    event.status            = scMonsterEvent.status
    event.x                 = scMonsterEvent.x
    event.y                 = scMonsterEvent.y
    event.direction         = scMonsterEvent.direction
    event.params            = json.decode(scMonsterEvent.content) or {}
    event.params.direction  = event.direction
    event.wasTriggerBattle  = scMonsterEvent.was_trigger_battle
    event.threatServerId    = scMonsterEvent.threat_player_pair.server_id
    event.threatPlayerId    = scMonsterEvent.threat_player_pair.player_id

    if scMonsterEvent:HasField('monster_base') then
        local scMonsterBase = scMonsterEvent.monster_base
        local monsterInfo = lt.MonsterInfo.new(scMonsterBase)
        event.monsterInfo = monsterInfo
    end

    return event
end

function DataManager:onGetMonsters(event)
    local s2cGetMonsters = event.data
    local code = s2cGetMonsters.code
    lt.CommonUtil.print("s2cGetMonsters code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    local worldMapId = s2cGetMonsters.world_map_id
    if worldMapId ~= self._worldMapId then
        -- 不是当前地图过滤
        return
    end

    -- lt.CommonUtil.print("s2cGetMonsters content\n"..tostring(s2cGetMonsters))

    -- 清理之前的临时数据
    self:clearTempMonsterTable()

    local eventArray = {}
    local scMonsterEventArray = s2cGetMonsters.event_array
    for _,scMonsterEvent in ipairs(scMonsterEventArray) do
        local event = self:analysisS2CMonsterEvent(scMonsterEvent)
        table.insert(eventArray, event)
    end

    lt.MultiEventManager:onWorldMonsterEvent(eventArray, true, s2cGetMonsters.round)
end

function DataManager:onMonsterEvent(event)
    local s2cMonsterEvent = event.data
    -- lt.CommonUtil.print("s2cMonsterEvent OK")

    local worldMapId = s2cMonsterEvent.world_map_id
    if worldMapId ~= self._worldMapId then
        -- 不是当前地图过滤
        return
    end

    local eventArray = {}
    local scMonsterEventArray = s2cMonsterEvent.event_array
    for _,scMonsterEvent in ipairs(scMonsterEventArray) do
        local event = {}
        event.worldMonsterId    = scMonsterEvent.world_monster_id
        event.monsterId         = scMonsterEvent.monster_id
        event.monsterIndex      = scMonsterEvent.monster_index
        event.status            = scMonsterEvent.status
        event.x                 = scMonsterEvent.x
        event.y                 = scMonsterEvent.y
        event.direction         = scMonsterEvent.direction
        event.params            = json.decode(scMonsterEvent.content) or {}
        event.params.direction  = event.direction
        event.wasTriggerBattle  = scMonsterEvent.was_trigger_battle
        event.threatPlayerId    = scMonsterEvent.threat_player_id

        table.insert(eventArray, event)
    end

    lt.MultiEventManager:onWorldMonsterEvent(eventArray)
end

function DataManager:onRefreshMonsters(event)
    local s2cRefreshMonsters = event.data
    -- lt.CommonUtil.print("s2cRefreshMonsters OK ")

    local worldMapId = s2cRefreshMonsters.world_map_id
    if worldMapId ~= self._worldMapId then
        -- 不是当前地图过滤
        return
    end

    local eventArray = {}
    local scMonsterEventArray = s2cRefreshMonsters.event_array
    for _,scMonsterEvent in ipairs(scMonsterEventArray) do
        local event = {}
        event.worldMonsterId    = scMonsterEvent.world_monster_id
        event.monsterId         = scMonsterEvent.monster_id
        event.monsterIndex      = scMonsterEvent.monster_index
        event.status            = scMonsterEvent.status
        event.x                 = scMonsterEvent.x
        event.y                 = scMonsterEvent.y
        event.direction         = scMonsterEvent.direction
        event.params            = json.decode(scMonsterEvent.content) or {}
        event.params.direction  = event.direction
        event.wasTriggerBattle  = scMonsterEvent.was_trigger_battle
        event.threatPlayerId    = scMonsterEvent.threat_player_id

        if scMonsterEvent:HasField('monster_base') then
            local scMonsterBase = scMonsterEvent.monster_base

            local monsterInfo = lt.MonsterInfo.new(scMonsterBase)
            -- self:setTempMonsterInfo(monsterInfo)

            event.monsterInfo = monsterInfo
        end
        
        table.insert(eventArray, event)
    end

    lt.MultiEventManager:onWorldMonsterEvent(eventArray)
    lt.MultiEventManager:onWorldMonsterRefresh(s2cRefreshMonsters.round)
end

-- S2C_KillDungeonMonster
function DataManager:onKillMonster(event)
    local s2cKillMonster = event.data
    local code = s2cKillMonster.code
    lt.CommonUtil.print("s2cKillMonster code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cKillMonster content\n"..tostring(s2cKillMonster))

    local scDropGainItemArray = s2cKillMonster.drop_gain_item_array or {}
    local dropInfoArray = {}
    for _,scGainItemInfo in ipairs(scDropGainItemArray) do
        local monsterIdx = scGainItemInfo.dungeon_monster_id

        local scSimpleItemArray = scGainItemInfo.gain_item_array
        local simpleItemArray = {}
        for _,scSimpleItemInfo in ipairs(scSimpleItemArray) do
            local simpleItemInfo = lt.SimpleItemInfo.new(scSimpleItemInfo)
            table.insert(simpleItemArray, simpleItemInfo)
        end

        local rewardArray = {}
        local scExpOrCoinArray = scGainItemInfo.exp_or_coin_array or {}
        for _,scExpOrCoin in ipairs(scExpOrCoinArray) do
            local type  = scExpOrCoin.type
            local count = scExpOrCoin.count

            table.insert(rewardArray, {type = type, count = count})
        end

        table.insert(dropInfoArray, {monsterIdx = monsterIdx, simpleItemArray = simpleItemArray, rewardArray = rewardArray})
    end

    lt.MultiEventManager:onWorldMonsterKill(dropInfoArray)
end

-- 多人更新伙伴血量
function DataManager:onUpdatePlayerHealthPoint(event)
    local s2cUpdatePlayerHealthPoint = event.data

    local serverId = s2cUpdatePlayerHealthPoint.server_id
    local playerId = s2cUpdatePlayerHealthPoint.player_id

    -- lt.CommonUtil.print("s2cUpdatePlayerHealthPoint content\n"..tostring(s2cUpdatePlayerHealthPoint))

    if self:isSelfPlayer(serverId, playerId) then
        -- 过滤自己的血量
        return
    end

    local curHp         = s2cUpdatePlayerHealthPoint.cur_hp
    local curHpPercent  = s2cUpdatePlayerHealthPoint.cur_hp_percent

    lt.MultiEventManager:onBattleMultiHeroHpChange(serverId, playerId, curHp, curHpPercent)
end

function DataManager:onHealthUpdateEvent(event)
    local s2cHealthUpdateEvent = event.data

    local worldMapId  = s2cHealthUpdateEvent.world_map_id
    local worldMapKey = s2cHealthUpdateEvent.world_map_key

    local scEventArray = s2cHealthUpdateEvent.event_array
    for _,scEvent in ipairs(scEventArray) do
        local serverId = scEvent.player_pair.server_id
        local playerId = scEvent.player_pair.player_id

        if not self:isSelfPlayer(serverId, playerId) then
            local curHp         = scEvent.cur_hp
            local curHpPercent  = scEvent.cur_hp_percent

            lt.MultiEventManager:onBattleMultiHeroHpChange(serverId, playerId, curHp, curHpPercent)
        end
    end
end

function DataManager:onHitBattleMonster(event)
    local s2cHitDungeonMonster = event.data
    lt.CommonUtil.print("s2cHitDungeonMonster code ".. s2cHitDungeonMonster.code)

    local hitArray = s2cHitDungeonMonster.hit_array
    for _,battleMonsterHitInfo in ipairs(hitArray) do
        lt.MultiEventManager:onBattleMultiMonsterHpChange(battleMonsterHitInfo.dungeon_monster_id, battleMonsterHitInfo.cur_hp)
    end
end


function DataManager:onHitMonster(event)
    local s2cHitMonster = event.data
    -- lt.CommonUtil.print("s2cHitMonster OK")
    -- lt.CommonUtil.print("s2cHitMonster content\n"..tostring(s2cHitMonster))

    local worldMapId = s2cHitMonster.world_map_id
    if worldMapId ~= self._worldMapId then
        -- 非本地图数据
        return
    end

    local monsterIdxArray = s2cHitMonster.monster_index
    local curHpArray      = s2cHitMonster.cur_health_point

    local monsterIdxCount = #monsterIdxArray
    local curHpCount      = #curHpArray

    if monsterIdxCount ~= curHpCount then
        lt.CommonUtil.print("DataManager:onHitMonster data not pair")
        return
    end

    for i=1,monsterIdxCount do
        local monsterIdx = monsterIdxArray[i]
        local curHp      = curHpArray[i]

        lt.MultiEventManager:onMonsterHpUpdate(monsterIdx, curHp)
    end
end

function DataManager:onTriggerBossBattle(event)
    local s2cTriggerBossBattle = event.data
    lt.CommonUtil.print("s2cTriggerBossBattle OK")

    local worldMapId = s2cTriggerBossBattle.world_map_id
    if worldMapId ~= self._worldMapId then
        -- 非本地图数据
        return
    end

    local monsterIdx = s2cTriggerBossBattle.monster_index
    local wasTriggerBattle = s2cTriggerBossBattle.was_trigger_battle
    local triggerBattleMillis = s2cTriggerBossBattle.trigger_battle_millis

    lt.MultiEventManager:onTriggerBossBattle(monsterIdx, wasTriggerBattle, triggerBattleMillis)
end

function DataManager:onChangeThreatTarget(event)
    local s2cChangeThreatTarget = event.data
    -- lt.CommonUtil.print("s2cChangeThreatTarget OK")

    local worldMapId = s2cChangeThreatTarget.world_map_id
    if worldMapId ~= self._worldMapId then
        -- 非本地图数据
        return
    end

    local monsterIdxArray = s2cChangeThreatTarget.monster_index
    local playerPairArray = s2cChangeThreatTarget.player_pair_array

    local monsterIdxCount = #monsterIdxArray
    local playerPairCount = #playerPairArray

    if monsterIdxCount ~= playerPairCount then
        lt.CommonUtil.print("DataManager:onChangeThreatTarget data not pair")
        return
    end

    for i=1,monsterIdxCount do
        local monsterIdx = monsterIdxArray[i]
        local playerPair = playerPairArray[i]
        local serverId   = playerPair.server_id
        local playerId   = playerPair.player_id

        lt.MultiEventManager:onMonsterChangeThreatTarget(monsterIdx, serverId, playerId)
    end
end

function DataManager:onBattleDropItem(event)
    local s2cBattleDropItem = event.data
    local code = s2cBattleDropItem.code
    lt.CommonUtil.printf("s2cBattleDropItem code %d", code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    local scDroppedItemArray = s2cBattleDropItem.dropped_item_array
    local dropArray = {}
    for _,scDroppedItem in ipairs(scDroppedItemArray) do
        local battleDroppedElement = lt.BattleDroppedElement.new(scDroppedItem)
        dropArray[#dropArray + 1] = battleDroppedElement
    end

    lt.MultiEventManager:onBattleMultiDropItem(dropArray)
end

-- ################################################## 福利活动删除 ##################################################
function DataManager:getDeleteActivityInfoTable()
    if not self._deleteActivityInfoTable then
        self._deleteActivityInfoTable = {}
    end

    return self._deleteActivityInfoTable
end

function DataManager:checkActivityOpen(id)
    local deleteActivityInfo = self:getDeleteActivityInfoTable()

    if deleteActivityInfo[id] then
        if deleteActivityInfo[id] == 2 then
            --lt.CommonUtil.print("不存在且已结束")
            return false
        else
            if deleteActivityInfo[id] == 1 then
                --lt.CommonUtil.print("存在但已结束")
            end
            if deleteActivityInfo[id] == 0 then
                --lt.CommonUtil.print("存在且未结束")
            end

            return true
        end
    end

    return true
end

function DataManager:onGetDeleteActivityInfoResponse(event)
    local s2cOnGetDeleteActivityInfoResponse = event.data

    local code = s2cOnGetDeleteActivityInfoResponse.code

    lt.CommonUtil.print("s2cOnGetDeleteActivityInfoResponse code ====="..code)

    --id: 1--连续签到   2--升级有礼  3--成长任务 4--战力达人 5--沖级达人    value: 0--存在且未结束  1--存在但已结束 2--不存在且已结束 （结束对应于玩家已经完成或活动到期或活动奖励全部领完）

    local deleteActivityInfoTable = self:getDeleteActivityInfoTable()

    local addArray = s2cOnGetDeleteActivityInfoResponse.add_delete_activity_info_array

    for i,v in ipairs(addArray) do
        local idValuePair = lt.IdValuePair.new(v)
        local id = idValuePair:getId()
        local value = idValuePair:getValue()
        deleteActivityInfoTable[id] = value
    end

    local setArray = s2cOnGetDeleteActivityInfoResponse.set_delete_activity_info_array

    for i,v in ipairs(setArray) do
        local idValuePair = lt.IdValuePair.new(v)
        local id = idValuePair:getId()
        local value = idValuePair:getValue()
        deleteActivityInfoTable[id] = value
    end

end

--新服活动时间
function DataManager:getNewServiceTimeInfo()
    if not self._newServiceTimeInfo then
        self._newServiceTimeInfo = {}
    end

    return self._newServiceTimeInfo
end

function DataManager:getNewServiceTimeInfoById(id)
    local newServiceTimeInfo = self:getNewServiceTimeInfo()

    return newServiceTimeInfo[id]
end

function DataManager:onGetOpenServerActivityTimeInfoResponse(event)
    local s2cOnGetOpenServerActivityTimeInfoResponse = event.data

    local code = s2cOnGetOpenServerActivityTimeInfoResponse.code

    lt.CommonUtil.print("s2cOnGetOpenServerActivityTimeInfoResponse code ====="..code)

    local openArray = s2cOnGetOpenServerActivityTimeInfoResponse.add_open_server_activity_time_array

    local newServiceTimeInfo = self:getNewServiceTimeInfo()

    for i,v in ipairs(openArray) do
        local idValuesPair = lt.IdValuesPair.new(v)
        local id = idValuesPair:getId()

        newServiceTimeInfo[id] = idValuesPair
    end

end

-- ################################################## 部位强化 ##################################################
function DataManager:getPositionStrengthTable()
    if not self._positionStrengthTable then
        self._positionStrengthTable = {}
    end

    return self._positionStrengthTable
end

function DataManager:setPositionStrengthTable(info)
                                                                         
    if not info then return end
    local table = self:getPositionStrengthTable()

    local position = info:getPosition()

    table[position] = info
end

function DataManager:getPositionStrengthInfoByPosition(position)
    local table = self:getPositionStrengthTable()
    return table[position]
end

function DataManager:onGetPositionStrengthResponse(event)
    local s2cPositionStrengthInfo = event.data

    local positionStrengthenTable = self:getPositionStrengthTable()

    local positionStrengthenArray = s2cPositionStrengthInfo.position_strengthen_array


    for i = 1,#positionStrengthenArray do

        local positionStrengthenInfo = lt.PositionStrengthen.new(positionStrengthenArray[i])

        local position = positionStrengthenInfo:getPosition()
        positionStrengthenTable[position] = positionStrengthenInfo
    end
end

function DataManager:getTotalStoneLevel()
    local totalLevel = 0
    local positionStrengthenTable = self:getPositionStrengthTable()
    for _,positionStrengthen in pairs(positionStrengthenTable) do
        totalLevel = totalLevel + positionStrengthen:getTotalLevel()
    end
    return totalLevel
end

function DataManager:getTotalPositionLevel()
    local totalLevel = 0
    local positionStrengthenTable = self:getPositionStrengthTable()
    for _,positionStrengthen in pairs(positionStrengthenTable) do
        totalLevel = totalLevel + positionStrengthen:getOrder()*5+positionStrengthen:getLevel()
    end
    return totalLevel
end

-- ################################################## 月卡信息 ##################################################
function DataManager:getCardLogTable()
    if not self._cardLogTable then
        self._cardLogTable = {}
    end

    return self._cardLogTable
end

function DataManager:getCardLogValidTime(type)
    local cardLogTable = self:getCardLogTable()


    if cardLogTable[type] then
        return cardLogTable[type]
    else
        return nil
    end
end

function DataManager:onGetCardLogListResponse(event)
    local s2cOnGetCardLogListResponse = event.data

    lt.CommonUtil.print("s2cOnGetCardLogListResponse code ====="..s2cOnGetCardLogListResponse.code)

    local cardLogList = s2cOnGetCardLogListResponse.add_card_log_array

    local cardLogTable = self:getCardLogTable()

    for _,s2cCardLogInfo in ipairs (cardLogList) do
        local cardLogInfo = lt.CardLog.new(s2cCardLogInfo)
        local type = cardLogInfo:getType()

        cardLogTable[type] = cardLogInfo
    end
end

-- ################################################## 月卡领取状态 ##################################################
function DataManager:getCardReceiveLogTable()
    if not self._cardReceiveLogTable then
        self._cardReceiveLogTable = {}
    end

    return self._cardReceiveLogTable
end

function DataManager:getCardReceiveLogInfo(type)
    local cardLogTable = self:getCardReceiveLogTable()

    if cardLogTable[type] then
        return cardLogTable[type]
    else
        return nil
    end
end

function DataManager:onGetCardReceiveLogListResponse(event)
    local s2cOnGetCardReceiveLogListResponse = event.data

    lt.CommonUtil.print("s2cOnGetCardReceiveLogListResponse code ====="..s2cOnGetCardReceiveLogListResponse.code)

    local cardReceiveLogTable = self:getCardReceiveLogTable()
    local array = s2cOnGetCardReceiveLogListResponse.add_card_receive_log_array

    for _,s2cCardLogInfo in ipairs (array) do
        local cardLogInfo = lt.CardReceiveLog.new(s2cCardLogInfo)
        local type = cardLogInfo:getType()

        cardReceiveLogTable[type] = cardLogInfo

    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.CARD_UPDATE)
end

-- ################################################## 多人状态下 其他人的信息 ##################################################
DataManager._requestSimplePlayerInfoHandler = nil
DataManager._addingMultiInfoRequestTable = nil
DataManager._waitingMultiInfoRequestTable = nil

function DataManager:getMultiPlayerInfoTable(serverId)
    serverId = serverId or self:getCurServerId()

    return self:_getMultiPlayerInfoTable(serverId)
end

function DataManager:_getMultiPlayerInfoTable(serverId)
    if not self._multiPlayerInfoTable then
        self._multiPlayerInfoTable = {}

        self._addingMultiInfoRequestTable  = {}
        self._waitingMultiInfoRequestTable = {}
    end

    if not serverId then
        return nil
    end

    self._multiPlayerInfoTable[serverId] = self._multiPlayerInfoTable[serverId] or {}

    return self._multiPlayerInfoTable[serverId]
end

function DataManager:resetMultiPlayerInfoTable()
    if not self._multiPlayerInfoTable then
        return
    end

    for serverId,multiPlayerInfoTable in pairs(self._multiPlayerInfoTable) do
        for playerId,simplePlayerInfo in pairs(multiPlayerInfoTable) do
            if self:isTeammate(serverId, playerId) then
            else
                self._multiPlayerInfoTable[serverId][playerId] = nil
            end
        end
    end

    self._addingMultiInfoRequestTable  = {}
    self._waitingMultiInfoRequestTable = {}
end

function DataManager:getSimplePlayerInfo(serverId, playerId)
    if not playerId then
        playerId = serverId
        serverId = self:getCurServerId()
    end

    return self:_getSimplePlayerInfo(serverId, playerId)
end

function DataManager:_getSimplePlayerInfo(serverId, playerId)
    if not serverId then
        return nil
    end
    
    local multiPlayerInfoTable = self:_getMultiPlayerInfoTable(serverId)

    return multiPlayerInfoTable[playerId]
end

function DataManager:setSimplePlayerInfo(scSimplePlayerInfo)
    local multiPlayerInfoTable = self:getMultiPlayerInfoTable()

    local serverId = scSimplePlayerInfo.server_id or self:getCurServerId()
    local playerId = scSimplePlayerInfo.id

    local simplePlayerInfo = self:_getSimplePlayerInfo(serverId, playerId)
    if simplePlayerInfo == nil then
        -- 新建
        simplePlayerInfo = lt.SimplePlayerInfo.new(scSimplePlayerInfo)
        self:_setSimplePlayerInfo(simplePlayerInfo)
    else
        -- 更新
        simplePlayerInfo:update(scSimplePlayerInfo)
    end

    -- 清理请求信息
    self:_clearRequestingMultiPlayerInfo(serverId, playerId)

    return simplePlayerInfo
end

function DataManager:_setSimplePlayerInfo(simplePlayerInfo)
    if not simplePlayerInfo then
        return
    end

    local serverId = simplePlayerInfo:getServerId()
    local playerId = simplePlayerInfo:getId()

    local multiPlayerInfoTable = self:_getMultiPlayerInfoTable(serverId)
    multiPlayerInfoTable[playerId] = simplePlayerInfo
end

function DataManager:getMultiPlayerInfo(playerId, checkUpdate)
    local serverId = self:getCurServerId()

    return self:_getMultiPlayerInfo(serverId, playerId, checkUpdate)
end

function DataManager:_getMultiPlayerInfo(serverId, playerId, checkUpdate)
    local _multiPlayerInfoTable = self:_getMultiPlayerInfoTable(serverId)

    local simplePlayerInfo = _multiPlayerInfoTable[playerId]
    if not simplePlayerInfo then
        return nil
    end

    if checkUpdate then
        simplePlayerInfo:checkUpdate()
    end

    return simplePlayerInfo
end

--[[
    只有一个参数的情况下 即playerId == nil时 serverId 就是 playerId
]]
function DataManager:isRequestingMultiPlayerInfo(serverId, playerId)
    if playerId == nil then
        playerId = serverId
        serverId = self:getCurServerId()
    end

    return self:_isRequestingMultiPlayerInfo(serverId, playerId)
end

function DataManager:_isRequestingMultiPlayerInfo(serverId, playerId)
    if not self._addingMultiInfoRequestTable or not self._waitingMultiInfoRequestTable then
        self:_getMultiPlayerInfoTable()
    end

    if not serverId then
        return false
    end

    self._addingMultiInfoRequestTable[serverId]  = self._addingMultiInfoRequestTable[serverId] or {}
    self._waitingMultiInfoRequestTable[serverId] = self._waitingMultiInfoRequestTable[serverId] or {}

    return isset(self._addingMultiInfoRequestTable[serverId], playerId) or isset(self._waitingMultiInfoRequestTable[serverId], playerId)
end

function DataManager:_clearRequestingMultiPlayerInfo(serverId, playerId)
    if self._addingMultiInfoRequestTable and isset(self._addingMultiInfoRequestTable, serverId) then
        self._addingMultiInfoRequestTable[serverId][playerId] = nil
    end

    if self._waitingMultiInfoRequestTable and isset(self._waitingMultiInfoRequestTable, serverId) then
        self._waitingMultiInfoRequestTable[serverId][playerId] = nil
    end
end

function DataManager:_addMultiInfoRequest(serverId, playerId)
    self._addingMultiInfoRequestTable = self._addingMultiInfoRequestTable or {}
    self._addingMultiInfoRequestTable[serverId] = self._addingMultiInfoRequestTable[serverId] or {}
    self._addingMultiInfoRequestTable[serverId][playerId] = true
end

function DataManager:_waitMultiInfoRequest(serverId, playerId)
    self._waitingMultiInfoRequestTable = self._waitingMultiInfoRequestTable or {}
    self._waitingMultiInfoRequestTable[serverId] = self._waitingMultiInfoRequestTable[serverId] or {}
    self._waitingMultiInfoRequestTable[serverId][playerId] = true
end

-- 请求他人信息(本服)
function DataManager:requestSimplePlayerInfo(playerIdArray)
    if type(playerIdArray) == "number" then
        playerIdArray = {playerIdArray}
    end

    local curServerId = self:getCurServerId()

    for _,playerId in ipairs(playerIdArray) do
        if not self:isRequestingMultiPlayerInfo(curServerId, playerId) then
            self:_addMultiInfoRequest(curServerId, playerId)
        end
    end

    if not self._requestSimplePlayerInfoHandler then
        self._requestSimplePlayerInfoHandler = lt.scheduler.performWithDelayGlobal(handler(self, self._requestSimplePlayerInfoDelay), 0)
    end
end

function DataManager:_requestSimplePlayerInfo(serverId, playerId)
    if not self:isRequestingMultiPlayerInfo(serverId, playerId) then
        self:_addMultiInfoRequest(serverId, playerId)
    end

    if not self._requestSimplePlayerInfoHandler then
        self._requestSimplePlayerInfoHandler = lt.scheduler.performWithDelayGlobal(handler(self, self._requestSimplePlayerInfoDelay), 0)
    end
end

-- 请求他人信息(跨服)
function DataManager:requestServerSimplePlayerInfo()
    -- body
end

function DataManager:_requestSimplePlayerInfoDelay()
    local curServerId = self:getCurServerId()
    for serverId,playerIdTable in pairs(self._addingMultiInfoRequestTable) do
        if serverId == curServerId then
            -- 本服玩家信息
            local realPlayerIdArray = {}
            for playerId,_ in pairs(playerIdTable) do
                table.insert(realPlayerIdArray, playerId)
            end
            lt.SocketApi:getSimplePlayerInfo(realPlayerIdArray)
        else
            -- TODO: 跨服玩家信息
        end

        self._waitingMultiInfoRequestTable[serverId] = self._addingMultiInfoRequestTable[serverId]
        self._addingMultiInfoRequestTable[serverId] = {}
    end

    self._requestSimplePlayerInfoHandler = nil
end

-- 获得他人详细数据
function DataManager:onGetSimplePlayerInfo(event)
    local s2cGetSimplePlayerInfo = event.data
    local code = s2cGetSimplePlayerInfo.code
    lt.CommonUtil.print("s2cGetSimplePlayerInfo code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cGetSimplePlayerInfo content\n"..tostring(s2cGetSimplePlayerInfo))
    
    local playerIdArray = {}
    local playerPairArray = {}

    local scSimplePlayerInfoArray = s2cGetSimplePlayerInfo.player_info_array
    for _,scSimplePlayerInfo in ipairs(scSimplePlayerInfoArray) do
        local simplePlayerInfo = self:setSimplePlayerInfo(scSimplePlayerInfo)

        local serverId = simplePlayerInfo:getServerId()
        local playerId = simplePlayerInfo:getId()

        table.insert(playerIdArray, playerId)
        table.insert(playerPairArray, {serverId = serverId, playerId = playerId})
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.SIMPLE_PLAYER_INFO_UPDATE, {playerIdArray = playerIdArray, playerPairArray = playerPairArray})
end

function DataManager:onUpdateSimplePlayerInfo(event)
    local s2cUpdateSimplePlayerInfo = event.data
    lt.CommonUtil.print("s2cUpdateSimplePlayerInfo OK")

    -- lt.CommonUtil.print("s2cUpdateSimplePlayerInfo content\n"..tostring(s2cUpdateSimplePlayerInfo))

    local scSimplePlayerInfo = s2cUpdateSimplePlayerInfo.player_info
    local simplePlayerInfo = self:setSimplePlayerInfo(scSimplePlayerInfo)

    local serverId = simplePlayerInfo:getServerId()
    local playerId = simplePlayerInfo:getId()

    local playerIdArray = {}
    table.insert(playerIdArray, playerId)

    local playerPairArray = {}
    table.insert(playerPairArray, {serverId = serverId, playerId = playerId})

    lt.GameEventManager:post(lt.GameEventManager.EVENT.SIMPLE_PLAYER_INFO_UPDATE, {playerIdArray = playerIdArray, playerPairArray = playerPairArray})

    if self:isTeammate(serverId, playerId) then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.TEAM_UPDATE, {status = 1})
    end
end

function DataManager:onPvpOnlineStatus(event)
    local s2cPvpOnlineStatus = event.data
    lt.CommonUtil.print("s2cPvpOnlineStatus OK")
    lt.CommonUtil.print("s2cPvpOnlineStatus content\n"..tostring(s2cPvpOnlineStatus))

    local serverId = s2cPvpOnlineStatus.server_id
    local playerId = s2cPvpOnlineStatus.player_id
    local status   = s2cPvpOnlineStatus.status

    self:_onPlayerStatusUpdate(serverId, playerId, status)
end

function DataManager:onPlayerStatusUpdate(event)
    local s2cPlayerStatusUpdate = event.data
    lt.CommonUtil.print("s2cPlayerStatusUpdate OK")
    lt.CommonUtil.print("s2cPlayerStatusUpdate content\n"..tostring(s2cPlayerStatusUpdate))

    local serverId = s2cPlayerStatusUpdate.player_pair.server_id
    local playerId = s2cPlayerStatusUpdate.player_pair.player_id
    local status   = s2cPlayerStatusUpdate.status

    self:_onPlayerStatusUpdate(serverId, playerId, status)
end

function DataManager:_onPlayerStatusUpdate(serverId, playerId, status)
    local simplePlayerInfo = self:getSimplePlayerInfo(serverId, playerId)
    if not simplePlayerInfo then
        return
    end

    simplePlayerInfo:setStatus(status)

    if self:isTeammate(serverId, playerId) then
        -- 更新队伍中的数据状态
        local teamInfo = self:getSelfTeamInfo()
        if teamInfo then
            local teamPlayer = teamInfo:getTeamPlayer(serverId, playerId)
            if teamPlayer then
                teamPlayer:setStatus(status)
            end
        end

        lt.GameEventManager:post(lt.GameEventManager.EVENT.TEAM_UPDATE, {status = 1})
    end
end

---- ################################################## 玩家网络状态 ##################################################
function DataManager:getPlayerNetEnvTable()
    if not self._playerNetEnvTable then
        self._playerNetEnvTable = {}
    end

    return self._playerNetEnvTable
end

function DataManager:setSelfNetEnv(netLevel)
    local netEnv = 0
    if device.platform ~= "windows" then
        netEnv = network.getInternetConnectionStatus()
    end

    local playerNetEnvTable = self:getPlayerNetEnvTable()
    local selfPlayerId = self:getPlayerId()
    local playerNetEnv = lt.PlayerNetEnv.new({player_id = selfPlayerId, net_env = netEnv, net_level = netLevel})

    playerNetEnvTable[selfPlayerId] = playerNetEnv
    
    -- 发送消息
    lt.GameEventManager:post(lt.GameEventManager.EVENT.PLAYER_NET_ENV_UPDATE)
end

function DataManager:getSelfNetEnv()
    local playerId = self:getPlayerId()

    return self:getPlayerNetEnv(playerId)
end

function DataManager:getPlayerNetEnv(playerId)
    if not playerId then
        playerId = self:getPlayerId()
    end

    local playerNetEnvTable = self:getPlayerNetEnvTable()
    return playerNetEnvTable[playerId]
end

function DataManager:onUpdateNetworkResponse(event)
    local s2cUpdateNetworkResponse = event.data
    local code = s2cUpdateNetworkResponse.code
    lt.CommonUtil.printf("s2cUpdateNetworkResponse code %d", code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    local playerNetEnvTable = self:getPlayerNetEnvTable()
    local playerNetEnv = lt.PlayerNetEnv.new(s2cUpdateNetworkResponse)

    playerNetEnvTable[playerNetEnv:getPlayerId()] = playerNetEnv

    if playerNetEnv:getPlayerId() == self:getPlayerId() then
    else
        -- 发送消息
        lt.GameEventManager:post(lt.GameEventManager.EVENT.PLAYER_NET_ENV_UPDATE)
    end
end

function DataManager:onNeedReloginResponse(event)
    lt.CommonUtil.printf("onNeedReloginResponse")
    lt.SocketLoading:socketLoadingOff()
    lt.AlertLayer:alertOn(lt.StringManager:getString("STRING_ERROR_PLAYER_DATA"), function( )
        -- lt.CommonUtil.print("DataManager:resetBegin")
        -- -- 切换到重置场景用于清理之前场景的资源
        -- display.replaceScene(lt.ResetScene.new())
        lt.SocketApi:disconnect()
        lt.Game:resetBegin()
    end)
end

---- ################################################## 好人卡信息 ##################################################
--今日好人卡兑换道具table
function DataManager:getTodayExchangePointTable()
    if not self._todayExchangePointTable then
        self._todayExchangePointTable = {}
    end

    return self._todayExchangePointTable
end
function DataManager:getTodayExchangePointById(id)
    local todayExchangePointTable = self:getTodayExchangePointTable()

    return todayExchangePointTable[id]
end


--通过活动活着地下城获得好人卡点数
function DataManager:getTodayGainPointTable()
    if not self._todayGainPointTable then
        self._todayGainPointTable = {}
    end

    return self._todayGainPointTable
    
end

function DataManager:getTodayGainPointByType(type)
    local todayGainPointTable = self:getTodayGainPointTable()
    if not todayGainPointTable[type] then
        return  0
    end
    return todayGainPointTable[type]
end

--获取今日获得好人卡点数
function DataManager:getTodayGoodcardPoint()
    if not self._todayGoodcardPoint then
        self._todayGoodcardPoint = 0
    end

    return self._todayGoodcardPoint
end

function DataManager:onGetExchangePointInfo(event)
    local s2cOnGetExchangePointInfo = event.data
    local code = s2cOnGetExchangePointInfo.code
    lt.CommonUtil.printf("s2cOnGetExchangePointInfo code %d", code)

    --今日兑换道具table
    local todayExchangePointTable = self:getTodayExchangePointTable()
    local s2cExchangeCountArray = s2cOnGetExchangePointInfo.exchange_count_array

    if s2cExchangeCountArray then
        for k,v in ipairs(s2cExchangeCountArray) do
            local idValuePair = lt.IdValuePair.new(v)
            local id = idValuePair:getId()
            todayExchangePointTable[id] = idValuePair
        end
    end
end

function DataManager:onGetExchangeGoodmanPointInfo(event)--获得玩家当天活动中获得的好人卡数
    local s2cOnGetExchangeGoodmanPointInfo = event.data
    local code = s2cOnGetExchangeGoodmanPointInfo.code
    lt.CommonUtil.printf("s2cOnGetExchangeGoodmanPointInfo code %d", code)

    --今日获得好人卡点数
    local todayGainPointTable = self:getTodayGainPointTable()
    local s2cCurdayGainPointArray = s2cOnGetExchangeGoodmanPointInfo.cur_day_gain_point_array

    for k,v in ipairs(s2cCurdayGainPointArray) do
        local idValuePair = lt.IdValuePair.new(v)
        local type = idValuePair:getId()
        local value = idValuePair:getValue()
        local count = idValuePair:getCount()
        if count and count == 1 then
            lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_GOODCARD_TODAT_ACTIVITY_TITLE"))
        end
        todayGainPointTable[type] = value
    end
end

function DataManager:onGainGoodmanPoint(event)
    local s2conGainGoodmanPoint = event.data
    lt.CommonUtil.print("s2conGainGoodmanPoint code ====="..s2conGainGoodmanPoint.code)

    local point = s2conGainGoodmanPoint.point or 0

    if point > 0 then
        lt.NoticeManager:addGainItemMessage(lt.GameIcon.TYPE.ITEM,lt.Constants.ITEM.GOODMAN_SCORE,point)
    end
    
end

---- ################################################## 时装 ##################################################
function DataManager:getPlayerDressTable()
    if not self._playerDressTable then
        self._playerDressTable = {}
    end
    return self._playerDressTable
end

function DataManager:getPlayerDress(dressId)
    local playerDressTable = self:getPlayerDressTable()
    return playerDressTable[dressId]
end

function DataManager:hasPlayerDress(dressId)
    local mstDress = lt.CacheManager:getDress(dressId)
    if not mstDress then
        return false
    end
    local playerDressTable = self:getPlayerDressTable()
    for _,playerDress in pairs(playerDressTable) do
        local id = playerDress:getDressId()
        local dressInfo = lt.CacheManager:getDress(id)
        if not dressInfo then
            return false
        end
        if mstDress:getType() == dressInfo:getType() and mstDress:getSex() == dressInfo:getSex() and id >= dressId then
            return true
        end
    end
    return false
end

function DataManager:onGetDressListResponse(event)
    local s2cGetDressListResponse = event.data
    local code = s2cGetDressListResponse.code
    lt.CommonUtil.print("s2cGetDressListResponse code "..code)
    local playerDressTable = self:getPlayerDressTable()
    for _,dressInfo in ipairs(s2cGetDressListResponse.dress_array) do
        local playerDress = lt.PlayerDress.new(dressInfo)
        playerDressTable[playerDress:getDressId()] = playerDress
    end 
end

function DataManager:onUpdateDressListResponse(event)
    local s2cUpdateDressListResponse = event.data
    local code = s2cUpdateDressListResponse.code
    lt.CommonUtil.print("s2cUpdateDressListResponse code "..code)
    local playerDressTable = self:getPlayerDressTable()
    for _,dressInfo in ipairs(s2cUpdateDressListResponse.add_dress_array) do
        local playerDress = lt.PlayerDress.new(dressInfo)
        playerDressTable[playerDress:getDressId()] = playerDress
    end 

    for _,dressInfo in ipairs(s2cUpdateDressListResponse.set_dress_array) do
        local playerDress = lt.PlayerDress.new(dressInfo)
        playerDressTable[playerDress:getDressId()] = playerDress
    end 
end

---- ################################################## 引导 ##################################################
function DataManager:getGuideTable( )
    if not self._guideTable then
        self._guideTable = {}
    end

    return self._guideTable
end

function DataManager:getGuideStep(guideClassId)
    local guideTable = self:getGuideTable()
    return guideTable[guideClassId] or 0
end

function DataManager:setGuideStep(guideClassId, guideStep)
    local guideTable = self:getGuideTable()
    
    guideTable[guideClassId] = guideStep
end

function DataManager:onGetGuideProgressListResponse(event)
    local s2cGetGuideProgressList = event.data
    local code = s2cGetGuideProgressList.code
    lt.CommonUtil.printf("s2cGetGuideProgressList code %d", code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    local guideTable = self:getGuideTable()
    local scProgressArray = s2cGetGuideProgressList.progress_array
    for _,scIdValuePair in ipairs(scProgressArray) do
        local id    = scIdValuePair.id
        local value = scIdValuePair.value

        guideTable[id] = value
    end
end

function DataManager:onUpdateGuideProgressListResponse(event)
    local s2cUpdateGuideProgressList = event.data
    local code = s2cUpdateGuideProgressList.code
    lt.CommonUtil.printf("s2cUpdateGuideProgressList code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end
    
    -- lt.CommonUtil.printf("s2cUpdateGuideProgressList content\n"..tostring(s2cUpdateGuideProgressList))

    local guideTable = self:getGuideTable()
    local scProgressArray = s2cUpdateGuideProgressList.set_progress_array
    for _,scIdValuePair in ipairs(scProgressArray) do
        local id    = scIdValuePair.id
        local value = scIdValuePair.value

        guideTable[id] = value
    end
end

---- ################################################## 福利 ##################################################
function DataManager:getDailySigninLogListTable()

    if not self._dailySigninLogListTable then
        self._dailySigninLogListTable = {}
    end

    return self._dailySigninLogListTable
end

function DataManager:getDailySigninLogListInfo(wday)
    local dailySigninLogListTable = self:getDailySigninLogListTable()

    if dailySigninLogListTable[wday] then
        return dailySigninLogListTable[wday]
    else
        return nil
    end

end

function DataManager:onGetDailySigninLogListResponse(event)
    local s2cOnGetDailySigninLogListResponse = event.data

    lt.CommonUtil.print("s2cOnGetDailySigninLogListResponse code ==="..s2cOnGetDailySigninLogListResponse.code)

    local dailySigninLogListTable = self:getDailySigninLogListTable()

    local dailySigninLogList = s2cOnGetDailySigninLogListResponse.daily_signin_list


    for _,info in ipairs(dailySigninLogList) do
        local signinInfo = lt.DailySignInLog.new(info)

        local wday = signinInfo:getWdayId()

        local day = wday - 1 
        if day == 0 then
            day = 7
        end
        dailySigninLogListTable[day] = signinInfo
    end

end

function DataManager:onUpdateDailySigninLogListResponse(event)
    local s2cOnUpdateDailySigninLogListResponse = event.data

    lt.CommonUtil.print("s2cOnUpdateDailySigninLogListResponse code ==="..s2cOnUpdateDailySigninLogListResponse.code)

    local dailySigninLogListTable = self:getDailySigninLogListTable()

    local dailySigninLogList = s2cOnUpdateDailySigninLogListResponse.daily_signin_list


    for _,info in ipairs(dailySigninLogList) do
        local signinInfo = lt.DailySignInLog.new(info)

        local wday = signinInfo:getWdayId()
        local day = wday - 1 
        if day == 0 then
            day = 7
        end

        dailySigninLogListTable[day] = signinInfo
    end
end

---- ################################################## 升级奖励 ##################################################
function DataManager:getUpgradeRewardLogListTable()

    if not self._upgradeRewardLogListTable then
        self._upgradeRewardLogListTable = {}
    end

    return self._upgradeRewardLogListTable
end

function DataManager:getUpgradeRewardLogListInfo(level)
    local upgradeRewardLogListTable = self:getUpgradeRewardLogListTable()

    if upgradeRewardLogListTable[level] then
        return upgradeRewardLogListTable[level]
    else
        return nil
    end

end

function DataManager:onGetUpgradeRewardLogListResponse(event)
    local s2cOnGetUpgradeRewardLogListResponse = event.data

    lt.CommonUtil.print("s2cOnGetUpgradeRewardLogListResponse code ======"..s2cOnGetUpgradeRewardLogListResponse.code)


    local upgradeRewardLogListTable = self:getUpgradeRewardLogListTable()

    local upgradeRewardLogList = s2cOnGetUpgradeRewardLogListResponse.upgrade_reward_list


    for _,info in ipairs(upgradeRewardLogList) do
        local upgradeRewardInfo = lt.UpgradeRewardLog.new(info)

        local level = upgradeRewardInfo:getLevel()
        upgradeRewardLogListTable[level] = upgradeRewardInfo
    end
end

function DataManager:onUpdateUpgradeRewardLogListResponse(event)
    local s2cOnUpdateUpgradeRewardLogListResponse = event.data

    lt.CommonUtil.print("s2cOnUpdateUpgradeRewardLogListResponse code ======"..s2cOnUpdateUpgradeRewardLogListResponse.code)

    local upgradeRewardLogListTable = self:getUpgradeRewardLogListTable()

    local upgradeRewardLogList = s2cOnUpdateUpgradeRewardLogListResponse.upgrade_reward_list

    for _,info in ipairs(upgradeRewardLogList) do
        local upgradeRewardInfo = lt.UpgradeRewardLog.new(info)

        local level = upgradeRewardInfo:getLevel()
        upgradeRewardLogListTable[level] = upgradeRewardInfo
    end
end

---- ################################################## 冲级奖励 ##################################################
function DataManager:getPromoteRewardList()
    if not self._promoteRewardListTable then
        self._promoteRewardListTable = {}
    end

    return self._promoteRewardListTable
end

function DataManager:onGetPromoteRewardResponse(event)

    local s2cOnGetPromoteRewardResponse = event.data
    
    lt.CommonUtil.print("s2cOnGetPromoteRewardResponse code========="..s2cOnGetPromoteRewardResponse.code)

    local promoteRewardListTable = self:getPromoteRewardList()

    local array = s2cOnGetPromoteRewardResponse.promote_reward_list

    for _,s2cPromoteReward in ipairs(array) do
        local rewardInfo = lt.PromoteReward.new(s2cPromoteReward)

        local level = rewardInfo:getLevel()
        promoteRewardListTable[level] = rewardInfo
    end


end

function DataManager:onUpdatePromoteRewardResponse(event)

    local s2cOnUpdatePromoteRewardResponse = event.data

    lt.CommonUtil.print("s2cOnUpdatePromoteRewardResponse code========="..s2cOnUpdatePromoteRewardResponse.code)

    local promoteRewardListTable = self:getPromoteRewardList()

    local array = s2cOnUpdatePromoteRewardResponse.promote_reward_list

    for _,s2cPromoteReward in ipairs(array) do
        local rewardInfo = lt.PromoteReward.new(s2cPromoteReward)

        local level = rewardInfo:getLevel()
        promoteRewardListTable[level] = rewardInfo
    end

    
end

function DataManager:getPromoteRewardReceiveTimesTable()
    if not self._promoteRewardReceiveTimesTable then
        self._promoteRewardReceiveTimesTable = {}
    end

    return self._promoteRewardReceiveTimesTable
end


function DataManager:onGetPromoteRewardReceiveTimesResponse(event)
    local s2cOnGetPromoteRewardReceiveTimesResponse = event.data

    lt.CommonUtil.print("s2cOnGetPromoteRewardReceiveTimesResponse code ====="..s2cOnGetPromoteRewardReceiveTimesResponse.code)

    local times30 = s2cOnGetPromoteRewardReceiveTimesResponse.promote_level_30
    local times35 = s2cOnGetPromoteRewardReceiveTimesResponse.promote_level_35
    local times40 = s2cOnGetPromoteRewardReceiveTimesResponse.promote_level_40
    local times50 = s2cOnGetPromoteRewardReceiveTimesResponse.promote_level_50
    local times55 = s2cOnGetPromoteRewardReceiveTimesResponse.promote_level_55
    local times59 = s2cOnGetPromoteRewardReceiveTimesResponse.promote_level_59

    local receiveTimesTable = self:getPromoteRewardReceiveTimesTable()

    receiveTimesTable[30] = times30
    receiveTimesTable[35] = times35
    receiveTimesTable[40] = times40
    receiveTimesTable[50] = times50
    receiveTimesTable[55] = times55
    receiveTimesTable[59] = times59
end

---- ################################################## 符文 ##################################################
--镶嵌符文
function DataManager:getRuneListTable()
    
    if not self._runeListTable then
        self._runeListTable = {}
    end

    return self._runeListTable
end

function DataManager:getRuneListTableByPage(page)
    local runeListTable = self:getRuneListTable()

    if runeListTable[page] then
        return runeListTable[page]
    else
        return {}
    end
    
end

function DataManager:getRune(page,position)
    local runeListTable = self:getRuneListTableByPage(page)
    if runeListTable then
        return runeListTable[position]
    end
    return nil
end

function DataManager:onGetRuneListResponse(event)
    local s2cOnGetRuneListResponse = event.data
    lt.CommonUtil.print("s2cOnGetRuneListResponse OK")
    -- lt.CommonUtil.print("s2cOnGetRuneListResponse content\n"..tostring(s2cOnGetRuneListResponse))

    local runeListTable = self:getRuneListTable()

    local runeListArray = s2cOnGetRuneListResponse.rune_array

    for _,s2cRuneInfo in ipairs(runeListArray) do
        local runeInfo = lt.Rune.new(s2cRuneInfo)

        local page = runeInfo:getPage()
        local position = runeInfo:getPosition()

        if page then
            local arr = runeListTable[page]
            if arr then
                arr[position] = runeInfo
            else
                arr = {}
                runeListTable[page] = arr
                arr[position] = runeInfo
                
            end
        end
    end

end

function DataManager:onUpdateRuneListResponse(event)
    local s2cOnUpdateRuneListResponse = event.data
    lt.CommonUtil.print("s2cOnUpdateRuneListResponse OK")
    -- lt.CommonUtil.print("s2cOnUpdateRuneListResponse content\n"..tostring(s2cOnUpdateRuneListResponse))

    local runeListTable = self:getRuneListTable()

    local addRuneArray = s2cOnUpdateRuneListResponse.add_rune_array

    for _,s2cAddRuneInfo in pairs(addRuneArray) do

        local runeInfo = lt.Rune.new(s2cAddRuneInfo)

        local page = runeInfo:getPage()
        local position = runeInfo:getPosition()

        if page then
            local arr = runeListTable[page]
            if arr then
                arr[position] = runeInfo
            else
                arr = {}
                runeListTable[page] = arr
                arr[position] = runeInfo
                
            end
        end
    end

    local setRuneArray = s2cOnUpdateRuneListResponse.set_rune_array

    for _,s2cSetRuneInfo in pairs(setRuneArray) do

        local runeInfo = lt.Rune.new(s2cSetRuneInfo)

        local page = runeInfo:getPage()
        local position = runeInfo:getPosition()

        if page then
            local arr = runeListTable[page]
            if arr then
                arr[position] = runeInfo
            else
                arr = {}
                runeListTable[page] = arr
                arr[position] = runeInfo
                
            end
        end

    end


    lt.GameEventManager:post(lt.GameEventManager.EVENT.RUNE_UPDATE)
end

--获取可出售符文table
function DataManager:getBagRuneCanSaleTable()

    local leftCountTable = {}
    local allRuneModelTable = {}
    for i=1,10 do
        local runeModelTable = {}
        local runeListTable = self:getRuneListTableByPage(i)
        for _,runeInfo in pairs(runeListTable) do
            local modelId = runeInfo:getModelId()
            if modelId > 0 then
                runeModelTable[modelId] = (runeModelTable[modelId] or 0) + 1
            end
        end

        for modelId,count in pairs(runeModelTable) do
            allRuneModelTable[modelId] = math.max((allRuneModelTable[modelId] or 0), count)
        end
    end

    local runeBagListTable = self:getBagRuneListTable()

    local currentTable = {}

    for _,playerRune in pairs(runeBagListTable) do
        local modelId = playerRune:getModelId()
        local totalCount = playerRune:getTotalSize()

        local useCount = allRuneModelTable[modelId] or 0

        local leftCount = totalCount - useCount
        leftCountTable[modelId] = leftCount
        if leftCount > 0 then 
            currentTable[modelId] = playerRune
        end
    end

    return currentTable,leftCountTable
end

--背包符文
function DataManager:getBagRuneListTable()
    
    if not self._runeBagListTable then
        self._runeBagListTable = {}
    end

    return self._runeBagListTable
end

function DataManager:getBagRuneInfo(modelId)
    local bagRuneList = self:getBagRuneListTable()
    return bagRuneList[modelId]
end

function DataManager:onGetBagRuneListResponse(event)
    local s2cOnGetBagRuneListResponse = event.data
    lt.CommonUtil.print("s2cOnGetBagRuneListResponse OK")
    -- lt.CommonUtil.print("s2cOnGetBagRuneListResponse content\n"..tostring(s2cOnGetBagRuneListResponse))

    local runeBagListTable = self:getBagRuneListTable()

    local runeBagListArray = s2cOnGetBagRuneListResponse.rune_bag_array

    for _,s2cRuneInfo in ipairs(runeBagListArray) do
        local runeInfo = lt.PlayerRune.new(s2cRuneInfo)

        local modelId = runeInfo:getModelId()
        local size = runeInfo:getSize()

        -- TODO:
        -- if size > 0  then
            runeBagListTable[modelId] = runeInfo
        -- end
    end
end

function DataManager:onUpdateBagRuneListResponse(event)
    local s2cOnUpdateBagRuneListResponse = event.data
    lt.CommonUtil.print("刷新背包数量")
    local runeBagListTable = self:getBagRuneListTable()
    local addArray = s2cOnUpdateBagRuneListResponse.add_rune_bag_array
    local setArray = s2cOnUpdateBagRuneListResponse.set_rune_bag_array

    for _,s2cRuneInfo in ipairs(addArray) do
        local runeInfo = lt.PlayerRune.new(s2cRuneInfo)

        local modelId = runeInfo:getModelId()
        runeBagListTable[modelId] = runeInfo
    end

    for _,s2cRuneInfo in ipairs(setArray) do
        local runeInfo = lt.PlayerRune.new(s2cRuneInfo)

        local modelId = runeInfo:getModelId()
        runeBagListTable[modelId] = runeInfo
    end
end


--符文页数和名字
function DataManager:getRunePageListTable()

    if not self._runePageListTable then
        self._runePageListTable = {}
    end

    return self._runePageListTable
end

function DataManager:getRunePageInfo(page)
    local runePageListTable = self:getRunePageListTable()

    return runePageListTable[page]
end

function DataManager:onGetRunePageListResponse(event)
    local s2cOnGetRunePageListResponse = event.data
    lt.CommonUtil.print("s2cOnGetRunePageListResponse OK")
    
    local runePageListTable = self:getRunePageListTable()

    local runePageListArray = s2cOnGetRunePageListResponse.rune_page_array

    for _,s2cRunePage in ipairs(runePageListArray) do
        local runePage = lt.RunePage.new(s2cRunePage)

        local page = runePage:getPage()

        runePageListTable[page] = runePage

    end
end

function DataManager:onUpdateRunePageListResponse(event)
    local s2cOnUpdateRunePageListResponse = event.data
    lt.CommonUtil.print("s2cOnUpdateRunePageListResponse OK")

    local runePageListTable = self:getRunePageListTable()

    local addArray = s2cOnUpdateRunePageListResponse.add_rune_page_array

    for _,s2cRunePage in ipairs(addArray) do
        local runePage = lt.RunePage.new(s2cRunePage)

        local page = runePage:getPage()

        runePageListTable[page] = runePage

    end

    local setArray = s2cOnUpdateRunePageListResponse.set_rune_page_array

    for _,s2cRunePage in ipairs(setArray) do
        local runePage = lt.RunePage.new(s2cRunePage)

        local page = runePage:getPage()

        runePageListTable[page] = runePage

    end
end

--符文宝箱
function DataManager:getRuneBoxTable()
    if not self._runeBoxTable then
        self._runeBoxTable = {}
    end
    return self._runeBoxTable
end

function DataManager:getRuneBox(currencyType)
    local runeBoxTable = self:getRuneBoxTable()
    return runeBoxTable[currencyType]
end

function DataManager:onGetRuneBoxListResponse(event)
    local s2cOnGetRuneBoxListResponse = event.data
    lt.CommonUtil.print("s2cOnGetRuneBoxListResponse code ==="..s2cOnGetRuneBoxListResponse.code)
    
    local runeBoxTable = self:getRuneBoxTable()
    for _,runeBox in ipairs(s2cOnGetRuneBoxListResponse.rune_box_array) do
        local playerRuneBox = lt.PlayerRuneBox.new(runeBox)
        runeBoxTable[playerRuneBox:getCurrencyType()] = playerRuneBox
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.RUNE_BOX_LIST)
end

--符文穿戴
function DataManager:onRuneEquipResponse(event)
    local s2cOnRuneEquipResponse = event.data

    lt.CommonUtil.print("s2cOnRuneEquipResponse code===="..s2cOnRuneEquipResponse.code)

    if s2cOnRuneEquipResponse.code == 0 then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_RUNE_SKILL)
    end
end

--符文卸下
function DataManager:onRuneUnEquipResponse(event)
    local s2cOnRuneUnEquipResponse = event.data

    lt.CommonUtil.print("s2cOnRuneUnEquipResponse code===="..s2cOnRuneUnEquipResponse.code)

    if s2cOnRuneUnEquipResponse.code == 0 then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_RUNE_SKILL)
    end
end

---- ################################################## 自动分解相关 ##################################################
function DataManager:getEquipmentAutoDecomposeInfo()
    

    return self._equipmentAutoDecomposeInfo
end

function DataManager:onEquipmentAutoDecompose(event)

    local s2cOnEquipmentAutoDecompose = event.data

    lt.CommonUtil.print("s2cOnEquipmentAutoDecompose code======="..s2cOnEquipmentAutoDecompose.code)

    local autoInfo = s2cOnEquipmentAutoDecompose.equipment_auto_decompose

    self._equipmentAutoDecomposeInfo = lt.EquipmentAutoDecompose.new(autoInfo)
    
    lt.GameEventManager:post(lt.GameEventManager.EVENT.AUTO_STATUS)
end

function DataManager:onGetAutoDecomposeList(event)
    local s2cOnGetAutoDecomposeList = event.data
    lt.CommonUtil.print("分解装备分解装备")
    local array = s2cOnGetAutoDecomposeList.decompose_item_array

    for i,item in ipairs(array) do
        local type = item.type
        local modelId = item.model_id
        local count = item.count

        local equipmentInfo = lt.CacheManager:getEquipmentInfo(modelId)
        local name = equipmentInfo:getName()
        local str1 = lt.StringManager:getString("STRING_EQUIPMENT_RESOLVE_STRING_1")
        local str2 = count
        local str3 = lt.StringManager:getString("STRING_EQUIPMENT_RESOLVE_STRING_2")

        local quality = equipmentInfo:getQuality()


        local equipColor = lt.ResourceManager:getQualityColor(quality)

        lt.NoticeManager:addRichMessage({{message = str1, color = lt.Constants.COLOR.WHITE, outline = true},{message = str2, color = lt.Constants.COLOR.GREEN, outline = true}
            ,{message = str3, color = lt.Constants.COLOR.WHITE, outline = true}, {message = name, color = equipColor, outline = true}})

    end

end

---- ################################################## 魔王巢穴 ##################################################
function DataManager:getDevilNestListTable()
    if not self._devilNestListTable then
        self._devilNestListTable = {}
    end

    return self._devilNestListTable
end

function DataManager:getCurrentFloor()
    local devilTable = self:getDevilNestListTable()

    local develNestArray = lt.CommonUtil:getArrayFromTable(devilTable)

    table.sort(develNestArray,function(info1,info2)
        if info1:getFloorId() < info2:getFloorId() then
            return true
        end
    end)

    local floor = 1

    for i = 1,#develNestArray do
        local info = develNestArray[i]
        local floorId = info:getFloorId()
        local state = info:getState()
        if state == 0 then
            floor = floorId
            break
        end

        if floorId == 10 and state == 1 then
            floor = floorId
        end

    end

    return floor
end

function DataManager:onGetDevilNestListResponse(event)
    local s2cOnGetDevilNestListResponse = event.data
    lt.CommonUtil.print("s2cOnGetDevilNestListResponse OK")
    -- lt.CommonUtil.print("s2cOnGetDevilNestListResponse content\n"..tostring(s2cOnGetDevilNestListResponse))

    local devilListTable = self:getDevilNestListTable()

    local addArray = s2cOnGetDevilNestListResponse.add_data_array

    for _,s2cDevilNestInfo in ipairs(addArray) do
        local devilNestInfo = lt.PlayerDevilNest.new(s2cDevilNestInfo)

        local floorId = devilNestInfo:getFloorId()

        devilListTable[floorId] = devilNestInfo
    end

    local setArray = s2cOnGetDevilNestListResponse.set_data_array

    for _,s2cDevilNestInfo in ipairs(setArray) do
        local devilNestInfo = lt.PlayerDevilNest.new(s2cDevilNestInfo)

        local floorId = devilNestInfo:getFloorId()

        devilListTable[floorId] = devilNestInfo
    end
end

function DataManager:getDevilNestRankListTable()
    if not self._devilNestRankListTable then
        self._devilNestRankListTable = {}
    end

    return self._devilNestRankListTable
end

function DataManager:getCurrentRankArray(floorId)
    local array = {}
    local rankListTable = self:getDevilNestRankListTable()

    local currentTable = rankListTable[floorId]

    if currentTable then
        local currentArray = lt.CommonUtil:getArrayFromTable(currentTable)

        for i = 1, #currentArray do
            local info = currentArray[i]

            local spendTime = info:getSpendTime()

            if spendTime > 0 then
                array[#array + 1] = info
            end

        end

    end

    return array
end

function DataManager:onGetDevilNestRankListResponse(event)
    local s2cOnGetDevilNestRankListResponse = event.data
    lt.CommonUtil.print("s2cOnGetDevilNestRankListResponse OK")

    local devilListTable = self:getDevilNestRankListTable()

    local addArray = s2cOnGetDevilNestRankListResponse.add_data_array

    for _,s2cDevilNestInfo in ipairs(addArray) do
        local devilNestInfo = lt.PlayerDevilNestRank.new(s2cDevilNestInfo)

        local id = devilNestInfo:getFloorId()
        local rankId = devilNestInfo:getRankId()

        if not isset(devilListTable,id) then
            devilListTable[id] = {}
        end

        devilListTable[id][rankId] = devilNestInfo
    end

    local setArray = s2cOnGetDevilNestRankListResponse.set_data_array

    for _,s2cDevilNestInfo in ipairs(setArray) do
        local devilNestInfo = lt.PlayerDevilNestRank.new(s2cDevilNestInfo)

        local id = devilNestInfo:getFloorId()
        local rankId = devilNestInfo:getRankId()

        if not isset(devilListTable,id) then
            devilListTable[id] = {}
        end

        devilListTable[id][rankId] = devilNestInfo
    end

end

function DataManager:getDevilNestExtraListTable()
    if not self._devilNestExtraListTable then
        self._devilNestExtraListTable = {}
    end

    return self._devilNestExtraListTable
end

function DataManager:onGetDevilNestExtraListResponse(event)
    local s2cOnGetDevilNestExtraListResponse = event.data
    lt.CommonUtil.print("s2cOnGetDevilNestExtraListResponse OK")

    local devilListTable = self:getDevilNestExtraListTable()

    local addArray = s2cOnGetDevilNestExtraListResponse.add_data_array

    for _,s2cDevilNestInfo in ipairs(addArray) do
        local devilNestInfo = lt.PlayerDevilNestExtra.new(s2cDevilNestInfo)

        local id = devilNestInfo:getFloorId()

        devilListTable[id] = devilNestInfo
    end

    local setArray = s2cOnGetDevilNestExtraListResponse.set_data_array

    for _,s2cDevilNestInfo in ipairs(setArray) do
        local devilNestInfo = lt.PlayerDevilNestExtra.new(s2cDevilNestInfo)

        local id = devilNestInfo:getFloorId()

        devilListTable[id] = devilNestInfo
    end
end

---- ################################################## 药剂相关 ##################################################
function DataManager:getPharmacyColumnDisplayTable()
    if not self._pharmacyColumnDisplayInfo then
        self._pharmacyColumnDisplayInfo = {}
    end

    return self._pharmacyColumnDisplayInfo
end

function DataManager:onGetPharmacyColumnDisplay(event)
    local s2cOnGetPharmacyColumnDisplay = event.data

    lt.CommonUtil.print("s2cOnGetPharmacyColumnDisplay code===="..s2cOnGetPharmacyColumnDisplay.code)


    self._pharmacyColumnDisplayInfo = lt.PlyPharmacyColumnDisplay.new(s2cOnGetPharmacyColumnDisplay.pharmacy_column_display)

    lt.GameEventManager:post(lt.GameEventManager.EVENT.POTION_UPDATE)
end

---- ################################################## 扭蛋机 ##################################################
function DataManager:getEggDiamond()--扭蛋池
    if not self._eggDiamond then
        self._eggDiamond = {}
    end
    return self._eggDiamond
end

function DataManager:onGetEggDiamond(event)
    local s2cOnGetEggDiamond = event.data

    lt.CommonUtil.print("s2cOnGetEggDiamond.code==")
    if not self._eggDiamond then
        self._eggDiamond = {}
    end

    if not self._eggDiamond.newValue then
        if (self._eggDiamond.newValue or 0) ~= s2cOnGetEggDiamond.diamond then
            self._eggDiamond.newValue = s2cOnGetEggDiamond.diamond
            lt.GameEventManager:post(lt.GameEventManager.EVENT.PLAYER_EGG_POOL_REFRESH)
        end
        self._eggDiamond.oldValue = self._eggDiamond.newValue
    else
        self._eggDiamond.oldValue = self._eggDiamond.newValue
        if self._eggDiamond.newValue ~= s2cOnGetEggDiamond.diamond then
            self._eggDiamond.newValue = s2cOnGetEggDiamond.diamond
            lt.GameEventManager:post(lt.GameEventManager.EVENT.PLAYER_EGG_POOL_REFRESH)
        end
    end
end

function DataManager:getEggArray()
    if not self._eggArray then
        self._eggArray = {}
    end
    return self._eggArray
end

function DataManager:onGetEgg(event)--获取扭过的蛋的id序号
    local s2cOnGetEgg = event.data
    lt.CommonUtil.print("s2cOnGetEgg OK")

    self._eggArray = {}
    local eggArray = self:getEggArray()
    for _,id in ipairs(s2cOnGetEgg.id_array) do
        eggArray[#eggArray+1] = id
    end
end

---- ################################################## 功能开启 ##################################################
function DataManager:getFuncOpenTable( )
    if not self._functionOpenTable then
        self._functionOpenTable = {}
    end

    return self._functionOpenTable
end

function DataManager:onGetFunctionOpenList(event)
    local s2cGetFunctionOpenList = event.data
    local code = s2cGetFunctionOpenList.code
    lt.CommonUtil.print("s2cGetFunctionOpenList code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cGetFunctionOpenList content\n"..tostring(s2cGetFunctionOpenList))

    local funcOpenTable = self:getFuncOpenTable()

    local scFunctionOpenArray = s2cGetFunctionOpenList.function_open_array
    for _,scFunctionOpen in ipairs(scFunctionOpenArray) do
        local functionId = scFunctionOpen.function_id
        local isOpen     = (scFunctionOpen.is_receive or 0) == 1

        funcOpenTable[functionId] = isOpen
    end
end

function DataManager:onUpdateFunctionOpenList(event)
    local s2cUpdateFunctionOpenList = event.data
    local code = s2cUpdateFunctionOpenList.code
    lt.CommonUtil.print("s2cUpdateFunctionOpenList code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cUpdateFunctionOpenList content\n"..tostring(s2cUpdateFunctionOpenList))

    local funcOpenTable = self:getFuncOpenTable()

    local scAddFunctionOpenArray = s2cUpdateFunctionOpenList.add_function_open_array
    for _,scFunctionOpen in ipairs(scAddFunctionOpenArray) do
        local functionId = scFunctionOpen.function_id
        local isOpen     = (scFunctionOpen.is_receive or 0) == 1

        funcOpenTable[functionId] = isOpen
    end

    local scSetFunctionOpenArray = s2cUpdateFunctionOpenList.set_function_open_array
    for _,scFunctionOpen in ipairs(scSetFunctionOpenArray) do
        local functionId = scFunctionOpen.function_id
        local isOpen     = (scFunctionOpen.is_receive or 0) == 1

        funcOpenTable[functionId] = isOpen
    end

    -- 功能开启更新
    lt.GameEventManager:post(lt.GameEventManager.EVENT.FUNC_OPEN)
end

function DataManager:isFunctionOpen(id)
    if self:_isFunctionOpen(id) then
        return true
    end

    local functionOpen = lt.CacheManager:getFunctionOpen(id)
    if not functionOpen then
        return false
    end

    local playerLevel = self:getPlayerLevel()

    return playerLevel >= functionOpen:getOpenLevel()
end

function DataManager:_isFunctionOpen(id)
    local functionOpenTable = self:getFuncOpenTable()
    return functionOpenTable[id]
end

function DataManager:getCloserFunctionOpen()
    local functionOpenArray = lt.CacheManager:getFunctionOpenArray()
    for _,functionOpen in ipairs(functionOpenArray) do
        local id = functionOpen:getId()
        if not self:_isFunctionOpen(id) then
            return functionOpen
        end
    end

    return nil
end

-- 技能功能是否开启
function DataManager:isSkillFuncOpen()
    return self:isFunctionOpen(1000)
end

-- 时装功能是否开启
function DataManager:isDressFuncOpen()
    return self:isFunctionOpen(1)
end

-- 打造功能是否开启
function DataManager:isMakeFuncOpen()
    return self:isFunctionOpen(4)
end

-- 公会功能是否开启
function DataManager:isGuildFuncOpen()
    return self:isFunctionOpen(2)
end

-- 排行榜是否开启
function DataManager:isRankFuncOpen()
    return self:isFunctionOpen(1002)
end

-- 商会是否开启
function DataManager:isStallFuncOpen()
    return self:isFunctionOpen(1001)
end

-- 活动是否开启
function DataManager:isActivityFuncOpen()
    return self:isFunctionOpen(1003)
end

-- 部位强化是否开启
function DataManager:isSiteFuncOpen()
    return self:isFunctionOpen(1004)
end

---- ################################################## searchHistory ##################################################
function DataManager:getHistoryTable()
    if not self._historyTable then
        self._historyTable = {}
    end
    return self._historyTable
end

function DataManager:getSearchHistory(searchType)
    local historyTable = self:getHistoryTable()
    return historyTable[searchType]
end

function DataManager:resetHistory(searchType)
    if searchType then
        local historyTable = self:getHistoryTable()
        historyTable[searchType] = nil
        return
    end
    self._historyTable = {}
end

---- ################################################## playerAlchemy ##################################################
function DataManager:getPlayerAlchemy()
    return self._playerAlchemy
end

function DataManager:onGetAlchemyResponse(event)
    local s2cGetAlchemy = event.data
    lt.CommonUtil.printf("s2cGetAlchemyResponse code 0")
    self._playerAlchemy = lt.PlayerAlchemy.new(s2cGetAlchemy.alchemy)
end

---- ################################################## 服务器等级 ##################################################
function DataManager:getServerLevel()
    return self._serverLevel or 0 
end

function DataManager:getLeftDayCount()
    return self._leftDayCount or 0 
end

function DataManager:getOpenDayCount()
    return self._openDayCount or 0 
end

function DataManager:getIsStopLevel()
    return self._isStopLevel or 0 
end

function DataManager:onGetServerLevelResponse(event)
    local s2cOnGetServerLevelResponse = event.data

    lt.CommonUtil.print("s2cOnGetServerLevelResponse code ===="..s2cOnGetServerLevelResponse.code)

    if s2cOnGetServerLevelResponse:HasField('server_level') then
        self._serverLevel = s2cOnGetServerLevelResponse.server_level
    end

    if s2cOnGetServerLevelResponse:HasField('left_day_count') then
        self._leftDayCount = s2cOnGetServerLevelResponse.left_day_count
    end

    if s2cOnGetServerLevelResponse:HasField('server_day_count') then
        self._openDayCount = s2cOnGetServerLevelResponse.server_day_count
    end

    if s2cOnGetServerLevelResponse:HasField('is_stop_level') then
        self._isStopLevel = s2cOnGetServerLevelResponse.is_stop_level
    end
end

---- ################################################## 双倍离线经验 ##################################################
function DataManager:getOfflineDoubleExp()
    return self._offlineDoubleExp
end

function DataManager:onNotifyOfflineDoubleExpResponse(event)

    -- local s2cDoubleExp = event.data

    -- local doubleExp = self:getOfflineDoubleExp()

    -- doubleExp = s2cDoubleExp.double_exp

    -- local logoutTime = s2cDoubleExp.logout_total_time

    -- local totalMin = math.ceil(logoutTime / 60)


    -- if doubleExp > 0 then

    --     local systemChatMessage = {}
    --     systemChatMessage.sender_id = 1
    --     systemChatMessage.receiver_id = self:getPlayerId()

    --     systemChatMessage.message = string.format(lt.StringManager:getString("STRING_FRIEND_OFF_LINE_TIME"), totalMin, doubleExp)
    --     systemChatMessage.send_time = lt.CommonUtil:getCurrentTime()
    --     systemChatMessage.id = 1
    --     systemChatMessage.sub_type = 0
    --     systemChatMessage.sub_param = 0
    --     systemChatMessage.sub_content = 0

    --     local info = lt.ChatMessage.new()
    --     info:initWithRow(systemChatMessage)

    --     lt.ChatManager:insertChatInfo(info)

    --     self:setSystemChat(true)
    -- end
end

---- ################################################## 武器特效 ##################################################
function DataManager:getWeaponTable()
    if not self._weaponTable then
        self._weaponTable = {}
        self._equippedWeaponTable = {}
    end
    return self._weaponTable,self._equippedWeaponTable
end

function DataManager:getWeapon(weaponId)
    local weaponTable,equippedWeaponTable = self:getWeaponTable()
    return weaponTable[weaponId]
end

function DataManager:getEquippedWeapon(modelId)
    local weaponTable,equippedWeaponTable = self:getWeaponTable()
    return equippedWeaponTable[modelId]
end

function DataManager:onGetWeaponListResponse(event)
    local s2cGetWeaponList = event.data
    lt.CommonUtil.print("s2cGetWeaponList code ===="..s2cGetWeaponList.code)

    local weaponTable,equippedWeaponTable = self:getWeaponTable()
    for _,row in ipairs(s2cGetWeaponList.weapon_array) do
        local weapon = lt.PlayerWeapon.new(row)
        weaponTable[weapon:getWeaponId()] = weapon
        if weapon:getIsEquipped() == 1 then
            local modelIdArray = weapon:getModelIdArray()
            for _,modelId in pairs(modelIdArray) do
                equippedWeaponTable[modelId] = weapon
            end
        end
    end
end

function DataManager:onUpdateWeaponListResponse(event)
    local s2cUpdateWeaponList = event.data
    lt.CommonUtil.print("s2cUpdateWeaponList code ===="..s2cUpdateWeaponList.code)

    local weaponTable,equippedWeaponTable = self:getWeaponTable()
    for _,row in ipairs(s2cUpdateWeaponList.add_weapon_array) do
        local weapon = lt.PlayerWeapon.new(row)
        weaponTable[weapon:getWeaponId()] = weapon
        if weapon:getIsEquipped() == 1 then
            local modelIdArray = weapon:getModelIdArray()
            for _,modelId in pairs(modelIdArray) do
                equippedWeaponTable[modelId] = weapon
            end
        end
    end

    for _,row in ipairs(s2cUpdateWeaponList.set_weapon_array) do
        local weapon = lt.PlayerWeapon.new(row)
        weaponTable[weapon:getWeaponId()] = weapon
        if weapon:getIsEquipped() == 1 then
            local modelIdArray = weapon:getModelIdArray()
            for _,modelId in pairs(modelIdArray) do
                equippedWeaponTable[modelId] = weapon
            end
        else
            local modelIdArray = weapon:getModelIdArray()
            for _,modelId in pairs(modelIdArray) do
                equippedWeaponTable[modelId] = nil
            end
        end
    end
end

---- ################################################## 头像气泡 ##################################################
function DataManager:getFigureTable()
    if not self._figureTable then
        self._figureTable = {}
    end
    return self._figureTable
end

function DataManager:getFigure(figureId)
    local figureTable = self:getFigureTable()
    return figureTable[figureId]
end

function DataManager:onGetFigureListResponse(event)
    local scGetFigureList = event.data
    lt.CommonUtil.print("scGetFigureList code ===="..scGetFigureList.code)

    local figureTable = self:getFigureTable()
    for _,row in ipairs(scGetFigureList.figure_array) do
        local figure = lt.PlayerFigure.new(row)
        figureTable[figure:getFigureId()] = figure
    end
end

function DataManager:onUpdateFigureListResponse(event)
    local scUpdateFigureList = event.data
    lt.CommonUtil.print("scUpdateFigureList code ===="..scUpdateFigureList.code)

    local figureTable = self:getFigureTable()
    for _,row in ipairs(scUpdateFigureList.add_figure_array) do
        local figure = lt.PlayerFigure.new(row)
        figureTable[figure:getFigureId()] = figure
    end

    for _,row in ipairs(scUpdateFigureList.set_figure_array) do
        local figure = lt.PlayerFigure.new(row)
        figureTable[figure:getFigureId()] = figure
    end
end

---- ################################################## 颜值 ##################################################
function DataManager:getDressAddition()
    return self._dressAddition
end

function DataManager:onGetDressAdditionResponse(event)
    local scGetDressAddition = event.data
    lt.CommonUtil.print("scGetDressAddition code==== 0")

    self._dressAddition = lt.PlayerDressAddition.new(scGetDressAddition.dress_addition)
end

---- ################################################## 好友里面的系统消息 ##################################################
function DataManager:onGetSystemEventResponse(event)
    local scGetSystemEventResponse = event.data
    lt.CommonUtil.print("scGetSystemEventResponse")

    local systemInfo = lt.SystemEvent.new(scGetSystemEventResponse.system_event)

    local eventType = systemInfo:getEvevtType()
    local eventParam = systemInfo:getEvevtParam()
    local eventTime = systemInfo:getEventTime()

    if eventType then
        self:setSystemNewMessage(eventType, eventParam, eventTime)
    end
end

function DataManager:onGetSystemEventListResponse(event)
    local scGetSystemEventResponse = event.data
    lt.CommonUtil.print("scGetSystemEventResponse")

    local updateTime = lt.CommonUtil:getCurrentTime()
    lt.ChatManager:insertChatUpdateTime(1,updateTime)

    local eventArray = scGetSystemEventResponse.event_array


    for _,info in pairs(eventArray) do

        local systemInfo = lt.SystemEvent.new(info)


        local eventType = systemInfo:getEvevtType()
        local eventParam = systemInfo:getEvevtParam()
        local eventTime = systemInfo:getEventTime()

        if eventType then
            self:setSystemNewMessage(eventType, eventParam, eventTime)
        end
    end
end

function DataManager:setSystemNewMessage(eventType, eventParam, eventTime)
    local systemChatMessage = {}
    systemChatMessage.sender_id = 1
    systemChatMessage.receiver_id = self:getPlayerId()
    systemChatMessage.send_time = eventTime
    systemChatMessage.id = 1
    systemChatMessage.sub_type = 0
    systemChatMessage.sub_param = 0
    systemChatMessage.sub_content = 0
    systemChatMessage.is_audio = 0
    systemChatMessage.local_audio_id = 0

    if eventType == lt.Constants.SYSTEM_FRIEND_TYPE.RISK_TEAM_ADD then

        local teamName = eventParam.team_prefix..lt.StringManager:getString(lt.StringManager:getCHSNumberString(eventParam.team_count))..eventParam.team_name
        local playerName = eventParam.player_name

        if playerName == self:getPlayer():getName() then
            return
        end

        systemChatMessage.message = string.format(lt.StringManager:getString("STRING_FRIEND_SYSTEM_ADD"), playerName, teamName)

    elseif eventType == lt.Constants.SYSTEM_FRIEND_TYPE.RISK_TEAM_DEL then

        --local teamName = eventParam.team_prefix..lt.StringManager:getCHSNumberString(eventParam.team_count)..eventParam.team_name
        local playerName = eventParam.player_name

        if playerName == self:getPlayer():getName() then
            return
        end

        systemChatMessage.message = string.format(lt.StringManager:getString("STRING_FRIEND_SYSTEM_DEL"), playerName)

    elseif eventType == lt.Constants.SYSTEM_FRIEND_TYPE.OFFLINE_EXP then
        
        local totalMin = math.ceil(eventParam.logout_total_time / 60)
        local doubleExp = eventParam.gain_double_exp

        if doubleExp <= 0 then
            return
        end

        systemChatMessage.message = string.format(lt.StringManager:getString("STRING_FRIEND_OFF_LINE_TIME"), totalMin, doubleExp)

    elseif eventType == lt.Constants.SYSTEM_FRIEND_TYPE.TRADING then

        local itemType = eventParam.item_type
        local itemModelId = eventParam.item_model_id
        local itemName = ""
        local itemInfo = nil

        if itemType == lt.GameIcon.TYPE.ITEM then
            itemInfo = lt.CacheManager:getItemInfo(itemModelId)
        elseif itemType == lt.GameIcon.TYPE.EQUIPMENT then
            itemInfo = lt.CacheManager:getEquipmentInfo(itemModelId)
        end

        if itemInfo then
            itemName = itemInfo:getName()
        end

        systemChatMessage.message = string.format(lt.StringManager:getString("STRING_FRIEND_SYSTEM_TRADING"), itemName)

    elseif eventType == lt.Constants.SYSTEM_FRIEND_TYPE.RISK_TEAM_EXIT then
        
        local teamName = eventParam.team_prefix..lt.StringManager:getString(lt.StringManager:getCHSNumberString(eventParam.team_count))..eventParam.team_name

        systemChatMessage.message = string.format(lt.StringManager:getString("STRING_FRIEND_SYSTEM_EXIT"), teamName)
    elseif eventType == lt.Constants.SYSTEM_FRIEND_TYPE.GET_GIFT then

        local sendName = eventParam.send_player_name
        local itemId = eventParam.item_id
        local itemInfo = lt.CacheManager:getItemInfo(itemId)
        local itemName = itemInfo:getName()
        local itemCount = eventParam.item_count

        systemChatMessage.message = string.format(lt.StringManager:getString("STRING_FRIEND_SYSTEM_GET_GIFT"), sendName, itemCount, itemName)
    elseif eventType == lt.Constants.SYSTEM_FRIEND_TYPE.RISK_TEAM_CHANGE_NAME then
        local teamName = eventParam.team_prefix..lt.StringManager:getString(lt.StringManager:getCHSNumberString(eventParam.team_count))..eventParam.team_name

        systemChatMessage.message = string.format(lt.StringManager:getString("STRING_FRIEND_SYSTEM_NAME_CHANGE"), teamName)
    elseif eventType == lt.Constants.SYSTEM_FRIEND_TYPE.FRIEND_NAME_EXCHANGE then
        local oldName = eventParam.old_name
        local newName = eventParam.new_name

        systemChatMessage.message = string.format(lt.StringManager:getString("STRING_FRIEND_NAME_CHANGE"), oldName, newName)

    else
        lt.CommonUtil.print("lack of type"..eventType)
        return
    end

    local info = lt.ChatMessage.new()
    info:initWithRow(systemChatMessage)

    lt.ChatManager:insertChatInfo(info)

    self:setSystemChat(true)
end

---- ################################################## 获得经验 ##################################################
function DataManager:onGetExpResponse(event)
    local scGetExp = event.data
    lt.CommonUtil.print("scGetExp OK")

    -- do return end

    -- lt.CommonUtil.print("scGetExp content\n"..tostring(scGetExp))

    if scGetExp:HasField('double_exp_pool') then
        local doubleExpPool = scGetExp.double_exp_pool

        self._player:setDoubleExpPool(doubleExpPool)
    end

    if scGetExp:HasField('exp') then
        local exp = scGetExp.exp

        self._player:setExp(exp)

        -- 玩家经验更新
        lt.GameEventManager:post(lt.GameEventManager.EVENT.PLAYER_UPDATE_EXP)
    end

    local chatInfo = lt.Chat.new()
    chatInfo:setChannel(lt.Constants.CHAT_TYPE.SYSTEM)
    chatInfo:setSenderName("system")
    chatInfo:setSendTime(lt.CommonUtil:getCurrentTime())
    chatInfo:setMessage("")
    local subContent = {}
    subContent["all_exp_increase"] = scGetExp.all_exp_increase
    subContent["double_increase"]  = scGetExp.double_increase
    subContent["rise_increase"]    = scGetExp.rise_increase
    chatInfo:setSubContent(json.encode(subContent))
    chatInfo:setSubType(lt.Constants.CHAT_SUB_TYPE.GET_EXP)
    self:addSystemChatInfo(chatInfo)
    lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_SYSTEM, {chatInfo=chatInfo})
end

---- ################################################## 新进入地图 ##################################################
function DataManager:onGetEnteredMap(event)
    local scGetEnteredMap = event.data
    local code = scGetEnteredMap.code
    lt.CommonUtil.print("scGetEnteredMap code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("scGetEnteredMap content\n"..tostring(scGetEnteredMap))

    local enteredMapTable = self:getEnteredMapTable(true)
    local enteredMapIdArray = scGetEnteredMap.entered_map_array
    for _,mapId in ipairs(enteredMapIdArray) do
        enteredMapTable[mapId] = true
    end
end

function DataManager:getEnteredMapTable(clear)
    if not self._enteredMapTable then
        self._enteredMapTable = {}
    end

    if clear then
        self._enteredMapTable = {}
    end

    return self._enteredMapTable
end

function DataManager:isMapEntered(mapId)
    local worldMap = lt.CacheManager:getWorldMap(mapId)
    local playerLevel = self:getPlayerLevel()
    if playerLevel >= worldMap:getLevelRequire() then
        return true
    end

    local enteredMapTable = self:getEnteredMapTable()
    return enteredMapTable[mapId]
end

---- ################################################## 持续性Buff ##################################################
function DataManager:onGetBuff(event)
    local s2cGetBuff = event.data
    local code = s2cGetBuff.code
    lt.CommonUtil.print("s2cGetBuff code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cGetBuff content\n"..tostring(s2cGetBuff))

    local plyBuffArray = s2cGetBuff.buff_array
    self._itemBuffArray = {}
    for _,scPlyBuff in ipairs(plyBuffArray) do
        local playerItemBuff = lt.PlayerItemBuff.new(scPlyBuff)
        table.insert(self._itemBuffArray, playerItemBuff)
    end

    -- 刷新人物Buff信息
    lt.GameEventManager:post(lt.GameEventManager.EVENT.ITEM_BUFF_UPDATE)
end

function DataManager:getItemBuffArray()
    if not self._itemBuffArray then
        self._itemBuffArray = {}
    end

    return self._itemBuffArray
end

---- ################################################## 技能等级Table ##################################################
function DataManager:getRuneSkillArray()

    local runeSkillArray = {}
    local runeSkillTable = {}

    local runeListTable = self:getRuneListTableByPage(self:getPlayer():getCurrentRunePage())
    local talentListTable = self:getTalentListTableByPage(self:getCurrentTalentPage())

    for _,runeInfo in pairs(runeListTable) do
        local modelId = runeInfo:getModelId()
        if modelId > 0 then
            local runeInfo = lt.CacheManager:getRuneInfo(modelId)
            local rtype = runeInfo:getType()
            if rtype == 1 then
                local skillId = runeInfo:getSkillId()
                local runeSkillInfo = lt.CacheManager:getRuneTalentInfo(skillId)
                if runeSkillInfo then
                    local skillIndex = runeSkillInfo:getIndex()
                    local level      = runeSkillInfo:getLevel()

                    runeSkillTable[skillIndex] = level
                end
            end
        end
    end

    for _,talentInfo in pairs(talentListTable) do
        local talentId = talentInfo:getTalentId()
        local level    = talentInfo:getLevel()

        if level > 0 then
            local heroTalentInfo = lt.CacheManager:getHeroTalentInfo(talentId)
            local skillType = heroTalentInfo:getSkillType()
            if skillType == 2 then
                -- 对应符文技能
                local skillIndex = heroTalentInfo:getSkillIndex()
                if isset(runeSkillTable, skillIndex) then
                    runeSkillTable[skillIndex] = runeSkillTable[skillIndex] + level
                else
                    runeSkillTable[skillIndex] = level
                end
            end
        end
    end

    for skillIndex,level in pairs(runeSkillTable) do
        local sequence = skillIndex * 100
        local equipTalentInfo = self:getPlayerEquipmentTalentById(sequence)
        local equipTalentLevel = 0
        if equipTalentInfo then
            equipTalentLevel = equipTalentInfo.value
        end

        if equipTalentLevel > 0 then
            level = level + equipTalentLevel

            runeSkillTable[skillIndex] = level
        end
    end

    for skillIndex,level in pairs(runeSkillTable) do
        local fSequence = skillIndex * 100
        local runeSkillInfo = lt.CacheManager:getRuneTalentInfo(fSequence)
        local maxLevel = 1
        if runeSkillInfo then
            maxLevel = runeSkillInfo:getRealMaxLevel()
        end
        level = math.min(level, maxLevel)
        local rSkillId = fSequence + level - 1

        runeSkillArray[#runeSkillArray + 1] = rSkillId
    end

    return runeSkillArray
end


---- ################################################## 获取当前天赋对应等级 ##################################################
function DataManager:getTalentSkillLevel(index)

    local equipLevel = 0
    local talentLevel = 0
    local runeLevel = 0

    local runeSkillArray = {}
    local runeSkillTable = {}

    local runeListTable = self:getRuneListTableByPage(self:getPlayer():getCurrentRunePage())
    local talentListTable = self:getTalentListTableByPage(self:getCurrentTalentPage())

    for _,runeInfo in pairs(runeListTable) do
        local modelId = runeInfo:getModelId()
        if modelId > 0 then
            local runeInfo = lt.CacheManager:getRuneInfo(modelId)
            local rtype = runeInfo:getType()
            if rtype == 1 then
                local skillId = runeInfo:getSkillId()
                local runeSkillInfo = lt.CacheManager:getRuneTalentInfo(skillId)
                if runeSkillInfo then
                    local skillIndex = runeSkillInfo:getIndex()
                    local level      = runeSkillInfo:getLevel()
                    runeSkillTable[skillIndex] = level
                    if skillIndex == index then
                        runeLevel = level
                    end
                end
            end
        end
    end

    for _,talentInfo in pairs(talentListTable) do
        local talentId = talentInfo:getTalentId()
        local level    = talentInfo:getLevel()

        if level > 0 then
            local heroTalentInfo = lt.CacheManager:getHeroTalentInfo(talentId)
            local skillType = heroTalentInfo:getSkillType()
            if skillType == 2 then
                -- 对应符文技能
                local skillIndex = heroTalentInfo:getSkillIndex()
                if skillIndex == index then
                    talentLevel = level
                end
                if isset(runeSkillTable, skillIndex) then
                    runeSkillTable[skillIndex] = runeSkillTable[skillIndex] + level
                else
                    runeSkillTable[skillIndex] = level
                end
            end
        end
    end

    for skillIndex,level in pairs(runeSkillTable) do
        local sequence = skillIndex * 100
        local equipTalentInfo = self:getPlayerEquipmentTalentById(sequence)
        local equipTalentLevel = 0
        if equipTalentInfo then
            equipTalentLevel = equipTalentInfo.value
        end

        if equipTalentLevel > 0 then
            if skillIndex == index then
                equipLevel = equipTalentLevel
            end
            level = level + equipTalentLevel

            runeSkillTable[skillIndex] = level
        end
    end


    return equipLevel, runeLevel
end


function DataManager:getActivityArray()

    --排队按照定义的sort来排--已完成的活动》推荐活动》周常活动》限时活动》显示活动》等级未满足的活动》

    local array = {}

    local playerLevel = self:getPlayerLevel()
    local activityTable = lt.CacheManager:getActivityTable()

    local time = lt.CommonUtil:getCurrentTime()

    local tm = os.date("!*t", time)

    local wday = tm.wday

    local day = wday - 1 
    if day == 0 then
        day = 7
    end

    for id,activityInfo in pairs(activityTable) do
        local flag = activityInfo:getFlag()
        local currentTimes = 0
        local allExeclCount = activityInfo:getExecLimit()

        local levelMin = activityInfo:getOpenLevelMin()
        
        local finishedReward =  activityInfo:getFinishedReward()

        local finishFlag = 0

        local info = activityInfo

        local activityId = info:getId()

        if finishedReward == 1 then --完成任务有奖励可以领取
            if activityId == lt.Constants.ACTIVITY.ADVENTURE_TASK then --冒险任务
                local taskInfo = self:getActivityAdventureTask()
                if taskInfo then
                    finishFlag = taskInfo:getFinishedReceiveFlag() --//0 未领取   1 已领取
                end
            end

            if activityId == lt.Constants.ACTIVITY.ADVENTURE_TRIAL then --冒险试炼
                local taskInfo = self:getActivityAdventureTrail()
                if taskInfo then
                    finishFlag = taskInfo:getFinishedReceiveFlag()
                end
            end

            if activityId == lt.Constants.ACTIVITY.MONSTER_PURIFICATION then --魔物净化
                local taskInfo = self:getActivityMonsterPurification()
                if taskInfo then
                    finishFlag = taskInfo:getFinishedReceiveFlag()
                end
            end

            -- if info:getId() == lt.Constants.ACTIVITY.MONSTER_PURIFICATION then --深渊领主
            --     local taskInfo = self:getActivityPitlordTask()
            --     if taskInfo then
            --         finishFlag = taskInfo:getFinishedReceiveFlag()
            --     end
            -- end

            if activityId == lt.Constants.ACTIVITY.TREASURE then --魔王宝藏
                local taskInfo = self:getActivityTreasureTask()
                if taskInfo then
                    finishFlag = taskInfo:getFinishedReceiveFlag()

                end
            end

            if activityId == lt.Constants.ACTIVITY.GUARD then --守卫遗迹
                local taskInfo = self:getActivityGuard()
                if taskInfo then
                    finishFlag = taskInfo:getFinishedReceiveFlag()

                end
            end

            if activityId == lt.Constants.ACTIVITY.GUILD_FAM then --工会秘境
                local taskInfo = self:getActivityGuildFam()
                if taskInfo then
                    finishFlag = taskInfo:getFinishedReceiveFlag()

                end
            end

            if activityId == lt.Constants.ACTIVITY.GUILD_BUILD then --工会建设
                local taskInfo = self:getActivityGuildBuildTask()
                if taskInfo then
                    finishFlag = taskInfo:getFinishedReceiveFlag()
                end
            end

            if activityId == lt.Constants.ACTIVITY.WORLD_ANSWER then --世界答题
                local taskInfo = self:getActivityWorldAnswer()
                if taskInfo then
                    finishFlag = taskInfo:getFinishedReceiveFlag()
                end
            end

            if activityId == lt.Constants.ACTIVITY.WORLD_BOSS then --世界BOSS
                local taskInfo = self:getActivityWorldBoss()
                if taskInfo then
                    finishFlag = taskInfo:getFinishedReceiveFlag()
                end
            end

            if activityId == lt.Constants.ACTIVITY.CREAM_BOSS then --魔物入侵
                local taskInfo = self:getActivityCreamBoss()
                if taskInfo then
                    finishFlag = taskInfo:getFinishedReceiveFlag()
                end
            end

        else
            finishFlag = 0
        end


        if id == lt.Constants.ACTIVITY.ADVENTURE_TASK then
            local taskInfo = self:getActivityAdventureTask()
            if taskInfo then
                currentTimes = taskInfo:getAllCount()
            end
        elseif id == lt.Constants.ACTIVITY.ADVENTURE_TRIAL then
            local taskInfo = self:getActivityAdventureTrail()
            if taskInfo then
                currentTimes = taskInfo:getAllRound()
            end
        elseif id == lt.Constants.ACTIVITY.MONSTER_PURIFICATION then
            local taskInfo = self:getActivityMonsterPurification()
            if taskInfo then
                currentTimes = taskInfo:getAllCount()
            end

        elseif id == lt.Constants.ACTIVITY.PITLORD then--深渊领主
            local taskInfo = self:getActivityPitlordTask()
            if taskInfo then
                currentTimes = taskInfo:getAllCount()
            end
        elseif id == lt.Constants.ACTIVITY.TREASURE then --魔王宝藏
            local taskInfo =  self:getActivityTreasureTask()

            if taskInfo then
                currentTimes = taskInfo:getAllCount()
            end

        elseif id == lt.Constants.ACTIVITY.GUARD then --守卫遗迹
            local taskInfo =  self:getActivityGuard()

            if taskInfo then
                currentTimes = taskInfo:getAllCount()
            end

        elseif id == lt.Constants.ACTIVITY.GUILD_FAM then --工会秘境
            local taskInfo = self:getActivityGuildFam()

            if taskInfo then
                currentTimes = taskInfo:getAllCount()
            end
        elseif id == lt.Constants.ACTIVITY.GUILD_BUILD then --工会建设
            local taskInfo = self:getActivityGuildBuildTask()

            if taskInfo then
                currentTimes = taskInfo:getAllCount()
            end
        elseif id == lt.Constants.ACTIVITY.WORLD_ANSWER then --世界答题
            local taskInfo = self:getActivityWorldAnswer()

            if taskInfo then
                currentTimes = taskInfo:getCount()
            end
        elseif id == lt.Constants.ACTIVITY.WORLD_BOSS then --世界BOSS
            local taskInfo = self:getActivityWorldBoss()

            if taskInfo then
                currentTimes = taskInfo:getAllCount()
            end
        elseif id == lt.Constants.ACTIVITY.CREAM_BOSS then --魔物入侵
            local taskInfo = self:getActivityCreamBoss()
            if taskInfo then
                currentTimes = taskInfo:getAllCount()
            end
        end


        activityInfo.sort = 10
        activityInfo.compolete = 1
        if currentTimes >= allExeclCount and allExeclCount ~= 0 then --已经完成的活动

            if id == lt.Constants.ACTIVITY.WORLD_ANSWER then
                local playerActivity = lt.DataManager:getPlayerActivity(lt.Constants.ACTIVITY.WORLD_ANSWER)
                if playerActivity:getRewardTime() > playerActivity:getDailyOpenTime() then
                    activityInfo.compolete = 0
                end
            else
                if finishedReward == 1 then
                    if finishFlag == 1 then
                        activityInfo.compolete = 0
                    end
                else
                    activityInfo.compolete = 0
                end
            end
        end

        -- if id == lt.Constants.ACTIVITY.WORLD_BOSS then
        --     local worldBossInfo = lt.DataManager:onGetActivityWorldBossInfo()

        --     local killedCount = 0
        --     if worldBossInfo then
        --         killedCount = worldBossInfo:getCurKilledCount()
        --     end

        --     if killedCount > 0 then
        --         activityInfo.compolete = 0
        --     end
        -- end

        -- if id == lt.Constants.ACTIVITY.GUILD_BOSS then
        --     local guildBossList = lt.DataManager:getActivityGuildBossList()

        --     local killTime = 0
        --     for _,guildBossInfo in ipairs(guildBossList) do
        --         local killed = guildBossInfo.killed

        --         if killed == 1 then
        --             killTime = killTime + 1
        --         end
        --     end

        --     if killTime >= 3 then
        --         activityInfo.compolete = 0
        --     end
        -- end


        if activityInfo:getTag() == 4 then --显示活动
            activityInfo.sort = 4
        end

        if activityInfo:getTag() == 2 then --限时活动
            activityInfo.sort = 5
        end

        if activityInfo:getTag() == 3 then --周常活动
            activityInfo.sort = 6
        end

        if flag == 1 then
            activityInfo.sort = 7
        end

        local tag = activityInfo:getTag()

        if tag ~= 5 and tag ~= 6 and tag ~= 7 then
            if tag == 2 then
                local weekDay = activityInfo:getOpenWeekDay()
                for j = 1, #weekDay do

                    local today = weekDay[j]
                    if day == today then
                        array[#array + 1] = activityInfo
                    end

                end
            else
                array[#array + 1] = activityInfo
            end
        end

        activityInfo.openTag = 0

        local levelMin = activityInfo:getOpenLevelMin()

        if self:getPlayerLevel() >= levelMin then
            activityInfo.openTag = 1
        end

    end

    table.sort(array,function(activity1,activity2)
        if activity1.compolete > activity2.compolete then
            return true
        elseif activity1.compolete == activity2.compolete then
            if activity1.openTag > activity2.openTag then
                return true
            elseif activity1.openTag == activity2.openTag then
                if activity1:getSequence() < activity2:getSequence() then
                    return true
                end
            end
        end
    end)

    return array
end

--获取每日签到table
function DataManager:getDailySingTable()

    local dailySignTable = lt.CacheManager:getDailySignTable()


    local dailySignRound = self:getPlayer():getDailySignInRound()


    local currentWeekDay = lt.CommonUtil:getCurrentWeekDay()


    local padding = (720 - 74 * 7) / 8


    local currentDailyRound = {}

    local beforeIdx = (dailySignRound - 1 ) * 7 + 1

    local idx = (dailySignRound - 1 ) * 7 + 1

    for id,info in pairs(dailySignTable) do
        
        if dailySignTable[idx] then
            currentDailyRound[idx] = dailySignTable[idx]
        end


        idx = idx + 1

        

        if idx - beforeIdx > 6 then
            break
        end
    end


    return currentDailyRound
end

function DataManager:setShopSelectTable(table)
    self._shopSelectTable = table
end

function DataManager:getShopSelectTable()
    if not self._shopSelectTable then
        self._shopSelectTable = {}
    end

    return self._shopSelectTable
end


function DataManager:setShopClubTable(table)
    self._shopClubTable = table
end

function DataManager:getShopClubTable()
    if not self._shopClubTable then
        self._shopClubTable = {}
    end

    return self._shopClubTable
end

--商会选择购买or出售
function DataManager:setShopClubSelectIdx(idx)
    self._shopClubSelectIdx = idx
end

function DataManager:getShopClubSelectIdx()
    if not self._shopClubSelectIdx then
        self._shopClubSelectIdx = 1
    end

    return self._shopClubSelectIdx
end

--商会选择出售物品id
function DataManager:setShopClubSaleId(id)
    self._shopClubSaleId = id
end

function DataManager:getShopClubSaleId()
    if not self._shopClubSaleId then
        self._shopClubSaleId = nil
    end

    return self._shopClubSaleId
end

--商城选择钻石or Z币
function DataManager:setShopItemSelectIdx(idx)
    self._shopItemSelectIdx = idx
end

function DataManager:getShopItemSelectIdx()
    if not self._shopItemSelectIdx then
        self._shopItemSelectIdx = 1
    end

    return self._shopItemSelectIdx
end

--钻石商城选择id
function DataManager:setShopItemId(id)
    self._shopItemId = id
end

function DataManager:getShopItemId()
    if not self._shopItemId then
        self._shopItemId = nil
    end

    return self._shopItemId
end

--zbi商城选择id
function DataManager:setZbiItemId(id)
    self._zbiItemId = id
end

function DataManager:getZbiItemId()
    if not self._zbiItemId then
        self._zbiItemId = nil
    end

    return self._zbiItemId
end

function DataManager:clearShopItemSelect()
    self:setShopClubSelectIdx()
    self:setShopClubSaleId()
    self:setShopItemSelectIdx()
    self:setShopItemId()
    self:setZbiItemId()
end

-- ################################################## 武道场 3V3 ##################################################
function DataManager:getActivityFlushTimeTable()
    if not self._activityFlushTimeTable then
        self._activityFlushTimeTable = {}
    end

    return self._activityFlushTimeTable
end

function DataManager:getDaily3V3FlushTime()
    local activityFlushTimeTable = self:getActivityFlushTimeTable()
    return activityFlushTimeTable[lt.Constants.ACTIVITY.PK_3V3]
end


function DataManager:onGetFlushTime(event)
    local s2cGetFlushTime = event.data
    lt.CommonUtil.print("s2cGetFlushTime OK")
    -- lt.CommonUtil.print("s2cGetFlushTime content\n"..tostring(s2cGetFlushTime))

    local activityFlushTimeTable = self:getActivityFlushTimeTable()
    local scActivityFlushTimeArray = s2cGetFlushTime.activity_flush_time_array
    for _,scActivityFlushTime in ipairs(scActivityFlushTimeArray) do
        local activityFlushTime = lt.ActivityFlushTime.new(scActivityFlushTime)
        activityFlushTimeTable[activityFlushTime:getActivityId()] = activityFlushTime
    end
end

function DataManager:getDaily3V3RewardReceiveArray()
    if not self._daily3V3RewardReceiveArray then
        self._daily3V3RewardReceiveArray = {}
    end

    return self._daily3V3RewardReceiveArray
end

function DataManager:onNotifyDaily3V3RewardReceiveInfo(event)
    local s2cNotifyDaily3V3RewardReceiveInfo = event.data
    local code = s2cNotifyDaily3V3RewardReceiveInfo.code
    lt.CommonUtil.print("s2cNotifyDaily3V3RewardReceiveInfo code "..code)

    if code ~= lt.SocketConstants.CODE_OK then
        return
    end

    -- lt.CommonUtil.print("s2cNotifyDaily3V3RewardReceiveInfo content\n"..tostring(s2cNotifyDaily3V3RewardReceiveInfo))

    self._daily3V3RewardReceiveArray = {}
    local scDaily3V3RewardReceiceArray = s2cNotifyDaily3V3RewardReceiveInfo.daily_3v3_reward_receive_array
    for _,scDaily3V3RewardReceice in ipairs(scDaily3V3RewardReceiceArray) do
        table.insert(self._daily3V3RewardReceiveArray, {count = scDaily3V3RewardReceice.id, status = scDaily3V3RewardReceice.value})
    end
end

-- ################################################## 特殊事件 ##################################################
    --次日礼包
function DataManager:getMorrowRewardTable()
    if not self._morrowRewardTable then
        self._morrowRewardTable = {}
    end

    return self._morrowRewardTable
end

function DataManager:onGetMorrowReward(event)
    local s2cMorrowReward = event.data
    lt.CommonUtil.print("s2cGetMorrowReward OK")

    local morrowRewardTable = self:getMorrowRewardTable()
    if s2cMorrowReward.morrow_reward then
        morrowRewardTable["is_open"] = s2cMorrowReward.morrow_reward.is_open--是否开启 0：未开启 1:已开启
        morrowRewardTable["receive_time"] = s2cMorrowReward.morrow_reward.receive_time--可领取时间戳
        morrowRewardTable["receive_state"] = s2cMorrowReward.morrow_reward.receive_state--领取状态 0：未领取 1:已领取
        morrowRewardTable["fondle_count"] = s2cMorrowReward.morrow_reward.fondle_count--抚摸次数
        morrowRewardTable["next_fondle_time"] = s2cMorrowReward.morrow_reward.next_fondle_time--抚摸time

        -- local logStr = "s2cGetMorrowReward content\n"
        -- for k,v in pairs(morrowRewardTable) do
        --     logStr = logStr .. k..": "..v.."\n"
        -- end
        -- lt.CommonUtil.print(logStr)
    end
    lt.GameEventManager:post(lt.GameEventManager.EVENT.MORROW_REWARD_UPDATE)
end

-- ################################################## 喊话历史 ##################################################
function DataManager:setTeamAdvertisementTime(teamAdvertisementTime)
    self._teamAdvertisementTime = teamAdvertisementTime
end

function DataManager:getTeamAdvertisementTime()
    return self._teamAdvertisementTime or 0
end

function DataManager:getTeamAdvertisementHistroy()
    return self._teamAdvertisementHistroy or {}
end

function DataManager:setTeamAdvertisementHistroy(teamAdvertisementHistroy)
    self._teamAdvertisementHistroy = teamAdvertisementHistroy
end

--判断道具在不在背包
function DataManager:checkItemInBag(id)

    local flag = false

    local equimentTable = self:getEquipmentTable()
    local itemTable = self:getItemTable()

    for k,v in pairs(equimentTable) do
        if k == id then
            flag = true
            break
        end
    end

    for k,v in pairs(itemTable) do
        if k == id then
            flag = true
            break
        end
    end

    return flag
end

-- ################################################## 大战场 ##################################################
function DataManager:getExchangeSeasonCountTable()
    if not self._exchangeSeasonCountTable then
        self._exchangeSeasonCountTable = {}
    end

    return self._exchangeSeasonCountTable
end

function DataManager:onGetExchangeSeasonCountInfoResponse(event)
    local s2cOnGetExchangeSeasonCountInfoResponse = event.data

    local code = s2cOnGetExchangeSeasonCountInfoResponse.code

    lt.CommonUtil.print("s2cOnGetExchangeSeasonCountInfoResponse code "..code)

    local exchangeSeasonCountTable = self:getExchangeSeasonCountTable()

    local count1 = s2cOnGetExchangeSeasonCountInfoResponse.item_700
    local count2 = s2cOnGetExchangeSeasonCountInfoResponse.item_701
    local count3 = s2cOnGetExchangeSeasonCountInfoResponse.item_702
    local count4 = s2cOnGetExchangeSeasonCountInfoResponse.item_703
    local count5 = s2cOnGetExchangeSeasonCountInfoResponse.item_704

    exchangeSeasonCountTable[700] = count1
    exchangeSeasonCountTable[701] = count2
    exchangeSeasonCountTable[702] = count3
    exchangeSeasonCountTable[703] = count4
    exchangeSeasonCountTable[704] = count5


end

-- ################################################## 领取红包 ##################################################
function DataManager:getReceiveRedPacketLog()
    if not self._receiveRedPackLog then
        self._receiveRedPackLog = {}
    end

    return self._receiveRedPackLog
end

function DataManager:onReceiveRedPacketLog(event)
    local s2cOnReceiveRedPacketLog = event.data
    lt.CommonUtil.print("s2cOnReceiveRedPacketLog OK")

    local receiveRedPackLog = self:getReceiveRedPacketLog()
    local idArray = s2cOnReceiveRedPacketLog.packet_id_array

    for _,id in ipairs(idArray) do
        receiveRedPackLog[id] = id
    end

end

-- ################################################## 世界boss信息 ##################################################
function DataManager:onGetActivityWorldBossInfo()

    return self._activityWorldBossInfo or nil
end

function DataManager:onGetActivityUltimateChallenge(event)
    local s2cOnGetActivityUltimateChallenge = event.data
    lt.CommonUtil.print("s2cOnGetActivityUltimateChallenge OK")

    
    local boosFlush = s2cOnGetActivityUltimateChallenge.boss_flush or {}

    local activityMonsterPurification = lt.ActivityWorldBossInfo.new(boosFlush)

    self._activityWorldBossInfo = activityMonsterPurification


end


-- ################################################## 宝石达人 ##################################################
function DataManager:getStoneRewardLogListTable()
    if not self._stoneRewardListTable then
        self._stoneRewardListTable = {}
    end

    return self._stoneRewardListTable
end

function DataManager:getStoneRewardIsFinished()
    return self._stoneRewardFlag
end

function DataManager:onGetStoneRewardLogListResponse(event)
    local s2cOnGetStoneRewardLogListResponse = event.data
    lt.CommonUtil.print("s2cOnGetStoneRewardLogListResponse OK")

    local stoneRewardListTable = self:getStoneRewardLogListTable()
    local rewardList = s2cOnGetStoneRewardLogListResponse.reward_list

    for _,s2cStoneRewardInfo in ipairs(rewardList) do
        local stoneRewardInfo = lt.PlayerRewardLog.new(s2cStoneRewardInfo)
        local rewardId = stoneRewardInfo:getRewardId()

        stoneRewardListTable[rewardId] = stoneRewardInfo
    end

    self._stoneRewardFlag = s2cOnGetStoneRewardLogListResponse.is_finished
end

function DataManager:onUpdateStoneRewardLogListResponse(event)
    local s2cOnUpdateStoneRewardLogListResponse = event.data
    lt.CommonUtil.print("s2cOnUpdateStoneRewardLogListResponse OK")

    local stoneRewardListTable = self:getStoneRewardLogListTable()

    local addArray = s2cOnUpdateStoneRewardLogListResponse.add_reward_list

    for _,s2cStoneRewardInfo in ipairs(addArray) do
        local stoneRewardInfo = lt.PlayerRewardLog.new(s2cStoneRewardInfo)
        local rewardId = stoneRewardInfo:getRewardId()

        stoneRewardListTable[rewardId] = stoneRewardInfo
    end

    local setArray = s2cOnUpdateStoneRewardLogListResponse.set_reward_list

    for _,s2cStoneRewardInfo in ipairs(setArray) do
        local stoneRewardInfo = lt.PlayerRewardLog.new(s2cStoneRewardInfo)
        local rewardId = stoneRewardInfo:getRewardId()

        stoneRewardListTable[rewardId] = stoneRewardInfo
    end
end

function DataManager:getStoneReceiveTimesInfo()
    if not self._stoneReceiveTimesInfo then
        self._stoneReceiveTimesInfo = {}
    end

    return self._stoneReceiveTimesInfo
end

function DataManager:onGetStoneRewardReceiveTimesResponse(event)
    local s2cOnGetStoneRewardReceiveTimesResponse = event.data
    lt.CommonUtil.print("s2cOnGetStoneRewardReceiveTimesResponse  ")

    local stoneReceiveTimesTable = self:getStoneReceiveTimesInfo()

    local rewardReceiveTimes = s2cOnGetStoneRewardReceiveTimesResponse.reward_receive_times

    self._stoneReceiveTimesInfo = lt.RewardReceiveTimes.new(rewardReceiveTimes)

end

-- ################################################## 英灵达人 ##################################################
function DataManager:getServantRewardLogListTable()
    if not self._servantRewardListTable then
        self._servantRewardListTable = {}
    end

    return self._servantRewardListTable
end

function DataManager:getServantRewardIsFinished()
    return self._servantRewardFlag
end

function DataManager:onGetServantRewardLogListResponse(event)
    local s2cOnGetServantRewardLogListResponse = event.data
    lt.CommonUtil.print("s2cOnGetServantRewardLogListResponse OK")

    local servantRewardListTable = self:getServantRewardLogListTable()
    local rewardList = s2cOnGetServantRewardLogListResponse.reward_list

    for _,s2cServantRewardInfo in ipairs(rewardList) do
        local servantRewardInfo = lt.PlayerRewardLog.new(s2cServantRewardInfo)
        local rewardId = servantRewardInfo:getRewardId()

        servantRewardListTable[rewardId] = servantRewardInfo
    end

    self._servantRewardFlag = s2cOnGetServantRewardLogListResponse.is_finished
end

function DataManager:onUpdateServantRewardLogListResponse(event)
    local s2cOnUpdateServantRewardLogListResponse = event.data
    lt.CommonUtil.print("s2cOnUpdateServantRewardLogListResponse OK")

    local servantRewardListTable = self:getServantRewardLogListTable()

    local addArray = s2cOnUpdateServantRewardLogListResponse.add_reward_list

    for _,s2cServantRewardInfo in ipairs(addArray) do
        local servantRewardInfo = lt.PlayerRewardLog.new(s2cServantRewardInfo)
        local rewardId = servantRewardInfo:getRewardId()

        servantRewardListTable[rewardId] = servantRewardInfo
    end

    local setArray = s2cOnUpdateServantRewardLogListResponse.set_reward_list

    for _,s2cServantRewardInfo in ipairs(setArray) do
        local servantRewardInfo = lt.PlayerRewardLog.new(s2cServantRewardInfo)
        local rewardId = servantRewardInfo:getRewardId()

        servantRewardListTable[rewardId] = servantRewardInfo
    end
end

function DataManager:getServantReceiveTimesInfo()
    if not self._servantReceiveTimesInfo then
        self._servantReceiveTimesInfo = {}
    end

    return self._servantReceiveTimesInfo
end

function DataManager:onGetServantRewardReceiveTimesResponse(event)
    local s2cOnGetServantRewardReceiveTimesResponse = event.data
    lt.CommonUtil.print("s2cOnGetServantRewardReceiveTimesResponse OK")

    local servantReceiveTimesTable = self:getServantReceiveTimesInfo()

    local rewardReceiveTimes = s2cOnGetServantRewardReceiveTimesResponse.reward_receive_times

    self._servantReceiveTimesInfo = lt.RewardReceiveTimes.new(rewardReceiveTimes)

end

-- ################################################## 生活达人 ##################################################
function DataManager:getLifeRewardLogListTable()
    if not self._lifeRewardListTable then
        self._lifeRewardListTable = {}
    end

    return self._lifeRewardListTable
end

function DataManager:getLifeRewardIsFinished()
    return self._lifeRewardFlag
end

function DataManager:onGetLifeRewardLogListResponse(event)
    local s2cOnGetLifeRewardLogListResponse = event.data
    lt.CommonUtil.print("s2cOnGetLifeRewardLogListResponse OK")

    local lifeRewardListTable = self:getLifeRewardLogListTable()
    local rewardList = s2cOnGetLifeRewardLogListResponse.reward_list

    for _,s2cLifeRewardInfo in ipairs(rewardList) do
        local lifeRewardInfo = lt.PlayerRewardLog.new(s2cLifeRewardInfo)
        local rewardId = lifeRewardInfo:getRewardId()

        lifeRewardListTable[rewardId] = lifeRewardInfo
    end

    self._lifeRewardFlag = s2cOnGetLifeRewardLogListResponse.is_finished
end

function DataManager:onUpdateLifeRewardLogListResponse(event)
    local s2cOnUpdateLifeRewardLogListResponse = event.data
    lt.CommonUtil.print("s2cOnUpdateLifeRewardLogListResponse OK")

    local lifeRewardListTable = self:getLifeRewardLogListTable()

    local addArray = s2cOnUpdateLifeRewardLogListResponse.add_reward_list

    for _,s2cLifeRewardInfo in ipairs(addArray) do
        local lifeRewardInfo = lt.PlayerRewardLog.new(s2cLifeRewardInfo)
        local rewardId = lifeRewardInfo:getRewardId()

        lifeRewardListTable[rewardId] = lifeRewardInfo
    end

    local setArray = s2cOnUpdateLifeRewardLogListResponse.set_reward_list

    for _,s2cLifeRewardInfo in ipairs(setArray) do
        local lifeRewardInfo = lt.PlayerRewardLog.new(s2cLifeRewardInfo)
        local rewardId = lifeRewardInfo:getRewardId()

        lifeRewardListTable[rewardId] = lifeRewardInfo
    end
end

function DataManager:getLifeReceiveTimesInfo()
    if not self._lifeReceiveTimesInfo then
        self._lifeReceiveTimesInfo = {}
    end

    return self._lifeReceiveTimesInfo
end

function DataManager:onGetLifeRewardReceiveTimesResponse(event)
    local s2cOnGetLifeRewardReceiveTimesResponse = event.data
    lt.CommonUtil.print("s2cOnGetLifeRewardReceiveTimesResponse OK")

    local lifeReceiveTimesTable = self:getLifeReceiveTimesInfo()

    local rewardReceiveTimes = s2cOnGetLifeRewardReceiveTimesResponse.reward_receive_times

    self._lifeReceiveTimesInfo = lt.RewardReceiveTimes.new(rewardReceiveTimes)

end


-- ################################################## 强化达人 ##################################################
function DataManager:getStrengthRewardLogListTable()
    if not self._strengthRewardListTable then
        self._strengthRewardListTable = {}
    end

    return self._strengthRewardListTable
end

function DataManager:getStrengthRewardIsFinished()
    return self._strengthRewardFlag
end

function DataManager:onGetStrengthRewardLogListResponse(event)
    local s2cOnGetStrengthRewardLogListResponse = event.data
    lt.CommonUtil.print("s2cOnGetStrengthRewardLogListResponse OK")

    local strengthRewardListTable = self:getStrengthRewardLogListTable()
    local rewardList = s2cOnGetStrengthRewardLogListResponse.reward_list

    for _,s2cStrengthRewardInfo in ipairs(rewardList) do
        local strengthRewardInfo = lt.PlayerRewardLog.new(s2cStrengthRewardInfo)
        local rewardId = strengthRewardInfo:getRewardId()

        strengthRewardListTable[rewardId] = strengthRewardInfo
    end

    self._strengthRewardFlag = s2cOnGetStrengthRewardLogListResponse.is_finished
end

function DataManager:onUpdateStrengthRewardLogListResponse(event)
    local s2cOnUpdateStrengthRewardLogListResponse = event.data
    lt.CommonUtil.print("s2cOnUpdateStrengthRewardLogListResponse OK")

    local strengthRewardListTable = self:getStrengthRewardLogListTable()

    local addArray = s2cOnUpdateStrengthRewardLogListResponse.add_reward_list

    for _,s2cStrengthRewardInfo in ipairs(addArray) do
        local strengthRewardInfo = lt.PlayerRewardLog.new(s2cStrengthRewardInfo)
        local rewardId = strengthRewardInfo:getRewardId()

        strengthRewardListTable[rewardId] = strengthRewardInfo
    end

    local setArray = s2cOnUpdateStrengthRewardLogListResponse.set_reward_list

    for _,s2cStrengthRewardInfo in ipairs(setArray) do
        local strengthRewardInfo = lt.PlayerRewardLog.new(s2cStrengthRewardInfo)
        local rewardId = strengthRewardInfo:getRewardId()

        strengthRewardListTable[rewardId] = strengthRewardInfo
    end
end

function DataManager:getStrengthReceiveTimesInfo()
    if not self._strengthReceiveTimesInfo then
        self._strengthReceiveTimesInfo = {}
    end

    return self._strengthReceiveTimesInfo
end

function DataManager:onGetStrengthRewardReceiveTimesResponse(event)
    local s2cOnGetStrengthRewardReceiveTimesResponse = event.data
    lt.CommonUtil.print("s2cOnGetStrengthRewardReceiveTimesResponse OK")

    local rewardReceiveTimes = s2cOnGetStrengthRewardReceiveTimesResponse.reward_receive_times

    self._strengthReceiveTimesInfo = lt.RewardReceiveTimes.new(rewardReceiveTimes)

end

function DataManager:getCurrentGemLevel()

    local level = 0
    for i = 1, 10 do
        local positionInfo = self:getPositionStrengthInfoByPosition(i)
        if positionInfo then
            for j = 1, 3 do
                local stoneId = positionInfo:getStoneById(j)

                if stoneId > 0 then
                    local info = lt.CacheManager:getGemTable(i,stoneId)

                    if info then
                        level = level + info:getLevel()
                    end
                end

            end
        end
    end

    return level
end

function DataManager:getCurrentLifeSkillLevel()

    local level = 0
    local playerLifeSkillTable = self:getLifeSkillTable()

    for _,lifeSkillInfo in pairs(playerLifeSkillTable) do
        if lifeSkillInfo then
            level = level + lifeSkillInfo:getLevel()
        end
    end

    return level
end

function DataManager:getCurrentSiteStrengthlLevel()

    local level = 0
    local order = 0
    local siteTable = self:getPositionStrengthTable()

    for _,siteInfo in pairs(siteTable) do
        if siteInfo then
            level = level + siteInfo:getLevel() + siteInfo:getOrder() * 5
        end
    end

    return level
end


-- ################################################## 全民答题 ##################################################

function DataManager:getActivityAnswerPartyInfo()
    return self._activityAnswerPartyInfo or nil
end

function DataManager:onGetActivityAnswerPartyInfo(event)
    local s2cOnGetActivityAnswerPartyInfo = event.data

    lt.CommonUtil.print("s2cOnGetActivityAnswerPartyInfo")

    local infoTabel = {}

    infoTabel["state"] = s2cOnGetActivityAnswerPartyInfo.state   --//答题活动状态  0：未开启 1：准备 2：进行中
    infoTabel["start_time"] = s2cOnGetActivityAnswerPartyInfo.start_time--//答题真正开始时间
    infoTabel["end_time"] = s2cOnGetActivityAnswerPartyInfo.end_time--//答题结束时间
    infoTabel["answer_index"] = s2cOnGetActivityAnswerPartyInfo.answer_index--//当前题号索引
    infoTabel["answer_id"] = s2cOnGetActivityAnswerPartyInfo.answer_id-- //题库中题目序号

    infoTabel["answer_correct"] = s2cOnGetActivityAnswerPartyInfo.answer_correct-- //是否回答正确 0：未回答或回答错误 1：回答正确
    infoTabel["answer_next_time"] = s2cOnGetActivityAnswerPartyInfo.answer_next_time-- //下一题开始时间  0：已是最后一题
    infoTabel["answer_score"] = s2cOnGetActivityAnswerPartyInfo.answer_score-- //我的积分

    self._activityAnswerPartyInfo = infoTabel
    lt.GameEventManager:post(lt.GameEventManager.EVENT.ANSWER_PARTY_INFO_UPDATE)
end

function DataManager:getNotifyAnswerPartyRewardAccumulative()
    return self._notifyAnswerPartyRewardAccumulative or nil
end

function DataManager:onNotifyAnswerPartyRewardAccumulative(event)
    local s2cOnNotifyAnswerPartyRewardAccumulative = event.data

    lt.CommonUtil.print("s2cOnNotifyAnswerPartyRewardAccumulative ")

    local infoTabel = {}
    infoTabel["correct_count"] = s2cOnNotifyAnswerPartyRewardAccumulative.correct_count   --
    infoTabel["total_count"] = s2cOnNotifyAnswerPartyRewardAccumulative.total_count--


--     id
-- value
--     local reward = {}
--     for k,item in pairs(s2cOnNotifyAnswerPartyRewardAccumulative.gain_item_list) do
--         reward
--     end

    infoTabel["gain_item_list"] = {}

    for _,item in pairs(s2cOnNotifyAnswerPartyRewardAccumulative.gain_item_list) do
        if item.id then
            local itemInfo = {}
            itemInfo.id = item.id
            itemInfo.value = item.value
            infoTabel["gain_item_list"][item.id] = itemInfo           
        end
    end

    self._notifyAnswerPartyRewardAccumulative = infoTabel    

    
    lt.GameEventManager:post(lt.GameEventManager.EVENT.ANSWER_PARTY_REWARD_UPDATE)
end

function DataManager:onGetActivityAnswerPartyBestPlayer(event)
    local s2cGetActivityAnswerPartyBestPlayer = event.data
    lt.CommonUtil.print("s2cGetActivityAnswerPartyBestPlayer OK")
    -- lt.CommonUtil.print("s2cGetActivityAnswerPartyBestPlayer content\n"..tostring(s2cGetActivityAnswerPartyBestPlayer))

    self._answerPartyBestPlayer = lt.RankInfo.new({
        player_id     = s2cGetActivityAnswerPartyBestPlayer.player_id,
        player_name   = s2cGetActivityAnswerPartyBestPlayer.name,
        occupation_id = s2cGetActivityAnswerPartyBestPlayer.occupation_id,
        -- sex           = s2cGetActivityAnswerPartyBestPlayer.sex,
    })
    self._answerPartyBestPlayer.periodId = s2cGetActivityAnswerPartyBestPlayer.period_id

    lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_ANSWER_PARTY_BEST_PLAYER)
end

function DataManager:clearAnswerPartyBestPlayer()
    self._answerPartyBestPlayer = nil
end

function DataManager:getAnswerPartyBestPlayer()
    return self._answerPartyBestPlayer
end

-- ################################################## 战队 RiskTeam ##################################################
function DataManager:onGetRiskTeamInfo(event)
    local s2cGetRiskTeamInfo = event.data
    lt.CommonUtil.print("s2cGetRiskTeamInfo OK")
    -- lt.CommonUtil.print("s2cGetRiskTeamInfo content\n"..tostring(s2cGetRiskTeamInfo))

    local scRiskTeam = s2cGetRiskTeamInfo.team
    self._riskTeam = lt.RiskTeam.new(scRiskTeam)

    self._isRiskTeamLeader = self._riskTeam:getPresidentId() == self:getPlayerId()

    local scRiskTeamMemberArray = s2cGetRiskTeamInfo.add_member_array
    for _,scRiskTeamMember in ipairs(scRiskTeamMemberArray) do
        local riskTeamMember = lt.RiskTeamMember.new(scRiskTeamMember)
        self._riskTeam:addMember(riskTeamMember)
    end
    self._riskTeam:sort()
    
    local scRiskTeamEventArray = s2cGetRiskTeamInfo.add_event_array
end

function DataManager:onUpdateRiskTeamInfo(event)
    local s2cUpdateRiskTeamInfo = event.data
    lt.CommonUtil.print("s2cUpdateRiskTeamInfo OK")
    -- lt.CommonUtil.print("s2cUpdateRiskTeamInfo content\n"..tostring(s2cUpdateRiskTeamInfo))

    if not self._riskTeam then
        return
    end

    if s2cUpdateRiskTeamInfo:HasField('team') then 
        local scRiskTeam = s2cUpdateRiskTeamInfo.team
        self._riskTeam:updateInfo(scRiskTeam)

        self._isRiskTeamLeader = self._riskTeam:getPresidentId() == self:getPlayerId()
    end

    local scAddRiskTeamMemberArray = s2cUpdateRiskTeamInfo.add_member_array
    for _,scRiskTeamMember in ipairs(scAddRiskTeamMemberArray) do
        local riskTeamMember = lt.RiskTeamMember.new(scRiskTeamMember)
        self._riskTeam:addMember(riskTeamMember)
    end

    local scSetRiskTeamMemberArray = s2cUpdateRiskTeamInfo.set_member_array
    for _,scRiskTeamMember in ipairs(scSetRiskTeamMemberArray) do
        local riskTeamMember = lt.RiskTeamMember.new(scRiskTeamMember)
        self._riskTeam:setMember(riskTeamMember)
    end
    self._riskTeam:sort()

    local selfPlayerId = self:getPlayerId()
    local scDelMemberPlayerIdArray = s2cUpdateRiskTeamInfo.del_member_player_id_array
    for _,scPlayerId in ipairs(scDelMemberPlayerIdArray) do
        self._riskTeam:removeMember(scPlayerId)

        if selfPlayerId == scPlayerId then
            self:clearRiskTeam()

            lt.GameEventManager:post(lt.GameEventManager.EVENT.RISK_TEAM_DELETE)
            break
        end
    end
end

function DataManager:onExitRiskTeamSuccess(event)
    local s2cExitRiskTeamSuccess = event.data
    lt.CommonUtil.print("s2cExitRiskTeamSuccess OK")
    -- lt.CommonUtil.print("s2cExitRiskTeamSuccess content\n"..tostring(s2cExitRiskTeamSuccess))

    if not self._riskTeam then
        return
    end
    
    self:clearRiskTeam()
    lt.GameEventManager:post(lt.GameEventManager.EVENT.RISK_TEAM_DELETE)
end

function DataManager:onRiskTeamDeleted(event)
    local s2cRiskTeamDeleted = event.data
    lt.CommonUtil.print("s2cRiskTeamDeleted OK")
    -- lt.CommonUtil.print("s2cRiskTeamDeleted content\n"..tostring(s2cRiskTeamDeleted))

    if not self._riskTeam then
        return
    end

    local riskTeamId = s2cRiskTeamDeleted.risk_team_id

    if self._riskTeam:getId() == riskTeamId then
        self:clearRiskTeam()

        lt.GameEventManager:post(lt.GameEventManager.EVENT.RISK_TEAM_DELETE)
    end
end

function DataManager:onNotifyRiskTeamNameChanged(event)
    local s2cNotifyRiskTeamNameChanged = event.data

    if not self._riskTeam then
        return
    end

    if s2cNotifyRiskTeamNameChanged:HasField('team') then 
        local scRiskTeam = s2cNotifyRiskTeamNameChanged.team
        self._riskTeam:updateInfo(scRiskTeam)

        self._isRiskTeamLeader = self._riskTeam:getPresidentId() == self:getPlayerId()
    end

    -- TODO: 关心称号问题
end

function DataManager:getRiskTeam()
    return self._riskTeam
end

function DataManager:isRiskTeamLeader()
    return self._isRiskTeamLeader
end

function DataManager:getSlefRiskTeamMemer()
    if not self._riskTeam then
        return nil
    end

    return self._riskTeam:getSelfMember()
end

function DataManager:clearRiskTeam()
    self._riskTeam = nil
    self._tempRiskSortPlayerIdArray = {}
    self._isRiskTeamLeader = false
end

function DataManager:setTempRiskTeam(riskTeam)
    self._tempRiskTeam = riskTeam
end

function DataManager:getTempRiskTeam()
    return self._tempRiskTeam
end

--根据id判断是否为战队成员
function DataManager:checkIsRiskMember(id)
    local riskTeamInfo = self:getRiskTeam()

    local flag = false

    if riskTeamInfo then
        local memberArray = riskTeamInfo:getMemberArray()
        for i = 1, #memberArray do
            if id == memberArray[i]:getPlayerId() then
                flag = true
                break
            end
        end
    end



    return flag
end


--战队聊天信息

function DataManager:setRiskTeamMessageNew(bool)
    self._riskTeamMessageNew = bool
end

function DataManager:getRiskTeamMessageNew()
    return self._riskTeamMessageNew
end

function DataManager:onGetTeamChatMessageResponse(event)
    local s2cOnGetTeamChatMessageResponse = event.data

    lt.CommonUtil.print("s2cOnGetTeamChatMessageResponse code ===="..s2cOnGetTeamChatMessageResponse.code)

    local messageArray = s2cOnGetTeamChatMessageResponse.message_array

    for i=1,#messageArray do
        local message = messageArray[i]
        local messageInfo = lt.ChatMessage.new()

        messageInfo:initWithRow(message)

        if not lt.ChatManager:isExist(messageInfo:getId()) then
            lt.ChatManager:insertChatTeamInfo(messageInfo)
        end
    end

    local teamId = s2cOnGetTeamChatMessageResponse.risk_team_id

    local updateTime = lt.CommonUtil:getCurrentTime()
    lt.ChatManager:insertChatTeamRiskUpdateTime(teamId,updateTime)

    if #messageArray > 0 then
        self:setRiskTeamMessageNew(true)
    end

end


-- ################################################## 特殊事件-迷宫 Maze ##################################################
function DataManager:onMazeTriigerAnswer(event)
    local s2cMazeTriigerAnswer = event.data
    local code = s2cMazeTriigerAnswer.code
    lt.CommonUtil.print("s2cMazeTriigerAnswer code "..code)
    -- lt.CommonUtil.print("s2cMazeTriigerAnswer content\n"..tostring(s2cMazeTriigerAnswer))
end

function DataManager:onGetSpecialEventMaze(event)
    local s2cGetSpecialEventMaze = event.data
    lt.CommonUtil.print("s2cGetSpecialEventMaze OK")
    -- lt.CommonUtil.print("s2cGetSpecialEventMaze content\n"..tostring(s2cGetSpecialEventMaze))

    local status = 0

    local scMaze = s2cGetSpecialEventMaze.maze
    local mazeTask = lt.PlayerMazeTask.new(scMaze)
    if self._mazeTask and self._mazeTask:isExist() and not mazeTask:isExist() then
        -- 任务完成
        status = 2

        local mazeName = self._mazeTask:getName()
        lt.NoticeManager:onMazeComplete(mazeName)
    elseif (not self._mazeTask or not self._mazeTask:isExist() and mazeTask:isExist()) then
        -- 任务接取
        status = 3

        if self._flush then
            lt.NoticeManager:onMazeTask()
        end
    else
        status = 1
    end
    self._mazeTask = mazeTask

    lt.GameEventManager:post(lt.GameEventManager.EVENT.TASK_UPDATE, {maze = true, status = status})
end

function DataManager:getMazeTask()
    return self._mazeTask
end

--###################################################称号##################
function DataManager:getTitleTable()
    if not self._titleInfoTable then
        self._titleInfoTable = {}
    end
    return self._titleInfoTable
end

function DataManager:onTitleInfo(event)
    lt.CommonUtil.print("s2cTitle OK")
    local s2cTitleInfo = event.data
    local titleTable = self:getTitleTable()
    if s2cTitleInfo.add_title_array then
        for k,title in pairs(s2cTitleInfo.add_title_array) do
            if title.title_id then
                local currentTime = lt.CommonUtil:getCurrentTime()
                if title.expire_time and title.expire_time > 0 then
                    if currentTime < title.expire_time then
                        local info = {}
                        info["titleId"] = title.title_id
                        info["name"] = title.name
                        info["expireTime"] = title.expire_time
                        info["equiped"] = title.equiped
                        titleTable[title.title_id] = info
                    end
                else
                    local info = {}
                    info["titleId"] = title.title_id
                    info["name"] = title.name
                    info["expireTime"] = title.expire_time or 0
                    info["equiped"] = title.equiped
                    titleTable[title.title_id] = info
                end
            end
        end
    end

    if s2cTitleInfo.set_title_array then
        for k,title in pairs(s2cTitleInfo.set_title_array) do
            if title.title_id then
                local currentTime = lt.CommonUtil:getCurrentTime()
                if title.expire_time and title.expire_time > 0 then
                    if currentTime < title.expire_time then
                        local info = {}
                        info["titleId"] = title.title_id
                        info["name"] = title.name
                        info["expireTime"] = title.expire_time
                        info["equiped"] = title.equiped
                        titleTable[title.title_id] = info
                    end
                else
                    local info = {}
                    info["titleId"] = title.title_id
                    info["name"] = title.name
                    info["expireTime"] = title.expire_time or 0
                    info["equiped"] = title.equiped
                    titleTable[title.title_id] = info
                end
            end
        end
    end

    if s2cTitleInfo.del_id_array then
        for k,titleId in pairs(s2cTitleInfo.del_id_array) do
            if titleId then
                titleTable[titleId] = nil
            end
        end
    end

    --dump(self._titleInfoTable)
    
    -- lt.CommonUtil.print("DataManager:onTitleInfo   update code  OK")
    lt.GameEventManager:post(lt.GameEventManager.EVENT.PLAYER_TITLE)
end

function DataManager:getAllTitleTable()
    local titleTable = self:getTitleTable()

    --公会
    local guildId = lt.DataManager:getGuildId()
    if guildId ~= 0 then
        local playerGuild = lt.DataManager:getPlayerGuild()
        
        if playerGuild then
            local member = lt.DataManager:getMember(lt.DataManager:getPlayerId())

            local info = titleTable[lt.Constants.PLAYER_TITLE_TYPE.GUILD_TITLE] or {}
            info["titleId"] = lt.Constants.PLAYER_TITLE_TYPE.GUILD_TITLE
            info["expireTime"] = 0--零为永久
            if member then
                info["name"] = playerGuild:getName().." · "..playerGuild:getOfficeName(member:getOfficeLevel())
            else
                info["name"] = playerGuild:getName()
            end
            titleTable[lt.Constants.PLAYER_TITLE_TYPE.GUILD_TITLE] = info
        else
            titleTable[lt.Constants.PLAYER_TITLE_TYPE.GUILD_TITLE] = nil
        end
    else
        titleTable[lt.Constants.PLAYER_TITLE_TYPE.GUILD_TITLE] = nil
    end

    --大富翁
    local yearCardFlag = lt.DataManager:getPlayer():getYearCardFlag()
    if yearCardFlag == 1 then
        local titleInfo = lt.CacheManager:getPlayerTitleInfoById(lt.Constants.PLAYER_TITLE_TYPE.LIFE_TITLE)
        local info = titleTable[lt.Constants.PLAYER_TITLE_TYPE.LIFE_TITLE] or {}
        info["titleId"] = lt.Constants.PLAYER_TITLE_TYPE.LIFE_TITLE
        info["expireTime"] = 0--零为永久
        info["name"] = titleInfo:getName()
        titleTable[lt.Constants.PLAYER_TITLE_TYPE.LIFE_TITLE] = info
    else
        titleTable[lt.Constants.PLAYER_TITLE_TYPE.LIFE_TITLE] = nil
    end

    --小队
    local riskTeam = lt.DataManager:getRiskTeam()
    if riskTeam then
        local titleInfo = lt.CacheManager:getPlayerTitleInfoById(lt.Constants.PLAYER_TITLE_TYPE.TEAM_TITLE)
        local info = titleTable[lt.Constants.PLAYER_TITLE_TYPE.TEAM_TITLE] or {}
        info["titleId"] = lt.Constants.PLAYER_TITLE_TYPE.TEAM_TITLE
        info["expireTime"] = 0--零为永久
        info["name"] = riskTeam:getTitle()
        titleTable[lt.Constants.PLAYER_TITLE_TYPE.TEAM_TITLE] = info
    else
        titleTable[lt.Constants.PLAYER_TITLE_TYPE.TEAM_TITLE] = nil
    end

    for k,title in pairs(titleTable) do
        if title then
            local currentTime = lt.CommonUtil:getCurrentTime()
            if title.expireTime and title.expireTime > 0 then
                if currentTime >= title.expireTime then
                    titleTable[k] = nil
                end
            end
        end
    end

    return titleTable
end
    
function DataManager:getEquipTitle()
    local equipTitle = nil
    local allTitle = lt.DataManager:getAllTitleTable()
    for k,title in pairs(allTitle) do
        if title.equiped and title.equiped == 1 then
            equipTitle = title
            break
        end
    end
    return equipTitle
end

function DataManager:setTempRiskSortPlayerIdArray(playerIdArray)
    self._tempRiskSortPlayerIdArray = playerIdArray
end

function DataManager:getTempRiskSortPlayerIdArray()
    return self._tempRiskSortPlayerIdArray
end

--###################################################回流礼包##################

function DataManager:getBackFlowTable()
    if not self._backFlowTable then
        self._backFlowTable = {}
    end

    return self._backFlowTable
end

function DataManager:getBackFlowRewardTable()
    if not self._backFlowRewardTable then
        self._backFlowRewardTable = {}
    end

    return self._backFlowRewardTable
end

function DataManager:onGetBackFlowGagArray(event)
    local s2cOnGetBackFlowGagArray = event.data

    lt.CommonUtil.print("s2cOnGetBackFlowGagArray code111111111111111111111111111111111111 =")

    local backFlowTable = self:getBackFlowTable()

    local backFlowRewardTable = self:getBackFlowRewardTable()

    local addBackFlowBagArray = s2cOnGetBackFlowGagArray.add_back_flow_bag_array

    for _,s2cBackFlowInfo in ipairs(addBackFlowBagArray) do
        local info = lt.BackFlowInfo.new(s2cBackFlowInfo)

        local type = info:getType()

        backFlowTable[type] = info

    end


    local setBackFlowBagArray = s2cOnGetBackFlowGagArray.set_back_flow_bag_array

    for _,s2cBackFlowInfo in ipairs(setBackFlowBagArray) do
        local info = lt.BackFlowInfo.new(s2cBackFlowInfo)

        local type = info:getType()

        backFlowTable[type] = info
    end

    local activityRewardArray = s2cOnGetBackFlowGagArray.activity_reward_array

    for _,s2cBackFlowInfo in ipairs(activityRewardArray) do
        local info = lt.BackFlowRewardInfo.new(s2cBackFlowInfo)

        local id = info:getId()

        backFlowRewardTable[id] = info
    end


end

--###################################################在线有礼##################
function DataManager:getOnlineRewardInfo()
    return self._onlineRewardInfo
end

function DataManager:onGetOnlineReward(event)

    lt.CommonUtil.print("s2cOnGetOnlineRewardResponse")

    local s2cOnGetOnlineRewardResponse = event.data


    self._onlineRewardInfo =  lt.OnlineActivityRewardInfo.new(s2cOnGetOnlineRewardResponse.online_reward)
end

--###################################################玩家充值总共数##################
function DataManager:getTotalRechargeRmb()
    return self._totalRechargeAmount or 0
end


function DataManager:getTotalRechargeAmount(event)
    lt.CommonUtil.print("s2cGetTotalRechargeAmount amount =", event.data.amount)
    local s2cGetTotalRechargeAmount = event.data
    self._totalRechargeAmount = s2cGetTotalRechargeAmount.amount
end


--###################################################首冲累冲##################
function DataManager:getRechargeLogTable()
    if not self._rechargeLogTable then
        self._rechargeLogTable = {}
    end
    return self._rechargeLogTable
end

function DataManager:getRechargeLog(event)
    lt.CommonUtil.print("s2cRechargeLog OK")
    local s2cRechargeLog = event.data
    local rechargeLogTable = self:getRechargeLogTable()
    --dump(tostring(s2cRechargeLog))
    if s2cRechargeLog.recharge_log then
        local RechargeLog = s2cRechargeLog.recharge_log
        rechargeLogTable["finishFlag"] = RechargeLog.finish_flag

        rechargeLogTable["firstRechargeFlag"] = RechargeLog.first_recharge_flag
        rechargeLogTable["firstRechargeReceiveFlag"] = RechargeLog.first_recharge_receive_flag
        rechargeLogTable["firstRechargeRewardArray"] = {}
        for k,item in pairs(RechargeLog.first_recharge_reward_array) do
            if item.id then
                local info = {}
                info["itemType"] = item.id
                info["itemId"] = item.value
                info["count"] = item.count
                table.insert(rechargeLogTable["firstRechargeRewardArray"], info)
            end
        end

        rechargeLogTable["accumulateRechargeAmount"] = RechargeLog.accumulate_recharge_amount--累积的值
        rechargeLogTable["accumulateRechargeRewardId"] = RechargeLog.accumulate_recharge_reward_id--进行到的阶段id

        rechargeLogTable["accumulateRechargeReceiveArray"] = {}
        for k,receive in pairs(RechargeLog.accumulate_recharge_receive_array) do
            if receive.id then
                rechargeLogTable["accumulateRechargeReceiveArray"][receive.id] = receive.value  --0 未领取 1：已领取
            end
        end

        rechargeLogTable["accumulateRechargeRewardArray"] = {}
        for k,accumulateInfo in pairs(RechargeLog.accumulate_recharge_reward_array) do
            if accumulateInfo.id then
                local rechargeInfo = {}
                rechargeInfo["rechargeId"] = accumulateInfo.id
                rechargeInfo["amount"] = accumulateInfo.amount
                rechargeInfo["rewardArray"] = {}
                for k,reward in pairs(accumulateInfo.reward_array) do
                    if reward.id then
                        local info = {}
                        info["itemType"] = reward.id
                        info["itemId"] = reward.value
                        info["count"] = reward.count
                        table.insert(rechargeInfo["rewardArray"], info)
                    end
                end
                --table.insert(rechargeLogTable["accumulateRechargeRewardArray"], rechargeInfo)
                rechargeLogTable["accumulateRechargeRewardArray"][accumulateInfo.id] = rechargeInfo
            end
        end
    lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_FIRST_RECHARGE)
    end
end

--###################################################   特惠礼包   ##################

function DataManager:getMasterSpecialGiftPackDataList()
    if not self._masterSpecialGiftPackDataList then
        self._masterSpecialGiftPackDataList = {}
    end
    return self._masterSpecialGiftPackDataList
end

function DataManager:getMasterSpecialGiftPackDataByItem(itemId, modelId)-- 特惠礼包触发 通过等级还有充值情况获取数据 --modelId 英灵modelid 特性书的特殊处理

    local playerLevel = self:getPlayerLevel()
    local totalRecharge = self:getTotalRechargeRmb()

    local tempLevel = 0
    local tempData = nil

    local masterSpecialGiftPackDataList = lt.DataManager:getMasterSpecialGiftPackDataList()
    for k,giftPack in pairs(masterSpecialGiftPackDataList) do
        --if giftPack.level > tempLevel then
            local rechargeRect = json.decode(giftPack.charge)--充值区间
            if  totalRecharge >= rechargeRect[1] and totalRecharge <= rechargeRect[2] and  playerLevel >= giftPack.level  then
                --tempLevel = giftPack.level
                tempData = giftPack

                if tempData then
                    local rewardTable = json.decode(tempData.reward) or {}
                    for k,reward in pairs(rewardTable) do
                        if reward[2]  and reward[2] == itemId then--找到了符合条件的

                            lt.CommonUtil:print("找到了符合条件的特惠礼包", tempData.id)
                            local specialGiftPackDataList = lt.DataManager:getSpecialGiftPackDataList()--服务器储存已经触发过的数据
                            if not specialGiftPackDataList[tempData.id] then--还没触发过可以触发
                                --英灵特性书特殊处理  暂未处理
                                --[[
                                    低级特性书*4  规则不变
                                    低级特性书*10 需要玩家至少学习满4本特性书（特性书不区分高低级）
                                    高级特性书*4 需要玩家至少学习满8本特性书（特性书不区分高低级）
                                ]]--
                                if tempData.id == 8 then --低级特性书*10
                                    local servantInfo = lt.CacheManager:getServantInfo(modelId)
                                    if not servantInfo then
                                        return
                                    end
                                    local characterIdArray =  servantInfo:getCharacterIdArray() or {}
                                    lt.CommonUtil:print("特惠礼包特性书", #characterIdArray)
                                    if #characterIdArray < 4 then
                                        return
                                    end
                                end

                                if tempData.id == 9 then --高级特性书*4
                                    local servantInfo = lt.CacheManager:getServantInfo(modelId)
                                    if not servantInfo then
                                        return
                                    end
                                    local characterIdArray =  servantInfo:getCharacterIdArray() or {}
                                    lt.CommonUtil:print("特惠礼包特性书", #characterIdArray)
                                    if #characterIdArray < 8 then
                                        return
                                    end
                                end

                                lt.CommonUtil:print("触发特惠礼包", tempData.id)
                                display.getRunningScene():getWorldMenuLayer():onSpecialGiftBagBtn({giftId = tempData.id})
                                
                                return tempData
                            end
                        end
                    end
                end
            end
        --end
    end

    return nil
end

function DataManager:getMasterSpecialGiftPackList(event)

    lt.CommonUtil.print("s2cMasterSpecialGiftPackList OK")
    local s2cMasterSpecialGiftPackList = event.data
    local masterSpecialGiftPackDataList = self:getMasterSpecialGiftPackDataList()

    if s2cMasterSpecialGiftPackList.data_array then
        for k,data in pairs(s2cMasterSpecialGiftPackList.data_array) do
            if data.id then
                local info = {}
                info["id"] = data.id
                info["name"] = data.name
                info["level"] = data.level
                info["charge"] = data.charge --json.decode(data.charge)
                info["reward"] = data.reward
                info["original_price"] = data.original_price
                info["currency_type"] = data.currency_type
                info["currency_count"] = data.currency_count
                info["shop_item_id"] = data.shop_item_id
                masterSpecialGiftPackDataList[data.id] = info
            end
        end
    end
end

function DataManager:getSpecialGiftPackDataList()
    if not self._specialGiftPackDataList then
        self._specialGiftPackDataList = {}
    end
    return self._specialGiftPackDataList
end

function DataManager:getSpecialGiftPackList(event)
    lt.CommonUtil.print("s2cSpecialGiftPackList OK")
    local s2cSpecialGiftPackList = event.data
    local specialGiftPackDataList = self:getSpecialGiftPackDataList()

    if s2cSpecialGiftPackList.add_gift_pack_array then
        for k,data in pairs(s2cSpecialGiftPackList.add_gift_pack_array) do
            if data.pack_id then
                local info = {}
                info["id"] = data.pack_id
                info["status"] = data.status--//0:未领取 1:已领取
                info["createTime"] = data.create_time
                specialGiftPackDataList[data.pack_id] = info
            end
        end
    end
end

function DataManager:updateSpecialGiftPackList(event)
    lt.CommonUtil.print("s2cupdateSpecialGiftPackList OK")
    local s2cSpecialGiftPackList = event.data
    local specialGiftPackDataList = self:getSpecialGiftPackDataList()
    local postData = nil
    if s2cSpecialGiftPackList.add_gift_pack_array then
        for k,data in pairs(s2cSpecialGiftPackList.add_gift_pack_array) do
            if data.pack_id then
                local info = {}
                info["id"] = data.pack_id
                info["status"] = data.status--//0:未领取 1:已领取
                info["createTime"] = data.create_time
                postData = info
            end
        end
    end

    if s2cSpecialGiftPackList.set_gift_pack_array then
        for k,data in pairs(s2cSpecialGiftPackList.set_gift_pack_array) do
            if data.pack_id then
                local info = {}
                info["id"] = data.pack_id
                info["status"] = data.status--//0:未领取 1:已领取
                info["createTime"] = data.create_time
                postData = info
            end
        end
    end

    if postData then
        if not specialGiftPackDataList[postData.id] then
            specialGiftPackDataList[postData.id] = postData
            lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_SPECIAL_GIFT_BAG, {newAdd = true, postData = postData})
        else
            specialGiftPackDataList[postData.id] = postData
            lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_SPECIAL_GIFT_BAG, {newAdd = false, postData = postData})
        end
    end
end

--###################################################   成长基金   ##################
function DataManager:getGrowUpFundTable()
    if not self._growUpFundTable then
        self._growUpFundTable = {}
    end
    return self._growUpFundTable
end

function DataManager:resetGrowUpFundTable()
    self._growUpFundTable = {}
    return self._growUpFundTable
end

function DataManager:getGrowUpFundInfo()
    if not self._growUpFundInfo then
        self._growUpFundInfo = {}
    end
    return self._growUpFundInfo
end

function DataManager:getGrowUpFundIdArray()
    if not self._growUpFundIdArray then
        self._growUpFundIdArray = {}
    end
    return self._growUpFundIdArray
end

function DataManager:resetGrowUpFundIdArray()
    self._growUpFundIdArray = {}
    return self._growUpFundIdArray
end

function DataManager:getGrowUpFund(event)
    lt.CommonUtil.print("s2cGrowUpFund OK")
    local s2cGrowUpFund = event.data
    --dump(tostring(s2cGrowUpFund))

    local growUpFundTable = self:resetGrowUpFundTable()

    local growUpFundInfo = self:getGrowUpFundInfo()

    local fundIdArray = self:resetGrowUpFundIdArray()
    
    if s2cGrowUpFund.grow_up_fund then
        local rootData = s2cGrowUpFund.grow_up_fund
        if rootData.fund_reward_array then
            for k,info in pairs(rootData.fund_reward_array) do
                if info.id then--195 196 197
                    table.insert(fundIdArray, info.id)

                    local fundInfo = {}
                    fundInfo["id"] = info.id
                    fundInfo["minLevel"] = info.min_level
                    fundInfo["maxLevel"] = info.max_level
                    fundInfo["levelRewardArray"] = {}

                    for k,rewardInfo in pairs(info.reward_array) do
                        if rewardInfo.id then--level
                            local reward = {}
                            reward["level"] = rewardInfo.id
                            reward["reward"] = {}
                            for k,item in pairs(rewardInfo.level_reward_array) do
                                table.insert(reward["reward"], item)--id：道具类型     value:道具id count：道具数量
                            end
                            table.insert(fundInfo["levelRewardArray"], reward)
                        end
                    end

                    table.sort(fundInfo["levelRewardArray"], function(a, b)
                        return a.level < b.level
                    end)

                    table.insert(growUpFundTable, fundInfo)
                end

                table.sort(growUpFundTable, function(a, b)
                    return a.id < b.id
                end)
            end
        end

        growUpFundInfo["isFinish"] = rootData.is_finish--0:未结束 1：结束保留界面  2：结束删除界面
        --购买状态
        if rootData.buy_state_array then
            if not growUpFundInfo["buyStateArray"] then
                growUpFundInfo["buyStateArray"] = {}
            end
            for k,state in pairs(rootData.buy_state_array) do
                if type(state) == "table" and state.id then
                    growUpFundInfo["buyStateArray"][state.id] = state.value -- id：195 196 197  value 0:不可购买 1：可购买 2：已买   
                end
            end
        end

        --领取状态
        table.sort(fundIdArray, function(a, b)
            return a < b
        end)

        if not growUpFundInfo["receiveStateTable"] then
            growUpFundInfo["receiveStateTable"] =  {}
        end
        -- growUpFundInfo["receiveStateTable"][197] = {}
        -- growUpFundInfo["receiveStateTable"][197][60] = 0
        -- growUpFundInfo["receiveStateTable"][197][65] = 1
        -- growUpFundInfo["receiveStateTable"][197][70] = 0


        if rootData.level_1_receive_state then
            for k,info in pairs(rootData.level_1_receive_state) do
                if info.id then
                    if not growUpFundInfo["receiveStateTable"][fundIdArray[1]] then
                        growUpFundInfo["receiveStateTable"][fundIdArray[1]] = {}
                    end
                    growUpFundInfo["receiveStateTable"][fundIdArray[1]][info.id] = info.value -- 195 id：level  value 0:未领取 1：已领取 
                end
            end
        end

        if rootData.level_2_receive_state then
            for k,info in pairs(rootData.level_2_receive_state) do
                if info.id then
                    if not growUpFundInfo["receiveStateTable"][fundIdArray[2]] then
                        growUpFundInfo["receiveStateTable"][fundIdArray[2]] = {}
                    end
                    growUpFundInfo["receiveStateTable"][fundIdArray[2]][info.id] = info.value -- 196 id：level  value 0:未领取 1：已领取 
                end 
            end
        end

        if rootData.level_3_receive_state then
            for k,info in pairs(rootData.level_3_receive_state) do
                if info.id then
                    if not growUpFundInfo["receiveStateTable"][fundIdArray[3]] then
                        growUpFundInfo["receiveStateTable"][fundIdArray[3]] = {}
                    end
                    growUpFundInfo["receiveStateTable"][fundIdArray[3]][info.id] = info.value -- 197 id：level  value 0:未领取 1：已领取 
                end 
            end
        end
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_GROW_UP_FUND)
end

function DataManager:getCollectiveActiveTable()

    if not self._collectiveActiveTable then
        self._collectiveActiveTable = {}
    end

    return self._collectiveActiveTable
end

function DataManager:getCollectiveActive(event)
    lt.CommonUtil.print("s2cGetCollectiveActive OK++++++++++++++++++++++++++++++++")
    local s2cCollectiveActive = event.data

    local collectiveActiveTable = self:getCollectiveActiveTable()
    if s2cCollectiveActive.receive_array then
        for k,info in pairs(s2cCollectiveActive.receive_array) do
            if info.id then
                collectiveActiveTable[info.id] = info.value --//id :总活跃度奖励ID  value:0 不可领取 1：可领取  2：已领取
            end
        end
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_COLLECTIVE_ACTION)
end

-- ################################################## 运营活动 ##################################################
function DataManager:getBatchActivityTable()
    if not self._batchActivityTable then
        self._batchActivityTable = {}
    end

    return self._batchActivityTable
end

-- batchActivityId 为 Constants.BATCH_ACTIVITY_ID
function DataManager:getBatchActivity(batchActivityId)
    local batchActivityTable = self:getBatchActivityTable()
    return batchActivityTable[batchActivityId]
end

function DataManager:getBatchActivityAccumulateLogin()
    return self:getBatchActivity(lt.Constants.BATCH_ACTIVITY_ID.ACCUMULATE_LOGIN)
end

function DataManager:getBatchActivityFirstCharge()
    return self:getBatchActivity(lt.Constants.BATCH_ACTIVITY_ID.FIRST_CHARGE)
end

function DataManager:getBatchActivityHappyTogether()
    return self:getBatchActivity(lt.Constants.BATCH_ACTIVITY_ID.HAPPY_TOGETHER)
end

function DataManager:getBatchActivityPower()
    return self:getBatchActivity(lt.Constants.BATCH_ACTIVITY_ID.POWER)
end

-- 运营活动是否开启
function DataManager:isBatchActivityValid(batchActivityId)
    local batchActivity = self:getBatchActivity(batchActivityId)
    return (batchActivity and batchActivity:isValid()), batchActivity
end

function DataManager:isBatchActivityValidWechat()
    return self:isBatchActivityValidAccumulateLogin()
        or self:isBatchActivityValidFirstCharge()
        or self:isBatchActivityValidHappyTogether()
        or self:isBatchActivityValidPower()
end

-- 微信红包-累积登陆
function DataManager:isBatchActivityValidAccumulateLogin()
    return self:isBatchActivityValid(lt.Constants.BATCH_ACTIVITY_ID.ACCUMULATE_LOGIN)
end

-- 微信红包-首充红包
function DataManager:isBatchActivityValidFirstCharge()
    local valid, batchActivity = self:isBatchActivityValid(lt.Constants.BATCH_ACTIVITY_ID.FIRST_CHARGE)

    if valid then
        if batchActivity and batchActivity:isEnd() then
            -- 活动结束 判断是否显示
            local startTime  = batchActivity:getStartTime()
            local endTime    = batchActivity:getEndTime()
            local currentDay = self:getActivityFirstChargeLoginCount()
            local mstActivityFirstChargeArray = self:getMstActivityFirstChargeArray()
            local hasCharge = false
            for _,mstActivityFirstCharge in ipairs(mstActivityFirstChargeArray) do
                -- 判断是否已经领取
                local rewardId = mstActivityFirstCharge:getId()
                local activityRewardLog = self:getActivityRewardLog(lt.Constants.BATCH_ACTIVITY_ID.FIRST_CHARGE, rewardId)
                if not activityRewardLog then
                    -- 尚未领取
                    local targetDay = mstActivityFirstCharge:getDays()
                    local amount = mstActivityFirstCharge:getAmount()
                    if currentDay >= targetDay and self:overChargeOrder(amount, startTime, endTime) then
                        hasCharge = true
                    end
                else
                    hasCharge = true
                end
            end

            if hasCharge then
                return valid, batchActivity
            else
                return false, batchActivity
            end
        else
            return valid, batchActivity
        end
    else
        return valid,  batchActivity
    end
end

-- 微信红包-一起来嗨
function DataManager:isBatchActivityValidHappyTogether()
    return self:isBatchActivityValid(lt.Constants.BATCH_ACTIVITY_ID.HAPPY_TOGETHER)
end

-- 微信红包-战力红包
function DataManager:isBatchActivityValidPower()
    return self:isBatchActivityValid(lt.Constants.BATCH_ACTIVITY_ID.POWER)
end

--女皇贡品
function DataManager:isBatchActivityValidQueenTribute()
    return self:isBatchActivityValid(lt.Constants.BATCH_ACTIVITY_ID.QUEEN_TRIBUTE)
end

--多买多送
function DataManager:isBatchActivityValidMoreAndMore()
    return self:isBatchActivityValid(lt.Constants.BATCH_ACTIVITY_ID.MORE_AND_MORE)
end

--冒险者宝藏
function DataManager:isBatchActivityValidAdventurer()
    return self:isBatchActivityValid(lt.Constants.BATCH_ACTIVITY_ID.ADVENTURER_REWARD)
end

--特殊礼包
function DataManager:isBatchActivityValidSpecialPacket()
    return self:isBatchActivityValid(lt.Constants.BATCH_ACTIVITY_ID.SPECIAL_PACKET)
end

--运营活动是否开启
function DataManager:isOperationOpen()
    return self:isBatchActivityValidAccumulateCharge()
        or self:isBatchActivityValidAccumulateCost()
        or self:isBatchActivityBackGift()
        or self:isBatchActivityDailyTotalCharge()

        or self:isBatchActivityValidQueenTribute()
        or self:isBatchActivityValidMoreAndMore() 
        or self:isBatchActivityValidAdventurer()
        or self:isBatchActivityValidSpecialPacket()
end

-- 运营活动-累积充值
function DataManager:isBatchActivityValidAccumulateCharge()
    return self:isBatchActivityValid(lt.Constants.BATCH_ACTIVITY_ID.ACCUMULATIVE_RECHARGE)
end

-- 运营活动-累计消费
function DataManager:isBatchActivityValidAccumulateCost()
    return self:isBatchActivityValid(lt.Constants.BATCH_ACTIVITY_ID.ACCUMULATIVE_COST)
end

-- 运营活动-回流礼包
function DataManager:isBatchActivityBackGift()
    return self:isBatchActivityValid(lt.Constants.BATCH_ACTIVITY_ID.BACK_GIFT)
end

-- 运营活动-每日累计充值
function DataManager:isBatchActivityDailyTotalCharge()
    return self:isBatchActivityValid(lt.Constants.BATCH_ACTIVITY_ID.DAILY_TOTAL_CHARGE)
end


function DataManager:onGetBatchActivity(event)
    local s2cGetBatchActivity = event.data
    lt.CommonUtil.print("s2cGetBatchActivity OK")
    -- lt.CommonUtil.print("s2cGetBatchActivity content\n"..tostring(s2cGetBatchActivity))

    --dump(tostring(s2cGetBatchActivity))

    local batchActivityTable = self:getBatchActivityTable()
    local updateBatchActivityIdTable = {} -- 变化的活动的id

    local s2cAddBatchActivityArray = s2cGetBatchActivity.add_batch_activity_array
    for _,scBatchActivity in ipairs(s2cAddBatchActivityArray) do
        local batchActivity = lt.BatchActivity.new(scBatchActivity)
        local activityId = batchActivity:getActivityId()
        batchActivityTable[activityId] = batchActivity

        updateBatchActivityIdTable[activityId] = true
    end

    local s2cSetBatchActivityArray = s2cGetBatchActivity.set_batch_activity_array
    for _,scBatchActivity in ipairs(s2cSetBatchActivityArray) do
        local batchActivity = lt.BatchActivity.new(scBatchActivity)
        local activityId = batchActivity:getActivityId()
        batchActivityTable[activityId] = batchActivity

        updateBatchActivityIdTable[activityId] = true
    end

    local s2cDelBatchActivityIdArray = s2cGetBatchActivity.del_batch_activity_id_array
    for _,activityId in ipairs(s2cDelBatchActivityIdArray) do
        batchActivityTable[activityId] = nil

        updateBatchActivityIdTable[activityId] = true
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_BATCH_ACTIVITY, {activityIdTable = updateBatchActivityIdTable})
end

function DataManager:getActivityRewardLogTable()
    if not self._activityRewardLogTable then
        self._activityRewardLogTable = {}
    end

    return self._activityRewardLogTable
end

-- 红包兑换码记录
function DataManager:getActivityRewardLog(activityId, rewardId)
    local activityRewardLogTable = self:getActivityRewardLogTable()
    if not isset(activityRewardLogTable, activityId) then
        return nil
    end

    return activityRewardLogTable[activityId][rewardId]
end

function DataManager:onGetActivityRewardLogList(event)
    local s2cGetActivityRewardLogList = event.data
    lt.CommonUtil.print("s2cGetActivityRewardLogList OK")
    -- lt.CommonUtil.print("s2cGetActivityRewardLogList content\n"..tostring(s2cGetActivityRewardLogList))

    local activityRewardLogTable = self:getActivityRewardLogTable()
    local scAddActivityRewardLogArray = s2cGetActivityRewardLogList.add_activity_reward_log_array
    for _,scActivityRewardLog in ipairs(scAddActivityRewardLogArray) do
        local activityRewardLog = lt.ActivityRewardLog.new(scActivityRewardLog)
        local activityId = activityRewardLog:getActivityId()

        if not isset(activityRewardLogTable, activityId) then
            activityRewardLogTable[activityId] = {}
        end

        local rewardId = activityRewardLog:getRewardId()
        activityRewardLogTable[activityId][rewardId] = activityRewardLog
    end
end

function DataManager:onUpdateActivityRewardLogList(event)
    local s2cUpdateActivityRewardLogList = event.data
    lt.CommonUtil.print("s2cUpdateActivityRewardLogList OK")
    -- lt.CommonUtil.print("s2cUpdateActivityRewardLogList content\n"..tostring(s2cUpdateActivityRewardLogList))

    local activityRewardLogTable = self:getActivityRewardLogTable()
    local scAddActivityRewardLogArray = s2cUpdateActivityRewardLogList.add_activity_reward_log_array
    for _,scActivityRewardLog in ipairs(scAddActivityRewardLogArray) do
        local activityRewardLog = lt.ActivityRewardLog.new(scActivityRewardLog)
        local activityId = activityRewardLog:getActivityId()

        if not isset(activityRewardLogTable, activityId) then
            activityRewardLogTable[activityId] = {}
        end

        local rewardId = activityRewardLog:getRewardId()
        activityRewardLogTable[activityId][rewardId] = activityRewardLog
    end

    local scSetActivityRewardLogArray = s2cUpdateActivityRewardLogList.set_activity_reward_log_array
    for _,scActivityRewardLog in ipairs(scSetActivityRewardLogArray) do
        local activityRewardLog = lt.ActivityRewardLog.new(scActivityRewardLog)
        local activityId = activityRewardLog:getActivityId()

        if not isset(activityRewardLogTable, activityId) then
            activityRewardLogTable[activityId] = {}
        end

        local rewardId = activityRewardLog:getRewardId()
        activityRewardLogTable[activityId][rewardId] = activityRewardLog
    end
end

--特惠礼包
function DataManager:getMstActivitySpecialPacketTable()
    if not self._mstActivitySpecialPacketTable then
        self._mstActivitySpecialPacketTable = {}
    end

    return self._mstActivitySpecialPacketTable
end

function DataManager:getMstActivitySpecialPacketList(event)
    local s2cMstActivitySpecialPacketList = event.data
    lt.CommonUtil.print("s2cMstActivitySpecialPacketList OK")

    self._mstActivitySpecialPacketTable = {}
    
    local mstActivitySpecialPacketTable = self:getMstActivitySpecialPacketTable()
    if s2cMstActivitySpecialPacketList.data_array then
        for k,packet in ipairs(s2cMstActivitySpecialPacketList.data_array) do
            if packet.id then
                local info = lt.SpecialGiftInfo.new(packet)
                table.insert(mstActivitySpecialPacketTable, info)
            end
        end
        table.sort(mstActivitySpecialPacketTable, function(a, b)
            return a:getDay() <  b:getDay()
        end)
    end
end

function DataManager:getSpecialPacketCurrentRewardInfo()
    local openInfo = self:getBatchActivity(lt.Constants.BATCH_ACTIVITY_ID.SPECIAL_PACKET)
    if not openInfo then
        return nil
    end

    local mstActivitySpecialPacketTable = self:getMstActivitySpecialPacketTable()
    --local countdown = lt.CommonUtil:getCurrentTime() - openInfo:getStartTime()
    local st = os.date('*t',openInfo:getStartTime())

    local refreshTime = os.time({year =st.year, month = st.month, day =st.day, hour=5, min =0, sec = 0})
    local st2 = os.date('*t', lt.CommonUtil:getCurrentTime())
    local currentTime = os.time({year = st2.year, month = st2.month, day = st2.day, hour=5, min =0, sec = 0})

    if st2.hour < 5 then
        currentTime = currentTime - 86400
    end

    local countdown = currentTime - refreshTime

    local day = math.ceil(countdown / 86400) + 1
    lt.CommonUtil:print("SpecialPacketCurrent day", day)
    --day = 10
    for k,info in ipairs(mstActivitySpecialPacketTable) do
        if day < info:getDay() + info:getDelay() then
            return info
        end
    end
    return nil
end

-- ############################## 充值记录 ##############################
function DataManager:getChargeOrderTable(clear)
    if clear or not self._chargeOrderTable then
        self._chargeOrderTable = {}
    end

    return self._chargeOrderTable
end

function DataManager:getChargeOrderArray()
    if not self._chargeOrderArray then
        self._chargeOrderArray = {}
    end

    return self._chargeOrderArray
end

function DataManager:hasChargeOrder(amount, startTime, endTime)
    if not isset(self._chargeOrderTable, amount) then
        return false
    end

    local chargeOrderArray = self._chargeOrderTable[amount]
    if startTime and endTime then
        for _,chargeOrder in ipairs(chargeOrderArray) do
            local chargeTime = chargeOrder:getTime()
            return chargeTime > startTime and chargeTime < endTime
        end

        return false
    else
        return #chargeOrderArray > 0
    end
end

-- 金额以上充值(包括amount)
function DataManager:overChargeOrder(amount, startTime, endTime)
    for tempAmount,chargeOrderArray in pairs(self._chargeOrderTable) do
        if tempAmount >= amount then
            if startTime and endTime then
                for _,chargeOrder in ipairs(chargeOrderArray) do
                    local chargeTime = chargeOrder:getTime()
                    if chargeTime > startTime and chargeTime < endTime then
                        return true
                    end
                end
            else
                if #chargeOrderArray > 0 then
                    return true
                end
            end
        end
    end

    return false
end

function DataManager:onGetChargeOrderList(event)
    local s2cGetChargeOrderList = event.data
    lt.CommonUtil.print("s2cGetChargeOrderList OK")
    -- lt.CommonUtil.print("s2cGetChargeOrderList content\n"..tostring(s2cGetChargeOrderList))

    local chargeOrderTable = self:getChargeOrderTable(true)
    local scAddOrderArray = s2cGetChargeOrderList.add_order_array
    for _,scChargeOrder in ipairs(scAddOrderArray) do
        local chargeorder = lt.ChargeOrder.new(scChargeOrder)
        local amount = chargeorder:getAmount()
        if not isset(chargeOrderTable, amount) then
            chargeOrderTable[amount] = {}
        end
        chargeOrderTable[amount][#chargeOrderTable[amount] + 1] = chargeorder
    end

    -- local scSetOrderArray = s2cGetChargeOrderList.set_order_array

    lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_CHARGE_ORDER)
end

function DataManager:getBatchActivityLogListTable()
    if not self._batchActivityLogListTable then
        self._batchActivityLogListTable = {}
    end

    return self._batchActivityLogListTable
end

function DataManager:onGetBatchActivityLogArray(event)
    local s2cGetBatchActivityLogArray = event.data

    lt.CommonUtil.print("s2cGetBatchActivityLogArray OK")
    -- lt.CommonUtil.print("s2cGetBatchActivityLogArray content\n"..tostring(s2cGetBatchActivityLogArray))
    
    local batchActivityLogListTable = self:getBatchActivityLogListTable()

    local addBatchActivityLogArray = s2cGetBatchActivityLogArray.add_batch_activity_log_array

    for _,s2cBatchActivityLog in ipairs(addBatchActivityLogArray) do
        local info = lt.PlayerBatchActivityLog.new(s2cBatchActivityLog)

        local activityId = info:getActivityId()

        batchActivityLogListTable[activityId] = info

    end

    local setBatchActivityLogArray = s2cGetBatchActivityLogArray.set_batch_activity_log_array

    for _,s2cBatchActivityLog in ipairs(setBatchActivityLogArray) do
        local info = lt.PlayerBatchActivityLog.new(s2cBatchActivityLog)

        local activityId = info:getActivityId()

        batchActivityLogListTable[activityId] = info

    end



end

-- ############################## 登陆记录 ##############################
function DataManager:getActivityAccumulateLoginTable(clear)
    if not self._activityAccumulateLoginTable or clear then
        self._activityAccumulateLoginTable = {}
    end

    return self._activityAccumulateLoginTable
end

function DataManager:onGetActivityAccumulateLoginList(event)
    local s2cGetActivityAccumulateLoginList = event.data
    lt.CommonUtil.print("s2cGetActivityAccumulateLoginList OK")
    -- lt.CommonUtil.print("s2cGetActivityAccumulateLoginList content\n"..tostring(s2cGetActivityAccumulateLoginList))

    local activityAccumulateLoginTable = self:getActivityAccumulateLoginTable(true)
    local s2cAddActivityAccumulateLoginArray = s2cGetActivityAccumulateLoginList.add_activity_accumulate_login_array
    for idx,scActivityAccumulateLogin in ipairs(s2cAddActivityAccumulateLoginArray) do
        local activityAccumulateLogin = lt.ActivityAccumulateLogin.new(scActivityAccumulateLogin)
        local activityId = activityAccumulateLogin:getActivityId()

        if not isset(activityAccumulateLoginTable, activityId) then
            activityAccumulateLoginTable[activityId] = {}
        end

        activityAccumulateLoginTable[activityId][#activityAccumulateLoginTable[activityId] + 1] = activityAccumulateLogin
    end
end

-- ############################## 累积登陆 ##############################
function DataManager:getMstActivityAccumulateLoginTable()
    if not self._mstActivityAccumulateLoginTable then
        self._mstActivityAccumulateLoginTable = {}
    end

    return self._mstActivityAccumulateLoginTable
end

function DataManager:getMstActivityAccumulateLoginArray()
    if not self._mstActivityAccumulateLoginArray then
        self._mstActivityAccumulateLoginArray = {}
    end

    return self._mstActivityAccumulateLoginArray
end

function DataManager:onGetMstActivityAccumulateLoginList(event)
    local s2cGetMstActivityAccumulateLoginList = event.data
    lt.CommonUtil.print("s2cGetMstActivityAccumulateLoginList OK")
    -- lt.CommonUtil.print("s2cGetMstActivityAccumulateLoginList content\n"..tostring(s2cGetMstActivityAccumulateLoginList))

    local mstActivityAccumulateLoginTable = self:getMstActivityAccumulateLoginTable()
    self._mstActivityAccumulateLoginArray = {}
    local s2cMstActivityAccumulateLoginArray =  s2cGetMstActivityAccumulateLoginList.data_array
    for idx,s2cMstActivityAccumulateLogin in ipairs(s2cMstActivityAccumulateLoginArray) do
        local mstActivityAccumulateLogin = lt.MstActivityAccumulateLogin.new(s2cMstActivityAccumulateLogin)

        mstActivityAccumulateLoginTable[mstActivityAccumulateLogin:getId()] = mstActivityAccumulateLogin

        self._mstActivityAccumulateLoginArray[idx] = mstActivityAccumulateLogin
    end

    table.sort(self._mstActivityAccumulateLoginArray, function(mstActivityAccumulateLogin1, mstActivityAccumulateLogin2)
        return mstActivityAccumulateLogin1:getId() < mstActivityAccumulateLogin2:getId()
    end)
end

function DataManager:getLoginRewardLogTable()
    if not self._loginRewardLogTable then
        self._loginRewardLogTable = {}
    end

    return self._loginRewardLogTable
end

function DataManager:getLoginRewardLog(rewardId)
    local loginRewardLogTable = self:getLoginRewardLogTable()
    return loginRewardLogTable[rewardId]
end

function DataManager:onGetLoginRewardLogList(event)
    local s2cGetLoginRewardLogList = event.data
    lt.CommonUtil.print("s2cGetLoginRewardLogList OK")
    -- lt.CommonUtil.print("s2cGetLoginRewardLogList content\n"..tostring(s2cGetLoginRewardLogList))

    local loginRewardLogTable = self:getLoginRewardLogTable()
    local scAddLoginRewardLogArray = s2cGetLoginRewardLogList.add_login_reward_log_array
    for _,scLoginRewardLog in ipairs(scAddLoginRewardLogArray) do
        local cmnLoginRewardLog = lt.CmnLoginRewardLog.new(scLoginRewardLog)
        loginRewardLogTable[cmnLoginRewardLog:getRewardId()] = cmnLoginRewardLog
    end

    local loginRewardLogTable = self:getLoginRewardLogTable()
    local scSetLoginRewardLogArray = s2cGetLoginRewardLogList.set_login_reward_log_array
    for _,scLoginRewardLog in ipairs(scSetLoginRewardLogArray) do
        local cmnLoginRewardLog = lt.CmnLoginRewardLog.new(scLoginRewardLog)
        loginRewardLogTable[cmnLoginRewardLog:getRewardId()] = cmnLoginRewardLog
    end

    lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_ACCUMULATE_LOGIN, {status = 1})
end

-- 累积登陆活动登陆天数
function DataManager:getActivityAccumulateLoginCount()
    local activityAccumulateLoginTable = self:getActivityAccumulateLoginTable()
    return #(activityAccumulateLoginTable[lt.Constants.BATCH_ACTIVITY_ID.ACCUMULATE_LOGIN] or {})
end

-- ############################## 首冲红包 ##############################
function DataManager:getMstActivityFirstChargeTable(clear)
    if not self._mstActivityFirstChargeTable or clear then
        self._mstActivityFirstChargeTable = {}
    end

    return self._mstActivityFirstChargeTable
end

function DataManager:getMstActivityFirstChargeArray()
    if not self._mstActivityFirstChargeArray then
        self._mstActivityFirstChargeArray = {}
    end

    return self._mstActivityFirstChargeArray
end

function DataManager:onGetMstActivityFirstChargeList(event)
    local s2cGetMstActivityFirstChargeList = event.data
    lt.CommonUtil.print("s2cGetMstActivityFirstChargeList OK")
    -- lt.CommonUtil.print("s2cGetMstActivityFirstChargeList content\n"..tostring(s2cGetMstActivityFirstChargeList))

    local mstActivityFirstChargeTable = self:getMstActivityFirstChargeTable(true)
    self._mstActivityFirstChargeArray = {}

    local scMstActivityFirstChargeArray = s2cGetMstActivityFirstChargeList.data_array
    for idx,scMstActivityFirstCharge in ipairs(scMstActivityFirstChargeArray) do
        local mstActivityFirstCharge = lt.MstActivityFirstCharge.new(scMstActivityFirstCharge)

        mstActivityFirstChargeTable[mstActivityFirstCharge:getId()] = mstActivityFirstCharge

        self._mstActivityFirstChargeArray[idx] = mstActivityFirstCharge
    end

    table.sort(self._mstActivityFirstChargeArray, function(mstActivityFirstCharge1, mstActivityFirstCharge2)
        return mstActivityFirstCharge1:getId() < mstActivityFirstCharge2:getId()
    end)
end

-- 首冲红包
function DataManager:getActivityFirstChargeLoginCount()
    local activityAccumulateLoginTable = self:getActivityAccumulateLoginTable()
    return #(activityAccumulateLoginTable[lt.Constants.BATCH_ACTIVITY_ID.FIRST_CHARGE] or {})
end

-- ############################## 一起来嗨 ##############################
function DataManager:getMstActivityHappyTogetherTable(clear)
    if not self._mstActivityHappyTogetherTable or clear then
        self._mstActivityHappyTogetherTable = {}
    end

    return self._mstActivityHappyTogetherTable
end

function DataManager:getFirstMstActivityHappyTogether()
    local mstActivityHappyTogetherTable = self:getMstActivityHappyTogetherTable()
    for k,mstActivityHappyTogether in pairs(mstActivityHappyTogetherTable) do
        return mstActivityHappyTogether
    end

    return nil
end

function DataManager:onGetMstActivityHappyTogetherList(event)
    local s2cGetMstActivityHappyTogetherList = event.data
    lt.CommonUtil.print("s2cGetMstActivityFirstChargeList OK")
    -- lt.CommonUtil.print("s2cGetMstActivityHappyTogetherList content\n"..tostring(s2cGetMstActivityHappyTogetherList))

    local mstActivityHappyTogetherTable = self:getMstActivityHappyTogetherTable(true)

    local scMstActivityHappyTogetherArray = s2cGetMstActivityHappyTogetherList.data_array
    for _,scMstActivityHappyTogether in ipairs(scMstActivityHappyTogetherArray) do
        local mstActivityHappyTogether = lt.MstActivityHappyTogether.new(scMstActivityHappyTogether)

        mstActivityHappyTogetherTable[mstActivityHappyTogether:getId()] = mstActivityHappyTogether
    end  
end

-- ############################## 战力红包 ##############################
function DataManager:getMstActivityPowerTable(clear)
    if not self._mstActivityPowerTable or clear then
        self._mstActivityPowerTable = {}
    end

    return self._mstActivityPowerTable
end

function DataManager:getMstActivityPowerArray(clear)
    if not self._mstActivityPowerArray or clear then
        self._mstActivityPowerArray = {}
    end

    return self._mstActivityPowerArray
end

function DataManager:onGetMstActivityPowerList(event)
    local s2cGetMstActivityPowerList = event.data
    lt.CommonUtil.print("s2cGetMstActivityPowerList OK")
    -- lt.CommonUtil.print("s2cGetMstActivityPowerList content\n"..tostring(s2cGetMstActivityPowerList))

    local mstActivityPowerTable = self:getMstActivityPowerTable(true)
    local mstActivityPowerArray = self:getMstActivityPowerArray(true)
    local scMstActivityPowerArray = s2cGetMstActivityPowerList.data_array
    for _,scMstActivityPower in ipairs(scMstActivityPowerArray) do
        local mstActivityPower = lt.MstActivityPower.new(scMstActivityPower)
        mstActivityPowerTable[mstActivityPower:getId()] = mstActivityPower

        local amount = mstActivityPower:getAmount()
        if not isset(mstActivityPowerArray, amount) then
            mstActivityPowerArray[amount] = {}
        end
        mstActivityPowerArray[amount][#mstActivityPowerArray[amount] + 1] = mstActivityPower
    end  

    for amount,mstActivityPowerArray2 in ipairs(mstActivityPowerArray) do
        table.sort(mstActivityPowerArray2, function(mstActivityPower1, mstActivityPowe2)
            return mstActivityPower1:getPower() < mstActivityPower2:getPower()
        end)
    end
end

--女皇的贡品
function DataManager:getQueenTributeRewardArray(clear)
    if not self._queenTributeRewardList or clear then
        self._queenTributeRewardList = {}
    end
    return self._queenTributeRewardList
end

function DataManager:getMstActivityQueenTributeRewardList(event)
    local s2cGetMstActivityQueenTributeRewardList = event.data
    lt.CommonUtil.print("s2cGetMstActivityQueenTributeRewardList OK")
    --dump(tostring(s2cGetMstActivityQueenTributeRewardList))

    local QueenTributeRewardList = self:getQueenTributeRewardArray(true)

    if s2cGetMstActivityQueenTributeRewardList.data_array then
        for k,v in ipairs(s2cGetMstActivityQueenTributeRewardList.data_array) do
            local info = lt.QueenTributeReward.new(v)
            QueenTributeRewardList[#QueenTributeRewardList + 1] = info
        end
    end
end

function DataManager:getQueenTributeTable()
    if not self._getQueenTributeTable then
        self._getQueenTributeTable = {}
    end
    return self._getQueenTributeTable
end

function DataManager:getQueenTributeSubmitCount()
    local array = self:getQueenTributeTable()
    local count = 0
    for k,v in pairs(array) do
        if v:getFinished() == 1 then
            count = count + 1
        end
    end
    return count
end

function DataManager:getQueenTribute(event)
    local s2cGetQueenTribute = event.data
    lt.CommonUtil.print("s2cGetQueenTribute OK")
    --dump(tostring(s2cGetQueenTribute))
    local QueenTributeTable = self:getQueenTributeTable()
    if s2cGetQueenTribute.item_array then
        for k,v in ipairs(s2cGetQueenTribute.item_array) do
            local QueenTribute = lt.QueenTributeSubmit.new(v)
            QueenTributeTable[QueenTribute:getId()] = QueenTribute
        end
    end
    lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_QUEEN_TRIBUTE_SUBMIT)
end

function DataManager:getQueenTributeRewardLogInfo()
    if not self._getQueenTributeRewardLogInfo then
        self._getQueenTributeRewardLogInfo = {}
    end
    return self._getQueenTributeRewardLogInfo
end

function DataManager:getQueenTributeRewardLogList(event)
    local s2cGetQueenTributeRewardLogList = event.data
    lt.CommonUtil.print("s2cGetQueenTributeRewardLogList OK")
    --dump(tostring(s2cGetQueenTributeRewardLogList))
    local QueenTributeRewardLog = self:getQueenTributeRewardLogInfo()

    if s2cGetQueenTributeRewardLogList.add_queen_tribute_reward_log_array then
        for k,v in pairs(s2cGetQueenTributeRewardLogList.add_queen_tribute_reward_log_array) do
            if v.reward_id then
                local info = {}
                info["reward_id"] = v.reward_id
                info["reward_time"] = v.reward_time
                QueenTributeRewardLog[v.reward_id] = info
            end
        end
    end
end

function DataManager:updateQueenTributeRewardLogList(event)
    local s2cupdateQueenTributeRewardLogList = event.data
    lt.CommonUtil.print("s2cupdateQueenTributeRewardLogList OK")
    --dump(tostring(s2cupdateQueenTributeRewardLogList))

    local QueenTributeRewardLog = self:getQueenTributeRewardLogInfo()

    if s2cupdateQueenTributeRewardLogList.add_queen_tribute_reward_log_array then
        for k,v in ipairs(s2cupdateQueenTributeRewardLogList.add_queen_tribute_reward_log_array) do
            local info = {}
            info["reward_id"] = v.reward_id
            info["reward_time"] = v.reward_time
            QueenTributeRewardLog[v.reward_id] = info
        end
    end

end


-- cross server proto
function DataManager:onCrossTest(event)
    local s2cCrossTest = event.data
    print("s2cCrossTest OK code:"..s2cCrossTest.code)
end

















return DataManager

