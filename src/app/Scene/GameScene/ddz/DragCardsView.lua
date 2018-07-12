local DragCardsView = class("DragCardsView", function( ... )
	return display.newLayer()
end)
-- local DragCardsView = {}

local Card = require("app.Scene.GameScene.ddz.Card")
local JudgeCard = require("app.Scene.GameScene.ddz.JudgeCard")


-- 开始点
local __BEGAN_POS__ = cc.p(126, 50)
-- 最右边的点
local __ENDED_POS__ = cc.p(display.width - 126, 50)
-- 牌之间最大间距
local __MAX_GAP__ = 80

function DragCardsView:ctor(  )
	
	self:addTouchEvent(self)
	self.layer = self
	self:cleanLayer()
end

function DragCardsView:initCtrl( ctrlView )
	self.ctrlView = ctrlView 
end

-- 恢复下最初的状态
function DragCardsView:cleanLayer()
	self.iHandCards = {{}, {}, {}}
	self.cardList = {}
	self.tSelect = {}
	self.layer:removeAllChildren()
end

function DragCardsView:selectCardWithArr(arr)
    self:unSelectAllCard()
    for i, v in pairs(arr) do
        for ii, vv in pairs(self.cardList) do
            local cardValue = math.floor(vv:getCard() % 100)
            if cardValue == v and vv.isSelect ~= true then
                self:selectCard(vv)
                break
            end
        end       
    end
    -- 检测选中的牌
    self:JudgeCardShape()
end



-- 动态计算牌的位置
function DragCardsView:dynCardPos(allNums, isRight)
	-- local px =  (__ENDED_POS__s.x - __BEGAN_POS__.x) / 2 + __BEGAN_POS__.x

	-- local tempIndex = index / 2 
	-- -- 是否向右
	-- if isRight then

	-- end
end

function DragCardsView:addCard(arr)

    dump(arr, 'addCard')

    for i , v in pairs(arr) do 
        for z = 1, 20 do 
            if not self.iHandCards[2][z] or self.iHandCards[2][z] == 0 then
                self.iHandCards[2][z] = v
                break
            end
        end
    end
    -- 排序，然后刷新
    self:refreshCardNode()

    local arr1 = clone(arr)

    for i, v in pairs(arr1) do 
        for ii, vv in pairs(self.cardList) do 
            if vv.iCard == v then
                v = 0
                self:selectCard(vv, false)
                break;
            end
        end
    end
end

function DragCardsView:getMainCard(  )
    return self.iHandCards[2] 
end


function DragCardsView:removeCard( cardArr )
    dump(cardArr, 'removeCard')

    cardArr = cardArr or {}

    for i , v in pairs(cardArr) do 
        for z = 1, 20 do 
            if self.iHandCards[2][z] and self.iHandCards[2][z] == v then
                self.iHandCards[2][z] = 0
                break
            end
        end
    end
    -- 把选中的数组清掉，防止会继续适用
    -- 排序，然后刷新
    self.tSelect = {}
    self:refreshCardNode()
end
function DragCardsView:refreshCardList(cardArr)
	if not cardArr then
		print("ERROR::DragCardsView:refreshCard  is not cardArr, with pamam 1")
		return 
	end
	self.iHandCards[2] = cardArr
	dump(self.iHandCards, "self.iHandCards", 8)
end

