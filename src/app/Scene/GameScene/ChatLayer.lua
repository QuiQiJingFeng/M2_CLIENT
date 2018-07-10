

local ChatLayer = class("ChatLayer", function( ... )
    return cc.CSLoader:createNode("games/ddz/ChatLayer.csb")--背景层
    -- return cc.CSLoader:createNode("games/ddz/ChatLayer0.csb")--背景层
end)

local eWidgetTag = {
eIcon = 1,
eIconMax = 100,
eFast = 101,
eFastMax = 200,
}


function ChatLayer:showChatLayer( ... )
    self:setVisible(true)
end

function ChatLayer:closeChatLayer( ... )
    self:setVisible(false)
end

function ChatLayer:ctor( ... )
    self:onInit()
end



function ChatLayer:onCreate()
    -- self:openKeyboard()
end

function ChatLayer:onInit()

    -- 获取界面控件
    local layer = self
    layer:setCascadeOpacityEnabled(false)
    -- layer:setOpacity(200)
    self.bnMark = layer:getChildByName("Ie_Mark")
    -- self.bnMark:setOpacity(0)
    -- self.bnMark:setVisible(false)
    layer:setColor(cc.c3b(255, 255, 255))
    layer:setOpacity(0)
    local bg = layer:getChildByName("Ie_Bg")


    self.bnFast = bg:getChildByName("Bn_Fast")
    self.ieFastCheck = bg:getChildByName("Ie_FastCheck")
    self.bnIcon = bg:getChildByName("Bn_Icon")
    self.ieIconCheck = bg:getChildByName("Ie_IconCheck")

    self.svIcon = bg:getChildByName("SV_Icon")
    self.svIcon:setScrollBarEnabled(false)
    self.svFast = bg:getChildByName("SV_Fast")
    self.svFast:setScrollBarEnabled(false)

    local iFastItemHeight = 50
    local iFastItemSpace = 2

    local fastInfo = self:getCurrGameChatFastInfo()
    local intFastCount = #fastInfo
    local iScrollHeight = iFastItemHeight * intFastCount +(intFastCount - 1) * iFastItemSpace;
    local intItemWidth = self.svFast:getContentSize().width
    self.svFast:setInnerContainerSize(cc.size(intItemWidth, iScrollHeight))
    local intPosY = 0
    for num = 1, intFastCount do
        intPosY = iScrollHeight - iFastItemHeight / 2 -(num - 1) *(iFastItemSpace + iFastItemHeight)
        self:setFastItemInfo( fastInfo[num], num + eWidgetTag.eFast, intItemWidth,iFastItemHeight, intPosY)
    end

    -- 表情
    self.mtIcon = {layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer,layer}
    for num = 1, 29 do
        self.mtIcon[num] = self.svIcon:getChildByName(string.format("Bn_Icon%d",num))
        self.mtIcon[num]:setTag(eWidgetTag.eIcon + num)
         self:addImageTouchEventListener(self.mtIcon[num])
    end
    -- 按钮事件
    lt.CommonUtil:addNodeClickEvent(self.bnMark, handler(self, self.buttonClicked), false)
    lt.CommonUtil:addNodeClickEvent(self.bnFast, handler(self, self.buttonClicked), false)
    lt.CommonUtil:addNodeClickEvent(self.bnIcon, handler(self, self.buttonClicked), false)

    -- 自定义数据
    self.miSVMoveY = 0
 
end

function ChatLayer:onEnter()
    
end

function ChatLayer:onExit()
    lt.UILayerManager:removeLayer(self)
end


function ChatLayer:imageTouchBegin(pSender)
    self.miSVMoveY = self:getSVMovePosY()
end

function ChatLayer:imageTouchEnd(pSender)
    local posY = self:getSVMovePosY()
    if posY == self.miSVMoveY then
        local intTag = pSender:getTag()
        local strChat = "/00"..tostring(intTag)
        self:sendChatReq( strChat )
        -- self:setVisible(false)
        self:onExit()
    end
end

function ChatLayer:buttonClicked(pSender)
     -- if dzqp.g_tLocalUserData.iSoundSet == 1 then
    --     dzqp:playEffect("hallcomm/sound/btn.mp3", false)
    -- end
    -- 遮罩事件
    if pSender == self.bnMark then
       -- self:setVisible(false)
       self:onExit()
    -- 常用语
    elseif pSender == self.bnFast then
        self:changeView(false,true)
    -- 表情
    elseif pSender == self.bnIcon then
        self:changeView(true,false)
    end
