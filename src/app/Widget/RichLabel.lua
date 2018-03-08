--支持变色的GameLabel,目前不支持换行
local RichLabel = class("RichLabel", function()
	return display.newNode()
end)

function RichLabel:ctor(str,fontSize,fontColor,...)
    if arg.n % 2 ~= 0 then
        lt.CommonUtil.print("[lua error] params after fontColor must as pairs")
        return
    end

    local richTable = string.split(str, "%s")
    local strTable = {}
    local i = 1
    for k,v in pairs(richTable) do
        table.insert(strTable,i,v)
        i = i+2
    end

    local j = 2
    for k,v in pairs(arg) do
        if type(v) == "string" then
            table.insert(strTable,j,v)
            j = j+2
        end
    end

    local x = 0
    local n = 1
    for k,str in pairs(strTable) do
        local lblText = lt.GameLabel.new(str,fontSize,fontColor)
        lblText:setAnchorPoint(0,0.5)
        lblText:setPosition(x,self:getContentSize().height/2)
        self:addChild(lblText)
        
        if n%2 == 0 then
            lblText:setColor(arg[n])
        end

        n = n + 1
        x = x + lblText:getContentSize().width
    end

end

return RichLabel
