

local DDZTotalLayer = class("DDZTotalLayer", function()
	return cc.CSLoader:createNode("games/ddz/TotalResultLayer.csb")
end)


function DDZTotalLayer:ctor(  )
	 -- 获取界面控件
    -- local layer = self:getChildByName("Layer")
    local layer = self
    local bg = layer:getChildByName("Ie_Bg")
    self.bnContinue = bg:getChildByName("Bn_Continue")
    self.bnShare = bg:getChildByName("Bn_Share")--分享到微信群
    self.bnShareFriends = bg:getChildByName("Bn_Share_Friends")--分享到朋友圈
    self.bnShareFriends:setVisible(false)
    self.iconShareAddCoin = self.bnShareFriends:getChildByName("Image_addCoin")
    self.txtShareAddCoin = self.iconShareAddCoin:getChildByName("Text_addCoin")

    self.bnClose = bg:getChildByName("Bn_Close")

    self.Tt_RoomOwner = bg:getChildByName("Text_RoomOwner")
    self.Tt_RoomOwner:setString("")
    self.losePlayerBG = {}
    self.winPlayerBG = {}

    self.losePlayerInfo = {
        {
           Se_Head = layer,
           Tt_PlayerInfo = layer,
           Al_TotalScore = layer,
        },
        {
           Se_Head = layer,
           Tt_PlayerInfo = layer,
           Al_TotalScore = layer,
        },
        {
           Se_Head = layer,
           Tt_PlayerInfo = layer,
           Al_TotalScore = layer,         
        },

    }

    self.winPlayerInfo = {
        {
           Se_Head = layer,
           Ig_Bg1 = layer,
           Ig_Bg2 = layer,
           Tt_PlayerInfo = layer,
           Al_TotalScore = layer,
           Se_BigWiner = layer,
        },
        {
           Se_Head = layer,
           Ig_Bg1 = layer,
           Ig_Bg2 = layer,
           Tt_PlayerInfo = layer,
           Al_TotalScore = layer,
           Se_BigWiner = layer,
        },
        {
           Se_Head = layer,
           Ig_Bg1 = layer,
           Ig_Bg2 = layer,
           Tt_PlayerInfo = layer,
           Al_TotalScore = layer,
           Se_BigWiner = layer,           
        },

    }
    local imBg
    for num = 1,3 do
         imBg = bg:getChildByName(string.format("Node_Player%d",num))
         self.losePlayerBG[num] = imBg:getChildByName("Lose_PlayerBg")
         self.losePlayerInfo[num].Se_Head = self.losePlayerBG[num]:getChildByName("Se_Head")
         self.losePlayerInfo[num].Tt_PlayerInfo = self.losePlayerBG[num]:getChildByName("Tt_PlayerInfo")
         self.losePlayerInfo[num].Al_TotalScore = self.losePlayerBG[num]:getChildByName("Al_TotalScore")

         self.winPlayerBG[num] = imBg:getChildByName("Win_PlayerBg")
         self.winPlayerBG[num]:setVisible(false)

         self.winPlayerInfo[num].Ig_Bg1 = self.winPlayerBG[num]:getChildByName("Image_bg1")
         self.winPlayerInfo[num].Ig_Bg2 = self.winPlayerBG[num]:getChildByName("Image_bg2")
         self.winPlayerInfo[num].Ig_Bg1:setVisible(false)
         self.winPlayerInfo[num].Ig_Bg2:setVisible(false)

         self.winPlayerInfo[num].Se_Head = self.winPlayerBG[num]:getChildByName("Se_Head")
         self.winPlayerInfo[num].Tt_PlayerInfo = self.winPlayerBG[num]:getChildByName("Tt_PlayerInfo")
         self.winPlayerInfo[num].Al_TotalScore = self.winPlayerBG[num]:getChildByName("Al_TotalScore")
         self.winPlayerInfo[num].Se_BigWiner = self.winPlayerBG[num]:getChildByName("Se_BigWiner")
    end

    lt.CommonUtil:addNodeClickEvent(self.bnShare, function ( ... )
        self:buttonClicked(self.bnShare)
    end)
    lt.CommonUtil:addNodeClickEvent(self.bnShareFriends, function ( ... )
        self:buttonClicked(self.bnShareFriends)
    end)
    lt.CommonUtil:addNodeClickEvent(self.bnClose, function ( ... )
        self:buttonClicked(self.bnClose)
    end)

    -- 隐藏
    -- self:setVisible(false)  
    self.tPlayerData = nil
    -- self.mbStart = false    -- 是否显示开始按钮
