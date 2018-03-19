
-- ################################################## 资源管理 ##################################################
local armatureDataManager = ccs.ArmatureDataManager:getInstance()

local ResourceManager = {}

ResourceManager._loadedSpriteFramesTable = nil
ResourceManager._loadedSpriteFramesMap   = nil
ResourceManager._loadedArmatureTable     = nil
ResourceManager._loadedArmatureMap       = nil

ResourceManager._loadResourceHandler  = nil
ResourceManager._loadWorldResourceHandler	 = nil

ResourceManager._loadWorldResourceCallback = nil
ResourceManager._loadedWorldResourceArray = nil
ResourceManager._addingWorldResourceArray = nil

ResourceManager._loadedResourceArray = nil
ResourceManager._addingResourceArray = nil

function ResourceManager:init()
    self._loadedSpriteFramesTable = {}
    self._loadedSpriteFramesMap = {}
    self._loadedArmatureTable = {}
    self._loadedArmatureMap = {}

    self._loadedWorldResourceArray = {}
    self._addingWorldResourceArray = {}

    self._loadedResourceArray = {}
    self._addingResourceArray = {}

    self._mapResourceArray = {}
end

function ResourceManager:clear()
    lt.CommonUtil.print("ResourceManager:clear")
    -- 停止当前相关回调
    if self._loadResourceHandler then
        lt.scheduler.unscheduleGlobal(self._loadResourceHandler)
        self._loadResourceHandler = nil
    end

    if self._loadWorldResourceHandler then
        lt.scheduler.unscheduleGlobal(self._loadWorldResourceHandler)
        self._loadWorldResourceHandler = nil
    end

    -- 清除所有资源
    if self._loadedArmatureMap then
        for _,armatureFile in pairs(self._loadedArmatureMap) do
            self:removeArmatureFileInfo(armatureFile)
        end
    end

    for plist,texture in pairs(self._loadedSpriteFramesMap) do
        display.removeSpriteFramesWithFile(plist, texture)
    end
end

-- spriteFrames
function ResourceManager:isSpriteFramesLoaded(plist)
    return isset(self._loadedSpriteFramesTable, plist)
end

function ResourceManager:addSpriteFrames(plist, texture, ignoreSet)
    if not plist or not texture then
        return
    end

    if not isset(self._loadedSpriteFramesTable, plist) then
        self._loadedSpriteFramesTable[plist] = 1
        self._loadedSpriteFramesMap[plist] = texture

        print("加载资源！！！！！！！！！！！！！！11", plist, texture)
        
        display.loadSpriteFrames(plist, texture)
    else
        self._loadedSpriteFramesTable[plist] = self._loadedSpriteFramesTable[plist] + 1
    end
end

function ResourceManager:removeSpriteFrames(plist, texture)
    if not isset(self._loadedSpriteFramesTable, plist) then
        lt.CommonUtil.print("SpriteFrames "..plist.." is not load !!!")
        return
    end

    self._loadedSpriteFramesTable[plist] = self._loadedSpriteFramesTable[plist] - 1

    if self._loadedSpriteFramesTable[plist] == 0 then
        self._loadedSpriteFramesTable[plist] = nil
        self._loadedSpriteFramesMap[plist] = nil

        display.removeSpriteFrames(plist, texture)
    end
end

-- 特效
function ResourceManager:isArmatureLoaded(armatureName)
    return isset(self._loadedArmatureTable, armatureName)
end

function ResourceManager:addArmature(armatureName, armatureFile, ignoreSet)
    if not armatureName or not armatureFile then
        lt.CommonUtil.print("addArmature nil ???")
        return
    end
        
    if not isset(self._loadedArmatureTable, armatureName) then
        self._loadedArmatureTable[armatureName] = 1
        self._loadedArmatureMap[armatureName] = armatureFile

        if not ignoreSet and lt.PreferenceManager:getTextureSet() < 3 then
            cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2D_PIXEL_FORMAT_RGBA4444)
        end

        self:addArmatureFileInfo(armatureFile)

        cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2D_PIXEL_FORMAT_RGBA8888)
    else
        self._loadedArmatureTable[armatureName] = self._loadedArmatureTable[armatureName] + 1
    end
