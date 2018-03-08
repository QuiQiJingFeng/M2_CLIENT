local DeleteConfirmLayer = class("DeleteConfirmLayer", lt.CommonPopupSmallLayer)

DeleteConfirmLayer._updateHandler = nil

DeleteConfirmLayer.TYPE = {
							HERO  =  1,--删除角色
							GUILD =  2,--删除公会
						}
function DeleteConfirmLayer:ctor(info, type, callback)
	self:setNodeEventEnabled(true)

	DeleteConfirmLayer.super.ctor(self)
	self._deleteType = type
	self._callBack = callback

	local titleStr = lt.StringManager:getString("STRING_COMMON_COMMIT_TITLE")
	self:setTitle(titleStr)

	local infoBgSize = cc.size(558, 305)
	self._infoBg = lt.GameNewPanel.new(lt.GameNewPanel.TYPE.NEW_WHITE, self._bg:getContentSize().width / 2, self._bg:getContentSize().height - 38 * self._winScale, infoBgSize)
	self._infoBg:setScale(self._winScale)
	self._infoBg:setAnchorPoint(0.5, 1)
	self._bg:addChild(self._infoBg)

	local textLabel = lt.RichText.new()
	textLabel:setPosition(self._infoBg:getContentSize().width/2, 240)
	textLabel:setAutoSize(true, 500)
	self._bg:addChild(textLabel)


	if type == self.TYPE.HERO then
		local text = lt.RichTextText.new(lt.StringManager:getString("STRING_DELETE_CONFIRM"), lt.Constants.FONT_SIZE2, lt.Constants.DEFAULT_LABEL_COLOR_2)
	    textLabel:insertElement(text)

	    if info then
	    	self._loginPlayer = info
	    	local str = "("..info.name..",Lv."..info.level..")"
	    	local text2 = lt.RichTextText.new(str, lt.Constants.FONT_SIZE2, lt.Constants.COLOR.LIGHT_BLUE)
	    	textLabel:insertElement(text2)
	    end
	elseif type == self.TYPE.GUILD then
		local text = lt.RichTextText.new(lt.StringManager:getString("STRING_DELETE_GUILD"), lt.Constants.FONT_SIZE2, lt.Constants.DEFAULT_LABEL_COLOR_2)
	    textLabel:insertElement(text)

	    if info then
	    	self._guildInfo = info
	    	local str = "("..info:getName()..",Lv."..info:getLevel()..")"
	    	local text2 = lt.RichTextText.new(str, lt.Constants.FONT_SIZE2, lt.Constants.COLOR.LIGHT_BLUE)
	    	textLabel:insertElement(text2)
	    end
	end
	
    local text3 = lt.RichTextText.new("?", lt.Constants.FONT_SIZE2, lt.Constants.DEFAULT_LABEL_COLOR_2)
    textLabel:insertElement(text3)

	local commitStr = "STRING_COMMON_COMMIT"
	local commitBtn = lt.ScaleBMLabelButton.newYellow(commitStr, "select_btn.fnt")
	commitBtn:setPosition(self._infoBg:getContentSize().width / 2 + 115, 60)
	commitBtn:onButtonClicked(handler(self, self.onCommit))
	self._infoBg:addChild(commitBtn)

	self._cancelStr = "STRING_COMMON_CANCEL"
	self._cancelBtn = lt.ScaleBMLabelButton.newBlue(self._cancelStr, "select_btn.fnt")
	self._cancelBtn:setPosition(self._infoBg:getContentSize().width / 2 - 115, 60)
	self._cancelBtn:onButtonClicked(handler(self, self.onCancel))
	self._infoBg:addChild(self._cancelBtn)

	-- 自动取消倒计时
	self._cancelCountdown = 10
end

function DeleteConfirmLayer:onEnter()
	if self._cancelCountdown then	
		-- 开启倒计时
		self._cancelElapse = 0

		self._updateHandler = lt.scheduler.scheduleUpdateGlobal(handler(self, self.onUpdate))
	end
end

function DeleteConfirmLayer:onExit()
	if self._updateHandler then
		lt.scheduler.unscheduleGlobal(self._updateHandler)
		self._updateHandler = nil
	end
end

function DeleteConfirmLayer:onUpdate(delta)
	self._cancelElapse = self._cancelElapse + delta

	if self._cancelElapse > self._cancelCountdown then
		-- 倒计时结束
		self:onCancel()
		return
	end

	-- 倒计时显示
	local cancelStr = string.format("%s(%.0f)", lt.StringManager:getString(self._cancelStr), math.max(0, self._cancelCountdown - self._cancelElapse))

	self._cancelBtn:setString(cancelStr)
end


function DeleteConfirmLayer:onCommit()
	if not self._deleteType  then
		return
	end

	if self._deleteType == self.TYPE.HERO then
		if self._loginPlayer then
			lt.SocketApi:deletePlayer(self._loginPlayer.id)
		end
	elseif self._deleteType == self.TYPE.GUILD then
		if self._guildInfo then
			lt.SocketApi:deleteGuild()
		end
	end
	self:close()
end

function DeleteConfirmLayer:onCancel()
	self:close()
end

function DeleteConfirmLayer:onClose()
	self:close()
end

function DeleteConfirmLayer:close()
	if self._deleteType == self.TYPE.HERO then
		self:removeFromParent()
	elseif self._deleteType == self.TYPE.GUILD then
		lt.UILayerManager:removeLayer(self)
	end
end

return DeleteConfirmLayer
