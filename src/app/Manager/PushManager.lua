local PushManager = {}
local ACTIVITY_PUSH_TAG = "activity_push_tag"
function PushManager:init()
	local activityPushTable = lt.CacheManager:getActiveActivityPushArray()

	-- if not lt.PreferenceManager:getNoticeInited() then
	-- 	for _,activityPush in pairs(activityPushTable) do
	-- 		if activityPush:getDefaultOpen() == 1 then
	-- 			lt.PreferenceManager:setNoticeSetting(activityPush:getTag(),true)
	-- 		end
	-- 	end

	-- 	lt.PreferenceManager:noticeInited()
	-- end

	if not lt.PreferenceManager:getPushtipsOn() then--设置界面 推送总开关
		return
	end

	if lt.PreferenceManager:getNoticeInited() then
		return
	end
	lt.PreferenceManager:setNoticeInited(true)

	for _,activityPush in pairs(activityPushTable) do

		for k,day in pairs(activityPush:getOpenWeekDay()) do--星期
			if lt.DataManager:getActivityCallmeSwitch(activityPush:getId()) then--开关打开
				if device.platform == "ios" or device.platform == "android" then

					local openTime = activityPush:getDailyOpenTime()
				    if openTime then
				    	--lt.CommonUtil.print("添加手机推送"..ACTIVITY_PUSH_TAG..activityPush:getId()..day..openTime.hour..openTime.min)
				    	cpp.GamePlatform:addPush(ACTIVITY_PUSH_TAG..activityPush:getId()..day..openTime.hour..openTime.min, activityPush:getPushInformation(), openTime.hour, openTime.min, day - 1)
					else--多时间段
				        local mulTime = activityPush:getIntervalActivityTime()
				        if mulTime then
				        	for k,auto in pairs(mulTime) do
				        		--lt.CommonUtil.print("添加手机推送"..ACTIVITY_PUSH_TAG..activityPush:getId()..day..auto[1]..auto[2])
								cpp.GamePlatform:addPush(ACTIVITY_PUSH_TAG..activityPush:getId()..day..auto[1]..auto[2], activityPush:getPushInformation(), auto[1], auto[2], day - 1)
				            end
				        end
					end
				end
			else
				if device.platform == "ios" or device.platform == "android" then
					local openTime = activityPush:getDailyOpenTime()

					local openTime = activityPush:getDailyOpenTime()
				    if openTime then
				    	--lt.CommonUtil.print("取消手机推送"..ACTIVITY_PUSH_TAG..activityPush:getId()..day..openTime.hour..openTime.min)
				    	cpp.GamePlatform:removePush(ACTIVITY_PUSH_TAG..activityPush:getId()..day..openTime.hour..openTime.min)
					else--多时间段
				        local mulTime = activityPush:getIntervalActivityTime()
				        if mulTime then
				        	for k,auto in pairs(mulTime) do
				        		--lt.CommonUtil.print("取消手机推送"..ACTIVITY_PUSH_TAG..activityPush:getId()..day..auto[1]..auto[2])
								cpp.GamePlatform:removePush(ACTIVITY_PUSH_TAG..activityPush:getId()..day..auto[1]..auto[2])
				            end
				        end
					end
				end
			end
		end
	end
end

function PushManager:addPush(activityId)
	local activityPush = lt.CacheManager:getActivityInfo(activityId)
	if not activityPush then
		return
	end
	if device.platform == "ios" or device.platform == "android" then
		for k,day in pairs(activityPush:getOpenWeekDay()) do--星期
			local openTime = activityPush:getDailyOpenTime()
		    if openTime then
		    	--lt.CommonUtil.print("添加手机推送"..ACTIVITY_PUSH_TAG..activityPush:getId()..day..openTime.hour..openTime.min)
		    	cpp.GamePlatform:addPush(ACTIVITY_PUSH_TAG..activityPush:getId()..day..openTime.hour..openTime.min, activityPush:getPushInformation(), openTime.hour, openTime.min, day - 1)
			else--多时间段
		        local mulTime = activityPush:getIntervalActivityTime()
		        if mulTime then
		        	for k,auto in pairs(mulTime) do
		        		--lt.CommonUtil.print("添加手机推送"..ACTIVITY_PUSH_TAG..activityPush:getId()..day..auto[1]..auto[2])
						cpp.GamePlatform:addPush(ACTIVITY_PUSH_TAG..activityPush:getId()..day..auto[1]..auto[2], activityPush:getPushInformation(), auto[1], auto[2], day - 1)
		            end
		        end
			end
		end
	end
end

function PushManager:removePush(activityId)
	local activityPush = lt.CacheManager:getActivityInfo(activityId)
	if not activityPush then
		return
	end

	if device.platform == "ios" or device.platform == "android" then
		for k,day in pairs(activityPush:getOpenWeekDay()) do--星期
			local openTime = activityPush:getDailyOpenTime()

			local openTime = activityPush:getDailyOpenTime()
		    if openTime then
		    	--lt.CommonUtil.print("取消手机推送"..ACTIVITY_PUSH_TAG..activityPush:getId()..day..openTime.hour..openTime.min)
		    	cpp.GamePlatform:removePush(ACTIVITY_PUSH_TAG..activityPush:getId()..day..openTime.hour..openTime.min)
			else--多时间段
		        local mulTime = activityPush:getIntervalActivityTime()
		        if mulTime then
		        	for k,auto in pairs(mulTime) do
		        		--lt.CommonUtil.print("取消手机推送"..ACTIVITY_PUSH_TAG..activityPush:getId()..day..auto[1]..auto[2])
						cpp.GamePlatform:removePush(ACTIVITY_PUSH_TAG..activityPush:getId()..day..auto[1]..auto[2])
		            end
		        end
			end
		end
	end
end

return PushManager
