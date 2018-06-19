
local SettingLayer = class("SettingLayer", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/gwidget/GameSetLayer.csb")--  FriendLayer
end)

function SettingLayer:ctor()
	SettingLayer.super.ctor(self)

	self._scrollView = self:getChildByName("ScrollView")

	local dissolveRoom = self._scrollView:getChildByName("Btn_DissolveRoom")

	local backLobby = self._scrollView:getChildByName("Btn_BackLobby")

    local btnClose = self._scrollView:getChildByName("Btn_Close")
    if lt.DataManager:getRePlayState() then
        dissolveRoom:setVisible(false)
    end
    lt.CommonUtil:addNodeClickEvent(dissolveRoom, handler(self, self.onDissolveRoom))
	lt.CommonUtil:addNodeClickEvent(backLobby, handler(self, self.onBackLobby))
    lt.CommonUtil:addNodeClickEvent(btnClose, handler(self, self.onClose))
    self:setshow()
end

function SettingLayer:setshow() 
    local selectNumBgcolor = {}
    local selectNumMjcolor = {}
    local selectNumGameyy = {}
    local selectNumGameyx = {}
    local selectNumGamelanguage = {}
    local xuanzhonBgcolor = lt.PreferenceManager:getBgcolor() --记录选中背景颜色
    local xuanzhonMjcolor = lt.PreferenceManager:getMJcolor() --记录选中麻将颜色
    local xuanzhonGameyy = lt.PreferenceManager:getGemeyy()   --记录选中游戏音乐
    local xuanzhonGameyx = lt.PreferenceManager:getGemeyx()   --记录选中游戏音效
    local xuanzhonGamelanguage = lt.PreferenceManager:getGamelanguage()   --记录选中游戏语言
    for i=1,3 do    
        -- select背景颜色
        local bgPalel = self._scrollView:getChildByName("BGColor_".. i)
        bgPalel.selectNode = bgPalel:getChildByName("Image_Select")
        bgPalel._textNode = bgPalel:getChildByName("image_result")
        selectNumBgcolor[i] = bgPalel

        if xuanzhonBgcolor == 0 then
         --不存在代表是新手默认在第一项
            xuanzhonBgcolor = 1
        end

        if i == xuanzhonBgcolor then
            bgPalel.selectNode:setVisible(true)
        else
            bgPalel.selectNode:setVisible(false)
        end

        lt.CommonUtil:addNodeClickEvent(bgPalel, function( ... )
            for i, v in pairs(selectNumBgcolor) do 
                if v == bgPalel then
                    v.selectNode:setVisible(true)
                    lt.PreferenceManager:setBgcolor(i)
                else
                    v.selectNode:setVisible(false)
                end
            end
        end, false)
    end

    for i=1,3 do
        -- select麻将颜色
        local mjPalel = self._scrollView:getChildByName("MJColor_".. i)
        mjPalel.selectNode = mjPalel:getChildByName("Image_Select")
        mjPalel._textNode = mjPalel:getChildByName("image_result")
        selectNumMjcolor[i] = mjPalel

        if xuanzhonMjcolor == 0 then
         --不存在代表是新手默认在第一项
            xuanzhonMjcolor = 1
        end

        if i == xuanzhonMjcolor then
            mjPalel.selectNode:setVisible(true)
        else
            mjPalel.selectNode:setVisible(false)
        end

        lt.CommonUtil:addNodeClickEvent(mjPalel, function( ... )
            for i, v in pairs(selectNumMjcolor) do 
                if v == mjPalel then
                    v.selectNode:setVisible(true)
                    lt.PreferenceManager:setMJcolor(i)
                else
                    v.selectNode:setVisible(false)
                end
            end
        end, false)
    end

    for i=1,4 do
        -- select游戏音乐
        local musicPalel = self._scrollView:getChildByName("BGMusic_".. i)
        musicPalel.selectNode = musicPalel:getChildByName("Image_Select")
        musicPalel._textNode = musicPalel:getChildByName("image_result")
        selectNumGameyy[i] = musicPalel

        if xuanzhonGameyy == 0 then
         --不存在代表是新手默认在第一项
            xuanzhonGameyy = 1
        end

        if i == xuanzhonGameyy then
            musicPalel.selectNode:setVisible(true)
        else
            musicPalel.selectNode:setVisible(false)
        end

        lt.CommonUtil:addNodeClickEvent(musicPalel, function( ... )
            for i, v in pairs(selectNumGameyy) do 
                if v == musicPalel then
                    v.selectNode:setVisible(true)
                    lt.PreferenceManager:setGemeyy(i) 
                else
                    v.selectNode:setVisible(false)
                end
            end
        end, false)
    end

    for i=1,2 do
        -- select游戏音效
        local yxPalel = self._scrollView:getChildByName("GameMusic_".. i)
        yxPalel.selectNode = yxPalel:getChildByName("Image_Select")
        yxPalel._textNode = yxPalel:getChildByName("image_result")
        selectNumGameyx[i] = yxPalel

        if xuanzhonGameyx == 0 then
         --不存在代表是新手默认在第一项
            xuanzhonGameyx = 1
        end

        if i == xuanzhonGameyx then
            yxPalel.selectNode:setVisible(true)
        else
            yxPalel.selectNode:setVisible(false)
        end

        lt.CommonUtil:addNodeClickEvent(yxPalel, function( ... )
            for i, v in pairs(selectNumGameyx) do 
                if v == yxPalel then
                    v.selectNode:setVisible(true)
                    lt.PreferenceManager:setGemeyx(i)  
                else
                    v.selectNode:setVisible(false)
                end
            end
        end, false)
    end

    for i=1,2 do
        -- select游戏语言
        local languagePalel = self._scrollView:getChildByName("Language_".. i)
        languagePalel.selectNode = languagePalel:getChildByName("Image_Select")
        languagePalel._textNode = languagePalel:getChildByName("image_result")
        selectNumGamelanguage[i] = languagePalel

        if xuanzhonGamelanguage == 0 then
         --不存在代表是新手默认在第一项
            xuanzhonGamelanguage = 1
        end

        if i == xuanzhonGamelanguage then
            languagePalel.selectNode:setVisible(true)
        else
            languagePalel.selectNode:setVisible(false)
        end

        lt.CommonUtil:addNodeClickEvent(languagePalel, function( ... )
            for i, v in pairs(selectNumGamelanguage) do 
                if v == languagePalel then
                    v.selectNode:setVisible(true)
                    lt.PreferenceManager:setGamelanguage(i)  
                else
                    v.selectNode:setVisible(false)
                end
            end
        end, false)
    end

    local Ie_PBVoiceCheck = self._scrollView:getChildByName("Ie_PBVoiceCheck")  --游戏语音
    local GameVoice = self._scrollView:getChildByName("GameVoice")              --游戏语音select
    local xuanzhonstartYuyin = lt.PreferenceManager:getGameyuyin()
    if xuanzhonstartYuyin == 1 then
        Ie_PBVoiceCheck:setVisible(true)
    else
        Ie_PBVoiceCheck:setVisible(false)
    end

    lt.CommonUtil:addNodeClickEvent(GameVoice, function( ... )  
        local xuanzhonYuyin = lt.PreferenceManager:getGameyuyin()
        if xuanzhonYuyin == 1 then --当前如果是1代表目前是已选中状态，
            Ie_PBVoiceCheck:setVisible(false)
            lt.PreferenceManager:setGameyuyin(2)
        elseif xuanzhonYuyin == 2 then
            Ie_PBVoiceCheck:setVisible(true)
            lt.PreferenceManager:setGameyuyin(1)
            
        end
    end, false)

    local Ie_PBVibratCheck = self._scrollView:getChildByName("Ie_PBVibratCheck") --震动提醒
    local GameVibrat = self._scrollView:getChildByName("GameVibrat")             --震动提醒select
    local xuanzhonstartGameVibrat = lt.PreferenceManager:getGamevibrate()
    if xuanzhonstartGameVibrat == 1 then
        Ie_PBVibratCheck:setVisible(true)
    else
        Ie_PBVibratCheck:setVisible(false)
    end

    lt.CommonUtil:addNodeClickEvent(GameVibrat, function( ... )
        local xuanzhonGameVibrat = lt.PreferenceManager:getGamevibrate()
        if xuanzhonGameVibrat == 1 then --当前如果是1代表目前是已选中状态，
            Ie_PBVibratCheck:setVisible(false)
            lt.PreferenceManager:setGamevibrate(2)
        elseif xuanzhonGameVibrat == 2 then
            Ie_PBVibratCheck:setVisible(true)
            lt.PreferenceManager:setGamevibrate(1)
            
        end
    end, false)

    local Ie_PBShakeCheck = self._scrollView:getChildByName("Ie_PBShakeCheck") --抖动特效
    local GameShake = self._scrollView:getChildByName("GameShake")              --抖动特效select
    local xuanzhonstartshake = lt.PreferenceManager:getGameshake()
    if xuanzhonstartshake == 1 then
        Ie_PBShakeCheck:setVisible(true)
    else
        Ie_PBShakeCheck:setVisible(false)
    end

    lt.CommonUtil:addNodeClickEvent(GameShake, function( ... )
        local xuanzhonshake = lt.PreferenceManager:getGameshake()
        if xuanzhonshake == 1 then --当前如果是1代表目前是已选中状态，
            Ie_PBShakeCheck:setVisible(false)
            lt.PreferenceManager:setGameshake(2)
        elseif xuanzhonshake == 2 then
            Ie_PBShakeCheck:setVisible(true)
            lt.PreferenceManager:setGameshake(1)
            
        end
    end, false)

