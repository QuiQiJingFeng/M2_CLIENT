
local Constants = {}

-- CG表示
Constants.CG_ON = false

Constants.GUIDE_AUTO_BATTLE_LEVEL = 2

--游戏类型
Constants.GAME_TYPE = {
    HZMJ = 1,--红中
    DDZ  = 2,--斗地主
    SQMJ  = 3,--商丘麻将
    PLZ  = 4, --飘癞子
    TDH  = 5,--推倒胡
}

--类型转字符串
Constants.GAME_NAME = {
    [1] = "红中麻将",
    [2] = "斗地主",
    [3] = "商丘麻将",
    [4] = "山东麻将(飘癞子)",
    [5] = "推倒胡"
}

--通用常量配置
Constants["PAY_NAME"] = {
    [1] = "房主出资";     --房主出资
    [2] = "平摊";
    [3] = "赢家出资";
}

Constants.BASE_CARD_VALUE_TABLE = {
    1,2,3,4,5,6,7,8,9,
    11,12,13,14,15,16,17,18,19,
    21,22,23,24,25,26,27,28,29,
}

Constants.ADD_CARD_VALUE_TABLE1 = {
    35
}

Constants.ADD_CARD_VALUE_TABLE2 = {
    31,32,33,34,35,36,37,
}

Constants.ADD_CARD_VALUE_TABLE3 = {
    41,42,43,44,45,46,47,48
}

Constants.HONG_ZHONG_VALUE = 35

Constants.DIRECTION = {
	XI = 1,
	NAN = 2,
	DONG = 3,
	BEI = 4,
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


-- if debug 47.52.99.120  "39.105.109.58"
Constants.HOST = "39.105.109.58"--"127.0.0.1"--"mengyagame.com"  --"192.168.0.100"
Constants.PORT = 80--3000

return Constants
