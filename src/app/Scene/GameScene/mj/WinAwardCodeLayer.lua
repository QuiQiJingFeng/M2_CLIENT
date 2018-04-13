--奖码
local WinAwardCodeLayer = class("WinAwardCodeLayer", lt.BaseLayer, function()

    return cc.CSLoader:createNode("games/hzmj/landscape/HZMJWinAwardLayer.csb")
end)

function WinAwardCodeLayer:ctor(deleget)
    -- 获取界面控件
    WinAwardCodeLayer.super.ctor(self)
    self._deleget = deleget

    self.m_panel = self:getChildByName("Panel")
    self.m_spAwardBg = self.m_panel:getChildByName("sp_awardBg")
    self.m_panelAward = self.m_panel:getChildByName("panel_Award")
    

    self.star1 = self.m_spAwardBg:getChildByName("star1")
    self.star2 = self.m_spAwardBg:getChildByName("star2")
    self.star3 = self.m_spAwardBg:getChildByName("star3")
    self.star4 = self.m_spAwardBg:getChildByName("star4")
    self.spAwardNum = self.m_spAwardBg:getChildByName("awardNum")
    

    lt.CommonUtil:addNodeClickEvent(self.m_panel, function( )
        if self.acOver == true then
            self:setVisible(false)
            --self:close()
            --lt.UILayerManager:removeLayer(self)
        end
    end, false)

    self.acOver = false
    self.cardWidth = 92
    self.cardHeight = 137
    self.gap = 20

    local awardCards = lt.DataManager:getGameOverInfo().award_list
    self.nodeCards = {}
    self.cardNum = 0
    for i = 1,#awardCards do
        if awardCards[i] ~= 0 then
            self.cardNum = self.cardNum + 1
        end
    end

    local spNum = display.newSprite(string.format("#games/hzmj/game/%d.png",self.cardNum))
    self.spAwardNum:addChild(spNum)
    spNum:setPosition(cc.p(self.spAwardNum:getContentSize().width/2,self.spAwardNum:getContentSize().height/2))

    self.m_panelAward:setContentSize(cc.size(self.cardNum*(self.cardWidth+self.gap),self.cardHeight))
    self.m_panelAward:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height))

    for i = 1,#awardCards do
        local bContinue = false
        if awardCards[i] == 0 then
            bContinue = true
        end
        if not bContinue then
            local card = self:createCard(awardCards[i])
            self.m_panelAward:addChild(card)
            card:setPosition(cc.p((i-1)*(self.cardWidth+self.gap)+self.cardWidth/2,self.m_panelAward:getContentSize().height/2))
            card:setVisible(false)
            card.x = (i-1)*(self.cardWidth+self.gap)+self.cardWidth/2
            card.y = self.m_panelAward:getContentSize().height/2
            card.value = awardCards[i]
            table.insert(self.nodeCards,card)
        end
    end  
end

function WinAwardCodeLayer:onEnter()  
  self:showPrizeCards()
end

