local user = {}

function user:init(user_id,reconnect_token)
	self.user_id = user_id
	self.reconnect_token = reconnect_token
end

function user:logout()
	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedule_id)
end

function user:setRoomInfo(room_info)
	self.room_info = room_info
end



return user