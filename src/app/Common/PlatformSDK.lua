local PlatformSDK = {}
local meta = {}
setmetatable(PlatformSDK,meta)

meta.__index = function(tb,key)
	return function(...)
		FYDSDK.excute(key,...)
	end
end

return PlatformSDK