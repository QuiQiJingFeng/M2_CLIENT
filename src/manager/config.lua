Game.manager.config = {}

local config = Game.manager.config
function config:init()
    self:loadAll()
end

function config:loadAll()
    self.buff = require("config.buff")
    self.active = require("config.active")
    self.passive = require("config.passive")
    self.role = require("config.role")
    self.class = require("config.class")
    self.animation = require("config.animation")
end

return config