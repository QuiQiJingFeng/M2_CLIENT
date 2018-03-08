
local GameMenuTab = class("GameMenuTab", function()
	return display.newNode()
end)

GameMenuTab._buttonArray = {}
GameMenuTab._currTag = 1
GameMenuTab._padding = 10
GameMenuTab._width = 8
local state = {}
function GameMenuTab:ctor(padding)
	self._currTag = 1
	self._buttonArray = {}
	if padding then
		self._padding = padding
	end
end

function GameMenuTab:addButton(title, pic, onButtonClicked, enable, tag)
	local button = lt.PushButton.new({normal = "#common_btn_normal_gray.png", pressed = "#common_btn_select_blue.png"})
	local count = self:getCount()
	local rTag = tag or count + 1
	local x = 0
	if count == 0 then
		button:setButtonImage(lt.PushButton.NORMAL,"#common_btn_select_blue.png")
	end

	if pic then
		local image = display.newSprite(pic)
		image:setPosition(0,0)
		button:addChild(image,10)
	end

	-- if title then
	-- 	local title = lt.GameBMLabel.new(title, "select_btn.fnt")
 --        title:setAnchorPoint(0.5, 0)
 --        title:setPosition(0, -40)
 --        button:addChild(title,11)
	-- end



	button._buttonClicked = onButtonClicked
    button:setPosition(x, -count*(self._padding + 70))
    button:setScale(lt.CacheManager:getWinScale())
    button:setTag(rTag)
    button:onButtonClicked(handler(self,self.onButtonClicked))
    button:onButtonRelease(handler(self,self.onButtonRelease))
    if enable == nil then enable = true end
    button.enable = enable
    self:addChild(button)

    self._buttonArray[rTag] = button

    local newCount = self:getCount()
    if newCount > rTag then
    	button:setPosition(x, -(rTag-1)*(self._padding + 70))

    	for idx=rTag+1,newCount do
    		local btn = self._buttonArray[idx]
    		if btn then
    			local y = btn:getPositionY()
    			btn:setPositionY(y-self._padding-70)
    		end
    	end
    end

    return self
end

function GameMenuTab:onButtonClicked(event)
	local button = event.target

	if button:getTag() == self._currTag then
		return
	end

    for k,v in pairs(self._buttonArray) do
     v:setButtonImage(lt.PushButton.NORMAL,"#common_btn_normal_gray.png")
    end

    button:setButtonImage(lt.PushButton.NORMAL,"#common_btn_select_blue.png")

	self._currTag = button:getTag()
	button._buttonClicked(event)
end


function GameMenuTab:onButtonRelease(event)
	-- local button = event.target

	-- for k,v in pairs(self._buttonArray) do
	-- 	v:setButtonImage(lt.PushButton.NORMAL,"#common_btn_normal_gray.png")
	-- end

	-- button:setButtonImage(lt.PushButton.NORMAL,"#common_btn_select_blue.png")
end

function GameMenuTab:changeTab(tag)
	for k,v in pairs(self._buttonArray) do
		if v:getTag() == tag then
			v:setButtonImage(lt.PushButton.NORMAL,"#common_btn_select_blue.png")
		else
			v:setButtonImage(lt.PushButton.NORMAL,"#common_btn_normal_gray.png")
		end
		
	end
	self._currTag = tag
end

function GameMenuTab:getButtonByTag(tag)
	return self._buttonArray[tag]
end

function GameMenuTab:addTabNoticeByTag(tag)
    if self._buttonArray[tag] and not self._buttonArray[tag]:getChildByTag(100) then
        local servantNotice = ccs.Armature:create("uieffect_new_icon")
        servantNotice:getAnimation():playWithIndex(0)
        servantNotice:setPosition(38, 38)
        servantNotice:setTag(100)
        self._buttonArray[tag]:addChild(servantNotice, 100)      
    end
    return self._buttonArray[tag]:getChildByTag(100)
end

function GameMenuTab:setTabNoticeVisibleByTag(tag, bool)
    if self._buttonArray[tag] then
        if self._buttonArray[tag]:getChildByTag(100) then
            self._buttonArray[tag]:getChildByTag(100):setVisible(bool)
        end
    end
end

function GameMenuTab:getCount()
	local count = 0
	for _,button in pairs(self._buttonArray) do
		count = count + 1
	end
	return count
end

return GameMenuTab
