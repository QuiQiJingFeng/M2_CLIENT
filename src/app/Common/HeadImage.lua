-- 头像
local HeadImage = class("HeadImage")

--@param info  玩家信息， 需要使用user_pic， user_id 字段
--@param node  imgNode, 精灵和图片都可以, 更换一下纹理
--example 
--[[
	lt.HeadImage:setHeadImg(loginData, nodeImg)
]]
function HeadImage:setHeadImg(info, node)
	if not node then
		print("ERROR: 头像设置错误，node is nil")
		return
	end
	local size = node:getContentSize()
	local url = info.user_pic
	local uid = info.user_id

	-- 无效路径
	if url == "" or url == "http://xxxx.png" then
		url = nil
	end
    if url ~= nil and uid ~= nil then
	    local fileName = cc.FileUtils:getInstance():getWritablePath()..uid..".png"
	    local __file = io.open(fileName, "r")
	    if __file == nil then--如果本地没有就从网上下载
	    	-- loginData
		    lt.CommonUtil:sendXMLHTTPrequrest("GET",url,nil,function(receive)
		    	if receive  then
			    	local tempFile = io.open(fileName,"wb")
				    tempFile:write(receive) --下载后写入本地
				    tempFile:close()
				    node:loadTexture(fileName)
					if node.loadTexture then
				    	node:loadTexture(fileName)
			    	elseif node.setTexture then
			    		node:setTexture(fileName)
				    end
		    	end
		 	end) 
		else
		 	__file:close()
		end
		if node.loadTexture then
	    	node:loadTexture(fileName)
    	elseif node.setTexture then
    		node:setTexture(fileName)
	    end
	    node:setContentSize(size.width, size.height)
	end
end

return HeadImage