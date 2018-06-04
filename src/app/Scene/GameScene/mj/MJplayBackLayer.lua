local MJplayBackLayer = class("MJplayBackLayer", lt.BaseLayer)


function MJplayBackLayer:ctor()
	self._gameBgPanel = lt.GameBgPanel.new()--背景层
	self:addChild(self._gameBgPanel)

	self._gameSetPanel = lt.GameSetPanel.new(self)--设置
	self:addChild(self._gameSetPanel)
	self._settingLayer = lt.SettingLayer.new(self)--设置
	self:addChild(self._settingLayer)


	self._gameCompassPanel = lt.GameCompassPanel.new(self)--罗盘层

	self._engine = lt.MjEngine:create(self)
	self._showCardsPanel = self._engine:getShowCardsLayer()
	self._gameCompassPanel:addChild(self._showCardsPanel)
	self:addChild(self._gameCompassPanel)

	self._gameSelectPosPanel = lt.GameSelectPosPanel.new(self, self._gameCompassPanel)--入座 玩家头像
	self:addChild(self._gameSelectPosPanel)

	self._gameRoomInfoPanel = lt.GameRoomInfoPanel.new(self)--房间信息
	self:addChild(self._gameRoomInfoPanel)

	self._gameActionBtnsPanel = lt.GameActionBtnsPanel.new(self)--吃碰杠胡过
	self:addChild(self._gameActionBtnsPanel)

	------------false掉一些不需要的东西------------------------------------------
	local Button_Voice = self._gameSetPanel:getChildByName("Button_Voice")
	local Button_Chat = self._gameSetPanel:getChildByName("Button_Chat")
	Button_Voice:setVisible(false)--不需要false掉
	Button_Chat:setVisible(false)

	local Panel_RecordCtrl = self._gameSetPanel:getChildByName("Panel_RecordCtrl"):setVisible(true)

	local Button_PausePlay = Panel_RecordCtrl:getChildByName("Button_PausePlay")
	local Sprite_Pause = Button_PausePlay:getChildByName("Sprite_Pause")--暂停
	local Sprite_Play = Button_PausePlay:getChildByName("Sprite_Play")--播放
	Sprite_Play:setVisible(false)
	--Sprite_Pause:setVisible(false)

	
	
	local Button_Fast = Panel_RecordCtrl:getChildByName("Button_Fast")
	local Button_Slowe = Panel_RecordCtrl:getChildByName("Button_Slowe")
	Button_PausePlay:setVisible(true)
	Button_Fast:setVisible(true)
	Button_Slowe:setVisible(true)

	local jsRoom = self._settingLayer:getChildByName("ScrollView"):getChildByName("Btn_DissolveRoom")
	jsRoom:setVisible(false)--这个还需要处理
	self._settingLayer:setVisible(false)


	

	---------------------------------------------------------------------------
	
	

--[[
	self._gameCompassPanel = lt.GameCompassPanel.new(self)--罗盘层
	self._engine = lt.MjEngine:create(self)
	self._showCardsPanel = self._engine:getShowCardsLayer()
	self._gameCompassPanel:addChild(self._showCardsPanel)

	self:addChild(self._gameBgPanel)

	self:addChild(self._gameCompassPanel)--]]

end

function MJplayBackLayer:SetPlayersLogo(pos)--设置玩家
	local a = self._gameSelectPosPanel:getChildByName("Node_Player1")
	a:setVisible(true)
end

function MJplayBackLayer:onEnter()
end

function MJplayBackLayer:onExit()
end

return MJplayBackLayer