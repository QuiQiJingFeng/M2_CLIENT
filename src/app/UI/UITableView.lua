local UITableView = {}
UITableView.__index = UITableView

function UITableView:bindNode(scroll_view,cell_path)
	local parent = scroll_view:getParent()
	scroll_view:removeSelf()
	local t = class("UITableView",function() 
		return scroll_view
	end)
	setmetatable(t,UITableView)
	local obj = t.new()
	obj:init(cell_path)

	parent:addChild(obj)
	return obj
end

function UITableView:init(cell_path)
	self.cell_path = cell_path

	self.inner_container = self:getInnerContainer()
	local direction = self:getDirection()
    self.vertical = direction == ccui.ScrollViewDir.vertical


	self.used_cells = {}
	self.cell_pool = {}


	local inner_size = nil
	local cell = self:dequeueCell(-1)
	self.cell_size = cell:getContentSize()
	self.cell_anchor = cell:getAnchorPoint()

	self:pushToCellPool(cell)

	--监听事件
    self:addEventListener(handler(self,self.listenter))
    local function onNodeEvent(event)
        if event == "exit" then
            self:clearPool()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end


--clear cell pool
function UITableView:clearPool()
	for _,cell in ipairs(self.cell_pool) do
		cell:release()
	end
	self.cell_pool = {}
end

function UITableView:pushToCellPool(cell)
	for i=#self.used_cells,1,-1 do
		local old = self.used_cells[i]
		if cell:getTag() == old:getTag() then
			table.remove(self.used_cells,i)
			break
		end
	end
	cell:setTag(-1)
	cell:removeSelf()
	cell:retain()
	table.insert(self.cell_pool,cell)
end

--get a unused cell from pool
function UITableView:dequeueCell(idx)
	local cell = table.remove(self.cell_pool)
	if not cell then
		cell = require(self.cell_path).new()
		cell:retain()
	end

	self:autoRelease(cell)
	cell:setTag(idx)
	if idx > 0 then
		cell:refreshData(self.data[idx])
	end
	table.insert(self.used_cells,cell)
	table.sort(self.used_cells,function(a,b) 
			return a:getTag() < b:getTag()
		end)

	return cell
end

function UITableView:clearUsedCells()
	for i=#self.used_cells,1,-1 do
		local cell = self.used_cells[i]
		self:pushToCellPool(cell)
	end
end

-- load data to init tableview
function UITableView:setData(data,x_space,y_space,unit)
	self.data = data
	self:clearUsedCells()
	self.x_space = x_space or 0
	self.y_space = y_space or 0
	self.unit = unit or 10

	
	if self.vertical then
		local height = (self.cell_size.height * #data) + (#data -1) * self.unit + self.y_space
		local width = self:getContentSize().width
		local inner_size = cc.size(width,height)
		self:setInnerContainerSize(inner_size)
	else
		local height = self:getContentSize().height
		local width = (self.cell_size.width * #data) + (#data -1) * self.unit + self.x_space
		local inner_size = cc.size(width,height)
		self:setInnerContainerSize(inner_size)
	end

	self.inner_size = self:getInnerContainerSize()
	for idx=1,#self.data do
		local anchor = self.cell_anchor
		local size = self.cell_size
		local x,y
		if self.vertical then
			y = self.inner_size.height - ((size.height + self.unit) * (idx-1) + self.y_space + (1-anchor.y)*size.height) * 1
			x = self.x_space + anchor.x * size.width
		else
			y = self.y_space
			x = (size.width + self.unit) * (idx-1) + self.x_space + size.width/2
		end
		local pos = cc.p(x,y)
		local inter = self:checkInter(pos)
		--如果不相交
		if inter then
			local cell = self:dequeueCell(idx)
			cell:setPosition(pos)
			self:addChild(cell)
		else
			break
		end
	end
end

function UITableView:checkInter(pos)
	local x = pos.x - self.cell_size.width * self.cell_anchor.x
	local y = pos.y - self.cell_size.height * self.cell_anchor.y

	local word_pos = self.inner_container:convertToWorldSpace(cc.p(x,y))
	local new_pos = self:convertToNodeSpace(word_pos)
	local cell_box = {x=new_pos.x,y=new_pos.y,width=self.cell_size.width,height=self.cell_size.height}
	local box = self:getBoundingBox()
	box.x = 0
	box.y = 0
	local inter = cc.rectIntersectsRect(cell_box,box)
	return inter
end


function UITableView:update()
	--检查是否有正在使用的cell 出了边界
	for i=#self.used_cells,1,-1 do
		local cell = self.used_cells[i]
		local inter = self:checkInter(cc.p(cell:getPosition()))
		if not inter then
			self:pushToCellPool(cell)
		end
	end

	--往后检查
	repeat
		local last_cell = self.used_cells[#self.used_cells]
		if not last_cell then
			break
		end
		local size = last_cell:getContentSize()
		local anchor = last_cell:getAnchorPoint()
		local idx = last_cell:getTag()
		if idx + 1 > #self.data then
			break
		end
		if self.vertical then
			y = self.inner_size.height -  ((size.height + self.unit) * (idx) + self.y_space + (1-anchor.y)*size.height) 
			x = self.x_space + anchor.x * size.width
		else
			y = self.y_space
			x = (size.width + self.unit) * (idx) + self.x_space + size.width/2
		end

		local pos = cc.p(x,y)

		local inter = self:checkInter(pos)
		if inter then
			local cell = self:dequeueCell(idx+1)
			cell:setPosition(pos)
			self:addChild(cell)
		end
	until not inter

	--往前检查
	repeat
		local first_cell = self.used_cells[1]
		if not first_cell then
			break
		end
		local size = first_cell:getContentSize()
		local anchor = first_cell:getAnchorPoint()
		local idx = first_cell:getTag()
		if idx - 1 <= 0 then
			break
		end
		
		if self.vertical then
			y = self.inner_size.height -  ((size.height + self.unit) * (idx-2) + self.y_space + (1-anchor.y)*size.height) 
			x = self.x_space + anchor.x * size.width
		else
			y = self.y_space
			x = (size.width + self.unit) * (idx-2) + self.x_space + size.width/2
		end

		local pos = cc.p(x,y)
		local inter = self:checkInter(pos)
		if inter then
			local cell = self:dequeueCell(idx-1)
			cell:setPosition(pos)
			self:addChild(cell)
		end
	until not inter
end

function UITableView:listenter(sender,event_name)
    if event_name == ccui.ScrollviewEventType.scrolling or event_name == ccui.ScrollviewEventType.containerMoved then
        self:update()  
    end
end

--delay execute release operator
function UITableView:autoRelease(cell)
	local scheduler = cc.Director:getInstance():getScheduler()
	scheduler:scheduleScriptFunc(function(dt)
	    cell:release()
	end,0,true)
end


return UITableView



--[[
    local tableview = require("common.UITableView").new("common.UITableViewItem")
    tableview:setContentSize(cc.size(400,400))
    tableview:setPosition(cc.p(100,100))
    self:addChild(tableview)

    tableview:setData({ {str="*"},{str="**"},{str="***"},{str="****"},{str="*****"},{},{},{},{},{},{},{},{},{},{},{},{},{} })


]]