end

function ResourceManager:removeArmature(armatureName, armatureFile)
    if not isset(self._loadedArmatureTable, armatureName) then
        lt.CommonUtil.print("Armature "..armatureName.." is not load !!!")
        return
    end

    self._loadedArmatureTable[armatureName] = self._loadedArmatureTable[armatureName] - 1

    if self._loadedArmatureTable[armatureName] == 0 then
        self._loadedArmatureTable[armatureName] = nil
        self._loadedArmatureMap[armatureName] = nil

        self:removeArmatureFileInfo(armatureFile)
    end
end

function ResourceManager:addArmatureFileInfo(configFilePath)
    armatureDataManager:addArmatureFileInfo(configFilePath)
end

function ResourceManager:removeArmatureFileInfo(configFilePath)
    armatureDataManager:removeArmatureFileInfo(configFilePath, true)
end

function ResourceManager:clearSceneResource( ... )
end

function ResourceManager:loadSceneResource()
    -- body
end

-- 加载世界地图资源
function ResourceManager:loadWorldResource(classId, loadMapResourceCallback)
	self._loadedWorldResourceArray  = {}
	self._addingWorldResourceArray  = {}
	self._loadWorldResourceCallback = loadMapResourceCallback

	local className  = "class"..classId
	local mapSetName = "map/"..className.."/resourceSet.json"

	local mapSetPath   = cc.FileUtils:getInstance():fullPathForFilename(mapSetName)
    local mapSetString = cc.FileUtils:getInstance():getStringFromFile(mapSetPath)
    local mapSetJson   = json.decode(mapSetString) or {}

    local count = 0
    
    -- 装饰图块
    count = mapSetJson.decoration or 0
    for i=0,count-1 do
    	local file    = "map/"..className.."/decoration-"..i
        local plist   = file..".plist"
        local texture = file..".png"

        table.insert(self._addingWorldResourceArray, {type = lt.Constants.RESOURCE_FRAME, plist = plist, texture = texture})
    end
    
    -- 特效图块
    count = mapSetJson.effect or 0
    for i=0,count-1 do
    	local file    = "map/"..className.."/effect-"..i
        local plist   = file..".plist"
        local texture = file..".png"

        table.insert(self._addingWorldResourceArray, {type = lt.Constants.RESOURCE_FRAME, plist = plist, texture = texture})
    end

    -- 遮罩图块
    count = mapSetJson.mask or 0
    for i=0,count-1 do
    	local file    = "map/"..className.."/mask-"..i
        local plist   = file..".plist"
        local texture = file..".png"

        table.insert(self._addingWorldResourceArray, {type = lt.Constants.RESOURCE_FRAME, plist = plist, texture = texture})
    end

    if not self._loadWorldResourceHandler then
    	self._loadWorldResourceHandler = lt.scheduler.scheduleUpdateGlobal(handler(self, self.loadWorldResourceUpdate))
    end
end

ResourceManager.LOAD_WORLD_RESOURCE_FUNC = {
    [lt.Constants.RESOURCE_FRAME] = function(self, resourceInfo)
        local plist   = resourceInfo.plist
        local texture = resourceInfo.texture

        self:addSpriteFrames(plist, texture)

        table.insert(self._loadedWorldResourceArray, resourceInfo)
        table.remove(self._addingWorldResourceArray)
    end,
    [lt.Constants.RESOURCE_ARMATURE] = function(self, resourceInfo)
        local armatureName = resourceInfo.armatureName
        local armatureFile = resourceInfo.armatureFile

        self:addArmature(armatureName, armatureFile)

        table.insert(self._loadedWorldResourceArray, resourceInfo)
        table.remove(self._addingWorldResourceArray)
    end,
}

