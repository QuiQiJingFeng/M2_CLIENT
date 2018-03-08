
-- 玩家头像Icon
local PlayerFaceButton = class("PlayerFaceButton", function()
	return lt.PushButton.new("#common_icon_bg_big.png")
end)

PlayerFaceButton._scale = 76/88
PlayerFaceButton._levelLabel = nil


function PlayerFaceButton:ctor(scale)
	if scale then
		self:setScale(1)
		self._scale = 1
	else
		self:setScale(self._scale)
	end
end

function PlayerFaceButton:updateInfo(occupationId,id,url,faceId)


	if url and url ~= "" then
		local faceImg = lt.NetSprite.new(url)
		local urlScale = 77/128
	    faceImg:setScale(urlScale)
	    faceImg:setPosition(self:getContentSize().width / 2,self:getContentSize().height / 2)
	    self:addChild(faceImg)
		return
	end
	
    
    	
    if faceId and faceId ~= 0 then
    	local imageName = string.format("image/face/%d.png", faceId)
    	local faceImg = display.newSprite(imageName)
    	
    	--faceImg:setScale(self._scale)
	    faceImg:setPosition(self:getContentSize().width / 2,self:getContentSize().height / 2)
	    self:addChild(faceImg)
	else
		local faceImgName = lt.ResourceManager:getOccupationFace(occupationId)
	    local faceImgNameFrame = display.newSpriteFrame(faceImgName)
	    if faceImgNameFrame then
	    	local faceImg = display.newSprite(faceImgNameFrame)
		    faceImg:setPosition(self:getContentSize().width / 2,self:getContentSize().height / 2)
		    self:addChild(faceImg)
	    end
    end

    local playerId = lt.DataManager:getPlayerId()

    local id = id or 0
    if playerId == id then
    	return
    end

    local friendTable = lt.DataManager:getFriendTable()
    local friendArray = lt.CommonUtil:getArrayFromTable(friendTable)

    local single = false
    local double = false

    for i = 1,#friendArray do
        if id == friendArray[i]:getId() then
            single = true

            if friendArray[i]:isEachother() then
            	double = true
        	end
        end
    end

    if double then
    	local doubleImg = display.newSprite("#friend_img_double.png")
    	doubleImg:setAnchorPoint(1,1)
    	doubleImg:setPosition(78/2,78/2 + 3)
    	self:addChild(doubleImg)
    	return
    end

    if single then
    	local singleImg = display.newSprite("#friend_img_single.png")
    	singleImg:setAnchorPoint(1,1)
    	singleImg:setPosition(78/2 + 2,78/2 + 2)
    	self:addChild(singleImg)
    end


end

function PlayerFaceButton:setLevel(level)
	if not self._levelLabel then
		self._levelLabel = lt.GameLabel.new(level, 16, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
		self._levelLabel:setAnchorPoint(1, 0)
		self._levelLabel:setPosition(self:getContentSize().width - 6, 4)
		self:addChild(self._levelLabel)
	else
		self._levelLabel:setString(level)
	end
end

function PlayerFaceButton:setGray(isGray)
	if isGray then
		for k,v in pairs(self:getChildren()) do
			if tolua.type(v) == "cc.Sprite" or tolua.type(v) == "cc.Scale9Sprite" then
				self:darkNode(v)
			end
		end
	else
		for k,v in pairs(self:getChildren()) do
			if tolua.type(v) == "cc.Sprite" or tolua.type(v) == "cc.Scale9Sprite" then
				v:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
			end
		end
	end
end

function PlayerFaceButton:darkNode(node)
    node:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgram:createWithFilenames("shader/normalTexture.vsh","shader/gray.fsh")))
end

return PlayerFaceButton