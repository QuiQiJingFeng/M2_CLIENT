cc.FileUtils:getInstance():setPopupNotify(false)

if CC_SHOW_FPS then
    cc.Director:getInstance():setDisplayStats(true)
end

local function main()
	--TODO
    -- display.runScene(require("scene.battle"):create(require("tmp"):doBattle()))
    -- display.runScene(require("scene.game_scene"):create())

    -- App.SceneManager:runScene("login_scene")
    require("app.AppGame").new():run()

 --    require("app.Net.Protobuf")
 -- -- 注册protobuf协议
 --    protobuf.register(cc.FileUtils:getInstance():getStringFromFile("proto/protocol.pb"))
 --    local data_content = {
 --                game_cmd = {
 --                            command="PLAY_CARD",
 --                            nowType=101,
 --                            nowValue=3,
 --                            cardNums={1},
 --                            cardList={403}
 --                        }
 --                    }
 --    local success, data, err = pcall(protobuf.encode, "C2S", data_content)
 --    if not success or err then
 --        print("encode protobuf error:", success, data, err)
 --    else
 --        print("success")
 --    end


end

function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print(debug.traceback(msg))
    print("----------------------------------------")

    return msg
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
