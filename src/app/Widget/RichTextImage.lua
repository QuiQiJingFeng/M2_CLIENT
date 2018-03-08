
-- 富文本 图片
local RichTextImage = class("RichTextImage", function(filePath, params)
	params = params or {}
	local color = params.color or lt.Constants.COLOR.WHITE
	local opacity = params.opacity or 255

	return cpp.RichItemImage:create(0, color, opacity, filePath)
end)

function RichTextImage:ctor()
end

return RichTextImage
