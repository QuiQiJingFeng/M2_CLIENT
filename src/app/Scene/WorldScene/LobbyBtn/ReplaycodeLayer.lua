local ReplaycodeLayer = class("ReplaycodeLayer", function()
    return cc.CSLoader:createNode("game/common/RecordCodeLayer.csb")
end)

function ReplaycodeLayer:ctor()
	local Ie_Bg = self:getChildByName("Ie_Bg")
	local Bn_Sure = Ie_Bg:getChildByName("Bn_Sure")--确认
	local Bn_Cancel = Ie_Bg:getChildByName("Bn_Cancel")--取消

	self._text_Place = self:getChildByName("Text_Place")--预设文本
	self._text_Input = self:getChildByName("Text_Input")--输入文本
	self._text_Input:setText("")
	


	local btn_close = self:getChildByName("btn_close")--返回
	
	local Panel_KeyBoard = self:getChildByName("Panel_KeyBoard")--按键

	self._numberText = ""

	for i=1,10 do
		local Nodenum = i-1
		local keyNum = Panel_KeyBoard:getChildByName("Ie_"..Nodenum)
		keyNum:setTag(i - 1)
		lt.CommonUtil:addNodeClickEvent(keyNum, handler(self, self.onClickNumKey))
	end
	
	self._ie_reset = Panel_KeyBoard:getChildByName("Ie_reset")--重输
	self._ie_dele = Panel_KeyBoard:getChildByName("Ie_dele")--删除

	lt.CommonUtil:addNodeClickEvent(Bn_Sure, handler(self, self.onSure))
	lt.CommonUtil:addNodeClickEvent(btn_close, handler(self, self.onclose))
	lt.CommonUtil:addNodeClickEvent(self._ie_reset, handler(self, self.onReset))
	lt.CommonUtil:addNodeClickEvent(self._ie_dele, handler(self, self.onDele))
	
end

function ReplaycodeLayer:onSure(event)
	--接口
end
function ReplaycodeLayer:onClickNumKey(event)
	if string.len(self._numberText) >= 8 then--最多输入的个数	
		return
	end
	print("===========输入数字==========",event:getTag())
	self._numberText = self._numberText..event:getTag()

	if string.len(self._numberText) >= 1 then--
		self._text_Place:setText("")
	end

	print("=====内容字符串的长度======",string.len(self._numberText))

	self._text_Input:setText(self._numberText)
	
end

function ReplaycodeLayer:onReset(event)
	self._numberText = ""
	self._text_Input:setText(self._numberText)
	self._text_Place:setText("请输入回放码")
end

function ReplaycodeLayer:onDele(event)
	local lenNum = string.len(self._numberText)
	self._numberText = string.sub(self._numberText,1,lenNum-1)
	print("====1=1=1=1=",self._numberText)
	self._text_Input:setText(self._numberText)
	if string.len(self._numberText) < 1 then
		self._text_Place:setText("请输入回放码")
	end
end

function ReplaycodeLayer:onclose(event)
	lt.UILayerManager:removeLayer(self)
end

return ReplaycodeLayer