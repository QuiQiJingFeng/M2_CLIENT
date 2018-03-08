
-- 骨骼动画
local SpSkeletonAnimation = class("SpSkeletonAnimation", function(skel, atlas, scale, retainData)
	scale = scale or 1
	retainData = retainData or false

	return sp.SkeletonAnimation:createWithBinaryFile(skel, atlas, scale, retainData)
end)

return SpSkeletonAnimation
