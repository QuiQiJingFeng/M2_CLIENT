
-- 用于管理游戏内文件
local StringManager = {}

StringManager._stringInfo = nil

function StringManager:init()
	if GAME_LOCAL then
		-- 开发模式
		local fileName = lt.Constants.STRINGPATH

		local path = cc.FileUtils:getInstance():fullPathForFilename(fileName)
		if io.exists(path) then
			local fileData = io.readfile(path)
			local gameString = loadstring(fileData)
			self._stringInfo = gameString()
		end
	else
		-- 正式模式
		local codePath = cc.FileUtils:getInstance():fullPathForFilename("language.zip")
        cc.LuaLoadChunksFromZIP(codePath)

		local fileName = lt.Constants.STRINGFILE
		local gameString = require(fileName)
		self._stringInfo = gameString
	end
end

function StringManager:getFormatString(key, ...)
	return string.format(self:getString(key), ...)
end

function StringManager:getString(key)
	return self._stringInfo[key] or ""
end

StringManager.CHS_NUMBER_STRING = {
	[1] = "STRING_CHS_NUMBER_1",
	[2] = "STRING_CHS_NUMBER_2",
	[3] = "STRING_CHS_NUMBER_3",
	[4] = "STRING_CHS_NUMBER_4",
	[5] = "STRING_CHS_NUMBER_5",
	[6] = "STRING_CHS_NUMBER_6",
	[7] = "STRING_CHS_NUMBER_7",
	[8] = "STRING_CHS_NUMBER_8",
	[9] = "STRING_CHS_NUMBER_9",
}
function StringManager:getCHSNumberString(number)
	return self.CHS_NUMBER_STRING[number] or ""
end

StringManager._weekdayString = nil
function StringManager:getWeekDayString(weekDay, longType)
	if not self._weekdayString then
		self._weekdayString = {
			[0] = {
				[1] = self:getString("STRING_WEEKDAY_STRING_S_1"),
				[2] = self:getString("STRING_WEEKDAY_STRING_S_2"),
				[3] = self:getString("STRING_WEEKDAY_STRING_S_3"),
				[4] = self:getString("STRING_WEEKDAY_STRING_S_4"),
				[5] = self:getString("STRING_WEEKDAY_STRING_S_5"),
				[6] = self:getString("STRING_WEEKDAY_STRING_S_6"),
				[7] = self:getString("STRING_WEEKDAY_STRING_S_7"),
			},
			[1] = {
				[1] = self:getString("STRING_WEEKDAY_STRING_1"),
				[2] = self:getString("STRING_WEEKDAY_STRING_2"),
				[3] = self:getString("STRING_WEEKDAY_STRING_3"),
				[4] = self:getString("STRING_WEEKDAY_STRING_4"),
				[5] = self:getString("STRING_WEEKDAY_STRING_5"),
				[6] = self:getString("STRING_WEEKDAY_STRING_6"),
				[7] = self:getString("STRING_WEEKDAY_STRING_7"),
			},
		}
	end

	longType = longType or 0

	return self._weekdayString[longType][weekDay]
end

StringManager._occupationString = nil
function StringManager:getOccupationString(occupationId)
	if not self._occupationString then
		self._occupationString = {
			[lt.Constants.OCCUPATION.QS]	= self:getString("STRING_COMMON_OCCUPATION_QS"),
			[lt.Constants.OCCUPATION.MFS] 	= self:getString("STRING_COMMON_OCCUPATION_MFS"),
			[lt.Constants.OCCUPATION.JS] 	= self:getString("STRING_COMMON_OCCUPATION_ZL"),
			[lt.Constants.OCCUPATION.BWLR] 	= self:getString("STRING_COMMON_OCCUPATION_BWLR")
		}
	end

	return self._occupationString[occupationId] or ""
end

