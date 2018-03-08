
local ScaleBMLabelButton = class("ScaleBMLabelButton", lt.ScaleButton)

-- old
function ScaleBMLabelButton.newCommit(options)
	options = options or {}

	local commonStr = options.str or "STRING_COMMON_COMMIT"

	return ScaleBMLabelButton.new(commonStr, ScaleBMLabelButton.BLUE, options)
end
function ScaleBMLabelButton.newCancel(options)
	options = options or {}

	local cancelStr = options.str or "STRING_COMMON_CANCEL"

	return ScaleBMLabelButton.new(cancelStr, ScaleBMLabelButton.RED, options)
end
function ScaleBMLabelButton.newBack(options)
	options = options or {}
	options.offset = 20
	options.pic = "#common_icon_back.png"
	options.picOffset = -30
	return ScaleBMLabelButton.new("STRING_COMMON_BACK", ScaleBMLabelButton.BLUE, options)
end
function ScaleBMLabelButton.newMix(key, options)
	return ScaleBMLabelButton.new(key, ScaleBMLabelButton.MIX, options)
end


function ScaleBMLabelButton.newRed(key, options)
	return ScaleBMLabelButton.new(key, ScaleBMLabelButton.RED, options)
end

function ScaleBMLabelButton.newBigYellow(key, options)
	options = options or {}
	options.size = cc.size(152, 90)

	return ScaleBMLabelButton.new(key, ScaleBMLabelButton.YELLOW, options)
end

-- new
function ScaleBMLabelButton.newBlue(key, font, options)
	return ScaleBMLabelButton.new(key, font, ScaleBMLabelButton.BLUE, options)
end

function ScaleBMLabelButton.newYellow(key, font, options)
	return ScaleBMLabelButton.new(key, font, ScaleBMLabelButton.YELLOW, options)
end

function ScaleBMLabelButton.newSmallBlue(key, font, options)
	return ScaleBMLabelButton.new(key, font, ScaleBMLabelButton.SMALL_BLUE, options)
end

function ScaleBMLabelButton.newSmallYellow(key, font, options)
	return ScaleBMLabelButton.new(key, font, ScaleBMLabelButton.SMALL_YELLOW, options)
end

function ScaleBMLabelButton.newGrey(key, font, options)
	return ScaleBMLabelButton.new(key, font, ScaleBMLabelButton.GREY, options)
end

function ScaleBMLabelButton.newGray(key, font, options)
	return ScaleBMLabelButton.new(key, font, ScaleBMLabelButton.GRAY, options)
end

function ScaleBMLabelButton:ctor(key, font, tp, options)
	local imageName = self.tpToImage(tp, options)

	ScaleBMLabelButton.super.ctor(self, imageName, options)

	-- 美术字
	local str = lt.StringManager:getString(key)
	local label = lt.GameLabel.new(str, lt.Constants.FONT_SIZE4, lt.Constants.COLOR.WHITE, {outline = true, outlineColor = lt.Constants.COLOR.COMMON_BTN_OUTLINE_COLOR})
	label:setAdditionalKerning(2)

	self:setButtonLabel("normal", label)
end

function ScaleBMLabelButton:setKeyString(key)
	self:setString(lt.StringManager:getString(key))
end

function ScaleBMLabelButton:setString(string)
	self._string = string
	self:getButtonLabel("normal"):setString(string)
end

return ScaleBMLabelButton
