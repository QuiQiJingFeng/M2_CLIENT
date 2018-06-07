
local Constants = {}

-- CG表示
Constants.CG_ON = false

Constants.GUIDE_AUTO_BATTLE_LEVEL = 2

--游戏类型
Constants.GAME_TYPE = {
    HZMJ = 1,--红中
    DDZ  = 2,--斗地主
    SQMJ  = 3,--商丘麻将
    TDH  = 4,--推倒胡
    PLZ  = 5, --飘癞子
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

-- if debug 47.52.99.120
Constants.HOST = "47.52.99.120"--"mengyagame.com"  --"192.168.0.100"
Constants.PORT = 80

return Constants
