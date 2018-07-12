
local LanguageString = {}

--//////////////////////////普通文本////////////////////////////
LanguageString["STRING_GAME_NAME_1"] 			= "红中麻将"
LanguageString["STRING_GAME_NAME_2"]			= "斗地主"
LanguageString["STRING_GAME_NAME_3"]			= "商丘麻将"
LanguageString["STRING_GAME_NAME_4"]			= "飘癞子"
LanguageString["STRING_GAME_NAME_5"]			= "推倒胡"

LanguageString["DISTROY_ROOM_paramater_error"]			= "客户端参数错误"
LanguageString["DISTROY_ROOM_server_error"]				= "服务器错误"
LanguageString["DISTROY_ROOM_key_exchange_failed"]		= "密钥交换失败"
LanguageString["DISTROY_ROOM_other_player_login"]		= "其他玩家登陆"
LanguageString["DISTROY_ROOM_auth_faild"]		        = "校验失败"
LanguageString["DISTROY_ROOM_gold_not_enough"]			= "金币不足"
LanguageString["DISTROY_ROOM_current_in_game"]			= "当前在游戏当中"
LanguageString["DISTROY_ROOM_not_exist_room"]			= "不存在的房间"
LanguageString["DISTROY_ROOM_not_in_room"]			    = "当前不在房间中"
LanguageString["DISTROY_ROOM_sit_already_has"]			= "已经有人坐下"
LanguageString["DISTROY_ROOM_round_not_enough"]			= "圈数不足"
LanguageString["DISTROY_ROOM_pos_has_player"]			= "位置已经有人坐了"
LanguageString["DISTROY_ROOM_already_sit"]			    = "当前已经坐下了,不需要发送多次"
LanguageString["DISTROY_ROOM_invaild_operator"]			= "无效的操作"
LanguageString["DISTROY_ROOM_no_support_command"]		= "无效的命令"
LanguageString["DISTROY_ROOM_no_permission_distroy"]	= "没有权限解散房间"
LanguageString["DISTROY_ROOM_current_in_room"]			= "当前在房间当中"
LanguageString["DISTROY_ROOM_no_position"]			    = "没有位置了"

LanguageString["ROOM_COST_1"]			    			= "房主出资" --支付类型
LanguageString["ROOM_COST_2"]			    			= "玩家平摊"
LanguageString["ROOM_COST_3"]			    			= "赢家出资"

LanguageString["REPLAYCODETEXT"]			    		= "请输入回放码"
LanguageString["ROOM_OWNER_LEAVE"]			    		= "返回大厅您的房间扔会保留哦！"
LanguageString["ROOM_OWNER_DISBAND"]			    	= "解散房间不扣除金币，是否确定解散？"



LanguageString["PLAYER_NOT_GREEN_OVER"] = "玩家【%s】不同意解散房间,请继续游戏"

LanguageString["SENDTOZHANHJIINFO"] = "没有请求到战绩信息"

LanguageString["ROOM_ALREADY_DISTROY"] = "房间已被解散"

LanguageString["ROOM_ALREADY_DISTROY_BY_TIME"] = "游戏时间超时，房间已被解散"


--////////////////////提示文本////////////////////////
LanguageString["internal_error"] = "服务器繁忙,请稍后再试"
LanguageString["no_server_info"] = "该服务器不存在"
LanguageString["not_select_info"] = "用户信息查询失败,请稍后再试"
LanguageString["error_request"] = "错误的请求"
LanguageString["error_token"] = "请求验证失败"
LanguageString["account_exist"] = "账户不存在"
LanguageString["register_first"] = "请先完成注册"
LanguageString["paramater_error"] = "参数错误"
LanguageString["server_error"] = "服务器错误"
LanguageString["key_exchange_failed"] = "密钥交换失败"
LanguageString["other_player_login"] = "有其他玩家登陆此号"
LanguageString["auth_faild"] = "校验失败"
LanguageString["gold_not_enough"] = "金币不足"
LanguageString["current_in_game"] = "当前在游戏当中"
LanguageString["not_exist_room"] = "不存在该房间"
LanguageString["not_in_room"] = "当前不在房间当中"
LanguageString["round_not_enough"] = "局数不足"
LanguageString["pos_has_player"] = "该位置已经有人坐了"
LanguageString["already_sit"] = "当前已经入座成功,不需要重复入座"
LanguageString["invaild_operator"] = "无效的操作"
LanguageString["no_support_command"] = "无效的命令"
LanguageString["no_permission_distroy"] = "没有权限解散房间"
LanguageString["current_in_room"] = "当前在房间当中"
LanguageString["no_position"] = "没有位置了"
LanguageString["operator_error"] = "操作错误"
LanguageString["in_four_cardlist"] = "亮四打一的牌不可以出"
LanguageString["already_ting_card"] = "当前已经听牌,不能再次听牌"
LanguageString["must_zimo"] = "当前必须自摸才能胡牌"
LanguageString["can_not_hui_card"] = "不能出癞子牌"
LanguageString["not_allow_ting"] = "不可以听牌"

function LanguageString:getString(key)
	return LanguageString[key] or nil
end

return LanguageString