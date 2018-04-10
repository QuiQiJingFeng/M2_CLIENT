
--房间信息层
local GameRoomInfoPanel = class("GameRoomInfoPanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/csb/base/GameTableInfo.csb")
end)


function GameRoomInfoPanel:ctor()
	GameRoomInfoPanel.super.ctor(self)
	lt.CommonUtil:getChildByNames(self, "Node_TableInfo", "Text_RoomNo"):setString(lt.DataManager:getGameRoomInfo().room_id)

end

function GameRoomInfoPanel:onEnter()   

end

function GameRoomInfoPanel:onExit()

end

return GameRoomInfoPanel