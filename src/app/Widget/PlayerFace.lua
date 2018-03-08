
local PlayerFace = class("PlayerFace", function(params)
	return display.newSprite("#common_new_icon.png")
end)

PlayerFace._winScale = lt.CacheManager:getWinScale()
PlayerFace._levelLabel = nil

function PlayerFace:ctor(params)
end

function PlayerFace:updateInfo(params)
	self:setEmpty()

	params = params or {}

	-- 游戏机 网络 url > faceId > occupationId> id
	local url = params.url
	if url then
		local urlScale = 77/128

		local faceImg = lt.NetSprite.new(url)
	    faceImg:setScale(urlScale)
	    faceImg:setPosition(self:getContentSize().width / 2,self:getContentSize().height / 2)
	    self:addChild(faceImg)
	else
		local faceId = params.faceId
		if faceId and faceId ~= 0 then 
			local imageName = string.format("image/face/%d.png", faceId)
	    	local faceImg = display.newSprite(imageName)
	    	
		    faceImg:setPosition(self:getContentSize().width / 2,self:getContentSize().height / 2)
		    self:addChild(faceImg)
		else
			local occupationId = params.occupationId

			local faceImgName = lt.ResourceManager:getOccupationFace(occupationId)

	    	local faceImg = display.newSprite(faceImgName)
		    faceImg:setPosition(self:getContentSize().width / 2,self:getContentSize().height / 2)
		    self:addChild(faceImg)

		end
	end

	if params.nofriend then
		return
	end

    -- 处理好友关系
    local playerId = lt.DataManager:getPlayerId()

    local id = params.id or 0
    if playerId == id then
    	return
    end

    local friendTable = lt.DataManager:getFriendTable()
    local friendArray = lt.CommonUtil:getArrayFromTable(friendTable)

    local status = 0

    for i = 1,#friendArray do
        if id == friendArray[i]:getId() then
            status = 1

            if friendArray[i]:isEachother() then
            	status = 2
        	end
        	break
        end
    end

    if status == 2 then
    	-- 互为好友
    	local doubleImg = display.newSprite("#friend_img_double.png")
    	doubleImg:setAnchorPoint(1,1)
    	doubleImg:setPosition(self:getContentSize().width - 3,self:getContentSize().height)
    	self:addChild(doubleImg)
    elseif status == 1 then
    	-- 单向好友
    	local singleImg = display.newSprite("#friend_img_single.png")
    	singleImg:setAnchorPoint(1,1)
    	singleImg:setPosition(self:getContentSize().width,self:getContentSize().height)
    	self:addChild(singleImg)
    end
end

function PlayerFace:setAddedNoMask()
	if not self._addedNoMask then
		self._addedNoMask = display.newSprite("#team_plus.png")
		self._addedNoMask:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self:addChild(self._addedNoMask, 100)

	end
	self._addedNoMask:setVisible(true)
end

function PlayerFace:setEmpty()
	self:removeAllChildren()
	self._levelLabel = nil
	self._addedNoMask = nil
end

function PlayerFace:setLevel(level)
	if not self._levelLabel then
		self._levelLabel = lt.GameLabel.new(level, 16, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.DEFAULT_LABEL_COLOR_2})
		self._levelLabel:setAnchorPoint(1, 0)
		self._levelLabel:setPosition(self:getContentSize().width - 6, 4)
		self:addChild(self._levelLabel)
	else
		self._levelLabel:setString(level)
	end
end

function PlayerFace:setGray(isGray)
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

function PlayerFace:darkNode(node)
    node:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgram:createWithFilenames("shader/normalTexture.vsh","shader/gray.fsh")))
end

return PlayerFace