

-- ////////////////////////////////////////////////////////////////////
-- //                          _ooOoo_                               //
-- //                         o8888888o                              //
-- //                         88" . "88                              //
-- //                         (| ^_^ |)                              //
-- //                         O\  =  /O                              //
-- //                      ____/`---'\____                           //
-- //                    .'  \\|     |//  `.                         //
-- //                   /  \\|||  :  |||//  \                        //
-- //                  /  _||||| -:- |||||-  \                       //
-- //                  |   | \\\  -  /// |   |                       //
-- //                  | \_|  ''\---/''  |   |                       //
-- //                  \  .-\__  `-`  ___/-. /                       //
-- //                ___`. .'  /--.--\  `. . ___                     //
-- //              ."" '<  `.___\_<|>_/___.'  >'"".                  //
-- //            | | :  `- \`.;`\ _ /`;.`/ - ` : | |                 //
-- //            \  \ `-.   \_ __\ /__ _/   .-` /  /                 //
-- //      ========`-.____`-.___\_____/___.-`____.-'========         //
-- //                           `=---='                              //
-- //      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        //
-- //         佛祖保佑       永无BUG     永不修改                  //
-- ////////////////////////////////////////////////////////////////////
cc.KeyCodeKey =
{
    "KEY_NONE",
    "KEY_PAUSE",
    "KEY_SCROLL_LOCK",
    "KEY_PRINT",
    "KEY_SYSREQ",
    "KEY_BREAK",
    "KEY_ESCAPE",
    -- "KEY_BACK",
    "KEY_BACKSPACE",
    "KEY_TAB",
    "KEY_BACK_TAB",
    "KEY_RETURN",
    "KEY_CAPS_LOCK",
    "KEY_SHIFT",
    -- "KEY_LEFT_SHIFT",
    "KEY_RIGHT_SHIFT",
    "KEY_CTRL",
    -- "KEY_LEFT_CTRL",
    "KEY_RIGHT_CTRL",
    "KEY_ALT",
    -- "KEY_LEFT_ALT",
    "KEY_RIGHT_ALT",
    "KEY_MENU",
    "KEY_HYPER",
    "KEY_INSERT",
    "KEY_HOME",
    "KEY_PG_UP",
    "KEY_DELETE",
    "KEY_END",
    "KEY_PG_DOWN",
    "KEY_LEFT_ARROW",
    "KEY_RIGHT_ARROW",
    "KEY_UP_ARROW",
    "KEY_DOWN_ARROW",
    "KEY_NUM_LOCK",
    "KEY_KP_PLUS",
    "KEY_KP_MINUS",
    "KEY_KP_MULTIPLY",
    "KEY_KP_DIVIDE",
    "KEY_KP_ENTER",
    "KEY_KP_HOME",
    "KEY_KP_UP",
    "KEY_KP_PG_UP",
    "KEY_KP_LEFT",
    "KEY_KP_FIVE",
    "KEY_KP_RIGHT",
    "KEY_KP_END",
    "KEY_KP_DOWN",
    "KEY_KP_PG_DOWN",
    "KEY_KP_INSERT",
    "KEY_KP_DELETE",
    "KEY_F1",
    "KEY_F2",
    "KEY_F3",
    "KEY_F4",
    "KEY_F5",
    "KEY_F6",
    "KEY_F7",
    "KEY_F8",
    "KEY_F9",
    "KEY_F10",
    "KEY_F11",
    "KEY_F12",
    "KEY_SPACE",
    "KEY_EXCLAM",
    "KEY_QUOTE",
    "KEY_NUMBER",
    "KEY_DOLLAR",
    "KEY_PERCENT",
    "KEY_CIRCUMFLEX",
    "KEY_AMPERSAND",
    "KEY_APOSTROPHE",
    "KEY_LEFT_PARENTHESIS",
    "KEY_RIGHT_PARENTHESIS",
    "KEY_ASTERISK",
    "KEY_PLUS",
    "KEY_COMMA",
    "KEY_MINUS",
    "KEY_PERIOD",
    "KEY_SLASH",
    "KEY_0",
    "KEY_1",
    "KEY_2",
    "KEY_3",
    "KEY_4",
    "KEY_5",
    "KEY_6",
    "KEY_7",
    "KEY_8",
    "KEY_9",
    "KEY_COLON",
    "KEY_SEMICOLON",
    "KEY_LESS_THAN",
    "KEY_EQUAL",
    "KEY_GREATER_THAN",
    "KEY_QUESTION",
    "KEY_AT",
    "KEY_CAPITAL_A",
    "KEY_CAPITAL_B",
    "KEY_CAPITAL_C",
    "KEY_CAPITAL_D",
    "KEY_CAPITAL_E",
    "KEY_CAPITAL_F",
    "KEY_CAPITAL_G",
    "KEY_CAPITAL_H",
    "KEY_CAPITAL_I",
    "KEY_CAPITAL_J",
    "KEY_CAPITAL_K",
    "KEY_CAPITAL_L",
    "KEY_CAPITAL_M",
    "KEY_CAPITAL_N",
    "KEY_CAPITAL_O",
    "KEY_CAPITAL_P",
    "KEY_CAPITAL_Q",
    "KEY_CAPITAL_R",
    "KEY_CAPITAL_S",
    "KEY_CAPITAL_T",
    "KEY_CAPITAL_U",
    "KEY_CAPITAL_V",
    "KEY_CAPITAL_W",
    "KEY_CAPITAL_X",
    "KEY_CAPITAL_Y",
    "KEY_CAPITAL_Z",
    "KEY_LEFT_BRACKET",
    "KEY_BACK_SLASH",
    "KEY_RIGHT_BRACKET",
    "KEY_UNDERSCORE",
    "KEY_GRAVE",
    "KEY_A",
    "KEY_B",
    "KEY_C",
    "KEY_D",
    "KEY_E",
    "KEY_F",
    "KEY_G",
    "KEY_H",
    "KEY_I",
    "KEY_J",
    "KEY_K",
    "KEY_L",
    "KEY_M",
    "KEY_N",
    "KEY_O",
    "KEY_P",
    "KEY_Q",
    "KEY_R",
    "KEY_S",
    "KEY_T",
    "KEY_U",
    "KEY_V",
    "KEY_W",
    "KEY_X",
    "KEY_Y",
    "KEY_Z",
    "KEY_LEFT_BRACE",
    "KEY_BAR",
    "KEY_RIGHT_BRACE",
    "KEY_TILDE",
    "KEY_EURO",
    "KEY_POUND",
    "KEY_YEN",
    "KEY_MIDDLE_DOT",
    "KEY_SEARCH",
    "KEY_DPAD_LEFT",
    "KEY_DPAD_RIGHT",
    "KEY_DPAD_UP",
    "KEY_DPAD_DOWN",
    "KEY_DPAD_CENTER",
    "KEY_ENTER",
    "KEY_PLAY",
}

cc.KeyCodeIdx =
{
}

for k,v in ipairs(cc.KeyCodeKey) do
    cc.KeyCodeIdx[v] = k - 1
end

cc.KeyCodeIdx.KEY_BACK = cc.KeyCodeIdx.KEY_ESCAPE

