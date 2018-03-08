
-- ################################################## 世界界面(实例世界) ##################################################
local WorldLayer = class("WorldLayer", function()
	return display.newLayer()
end)

WorldLayer._worldScene   = nil
WorldLayer._worldMenuLayer = nil
WorldLayer._wolrdUILayer = nil

WorldLayer._worldMapId = 0
-- WorldLayer._worldMapId = 200

WorldLayer._worldEntity = nil

local noUIDebug = false

-- temp
WorldLayer._winScale = lt.CacheManager:getWinScale()

function WorldLayer:ctor(worldScene)

	self:setNodeEventEnabled(true)

	self._worldScene = worldScene

	-- 创建/注册 世界实例
	self._worldEntity = lt.WorldEntity.new(self)
	lt.EntityManager:registerWorldEntity(self._worldEntity)

	if noUIDebug then
		-- 遥控杆
	    self._joystickBg = display.newSprite("#control_joystick_bg.png")
	    self._joystickBg:pos(self._directionLocation.x, self._directionLocation.y)
	    self:addChild(self._joystickBg, 100)

	    self._joystick = display.newSprite("#control_joystick.png")
	    self._joystick:pos(self._directionLocation.x, self._directionLocation.y)
	    self:addChild(self._joystick, 101)

	    -- 右边操作按钮
	    self._controlNode = display.newNode()
	    self:addChild(self._controlNode, 100)

	    -- 跳跃按钮
	    self._jumpButton = display.newSprite("#control_btn_jump.png")
	    self._jumpButton:setScale(self._winScale)
	    self._jumpButton:setPosition(display.width, display.bottom + 8 * self._winScale)

	    self._controlNode:addChild(self._jumpButton)

	    -- 攻击按钮
	    self._attackButton = display.newSprite("#battle_btn_atk.png")
	    self._attackButton:setScale(self._winScale)
	    self._attackButton:setPosition(display.width - 96 * self._winScale, display.bottom + 112 * self._winScale)
	    self._controlNode:addChild(self._attackButton)

	    -- 攻击图标
	    local occupationId = lt.DataManager:getOccupation()
	    local attackPic = "#battle_btn_atk_pic_"..occupationId..".png"
	    local attackIcon = display.newSprite(attackPic)
	    attackIcon:setPosition(self._attackButton:getContentSize().width / 2, self._attackButton:getContentSize().height / 2)
	    self._attackButton:addChild(attackIcon)

	    if occupationId == lt.Constants.OCCUPATION.MFS then
	        self._fsBurst = ccs.Armature:create("uieffect_weapon_effect_fs")
	        self._fsBurst:setPosition(self._attackButton:getContentSize().width / 2, self._attackButton:getContentSize().height / 2)
	        self._fsBurst:getAnimation():playWithIndex(0)
	        self._fsBurst:setVisible(false)
	        self._attackButton:addChild(self._fsBurst)
	    end

	    -- 技能按钮
	    self._skillButtonTable = {}

	    self._skillButtonPosition1 = cc.p(display.right - 228 * self._winScale, display.bottom + 72 * self._winScale)
	    self._skillButton1 = display.newSprite("#battle_btn_bg_1.png")
	    self._skillButton1:setPosition(self._skillButtonPosition1)
	    self._controlNode:addChild(self._skillButton1)
	    
	    self._skillButtonTable[1] = self._skillButton1

	    self._skillButtonPosition2 = cc.p(display.right - 228 * self._winScale, display.bottom + 168 * self._winScale)
	    self._skillButton2 = display.newSprite("#battle_btn_bg_1.png")
	    self._skillButton2:setPosition(self._skillButtonPosition2)
	    self._controlNode:addChild(self._skillButton2)

	    self._skillButtonTable[2] = self._skillButton2

	    self._skillButtonPosition3 = cc.p(display.right - 158 * self._winScale, display.bottom + 234 * self._winScale)
	    self._skillButton3 = display.newSprite("#battle_btn_bg_1.png")
	    self._skillButton3:setPosition(self._skillButtonPosition3)
	    self._controlNode:addChild(self._skillButton3)

	    self._skillButtonTable[3] = self._skillButton3

	    self._skillButtonPosition4 = cc.p(display.right - 66 * self._winScale, display.bottom + 234 * self._winScale)
	    self._skillButton4 = display.newSprite("#battle_btn_bg_1.png")
	    self._skillButton4:setPosition(self._skillButtonPosition4)
	    self._controlNode:addChild(self._skillButton4)

	    self._skillButtonTable[4] = self._skillButton4
	end
end

