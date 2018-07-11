local sdk = {}
local meta = {}
setmetatable(sdk,meta)

meta.__index = function(tb,className)

	local internal = {}
	local internal_meta = {}
	setmetatable(internal,internal_meta)
	internal_meta.__index = function(tb,funcName)
		if device.platform == "ios" or device.platform == "android" then
			return function(...)
				return __FYDSDK__.excute(className,funcName,...)
			end
		else
			return function() end
		end
	end

	return internal
end

if device.platform == "android" then
	if __FYDSDK__.setJavaSearchPath then
		local searchs = {
			"com/common",
			"com/mengya/game",
			"com/mengya/wechat"
		}
		__FYDSDK__.setJavaSearchPath(searchs)
	end
end

return sdk