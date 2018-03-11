
local InitLayer = class("InitLayer",lt.BaseLayer,function()
    return cc.CSLoader:createNode("games/comm/launch/LaunchLayer.csb")
end)

function InitLayer:ctor(...)
    InitLayer.super.ctor(self, ...)
    self._rootNode = self
    --self._updateLayer = cc.CSLoader:createNode("games/comm/launch//UpdateLayer.csb")

    self._loginLayer = cc.CSLoader:createNode("games/comm/launch/LoginLayer.csb")

    --self._rootNode:addChild(self._updateLayer)
    self._rootNode:addChild(self._loginLayer)

    local Pl_Bg = self._loginLayer:getChildByName("Pl_Bg")
    self._loginBtn = Pl_Bg:getChildByName("Bn_Login")

    self:RegisterWidgetEvent()
end

function InitLayer:onConnectResponse(msg)--连接成功回调
    self._connectSuccess = true
end

function InitLayer:onLogin()--登录微信
    -- 正常游戏

    if self._connectSuccess then
        local arg = {account="FYD3",token="FYD",login_type="debug"}--weixin
        lt.NetWork:send({["login"]=arg})
    end

    -- local worldScene = lt.WorldScene.new()
    -- lt.SceneManager:replaceScene(worldScene)
end

function InitLayer:onLoginResponse(msg)--登录回调
    if msg.result == "success" then
        local user_id = msg.user_id
        local reconnect_token = msg.reconnect_token
        --user:init(user_id,reconnect_token)
        print("登陆成功  user_id="..msg.user_id.." reconnect_token=",msg.reconnect_token)

        local worldScene = lt.WorldScene.new()
        lt.SceneManager:replaceScene(worldScene)
    else
        print("登陆失败")
    end
end

function InitLayer:RegisterEvent()--注册事件的回调
    
end

function InitLayer:RegisterWidgetEvent()
    lt.CommonUtil:addNodeClickEvent(self._loginBtn, handler(self, self.onLogin))
end

function InitLayer:onEnter()   
    print("InitLayer:onEnter")
    lt.GameEventManager:addListener("login", handler(self, self.onLoginResponse), "InitLayer:onLoginResponse")

    lt.NetWork:connect("47.52.99.120", 8888, handler(self, self.onConnectResponse))
end

function InitLayer:onExit()
    print("InitLayer:onExit")
    lt.GameEventManager:removeListener("login", "InitLayer:onLoginResponse")
end

--[[
    下面代码先放着，以后再说看看
]]--

function InitLayer:initGame()
    self._progress:setPercentage(self.PERCENTAGE.INIT_GAME)
    self._progressLabel:setString(self.PERCENTAGE.INIT_GAME.."%")

    self._infoTips:setString(lt.StringManager:getString("STRING_INIT_GAME"))

    if device.platform == "windows" and not GAME_LOCAL then
        -- 校验资源完整性
        self._delayHandler = lt.scheduler.performWithDelayGlobal(handler(self, self.checkGame), 0)
    else
        -- 游戏初始化(展开游戏资源)
        self._delayHandler = lt.scheduler.performWithDelayGlobal(handler(self, self.initData), 0)
    end
end

function InitLayer:checkGame()
    self._infoTips:setString(lt.StringManager:getString("STRING_CHECK_GAME"))

    -- TODO:发送请求
    print("TODO:发送请求")
end

function InitLayer:initData()
    local initResult, initCount, initSum = lt.CacheManager:initData()
    if initResult then
        -- 只有一个初始化 直接开始下一步
        self._progress:setPercentage(self.PERCENTAGE.INIT_GAME + self.PERCENTAGE.INIT_DATA)
        self._progressLabel:setString((self.PERCENTAGE.INIT_GAME + self.PERCENTAGE.INIT_DATA).."%")

        self._infoTips:setString(lt.StringManager:getString("STRING_INIT_DATA"))

        self._delayHandler = lt.scheduler.performWithDelayGlobal(handler(self, self.initResource), 0)
    else
        local percentage = self.PERCENTAGE.INIT_GAME + self.PERCENTAGE.INIT_DATA * initCount / initSum
        self._progress:setPercentage(percentage)
        self._progressLabel:setString(string.format("%.0f%%", percentage))

        self._infoTips:setString(lt.StringManager:getString("STRING_INIT_DATA"))

        self._delayHandler = lt.scheduler.scheduleUpdateGlobal(handler(self, self.initDataStep))
    end
end

function InitLayer:initDataStep()
    local initResult, initCount, initSum = lt.CacheManager:initData()
    if initResult then
        -- 所有数据初始化完毕
        self._progress:setPercentage(self.PERCENTAGE.INIT_GAME + self.PERCENTAGE.INIT_DATA)
        self._progressLabel:setString((self.PERCENTAGE.INIT_GAME + self.PERCENTAGE.INIT_DATA).."%")

        self._infoTips:setString(lt.StringManager:getString("STRING_INIT_RESOURCE"))

        lt.scheduler.unscheduleGlobal(self._delayHandler)
        self._delayHandler = lt.scheduler.performWithDelayGlobal(handler(self, self.initResource), 0)
    else
        -- 继续下一个
        local percentage = self.PERCENTAGE.INIT_GAME + self.PERCENTAGE.INIT_DATA * initCount / initSum
        self._progress:setPercentage(percentage)
        self._progressLabel:setString(string.format("%.0f%%", percentage))
    end
