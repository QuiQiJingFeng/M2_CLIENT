stringTable = {}
ltMetaTable = {}
setmetatable(stringTable, ltMetaTable)

ltMetaTable.__index = function(table, name)
	print("__________________", name)
    table[name] = require(ltMetaTable[name])
    return table[name]
end

stringTable["STRING_GAME_NAME_1"] 				= "红中麻将"
stringTable["STRING_GAME_NAME_2"]			= "斗地主"
