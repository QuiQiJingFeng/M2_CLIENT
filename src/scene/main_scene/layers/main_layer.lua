local user = require("logic.user")

local layer = class("main_layer",cc.Layer)

function layer:ctor()

    local title = cc.Label:createWithSystemFont("","Aria",32)
    title:setPosition(display.cx,display.cy*2-100)
    self:addChild(title)

	local create_room_btn = ccui.Button:create("btn_0.png", "btn_1.png")
    create_room_btn:setTitleText("创建房间")
    create_room_btn:setTitleFontSize(28)
    create_room_btn:addClickEventListener(function(sender)
    		AppNet:send({["create_room"] = {}},function(msg) 
                    if msg.result == "success" then
                        print("创建房间成功")
                        local str = "room_id = "..msg.room_id.."\n"
                        str = str.."player id = "..msg.players[1].user_id.."\n"
                        str = str.."player name = "..msg.players[1].user_name
                        title:setString(str)

                        local room_info = { room_id = msg.room_id,players = {}}
                        local player = {user_id = msg.players[1].user_id,user_name = msg.players[1].user_name}
                        table.insert(room_info.players,player)
                        user:setRoomInfo(room_info)
                    else
                        print("创建房间失败 result = ",msg.result)
                    end
                end)
    	end)
    create_room_btn:setPosition(display.cx,display.cy)
    self:addChild(create_room_btn)

    local room_text = cc.EditBox:create(cc.size(200,50), cc.Scale9Sprite:create("btn_test.png"))
    room_text:setPosition(display.cx,display.cy-150)
    self:addChild(room_text)

    local join_room_btn = ccui.Button:create("btn_0.png", "btn_1.png")
    join_room_btn:setTitleText("加入房间")
    join_room_btn:setTitleFontSize(28)
    join_room_btn:addClickEventListener(function(sender)
            local room_id = room_text:getText()
            AppNet:send({["join_room"] = {room_id = room_id}},function(msg)
                    if msg.result == "success" then
                        print("加入房间成功")
                        print("room_id = ",msg.room_id)
                        for i=1,#msg.players do
                            local obj = msg.players[i]
                            print("user_id:",obj.user_id)
                            print("user_name:",obj.user_name)
                        end
                    else
                        print("加入房间失败 result=",msg.result)
                    end
                end)
        end)
    join_room_btn:setPosition(display.cx,display.cy-300)
    self:addChild(join_room_btn)

    lt.GameEventManager:registerEvent("refresh_room_info", function(msg) 
            print("refresh_room_info")
            local str = ""
            for i=1,#msg.players do
                local obj = msg.players[i]
                str = str .. "user_id:"..obj.user_id.." user_name:"..obj.user_name.."\n"
                print("user_id:",obj.user_id)
                print("user_name:",obj.user_name)
            end
            title:setString(str)
        end)
end

return layer