ResourceManager.UNLOAD_WORLD_RESOURCE_FUNC = {
    [lt.Constants.RESOURCE_FRAME] = function(self, resourceInfo)
        local plist   = resourceInfo.plist
        local texture = resourceInfo.texture

        self:removeSpriteFrames(plist, texture)
    end,
    [lt.Constants.RESOURCE_ARMATURE] = function(self, resourceInfo)
        local armatureName = resourceInfo.armatureName
        local armatureFile = resourceInfo.armatureFile

        self:removeArmature(armatureName, armatureFile)
    end,
}

function ResourceManager:loadWorldResourceUpdate()
	if self._addingWorldResourceArray then
		local addingWorldResourceCount = #self._addingWorldResourceArray

		if addingWorldResourceCount == 0 then
			-- 全部任务完成
			if self._loadWorldResourceCallback then
				-- 执行回调
				self._loadWorldResourceCallback()
			end
		else
			-- 加载资源
			local resourceInfo = self._addingWorldResourceArray[addingWorldResourceCount]

            local type = resourceInfo.type
            local func = self.LOAD_WORLD_RESOURCE_FUNC[type]
            if func then
                func(self, resourceInfo)
            else
                lt.CommonUtil.print("lack LOAD_WORLD_RESOURCE_FUNC for type %d", type)
            end
            return
		end
	end
	
	self:clearWorldResourceUpdate()
end

function ResourceManager:clearWorldResourceUpdate()
    if self._loadWorldResourceHandler then
        lt.scheduler.unscheduleGlobal(self._loadWorldResourceHandler)
        self._loadWorldResourceHandler = nil
    end

    self._loadWorldResourceCallback = nil

    self._addingWorldResourceArray = {}
end

-- 卸载主城资源
function ResourceManager:unloadWorldResource()
    -- 清理正在加载的内容
    self:clearWorldResourceUpdate()

    for _,resourceInfo in ipairs(self._loadedWorldResourceArray) do
        local type = resourceInfo.type
        local func = self.UNLOAD_WORLD_RESOURCE_FUNC[type]
        if func then
            func(self, resourceInfo)
        else
            lt.CommonUtil.print("lack UNLOAD_WORLD_RESOURCE_FUNC for type %d", type)
        end
    end
    self._loadedWorldResourceArray = nil
end

-- 添加
function ResourceManager:loadWorldArmatureResource(armatureName, armatureFile)
    if self:isArmatureLoaded(armatureName) then
        -- 增加计数
        self:addArmature(armatureName, armatureFile)
        return true
    end

    -- 添加加载任务
    table.insert(self._addingWorldResourceArray, {type = lt.Constants.RESOURCE_ARMATURE, armatureName = armatureName, armatureFile = armatureFile})

    if not self._loadWorldResourceHandler then
        self._loadWorldResourceHandler = lt.scheduler.scheduleGlobal(handler(self, self.loadWorldResourceUpdate), 0.1)
    end
end

-- 随时加载随时释放资源
function ResourceManager:loadSpriteFramesResource(plist, texture)
    if self:isSpriteFramesLoaded(plist) then
        -- 增加计数
        self:addSpriteFrames(plist, texture)
        return true
    end

    -- 添加加载任务
    table.insert(self._addingResourceArray, {type = lt.Constants.RESOURCE_FRAME, plist = plist, texture = texture})

    if not self._loadResourceHandler then
        self._loadResourceHandler = lt.scheduler.scheduleGlobal(handler(self, self.loadResourceUpdate), 0.1)
    end
end

function ResourceManager:unloadSpriteFramesResource(plist, texture)
    if self:isSpriteFramesLoaded(plist) then
        self:removeSpriteFrames(plist, textur)
    else
        -- 查找正在添加的列表
        for key,resourceInfo in ipairs(self._addingResourceArray) do
            if resourceInfo.type == lt.Constants.RESOURCE_FRAME and resourceInfo.plist == plist then
                table.remove(self._addingResourceArray, key)
                break
            end
        end
    end