function WorldLayer:onEnter()
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.CHAT_CURRENT, handler(self, self.onChatMessage), "WorldLayer:onChatMessage")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.AUDIO_CHAT_UPDATE, handler(self, self.onOwnChatMessage), "WorldLayer:onOwnChatMessage")
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onUpdate))
	self:scheduleUpdate()

	self._delayInitHandler = lt.scheduler.performWithDelayGlobal(handler(self, self.delayInit), 0)

	if noUIDebug then
	    self:setTouchEnabled(true)
	    self:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)
	    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))
	end
end

function WorldLayer:onExit()
	-- 卸载特效
    lt.ResourceManager:removeArmature("uieffect_city_auto_way", "effect/ui/uieffect_city_auto_way.ExportJson")
    lt.ResourceManager:removeArmature("uieffect_city_follow_leader", "effect/ui/uieffect_city_follow_leader.ExportJson")

	lt.GameEventManager:removeListener("WorldLayer:onChatMessage")
	lt.GameEventManager:removeListener("WorldLayer:onOwnChatMessage")
	-- 注销 世界实例
	self._worldEntity:clear()

	lt.EntityManager:unregisterWorldEntity()

	if self._delayInitHandler then
		lt.scheduler.unscheduleGlobal(self._delayInitHandler)
	end
end

function WorldLayer:delayInit()
	self._delayInitHandler = nil

	-- 世界初始化
	self._worldEntity:worldFirstInit()
end

function WorldLayer:setWorldMenuLayer(worldMenuLayer)
	self._worldMenuLayer = worldMenuLayer

	self._worldEntity:setUIDelegate(self._worldMenuLayer)
end

function WorldLayer:setWorldUILayer(worldUILayer)
	self._wolrdUILayer = worldUILayer
end

function WorldLayer:onUpdate(delta)
    -- lt.TimeCounter:flagInit()

	local params = nil

    if noUIDebug then
	    params = {
	    	joyStickDirection = self:getDirection(),
	    	controlButton 	  = self:getControlButton(),
	    	delta 			  = delta,
		}
	else
		if self._worldMenuLayer then
	    	params = {
		        joyStickDirection = self._worldMenuLayer:getDirection(),
		        controlButton     = self._worldMenuLayer:getControlButton(),
		        delta             = delta
		    }
		else
			params = {
				delta 		= delta
			}
	    end
	end

    -- lt.TimeCounter:flag("WorldLayer 1")

    self._worldEntity:setFrameParams(params)
	self._worldEntity:onUpdate(delta)

    -- lt.TimeCounter:flag("WorldLayer 2")

    if self._worldMenuLayer then
		self._worldMenuLayer:onUpdate(delta)
	end

    -- lt.TimeCounter:flag("WorldLayer 3")

	-- NewFlagUpdate
	lt.NewFlagManager:onUpdate(delta)

	if self._worldEntity:isFieldEnv() then
		-- 处于野外才会活动推送
		lt.ActivityPushManager:onUpdate(delta)
	end
	 
    -- lt.TimeCounter:flag("WorldLayer 4")
    -- lt.TimeCounter:dump()
end

function WorldLayer:onWorldTransfer(worldMapId)
	self._worldEntity:onWorldTransfer(worldMapId)
end

function WorldLayer:loadingOn()
	self._worldScene:loadingOn()
end

function WorldLayer:loadingOff()
	self._worldScene:loadingOff()
end

-- 上层传来点击事件
function WorldLayer:onPoint(point)
	return self._worldEntity:onPoint(point)
end

-- ############################## 跟随效果 ##############################
function WorldLayer:showPathFinding(show)
	if show == nil or show then
		if not self._followNode then
			self._followNode = display.newNode()
			self._followNode:setPosition(display.cx, display.cy - 160)
			self:addChild(self._followNode, 20000)

			local armature = ccs.Armature:create("uieffect_city_auto_way")
			armature:getAnimation():playWithIndex(0)
			self._followNode:addChild(armature)
		end

		self._followNode:setVisible(true)
	else
		self:hidePathFinding()
	end
end

function WorldLayer:showFollowLeader(show)
	if show == nil or show then
		if not self._followNode then
			self._followNode = display.newNode()
			self._followNode:setPosition(display.cx, display.cy - 160)
			self:addChild(self._followNode, 20000)

			local armature = ccs.Armature:create("uieffect_city_follow_leader")
			armature:getAnimation():playWithIndex(0)
			self._followNode:addChild(armature)
		end

		self._followNode:setVisible(true)
	else
		self:hidePathFinding()
	end
end

function WorldLayer:hidePathFinding()
	if self._followNode then
		self._followNode:removeFromParent()
		self._followNode = nil
	end
end

