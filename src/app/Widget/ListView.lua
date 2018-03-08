
-- 重写 UIListView 从而能一行多个
local UIScrollView = cc.ui.UIScrollView
local UIListView   = cc.ui.UIListView
local ListView     = class("ListView", UIListView)

-- 注意!!! 加入 col 和 row 必须是子成员一样大小
ListView._col = 0
ListView._row = 0

ListView.LOAD_ONE_ITEM			= "loadOneItem"

function ListView:ctor(params)
    ListView.super.ctor(self, params)

    self._col = params.col or 1
    self._row = params.row or 1

    -- self:setBounceable(false)
end

function ListView:setCol(col)
	self._col = col
end

function ListView:setRow(row)
	self._row = row
end

function ListView:modifyItemSizeIf_(item)
	local w, h = item:getItemSize()

	if UIScrollView.DIRECTION_VERTICAL == self.direction then
		if w ~= self.viewRect_.width then
			item:setItemSize(self.viewRect_.width / self._col, h, true)
		end
	else
		if h ~= self.viewRect_.height then
			item:setItemSize(w, self.viewRect_.height / self._row, true)
		end
	end
end

function ListView:setViewRect(viewRect)
	if UIScrollView.DIRECTION_VERTICAL == self.direction then
		self.redundancyViewVal = viewRect.height * 0.65
	else
		self.redundancyViewVal = viewRect.width * 0.65
	end

	UIListView.super.setViewRect(self, viewRect)
end

function ListView:reload(refresh)
	if not refresh then refresh = false end

    local offsetYReverse, offsetSBX, offsetSBY = nil
	if refresh then
		if self.bAsyncLoad then
			local more = false
		    if UIScrollView.DIRECTION_VERTICAL == self.direction then 
	    		local offsetX, offsetY = self:getOffset()

	    		offsetYReverse = offsetY
		    elseif UIScrollView.DIRECTION_HORIZONTAL == self.direction then 
		    end
		else
			local width  = self.size.width or 0
			local height = self.size.height or 0

		    local more = false
		    if UIScrollView.DIRECTION_VERTICAL == self.direction and self.viewRect_.height < height then 
	    		more = true

	    		local offsetX, offsetY = self:getOffset()

	    		offsetYReverse = offsetY + height
		    elseif UIScrollView.DIRECTION_HORIZONTAL == self.direction and self.viewRect_.width < width then 
			    more = true
		    end

		    if more then
				offsetSBX, offsetSBY = self:getSBHOffset()
			end
		end
	end

	if self.bAsyncLoad then
		self:asyncLoad_()
	else
		self:layout_()
	end

	-- 显示一次
	self:enableScrollBar(true)

	if self.bAsyncLoad then
		if offsetYReverse then
			local offsetX, offsetY = self:getOffset()

			offsetY = offsetYReverse

			self:scrollTo(offsetX, offsetY)

			-- 因为是异步加载的所以reload后立即刷新一次status
			self:checkItemsInStatus_()
			self:increaseOrReduceItem_()
		end
	else
		local height = self.size.height or 0

		if offsetYReverse and height > self.viewRect_.height then
			local offsetX, offsetY = self:getOffset()

			offsetY = offsetYReverse - height

			offsetY = lt.CommonUtil:fixValue(offsetY, self.viewRect_.height - height, 0)

			self:scrollTo(offsetX, offsetY)

	        if offsetSBX and offsetSBY then
	        	self:setSBHOffset(offsetSBX, offsetSBY)
	        end
	    end
	end

	return self
end

