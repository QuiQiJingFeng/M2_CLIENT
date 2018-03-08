
--[[

Copyright (c) 2011-2014 chukong-inc.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

--------------------------------
-- @module UIGamePageView

--[[--

quick page控件

]]

local UIPageViewItem = import("framework.cc.ui.UIPageViewItem")

local UIGamePageView = class("UIGamePageView", function()
	-- local node = display.newNode()
	local node = display.newClippingRegionNode()
	-- node:setContentSize(display.width, display.height)
	return node
end)

-- start --

--------------------------------
-- UIGamePageView构建函数
-- @function [parent=#UIGamePageView] new
-- @param table params 参数表

--[[--

UIGamePageView构建函数

可用参数有：

-   column 每一页的列数，默认为1
-   row 每一页的行数，默认为1
-   columnSpace 列之间的间隙，默认为0
-   rowSpace 行之间的间隙，默认为0
-   viewRect 页面控件的显示区域
-   padding 值为一个表，页面控件四周的间隙
    -   left 左边间隙
    -   right 右边间隙
    -   top 上边间隙
    -   bottom 下边间隙
-   bCirc 页面是否循环,默认为false

]]
-- end --

function UIGamePageView:ctor(params)
	self.items_ = {}
	self.viewRect_ = params.viewRect or cc.rect(0, 0, display.width, display.height)
	self.column_ = params.column or 1
	self.row_ = params.row or 1
	self.columnSpace_ = params.columnSpace or 0
	self.rowSpace_ = params.rowSpace or 0
	self.padding_ = params.padding or {left = 0, right = 0, top = 0, bottom = 0}
	self.bCirc = params.bCirc or false

	self:setClippingRegion(self.viewRect_)
	-- self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(...)
	-- 		self:update_(...)
	-- 	end)
	self:setTouchEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        	return self:onTouch_(event)
    	end)
end

-- start --

--------------------------------
-- 创建一个新的页面控件项
-- @function [parent=#UIGamePageView] newItem
-- @return UIPageViewItem#UIPageViewItem 

-- end --

function UIGamePageView:newItem()
	local item = UIPageViewItem.new()
	local itemW = (self.viewRect_.width - self.padding_.left - self.padding_.right
				- self.columnSpace_*(self.column_ - 1)) / self.column_
	local itemH = (self.viewRect_.height - self.padding_.top - self.padding_.bottom
				- self.rowSpace_*(self.row_ - 1)) / self.row_
	-- item:setContentSize(self.viewRect_.width/self.column_, self.viewRect_.height/self.row_)
	item:setContentSize(itemW, itemH)

	return item
end

-- start --

--------------------------------
-- 添加一项到页面控件中
-- @function [parent=#UIGamePageView] addItem
-- @param node item 页面控件项
-- @return UIGamePageView#UIGamePageView 

-- end --

function UIGamePageView:addItem(item)
	table.insert(self.items_, item)

	return self
end

-- start --

--------------------------------
-- 移除一项
-- @function [parent=#UIGamePageView] removeItem
-- @param number idx 要移除项的序号
-- @return UIGamePageView#UIGamePageView 

-- end --

function UIGamePageView:removeItem(item)
	local itemIdx
	for i,v in ipairs(self.items_) do
		if v == item then
			itemIdx = i
		end
	end

	if not itemIdx then
		lt.CommonUtil.print("ERROR! item isn't exist")
		return self
	end

	if itemIdx then
		table.remove(self.items_, itemIdx)
	end

	self:reload(self.curPageIdx_)

	return self
end

-- start --

--------------------------------
-- 移除所有页面
-- @function [parent=#UIGamePageView] removeAllItems
-- @return UIGamePageView#UIGamePageView 

-- end --

function UIGamePageView:removeAllItems()
	self.items_ = {}

	self:reload(self.curPageIdx_)

	return self
end

-- start --

--------------------------------
-- 注册一个监听函数
-- @function [parent=#UIGamePageView] onTouch
-- @param function listener 监听函数
-- @return UIGamePageView#UIGamePageView 

-- end --

function UIGamePageView:onTouch(listener)
	self.touchListener = listener

	return self
end

-- start --

--------------------------------
-- 加载数据，各种参数
-- @function [parent=#UIGamePageView] reload
-- @param number page index加载完成后,首先要显示的页面序号,为空从第一页开始显示
-- @return UIGamePageView#UIGamePageView 

-- end --

function UIGamePageView:reload(idx)
	local page
	local pageCount
	self.pages_ = {}

	-- retain all items
	for i,v in ipairs(self.items_) do
		v:retain()
	end

	self:removeAllChildren()

	pageCount = self:getPageCount()
	if pageCount < 1 then
		return self
	end

	if pageCount > 0 then
		for i = 1, pageCount do
			page = self:createPage_(i)
			page:setVisible(false)
			table.insert(self.pages_, page)
			self:addChild(page)
		end
	end

	if not idx or idx < 1 then
		idx = 1
	elseif idx > pageCount then
		idx = pageCount
	end
	self.curPageIdx_ = idx
	self.pages_[idx]:setVisible(true)
	self.pages_[idx]:setPosition(
		self.viewRect_.x, self.viewRect_.y)

	-- release all items
	for i,v in ipairs(self.items_) do
		v:release()
	end

	return self
end

-- start --

--------------------------------
-- 跳转到特定的页面
-- @function [parent=#UIGamePageView] gotoPage
-- @param integer pageIdx 要跳转的页面的位置
-- @param boolean bSmooth 是否需要跳转动画
-- @param bTopToBottom 移动的方向,在可循环下有效, nil:自动调整方向,false:从下到上,true:从上到下
-- @return UIGamePageView#UIGamePageView 

-- end --

function UIGamePageView:gotoPage(pageIdx, bSmooth, bTopToBottom)
	if pageIdx < 1 or pageIdx > self:getPageCount() then
		return self
	end
	if pageIdx == self.curPageIdx_ and bSmooth then
		return self
	end

	if bSmooth then
		self:resetPagePos(pageIdx, bTopToBottom)
		self:scrollPagePos(pageIdx, bTopToBottom)
	else
		self.pages_[self.curPageIdx_]:setVisible(false)
		self.pages_[pageIdx]:setVisible(true)
		self.pages_[pageIdx]:setPosition(
			self.viewRect_.x, self.viewRect_.y)
		self.curPageIdx_ = pageIdx

		-- self.notifyListener_{name = "clicked",
		-- 		item = self.items_[clickIdx],
		-- 		itemIdx = clickIdx,
		-- 		pageIdx = self.curPageIdx_}
		self:notifyListener_{name = "pageChange"}
	end

	return self
end

-- start --

--------------------------------
-- 得到页面的总数
-- @function [parent=#UIGamePageView] getPageCount
-- @return number#number 

-- end --

function UIGamePageView:getPageCount()
	return math.ceil(table.nums(self.items_)/(self.column_*self.row_))
end

-- start --

--------------------------------
-- 得到当前页面的位置
-- @function [parent=#UIGamePageView] getCurPageIdx
-- @return number#number 

-- end --

function UIGamePageView:getCurPageIdx()
	return self.curPageIdx_
end

-- start --

--------------------------------
-- 设置页面控件是否为循环
-- @function [parent=#UIGamePageView] setCirculatory
-- @param boolean bCirc 是否循环
-- @return UIGamePageView#UIGamePageView 

-- end --

function UIGamePageView:setCirculatory(bCirc)
	self.bCirc = bCirc

	return self
end

-- private

function UIGamePageView:createPage_(pageNo)
	local page = display.newNode()
	local item
	local beginIdx = self.row_*self.column_*(pageNo-1) + 1
	local itemW, itemH

	itemW = (self.viewRect_.width - self.padding_.left - self.padding_.right
				- self.columnSpace_*(self.column_ - 1)) / self.column_
	itemH = (self.viewRect_.height - self.padding_.top - self.padding_.bottom
				- self.rowSpace_*(self.row_ - 1)) / self.row_
	local bBreak = false
	for row=1,self.row_ do
		for column=1,self.column_ do
			item = self.items_[beginIdx]
			beginIdx = beginIdx + 1
			if not item then
				bBreak = true
				break
			end
			page:addChild(item)

			item:setAnchorPoint(cc.p(0.5, 0.5))
			item:setPosition(
				self.padding_.left + (column - 1)*self.columnSpace_ + column*itemW - itemW/2,
				self.viewRect_.height - self.padding_.top - (row - 1)*self.rowSpace_ - row*itemH)
				-- self.padding_.bottom + (row - 1)*self.rowSpace_ + row*itemH - itemH/2)
		end
		if bBreak then
			break
		end
	end
	page:setContentSize(cc.size(self.viewRect_.width, self.viewRect_.height))

	page:setTag(1500 + pageNo)

	return page
end

function UIGamePageView:isTouchInViewRect_(event, rect)
	rect = rect or self.viewRect_
	local viewRect = self:convertToWorldSpace(cc.p(rect.x, rect.y))
	viewRect.width = rect.width
	viewRect.height = rect.height

	return cc.rectContainsPoint(viewRect, cc.p(event.x, event.y))
end

function UIGamePageView:onTouch_(event)
	if "began" == event.name
		and not self:isTouchInViewRect_(event) then
		lt.CommonUtil.print("UIGamePageView - touch didn't in viewRect")
		return false
	end

	if "began" == event.name then
		self:stopAllTransition()
		self.bDrag_ = false
	elseif "moved" == event.name then
		self.speed = event.y - event.prevY
		if self.speed ~= 0 then
			self.bDrag_ = true
			self:scroll(self.speed)
		end
	elseif "ended" == event.name then
		if self.bDrag_ then
			self:scrollAuto()
		else
			self:resetPages_()
			self:onClick_(event)
		end
	end

	return true
end

--[[--

重置页面,检查当前页面在不在初始位置
用于在动画被stopAllTransition的情况

]]
function UIGamePageView:resetPages_()
	local x,y = self.pages_[self.curPageIdx_]:getPosition()

	if y == self.viewRect_.y then
		return
	end
	lt.CommonUtil.print("UIGamePageView - resetPages_")
	-- self.pages_[self.curPageIdx_]:getPosition(self.viewRect_.x, y)
	self:disablePage()
	self:gotoPage(self.curPageIdx_)
end

--[[--

重置相关页面的位置

@param integer pos 要移动到的位置
@param bTopToBottom 移动的方向,在可循环下有效, nil:自动调整方向,false:从下到上,true:从上到下

]]
function UIGamePageView:resetPagePos(pos, bTopToBottom)
	local pageIdx = self.curPageIdx_
	local page
	local pageHeight = self.viewRect_.height
	local dis
	local count = #self.pages_

	dis = pos - pageIdx
	if self.bCirc then
		local disT,disB
		if dis > 0 then
			disB = dis
			disT = disB - count
		else
			disT = dis
			disB = disT + count
		end

		if nil == bTopToBottom then
			dis = ((math.abs(disT) > math.abs(disB)) and disB) or disT
		elseif bTopToBottom then
			dis = disB
		else
			dis = disT
		end
	end

	local disABS = math.abs(dis)
	local y = self.pages_[pageIdx]:getPositionY()

	for i=1,disABS do
		if dis > 0 then
			pageIdx = pageIdx + 1
			y = y + pageHeight
		else
			pageIdx = pageIdx + count
			pageIdx = pageIdx - 1
			y = y - pageHeight
		end
		pageIdx = pageIdx % count
		if 0 == pageIdx then
			pageIdx = count
		end
		page = self.pages_[pageIdx]
		if page then
			page:setVisible(true)
			page:setPosition(self.viewRect_.x, y)
		end
	end
end

--[[--

移动到相对于当前页的某个位置

@param integer pos 要移动到的位置
@param bTopToBottom 移动的方向,在可循环下有效, nil:自动调整方向,false:从右向左,true:从左向右

]]
function UIGamePageView:scrollPagePos(pos, bTopToBottom)
	local pageIdx = self.curPageIdx_
	local page
	local pageHeight = self.viewRect_.height
	local dis
	local count = #self.pages_

	dis = pos - pageIdx
	if self.bCirc then
		local disT,disB
		if dis > 0 then
			disB = dis
			disT = disB - count
		else
			disT = dis
			disB = disT + count
		end

		if nil == bTopToBottom then
			dis = ((math.abs(disT) > math.abs(disB)) and disB) or disT
		elseif bTopToBottom then
			dis = disB
		else
			dis = disT
		end
	end


	local disABS = math.abs(dis)
	local y = self.viewRect_.y
	local movedis = dis*pageHeight

	for i=1, disABS do
		if dis > 0 then
			pageIdx = pageIdx + 1
		else
			pageIdx = pageIdx + count
			pageIdx = pageIdx - 1
		end
		pageIdx = pageIdx % count
		if 0 == pageIdx then
			pageIdx = count
		end
		page = self.pages_[pageIdx]
		if page then
			page:setVisible(true)
			transition.moveBy(page,
					{x = 0, y = movedis, time = 0.3})
		end
	end
	transition.moveBy(self.pages_[self.curPageIdx_],
					{x = 0, y = movedis, time = 0.3,
					onComplete = function()
						local pageIdx = (self.curPageIdx_ + dis + count)%count
						if 0 == pageIdx then
							pageIdx = count
						end
						self.curPageIdx_ = pageIdx
						self:disablePage()
						self:notifyListener_{name = "pageChange"}
					end})
end

function UIGamePageView:stopAllTransition()
	for i,v in ipairs(self.pages_) do
		transition.stopTarget(v)
	end
end

function UIGamePageView:disablePage()
	local pageIdx = self.curPageIdx_
	local page

	for i,v in ipairs(self.pages_) do
		if i ~= self.curPageIdx_ then
			v:setVisible(false)
		end
	end
end

function UIGamePageView:scroll(dis)
	local threePages = {}
	local count
	if self.pages_ then
		count = #self.pages_
	else
		count = 0
	end

	local page
	if 0 == count then
		return
	elseif 1 == count then
		table.insert(threePages, false)
		table.insert(threePages, self.pages_[self.curPageIdx_])
	elseif 2 == count then
		local posX, posY = self.pages_[self.curPageIdx_]:getPosition()
		if posY < self.viewRect_.y then
			page = self:getNextPage(false)
			if not page then
				page = false
			end
			table.insert(threePages, page)
			table.insert(threePages, self.pages_[self.curPageIdx_])
		else
			table.insert(threePages, false)
			table.insert(threePages, self.pages_[self.curPageIdx_])
			table.insert(threePages, self:getNextPage(true))
		end
	else
		page = self:getNextPage(false)
		if not page then
			page = false
		end
		table.insert(threePages, page)
		table.insert(threePages, self.pages_[self.curPageIdx_])
		table.insert(threePages, self:getNextPage(true))
	end

	self:scrollLCRPages(threePages, dis)
end

function UIGamePageView:scrollLCRPages(threePages, dis)
	local posX, posY
	local pageT = threePages[1]
	local page = threePages[2]
	local pageB = threePages[3]

	-- current
	posX, posY = page:getPosition()
	posY = posY + dis
	page:setPosition(posX, posY)

	-- left
	posY = posY + self.viewRect_.height
	if pageT and "boolean" ~= type(pageT) then
		pageT:setPosition(posX, posY)
		if not pageT:isVisible() then
			pageT:setVisible(true)
		end
	end

	posY = posY - self.viewRect_.height * 2
	if pageB then
		pageB:setPosition(posX, posY)
		if not pageB:isVisible() then
			pageB:setVisible(true)
		end
	end
end

function UIGamePageView:scrollAuto()
	local page = self.pages_[self.curPageIdx_]
	local pageT = self:getNextPage(false) -- self.pages_[self.curPageIdx_ - 1]
	local pageB = self:getNextPage(true) -- self.pages_[self.curPageIdx_ + 1]
	local bChange = false
	local posX, posY = page:getPosition()
	local dis = posY - self.viewRect_.y

	local pageBY = self.viewRect_.y - self.viewRect_.height
	local pageTY = self.viewRect_.y + self.viewRect_.height

	local count = #self.pages_
	if 0 == count then
		return
	elseif 1 == count then
		pageT = nil
		pageB = nil
	end
	if (-dis > self.viewRect_.height/2 or -self.speed > 10)
		and (self.curPageIdx_ > 1 or self.bCirc)
		and count > 1 then
		bChange = true
	elseif (dis > self.viewRect_.height/2 or self.speed > 10)
		and (self.curPageIdx_ < self:getPageCount() or self.bCirc)
		and count > 1 then
		bChange = true
	end

	if dis > 0 then
		if bChange then
			transition.moveTo(page,
				{x = posX, y = pageTY, time = 0.3,
				onComplete = function()
					self.curPageIdx_ = self:getNextPageIndex(true)
					self:disablePage()
					self:notifyListener_{name = "pageChange"}
				end})
			transition.moveTo(pageB,
				{x = posX, y = self.viewRect_.y, time = 0.3})
		else
			transition.moveTo(page,
				{x = posX, y = self.viewRect_.y, time = 0.3,
				onComplete = function()
					self:disablePage()
					self:notifyListener_{name = "pageChange"}
				end})
			if pageB then
				transition.moveTo(pageB,
					{x = posX, y = pageBY, time = 0.3})
			end
		end
	else
		if bChange then
			transition.moveTo(page,
				{x = posX, y = pageBY, time = 0.3,
				onComplete = function()
					self.curPageIdx_ = self:getNextPageIndex(false)
					self:disablePage()
					self:notifyListener_{name = "pageChange"}
				end})
			transition.moveTo(pageT,
				{x = posX, y = self.viewRect_.y, time = 0.3})
		else
			transition.moveTo(page,
				{x = posX, y = self.viewRect_.y, time = 0.3,
				onComplete = function()
					self:disablePage()
					self:notifyListener_{name = "pageChange"}
				end})
			if pageT then
				transition.moveTo(pageT,
					{x = posX, y = pageTY, time = 0.3})
			end
		end
	end
end

function UIGamePageView:onClick_(event)
	local itemW, itemH

	itemW = (self.viewRect_.width - self.padding_.left - self.padding_.right
				- self.columnSpace_*(self.column_ - 1)) / self.column_
	itemH = (self.viewRect_.height - self.padding_.top - self.padding_.bottom
				- self.rowSpace_*(self.row_ - 1)) / self.row_

	local itemRect = {width = itemW, height = itemH}

	local clickIdx
	for row = 1, self.row_ do
		itemRect.y = self.viewRect_.y + self.viewRect_.height - self.padding_.top - row*itemH - (row - 1)*self.rowSpace_
		for column = 1, self.column_ do
			itemRect.x = self.viewRect_.x + self.padding_.left + (column - 1)*(itemW + self.columnSpace_)

			if self:isTouchInViewRect_(event, itemRect) then
				clickIdx = (row - 1)*self.column_ + column
				break
			end
		end
		if clickIdx then
			break
		end
	end

	if not clickIdx then
		-- not found, maybe touch in space
		return
	end

	clickIdx = clickIdx + (self.column_ * self.row_) * (self.curPageIdx_ - 1)

	self:notifyListener_{name = "clicked",
		item = self.items_[clickIdx],
		itemIdx = clickIdx}
end

function UIGamePageView:notifyListener_(event)
	if not self.touchListener then
		return
	end

	event.pageView = self
	event.pageIdx = self.curPageIdx_
	self.touchListener(event)
end

function UIGamePageView:getNextPage(bRight)
	if not self.pages_ then
		return
	end

	if self.pages_ and #self.pages_ < 2 then
		return
	end

	local pos = self:getNextPageIndex(bRight)

	return self.pages_[pos]
end

function UIGamePageView:getNextPageIndex(bRight)
	local count = #self.pages_
	local pos
	if bRight then
		pos = self.curPageIdx_ + 1
	else
		pos = self.curPageIdx_ - 1
	end

	if self.bCirc then
		pos = pos + count
		pos = pos%count
		if 0 == pos then
			pos = count
		end
	end

	return pos
end



return UIGamePageView