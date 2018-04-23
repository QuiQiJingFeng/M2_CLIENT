
-- ################################################## 世界界面(消息界面) ##################################################
-- 此界面只用于 添加游戏内各种提示性消息
local WorldNoticeLayer = class("WorldNoticeLayer", lt.BaseLayer)

function WorldNoticeLayer:ctor()
	--self:setNodeEventEnabled(true)
    WorldNoticeLayer.super.ctor(self)
end

function WorldNoticeLayer:onEnter()   
	self:setTouchEnabled(false)

end

function WorldNoticeLayer:onExit()

end

-- ############################## Loading效果(只用于显示) ############################## 
WorldNoticeLayer._loadingNode = nil
WorldNoticeLayer._progressMask = nil
WorldNoticeLayer._percentage = 0

function WorldNoticeLayer:loadingOn(duration)
	if not self._loadingNode then
		self._loadingNode = display.newNode()
		self._loadingNode:setPosition(display.cx, display.cy - 160)
		self:addChild(self._loadingNode, 20000)

		local bg = display.newSprite("#common_progress_bg.png")
		self._loadingNode:addChild(bg, -1)

		-- local progress = display.newSprite("effect/pic/uiefffect_progress_dise_nfxq.png")
		-- progress:setBlendFunc(gl.ONE, gl.ONE)
		-- self._loadingNode:addChild(progress)

		-- progress:runAction(cca.loop(cca.rotateBy(2, 360)))

		local progress = ccs.Armature:create("uiefffect_progress")
		progress:getAnimation():playWithIndex(0)
		self._loadingNode:addChild(progress)

		self._progressMask = display.newProgressTimer("#common_progress_bg.png", 0)
		self._progressMask:setReverseDirection(true)
		self._loadingNode:addChild(self._progressMask, 1)

		self._progressIcon = display.newSprite()
		self._loadingNode:addChild(self._progressIcon, 9)

		self._progressLight = ccs.Armature:create("uiefffect_progress")
		self._progressLight:getAnimation():playWithIndex(1)
		self._progressLight:setPosition(0, 35)
		self._loadingNode:addChild(self._progressLight, 10)

		self._progressLabel = display.newSprite()
		self._progressLabel:setPosition(0, -36)
		self._loadingNode:addChild(self._progressLabel, 11)
	end

	self._loadingNode:setVisible(true)

	self._percentage = 100
	self._progressMask:setPercentage(self._percentage)

	self._rotation = 0

	if self._loadingUpdateHandler then
		lt.scheduler.unscheduleGlobal(self._loadingUpdateHandler)
	end

	duration = duration or 2

	self._loadingUpdateHandler = lt.scheduler.scheduleUpdateGlobal(function(dt)
		self._percentage = self._percentage - (100 / duration) * dt
		self._progressMask:setPercentage(self._percentage)

		local angle = 90 - 360 * (100 - self._percentage) / 100
		local radius = 35
		local x = math.cos(math.rad(angle)) * radius
		local y = math.sin(math.rad(angle)) * radius
		self._progressLight:setPosition(x, y)

		if self._percentage <= 0 and self._loadingUpdateHandler then
			lt.scheduler.unscheduleGlobal(self._loadingUpdateHandler)
			self._loadingUpdateHandler = nil
		end
	end)

	self._customAudioId = lt.AudioManager:playSound("ui/audio_custom_action")
end


--#########################################################跑马灯###############################
function WorldNoticeLayer:onRedPacketNotice(params)
    self:updateTrumpetNode(params)
end

function WorldNoticeLayer:updateTrumpetNode(params)
    if params and params.chatInfo then
        lt.NoticeManager:addRunningHorse(params.chatInfo)
    end
end