cc.KeyCodeStr = {
    KEY_LEFT_ARROW        = '←',
    KEY_RIGHT_ARROW       = '→',
    KEY_UP_ARROW          = '↑',
    KEY_DOWN_ARROW        = '↓',
    KEY_F1                = 'F1',
    KEY_F2                = 'F2',
    KEY_F3                = 'F3',
    KEY_F4                = 'F4',
    KEY_F5                = 'F5',
    KEY_F6                = 'F6',
    KEY_F7                = 'F7',
    KEY_F8                = 'F8',
    KEY_F9                = 'F9',
    KEY_F10               = 'F10',
    KEY_F11               = 'F11',
    KEY_F12               = 'F12',
    KEY_SPACE             = 'SPACE',
    KEY_EXCLAM            = '!',
    KEY_QUOTE             = '"',
    KEY_NUMBER            = '#',
    KEY_DOLLAR            = '$',
    KEY_PERCENT           = '%',
    KEY_CIRCUMFLEX        = '^',
    KEY_AMPERSAND         = '&',
    KEY_APOSTROPHE        = '\'',
    KEY_LEFT_PARENTHESIS  = '(',
    KEY_RIGHT_PARENTHESIS = ')',
    KEY_ASTERISK          = '*',
    KEY_PLUS              = '+',
    KEY_COMMA             = ',',
    KEY_MINUS             = '-',
    KEY_PERIOD            = '.',
    KEY_SLASH             = '/',
    KEY_0                 = '0',
    KEY_1                 = '1',
    KEY_2                 = '2',
    KEY_3                 = '3',
    KEY_4                 = '4',
    KEY_5                 = '5',
    KEY_6                 = '6',
    KEY_7                 = '7',
    KEY_8                 = '8',
    KEY_9                 = '9',
    KEY_COLON             = ':',
    KEY_SEMICOLON         = ';',
    KEY_LESS_THAN         = '<',
    KEY_EQUAL             = '=',
    KEY_GREATER_THAN      = '>',
    KEY_QUESTION          = '?',
    KEY_AT                = '@',
    KEY_LEFT_BRACKET      = '[',
    KEY_BACK_SLASH        = '\\',
    KEY_RIGHT_BRACKET     = ']',
    KEY_UNDERSCORE        = '_',
    KEY_GRAVE             = '`',
    KEY_A                 = 'A',
    KEY_B                 = 'B',
    KEY_C                 = 'C',
    KEY_D                 = 'D',
    KEY_E                 = 'E',
    KEY_F                 = 'F',
    KEY_G                 = 'G',
    KEY_H                 = 'H',
    KEY_I                 = 'I',
    KEY_J                 = 'J',
    KEY_K                 = 'K',
    KEY_L                 = 'L',
    KEY_M                 = 'M',
    KEY_N                 = 'N',
    KEY_O                 = 'O',
    KEY_P                 = 'P',
    KEY_Q                 = 'Q',
    KEY_R                 = 'R',
    KEY_S                 = 'S',
    KEY_T                 = 'T',
    KEY_U                 = 'U',
    KEY_V                 = 'V',
    KEY_W                 = 'W',
    KEY_X                 = 'X',
    KEY_Y                 = 'Y',
    KEY_Z                 = 'Z',
    KEY_LEFT_BRACE        = '{',
    KEY_BAR               = '|',
    KEY_RIGHT_BRACE       = '}',
    KEY_TILDE             = '~',
}


local Constants = {}

-- 广电总局版
Constants.GDZJ = gdzj

-- 齐刘海判断(IphoneX)
Constants.IPHONEX = lt.CommonUtil:isDeviceIphoneX()
-- Constants.IPHONEX = true

Constants.IPHONEX_PADDING = 50 -- IPHONEX适配间隔
Constants.IPHONEX_TOUCH_OFFSETY = 30

Constants.EXTRA_MD5 = "PW0YEzEfy7V1O4ACK37cNhAf3cwL1Ui1"

Constants.BACKGROUND_RESET_TIME      = 300 -- 游戏进入后台重置时间
Constants.BACKGROUND_RESET_TIME_TEAM = 0 -- 游戏进入后台重置时间 组队

Constants.DEFAULT_FPS = 60 -- 游戏默认帧率

Constants.SOCKET_WAITING = 10 -- Socket最长等待时间 超时重置游戏

--最大精力值
Constants.MAX_ENERGY = 2000

--宝石的typeValue
Constants.GEM_TYPE_VALUE = 11

--连续请求时间间隔
Constants.SOCKET_INTERVAL = 0.3

--系统的ID
Constants.SYSTEM_CHAT_ID = 1

--发红包等级
Constants.SEND_PACKET_LEVEL = 40
--领取红包等级
Constants.GET_PACKET_LEVEL = 30
--背包仓库最大数量
Constants.BAG_STORAGE_MAX_NUM = 10
--背包免费仓库数量
Constants.BAG_FREE_STORAGE_NUM = 2
--背包仓库开启需要花费银币数量
Constants.UNLOCK_COST_COIN = 1000000
--背包最大格数
Constants.BAG_MAX_SIZE = 72

--红包金色金额
Constants.RED_PACKET_GOLD_VALUE = 5000000

--表情最大ID
Constants.EMIOY_MAX_ID = 54

-- 世界人物上限
Constants.WORLD_PLAYER_MAX = 30

-- 开启等级
Constants.SHOP_CLUB_LEVEL               = 13 -- 商会开启等级
Constants.RANK_OPEN_LEVEL               = 15 -- 排行榜开启等级
Constants.GUILD_OPEN_LEVEL              = 18 -- 公会开启等级
Constants.GEM_MOUTING_LEVEL             = 20 -- 宝石开启等级
Constants.EGG_OPEN_LEVEL                = 25 -- 扭蛋开启等级
Constants.EQUIP_MAKE_LEVEL              = 30 -- 装备打造
Constants.BATTLE_FIELD_LEVEL            = 30 -- 战场开放等级

Constants.MONSTER_PURIFICATION_FIELD    = 30 -- 魔物净化野外开启等级
Constants.MONSTER_PURIFICATION          = 50 -- 魔物净化副本开启等级
Constants.MONSTER_LEVEL                 = math.min(Constants.MONSTER_PURIFICATION_FIELD, Constants.MONSTER_PURIFICATION) -- 魔物净化开启等级

Constants.STALL_OPEN_LEVEL              = 32 -- 黑市摆摊开放等级
Constants.TRUMPET_OPEN_LEVEL            = 32 -- 喇叭开启等级
Constants.GUILD_BOSS_GOTO_LEVEL         = 35 -- 公会boss挑战等级
Constants.EQUIP_ENCHANT_LEVEL           = 40 -- 装备附魔等级需求
Constants.LIFESKILL_LEVEL               = 40 -- 生活技能
Constants.ALCHEMY_OPEN_LEVEL            = 40 -- 炼金术开启等级
Constants.RUNE_LEVEL                    = 50 -- 符文开启等级
Constants.RUNE_BOX_OPEN_LEVEL           = 50 -- 符文宝箱开启等级
Constants.SERVANT_COMMENT_OPEN_LEVEL    = 50 -- 英灵品论
Constants.SERVANT_BOUND_OPEN_LEVEL      = 50 -- 英灵羁绊
Constants.EQUIP_STREBGTH_LEVEL          = 60 -- 装备精炼等级需求

--玩家血池上限
Constants.PLAYER_BLOOD_MAX = 100000

--活跃度开启宝箱点数
Constants.ACTIVITY_OPEN_BOX_POINT = 30

--聊天时间间隔
Constants.WORLD_CHAT_TIME = 30
Constants.TRUMPET_CHAT_TIME = 3
Constants.WORLD_CHAT_LEVEL = 15
Constants.WORLD_CHAT_COST = 500
Constants.TRUMPET_CHAT_LEVEL = 32

-- 福利活动关闭
Constants.ACTIVITY_ID = {
    SEVENDAYSSIGN   = 1, -- 连续签到
    LEVELUP         = 2, -- 升级有礼
    GROW_TASK       = 3, -- 成长任务
    FIGHT_REWARD    = 4, -- 战力达人
    LEVELING_REWARD = 5, -- 沖级达人
}

Constants.BATCH_ACTIVITY_ID = {
    ACCUMULATIVE_RECHARGE = 1,  -- 累积充值
    ACCUMULATIVE_COST     = 2,  -- 累积消费
    ADVENTURER_REWARD     = 3,--  冒险者宝藏
    MORE_AND_MORE         = 4,  -- 多买多送
    DAILY_TOTAL_CHARGE    = 5,  -- 每日累充
    BACK_GIFT             = 6,  -- 回流礼包
    ACCUMULATE_LOGIN      = 7,  -- 累积登录
    FIRST_CHARGE          = 8,  -- 首充
    HAPPY_TOGETHER        = 9,  -- 一起嗨
    POWER                 = 10, -- 战力
    SPECIAL_PACKET        = 11, -- 特惠礼包
    QUEEN_TRIBUTE         = 12, --女王的贡品
}

