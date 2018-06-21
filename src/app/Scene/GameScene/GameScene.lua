-- 游戏场景
local GameScene = class("GameScene", function()
    return display.newScene("GameScene")
end)

GameScene._gameRoomLayer 	= nil -- 游戏背景层、牌面层、入座头像层、设置层、房间信息层
GameScene._gameUILayer 	= nil -- 游戏UI界面  由 gamePlayLayer 层触发显示层
GameScene._gameNoticeLayer = nil--提示层

local ChatLayer = require("app.Scene.GameScene.ChatLayer")

function GameScene:ctor()
    local gameInfo = lt.DataManager:getGameRoomInfo()

    local gameid = 1

    if gameInfo and gameInfo.room_setting and gameInfo.room_setting.game_type then
        gameid = gameInfo.room_setting.game_type
    end

    dump(gameInfo, "gameInfo")

    if gameid == lt.Constants.GAME_TYPE.HZMJ or gameid == lt.Constants.GAME_TYPE.SQMJ then --红中麻将
        self._gameRoomLayer = lt.GameRoomLayer.new()
        self:addChild(self._gameRoomLayer)
    elseif gameid == 2 then --斗地主
        self._gameRoomLayer = lt.DDZGameLayer.new()
        self:addChild(self._gameRoomLayer)
    end 



    self._gameUILayer = lt.WorldUILayer.new(self)
    self._gameUILayer:setVisible(false)
    self:addChild(self._gameUILayer)


    --self:loadingOn()
    self._gameNoticeLayer = lt.WorldNoticeLayer.new()
    self:addChild(self._gameNoticeLayer)

    lt.UILayerManager:setWorldMenuLayer(self._gameRoomLayer)
    lt.UILayerManager:setWorldUILayer(self._gameUILayer)

    -- self.__ChatLayer = ChatLayer:new()
    -- self._gameUILayer:addChild(self.__ChatLayer)
    -- self.__ChatLayer:setVisible(false)
    
end

function GameScene:getGameRoomUILayer()
	return self._gameUILayer
end

function GameScene:getGameRoomUILayer()
	return self._gameUILayer
end

function GameScene:loadingOn()
	-- if not self._worldLoadingLayer then
	-- 	self._worldLoadingLayer = lt.WorldLoadingLayer.new()
	-- 	self:addChild(self._worldLoadingLayer, lt.Constants.ZORDER.LOADING)
	-- end
end

function GameScene:loadingOff()
	-- if self._worldLoadingLayer then
	-- 	self._worldLoadingLayer:removeSelf()
	-- 	self._worldLoadingLayer = nil
	-- end
end

return GameScene