-- 重写分布
function ListView:layout_()
	local width, height = 0, 0
	local itemW, itemH = 0, 0
	local margin

	-- calcate whole width height
	if UIScrollView.DIRECTION_VERTICAL == self.direction then
		width = self.viewRect_.width

		local idx = 0
		for i,v in ipairs(self.items_) do
			itemW, itemH = v:getItemSize()
			itemW = itemW or 0
			itemH = itemH or 0

			idx = idx + 1
			if idx == 1 then
				height = height + itemH
			end

			if idx == self._col then
				idx = 0
			end
		end
	else
		height = self.viewRect_.height

		local idx = 0
		for i,v in ipairs(self.items_) do
			itemW, itemH = v:getItemSize()
			itemW = itemW or 0
			itemH = itemH or 0

			idx = idx + 1
			if idx == 1 then
				width = width + itemW
			end

			if idx == self._row then
				idx = 0
			end
		end
	end

	self:setActualRect({x = self.viewRect_.x,
		y = self.viewRect_.y,
		width = width,
		height = height})
	self.size.width = width
	self.size.height = height

	local tempWidth, tempHeight = width, height
	if UIScrollView.DIRECTION_VERTICAL == self.direction then
		itemW, itemH = 0, 0

		local content
		local idx = 0
		for i,v in ipairs(self.items_) do
			itemW, itemH = v:getItemSize()
			itemW = itemW or 0
			itemH = itemH or 0

			local calWidth  = idx * itemW
			local calHeight = tempHeight - itemH
			content = v:getContent()
			content:setAnchorPoint(0.5, 0.5)
			self:setPositionByAlignment_(content, itemW, itemH, v:getMargin(), idx)
			v:setPosition(self.viewRect_.x + calWidth, self.viewRect_.y + calHeight)

			idx = idx + 1
			if idx == self._col then
				tempHeight = tempHeight - itemH

				idx = 0
			end
		end
	else
		itemW, itemH = 0, 0
		tempWidth = 0

		local content
		local idx = 0
		for i,v in ipairs(self.items_) do
			itemW, itemH = v:getItemSize()
			itemW = itemW or 0
			itemH = itemH or 0

			local calWidth  = tempWidth
			local calHeight = (self._row - idx - 1) * itemH
			content = v:getContent()
			content:setAnchorPoint(0.5, 0.5)
			self:setPositionByAlignment_(content, itemW, itemH, v:getMargin(), idx)
			v:setPosition(self.viewRect_.x + calWidth, self.viewRect_.y + calHeight)
			
			idx = idx + 1
			if idx == self._row then
				tempWidth = tempWidth + itemW

				idx = 0
			end
		end
	end

	self.container:setPosition(0, self.viewRect_.height - self.size.height)
end