--人物战力提升
Constants.PROMOTE = {
    SKILL     =   1,
    GEM       =   2,
    SITE      =   3,
    TALENT    =   4,
}

--推送活动TAG
Constants.ACTIVITY_PUSH_TAG = {
    TREASURE    =   1,  --魔物净化
    GUIARD      =   2,  --守卫遗迹
    PK          =   3,  --PK
    WORLD_BOSS  =   4,  --野外boss
    
}

--好友里面系统消息分类
Constants.SYSTEM_FRIEND_TYPE = {
    RISK_TEAM_ADD   =  1,
    RISK_TEAM_DEL   =  2,
    OFFLINE_EXP     =  3,
    TRADING         =  4,
    FRIEND_NAME_EXCHANGE =  5,
    RISK_TEAM_EXIT   = 6,
    GET_GIFT        = 7,
    RISK_TEAM_CHANGE_NAME = 8,
}

--装备打造区间
Constants.EQUIPMAKE_RANGE_MIN = 0.45
Constants.EQUIPMAKE_RANGE_MAX = 1

-- 难度
Constants.DIFFICULTY = {
    NONE    = -1, -- 用于难度选择中的全部
    NORMAL  = 0,  -- 普通
    HARD    = 1,  -- 困难
    CRAZY   = 2   -- 地狱(尚未开启)
}

Constants.ZONE_TYPE = {
    OWN     = 0, --自己空间
    OTHERS  = 1  --别人空间
}

Constants.MONTH_CARD_ID  =  198--月卡id
Constants.FOREVER_CARD_ID  =  199--终身卡id

-- 好友状态
Constants.FRIEND_STATUS ={
    NOT_ONLINE    = 0, -- 不在线
    ONLINE        = 1, -- 空闲中
    INROOM        = 2, -- 房间中
    FIGHTING      = 3, -- 战斗中
}

-- 实例类别
Constants.ENTITY_TYPE = {
    ROLE         = 10000, -- 角色实例

    HERO         = 1,
    SERVANT      = 10,
    MONSTER      = 20,
    MONSTER_TEAM = 21,
    MAP          = 1000,
    ENV          = 2000
}

-- 地图区域格子类型
Constants.BLOCK_TYPE_NONE          = 0
Constants.BLOCK_TYPE_NORMAL        = 1
Constants.BLOCK_TYPE_THROUGH       = 2
Constants.BLOCK_TYPE_NORMAL_LEFT   = 3
Constants.BLOCK_TYPE_NORMAL_RIGHT  = 4
Constants.BLOCK_TYPE_THROUGH_LEFT  = 5
Constants.BLOCK_TYPE_THROUGH_RIGHT = 6
Constants.BLOCK_TYPE_LADDER        = 7
Constants.BLOCK_TYPE_SLOPE_LEFT    = 8 -- 左低
Constants.BLOCK_TYPE_SLOPE_RIGHT   = 9 -- 右低

Constants.SLOPE_RATE = 0.7071067 -- 斜坡斜率 45°

-- 方向
Constants.DIRECTION = {
    INVALID = 0,
    RIGHT   = 1,
    UP      = 2,
    LEFT    = 3,
    DOWN    = 4
}

-- 边缘类型
Constants.EDGE_TYPE = {
    NONE  = -1,
    LEFT  = 0,
    RIGHT = 1
}

-- 控制
Constants.CONTROL_INVALID              = 0
Constants.CONTROL_BUTTON_ATTACK_START  = 1
Constants.CONTROL_BUTTON_ATTACK_END    = 2
Constants.CONTROL_BUTTON_JUMP          = 3
Constants.CONTROL_BUTTON_ROLL          = 4
Constants.CONTROL_BUTTON_SKILL_1       = 51
Constants.CONTROL_BUTTON_SKILL_2       = 52
Constants.CONTROL_BUTTON_SKILL_3       = 53
Constants.CONTROL_BUTTON_SKILL_4       = 54
Constants.CONTROL_BUTTON_SERVANT       = 79
Constants.CONTROL_BUTTON_POTION        = 99

Constants.CONTROL_BUTTON_DEBUG = 75

-- 键盘控制
Constants.KEY_CONTROL_UP          = "1"
Constants.KEY_CONTROL_DOWN        = "2"
Constants.KEY_CONTROL_LEFT        = "3"
Constants.KEY_CONTROL_RIGHT       = "4"
Constants.KEY_CONTROL_ATTACK      = "101"
Constants.KEY_CONTROL_JUMP        = "102"
Constants.KEY_CONTROL_ROLL        = "103"
Constants.KEY_CONTROL_POTION      = "104"
Constants.KEY_CONTROL_SERVANT     = "105"
Constants.KEY_CONTROL_SKILL_1     = "201"
Constants.KEY_CONTROL_SKILL_2     = "202"
Constants.KEY_CONTROL_SKILL_3     = "203"
Constants.KEY_CONTROL_SKILL_4     = "204"

Constants.KEY_CONTROL_TABLE = {
    [Constants.KEY_CONTROL_UP]        = tonumber(cc.KeyCodeIdx.KEY_W),
    [Constants.KEY_CONTROL_DOWN]      = tonumber(cc.KeyCodeIdx.KEY_S),
    [Constants.KEY_CONTROL_LEFT]      = tonumber(cc.KeyCodeIdx.KEY_A),
    [Constants.KEY_CONTROL_RIGHT]     = tonumber(cc.KeyCodeIdx.KEY_D),
    [Constants.KEY_CONTROL_ATTACK]    = tonumber(cc.KeyCodeIdx.KEY_H),
    [Constants.KEY_CONTROL_JUMP]      = tonumber(cc.KeyCodeIdx.KEY_J),
    [Constants.KEY_CONTROL_ROLL]      = tonumber(cc.KeyCodeIdx.KEY_K),
    [Constants.KEY_CONTROL_POTION]    = tonumber(cc.KeyCodeIdx.KEY_L),
    [Constants.KEY_CONTROL_SERVANT]   = tonumber(cc.KeyCodeIdx.KEY_P),
    [Constants.KEY_CONTROL_SKILL_1]   = tonumber(cc.KeyCodeIdx.KEY_Y),
    [Constants.KEY_CONTROL_SKILL_2]   = tonumber(cc.KeyCodeIdx.KEY_U),
    [Constants.KEY_CONTROL_SKILL_3]   = tonumber(cc.KeyCodeIdx.KEY_I),
    [Constants.KEY_CONTROL_SKILL_4]   = tonumber(cc.KeyCodeIdx.KEY_O),
}

-- 实例用层级(用于 特效前 特效后)
Constants.ENTITY_LAYER = {
    EFFECT_FRONT = 30000,
    EFFECT_BACK  = -30000,
}

--1:系统 2:世界 3:队伍 4:公会 5:空间 10:好友 11:答题派对 
--聊天类型
Constants.CHAT_TYPE = {
    SYSTEM     =  1,
    WORLD      =  2,
    TEAM       =  3,
    GUILD      =  4,
    ZONE       =  5,
    CURRENT    =  6,
    TRUMPET    =  7,
    RISK_TEAM  =  8,
    FRIEND     =  10,
    ANSWER_PARTY     =  11,
    RUNNIND_NOTICE     =  12,
}

