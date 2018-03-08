
local GameBMLabel = class("GameBMLabel", function(stringInfo, font, params)
    if not stringInfo then stringInfo = "" end

    params = params or {}
    params.text  = (string.gsub(stringInfo, "\\n", '\n'))
    if string.byte(font) == 35 then -- first char is #
        params.font  = string.sub(font, 2)
    else
        params.font  = lt.Constants.BMFONTPATH .. font
    end
    params.align = cc.TEXT_ALIGNMENT_CENTER

    local bmLabel = display.newBMFontLabel(params)
    -- bmLabel:getTexture():setAliasTexParameters()
    
    return bmLabel
end)

function GameBMLabel:ctor(stringInfo, font, params)
end

function GameBMLabel.newString(key, font, params)
    local stringInfo = lt.StringManager:getString(key)
    return GameBMLabel.new(stringInfo, font, params)
end

function GameBMLabel:setLineBreakString(stringInfo)
    if not stringInfo then
        stringInfo = ""
    else
        stringInfo = string.gsub(stringInfo, "\\n", '\n');
    end

    self:setString(stringInfo)
end

return GameBMLabel