StringManager._attributeString = nil
function StringManager:getAttributeString(attribute)
	if not self._attributeString then
		self._attributeString = {
			[lt.Constants.ATTRIBUTE.ATTACK]				= self:getString("STRING_ATTRIBUTE_ATTACK"),
			[lt.Constants.ATTRIBUTE.SKILL_ATTACK]		= self:getString("STRING_ATTRIBUTE_SKILL_ATTACK"),
			[lt.Constants.ATTRIBUTE.ARMOR]				= self:getString("STRING_ATTRIBUTE_ARMOR"),
			[lt.Constants.ATTRIBUTE.HEALTH]				= self:getString("STRING_ATTRIBUTE_HEALTH"),
			[lt.Constants.ATTRIBUTE.MP]					= self:getString("STRING_ATTRIBUTE_MP"),
			[lt.Constants.ATTRIBUTE.MP_RECOVER]			= self:getString("STRING_ATTRIBUTE_MP_RECOVER"),
			[lt.Constants.ATTRIBUTE.RESILIENCE]			= self:getString("STRING_ATTRIBUTE_RESILIENCE"),
			[lt.Constants.ATTRIBUTE.PARRY]				= self:getString("STRING_ATTRIBUTE_PARRY"),
			[lt.Constants.ATTRIBUTE.CRITICAL_DAMAGE]	= self:getString("STRING_ATTRIBUTE_CRITICAL_DAMAGE"),
			[lt.Constants.ATTRIBUTE.CRITICAL]			= self:getString("STRING_ATTRIBUTE_CRITICAL"),
			[lt.Constants.ATTRIBUTE.SHIELD]				= self:getString("STRING_ATTRIBUTE_SHIELD"),
			[lt.Constants.ATTRIBUTE.ENDURE]				= self:getString("STRING_ATTRIBUTE_ENDURE"),
			[lt.Constants.ATTRIBUTE.ANTI_ENDURE]		= self:getString("STRING_ATTRIBUTE_ANTI_ENDURE"),
			[lt.Constants.ATTRIBUTE.MOVE_SPEED]			= self:getString("STRING_ATTRIBUTE_MOVE_SPEED"),
			[lt.Constants.ATTRIBUTE.FIRE]				= self:getString("STRING_ATTRIBUTE_PROPERTY_FIRE"),
			[lt.Constants.ATTRIBUTE.WATER]				= self:getString("STRING_ATTRIBUTE_PROPERTY_WATER"),
			[lt.Constants.ATTRIBUTE.WIND]				= self:getString("STRING_ATTRIBUTE_PROPERTY_WIND"),
			[lt.Constants.ATTRIBUTE.LIGHT]				= self:getString("STRING_ATTRIBUTE_PROPERTY_LIGHT"),
			[lt.Constants.ATTRIBUTE.DARK]				= self:getString("STRING_ATTRIBUTE_PROPERTY_DARK"),
		}
	end

	return  self._attributeString[attribute] or ""
end

--用于符文里面的属性 ，烦的一b
StringManager._attributeRuneString = nil
function StringManager:getRuneAttributeString(attribute)
	if not self._attributeRuneString then
		self._attributeRuneString = {
			[lt.Constants.ATTRIBUTE.ATTACK]				= self:getString("STRING_ATTRIBUTE_ATTACK"),
			[lt.Constants.ATTRIBUTE.SKILL_ATTACK]		= self:getString("STRING_ATTRIBUTE_SKILL_ATTACK"),
			[lt.Constants.ATTRIBUTE.ARMOR]				= self:getString("STRING_ATTRIBUTE_ARMOR"),
			[lt.Constants.ATTRIBUTE.HEALTH]				= self:getString("STRING_ATTRIBUTE_HEALTH"),
			[lt.Constants.ATTRIBUTE.MP]					= self:getString("STRING_ATTRIBUTE_MP"),
			[lt.Constants.ATTRIBUTE.MP_RECOVER]			= self:getString("STRING_ATTRIBUTE_MP_RECOVER"),
			[lt.Constants.ATTRIBUTE.RESILIENCE]			= self:getString("STRING_ATTRIBUTE_RESILIENCE"),
			[lt.Constants.ATTRIBUTE.PARRY]				= self:getString("STRING_ATTRIBUTE_PARRY"),
			[lt.Constants.ATTRIBUTE.CRITICAL_DAMAGE]	= self:getString("STRING_ATTRIBUTE_CRITICAL_DAMAGE"),
			[lt.Constants.ATTRIBUTE.CRITICAL]			= self:getString("STRING_ATTRIBUTE_CRITICAL"),
			[lt.Constants.ATTRIBUTE.SHIELD]				= self:getString("STRING_ATTRIBUTE_SHIELD"),
			[lt.Constants.ATTRIBUTE.ENDURE]				= self:getString("STRING_ATTRIBUTE_ENDURE"),
			[lt.Constants.ATTRIBUTE.ANTI_ENDURE]		= self:getString("STRING_ATTRIBUTE_ANTI_ENDURE"),
			[lt.Constants.ATTRIBUTE.MOVE_SPEED]			= self:getString("STRING_ATTRIBUTE_MOVE_SPEED"),
			[lt.Constants.ATTRIBUTE.FIRE]				= self:getString("STRING_ATTRIBUTE_PROPERTY_FIRE_HURT"),
			[lt.Constants.ATTRIBUTE.WATER]				= self:getString("STRING_ATTRIBUTE_PROPERTY_WATER_HURT"),
			[lt.Constants.ATTRIBUTE.WIND]				= self:getString("STRING_ATTRIBUTE_PROPERTY_WIND_HURT"),
			[lt.Constants.ATTRIBUTE.LIGHT]				= self:getString("STRING_ATTRIBUTE_PROPERTY_LIGHT_HURT"),
			[lt.Constants.ATTRIBUTE.DARK]				= self:getString("STRING_ATTRIBUTE_PROPERTY_DARK_HURT"),
		}
	end

	return  self._attributeRuneString[attribute] or ""
