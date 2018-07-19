-- 头像
local HeadImage = class("HeadImage")
function HeadImage:setHeadImg(info, node, bCircle)
	if not node then
		print("ERROR: 头像设置错误，node is nil")
		return
	end
	local size = node:getContentSize()
	local url = info.user_pic
	local uid = info.user_id
	local bSprite = false
    if url ~= nil and uid ~= nil then
	    local fileName = cc.FileUtils:getInstance():getWritablePath()..uid..".png"
		dump(fileName, "fileName")	   
	    local __file = io.open(fileName, "r")
	    if __file == nil then--如果本地没有就从网上下载
	    	-- loginData
		    lt.CommonUtil:sendXMLHTTPrequrest("GET",url,nil,function(receive)
		    	if receive  then
			    	local tempFile = io.open(fileName,"wb")
				    tempFile:write(receive) --下载后写入本地
				    tempFile:close()
		    	end
		 	end) 
		else
		 	__file:close()
		end
		if node.loadTexture then
	    	node:loadTexture(fileName)
    	elseif node.setTexture then
    		node:setTexture(fileName)
    		bSprite = true
    		-- local size1 = node:getContentSize()
    		-- node:setScale(size.width/size1.width, size.height/size1.height)
	    end
	    -- dump(node:getContentSize(), "contentsize")
	    node:setContentSize(size.width, size.height)
	end
	-- 设置成圆形的头像-- 只是针对imgview, sprite 会出现位置错误
	if bCircle and bSprite == false then
		-- local parent = node:getParent()
		-- local px, py = node:getPosition()
		-- local size = node:getContentSize()
		-- local clipNode = cc.ClippingNode:create()
		-- local stencil = display.newSprite("hallcomm/lobby/img/friend_head_default.png")
		-- stencil:setPosition(size.width/2, size.height/2)
		-- local size1 = stencil:getContentSize()
		-- stencil:setScale(size.width/size1.width, size.height/size1.height)
		-- stencil:setContentSize(size)
		-- clipNode:setStencil(stencil)
		-- clipNode:addChild(stencil)
		-- clipNode:setContentSize(size.width, size.height)
		-- clipNode:setAnchorPoint(cc.p(0.5, 0.5))
		-- clipNode:setAlphaThreshold(0.5)
		-- clipNode:setPosition(px, py)
		-- parent:addChild(clipNode, 100)
		-- clipNode:setPosition(px, py)
		-- node:retain()
		-- node:removeFromParent()
		-- clipNode:addChild(node)
		-- node:setPosition(size.width/2, size.height/2)
		-- node:release()
	end

end

return HeadImage