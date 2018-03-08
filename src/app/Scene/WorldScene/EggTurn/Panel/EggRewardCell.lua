local EggRewardCellSize = cc.size(265, 104)

local EggRewardCell = class("EggRewardCell", function()
	return lt.GameListCell.new(lt.GameListCell.TYPE.GAME_LIST_CELL_TYPE_1, 265 * lt.CacheManager:getWinScale(),0,0)
end)

EggRewardCell._infoNode = nil
EggRewardCell._selectFlag = nil
EggRewardCell._winScale = lt.CacheManager:getWinScale()


function EggRewardCell:ctor()
	self._infoNode = display.newNode()
	self._infoNode:setScale(lt.CacheManager:getWinScale())
	self:addChild(self._infoNode)
end
    
function EggRewardCell:updateInfo(row, info)
    self._selectFlag = nil
	self._infoNode:removeAllChildren()

    local index --序号
    local itemName --名字
    local itemType --道具类型
    local itemId --道具id
    --local itemName = info:getRate()--概率
    --local itemName = info:getBind()--是否绑定
    local itemCount --数量
    --local itemAnnounce = info:getAnnounce()--是否系统公告
    local itemCategory  --类别

	-- if row == 1 then--如果是彩蛋
 --       index = info._index
 --       itemName = info:getName()
 --       itemType = info:getType()
 --       itemId = info:getId()
 --       itemCount = 1
 --       itemCategory = 9
 --    else

        itemName = info:getName()
        itemType = info:getItemType()
        itemId = info:getItemId()
        itemCount = info:getCount()
        itemCategory = info:getCategory()
	-- end
	local shopIcon = lt.GameIcon.new()
	shopIcon:setAnchorPoint(0 ,0)
	shopIcon:setPosition(12, 12)
	self._infoNode:addChild(shopIcon)
    shopIcon:setTag(100)
	shopIcon:updateInfo(lt.GameIcon.TYPE.ITEM,itemId)

	local nameLabel = lt.GameLabel.new(itemName.."x"..itemCount,lt.Constants.FONT_SIZE4,lt.Constants.COLOR.WHITE,{outline = true, outlineColor = lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
    nameLabel:setAnchorPoint(0, 0.5)
    nameLabel:setPosition(110, 78)
    self._infoNode:addChild(nameLabel)
    local color = lt.Constants.COLOR.GREEN
    if info._costNum <= 0 then
        color = lt.Constants.COLOR.PROPERTY_RED
    end

    local numLabelDesc = lt.GameLabel.new(lt.StringManager:getString("STRING_EGG_SURPLUS_COUNT"), lt.Constants.FONT_SIZE4, lt.Constants.DEFAULT_LABEL_COLOR_2)
    numLabelDesc:setAnchorPoint(0, 0.5)
    numLabelDesc:setPosition(110, 25)

    local costNumLabel = lt.GameLabel.new(info._costNum, lt.Constants.FONT_SIZE4, color)
    costNumLabel:setAnchorPoint(0, 0.5)
    costNumLabel:setPosition(200, 25)

    self._infoNode:addChild(numLabelDesc)
    self._infoNode:addChild(costNumLabel)
end

function EggRewardCell:setSelected(selected)
    if selected then
        if not self._selectFlag then
            self._selectFlag = lt.GameInfoBg.new(lt.GameInfoBg.TYPE.GAME_INFO_BG_TYPE_7,cc.size(EggRewardCellSize.width + 2, EggRewardCellSize.height + 2))
            self._selectFlag:setPosition(EggRewardCellSize.width/2, 52)
            self._infoNode:addChild(self._selectFlag,-1)
        else
            self._selectFlag:setVisible(true)
        end
    else
        if self._selectFlag then 
            self._selectFlag:setVisible(false)
        end
    end
end

return EggRewardCell