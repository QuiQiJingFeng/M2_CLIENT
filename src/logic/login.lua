Game.logic.login = { handler = {} }

local manager = Game.manager
local network = manager.network

local login = Game.logic.login
local handler = login.handler

function handler.login(rsp_msg)
end
function login:login()
end

function handler.logout(rsp_msg)
    if rsp_msg.result == "success" then
        network:disconnect()
    end
end
function login:logout()
    local req_msg = { }
    network:send({["logout"] = req_msg}, handler.logout)
end