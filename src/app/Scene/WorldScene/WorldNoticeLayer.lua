
-- ################################################## 世界界面(消息界面) ##################################################
-- 此界面只用于 添加游戏内各种提示性消息
local WorldNoticeLayer = class("WorldNoticeLayer", lt.BaseLayer)

function WorldNoticeLayer:ctor()
	--self:setNodeEventEnabled(true)
    WorldNoticeLayer.super.ctor(self)
end

function WorldNoticeLayer:onEnter()   
	self:setTouchEnabled(false)

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.APP_ENTER_BACKGROUND, handler(self, self.onRedPacketNotice), "WorldNoticeLayer:onRedPacketNotice")
end

function WorldNoticeLayer:onExit()
    lt.GameEventManager:removeListener("WorldNoticeLayer:onRedPacketNotice")
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

function WorldNoticeLayer:loadingOff()
	if self._loadingNode then
		self._loadingNode:setVisible(false)

		if self._loadingUpdateHandler then
			lt.scheduler.unscheduleGlobal(self._loadingUpdateHandler)
			self._loadingUpdateHandler = nil
		end
	end

	lt.AudioManager:stopSound(self._customAudioId)
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


        local effectName = "uieffect_running_horse_circle"
        local armatureFile = "effect/ui/uieffect_running_horse_circle.ExportJson"
        if not lt.ResourceManager:isArmatureLoaded(effectName) then
            lt.ResourceManager:addArmature(effectName, armatureFile)
        end
        local armature = ccs.Armature:create(effectName)
        armature:setScaleX(2)
        armature:setScaleY(1.7)
        armature:getAnimation():playWithIndex(0)
        armature:setPosition(self._trumpetNode:getContentSize().width / 2, self._trumpetNode:getContentSize().height / 2)
        self._trumpetNode:addChild(armature)

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

-- ############################## 速度线 ############################## 
function WorldNoticeLayer:onBossEndLine()
	local armatureName = "battle_boss_endline"
	if not lt.ResourceManager:isArmatureLoaded(armatureName) then
		return
	end

	local armature = ccs.Armature:create(armatureName)
    armature:getAnimation():playWithIndex(0)
    armature:getAnimation():setMovementEventCallFunc(function(armature, movementType, movementId)
        if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
            armature:removeFromParent()
        end
    end)
    armature:setPosition(display.cx, display.cy)
    self:addChild(armature)
end

-- ############################## 升级效果 ############################## 
function WorldNoticeLayer:onPlayerLevelUp()
	local armatureName = "uieffect_levelup_bg"
	if not lt.ResourceManager:isArmatureLoaded(armatureName) then
		return
	end

    local armature1 = ccs.Armature:create(armatureName)
    armature1:getAnimation():playWithIndex(0)
    armature1:getAnimation():setMovementEventCallFunc(function(armature, movementType, movementId)
        if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
            armature:removeFromParent()
        end
    end)
    armature1:getAnimation():setFrameEventCallFunc(function(bone, eventName, originFrameIndex, currentFrameIndex)
        if eventName == "on_effect" then
            -- 屏幕中间加入特效
            local screenArmature = ccs.Armature:create("uieffect_levelup_screen")
			screenArmature:getAnimation():playWithIndex(0)
			screenArmature:getAnimation():setMovementEventCallFunc(function(armature, movementType, movementId)
		        if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
		            armature:removeFromParent()
		        end
		    end)
		    screenArmature:setPosition(display.cx, display.cy)
		    self:addChild(screenArmature)

		    local sprite = display.newScale9Sprite("effect/pic/uieffect_levelup_screen_glow.png", display.cx, display.cy, cc.size(display.width, display.height))
		    self:addChild(sprite)

		    sprite:runAction(cca.seq{
		    		cca.fadeTo(0.333, 204),
		    		cca.fadeOut(0.5),
		    		cca.removeSelf()
		    	})

		    local level1 = display.newSprite("image/ui/level.png")
            level1:setAnchorPoint(0, 0.5)
            self:addChild(level1)

            local level2 = lt.GameBMLabel.new(lt.DataManager:getPlayer():getLevel(), "#fonts/ui_num_6.fnt")
            level2:setAdditionalKerning(-20)
            level2:setAnchorPoint(0, 0.5)
            self:addChild(level2)

            local width = level1:getContentSize().width + level2:getContentSize().width

            level1:setPosition(display.cx - width / 2, display.cy + 100)
            level2:setPosition(display.cx - width / 2 + level1:getContentSize().width, display.cy + 100)

            level1:runAction(cca.seq{
            		cca.delay(2),
            		cca.removeSelf()
            	})
           	level2:runAction(cca.seq{
            		cca.delay(2),
            		cca.removeSelf()
            	})

           	lt.AudioManager:playSound("ui/audio_player_level_up_2")
        end
    end)
    armature1:setPosition(display.cx, display.cy + 100)
    self:addChild(armature1)

    lt.AudioManager:playSound("ui/audio_player_level_up_1")
