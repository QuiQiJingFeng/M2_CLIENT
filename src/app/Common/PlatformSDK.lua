local PlatformSDK = {}
local meta = {}
setmetatable(PlatformSDK,meta)

meta.__index = function(tb,key)
	return function(...)
		return FYDSDK.excute(key,...)
	end
end

local ret = FYDSDK.setJavaSearchPath({
				"com/mengya/common",
				"com/mengya/game",
				"com/mengya/wechat"
			})
if ret then
	print("FYD ERROR-->",ret)
end

return PlatformSDK