Constants.CHAT_SUB_TYPE = {
    NONE                    = 0, -- 非系统频道的普通文本
    NORMAL                 = 1, -- 普通文本
    AUDIO                  = 2, -- 语音消息
    QUESTION               = 100, --答题
    EQUIP_STRENGTH_SUCCESS = 120, --装备强化至+11以上(包括+11)
    EQUIP_STRENGTH_FAIL    = 121, --装备强化至+12以上（包括+12）失败
    BOSS_GET               = 130, --打怪获取
    ITEM_OPEN              = 140, --道具开启
    ACTIVITY_1             = 141, --策划的藏宝库活动换取“策划的藏宝箱”道具。
    ACTIVITY_2             = 142, --海底寻宝活动中获得低级特性书
    ACTIVITY_4             = 144, --追击盗墓者活动的黄金宝箱和远古宝箱开出低级特性书/高级特性书。
    EQUIP_MAKE             = 151, --装备制作
    TRADE                  = 161, --摆摊出售
    TRADE_NORMAl           = 162, --摆摊正常出售
    GET_ITEM               = 163, --获得道具
    GET_EXP                = 164, --获得经验
    FRIEND_GIFT            = 171, --好友送礼
    RUNE_BOX               = 200, --符文宝箱
    EGG                    = 201, --扭蛋系统提示
    CREATE_OREANGE_ITEM    = 202,  --装备打造出橙装
    ACTIVITY_WORLD_BOSS_KILLED  = 203,  --野外打死boss
    ACTIVITY_WORLD_BOSS_FLUSH   = 204,  --野外boss刷新
    GOT_DRESS_TICKET   = 205,  --公会秘境 第八层获得时装兑换券
    ACTIVITY_WORLD_BOSS_HP_CHANGE   = 206,  --野外boss血量
    ACTIVITY_GUILD_BOSS_FLUSH    = 207,  --公会boss刷新
    ACTIVITY_GUILD_BOSS_LAST_ATTACK    = 208,  --公会boss最后一击
    ACTIVITY_GUILD_BOSS_KILLED    = 209,  --公会boss被击杀
    ACTIVITY_ULIMATE_CHALLENGE_LAST_ATTACK   = 210,  --极限挑战最后一击
    TREASURE_MAP       = 211, --藏宝图
    MAZE                = 212, --迷宫触发

    CREATE_RISK_TEAM       = 300, --战队
    RED_PACKET             = 400, --红包
    INVITE_ROOM            = 520, --组队邀请
    GUILD_CARNIVAL         = 567, --公会狂欢
    LINK_LINE              = 999, --发送装备,表情，英灵超连接
}

--[[
    1.空间
    2.查看信息
    3.赠送礼物
    4.加为好友
    5.删除好友
    6.申请入队
    7.邀请入队
    8.申请入会
    9.邀请入会
    10.发送消息
    11.移出列表
    12.转让队长
    13.请离队伍
    99.职务任命
    100.踢出工会
    101.任命成员
    102.任命精英
    103.任命副会长
    104.任命会长 
    ]]
Constants.FRIEND_TIPS_TYPE = {
    SHOWSPACE       =   1,
    FRIENDINFO      =   2,
    GIVEGIFT        =   3,
    ADDFRIEND       =   4,
    DELETEFRIEND    =   5,
    TEAMAPPLY       =   6,
    TEAMIVAITE      =   7,
    GUILDAPPLY      =   8,
    GUILDIVAITE     =   9,
    SENDMESSAGE     =   10,
    REMOVE          =   11,
    LEADERCHANGE    =   12,
    KICK_TEAM       =   13,
    TRANSFER_TEAM_HOST = 14,
    POSITIONS       =   99,
    KICK_GUILD      =   100,
    SET_OFFER_MEMBER            = 101,
    SET_OFFER_ELITE             = 102,
    SET_OFFER_VICE_PRESIDENT    = 103,
    SET_OFFER_PRESIDENT         = 104
}

-- 地图层级
Constants.TILE_SIZE          = 50   -- 砖块大小
Constants.TILE_SIZE_OPPOSITE = 0.02 -- 优化除法计算(/50 即为 *0.02)

Constants.LAYER_TYPE = {
    INVALID                     = 100000,

    SUPER_EFFECT_MAP_MASK       = 90000,          -- 地图遮罩层 (技能中屏幕闪白等)

    BATTLE_FONT                 = 80000,          -- 战斗文字
    BLOCK                       = 40000,          -- 编辑层
    WEATHER                     = 30000,          -- 天气环境层

    SUPER_FOREGROUND_EFFECT     = 22000,          -- 超前特效层
    SUPER_FOREGROUND_DECORATION = 21000,          -- 超前装饰层 (遮挡住英雄的柱子等)

    REWARD                      = 20000,          -- 掉落物品层

    FOREGROUND_NPC              = 19000,          -- 前景NPC

    EFFECT_HERO_FRONT           = 16100,          -- 人前特效层
    HERO                        = 16000,          -- 人层
    EFFECT_HERO_BACK            = 15900,          -- 人后特效层

    EFFECT_MONSTER_FRONT        = 14100,          -- 怪前特效层
    MONSTER                     = 14000,          -- 怪层
    EFFECT_MONSTER_BACK         = 13900,          -- 怪后特效层

    EFFECT_SERVANT_FRONT        = 13100,          -- 契约特效前层(调整到 怪物后)
    EFFECT_SERVANT_FRONT_REAL   = 13100,          -- 契约特效前层(调整到 怪物后)
    SERVANT                     = 13000,          -- 契约层
    EFFECT_SERVANT_BACK         = 12900,          -- 契约特效后层(调整到 怪物后)
    EFFECT_SERVANT_BACK_REAL    = 12900,          -- 契约特效前层(调整到 怪物后)

    BACKGROUND_NPC              = 12000,          -- 后景NPC(NPC 默认层级)

    EFFECT_MAP_MASK             = 10500,          -- 地图遮罩层 (技能中屏幕变黑等)

    FOREGROUND_MASK             = 5000,           -- 前景遮罩层
    TRIGGER                     = 3000,           -- 机关层
    FOREGROUND_DECORATION       = 2000,           -- 前装饰层 (在道路前, 但是在人物后)

    BASE                        = 0,              -- 道路层

    BACKGROUND_EFFECT           = -10000,         -- 背景装饰特效层
    BACKGROUND_DECORATION       = -11000,         -- 背景装饰层

    SUPER_BACKGROUND_EFFECT     = -11500,         -- 超背景特效层
    SUPER_BACKGROUND_MASK       = -11800,         -- 超后背景遮罩层
    SUPER_BACKGROUND_DECORATION = -12000,         -- 超后背景装饰层

    BACKGROUND                  = -13000,         -- 背景层

    SKY_EFFECT                  = -18000,         -- 天空特效层
    SKY_MASK                    = -19000,         -- 天空遮罩层
    SKY_DECORATION_0            = -20000,         -- 天空装饰层0 速率 0.8 (比如远景建筑)
    SKY_DECORATION_1            = -21000,         -- 天空装饰层1 速率 0.6 (比如云)
    SKY_DECORATION_2            = -21500,         -- 天空装饰层2 速率 0.4 
    SKY                         = -22000          -- 天空层
}

-- 伤害类型
Constants.DAMAGE_TYPE = {
    REAL        = -1,   -- 真实伤害(不受任何减免)
    NORMAL      = 0,    -- 普通伤害(物理)
    SKILL       = 1,    -- 技能伤害(法术)
}

-- 游戏常量定义
-- 环境变量 区分战斗/非战斗
Constants.ENV_GROUP = {
    INVALID  = 0,
    WORLD    = 1,
    DUNGEON  = 11,
    PK       = 12,
    SURVIVAL = 13,
    MAZE     = 14,
}

Constants.ENV_TYPE = {
    INVALID                 = 0,
    SE_DEBUG                = 9999, -- 程序测试
    GUIDE                   = 9998, -- 引导副本
    CITY                    = 1, -- 主城中
    FIELD                   = 2, -- 野外
    DUNGEON                 = 3, -- 主线地下城
    MONSTER_PURIFICATION    = 4, -- 活动-魔物净化
    ADVENTURE_TRIAL         = 5, -- 活动-冒险试炼
    TRANSCEND               = 6, -- 突破任务
    PITLORD                 = 7, -- 活动-深渊领主
    GUARD                   = 8, -- 活动-守卫遗迹
    TREASURE                = 9, -- 活动-魔王的宝藏
    GUILD_FAM               = 10, -- 活动-工会秘境
    FISHING                 = 11, -- 钓鱼场景
    CREAM_BOSS              = 12, -- 魔物入侵
    MONSTER_ATTACK          = 13, -- 怪物侵袭
    GUILD_BOSS              = 14, -- 公会Boss
    DEVIL_NEST              = 15, -- 魔王巢穴
    CRAZY_DOCTOR            = 16, -- 疯狂博士
    MAZE                    = 17, -- 迷宫
    NATION_ANSWER_PARTY     = 18, -- 语音答题(专用场景)
    ARENA_3V3               = 1000, -- 竞技场
    GUILD_HAPPY             = 1003, -- 公会狂欢
    GUILD                   = 2000, -- 公会领地
    WORLD_BOSS_FIELD        = 2001, -- 野外BOSS地图
    WORLD_BOSS              = 2002, -- 极限挑战
}