end


function SettingLayer:onDissolveRoom()--申请解散房间
    --local ApplyGameOverPanel = lt.ApplyGameOverPanel.new()
    --self:addChild(ApplyGameOverPanel,10)
    
    ---[[
    local roomInfo = lt.DataManager:getGameRoomInfo()
    local loginData = lt.DataManager:getPlayerInfo()
    dump(roomInfo)
    dump(loginData)
    local playertype = nil
    if loginData.user_id == lt.DataManager:getPlayerUid() then
        playertype = 15200--2 --本人是房主
    else
        playertype = 1
    end
    local arg = {room_id = roomInfo.room_id} --1.room_id //解散类型  1 玩家申请解散  2、房主解散
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.DISTROY_ROOM,arg)--]]
end

function SettingLayer:onClose()
    lt.UILayerManager:removeLayer(self)
end

function SettingLayer:aa()
end

function SettingLayer:bb()
end

function SettingLayer:onBackLobby()
    if lt.DataManager:getRePlayState() then
        lt.MJplayBackManager:closeReplay()
        local worldScene = lt.WorldScene.new()
        lt.SceneManager:replaceScene(worldScene)
        lt.NetWork:disconnect()
    else
        lt.NetWork:sendTo(lt.GameEventManager.EVENT.LEAVE_ROOM)
    end