end

-- 加载通用特效资源
function InitLayer:initResource()
    lt.ResourceManager:setLoadArmatureResourceStepCallback(handler(self, self.initResourceStep))
    lt.ResourceManager:setLoadArmatureResourceCompleteCallback(handler(self, self.initResourceOK))

    self._initResourceCount = 0
    self._initResourceSum   = 0

    -- 速度线
    local armatureName = "battle_boss_endline"
    local armatureFile = "effect/ui/"..armatureName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    local armatureName = "roll_line"
    local armatureFile = "effect/other/"..armatureName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    local armatureName = "roll_line_2"
    local armatureFile = "effect/other/"..armatureName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    -- 人物升级特效
    local armatureName = "uieffect_herolevelup"
    local armatureFile = "effect/ui/"..armatureName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    local armatureName = "uieffect_levelup_bg"
    local armatureFile = "effect/ui/"..armatureName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    local armatureName = "uieffect_levelup_screen"
    local armatureFile = "effect/ui/"..armatureName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    -- 小红点
    local armatureName = "uieffect_new_icon"
    local armatureFile = "effect/ui/"..armatureName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    -- 进度条
    local armatureName = "uiefffect_progress"
    local armatureFile = "effect/ui/"..armatureName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    -- 任务完成
    local armatureName = "battle_task_complete"
    local armatureFile = "effect/ui/"..armatureName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    -- 主角死亡
    local armatureName = "monster_die_0"
    local armatureFile = "effect/other/"..armatureName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    -- 小怪死亡
    local armatureName = "battle_hero_relive"
    local armatureFile = "effect/other/"..armatureName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    -- 眩晕buff
    local armatureName = "battle_buff_201"
    local armatureFile = "effect/buff/"..armatureName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    -- 技能预警
    local armatureName = "trigger_earlywarning"
    local armatureFile = "effect/other/"..armatureName..".ExportJson"

    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    local armatureName = "sk_earlywarning_2"
    local armatureFile = "effect/other/"..armatureName..".ExportJson"

    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    -- 技能爆发
    local armatureName = "riseattack"
    local armatureFile = "effect/other/"..armatureName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    -- 传送门/点 特效
    local armatureName = "map_transfer_door_2"
    local armatureFile = "effect/env/"..armatureName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)
    
    local armatureName = "world_dungeon_transfer"
    local armatureFile = "effect/env/"..armatureName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)

    -- 受击效果(只剩4种)
    local hitName = "hit_general1"
    local hitFile = "effect/hit/"..hitName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(hitName, hitFile)

    local hitName = "hit_general2"
    local hitFile = "effect/hit/"..hitName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(hitName, hitFile)

    local hitName = "hit_general3"
    local hitFile = "effect/hit/"..hitName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(hitName, hitFile)

    local hitName = "hit39_fxq"
    local hitFile = "effect/hit/"..hitName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(hitName, hitFile)

    -- 法师的法球
    for i=0,5 do
        local armatureName = "atk2_"..i
        local armatureFile = "effect/atk/"..armatureName..".ExportJson"
        lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)
    end

    -- 法师蓄力效果
    local burstName = "battle_weapon_effect_fs"
    local burstJson = "effect/other/"..burstName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(burstName, burstJson)

    local burstUIName = "uieffect_weapon_effect_fs"
    local burstUIJson = "effect/ui/"..burstUIName..".ExportJson"
    lt.ResourceManager:loadArmatureResource(burstUIName, burstUIJson)
    
    -- 职业技能
    for i=1,4 do
        local skillIndexArray = lt.BattleConfig:getSkillIndexArray(i)
        for _,skillIndex in ipairs(skillIndexArray) do
            local skillId = skillIndex * 1000

            local armatureName = "hsk"..skillId
            local armatureFile = "effect/sk/"..armatureName..".ExportJson"

            lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)
        end
    end

    if device.platform == "android" or device.platform == "mac" or device.platform == "windows" then
    -- if device.platform == "android" then
        -- 预加载部分英灵技能特效
        local skillIdArray = {
            2100,
            2200,
            2300,
            2400,
            2500,
            6600,
            6700,
            6800,
            6900,
            7000,
            10100,
            10200,
            10300,
            10400,
            10500,
            11100,
            11200,
            11300,
            11400,
            11500,
            12100,
            12200,
            12300,
            12400,
            12500,
        }

        for _,skillId in ipairs(skillIdArray) do
            local armatureName = "ssk"..skillId
            local armatureFile = "effect/sk/"..armatureName..".ExportJson"

            lt.ResourceManager:loadArmatureResource(armatureName, armatureFile)
        end
    end

    self._initResourceSum = lt.ResourceManager:getAddingResourceArrayCount()
