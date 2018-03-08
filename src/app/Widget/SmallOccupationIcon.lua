local SmallOccupationIcon = class("SmallOccupationIcon", function(occupationId)
	local iconStr = "#"..lt.ResourceManager.OCCUPATION_EMBLEM_SMALL[occupationId]
	return display.newSprite(iconStr)
end)

function SmallOccupationIcon:setGray(isGray)
	if isGray then
		self:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgram:createWithFilenames("shader/normalTexture.vsh","shader/gray.fsh")))
	else
		self:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
	end
end

return SmallOccupationIcon