end

function SettingLayer:onBackLobbyResponse(msg)
    if msg.result == "success" then
    	local worldScene = lt.WorldScene.new()
        lt.SceneManager:replaceScene(worldScene)
        lt.NetWork:disconnect()
    end
end

function SettingLayer:onDistroyroomResponse(msg)    
    if msg.result ~= "success" then
        --local worldScene = lt.WorldScene.new()
        --lt.SceneManager:replaceScene(worldScene)
        --lt.NetWork:disconnect()
        ---[[
    --else
        local text = lt.LanguageString:getString("DISTROY_ROOM_"..msg.result)
        lt.MsgboxLayer:showMsgBox(text, false,function()  print("===1===")  end, function()  print("===2===") end, true, 15)--]]
    end
end

function SettingLayer:onEnter()   
    print("SettingLayer:onEnter")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.LEAVE_ROOM, handler(self, self.onBackLobbyResponse), "SettingLayer:onBackLobbyResponse")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.DISTROY_ROOM, handler(self, self.onDistroyroomResponse), "SettingLayer:onDistroyroomResponse")


    local function onTouchBegan(touch,event)

        local iBeginPx = touch:getLocation().x
        local iBeginPY = touch:getLocation().y
        local worldPos = self:convertToWorldSpace(cc.p(self._scrollView:getPosition()))
        local worldRect = cc.rect(worldPos.x - self._scrollView:getContentSize().width, worldPos.y-self._scrollView:getContentSize().height, self._scrollView:getContentSize().width, self._scrollView:getContentSize().height)
        if not cc.rectContainsPoint(worldRect, cc.p(iBeginPx, iBeginPY)) then
            self:onClose()
        end

        return false
    end

    local onTouchEnded = function ( )
        -- body
    end

    self._listener = lt.CommonUtil:createEventListenerTouchOneByOne(self, onTouchBegan, onTouchEnded)

end

function SettingLayer:onExit()
    print("SettingLayer:onExit")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.LEAVE_ROOM, "SettingLayer:onBackLobbyResponse")
    lt.CommonUtil:removeEventListenerTouchOneByOne(self, self._listener)
end

return SettingLayer