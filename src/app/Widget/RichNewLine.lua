
-- 富文本 文字
local RichNewLine = class("RichNewLine", function(tag)
	tag = tag or 0

	return cpp.RichItemNewLine:create(tag) 
end)

function RichNewLine:ctor(tag)
end

return RichNewLine
