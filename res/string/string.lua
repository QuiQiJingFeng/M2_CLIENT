stringTable = {}
ltMetaTable = {}
setmetatable(stringTable, ltMetaTable)

ltMetaTable.__index = function(table, name)
	print("__________________", name)
    table[name] = require(ltMetaTable[name])
    return table[name]
end

stringTable["STRING_INIT_GAME"] 				= "技术的开发建设的开发都是"
stringTable["STRING_CHECK_GAME"]			= "技术的开发建设的开发都是"
stringTable["STRING_INIT_DATA"]			= "技术的开发建设的开发都是"

stringTable["STRING_INIT_RESOURCE"]  			= "技术的开发建设的开发都是"
stringTable["STRING_INIT_OTHER"]   			= "技术的开发建设的开发都是"
stringTable["STRING_INIT_END"]   			= "技术的开发建设的开发都是"