end

-- 属性显示规范化(用于显示) 显示正负号 入 暴击格挡 为万分比(保留小数 不填充0)暴击格挡(填充0)
function StringManager:getAttributeFormat(attribute, value, sign,params)
	local signLabel = ""
	if value >= 0 then
		if sign == nil or sign then
	    	signLabel = "+"
		end
    elseif value < 0 then
        signLabel = "-"
    end

    if params and params.noSign then
    	signLabel = ""
    end

    value = math.abs(value)

	if attribute ==  lt.Constants.ATTRIBUTE.PARRY or
		attribute == lt.Constants.ATTRIBUTE.CRITICAL_DAMAGE or
		attribute == lt.Constants.ATTRIBUTE.CRITICAL
	then
		return signLabel..value
		--return string.format("%s%.2f%%", signLabel, value / 100)
	elseif
		attribute == lt.Constants.ATTRIBUTE.FIRE or
		attribute == lt.Constants.ATTRIBUTE.WATER or
		attribute == lt.Constants.ATTRIBUTE.WIND or
		attribute == lt.Constants.ATTRIBUTE.LIGHT or
		attribute == lt.Constants.ATTRIBUTE.DARK
	then
		--return string.format("%s%.2f%%", signLabel, value / 100)
		return signLabel..value
	elseif
		attribute == lt.Constants.ATTRIBUTE.MP_RECOVER
	then
		return string.format("%s%.2f", signLabel, value / 10000)
	else
		return string.format("%s%.0f", signLabel, value)
	end
end

StringManager._propertyString = nil
function StringManager:getPropertyString(property, longType)
	if not self._propertyString then
		self._propertyString = {
			[0] = {
				[lt.Constants.PROPERTY.NIL]		= self:getString("STRING_COMMON_PROPERTY_NIL"),
				[lt.Constants.PROPERTY.FIRE]	= self:getString("STRING_COMMON_PROPERTY_FIRE"),
				[lt.Constants.PROPERTY.WATER]	= self:getString("STRING_COMMON_PROPERTY_WATER"),
				[lt.Constants.PROPERTY.WIND]	= self:getString("STRING_COMMON_PROPERTY_WIND"),
				[lt.Constants.PROPERTY.LIGHT]	= self:getString("STRING_COMMON_PROPERTY_LIGHT"),
				[lt.Constants.PROPERTY.DARK]	= self:getString("STRING_COMMON_PROPERTY_DARK")
			},
			[1] = {
				[lt.Constants.PROPERTY.NIL]	    = self:getString("STRING_SERVANT_PROPERTY_FILTER_ALL"),
				[lt.Constants.PROPERTY.FIRE]	= self:getString("STRING_COMMON_PROPERTY_FIRE_1"),
				[lt.Constants.PROPERTY.WATER]	= self:getString("STRING_COMMON_PROPERTY_WATER_1"),
				[lt.Constants.PROPERTY.WIND]	= self:getString("STRING_COMMON_PROPERTY_WIND_1"),
				[lt.Constants.PROPERTY.LIGHT]	= self:getString("STRING_COMMON_PROPERTY_LIGHT_1"),
				[lt.Constants.PROPERTY.DARK]	= self:getString("STRING_COMMON_PROPERTY_DARK_1")
			}
		}
	end

	local type = 0
	if longType then
		type = 1
	end

	return self._propertyString[type][property] or ""