function DragCardsView:refreshCardNode(isPlayEff)


    local _SPACEING = 50
    local _BEGANPOSX = 200
    local _MIDPOSX = display.cx - 25


    local iCardNums = 0 
    for i, v in pairs(self.iHandCards[2]) do 
        if v ~= 0 then
            iCardNums = iCardNums + 1
        end
    end
    -- dump(self.iHandCards[2], "self.iHandCards[2]")
    -- dump(iCardNums, "iCardNums")

    if iCardNums == 20 then
        _SPACEING = 46
    end

    local isDan = math.floor(iCardNums % 2) == 1 

    if isDan then
        _BEGANPOSX = _MIDPOSX - (iCardNums / 2) * _SPACEING
    else
        _BEGANPOSX = _MIDPOSX + (_SPACEING / 2) - (iCardNums / 2) * _SPACEING
    end

	for i = 1, #self.cardList do
		self.cardList[i]:removeSelf()
		self.cardList[i] = nil
	end
    
	self:sortCard()

    dump(self.iHandCards, "self.iHandCards")

    local index = 0
	for i , v in pairs(self.iHandCards[2]) do 
        if v ~= 0 then
        	local cardsp = Card:createCard(v)
            index = index + 1
        	cardsp:setPosition(index * _SPACEING + _BEGANPOSX, 100)

        	local cx, cy = cardsp:getPosition()
        	cardsp.px = cx
        	cardsp.py = cy
            cardsp.iCard = v

            cardsp:setScale(0.75)

        	self.layer:addChild(cardsp)
        	table.insert(self.cardList, cardsp)

        	if isPlayEff then
        		cardsp:setVisible(false)
        	end
        end
    end

    local effTime = 0.05
    if isPlayEff then
    	for i = 1, #self.cardList do 
    		self.cardList[i]:runAction(cc.Sequence:create(cc.DelayTime:create(i*effTime), cc.CallFunc:create(function()
    				self.cardList[i]:setVisible(true)
    		end)))
    	end
    end 
end