-- 跨服地图表
Constants.CROSS_ENV_TYPE_TABLE = {
    [Constants.ENV_TYPE.ARENA_3V3] = true,
    [Constants.ENV_TYPE.PITLORD]   = true,
}

Constants.GUIDE_MAP         = 99999
Constants.ARENA_MAP         = 50000

-- 职业
Constants.OCCUPATION = {
    QS       = 1, -- 骑士          knight
    MFS      = 2, -- 魔法师(法师)   magic
    JS       = 3, -- 祭司          priest
    BWLR     = 4, -- 宝物猎人(猎人) hunter
}

-- 属性
Constants.PROPERTY = {
    NIL    = 0,
    FIRE   = 1,
    WATER  = 2,
    WIND   = 3,
    LIGHT  = 4,
    DARK   = 5,
}

-- 是否使用砖石兑换金币，然后金币再兑换银币，然后再使用银币
Constants.CURRENCY_EXCHANGE_TYPE_FLAG = 1

-- 英灵卡牌尺寸
Constants.SERVANT_SIZE = {
    S = cc.size(96, 96),
    M = cc.size(188, 252),
    L = cc.size(422, 564),
}

--道具品质新
Constants.QUALITY = {
    QUALITY_WHITE  = 1,
    QUALITY_GREEN  = 2,
    QUALITY_BLUE   = 3,
    QUALITY_PURPLE = 4,
    QUALITY_ORANGE = 5
}

-- 获取道具显示类型
Constants.GAIN_ITEM_TYPE = {
    ITEM             = 1,  -- 道具
    EQUIPMENT        = 2,  -- 装备
    SERVANT          = 3,  -- 英灵
    DRESS            = 4,  -- 时装
    DECORATION       = 5,  -- 装饰
    RUNE             = 6,  -- 符文
    GOLD             = 9,  -- 金币
    COIN             = 10, -- 银币
    DIAMOND          = 11, -- 钻石
    EXP              = 12, -- 经验
    -- VIP_EXP          = 13, -- VIP经验
    -- EXERCISE_ROUND   = 14, -- 幻境历练
    GUILD_SCORE      = 15, -- 公会点数
    ENERGY           = 16, -- 精力
    -- RUNE_COIN        = 17, -- 符文碎片
    Z_CURRENCY       = 18, -- Z币
    EXPERIENCE_SCORE = 19, -- 历练积分
    RUNE_PIECE       = 20, -- 符文碎片
    COMPETION_SCORE  = 21, -- 竞技积分
    GOODMAN_POINT    = 22, -- 好人卡点数
    -- GOODMAN_POINT   = 666, -- 好人卡点数
}

-- 道具类型
Constants.ITEM_TYPE = {
    MATERIAL            = 1,  -- 材料
    PAPER               = 2,  -- 图纸
    CONSUME             = 3,  -- 消耗类
    TREASURE            = 4,  -- 宝箱
    PACKAGE             = 5,  -- 包裹
    VALUE               = 6,  -- 值类型
    EQUIP_TICKET        = 7,  -- 装备强化类
    CHARACTER_SCROLL    = 8,  -- 英灵特性书
    FIGHT_COST          = 9,  -- 战斗消耗
    RUNE                = 10, -- 神符
    DECORATION          = 11, -- 个性装饰
    TASK                = 13, -- 任务道具
    MEDICAMENT          = 14, -- 药剂
    SPCIAL_REWARD       = 15, -- 特殊抽奖宝箱
    BLOOD               = 16, -- 血池
    BUFF_ITEM           = 17, -- buff道具
    DOUBLE_EXP          = 18, -- 双倍经验
    EQUIP_REWARD        = 19, -- 装备抽奖宝箱类
    RUNE_REWARD         = 20, -- 符文抽奖宝箱类
    CARD_INFO           = 21, -- 月卡终身卡
    GIFT                = 22, -- 礼物
    TITLE               = 23, -- 称号
}

-- 道具值类型
Constants.ITEM_VALUE_TYPE = {
    DIAMOND             = 1, -- 砖石
    COIN                = 2, -- 银币
    GOLD                = 3, -- 金币
    VIP_EXP             = 4, -- vip经验
    EXP                 = 5, -- 经验
    Z_CURRENCY          = 6, -- z币
    MONEY               = 9, -- 人民币
    GUILD_SCORE         = 11, -- 工会积分
    COMPETION_SCORE     = 12, -- 竞技积分
    RISK_SCORE          = 13, -- 冒险者积分
    EXPERIENCE_SCORE    = 14, -- 历练积分
    GOODMAN_SCORE       = 15, -- 好心值
    ENERGY              = 16, -- 精力
    FURNACE             = 17, -- 熔炉经验
    LIVE                = 18, -- 生活技能熟练度
    SERVANT_EXP         = 19, -- 英灵经验
    HONOR_SCORE         = 21, -- 荣誉
}

-- 材料值类型
Constants.MATERIAL_ITEM_VALUE_TYPE = {
    ENCHANT           = 3,  -- 附魔材料
    BAPTIZE           = 8,  -- 洗炼
    STRENGTHEN        = 9,  -- 精炼
    BUILDER           = 10, -- 装备打造符
    ORE               = 13, -- 矿石
    MASTER_TICKET     = 15, -- 大师工匠券
}

-- 装备类型
Constants.EQUIPMENT_TYPE = {
    INVALID     = 0,
    WEAPON      = 1,
    ASSISTANT   = 2,
    HELMET      = 3,
    CLOTHES     = 4,
    TROUSERS    = 5,
    SHOES       = 6,
    NECKLACE    = 7,
    RING        = 8,
    BELT        = 9,
    ORNAMENT    = 10
}

-- 默认装备
Constants.DEFAULT_EQUIPMENT = {
    QS_WEAPON      = 50000, -- 骑士默认武器
    QS_ASSISTANT   = 60000, -- 骑士默认专属
    MFS_WEAPON     = 51000, -- 法师默认武器
    MFS_ASSISTANT  = 61000, -- 法师默认专属
    JS_WEAPON      = 53000, -- 祭司默认武器
    JS_ASSISTANT   = 63000, -- 祭司默认专属
    BWLR_WEAPON    = 52000, -- 猎魔默认武器
    BWLR_ASSISTANT = 62000, -- 猎魔默认专属
}

-- 属性类型定义
Constants.ATTRIBUTE = {
    ATTACK          = 1,  -- 普通攻击
    SKILL_ATTACK    = 2,  -- 技能攻击
    ARMOR           = 3,  -- 护甲
    HEALTH          = 4,  -- 生命
    MP              = 5,  -- 魔法
    MP_RECOVER      = 6,  -- 魔法恢复
    RESILIENCE      = 7,  -- 韧性
    PARRY           = 8,  -- 格挡 万分比
    CRITICAL_DAMAGE = 9,  -- 暴伤值
    CRITICAL        = 10, -- 暴击值
    SHIELD          = 11, -- 护盾值
    ENDURE          = 12, -- 霸体值
    ANTI_ENDURE     = 13, -- 破坏值
    MOVE_SPEED      = 14, -- 移动速度
    FIRE            = 20, -- 火属性修正 万分比
    WATER           = 21, -- 水属性修正 万分比
    WIND            = 22, -- 风属性修正 万分比
    LIGHT           = 23, -- 光属性修正 万分比
    DARK            = 24, -- 暗属性修正 万分比
    THREAT          = 25, -- 仇恨值

    EXTRA_SKILL_LEVEL = 100, -- 额外技能等级
    SERVANT_SKILL_CD = 1000, -- 英灵技能冷却缩减：10000为100%
}

