
local GamePageView = class("GamePageView", function()
	return display.newNode()
end)

GamePageView._showPageIcon   = nil
GamePageView._pageIconOffset = nil
GamePageView._pageIconWidth  = nil
GamePageView._pageIcons      = nil
GamePageView._pageIconScale  = nil
GamePageView._curPageIcon    = nil

function GamePageView:ctor(params)
	self._pageView = cc.ui.UIPageView.new(params)
	self._pageView:onTouch(handler(self,self.onTouched))
	self:addChild(self._pageView)

	self.viewRect_ = params.viewRect or cc.rect(0, 0, display.width, display.height)
	self._showPageIcon   = params.showPageIcon
	if self._showPageIcon == nil then
		self._showPageIcon = true
	end
	self._pageIconOffset = params.pageIconOffset or 0
	self._pageIcons 	 = {}
	self._pageIconWidth  = params.iconWidth or 0
	self._pageIconScale  = params.iconScale or 1

	self:setContentSize(cc.size(self.viewRect_.width,self.viewRect_.height))

	self:setTouchEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        return self._pageView:onTouch_(event)
    end)
end

function GamePageView:reload(idx)
	for _,pageIcon in pairs(self._pageIcons) do
		pageIcon:removeFromParent()
	end

	if self._curPageIcon then
		self._curPageIcon:removeFromParent()
		self._curPageIcon = nil
	end
	-- 清除所有child
	self._pageView:reload(idx)

	local pageCount = self._pageView:getPageCount()

	-- 增加页签图标
	self._pageIcons = {}

	if self._pageIconWidth == 0 then
		self._pageIconWidth = math.max(30, math.min(90, self.viewRect_.width / pageCount))
	end

	if self._showPageIcon then
		local viewWidth = self.viewRect_.width

		for i = 1, pageCount do
			local pageIcon = display.newSprite("#common_page_back.png")
			pageIcon:setScale(self._pageIconScale)
			pageIcon:setPosition(self.viewRect_.x + viewWidth / 2 + ((1 - pageCount) / 2 + i - 1) * self._pageIconWidth, self.viewRect_.y + self._pageIconOffset)
			self:addChild(pageIcon, 10)

			table.insert(self._pageIcons, pageIcon)
		end

		if not idx or idx < 1 then
			idx = 1
		elseif idx > pageCount then
			idx = pageCount
		end

		self._curPageIcon = display.newSprite("#common_page_on.png")
		self._curPageIcon:setScale(self._pageIconScale)
		self._curPageIcon:setPosition(self.viewRect_.x + viewWidth / 2 + ((1 - pageCount) / 2 + idx - 1) * self._pageIconWidth, self.viewRect_.y + self._pageIconOffset)
		self:addChild(self._curPageIcon , 11)
	end
end

function GamePageView:removeAllItems()
	self._pageView:removeAllItems()
end

function GamePageView:getAllItems()
	return self._pageView.items_
end

function GamePageView:newItem()
	return self._pageView:newItem()
end

function GamePageView:addItem(item)
	self._pageView:addItem(item)
end

function GamePageView:onTouch(listener)
	self.touchListener = listener

	return self
end

function GamePageView:getCurPageIdx()
	return self._pageView:getCurPageIdx()
end

function GamePageView:getPageCount()
	return self._pageView:getPageCount()
end

function GamePageView:getNextPageIndex(bRight)
	local count = #self._pageView.pages_
	local pos
	if bRight then
		pos = self._pageView:getCurPageIdx() + 1
	else
		pos = self._pageView:getCurPageIdx() - 1
	end

	if self.bCirc then
		pos = pos + count
		pos = pos%count
		if 0 == pos then
			pos = count
		end
	else
		pos = math.max(0, pos)
		pos = math.min(count + 1, pos)
	end

	return pos
end

function GamePageView:gotoPage(pageIndex,bSmooth)
	local smooth = bSmooth or false
	self._pageView:gotoPage(pageIndex,smooth)
end

function GamePageView:onTouched(event)
	if event and event.name == "pageChange" and self._curPageIcon ~= nil then
		local pageCount = self._pageView:getPageCount()
		local viewWidth = self.viewRect_.width

		self._curPageIcon:setVisible(true)
		self._curPageIcon:setPosition(self.viewRect_.x + viewWidth / 2 + ((1 - pageCount) / 2 + self._pageView.curPageIdx_ - 1) * self._pageIconWidth, self.viewRect_.y + self._pageIconOffset)
	end

	if not self.touchListener then
		return
	end

	self.touchListener(event)
end

return GamePageView
