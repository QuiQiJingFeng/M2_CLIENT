
-- 英灵卡牌(小)
local ServantCardS = class("ServantCardS", function()
	return display.newSprite("#common_new_icon.png")
end)

ServantCardS.TYPE = {
	BASE   = 0, -- 基础
	PLAYER = 1, -- 玩家卡牌
}

ServantCardS.SIZE = lt.Constants.SERVANT_SIZE.S

ServantCardS._type    = nil
ServantCardS._realId  = nil
ServantCardS._modelId = nil

ServantCardS._qualityBg = nil
ServantCardS._mask 		= nil

function ServantCardS:ctor(empty)
	if empty then
		-- 空卡牌
		self:setEmpty()
	end

	self._unfreezeTime = 0
end

function ServantCardS:setEmpty()
	self._realId  = nil
	self._modelId = nil
end

function ServantCardS:updateInfo(type, info, params)
	params = params or {}

	self._type = type

	if not self._type then
		self:setEmpty()
	elseif self._type == self.TYPE.BASE then
		local servantInfo = info

		-- 品质背景
		if self._qualityBg then
			self._qualityBg:removeFromParent()
			self._qualityBg = nil
		end

		self._qualityBg = display.newSprite("#servant_quality_s.png")
		self:addChild(self._qualityBg)

		-- 原画
		local figureId = servantInfo:getModelId()
		local pic    = "image/servant/pics/servants"..figureId..".png"
		local figure = display.newSprite(pic)
		figure:setPosition(self._qualityBg:getContentSize().width / 2, self._qualityBg:getContentSize().height / 2)
		self._qualityBg:addChild(figure)

	elseif self._type == self.TYPE.PLAYER then
		-- 实例
		local playerServant = info

		self._realId  = playerServant:getId()
		self._modelId = playerServant:getModelId()

		self._unfreezeTime = 0

		local grade = info:getQuality() --用紫橙
		local qualityName = lt.ResourceManager:getQualityBg(grade)
		local qualityIconName = lt.ResourceManager:getQualityIcon(grade)


		if self._qualityIcon then
			self._qualityIcon:removeFromParent()
			self._qualityIcon = nil
		end
		
		if grade > lt.Constants.QUALITY.QUALITY_WHITE then
			self._qualityIcon = display.newSprite(qualityIconName)
			self._qualityIcon:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
			self:addChild(self._qualityIcon)
		end

		if self._qualityBg then
			self._qualityBg:removeFromParent()
			self._qualityBg = nil
		end

		self._qualityBg = display.newSprite(qualityName)
		self._qualityBg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self:addChild(self._qualityBg)

		-- 原画

		local figureId = playerServant:getFigureId()
		local pic    = "image/servant/pics/servants"..figureId..".png"
		local figure = display.newSprite(pic)
		figure:setPosition(self._qualityBg:getContentSize().width / 2, self._qualityBg:getContentSize().height / 2)
		self._qualityBg:addChild(figure)


		if not params.noPropertyIcon then
			-- 元素
			local property     = playerServant:getProperty()
			local propertyIcon = lt.PropertyIcon.new(property)
			propertyIcon:setScale(0.9)
			propertyIcon:setPosition(self._qualityBg:getContentSize().width - 8, self._qualityBg:getContentSize().height - 8)
			self._qualityBg:addChild(propertyIcon, 10)
		end

		if not params.noDetail then
			-- 等级
			-- local levelBg = display.newSprite()
			-- levelBg:setAnchorPoint(0, 0.5)
			-- levelBg:setPosition(0, 32)
			-- self._qualityBg:addChild(levelBg)

			local level = playerServant:getLevel()
			local levelLabel = lt.GameBMLabel.new(level, "#fonts/icon_num.fnt")
			--levelLabel:setScale(0.75)
			levelLabel:setAnchorPoint(0, 0)
			levelLabel:setPosition(3, 20)
			levelLabel:setAdditionalKerning(-2)
			self._qualityBg:addChild(levelLabel)

			local star = playerServant:getServantInfo():getStar()
			local star1 = math.floor((star + 1) / 2)
			local star2 = star % 2

			for i=1,5 do
				local starBg = display.newSprite("#common_star_empty_1.png")
				starBg:setScale(0.35)
				starBg:setPosition(self._qualityBg:getContentSize().width / 2 + (i - 3) * 17, 11)
				self._qualityBg:addChild(starBg, 5 - i)

				if i <= star then
					local starF = display.newSprite("#common_star_4.png")
					starF:setPosition(starBg:getContentSize().width / 2, starBg:getContentSize().height / 2)
					starBg:addChild(starF)
				end
			end
		end
	end