end

function ResourceManager:setLoadArmatureResourceStepCallback(callback)
    self._loadArmatureResourceStepCallback = callback
end

function ResourceManager:setLoadArmatureResourceCompleteCallback(callback)
    self._loadArmatureResourceCompleteCallback = callback
end

function ResourceManager:getAddingResourceArrayCount()
    return #self._addingResourceArray
end

function ResourceManager:loadArmatureResource(armatureName, armatureFile)
    if self:isArmatureLoaded(armatureName) then
        -- 增加计数
        self:addArmature(armatureName, armatureFile)
        return true
    end

    -- 添加加载任务
    table.insert(self._addingResourceArray, {type = lt.Constants.RESOURCE_ARMATURE, armatureName = armatureName, armatureFile = armatureFile})

    if not self._loadResourceHandler then
        self._loadResourceHandler = lt.scheduler.scheduleUpdateGlobal(handler(self, self.loadResourceUpdate))
    end
end

function ResourceManager:unloadArmatureResource(armatureName, armatureFile)
    if self:isArmatureLoaded(armatureName) then
        self:removeArmature(armatureName, armatureFile)
    else
        -- 查找正在添加的列表
        for key,resourceInfo in ipairs(self._addingResourceArray) do
            if resourceInfo.type == lt.Constants.RESOURCE_ARMATURE and resourceInfo.armatureName == armatureName then
                table.remove(self._addingResourceArray, key)
                break
            end
        end
    end
end

ResourceManager.LOAD_RESOURCE_FUNC = {
    [lt.Constants.RESOURCE_FRAME] = function(self, resourceInfo)
        local plist   = resourceInfo.plist
        local texture = resourceInfo.texture

        self:addSpriteFrames(plist, texture)

        table.insert(self._loadedResourceArray, resourceInfo)
        table.remove(self._addingResourceArray)
    end,
    [lt.Constants.RESOURCE_ARMATURE] = function(self, resourceInfo)
        local armatureName = resourceInfo.armatureName
        local armatureFile = resourceInfo.armatureFile

        self:addArmature(armatureName, armatureFile)

        table.insert(self._loadedResourceArray, resourceInfo)
        table.remove(self._addingResourceArray)
    end,
}

function ResourceManager:loadResourceUpdate()
    if self._addingResourceArray then
        local addingResourceCount = #self._addingResourceArray

        if addingResourceCount == 0 then
            -- 全部任务完成
            if self._loadArmatureResourceCompleteCallback then
                self._loadArmatureResourceCompleteCallback()
            end
        else
            -- 加载资源
            local resourceInfo = self._addingResourceArray[addingResourceCount]

            local type = resourceInfo.type
            local func = self.LOAD_RESOURCE_FUNC[type]
            if func then
                func(self, resourceInfo)
            else
                lt.CommonUtil.print("lack LOAD_RESOURCE_FUNC for type %d", type)
            end

            if self._loadArmatureResourceStepCallback then
                self._loadArmatureResourceStepCallback()
            end
            return
        end
    end
    
    self:clearResourceUpdate()
end

function ResourceManager:clearResourceUpdate()
    if self._loadResourceHandler then
        lt.scheduler.unscheduleGlobal(self._loadResourceHandler)
        self._loadResourceHandler = nil
    end

    self._loadArmatureResourceStepCallback = nil
    self._loadArmatureResourceCompleteCallback = nil

    self._addingResourceArray = {}
end

-- ################################################## 添加装备资源 ##################################################
function ResourceManager:addEquipmentResource(params)
    if not params then
        return
    end
    
    local figureId  = params.figureId or 0
    local hasEffect = params.hasEffect or false

    if figureId == 0 then
        return
    end

    -- 武器贴图
    local plist   = "image/equipment/model/"..figureId..".plist"
    local texture = "image/equipment/model/"..figureId..".png"
    self:addSpriteFrames(plist, texture) 

    if hasEffect then
        -- 武器特效
        local plist   = "image/equipment/effect/e"..figureId..".plist"
        local texture = "image/equipment/effect/e"..figureId..".pvr.ccz"
        self:addSpriteFrames(plist, texture)
    end
