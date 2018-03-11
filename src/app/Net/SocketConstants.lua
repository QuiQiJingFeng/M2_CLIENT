
local SocketConstants = {}

-- Message Id

SocketConstants.ID_C2S_PC_REGISTER 			 	= 80001
SocketConstants.ID_S2C_PC_REGISTER 			  	= 80002

SocketConstants.ID_C2S_KEEP_ALIVE   				= 90000
SocketConstants.ID_S2C_KEEP_ALIVE   				= 90001

-- Code
SocketConstants.CODE_OK                     						= 0
SocketConstants.CODE_ERROR                  						= 1  	-- 服务器出错
SocketConstants.CODE_UNDER_MAINTENANCE      						= 2     -- 服务器维护中
SocketConstants.CODE_VERSION_INVALID        						= 3     -- 版本无效
SocketConstants.CODE_SERVER_BUSY 									= 4 	-- 服务器忙
					
return SocketConstants
