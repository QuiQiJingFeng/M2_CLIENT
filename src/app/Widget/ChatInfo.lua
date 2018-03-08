-- 聊天
local ChatInfo = class("ChatInfo", function()
	return display.newNode()
end)

function ChatInfo:ctor()

end

function ChatInfo:updateInfo(chatInfo,team)

    local name = chatInfo:getSenderName()
    local senderId = chatInfo:getSenderId()
    local subType = chatInfo:getSubType()
    local subParam = chatInfo:getSubParam()
    local sunContent = chatInfo:getSubContent()
    local channel = chatInfo:getChannel()
    local occupationId = chatInfo:getOccupationId()
    local message = chatInfo:getMessage()


    local textLabel = lt.RichText.new()
    textLabel:setSize(cc.size(480, 10))
    textLabel:setAnchorPoint(cc.p(0, 1))
    textLabel:setLineHeigt(30)
    textLabel:setPositionY(38)
    if team then
    	textLabel:setLineHeigt(30)
    	textLabel:setPositionY(38)
    end
    self:addChild(textLabel)
    
	if channel == lt.Constants.CHAT_TYPE.SYSTEM then
        sunContent = json.decode(sunContent)
        local systemStr = lt.RichTextText.new("【"..lt.StringManager:getString("STRING_MESSAGE_SYSTEM").."】",lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_RED)

        if subType == lt.Constants.CHAT_SUB_TYPE.NORMAL then
            -- 普通文本
            textLabel:insertElement(systemStr)

            local messageText = lt.RichTextText.new(message,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(messageText)
        elseif subType == lt.Constants.CHAT_SUB_TYPE.EQUIP_STRENGTH_SUCCESS then
            --装备强化成功

            local level = sunContent["level"]

            local name = sunContent["player_name"]
            local equipModelId = sunContent["equipment"]

            local equipmentInfo = lt.CacheManager:getEquipmentInfo(equipModelId)
            local equipmentName = equipmentInfo:getName()
            local quality = equipmentInfo:getQuality()
            
            textLabel:insertElement(systemStr)

            local nameStr = lt.RichTextText.new(name,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.BLUE)
            textLabel:insertElement(nameStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_4"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text1)

            local levelStr = lt.RichTextText.new("+"..level,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.GREEN)
            textLabel:insertElement(levelStr)

            local equipNameStr = lt.RichTextText.new(" "..equipmentName,lt.Constants.FONT_SIZE5,lt.ResourceManager:getEquipQualityColor(quality))
            textLabel:insertElement(equipNameStr)

            local text3 = lt.RichTextText.new(" "..lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_6"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text3)

            local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_3"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text3)
        elseif subType == lt.Constants.CHAT_SUB_TYPE.EQUIP_STRENGTH_FAIL then
            --装备强化失败
            
            local level = sunContent["level"]

            local name = sunContent["player_name"]
            local equipModelId = sunContent["equipment"]

            local equipmentInfo = lt.CacheManager:getEquipmentInfo(equipModelId)
            local equipmentName = equipmentInfo:getName()
            local quality = equipmentInfo:getQuality()
            
            textLabel:insertElement(systemStr)

            local nameStr = lt.RichTextText.new(name,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.BLUE)
            textLabel:insertElement(nameStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_4"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text1)

            local levelStr = lt.RichTextText.new("+"..level,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.GREEN)
            textLabel:insertElement(levelStr)

            local equipNameStr = lt.RichTextText.new(" "..equipmentName,lt.Constants.FONT_SIZE5,lt.ResourceManager:getEquipQualityColor(quality))
            textLabel:insertElement(equipNameStr)

            local text2 = lt.RichTextText.new(" "..lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_5"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text2)

            local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_3"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text3)


        elseif subType == lt.Constants.CHAT_SUB_TYPE.BOSS_GET then--打怪获取

            local playerName = sunContent["player_name"]
            local difficulty = sunContent["difficulty"]
            local dungeonId = sunContent["dungeon_id"]
            local itemType = sunContent["item_type"]
            local itemId = sunContent["item_id"]
            local dungeonMonsterId = sunContent["dungeon_monster_id"]
            local dungeonMonsterInfo = nil


            local bossName = ""
            if not dungeonMonsterInfo then
                return
            end

            bossName = dungeonMonsterInfo:getName()

            local quality = 0
            local itemInfo = {}
            if itemType == lt.GameIcon.TYPE.EQUIPMENT then
                itemInfo = lt.CacheManager:getEquipmentInfo(itemId)
                quality = itemInfo:getQuality()
            else
                itemInfo = lt.CacheManager:getItemInfo(itemId)
                quality = itemInfo:getGrade()
            end

            local itemName = itemInfo:getName()

            local dungeonInfo = lt.CacheManager:getDungeonInfo(dungeonId)
            
            local params = dungeonInfo:getParams()

            local classId = dungeonInfo:getClass()
            local dungeonClassInfo = lt.CacheManager:getDungeonClassInfo(classId)

            local dungeonName = dungeonClassInfo:getName()

            if params and params["group"] == 2 then
                dungeonName = dungeonClassInfo:getTransferDungeonName2()
            end

            textLabel:insertElement(systemStr)

            local nameStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.BLUE)
            textLabel:insertElement(nameStr)

            local text0 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_13"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text0)

            local text1 = lt.RichTextText.new(" "..lt.StringManager:getDifficultyString(difficulty),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text1)

            local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_14"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text2)
            
            local dungeonTitle = lt.RichTextText.new(dungeonName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(dungeonTitle)

            local text3 = lt.RichTextText.new(" "..lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_15"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text3)
            
            local bossNameLabel = lt.RichTextText.new(bossName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.SPACE_ORANGE)
            textLabel:insertElement(bossNameLabel)
            
            local text4 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_20"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text4)

            local text5 = lt.RichTextText.new(itemName,lt.Constants.FONT_SIZE5,lt.ResourceManager:getEquipQualityColor(quality))
            textLabel:insertElement(text5)

            
            local text6 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_24"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text6)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.ITEM_OPEN then--道具开启
            
            local useItemId = subParam
            local playerName = sunContent["player_name"]
            local itemType = sunContent["item_type"]
            local itemId = sunContent["item_id"]

            local useItemInfo = lt.CacheManager:getItemInfo(useItemId)

            local useItemName = useItemInfo:getName()
            local useQuality = useItemInfo:getGrade()

            textLabel:insertElement(systemStr)

            local nameStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.BLUE)
            textLabel:insertElement(nameStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_7"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text1)

            local text2 = lt.RichTextText.new(" "..useItemName,lt.Constants.FONT_SIZE5,lt.ResourceManager:getEquipQualityColor(useQuality))
            textLabel:insertElement(text2)

            local text3 = lt.RichTextText.new(" "..lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_8"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text3)
            
            local itemInfo = lt.CacheManager:getItemInfo(itemId)
            local itemName = itemInfo:getName()
            local quality = itemInfo:getGrade()
            local text4 = lt.RichTextText.new(itemName,lt.Constants.FONT_SIZE5,lt.ResourceManager:getEquipQualityColor(quality))
            textLabel:insertElement(text4)

            local text5 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_3"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text5)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.EQUIP_MAKE then
            local playerName = sunContent["player_name"]
            local itemId = sunContent["item_id"]

            local equipmentInfo = lt.CacheManager:getEquipmentInfo(itemId)
            local equipmentName = equipmentInfo:getName()
            local quality = equipmentInfo:getQuality()
            
            textLabel:insertElement(systemStr)

            local nameStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.BLUE)
            textLabel:insertElement(nameStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_21"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text1)
            
            local equipmentNameLabel = lt.RichTextText.new(equipmentName,lt.Constants.FONT_SIZE5,lt.ResourceManager:getEquipQualityColor(quality))
            textLabel:insertElement(equipmentNameLabel)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.FRIEND_GIFT then--赠送空间礼物

            local givePlayerName = sunContent["give_player_name"]
            local itemId = sunContent["item_id"]
            local itemSize = sunContent["item_size"]
            local toPlayerName = sunContent["to_player_name"]
            local itemInfo = lt.CacheManager:getItemInfo(itemId)
            local itemName = itemInfo:getName()
            local quality = itemInfo:getGrade()

            textLabel:insertElement(systemStr)

            local nameStr = lt.RichTextText.new(givePlayerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.BLUE)
            textLabel:insertElement(nameStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_11"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text1)

            local toPlayerLabel = lt.RichTextText.new(toPlayerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.BLUE)
            textLabel:insertElement(toPlayerLabel)

            
            local text11 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_26"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text11)

            local text2 = lt.RichTextText.new(itemName.."*",lt.Constants.FONT_SIZE5,lt.ResourceManager:getEquipQualityColor(quality))
            textLabel:insertElement(text2)

            local text3 = lt.RichTextText.new(itemSize,lt.Constants.FONT_SIZE5,lt.ResourceManager:getEquipQualityColor(quality))
            textLabel:insertElement(text3)

            local text4 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_12"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text4)
            

        elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_1 then----策划的藏宝库活动换取“策划的藏宝箱”道具。

            local playerName = sunContent["player_name"]
            local activityName = sunContent["activity_name"]
            local itmeId = sunContent["item_id"]
            local itemInfo = lt.CacheManager:getItemInfo(itmeId)
            local itemName = itemInfo:getName()
            local quality = itemInfo:getGrade()
            
            textLabel:insertElement(systemStr)

            local nameStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.BLUE)
            textLabel:insertElement(nameStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_13"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text1)

            local activityStr = string.format(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_16"),activityName)
            local text2 = lt.RichTextText.new(activityStr,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text2)

            local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_17"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text3)

            local itemNameLabel = lt.RichTextText.new(itemName,lt.Constants.FONT_SIZE5,lt.ResourceManager:getEquipQualityColor(quality))
            textLabel:insertElement(itemNameLabel)

            local text4 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_18"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text4)
        elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_2 then--海底寻宝活动中获得低级特性书
            local playerName = sunContent["player_name"]
            local itemId = sunContent["item_id"]
            local activityName = sunContent["activity_name"]
            local itemInfo = lt.CacheManager:getItemInfo(itemId)
            local itemName = itemInfo:getName()
            local quality = itemInfo:getGrade()

            textLabel:insertElement(systemStr)

            local nameStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.BLUE)
            textLabel:insertElement(nameStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_13"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text1)

            local activityStr = string.format(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_16"),activityName)
            local text2 = lt.RichTextText.new(activityStr,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text2)

            local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_23"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text2)

            local itemNameLabel = lt.RichTextText.new(itemName,lt.Constants.FONT_SIZE5,lt.ResourceManager:getEquipQualityColor(quality))
            textLabel:insertElement(itemNameLabel)

            local text5 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_3"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text5)
            

        elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_4 then--追击盗墓者活动

            local playerName = sunContent["player_name"]
            local itemId = sunContent["item_id"]
            local activityName = sunContent["activity_name"]
            local boxType = sunContent["box_type"]
            local itemId = sunContent["item_id"]
            local itemInfo = lt.CacheManager:getItemInfo(itemId)
            local itemName = itemInfo:getName()
            local quality = itemInfo:getGrade()
 
            textLabel:insertElement(systemStr)

            local nameStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.BLUE)
            textLabel:insertElement(nameStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_13"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text1)

            local activityStr = string.format(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_16"),activityName)
            local text2 = lt.RichTextText.new(activityStr,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text2)

            local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_19"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text3)
            
            local boxName = lt.RichTextText.new(lt.StringManager:getBoxNameString(boxType),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.SPACE_ORANGE)
            textLabel:insertElement(boxName)

            local text4 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_20"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text4)
            
            local itemNameLabel = lt.RichTextText.new(itemName,lt.Constants.FONT_SIZE5,lt.ResourceManager:getEquipQualityColor(quality))
            textLabel:insertElement(itemNameLabel)

            local text5 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_3"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text5)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.TRADE then --摆摊出售特性9以及以上的英灵
            local playerName = sunContent["player_name"]
            local itemType = sunContent["item_type"]
            local itemId = sunContent["item_id"]
            local characterCount = sunContent["character_count"]

            textLabel:insertElement(systemStr)

            local nameStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.BLUE)
            textLabel:insertElement(nameStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_9"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text1)

            local numStr = lt.RichTextText.new(characterCount,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.RED)
            textLabel:insertElement(numStr)

            local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_10"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text2)

            local servantInfo = lt.CacheManager:getServantInfo(itemId)
            local servantName = servantInfo:getName()
            local quality = servantInfo:getQuality()

            local text3 = lt.RichTextText.new(servantName,lt.Constants.FONT_SIZE5,lt.ResourceManager:getEquipQualityColor(quality))
            textLabel:insertElement(text3)

            local text4 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_25"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(text4)

        else
            -- local messageText = lt.RichTextText.new(message,lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
            -- textLabel:insertElement(messageText)
            lt.CommonUtil.print("SYSTEM MESSAGE ")
        end
    elseif channel == lt.Constants.CHAT_TYPE.WORLD then

        local systemStr = lt.RichTextText.new("【"..lt.StringManager:getString("STRING_MESSAGE_WORLD").."】",16,lt.Constants.COLOR.CITY_CHAT_RED)
        textLabel:insertElement(systemStr)

        local nameStr = lt.RichTextText.new(name..":",16,lt.Constants.COLOR.CITY_CHAT_BLUE)
        textLabel:insertElement(nameStr)


        if subType == 100 then
            local contentInfo = lt.RichTextText.new("  ["..sunContent.."]",16,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = subParam..","..name})
            textLabel:insertElement(contentInfo)
        elseif subType == 520 then


            local joinStr = lt.StringManager:getString("STRING_COMMON_JOIN_ROOM")


            local roomMessage = json.decode(sunContent)


            local realMessage = roomMessage["message"]
            local roomId = roomMessage["room_id"]

            local contentInfo = lt.RichTextText.new("  "..realMessage,16,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(contentInfo)

            local joinInfo = lt.RichTextText.new(joinStr,16,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = roomId})
            textLabel:insertElement(joinInfo)
        elseif subType == 999 then
            -- 超链接文本

            local message = chatInfo:getMessage()

            local subContentJson = chatInfo:getSubContent()
            local subContent = json.decode(subContentJson)


            local checkMessage = string.gsub(message, "+", "_")


            local subArray = {}
            for keyStr,linkInfo in pairs(subContent) do
                keyStr = string.gsub(keyStr, "+", "_")
                local st, ed = string.find(checkMessage, keyStr)

                if st then
                    subArray[#subArray + 1] = {st = st, ed = ed, linkInfo = linkInfo}
                end
            end

            local tempMessage = message
            local messageArray = {}
            local messageLen = string.len(message)

            table.sort(subArray, function(info1, info2)
                return info1.st < info2.st
            end)
            
            local pos = 1
            for _,subInfo in ipairs(subArray) do

                local st        = subInfo.st
                local ed        = subInfo.ed
                local linkInfo  = subInfo.linkInfo

                if st > pos then

                    local subMessage = string.sub(tempMessage, pos, st - 1)
                    messageArray[#messageArray + 1] = {ty = 0, text = subMessage}
                    pos = st
                end


                local linkMessage = string.sub(tempMessage, pos, ed)
                messageArray[#messageArray + 1] = {ty = 1, text = linkMessage, linkInfo = linkInfo}
                pos = ed + 1
            end

            if pos <= messageLen then
                -- 剩余普通文本
                local subMessage = string.sub(tempMessage, pos, messageLen)
                messageArray[#messageArray + 1] = {ty = 0, text = subMessage}
            end



            --local msg = ""
            for _,messageInfo in ipairs(messageArray) do
                local ty = messageInfo.ty
                if ty == 0 then

                    local contentInfo = lt.RichTextText.new(messageInfo.text,16,lt.Constants.COLOR.WHITE)
                    textLabel:insertElement(contentInfo)
                    --msg = msg .. string.format("(普通文字)%s", messageInfo.text)
                elseif ty == 1 then

                    local realInfo = json.encode(messageInfo.linkInfo)
                    local contentInfo = lt.RichTextText.new(messageInfo.text,16,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = realInfo})
                    textLabel:insertElement(contentInfo)
                    --msg = msg .. string.format("(超文本)%s", messageInfo.text)
                end
            end
        else
            local messageText = lt.RichTextText.new("  "..message,16,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(messageText)
        end
    elseif channel == lt.Constants.CHAT_TYPE.GUILD then

          --发言内容
        local systemStr = lt.RichTextText.new("【"..lt.StringManager:getString("STRING_MESSAGE_GUILD").."】",16,lt.Constants.COLOR.CITY_CHAT_RED)
        textLabel:insertElement(systemStr)

        local nameStr = lt.RichTextText.new(name..": ",16,lt.Constants.COLOR.CITY_CHAT_BLUE)
        textLabel:insertElement(nameStr)
 

        if subType == 100 then

            local textInfo = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_HELP"),16,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(textInfo)

            local contentInfo = lt.RichTextText.new("["..sunContent.."]",16,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = subParam..","..name..","..senderId})
            textLabel:insertElement(contentInfo)
        elseif subType == 520 then
            textLabel:onClicked(handler(self, self.roomRichTest))

            local joinStr = lt.StringManager:getString("STRING_COMMON_JOIN_ROOM")


            local roomMessage = json.decode(sunContent)


            local realMessage = roomMessage["message"]
            local roomId = roomMessage["room_id"]


            local roomInfo = {}
            roomInfo.roomId = roomId
            roomInfo.sequence = subParam

            local realInfo = json.encode(roomInfo)

            local contentInfo = lt.RichTextText.new(realMessage,16,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(contentInfo)

            local joinInfo = lt.RichTextText.new(joinStr,16,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = realInfo})
            textLabel:insertElement(joinInfo)
        elseif subType == 999 then
            textLabel:onClicked(handler(self, self.tipsCallBack))
            -- 超链接文本
            local message = chatInfo:getMessage()

            local subContentJson = chatInfo:getSubContent()
            local subContent = json.decode(subContentJson)


            local checkMessage = string.gsub(message, "+", "_")


            local subArray = {}
            for keyStr,linkInfo in pairs(subContent) do
                keyStr = string.gsub(keyStr, "+", "_")
                local st, ed = string.find(checkMessage, keyStr)

                if st then
                    subArray[#subArray + 1] = {st = st, ed = ed, linkInfo = linkInfo}
                end
            end

            local tempMessage = message
            local messageArray = {}
            local messageLen = string.len(message)

            table.sort(subArray, function(info1, info2)
                return info1.st < info2.st
            end)
            

            local pos = 1
            for _,subInfo in ipairs(subArray) do

                local st        = subInfo.st
                local ed        = subInfo.ed
                local linkInfo  = subInfo.linkInfo

                if st > pos then

                    local subMessage = string.sub(tempMessage, pos, st - 1)
                    messageArray[#messageArray + 1] = {ty = 0, text = subMessage}
                    pos = st
                end


                local linkMessage = string.sub(tempMessage, pos, ed)
                messageArray[#messageArray + 1] = {ty = 1, text = linkMessage, linkInfo = linkInfo}
                pos = ed + 1
            end

            if pos <= messageLen then
                -- 剩余普通文本
                local subMessage = string.sub(tempMessage, pos, messageLen)
                messageArray[#messageArray + 1] = {ty = 0, text = subMessage}
            end



            --local msg = ""
            for _,messageInfo in ipairs(messageArray) do
                local ty = messageInfo.ty
                if ty == 0 then

                    local contentInfo = lt.RichTextText.new(messageInfo.text,16,lt.Constants.COLOR.WHITE)
                    textLabel:insertElement(contentInfo)
                    --msg = msg .. string.format("(普通文字)%s", messageInfo.text)
                elseif ty == 1 then

                    local realInfo = json.encode(messageInfo.linkInfo)
                    local contentInfo = lt.RichTextText.new(messageInfo.text,16,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = realInfo})
                    textLabel:insertElement(contentInfo)
                    --msg = msg .. string.format("(超文本)%s", messageInfo.text)
                end
            end
        else
            local messageText = lt.RichTextText.new(message,16,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(messageText)
        end
    elseif channel == lt.Constants.CHAT_TYPE.TEAM then
    	 local systemStr = lt.RichTextText.new("【"..lt.StringManager:getString("STRING_MESSAGE_TEAM").."】",16,lt.Constants.COLOR.CITY_CHAT_RED)
        textLabel:insertElement(systemStr)

        local nameStr = lt.RichTextText.new(name,16,lt.Constants.COLOR.CITY_CHAT_BLUE)
        textLabel:insertElement(nameStr)

        local colonStr = lt.RichTextText.new(name,16,lt.Constants.COLOR.CITY_CHAT_BLUE)

        if subType == 100 then
            local contentInfo = lt.RichTextText.new("  ["..sunContent.."]",16,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = subParam..","..name})
            textLabel:insertElement(contentInfo)
        elseif subType == 520 then


            local joinStr = lt.StringManager:getString("STRING_COMMON_JOIN_ROOM")


            local roomMessage = json.decode(sunContent)


            local realMessage = roomMessage["message"]
            local roomId = roomMessage["room_id"]

            local contentInfo = lt.RichTextText.new("  "..realMessage,16,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(contentInfo)

            local joinInfo = lt.RichTextText.new(joinStr,16,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = roomId})
            textLabel:insertElement(joinInfo)
        elseif subType == 999 then
            -- 超链接文本

            local message = chatInfo:getMessage()

            local subContentJson = chatInfo:getSubContent()
            local subContent = json.decode(subContentJson)


            local checkMessage = string.gsub(message, "+", "_")


            local subArray = {}
            for keyStr,linkInfo in pairs(subContent) do
                keyStr = string.gsub(keyStr, "+", "_")
                local st, ed = string.find(checkMessage, keyStr)

                if st then
                    subArray[#subArray + 1] = {st = st, ed = ed, linkInfo = linkInfo}
                end
            end

            local tempMessage = message
            local messageArray = {}
            local messageLen = string.len(message)

            table.sort(subArray, function(info1, info2)
                return info1.st < info2.st
            end)
            
            local pos = 1
            for _,subInfo in ipairs(subArray) do

                local st        = subInfo.st
                local ed        = subInfo.ed
                local linkInfo  = subInfo.linkInfo

                if st > pos then

                    local subMessage = string.sub(tempMessage, pos, st - 1)
                    messageArray[#messageArray + 1] = {ty = 0, text = subMessage}
                    pos = st
                end


                local linkMessage = string.sub(tempMessage, pos, ed)
                messageArray[#messageArray + 1] = {ty = 1, text = linkMessage, linkInfo = linkInfo}
                pos = ed + 1
            end

            if pos <= messageLen then
                -- 剩余普通文本
                local subMessage = string.sub(tempMessage, pos, messageLen)
                messageArray[#messageArray + 1] = {ty = 0, text = subMessage}
            end



            --local msg = ""
            for _,messageInfo in ipairs(messageArray) do
                local ty = messageInfo.ty
                if ty == 0 then

                    local contentInfo = lt.RichTextText.new(messageInfo.text,16,lt.Constants.COLOR.WHITE)
                    textLabel:insertElement(contentInfo)
                    --msg = msg .. string.format("(普通文字)%s", messageInfo.text)
                elseif ty == 1 then

                    local realInfo = json.encode(messageInfo.linkInfo)
                    local contentInfo = lt.RichTextText.new(messageInfo.text,16,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = realInfo})
                    textLabel:insertElement(contentInfo)
                    --msg = msg .. string.format("(超文本)%s", messageInfo.text)
                end
            end
        else
            local messageText = lt.RichTextText.new("  "..message,16,lt.Constants.COLOR.WHITE)
            textLabel:insertElement(messageText)
        end
    end
end

return ChatInfo