-- ############################## 收到当前频道消息 ##############################
function WorldLayer:onChatMessage(params)

    if params.chatInfo and params.isAudio then--params.isAudio 这个语音的抛出事件 
        local playerId = params.chatInfo:getSenderId()
        if playerId == lt.DataManager:getPlayerId() then--自己说的语音
            return
        end
    end

	if self._worldEntity then
		self._worldEntity:chatMessage(params.chatInfo)
	end
end

function WorldLayer:onOwnChatMessage(params)--翻译自己说的话
	if not params.chatInfo then
		return
	end
	local channel = params.chatInfo:getChannel()
	
	if channel == lt.Constants.CHAT_TYPE.CURRENT then
		if self._worldEntity then
			self._worldEntity:chatMessage(params.chatInfo)
		end
	end
end

-- ############################## temp ##############################
local pi = math.pi

WorldLayer._joystick       = nil
WorldLayer._joystickBg     = nil
WorldLayer._joystickMinRadius = 20
WorldLayer._joystickMinRadiusSQ = 400 -- 20 * 20
WorldLayer._joystickMaxRadius = 56
WorldLayer._joystickMaxRadiusSQ = 3136 -- 56 * 56

WorldLayer._direciton                = lt.Constants.DIRECTION.INVALID
WorldLayer._directionEventId         = -1
WorldLayer._directionDefaultLocation = cc.p(display.left + 160, display.bottom + 155)
WorldLayer._joystickLocation         = nil
WorldLayer._joystickLocationChange   = false
WorldLayer._isControlDirection       = false

WorldLayer._directionRect1    = cc.rect(0,0,380,display.height / 2) -- 最大坐标区域
WorldLayer._directionRect2    = cc.rect(WorldLayer._directionDefaultLocation.x - 80, WorldLayer._directionDefaultLocation.y, 160, 80) -- 控制不变区域
WorldLayer._directionLocation = WorldLayer._directionDefaultLocation

WorldLayer.RADIAN1 = pi * 2 / 3
WorldLayer.RADIAN2 = pi / 3
WorldLayer.RADIAN3 = - pi * 64 / 180
WorldLayer.RADIAN4 = - pi * 116 / 180
WorldLayer.RADIAN5 = - pi / 2

WorldLayer._radian = nil

WorldLayer._attackEventId           = -1
WorldLayer._attackRect              = cc.rect(display.width - (96 + 70) * WorldLayer._winScale, display.bottom + (112 - 70) * WorldLayer._winScale, 140 * WorldLayer._winScale, 140 * WorldLayer._winScale)


function WorldLayer:onTouch(event)
    if event.name == "began" or event.name == "added" then
        return self:handleEventBeganAndAdded(event)
    elseif event.name == "moved" then
        self:handleEventMoved(event)
    elseif event.name == "ended" or event.name == "cancelled" or event.name == "removed" then
        self:handleEventEndedAndRemoved(event)
    end
end

function WorldLayer:handleEventBeganAndAdded(event)
    local inControl = false
    for id, point in pairs(event.points) do
        if not self._isControlDirection and cc.rectContainsPoint(self._directionRect1, point) then
            -- JoyStick
            self._isControlDirection = true
            self._directionEventId = id
            self._joystick:stopAllActions()

            self:setJoystickLocation(point, true)

            self._joystickBg:runAction(cca.scaleTo(0.15, 1.2))

            inControl = true
        else
            local inButton = false
            if self._controlNode:isVisible() then
                local distanceSQ1 = (95 * self._winScale * 95 * self._winScale)
                local distanceSQ2 = (45 * self._winScale * 45 * self._winScale)

                -- 控制面板生效中
                if cc.pDistanceSQ(point, cc.p(self._jumpButton:getPosition())) <= distanceSQ1 then
                    -- 点击跳跃
                    self._controlButton = lt.Constants.CONTROL_BUTTON_JUMP

                    inButton  = true
                elseif cc.rectContainsPoint(self._attackRect, point) then
                    -- 点击攻击
                    self._attackEventId = id
                    self._controlButton = lt.Constants.CONTROL_BUTTON_ATTACK_START

                    inControl = true
                    inButton  = true
                elseif cc.pDistanceSQ(point, self._skillButtonPosition1) <= distanceSQ2 then
                    -- 点击技能1
                    self._controlButton = lt.Constants.CONTROL_BUTTON_SKILL_1

                    inButton  = true
                elseif cc.pDistanceSQ(point, self._skillButtonPosition2) <= distanceSQ2 then
                    -- 点击技能2
                    self._controlButton = lt.Constants.CONTROL_BUTTON_SKILL_2

                    inButton  = true
                elseif cc.pDistanceSQ(point, self._skillButtonPosition3) <= distanceSQ2 then
                    -- 点击技能3
                    self._controlButton = lt.Constants.CONTROL_BUTTON_SKILL_3

                    inButton  = true
                elseif cc.pDistanceSQ(point, self._skillButtonPosition4) <= distanceSQ2 then
                    -- 点击技能4
                    self._controlButton = lt.Constants.CONTROL_BUTTON_SKILL_4

                    inButton  = true
                end
            end
        end
    end

    return inControl