end

function ResourceManager:removeEquipmentResource(params)
    if not params then
        return
    end

    local figureId  = params.figureId or 0
    local hasEffect = params.hasEffect or false

    -- 武器贴图
    local plist   = "image/equipment/model/"..figureId..".plist"
    local texture = "image/equipment/model/"..figureId..".png"
    self:removeSpriteFrames(plist, texture) 

    if hasEffect then
        -- 武器特效
        local plist   = "image/equipment/effect/e"..figureId..".plist"
        local texture = "image/equipment/effect/e"..figureId..".pvr.ccz"
        self:removeSpriteFrames(plist, texture)
    end
end

-- ################################################## 默认资源 ##################################################
-- ############################## 道具相关 ##############################
--根据道具品质获取道具ICON底图颜色
ResourceManager.QUALITY_COLOR = {
    [lt.Constants.QUALITY.QUALITY_WHITE]  = lt.Constants.COLOR.QUALITY_WHITE,
    [lt.Constants.QUALITY.QUALITY_GREEN]  = lt.Constants.COLOR.QUALITY_GREEN,
    [lt.Constants.QUALITY.QUALITY_BLUE]   = lt.Constants.COLOR.QUALITY_BLUE,
    [lt.Constants.QUALITY.QUALITY_PURPLE] = lt.Constants.COLOR.QUALITY_PURPLE,
    [lt.Constants.QUALITY.QUALITY_ORANGE] = lt.Constants.COLOR.QUALITY_ORANGE,
}

function ResourceManager:getQualityColor(quality,flag)
    if flag then
        ResourceManager.QUALITY_COLOR[lt.Constants.QUALITY.QUALITY_WHITE] = lt.Constants.COLOR.NEW_GRAY
    end

    return self.QUALITY_COLOR[quality]
end

ResourceManager.QUALITY_BG = {
    [lt.Constants.QUALITY.QUALITY_WHITE]  = "#common_quality_white.png",
    [lt.Constants.QUALITY.QUALITY_GREEN]  = "#common_quality_green.png",
    [lt.Constants.QUALITY.QUALITY_BLUE]   = "#common_quality_blue.png",
    [lt.Constants.QUALITY.QUALITY_PURPLE] = "#common_quality_purple.png",
    [lt.Constants.QUALITY.QUALITY_ORANGE] = "#common_quality_orange.png",
}

function ResourceManager:getQualityBg(quality)
    return self.QUALITY_BG[quality]
end

ResourceManager.QUALITY_ICON = {
    [lt.Constants.QUALITY.QUALITY_WHITE]  = "#common_new_icon.png",
    [lt.Constants.QUALITY.QUALITY_GREEN]  = "#common_new_icon_green.png",
    [lt.Constants.QUALITY.QUALITY_BLUE]   = "#common_new_icon_blue.png",
    [lt.Constants.QUALITY.QUALITY_PURPLE] = "#common_new_icon_purple.png",
    [lt.Constants.QUALITY.QUALITY_ORANGE] = "#common_new_icon_orange.png",
}

function ResourceManager:getQualityIcon(quality)
    return self.QUALITY_ICON[quality]
end

function ResourceManager:getItemPic(itemId)
    return string.format("#%d.png", itemId)
end

