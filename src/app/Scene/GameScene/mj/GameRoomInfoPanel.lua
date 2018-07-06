
--房间信息层
local GameRoomInfoPanel = class("GameRoomInfoPanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/csb/base/GameTableInfo.csb")
end)


function GameRoomInfoPanel:ctor()
	GameRoomInfoPanel.super.ctor(self)
	local roomInfo = lt.DataManager:getGameRoomInfo()
	local roomSetting = roomInfo.room_setting

	if roomSetting then
		if roomSetting.game_type == lt.Constants.GAME_TYPE.HZMJ then
			local name = lt.LanguageString:getString("STRING_GAME_NAME_"..roomSetting.game_type)
			lt.CommonUtil:getChildByNames(self, "Node_TableInfo", "Text_GameName"):setString(name)
		end
		lt.CommonUtil:getChildByNames(self, "Node_TableInfo", "Text_JuShu"):setString(roomInfo.cur_round.."/"..roomSetting.round)
	end

	lt.CommonUtil:getChildByNames(self, "Node_TableInfo", "Text_RoomNo"):setString(lt.DataManager:getGameRoomInfo().room_id)
end

function GameRoomInfoPanel:onDealDown(msg)
	local roomSetting = lt.DataManager:getGameRoomInfo().room_setting

	local curRound = 0

    if lt.DataManager:getRePlayState() then
    	if msg[1] then
    		for i,v in pairs(msg[1]) do
    			curRound = v.cur_round
    			break
    		end
    	end
    else
    	curRound = msg.cur_round
    end
    
    curRound = curRound or 0
    lt.DataManager:getGameRoomInfo().cur_round = curRound

	if roomSetting then
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