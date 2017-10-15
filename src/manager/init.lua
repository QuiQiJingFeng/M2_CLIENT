Game.manager = Game.manager or {}

require "manager.event_handler"
require "manager.config"
require "manager.network"

Game.manager.config:init()
Game.manager.network:init()