-- 主城
Constants.MAP = {
    ZQXZ            = 1,     -- 蒸汽小镇
    YLSDG           = 2,     -- 亚历山大港
    GUILD           = 50,    -- 公会领地
    CRAZY_DOCTOR    = 10005, -- 疯狂博士实验室
    PK_3V3          = 50000, -- 武道场
    GUIDE           = 99999, -- 引导地图
}

Constants.DEFAULT_WORLD_MAP_ID = Constants.MAP.ZQXZ -- 默认初始地图(蒸汽小镇)

-- 特殊道具ID
Constants.ITEM = {
    Z_CURRENCY          = 6,   --z币
    RUNE_PIECE          = 15,  --符文碎片
    DIAMOND             = 17,  -- 钻石
    COIN                = 18,  -- 银币
    GOLD                = 19,  -- 金币
    EXP                 = 86,  -- 经验
    -- VIP_EXP             = 89,  -- VIP经验
    FANTASY_DUST        = 90,  -- 奇幻之尘
    DREAM_DUST          = 91,  -- 梦幻之尘
    SOUL_DUST           = 93,  -- 灵魂之尘
    TREASURE_MAP        = 174, -- 藏宝图
    REVIVE_COIN         = 175, -- 复活币
    PITLORD_CARD        = 176, -- 深渊领主通行证
    RISK_TEAM_NAME_CHANGE   = 201, -- 涂改液
    BAITS               = 460, -- 鱼饵
    COPPER_ORE          = 464, -- 铜矿
    SILVER_ORE          = 465, -- 银矿
    S_SILVER_ORE        = 466, -- 秘银矿
    POTION_1            = 498, -- 新手药剂
    DOUBLE_EXP          = 499, -- 双倍经验药水
    STRENGTHEN_MAKE     = 509, -- 大师工匠券
    PURE_CRYSTAL        = 510, -- 纯净水晶
    MATHEMATIC_CRYSTAL  = 511, -- 奥术水晶
    MAGIC_CRYSTAL       = 512, -- 魔化水晶
    GUILD_SCORE         = 514, -- 工会积分
    COMPETION_SCORE     = 515, -- 竞技积分
    RISK_SCORE          = 516, -- 冒险者积分
    EXPERIENCE_SCORE    = 517, -- 历练积分
    GOODMAN_SCORE       = 518, -- 好心值
    ENERGY              = 519, -- 精力
    ENERGY_USE_ITEM     = 523, -- 精力果实
    POTION_2            = 612, -- 初级药剂
    POTION_3            = 614, -- 中级药剂
    POTION_4            = 616, -- 高级药剂
    POTION_5            = 618, -- 强效药剂
    POTION_6            = 619, -- 大师药剂
    EGG_COIN            = 610, -- 扭蛋机代币
    TRUMPET             = 649, -- 喇叭
    HONOR_SCORE         = 700, --荣誉
}

-- 空间赠送礼物ID
Constants.SPACE_GIFT = {
    FLOWERS = 166, --玫瑰花
    CAR     = 167, --超级跑车
    HOUSE   = 168, --土豪别墅
}

--背包道具选择
Constants.BAGITEM = {
    ALL   = 0, -- 全部
    ITEM  = 1, -- 道具
    EQUIP = 2, -- 装备 
}

-- 兑换货币类型
Constants.CURRENCY_TYPE = {
    DIAMOND = 1,          -- 钻石
    COIN    = 2,          -- 银币
    GOLD    = 3,          -- 金币
} 

-- 商店类型
Constants.SHOP_TYPE = {
    SHOP         = 1, -- 商城
    BLACKSHOP    = 2, -- 黑市商店
    STALL        = 3, -- 摆摊
} 

-- 宝箱类型
Constants.BOX_TYPE = {
    SILVER         = 1, -- 白银
    GOLD           = 2, -- 黄金
    ANCIENT        = 3, -- 远古
} 
-- 交易状态
Constants.TRADING_STATUS = {
    PUBLIC   = 1, -- 公示
    ONSALE   = 2, -- 出售中
    DATEOUT  = 3, -- 过期
    HOLD     = 90, -- 截留
}

-- 任务目标类型
Constants.TASK_TARGET_TYPE = {
    DIALOG              = 1, -- 对话任务
    LOCATION            = 2, -- 到达指定地点
    KILL_MONSTER        = 3, -- 击杀怪物
    DONATE              = 4, -- 捐献
    COLLECT             = 5, -- 采集
    USE_ITEM            = 6, -- 使用道具
    COMPLETE_DUNGEON    = 7, -- 通关地下城
    LEVEL               = 8, -- 到达等级
    ENTER_DUNGEON       = 9, -- 进入地下城
    SKILL_LEVEL_UP      = 10, -- 技能升级
    SITE_STRENGTH       = 11, -- 部位强化
    ADD_FRIEND          = 12, -- 添加好友
    ADD_GUILD           = 13, -- 加入公会
    ADVENTURE_TASK      = 14, -- 冒险任务
    CHECK               = 15, -- 查看
    SEARCH              = 16, -- 搜索
    OPEN                = 17, -- 开启
    PITLORD             = 18, -- 深渊领主
    PK_3V3              = 19, -- 武道场
    DECLARE             = 20, -- 宣告
}

-- 任务自定义行为
Constants.CUSTOM_ACTION = {
    COLLECT                     = 1, -- 采集
    USE_ITEM                    = 2, -- 使用道具
    CHECK                       = 3, -- 查看
    SEARCH                      = 4, -- 搜索
    OPEN                        = 5, -- 开启
    TREASURE_MAP_DIG            = 6, -- 藏宝图挖掘
    DECLARE_GUILD_ANNOUNCEMENT  = 7, -- 宣读公会公告
}

-- 活动类别
Constants.ACTIVITY = {
    ADVENTURE_TRIAL         = 1,  -- 冒险试炼
    ADVENTURE_TASK          = 2,  -- 冒险任务
    MONSTER_PURIFICATION    = 3,  -- 魔物净化
    PITLORD                 = 4,  -- 深渊领主
 	WORLD_ANSWER            = 5, -- 世界答题
    TREASURE                = 6,  -- 魔王宝藏
    GUARD                   = 7,  -- 守卫遗迹
    GUILD_BUILD             = 8,  -- 公会建设
    GUILD_FAM               = 9,  -- 公会秘境
    ALCHEMY                 = 11, -- 炼金术
    FISHING                 = 12, -- 钓鱼发烧友
    -- MAGIC_PYRAMID           = 13, -- 神秘金字塔
    CREAM_BOSS              = 14, -- 魔物入侵
    GUILD_BOSS              = 15, -- 公会Boss
	DEVIL_NEST              = 16, -- 魔王巢穴
    WORLD_BOSS              = 17, -- 世界Boss
    CRAZY_DOCTOR            = 18, -- 疯狂博士
    ALL_QUESTION            = 19, -- 全名答题
    PK_3V3                  = 1000, -- 武道场
    FIELD_BOSS              = 1001, -- 野外boss
    MONSTER_ATTACK          = 1002, -- 怪物侵袭
    GUILD_HAPPY             = 1003, -- 公会狂欢
}

Constants.ADVENTURE_TRIAL_MAX_ROUND      = 10 -- 冒险试炼一次最大10轮
Constants.ADVENTURE_TRIAL_MAX_ROUND_HIGH = 20 -- 冒险试炼高收益20轮

Constants.ADVENTURE_TASK_MAX_ROUND_HIGH = 20 -- 冒险任务高收益20轮