-- ############################## 装备相关 ##############################
-- 获得基本装备
ResourceManager.BASE_EQUIPMENT_ID = {
    [lt.Constants.OCCUPATION.QS] = {
        [lt.Constants.EQUIPMENT_TYPE.WEAPON] = lt.Constants.DEFAULT_EQUIPMENT.QS_WEAPON,
        [lt.Constants.EQUIPMENT_TYPE.ASSISTANT] = lt.Constants.DEFAULT_EQUIPMENT.QS_ASSISTANT,
    },
    [lt.Constants.OCCUPATION.MFS] = {
        [lt.Constants.EQUIPMENT_TYPE.WEAPON] = lt.Constants.DEFAULT_EQUIPMENT.MFS_WEAPON,
        [lt.Constants.EQUIPMENT_TYPE.ASSISTANT] = lt.Constants.DEFAULT_EQUIPMENT.MFS_ASSISTANT,
    },
    [lt.Constants.OCCUPATION.JS] = {
        [lt.Constants.EQUIPMENT_TYPE.WEAPON] = lt.Constants.DEFAULT_EQUIPMENT.JS_WEAPON,
        [lt.Constants.EQUIPMENT_TYPE.ASSISTANT] = lt.Constants.DEFAULT_EQUIPMENT.JS_ASSISTANT,
    },
    [lt.Constants.OCCUPATION.BWLR] = {
        [lt.Constants.EQUIPMENT_TYPE.WEAPON] = lt.Constants.DEFAULT_EQUIPMENT.BWLR_WEAPON,
        [lt.Constants.EQUIPMENT_TYPE.ASSISTANT] = lt.Constants.DEFAULT_EQUIPMENT.BWLR_ASSISTANT,
    },
}

function ResourceManager:getBaseEquipmentId(occupationId, type)
    if not isset(self.BASE_EQUIPMENT_ID, occupationId) then
        return nil
    end

    return self.BASE_EQUIPMENT_ID[occupationId][type]
end

-- 获取职业徽记小图标
ResourceManager.OCCUPATION_EMBLEM_SMALL = {
    [lt.Constants.OCCUPATION.QS]    = "common_emblem_qs_small.png",
    [lt.Constants.OCCUPATION.MFS]   = "common_emblem_fs_small.png",
    [lt.Constants.OCCUPATION.JS]   = "common_emblem_js_small.png",
    [lt.Constants.OCCUPATION.BWLR]  = "common_emblem_lm_small.png",
}
function ResourceManager:getOccupationEmblemSmall(occupationId)
    return self.OCCUPATION_EMBLEM_SMALL[occupationId] or "common_emblem_qs_small.png"
end

-- 获取职业徽记小图标
ResourceManager.OCCUPATION_EMBLEM_BLACK = {
    [lt.Constants.OCCUPATION.QS]    = "common_emblem_qs_dark.png",
    [lt.Constants.OCCUPATION.MFS]   = "common_emblem_fs_dark.png",
    [lt.Constants.OCCUPATION.JS]   = "common_emblem_js_dark.png",
    [lt.Constants.OCCUPATION.BWLR]  = "common_emblem_lm_dark.png",
}
function ResourceManager:getOccupationEmblemBlack(occupationId)
    return self.OCCUPATION_EMBLEM_BLACK[occupationId] or "common_emblem_qs_dark.png"
end

-- 获取职业徽记
ResourceManager.OCCUPATION_EMBLEM = {
    [lt.Constants.OCCUPATION.QS]    = "common_emblem_qs.png",
    [lt.Constants.OCCUPATION.MFS]   = "common_emblem_fs.png",
    [lt.Constants.OCCUPATION.JS]   = "common_emblem_js.png",
    [lt.Constants.OCCUPATION.BWLR]  = "common_emblem_lm.png",
}
function ResourceManager:getOccupationEmblem(occupationId)
    return self.OCCUPATION_EMBLEM[occupationId] or "common_emblem_qs.png"
end

-- 获取职业徽记(黑白)
ResourceManager.OCCUPATION_EMBLEM_DARK = {
    [lt.Constants.OCCUPATION.QS]    = "common_emblem_qs.png",
    [lt.Constants.OCCUPATION.MFS]   = "common_emblem_fs.png",
    [lt.Constants.OCCUPATION.JS]   = "common_emblem_js.png",
    [lt.Constants.OCCUPATION.BWLR]  = "common_emblem_lm.png",
}
function ResourceManager:getOccupationEmblemDark(occupationId)
    return self.OCCUPATION_EMBLEM_DARK[occupationId] or "common_emblem_qs.png"
