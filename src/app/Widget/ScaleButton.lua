
-- ################################################## 通用按钮(缩放) ##################################################
local ScaleButton = class("ScaleButton", lt.PushButton)

ScaleButton.MIX                 = 0
-- ScaleButton.RED                 = 2
-- ScaleButton.NEWGRAY             = 7
-- ScaleButton.NEWYELLOW           = 8
-- ScaleButton.SMALLBLUE           = 9
-- ScaleButton.NEW_YELLOW          = 10 --最新版黄色
-- ScaleButton.NEW_BLUE            = 11 --最新版蓝色
-- ScaleButton.NEW_SMALL_YELLOW    = 12 --最新版黄色(小)
-- ScaleButton.NEW_SMALL_BLUE      = 13 --最新版蓝色(小)
-- ScaleButton.CELL_YELLOW         = 101

ScaleButton.BLUE                = 1001
ScaleButton.YELLOW              = 1002
ScaleButton.SMALL_BLUE          = 1003
ScaleButton.SMALL_YELLOW        = 1004
ScaleButton.HORN_BLUE           = 1005 --带角的蓝色 119x70
ScaleButton.ORANGE              = 1006 --新的橙色 125 * 70
ScaleButton.POP_LONG_BLUE       = 1007 --带角的蓝色 120*60
ScaleButton.GREY                = 1008 --灰色按钮 176 * 68
ScaleButton.GRAY                = 1009 -- 新的灰色
ScaleButton.PINK                = 1010

ScaleButton.IMAGE_TABLE = {
    [ScaleButton.BLUE]             = "#common_btn_blue_new.png",
    [ScaleButton.YELLOW]           = "#common_btn_yellow_new.png",
    [ScaleButton.SMALL_BLUE]       = "#common_btn_blue_small_new.png",
    [ScaleButton.SMALL_YELLOW]     = "#common_btn_yellow_small_new.png",
    [ScaleButton.GRAY]             = "#common_btn_gray_new.png",
    [ScaleButton.PINK]             = "#common_btn_pink_new.png",
    [ScaleButton.ORANGE]           = "#common_btn_orange_new.png",

    [ScaleButton.HORN_BLUE]        = "#common_new_blue_btn.png",
    [ScaleButton.POP_LONG_BLUE]    = "#common_btn_pop_longblue.png",
    [ScaleButton.GREY]             = "#common_cell_newgray.png",
    -- [ScaleButton.SMALLBLUE]        = "#common_btn_small_blue.png",
    -- [ScaleButton.RED]              = "image/ui/common/common_btn_red.png",
    -- [ScaleButton.NEWGRAY]          = "#common_btn_newGray.png",
    -- [ScaleButton.NEWYELLOW]        = "#common_btn_newYellow.png",
    -- [ScaleButton.CELL_YELLOW]      = "#common_cell_yellow.png",
    -- [ScaleButton.NEW_YELLOW]       = "#common_btn_yellow_new.png",
    -- [ScaleButton.NEW_BLUE]         = "#common_btn_blue_new.png",
    -- [ScaleButton.NEW_SMALL_YELLOW] = "#common_btn_yellow_small_new.png",
    -- [ScaleButton.NEW_SMALL_BLUE]   = "#common_btn_blue_small_new.png",
}

function ScaleButton.tpToImage(tp, options)
    local imageName = nil
    if tp == ScaleButton.MIX then
        imageName = {}
        imageName.normal   = options.normal
        imageName.disabled = options.disabled
    else
        imageName = ScaleButton.IMAGE_TABLE[tp]
    end

    return imageName
end

-- options 中 设置 scale 为 设置按钮初始大小
function ScaleButton.newClose(options)
    return ScaleButton.new("#common_btn_close1.png", options)
end

function ScaleButton.newBlue(options)
    return ScaleButton.newButton(ScaleButton.NEW_BLUE, options)
end

function ScaleButton.newButton(tp, options)
    local imageName = ScaleButton.tpToImage(tp, options)

    return ScaleButton.new(imageName, options)
end

function ScaleButton:ctor(imageName, options)
    ScaleButton.super.ctor(self, imageName, options)

    self:onButtonPressed(function(event)
    						local scale = 0.9 * event.target:getBaseScale()
    						event.target:setScale(scale)
    					end)

    self:onButtonRelease(function(event)
    						local scale1 = 1.1 * event.target:getBaseScale()
    						local scale2 = 1.0 * event.target:getBaseScale()
    						event.target:runAction(cca.seq {
    													cca.scaleTo(0.1, scale1),
    													cca.scaleTo(0.05, scale2)
    												})
    					end)
end

return ScaleButton