-- NPC功能类别
Constants.NPC_FUNC = {
    ADVENTURE_TRIAL     = 1,  -- 冒险试炼
    ADVENTURE_TASK      = 3,  -- 冒险任务
    TRANSCEND_TASK      = 4,  -- 超越任务
    PITLORD             = 5,  -- 深渊领主
    TREASURE            = 6,  -- 魔王的宝藏
    GUARD               = 7,  -- 守卫遗迹
    GUILD_BUILD         = 9,  -- 公会建设
    GUILD_FAM           = 10, -- 公会秘境
    MONSTER_ATTACK      = 12, -- 怪物侵袭
    CREAM_BOSS          = 14, -- 魔物入侵
    GUILD_BOSS          = 15, -- 公会Boss
	DEVIL_NEST          = 16, -- 魔王巢穴
    WORLD_BOSS          = 17, -- 世界Boss
    CRAZY_DOCTOR        = 18, -- 疯狂博士
    RISK_TEAM_CREATE    = 20000, -- 组建战队
    RISK_TEAM_ADD       = 20001, -- 加入成员
    RISK_TEAM_MANAGER   = 20002, -- 管理战队
}

-- 特殊NPC
Constants.NPC = {
    -- special 占用NpcId位置
    ALCHEMY             = 11, -- 炼金术
    FISHING             = 12, -- 钓鱼

    ADVENTURE_TRIAL     = 500001,
    ADVENTURE_TASK      = 500002,
    TRANSCEND           = 500003, -- 突破任务Npc
    PITLORD             = 500005,
    TREASURE            = 500006,
    GUARD               = 500007,
    GUILD_BUILD         = 500011,
    GUILD_FAM           = 500012,
    DEVIL_NEST          = 500013,
    WORLD_BOSS          = 500014,
    GUILD_BOSS          = 500015,
    CRAZY_DOCTOR        = 500016,--疯狂博士
    RISK_TEAM           = 500017,
}

-- 公会成员
Constants.GUILD_OFFICE_LEVEL = {
    TRAINEE         = 0,       -- 实习生
    MEMBER          = 1,       -- 成员
    ELITE           = 2,       -- 精英
    VICE_PRESIDENT  = 3,       -- 副会长
    PRESIDENT       = 4        -- 会长
} 
--公会福利
Constants.GUILD_WELFARE_TYPE = {
    GUILD_SHOP      = 1,
    GUILD_ACTIVITY  = 2,
} 


-- 权限id
Constants.GUILD_AUTH_ID = {
    POST_MODIFY       = 1,       -- 职位修改
    POST_SET          = 2,       -- 设置职位
    ANNOUCEMENT       = 3,       -- 设置公告
    ACTIVITY          = 4,       -- 开启活动
    BATTLE            = 5,       -- 报名公会战
    JOIN              = 6,       -- 管理入会
    REMOVE            = 7,       -- 请离公会
    MERGE             = 8,       -- 合并处理
} 

-- 委托目标
Constants.GUILD_DELEGATE_TYPE = {
    SUBMIT_ITEM     = 1,       -- 上交道具
    KILL_MONSTER    = 2,       -- 击杀怪物
    ACCESS_NPC      = 3        -- 访问NPC
}

-- 平台
Constants.PLATFORM = {
    APPSTORE = 1,          -- appstore
}

Constants.HERO_LEVEL_MAX     = 79 -- 游戏开放最大等级
Constants.GAME_LEVEL_MAX     = 99 -- 版本最好等级

Constants.FRIEND_MAX         = 100
Constants.FRIEND_MATCH_LEVEL = 5 -- 推荐好友为向上5级

Constants.FISHING_ACTION = {
    [Constants.OCCUPATION.QS] = {
        [1] = 300001, -- 骑士钓鱼
        [2] = 300002, -- 骑士高级钓鱼
    },
    [Constants.OCCUPATION.MFS] = {
        [1] = 300003, -- 法师钓鱼
        [2] = 300004, -- 法师高级钓鱼
    },
    [Constants.OCCUPATION.JS] = {
        [1] = 300007, -- 猎魔钓鱼
        [2] = 300008, -- 猎魔高级钓鱼
    },
    [Constants.OCCUPATION.BWLR] = {
        [1] = 300005, -- 猎魔钓鱼
        [2] = 300006, -- 猎魔高级钓鱼
    },
}

-- UI 背景基础宽度
Constants.BGWIDTH = 1136
Constants.BGHEIGHT = 640

-- UI层级
Constants.ZORDER = {
    LOADING  = 100000000,    -- loading页面
    DOWNLOAD = 99999999,     -- 下载界面
    ALERT    = 10000000,     -- alert/commit/notice/tips
    DEBUG    = 9000000,      -- 测试页面

    MASK     = 888888,      -- 场景遮罩

    TOPINFO  = 500000,      -- 游戏上层消息(只显示 不影响点击)
    POPUP    = 200000,      -- 弹出消息
    -- 500 ~ 1000 UI层
    BOTTOMINFO  = 0,    -- 游戏底层信息(地下城邀请 再UI层以下)
}

-- UI 字体

-- UI 配置设定
--[[
    chs     简体中文
]]
Constants.LANGUAGE = "chs"

Constants.STRINGPATH    = "string/" .. Constants.LANGUAGE .."/string.lua"
Constants.STRINGFILE    = Constants.LANGUAGE..".string"

Constants.FONT          = "fonts/" .. Constants.LANGUAGE .. "/gameFont.TTF"
Constants.BMFONTPATH    = "fonts/" .. Constants.LANGUAGE .. "/"

Constants.FONT_SIZE1 = 22    -- 字体大小
Constants.FONT_SIZE2 = 24    -- 标题
Constants.FONT_SIZE3 = 20    -- 
Constants.FONT_SIZE4 = 18    
Constants.FONT_SIZE5 = 16
Constants.FONT_SIZE6 = 16    --走马灯的字体

--快捷购买类型
Constants.QUICK_BUY = {
    DIAMOND_SHOP    =  1,--钻石商城
    CRYSTAL_SHOP    =  2,--水晶商城
    SHOP_CLUB_COIN  =  3,--银币商城
    GUILD_SHOP      =  4,--工会积分
    COMPETION_SHOP  =  5,--竞技积分
    RISK_SHOP       =  6,--冒险者积分
    EXPERIENCE      =  7,--历练积分
    GOODMAN         =  8,--好心值积分
}

--获取途径所有类型
Constants.ACCESSMETHOD_TYPE = {
    QUICK_SHOP      =   1,  --快捷购买
    SHOP            =   2,  --商城
    SHOP_CLUB       =   3,  --商会
    GUILD_SHOP      =   4,  --公会积分商店
    COMPETION       =   5,  --竞技积分商店
    RISK_SHOP       =   6,  --冒险积分商店
    EXPERIENCE      =   7,  --历练积分商店
    GOODMAN         =   8,  --好心值商店
    STALL           =   9,  --摆摊
    RESOLVE         =   10, --分解
    COMPOSE         =   11, --合成
    FURNACE         =   12, --炼金炉
    LIVE_SHILL      =   13, --生活技能
    SPIRIT          =   14, --精灵
    Z_CURRENCY_SHOP =   15, --Z币商城
    EGG             =   16, --扭蛋机
}

-- UI 窗口定义
Constants.PANEL_PADDING = 7

Constants.UI_NEW_SIZE = {
    FULL   = cc.size(950, 590), -- 近全屏
    FULL_2 = cc.size(862, 590), -- 右边没有按钮的大界面
    MIDDLE = cc.size(706, 510), -- 中弹框
    SMALL  = cc.size(570, 350), -- 小弹框
    POP    = cc.size(590, 358), -- 小弹窗(tips)
}

