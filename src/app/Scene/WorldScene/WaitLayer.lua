
local WaitLayer = class("WaitLayer", function ( ... )
    return cc.CSLoader:createNode("hallcomm/common/WaitLayer.csb")
end)

----------------------------------------------------------------------------------
--
function WaitLayer:onCreate()
end

----------------------------------------------------------------------------------
--
function WaitLayer:onInit()
    -- 获取界面控件
    -- local layer = self
    -- local layer = self:getChildByName("Layer")
    -- local bg = layer:getChildByName("Ie_Bg")
    -- self.ieMark = layer:getChildByName("Ie_Bg")
    -- self.ttContent = bg:getChildByName("Tt_Countent")
    self.miSchedulerId = nil
end

----------------------------------------------------------------------------------
--
function WaitLayer:onEnter()
    -- dzqp:addMNByView(dzqp.g_eMNByView.eMsgBoxSure, self, self.callBackMsgBoxSure)
    -- dzqp:addMNByView(dzqp.g_eMNByView.eMsgBoxMark, self, self.callBackMsgBoxMark)
    -- dzqp:addMNByView(dzqp.g_eMNByView.eWaitClose, self, self.funWaitClose)
end

----------------------------------------------------------------------------------
-- 
function WaitLayer:onEnterTransitionFinish()
    -- 计时器
    local function updateCutTime(dt)
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.miSchedulerId)
        self.miSchedulerId = nil
        -- self:setMsgBox(dzqp.g_tStrDefine.eMsgReqOut)
        -- local msgbox = lt.MsgboxLayer.new()
        -- self:addChild(msgbox)
        print("WaitLayer   链接超时")
    end
    self.miSchedulerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(updateCutTime, 20, false) 
end

----------------------------------------------------------------------------------
--
function WaitLayer:onExit()

    -- dzqp:delMNByView(dzqp.g_eMNByView.eMsgBoxSure, self)
    -- dzqp:delMNByView(dzqp.g_eMNByView.eMsgBoxMark, self)
    -- dzqp:delMNByView(dzqp.g_eMNByView.eWaitClose, self)

    -- 关闭计时器
    if self.miSchedulerId ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.miSchedulerId)
        self.miSchedulerId = nil
    end
end

----------------------------------------------------------------------------------
--
function WaitLayer:setContent(strContent)
    self.ttContent:setString(strContent)
end

----------------------------------------------------------------------------------
-- 设置msgbox
function WaitLayer:setMsgBox( strContent )
    -- local lyrMsgBox = self:getApp():createView(dzqp.g_tMsgBoxLayer, self)  
    -- lyrMsgBox:setMNView(self.tag_)
    -- lyrMsgBox:setSingleType()
    -- lyrMsgBox:setMarkVisible(false)
    -- lyrMsgBox:setContent(strContent)
    -- self:addChild(lyrMsgBox)

    print("strContent")


    -- local 


end

----------------------------------------------------------------------------------
-- 
function WaitLayer:callBackMsgBoxSure( tDate )
    self:exit()
end

----------------------------------------------------------------------------------
-- 
function WaitLayer:callBackMsgBoxMark( tDate )
    self:callBackMsgBoxSure(intBnTag)
end

----------------------------------------------------------------------------------
-- 
function WaitLayer:funWaitClose( szMsgInfo )
    -- 关闭计时器
    if self.miSchedulerId ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.miSchedulerId)
        self.miSchedulerId = nil
    end
    if szMsgInfo ~= nil then
        self:setMsgBox(szMsgInfo)
    end
end


return WaitLayer
