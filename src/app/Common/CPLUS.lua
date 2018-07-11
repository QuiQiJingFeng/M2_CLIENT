local CPLUS = {}
local meta = {}
setmetatable(CPLUS,meta)

meta.__index = function(tb,className)

	local internal = {}
	local internal_meta = {}
	setmetatable(internal,internal_meta)
	internal_meta.__index = function(tb,funcName)
		return function(...)
			return __FYDC__.excute(className,funcName,...)
		end
	end

	return internal
end

return CPLUS