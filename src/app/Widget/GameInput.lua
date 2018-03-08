local GameInput = class("GameInput", cc.ui.UIInput)

GameInput._listener = nil
GameInput._warningTips = false
GameInput._warningStr  = ""
--是否显示屏蔽字符
GameInput._showWarningStr = false
GameInput._isWarnStr = true --屏蔽非法字符 yes/no
function GameInput:ctor(options)
	if options.listener then
		self._listener = options.listener
	end

	self._warningTips = options.warningTips
	self._warningStr  = options.warningStr
	self._showWarningStr = options.showWarningStr

	if options.isWarnStr ~= nil then
		-- 是否屏蔽非法字符
		self._isWarnStr = options.isWarnStr
	end

	-- 注册为自己的监听事件
	self:registerScriptEditBoxHandler(handler(self, self.onEdit))
end

function GameInput:onEdit(event, editbox)
    if event == "began" then
	elseif event == "changed" then
	elseif event == "ended" then
		-- 屏蔽字处理
		if self._isWarnStr then
			local text = string.trim(self:getText())--过滤两边空格
			local hasWarning, str = lt.WarnStrFunc:warningStrGsub(text)
			if hasWarning and not self._showWarningStr then
				self:setText(str)
				
				if self._warningTips then
					-- 屏蔽字提示
					lt.TipsLayer:tipsOn(self._warningStr)
				end
			end
		end
	end

	if self._listener then
		self._listener(event, editbox)
	end
end

return GameInput