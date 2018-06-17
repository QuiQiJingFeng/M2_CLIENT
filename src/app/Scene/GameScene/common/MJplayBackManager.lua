local MJplayBackManager = class("MJplayBackManager")


function MJplayBackManager:CreateReplay()
	self._rePlayingState = true

	local scheduler = cc.Director:getInstance():getScheduler()
	self.schedule = scheduler:scheduleScriptFunc(function(dt)
    	self:onUpdate(dt)
	end,0,false)
	self._tempTime = 2
	self._playTime = 1

	self._data = lt.DataManager:getReplayDataDispose()
	self._playDate = {}
	self._num = 0

	return self
end

function MJplayBackManager:StopReplay()
	self._rePlayingState = false
end

function MJplayBackManager:StarReplay()
	self._rePlayingState = true
	self._tempTime = 0
end

function MJplayBackManager:closeReplay()
    if self.schedule then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedule)
	end
end

function MJplayBackManager:addSpeed(dt)
	self._playTime = 0.5
end

function MJplayBackManager:surSpeed(dt)
	self._playTime = 1.5
end

function MJplayBackManager:onUpdate(dt)

	if not self._rePlayingState then
		return
	end

	self._tempTime = self._tempTime + dt

	if self._tempTime >= self._playTime then
		print("==222lkkkkkkkkkkkkkkkkk")

		self._tempTime = 0

		self._num = self._num + 1 
		self._playDate = self._data[self._num]

		if not self._playDate then
			self:closeReplay()
			return
		end

		if self._num  == 1 then
			dump(self._playDate, "deal_card")
			lt.GameEventManager:post("deal_card", self._playDate)
		else

			if self._num == 3 then
				--self:StopReplay()
			end

			---dump(self._playDate, "对方电大幅度")
			self._playDate = json.decode(self._playDate)
			for eventName,msg in pairs(self._playDate) do
				dump(eventName)
				lt.GameEventManager:post(eventName, msg)
			end
		end


	end
end

return MJplayBackManager