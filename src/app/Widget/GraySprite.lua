
local GraySprite = class("GraySprite", function(filename, x, y, params)
	return display.newSprite(filename, x, y, params)
end)

GraySprite._isGray = false

function GraySprite:ctor()
	self:setGray(true)
end

function GraySprite:setGray(isGray)
	if self._isGray == isGray then
		return
	end

	self._isGray = isGray

	if self._isGray then
        self:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgram:createWithFilenames("shader/normalTexture.vsh","shader/gray.fsh")))
	else
		self:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
	end
end

return GraySprite
