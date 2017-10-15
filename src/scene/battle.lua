local logic = Game.logic

local scene = class("battle_scene", require("scene.prototype"))

function scene:onCreate(battle_data)
    logic.battle:init(battle_data)
end

function scene:onEnter()
    logic.battle:nextState()
end

function scene:onUpdate(dt)
    logic.battle:onUpdate(dt)
end

return scene