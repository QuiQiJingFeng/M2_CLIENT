
--玩家战绩单个Layer
local ResultTotalEnditems = class("GmaeResultTotalEndLayer",function()
    return cc.CSLoader:createNode("game/mjcomm/gwidget/TotalResultitemLayer.csb")
end)

function ResultTotalEnditems:ctor(info,bigWinNum)
	 --[[
    message SattleItem{
    optional int32 user_id = 1;
    optional int32 user_pos = 2;
    optional int32 hu_num = 3;
    optional int32 ming_gang_num = 4;
    optional int32 an_gang_num = 5;
    optional int32 reward_num = 6;
}
//总结算
message NoticeTotalSattle {
    required int32 room_id = 1;
    repeated SattleItem sattle_list = 2;
}--]]
	self._node_Playernew = self:getChildByName("Node_Playernew")
	self._image_WinBg = self._node_Playernew:getChildByName("Image_WinBg")
	self._image_FailBg = self._node_Playernew:getChildByName("Image_FailBg")
	local roomInfo = lt.DataManager:getGameRoomInfo()

	if info.score > 0 then --大赢家
		self._image_WinBg:setVisible(true)
		self._image_FailBg:setVisible(false)
		
		local Sprite_TagEffect = self._image_WinBg:getChildByName("Sprite_TagEffect")
		Sprite_TagEffect:setVisible(true)

		local Se_BigWiner = self._image_WinBg:getChildByName("Se_BigWiner")
		if info.score == bigWinNum then --大赢家
			Se_BigWiner:setVisible(true)
		end

		local minggangTextbs = self._image_WinBg:getChildByName("Tt_Textbs_1")
		local angangTextbs = self._image_WinBg:getChildByName("Tt_Textbs_2")
		local rewardTextbs = self._image_WinBg:getChildByName("Tt_Textbs_3")

		minggangTextbs:setString("明杠次数：")
		angangTextbs:setString("暗杠次数：")
		rewardTextbs:setString("奖码次数：")

		local minggangText_num = self._image_WinBg:getChildByName("Tt_jiepao")
		local angangTextbs_num = self._image_WinBg:getChildByName("Tt_dianpao")
		local rewardTextbs_num = self._image_WinBg:getChildByName("Tt_zimo")
		if not info.ming_gang_num then
			info.ming_gang_num =0
		end
		if not info.an_gang_num then
			info.an_gang_num =0
		end
		if not info.reward_num then
			info.reward_num =0
		end

		minggangText_num:setString(info.ming_gang_num)
		angangTextbs_num:setString(info.an_gang_num)
		rewardTextbs_num:setString(info.reward_num)

		
		local Se_Head = self._image_WinBg:getChildByName("Se_Head")--头像

		local Al_TotalScore = self._image_WinBg:getChildByName("Al_TotalScore")
		Al_TotalScore:setString(info.score)

		local nameText = self._image_WinBg:getChildByName("Tt_PlayerInfo")--姓名
		local nameLabel = ""
		for k, v in ipairs(roomInfo.players) do
   			if v.user_id == info.user_id then
   				nameLabel = v.user_name
   			end
     	end
     	nameText:setString(nameLabel)


		local idText = self._image_WinBg:getChildByName("Tt_ID")
		idText:setString("ID: "..info.user_id)

	elseif info.score == 0 then	
		self._image_WinBg:setVisible(true)
		self._image_FailBg:setVisible(false)

		local Sprite_TagEffect = self._image_WinBg:getChildByName("Sprite_TagEffect")
		Sprite_TagEffect:setVisible(false)

		local Se_BigWiner = self._image_WinBg:getChildByName("Se_BigWiner")
		if info.score == bigWinNum then --大赢家
			Se_BigWiner:setVisible(true)
		end

		local minggangTextbs = self._image_WinBg:getChildByName("Tt_Textbs_1")
		local angangTextbs = self._image_WinBg:getChildByName("Tt_Textbs_2")
		local rewardTextbs = self._image_WinBg:getChildByName("Tt_Textbs_3")

		minggangTextbs:setString("明杠次数：")
		angangTextbs:setString("暗杠次数：")
		rewardTextbs:setString("奖码次数：")

		local minggangText_num = self._image_WinBg:getChildByName("Tt_jiepao")
		local angangTextbs_num = self._image_WinBg:getChildByName("Tt_dianpao")
		local rewardTextbs_num = self._image_WinBg:getChildByName("Tt_zimo")
		if not info.ming_gang_num then
			info.ming_gang_num =0
		end
		if not info.an_gang_num then
			info.an_gang_num =0
		end
		if not info.reward_num then
			info.reward_num =0
		end
		minggangText_num:setString(info.ming_gang_num)
		angangTextbs_num:setString(info.an_gang_num)
		rewardTextbs_num:setString(info.reward_num)

		
		local Se_Head = self._image_WinBg:getChildByName("Se_Head")--头像

		local Al_TotalScore = self._image_WinBg:getChildByName("Al_TotalScore")
		Al_TotalScore:setString(info.score)

		local nameText = self._image_WinBg:getChildByName("Tt_PlayerInfo")--姓名

		local nameLabel = ""
		for k, v in ipairs(roomInfo.players) do
   			if v.user_id == info.user_id then
   				nameLabel = v.user_name
   			end
     	end
     	nameText:setString(nameLabel)

		local idText = self._image_WinBg:getChildByName("Tt_ID")
		idText:setString("ID: "..info.user_id)


	elseif info.score < 0 then --输家
		self._image_WinBg:setVisible(false)
		self._image_FailBg:setVisible(true)

		local minggangTextbs = self._image_FailBg:getChildByName("Tt_Textbs_1")
		local angangTextbs = self._image_FailBg:getChildByName("Tt_Textbs_2")
		local rewardTextbs = self._image_FailBg:getChildByName("Tt_Textbs_3")

		minggangTextbs:setString("明杠次数：")
		angangTextbs:setString("暗杠次数：")
		rewardTextbs:setString("奖码次数：")

		local minggangText_num = self._image_FailBg:getChildByName("Tt_jiepao")
		local angangTextbs_num = self._image_FailBg:getChildByName("Tt_dianpao")
		local rewardTextbs_num = self._image_FailBg:getChildByName("Tt_zimo")
		if not info.ming_gang_num then
			info.ming_gang_num =0
		end
		if not info.an_gang_num then
			info.an_gang_num =0
		end
		if not info.reward_num then
			info.reward_num =0
		end
		minggangText_num:setString(info.ming_gang_num)
		angangTextbs_num:setString(info.an_gang_num)
		rewardTextbs_num:setString(info.reward_num)



		
		local Se_Head = self._image_FailBg:getChildByName("Se_Head")--头像

		local Al_TotalScore = self._image_FailBg:getChildByName("Al_TotalScore")
		local pjNum = self:getIntPart(tonumber(info.score))
		local tt = tostring(pjNum)
		Al_TotalScore:setString("/"..tt)
		print("Al_TotalScore:getString() = ", Al_TotalScore:getString())

		local nameText = self._image_FailBg:getChildByName("Tt_PlayerInfo")--姓名

		local nameLabel = ""
		for k, v in ipairs(roomInfo.players) do
   			if v.user_id == info.user_id then
   				nameLabel = v.user_name
   			end
     	end
     	nameText:setString(nameLabel)

		local idText = self._image_FailBg:getChildByName("Tt_ID")
		idText:setString("ID: "..info.user_id)
	end
	
end

function ResultTotalEnditems:getIntPart(x)
	local y = (-x)
	
	return y
end

return ResultTotalEnditems