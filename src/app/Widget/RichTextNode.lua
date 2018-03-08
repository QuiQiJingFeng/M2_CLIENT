
-- 富文本 自定义
local RichTextNode = class("RichTextNode", function(node, params)
	params = params or {}
	local color = params.color or lt.Constants.COLOR.WHITE
	local opacity = params.opacity or 255

	return cpp.RichItemCustom:create(0, color, opacity, node)
end)

function RichTextNode:ctor()
end

return RichTextNode