end

-- 获取货币图片根据道具ID
ResourceManager.ITEM_ID = {
    [lt.Constants.ITEM.DIAMOND]   = "common_diamond.png",
    [lt.Constants.ITEM.COIN]   = "common_coin_silver.png",
    [lt.Constants.ITEM.GOLD]  = "common_coin_gold.png",
    [lt.Constants.ITEM.GUILD_SCORE] = "common_coin_guild.png",
    [lt.Constants.ITEM.COMPETION_SCORE] = "common_coin_competion.png",
    [lt.Constants.ITEM.RISK_SCORE] = "common_coin_risk.png",
    [lt.Constants.ITEM.EXPERIENCE_SCORE] = "common_coin_experience.png",
    [lt.Constants.ITEM.GOODMAN_SCORE] = "common_coin_goodcard.png",
    [lt.Constants.ITEM.ENERGY] = "common_coin_energy.png",
    [lt.Constants.ITEM.Z_CURRENCY] = "common_coin_zb.png",
    [lt.Constants.ITEM.EGG_COIN] = "common_coin_egg.png",
}
function ResourceManager:getItemImgByItemId(itemId)
    return self.ITEM_ID[itemId] or "common_coin_silver.png"
end


-- 获取货币图片
ResourceManager.COIN_TYPE = {
    [lt.Constants.ITEM_VALUE_TYPE.DIAMOND]    = "common_diamond.png",
    [lt.Constants.ITEM_VALUE_TYPE.COIN]   = "common_coin_silver.png",
    [lt.Constants.ITEM_VALUE_TYPE.GOLD]  = "common_coin_gold.png",
    [lt.Constants.ITEM_VALUE_TYPE.Z_CURRENCY]  = "common_coin_zb.png",
    [lt.Constants.ITEM_VALUE_TYPE.GUILD_SCORE]  = "common_coin_guild.png",
    [lt.Constants.ITEM_VALUE_TYPE.COMPETION_SCORE]  = "common_coin_competion.png",
    [lt.Constants.ITEM_VALUE_TYPE.RISK_SCORE]  = "common_coin_risk.png",
    [lt.Constants.ITEM_VALUE_TYPE.EXPERIENCE_SCORE]  = "common_coin_experience.png",
    [lt.Constants.ITEM_VALUE_TYPE.GOODMAN_SCORE]  = "common_coin_goodcard.png",
    [lt.Constants.ITEM_VALUE_TYPE.ENERGY]  = "common_coin_energy.png",
}
function ResourceManager:getCoinImgByType(type)
    return self.COIN_TYPE[type] or "common_diamond.png"
end

-- 获取获取途径的图片
ResourceManager.ACCESSMETHOD_TYPE = {
    [lt.Constants.ACCESSMETHOD_TYPE.QUICK_SHOP]    = "common_icon_quickbuy.png",
    [lt.Constants.ACCESSMETHOD_TYPE.SHOP]          = "common_icon_shop.png",
    [lt.Constants.ACCESSMETHOD_TYPE.SHOP_CLUB]     = "common_icon_shopclub.png",
    [lt.Constants.ACCESSMETHOD_TYPE.STALL]         = "common_icon_stall.png",
    [lt.Constants.ACCESSMETHOD_TYPE.RESOLVE]       = "common_icon_resolve.png",
    [lt.Constants.ACCESSMETHOD_TYPE.COMPOSE]       = "common_icon_compose.png",
    [lt.Constants.ACCESSMETHOD_TYPE.FURNACE]       = "common_icon_alchemy.png",
    [lt.Constants.ACCESSMETHOD_TYPE.LIVE_SHILL]    = "common_icon_lifeskill.png",
    [lt.Constants.ACCESSMETHOD_TYPE.Z_CURRENCY_SHOP] = "common_icon_zbi.png",
}

