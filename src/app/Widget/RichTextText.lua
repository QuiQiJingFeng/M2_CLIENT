
-- 富文本 文字
local RichTextText = class("RichTextText", function(string, fontSize, color, params)
	params = params or {}
	local opacity = params.opacity or 255

	return cpp.RichItemText:create(0, color, opacity, string, lt.Constants.FONT, fontSize) 
end)

-- function setContext     设置key 点击回调
-- function enableLinkLine 开启超链接
function RichTextText:ctor(string, fontSize, color, params)
	params = params or {}

	local link    = params.link or false

	if link then
		-- 超链接
		local linkColor = params.linkColor
		if not linkColor then
			linkColor = cc.c4b(color.r, color.g, color.b, 255)
		end
		local linkSize  = params.linkSize or 1
		local linkInfo  = params.linkInfo or string

		self:enableLinkLine(linkColor, linkSize)
    	self:setContext(linkInfo)
	end

	if params.outline then
		self:setOutLine(params.outlineColor, params.outlineSize)
	end
end

function RichTextText:setOutLine(color4b, outlineSize)
	local fontColor = self:getColor()
	self:setColor(cc.c3b(255,255,255))
	self:setTextColor(cc.c4b(fontColor.r, fontColor.g, fontColor.b, 255))

	if not color4b then color4b = cc.c4b(255, 255, 255, 255) end
	if not color4b.a then color4b.a = 255 end
	if not outlineSize then outlineSize = 2 end

	self:enableOutLine(color4b, outlineSize)
end


return RichTextText
