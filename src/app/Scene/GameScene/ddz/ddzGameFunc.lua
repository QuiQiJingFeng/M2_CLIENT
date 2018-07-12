local ddzGameFunc = {}

local Card = require("app.Scene.GameScene.ddz.Card")
local JudgeCard = require("app.Scene.GameScene.ddz.JudgeCard")

-- 查看是否有比别人更大的牌
function ddzGameFunc:tipsBiggerCard(  )

	-- 桌面上的牌
	local iType = self.cTableCardType
	local iValue = self.cTableCardValue

	-- 搜索之后可以出的牌, 用self标记, 标记下个提醒

	self.pGetShapeSendiCardType = -1
	self.pGetShapeSendiCardValue = -1

	--  提示能取得的牌
    local cGetCard = {} 
    for var = 1 ,50 do            
        cGetCard[var] = {}
    end
    local iGetCardNum = 20

    -- 得到的牌type 和 valua
    local iTipsType = -1
    local iTipsValue = -1

	local cHandCard1 = {} 
    local cHandCard2 = {}
    local cHandCard3 = {}       
    for var =1,20 do 
        table.insert(cHandCard1,#cHandCard1+1,-1)
        table.insert(cHandCard2,#cHandCard2+1,-1)
        table.insert(cHandCard3,#cHandCard3+1,-1)
    end

    local iCardCount = 0 
    local allCard = self.GameCardLayer:getMainCard()


    print("检测更大牌型iType[%d], iValue[%d]", iType, iValue)

    dump(allCard, "allCard")

    local cOneCard
    for var = 1, 20 do
    	if allCard[var] and allCard[var] ~= 0 then
    		cOneCard = allCard[var]
			iCardCount = iCardCount + 1
	        cHandCard1[iCardCount] = cOneCard
	        cHandCard2[iCardCount] = cOneCard
	        cHandCard3[iCardCount] = cOneCard
    	end
    end


    local bSearch = false

    for k = 1, iCardCount do
        cHandCard2[k] = self:checkCardValue(cHandCard2[k])
    end

    ----判断手中是否有大的牌
    local cGetCard = {}
    for var = 1 ,20 do            
        cGetCard[var] = {}
    end

    self.m_vOut = {}

    if bSearch == false then  
        iTipsType = -1
		iTipsValue = -1
		bSearch = self:getSerchCard(cHandCard2, iCardCount, cGetCard, self.cTableCardType, self.cTableCardValue, iTipsType)
    end

    return bSearch
end


function ddzGameFunc:tipsCard( ... )

	-- 桌面上的牌
	local iType = self.cTableCardType
	local iValue = self.cTableCardValue

	-- 搜索之后可以出的牌, 用self标记, 标记下个提醒

	self.pGetShapeSendiCardType = -1
	self.pGetShapeSendiCardValue = -1

	-- 把所有牌清除选择状态, 重置状态
	self.GameCardLayer:unSelectAllCard()

	--  提示能取得的牌
    local cGetCard = {} 
    for var = 1 ,50 do            
        cGetCard[var] = {}
    end
    local iGetCardNum = 20

    -- 得到的牌type 和 valua
    self.iTipsType = -1
    self.iTipsValue = -1

	local cHandCard1 = {} 
    local cHandCard2 = {}
    local cHandCard3 = {}       
    for var =1,20 do 
        table.insert(cHandCard1,  0)
        table.insert(cHandCard2,  0)
        table.insert(cHandCard3,  0)
    end

    local iCardCount = 0 
    local allCard = self.GameCardLayer:getMainCard()

    local cOneCard
    for var = 1, 20 do
    	if allCard[var] and allCard[var] ~= 0 then
    		cOneCard = allCard[var]
			iCardCount = iCardCount + 1
	        cHandCard1[iCardCount] = cOneCard
	        cHandCard2[iCardCount] = cOneCard
	        cHandCard3[iCardCount] = cOneCard
    	end
    end

    local bSearch = false

    for k = 1, iCardCount do
        cHandCard2[k] = self:checkCardValue(cHandCard2[k])
    end

    ----判断手中是否有大的牌
    local cGetCard = {}
    for var = 1 ,20 do            
        cGetCard[var] = {}
    end

    self.m_vOut = {}

    if bSearch == false then  
        self.iTipsType = -1
		self.iTipsValue = -1
	
		bSearch = self:getSerchCard(cHandCard2, iCardCount, cGetCard, self.cTableCardType, self.cTableCardValue, self.iTipsType)
    end

    print("找牌结果", bSearch)

    dump(cGetCard, "cGetCard")

   	if #cGetCard[self.m_iSelectHint + 1] == 0 then 
        self.m_iSelectHint = 0
        -- 不能够在提示， 就不能出牌

        -- self.m_objView.m_btnChupai:setEnabled(false)  
        -- self.m_objView.m_btnChupaiFirst:setEnabled(false)
        return 
    end

    if bSearch then
		self.m_iCurTableCardTypeTemp = self.iTipsType
		self.m_iCurTableCardValueTemp = self.iTipsValue

		local vCard = {}
        for m = 1,20 do 
            if cGetCard[self.m_iSelectHint + 1][m] ~= 0 then 
                table.insert(vCard,#vCard+1,cGetCard[self.m_iSelectHint + 1][m])
            end     
        end 
        -- self:setSelectCards(vCard)
        self.GameCardLayer:selectCardWithArr(vCard)
    else
    	self.m_iCurTableCardTypeTemp = self.cTableCardType
        self.m_iCurTableCardValueTemp = self.cTableCardValue
    end

    self.m_iSelectHint = self.m_iSelectHint + 1


end
-- @param	cHandCard,  	-- 所有的手牌
-- @param	iCardCount,		-- 有效的牌的个数
-- @param	cGetCard,		-- getCard
-- @param	iGetCardNum,	-- 获取到的牌的个数
-- @param	iNowType 		-- 桌面上牌的类型
-- @param	iNowValue 		-- 桌面上牌的最大的值
-- @param   iGetType,		-- 获取时候的类型，
function ddzGameFunc:getSerchCard(cHandCard, iCardCount, cGetCard, iNowType, iNowValue, iGetType)
    print(" 找牌函数iNowType = "..iNowType) -- = 1
    print(" 找牌函数iNowValue = "..iNowValue)  
    print(" 找牌函数iGetType = "..iGetType) -- = -1
    print(" 找牌函数iCardCount = "..iCardCount) -- > 0
    if iNowType == -1 then
        return false
    end
    if iGetType ~= -1 then
        return false
    end
    if iCardCount < 0 then
        return false  
    end

    self.__iNowType = iNowType
	self.__iNowValue = iNowValue

	local vCard = {}
	-- for i = 1, iCardCount do
        -- table.insert(vCard, cHandCard[i])

	for i = 1, 20 do
		if cHandCard[i] and cHandCard[i] > 0 then
			table.insert(vCard, cHandCard[i])
		end
	end 
	-- dump(cHandCard, "cHandCard")
	-- dump(vCard, "vCard")

	if #vCard ~= iCardCount then
		-- 和统计的个数不一致
		print("ERROE", #vCard, "~=", iCardCount)
		return false  
	end


	table.sort(vCard,function(a,b)
        return b>a
    end)

	self:AnalyseHandCard(vCard)

	local bSearch = false

	if iNowType ==  101 then -- 单张
		bSearch = self:SearchSingleCard()
	elseif iNowType == 102 then 
        bSearch = self:SearchPairCard()	-- 对子
    elseif iNowType == 103 then 
        bSearch = self:SearchTriadCard()
    elseif iNowType == 104 then 
        bSearch = self:SearchTriadSingleCard()
    elseif iNowType == 105 then        
        bSearch = self:SearchTriadPairCard()
    elseif iNowType == 111 or iNowType == 112 or 
           iNowType == 113 or iNowType == 114 or 
           iNowType == 115 or iNowType == 116 or 
           iNowType == 117 or iNowType == 118 then 

        bSearch = self:SearchSingleSequence()
    elseif iNowType == 121 or iNowType == 122 or 
           iNowType == 123 or iNowType == 124 or 
           iNowType == 125 or iNowType == 126 or 
           iNowType == 127 or iNowType == 128 then 

        bSearch = self:SearchPairSequence()
    elseif iNowType == 131 or iNowType == 132 or 
           iNowType == 133 or iNowType == 134 or 
           iNowType == 135  then 

        bSearch = self:SearchTriadSequence()
    elseif iNowType == 141 or iNowType == 142 then 

        bSearch = self:SearchQuatSequence()
    elseif iNowType == 151 or iNowType == 152 or 
           iNowType == 153 or iNowType == 154 or 
           iNowType == 155 or iNowType == 156 or 
           iNowType == 157 then 

        bSearch = self:SearchPlane()
    elseif iNowType == 161 or iNowType == 162 then 
        bSearch = self:SearchBomb()
    end 

    for var = 1 ,#self.m_vOut do 
         for j = 1, 20 do 
            cGetCard[var][j] = self.m_vOut[var][j]
         end 
    end 
    
    
    if bSearch then 
        -- for var = 1 ,#cGetCard do 
        --     for j = 1 ,20 do 
        --         cGetCard[var][j] = self:TranslateCard(cGetCard[var][j])
        --     end 
        -- end
    end 

    return bSearch
end

function ddzGameFunc:SearchTriadCard()
	local i 
    local bFind = false 
    local vLegalCard = {}
    self.m_vOut = {}
    for var = 2, 2 do 
        if #self.m_vSortCard[var + 1] ~= 0 then  
            local k = 1
            for i = 1,#self.m_vSortCard[var + 1],3 do 
                k  =  k + 1
                if self.m_vSortCard[var + 1][k-1] > self.cTableCardValue then 
                    table.insert(vLegalCard ,self.m_vSortCard[var + 1][k - 1])
                    table.insert(vLegalCard ,self.m_vSortCard[var + 1][k - 1 + 1])
                    table.insert(vLegalCard ,self.m_vSortCard[var + 1][k - 1 + 2])
                    k = var + k
                    bFind = true
                else 
                    k = var + k
                end  
            end 
        end 
    end 

    dump(vLegalCard, "vLegalCard")


    -- --癞子斗地主补充
    -- if dzqp.g_tEnterData.tRule[3] == 1 then
    --     if #self.m_vSortCard[2] ~= 0 and self.m_iLaiZiCount >= 1 then
    --         for m = 1,#self.m_vSortCard[2],2 do
    --             if  self.m_vSortCard[2][m] > self.cTableCardType then 
    --                 table.insert(vLegalCard ,self.m_vSortCard[2][m])
    --                 table.insert(vLegalCard ,self.m_vSortCard[2][m + 1])
    --                 bFind = true
    --             end  
    --             --找1张癞子
    --             table.insert(vLegalCard ,self.m_cLaiZiCards[1])
    --         end
    --     end    

    --     if #self.m_vSortCard[1] ~= 0 and self.m_iLaiZiCount >= 2 then
    --         for m = 1,#self.m_vSortCard[1],2 do
    --             if  self.m_vSortCard[1][m] > self.cTableCardType and
    --                 self.m_vSortCard[1][m] ~= 25 and self.m_vSortCard[1][m] ~= 26 then 
    --                 table.insert(vLegalCard ,self.m_vSortCard[1][m])
    --                 bFind = true
    --             end  
    --             --找2张癞子
    --             table.insert(vLegalCard ,self.m_cLaiZiCards[1])
    --             table.insert(vLegalCard ,self.m_cLaiZiCards[2])
    --         end
    --     end    

    -- end

    

    local iLast = #vLegalCard
    local out = {}
    for i = 1 , iLast, 3 do 
        for var = 1, 20 do 
            out[var] = 0x00
        end 
           
        out[1] = vLegalCard[i]
        out[2] = vLegalCard[i+1]
        out[3] = vLegalCard[i+2]
        table.insert(self.m_vOut, clone(out))
    end 

    local bSearchBomb = self:SearchNormalBomb()


    dump(self.m_vSortCard, "self.m_vSortCard")
    dump(vLegalCard, "vLegalCard")

    if (#vLegalCard > 0 and bFind == true ) or bSearchBomb == true then 
        return true
    else 
        return false
    end  
end

function ddzGameFunc:TranslateCard(value)
    return value
end
--找单牌
function ddzGameFunc:SearchSingleCard()
    local i 
    local bFind = false
    
    local iSingleCardNum = 0 
    self.m_vOut = {}
    local vLegalCard = {}

    for var = 1 ,5 do 
        local vtempLegalCard = {}
        dump(self.m_vSortCard)
        if #self.m_vSortCard[var] ~= 0 then 
            for i = 1 ,#self.m_vSortCard[var] do 
                if self.m_vSortCard[var][i] > self.cTableCardValue then  
                    table.insert(vtempLegalCard,self.m_vSortCard[var][i])
                    i = i + var
                    bFind = true
                    iSingleCardNum = iSingleCardNum + 1
                end 
            end 
        end 
        local temp = {}
        for key, v in pairs(vtempLegalCard) do
            temp[v] = true
        end
        local temp1 = {}
        for key, v in pairs(temp) do
            table.insert(temp1,key)
        end
        table.sort(temp1)
        vtempLegalCard = temp1

        for key, v in pairs(vtempLegalCard) do
            table.insert(vLegalCard,v)
        end
    end
    local iLast = #vLegalCard
    local out = {}


    for i = 1, iLast do 
        for var = 1, 20 do 
            out[var] = 0
        end 
        if vLegalCard[i] > self.cTableCardValue then
            out[1] = vLegalCard[i]
            table.insert(self.m_vOut,clone(out))
        end
        
    end 

    if #self.m_vSortCard[4] ~= 0 then 
        for var = 1, 20 do 
            out[var] = 0
        end 

        local iZhaDanNum = #self.m_vSortCard[4]/4
        for i = 1,iZhaDanNum do 
            out[1] = self.m_vSortCard[4][(i - 1)*4 + 1]
            out[2] = self.m_vSortCard[4][(i - 1)*4 + 2]
            out[3] = self.m_vSortCard[4][(i - 1)*4 + 3]
            out[4] = self.m_vSortCard[4][(i - 1)*4 + 4]

            table.insert(self.m_vOut,clone(out))

            table.insert(vLegalCard,self.m_vSortCard[4][(i - 1)*4 + 1])
            table.insert(vLegalCard,self.m_vSortCard[4][(i - 1)*4 + 2])
            table.insert(vLegalCard,self.m_vSortCard[4][(i - 1)*4 + 3])
            table.insert(vLegalCard,self.m_vSortCard[4][(i - 1)*4 + 4])
            
            bFind = true
        end
    end 

    if #self.m_vSortCard[5] ~= 0 then 
        for var = 1, 20 do 
            out[var] = 0x00
        end 

        for i = 1,2 do           
            out[i] = self.m_vSortCard[5][i]
        end 

        table.insert(self.m_vOut,clone(out))
    end 

    
    if #vLegalCard > 0 and bFind == true then 
        return true
    else
        return false
    end
end

--找对子
function ddzGameFunc:SearchPairCard()
       
    local bFind = false
    local vLegalCard = {}
    self.m_vOut = {}
    local t 
    for var = 1, 3 do 
        if #self.m_vSortCard[var + 1] ~= 0 then 
            local k =  1
            if  var == 1 then  
                t = 2 
            elseif  var == 2 then 
                t = 3
            elseif  var == 3 then 
                t = 4
            end 
                
            for i = 1,#self.m_vSortCard[var + 1], t do 
                k = k + 1    
                if  self.m_vSortCard[var + 1][k -1] > self.cTableCardValue then 
                    table.insert(vLegalCard ,self.m_vSortCard[var+1][k - 1])
                    table.insert(vLegalCard ,self.m_vSortCard[var+1][k - 1 + 1])
                    k = var + k  

                    bFind = true
                else 
                    
                    k = var + k
                end  
            end 
        end 
    end

    local out = {}
    local iLast = #vLegalCard
    for i = 1, iLast,2 do 
        for var = 1, 20 do 
            out[var] = 0x00
        end 
        out[1] = vLegalCard[i]
        out[2] = vLegalCard[i + 1]
        table.insert(self.m_vOut,clone(out))
    end 
        
    local bSearchBomb = self:SearchNormalBomb()

    if ( #vLegalCard > 0 and  bFind == true ) or bSearchBomb == true then 
        return true
    else 
        return false
    end 
end



--找炸弹
function ddzGameFunc:SearchNormalBomb()
    local i,j
    local bFind = false 
    local vLegalCard = {}
    local out = {}
    for var = 1, 20 do 
        out[var] = 0x00
    end 

    if #self.m_vSortCard[4] ~= 0 then 
        for i = 1,#self.m_vSortCard[4],4 do 
            for var = 1, 20 do 
                out[var] = 0x00
            end 
            for j = 1,4 do 
                table.insert(vLegalCard,self.m_vSortCard[4][i])
                out[j] = self.m_vSortCard[4][i] 
            end 
            table.insert(self.m_vOut,clone(out))
            bFind = true
        end 
    end


    if #self.m_vSortCard[5] ~= 0 then 
        local out = {}

        for var = 1, 20 do 
            out[var] = 0x00
        end 
         
        for i = 1, 2 do 
            table.insert(vLegalCard,self.m_vSortCard[5][i])
            out[i] = self.m_vSortCard[5][i]
        end 

        table.insert(self.m_vOut,clone(out))
        bFind = true
    end 

    if bFind then 
        return true
    else 
        return false
    end 

end

function ddzGameFunc:AnalyseHandCard(cHandCard)
    self.m_vSortCard = {}
    self.m_vSortCardTable1 = {}
    self.m_vSortCardTable2 = {}
    self.m_vSortCardTable3 = {}
    self.m_vSortCardTable4 = {}
    self.m_vSortCardTable5 = {}

    self.m_vSortCard[1] = self.m_vSortCardTable1
    self.m_vSortCard[2] = self.m_vSortCardTable2
    self.m_vSortCard[3] = self.m_vSortCardTable3
    self.m_vSortCard[4] = self.m_vSortCardTable4
    self.m_vSortCard[5] = self.m_vSortCardTable5
     
    --单张牌
    self.m_vSingleSeq = {}
    -- 双
    self.m_vPairSeq = {}  
    -- 三
    self.m_vTriadSeq = {} 
    -- 
    self.m_vecAllSeq = {} 


    local vCard = clone(cHandCard)

    -- dump(cHandCard, "cHandCard")

    local iSize = #vCard
    for var = 1,iSize do 
        local value = vCard[var] 
        vCard[var] = self:ValueSwitchIn(value)
    end 

    table.insert(self.m_vSingleSeq,vCard[1])
        
    table.sort(vCard)

   	-- 把牌都扔到单张拍数组里面去
    for var =1 ,20 do 
        local hk = 1
        for k = 1, #self.m_vSingleSeq ,1 do 
            if vCard[var] == 0 or self.m_vSingleSeq[k] == vCard[var] then 
                break
            end 
            hk = hk + 1
        end 
            
        if hk == #self.m_vSingleSeq+1 then 
            table.insert(self.m_vSingleSeq, vCard[var])
        end 
    end 

    table.sort(self.m_vSingleSeq)

    -- dump(self.m_vSingleSeq, "self.m_vSingleSeq")

    -- local iMaxSize = 20 
    local iCount 
    for iSameNum = 4 ,2, -1 do 
        iCount  = 1
        for i = 2, 20 do 
            if vCard[i] ~= 0 and vCard[i - 1] == vCard[i] then 
                iCount = iCount + 1
            else 
                iCount = 1
            end 

            if iCount == iSameNum then 
                for j = 1, iSameNum do 
                    table.insert(self.m_vSortCard[iSameNum -1 + 1],vCard[i - iSameNum -1  + 1 + j])
                    vCard[i - iSameNum - 1 + 1 + j] = 0
                end 
                iCount = 1
            end 
        end 
    end 

    for var = 1, 20 do 
        if vCard[var] ~= 0 then 
            table.insert(self.m_vSortCard[1],vCard[var])
        end 
    end

    

    if vCard[#cHandCard-1] == 24 and  vCard[#cHandCard] == 25 then 
        table.insert(self.m_vSortCard[5],24)
        table.insert(self.m_vSortCard[5],25)
    end  

    for i = 2, 4 do 
        local k = 1
        for  j = 1 ,#self.m_vSortCard[i] do 
            if self.m_vSortCard[i][k] ~= 0  then 
                table.insert(self.m_vPairSeq,self.m_vSortCard[i][k])
                k = k + i
            end 
        end 
    end 

    table.sort(self.m_vPairSeq)

    -- dump(self.m_vPairSeq, "self.m_vPairSeq")

    for i = 3 ,4 do 
        local k = 1
        for j = 1,#self.m_vSortCard[i] do  
            if self.m_vSortCard[i][k] ~= 0 then 
                table.insert(self.m_vTriadSeq,self.m_vSortCard[i][k])
                k = k + i
            end  
        end 
    end 

    table.sort(self.m_vTriadSeq)

    -- dump(self.m_vTriadSeq, "self.m_vTriadSeq")

    local iNum  = 0 

    for var = 1 ,4 do 
        for  j  = 1 ,#self.m_vSortCard[var] do 
            iNum = iNum + 1
        end 
    end 

    iNum = 0 
    for j = 1,#self.m_vSingleSeq do 
        iNum = iNum + 1
    end   
    
    iNum = 0
    for j = 1 ,#self.m_vPairSeq do 
        iNum = iNum + 1
    end  

    iNum = 0
    for j = 1,#self.m_vTriadSeq  do 
        iNum = iNum + 1
    end
        
    return 1 
end


function ddzGameFunc:ValueSwitchIn(value)
    
    value = math.floor(value % 100)
    return value
end

function ddzGameFunc:getCardValue(value)
    return math.floor(value % 100)
end 


function ddzGameFunc:checkCardValue(value)
    local temp 
    local var = math.floor(value % 100)
    if var then
    	temp = var
    end
    return temp
end


-- 刷新出的牌
function ddzGameFunc:refreshSendCard( iPos )


    if iPos < 1 or iPos > 3 then
        print("ERROR::refreshSendCard, iPos = ", iPos)    
    end
	
	for i, v in pairs(self.t_nodeSendCards[iPos]) do 
		v:removeSelf()
	end
	self.t_nodeSendCards[iPos] = {}

	local cards = self.t_SendCards[iPos]
	-- 起始位置
	-- 计算出多少间距
	local _SPACEING = 35
    local _BEGANPOSX = 200
    local _MIDPOSX = display.cx

    local _MIDPOSY = 500

    local isDan = math.floor(#cards % 2) == 1 

    if isDan then
        _BEGANPOSX = _MIDPOSX - (#cards / 2) * _SPACEING
    else
        _BEGANPOSX = _MIDPOSX + (_SPACEING / 2) - (#cards / 2) * _SPACEING
    end	

    if iPos == 1 then
    	_MIDPOSY = 500
    	_BEGANPOSX = 200
    elseif iPos == 2 then
    	_MIDPOSY = 280
    elseif iPos == 3 then
    	_MIDPOSY = 500
    	local cardNums = #cards > 10 and 10 or #cards
    	_BEGANPOSX = display.width - 250 - cardNums*_SPACEING
    end

   	local tempCards = self:sortCard(cards)
   	-- dump(tempCards)
	for i, v in ipairs(tempCards) do 
		local card = Card:createCard(v)

		if i > 10 and iPos ~= 2 then
			card:setPosition((i-11)*_SPACEING + _BEGANPOSX, _MIDPOSY - 50)
		else
			card:setPosition((i-1)*_SPACEING + _BEGANPOSX, _MIDPOSY)
		end 
		card:addTo(self.GameCardLayer)	
		card:setScale(0.4)

		table.insert(self.t_nodeSendCards[iPos], card)
	end
end

function ddzGameFunc:sortCard( cards )
	local cardTable = {}
    local arg_num = 0
    for i, v in pairs(cards) do 
        table.insert(cardTable, v)
        arg_num = arg_num + 1
    end

    local iTemp = {}
    if arg_num > 0 then
        local iNowType, arg_value = JudgeCard:JudgeCardShape(cardTable, arg_num, arg_value)
        -- 飞机
        print("iNowType, arg_value", iNowType, arg_value)
        if iNowType  and iNowType >= JudgeCard.TYPE_PLANE_TWO_WING_SIGLE and iNowType <= JudgeCard.TYPE_PLANE_FIVE_WING_SIGLE then
        	-- 检索出飞机
        	local planeNum = iNowType - 150

        	for i = arg_value - planeNum, arg_value  do 
        		for j = 1, 3 do
        			-- 保存下和这个值相等的card值
        			-- table.insert(iTemp, i)
        			for z = 1, #cardTable do 
        				if math.floor(cardTable[z] % 100) == i then
        					table.insert(iTemp, cardTable[z]) 
        					cardTable[z] = 0 
        					break
    					end
    				end
				end
        	end	

        	dump(cardTable, "cardTable")
        	dump(iTemp, "iTemp")

	        for i = 1, #cardTable do 
				if cardTable[i] ~= 0 then
					table.insert(iTemp, cardTable[i])
				end
			end

			return iTemp
		end
    end

    table.sort(cards, function( a, b )
    	return math.floor(a % 100) < math.floor(b % 100)
    end)

    return cards
end

-- 叫地主和不叫地主
function ddzGameFunc:sendMainReq( beMain )

	local arg = {}
	if beMain == true or beMain == 1 then
		
	else

	end
	-- 没有定义协议。 需要的时候做， 可以使用cmd
	-- lt.NetWork:sendTo(lt.GameEventManager.EVENT.mian, arg)
end

-- 发送是否加倍
function ddzGameFunc:sendDoubleReq(beDoub)
	
end


-- sendReadyReq
-- @param pos in index
function ddzGameFunc:sendReadyReq( pos )
	print("ddzGameFunc::sendReady ")
	local arg = {pos = self:getMyExtraNum()}
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.SIT_DOWN, arg)
end

function ddzGameFunc:sendDemand( point )
	print("ddzGameFunc sendDemand:", point)
	local arg = {
		command =  "DEMAND",
		demandPoint = point,
	}	

	self.nodeDemand:setVisible(false)
	if self.bDemand == true then
		return
	end

	dump(arg, "sendDemand")

	self.bDemand = true

    lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
end

function ddzGameFunc:sendCardReq( iCardList )
	print("ddzGameFunc:sendCardReq")
	local tempList = {}
	if not iCardList then
		iCardList = self.playCardLayer.tSelect
	end

	for _, v in pairs(iCardList) do 
		if v.iCard ~= 0 then
			table.insert(tempList, v.iCard)
		end 
	end

	-- if not tempList then
	-- 	print("iCardList:sendCardReq, not iCardList")
	-- end

    local iCardNums = 0
    for i, v in pairs(tempList) do 
        if v ~= 0 then
            iCardNums = iCardNums + 1
        end
    end
    
    -- 验证是否能出？ 分为自己牌权和别人牌权，大多是自己牌权的时候
    -- 自己牌权的时候不允许出空牌
    if self.iTablePlayer == 2 or self.iTablePlayer == 0 then
        if #tempList == 0 then
            print("ERROR::#tempList == ", #tempList)
            return
        end
        if self.iNowType == nil or self.iNowType == -1 then
            print("ERROR::self.iNowType = ", self.iNowType)
            return
        end
        local iNowType, arg_value = -1, -1
        iNowType, arg_value = JudgeCard:JudgeCardShape(tempList, iCardNums, arg_value)

        if iNowType ~= self.iNowType then
            print("ERROR::::iNowType == self.iNowType", iNowType, self.iNowType)
            return
        end
    end

	if self.iNowType == nil or self.iNowValue == nil then
		print("ERROR: not self.iNowType or self.iNowType", self.iNowType, self.iNowValue)
        return
	end

    if not self.bCanSendCard then
        print("没有出牌权限， 已经出过牌， 或者不是自己出牌")
        return
    end
    self.bCanSendCard = false

	if iCardNums == 0 then
		self.GameCardLayer:unSelectAllCard()
	end

	local arg = {
		command = "PLAY_CARD",
		cardList = tempList,
		nowType = self.iNowType,		-- 当前的牌型
		nowValue = self.iNowValue, 		-- 当前牌型判断的最大值
		cardNums = iCardNums,
	}
	dump(arg, "GAME_CMD")
    lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
end	


--三带一
function ddzGameFunc:SearchTriadSingleCard()
    local i ,j
    local bFind = false
    local vLegalCard = {}
    self.m_vOut = {}
    local t = 0
    for iCount = 2, 3  do 
        local k = 1 
        if iCount == 2 then 
            t = 3
        else 
            t = 4
        end 
              
        if #self.m_vSortCard[iCount + 1] ~= 0 then 
            for i = 1,#self.m_vSortCard[iCount + 1],t do 
                k = k + 1
                if self.m_vSortCard[iCount + 1][ k -1] > self.cTableCardValue then 
                    table.insert(vLegalCard ,self.m_vSortCard[iCount + 1][k - 1])
                    table.insert(vLegalCard ,self.m_vSortCard[iCount + 1][k - 1 + 1])
                    table.insert(vLegalCard ,self.m_vSortCard[iCount + 1][k - 1 + 2])
                    k = k + iCount
                else 
                    k = k + iCount
                end 
            end
        end  
    end 

    -- --癞子斗地主补充
    -- if dzqp.g_tEnterData.tRule[3] == 1 then
    --     if #self.m_vSortCard[2] ~= 0 and self.m_iLaiZiCount >= 1 then
    --         for m = 1,#self.m_vSortCard[2],2 do
    --             if  self.m_vSortCard[2][m] > self.cTableCardType then 
    --                 table.insert(vLegalCard ,self.m_vSortCard[2][m])
    --                 table.insert(vLegalCard ,self.m_vSortCard[2][m + 1])
    --             end  
    --             --找1张癞子
    --             table.insert(vLegalCard ,self.m_cLaiZiCards[1])
    --         end
    --     end    

    --     if #self.m_vSingleSeq >= 3 then
    --         if #self.m_vSortCard[1] ~= 0 and self.m_iLaiZiCount >= 2 then
    --             for m = 1,#self.m_vSortCard[1],2 do
    --                 if  self.m_vSortCard[1][m] > self.cTableCardType and
    --                     self.m_vSortCard[1][m] ~= 25 and self.m_vSortCard[1][m] ~= 26 then 
    --                     table.insert(vLegalCard ,self.m_vSortCard[1][m])
    --                 end  
    --                 --找2张癞子
    --                 table.insert(vLegalCard ,self.m_cLaiZiCards[1])
    --                 table.insert(vLegalCard ,self.m_cLaiZiCards[2])
    --             end
    --         end  
    --     end
          
    -- end


    if #vLegalCard > 0 then --找单张
        for i = 1, 5 do 
            for j = 1, #self.m_vSortCard[i] do 
                if vLegalCard[1] ~= self.m_vSortCard[i][j] then 
                    table.insert(vLegalCard ,self.m_vSortCard[i][j]) 
                    if i < 5 then 
                        j  = j + i
                    end 
                    bFind = true
                    break
                end  
            end 

            if bFind == true then 
                break
            end 
        end 
    end 

    local iLast = #vLegalCard
    local k = (iLast - 1)/3
    j = 0
    local out = {}
    local h = 1
    for i = 1,iLast-1,3*j do 
        if j == 0 then  
            h = h
        else 
            h = 3*j + h
        end 
               
        for var = 1, 20 do 
            out[var] = 0x00
        end 

        out[1] = vLegalCard[h]
        out[2] = vLegalCard[h+1]
        out[3] = vLegalCard[h+2]
        out[4] = vLegalCard[iLast]
        j = j + 1
        table.insert(self.m_vOut,clone(out))
        if j >= k then 
            break
        end 
    end 

    local bSeachBomb = self:SearchNormalBomb()
    if (#vLegalCard > 0 and bFind == true ) or bSeachBomb == true then 
        return true
    else 
        return false
    end  
end

--三带二
function ddzGameFunc:SearchTriadPairCard()
        
    local i ,j
    local bFind = false
    local vLegalCard = {}
    self.m_vOut = {}
    local t = 0
    for iCount = 2, 3  do 
        local  k = 1
        if iCount == 2 then 
            t = 3
        else 
            t = 4
        end 

        if #self.m_vSortCard[iCount+ 1] ~= 0 then 
            for i = 1, #self.m_vSortCard[iCount + 1],t do   
                k = k + 1
                if self.m_vSortCard[iCount+ 1][k -1 ] > self.cTableCardValue then 
                    table.insert(vLegalCard ,self.m_vSortCard[iCount + 1][k - 1])
                    table.insert(vLegalCard ,self.m_vSortCard[iCount + 1][k - 1 + 1])
                    table.insert(vLegalCard ,self.m_vSortCard[iCount + 1][k - 1 + 2])
                    k  = k + iCount
                else 
                    k  = k + iCount
                end 
            end
        end  
    end 

    local vPairCard = {}

    --癞子斗地主补充
    -- if dzqp.g_tEnterData.tRule[3] == 1 then
    --     if #self.m_vPairSeq >= 3 then
    --         if #self.m_vSortCard[2] ~= 0 and self.m_iLaiZiCount >= 1 then
    --             for m = 1,#self.m_vSortCard[2],2 do
    --                 if  self.m_vSortCard[2][m] > self.cTableCardType then 
    --                     table.insert(vLegalCard ,self.m_vSortCard[2][m])
    --                     table.insert(vLegalCard ,self.m_vSortCard[2][m + 1])
    --                 end  
    --                 --找1张癞子
    --                 table.insert(vLegalCard ,self.m_cLaiZiCards[1])
    --             end
    --         end
    --     end
            
        
    --     if #self.m_vSortCard[1] ~= 0 and self.m_iLaiZiCount >= 2 then
    --         for m = 1,#self.m_vSortCard[1],2 do
    --             if  self.m_vSortCard[1][m] > self.cTableCardType and
    --                 self.m_vSortCard[1][m] ~= 25 and self.m_vSortCard[1][m] ~= 26 then 
    --                 table.insert(vLegalCard ,self.m_vSortCard[1][m])
    --             end  
    --             --找2张癞子
    --             table.insert(vLegalCard ,self.m_cLaiZiCards[1])
    --             table.insert(vLegalCard ,self.m_cLaiZiCards[2])
    --         end
    --     end
    -- end

    if #vLegalCard > 0 then 
        for i = 1, 3 do 
            if #self.m_vSortCard[i+1] > 0 then 
                local k = 1
                if i == 1 then 
                    t = 2
                elseif i == 2 then 
                    t = 3 
                else 
                    t = 4
                end 

                for j = 1,#self.m_vSortCard[i + 1],t do 
                    k = k + 1
                    table.insert(vPairCard,self.m_vSortCard[i + 1][k - 1])
                    table.insert(vPairCard,self.m_vSortCard[i + 1][k - 1])
                    bFind = true
                    if i == 1 then   
                        k = k + i 
                    elseif i == 2 then 
                        k = k + i
                    else
                        k = k + i
                    end  
                end 
            end 
        end 
    end 

    if bFind then 
        for iThreeNum = 1 ,#vLegalCard/3 do 
            for iPairNum = 1, #vPairCard/2 do 
                if #vPairCard == 2 then 
                    if vLegalCard[(iThreeNum - 1)*3 + 1] == vPairCard[(iPairNum - 1)*2 + 1]  then 
                        bFind = false
                        break
                    end 
                end
                if  vLegalCard[(iThreeNum - 1)*3 + 1 ] ~= vPairCard[(iPairNum - 1)*2 + 1]  then 
                    local out = {}
                    for var = 1, 20 do 
                        out[var] = 0x00
                    end 
                                
                    out[1] = vLegalCard[(iThreeNum - 1)*3 + 1]
                    out[2] = vLegalCard[(iThreeNum - 1)*3 + 2]
                    out[3] = vLegalCard[(iThreeNum - 1)*3 + 3]
                    out[4] = vPairCard[(iPairNum-1)*2 + 1]
                    out[5] = vPairCard[(iPairNum-1)*2 + 2]
                    table.insert( self.m_vOut,clone(out))
                    bFind = true
                end 
            end  
        end 
    end 

    local bSeachBomb = self:SearchNormalBomb()
    if (#vLegalCard > 0 and bFind == true ) or bSeachBomb ==true then 
        return true
    else 
        return false
    end  
end

--单顺牌
function ddzGameFunc:SearchSingleSequence()
    local i , j 
    local  bFind = false 
    local vLegalCard = {}
    self.m_vOut = {}
    local iSequenceCount = self.cTableCardType - 111 + 5
    local iBegin = #self.m_vSingleSeq - 1

    for i = 1,  #self.m_vSingleSeq  do 
        if self.m_vSingleSeq[i] > (self.cTableCardValue - iSequenceCount + 1) then 
            iBegin  = i 
            break
        end 
    end 

    local iCount = 1
    for k = iBegin ,#self.m_vSingleSeq - 4   do 
        iCount = 1
        for i = k,k+ iSequenceCount - 1  do 
            if i <= #self.m_vSingleSeq then
                if self.m_vSingleSeq[i] + 1 == self.m_vSingleSeq[i+1] then 
                    iCount = iCount + 1
                else  
                    iCount = 1
                end  

                if iCount == iSequenceCount then 
                    if self.m_vSingleSeq[i - iCount + 1 + 1] > (self.cTableCardValue  - iSequenceCount + 1) then 
                        for j = 1, iSequenceCount do 
                            table.insert(vLegalCard, self.m_vSingleSeq[i - iCount + 1 + j])
                        end 
                        bFind = true
                        break
                    end 
                end 
                if iCount == 1 then 
                    break
                end 
            end 
        end 
    end  
       
    local iLast = #vLegalCard
    local out = {} 
    for j = 1, iLast/iSequenceCount do 
        for var = 1, 20 do 
            out[var] = 0x00
        end 
        local iIndex = 1
        for i = (j - 1)* iSequenceCount + 1 ,(j)*iSequenceCount do 
            out[iIndex] = vLegalCard[i]
            iIndex = iIndex + 1
        end 

        table.insert( self.m_vOut,clone(out))
    end 

    local bSeachBomb = self:SearchNormalBomb()
    if (#vLegalCard > 0 and bFind == true ) or bSeachBomb ==true then 
        return true
    else 
        return false
    end  

end

--双顺牌
function ddzGameFunc:SearchPairSequence() 
    local i , j 
    local bFind = false 
    local vLegalCard = {}
    self.m_vOut = {}
    local iSequenceCount = self.cTableCardType - 121 + 3
    local iBegin = #self.m_vPairSeq - 1

    for i = 1,  #self.m_vPairSeq  do 
        if self.m_vPairSeq[i] > (self.cTableCardValue - iSequenceCount + 1) then 
            iBegin  = i 
            break
        end 
    end 

    local iCount = 1
    for  k = iBegin  ,#self.m_vPairSeq - 2   do 
        iCount = 1
        for i = k, k+ iSequenceCount - 2  do 
            if i < #self.m_vPairSeq then
                if self.m_vPairSeq[i + 1] - 1  == self.m_vPairSeq[i + 1-1] then 
                    iCount = iCount + 1
                else  
                    iCount = 1
                end  

                if  iCount == iSequenceCount then 
                    if self.m_vPairSeq[i + 1 - iCount + 1] > (self.cTableCardValue - iSequenceCount + 1) then 
                        local iIndex = 0
                        for j = 1, iSequenceCount do 
                                   
                            table.insert(vLegalCard, self.m_vPairSeq[i + 1 - iCount + 1 + j - 1])
                            table.insert(vLegalCard, self.m_vPairSeq[i + 1 - iCount + 1 + j - 1])
                            iIndex = iIndex + 2
                        end 
                        bFind = true
                        iCount = 1
                        break
                    end 
                end 
            end 
        end 
    end  
       
    local iLast = #vLegalCard
    local out = {}
    for j = 1, iLast/(iSequenceCount*2) do 
        for var = 1, 20 do 
            out[var] = 0x00

        end 

        local iIndex = 1
        for i =(j-1) * iSequenceCount*2 + 1, (j)*iSequenceCount*2 do 
            out[iIndex] = vLegalCard[i]
            iIndex = iIndex + 1
        end 

        table.insert( self.m_vOut,clone(out))
    end 

    local bSeachBomb = self:SearchNormalBomb()

    if (#vLegalCard > 0 and bFind == true ) or bSeachBomb ==true then 
        return true
    else 
        return false
    end  
end 

--三顺
function ddzGameFunc:SearchTriadSequence()
    local i ,j 
    local bFind = false 
    local vLegalCard = {}
    self.m_vOut = {}
    local iSequenceCount = self.cTableCardType - 131 + 2
    local iBegin = #self.m_vTriadSeq - 1

    for i = 1,  #self.m_vTriadSeq  do 
        if self.m_vTriadSeq[i] > (self.cTableCardValue - iSequenceCount + 1) then 
            iBegin  = i 
            break
        end 
    end 

    local  iCount = 1
    for k = iBegin  ,#self.m_vTriadSeq - 1   do 
        iCount = 1
        for i = k,  k+ iSequenceCount -2  do 
            if #self.m_vTriadSeq > 0 then
                if i < #self.m_vTriadSeq then 
                    if self.m_vTriadSeq[i + 1] - 1  == self.m_vTriadSeq[i + 1 - 1] then 
                        iCount = iCount + 1
                    else 
                                
                        iCount = 1
                    end  

                    if iCount == iSequenceCount then 
                        if self.m_vTriadSeq[i + 1 - iCount + 1] > (self.cTableCardValue - iSequenceCount + 1) then 
                            local iIndex = 0
                            for j = 1, iSequenceCount do 
                                table.insert(vLegalCard, self.m_vTriadSeq[i + 1 - iCount + 1 + j - 1])
                                table.insert(vLegalCard, self.m_vTriadSeq[i + 1 - iCount + 1 + j - 1])
                                table.insert(vLegalCard, self.m_vTriadSeq[i + 1 - iCount + 1 + j - 1])
                                iIndex = iIndex + 3
                            end 
                            bFind = true
                            iCount = 1
                            break
                        end 
                    end
                end   
            end 
        end
    end  
       
    local iLast = #vLegalCard
    local out = {}
    for j = 1, iLast/(iSequenceCount*3) do 
              
        for var = 1, 20 do 
            out[var] = 0x00
        end 

        local iIndex = 1
        for i = (j -1) * iSequenceCount*3 + 1, (j)*iSequenceCount*3 do 
            out[iIndex] = vLegalCard[i]
            iIndex = iIndex + 1
        end 

        table.insert( self.m_vOut,clone(out))
    end 

    local bSeachBomb = self:SearchNormalBomb()
    if (#vLegalCard > 0 and bFind == true ) or bSeachBomb == true then 
        return true
    else 
        return false
    end  
end

--四带两单   四带两对
function ddzGameFunc:SearchQuatSequence() 
    local i,j
    local vLegalCard = {}
    local bFind = false
    local out = {}
    self.m_vOut = {}
    for var = 1, 20 do 
        out[var] = 0x00
    end 

    local iSequenceCount = self.cTableCardType - 141
    local  k =  #self.m_vSortCard[4]
    for  j = #self.m_vSortCard[4] , 1 ,-3 do  
        for i =#self.m_vPairSeq, 1 ,-1 do 
            if self.m_vSortCard[4][j] == self.m_vPairSeq[i] then
                table.remove(self.m_vPairSeq,i)
                break
            end 
        end 

        for i = #self.m_vSingleSeq ,1,-1 do 
            if self.m_vSortCard[4][j] == self.m_vSingleSeq[i]then 
                table.remove(self.m_vSingleSeq,i) 
                break
            end 
        end 
    end 
           
    if  #self.m_vSortCard[4] ~= 0 then  
        for j = 1, #self.m_vSortCard[4] ,3  do 
            if iSequenceCount ==1 and self.m_vSortCard[4][j] > self.cTableCardValue 
                and  #self.m_vPairSeq  >= 2 then --四带两对
                for  i = 1, 4 do 
                    table.insert(vLegalCard,self.m_vSortCard[4][j])
                end 
                table.insert(vLegalCard,self.m_vPairSeq[1])
                table.insert(vLegalCard,self.m_vPairSeq[1])
                table.insert(vLegalCard,self.m_vPairSeq[2])
                table.insert(vLegalCard,self.m_vPairSeq[2])
                for var = 1, 20 do 
                    out[var] = 0x00
                end 
                for i = 1 , 4 do 
                    out[i] = self.m_vSortCard[4][j]
                end 
                out[5] = self.m_vPairSeq[1]
                out[6] = self.m_vPairSeq[1]
                out[7] = self.m_vPairSeq[2]
                out[8] = self.m_vPairSeq[2]
                table.insert(self.m_vOut,clone(out))
                          
                bFind = true
            elseif iSequenceCount == 0 and self.m_vSortCard[4][j] >self.cTableCardValue 
                and  #self.m_vSingleSeq >= 2 then --四带两单
                           
                for i= 1 , 4 do 
                    table.insert(vLegalCard,self.m_vSortCard[4][j])
                end 
                table.insert(vLegalCard,self.m_vSingleSeq[1])
                table.insert(vLegalCard,self.m_vSingleSeq[2])
                            
                for var = 1, 20 do 
                    out[var] = 0x00
                end    

                for i = 1, 4 do 
                    out[i] = self.m_vSortCard[4][j]
                end     
                out[5] = self.m_vSingleSeq[1]
                out[6] = self.m_vSingleSeq[2]
                table.insert(self.m_vOut,clone(out)) 
                bFind = true
            end 
        end
    end 

    --癞子斗地主补充   (1张癞子一个三张)
    -- if dzqp.g_tEnterData.tRule[3] == 1 then
    --     if iSequenceCount == 1 and #self.m_vPairSeq >= 2 then
    --         if #self.m_vSortCard[3] ~= 0 and self.m_iLaiZiCount >= 1 then
    --             for m = 1,#self.m_vSortCard[3],3 do
    --                 if  self.m_vSortCard[3][m] > self.cTableCardType then 
    --                     table.insert(vLegalCard ,self.m_vSortCard[3][m])
    --                     table.insert(vLegalCard ,self.m_vSortCard[3][m + 1])
    --                     table.insert(vLegalCard ,self.m_vSortCard[3][m + 2])
    --                 end  
    --                 --找1张癞子
    --                 table.insert(vLegalCard ,self.m_cLaiZiCards[1])

    --                 --找2对
    --                 table.insert(vLegalCard,self.m_vPairSeq[1])
    --                 table.insert(vLegalCard,self.m_vPairSeq[1])
    --                 table.insert(vLegalCard,self.m_vPairSeq[2])
    --                 table.insert(vLegalCard,self.m_vPairSeq[2])
    --                 for var = 1, 20 do 
    --                     out[var] = 0x00
    --                 end 
    --                 for i = 1 , 4 do 
    --                     out[i] = self.m_vSortCard[4][j]
    --                 end 
    --                 out[5] = self.m_vPairSeq[1]
    --                 out[6] = self.m_vPairSeq[1]
    --                 out[7] = self.m_vPairSeq[2]
    --                 out[8] = self.m_vPairSeq[2]
    --                 table.insert(self.m_vOut,clone(out))
                              
    --                 bFind = true
    --             end
    --         end  
    --     elseif iSequenceCount == 0 and #self.m_vSingleSeq >= 2 then --四带两单
    --         if #self.m_vSortCard[3] ~= 0 and self.m_iLaiZiCount >= 1 then
    --             for m = 1,#self.m_vSortCard[3],3 do
    --                 if  self.m_vSortCard[3][m] > self.cTableCardType then 
    --                     table.insert(vLegalCard ,self.m_vSortCard[3][m])
    --                     table.insert(vLegalCard ,self.m_vSortCard[3][m + 1])
    --                     table.insert(vLegalCard ,self.m_vSortCard[3][m + 2])
    --                 end  
    --                 --找1张癞子
    --                 table.insert(vLegalCard ,self.m_cLaiZiCards[1])

    --                 --找2单
    --                 table.insert(vLegalCard,self.m_vSingleSeq[1])
    --                 table.insert(vLegalCard,self.m_vSingleSeq[2])
                                
    --                 for var = 1, 20 do 
    --                     out[var] = 0x00
    --                 end    

    --                 for i = 1, 4 do 
    --                     out[i] = self.m_vSortCard[4][j]
    --                 end     
    --                 out[5] = self.m_vSingleSeq[1]
    --                 out[6] = self.m_vSingleSeq[2]
    --                 table.insert(self.m_vOut,clone(out)) 
    --                 bFind = true
    --             end
    --         end
    --     end
    -- end

    --癞子斗地主补充   (2张癞子一个对子)
    -- if dzqp.g_tEnterData.tRule[3] == 1 then
    --     if iSequenceCount == 1 and #self.m_vPairSeq >= 3 then
    --         if #self.m_vSortCard[2] ~= 0 and self.m_iLaiZiCount >= 2 then
    --             for m = 1,#self.m_vSortCard[2],2 do
    --                 if  self.m_vSortCard[2][m] > self.cTableCardType then 
    --                     table.insert(vLegalCard ,self.m_vSortCard[2][m])
    --                     table.insert(vLegalCard ,self.m_vSortCard[2][m + 1])
    --                 end  
    --                 --找2张癞子
    --                 table.insert(vLegalCard ,self.m_cLaiZiCards[1])
    --                 table.insert(vLegalCard ,self.m_cLaiZiCards[2])

    --                 --找2对
    --                 table.insert(vLegalCard,self.m_vPairSeq[1])
    --                 table.insert(vLegalCard,self.m_vPairSeq[1])
    --                 table.insert(vLegalCard,self.m_vPairSeq[2])
    --                 table.insert(vLegalCard,self.m_vPairSeq[2])
    --                 for var = 1, 20 do 
    --                     out[var] = 0x00
    --                 end 
    --                 for i = 1 , 4 do 
    --                     out[i] = self.m_vSortCard[4][j]
    --                 end 
    --                 out[5] = self.m_vPairSeq[1]
    --                 out[6] = self.m_vPairSeq[1]
    --                 out[7] = self.m_vPairSeq[2]
    --                 out[8] = self.m_vPairSeq[2]
    --                 table.insert(self.m_vOut,clone(out))
                              
    --                 bFind = true
    --             end
    --         end  
    --     elseif iSequenceCount == 0 and #self.m_vSingleSeq >= 2 then --四带两单
    --         if #self.m_vSortCard[2] ~= 0 and self.m_iLaiZiCount >= 1 then
    --             for m = 1,#self.m_vSortCard[2],2 do
    --                 if  self.m_vSortCard[2][m] > self.cTableCardType then 
    --                     table.insert(vLegalCard ,self.m_vSortCard[2][m])
    --                     table.insert(vLegalCard ,self.m_vSortCard[2][m + 1])
    --                 end  
    --                 --找2张癞子
    --                 table.insert(vLegalCard ,self.m_cLaiZiCards[1])
    --                 table.insert(vLegalCard ,self.m_cLaiZiCards[2])
    --                 --找2单
    --                 table.insert(vLegalCard,self.m_vSingleSeq[1])
    --                 table.insert(vLegalCard,self.m_vSingleSeq[2])
                                
    --                 for var = 1, 20 do 
    --                     out[var] = 0x00
    --                 end    

    --                 for i = 1, 4 do 
    --                     out[i] = self.m_vSortCard[4][j]
    --                 end     
    --                 out[5] = self.m_vSingleSeq[1]
    --                 out[6] = self.m_vSingleSeq[2]
    --                 table.insert(self.m_vOut,clone(out)) 
    --                 bFind = true
    --             end
    --         end
    --     end
    -- end

    local bSeachBomb = self:SearchNormalBomb()
	if bFind == true or bSeachBomb ==true then
		return true
	else
		return false
    end 
end

--飞机
function ddzGameFunc:SearchPlane()
    local bFind = false  
    local bFindSeq = false
    self.m_vOut={}
    local iSequenceCount = 0
    if self.cTableCardType == 151 or self.cTableCardValue == 152 then 
        iSequenceCount = 2
    elseif  self.cTableCardValue == 153 or self.cTableCardValue == 154 then 
        iSequenceCount = 3
    elseif  self.cTableCardValue == 155 or self.cTableCardValue == 156 then
        iSequenceCount = 4 
    elseif  self.cTableCardValue == 157 then  
        iSequenceCount = 5 
    end 

    local vLegalCard
    local vTriadSeq = {}
    if #self.m_vTriadSeq > 0 then 
        local iBegin = #self.m_vTriadSeq - 1 
        if 1 then 
            for i = 1, #self.m_vTriadSeq do 
                if self.m_vTriadSeq[i] > self.cTableCardValue - iSequenceCount + 1 then 
                    iBegin = i
                    break
                end   
            end 
        end
        local iCount = 1
        for i = iBegin ,  #self.m_vTriadSeq - 1 do 
            if  self.m_vTriadSeq[i + 1] - 1  == self.m_vTriadSeq[i + 1 - 1] then
                iCount = iCount + 1
            else  
                iCount = 1
            end 

            if iCount == iSequenceCount then 
                if self.m_vTriadSeq[i+ 1 - iCount + 1]  > self.cTableCardValue - iSequenceCount + 1 then 
                    local vOneSeq = {}
                    local iIndex = 1
                    for j= 1,iSequenceCount do 
                        table.insert(vOneSeq,self.m_vTriadSeq[i + 1- iCount + 1 + j-1] )
                        table.insert(vOneSeq,self.m_vTriadSeq[i + 1- iCount + 1 + j - 1])
                        table.insert(vOneSeq,self.m_vTriadSeq[i + 1- iCount + 1 + j - 1])
                    end  
                    bFindSeq = true
                    table.insert(vTriadSeq,vOneSeq)
                    i  = i + 1 - (iCount - 2) -1
                    
                end 
               
                iCount = 1
            end 
        end 
    end 

    if bFindSeq == true then 
        local  bNeedPair = false    
        if self.cTableCardType == 154 or self.cTableCardType == 155
            or self.cTableCardType == 156 then 
            bNeedPair = true
        end 
            
        if self.m_bAppropriate == true  then
            local vSingleSeq = {}
            self:FindCombinatoryOfSingleOrPairInHandCard(iSequenceCount,vSingleSeq,bNeedPairbNeedPair)
            local a
            for a = 1,#vTriadSeq do 
                for b = 1,#vSingleSeq do    
                    for  i = 1,#vSingleSeq[b] do 
                                
                        if vTriadSeq[a][i] == vSingleSeq[b][i]  then 
                            break
                        end 

                    end 
                end 
            end 

            for m = 1,#vSingleSeq do 
                if a == vSingleSeq[m] then 
                    local out = {}
                    for var = 1, 20 do 
                        out[var] = 0x00
                    end 
                    local iIndex = 0 
                    for h = 1 ,#vSingleSeq[m] do 
                                   
                        iIndex = iIndex + 1
                        for q = 1,#vTriadSeq do
                            out[iIndex] = vTriadSeq[q][a]
                        end 
                    end
                               
                    for k = 1 ,#vSingleSeq[k]  do 
                        iIndex = iIndex + 1
                        for r = 1 ,#vSingleSeq do 
                            out[iIndex] = vTriadSeq[r][k]
                        end
                        if  bNeedPair then 
                            iIndex = iIndex + 1
                            for r = 1 ,#vSingleSeq do 
                                out[iIndex] = vTriadSeq[r][k]
                            end
                        end 
                    end 
                    table.insert(self.m_vOut,clone(out))
                    bFind = true

                               
                end
            end 
                   
        else --(self.m_bAppropriate == false )
            -- //点提示的时候除了三张的切换，翅膀不用切换，所以翅膀只要找到最小满足就ok
            for a = 1 ,#vTriadSeq do 
                local bFindWith = false
                local vLegalCard = {}
                     
                local i = 0
                local iMaxSame = 5
                if  bNeedPair == true  then 
                         
                    i = 1
                    iMaxSame = 4
                end 
                if bNeedPair == true  then  -- (i =1 ,iMaxSame = 4)
                    for b = 2,iMaxSame  do 
                        for c = 1 ,#self.m_vSortCard[b] do 
                            if  self:isIncludeIt(vTriadSeq[a],self.m_vSortCard[b][c]) == false then 
                                table.insert(vLegalCard,self.m_vSortCard[b][c] )
                                if bNeedPair then 
                                    table.insert(vLegalCard,self.m_vSortCard[b][c] )
                                end 
                                if #vLegalCard ==iSequenceCount * ( 1 + 1) then 
                                    bFindWith = true
                                    break
                                end 
                            end 
                            if b < 4 then 
                            c = c + b  
                            end 
                        end 

                        if bFindWith then 
                            break
                        end
                    end 
                            
                    if bFindWith then 
                        local out = {}
                        for var = 1, 20 do 
                            out[var] = 0x00

                        end  
                             
                        local iIndex = 0 
                        for var = 1, #vTriadSeq do 
                            for b = 1 ,#vTriadSeq[var] do 
                                iIndex = iIndex + 1
                                out[iIndex] = vTriadSeq[var][b]
                            end
                        end 
                             
                        for c = 1 ,#vLegalCard do 
                            iIndex = iIndex + 1
                            out[iIndex] = vLegalCard[b]
                        end                    
                                 
                        table.insert(self.m_vOut,out)
                        bFind = true
                    end 

                else -- bNeedPair == false
                       
                    for b = 1,iMaxSame  do 

                        for c = 1 ,#self.m_vSortCard[b] do 
                              
                            if  self:isIncludeIt(vTriadSeq[a],self.m_vSortCard[b][c]) == false then 
                                  
                                table.insert(vLegalCard,self.m_vSortCard[b][c] )
                                if bNeedPair then 
                                    table.insert(vLegalCard,self.m_vSortCard[b][c] )
                                end 
                                           
                                if #vLegalCard ==iSequenceCount * (1 + 0)then 
                                    bFindWith = true
                                    break      
                                end 
                                       
                                       
                            end 
                              
                            if b < 4 then 
                                c = c + b  
                            end 
                        end   
                   
                        if bFindWith then 
                            break
                        end
                        
                    end 
                    
                    if bFindWith then 
                        local out = {}
                        for var = 1, 20 do 
                            out[var] = 0x00

                        end  
                             
                        -- local iIndex = 0 
                        for var = 1, #vTriadSeq do 
                            local iIndex = 0 
                            for b = 1 ,#vTriadSeq[var] do 
                                iIndex = iIndex + 1
                                          
                                out[iIndex] = vTriadSeq[var][b]
                            end                                         
                            for c = 1 ,#vLegalCard do 
                                iIndex = iIndex + 1
                                out[iIndex] = vLegalCard[c]
                            end    
                            table.insert(self.m_vOut,clone(out))
                            bFind = true
                        end 
                        --[[
                        for c = 1 ,#vLegalCard do 
                                iIndex = iIndex + 1
                            out[iIndex] = vLegalCard[c]
                        end                    
                        ]]--   
                    end 
                end   -- -- bNeedPair == true 
            end  --for循环的end
        end  -- self.m_bAppropriate == true  
    end    --  bFindSeq == true     
    
    local  bSeachBomb = self:SearchNormalBomb() 
    
    if bFind == true or bSeachBomb ==true then
	    return true
    else
        return false
    end 
end 

function ddzGameFunc:isIncludeIt(t,h)
     for i = 1 ,#t do 
        
         if t[i] == h then 

            return true 
         end 
     end 

     return false 
end

-- 游戏声音资源路径
function ddzGameFunc:getSoundResPath(strSpriteFramName, bIgnoreSuffix)
    bIgnoreSuffix = (bIgnoreSuffix == nil) and true or bIgnoreSuffix
    return "hallcomm/sound/zp/" .. strSpriteFramName .. (bIgnoreSuffix and ".mp3" or "")
end

--炸弹
function ddzGameFunc:SearchBomb()
    local i,j
    local out = {}
    self.m_vOut = {}
    for var = 1, 20 do 
        out[var] = 0x00
    end 
    local bFind = false
    if self.cTableCardType == 162 then 
        return bFind
    end 

    local vLegalCard = {}
    
    if self.cTableCardType == 161 then 
        if #self.m_vSortCard[4] ~= 0 then 
            for i = 1,#self.m_vSortCard[4],4 do 
                if self.m_vSortCard[4][i] > self.cTableCardValue then 
                    for var = 1, 20 do 
                        out[var] = 0x00
                    end 
                    for j = 1 ,4 do 
                        table.insert(vLegalCard,self.m_vSortCard[4][i])
                        out[j] = self.m_vSortCard[4][i]
                    end 
                    table.insert(self.m_vOut,clone(out))
                    bFind = true
                end  
            end 
        end  
    end 

    if  #self.m_vSortCard[5] ~= 0 then 
        for var = 1, 20 do 
            out[var] = 0x00
        end
       
       
        for i =1 ,2 do 
            table.insert(vLegalCard,self.m_vSortCard[5][i])
            out[i] = self.m_vSortCard[5][i]
        end 
        table.insert(self.m_vOut,clone(out))
        bFind = true
    end

    if bFind == true then 
        return true
    else
        return false
    end
end

-- 播放牌型声音 
function ddzGameFunc:playPaiXingSound(cCardType, cCardValue, iClientPos)
     
    -- local cTableNumExtra = self:idxTocTableNumExtra(iClientPos)
    -- local temp

    local strPerson
    local cLevelNum = math.random(2)
    if cLevelNum == 2 then 
        strPerson = string.format("w")
    else 
        strPerson = string.format("m")
    end 

    if cCardType == JudgeCard.TYPE_SINGLE_CARDS then 
        temp = string.format("%s_card_%d",strPerson, cCardValue)
        AudioEngine.playEffect(self:getSoundResPath(temp))
    elseif cCardType == JudgeCard.TYPE_PAIR_CARDS then   
        if cCardValue > 9 then
            temp = string.format("%s_card_1%d",strPerson,cCardValue)
        else
            temp = string.format("%s_card_10%d",strPerson,cCardValue)
        end
        AudioEngine.playEffect(self:getSoundResPath(temp))
    elseif cCardType >= JudgeCard.TYPE_SINGLE_SEQUENCE_CARDS and cCardType <= JudgeCard.TYPE_SINGLE_SEQUENCE_TWELVE then 
        temp = string.format("%s_shunzi",strPerson)
        AudioEngine.playEffect(self:getSoundResPath(temp))
    elseif cCardType >= JudgeCard.TYPE_PAIR_SEQUENCE_CARDS and cCardType <= JudgeCard.TYPE_PAIR_SEQUENCE_EIGHT then 
        temp = string.format("%s_liandui",strPerson)
        AudioEngine.playEffect(self:getSoundResPath(temp))
    elseif cCardType == JudgeCard.TYPE_TRIAD_CARDS then 
        temp = string.format("%s_sange",strPerson)
        AudioEngine.playEffect(self:getSoundResPath(temp))
    elseif cCardType == JudgeCard.TYPE_TRIAD_CARDS_SINGLE then 
        temp = string.format("%s_sandaiyi",strPerson)
        AudioEngine.playEffect(self:getSoundResPath(temp))
    elseif cCardType == JudgeCard.TYPE_TRIAD_CARDS_PAIR then 
        temp = string.format("%s_sandaiyidui",strPerson)
        AudioEngine.playEffect(self:getSoundResPath(temp))
    elseif cCardType == JudgeCard.TYPE_FOUR_WITH_SINGLE then 
        temp = string.format("%s_sidaier",strPerson)
        AudioEngine.playEffect(self:getSoundResPath(temp))

    elseif cCardType == JudgeCard.TYPE_FOUR_WITH_PAIR then 
        temp = string.format("%s_sidailiangdui",strPerson)
        AudioEngine.playEffect(self:getSoundResPath(temp))
    elseif  (cCardType >= JudgeCard.TYPE_TRIAD_SEQUENCE_CARDS and cCardType <= JudgeCard.TYPE_TRIAD_SEQUENCE_SIX) or 
        (cCardType >= JudgeCard.TYPE_PLANE_TWO_WING_SIGLE and cCardType <= JudgeCard.TYPE_PLANE_FOUR_WING_SIGLE) then --飞机
        temp = string.format("%s_feiji",strPerson)
        AudioEngine.playEffect(self:getSoundResPath(temp))
    elseif cCardType == JudgeCard.TYPE_BOMB_CARD then 
        if lt.CommonUtil.screenShakerNew then
            lt.CommonUtil.screenShakerNew()
        end
        temp = string.format("%s_zhadan",strPerson)
        AudioEngine.playEffect(self:getSoundResPath(temp))
        AudioEngine.playEffect(self:getSoundResPath("threebomb"))
    elseif cCardType == JudgeCard.TYPE_ROCKET_CARD then 
        if lt.CommonUtil.screenShakerNew then
            lt.CommonUtil.screenShakerNew(0.5,5)
        end
        local room = self:getRoomInfo()
        -- 经典斗地主
        if room.room_setting.other_setting[2] == 1 then
            temp = string.format("%s_zhadan",strPerson)
            AudioEngine.playEffect(self:getSoundResPath(temp))
            AudioEngine.playEffect(self:getSoundResPath("threebomb"))
        else
            temp = string.format("%s_wangzha",strPerson)
            AudioEngine.playEffect(self:getSoundResPath(temp))
            AudioEngine.playEffect(self:getSoundResPath("bomb"))
        end
        
    elseif cCardType == JudgeCard.TYPE_LZDDZ_BOMB_CARD_LAIZI then --4个癞子炸弹 。。。普通的没有
        temp = string.format("%s_zhadan",strPerson)
        AudioEngine.playEffect(self:getSoundResPath(temp))
        AudioEngine.playEffect(self:getSoundResPath("threebomb"))
    elseif cCardType == JudgeCard.TYPE_LZDDZ_ROCKET_CARD then --癞子火箭
        temp = string.format("%s_wangzha",strPerson)
        AudioEngine.playEffect(self:getSoundResPath(temp))
        AudioEngine.playEffect(self:getSoundResPath("bomb"))
    end   
end


function ddzGameFunc:callbackEndAniFlyCard(iClientPos, m_iCurTableCardType)
    if m_iCurTableCardType >= JudgeCard.TYPE_SINGLE_SEQUENCE_CARDS and m_iCurTableCardType <= JudgeCard.TYPE_SINGLE_SEQUENCE_TWELVE then --单顺
        self:showAniShunZi(iClientPos)
        return
        
    elseif  m_iCurTableCardType >= JudgeCard.TYPE_PAIR_SEQUENCE_CARDS and m_iCurTableCardType <= JudgeCard.TYPE_PAIR_SEQUENCE_TEN then --双顺
        self:showAniLianDui(iClientPos)
        return
    elseif  (m_iCurTableCardType >= JudgeCard.TYPE_TRIAD_SEQUENCE_CARDS and m_iCurTableCardType <= JudgeCard.TYPE_TRIAD_SEQUENCE_SIX) or (m_iCurTableCardType >= JudgeCard.TYPE_PLANE_TWO_WING_SIGLE and m_iCurTableCardType <= JudgeCard.TYPE_PLANE_FIVE_WING_SIGLE) then --飞机
        self:showAniFeiJi()
        return
        
    elseif  m_iCurTableCardType == JudgeCard.TYPE_BOMB_CARD then --//小炸弹
        self:showAniSmallBomb()
        return
        
    elseif m_iCurTableCardType >= JudgeCard.TYPE_ROCKET_CARD then --//大炸
        self:showAniBigBomb()
        return
    end
end

function ddzGameFunc:showAniShunZi(iClientPos)
    self.m_tArrSpAni[iClientPos]:setSpriteFrame(self:getGameResPath("ImageText34"))
    self.m_tArrSpAni[iClientPos]:setVisible(true)
    local sTo = cc.ScaleTo:create(0.5,0.75)
    local function functionLoacl()
        self.m_tArrSpAni[iClientPos]:setVisible(false)
    end

    local actionInstant = cc.CallFunc:create(functionLoacl)
    local sq = cc.Sequence:create(sTo,actionInstant)
    self.m_tArrSpAni[iClientPos]:runAction(sq)
end

function ddzGameFunc:showAniLianDui(iClientPos)
    self.m_tArrSpAni[iClientPos]:setSpriteFrame(self:getGameResPath("ImageText33"))
    self.m_tArrSpAni[iClientPos]:setVisible(true)
    local sTo = cc.ScaleTo:create(0.5, 0.75)
    local function functionLoacl()
        self.m_tArrSpAni[iClientPos]:setVisible(false)
    end

    local actionInstant = cc.CallFunc:create(functionLoacl)
    local sq = cc.Sequence:create(sTo,actionInstant)
    self.m_tArrSpAni[iClientPos]:runAction(sq)
end

function ddzGameFunc:showAniBigBomb()
    -- local  sSize =  cc.Director:getInstance():getWinSize()
    local  animationWang = cc.Animation:create()
    local frameName 
    for i = 1, 25 do 
        frameName = string.format("wangzha%d",i)
        local frame = display.newSpriteFrame(self:getGameResPath(frameName,true))
        animationWang:addSpriteFrame(frame)
    end 
      
    animationWang:setDelayPerUnit(1.0/25.0)
    animationWang:setRestoreOriginalFrame(false) 
    
    local actionWang = cc.Animate:create(animationWang)

    local spWang = display.newSprite(self:getGameResPath("wangzha1",true))
    spWang:setScale(1.5)
    spWang:setPosition(cc.p(display.width/2, display.height*0.75))
    self:addChild(spWang, 100)
      
    local function functionLoacl(arg)
        spWang:removeFromParent()
    end

    local  actionInstant = cc.CallFunc:create(functionLoacl)

    local sq = cc.Sequence:create(actionWang,actionInstant)

    spWang:runAction(sq)
end

function ddzGameFunc:showAniSmallBomb()

    local  sSize =  cc.Director:getInstance():getWinSize()
    local  animation = cc.Animation:create()
    local frameName 
    for i = 1, 22 do 
        frameName = string.format("zhadan%d",i)
        local frame = display.newSpriteFrame(self:getGameResPath(frameName,true))
        --frame:setScale(1.5)
        animation:addSpriteFrame(frame)
    end 
      
    animation:setDelayPerUnit(1.0/22.0)
    animation:setRestoreOriginalFrame(false) 
    --animation:setScale(1.5)
    local action = cc.Animate:create(animation)


    local spBm = display.newSprite(self:getGameResPath("zhadan1",true))
    spBm:setScale(1.5)
    spBm:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height*0.75))
    self:addChild(spBm)
      
    local function functionLoacl(arg)
        -- self:showAniBigBomb()
        spBm:removeFromParent()
    end

    local actionInstant = cc.CallFunc:create(functionLoacl)
    local sq = cc.Sequence:create(action,actionInstant)
    spBm:runAction(sq)

     
end

function ddzGameFunc:showAniFeiJi()
    if self.spShun ~= nil then
        self.spShun:removeFromParent()
    end
    local animation = cc.Animation:create()
    local frameName 
    local frame
    for i = 1, 15 do 
         frameName = string.format("feiji%d",(i - 1)%3)
         frame = display.newSpriteFrame(self:getGameResPath(frameName,true))
         animation:addSpriteFrame(frame)
    end 

    animation:setDelayPerUnit(0.07)
    animation:setRestoreOriginalFrame(false) 


    local animate = cc.Animate:create(animation)
    self.spShun = display.newSprite(self:getGameResPath("feiji0",true))
    
    self.spShun:setPosition(cc.p(cc.Director:getInstance():getWinSize().width+400,cc.Director:getInstance():getWinSize().height/2+100))
    self:addChild(self.spShun) 

    local function functionLoacl()
        self:callbackAniEnd()
    end

    local actionInstant = cc.CallFunc:create(functionLoacl)
    local mTo = cc.MoveTo:create(2,cc.p(-400,cc.Director:getInstance():getWinSize().height/2+100));
    local sq = cc.Sequence:create(mTo,cc.Hide:create(),actionInstant)
    self.spShun:runAction(cc.Sequence:create(animate,nil))
    self.spShun:runAction(sq)

end

function ddzGameFunc:callbackAniEnd()
    self.spShun:removeFromParent()
    self.spShun = nil
end


-- 游戏界面资源路径
function ddzGameFunc:getGameResPath(strSpriteFramName, bNeedFirstFlag, bIgnoreSuffix)
    bIgnoreSuffix = (bIgnoreSuffix == nil) and true or bIgnoreSuffix
    local path = "games/ddz/game/" .. strSpriteFramName .. (bIgnoreSuffix and ".png" or "")

    if bNeedFirstFlag  then
        if cc.SpriteFrameCache:getInstance():getSpriteFrame(path) then
            return "#"..path
        else    
            return "#".. "game/zpcomm/img/" .. strSpriteFramName .. (bIgnoreSuffix and ".png" or "")
        end
    elseif not bNeedFirstFlag then
        if cc.FileUtils:getInstance():isFileExist(path) then
            return path
        else
            if cc.SpriteFrameCache:getInstance():getSpriteFrame(path) then
                return path
            else    
                return "game/zpcomm/img/" .. strSpriteFramName .. (bIgnoreSuffix and ".png" or "")
            end
        end
    end
    return path
end



return ddzGameFunc
