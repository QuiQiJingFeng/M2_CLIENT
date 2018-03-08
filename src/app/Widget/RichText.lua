
-- 富文本控件
local RichText = class("RichText", function()
	return cpp.RichTextUI:create()
end)

RichText._listener = nil

function RichText:ctor()
	self:setNodeEventEnabled(true)
end

-- 注册到Manager
function RichText:onEnter()
	lt.RichTextManager:registerRichText(self)
end

function RichText:onExit()
	lt.RichTextManager:removeRichText(self)
end

-- 富文本刷新(超链接点击)
RichText._touchNodeArray = nil
function RichText:checkRefresh()
	if not self:getLuaRefresh() then
		return
	end

	if self._touchNodeArray then
		for _,touchNode in ipairs(self._touchNodeArray) do
			touchNode:removeSelf()
		end
	end
	self._touchNodeArray = {}

	local linkTable = self:getLinkVector()
	for _,linkId in ipairs(linkTable) do
		local linkLabel = self:getChildByTag(linkId)
		if linkLabel then
			local rect = linkLabel:getBoundingBox()
			
			local node = display.newNode()
		    self:addChild(node)
		    node.linkInfo = linkLabel:getContext()

			node:setContentSize(rect.width, rect.height)
			node:setPosition(rect.x, rect.y)
			node:setTouchSwallowEnabled(true)
			node:setTouchEnabled(true)
			node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
		        return self:onTouch_(event, node)
		    end)
		end
	end

	self:setLuaRefresh(false)
end

function RichText:onTouch_(event, node)
	if "began" == event.name then
		return true
	elseif "ended" == event.name then
		-- clicked
		if self._listener and node then
			self._listener(node.linkInfo)
		end
	end
end

-- 换行
function RichText:newLine()
	self:insertNewLine()
end

function RichText:setSize(size)
	self:setContentSize(size)
end

function RichText:onClicked(listener)
	self._listener = listener
	-- self:addEventListenerRichText(listener)
end

function RichText:addItem(richItem)
	self:insertElement(richItem)
end

function RichText:setTouchEnabled(bool)
	self:setTouchOn(bool)
end

function RichText:setLineHeigt(short)
	self:setLineSpace(short)
end

return RichText
