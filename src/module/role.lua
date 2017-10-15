local role = class("battle_role", cc.Node)

local util = Game.util
local helper = util.helper

local manager = Game.manager
local config = manager.config

function role:init(role_id)
    self.role_config = config.role[role_id]

    self.role_node = helper
        :createCSNode(string.format("%s.csb", self.role_config.role_file), true)
        :addTo(self)

    self:replaceHead(self.role_config.head)
    self:replaceBody(self.role_config.body)

    return self
end

function role:play(...)
    self.role_node:play(...)

    return self
end

function role:onFrameEvent(...)
    return self.role_node:onFrameEvent(...)
end

function role:clearFrameEventCallFunc(...)
    return self.role_node:clearFrameEventCallFunc(...)
end

function role:clearLastFrameCallFunc()
    return self.role_node:clearLastFrameCallFunc()
end

function role:replaceBody(body_id)
    display.loadSpriteFrames(string.format("role/b_%s.plist", body_id), string.format("role/b_%s.png", body_id))

    for k,timeline in ipairs(self.role_node.timeline:getTimelines()) do
        for i,frame in ipairs(timeline:getFrames()) do
            if tolua.type(frame) == "ccs.TextureFrame" then
                local texture_name = frame:getTextureName()
                if string.find(texture_name, "^role/b_") then
                    texture_name = string.gsub(texture_name, "^(role/b_)%d*(/.*.png)", "%1" .. body_id .. "%2")
                    frame:setTextureName(texture_name)
                end
            end
        end
    end

    return self
end

function role:replaceHead(head_id)
    display.loadSpriteFrames(string.format("role/h_%s.plist", head_id), string.format("role/h_%s.png", head_id))

    for k,timeline in ipairs(self.role_node.timeline:getTimelines()) do
        for i,frame in ipairs(timeline:getFrames()) do
            if tolua.type(frame) == "ccs.TextureFrame" then
                local texture_name = frame:getTextureName()
                if string.find(texture_name, "^role/h_") then
                    texture_name = string.gsub(texture_name, "^(role/h_)%d*(/.*.png)", "%1" .. head_id .. "%2")
                    frame:setTextureName(texture_name)
                end
            end
        end
    end

    return self
end

function role:replaceWeapon(weapon_id)
    for k,timeline in ipairs(self.role_node.timeline:getTimelines()) do
        for i,frame in ipairs(timeline:getFrames()) do
            if tolua.type(frame) == "ccs.TextureFrame" then
                local texture_name = frame:getTextureName()
                if string.find(texture_name, "/role/weapon/(%d+).png$") then
                    texture_name = string.gsub(texture_name, "(%d+).png$", string.format("%d.png", weapon_id))
                    frame:setTextureName(texture_name)
                end
            end
        end
    end

    return self
end

return role