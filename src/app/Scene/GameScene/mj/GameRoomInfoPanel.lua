
--房间信息层
local GameRoomInfoPanel = class("GameRoomInfoPanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/csb/base/GameTableInfo.csb")
end)


function GameRoomInfoPanel:ctor()
	GameRoomInfoPanel.super.ctor(self)

	local roomSetting = lt.DataManager:getGameRoomInfo().room_setting
	if roomSetting then
		if roomSetting.game_type == lt.Constants.GAME_TYPE.HZMJ then
			local name = lt.LanguageString:getString("STRING_GAME_NAME_"..roomSetting.game_type)
			lt.CommonUtil:getChildByNames(self, "Node_TableInfo", "Text_GameName"):setString(name)
		end
		lt.CommonUtil:getChildByNames(self, "Node_TableInfo", "Text_JuShu"):setString(roomSetting.cur_round.."/"..roomSetting.round)
	end

	lt.CommonUtil:getChildByNames(self, "Node_TableInfo", "Text_RoomNo"):setString(lt.DataManager:getGameRoomInfo().room_id)
end

function GameRoomInfoPanel:onDealDown(msg)
	local roomSetting = lt.DataManager:getGameRoomInfo().room_setting
	if roomSetting then
		local curRound = msg.cur_round or 0
		lt.CommonUtil:getChildByNames(self, "Node_TableInfo", "Text_JuShu"):setString(curRound.."/"..roomSetting.round)
	end
end

function GameRoomInfoPanel:onEnter()   
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.DEAL_DOWN, handler(self, self.onDealDown), "GameRoomInfoPanel.onDealDown")
end

function GameRoomInfoPanel:onExit()
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.DEAL_DOWN, "GameRoomInfoPanel:onDealDown")
end

return GameRoomInfoPanel