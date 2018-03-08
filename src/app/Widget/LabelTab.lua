
local LabelTab = class("LabelTab", function()
	return display.newNode()
end)

LabelTab._buttonArray = {}
LabelTab._currTag = 1
LabelTab._padding = 10
LabelTab._width = 8
local state = {}
function LabelTab:ctor(padding)
	self._currTag = 1
	self._buttonArray = {}
	if padding then
		self._padding = padding
	end
end

function LabelTab:addButton(title, pic, onButtonClicked, enable)
	local button = lt.PushButton.new(pic)
	button.pic = pic
	local count = #self._buttonArray
	local x = 0
	if count == 0 then
		x = self._width
		button:setButtonImage(lt.PushButton.NORMAL,button.pic.pressed)
	end

    button:setPosition(x, -count*(self._padding+76))
    button:setScale(lt.CacheManager:getWinScale())
    button:setTag(count+1)
    button:onButtonClicked(onButtonClicked)
    button:onButtonRelease(handler(self,self.onButtonRelease))
    if enable == nil then enable = true end
    button.enable = enable
    self:addChild(button)

    self._buttonArray[count+1] = button

    return self
end

function LabelTab:onButtonRelease(event)
	local button = event.target
	if button:getTag() == self._currTag or not button.enable then
		return
	end

	self._currTag = button:getTag()
	for k,v in pairs(self._buttonArray) do
		v:setPositionX(0)
		v:setButtonImage(lt.PushButton.NORMAL,v.pic.normal)
	end
	button:setPositionX(self._width)
	button:setButtonImage(lt.PushButton.NORMAL,button.pic.pressed)
end

function LabelTab:changeTab(tag)
	for k,v in pairs(self._buttonArray) do
		if v:getTag() == tag then
			v:setPositionX(self._width)
			v:setButtonImage(lt.PushButton.NORMAL,v.pic.pressed)
		else
			v:setPositionX(0)
			v:setButtonImage(lt.PushButton.NORMAL,v.pic.normal)
		end
		
	end
	self._currTag = tag
end

function LabelTab:getButtonByTag(tag)
	return self._buttonArray[tag]
end

return LabelTab
