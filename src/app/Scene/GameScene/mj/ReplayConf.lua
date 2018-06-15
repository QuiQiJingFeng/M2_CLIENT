local ReplayConf = {
deal_card = {evnet_name = "deal_card",data_manager = "insert"},--data_manager insert onlyone --发牌
push_draw_card = {evnet_name = "push_draw_card", filter_str = "card"},--通知其他人有人摸牌 
push_play_card = {evnet_name = "push_play_card", filter_str = "card_list"},--通知玩家该出牌了
notice_special_event = {evnet_name = "notice_special_event", data_manager = "onlyone"},----通知有人吃椪杠胡
notice_play_card = {evnet_name = "notice_play_card", data_manager = "onlyone"},--通知其他人有人出牌 
notice_game_over = {evnet_name = "notice_game_over", data_manager = "onlyone"},--结算
        }
function ReplayConf:processinsertData(info)
	local result = {}
	for i=1,#info do
		local table = json.decode(info[i])
		print("-----kkk")
		dump(table)
		result[i] = table
		--table.insert(result,table)
	end
	return result
end

function ReplayConf:processinsertDataOne(info)
	local result = {}

	dump(info)

	for i=1,#info do
		if i == 1 then--只取第一条
			result = info[i]
		end
	end
	return result

end

return ReplayConf