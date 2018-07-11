
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


Constants.PROMPT = {
    ["internal_error"] = "服务器繁忙,请稍后再试",
    ["no_server_info"] = "该服务器不存在",
    ["not_select_info"] = "用户信息查询失败,请稍后再试",
    ["error_request"] = "错误的请求",
    ["error_token"] = "请求验证失败",
    ["account_exist"] = "账户不存在",
    ["register_first"] = "请先完成注册",
    ["paramater_error"] = "参数错误",
    ["server_error"] = "服务器错误",
    ["key_exchange_failed"] = "密钥交换失败",
    ["other_player_login"] = "有其他玩家登陆此号",
    ["auth_faild"] = "校验失败",
    ["gold_not_enough"] = "金币不足",
    ["current_in_game"] = "当前在游戏当中",
    ["not_exist_room"] = "不存在该房间",
    ["not_in_room"] = "当前不在房间当中",
    ["round_not_enough"] = "局数不足",
    ["pos_has_player"] = "该位置已经有人坐了",
    ["already_sit"] = "当前已经入座成功,不需要重复入座",
    ["invaild_operator"] = "无效的操作",
    ["no_support_command"] = "无效的命令",
    ["no_permission_distroy"] = "没有权限解散房间",
    ["current_in_room"] = "当前在房间当中",
    ["no_position"] = "没有位置了",
    ["operator_error"] = "操作错误",
    ["in_four_cardlist"] = "亮四打一的牌不可以出",
    ["already_ting_card"] = "当前已经听牌,不能再次听牌",
    ["must_zimo"] = "当前必须自摸才能胡牌",
    ["can_not_hui_card"] = "不能出癞子牌",
    ["not_allow_ting"] = "不可以听牌",

}


-- if debug 47.52.99.120  "39.105.109.58"
Constants.HOST = "39.105.109.58"--"127.0.0.1"--"mengyagame.com"  --"192.168.0.100"
Constants.PORT = 80--3000

return Constants
