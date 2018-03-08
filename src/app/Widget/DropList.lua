--下拉菜单
local DropList = class("DropList", function()
	return display.newNode()
end)

DropList._winScale = lt.CacheManager:getWinScale()
DropList.CELL_SIZE = cc.size(200 * DropList._winScale, 86 * DropList._winScale)
DropList.SELECT_SIZE = cc.size(184 * DropList._winScale, 72 * DropList._winScale)

function DropList:ctor(viewSize)
    self:setNodeEventEnabled(true)
    self:setTouchSwallowEnabled(false)

    self._selectIdx = -1
    self._subIdx = -1
    self._flag = -11
	self._listView = lt.ListView.new {
            viewRect = cc.rect(7, 10, viewSize.width, viewSize.height),
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
            scale = self._winScale}
                :onTouch(handler(self, self.touchListener))
                :addTo(self)
end

function DropList:setItemTable(itemTable,type,subIdx)
    self._itemTable = itemTable
    if subIdx then
        self._subIdx = subIdx
    end

    self._listView:removeAllItems()
    if not type then
        value = 1
    end

    local idx = 1
	for _,itemInfo in pairs(itemTable) do
        local item = self._listView:newItem()
        
        local content = display.newScale9Sprite("#common_tab_gray_2.png", 0, 0, self.CELL_SIZE)
        content.idx = idx
        if idx == type then
            content.open = true
        else
            content.open = false
        end
        local title = lt.GameBMLabel.new(itemInfo.title,"tab.fnt")
        --local title = lt.GameLabel.new(itemInfo.title, lt.Constants.FONT_SIZE4, lt.Constants.COLOR.WHITE,{outline = true,outlineSize = 1,outlineColor = lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
        title:setPosition(content:getContentSize().width/2 - 10, content:getContentSize().height/2)
        title:setAnchorPoint(0, 0.5)
        content:addChild(title)

        local iconArrow = display.newSprite("#common_btn_round_blue.png")
        iconArrow:setTag(100)
        iconArrow:setRotation(180)
        iconArrow:setPosition(content:getContentSize().width / 2 -30*self._winScale,content:getContentSize().height/2)
        content:addChild(iconArrow)
        iconArrow:setFlippedY(content.open)

        item:addContent(content)
        item:setItemSize(self.CELL_SIZE.width, self.CELL_SIZE.height+5)
        self._listView:addItem(item)

        idx = idx + 1
    end
    self._listView:reload()


    self:createItem(type,true,true)
    
end

function DropList:selectItemByFlag(idx1, flag)


    if not idx1 then
        return
    end

    self:closeExceptIdx(idx1)

    local item = self._listView:getItemByPos(idx1)
    local content = item:getContent()
    content.open = true
    local arrow = content:getChildByTag(100)
    if arrow then
        arrow:setFlippedY(content.open)
    end
    self:createItem(content.idx, content.open,true)

    -- 根据Flag 默认选择
    if flag and self._itemArray then
        for _,item in pairs(self._itemArray) do
            if flag == item.flag then
                if self._subItem then
                    local frameGray = display.newSpriteFrame("common_btn_gray.png")
                    if frameGray then
                        self._subItem:setSpriteFrame(frameGray)
                    end
                    self._subItem:setPreferredSize(self.CELL_SIZE)
                end

                local frame = display.newSpriteFrame("common_btn_yellow.png")
                if frame then
                    item:setSpriteFrame(frame)
                end
                item:setPreferredSize(self.CELL_SIZE)
                
                self._subIdx  = item:getTag()
                self._flag    = item.flag
                self._subItem = item
                if self._callback then
                    self._callback(item.flag, item.info)
                end
            end
        end
    end
end

function DropList:setCallback(callback)
	self._callback = callback
end

function DropList:createItem(idx,open,firstCreate)
    self._itemArray = {}
    if self._currItem then
        self._listView:removeItemWithOutEase(self._currItem)
        self._currItem = nil
        self._subItem = nil
    end

    local itemInfo = self._itemTable[idx]
    if not itemInfo then
        return
    end

    if open then
        self._currItem = self._listView:newItem()

        local itemList = itemInfo.itemList
        local size = #itemList
        
        local width = self.CELL_SIZE.width+4
        local height = (self.SELECT_SIZE.height+5)*size + 5*self._winScale
        local content = display.newNode()--  lt.GamePanel.new(lt.GamePanel.TYPE.NEW_BGWHITE, 4, 4, cc.size(width-8, height-8))
        content:setContentSize(cc.size(width, height))
        content:setAnchorPoint(0,1)
        content:setPosition(0, 5)
        content.idx = -1
        content.parentIdx = idx


        local openIdx = -1

        if not self._resetSubInx then
            if self._selectIdx == idx and self._subIdx ~= -1 then
                openIdx = self._subIdx
            end
        else
            if self._subIdx ~= -1 then
                openIdx = self._subIdx
            end
        end

        if firstCreate then
            openIdx = 1
            if self._subIdx then
                openIdx = self._subIdx
            end
        end

        local id = 1
        for _,listItem in pairs(itemList) do
            local item = nil
            if id == openIdx then
                item = display.newScale9Sprite("#common_btn_yellow.png", 0, 0, self.SELECT_SIZE)
                self._subItem = item
                self._subIdx = openIdx
                -- if self._selectIdx ~= idx and self._callback  then
                --     self._callback(listItem.flag, listItem.info)
                -- end

                if self._flag ~= listItem.flag and self._callback then
                    self._callback(listItem.flag, listItem.info)
                end
                self._flag = listItem.flag
                self._selectIdx = idx
            else
                item = display.newScale9Sprite("#common_btn_gray.png", 0, 0, self.SELECT_SIZE)
            end
            item:setAnchorPoint(0,0)
            item:setTag(id)
            item.flag = listItem.flag
            item.info = listItem.info
            item:setPosition(13*self._winScale, content:getContentSize().height-(self.SELECT_SIZE.height+5)*id)
            content:addChild(item)

            local lblTitle = lt.GameBMLabel.new(listItem.title,"tab.fnt")
            --local lblTitle = lt.GameLabel.new(listItem.title, lt.Constants.FONT_SIZE4, lt.Constants.COLOR.WHITE,{outline = true,outlineSize = 1,outlineColor = lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
            lblTitle:setPosition(item:getContentSize().width/2,item:getContentSize().height/2)
            item:addChild(lblTitle)
            self._itemArray[#self._itemArray+1] = item

            id = id + 1
        end

        self._currItem:addContent(content)
        self._currItem:setItemSize(width, height)
        self._listView:addItem(self._currItem,idx+1)
        self._listView:reload()
    end
end

function DropList:closeExceptIdx(idx)
    for _,item in pairs(self._listView:getAllChildren()) do
        local content = item:getContent()
        if content.idx ~= idx then
            content.open = false
            local arrow = content:getChildByTag(100)
            if arrow then
                arrow:setFlippedY(content.open)
            end
        end
    end
end

function DropList:resetSubIndx(bool)--选择第一个小类
    self._resetSubInx = bool
end

function DropList:touchListener(event)
    if "clicked" == event.name then
        local content = event.item:getContent()
        if content.idx == -1 then
            self:onTouch(event.point,content.parentIdx)
            return
        end

        self:closeExceptIdx(content.idx)
        local pos = self._listView:getItemPos(event.item)
        if content.open then
            content.open = false
        else
            content.open = true
        end
        local arrow = content:getChildByTag(100)
        if arrow then
            arrow:setFlippedY(content.open)
        end
        if self._resetSubInx then
            self._subIdx = 1--这里
        end
        self:createItem(content.idx,content.open)
    end
end

function DropList:onTouch(event,idx)
    for _,item in pairs(self._itemArray) do
        local worldRect = cc.rect(item:getPositionX(),item:getPositionY()-15,self.CELL_SIZE.width,self.CELL_SIZE.height+10)
        if cc.rectContainsPoint(worldRect, cc.p(event.x, event.y)) then
            if self._flag == item.flag then
                return
            end

            if self._subItem then
                local frameGray = display.newSpriteFrame("common_btn_gray.png")
                if frameGray then

                    self._subItem:setSpriteFrame(frameGray)

                end
                self._subItem:setPreferredSize(self.SELECT_SIZE)
            end

            local frame = display.newSpriteFrame("common_btn_yellow.png")
            if frame then
                item:setSpriteFrame(frame)
            end
            item:setPreferredSize(self.SELECT_SIZE)
            
            self._subIdx = item:getTag()
            self._selectIdx = idx
            self._flag = item.flag
            self._subItem = item
            if self._callback then
                self._callback(item.flag, item.info)
            end
            break
        end
    end
end

function DropList:getListView()
    return self._listView
end

function DropList:ScrollTo(x,y)
    if self._listView then
        self._listView:scrollTo(x, y)
    end
end

return DropList
