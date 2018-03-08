local MessageCell = class("MessageCell", function()
	return display.newNode()
end)

function MessageCell:ctor()
	self._infoNode = display.newNode()
	self:addChild(self._infoNode)
end

function MessageCell:updateInfo(info,tipsCallBack)
    self._infoNode:removeAllChildren()

    self._tipsCallBack = tipsCallBack

	local chatInfo = info
	if not chatInfo then return end

    local hasAvatar = chatInfo:getHasAvatar()
    
	local player = lt.DataManager:getPlayer()
    local playerId = player:getId()
    local hero = player:getHero()

    local message = chatInfo:getMessage()
    
    local name = chatInfo:getSenderName()
    local senderId = chatInfo:getSenderId()
    local subType = chatInfo:getSubType()
    local subParam = chatInfo:getSubParam()
    local sunContent = chatInfo:getSubContent()
    local channel = chatInfo:getChannel()
    local occupationId = chatInfo:getOccupationId()
    local senderAvatarId = chatInfo:getSenderAvatarId()
    local bubbleId = chatInfo:getBubbleId()--

    local textLabel = lt.RichText.new()
    textLabel:setSize(cc.size(310, 10))
    textLabel:setAnchorPoint(cc.p(0,1))

    --系统
    if channel == lt.Constants.CHAT_TYPE.SYSTEM then
        local path = "image/channel/channel_icon_"..channel..".jpg"
        local titleBg = lt.RichTextImage.new(path)
        textLabel:insertElement(titleBg)

        sunContent = json.decode(sunContent)
        
        if subType == lt.Constants.CHAT_SUB_TYPE.NORMAL then
            -- 普通文本
            if type(message) == "string" then
                local messageText = lt.RichTextText.new(message,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(messageText)
            elseif type(message) == "table" then
                local messageArray = message
                for _,messageInfo in ipairs(messageArray) do
                    local message = messageInfo.message
                    local color = messageInfo.color or lt.Constants.COLOR.CITY_CHAT_ORANCE

                    local messageText = lt.RichTextText.new(message,lt.Constants.FONT_SIZE5,color)
                    textLabel:insertElement(messageText)
                end
            end
        elseif subType == lt.Constants.CHAT_SUB_TYPE.TRADE_NORMAl then--摆摊出售
            local itemType = sunContent["item_type"]
            local modelId = sunContent["model_id"]
            local size = sunContent["size"]

            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_29"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(systemStr)

            local sizeStr = lt.RichTextText.new(size,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_GREEN)
            textLabel:insertElement(sizeStr)

            local numStr = lt.RichTextText.new(lt.StringManager:getString("STRING_SHOP_TIPS_52"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(numStr)

            local name = ""
            local quality = 1
            if itemType == lt.GameIcon.TYPE.ITEM then
                local itemInfo = lt.CacheManager:getItemInfo(modelId)
                if itemInfo then
                    name = itemInfo:getName()
                    quality = itemInfo:getGrade()
                end
            else
                local equipmentInfo = lt.CacheManager:getEquipmentInfo(modelId)
                if equipmentInfo then
                    name = equipmentInfo:getName()
                    quality = equipmentInfo:getQuality()
                end
            end

            local nameStr = lt.RichTextText.new(name,lt.Constants.FONT_SIZE5,lt.UIMaker:getGradeColor(quality))
            textLabel:insertElement(nameStr)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.GET_ITEM then--自己获得
            local itemType = sunContent["item_type"]
            local modelId = sunContent["model_id"]
            local size = sunContent["size"]

            local name = ""
            local quality = 1
            local valueType = 0
            if itemType == lt.GameIcon.TYPE.ITEM then
                local itemInfo = lt.CacheManager:getItemInfo(modelId)
                if itemInfo then
                    name = itemInfo:getName()
                    quality = itemInfo:getGrade()
                    valueType = itemInfo:getType()
                end
            elseif itemType == lt.GameIcon.TYPE.EQUIPMENT then--2
                local equipmentInfo = lt.CacheManager:getEquipmentInfo(modelId)
                if equipmentInfo then
                    name = equipmentInfo:getName()
                    quality = equipmentInfo:getQuality()
                end
            elseif itemType == lt.GameIcon.TYPE.Rune or itemType == 4 then --4
                local runeInfo = lt.CacheManager:getRuneInfo(modelId)
                if runeInfo then
                    name = runeInfo:getName()
                    quality = runeInfo:getLevel()
                end
            end
            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_2"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(systemStr)

            local sizeStr = lt.RichTextText.new(size,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_GREEN)
            textLabel:insertElement(sizeStr)

            --if valueType ~= 6 then
                local numStr = lt.RichTextText.new(lt.StringManager:getString("STRING_SHOP_TIPS_52"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(numStr)
            --end

            local nameStr = lt.RichTextText.new(name,lt.Constants.FONT_SIZE5,lt.UIMaker:getGradeColor(quality))
            textLabel:insertElement(nameStr)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.GET_EXP then--获得经验
            local allExp = sunContent["all_exp_increase"]
            local doubleExp = sunContent["double_increase"]
            local riseExp = sunContent["rise_increase"]
            if allExp ~= -1 then--没有达到每日经验上限     
                local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_2"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(text1)

                local sizeStr = lt.RichTextText.new(allExp,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_GREEN)
                textLabel:insertElement(sizeStr)

                local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_5"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(text2)


                if doubleExp >= 0 or riseExp > 0 then
                    local doubleExpText1 = lt.RichTextText.new("(",lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(doubleExpText1)
                end

                --双倍
                if doubleExp >= 0 then
                    local doubleExpText2 = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_8"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(doubleExpText2)

                    local doubleExpText3 = lt.RichTextText.new(doubleExp,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_GREEN)
                    textLabel:insertElement(doubleExpText3)
                end

                if doubleExp >= 0 and riseExp > 0 then
                    local te = lt.RichTextText.new("，",lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(te)
                end

                if riseExp > 0 then
                    local text4 = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_6"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(text4)

                    local text5 = lt.RichTextText.new(riseExp,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_GREEN)
                    textLabel:insertElement(text5)
                end

                if doubleExp >= 0 or riseExp > 0 then
                    local text6 = lt.RichTextText.new(")",lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(text6)
                end
            else
                local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_EXP_LIMITE"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(text1)
            end
        elseif subType == lt.Constants.CHAT_SUB_TYPE.RUNE_BOX then--道具开启 宝箱符文
            local playerName = sunContent["player_name"]
            local runeId = sunContent["id"]
            local runeName = ""
            local level = 4
            local runeInfo = lt.CacheManager:getRuneInfo(runeId)
            if runeInfo then
                local nameArr = string.split(runeInfo:getName(),":")
                if #nameArr == 2 then
                    runeName = nameArr[2]
                end
                level = runeInfo:getLevel()
            end

            local nameStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(nameStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_30"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local txtStr = level..lt.StringManager:getString("STRING_LEVEL")..runeName
            local text2 = lt.RichTextText.new(txtStr,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.QUALITY_PURPLE)
            textLabel:insertElement(text2)

            local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_RUNE_STRING_TITLE"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text3)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.EGG then--扭蛋机
            local itemType = sunContent["item_type"]
            local modelId = sunContent["item_id"]
            local size = sunContent["item_size"]
            local playerName = sunContent["player_name"]

            local name = ""
            local quality = 1
            local valueType = 0

            local itemInfo = lt.CacheManager:getItemInfo(modelId)
            if itemInfo then
                name = itemInfo:getName()
                quality = itemInfo:getGrade()
                valueType = itemInfo:getType()
            end

            textLabel:onClicked(handler(self, self.tipsCallBack))
            --textLabel:onClicked(handler(self, self.roomRichTest))
            local linkInfo = {}
            linkInfo.itemType = itemType
            linkInfo.id = modelId
            linkInfo.modelId = modelId
            --linkInfo.playerId = playerName

            local realInfo = json.encode(linkInfo)

            local playerStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(playerStr)

            if modelId ~= lt.Constants.ITEM.DIAMOND then
                local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_EGG_1"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(text1)
                local sizeStr = lt.RichTextText.new(size,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_GREEN)
                textLabel:insertElement(sizeStr)
                if valueType ~= 6 then
                    local numStr = lt.RichTextText.new(lt.StringManager:getString("STRING_SHOP_TIPS_52"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(numStr)
                end
                local nameStr = lt.RichTextText.new("["..name.."]",lt.Constants.FONT_SIZE5,lt.UIMaker:getGradeColor(quality), {link = true,linkColor = lt.UIMaker:getGradeColor(quality), linkInfo = realInfo})
                textLabel:insertElement(nameStr)
            else

                local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_EGG_2"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(text1)

                local str = string.format(lt.StringManager:getString("STRING_GAIN_TIPS_EGG_3"), size)
                local sizeStr = lt.RichTextText.new(str,lt.Constants.FONT_SIZE5,lt.UIMaker:getGradeColor(quality))
                textLabel:insertElement(sizeStr)

                local nameStr = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_EGG_4"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(nameStr)
            end
        elseif subType == lt.Constants.CHAT_SUB_TYPE.CREATE_OREANGE_ITEM then--打造出橙装

            local modelId = sunContent["model_id"]
            local id = sunContent["item_id"]
            local level = sunContent["level"]
            local playerName = sunContent["player_name"]
            local playerId = sunContent["player_id"]
            local fromSystem = sunContent["from_system"]

            local name = ""
            local quality = 1
            local equipmentInfo = lt.CacheManager:getEquipmentInfo(modelId)
            if equipmentInfo then
                name = equipmentInfo:getName()
                quality = equipmentInfo:getQuality()
            end

            local linkInfo = {}
            linkInfo.itemType = lt.GameIcon.TYPE.EQUIPMENT
            linkInfo.id = id
            linkInfo.modelId = modelId
            linkInfo.playerId = playerId
            local realInfo = json.encode(linkInfo)

            textLabel:onClicked(handler(self, self.tipsCallBack))

            local playerStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(playerStr)

            local str1 = ""
            local str2 = ""
            if fromSystem == 1 then--打造
                str1 = "STRING_CREATE_OREANGE_ITEM_1"
                str2 = "STRING_CREATE_OREANGE_ITEM_2"
            else
                str1 = "STRING_DROP_OREANGE_ITEM_1"
                str2 = "STRING_DROP_OREANGE_ITEM_2"
            end

            local text1 = lt.RichTextText.new(lt.StringManager:getString(str1),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local levleStr = lt.RichTextText.new(level,lt.Constants.FONT_SIZE5, lt.Constants.COLOR.CITY_CHAT_GREEN)
            textLabel:insertElement(levleStr)

            local text2 = lt.RichTextText.new(lt.StringManager:getString(str2),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text2)

            local nameStr = lt.RichTextText.new("["..name.."]",lt.Constants.FONT_SIZE5, lt.UIMaker:getGradeColor(quality), {link = true,linkColor = lt.UIMaker:getGradeColor(quality), linkInfo = realInfo})
            textLabel:insertElement(nameStr)

            local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_CREATE_OREANGE_ITEM_3"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text3)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.GOT_DRESS_TICKET then--公会秘境 第八层获得时装兑换券
            local playerName = sunContent["player_name"]
            local playerId = sunContent["player_id"]
            local modelId = sunContent["model_id"]

            local itemName = ""
            local quality = 1
            local item = lt.CacheManager:getItemInfo(modelId)

            if item then
                itemName = item:getName()
                quality = item:getGrade()
            end

            local linkInfo = {}
            linkInfo.itemType = lt.GameIcon.TYPE.ITEM
            linkInfo.id = modelId
            linkInfo.modelId = modelId
            linkInfo.playerId = playerId
            local realInfo = json.encode(linkInfo)

            textLabel:onClicked(handler(self, self.tipsCallBack))
            local playerStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(playerStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_GOT_DRESS_TICKET_1"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local itemStr = lt.RichTextText.new(itemName,lt.Constants.FONT_SIZE5,lt.UIMaker:getGradeColor(quality), {link = true,linkColor = lt.UIMaker:getGradeColor(quality), linkInfo = realInfo})
            textLabel:insertElement(itemStr)

            local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_GOT_DRESS_TICKET_2"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text3)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_WORLD_BOSS_KILLED then--击杀野外boss
            local bossName = sunContent["boss_name"]
            local playerName = sunContent["player_name"]
            local playerId = sunContent["player_id"]

            textLabel:onClicked(handler(self, self.tipsCallBack))

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_KILL_BOSS_1"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local playerStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(playerStr)

            local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_KILL_BOSS_2"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text2)

            local bossStr = lt.RichTextText.new(bossName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(bossStr)

            local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_KILL_BOSS_3"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text3)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_WORLD_BOSS_FLUSH then--野外boss刷新
            local bossName = sunContent["boss_name"]
            local bossLevel = sunContent["boss_level"]
            local mapName = sunContent["map_name"]

            textLabel:onClicked(handler(self, self.tipsCallBack))

            local levleStr = lt.RichTextText.new(bossLevel,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(levleStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_FLUSH_BOSS_1"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local bossStr = lt.RichTextText.new(bossName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(bossStr)

            local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_FLUSH_BOSS_2"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text2)

            local mapStr = lt.RichTextText.new(mapName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(mapStr)

            local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_FLUSH_BOSS_3"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text3)
        elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_WORLD_BOSS_HP_CHANGE then--野外boss血量
            local bossName = sunContent["boss_name"]
            local hpType = sunContent["hp_type"]
            local mapName = sunContent["map_name"] 

            local mapName = lt.RichTextText.new(mapName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(mapName)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_BOSS_HP_1"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local bossStr = lt.RichTextText.new(bossName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(bossStr)
            if hpType then
                if hpType == 1 then
                    local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_BOSS_HP_2"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(text2)
                elseif hpType == 2 then
                    local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_BOSS_HP_3"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(text3)
                end
            end
        elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_ULIMATE_CHALLENGE_LAST_ATTACK then--极限挑战最后一击
            local playerId = sunContent["player_id"]
            local playerName = sunContent["player_name"]

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_ULIMATE_CHALLENGE_LAST_ATTACK_1"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local player = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(player)

            local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_ULIMATE_CHALLENGE_LAST_ATTACK_2"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text2)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.CREATE_RISK_TEAM then
            local playerId = sunContent["player_id"]
            local playerName = sunContent["player_name"]
            local name    =   sunContent["name"]
            local prefix    =   sunContent["prefix"]
            local memberCount    =   sunContent["member_count"]

            local num = lt.StringManager:getString(lt.StringManager:getCHSNumberString(memberCount))

            local teamName = prefix..num..name

            local player = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(player)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_BATTLE_TEAM_1"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local team = lt.RichTextText.new(teamName,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(team)

            local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_BATTLE_TEAM_2"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text2)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.TREASURE_MAP then--藏宝图
            --local playerId = sunContent["player_id"]
            local playerName = sunContent["player_name"]
            local itemID    =   sunContent["item_id"]
            local itemSize    =   sunContent["item_size"]
            local itemType    =   sunContent["item_type"]

            textLabel:onClicked(handler(self, self.tipsCallBack))--装备或者道具
            local player = lt.RichTextText.new(playerName, lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(player)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_TREASURE_MAP_1"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local quality = 1
            local name = ""
            local valueType = 1
            local itemInfo = lt.CacheManager:getItemInfo(itemID)
            if itemInfo then
                name = itemInfo:getName()
                quality = itemInfo:getGrade()
                valueType = itemInfo:getType()
            end
            
            local linkInfo = {}
            linkInfo.itemType = itemType
            linkInfo.id = itemID
            linkInfo.modelId = itemID
            local realInfo = json.encode(linkInfo)

            local team = lt.RichTextText.new("["..name.."]",lt.Constants.FONT_SIZE5,lt.UIMaker:getGradeColor(quality), {link = true,linkColor = lt.UIMaker:getGradeColor(quality), linkInfo = realInfo})
            textLabel:insertElement(team)

            local text2 = lt.RichTextText.new("!",lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text2)
        elseif subType == lt.Constants.CHAT_SUB_TYPE.MAZE then
            --local playerId = sunContent["player_id"]
            local playerName = sunContent["player_name"]
            local mazeName = sunContent["maze_name"]

            local player = lt.RichTextText.new(playerName, lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(player)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_MAZE_1"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local name = lt.RichTextText.new(mazeName, lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_GREEN)
            textLabel:insertElement(name)

            local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_MAZE_2"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text2)
        else
            lt.CommonUtil.print("SYSTEM MESSAGE ", subType)
        end
    --世界
    elseif channel == lt.Constants.CHAT_TYPE.WORLD
        or channel == lt.Constants.CHAT_TYPE.GUILD
        or channel == lt.Constants.CHAT_TYPE.TEAM
        or channel == lt.Constants.CHAT_TYPE.CURRENT then
        local height = 0

        local hasVoice = false
        if chatInfo:getIsAudio() then
            hasVoice = true
        end

        local messageColor = lt.Constants.COLOR.CITY_CHAT_GRAY
        if channel == lt.Constants.CHAT_TYPE.WORLD then
            messageColor = lt.Constants.COLOR.CITY_CHAT_YELLOW
        elseif channel == lt.Constants.CHAT_TYPE.TEAM then
            messageColor = lt.Constants.COLOR.CITY_CHAT_BLUE
        elseif channel == lt.Constants.CHAT_TYPE.GUILD then
            messageColor = lt.Constants.COLOR.CITY_CHAT_GREEN
        end

        local path = "image/channel/channel_icon_"..channel..".jpg"
        if subType == lt.Constants.CHAT_SUB_TYPE.INVITE_ROOM then
            path = "image/channel/channel_icon_520.jpg"
             messageColor = lt.Constants.COLOR.CITY_CHAT_PURPLE
        end
        local titleBg = lt.RichTextImage.new(path)
        textLabel:insertElement(titleBg)

        textLabel:onClicked(handler(self, self.tipsCallBack))

        local linkInfo = json.encode({itemType=-1,playerId=senderId,id=-1,modelId=0})
        --local textNameInfo = lt.RichTextText.new("["..name.."] ",lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CHAT_PLAYER_NAME,{link = true,linkColor = lt.Constants.COLOR.CHAT_PLAYER_NAME,linkInfo = linkInfo})
        
        if subType == lt.Constants.CHAT_SUB_TYPE.QUESTION then
            if name and name ~= "" then
                local textNameInfo = lt.RichTextText.new("["..name.."] ",lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CHAT_PLAYER_NAME)
                textLabel:insertElement(textNameInfo)
            end

        	local textInfo = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_REQUEST"),lt.Constants.FONT_SIZE5,lt.Constants.COLOR.WHITE)
        	textLabel:insertElement(textInfo)

        	local contentInfo = lt.RichTextText.new("["..sunContent.."]",lt.Constants.FONT_SIZE5,lt.Constants.COLOR.SPACE_ORANGE)
        	textLabel:insertElement(contentInfo)
        elseif subType == lt.Constants.CHAT_SUB_TYPE.GUILD_CARNIVAL then
            local guildInfo = {}
            guildInfo.showTipsType = lt.MessageLayer.SHOWTIPSTYPE.GUILD_CARNIVAL
            local realInfo = json.encode(guildInfo)

            local messageArray = string.split(message, "+")

            if messageArray[1] then
                local contentInfo1 = lt.RichTextText.new(messageArray[1],lt.Constants.FONT_SIZE5,lt.Constants.COLOR.SPACE_ORANGE)
                textLabel:insertElement(contentInfo1)
            end
            if messageArray[2] then
                local contentInfo2 = lt.RichTextText.new(messageArray[2],lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_PURPLE)
                textLabel:insertElement(contentInfo2)
            end

            if messageArray[3] then
                local contentInfo3 = lt.RichTextText.new(messageArray[3],lt.Constants.FONT_SIZE5,lt.Constants.COLOR.SPACE_ORANGE)
                textLabel:insertElement(contentInfo3)
            end
        elseif subType == lt.Constants.CHAT_SUB_TYPE.INVITE_ROOM then
            if name and name ~= "" then
                local textNameInfo = lt.RichTextText.new("["..name.."] ",lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CHAT_PLAYER_NAME)
                textLabel:insertElement(textNameInfo)
            end

            title = lt.StringManager:getString("STRING_MESSAGE_INVITE")

            local joinStr = lt.StringManager:getString("STRING_COMMON_JOIN_ROOM")
            local roomMessage = json.decode(sunContent)
            local realMessage = roomMessage["message"]

            local messagefArray = string.split(realMessage, "+")

            if messagefArray[1] then
                local contentInfo = lt.RichTextText.new(messagefArray[1],lt.Constants.FONT_SIZE5,lt.Constants.COLOR.SPACE_ORANGE)
                textLabel:insertElement(contentInfo)
            end

            if messagefArray[2] then
                local contentInfo = lt.RichTextText.new(messagefArray[2],lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_PURPLE)
                textLabel:insertElement(contentInfo)
            end

            local joinInfo = lt.RichTextText.new(joinStr,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.SPACE_ORANGE)
            textLabel:insertElement(joinInfo)
        elseif subType == lt.Constants.CHAT_SUB_TYPE.LINK_LINE then
            -- 超链接文本
            if name and name ~= "" then
                local textNameInfo = lt.RichTextText.new("["..name.."] ",lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CHAT_PLAYER_NAME)
                textLabel:insertElement(textNameInfo)
            end

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
                    local contentInfo = lt.RichTextText.new(messageInfo.text,lt.Constants.FONT_SIZE5,messageColor)
                    textLabel:insertElement(contentInfo)
      
                elseif ty == 1 then
                    if messageInfo.linkInfo.itemType == lt.GameIcon.TYPE.EMOJI then
                        local emoji = lt.Emoji.new(messageInfo.linkInfo.id,true)
                        emoji:setContentSize(cc.size(44,44))
                        local richItem = cpp.RichItemCustom:create(0, lt.Constants.COLOR.WHITE, 255, emoji)
                        textLabel:addItem(richItem)
                    else
                        local _linkInfo = messageInfo.linkInfo
                        local realInfo = json.encode(messageInfo.linkInfo)
                        local realText = string.gsub(string.gsub(messageInfo.text, "【", "["), "】","]")
                        local quality = 1
                        if _linkInfo.itemType == lt.GameIcon.TYPE.ITEM then
                            local itemInfo = lt.CacheManager:getItemInfo(_linkInfo.modelId)
                            if itemInfo then
                                quality = itemInfo:getGrade()
                            end
                        elseif _linkInfo.itemType == lt.GameIcon.TYPE.EQUIPMENT then
                            local equipmentInfo = lt.CacheManager:getEquipmentInfo(_linkInfo.modelId)
                            if equipmentInfo then
                                quality = equipmentInfo:getQuality()
                            end
                        elseif _linkInfo.itemType == lt.GameIcon.TYPE.CHARACTER_SERVANT then
                            local servantInfo = lt.CacheManager:getServantInfo(_linkInfo.modelId)
                            if servantInfo then
                                quality = servantInfo:getQuality()
                            end
                        end
                        local contentInfo = lt.RichTextText.new(realText,lt.Constants.FONT_SIZE5,lt.UIMaker:getGradeColor(quality),{link = false,linkColor = lt.UIMaker:getGradeColor(quality),linkInfo = realInfo})
                        textLabel:insertElement(contentInfo)
                    end
                end
            end
        elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_GUILD_BOSS_FLUSH then
            local text = lt.RichTextText.new(lt.StringManager:getString("STRING_GUILD_BOSS_FLUSH"),lt.Constants.FONT_SIZE5, messageColor)
            textLabel:insertElement(text)
        elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_GUILD_BOSS_LAST_ATTACK then

            local messageStr = json.decode(sunContent)
            local player_str = messageStr["player_name"] or ""
            local boss_str = messageStr["boss_name"] or ""

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_GUILD_BOSS_LAST_ATTACK_1"),lt.Constants.FONT_SIZE5,messageColor)
            textLabel:insertElement(text1)

            local textNameInfo = lt.RichTextText.new("["..player_str.."] ",lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CHAT_PLAYER_NAME)
            textLabel:insertElement(textNameInfo)

            local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_GUILD_BOSS_LAST_ATTACK_2"),lt.Constants.FONT_SIZE5,messageColor)
            textLabel:insertElement(text2)

            local textNameBoss= lt.RichTextText.new(boss_str,lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(textNameBoss)

            local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_GUILD_BOSS_LAST_ATTACK_3"),lt.Constants.FONT_SIZE5,messageColor)
            textLabel:insertElement(text3)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_GUILD_BOSS_KILLED then
            local text = lt.RichTextText.new(lt.StringManager:getString("STRING_GUILD_BOSS_KILLED"),lt.Constants.FONT_SIZE5, messageColor)
            textLabel:insertElement(text)
        else
            if name and name ~= "" then
                local textNameInfo = lt.RichTextText.new("["..name.."] ",lt.Constants.FONT_SIZE5,lt.Constants.COLOR.CHAT_PLAYER_NAME)
                textLabel:insertElement(textNameInfo)
            end

            if hasVoice then
                local effectBgName = "battle_chat"
                local armatureBgFile = "effect/ui/"..effectBgName..".ExportJson"

                if not lt.ResourceManager:isArmatureLoaded(effectBgName) then
                    lt.ResourceManager:addArmature(effectBgName, armatureBgFile)
                end

                local node = display.newNode()
                local horn = ccs.Armature:create(effectBgName)--喇叭
                horn:getAnimation():playWithIndex(1)
                --horn:setRotation(-90)
                node:addChild(horn)
                node:setContentSize(30,30)
                horn:setPosition(15,8)
                local richItem = cpp.RichItemCustom:create(0, lt.Constants.COLOR.WHITE, 255, node)
                textLabel:addItem(richItem)
            end

            if type(message) == "string" then
                local messageText = lt.RichTextText.new(message,lt.Constants.FONT_SIZE5,messageColor)
                textLabel:insertElement(messageText)
            elseif type(message) == "table" then
                local messageArray = message
                for _,messageInfo in ipairs(messageArray) do
                    local message = messageInfo.message
                    local color = messageInfo.color or messageColor

                    local messageText = lt.RichTextText.new(message,lt.Constants.FONT_SIZE5,color)
                    textLabel:insertElement(messageText)
                end
            end
	    end
    end

    textLabel:formatText()
    local height = textLabel:getContentSize().height

    self._costomSize = cc.size(310,height)
    self._infoNode:addChild(textLabel)
    textLabel:setPosition(0,height)
    self:setContentSize(cc.size(self._costomSize.width + 2, self._costomSize.height + 2))
end

function MessageCell:getInfoNode()
    return self._infoNode
end

function MessageCell:getCustomSize()
	return self._costomSize
end

function MessageCell:tipsCallBack(sender)
    if self._tipsCallBack then
        self._tipsCallBack(sender)
    end
end

function MessageCell:onDeleteMessage(event)
	self._delMessageCallback(event)
end

return MessageCell
