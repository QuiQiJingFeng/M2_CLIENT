
--背景层
local InvitePanel = class("InvitePanel", lt.BaseLayer, function()

    return cc.CSLoader:createNode("game/mjcomm/csb/base/InviteViewLayer.csb")--背景层--  FriendLayer
end)


function InvitePanel:ctor()
	InvitePanel.super.ctor(self)
	--支付宝分享
	self.alipay_share = lt.CommonUtil:getChildByNames(self, "Node_InviteView", "BgInvite","Btn_zfb")
	--微信分享
 	self.weichat_share = lt.CommonUtil:getChildByNames(self, "Node_InviteView", "BgInvite","Btn_weChat")
 	--拷贝分享
 	self.copy_share = lt.CommonUtil:getChildByNames(self, "Node_InviteView", "BgInvite","Btn_copyRoomNum")
 	--朋友圈分享
 	self.wechat_circle_share = lt.CommonUtil:getChildByNames(self, "Node_InviteView", "BgInvite","Btn_weChatCircle")

 	self.btn_close = lt.CommonUtil:getChildByNames(self, "Node_InviteView", "BgInvite","Btn_close")

 	self.wechat_circle_share:setPosition(cc.p(self.alipay_share:getPosition()))
 	self.wechat_circle_share:setVisible(true)
 	self.alipay_share:removeSelf()


 	lt.CommonUtil:addNodeClickEvent(self.weichat_share, handler(self, self.onWeichatShareClick))
 	lt.CommonUtil:addNodeClickEvent(self.copy_share, handler(self, self.onCopyShareClick))
 	lt.CommonUtil:addNodeClickEvent(self.wechat_circle_share, handler(self, self.onWeichatCircleClick))

 	lt.CommonUtil:addNodeClickEvent(self.btn_close, handler(self, self.onBtnClose))
end

function InvitePanel:onBtnClose()
	lt.UILayerManager:removeLayer(self)
end

function InvitePanel:onWeichatShareClick()

end

function InvitePanel:onCopyShareClick()
	local room_info = lt.DataManager:getGameRoomInfo()
	local room_id = room_info.room_id
	local seat_num = room_info.room_setting.seat_num
	local round = room_info.room_setting.round
	local playerNum = #room_info.players
	local gameType = room_info.room_setting.game_type
	local gameName = lt.Constants.GAME_NAME[gameType]
	local baseScore = room_info.room_setting.other_setting[1]
	local payName = lt.Constants.PAY_NAME[room_info.room_setting.pay_type]

	local message = [[
		-------------------
		1、长按整条信息->复制
		2、打开APP->可直通房间
		-------------------
		【3A麻将】
		★ 游戏：[%s]
		★ 房号：[%d]
		★ 局数：[%d]
		★ 底分：[%d]
		★ 资费：[%s]
		就缺你，输入房号赶紧进！！！
	]]
	message = string.format(message,gameName,room_id,round,baseScore,payName)


	local success = lt.SDK.Device.copyToClipBoard(message)
	-- 弹框提示 已经复制到剪切板
end

function InvitePanel:onWeichatCircleClick()

end

return InvitePanel