function DragCardsView:addTouchEvent(node)

	local x, y
	self.began = false
	local satrtPos = cc.p(0,0)

	-- 判断是否是出牌，左右移动和上下移动
	local m_bPtIsOut = false

	local spStarCard
	local satrtIndex = 0

    local lastCard = nil
    local lastType = 0   -- 0保持不动，-1←  1→  2↑ -2↓ 

    local lastPos = {x = 0, y = 0}

    local bLastAdd = false

    local tBeginSelect = {}

	local function onMyTouchBegan( touch,event )

		if self.began then
			return false
		end

        tBeginSelect = clone(self.tSelect)
		--  可以继续选择，当点击到牌外面的时候，重置数组
		-- for i , v in pairs(self.tSelect) do 
		-- 	-- 蒙版
		-- 	v.layer:setVisible(false)
		-- 	v.isSelect = false
		-- 	v:setPosition(v.px, v.py)
		-- end
		-- self.tSelect = {}
        local pos = touch:getLocation()

        local ptStart = touch:getLocationInView()
	    ptStart = cc.Director:getInstance():convertToGL(ptStart)

        x = pos.x
        y = pos.y

        -- 用来判断 在移动过程中的移动方向
        lastPos.x = pos.x
        lastPos.y = pos.y
        local cardIndex = 0
    	for var = #self.cardList,1,-1 do 
    		local size = self.cardList[var]:getContentSize()
    		local rect = cc.rect(-size.width/2, -size.height/2, size.width, size.height)
			local ccPoint = self.cardList[var]:convertTouchToNodeSpaceAR(touch)
			if cc.rectContainsPoint(rect, ccPoint) then 
	            cardIndex = var
	            satrtPos = ptStart
	            satrtIndex = var
	            break;
	        end  
	 	end   

       
	 	-- 保存到数组里面
	 	if cardIndex > 0  then
            local cardsp = self.cardList[cardIndex]
            -- 不管删除也好，增加也罢， 仍然允许点击
            spStarCard = cardsp
            self.isSelectCard = true 
        else
            -- print("当前没有选中任何牌")
            -- self:touchLayer()
            -- self:unSelectAllCard()
            self.isSelectCard = false
        end

        return cardIndex > 0
    end

    local function onMyTouchMoved( touch,event )

    	-- print("onMyTouchMoved")
        local pos = touch:getLocation()

        -- 这里面只判断左右滑动的情况。向上或者向下移动，暂时忽略， 等待结果
        -- 向右滑动
        local tempType = 0

        -- 垂直滑动的多
        if math.abs(pos.x - x) < math.abs(pos.y - y) then
            if pos.y - lastPos.y > 0 then
                tempType = 2
            elseif pos.y - lastPos.y < 0 then
                tempType = -2      
            end
        -- elseif math.floor(pos.x - x) < math.floor(pos.y - y) then
        else
            if pos.x - lastPos.x > 0 then
                tempType = 1
            elseif pos.x - lastPos.x < 0 then
                tempType = -1
            end
        end

        if lastType == 0 then
            lastType = tempType
        end

        lastPos.x = pos.x
        lastPos.y = pos.y

        local ptMoved = touch:getLocationInView()
     	ptMoved = cc.Director:getInstance():convertToGL(ptMoved)
     	local fDDy 
     	local fDDx	
     	-- 是否大于30度
     	local bPoint = false

	    if ptMoved.y > satrtPos.y then 
	        fDDy = ptMoved.y - satrtPos.y 
	        if ptMoved.x > satrtPos.x then 
	            fDDx = ptMoved.x - satrtPos.x
	        else 
	            fDDx = satrtPos.x - ptMoved.x 
	        end      
	        
	        if  fDDy/fDDx > 0.5 then 
	            bPoint = true
	            m_bPtIsOut = true
	        else
	            m_bPtIsOut = false
	        end 
	    end 
        -- print("tempType", tempType)
        if tempType == 1 or tempType == -1 then
            local cardIndex = 0
         	for var = #self.cardList,1,-1 do 
                local size = self.cardList[var]:getContentSize()
                local rect = cc.rect(-size.width/2, -size.height/2, size.width, size.height)
                local ccPoint = self.cardList[var]:convertTouchToNodeSpaceAR(touch)
                if cc.rectContainsPoint(rect, ccPoint) then 
                    cardIndex = var
                    break;
                end 
         	end
         	local spCard = self.cardList[cardIndex]
         	if cardIndex > 0 then
                local startId = satrtIndex < cardIndex and satrtIndex or cardIndex
                local endId = satrtIndex > cardIndex and satrtIndex or cardIndex
                -- 
                if spCard ~= lastCard then
                    -- print(string.format("spCard [%s], lastCard [%s]", tostring(spCard), tostring(lastCard)))
                    self:unSelectAllCard()
                    for i, v in pairs(tBeginSelect) do 
                        self:selectCard(v) 
                    end
                    for i = startId, endId do 
                        local cardsp = self.cardList[i]
                        local bFind = false
                        for _, v in pairs(tBeginSelect) do 
                            if v == cardsp then
                                bFind = true
                                break
                            end
                        end
                        if cardsp.isSelect then
                            self:unSelectCard(cardsp)
                        else
                            self:selectCard(cardsp)
                        end
                    end
                    lastType = tempType
                    lastCard = spCard
                end
            end
        end
        return true
    end
    local function onMyTouchEnded(touch,event)

    	self.began = false
        -- 点击的时候先不选择， 如果单击没有移动，就不做选择，如果是拖动，判断是否是向上拖动， 向上的话就走判断出牌的动作， 
        local pos = touch:getLocation();
        local rx = pos.x
        local ry = pos.y
        local rrx = rx - x
        local rry = ry - y

        -- 左右移动之后 上下移动无效
        if math.abs(rrx) >= math.abs(rry) then
            if rrx > 0 then
                print("右移动")
            elseif rrx < 0 then
                print("左移动")
            else    -- 选择当前牌
                
                print("一动不动")
                if spStarCard.isSelect then
                    self:unSelectCard(spStarCard)   
                else
                    self:selectCard(spStarCard)   
                end
            end
            --  检测牌是否合法
            self:JudgeCardShape()
        else
            if rry > 10 then
                -- print("上移动")
                self:sendCardReq(self.tSelect)
            elseif rry < -10 then
                print("下移动")
                self:unSelectAllCard()
            end
        end
    end

    local touchListen = cc.EventListenerTouchOneByOne:create()
    touchListen:registerScriptHandler(onMyTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    touchListen:registerScriptHandler(onMyTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    touchListen:registerScriptHandler(onMyTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(touchListen, node)
end

function DragCardsView:JudgeCardShape( ... )
    local cardTable = {}
    local arg_num = 0
    for i, v in pairs(self.tSelect) do 
        local iCard = v:getCard()
        table.insert(cardTable, iCard)
        arg_num = arg_num + 1
    end

    if arg_num > 0 then
        local iNowType, arg_value =  JudgeCard:JudgeCardShape(cardTable, arg_num, arg_value)
        -- print(string.format("iNowType = [%d], iNums = [%d], arg_value = [%d]", iNowType, arg_num, arg_value))
        -- 提供给ddzLayer 使用检测结果
        self.ctrlView:judgeSelectCard(iNowType, arg_value)
    end
end

-- 由ddzLayer 返回反馈。返回反馈之后可以请求后端出牌
function DragCardsView:sendCardReq( ... )
	local tTemp = self.tSelect 
	self.ctrlView:sendCardReq(tTemp)
end

-- view 给的反馈，如果什么也没点击， 就把选中的全部干掉
function DragCardsView:touchLayer( ... )
	-- self.ctrlView:touchLayer()
    print("touchLayer")
    if self.isSelectCard == false then
        self:unSelectAllCard()
    end
end


function DragCardsView:sortCard()
	print("DragCardsView:sortCard")
	table.sort(self.iHandCards[2], function ( a, b )
		local at = math.floor(a / 100) 
		local bt = math.floor(b / 100) 
		local av = math.floor(a % 100) 
		local bv = math.floor(b % 100) 
		if av == bv then
			return at < bt
		end
		return av > bv
	end)
end

function DragCardsView:selectCard( node , isVislayer)
	if not node then
		print("没有 node")
        return
    end
    if node and node.isSelect then
        print("这张牌已经被选中")
        return
    end

    -- 是否显示遮罩
    isVislayer = isVislayer == nil and true or isVislayer

    node.isSelect = true
    node.layer:setVisible(isVislayer)

    local py = node.py + 20
    node:setPositionY(py)

    -- 从表里面去查找 看是否有这张牌， 没有的话就加到一个空的位置
    for i = 1, 20 do
        if self.tSelect[i] and self.tSelect[i] == node then
            break;
        end
        if not self.tSelect[i] then
            self.tSelect[i] = node
            break
        end
    end
end


function DragCardsView:unSelectCard( node )
    -- node.isSelect = false
    -- node.layer:setVisible(false)
    -- node:setPosition(node.px, node.py)

    -- for i, v in pairs(self.tSelect) do 
    --     if v == node then 
    --         table.remove(self.tSelect, i)
    --         break;
    --     end
    -- end 

    if not node then
        return
    end

    if node and node.isSelect == false then
        -- print("这张牌没有被选中, 请检查table")
        -- dump(self.tSelect, "self.tSelect")
        return
    end

    node.isSelect = false
    node.layer:setVisible(false)
    node:setPosition(node.px, node.py)
    -- 从表里面去查找 看是否有这张牌， 没有的话就加到一个空的位置
    for i = 1, 20 do
        if not self.tSelect[i] then
            -- print("i == ", i)
            break
        end
        if self.tSelect[i] and self.tSelect[i] == node then

            self.tSelect[i] = nil
            -- 从后面往前移动
            for j = i, 20 do 
                if self.tSelect[j+1] == nil then
                    break
                end
                self.tSelect[j] = self.tSelect[j+1]
                self.tSelect[j+1] = nil
            end
            break
        end
    end
end

function DragCardsView:unSelectAllCard( )
    -- print("unSelectAllCard")
    for i, node in pairs(self.tSelect) do 
        node.isSelect = false
        if node.layer then
            node.layer:setVisible(false)
        end
        node:setPosition(node.px, node.py)
    end

    self.tSelect = {}


    self.ctrlView:judgeSelectCard(-1, 0)

end



return DragCardsView