function ResourceManager:getAccessIconById(id)
    return self.ACCESSMETHOD_TYPE[id] or "common_icon_shopclub.png"
end

--获取职业英文字母
ResourceManager.OCCUPATION_LABEL = {
    [lt.Constants.OCCUPATION.QS]    = "hero_image_qs.png",
    [lt.Constants.OCCUPATION.MFS]   = "hero_image_fs.png",
    [lt.Constants.OCCUPATION.JS]    = "hero_image_js.png",
    [lt.Constants.OCCUPATION.BWLR]  = "hero_image_lm.png",
}
function ResourceManager:getOccupationLabel(occupationId)
    return self.OCCUPATION_LABEL[occupationId] or "hero_image_qs.png"
end

--获取职业头像
ResourceManager.OCCUPATION_FACE = {
    [lt.Constants.OCCUPATION.QS]    = "image/occupation/tx_1.png",
    [lt.Constants.OCCUPATION.MFS]   = "image/occupation/tx_2.png",
    [lt.Constants.OCCUPATION.JS]    = "image/occupation/tx_3.png",
    [lt.Constants.OCCUPATION.BWLR]  = "image/occupation/tx_4.png",
}
function ResourceManager:getOccupationFace(occupationId)
    return self.OCCUPATION_FACE[occupationId] or "image/occupation/tx_1.png"
end

-- ################################################## 获取途径title ##################################################
ResourceManager.QUICK_BUY_TYPE = {
    [lt.Constants.QUICK_BUY.DIAMOND_SHOP]    = "#title_shop_title.png",
    [lt.Constants.QUICK_BUY.CRYSTAL_SHOP]   = "#title_zbi_title.png",
    [lt.Constants.QUICK_BUY.SHOP_CLUB_COIN]    = "#title_shopclub_title.png",
    [lt.Constants.QUICK_BUY.GUILD_SHOP]  = "#title_guild_title.png",
    [lt.Constants.QUICK_BUY.COMPETION_SHOP]  = "#title_competion_title.png",
    [lt.Constants.QUICK_BUY.RISK_SHOP]  = "#title_competion_title.png",
    [lt.Constants.QUICK_BUY.EXPERIENCE]  = "#title_experience_title.png",
    [lt.Constants.QUICK_BUY.GOODMAN]  = "#title_goodcard_title.png",
}
function ResourceManager:getQuickBuyImage(id)
    return self.QUICK_BUY_TYPE[id] or "#title_shop_title.png"
end

-- ################################################## 元素属性 ##################################################
-- 获取属性对应ICON
ResourceManager._propertyPic = nil
function ResourceManager:getPropertyPic(property)
    if not self._propertyPic then
        self._propertyPic = {
            [lt.Constants.PROPERTY.FIRE]    = "common_property_icon_fire.png",
            [lt.Constants.PROPERTY.WATER]   = "common_property_icon_water.png",
            [lt.Constants.PROPERTY.WIND]    = "common_property_icon_wind.png",
            [lt.Constants.PROPERTY.LIGHT]   = "common_property_icon_light.png",
            [lt.Constants.PROPERTY.DARK]    = "common_property_icon_dark.png"
        }
    end

    return self._propertyPic[property] or ""
end

-- 获取属性对应颜色
function ResourceManager:getPropertyStringColor(property)

    if property == lt.Constants.PROPERTY.FIRE then
        return lt.Constants.COLOR.PROPERTY_RED
    elseif property == lt.Constants.PROPERTY.WATER then
        return lt.Constants.COLOR.PROPERTY_BLUE
    elseif property == lt.Constants.PROPERTY.WIND then
        return lt.Constants.COLOR.PROPERTY_GREEN
    elseif property == lt.Constants.PROPERTY.LIGHT then
        return lt.Constants.COLOR.PROPERTY_YELLOW
    elseif property >= lt.Constants.PROPERTY.DARK then
        return lt.Constants.COLOR.PROPERTY_PURPLE
    else
        return lt.Constants.COLOR.WHITE
    end
end

return ResourceManager