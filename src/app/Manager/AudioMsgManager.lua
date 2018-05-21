-- 语音消息监听
local AudioMsgManager = {}

AudioMsgManager._msgId = 0
AudioMsgManager._cancelSend = false
AudioMsgManager._isPlaying = false
AudioMsgManager._chatList = {} --缓存自己发的消息
AudioMsgManager._autoChatList = {} --自动语音播放列表
AudioMsgManager._autoPlayAudioList = {}--自动语音播放列表
function AudioMsgManager:init()
	if device.platform ~= "mac" then
        lt.CommonUtil.print("/n-------------------------------------- YVsdK initSDK  begin !")
        yvcc.YVTool:getInstance():initSDK(1000608,cc.FileUtils:getInstance():getWritablePath(),false,false)
        lt.CommonUtil.print("/n-------------------------------------- YVsdK initSDK  end !")
    end
end

function AudioMsgManager:getMsgId()
    AudioMsgManager._msgId = AudioMsgManager._msgId + 1
    return AudioMsgManager._msgId
end

--ext: msgId_channel_playerId_playerName_avatarId_occupationId_bubbleId_receiveId
function AudioMsgManager:reveiveOwnMsg(path,ext,duration)
    lt.CommonUtil.print("path:"..path.." ext:"..ext.." duration:"..duration)
    local msg = string.split(ext, "_")
    if #msg ~= 9 then
        lt.CommonUtil.print("audio message parse ext error length is less then 9")
        return
    end

    lt.CommonUtil.print("msg size:"..#msg)

    local msgId = tonumber(msg[1])
    local channel = tonumber(msg[2])
    local senderId = tonumber(msg[3])
    local senderName = msg[4]
    local avatarId = tonumber(msg[5])
    local occupationId = tonumber(msg[6])
    local bubbleId = tonumber(msg[7])
    local receiveId = tonumber(msg[8])
    local subType = tonumber(msg[9]) or 0

    local chatInfo
    if channel ~= lt.Constants.CHAT_TYPE.FRIEND then
        chatInfo = self:handleChatMsg(msgId,channel,senderName,"",senderId,occupationId,duration,avatarId,bubbleId,path)
    else

        chatInfo = self:handleFriendMsg(msgId,"",0,senderId,senderName,receiveId,occupationId,duration,path,channel,subType)

    end
    self._chatList[msgId] = chatInfo
    self:handleOwnMessage(chatInfo)
end

function AudioMsgManager:updateMsg(ext,text,url)
    local msg = string.split(ext, "_")
    if #msg ~= 9 then
        lt.CommonUtil.print("audio message parse ext error length is less then 9")
        return
    end


    local msgId = tonumber(msg[1])
    local channel = tonumber(msg[2])
    local receiveId = tonumber(msg[8])
    local subType = tonumber(msg[9])

    local hasWarning, str = lt.WarnStrFunc:warningStrGsub(text)

    if hasWarning then
        text = str
    end
    -- if  text == "" then
    --     text =  "喔！"
    -- end
   
    if text == "" then
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_ACTIVITY_ANSWER_PARTY26"))
        return
    end

    local chatInfo = self._chatList[msgId]
    if chatInfo and channel ~= lt.Constants.CHAT_TYPE.FRIEND then--
        lt.SocketApi:chat(chatInfo:getChannel(),chatInfo:getSenderId(),text, lt.Constants.CHAT_SUB_TYPE.AUDIO, chatInfo:getDuration(), url, true, msgId)
    else

        if subType > 0 then
            lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_SEND_GIFT,{chatInfo=chatInfo, text=text, url = url,receiveId = receiveId, msgId = msgId})
        else
            lt.SocketApi:chat(chatInfo:getChannel(),receiveId,text, subType, chatInfo:getDuration(), url, url, 1, msgId)
        end
    end
end

