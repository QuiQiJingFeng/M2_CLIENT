
--[[
	params 为 额外参数
	params.shadow 开启阴影
	params.shadowColor 阴影颜色 c4b(可选)
	params.shadowSize 阴影偏移 size(可选)

	params.outline 开启描边
	params.outlineColor 描边颜色 默认白色(可选)
	params.outlineSize 描边大小 默认2(可选)


	function
		setAdditionalKerning 设置字间距
]]

local GameLabel = class("GameLabel", function(stringInfo, fontSize, fontColor, params)

	if params and params.nonewline then stringInfo = string.gsub(stringInfo, "\n", "") end

    local lparams = {}
    lparams.text  = stringInfo
    lparams.font  = lt.Constants.FONT
    lparams.size  = fontSize

    if params and params.font then
    	lparams.font = params.font
    end

    if fontColor ~= nil then lparams.color = fontColor else lparams.color = lt.Constants.COLOR.WHITE end
    if params and params.align then lparams.align = params.align end
    local label = display.newTTFLabel(lparams)
    -- label:getTexture():setAliasTexParameters()

    return label
end)

GameLabel._fontColor = nil

function GameLabel.newString(key, fontSize, fontColor, params)
	local stringInfo = lt.StringManager:getString(key)
	return GameLabel.new(stringInfo, fontSize, fontColor, params)
end

function GameLabel:ctor(stringInfo, fontSize, fontColor, params)
	if params then
		if params.shadow then
			self:setShadow(params.shadowColor, params.shadowSize)
		end

		if params.outline then
			self:setOutLine(params.outlineColor, params.outlineSize)
			-- self:setAdditionalKerning(-3)
		end
	end
end

function GameLabel:setLineWidth(width)
	self:setDimensions(width,0)
end

function GameLabel:setShadow(color4b, size)
	if not color4b then color4b = cc.c4b(0, 0, 0, 40) end
	if not size then size = cc.size(1, -2) end

	self:enableShadow(color4b, size)
end

function GameLabel:setOutLine(color4b, outlineSize)
	self._fontColor = self:getColor()
	self:setColor(cc.c3b(255,255,255))
	self:setTextColor(cc.c4b(self._fontColor.r, self._fontColor.g, self._fontColor.b, 255))

	if not color4b then color4b = cc.c4b(255, 255, 255, 255) end
	if not color4b.a then color4b.a = 255 end
	if not outlineSize then outlineSize = 2 end

	self:enableOutline(color4b, outlineSize)
end

function GameLabel:setTextColor3B(color3b)
	self:setTextColor(cc.c4b(color3b.r, color3b.g, color3b.b, 255))
end

function GameLabel:setOutLineColor3B(color3b, outlineSize)
	if not outlineSize then outlineSize = 2 end
	self:enableOutline(cc.c4b(color3b.r, color3b.g, color3b.b, 255), outlineSize)
end

function GameLabel:setColorString(itemType,itemModelId)
	local name = ""
	local quality = 1
	if itemType == lt.GameIcon.TYPE.ITEM then
		local itemInfo = lt.CacheManager:getItemInfo(itemModelId)
		if itemInfo then
			name = itemInfo:getName()
			quality = itemInfo:getGrade()
		end
	elseif itemType == lt.GameIcon.TYPE.EQUIPMENT then
		local equipmentInfo = lt.CacheManager:getEquipmentInfo(itemModelId)
		if equipmentInfo then
			name = equipmentInfo:getName()
			quality = equipmentInfo:getQuality()
		end
	end
	self:setString(name)
	self:setColor(lt.UIMaker:getGradeColor(quality))
end

return GameLabel