end


function DDZTotalLayer:buttonClicked( pSender )
    -- 返回大厅
    if pSender == self.bnClose then
        local worldScene = lt.WorldScene.new()
        lt.SceneManager:replaceScene(worldScene)
    elseif pSender == self.bnShare then
    	-- 分享到微信群
        -- if self.isUseNewShareView then
        --     self:shareToWeChat(dzqp.g_eWeChatShareMode.eFriend)
        -- else
        --     dzqp:shareScreenShotBG(dzqp.g_eWeChatShareMode.eFriend)
        -- end
    elseif pSender == self.bnShareFriends then
        --分享到朋友圈
        -- if self.isUseNewShareView then 
        --     printf("分享到好友圈的结果")
        --     self:shareToWeChat(dzqp.g_eWeChatShareMode.eFriendCircle)
        -- else
        --     -- dzqp:shareScreenShotBG(dzqp.g_eWeChatShareMode.eFriendCircle)
        -- end
        -- if self.iconShareAddCoin:isVisible() then
        --     --设置点击分享朋友圈标记
        --     -- bFriendCircleClicked = true
        -- end
    end

end


	-- "players" = {
	--     1 = {
	--         "cur_score"  = 0
	--         "disconnect" = false
	--         "gold_num"   = 0
	--         "is_sit"     = false
	--         "score"      = 0
	--         "user_id"    = 11249
	--         "user_ip"    = "::ffff:1.198.29.212"
	--         "user_name"  = "雀起71868"
	--         "user_pic"   = "http://xxxx.png"
	--         "user_pos"   = 1
	--     }
	-- }


-- 设置玩家信息
function DDZTotalLayer:setPlayerInfo( tPlayerData ,iPlayerNum )
    -- 玩家信息
    local strPlayerInfo
    dump(tPlayerData,"玩家信息")
    dump(lt.DataManager:getGameRoomInfo(),"getGameRoomInfo")

    self.tPlayerData = tPlayerData 
    iPlayerNum = iPlayerNum or 3
    local score = {}
    local bigger = 0
    for num = 1, iPlayerNum do
        if tPlayerData[num] then
            strPlayerInfo = self:dels(tPlayerData[num].user_name) .. "\nID:" .. tostring(tPlayerData[num].user_id)
            self.losePlayerInfo[num].Tt_PlayerInfo:setString(strPlayerInfo)
            self.winPlayerInfo[num].Tt_PlayerInfo:setString(strPlayerInfo)
            self.winPlayerInfo[num].Se_BigWiner:setVisible(false)
            self.winPlayerInfo[num].Ig_Bg1:setVisible(false)
            self.winPlayerInfo[num].Ig_Bg2:setVisible(false)


            score[num] = tPlayerData[num].score

            if score[num] > bigger then
                bigger = score[num]
            end
            local win = false
            local seatNum = 0
            if score[num] >= 0 then
                win = true
                seatNum = score[num]
            else
                win = false
                seatNum = "/" .. math.abs(score[num])
            end
            self.losePlayerInfo[num].Al_TotalScore:setString(seatNum)
            self.winPlayerInfo[num].Al_TotalScore:setString(seatNum)

            self.winPlayerBG[num]:setVisible(win)
            self.losePlayerBG[num]:setVisible(not win)
            -- 房主 信息
            if tPlayerData[num].user_id == lt.DataManager:getGameRoomInfo().room_setting.other_setting.owner_id then
            	self.Tt_RoomOwner:setString("房主："..self:dels(tPlayerData[num].user_name))
        	  end
        end
    end
    
    for i = 1, 3 do 
        if bigger ~= 0 and score[i] == bigger then
            self.winPlayerInfo[i].Se_BigWiner:setVisible(true)
            self.winPlayerInfo[i].Ig_Bg1:setVisible(true)
            self.winPlayerInfo[i].Ig_Bg2:setVisible(true)
        end 
    end
end

-- 显示layer层， 填数据进来
function DDZTotalLayer:showLayer( tResultData)
	self:setVisible(true)
end


function DDZTotalLayer:dels(input)
    return string.trim(string.split(input,"\0")[1])
end



return DDZTotalLayer