function AudioMsgManager:handleOwnMessage(chatInfo)--语音图标跟翻译一起
    local channel = chatInfo:getChannel()
    -- if channel == lt.Constants.CHAT_TYPE.WORLD then
    --     lt.DataManager:addWorldChatInfo(chatInfo)
    --     lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_WORLD,{chatInfo=chatInfo, isAudio=true})
    -- elseif channel == lt.Constants.CHAT_TYPE.TEAM then
    --     lt.DataManager:addTeamChatInfo(chatInfo)
    --     lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_TEAM,{chatMessageInfo = chatInfo, isAudio=true})
    -- elseif channel == lt.Constants.CHAT_TYPE.GUILD then
    --     lt.DataManager:addGuildChatInfo(chatInfo)
    --     lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_GUILD,{chatInfo=chatInfo, isAudio=true})
    -- elseif channel == lt.Constants.CHAT_TYPE.CURRENT then
    --     lt.DataManager:addCurrentChatInfo(chatInfo)
    --     lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_CURRENT,{chatInfo=chatInfo, isAudio=true})
    -- elseif channel == lt.Constants.CHAT_TYPE.ANSWER_PARTY then
    --     -- lt.DataManager:addAnswerPartyChatInfo(chatInfo)
    --     -- lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_ANSWER_PARTY,{chatInfo=chatInfo, isAudio=true})
    -- elseif channel == lt.Constants.CHAT_TYPE.TRUMPET then
    --     --chatInfo:setChannel(lt.Constants.CHAT_TYPE.WORLD)
    --     -- lt.DataManager:addWorldChatInfo(chatInfo)
    --     -- lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_WORLD,{chatInfo=chatInfo, isAudio=true})
    if channel == lt.Constants.CHAT_TYPE.FRIEND then

        local subType = chatInfo:getSubType()


        if subType > 0 then

        else
            lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_FRIEND_AUDIO,{chatInfo=chatInfo, isAudio=true})
        end
    elseif channel == lt.Constants.CHAT_TYPE.RISK_TEAM then
        lt.GameEventManager:post(lt.GameEventManager.EVENT.CHAT_AUDIO_RISK_TEAM,{chatInfo=chatInfo, isAudio=true})
    end
end

function AudioMsgManager:dealMessage(chatInfo)
    local channel = chatInfo:getChannel()
    if channel ~= lt.Constants.CHAT_TYPE.ANSWER_PARTY then
        if self:isPlaying() then
            return
        end
    end

    if chatInfo:getSenderId() == lt.DataManager:getPlayerId() then
        return
    end
    local auto = false

    if channel == lt.Constants.CHAT_TYPE.WORLD then
        auto = lt.PreferenceManager:getAutoAudioWorld()
    elseif channel == lt.Constants.CHAT_TYPE.TEAM then
        auto = lt.PreferenceManager:getAutoAudioTeam()
    elseif channel == lt.Constants.CHAT_TYPE.GUILD then
        auto = lt.PreferenceManager:getAutoAudioGuild()
    elseif channel == lt.Constants.CHAT_TYPE.CURRENT then
        auto = lt.PreferenceManager:getAutoAudioCurrent()
    elseif channel == lt.Constants.CHAT_TYPE.ANSWER_PARTY then
        auto = lt.PreferenceManager:getAutoAudioAnswerParty()
    elseif channel == lt.Constants.CHAT_TYPE.TRUMPET then
        auto = lt.PreferenceManager:getAutoAudioWorld()
    end

    if not auto then
        return
    end

    self:addToAudioList(channel, chatInfo)


    -- if channel == lt.Constants.CHAT_TYPE.ANSWER_PARTY then
    --     self:addToAudioList(lt.Constants.CHAT_TYPE.ANSWER_PARTY, chatInfo)
    --     return
    -- end
    -- local messageId = chatInfo:getMessageId()
    -- self:playAudio(chatInfo)
    -- chatInfo:setAuto(true)
    -- chatInfo:setRead(1)
    -- self._autoChatList[messageId] = chatInfo
end

function AudioMsgManager:handleChatMsg(msgId,channel,senderName,text,senderId,occupationId,duration,avatarId,bubbleId,path)
    local chatInfo = lt.Chat.new()
    chatInfo:setMessageId(msgId)
    chatInfo:setChannel(channel)
    chatInfo:setSenderName(senderName)
    chatInfo:setSendTime(lt.CommonUtil:getCurrentTime())
    chatInfo:setMessage(text)
    chatInfo:setSenderId(senderId)
    chatInfo:setOccupationId(occupationId)
    chatInfo:setDuration(duration)
    chatInfo:setSubType(-1)
    chatInfo:setSubParam(0)
    chatInfo:setSubContent("")
    chatInfo:setSenderAvatarId(avatarId)
    chatInfo:setBubbleId(bubbleId)
    chatInfo:setPath(path)
    chatInfo:setAuto(false)
    chatInfo:setIsAudio(1)
    return chatInfo
