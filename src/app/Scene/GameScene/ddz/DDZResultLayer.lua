-- 斗地主总结算DDZ总结果层
local DDZTotalResultLayer = class("DDZTotalResultLayer", function ( ... )
    return cc.CSLoader:createNode(sCsbPathName)
end)
----------------------------------------------------------------------------------
--
function DDZTotalResultLayer:ctor()

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
    self:setVisible(false)  
    self.tPlayerData = nil
    self.mbStart = false    -- 是否显示开始按钮
end

----------------------------------------------------------------------------------
--
function DDZTotalResultLayer:onEnter()
    -- 注册分享回调
    -- dzqp:addMNByC(dzqp.g_eMNByC.eShareResult, self, self.funShareResult)
end

----------------------------------------------------------------------------------
--
function DDZTotalResultLayer:onExit()
    self:removeRealShare()
    -- dzqp:delMNByC( dzqp.g_eMNByC.eShareResult, self )
end
----------------------------------------------------------------------------------
-- 

local bFriendCircleClicked = false
local eHttpGameShareUrl = "/api/lobby-shareEnd"

function DDZTotalResultLayer:funShareResult( tData )
    -- 没安装微信
    if tData.code == "4" then
        self:setMsgBox(dzqp.g_tStrDefine.eMsgNoWeChat)
    elseif tData.code == "0" then
        if bFriendCircleClicked == true then 
            --请求是否可以领金币
            local function funCallback(strDate)
                --- 获取数据
                local data = strDate
                data = json.decode(data)
                
                if data.map.result == "error" then
                    self:setMsgBox(data.map.desc)
                elseif data.map.result == "ok" then
                    --可已领取
                    self:setMsgBox(data.map.desc)
                end

                self.iconShareAddCoin:setVisible(false)
            end
            local url = dzqp.g_tUrlData.tLobbyUrl[dzqp.g_sLobbyLoginUrlIndex] .. eHttpGameShareUrl
            local strPostData = string.format("userId=%d&userToken=%s&appId=%d&opt=send", dzqp.g_tLobbyLoginData.iUserID, dzqp.g_tLobbyLoginData.strUserToken, dzqp.iAppId)
            dzqp:sendHttpMsg(url, strPostData, funCallback)
            bFriendCircleClicked = false
        end
    end 
end

-- 设置msgbox
function DDZTotalResultLayer:setMsgBox( strContent,intBnTag )
    local lyrMsgBox = self:getApp():createView(dzqp.g_tMsgBoxLayer, self)     
    if intBnTag ~= nil then
        lyrMsgBox:setMNView(self.tag_)
        lyrMsgBox:setData(intBnTag)
        lyrMsgBox:setMarkButtonEnbale(false)
    end
    
    lyrMsgBox:setSingleType()
    lyrMsgBox:setContent(strContent)
    self:addChild(lyrMsgBox)
end

function DDZTotalResultLayer:getUseNewShareView()
    -- local strGameDir, strGameName = self.m_objModel:getShowGameName()
    local strGameDir, strGameName = "ddz","斗地主"
    local pathHead = "games/ddz/game/"
    local pngShareGameName = cc.SpriteFrameCache:getInstance():getSpriteFrame(pathHead..strGameDir.."ShareGameName.png")
    local pngShareQRCode = cc.SpriteFrameCache:getInstance():getSpriteFrame("games/comm/shareQRCode.png")
    
    --是否使用新分享界面，标题 和 二维码是必须的
    self.isUseNewShareView = pngShareGameName and  pngShareQRCode
    
    if self.isUseNewShareView then
        self:initRealShare()
    end

    return self.isUseNewShareView
end

