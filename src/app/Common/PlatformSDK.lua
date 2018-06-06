local PlatformSDK = {}
local meta = {}
setmetatable PlatformSDK,meta)

meta.__index = function(tb,key)
	return function(...)
		FYDDSK.excute(key,...)
	end
end

return PlatformSDK