end

function WorldLayer:handleEventMoved(event)
    for id, point in pairs(event.points) do
        if self._directionEventId == id then
            self:setJoystickLocation(point)
            break
        end
    end
end

function WorldLayer:handleEventEndedAndRemoved(event)
    for id, point in pairs(event.points) do
        if id == self._directionEventId then
            self._isControlDirection = false
            self._directionEventId = -1
            
            self:setJoystickLocation()

            self._joystickBg:runAction(cca.scaleTo(0.15, 1))
        elseif id == self._attackEventId then
            self._attackEventId = -1
            self._controlButton = lt.Constants.CONTROL_BUTTON_ATTACK_END
        end
    end
end

function WorldLayer:setJoystickLocation(touchPoint, location)
    if not touchPoint then
        self:resetJoystickLocation()
    else
        if location then
            if cc.rectContainsPoint(self._directionRect2, touchPoint) then
                self._directionLocation = touchPoint
            else
                local newX = lt.CommonUtil:fixValue(touchPoint.x, self._directionRect2.x, self._directionRect2.x + self._directionRect2.width)
                local newY = lt.CommonUtil:fixValue(touchPoint.y, self._directionRect2.y, self._directionRect2.y + self._directionRect2.height)

                self._directionLocation = cc.p(newX, newY)
            end

            self._joystickBg:setPosition(self._directionLocation)
        end

        if self._joystickLocation and self._joystickLocation.x == touchPoint.x and self._joystickLocation.y == touchPoint.y then
            return
        end

        self._joystickLocation       = touchPoint
        self._joystickLocationChange = true

        local distanceSQ = cc.pDistanceSQ(self._joystickLocation, self._directionLocation)
        local joystickLocation = nil
        if distanceSQ < self._joystickMaxRadiusSQ then
            joystickLocation = touchPoint
        else
            local normalize = cc.pNormalize(cc.p(touchPoint.x - self._directionLocation.x, touchPoint.y - self._directionLocation.y))
            joystickLocation = cc.p(self._directionLocation.x + normalize.x * self._joystickMaxRadius, self._directionLocation.y + normalize.y * self._joystickMaxRadius)
        end

        self._joystick:setPosition(joystickLocation)
    end
end

function WorldLayer:resetJoystickLocation()
    self._directionLocation = self._directionDefaultLocation

    self._joystickLocation       = nil
    self._joystickLocationChange = true

    self._joystickBg:setPosition(self._directionLocation)
    self._joystick:setPosition(self._directionLocation)
end

-- 获得方向
function WorldLayer:getDirection()
	if self._keypadDirection then
		return self._keypadDirection
	end

    if not self._isControlDirection then
        return lt.Constants.DIRECTION.INVALID
    end

    if self._direction and not self._joystickLocationChange then
        return
    end

    self._joystickLocationChange = false

    self._direciton = lt.Constants.DIRECTION.INVALID

	local distanceSQ = cc.pDistanceSQ(self._directionLocation, self._joystickLocation)
    if distanceSQ < self._joystickMinRadiusSQ then
        -- 防止按上去就动
        return self._direciton
    end

    self._radian = cc.pToAngleSelf(cc.pSub(self._joystickLocation, self._directionLocation))

    if self._radian >= self.RADIAN1 then
        self._direciton = lt.Constants.DIRECTION.LEFT
    elseif self._radian > self.RADIAN2 then
        self._direciton = lt.Constants.DIRECTION.UP
    elseif self._radian > self.RADIAN3 then
        self._direciton = lt.Constants.DIRECTION.RIGHT
    elseif self._radian > self.RADIAN4 then
        if distanceSQ > self._joystickMaxRadiusSQ then
            self._direciton = lt.Constants.DIRECTION.DOWN
        else
            if self._radian == self.RADIAN5 then
                self._direciton = lt.Constants.DIRECTION.INVALID
            elseif self._radian > self.RADIAN5 then
                self._direciton = lt.Constants.DIRECTION.RIGHT
            else
                self._direciton = lt.Constants.DIRECTION.LEFT
            end
        end
    else
        self._direciton = lt.Constants.DIRECTION.LEFT
    end

    return self._direciton
end
-- 获得
function WorldLayer:getControlButton()
    local controlButton = self._controlButton

    -- 非长按只能取一次
    if self._controlButton ~= lt.Constants.CONTROL_BUTTON_ATTACK_START then
        self._controlButton = lt.Constants.CONTROL_INVALID
    end

    return controlButton
end

return WorldLayer