-- UI 颜色定义
Constants.COLOR = {
    BLACK           = cc.c3b(25,  25,  25),
    BROWN           = cc.c3b(58,  33,  4),
    GREEN           = cc.c3b(35,  169, 3),
    RED             = cc.c3b(251, 27,  8),   -- 放在浅底
    WHITE           = cc.c3b(255, 255, 255),
    GRAY            = cc.c3b(123, 123, 123),
    YELLOW          = cc.c3b(255, 234, 0),
    BLUE            = cc.c3b(29,  165, 252),

    LIGHT_ORANGE    = cc.c3b(252, 139, 38),
    LIGHT_GRAY      = cc.c3b(200, 200, 200),
    LIGHT_YELLOW    = cc.c3b(246, 202, 7),
    LIGHT_BLUE      = cc.c3b(54, 159, 247),--装备打造里面
    LIGHT_GREEN     = cc.c3b(50, 161, 1),
    LIGHT_RED       = cc.c3b(254, 96, 129),
    LIGHT_PURPLE    = cc.c3b(192, 99, 206),
    LIGHT_GREY      = cc.c3b(101, 101, 101),

    DEEP_BLACK      = cc.c3b(24,  16,  8),

    NEW_RED         = cc.c3b(255, 73,  75),  -- 放在深底
    NEW_GREEN       = cc.c3b(85,  254, 1),   -- 放在深底
    NEW_BLUE        = cc.c3b(68,  248, 254), -- 放在深底
    NEW_ORANGE      = cc.c3b(253, 187, 44),  -- 放在深底

    SPACE_ORANGE    = cc.c3b(255, 121, 0),      --空间字的颜色
    SPACE_BROWN     = cc.c3b(144, 97, 48),

    ACCESS_METHOD   = cc.c3b(255, 255, 204),    -- 获取途径字颜色

    PROPERTY_RED    = cc.c3b(249, 4, 21),   --元素属性红色
    PROPERTY_BLUE   = cc.c3b(23, 119, 249), --元素属性蓝色
    PROPERTY_GREEN  = cc.c3b(4, 197, 13),   --元素属性红色
    PROPERTY_YELLOW = cc.c3b(224, 186, 9),  --元素属性黄色
    PROPERTY_PURPLE = cc.c3b(177, 6, 226),  --元素属性紫色

    NEW_GOLD        = cc.c3b(254, 252, 201), --金色

    CITY_CHAT_GREEN     = cc.c3b(168,255,129),    --主界面聊天字体颜色
    CITY_CHAT_RED       = cc.c3b(255,33,80),
    CITY_CHAT_YELLOW    = cc.c3b(255,230,128),
    CITY_CHAT_PURPLE    = cc.c3b(234,159,255),
    CITY_CHAT_ORANCE    = cc.c3b(255,144,35),
    CITY_CHAT_GRAY      = cc.c3b(194,229,245),
    CITY_CHAT_BLUE      = cc.c3b(89,195,255),

    PLACEHOLDER     = cc.c3b(166,166,166),

    NEW_GRAY        = cc.c3b(65, 65, 65), --白底上面的装备品质颜色

    QUALITY_WHITE   = cc.c3b(165, 165, 165),--装备品质
    QUALITY_GREEN   = cc.c3b(50, 161, 1),
    QUALITY_BLUE    = cc.c3b(54, 159, 247),
    QUALITY_PURPLE  = cc.c3b(192, 99, 206),
    QUALITY_ORANGE  = cc.c3b(255,162,0),

    CHAT_PLAYER_NAME = cc.c3b(96,227,255), --聊天玩家姓名

    EQUIP_BLACK     = cc.c3b(59,59,59), --装备打造附魔里面文字描边
    EQUIP_GREEN     = cc.c3b(168, 255, 129),
    EQUIP_DARK      = cc.c3b(46, 45, 45),
    EQUIP_RED       = cc.c3b(255, 159, 186),
    EQUIP_YELLOW    = cc.c3b(245, 255, 79),

    ACTIVIVE_BLUE   = cc.c3b(168, 255, 129), --淡绿色

    COMMON_BTN_OUTLINE_COLOR = cc.c3b(77,77,77), --通用按钮上面的字的描边


    BLACK_GRAY            = cc.c3b(116, 114, 115),

    --新数字字体颜色
    NUM_BLUE  = cc.c3b(110, 223, 255),
    NUM_RED   = cc.c3b(255,33,80),
    NUM_GREEN = cc.c3b(50,161,1),

    --符文的绿色
    RUNE_GREEN = cc.c3b(143,255,93),
    RUNE_BLACK = cc.c3b(24,24,24),
    MAIL_RED   = cc.c3b(254,96,129),
}

-- 默认字体颜色
Constants.DEFAULT_LABEL_COLOR_2 = Constants.COLOR.BLACK 

-- 网络
Constants.SERVER_DELTA_RANGE = 2 -- 与服务器差值为2s
Constants.SERVER_DELTA_TIME  = 3 -- 与服务器时差过大警报次数

-- 装备品质系数
Constants.BP_EQUIP_QUALITY = {
    [Constants.QUALITY.QUALITY_WHITE]   = 0.3,
    [Constants.QUALITY.QUALITY_GREEN]   = 0.5,
    [Constants.QUALITY.QUALITY_BLUE]    = 1,
    [Constants.QUALITY.QUALITY_PURPLE]  = 1.5,
    [Constants.QUALITY.QUALITY_ORANGE]  = 2,
}

Constants.OCCUPATION_SKILL_HERO_ARRAY = {
    [1]={2000,5000,4000,6000},
    [2]={7000,9000,12000,8000},
    [3]={19000,20000,21000,29000},
    [4]={13000,14000,18000,16000}
}

Constants.OCCUPATION_TALLENT_HERO_ARRAY = {
    [1]={23000,24000},
    [2]={25000,26000},
    [3]={22000,30000},
    [4]={27000,28000}
}

Constants.BP_EQUIP_ATTRIBUTE = 0.8 -- 额外加成
Constants.BP_EQUIP_ENCHANT   = 0.8 -- 附魔加成

Constants.EQUIPMENT_EXTRA_RATIO = 10 -- 0.1 * 100
Constants.EQUIPMENT_FULL_RATE   = 10000

Constants.TEAM_PLAYER_COUNT_MAX = 4 -- 组队最大人数

Constants.ALCHEMY_RESET_COST      = 100000 -- 炼金术重置材料消耗银币
Constants.ALCHEMY_MAX_RESET_COUNT = 5 -- 炼金术每日重置材料最大次数
Constants.ALCHEMY_MAX_USE_COUNT   = 70 -- 炼金术每周炼金次数

Constants.CONDITION_UNLOCK = {
    DRESS                 = 1,
    EQUIPMENT_TOTAL_LEVEL = 2,
    STONE_TOTAL_LEVEL     = 3,
    EQUIPMENT             = 4,
    EQUIPMENT_LEVEL       = 5
}

Constants.FIGURE_TYPE = {
    AVATER = 1,
    BUBBLE = 2
}

Constants.RISK_LEVEL = 20 -- 创建/参加战队需要20级
Constants.RISK_MEMBER_MAX = 8 -- 战队成员最多8人
Constants.RISK_CREATE_COST = 500000 -- 创建战队需要500000银币
Constants.RISK_JOIN_COST = 100000 -- 加入战队需要100000银币
Constants.RISK_EXIT_COST = 300000 -- 退出战队需要300000银币
Constants.RISK_EXIT_COUNTDOWN = 86400 -- 脱离战队需要24小时
-- Constants.RISK_EXIT_COUNTDOWN = 30 -- 脱离战队需要24小时


-- 资源类型
Constants.RESOURCE_FRAME = 1
Constants.RESOURCE_ARMATURE = 2

--称号类型
Constants.PLAYER_TITLE_TYPE = {
    LIFE_TITLE          = 1,--终身卡用户称号
    GUILD_TITLE          = 2,--公会专属称号
    TEAM_TITLE           = 3,--战队专属称号
}

-- CG表示
Constants.CG_ON = false

Constants.GUIDE_AUTO_BATTLE_LEVEL = 2

Constants.GAME_TYPE = {
    [1] = "红中麻将"
}

Constants.TEXTS = {
    [1] = "\n(房主)",
    [2] = "未开始\n(剩余%d分钟)",
    [3] = "游戏中",
    [4] = "游戏结束"
}

Constants.ROOM_STATE = {
    GAME_PREPARE = 1,   --游戏准备阶段
    GAME_PLAYING = 2,   --游戏中
    GAME_OVER = 3,      --游戏结束
}

Constants.HOST = "47.52.99.120"
Constants.PORT = 3000

return Constants