end

function AudioMsgManager:handleFriendMsg(msgId,text,type,senderId,senderName,receiveId,occupationId,duration,path,channel,subType)
    local chatMessageInfo = lt.ChatMessage.new()
    chatMessageInfo:setMessageId(msgId)
    chatMessageInfo:setSenderId(senderId)
    chatMessageInfo:setReceiverId(receiveId)
    chatMessageInfo:setSendTime(lt.CommonUtil:getCurrentTime())
    chatMessageInfo:setType(type)
    chatMessageInfo:setMessage(text)
    chatMessageInfo:setName(senderName)
    chatMessageInfo:setId(0)
    chatMessageInfo:setDuration(duration)
    chatMessageInfo:setSubType(subType)
    chatMessageInfo:setSubContent("")
    chatMessageInfo:setPath(path)
    chatMessageInfo:setAudioIndex(0)
    chatMessageInfo:setIsAudio(1)
    chatMessageInfo:setChannel(channel)

    return chatMessageInfo
end

function AudioMsgManager:cpLogin(loginName)
    if device.platform ~= "mac" then
        yvcc.YVTool:getInstance():cpLogin(loginName)
    end
end

function AudioMsgManager:startRecord(channel,player,receiveId,subType)
    self._cancelSend = false
    self._isRecording = true
    self._startRecordTime = lt.CommonUtil:getCurrentTime()
    if device.platform ~= "mac" then
        lt.AudioManager:pauseMusic()
        lt.AudioManager:pauseSound()

        yvcc.YVTool:getInstance():stopPlay()
        local path = cc.FileUtils:getInstance():getWritablePath()
        local curTime = os.time()
        local loginName = lt.DataManager:getLoginName()
        local filepath = path..loginName..'_'..curTime..'.amr'
        if not receiveId then
            receiveId = 0
        end

        local subTypeTrue = 0

        if subType then
            subTypeTrue = subType
        end

        local ext = self:getMsgId().."_"..channel.."_"..player:getId().."_"..player:getName().."_"..player:getAvatarId().."_"..player:getOccupationId().."_"..player:getBubbleId().."_"..receiveId.."_"..subTypeTrue
        yvcc.YVTool:getInstance():startRecord(filepath,0,ext)
    end
end

function AudioMsgManager:isCancelSend()
    return self._cancelSend
end

function AudioMsgManager:stopRecord(cancelSend)
    self._cancelSend = cancelSend
    self._isRecording = false
    self._stopRecordTime = lt.CommonUtil:getCurrentTime()

    if self._cancelSend == false and self._startRecordTime + 1 > self._stopRecordTime then--录音时间过短
        self._cancelSend = true
        lt.NoticeManager:addMessage(lt.StringManager:getString("STRING_ACTIVITY_ANSWER_PARTY25"))--语音发送失败，请重试！
    end

    if device.platform ~= "mac" then
        lt.AudioManager:resumeMusic()
        lt.AudioManager:resumeSound()
        yvcc.YVTool:getInstance():stopRecord()
    end
end

function AudioMsgManager:playAudio(chatInfo)
    if device.platform ~= "mac" then
        yvcc.YVTool:getInstance():stopPlay()
        lt.AudioManager:pauseMusic()
        lt.AudioManager:pauseSound()
        self._isPlaying = true
        self._playingElapse = 0
        if chatInfo:getSenderId() == lt.DataManager:getPlayerId() then
            yvcc.YVTool:getInstance():playRecord(chatInfo:getPath(), "", tostring(chatInfo:getMessageId()))
        else
            yvcc.YVTool:getInstance():playFromUrl(chatInfo:getPath(), tostring(chatInfo:getMessageId()))
        end
    end
end

function AudioMsgManager:stopAudio()
    if device.platform ~= "mac" then
        if self._isPlaying then
            lt.AudioManager:resumeMusic()
            lt.AudioManager:resumeSound()
        end
        yvcc.YVTool:getInstance():stopPlay()
    end
end

function AudioMsgManager:isPlaying()
    return self._isPlaying
end

-- function AudioMsgManager:playFinished(messageId)
--     self._isPlaying = false
--     local chatInfo = self._autoChatList[messageId]
--     if chatInfo then
--         chatInfo:setAuto(false)
--         table.remove(self._autoChatList,messageId)
--     end
-- end