end

function ServantCardS:getRealId()
	return self._realId
end

function ServantCardS:getModelId()
	return self._modelId
end

function ServantCardS:selected(noFlag)
	if not self._mask then
		self._mask = display.newSprite("#common_icon_mask.png")
		self._mask:setPosition(self._qualityBg:getContentSize().width / 2, self._qualityBg:getContentSize().height / 2)
		self._qualityBg:addChild(self._mask, 5)

		if not noFlag then
			local flag = display.newSprite("#common_icon_selected.png")
			flag:setPosition(self._mask:getContentSize().width / 2, self._mask:getContentSize().height / 2)
			self._mask:addChild(flag)
		end
	end

	self._mask:setVisible(true)
end

function ServantCardS:unselected()
	if self._mask then self._mask:setVisible(false) end
end

function ServantCardS:isFrozen()
	local diffTime = self._unfreezeTime - lt.CommonUtil:getCurrentTime()
	if diffTime > 0 then
		self:setGray(true)
		return true
	end
	return false
end

function ServantCardS:getFreezeTimeString()
	local diffTime = self._unfreezeTime - lt.CommonUtil:getCurrentTime()
	if diffTime <= 0 then
		return ""
	end
	local d = math.floor(diffTime/(3600*24))
	local h = math.floor((diffTime-d*24*3600)/3600)
	local m = math.floor((diffTime - h*3600 - d*24*3600)/60)
	return string.format(lt.StringManager:getString("STRING_STALL_TIPS_34"),d,h,m)
end

function ServantCardS:setGray(isGray)
	if isGray then
		self:darkNode(self._qualityBg)
		for k,v in pairs(self._qualityBg:getChildren()) do
			self:darkNode(v)
		end
	else
		self._qualityBg:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
		for k,v in pairs(self._qualityBg:getChildren()) do
			v:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
		end
	end
end

function ServantCardS:darkNode(node)
	if device.platform ~= "windows" then
	    local vertDefaultSource = "\n"..
	    "attribute vec4 a_position; \n" ..
	    "attribute vec2 a_texCoord; \n" ..
	    "attribute vec4 a_color; \n"..                                                    
	    "#ifdef GL_ES  \n"..
	    "varying lowp vec4 v_fragmentColor;\n"..
	    "varying mediump vec2 v_texCoord;\n"..
	    "#else                      \n" ..
	    "varying vec4 v_fragmentColor; \n" ..
	    "varying vec2 v_texCoord;  \n"..
	    "#endif    \n"..
	    "void main() \n"..
	    "{\n" ..
	    "gl_Position = CC_PMatrix * a_position; \n"..
	    "v_fragmentColor = a_color;\n"..
	    "v_texCoord = a_texCoord;\n"..
	    "}"
	     
	    local pszFragSource = "#ifdef GL_ES \n" ..
	    "precision mediump float; \n" ..
	    "#endif \n" ..
	    "varying vec4 v_fragmentColor; \n" ..
	    "varying vec2 v_texCoord; \n" ..
	    "void main(void) \n" ..
	    "{ \n" ..
	    "vec4 c = texture2D(CC_Texture0, v_texCoord); \n" ..
	    "gl_FragColor.xyz = vec3(0.4*c.r + 0.4*c.g + 0.4*c.b); \n"..
	    "gl_FragColor.w = c.w * v_fragmentColor.w; \n"..
	    "}"
	 
	    local pProgram = cc.GLProgram:createWithByteArrays(vertDefaultSource,pszFragSource)
	     
	    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
	    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
	    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
	    pProgram:link()
	    pProgram:updateUniforms()
	    node:setGLProgram(pProgram)
	end
end

return ServantCardS
