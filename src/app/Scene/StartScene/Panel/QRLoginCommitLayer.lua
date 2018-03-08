
-- 二维码登陆界面
local QRLoginCommitLayer = class("QRLoginCommitLayer", function()
	return display.newColorLayer(cc.c4b(0, 0, 0, 126))
end)

QRLoginCommitLayer._delegate = nil

function QRLoginCommitLayer:ctor(delegate)
	self:setNodeEventEnabled(true)

    self._delegate = delegate

	--透明底
    local bgSize = cc.size(330, 200)
    local bg = lt.GameNewPanel.new(lt.GameNewPanel.TYPE.TRANSPARENT, display.cx, display.cy, bgSize)
    self:addChild(bg)

    --白色底
    local whiteBgSize = cc.size(bgSize.width - 10, bgSize.height - 10)
    local whiteBg = lt.GameNewPanel.new(lt.GameNewPanel.TYPE.NEW_WHITE, bgSize.width / 2, bgSize.height / 2, whiteBgSize)
    bg:addChild(whiteBg)

	local tips = display.newSprite("#ui_qr_login_tips.png")
	tips:setPosition(bgSize.width / 2, bgSize.height - 50)
	bg:addChild(tips)

	-- 按钮
    local commitBtn = lt.ScaleLabelButton.newCommit()
    commitBtn:setPosition(bgSize.width / 2 - 80, 50)
    commitBtn:onButtonClicked(handler(self, self.commitCallback))
    bg:addChild(commitBtn)

    local cancelBtn = lt.ScaleLabelButton.newCancel()
    cancelBtn:setPosition(bgSize.width / 2 + 80, 50)
    cancelBtn:onButtonClicked(handler(self, self.cancelCallback))
    bg:addChild(cancelBtn)
end

function QRLoginCommitLayer:updateInfo(callback, token)
	self._callback = callback
	self._token = token
end

function QRLoginCommitLayer:commitCallback()
	lt.HttpApi:pcLogin(self._callback, self._token, handler(self, self.onCommitSuccess), handler(self, self.onCommitFail))
end

function QRLoginCommitLayer:cancelCallback()
	self:close()
end

function QRLoginCommitLayer:onCommitSuccess(responseJson)
	lt.CommonUtil.print(responseJson, "onQRCodeScanSuccess responseJson")
    local response = json.decode(responseJson)

    local status = response.status or -1
    if checknumber(status) == 0 then
        local code = response.code or -1
        if code == 0 then
            -- 登陆成功
            lt.NoticeManager:addMessageString("STRING_QR_LOGON_LOGIN_SUCCESS")

            self:close()
        else
            lt.CommonUtil.print("onQRCodeScanSuccess", code, esponse.msg)
            lt.NoticeManager:addMessageString("STRING_QR_LOGON_LOGIN_FAIL")
        end
    else
        lt.CommonUtil.print("onQRCodeScanSuccess", status, esponse.desc)
        lt.NoticeManager:addMessageString("STRING_QR_LOGON_LOGIN_FAIL")
    end
end

function QRLoginCommitLayer:onCommitFail(responseJson)
	lt.CommonUtil.prin("onQRCodeScanFail responseJson", responseJson)
    lt.NoticeManager:addMessageString("STRING_QR_LOGON_LOGIN_FAIL")
end

function QRLoginCommitLayer:close()
	self._delegate:clearQRLoginCommitLayer()
end

return QRLoginCommitLayer