end

-- ############################## 任务完成效果 ############################## 
function WorldNoticeLayer:onTaskComplete(taskId)
	local taskInfo = lt.CacheManager:getTaskInfo(taskId)
	if not taskInfo then
		return
	end

	local armatureName = "battle_task_complete"
	if not lt.ResourceManager:isArmatureLoaded(armatureName) then
		return
	end

	local armature1 = ccs.Armature:create(armatureName)
    armature1:getAnimation():playWithIndex(1)
    armature1:getAnimation():setMovementEventCallFunc(function(armature, movementType, movementId)
        if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
            armature:removeFromParent()
        end
    end)
    armature1:getAnimation():setFrameEventCallFunc(function(bone, eventName, originFrameIndex, currentFrameIndex)
    	if eventName == "on_effect" then
    		local str = lt.StringManager:getFormatString("STRING_TASK_COMPLETE", taskInfo:getName())
    		local label = lt.GameBMLabel.new(str, "task_complete.fnt")
    		label:setPosition(0, -10)
    		armature1:addChild(label, 10)

    		lt.AudioManager:playSound("ui/audio_task_complete_2")
    	end
    end)
    armature1:setPosition(display.cx, display.cy + 100)
    self:addChild(armature1, 100)

    lt.AudioManager:playSound("ui/audio_task_complete_1")

    local armature2 = ccs.Armature:create(armatureName)
    armature2:getAnimation():playWithIndex(0)
    armature2:getAnimation():setMovementEventCallFunc(function(armature, movementType, movementId)
        if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
            armature:removeFromParent()
        end
    end)
    armature2:setPosition(display.cx, display.cy + 100)
    self:addChild(armature2, 100)
end

-- ############################## 领取迷宫任务效果 ############################## 
function WorldNoticeLayer:onMazeTask()
    local armatureName1 = "battle_special_event"

    if not lt.ResourceManager:isArmatureLoaded(armatureName1) then
        local armatureBgFile = "effect/ui/"..armatureName1..".ExportJson"
        lt.ResourceManager:addArmature(armatureName1, armatureBgFile)
    end

    local armatureName2 = "battle_special_fly_event"
    if not lt.ResourceManager:isArmatureLoaded(armatureName2) then
        local armatureBgFile = "effect/ui/"..armatureName2..".ExportJson"
        lt.ResourceManager:addArmature(armatureName2, armatureBgFile)
    end

    lt.AudioManager:preloadSound("ui/audio_special_event_task")

    local armature1 = ccs.Armature:create(armatureName1)
    armature1:getAnimation():playWithIndex(0)
    armature1:getAnimation():setMovementEventCallFunc(function(armature, movementType, movementId)
        if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
            armature:removeFromParent()
        end
    end)
    armature1:getAnimation():setFrameEventCallFunc(function(bone, eventName, originFrameIndex, currentFrameIndex)
        if eventName == "on_effect" then
            lt.AudioManager:playSound("ui/audio_special_event_task")

            local armature2 = ccs.Armature:create(armatureName2)
            armature2:getAnimation():playWithIndex(0)
            -- armature2:getAnimation():setMovementEventCallFunc(function(armature, movementType, movementId)
            --     if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
            --         armature:removeFromParent()
            --     end
            -- end)
            armature2:setRotation(-16)
            armature2:setPosition(display.cx, display.cy + 200)
            self:addChild(armature2, 100)

            armature2:runAction(cca.seq{
                cca.moveTo(0.6, 90, 440),
                cca.fadeOut(0.5),
                cca.removeSelf()
            })
        end
    end)
    armature1:setPosition(display.cx, display.cy + 200)
    self:addChild(armature1, 100)
end

-- ############################## 迷宫任务完成 ############################## 
function WorldNoticeLayer:onMazeComplete(mazeName)
    local armatureName = "battle_special_event"

    if not lt.ResourceManager:isArmatureLoaded(armatureName) then
        local armatureFile = "effect/ui/"..armatureName..".ExportJson"
        lt.ResourceManager:addArmature(armatureName, armatureFile)
    end

    local armature1 = ccs.Armature:create(armatureName)
    armature1:getAnimation():playWithIndex(1)
    armature1:getAnimation():setMovementEventCallFunc(function(armature, movementType, movementId)
        if movementType == ccs.MovementEventType.complete or movementType == ccs.MovementEventType.loopComplete then
            armature:removeFromParent()
        end
    end)
    armature1:getAnimation():setFrameEventCallFunc(function(bone, eventName, originFrameIndex, currentFrameIndex)
        if eventName == "on_effect" then            
            mazeName = mazeName or ""
            local str = lt.StringManager:getFormatString("STRING_MAZE_COMPLETE", mazeName)
            local label = lt.GameBMLabel.new(str, "task_complete.fnt")
            label:setPosition(display.cx, display.cy + 60)
            self:addChild(label, 110)

            lt.AudioManager:playSound("ui/audio_task_complete_2")

            label:runAction(cca.seq{
                    cca.delay(1.5),
                    cca.removeSelf()
                })
        end
    end)
    armature1:setPosition(display.cx, display.cy + 160)
    self:addChild(armature1, 100)

    lt.AudioManager:playSound("ui/audio_task_complete_1")
