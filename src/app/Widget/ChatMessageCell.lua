
-- 聊天
local ChatMessageCell = class("ChatMessageCell", function()
	return display.newNode()
end)



ChatMessageCell._infoNode = nil
ChatMessageCell._costomSize = cc.size(460, 10)
ChatMessageCell._padding = 7
ChatMessageCell._baseHeight = 30

ChatMessageCell._richTestCallBack = nil
ChatMessageCell._tipsCallBack = nil
ChatMessageCell._roomRichTextCallBack = nil

ChatMessageCell.FACE_TAG = 99999

ChatMessageCell._voiceCell = nil

function ChatMessageCell:ctor()
	self._infoNode = display.newNode()
	self:addChild(self._infoNode)
end

-- function ChatMessageCell:updateInfo(info,richTestCallBack,tipsCallBack,roomRichtest)
--    	self._richTestCallBack = richTestCallBack
--     self._tipsCallBack = tipsCallBack
--     self._roomRichTextCallBack = roomRichtest

function ChatMessageCell:updateInfo(info,showSomeTipsCallBack,richTestCallBack,guildCarnivalCallBack)

    self._infoNode:removeAllChildren()

    self._showSomeTipsCallBack = showSomeTipsCallBack
    self._richTestCallBack = richTestCallBack
    self._guildCarnivalCallBack = guildCarnivalCallBack

	local chatInfo = info
    self._chatInfo = info
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

    --系统 
    if channel == lt.Constants.CHAT_TYPE.SYSTEM then
        sunContent = json.decode(sunContent)

        local textLabel = lt.RichText.new()
        textLabel:setSize(cc.size(450, 10))
        textLabel:setAnchorPoint(cc.p(0,1))

        if subType == lt.Constants.CHAT_SUB_TYPE.NORMAL then
            -- 普通文本
            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
            textLabel:insertElement(systemStr)

            if type(message) == "string" then
                local messageText = lt.RichTextText.new(message,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(messageText)
            elseif type(message) == "table" then
                local messageArray = message
                for _,messageInfo in ipairs(messageArray) do
                    local message = messageInfo.message
                    local color = messageInfo.color or lt.Constants.COLOR.CITY_CHAT_ORANCE

                    local messageText = lt.RichTextText.new(message,lt.Constants.FONT_SIZE1,color)
                    textLabel:insertElement(messageText)
                end
            end
        elseif subType == lt.Constants.CHAT_SUB_TYPE.TRADE_NORMAl then--摆摊出售
            local itemType = sunContent["item_type"]
            local modelId = sunContent["model_id"]
            local size = sunContent["size"]

            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
            textLabel:insertElement(systemStr)

            local text = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_29"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
            textLabel:insertElement(text)

            local sizeStr = lt.RichTextText.new(size,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_GREEN)
            textLabel:insertElement(sizeStr)

            local numStr = lt.RichTextText.new(lt.StringManager:getString("STRING_SHOP_TIPS_52"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
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

            local nameStr = lt.RichTextText.new(name,lt.Constants.FONT_SIZE1,lt.UIMaker:getGradeColor(quality))
            textLabel:insertElement(nameStr)
        elseif subType == lt.Constants.CHAT_SUB_TYPE.GET_ITEM then--自己获得
            local itemType = sunContent["item_type"]
            local modelId = sunContent["model_id"]
            local size = sunContent["size"]

            local name = ""
            local quality = 1
            local valueType = 0
            if itemType == lt.GameIcon.TYPE.ITEM then--1
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

            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
            textLabel:insertElement(systemStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_2"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local sizeStr = lt.RichTextText.new(size,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_GREEN)
            textLabel:insertElement(sizeStr)

            --if valueType ~= 6 then
                local numStr = lt.RichTextText.new(lt.StringManager:getString("STRING_SHOP_TIPS_52"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(numStr)
            --end

            local nameStr = lt.RichTextText.new(name,lt.Constants.FONT_SIZE1,lt.UIMaker:getGradeColor(quality))
            textLabel:insertElement(nameStr)
        elseif subType == lt.Constants.CHAT_SUB_TYPE.GET_EXP then--获得经验
            local allExp    = sunContent["all_exp_increase"]
            local doubleExp = sunContent["double_increase"]
            local riseExp   = sunContent["rise_increase"]
            if allExp ~= -1 then
                local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
                textLabel:insertElement(systemStr)

                local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_2"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(text1)

                local sizeStr = lt.RichTextText.new(allExp,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_GREEN)
                textLabel:insertElement(sizeStr)

                local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_5"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(text2)


                if doubleExp >= 0 or riseExp > 0 then
                    local doubleExpText1 = lt.RichTextText.new("(",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(doubleExpText1)
                end

                --双倍
                if doubleExp >= 0 then
                    local doubleExpText2 = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_8"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(doubleExpText2)

                    local doubleExpText3 = lt.RichTextText.new(doubleExp,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_GREEN)
                    textLabel:insertElement(doubleExpText3)
                end

                if doubleExp >= 0 and riseExp > 0 then
                    local te = lt.RichTextText.new("，",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(te)
                end

                --奋起
                if riseExp > 0 then
                    local text4 = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_6"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(text4)

                    local text5 = lt.RichTextText.new(riseExp,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_GREEN)
                    textLabel:insertElement(text5)
                end

                if doubleExp >= 0 or riseExp > 0 then
                    local text6 = lt.RichTextText.new(")",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(text6)
                end
            else
                local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
                textLabel:insertElement(systemStr)
                local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_EXP_LIMITE"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(text1)
            end

        elseif subType == lt.Constants.CHAT_SUB_TYPE.RUNE_BOX then--道具开启
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

            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
            textLabel:insertElement(systemStr)

            local nameStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.BLUE)
            textLabel:insertElement(nameStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_STRING_30"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local txtStr = level..lt.StringManager:getString("STRING_LEVEL")..runeName
            local text2 = lt.RichTextText.new(txtStr,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.QUALITY_PURPLE)
            textLabel:insertElement(text2)

            local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_RUNE_STRING_TITLE"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
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
            --textLabel:onClicked(handler(self, self.tipsCallBack))
            textLabel:onClicked(handler(self, self.showSomeTipsCallBack))--装备或者道具

            local linkInfo = {}
            linkInfo.itemType = itemType
            linkInfo.id = modelId
            linkInfo.modelId = modelId
            linkInfo.playerId = playerId
            linkInfo.showTipsType = lt.MessageLayer.SHOWTIPSTYPE.TIPSSHOW
            local realInfo = json.encode(linkInfo)

            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
            textLabel:insertElement(systemStr)

            local playerStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE1, lt.Constants.COLOR.CITY_CHAT_BLUE)--
            textLabel:insertElement(playerStr)

            if modelId ~= lt.Constants.ITEM.DIAMOND then
                local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_EGG_1"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(text1)
                local sizeStr = lt.RichTextText.new(size,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_GREEN)
                textLabel:insertElement(sizeStr)
                if valueType ~= 6 then
                    local numStr = lt.RichTextText.new(lt.StringManager:getString("STRING_SHOP_TIPS_52"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(numStr)
                end

                local nameStr = lt.RichTextText.new("["..name.."]",lt.Constants.FONT_SIZE1,lt.UIMaker:getGradeColor(quality), {link = true, linkColor = lt.UIMaker:getGradeColor(quality), linkInfo = realInfo})
                textLabel:insertElement(nameStr)
            else
                local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_EGG_2"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(text1)
    
                local str = string.format(lt.StringManager:getString("STRING_GAIN_TIPS_EGG_3"), size)
                local sizeStr = lt.RichTextText.new(str,lt.Constants.FONT_SIZE1,lt.UIMaker:getGradeColor(quality))
                textLabel:insertElement(sizeStr)

                local nameStr = lt.RichTextText.new(lt.StringManager:getString("STRING_GAIN_TIPS_EGG_4"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
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

            -- local linkInfo1 = {}
            -- linkInfo1.playerId = playerId
            -- linkInfo1.showTipsType = lt.MessageLayer.SHOWTIPSTYPE.PLAYERTIP
            -- local realInfo1 = json.encode(linkInfo1)

            local linkInfo = {}
            linkInfo.itemType = lt.GameIcon.TYPE.EQUIPMENT
            linkInfo.id = id
            linkInfo.modelId = modelId
            linkInfo.playerId = playerId
            linkInfo.showTipsType = lt.MessageLayer.SHOWTIPSTYPE.TIPSSHOW
            local realInfo = json.encode(linkInfo)

            textLabel:onClicked(handler(self, self.showSomeTipsCallBack))--装备或者道具

            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
            textLabel:insertElement(systemStr)

            local playerStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_BLUE)
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

            local text1 = lt.RichTextText.new(lt.StringManager:getString(str1),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local levleStr = lt.RichTextText.new(level,lt.Constants.FONT_SIZE1, lt.Constants.COLOR.CITY_CHAT_GREEN)
            textLabel:insertElement(levleStr)

            local text2 = lt.RichTextText.new(lt.StringManager:getString(str2),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text2)

            local nameStr = lt.RichTextText.new("["..name.."]",lt.Constants.FONT_SIZE1, lt.UIMaker:getGradeColor(quality), {link = true,linkColor = lt.UIMaker:getGradeColor(quality), linkInfo = realInfo})
            textLabel:insertElement(nameStr)

            local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_CREATE_OREANGE_ITEM_3"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
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
            linkInfo.showTipsType = lt.MessageLayer.SHOWTIPSTYPE.TIPSSHOW
            local realInfo = json.encode(linkInfo)

            textLabel:onClicked(handler(self, self.showSomeTipsCallBack))

            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
            textLabel:insertElement(systemStr)

            local playerStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(playerStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_GOT_DRESS_TICKET_1"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local itemStr = lt.RichTextText.new(itemName,lt.Constants.FONT_SIZE1,lt.UIMaker:getGradeColor(quality), {link = true,linkColor = lt.UIMaker:getGradeColor(quality), linkInfo = realInfo})
            textLabel:insertElement(itemStr)

            local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_GOT_DRESS_TICKET_2"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text3)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_WORLD_BOSS_KILLED then--野外boss
            local bossName = sunContent["boss_name"]
            local playerName = sunContent["player_name"]
            local playerId = sunContent["player_id"]

            textLabel:onClicked(handler(self, self.showSomeTipsCallBack))

            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
            textLabel:insertElement(systemStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_KILL_BOSS_1"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local playerStr = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(playerStr)

            local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_KILL_BOSS_2"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text2)

            local bossStr = lt.RichTextText.new(bossName,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(bossStr)

            local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_KILL_BOSS_3"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text3)
        elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_WORLD_BOSS_FLUSH then--野外boss刷新
            local bossName = sunContent["boss_name"]
            local bossLevel = sunContent["boss_level"]
            local mapName = sunContent["map_name"]

            textLabel:onClicked(handler(self, self.showSomeTipsCallBack))

            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
            textLabel:insertElement(systemStr)

            local levleStr = lt.RichTextText.new(bossLevel,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(levleStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_FLUSH_BOSS_1"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local bossStr = lt.RichTextText.new(bossName,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(bossStr)

            local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_FLUSH_BOSS_2"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text2)

            local mapStr = lt.RichTextText.new(mapName,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(mapStr)

            local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_FLUSH_BOSS_3"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text3)
        elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_WORLD_BOSS_HP_CHANGE then--野外boss血量
            local bossName = sunContent["boss_name"]
            local hpType = sunContent["hp_type"]
            local mapName = sunContent["map_name"]

            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
            textLabel:insertElement(systemStr)

            local mapName = lt.RichTextText.new(mapName,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(mapName)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_BOSS_HP_1"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local bossStr = lt.RichTextText.new(bossName,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(bossStr)
            if hpType then
                if hpType == 1 then
                    local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_BOSS_HP_2"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(text2)
                elseif hpType == 2 then
                    local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_BOSS_HP_3"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                    textLabel:insertElement(text3)
                end
            end
        elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_ULIMATE_CHALLENGE_LAST_ATTACK then--极限挑战最后一击
            local playerId = sunContent["player_id"]
            local playerName = sunContent["player_name"]

            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
            textLabel:insertElement(systemStr)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_ULIMATE_CHALLENGE_LAST_ATTACK_1"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local player = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(player)

            local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_ULIMATE_CHALLENGE_LAST_ATTACK_2"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text2)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.CREATE_RISK_TEAM then--创建小队
            local playerId = sunContent["player_id"]
            local playerName = sunContent["player_name"]
            local name    =   sunContent["name"]
            local prefix    =   sunContent["prefix"]
            local memberCount    =   sunContent["member_count"]

            local num = lt.StringManager:getString(lt.StringManager:getCHSNumberString(memberCount))

            local teamName = prefix..num..name
            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
            textLabel:insertElement(systemStr)

            local player = lt.RichTextText.new(playerName,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(player)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_BATTLE_TEAM_1"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local team = lt.RichTextText.new(teamName,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(team)

            local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_BATTLE_TEAM_2"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text2)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.TREASURE_MAP then--藏宝图
            --local playerId = sunContent["player_id"]
            local playerName = sunContent["player_name"]
            local itemID    =   sunContent["item_id"]
            local itemSize    =   sunContent["item_size"]
            local itemType    =   sunContent["item_type"]

            textLabel:onClicked(handler(self, self.showSomeTipsCallBack))--装备或者道具
            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
            textLabel:insertElement(systemStr)

            local player = lt.RichTextText.new(playerName, lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(player)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_TREASURE_MAP_1"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
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
            linkInfo.showTipsType = lt.MessageLayer.SHOWTIPSTYPE.TIPSSHOW
            local realInfo = json.encode(linkInfo)

            local team = lt.RichTextText.new("["..name.."]",lt.Constants.FONT_SIZE1,lt.UIMaker:getGradeColor(quality), {link = true,linkColor = lt.UIMaker:getGradeColor(quality), linkInfo = realInfo})
            textLabel:insertElement(team)

            local text2 = lt.RichTextText.new("!",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text2)

        elseif subType == lt.Constants.CHAT_SUB_TYPE.MAZE then
            --local playerId = sunContent["player_id"]
            local playerName = sunContent["player_name"]
            local mazeName = sunContent["maze_name"]

            local systemStr = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_SYSTEM")..": ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
            textLabel:insertElement(systemStr)

            local player = lt.RichTextText.new(playerName, lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_BLUE)
            textLabel:insertElement(player)

            local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_MAZE_1"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text1)

            local name = lt.RichTextText.new(mazeName,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_GREEN)
            textLabel:insertElement(name)

            local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_CHAT_MAZE_2"),lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
            textLabel:insertElement(text2)

        else
            lt.CommonUtil.print("SYSTEM MESSAGE ")
        end
        textLabel:formatText()
        local height = textLabel:getContentSize().height + 10

        if height < 30 then
            height = 30
        end

        self._costomSize = cc.size(460,height)
        self._infoNode:addChild(textLabel)
        textLabel:setPosition(5,height)
        self:setContentSize(cc.size(self._costomSize.width + 2 * self._padding, self._costomSize.height + 2 * self._padding))
        self._infoNode:setPosition(self._padding, self._padding)
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

        --判断是自己说话还是别人的说话
        if senderId == playerId then
        	--人物头像背景
            local iconImg = lt.PlayerFace.new()
            iconImg:setAnchorPoint(1, 1)
            iconImg:setPosition(self._costomSize.width - 10,height - 5)
            self._infoNode:addChild(iconImg)
            iconImg:updateInfo({occupationId=hero:getOccupation(),id=playerId,faceId=senderAvatarId})

            --玩家姓名
            local nameLabel = lt.GameLabel.new(name, lt.Constants.FONT_SIZE1, lt.Constants.COLOR.WHITE)
            nameLabel:setAnchorPoint(1, 1)
            nameLabel:setPosition(iconImg:getPositionX() - iconImg:getContentSize().width - 15,iconImg:getPositionY())
            self._infoNode:addChild(nameLabel)

            --职业图标
            local occupationImg = lt.SmallOccupationIcon.new(hero:getOccupation())
            occupationImg:setAnchorPoint(1, 1)
            occupationImg:setPosition(nameLabel:getPositionX() - nameLabel:getContentSize().width - 7,nameLabel:getPositionY() + 3)
            self._infoNode:addChild(occupationImg)

            if hasAvatar ~= 0 then
                local spaceImg = display.newSprite("#space_btn_space5.png")
                spaceImg:setScale(0.8)
                spaceImg:setPosition(occupationImg:getPositionX() - occupationImg:getContentSize().width * occupationImg:getScale() - 20, nameLabel:getPositionY() - nameLabel:getContentSize().height / 2 )
                spaceImg:setTag(lt.MessageLayer.SPACE_TAG)
                spaceImg.id = senderId
                self._infoNode:addChild(spaceImg)
            end

            --发言内容
            local label = nil



            if subType == lt.Constants.CHAT_SUB_TYPE.QUESTION or subType == lt.Constants.CHAT_SUB_TYPE.INVITE_ROOM then
                label = lt.GameLabel.new(sunContent, lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
            else
                local str = ""
                if type(message) == "string" then
                    str = message
                elseif type(message) == "table" then
                    local messageArray = message
                    for _,messageInfo in ipairs(messageArray) do
                        local addStr = messageInfo.message
                        str = str..addStr
                    end
                end
                label = lt.GameLabel.new(str, lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
            end
            
    		local textLabel = lt.RichText.new()
            if label:getContentSize().width > 270 then
                textLabel:setSize(cc.size(270, 10))
            else
                local width = label:getContentSize().width

                if width < 56 then
                    width = 56
                end

                

                textLabel:setSize(cc.size(width, 10))
            end

            if subType == lt.Constants.CHAT_SUB_TYPE.QUESTION then--什么玩意？？？？
                
            	local textInfo = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_REQUEST"),lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
            	textLabel:insertElement(textInfo)

            	local contentInfo = lt.RichTextText.new("["..sunContent.."]",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = subParam..","..name})
            	textLabel:insertElement(contentInfo)
            --elseif subType == lt.Constants.CHAT_SUB_TYPE.RED_PACKET then --红包
                -- local textInfo = lt.RichTextText.new(message,lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
                -- textLabel:insertElement(textInfo)

                -- local contentInfo = lt.RichTextText.new("[去抢红包]",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.RED)
                -- textLabel:insertElement(contentInfo)
            elseif subType == lt.Constants.CHAT_SUB_TYPE.GUILD_CARNIVAL then
                textLabel:onClicked(handler(self, self.showSomeTipsCallBack))--进入狂欢
                local guildInfo = {}
                guildInfo.showTipsType = lt.MessageLayer.SHOWTIPSTYPE.GUILD_CARNIVAL
                local realInfo = json.encode(guildInfo)

                local messageArray = string.split(message, "+")

                if messageArray[1] then
                    local contentInfo1 = lt.RichTextText.new(messageArray[1],lt.Constants.FONT_SIZE1,lt.Constants.COLOR.SPACE_ORANGE)
                    textLabel:insertElement(contentInfo1)
                end
                if messageArray[2] then
                    local contentInfo2 = lt.RichTextText.new(messageArray[2],lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
                    textLabel:insertElement(contentInfo2)
                end

                if messageArray[3] then
                    local contentInfo3 = lt.RichTextText.new(messageArray[3],lt.Constants.FONT_SIZE1,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = realInfo})
                    textLabel:insertElement(contentInfo3)
                end

            elseif subType == lt.Constants.CHAT_SUB_TYPE.INVITE_ROOM then
                textLabel:onClicked(handler(self, self.showSomeTipsCallBack))--进入队伍

                local joinStr = lt.StringManager:getString("STRING_COMMON_JOIN_ROOM")

 
                local roomMessage = json.decode(sunContent)

 
                local realMessage = roomMessage["message"]
                local teamId = roomMessage["team_id"]

                local messagefArray = string.split(realMessage, "+")

                local roomInfo = {}
                roomInfo.teamId = teamId
                roomInfo.sequence = subParam
                roomInfo.showTipsType = lt.MessageLayer.SHOWTIPSTYPE.JOINTEAM
                local realInfo = json.encode(roomInfo)

                if messagefArray[1] then
                    local contentInfo1 = lt.RichTextText.new(messagefArray[1],lt.Constants.FONT_SIZE1,lt.Constants.COLOR.SPACE_ORANGE)
                    textLabel:insertElement(contentInfo1)
                end
                if messagefArray[2] then
                    local contentInfo2 = lt.RichTextText.new(messagefArray[2],lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
                    textLabel:insertElement(contentInfo2)
                end

                local joinInfo = lt.RichTextText.new(joinStr,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = realInfo})
                textLabel:insertElement(joinInfo)
            elseif subType == lt.Constants.CHAT_SUB_TYPE.LINK_LINE then

                textLabel:onClicked(handler(self, self.showSomeTipsCallBack))--这里应该是世界聊天里面输入的有表情文字和装备名字
                -- 超链接文本
                local message = chatInfo:getMessage()

                local subContentJson = chatInfo:getSubContent()
                local subContent = json.decode(subContentJson)

  
                local checkMessage = string.gsub(message, "+", "_")

                local subArray = {}
                local emojiCount = 0
                for keyStr,linkInfo in pairs(subContent) do
                    keyStr = string.gsub(keyStr, "+", "_")
                    if string.match(keyStr, "【#") then
                        emojiCount = emojiCount + 1
                    end
                    local st, ed = string.find(checkMessage, keyStr)
                    if st then
                        subArray[#subArray + 1] = {st = st, ed = ed, linkInfo = linkInfo}
                    end
                end

                if emojiCount > 1 then
                    local tWidth = math.min(label:getContentSize().width-24*(emojiCount-1),280)
                    textLabel:setSize(cc.size(tWidth, 10))
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

                        local contentInfo = lt.RichTextText.new(messageInfo.text,lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
                        textLabel:insertElement(contentInfo)
                        --local msg = string.format("(普通文字)%s", messageInfo.text)
          
                    elseif ty == 1 then
                        if messageInfo.linkInfo.itemType == lt.GameIcon.TYPE.EMOJI then
                            local emoji = lt.Emoji.new(messageInfo.linkInfo.id,true)
                            emoji:setContentSize(cc.size(44,44))
                            local richItem = cpp.RichItemCustom:create(0, lt.Constants.COLOR.WHITE, 255, emoji)
                            textLabel:addItem(richItem)
                        else
                            local _linkInfo = messageInfo.linkInfo
                            local quality = 1
                            _linkInfo.showTipsType = lt.MessageLayer.SHOWTIPSTYPE.TIPSSHOW --装备或者道具

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
                                _linkInfo.showTipsType = lt.MessageLayer.SHOWTIPSTYPE.SERVANT
                            end
                            
                            local realInfo = json.encode(_linkInfo)
                            local realText = string.gsub(string.gsub(messageInfo.text, "【", "["), "】","]")
                            local contentInfo = lt.RichTextText.new(realText,lt.Constants.FONT_SIZE1, lt.UIMaker:getGradeColor(quality),{link = true,linkColor = lt.UIMaker:getGradeColor(quality),linkInfo = realInfo})
                            textLabel:insertElement(contentInfo)
                        end
                    end
                end
            else
                if type(message) == "string" then
                    local messageText = lt.RichTextText.new(message,lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
                    textLabel:insertElement(messageText)
                elseif type(message) == "table" then
                    local messageArray = message
                    for _,messageInfo in ipairs(messageArray) do
                        local str = messageInfo.message
                        local color = messageInfo.color or lt.Constants.DEFAULT_LABEL_COLOR_2

                        local messageText = lt.RichTextText.new(str,lt.Constants.FONT_SIZE1,color)
                        textLabel:insertElement(messageText)
                    end
                end
    	    end

        	textLabel:formatText()
            --自己发言的背景框
            local textPadding = 20

            local textWidth = textLabel:getContentSize().width + textPadding


            if textWidth >= 280 then
            	textWidth = 295
            end
            local textHeight = textLabel:getContentSize().height + textPadding

            if textHeight < 48 then
                textHeight = 48
            end

            if subType == lt.Constants.CHAT_SUB_TYPE.RED_PACKET then

                textWidth = 290
                textHeight = 180
            else
                if textWidth < 56 then
                    textWidth = 56
                end
            end

            if hasVoice then
                textHeight = textHeight + 60
                textWidth = math.max(180, textWidth)
            end

            local rightInfoBg = nil


            if subType == lt.Constants.CHAT_SUB_TYPE.RED_PACKET then --红包特殊处理
                textLabel:formatText()

                local capInsets = cc.rect(20, 20, 1, 1)
                rightInfoBg = display.newScale9Sprite("image/chatbg/red_packet_bg.png", x, y, cc.size(textWidth, textHeight), capInsets)
                rightInfoBg:setAnchorPoint(1,1)
                rightInfoBg:setPosition(iconImg:getPositionX() - iconImg:getContentSize().width - 20, nameLabel:getPositionY() - nameLabel:getContentSize().height - 8)
                self._infoNode:addChild(rightInfoBg)
                rightInfoBg:setTag(lt.MessageLayer.RED_PACKET)

                textLabel:setAnchorPoint(cc.p(0.5, 0.5))

                textLabel:setPosition(rightInfoBg:getContentSize().width / 2,rightInfoBg:getContentSize().height / 2+3)


                rightInfoBg:addChild(textLabel,2)

                local redPacketImage = display.newSprite("image/chatbg/red_packet.png")
                redPacketImage:setPosition(5, 30)
                rightInfoBg:addChild(redPacketImage)

                local gotoLabel = lt.GameLabel.new(lt.StringManager:getString("STRING_REDPACKET_STRING_22"), lt.Constants.FONT_SIZE1, lt.Constants.COLOR.RED)
                gotoLabel:setAnchorPoint(1, 0)
                gotoLabel:setPosition(rightInfoBg:getContentSize().width - 10, 5)
                rightInfoBg:addChild(gotoLabel)

            else
                if bubbleId and bubbleId ~= 0 then
                    if textWidth < 150 then
                        textWidth = 150
                    end

                    height = height + 10
                    
                    rightInfoBg = lt.BubbleIcon.new()
                    rightInfoBg:updateInfo(bubbleId,cc.size(textWidth + 30, textHeight),true)
                    rightInfoBg:setPosition(iconImg:getPositionX() - iconImg:getContentSize().width - 20, nameLabel:getPositionY() - nameLabel:getContentSize().height - 15)
                    self._infoNode:addChild(rightInfoBg)

                    textLabel:setAnchorPoint(cc.p(0.5, 0.5))

                    textLabel:setPosition(rightInfoBg:getContentSize().width / 2,rightInfoBg:getContentSize().height / 2+3)


                    rightInfoBg:addNode(textLabel,2)



                else

                    rightInfoBg = lt.GameInfoBg.new(lt.GameInfoBg.TYPE.GAME_INFO_BG_TYPE_17, cc.size(textWidth,textHeight), iconImg:getPositionX() - iconImg:getContentSize().width - 20, nameLabel:getPositionY() - nameLabel:getContentSize().height - 5)
                    rightInfoBg:setAnchorPoint(1, 1)
                    self._infoNode:addChild(rightInfoBg)

                    textLabel:setAnchorPoint(cc.p(0.5, 0.5))

                    textLabel:setPosition(rightInfoBg:getContentSize().width / 2,rightInfoBg:getContentSize().height / 2+3)


                    rightInfoBg:addChild(textLabel,2)

                   

                    --箭头
                    local rightArrowImg = display.newSprite("#friend_left_arrow.png")
                    rightArrowImg:setRotation(180)
                    rightArrowImg:setAnchorPoint(0, 0)
                    rightArrowImg:setPosition(rightInfoBg:getContentSize().width + 13,rightInfoBg:getContentSize().height - 10)
                    rightInfoBg:addChild(rightArrowImg)
                end
            end

            if hasVoice then
                self._voiceCell = lt.VoiceCell.new(chatInfo,textWidth,textHeight,false)
                rightInfoBg:addChild(self._voiceCell)
                rightInfoBg:setTag(lt.MessageLayer.VOICE_TAG)

                rightInfoBg.info = self._voiceCell
                rightInfoBg.time = chatInfo:getDuration()
                textLabel:setPositionY(textLabel:getPositionY() - 35)

                if bubbleId and bubbleId ~= 0 then
                    self._voiceCell:setPosition(-textWidth, -textHeight)
                end

            end

            height = height + 15 + textHeight + nameLabel:getContentSize().height

            self._costomSize = cc.size(460,height)
            self:setContentSize(cc.size(self._costomSize.width + 2 * self._padding, self._costomSize.height + 2 * self._padding))
            --self:setPreferredSize(cc.size(self._costomSize.width + 2 * self._padding, self._costomSize.height + 2 * self._padding))
            self._infoNode:setPosition(self._padding, self._padding + height)
    	else
            local iconImg = nil
            local occupationImg = nil
            local nameLabel = nil

            if subType == lt.Constants.CHAT_SUB_TYPE.NORMAL 
                or subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_GUILD_BOSS_FLUSH
                or subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_GUILD_BOSS_LAST_ATTACK 
                or subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_GUILD_BOSS_KILLED then--不是玩家  是该频道的提示信息

                local bg = display.newSprite("#common_new_icon.png")
                bg:setPosition(10,height - 5)
                bg:setAnchorPoint(0, 1)
                self._infoNode:addChild(bg)

                iconImg = display.newSprite("#common_icon_system.png")
                iconImg:setAnchorPoint(0, 1)
                iconImg:setPosition(10,height - 5)
                self._infoNode:addChild(iconImg)

                nameLabel = lt.GameLabel.new(lt.StringManager:getString("STRING_PROMPT_TIP"), lt.Constants.FONT_SIZE1, lt.Constants.COLOR.WHITE)
                nameLabel:setAnchorPoint(0, 1)
                nameLabel:setPosition(iconImg:getPositionX() + iconImg:getContentSize().width + 15 ,iconImg:getPositionY())
                self._infoNode:addChild(nameLabel)
            else
                iconImg = lt.PlayerFace.new(true)
                iconImg:setAnchorPoint(0, 1)
                iconImg:setPosition(10,height - 5)
                self._infoNode:addChild(iconImg)
                iconImg:updateInfo({occupationId=occupationId,id=senderId,faceId=senderAvatarId})
                iconImg:setTag(lt.MessageLayer.PLAYER_FACE_TAG)
                iconImg.id = senderId

                occupationImg = lt.SmallOccupationIcon.new(occupationId)
                occupationImg:setAnchorPoint(0, 1)
                occupationImg:setPosition(iconImg:getPositionX() + iconImg:getContentSize().width + 15,iconImg:getPositionY() + 3)
                self._infoNode:addChild(occupationImg)
                --玩家姓名
                nameLabel = lt.GameLabel.new(name, lt.Constants.FONT_SIZE1, lt.Constants.COLOR.WHITE)
                nameLabel:setAnchorPoint(0, 1)
                nameLabel:setPosition(occupationImg:getPositionX() + occupationImg:getContentSize().width * occupationImg:getScale() + 5,iconImg:getPositionY())
                self._infoNode:addChild(nameLabel)
            end


        	-- --人物头像背景
         --    local iconImg = lt.PlayerFace.new(true)
         --    iconImg:setAnchorPoint(0, 1)
         --    iconImg:setPosition(10,height - 5)
         --    self._infoNode:addChild(iconImg)
         --    iconImg:updateInfo({occupationId=occupationId,id=senderId,faceId=senderAvatarId})
         --    iconImg:setTag(lt.MessageLayer.PLAYER_FACE_TAG)
         --    iconImg.id = senderId
            
         --    --职业图标

         --    local occupationImg = lt.SmallOccupationIcon.new(occupationId)
         --    occupationImg:setAnchorPoint(0, 1)
         --    occupationImg:setPosition(iconImg:getPositionX() + iconImg:getContentSize().width + 15,iconImg:getPositionY() + 3)
         --    self._infoNode:addChild(occupationImg)

         --    --玩家姓名
         --    local nameLabel = lt.GameLabel.new(name, lt.Constants.FONT_SIZE1, lt.Constants.COLOR.WHITE)
         --    nameLabel:setAnchorPoint(0, 1)
         --    nameLabel:setPosition(occupationImg:getPositionX() + occupationImg:getContentSize().width * occupationImg:getScale() + 5,iconImg:getPositionY())
         --    self._infoNode:addChild(nameLabel)

            if hasAvatar ~= 0 then
                local spaceImg = display.newSprite("#space_btn_space5.png")
                spaceImg:setScale(0.8)
                spaceImg:setPosition(nameLabel:getPositionX() + nameLabel:getContentSize().width + 20, nameLabel:getPositionY() - nameLabel:getContentSize().height / 2 )
                spaceImg:setTag(lt.MessageLayer.SPACE_TAG)
                spaceImg.id = senderId
                self._infoNode:addChild(spaceImg)
            end

            --发言内容
            local label = nil
            if subType == lt.Constants.CHAT_SUB_TYPE.QUESTION or subType == lt.Constants.CHAT_SUB_TYPE.INVITE_ROOM then
                label = lt.GameLabel.new(sunContent, lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
            elseif subType == lt.Constants.CHAT_SUB_TYPE.NORMAL then
                local str = ""
                if type(message) == "string" then
                    str = message
                elseif type(message) == "table" then
                    local messageArray = message
                    for _,messageInfo in ipairs(messageArray) do
                        local addStr = messageInfo.message
                        str = str..addStr
                    end
                end

                label = lt.GameLabel.new(str, lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
            elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_GUILD_BOSS_FLUSH then
                message = lt.StringManager:getString("STRING_GUILD_BOSS_FLUSH")
                label = lt.GameLabel.new(message, lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
            elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_GUILD_BOSS_LAST_ATTACK then
                local messageStr = json.decode(sunContent)
                local player_str = messageStr["player_name"] or ""
                local boss_str = messageStr["boss_name"] or ""
                message = string.format(lt.StringManager:getString("STRING_GUILD_BOSS_LAST_ATTACK"), player_str, boss_str)
                label = lt.GameLabel.new(message, lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)
            elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_GUILD_BOSS_KILLED then
                message = lt.StringManager:getString("STRING_GUILD_BOSS_KILLED")
                label = lt.GameLabel.new(message, lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)  
            else
                label = lt.GameLabel.new(message, lt.Constants.FONT_SIZE1, lt.Constants.DEFAULT_LABEL_COLOR_2)           
            end

            local textLabel = lt.RichText.new()
            if label:getContentSize().width > 270 then
                textLabel:setSize(cc.size(270, 10))
            else
                if label:getContentSize().width < 56 then
                    label:getContentSize().width = 56
                end

                textLabel:setSize(cc.size(label:getContentSize().width, 10))
            end
            
            if subType == lt.Constants.CHAT_SUB_TYPE.QUESTION then--答题
            	textLabel:onClicked(handler(self, self.richTest))

            	local textInfo = lt.RichTextText.new(lt.StringManager:getString("STRING_MESSAGE_CHAT_REQUEST"),lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
            	textLabel:insertElement(textInfo)

            	local contentInfo = lt.RichTextText.new("["..sunContent.."]",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = subParam..","..name..","..senderId})
            	textLabel:insertElement(contentInfo)
            elseif subType == lt.Constants.CHAT_SUB_TYPE.GUILD_CARNIVAL then
                textLabel:onClicked(handler(self, self.showSomeTipsCallBack))--进入狂欢
                local guildInfo = {}
                guildInfo.showTipsType = lt.MessageLayer.SHOWTIPSTYPE.GUILD_CARNIVAL
                local realInfo = json.encode(guildInfo)

                local messageArray = string.split(message, "+")

                if messageArray[1] then
                    local contentInfo1 = lt.RichTextText.new(messageArray[1],lt.Constants.FONT_SIZE1,lt.Constants.COLOR.SPACE_ORANGE)
                    textLabel:insertElement(contentInfo1)
                end
                if messageArray[2] then
                    local contentInfo2 = lt.RichTextText.new(messageArray[2],lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
                    textLabel:insertElement(contentInfo2)
                end

                if messageArray[3] then
                    local contentInfo3 = lt.RichTextText.new(messageArray[3],lt.Constants.FONT_SIZE1,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = realInfo})
                    textLabel:insertElement(contentInfo3)
                end
            elseif subType == lt.Constants.CHAT_SUB_TYPE.INVITE_ROOM then
                textLabel:onClicked(handler(self, self.showSomeTipsCallBack))--加入队伍

                local joinStr = lt.StringManager:getString("STRING_COMMON_JOIN_ROOM")

 
                local roomMessage = json.decode(sunContent)

 
                local realMessage = roomMessage["message"]
                local teamId = roomMessage["team_id"]

                local roomInfo = {}
                roomInfo.teamId = teamId
                roomInfo.sequence = subParam
                roomInfo.showTipsType = lt.MessageLayer.SHOWTIPSTYPE.JOINTEAM
                local realInfo = json.encode(roomInfo)

                local messagefArray = string.split(realMessage, "+")
                if messagefArray[1] then
                    local contentInfo1 = lt.RichTextText.new(messagefArray[1],lt.Constants.FONT_SIZE1,lt.Constants.COLOR.SPACE_ORANGE)
                    textLabel:insertElement(contentInfo1)
                end
                if messagefArray[2] then
                    local contentInfo2 = lt.RichTextText.new(messagefArray[2],lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
                    textLabel:insertElement(contentInfo2)
                end
                local joinInfo = lt.RichTextText.new(joinStr,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.SPACE_ORANGE,{link = true,linkColor = lt.Constants.COLOR.SPACE_ORANGE,linkInfo = realInfo})
                textLabel:insertElement(joinInfo)
            elseif subType == lt.Constants.CHAT_SUB_TYPE.LINK_LINE then
                textLabel:onClicked(handler(self, self.showSomeTipsCallBack))
                -- 超链接文本
                local message = chatInfo:getMessage()

                local subContentJson = chatInfo:getSubContent()
                local subContent = json.decode(subContentJson)

                local emojiCount = 0
                local checkMessage = string.gsub(message, "+", "_")
                local subArray = {}
                for keyStr,linkInfo in pairs(subContent) do
                    keyStr = string.gsub(keyStr, "+", "_")
                    if string.match(keyStr, "【#") then
                        emojiCount = emojiCount + 1
                    end
                    
                    local st, ed = string.find(checkMessage, keyStr)

                    if st then
                        subArray[#subArray + 1] = {st = st, ed = ed, linkInfo = linkInfo}
                    end
                end


                if emojiCount > 1 then
                    local tWidth = math.min(label:getContentSize().width-24*(emojiCount-1),280)
                    textLabel:setSize(cc.size(tWidth, 10))
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

                        local contentInfo = lt.RichTextText.new(messageInfo.text,lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
                        textLabel:insertElement(contentInfo)
                    elseif ty == 1 then
                        if messageInfo.linkInfo.itemType == lt.GameIcon.TYPE.EMOJI then
                            local emoji = lt.Emoji.new(messageInfo.linkInfo.id,true)
                            emoji:setContentSize(cc.size(44,44))
                            local richItem = cpp.RichItemCustom:create(0, lt.Constants.COLOR.WHITE, 255, emoji)
                            textLabel:addItem(richItem)
                        else
                            local _linkInfo = messageInfo.linkInfo
                            local quality = 1
                            _linkInfo.showTipsType = lt.MessageLayer.SHOWTIPSTYPE.TIPSSHOW

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
                                _linkInfo.showTipsType = lt.MessageLayer.SHOWTIPSTYPE.SERVANT
                            end 
                            
                            local realInfo = json.encode(_linkInfo)
                            local realText = string.gsub(string.gsub(messageInfo.text, "【", "["), "】","]")
                            local contentInfo = lt.RichTextText.new(realText,lt.Constants.FONT_SIZE1,lt.UIMaker:getGradeColor(quality),{link = true,linkColor = lt.UIMaker:getGradeColor(quality),linkInfo = realInfo})
                            textLabel:insertElement(contentInfo)
                        end
                    end
                end
            elseif subType == lt.Constants.CHAT_SUB_TYPE.ACTIVITY_GUILD_BOSS_LAST_ATTACK then
                local messageStr = json.decode(sunContent)
                local player_str = messageStr["player_name"] or ""
                local boss_str = messageStr["boss_name"] or ""

                local text1 = lt.RichTextText.new(lt.StringManager:getString("STRING_GUILD_BOSS_LAST_ATTACK_1"),lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
                textLabel:insertElement(text1)

                local textNameInfo = lt.RichTextText.new("["..player_str.."] ",lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CHAT_PLAYER_NAME)
                textLabel:insertElement(textNameInfo)

                local text2 = lt.RichTextText.new(lt.StringManager:getString("STRING_GUILD_BOSS_LAST_ATTACK_2"),lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
                textLabel:insertElement(text2)

                local textNameBoss= lt.RichTextText.new(boss_str,lt.Constants.FONT_SIZE1,lt.Constants.COLOR.CITY_CHAT_ORANCE)
                textLabel:insertElement(textNameBoss)

                local text3 = lt.RichTextText.new(lt.StringManager:getString("STRING_GUILD_BOSS_LAST_ATTACK_3"),lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
                textLabel:insertElement(text3)
            else
                if type(message) == "string" then
        	        local messageText = lt.RichTextText.new(message,lt.Constants.FONT_SIZE1,lt.Constants.DEFAULT_LABEL_COLOR_2)
        	    	textLabel:insertElement(messageText)
                elseif type(message) == "table" then
                    local messageArray = message
                    for _,messageInfo in ipairs(messageArray) do
                        local str = messageInfo.message
                        local color = messageInfo.color or lt.Constants.DEFAULT_LABEL_COLOR_2

                        local messageText = lt.RichTextText.new(str,lt.Constants.FONT_SIZE1,color)
                        textLabel:insertElement(messageText)
                    end
                end
    	    end

        	textLabel:formatText()
            --别人发言的背景框
            local textPadding = 20

            local textWidth = textLabel:getContentSize().width + textPadding

            if textWidth >= 280 then
            	textWidth = 295
            end

            local textHeight = textLabel:getContentSize().height + textPadding

            if textHeight < 48 then
                textHeight = 48
            end

            if subType == lt.Constants.CHAT_SUB_TYPE.RED_PACKET then

                textWidth = 290
                textHeight = 180
            else
                if textWidth < 56 then
                    textWidth = 56
                end
            end

            if hasVoice then
                textHeight = textHeight + 60
                textWidth = math.max(180, textWidth)
            end

            local rightInfoBg = nil

            if subType == lt.Constants.CHAT_SUB_TYPE.RED_PACKET then --红包特殊处理
                textLabel:formatText()

                local capInsets = cc.rect(20, 20, 1, 1)
                rightInfoBg = display.newScale9Sprite("image/chatbg/red_packet_bg.png", x, y, cc.size(textWidth, textHeight), capInsets)
                rightInfoBg:setAnchorPoint(0,1)
                rightInfoBg:setPosition(iconImg:getPositionX() + iconImg:getContentSize().width + 20, nameLabel:getPositionY() - nameLabel:getContentSize().height - 8)
                self._infoNode:addChild(rightInfoBg)
                rightInfoBg:setTag(lt.MessageLayer.RED_PACKET)

                textLabel:setAnchorPoint(cc.p(0.5, 0.5))

                textLabel:setPosition(rightInfoBg:getContentSize().width / 2,rightInfoBg:getContentSize().height / 2+3)


                rightInfoBg:addChild(textLabel,2)

                local redPacketImage = display.newSprite("image/chatbg/red_packet.png")
                redPacketImage:setPosition(rightInfoBg:getContentSize().width - 5, 30)
                rightInfoBg:addChild(redPacketImage)

                local gotoLabel = lt.GameLabel.new(lt.StringManager:getString("STRING_REDPACKET_STRING_22"), lt.Constants.FONT_SIZE1, lt.Constants.COLOR.RED)
                gotoLabel:setAnchorPoint(0, 0)
                gotoLabel:setPosition(10, 5)
                rightInfoBg:addChild(gotoLabel)
            else
                if bubbleId and bubbleId ~= 0 then
                    if textWidth < 150 then
                        textWidth = 150
                    end
                    height = height + 10
                    rightInfoBg = lt.BubbleIcon.new()
                    rightInfoBg:updateInfo(bubbleId,cc.size(textWidth + 30, textHeight))
                    rightInfoBg:setPosition(iconImg:getPositionX() + iconImg:getContentSize().width + 20, nameLabel:getPositionY() - nameLabel:getContentSize().height - 15)
                    self._infoNode:addChild(rightInfoBg)

                    
                    textLabel:setAnchorPoint(cc.p(0.5, 0.5))

                    textLabel:setPosition(rightInfoBg:getContentSize().width / 2,rightInfoBg:getContentSize().height / 2+3)


                    rightInfoBg:addNode(textLabel,2)
                else
                    rightInfoBg = lt.GameInfoBg.new(lt.GameInfoBg.TYPE.GAME_INFO_BG_TYPE_17, cc.size(textWidth,textHeight), iconImg:getPositionX() + iconImg:getContentSize().width + 20, nameLabel:getPositionY() - nameLabel:getContentSize().height - 5)
                    rightInfoBg:setAnchorPoint(0, 1)
                    self._infoNode:addChild(rightInfoBg)

                    textLabel:setAnchorPoint(cc.p(0.5, 0.5))

                    textLabel:setPosition(rightInfoBg:getContentSize().width / 2,rightInfoBg:getContentSize().height / 2+3)


                    rightInfoBg:addChild(textLabel,2)

                   
                   
                    --箭头
                    local rightArrowImg = display.newSprite("#friend_left_arrow.png")
                    rightArrowImg:setAnchorPoint(0, 1)
                    rightArrowImg:setPosition(-12,rightInfoBg:getContentSize().height - 10)
                    rightInfoBg:addChild(rightArrowImg)
                end
            end

            if hasVoice then
                self._voiceCell = lt.VoiceCell.new(chatInfo,textWidth,textHeight,true)
                rightInfoBg:addChild(self._voiceCell)
                rightInfoBg.info = self._voiceCell
                rightInfoBg.time = chatInfo:getDuration()
                rightInfoBg:setTag(lt.MessageLayer.VOICE_TAG)
                textLabel:setPositionY(textLabel:getPositionY() - 35)

                if bubbleId and bubbleId ~= 0 then
                    self._voiceCell:setPositionY(-textHeight)
                end
            end


            height = height + 15 + textHeight + nameLabel:getContentSize().height

            self._costomSize = cc.size(460,height)
            self:setContentSize(cc.size(self._costomSize.width + 2 * self._padding, self._costomSize.height + 2 * self._padding))
            --self:setPreferredSize(cc.size(self._costomSize.width + 2 * self._padding, self._costomSize.height + 2 * self._padding))
            self._infoNode:setPosition(self._padding, self._padding + height)
    	end

    end
end

function ChatMessageCell:getInfoNode()
    return self._infoNode
end

function ChatMessageCell:getCustomSize()
	return self._costomSize
end

function ChatMessageCell:richTest(sender)
	if self._richTestCallBack then
		self._richTestCallBack(sender)
	end
end

function ChatMessageCell:roomRichTest(sender)
    if self._roomRichTextCallBack then
        self._roomRichTextCallBack(sender)
    end
end

function ChatMessageCell:tipsCallBack(sender)
    if self._tipsCallBack then
        self._tipsCallBack(sender)
    end
end

function ChatMessageCell:showSomeTipsCallBack(sender)
    if self._showSomeTipsCallBack then
        self._showSomeTipsCallBack(sender)
    end
end

function ChatMessageCell:onPraiseBtnCallBack(event)
	self._praiseBtnCallBack(event)
end

function ChatMessageCell:onDeleteMessage(event)
	self._delMessageCallback(event)
end

function ChatMessageCell:clearVoiceAnimation()
    if self._voiceCell then
        self._voiceCell:clearAnimation()
    end
end

function ChatMessageCell:stopVoice()
    if self._voiceCell then
        self._voiceCell:stopVoice()
    end
end

function ChatMessageCell:getVoiceCell()
    return self._voiceCell
end

function ChatMessageCell:getMessageId()
    if self._chatInfo then
        return self._chatInfo:getMessageId()
    end
    return 0
end

return ChatMessageCell
