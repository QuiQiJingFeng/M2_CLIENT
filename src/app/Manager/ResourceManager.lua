
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
    self._loadedSpriteFramesMap = {}
    self._loadedSpriteFramesTable = {}
end

function ResourceManager:clear()
    for plist,texture in pairs(self._loadedSpriteFramesMap) do
        display.removeSpriteFramesWithFile(plist, texture)
    end
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

return ResourceManager