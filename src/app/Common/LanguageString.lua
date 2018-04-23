
local LanguageString = {}

LanguageString["STRING_GAME_NAME_1"] 				= "红中麻将"
LanguageString["STRING_GAME_NAME_2"]			= "斗地主"


function LanguageString:getString(key)
	return LanguageString[key] or nil
end

return LanguageString