function DDZTotalResultLayer:initRealShare()
    if not self.layShare then

        local layShare = cc.CSLoader:createNode("game/zpcomm/gwidget/ResultShareLayer.csb")
        
        local strGameDir, strGameName = self.m_objModel:getShowGameName()
        local pathHead = "games/"..strGameDir.."/game/"
        local pathcomm = "games/comm/"
        local data = self.tObjData
        local tPlayerData = self.tPlayerData
        --初始化界面
        local spBg = layShare:getChildByName("Sprite_Bg") --可能会变
        local bgPath = pathHead..strGameDir.."ShareBg.png"
        local shareBg = cc.SpriteFrameCache:getInstance():getSpriteFrame(bgPath)
        if shareBg then
            spBg:setSpriteFrame(shareBg)
        elseif cc.FileUtils:getInstance():isFileExist(bgPath) then
            --spBg:loadTexture(bgPath) --放在非plist里
            spBg:setTexture(bgPath)
        end

        local spFlower = layShare:getChildByName("Sprite_Flower") --可能会变
        spFlower:setVisible(false)
        --       local pngShareFlower = cc.SpriteFrameCache:getInstance():getSpriteFrame(pathHead.."shareFlower.png")
        --       if pngShareFlower then
        --           spFlower:setSpriteFrame(pngShareFlower)
        --       end
        local spIcon = layShare:getChildByName("Sprite_Icon") --可能会变
        local pngIcon = cc.SpriteFrameCache:getInstance():getSpriteFrame(pathcomm.."shareIcon.png")
        if pngIcon then
            spIcon:setSpriteFrame(pngIcon)
        elseif cc.FileUtils:getInstance():isFileExist(pathcomm.."shareIcon.png") then
            spIcon:setTexture(pathcomm.."shareIcon.png")--放在非plist里
        else
            spIcon:setVisible(false)
        end
        local spGameName = layShare:getChildByName("Sprite_GameName") --会变，不能没有
        local pngShareGameName = cc.SpriteFrameCache:getInstance():getSpriteFrame(pathHead..strGameDir.."ShareGameName.png")
        if pngShareGameName then
            spGameName:setSpriteFrame(pngShareGameName)
        end

        local imgContent = layShare:getChildByName("Image_Content")

        local spPeople = imgContent:getChildByName("Sprite_People") --人物，可能会换
        local pngSharePeople = cc.SpriteFrameCache:getInstance():getSpriteFrame(pathHead..strGameDir.."SharePeople.png")
        if pngSharePeople then
            spPeople:setSpriteFrame(pngSharePeople)
        end

        local nodeResultInfo = imgContent:getChildByName("Node_ResultInfo")
        local colorWin = cc.c3b(0xc8, 0x4e, 0x05)
        local colorLost = cc.c3b(0x51, 0x68, 0x86)
        local strFzName = ""

        for i = 1, #data do
            local cTableNumExtra = data[i][1]
            local iTotalAmount = data[i][2]
            local playerInfo = tPlayerData[cTableNumExtra]
            local isWin = iTotalAmount >= 0
            local isRank1 = iTotalAmount > 0 and i == 1
            local colorCur = isWin and colorWin or colorLost

            local layItem = nodeResultInfo:getChildByName("FileNode_Item_"..i)
            local imgWinBg = layItem:getChildByName("Image_WinBg")
            local imgWinLight = layItem:getChildByName("Sprite_WinLight")
            local imgLostBg = layItem:getChildByName("Image_LostBg")
            imgWinBg:setVisible(isWin)
            imgLostBg:setVisible(not imgWinBg:isVisible())
            imgWinLight:setVisible(isRank1)

            local imgHeadBg = layItem:getChildByName("Image_HeadBg")
            dzqp.g_pHeadFun:setUserHeadInfo(playerInfo.iUserID, imgHeadBg, 8)

            local textName = layItem:getChildByName("Text_Name")
            textName:setString(playerInfo.szNickName)

            local textUserId = layItem:getChildByName("Text_UserId")
            textUserId:setString("ID:" .. playerInfo.iUserID)

            local textResult = layItem:getChildByName("Text_Result")
            
            textResult:setColor(colorCur)
            textUserId:setColor(colorCur)
            textName:setColor(colorCur)

            local numWinScore = layItem:getChildByName("AtlasLabel_WinScore")
            local numLostScore = layItem:getChildByName("AtlasLabel_LostScore")

            local str = "/" .. math.abs(iTotalAmount)
            numWinScore:setString(str)
            numLostScore:setString(str)

            numWinScore:setVisible(isWin)
            numLostScore:setVisible(not isWin)

            local numWinRank = layItem:getChildByName("AtlasLabel_WinRank")
            local numLostRank = layItem:getChildByName("AtlasLabel_LostRank")
            local spWinTitle = layItem:getChildByName("Sprite_WinTitle")

            numWinRank:setString(i)
            numLostRank:setString(i)

            spWinTitle:setVisible(isWin and i == 1)
            numWinRank:setVisible(isWin and not spWinTitle:isVisible())
            numLostRank:setVisible(not isWin)

            if playerInfo.iUserID == dzqp.g_tEnterData.iRoomOwnerId then
                strFzName = playerInfo.szNickName
            end

            layItem:setVisible(true)
        end

        local nodeGameInfoInfo = imgContent:getChildByName("Node_GameInfo")
        
        local textTime = nodeGameInfoInfo:getChildByName("Text_Time")
        local textRoomNum = nodeGameInfoInfo:getChildByName("Text_RoomNum")
        local textBaseCode = nodeGameInfoInfo:getChildByName("Text_BaseCode")
        local textRoomOnwer = nodeGameInfoInfo:getChildByName("Text_RoomOnwer")
        local textZiFei = nodeGameInfoInfo:getChildByName("Text_ZiFei")
        
        local timeStr = os.date("%Y-%m-%d %H:%M:%S")
		
		local textRoundIndex = nodeGameInfoInfo:getChildByName("Text_RoundIndex")
		textRoundIndex:setString("局数："..dzqp.g_tEnterData.iRound)
        textTime:setString(timeStr.." 结束")      
        textRoomNum:setString("房号："..dzqp.g_tEnterData.iRoomCardId)
        textBaseCode:setString("底分："..self.iBaseCode)
        if strFzName ~= "" then
            textRoomOnwer:setString("房主："..strFzName)
        else
            textRoomOnwer:setString("")
        end
        local  payTypeStr = ""
        if dzqp.g_tEnterData.iPay == 0 then
            payTypeStr = "房主出资"
        elseif dzqp.g_tEnterData.iPay == 1 then
            payTypeStr = "玩家平摊"
        else
            payTypeStr = "大赢家出资"
        end
        textZiFei:setString("资费："..payTypeStr)

        local spQRCodeBg = layShare:getChildByName("Sprite_QRCodeBg")
        local spQRCode = spQRCodeBg:getChildByName("Sprite_QRCode")
        
        local pngShareQRCode = cc.SpriteFrameCache:getInstance():getSpriteFrame(pathcomm.."shareQRCode.png")
        if pngShareQRCode then
            spQRCode:setSpriteFrame(pngShareQRCode)
        elseif cc.FileUtils:getInstance():isFileExist(pathcomm.."shareQRCode.png") then
            spQRCode:setTexture(pathcomm.."shareQRCode.png")--放在非plist里
        end
        

        -----------------------------------------------------------------
        self.layShare = layShare

        layShare:setAnchorPoint(cc.p(1, 0))
        layShare:setRotation(90)
        layShare:retain()
        
    end