function WorldNoticeLayer:runningHorse(chatInfo, allNum)--跑马灯

    --喇叭信息区域
    if not self._trumpetNode then
        self._trumpetNode = lt.GameNewPanel.new(lt.GameNewPanel.TYPE.NEW_DARK_CHAT, 0, 0, cc.size(453,33))
        self._trumpetNode:setPosition(display.cx, display.top-150)
        self._trumpetNode:setVisible(false)
        --self._trumpetNode:setTouchEnabled(false)
        --self._trumpetNode:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self, self.onTrumpetNodeTouch))
        self:addChild(self._trumpetNode, 100)

        local trumpetBtn = lt.PushButton.new("image/ui/common/touch_rect_80.png", {scale9 = true, scale = self._winScale})
        trumpetBtn:setButtonSize(453, 33)
        trumpetBtn:setPosition(self._trumpetNode:getContentSize().width / 2, self._trumpetNode:getContentSize().height / 2)
        trumpetBtn:onButtonClicked(handler(self, self.onTrumpetNodeTouch))
        self._trumpetNode:addChild(trumpetBtn)

        self._trumpetIcon = display.newSprite("#ui_message_trumpt.png")
        self._trumpetIcon:setPosition(15,self._trumpetNode:getContentSize().height/2)
        self._trumpetNode:addChild(self._trumpetIcon)

        self._redPacketIcon = display.newSprite("image/newservice/newservice_little_redpacket.png")
        self._redPacketIcon:setPosition(15,self._trumpetNode:getContentSize().height/2 + 3)
        self._trumpetNode:addChild(self._redPacketIcon)

        self._labelName = lt.GameLabel.new("", 20, lt.Constants.COLOR.WHITE)
        self._labelName:setAnchorPoint(0, 0.5)
        self._labelName:setPosition(30,self._trumpetNode:getContentSize().height/2)
        self._trumpetNode:addChild(self._labelName)

        local rect = cc.rect(0,-self._trumpetNode:getContentSize().height/2,self._trumpetNode:getContentSize().width,self._trumpetNode:getContentSize().height)
        self._rollingNode = lt.RollingChatNode.new(rect)
        self._rollingNode:setPosition(0,self._trumpetNode:getContentSize().height/2)
        self._trumpetNode:addChild(self._rollingNode)
    end

    self._allRunningNum = allNum or 0
    self._runnindState = true--正在播


    self._rollingNode:setChatInfo(chatInfo)
    self._trumpetNode:setVisible(true)
    self._trumpetNode:stopAllActions()

    local name = chatInfo:getSenderName()
    if chatInfo:getSubType() == lt.Constants.CHAT_SUB_TYPE.EGG or chatInfo:getSubType() == lt.Constants.CHAT_SUB_TYPE.CREATE_RISK_TEAM then
        name = lt.StringManager:getString("STRING_GAIN_TIPS_EGG_5")
        self._labelName:setString("["..name.."]")
        self._labelName:setTextColor3B(lt.Constants.COLOR.RED)
    else
        self._labelName:setString("["..name.."]")
        self._labelName:setTextColor3B(lt.Constants.COLOR.CHAT_PLAYER_NAME)
    end

    if chatInfo:getSubType() == lt.Constants.CHAT_SUB_TYPE.RED_PACKET then
        --self._trumpetNode:setTouchEnabled(true)
        self._trumpetIcon:setVisible(false)
        self._redPacketIcon:setVisible(true)
    else
        --self._trumpetNode:setTouchEnabled(false)
        self._trumpetIcon:setVisible(true)
        self._redPacketIcon:setVisible(false)
    end

    local x = 35 + self._labelName:getContentSize().width
    local rect = cc.rect(x,-self._trumpetNode:getContentSize().height/2,self._trumpetNode:getContentSize().width-x,self._trumpetNode:getContentSize().height)
    self._rollingNode:setRect(rect)
end

function WorldNoticeLayer:closeRunningHorse()
    self._runnindState = false
    if self._allRunningNum == 1 then--播到了最后一条
        self._trumpetNode:runAction(cca.seq{
            cca.delay(10),
            cca.hide(),
            cca.cb(function()
                self._rollingNode:clear()
            end)
        })
    else
        self._trumpetNode:setVisible(false)
        self._rollingNode:clear()
    end
end

function WorldNoticeLayer:onTrumpetNodeTouch(event)
    if self._trumpetNode:isVisible() and self._redPacketIcon:isVisible() then
        if display.getRunningScene():getWorldMenuLayer() then
            display.getRunningScene():getWorldMenuLayer():onRedPacket()
        end
    end
end

function WorldNoticeLayer:getRunningHorseVisible()
    return self._runnindState or false
end

-- ############################## 弹幕啦啦啦啦啦啦啦 ############################## 
function WorldNoticeLayer:runningBarrage(info)--弹幕走一波  
    if not self._barrageLayer then
        self._barrageLayer = lt.TextBarrageLayer.new(self)
        self._barrageLayer:setAnchorPoint(0.5, 0.5)
        self._barrageLayer:setPosition(display.cx, display.cy)
        self:addChild(self._barrageLayer, 90)
    end
    self:resetBarrageText()
    info = info or {}
    self._barrageLayer:updateInfo(info)
end

function WorldNoticeLayer:resetBarrageText()
    if self._barrageLayer then
        self._barrageLayer:clearAll()
    end
end

function WorldNoticeLayer:addBarrageMessage(message)--评论 插了队
    if self._barrageLayer then
        self._barrageLayer:addMessage(message)
    end
end

function WorldNoticeLayer:addChatBarrageMessage(message)--频道聊天 不插队
    if self._barrageLayer then
        self._barrageLayer:addChatMessage(message)
    end
end

function WorldNoticeLayer:stopBarrageRunning()--停止弹幕
    if self._barrageLayer then
        self._barrageLayer:clearAll()
    end
end

function WorldNoticeLayer:closeRunningBarrage()--关闭弹幕
    if self._barrageLayer then
        self._barrageLayer:removeFromParent()
        self._barrageLayer = nil 
    end
end

return WorldNoticeLayer
