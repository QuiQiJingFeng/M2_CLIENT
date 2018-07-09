local MsgboxLayer = class("MsgboxLayer")

-- @param dataTable
-- @param dataTable.txtCoutent
function MsgboxLayer:ctor()

end

-- @param txtContent 	显示内容
-- @param isOneBtn		是否只有一个btn
-- @param sureFunc		确定按钮的回调
-- @param cancelFunc	取消按钮的回调
-- @param isCloseBox	回调完之后是否自动关闭弹窗
-- @param iClockTime	闹钟时间
function MsgboxLayer:showMsgBox(txtContent, isOneBtn, sureFunc, cancelFunc, isCloseBox, iClockTime)

	self.layer = cc.CSLoader:createNode("game/common/MsgBoxLayer.csb")

	-- local parent = self.layer:getParent()
	-- print("PARENT = ",parent)
	-- if not self.layer:getParent() then
	-- 	local scene = cc.Director:getInstance():getRunningScene()
	-- 	scene:addChild(self.layer)
	-- end
	lt.UILayerManager:addLayer(self.layer,true)	
	
	local blackBg = self.layer:getChildByName("Ie_Mark")
	-- 设置屏蔽下面所有事件
	-- blackBg:setTouchSwallowEnabled(true)
	blackBg:setSwallowTouches(true)

	local boxBg = self.layer:getChildByName("Ie_Bg")

	-- 显示的文字
	local txtCoutent = boxBg:getChildByName("Tt_Countent")
	-- 确定按钮
	local btnSure = boxBg:getChildByName("Bn_Sure")
	-- 取消按钮
	local btnCancel = boxBg:getChildByName("Bn_Cancel")
	-- 倒计时时间显示
	local txtClock = boxBg:getChildByName("Text_Clock")

	-- 默认设置为空
	txtClock:setString("")
	txtCoutent:setString("")

	self.boxBg = boxBg
	self.txtClock = txtClock
	self.txtCoutent = txtCoutent
	self.btnSure = btnSure
	self.btnCancel = btnCancel


	txtContent = txtContent or "当前传的显示内容为空, 请检查"
	isOneBtn = isOneBtn == true and 1 or 2
	sureFunc = sureFunc or nil
	cancelFunc = cancelFunc or nil
	isCloseBox = isCloseBox == nil and true or isCloseBox

	iClockTime = iClockTime or 0

	-- 设置显示内容
	self:setCoutentString(txtContent)
	-- 设置点击按钮
	self:setBtnShowtType(isOneBtn)
	-- 设置点击时间
	self:setSureClick(sureFunc, isCloseBox)
	self:setCancelClick(cancelFunc, isCloseBox)

	self:setClock(iClockTime)
end


function MsgboxLayer:setCoutentString( __string )
	__string = __string or ""
	self.txtCoutent:setString( tostring(__string))
end

-- 设置按钮显示方式
-- @param iNums 按钮的个数1/2
function MsgboxLayer:setBtnShowtType( iNums )
	local size = self.boxBg:getContentSize()
	if iNums == 1 then
		self.btnCancel:setVisible(false)
		self.btnSure:setVisible(true)
		self.btnSure:setPositionX(size.width / 2)
	else
		self.btnSure:setVisible(true)
		self.btnCancel:setVisible(true)

		self.btnSure:setPositionX(size.width / 4)
		self.btnCancel:setPositionX(size.width / 4 * 3)
	end
end

-- 设置同意的点击事件
-- @param func 
-- @param isClose  after onClick close MsgBox 
-- @param isScale
function MsgboxLayer:setSureClick( func, isClose, isScale )
	lt.CommonUtil:addNodeClickEvent(self.btnSure, function( ... )
		if isClose then
			self:onClose()
		end
		if func then
			func()
		end



	end, isScale)
end

-- 设置取消的点击事件
-- @param func 
-- @param isClose  after onClick close MsgBox 
-- @param isScale
function MsgboxLayer:setCancelClick( func, isClose, isScale )
	lt.CommonUtil:addNodeClickEvent(self.btnCancel, function( ... )
		if isClose then
			self:onClose()
		end
		if func then
			func()
		end

	end, isScale)
end


function MsgboxLayer:setClock( iTime )
	iTime = tonumber(iTime) or 0 

	if iTime <= 0 then
		self.txtClock:setString("")
		return
	end

	self.txtClock:setString(iTime)
	self.txtClock:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function()
		iTime = iTime - 1
		self.txtClock:setString(iTime)

		if iTime <= 0 then
			self.txtClock:stopAllActions()
			self:onClose()
		end
	end))) )
end

function MsgboxLayer:closeClock( )
	self.txtClock:stopAllActions()
	self.txtClock:setString("")
end


function MsgboxLayer:onClose( ... )
	lt.UILayerManager:removeLayer(self.layer)
	-- print("MsgBox Close")
	-- self.txtClock:stopAllActions()
	
	-- if tolua.isnull(self.layer) == true then
	-- 	print("MsgBox 已经被销毁，不能再次释放")
	-- else
	-- 	self.layer:removeSelf()
	-- 	local parent = self.layer:getParent()
	-- 	print("FYD====>>>>>>PARENT IS =>",parent)
	-- end
end




return MsgboxLayer