end

function InitLayer:initResourceStep()
    self._initResourceCount = self._initResourceCount + 1

    self._initResourceCount = math.min(self._initResourceCount, self._initResourceSum)

    local percentage = self.PERCENTAGE.INIT_GAME + self.PERCENTAGE.INIT_DATA + self.PERCENTAGE.INIT_RESOURCE * self._initResourceCount / self._initResourceSum
    self._progress:setPercentage(percentage)
    self._progressLabel:setString(string.format("%.0f%%", percentage))
end

function InitLayer:initResourceOK()
    local percentage = self.PERCENTAGE.INIT_GAME + self.PERCENTAGE.INIT_DATA + self.PERCENTAGE.INIT_RESOURCE
    self._progress:setPercentage(percentage)
    self._progressLabel:setString(percentage.."%")

    self._infoTips:setString(lt.StringManager:getString("STRING_INIT_OTHER"))

    -- 游戏初始化
    self._delayHandler = lt.scheduler.performWithDelayGlobal(handler(self, self.initOther), 0)
end

function InitLayer:initOther()
    -- 受击音效
    lt.AudioManager:preloadSound("effect/audio_hit_2", 2)
    lt.AudioManager:preloadSound("effect/audio_hit_3", 2)
    lt.AudioManager:preloadSound("effect/audio_hit_6", 2)

    -- 技能音效
    if device.platform == "android" or device.platform == "mac" or device.platform == "windows" then
        local soundArray = {
            "effect/audio_atk_1_1",
            "effect/audio_atk_1_2",
            "effect/audio_atk_1_3",
            "effect/audio_atk_1_4",
            "effect/audio_atk_2_1",
            "effect/audio_atk_2_2",
            "effect/audio_atk_3_1",
            "effect/audio_atk_3_2",
            "effect/audio_atk_3_3",
            "effect/audio_atk_4_1",
            "effect/audio_atk_4_2",
            "effect/audio_atk_4_3",
            "effect/audio_atk_4_4",
            "skill/audio_hsk_2000_1",
            "skill/audio_hsk_4000_1",
            "skill/audio_hsk_5000_1",
            "skill/audio_hsk_6000_1",
            "skill/audio_hsk_7000_2",
            "skill/audio_hsk_8000_2",
            "skill/audio_hsk_9000_2",
            "skill/audio_hsk_12000_2",
            "skill/audio_hsk_13000_2",
            "skill/audio_hsk_14000_2",
            "skill/audio_hsk_16000_2",
            "skill/audio_hsk_18000_2",
            "skill/audio_hsk_19000_1",
            "skill/audio_hsk_20000_1",
            "skill/audio_hsk_21000_1",
            "skill/audio_hsk_22000_1",
        }

        for _,soundName in ipairs(soundArray) do
            lt.AudioManager:preloadSound(soundName)
        end

        if not __G__PLAYER__LOGOUT__TYPE__ then
            -- 缓存所有英灵/主角模型
            local serverModelIdArray = {
                100005,
                100014,
                100021,
                100023,
                100025,
            }

            for _,serverModelId in ipairs(serverModelIdArray) do
                local skel  = "model/model_"..serverModelId..".skel"
                local atlas = "model/model_"..serverModelId..".atlas"

                local tempSkeletonAnimation = lt.SpSkeletonAnimation.new(skel, atlas, 1, true)
            end

            local dressIdTable = {
                201100,
                202100,
                401200,
                402200,
                601200,
                602200,
                801100,
                802100,
            }

            for _,dressId in ipairs(dressIdTable) do
                local dressInfo = lt.CacheManager:getDress(dressId)
                if dressInfo then
                    local figureId     = dressInfo:getFigureId()
                    local sex          = dressInfo:getSex()
                    local occupationId = dressInfo:getOccupation()

                    local skel  = "model/role_"..figureId.."_"..sex.."_"..occupationId..".skel"
                    local atlas = "model/role_"..figureId.."_"..sex..".atlas"

                    local tempSkeletonAnimation = lt.SpSkeletonAnimation.new(skel, atlas, 1, true)
                end
            end
        end
    end

    local percentage = self.PERCENTAGE.INIT_GAME + self.PERCENTAGE.INIT_DATA + self.PERCENTAGE.INIT_RESOURCE + self.PERCENTAGE.INIT_OTHER
    self._progress:setPercentage(percentage)
    self._progressLabel:setString(percentage.."%")

    self._infoTips:setString(lt.StringManager:getString("STRING_INIT_END"))

    -- 游戏初始化
    self._delayHandler = lt.scheduler.performWithDelayGlobal(handler(self, self.initComplete), 0)
end

function InitLayer:initComplete()
    self._progress:setPercentage(100)
    self._progressLabel:setString("100%")

    self._delayHandler = nil

    -- 游戏开始界面
    local startScene = lt.StartScene.new()
    lt.SceneManager:replaceScene(startScene)
end

return InitLayer