function ListView:increaseOrReduceItem_()

	if 0 == #self.items_ then
		-- lt.CommonUtil.print("ERROR items count is 0")
		return
	end

	local getContainerCascadeBoundingBox = function ()
		local boundingBox
		for i, item in ipairs(self.items_) do
			local w,h = item:getItemSize()
			local x,y = item:getPosition()
			local anchor = item:getAnchorPoint()
			x = x - anchor.x * w
			y = y - anchor.y * h

			if boundingBox then
				boundingBox = cc.rectUnion(boundingBox, cc.rect(x, y, w, h))
			else
				boundingBox = cc.rect(x, y, w, h)
			end
		end

		local point = self.container:convertToWorldSpace(cc.p(boundingBox.x, boundingBox.y))
		boundingBox.x = point.x
		boundingBox.y = point.y
		return boundingBox
	end

	local count = self.delegate_[UIListView.DELEGATE](self, UIListView.COUNT_TAG)
	local nNeedAdjust = 2 --作为是否还需要再增加或减少item的标志,2表示上下两个方向或左右都需要调整
	local cascadeBound = getContainerCascadeBoundingBox()
	local item
	local itemW, itemH

	if UIScrollView.DIRECTION_VERTICAL == self.direction then

		--ahead part of view
		local disH = cascadeBound.y + cascadeBound.height - self.viewRect_.y - self.viewRect_.height
		local tempIdx
		item = self.items_[1]
		if not item then
			lt.CommonUtil.print("increaseOrReduceItem_ item is nil, all item count:" .. #self.items_)
			return
		end
		tempIdx = item.idx_
		-- lt.CommonUtil.print(string.format("befor disH:%d, view val:%d", disH, self.redundancyViewVal))
		if disH > self.redundancyViewVal then
			itemW, itemH = item:getItemSize()
			if cascadeBound.height - itemH > self.viewRect_.height and disH - itemH > self.redundancyViewVal then
				-- 消除当前整数行
				local row = math.floor((tempIdx - 1) / self._col) + 1
				for i=1,self._col do
					local ttempIdx = tempIdx + (i - 1)
					local tempRow = math.floor((ttempIdx - 1) / self._col) + 1

					if tempRow ~= row then
						break
					end

					-- lt.CommonUtil.printf("before unload %d", ttempIdx)
					self:unloadOneItem_(ttempIdx)
				end
			else
				nNeedAdjust = nNeedAdjust - 1
			end
		else
			item = nil
			tempIdx = tempIdx - 1
			if tempIdx > 0 then
				-- 添加当前整行
				local localPoint = self.container:convertToNodeSpace(cc.p(cascadeBound.x, cascadeBound.y + cascadeBound.height))
				local row = math.floor((tempIdx - 1) / self._col) + 1
				for i=1,self._col do
					local ttempIdx = tempIdx - (i-1)
					if ttempIdx <= 0 then
						break
					end

					local tempRow = math.floor((ttempIdx - 1) / self._col) + 1

					if tempRow ~= row then
						break
					end

					-- lt.CommonUtil.printf("before load %d", ttempIdx)
					item, itemW, itemH = self:loadOneItem_(localPoint, ttempIdx, true)

					if item == nil then
						break
					end
				end
			end
			if nil == item then
				nNeedAdjust = nNeedAdjust - 1
			end
		end

		--part after view
		disH = self.viewRect_.y - cascadeBound.y
		item = self.items_[#self.items_]
		if not item then
			return
		end
		tempIdx = item.idx_
		-- lt.CommonUtil.print(string.format("after disH:%d, view val:%d", disH, self.redundancyViewVal))
		if disH > self.redundancyViewVal then
			itemW, itemH = item:getItemSize()
			if cascadeBound.height - itemH > self.viewRect_.height and disH - itemH > self.redundancyViewVal then
				local row = math.floor((tempIdx - 1) / self._col) + 1

				for i=1,self._col do
					local ttempIdx = tempIdx - (i-1)
					local tempRow = math.floor((ttempIdx - 1) / self._col) + 1

					if tempRow ~= row then
						break
					end

					-- lt.CommonUtil.printf("after unload %d", ttempIdx)
					self:unloadOneItem_(ttempIdx)
				end
			else
				nNeedAdjust = nNeedAdjust - 1
			end
		else
			item = nil
			tempIdx = tempIdx + 1
			if tempIdx <= count then
				local localPoint = self.container:convertToNodeSpace(cc.p(cascadeBound.x, cascadeBound.y))

				local row = math.floor((tempIdx - 1) / self._col) + 1
				for i=1,self._col do
					local ttempIdx = tempIdx + (i - 1)
					if ttempIdx > count then
						-- lt.CommonUtil.printf("after load over break")
						break
					end

					local tempRow = math.floor((ttempIdx - 1) / self._col) + 1

					if tempRow ~= row then
						break
					end

					-- lt.CommonUtil.printf("after load %d", ttempIdx)
					item, itemW, itemH = self:loadOneItem_(localPoint, ttempIdx)
					if ttempIdx % self._col == 1 then
						localPoint.y = localPoint.y - itemH
					end

					if item == nil then
						-- lt.CommonUtil.printf("after load nil break")
						break
					end
				end
			end

			if nil == item then
				nNeedAdjust = nNeedAdjust - 1
			end
		end
	else
		--left part of view
		local disW = self.viewRect_.x - cascadeBound.x
		item = self.items_[1]
		local tempIdx = item.idx_
		if disW > self.redundancyViewVal then
			itemW, itemH = item:getItemSize()
			if cascadeBound.width - itemW > self.viewRect_.width
				and disW - itemW > self.redundancyViewVal then
				self:unloadOneItem_(tempIdx)
			else
				nNeedAdjust = nNeedAdjust - 1
			end
		else
			item = nil
			tempIdx = tempIdx - 1
			if tempIdx > 0 then
				local localPoint = self.container:convertToNodeSpace(cc.p(cascadeBound.x, cascadeBound.y))
				item, itemW, itemH = self:loadOneItem_(localPoint, tempIdx, true)
			end
			if nil == item then
				nNeedAdjust = nNeedAdjust - 1
			end
		end

		--right part of view
		disW = cascadeBound.x + cascadeBound.width - self.viewRect_.x - self.viewRect_.width
		item = self.items_[#self.items_]
		tempIdx = item.idx_
		if disW > self.redundancyViewVal then
			itemW, itemH = item:getItemSize()
			if cascadeBound.width - itemW > self.viewRect_.width
				and disW - itemW > self.redundancyViewVal then
				self:unloadOneItem_(tempIdx)
			else
				nNeedAdjust = nNeedAdjust - 1
			end
		else
			item = nil
			tempIdx = tempIdx + 1
			if tempIdx <= count then
				local localPoint = self.container:convertToNodeSpace(cc.p(cascadeBound.x + cascadeBound.width, cascadeBound.y))
				item, itemW, itemH = self:loadOneItem_(localPoint, tempIdx)
			end
			if nil == item then
				nNeedAdjust = nNeedAdjust - 1
			end
		end
	end

	-- lt.CommonUtil.print("increaseOrReduceItem_() adjust:" .. nNeedAdjust)
	-- lt.CommonUtil.print("increaseOrReduceItem_() item count:" .. #self.items_)
	if nNeedAdjust > 0 then
		return self:increaseOrReduceItem_()
	end
end

function ListView:asyncLoad_()
	-- lt.CommonUtil.print("ListView:asyncLoad_")
	self:removeAllItems()
	self.container:setPosition(0, 0)
	self.container:setContentSize(cc.size(0, 0))

	local count = self.delegate_[UIListView.DELEGATE](self, UIListView.COUNT_TAG)

	self.items_ = {}
	local itemW, itemH = 0, 0
	local item
	local containerW, containerH = 0, 0
	local posX, posY = 0, 0
	local idx = 0
	for i=1,count do
		item, itemW, itemH = self:loadOneItem_(cc.p(posX, posY), i)

		idx = idx + 1
		if UIScrollView.DIRECTION_VERTICAL == self.direction then
			posX = posX + itemW

			if idx == 1 then
				posY = posY - itemH
			end

			if idx == self._col then
				posX = 0

				containerH = containerH + itemH

				idx = 0
			end
		else
			posY = posY + itemH

			if idx == self._row then
				posX = posX + itemW
				posY = 0

				containerW = containerW + itemW

				idx = 0
			end
		end

		-- 初始布局,最多保证可隐藏的区域大于显示区域就可以了
		if containerW > self.viewRect_.width + self.redundancyViewVal
			or containerH > self.viewRect_.height + self.redundancyViewVal then
			break
		end
	end

	-- self.container:setPosition(self.viewRect_.x, self.viewRect_.y)
	if UIScrollView.DIRECTION_VERTICAL == self.direction then
		self.container:setPosition(self.viewRect_.x,
			self.viewRect_.y + self.viewRect_.height)
	else
		self.container:setPosition(self.viewRect_.x, self.viewRect_.y)
	end

	return self
end

function ListView:loadOneItem_(originPoint, idx, bBefore)
	local itemW, itemH = 0, 0
	local item
	local containerW, containerH = 0, 0
	local posX, posY = originPoint.x, originPoint.y
	local content

	item = self.delegate_[UIListView.DELEGATE](self, UIListView.CELL_TAG, idx)
	if nil == item then
		lt.CommonUtil.print("ERROR! UIListView load nil item")
		return
	end
	item.idx_ = idx
	itemW, itemH = item:getItemSize()

	if UIScrollView.DIRECTION_VERTICAL == self.direction then
		itemW = itemW or 0
		itemH = itemH or 0

		posX = itemW * ((idx - 1) % self._col)

		if bBefore then
			if self._col == 1 or idx % self._col == 0 then
				-- posY = posY + itemH
			end
		else
			if self._col == 1 or idx % self._col == 1 then
				-- 第一个准备换行
				posY = posY - itemH
			end
		end
		content = item:getContent()
		content:setAnchorPoint(0.5, 0.5)
		self:setPositionByAlignment_(content, itemW, itemH, item:getMargin())
		item:setPosition(posX, posY)

		containerH = containerH + itemH
	else
		itemW = itemW or 0
		itemH = itemH or 0
		if bBefore then
			posX = posX - itemW
		end

		content = item:getContent()
		content:setAnchorPoint(0.5, 0.5)
		self:setPositionByAlignment_(content, itemW, itemH, item:getMargin())
		item:setPosition(posX, 0)

		containerW = containerW + itemW
	end

	if bBefore then
		table.insert(self.items_, 1, item)
	else
		table.insert(self.items_, item)
	end

	self.container:addChild(item)
	if item.bFromFreeQueue_ then
		item.bFromFreeQueue_ = nil
		item:release()
	end

	self.delegate_[UIListView.DELEGATE](self, ListView.LOAD_ONE_ITEM, idx, item)

	return item, itemW, itemH
end

function ListView:scrollListener(event)
	if "clicked" == event.name or "began" == event.name then
		local nodePoint = self.container:convertToNodeSpace(cc.p(event.x, event.y))
		local pos
		local idx

		if self.bAsyncLoad then
			local itemRect
			for i,v in ipairs(self.items_) do
				local posX, posY = v:getPosition()
				local itemW, itemH = v:getItemSize()
				itemRect = cc.rect(posX, posY, itemW, itemH)
				if cc.rectContainsPoint(itemRect, nodePoint) then
					idx = v.idx_
					pos = i
					break
				end
			end
		else
			nodePoint.x = nodePoint.x - self.viewRect_.x
			nodePoint.y = nodePoint.y - self.viewRect_.y

			local width, height = 0, self.size.height
			local itemW, itemH = 0, 0

			if UIScrollView.DIRECTION_VERTICAL == self.direction then
				local tempWidth  = 0
				local idx        = 0
				for i,v in ipairs(self.items_) do
					itemW, itemH = v:getItemSize()
					tempWidth = idx * itemW

					if nodePoint.x > tempWidth and nodePoint.x < tempWidth + itemW and nodePoint.y < height and nodePoint.y > height - itemH then
						pos = i
						idx = pos
						nodePoint.x = nodePoint.x - tempWidth
						nodePoint.y = nodePoint.y - (height - itemH)
						break
					end

					idx = idx + 1
					if idx == self._col then
						height = height - itemH

						idx = 0
					end
				end
			else
				local tempHeight  = 0
				local idx         = 0
				for i,v in ipairs(self.items_) do
					itemW, itemH = v:getItemSize()
					tempHeight = (self._row - idx) * itemH

					if nodePoint.x > width and nodePoint.x < width + itemW and nodePoint.y < tempHeight and nodePoint.y > tempHeight - itemH then
						pos = i
						idx = pos
						nodePoint.x = nodePoint.x - width
						nodePoint.y = nodePoint.y - (tempHeight - itemH)
						break
					end

					idx = idx + 1
					if idx == self._row then
						width = width + itemW

						idx = 0
					end
				end
			end
		end

		item = self.items_[pos]

		if event.name == "began" or item then
			self:notifyListener_{name = event.name,
				listView = self, itemPos = pos, item = item,
				point = nodePoint,
				idx = idx,
				x = event.x, y = event.y}
		end
	else
		event.scrollView = nil
		event.listView = self
		self:notifyListener_(event)
	end

end

function ListView:getItemByPos(pos)
	return self.items_[pos]
end

function ListView:getAllChildren()
	return self.items_
end

function ListView:getAllItems()
	return self.items_
end

function ListView:getItemCount()
	return #self.items_
end

function ListView:getFirstItem()
	return self.items_[1]
end

function ListView:checkItemStatus_(item)
	local rectIntersectsRect = function(rectParent, rect)
		local nIntersects -- 0:no intersects,1:have intersects,2,have intersects and include totally
		local bIn = rectParent.x <= rect.x and
				rectParent.x + rectParent.width >= rect.x + rect.width and
				rectParent.y <= rect.y and
				rectParent.y + rectParent.height >= rect.y + rect.height
		if bIn then
			nIntersects = 2
		else
			local bNotIn = rectParent.x > rect.x + rect.width or
				rectParent.x + rectParent.width < rect.x or
				rectParent.y > rect.y + rect.height or
				rectParent.y + rectParent.height < rect.y
			if bNotIn then
				nIntersects = 0
			else
				nIntersects = 1
			end
		end

		return nIntersects
	end

	bound = item:getBoundingBox()
	nodePoint = self.container:convertToWorldSpace(cc.p(bound.x, bound.y))
	bound.x = nodePoint.x
	bound.y = nodePoint.y

	return rectIntersectsRect(self.viewRect_, bound)
end

function ListView:getContainerHeight()
	return self.container:getCascadeBoundingBox().height
end

return ListView
