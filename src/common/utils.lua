local utils = {}

--获取延迟时间
function utils:ping(url)
	local str = string.format("ping -c 1 -i 0.5 -W 300 %s",url)
	local t = io.popen(str)
	local s = t:read("*all")
	local time = string.gmatch(s,".time=(.-) ms")() or -1
	return time
end

return utils