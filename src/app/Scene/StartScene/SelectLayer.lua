local RoleCell = class("RoleCell", function()
    return display.newSprite("#common_tab_gray_4.png")
end)

function RoleCell:ctor()
    self._lockIcon = display.newSprite("#common_icon_lock_gray.png")
    self._lockIcon:setVisible(false)
    self._lockIcon:setPosition(self:getContentSize().width/2,self:getContentSize().height/2)
    self:addChild(self._lockIcon)

    self._tipsLabel = lt.GameLabel.newString("STRING_CREATE_NEW_ROLE",18,lt.Constants.COLOR.WHITE,{outline=true,outlineColor=lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR,outlineSize=1})
    self._tipsLabel:setPosition(self:getContentSize().width/2,self:getContentSize().height/2)
    self:addChild(self._tipsLabel)

    self._faceIcon = lt.PlayerFace.new()
    self._faceIcon:setScale(0.8)
    self._faceIcon:setVisible(false)
    self._faceIcon:setPosition(45,self:getContentSize().height/2)
    self:addChild(self._faceIcon)

    self._nameLabel = lt.GameLabel.newString("",18,lt.Constants.COLOR.WHITE,{outline=true,outlineColor=lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR,outlineSize=1})
    self._nameLabel:setAnchorPoint(0,0.5)
    self._nameLabel:setPosition(self._faceIcon:getPositionX()+45,self._faceIcon:getPositionY()+15)
    self:addChild(self._nameLabel)

    self._occupationLabel = lt.GameLabel.newString("",16,lt.Constants.COLOR.WHITE,{outline=true,outlineColor=lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR,outlineSize=1})
    self._occupationLabel:setAnchorPoint(0,0.5)
    self._occupationLabel:setPosition(self._nameLabel:getPositionX(),self._nameLabel:getPositionY()-32)
    self:addChild(self._occupationLabel)
end

function RoleCell:updateInfo(player)
    if player then
        self._tipsLabel:setVisible(false)
        self._faceIcon:updateInfo({occupationId = player.occupation_id, id = player.id,faceId = player.avatar_id})
        self._faceIcon:setVisible(true)
        self._nameLabel:setString(player.name)
        self._occupationLabel:setString(string.format(lt.StringManager:getString("STRING_SELECT_OCCUPATION"),player.level,lt.StringManager:getOccupationString(player.occupation_id)))
    end
end

function RoleCell:setLock()
     self._lockIcon:setVisible(true)
     self._tipsLabel:setVisible(false)
end

function RoleCell:select()
    self:setSpriteFrame("common_tab_yellow_4.png")
end

function RoleCell:unSelect()
    self:setSpriteFrame("common_tab_gray_4.png")
end




local OccupationCell = class("OccupationCell", function()
    return display.newSprite("#common_tab_gray_3.png")
end)

function OccupationCell:ctor()
    -- body
end