end
----------------------------------------------------------------------------------
-- 

function DDZTotalResultLayer:removeRealShare()
    if self.layShare then
        self.layShare:release()
        self.layShare = nil
    end
end


function DDZTotalResultLayer:shareToWeChat(strMode)
    
    local fileName = "res//voice//ResultShare.png"
    local strImg = dzqp.g_sWritablePath .. fileName
    
    cc.Director:getInstance():getTextureCache():removeTextureForKey(fileName)
    cc.FileUtils:getInstance():removeFile(strImg)
    cc.FileUtils:getInstance():removeFile(fileName)

    local layShare = self.layShare
    if layShare == nil then
        layShare = cc.CSLoader:createNode("game/zpcomm/gwidget/ResultShareLayer.csb")
        layShare:setAnchorPoint(cc.p(1, 0))
        layShare:setRotation(90)
        layShare:retain()
    end
    local sw = 1334 * 0.6
    local sh = 750 * 0.6
    local sceneTotal = cc.RenderTexture:create(sw, sh, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)

    sceneTotal:begin()
    layShare:setScale(0.6)
    layShare:visit()
    sceneTotal:endToLua()

    local sp = sceneTotal:getSprite()
    sp:setRotation(-90)
    sp:setPosition(cc.p(sh/2, sw/2))

    local sceneFile = cc.RenderTexture:create(sh, sw, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
    sceneFile:begin()
    sp:visit()
    sceneFile:endToLua()

    local function callback()
        --分享到微信
        dzqp.g_pInterface:loadSharePlugin(dzqp.g_eShareMode.eWeChat, dzqp.g_sWeChatId)
        dzqp.g_pInterface:onSharePluginShare(strMode, "0", "0", "0", "0", strImg)

        if self.layShare == nil then
            layShare:release()
        end
    end

    local b = sceneFile:saveToFile(fileName, cc.IMAGE_FORMAT_PNG)

    local i = 0
    local update = function(ft)
        i = i + 1
        local b = cc.FileUtils:getInstance():isFileExist(strImg) == true
        if i == 600 or b then
            --缓动完成
            self:unscheduleUpdate()
            if b then
                callback()
            end
        end
    end

    self:scheduleUpdate(update)
end

function DDZTotalResultLayer:buttonClicked( pSender )
    -- 播放点击音效
    if dzqp.g_tLocalUserData.iSoundSet == 1 then
        dzqp:playEffect("hallcomm/sound/btn.mp3", false)
    end

    -- 事件触发  
    -- 退出
    if pSender == self.bnClose then
        self:sendEscapeReq(1, 2)
        dzqp.g_tLobbyLoginData.iRoomNo = 0
        dzqp.DzqpApp:enterScene(dzqp.g_tLobbyLayer)
    elseif pSender == self.bnShare then
        if self.isUseNewShareView then
            self:shareToWeChat(dzqp.g_eWeChatShareMode.eFriend)
        else
            dzqp:shareScreenShotBG(dzqp.g_eWeChatShareMode.eFriend)
        end
    elseif pSender == self.bnShareFriends then
        --分享到朋友圈
        if self.isUseNewShareView then 
            printf("分享到好友圈的结果")
            self:shareToWeChat(dzqp.g_eWeChatShareMode.eFriendCircle)
        else
            dzqp:shareScreenShotBG(dzqp.g_eWeChatShareMode.eFriendCircle)
        end
        if self.iconShareAddCoin:isVisible() then
            --设置点击分享朋友圈标记
            bFriendCircleClicked = true
        end
    end

end

----------------------------------------------------------------------------------
--
function DDZTotalResultLayer:setStartButton( objModel )   
    self.mbStart = true
    self.bnContinue_1:setVisible(true)
    self.bnContinue:setVisible(false)
end

----------------------------------------------------------------------------------
-- 设置玩家信息
function DDZTotalResultLayer:setPlayerInfo( tPlayerData ,iPlayerNum )
    -- 玩家信息
    local strPlayerInfo
    dump(tPlayerData,"玩家信息")
    self.tPlayerData = tPlayerData 
    for num = 1, iPlayerNum do
        if tPlayerData[num] then
            dzqp.g_pHeadFun:setUserHeadInfo( tPlayerData[num].iUserID,self.losePlayerInfo[num].Se_Head,6 )
            dzqp.g_pHeadFun:setUserHeadInfo( tPlayerData[num].iUserID,self.winPlayerInfo[num].Se_Head,6 )
            strPlayerInfo = self:dels(tPlayerData[num].szNickName) .. "\nID:" .. tostring(tPlayerData[num].iUserID)
            self.losePlayerInfo[num].Tt_PlayerInfo:setString(strPlayerInfo)
            self.winPlayerInfo[num].Tt_PlayerInfo:setString(strPlayerInfo)
            if tPlayerData[num].iUserID == dzqp.g_tEnterData.iRoomOwnerId then
                self.Tt_RoomOwner:setString("房主："..self:dels(tPlayerData[num].szNickName))
            end
        end
    end
end

function DDZTotalResultLayer:dels(input)
    return string.trim(string.split(input,"\0")[1])
end

----------------------------------------------------------------------------------
-- 设置游戏信息
function DDZTotalResultLayer:setGameInfo( tGameData,m_objModel,iBaseCode )
    -- 游戏信息
    self.m_objModel = m_objModel
    self.iRoomNo = m_objModel.m_roomId  
    self.iBaseCode = iBaseCode
    self.tObjData = {}
    for i = 1, #tGameData.iTotalAmount do
        table.insert(self.tObjData, {i, tGameData.iTotalAmount[i]})
    end

    --从大到小排序
    table.sort(self.tObjData,
        function(a, b)
            return b[2]<a[2]
        end
    )

    -- local _ = self:getUseNewShareView()


    local strGameInfo
    local strScroe
    local intScroe
    local intMaxScore = 0
    for num = 1, 3 do
        intScroe = tGameData.iTotalAmount[num]     
        if intScroe > intMaxScore then
            intMaxScore = intScroe
        end
        if intScroe >= 0 then
            strScroe = tostring(intScroe)
            self.winPlayerBG[num]:setVisible(true)     

            self.iconShareAddCoin:setVisible(false)
            --请求是否可以领金币
            -- local function funCallback(strDate)
            --     --- 获取数据
            --     local data = strDate
            --     data = json.decode(data)
                
            --     if type(data) == "table" and data.map and data.map.result == "ok" then
            --         --可已领取
            --         self.iconShareAddCoin:setVisible(true)
            --         self.txtShareAddCoin:setString("+"..data.map.sendGmoney)
            --     end
            -- end
            -- local url = dzqp.g_tUrlData.tLobbyUrl[dzqp.g_sLobbyLoginUrlIndex] .. eHttpGameShareUrl
            -- local strPostData = string.format("userId=%d&userToken=%s&appId=%d&opt=query", dzqp.g_tLobbyLoginData.iUserID, dzqp.g_tLobbyLoginData.strUserToken, dzqp.iAppId)
            -- dzqp:sendHttpMsg(url, strPostData, funCallback)
                  
        else
            strScroe = string.format("/%d", - intScroe)
            local iClientPos = m_objModel:cTableNumExtraToIdx(num-1)
            -- if iClientPos == 2 then
            --     self.bnShareFriends:setVisible(false)
            -- end
        end
        self.losePlayerInfo[num].Al_TotalScore:setString(strScroe)
        self.winPlayerInfo[num].Al_TotalScore:setString(strScroe)
    end

    -- for num = 1, 3 do
    --      if tGameData.iTotalAmount[num] == intMaxScore and intMaxScore ~= 0 then
    --          self.winPlayerInfo[num].Se_BigWiner:setVisible(true)
    --          self.winPlayerInfo[num].Ig_Bg1:setVisible(true)
    --          self.winPlayerInfo[num].Ig_Bg2:setVisible(true)
    --      else
    --          self.winPlayerInfo[num].Se_BigWiner:setVisible(false)
    --      end
    -- end

end

----------------------------------------------------------------------------------
-- 发送离开
function DDZTotalResultLayer:sendEscapeReq( cIfPlayerReq,cEscapeType )
     local tEscapeReq = dzqp.g_tEscapeReqDDZ.tSendInfo
     tEscapeReq.cIfPlayerReq = cIfPlayerReq 
     tEscapeReq.cEscapeType = cEscapeType       
     dzqp:sendSocketMsg(tEscapeReq, dzqp.g_tEscapeReqDDZ.iSendLen, dzqp.g_eDDZMsgType.eEscapeReq, dzqp.g_tEscapeReqDDZ.funEncode)  
end

----------------------------------------------------------------------------------
-- 发送准备
function DDZTotalResultLayer:sendReadyReq( )
    local tReadyReq = dzqp.g_tReadyReqDDZ.tSendInfo
    tReadyReq.cChangePosition = 0
    tReadyReq.cRenewPriRoom = 1
    if self.mbStart then--开始游戏
        print("开始游戏")
        tReadyReq.cRenewPriRoom = 0
    end
    dzqp:sendSocketMsg(tReadyReq, dzqp.g_tReadyReqDDZ.iSendLen, dzqp.g_eDDZMsgType.eReadyReq, dzqp.g_tReadyReqDDZ.funEncode)   
end


return DDZTotalResultLayer
