
--[[
	params 为 额外参数
	params.shadow 开启阴影
	params.shadowColor 阴影颜色 c4b(可选)
	params.shadowSize 阴影偏移 size(可选)

	params.outline 开启描边
	params.outlineColor 描边颜色 默认白色(可选)
	params.outlineSize 描边大小 默认2(可选)
]]

local GameNumberLabel = class("GameNumberLabel", function(stringInfo, fontSize, fontColor, params)

    if not params then
    	params = {}
    end

    params.font = "fonts/gameNumberFont.TTF"
    
    return lt.GameLabel.new(stringInfo, fontSize, fontColor, params)
end)


return GameNumberLabel