end

-- ############################## 传送效果 ############################## 
function WorldNoticeLayer:showTransfer()
	self:loadingOn(2)

	local frame1 = display.newSpriteFrame("common_progress_icon_1.png")
	if frame1 then
		self._progressIcon:setSpriteFrame(frame1)
	end

	local frame2 = display.newSpriteFrame("common_progress_label_transfer.png")
	if frame2 then
		self._progressLabel:setSpriteFrame(frame2)
	end
end

function WorldNoticeLayer:hideTransfer()
	self:loadingOff()
end


-- ############################## 任务自定义行为 ############################## 
WorldNoticeLayer.TASK_CUSTOM_FRAME_1 = {
	[lt.Constants.CUSTOM_ACTION.COLLECT]  					= "common_progress_icon_2.png",
	[lt.Constants.CUSTOM_ACTION.USE_ITEM] 					= "common_progress_icon_3.png",
	[lt.Constants.CUSTOM_ACTION.CHECK]    					= "common_progress_icon_4.png",
	[lt.Constants.CUSTOM_ACTION.SEARCH]   					= "common_progress_icon_3.png",
	[lt.Constants.CUSTOM_ACTION.OPEN]     					= "common_progress_icon_1.png",
	[lt.Constants.CUSTOM_ACTION.TREASURE_MAP_DIG]   		= "common_progress_icon_2.png",
	[lt.Constants.CUSTOM_ACTION.DECLARE_GUILD_ANNOUNCEMENT] = "common_progress_icon_4.png",
}

WorldNoticeLayer.TASK_CUSTOM_FRAME_2 = {
	[lt.Constants.CUSTOM_ACTION.COLLECT]  					= "common_progress_label_collect.png",
	[lt.Constants.CUSTOM_ACTION.USE_ITEM] 					= "common_progress_label_use.png",
	[lt.Constants.CUSTOM_ACTION.CHECK]    					= "common_progress_label_check.png",
	[lt.Constants.CUSTOM_ACTION.SEARCH]   					= "common_progress_label_explore.png",
	[lt.Constants.CUSTOM_ACTION.OPEN]     					= "common_progress_label_open.png",
	[lt.Constants.CUSTOM_ACTION.TREASURE_MAP_DIG]   		= "common_progress_label_open.png",
	[lt.Constants.CUSTOM_ACTION.DECLARE_GUILD_ANNOUNCEMENT]	= "common_progress_label_read.png",
}

function WorldNoticeLayer:showTaskCustom(customIdx, duration)
	self:loadingOn(duration)

	local framePic1 = self.TASK_CUSTOM_FRAME_1[customIdx]
	if framePic1 then
		local frame = display.newSpriteFrame(framePic1)
		if frame then
			self._progressIcon:setSpriteFrame(frame)
		end
	end

	local framePic2 = self.TASK_CUSTOM_FRAME_2[customIdx]
	if framePic2 then
		local frame = display.newSpriteFrame(framePic2)
		if frame then
			self._progressLabel:setSpriteFrame(frame)
		end
	end
end

function WorldNoticeLayer:hideTaskCustom()
	self:loadingOff()
end

-- ############################## Boss登场 ############################## 
function WorldNoticeLayer:bossWarning()
	local armatureName = "stage_warning"
	if not lt.ResourceManager:isArmatureLoaded(armatureName) then
		return
	end

	local armature1 = ccs.Armature:create(armatureName)
    armature1:getAnimation():playWithIndex(0)
    armature1:setPosition(display.cx, display.cy)
    self:addChild(armature1, 100)

    -- 音效
    lt.AudioManager:playSound("effect/audio_boss_warning")
end

function WorldNoticeLayer:bossAppear()
	local armatureName = "stage_public"
	if not lt.ResourceManager:isArmatureLoaded(armatureName) then
		return
	end

	local armature1 = ccs.Armature:create(armatureName)
    armature1:getAnimation():playWithIndex(0)
    armature1:setPosition(display.cx, display.cy)
    self:addChild(armature1, 100)
end

return WorldNoticeLayer