end

function ChatLayer:onKeyback()
    self:exit()
end

function ChatLayer:changeView( bIcon,bFast )
    self.ieIconCheck:setVisible(bIcon)
    self.svIcon:setVisible(bIcon)
    self.ieFastCheck:setVisible(bFast)
    self.svFast:setVisible(bFast)
end

function ChatLayer:setFastItemInfo(strFast,intTag,intItemWidth,iFastItemHeight,intPosY)
    local image = ccui.ImageView:create("game/zpcomm/gwidget/img/BG7.png",1)   
    image:setAnchorPoint(cc.p(0.5, 0.5))
    image:setTag(intTag) 
    image:setScale9Enabled(true)
    image:setContentSize(cc.size(intItemWidth, iFastItemHeight))  -- 设置大小
    image:ignoreContentAdaptWithSize(false)  -- 如果设置为true，忽略内容适应，使用系统默认的渲染大小 false时重新渲染为设置（setContentSize）的大小  系统默认为true 所以更改大小 要设置为false
    image:setPosition(cc.p(intItemWidth/2,intPosY))
 
    local txtItemName = cc.Label:createWithSystemFont(strFast, "Helvetica", 28)
    txtItemName:setAnchorPoint(cc.p(0, 0.5))
    txtItemName:setColor(cc.c3b(116, 60, 0))
    txtItemName:setPosition(cc.p(15, 25))
    image:addChild(txtItemName)

    local spriteLine = display.newSprite("#game/zpcomm/gwidget/img/BG4.png")
    spriteLine:setAnchorPoint(cc.p(0.5, 0.5))
    spriteLine:setScaleX(280)
    spriteLine:setPosition(intItemWidth / 2, intPosY - iFastItemHeight / 2)
    self.svFast:addChild(spriteLine)

    self:addImageTouchEventListener(image)
    self.svFast:addChild(image)
    
end

----------------------------------------------------------------------------------
-- 发送聊天
function ChatLayer:sendChatReq( strChat )
    -- local tChatReq = dzqp.g_tChatInfoReq.tSendInfo
    -- tChatReq.iUserID = dzqp.g_tLobbyLoginData.iUserID

    local tChatReq = {}

    -- 发送过去只发送id， 回来的时候处理为座位号
    tChatReq.user_pos = lt.DataManager:getPlayerUid()
    tChatReq.fast_index = strChat


    dump(tChatReq, "tChatReq")

    lt.NetWork:sendTo("fast_spake_req", tChatReq)
end

-----------------------------------------------------------------------------------
-- 获取当前游戏快捷聊天
function ChatLayer:getCurrGameChatFastInfo()
    return  { 
                "快点啊,都等的我花儿都谢了！",
                "别吵了,专心玩游戏！",
                "你是妹妹还是哥哥啊？",
                "大家好,很高兴见到各位！",
                "又断线了,网络怎么这么差！",
                "和你合作真是太愉快了。",
                "下次再玩吧,我要走了。",
                "不要走,决战到天亮。",
                "我们交个朋友吧,告诉我你的联系方法。",
                "各位,真不好意思,我要离开会。",
                "你的牌打的太好了！",
                "再见了,我会想念大家的！",
            }
end

-----------------------------------------------------------------------------------
-- 获取当前scorllview滚动条位置
function ChatLayer:getSVMovePosY()
    local intY = 0
    if self.ieFastCheck:isVisible() == true then
        intY = self.svFast:getInnerContainerPosition().y
    else
        intY = self.svIcon:getInnerContainerPosition().y
    end
    return intY
end


function ChatLayer:addImageTouchEventListener(pSender)
    local function onTouch(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            self:imageTouchBegin(sender)
        elseif eventType == ccui.TouchEventType.moved then
            -- local isHit = self:hitTest(sender, sender:getTouchMovePosition())
            -- if isHit == false then
            --     self:imageTouchCancel(sender)
            -- end  
        elseif eventType == ccui.TouchEventType.canceled or eventType == ccui.TouchEventType.ended then
            self:imageTouchEnd(sender)
        end
    end
    pSender:setTouchEnabled(true)
    pSender:addTouchEventListener(onTouch)      
end


return ChatLayer