end

StringManager._equipmentTypeString = nil
function StringManager:getEquipmentTypeString(type)
	if not self._equipmentTypeString then
		self._equipmentTypeString = {
			[lt.Constants.EQUIPMENT_TYPE.WEAPON]	= self:getString("STRING_EQUIPMENT_TYPE_WEAPON"),
			[lt.Constants.EQUIPMENT_TYPE.ASSISTANT]	= self:getString("STRING_EQUIPMENT_TYPE_ASSISTANT"),
			[lt.Constants.EQUIPMENT_TYPE.HELMET]	= self:getString("STRING_EQUIPMENT_TYPE_HELMET"),
			[lt.Constants.EQUIPMENT_TYPE.CLOTHES]	= self:getString("STRING_EQUIPMENT_TYPE_CLOTHES"),
			[lt.Constants.EQUIPMENT_TYPE.TROUSERS]	= self:getString("STRING_EQUIPMENT_TYPE_TROUSERS"),
			[lt.Constants.EQUIPMENT_TYPE.SHOES]		= self:getString("STRING_EQUIPMENT_TYPE_SHOES"),
			[lt.Constants.EQUIPMENT_TYPE.NECKLACE]	= self:getString("STRING_EQUIPMENT_TYPE_NECKLACE"),
			[lt.Constants.EQUIPMENT_TYPE.RING]		= self:getString("STRING_EQUIPMENT_TYPE_RING"),
			[lt.Constants.EQUIPMENT_TYPE.BELT]		= self:getString("STRING_EQUIPMENT_TYPE_BELT"),
			[lt.Constants.EQUIPMENT_TYPE.ORNAMENT]	= self:getString("STRING_EQUIPMENT_TYPE_ORNAMENT")
		}
	end
	return self._equipmentTypeString[type] or ""
end

StringManager._itemTypeString = nil
function StringManager:getItemTypeString(type)
	if not self._itemTypeString then
		self._itemTypeString = {
			[lt.Constants.ITEM_TYPE.MATERIAL]			= self:getString("STRING_ITEM_TYPE_MATERIAL"),
			[lt.Constants.ITEM_TYPE.PAPER]				= self:getString("STRING_ITEM_TYPE_PAPER"),
			[lt.Constants.ITEM_TYPE.CONSUME]			= self:getString("STRING_ITEM_TYPE_CONSUME"),
			[lt.Constants.ITEM_TYPE.TREASURE]			= self:getString("STRING_ITEM_TYPE_TREASURE"),
			[lt.Constants.ITEM_TYPE.PACKAGE]			= self:getString("STRING_ITEM_TYPE_PACKAGE"),
			[lt.Constants.ITEM_TYPE.VALUE]				= self:getString("STRING_ITEM_TYPE_VALUE"),
			[lt.Constants.ITEM_TYPE.EQUIP_TICKET]		= self:getString("STRING_ITEM_TYPE_EQUIP_TICKET"),
			[lt.Constants.ITEM_TYPE.CHARACTER_SCROLL]	= self:getString("STRING_ITEM_TYPE_CHARACTER_SCROLL"),
			[lt.Constants.ITEM_TYPE.FIGHT_COST]   		= self:getString("STRING_ITEM_TYPE_FIGHT_COST"),
			[lt.Constants.ITEM_TYPE.DECORATION]   		= self:getString("STRING_ITEM_TYPE_PERSONALITY"),
			[lt.Constants.ITEM_TYPE.TASK]   		    = self:getString("STRING_ITEM_TYPE_STRING_13"),
			[lt.Constants.ITEM_TYPE.MEDICAMENT]   		= self:getString("STRING_ITEM_TYPE_STRING_14"),
			[lt.Constants.ITEM_TYPE.SPCIAL_REWARD]   	= self:getString("STRING_ITEM_TYPE_STRING_15"),
			[lt.Constants.ITEM_TYPE.BLOOD]   			= self:getString("STRING_ITEM_TYPE_STRING_16"),
			[lt.Constants.ITEM_TYPE.BUFF_ITEM]   		= self:getString("STRING_ITEM_TYPE_STRING_17"),
			[lt.Constants.ITEM_TYPE.DOUBLE_EXP]   		= self:getString("STRING_ITEM_TYPE_STRING_18"),
			[lt.Constants.ITEM_TYPE.EQUIP_REWARD]   	= self:getString("STRING_ITEM_TYPE_STRING_19"),
			[lt.Constants.ITEM_TYPE.RUNE_REWARD]   		= self:getString("STRING_ITEM_TYPE_STRING_20"),
			[lt.Constants.ITEM_TYPE.CARD_INFO]   		= self:getString("STRING_ITEM_TYPE_STRING_21"),
			[lt.Constants.ITEM_TYPE.GIFT]   			= self:getString("STRING_ITEM_TYPE_STRING_22"),
			[lt.Constants.ITEM_TYPE.TITLE]   			= self:getString("STRING_ITEM_TYPE_STRING_23"),

		}
	end

	return self._itemTypeString[type] or ""
