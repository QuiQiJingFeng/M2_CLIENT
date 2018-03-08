
-- 骨骼动画
local SkeletonAnimation = class("SkeletonAnimation", function(file, scale, retainData)
	local skel  = file .. ".skel"
	local atlas = file .. ".atlas"

	scale = scale or 1
	retainData = retainData or false

	return sp.SkeletonAnimation:createWithBinaryFile(skel, atlas, scale, retainData)
end)

return SkeletonAnimation