function WinAwardCodeLayer:showPrizeCards()
    local function awardBgAction()
        for i = 1,4 do
            self["star"..i]:setOpacity(0)
            self["star"..i]:setPosition(cc.p(self.m_spAwardBg:getContentSize().width/2,self.m_spAwardBg:getContentSize().height/2))
        end
        self.m_spAwardBg:setScale(0.1)
        local scale = cc.EaseBounceOut:create((cc.ScaleTo:create(0.5,1))) --EaseElasticOut
        local function starAc()            
            for i = 1,4 do
                local scale = 0
                local star_x = 0
                local star_y = 0
                if i == 1 then
                    self["star"..i]:setScale(0.7)    
                    star_x = 160
                    star_y = 285
                elseif i == 2 then
                    self["star"..i]:setScale(0.8) 
                    star_x = 250
                    star_y = 345
                elseif i == 3 then
                    star_x = 415
                    star_y = 370
                    self["star"..i]:setScale(1) 
                elseif i == 4 then
                    star_x = 510
                    star_y = 300
                    self["star"..i]:setScale(0.5) 
                end
                local move = cc.MoveTo:create(0.5,cc.p(star_x,star_y))
                local fade = cc.FadeIn:create(1)
                self["star"..i]:runAction(cc.Spawn:create(move,fade))
            end
        end

        self.m_spAwardBg:runAction(cc.Sequence:create(scale,cc.CallFunc:create(starAc))) 
    end

    local idx = 0
    local function cardsAction()
        idx = idx + 1
        if idx > self.cardNum then
            local BingGoNumArr = {}
            local unBingGoNumArr = {}

            for i = 1,#self.nodeCards do

                local iT = math.floor(self.nodeCards[i].value / 10) + 1
                local iv = self.nodeCards[i].value % 10

                if iv == 1 or iv == 5 or iv == 9 then
                    table.insert(BingGoNumArr,i)
                    
                else  
                    table.insert(unBingGoNumArr,i)                            
                end
            end

            if #BingGoNumArr > 0 then 
                for i=1,#BingGoNumArr do
                    local function light()
                        self.nodeCards[BingGoNumArr[i]]:getChildByTag(2):setVisible(true)
                    end 
                    self.nodeCards[BingGoNumArr[i]]:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(light)))
                end             
            end

            if #unBingGoNumArr > 0 then
                
                if lt.DataManager:getGameRoomInfo().room_setting.other_setting[5] == 1 and #unBingGoNumArr == self.cardNum then
                    for i=1,#unBingGoNumArr do
                        local function light2()
                            self.nodeCards[unBingGoNumArr[i]]:getChildByTag(2):setVisible(true)
                        end 
                        self.nodeCards[unBingGoNumArr[i]]:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(light2)))
                    end               
                else
                    for i=1,#unBingGoNumArr do
                        local function unlight()
                            self.nodeCards[unBingGoNumArr[i]]:setColor(cc.c3b(127,127,127))
                            self.nodeCards[unBingGoNumArr[i]]:runAction(cc.ScaleTo:create(0.2,0.9))
                        end  
                        self.nodeCards[i]:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(unlight)))
                    end                     
                end 
            end
            return
        else
            self.nodeCards[idx]:setVisible(true)

            local card_move = cc.MoveTo:create(0.1,cc.p(self.nodeCards[idx].x,-self:getContentSize().height/2 + self.cardHeight/2)) --cc.EaseBounceOut:create
            self.nodeCards[idx]:runAction(cc.Sequence:create(card_move,cc.CallFunc:create(cardsAction)))            
        end 
    end
    local function cleanAwardAction()
        self.acOver = true  	
        self:setVisible(false)  
        --self:close() 
        --lt.UILayerManager:removeLayer(self)    
    end
    self:runAction(cc.Sequence:create(cc.CallFunc:create(awardBgAction),cc.DelayTime:create(1),cc.CallFunc:create(cardsAction),cc.DelayTime:create(2),cc.CallFunc:create(cleanAwardAction)))
end


function WinAwardCodeLayer:createCard(cardValue)  
   
    local cardNode = display.newSprite("#game/mjcomm/cardBgGreen/mjStandFace.png")   
    cardNode:setAnchorPoint(0.5,0.5)
    if cardValue and cardValue ~= 0 then
        local iT = math.floor(cardValue / 10) + 1
        local iV = cardValue % 10

        local cardFace = display.newSprite(string.format("#game/mjcomm/cards/card_%s_%s.png",tostring(iT),tostring(iV))) 
        cardFace:setAnchorPoint(0.5,0.5)
        cardFace:setPosition(cc.p(cardNode:getContentSize().width/2,cardNode:getContentSize().height/2 - 5))
        cardNode:addChild(cardFace,1,1)

        local cardLight = display.newSprite("#games/hzmj/game/cardLight.png")
        cardLight:setAnchorPoint(0.5,0.5)
        cardLight:setPosition(cc.p(45,70))
        cardLight:setVisible(false)
        cardNode:addChild(cardLight,2,2)        
    end
    return cardNode
end

function WinAwardCodeLayer:close()
    self._deleget:closeWinAwardCodeLayer()
end

function WinAwardCodeLayer:onExit()

end

return WinAwardCodeLayer


--endregion