end

StringManager._difficultyString = nil
function StringManager:getDifficultyString(difficulty)
	if not self._difficultyString then
		self._difficultyString = {
			[lt.Constants.DIFFICULTY.NONE]		= self:getString("STRING_DIFFICULTY_NONE"),
			[lt.Constants.DIFFICULTY.NORMAL]	= self:getString("STRING_DIFFICULTY_NORMAL"),
			[lt.Constants.DIFFICULTY.HARD]		= self:getString("STRING_DIFFICULTY_HARD")
		}
	end

	return self._difficultyString[difficulty] or ""
end

StringManager._bagItemString = nil
function StringManager:getbagItemString(type)
	if not self._bagItemString then
		self._bagItemString = {
			[lt.Constants.BAGITEM.ALL]		= self:getString("STRING_ALL"),
			[lt.Constants.BAGITEM.EQUIP]	= self:getString("STRING_EQUIPMENT"),
			[lt.Constants.BAGITEM.ITEM]		= self:getString("STRING_ITEM")
		}
	end

	return self._bagItemString[type] or ""
end

-- 根据装备品质获取对应类型名字
StringManager._equipmentQualityString = nil
function StringManager:getEquipmentQualityString(quality)
	if not self._equipmentQualityString then
		self._equipmentQualityString = {
			[lt.Constants.QUALITY.QUALITY_WHITE]	= self:getString("STRING_EQUIP_QUALITY_NORMAL"),
			[lt.Constants.QUALITY.QUALITY_GREEN]	= self:getString("STRING_EQUIP_QUALITY_ELITE"),
			[lt.Constants.QUALITY.QUALITY_BLUE]		= self:getString("STRING_EQUIP_QUALITY_EXCELLENT"),
			[lt.Constants.QUALITY.QUALITY_PURPLE]	= self:getString("STRING_EQUIP_QUALITY_EPIC"),
			[lt.Constants.QUALITY.QUALITY_ORANGE]	= self:getString("STRING_EQUIP_QUALITY_LEGEND"),
		}
	end

	return self._equipmentQualityString[quality] or ""
end

-- 根据商店ID获取商店名字
function StringManager:getShopNameString(shopId)
	if not self._shopNameString then
		self._shopNameString = {
			[lt.Constants.SHOP_TYPE.SHOP]		= self:getString("STRING_COMMON_SHOP"),
			[lt.Constants.SHOP_TYPE.BLACKSHOP]	= self:getString("STRING_COMMON_BALCKSHOP"),
			[lt.Constants.SHOP_TYPE.STALL]		= self:getString("STRING_COMMON_STALL")
		}
	end
	return self._shopNameString[shopId] or ""
end

-- 根据宝箱TYPE获取宝箱名字
function StringManager:getBoxNameString(type)
	if not self._boxNameString then
		self._boxNameString = {
			[lt.Constants.BOX_TYPE.SILVER]		= self:getString("STRING_COMMON_BOX_SILVER"),
			[lt.Constants.BOX_TYPE.GOLD]		= self:getString("STRING_COMMON_BOX_GOLD"),
			[lt.Constants.BOX_TYPE.ANCIENT]		= self:getString("STRING_COMMON_BOX_ANCIENT")
		}
	end
	return self._boxNameString[type] or ""
end

-- 特殊格式字符串 +10% +10.1%
function StringManager:propertyString(propertyRate)
    local sign = ""
    if propertyRate > 0 then
        sign = "+"
    elseif propertyRate < 0 then
        sign = "-"
    end

    return sign .. math.abs(propertyRate / 10) .. "%"
end

return StringManager