function AudioMsgManager:playFinished(messageId)
    lt.CommonUtil.print("AudioMsgManager:playFinished"..messageId)

    self:_playFinished()
end

function AudioMsgManager:_playFinished()
    if self._autoChatList[1] then
        table.remove(self._autoChatList, 1)
    end
    lt.AudioManager:resumeMusic()
    lt.AudioManager:resumeSound()

    self._isPlaying = false
    self._currentMessageId = nil
end

function AudioMsgManager:getChatInfoByLoaclId(localId)
    return self._chatList[localId]
end

--##################################################自动播放###################################

function AudioMsgManager:openUpdateHandler()
    if not self._updateHandler then
        self._updateHandler = lt.scheduler.scheduleUpdateGlobal(handler(self, self.onUpdate))
    end
end

function AudioMsgManager:closeUpdateHandler()--
    if self._updateHandler then
        lt.scheduler.unscheduleGlobal(self._updateHandler)
        self._updateHandler = nil
    end
end

function AudioMsgManager:onUpdate(delta)--
    if not self._autoChatList then
        return
    end

    if self._isRecording then
        return
    end

    if self._isPlaying then
        -- 持续时间
        self._playingElapse = self._playingElapse + delta
        if self._playingElapse > 12 then
            -- 语音播放时间超过12s 可能语音播放错误
            self:_playFinished()
        end
        return
    end

    local chatInfo = self._autoChatList[1]

    if not chatInfo then
        self._currentMessageId = nil
        return
    end
    self._currentMessageId = chatInfo:getMessageId()

    lt.GameEventManager:post(lt.GameEventManager.EVENT.UPDATE_AUTO_PLAY_AUDIO)
    self:playAudio(chatInfo)
    lt.CommonUtil.print("AudioMsgManager:onUpdate", self._currentMessageId)
end

function AudioMsgManager:getCurrentMessageId()
    return self._currentMessageId
end

function AudioMsgManager:channelAutoPlayAudioList(channel)--频道的自动播放列表
    self._autoChatList = self._autoPlayAudioList[channel] or {}
end

function AudioMsgManager:addToAudioList(channel, chatInfo)--加入播放列表

    if not self._needAutoChannel then--不在语音答题界面并且过滤掉答题的语音
        if channel ~= lt.Constants.CHAT_TYPE.ANSWER_PARTY then
            --这边是之前的逻辑
            local messageId = chatInfo:getMessageId()
            self:playAudio(chatInfo)
            chatInfo:setAuto(true)
            chatInfo:setRead(1)
            --self._autoChatList[messageId] = chatInfo
            return
        end
    else
        if channel ==  self._needAutoChannel then
            chatInfo:setAuto(true)
            --chatInfo:setRead(1)

            if not self._autoPlayAudioList[channel] then
                self._autoPlayAudioList[channel] = {}
            end
            table.insert(self._autoPlayAudioList[channel], chatInfo)
            lt.CommonUtil.print("AudioMsgManager:addToAudioList", channel)
            self:channelAutoPlayAudioList(channel)
        end
    end
end

function AudioMsgManager:openAutoPlayAudio(channel)
    self._needAutoChannel = channel
    self:openUpdateHandler()--开启调度
    lt.CommonUtil.print("AudioMsgManager:openAutoPlayAudio", channel)
end

function AudioMsgManager:closeAutoPlayAudio()--例如没有打开全民答题接界面
    self._needAutoChannel = nil
    self:closeUpdateHandler()--关闭调度
    self._autoPlayAudioList = {}--清空列表
    self._autoChatList = {}
    self:stopAudio()
    self._isPlaying = false
    lt.CommonUtil.print("AudioMsgManager:closeAutoPlayAudio")
end

function AudioMsgManager:stopAutoPlayAudio()--例如全民答题换题了就要清掉前一道题的语音 
    self._autoPlayAudioList = {}--清空列表
    self._autoChatList = {}
    self:stopAudio()
    self._isPlaying = false
    lt.CommonUtil.print("AudioMsgManager:stopAutoPlayAudio")
end

function AudioMsgManager:clearPlayAudioList(channel)--清空频道播放列表
    self._autoPlayAudioList[channel] = nil
end

return AudioMsgManager
