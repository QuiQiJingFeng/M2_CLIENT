
local ScaleLabelButton = class("ScaleLabelButton", lt.ScaleButton)

-- old
function ScaleLabelButton.newCommit(options)
	options = options or {}

	local commonStr = options.str or "STRING_COMMON_COMMIT"

	return ScaleLabelButton.new(commonStr, ScaleLabelButton.BLUE, options)
end
function ScaleLabelButton.newCancel(options)
	options = options or {}

	local cancelStr = options.str or "STRING_COMMON_CANCEL"

	return ScaleLabelButton.new(cancelStr, ScaleLabelButton.YELLOW, options)
end
function ScaleLabelButton.newBack(options)
	options = options or {}
	options.offset = 20
	options.pic = "#common_icon_back.png"
	options.picOffset = -30
	return ScaleLabelButton.new("STRING_COMMON_BACK", ScaleLabelButton.BLUE, options)
end
function ScaleLabelButton.newMix(key, options)
	return ScaleLabelButton.new(key, ScaleLabelButton.MIX, options)
end

function ScaleLabelButton.newRed(key, options)
	return ScaleLabelButton.new(key, ScaleLabelButton.RED, options)
end

function ScaleLabelButton.newBigYellow(key, options)
	options = options or {}
	options.size = cc.size(152, 90)

	return ScaleLabelButton.new(key, ScaleLabelButton.YELLOW, options)
end

-- new
function ScaleLabelButton.newBlue(key, options)
    return ScaleLabelButton.new(key, ScaleLabelButton.BLUE, options)
end

function ScaleLabelButton.newYellow(key, options)
	return ScaleLabelButton.new(key, ScaleLabelButton.YELLOW, options)
end

function ScaleLabelButton.newSmallBlue(key, options)
	return ScaleLabelButton.new(key, ScaleLabelButton.SMALL_BLUE, options)
end

function ScaleLabelButton.newSmallYellow(key, options)
	return ScaleLabelButton.new(key, ScaleLabelButton.SMALL_YELLOW, options)
end

function ScaleLabelButton.newHornBlue(key, options)
	return ScaleLabelButton.new(key, ScaleLabelButton.HORN_BLUE, options)
end

function ScaleLabelButton.newOrange(key, options)
	return ScaleLabelButton.new(key, ScaleLabelButton.ORANGE, options)
end

function ScaleLabelButton.newPopLongBlue(key, options)
	return ScaleLabelButton.new(key, ScaleLabelButton.POP_LONG_BLUE, options)
end

function ScaleLabelButton.newPink(key, options)
	return ScaleLabelButton.new(key, ScaleLabelButton.PINK, options)
end

function ScaleLabelButton:ctor(key, tp, options)
	local imageName = self.tpToImage(tp, options)

	options = options or {}

	ScaleLabelButton.super.ctor(self, imageName, options)

	if type(key) == "table" then
		for state,st in pairs(key) do
			local skey = ""
			local color = lt.Constants.DEFAULT_LABEL_COLOR_2
			if type(st) == "string" then
				skey = st
			elseif type(st) == "table" then
				skey = st.string or skey
				color = st.color or color
			end

			local label = lt.GameLabel.newString(skey, 22, color, {outline = 1})
			self:setButtonLabel(state, label)
		end
	elseif type(key) == "string" then
		local fontSize = options.fontSize or 18
		local label = lt.GameLabel.newString(key, fontSize, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
		self:setButtonLabel("normal", label)
	end

	local offset, offsetY = 0
	offset  = options.offset or 1
	offsetY = options.offsetY or 0
	self:setButtonLabelOffset(offset, offsetY)

	if options and options.pic then
		local pic = options.pic
		local picOffset = options.picOffset or 0

		local Pic = display.newSprite(pic)
		Pic:setPosition(picOffset, 0)
		self:addChild(Pic)
	end
end

function ScaleLabelButton:setKeyString(key)
	self:setString(lt.StringManager:getString(key))
end

function ScaleLabelButton:setString(string)
	self._string = string
	self:getButtonLabel("normal"):setString(string)
end

function ScaleLabelButton:getString()
	return self._string
end

return ScaleLabelButton
