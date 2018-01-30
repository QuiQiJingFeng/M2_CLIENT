local network = App.NetWork
local event_manager = App.EventManager

local logic_login = {}

function logic_login:init()
	self.handshake = nil
end

function logic_login:login(account,password)
	print("connecting.....")
	network:connect("127.0.0.1", 8888,false)
	--握手成功之后才可以发送登陆请求
	event_manager:on("handshake_success",function()
		print("握手成功")
			network:login(account,password)
		end)
	event_manager:on("login_result", function(recv_msg) 
			print("FYD+++登陆成功")
			App.SceneManager:runScene("game_scene")
		end)
end


return logic_login