function OccupationCell:updateInfo(occupationId)
    local occupationIcon = lt.OccupationIcon.new(occupationId)
    occupationIcon:setPosition(40,self:getContentSize().height/2)
    self:addChild(occupationIcon)


    local nameLabel = lt.GameLabel.new(lt.StringManager:getOccupationString(occupationId),20,lt.Constants.COLOR.WHITE,{outline=true,outlineColor=lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
    nameLabel:setPosition(self:getContentSize().width-40,self:getContentSize().height/2)
    self:addChild(nameLabel)
end

function OccupationCell:select()
    self:setSpriteFrame("common_tab_yellow_3.png")
end

function OccupationCell:unSelect()
    self:setSpriteFrame("common_tab_gray_3.png")
end




local SelectLayer = class("SelectLayer", function()
    return display.newLayer()
end)
SelectLayer._winScale = display.size.width / display.size.height *  640 / 1136
SelectLayer.STATUS = {
    CREATE  = 1,
    START   = 2,
    RECREATE   = 3
}


SelectLayer.RoleAudio = {
    [lt.Constants.OCCUPATION.QS] = "role/ch/audio_role_select_1_1",
    [lt.Constants.OCCUPATION.MFS] = "role/ch/audio_role_select_2_2",
    [lt.Constants.OCCUPATION.JS] = "role/ch/audio_role_select_3_1",
    [lt.Constants.OCCUPATION.BWLR] = "role/ch/audio_role_select_4_2",
}
SelectLayer._delegate = nil
SelectLayer._unfreeze_account_time = 0--角色封禁结束时间

function SelectLayer:ctor(delegate)
    for i=1,4 do
        local effectName = "smodel_"..i.."_effect"
        local effectJson = "effect/ui/"..effectName..".ExportJson"
        lt.ResourceManager:addArmature(effectName, effectJson, true)
    end
    self._delegate = delegate

	self:setNodeEventEnabled(true)
    self:setTouchSwallowEnabled(true)

    self._cellArray = {}

    self._sex = 1
    self._occupationId = lt.Constants.OCCUPATION.QS
    self._figureId = 20100
    self._status = self.STATUS.START

    local bg = display.newSprite("image/ui/select_occupatio_bg.jpg")
    local scale =  math.max(display.width / lt.Constants.BGWIDTH, display.height / lt.Constants.BGHEIGHT)
    --bg:setScale(display.width / lt.Constants.BGWIDTH)
    bg:setScale(scale)
    bg:setPosition(display.cx, display.cy)
    self:addChild(bg)

     -- 按钮
    local returnBtn = lt.ScaleButton.new("#select_icon_return.png")
    returnBtn:setPosition(50 * self._winScale, display.height-50 * self._winScale)
    returnBtn:onButtonClicked(handler(self, self.onReturn))
    self:addChild(returnBtn)

    self._rightBg = display.newSprite("image/ui/select_right_bg.png")
    self._rightBg:setOpacity(255*0.8)
    self._rightBg:setAnchorPoint(1,0)
    self._rightBg:setPosition(display.right,0)
    self:addChild(self._rightBg, 100)

    self._armatureList = {}
end

function SelectLayer:configInfo()
    lt.NoticeManager:clearAll()
    lt.NoticeManager:init(self)
end

function SelectLayer:onEnter()
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_CREATE, handler(self, self.onCreateResponse), "SelectLayer:onCreateResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_RANDOM_NAME, handler(self, self.onRandomNameResponse), "SelectLayer:onRandomNameResponse")
    lt.SocketApi:addListener(lt.SocketConstants.ID_S2C_DELETE_PLAYER, handler(self, self.onDeletePlayerResponse), "SelectLayer:onDeletePlayerResponse")
    lt.AudioManager:preloadSound("role/ch/audio_role_select_1_1")
    lt.AudioManager:preloadSound("role/ch/audio_role_select_2_2")
    lt.AudioManager:preloadSound("role/ch/audio_role_select_3_1")
    lt.AudioManager:preloadSound("role/ch/audio_role_select_4_2")

    local loginPlayerArray = lt.DataManager:getLoginPlayerArray()
    if #loginPlayerArray == 0 then
        --self:randName()

        if not lt.PreferenceManager:isGameActive() then
            -- sdk 激活
        end
    end
end

function SelectLayer:onExit()
	lt.SocketApi:removeEventListenersByTag("SelectLayer:onCreateResponse")
    lt.SocketApi:removeEventListenersByTag("SelectLayer:onRandomNameResponse")
    lt.SocketApi:removeEventListenersByTag("SelectLayer:onDeletePlayerResponse")

    -- 移除图片
    display.removeSpriteFrameByImageName("image/ui/select_occupatio_bg.jpg")
    display.removeSpriteFrameByImageName("image/ui/select_right_bg.png")

    -- 移除模型图片
    for i=1,4 do
        local modelPng = "model/smodel_"..i..".png"
        display.removeSpriteFrameByImageName(modelPng)
    end

    -- 释放特效
    for i=1,4 do
        local effectName = "smodel_"..i.."_effect"
        local effectJson = "effect/ui/"..effectName..".ExportJson"
        lt.ResourceManager:removeArmature(effectName, effectJson)
    end

    lt.AudioManager:unloadSound("role/ch/audio_role_select_1_1")
    lt.AudioManager:unloadSound("role/ch/audio_role_select_2_2")
    lt.AudioManager:unloadSound("role/ch/audio_role_select_3_1")
    lt.AudioManager:unloadSound("role/ch/audio_role_select_4_2")

    if self._delayHandler then
        lt.scheduler.unscheduleGlobal(self._delayHandler)
        self._delayHandler = nil
    end

    lt.NoticeManager:clearAll()
end

function SelectLayer:updateFigure(occupationId,offset)
    self._occupationId = occupationId

    -- if self._contentNode then
    --     self._contentNode:removeFromParent()
    --     self._contentNode = nil
    -- end

    -- if not self._contentNode then
    --     self._contentNode = display.newNode()
    --     self:addChild(self._contentNode)
    -- end

    self:palyAudio(occupationId)--音效
    local offsetX = offset or 0
    --界面显示
    for k,v in pairs(self._armatureList) do
        v.heroItem:setPositionX(480 * self._winScale + offsetX * self._winScale)
        v.infoImg:setPosition(v.heroItem:getPositionX() + 365 * self._winScale, display.top - 20 * self._winScale)

        if k ~= occupationId then
            v.armatureNode:setVisible(false)

            if v.leftModel then
                v.leftModel:setVisible(false)
            end
        else
            if occupationId == lt.Constants.OCCUPATION.MFS and offsetX ~= 0 then
                v.heroItem:setPosition(480 * self._winScale + offsetX * self._winScale - 40 * self._winScale, 70 * self._winScale)
            end
            v.armatureNode:setVisible(true)

            if offsetX == 0 then
                if v.leftModel then
                    v.leftModel:setVisible(true)
                end
                v.infoImg:setVisible(true)
            else
                if v.leftModel then
                    v.leftModel:setVisible(false)
                end
                v.infoImg:setVisible(false)
            end

            -- if v.leftModel then
            --     if offsetX == 0 then
            --         v.leftModel:setVisible(true)
            --     else
            --         v.leftModel:setVisible(false)
            --     end
            -- end
        end
    end
    --角色特效以及左下角小角色
    if self._armatureList[occupationId] then
        for k,v in pairs(self._armatureList[occupationId].armatureArray) do
            v:getAnimation():playWithIndex(k)
            v:setPositionX(self._armatureList[occupationId].heroItem:getPositionX())
        end

        if self._armatureList[occupationId].particle then--粒子效果  目前只有猎手有这个
            self._armatureList[occupationId].particle:setPositionX(self._armatureList[occupationId].heroItem:getPositionX())
        end

        if offsetX == 0 and not self._armatureList[occupationId].leftModel then --选择角色界面里面没有leftmodel
            local leftModel = nil
            local playerArray = lt.DataManager:getLoginPlayerArray()

            for k,player in pairs(playerArray) do
                if player.occupation_id == occupationId then
                    leftModel = display.newSprite("#select_model_bg.png")
                    leftModel:setPosition(120 * self._winScale,70 * self._winScale)
                    self._armatureList[occupationId].armatureNode:addChild(leftModel)
                    local model = lt.HeroItem.new(player.sex,player.occupation_id,player.figure_id)
                    model:playActionStand()
                    model:setPosition(leftModel:getContentSize().width/2,leftModel:getContentSize().height/2)
                    leftModel:addChild(model)
                    model:setTag(10)
                    break
                end
            end  
            self._armatureList[occupationId].leftModel = leftModel
        end
        --self._armatureList[occupationId].armatureNode:setPositionX(self._armatureList[occupationId].heroItem:getPositionX())
    else
        if occupationId == 0 then
            return
        end

        local effectName = "smodel_"..occupationId.."_effect"
        local file = string.format("model/smodel_%d", occupationId)

        local armatureNode = display.newNode()
        self:addChild(armatureNode)

        local heroItem = lt.SkeletonAnimation.new(file)
        heroItem:setPosition(480 * self._winScale + offsetX * self._winScale, 70 * self._winScale)
        armatureNode:addChild(heroItem)--角色骨骼
        heroItem:registerSpineEventHandler(handler(self, self.onSpineEvent), sp.EventType.ANIMATION_COMPLETE)
        heroItem:setAnimation(0, "stand", true)

        local posX = heroItem:getPositionX()
        local posY = heroItem:getPositionY()

        local infoImg = display.newSprite("#select_img_occupation_qs.png")
        if occupationId == lt.Constants.OCCUPATION.QS then
            infoImg = display.newSprite("#select_img_occupation_qs.png")
        elseif occupationId == lt.Constants.OCCUPATION.MFS then
            infoImg = display.newSprite("#select_img_occupation_mfs.png")
        elseif occupationId == lt.Constants.OCCUPATION.JS then
            infoImg = display.newSprite("#select_img_occupation_js.png")
        else
            infoImg = display.newSprite("#select_img_occupation_bwlr.png")
        end

        infoImg:setAnchorPoint(1,1)
        infoImg:setPosition(posX + 365 * self._winScale, display.top - 20 * self._winScale)
        armatureNode:addChild(infoImg, -10000000)--最下面
        infoImg:setVisible(false)
        local leftModel = nil
        if offsetX == 0 then
            local playerArray = lt.DataManager:getLoginPlayerArray()
            infoImg:setVisible(true)
            for k,player in pairs(playerArray) do
                if player.occupation_id == occupationId then
                    leftModel = display.newSprite("#select_model_bg.png")
                    leftModel:setPosition(120 * self._winScale,70 * self._winScale)
                    armatureNode:addChild(leftModel)
                    local model = lt.HeroItem.new(player.sex,player.occupation_id,player.figure_id)
                    model:playActionStand()
                    model:setPosition(leftModel:getContentSize().width/2,leftModel:getContentSize().height/2)
                    leftModel:addChild(model)
                    model:setTag(10)
                    break
                end
            end  
        end

        if occupationId == lt.Constants.OCCUPATION.QS then --角色入场特效

            local armature2 = ccs.Armature:create(effectName)
            armature2:getAnimation():playWithIndex(1)
            armature2:setPosition(posX, 70 * self._winScale)
            armatureNode:addChild(armature2, lt.Constants.ENTITY_LAYER.EFFECT_FRONT)

            local armature3 = ccs.Armature:create(effectName)
            armature3:getAnimation():playWithIndex(2)
            armature3:setPosition(posX, 70 * self._winScale)
            armatureNode:addChild(armature3, lt.Constants.ENTITY_LAYER.EFFECT_FRONT)

            local armature1 = ccs.Armature:create(effectName)
            armature1:getAnimation():playWithIndex(0)
            armature1:setPosition(posX, 20 * self._winScale)
            armatureNode:addChild(armature1, lt.Constants.ENTITY_LAYER.EFFECT_FRONT)

            local armature4 = ccs.Armature:create(effectName)
            armature4:getAnimation():playWithIndex(3)
            armature4:setPosition(posX, 70 * self._winScale)
            armatureNode:addChild(armature4, lt.Constants.ENTITY_LAYER.EFFECT_BACK)

            self._armatureList[occupationId] = {armatureNode = armatureNode, heroItem = heroItem, infoImg = infoImg, leftModel = leftModel, armatureArray = {[1] = armature2, [2] = armature3, [0] = armature1, [3] = armature4}}
        elseif occupationId == lt.Constants.OCCUPATION.MFS then 
            if offsetX ~= 0 then
                heroItem:setPositionX(480 * self._winScale + offsetX * self._winScale - 40 * self._winScale)
            end

            local armature1 = ccs.Armature:create(effectName)
            --armature1:setScale(0.9)
            armature1:getAnimation():playWithIndex(0)
            armature1:setPosition(posX, posY)
            armatureNode:addChild(armature1, lt.Constants.ENTITY_LAYER.EFFECT_FRONT)

            local armature2 = ccs.Armature:create(effectName)
            --armature2:setScale(0.9)
            armature2:getAnimation():playWithIndex(1)
            armature2:setPosition(posX, posY)
            armatureNode:addChild(armature2, lt.Constants.ENTITY_LAYER.EFFECT_BACK)

            local armature3 = ccs.Armature:create(effectName)
            --armature3:setScale(0.9)
            armature3:getAnimation():playWithIndex(2)
            armature3:setPosition(posX, posY)
            armatureNode:addChild(armature3, lt.Constants.ENTITY_LAYER.EFFECT_FRONT)
            self._armatureList[occupationId] = {armatureNode = armatureNode, heroItem = heroItem, leftModel = leftModel, infoImg = infoImg, armatureArray = {[0] = armature1, [1] = armature2, [2] = armature3}}
        elseif occupationId == lt.Constants.OCCUPATION.JS then

            local armature1 = ccs.Armature:create(effectName)
            --self._armature1:setScale(0.9)
            armature1:getAnimation():playWithIndex(0)
            armature1:setPosition(posX, 32 * self._winScale)
            armatureNode:addChild(armature1, lt.Constants.ENTITY_LAYER.EFFECT_FRONT)

            local armature2 = ccs.Armature:create(effectName)--盔甲右肩发光
            --self._armature2:setScale(0.9)
            armature2:getAnimation():playWithIndex(1)
            armature2:setPosition(posX, 70 * self._winScale)
            armatureNode:addChild(armature2, lt.Constants.ENTITY_LAYER.EFFECT_FRONT)

            local armature3 = ccs.Armature:create(effectName)
            --self._armature3:setScale(0.9)
            armature3:getAnimation():playWithIndex(2)
            armature3:setPosition(posX, 32 * self._winScale)
            armatureNode:addChild(armature3, lt.Constants.ENTITY_LAYER.EFFECT_BACK)
            self._armatureList[occupationId] = {armatureNode = armatureNode, heroItem = heroItem, leftModel = leftModel, infoImg = infoImg, armatureArray = {[0] = armature1, [1] = armature2, [2] = armature3}}
        elseif occupationId == lt.Constants.OCCUPATION.BWLR then
            heroItem:setPositionY(heroItem:getPositionY() + 50 * self._winScale)

            local armature1 = ccs.Armature:create(effectName)--红丝丝
            armature1:getAnimation():playWithIndex(0)
            armature1:setPosition(posX, posY + 50 * self._winScale)
            armatureNode:addChild(armature1, lt.Constants.ENTITY_LAYER.EFFECT_FRONT)

            local armature2 = ccs.Armature:create(effectName)
            armature2:getAnimation():playWithIndex(1)
            armature2:setPosition(posX, posY + 50 * self._winScale)
            armatureNode:addChild(armature2, lt.Constants.ENTITY_LAYER.EFFECT_FRONT)

            --左边的叶子
            local leftLeaf = display.newSprite("image/select/smodel_4_effect_yezi_fxq.png")
            local contentSize = leftLeaf:getContentSize()
            leftLeaf:setPosition(posX - 100 * self._winScale, posY + 200 * self._winScale + 50 * self._winScale)    
            leftLeaf:setScale(0.55,1)
            leftLeaf:setRotation(55)
            armatureNode:addChild(leftLeaf,100000)

            --右边的叶子
            local rightLeaf = display.newSprite("image/select/smodel_4_effect_yezi_fxq.png")
            rightLeaf:setPosition(heroItem:getPositionX()+130 * self._winScale,heroItem:getPositionY()+250 * self._winScale + 50 * self._winScale)
            rightLeaf:setScale(0.8,-1)
            rightLeaf:setRotation(120)
            armatureNode:addChild(rightLeaf)
            
            --[[--在某些andorid手机不支持,导致后续代码无法被执行
            local glprogram = cc.GLProgram:createWithFilenames("shader/normalTexture.vsh","shader/UVmove.fsh")
            local glprogramstate = cc.GLProgramState:getOrCreateWithGLProgram(glprogram)
            leftLeaf:setGLProgramState(glprogramstate)
            rightLeaf:setGLProgramState(glprogramstate)

            glprogramstate:setUniformVec2("fenpin",  {x = 1, y = 0.5})
            glprogramstate:setUniformFloat("speedX", 5.5)
            glprogramstate:setUniformFloat("speedY", 0.0)
            glprogramstate:setUniformFloat("alpha", 100)
            glprogramstate:setUniformVec3("color_rgb", {x = 255, y = 255,z = 255})  
            glprogramstate:setUniformVec2("v_scale", {x = posX - 100, y = 270})
            ]]

            local particle = cc.ParticleSystemQuad:create("effect/particle/smodel_4_effect_particle_fxq.plist")
            particle:setAnchorPoint(0.5,0.5)
            particle:setPosition(posX, posY + 220  * self._winScale + 50)
            particle:setGravity(cc.p(50,150))
            armatureNode:addChild(particle)

            self._armatureList[occupationId] = {armatureNode = armatureNode, heroItem = heroItem, leftModel = leftModel, particle = particle, infoImg = infoImg, armatureArray = {[0] = armature1, [1] = armature2}}
        end
    end
end

function SelectLayer:palyAudio(type)
    --音效
    if self._currentSoundId then
        if self._currentSoundType ~= type then
            lt.AudioManager:stopSound(self._currentSoundId)
            local soundName = self.RoleAudio[type]
            self._currentSoundId = lt.AudioManager:playSound(soundName)
            self._currentSoundType = type
        end
    else
        local soundName = self.RoleAudio[type]
        self._currentSoundId = lt.AudioManager:playSound(soundName)
        self._currentSoundType = type
    end
end

function SelectLayer:onSpineEvent(event)
    -- if event.type == "complete" then
    --     if self._armatureList[self._occupationId].armatureArray[2] then
    --         self._armatureList[self._occupationId].armatureArray[2]:getAnimation():playWithIndex(2)
    --     end
    --     --self._armature3:getAnimation():playWithIndex(2)
    -- end
end

function SelectLayer:updateInfo(reload, unfreezeAccountTime)

    local loginPlayerArray = lt.DataManager:getLoginPlayerArray()
    if #loginPlayerArray == 0 then
        self:getSelectPanel():setVisible(true)
        --self:getSelectNode(true):setVisible(false)
        
        --self:randName()
        self._sex = 1
        self._occupationId = lt.Constants.OCCUPATION.QS
        self._figureId = 20100

        self._rightBg:setVisible(false)
        self._status = self.STATUS.CREATE

        self:configCharacter()
        self:updateFigure(self._occupationId, 120)
        self:getSelectNode(true):setVisible(false)
    else
        --self._unfreeze_account_time = unfreezeAccountTime or self._unfreeze_account_time
        self:getSelectNode(true):setVisible(true)
        self:getSelectPanel():setVisible(false)
        self._rightBg:setVisible(true)
    end
end

function SelectLayer:onReturn()

    self._currentSelectIndex = -1
    if self._status == self.STATUS.CREATE or self._status == self.STATUS.START then
        self:setVisible(false)
        self._delegate:isfromSelectLayer()
        lt.NoticeManager:clearAll()
        lt.NoticeManager:init(self:getParent())
    else
        self:getSelectPanel():setVisible(false)
        --self:getSelectNode():setVisible(true)
        self._rightBg:setVisible(true)
        self._status = self.STATUS.START
        self:updateFigure(self._loginPlayer.occupation_id)
        self:getSelectNode():setVisible(true)

        --self._model:changeFigureId(self._loginPlayer.sex,self._loginPlayer.occupation_id,self._loginPlayer.figure_id)
        self._armatureList[self._loginPlayer.occupation_id].leftModel:getChildByTag(10):changeFigureId(self._loginPlayer.sex,self._loginPlayer.occupation_id,self._loginPlayer.figure_id)

        self:updateEquipmentFigure(self._loginPlayer.occupation_id,self._loginPlayer.id)
    end
end

function SelectLayer:onCreate()
    -- 判断名字长度
    local name = self._editBox:getText()

    if tonumber(name) ~= nil then
        lt.NoticeManager:addMessageString("STRING_SELECT_INPUT_NUMBER")
        return
    end

    local len = string.utf8len(name)

    
    if len == 0 then
        lt.NoticeManager:addMessageString("STRING_SELECT_INPUT_EMPTY")
        return
    end

    if len > 7 then
        lt.NoticeManager:addMessageString("STRING_SELECT_INPUT_LONG")
        return
    end

    if not cpp.Utils:isMatch(name) and device.platform ~= "windows" then
        lt.NoticeManager:addMessageString("STRING_ERROR_NICK_NAME_UN_LAWFUL")
        return
    end

    local hasWarning, str = lt.WarnStrFunc:warningStrGsub(name)

    if hasWarning then
        lt.NoticeManager:addMessageString("STRING_ERROR_NICK_NAME_UN_LAWFUL")
        return
    end

    -- 更新个人信息
    lt.SocketApi:create(self._occupationId, name, self._sex, self._figureId)
end

function SelectLayer:onStart()
    -- start
    local loginPlayerArray = lt.DataManager:getLoginPlayerArray()

    for k,player in pairs(loginPlayerArray) do
        if player.id == self._loginPlayer.id then
            self._loginPlayer = player
        end
    end

    local endtime = self._loginPlayer.unfreeze_account_time - lt.CommonUtil:getCurrentTime()
    if endtime > 0 then
        local str = string.format(lt.StringManager:getString("STRING_LOGIN_USER_FREEZED"), lt.CommonUtil:getFormatCountDown(endtime, 19))
        lt.AlertLayer:alertOn(str)
        return
    end

    -- 避免连读点击
    self._delayHandler = lt.scheduler.performWithDelayGlobal(function()
        self._startBtn:setTouchEnabled(true)
        self._maskClick:setVisible(false)
        lt.scheduler.unscheduleGlobal(self._delayHandler)
        self._delayHandler = nil
    end, 4)
    self._startBtn:setTouchEnabled(false)

    if not self._maskClick then
        self._maskClick = display.newLayer()
        self._maskClick:setNodeEventEnabled(true)
        self._maskClick:setTouchSwallowEnabled(true)
        self._maskClick:setAnchorPoint(0,0)
        self._maskClick:setPosition(0,0)
        self:addChild(self._maskClick, 20000)
    else
        self._maskClick:setVisible(true)
    end

    local loginId = lt.PreferenceManager:getLoginId(lt.DataManager:getToken())
    lt.SocketApi:flush(loginId)
end

function SelectLayer:onRandName()
    self:randName()
end

function SelectLayer:randName()
    local surname = 0
    lt.SocketApi:randomName(self._sex,surname)
end

function SelectLayer:getSelectNode(reload)
    if not self._selectNode or reload then
        if reload and self._selectNode then
            self._selectNode:removeFromParent()
            self._cellArray = {}
        end

        self._selectNode = display.newNode()
        self:addChild(self._selectNode, 100)

        local titleIcon = display.newSprite("#select_label_role.png")
        titleIcon:setPosition(display.right-self._rightBg:getContentSize().width/2,display.top-30)
        self._selectNode:addChild(titleIcon)

        local titleBg = display.newSprite("#select_name_bg.png")
        titleBg:setPosition(titleIcon:getContentSize().width/2,titleIcon:getContentSize().height/2)
        titleIcon:addChild(titleBg,-1)

        local deleteBtn = lt.ScaleButton.new("#select_btn_delete.png")
        deleteBtn:setPosition(titleIcon:getPositionX()-90,80)
        deleteBtn:onButtonClicked(handler(self,self.onDelete))
        self._selectNode:addChild(deleteBtn)

         -- 开始按钮
        self._startBtn = lt.ScaleBMLabelButton.newBlue("STRING_START","common_btn.fnt")
        self._startBtn:setPosition(display.right-self._rightBg:getContentSize().width/2+20, 80)
        self._startBtn:onButtonClicked(handler(self, self.onStart))
        self._selectNode:addChild(self._startBtn)


        -- local modelBg = display.newSprite("#select_model_bg.png")
        -- modelBg:setPosition(120,70)
        -- self._selectNode:addChild(modelBg)

        local playerArray = lt.DataManager:getLoginPlayerArray()
        for i=1,5 do
            local cell = RoleCell.new()
            cell:setPosition(titleIcon:getPositionX(), titleIcon:getPositionY() - 70 - 92*(i-1))
            self._selectNode:addChild(cell)

            if i <= 3 then
                local btnIcon = cc.ui.UIPushButton.new()
                btnIcon:setTag(0)
                btnIcon:setPosition(cell:getContentSize().width / 2,cell:getContentSize().height / 2)
                btnIcon:setContentSize(cell:getContentSize().width, cell:getContentSize().height)
                btnIcon:onButtonClicked(handler(self, self.onClickCell))
                cell:addChild(btnIcon)


                local player = playerArray[i]
                if player then
                    cell:updateInfo(player)

                    btnIcon:setTag(i)

                    if player.id == lt.PreferenceManager:getLoginId(lt.DataManager:getToken()) then
                        self._loginPlayer = player
                        cell:select()
                        local endtime = player.unfreeze_account_time - lt.CommonUtil:getCurrentTime()
                        if endtime> 0 then--这个角色被封禁
                            
                        end
                        self:updateFigure(player.occupation_id)

                        -- self._model = lt.HeroItem.new(player.sex,player.occupation_id,player.figure_id)
                        -- self._model:playActionStand()
                        -- self._model:setPosition(modelBg:getContentSize().width/2,modelBg:getContentSize().height/2)
                        -- modelBg:addChild(self._model)

                        self:updateEquipmentFigure(player.occupation_id,player.id)
                    end
                end

                self._cellArray[i] = cell
            else
                cell:setLock()
            end
        end
    end
    return self._selectNode
end

function SelectLayer:unSelectAll()
    for _,cell in pairs(self._cellArray) do
        cell:unSelect()
    end
end

function SelectLayer:getSelectPanel()--创建角色界面
    if not self._selectPanel then
        self._selectPanel = display.newNode()
        self:addChild(self._selectPanel,10)

        -- 输入框 
        local inputBg = display.newSprite("#select_occupation_namebg.png")
        inputBg:setAnchorPoint(1,0.5)
        inputBg:setPosition(display.width - 25,display.height / 2 - 20)
        self._selectPanel:addChild(inputBg)

        self._editBox = lt.GameInput.new({
            image = display.newScale9Sprite(),
            size = cc.size(162, 35),
            showWarningStr = true,
            x = inputBg:getContentSize().width / 2-20,
            y = inputBg:getContentSize().height / 2 ,
        })
        self._editBox:setMaxLength(7)

        self._editBox:setFont(lt.Constants.FONT, 20)
        self._editBox:setFontColor(lt.Constants.COLOR.WHITE)
        self._editBox:setPlaceHolder(lt.StringManager:getString("STRING_SELECT_INPUT_NAME"))
        self._editBox:setPlaceholderFont(lt.Constants.FONT, 20)
        self._editBox:setPlaceholderFontColor(lt.Constants.COLOR.WHITE)
        self._editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
        inputBg:addChild(self._editBox)

        local randBtn = lt.ScaleButton.new("#select_icon_ dice.png")
        randBtn:setPosition(inputBg:getPositionX() - 20, inputBg:getPositionY())
        randBtn:onButtonClicked(handler(self, self.onRandName))
        self._selectPanel:addChild(randBtn)

        local knightBtn = lt.ScaleButton.new("#select_btn_occupation_qs.png")
        knightBtn:onButtonClicked(handler(self, self.onSelect))
        knightBtn:setPosition(display.left + 236, display.top - 110)
        knightBtn:setTag(lt.Constants.OCCUPATION.QS)
        self._selectPanel:addChild(knightBtn, 100)

        local mfsBtn = lt.ScaleButton.new("#select_btn_occupation_mfs.png")
        mfsBtn:onButtonClicked(handler(self, self.onSelect))
        mfsBtn:setPosition(knightBtn:getPositionX()+20, knightBtn:getPositionY()-120)
        mfsBtn:setTag(lt.Constants.OCCUPATION.MFS)
        self._selectPanel:addChild(mfsBtn, 100)

        local jsBtn = lt.ScaleButton.new("#select_btn_occupation_js.png")
        jsBtn:onButtonClicked(handler(self, self.onSelect))
        jsBtn:setPosition(mfsBtn:getPositionX()+20, mfsBtn:getPositionY()-120)
        jsBtn:setTag(lt.Constants.OCCUPATION.JS)
        self._selectPanel:addChild(jsBtn, 100)

        local bwlrBtn = lt.ScaleButton.new("#select_btn_occupation_bwlr.png")
        bwlrBtn:onButtonClicked(handler(self, self.onSelect))
        bwlrBtn:setPosition(jsBtn:getPositionX()+20, jsBtn:getPositionY()-120)
        bwlrBtn:setTag(lt.Constants.OCCUPATION.BWLR)
        self._selectPanel:addChild(bwlrBtn, 100)

        local createBtn = lt.ScaleButton.new("#select_occupation_startbtn.png")
        createBtn:setPosition(display.right-105, 95)
        createBtn:onButtonClicked(handler(self, self.onCreate))
        self._selectPanel:addChild(createBtn)

    end
    return self._selectPanel
end

function SelectLayer:onSelect(event)--创建界面  选择角色
    local occupationId = event.target:getTag()

    if occupationId == self._occupationId then
        return
    end
    self._occupationId = occupationId
    if occupationId == lt.Constants.OCCUPATION.QS then
        self._sex = 1
        self._figureId = 20100
    elseif occupationId == lt.Constants.OCCUPATION.MFS then
        self._sex = 2
        self._figureId = 40100
    elseif occupationId == lt.Constants.OCCUPATION.JS then
        self._sex = 1
        self._figureId = 80100
    else
        self._sex = 2
        self._figureId = 60100
    end

    --self:onRandName()

    self:configCharacter()
    self:updateFigure(occupationId,120)
end

function SelectLayer:configCharacter()--创建界面  属性
    if self._characterBg then
        self._characterBg:removeFromParent()
        self._characterBg = nil
    end
    self._characterBg = display.newSprite("#select_occupation_character_"..self._occupationId..".png")
    self._characterBg:setAnchorPoint(1,1)
    self._characterBg:setPosition(display.width - 25,display.height - 25)
    self._selectPanel:addChild(self._characterBg)
end

function SelectLayer:onClickCell(event)--切换已有角色
    local idx = event.target:getTag()
    if self._currentSelectIndex ~= idx then
        self._currentSelectIndex = idx
    else
        return
    end

    if idx == 0 then
        self._status = self.STATUS.RECREATE
        --self:getSelectNode():setVisible(false)
        self:getSelectPanel():setVisible(true)
        self._rightBg:setVisible(false)
        --self:randName()
        self._sex = 1
        self._occupationId = lt.Constants.OCCUPATION.QS
        self._figureId = 20100

        self:configCharacter()
        self:updateFigure(self._occupationId,120)
        self:getSelectNode():setVisible(false)
        return
    end

    local playerArray = lt.DataManager:getLoginPlayerArray()
    local player = playerArray[idx]
    if player then
        lt.PreferenceManager:setLoginId(lt.DataManager:getToken(),player.id)
        self._loginPlayer = player
        self:updateFigure(player.occupation_id)
        --self._model:changeFigureId(player.sex,player.occupation_id,player.figure_id)
        self._armatureList[player.occupation_id].leftModel:getChildByTag(10):changeFigureId(player.sex,player.occupation_id,player.figure_id)

        self:updateEquipmentFigure(player.occupation_id,player.id)
        self:unSelectAll()
        local cell = self._cellArray[idx]
        cell:select()
    end
end

function SelectLayer:onDelete()
    local scrollConfirmLayer = lt.ScrollConfirmLayer.new(handler(self,self.onScrollEnd), 1)
    self:addChild(scrollConfirmLayer, 10000000)
end

function SelectLayer:onScrollEnd()
    local deleteConfirmLayer = lt.DeleteConfirmLayer.new(self._loginPlayer, lt.DeleteConfirmLayer.TYPE.HERO)
    self:addChild(deleteConfirmLayer)
end

function SelectLayer:onCreateResponse(event)
    local s2cCreate = event.data
    lt.CommonUtil.print("s2cCreate code: ", s2cCreate.code)
    lt.CommonUtil.print("s2cCreate player_id: ", s2cCreate.player_id)

    if s2cCreate.code == lt.SocketConstants.CODE_NICK_NAME_EXISTS then
        lt.NoticeManager:addMessageString("STRING_ERROR_NICK_NAME_EXISTS")
        return
    end

    if s2cCreate.code == lt.SocketConstants.CODE_NAME_INVALID then
        lt.NoticeManager:addMessageString("STRING_ERROR_NICK_NAME_UN_LAWFUL")
        return
    end

    if s2cCreate.code == lt.SocketConstants.CODE_PLAYER_ALREADY_FULL then
        lt.NoticeManager:addMessageString("STRING_ERROR_PLAYER_ALREADY_FULL")
        return
    end

    if s2cCreate.code ~= lt.SocketConstants.CODE_OK then
        return
    end

    local playerId = s2cCreate.player_id
    lt.PreferenceManager:setLoginId(lt.DataManager:getToken(),playerId)
    lt.SocketApi:flush(playerId)


    -- SDK统计
    if device.platform == "ios" or device.platform == "android" then
        if s2cCreate:HasField("create_time") then
            -- 设定创建时间
            local createTime = s2cCreate.create_time

            if cpp.SdkService:shared().setCreateTime then
                cpp.SdkService:shared():setCreateTime(createTime)
            end
        end

        local serverId = lt.DataManager:getCurServerId()
        local serverName = ""
        local serverInfo = lt.DataManager:getServerInfo(serverId)
        if serverInfo then
            serverName = serverInfo:getName()
        end
        cpp.SdkService:shared():createRole(s2cCreate.player_id , s2cCreate.name, 1, serverId, serverName)
    end
end

function SelectLayer:onRandomNameResponse(event)
    local s2cRandomName = event.data
    lt.CommonUtil.print("s2cRandomName code: ", s2cRandomName.code)

    local name = s2cRandomName.name
    self._editBox:setText(name)
end

function SelectLayer:onDeletePlayerResponse(event)
    local s2cDeletePlayer = event.data
    lt.CommonUtil.print("s2cDeletePlayer code: ", s2cDeletePlayer.code)

    if s2cDeletePlayer.code == lt.SocketConstants.CODE_OK then
        self:updateInfo(true)
    end
end

-- 更新模型装备
function SelectLayer:updateEquipmentFigure(occupationId,playerId)
    local serverId = lt.DataManager:getCurServerId()
    local weaponInfo = lt.PreferenceManager:getWeaponInfo(serverId,playerId)

    local weapon = nil
    if weaponInfo.weapon_id and weaponInfo.weapon_id > 0 then

        if weaponInfo.is_weapon_effect_id > 0 then --存的特效FigureIdid
            local hasEffect = false
            if weaponInfo.unlock_weapon > 0 then
                hasEffect = true
            end
            weapon = {figureId = weaponInfo.weapon_id, hasEffect = hasEffect}
        else
            local equipmentInfo = lt.CacheManager:getEquipmentInfo(weaponInfo.weapon_id)
            if equipmentInfo then
                local figureId = equipmentInfo:getFigureId()
                local hasEffect = false
                if weaponInfo.unlock_weapon > 0 then
                    hasEffect = true
                end
                weapon = {figureId = figureId, hasEffect = hasEffect}
            end
        end
    end

    if not weapon then
        -- 默认
        weapon = {figureId = lt.ResourceManager:getBaseEquipmentId(occupationId, lt.Constants.EQUIPMENT_TYPE.WEAPON), hasEffect = false}
    end

    local assistant = nil
    if weaponInfo.assistant_id and weaponInfo.assistant_id > 0 then
        
        if weaponInfo.is_assistant_effect_id > 0 then
            local hasEffect = false
            if weaponInfo.unlock_assistant > 0 then
                hasEffect = true
            end
            assistant = {figureId = weaponInfo.assistant_id, hasEffect = hasEffect}
        else
            local equipmentInfo = lt.CacheManager:getEquipmentInfo(weaponInfo.assistant_id)
            if equipmentInfo then
                local figureId = equipmentInfo:getFigureId()
                local hasEffect = false
                if weaponInfo.unlock_assistant > 0 then
                    hasEffect = true
                end
                assistant = {figureId = figureId, hasEffect = hasEffect}
            end
        end
    end

    if not assistant then
        assistant = {figureId = lt.ResourceManager:getBaseEquipmentId(occupationId, lt.Constants.EQUIPMENT_TYPE.ASSISTANT), hasEffect = false}
    end

    self._armatureList[occupationId].leftModel:getChildByTag(10):changeEquipment(lt.Constants.EQUIPMENT_TYPE.WEAPON, weapon)
    self._armatureList[occupationId].leftModel:getChildByTag(10):changeEquipment(lt.Constants.EQUIPMENT_TYPE.ASSISTANT, assistant)
    -- self._model:changeEquipment(lt.Constants.EQUIPMENT_TYPE.WEAPON, weapon)
    -- self._model:changeEquipment(lt.Constants.EQUIPMENT_TYPE.ASSISTANT, assistant)
end

return SelectLayer
