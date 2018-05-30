-- 头像
local HeadImage = class("HeadImage",function()
	return display.newLayer()
end)
--url = 下载玩家的地址
--uid = 一般使用user_id,用于标识名字
--posX,posY = 位置
--scalenum = 缩放
function HeadImage:ctor(url,uid,posX,posY,scalenum)
	if posX ~= nil and posY~= nil then
		self.fullFileName = "res/hallcomm/head/default.png"
	    self.img = display.newSprite(self.fullFileName)
	    self.img:setScale(scalenum)
	    self.img:setPosition(posX,posY)
	    self:addChild(self.img)

	    if url ~= nil and uid ~= nil then

		    local fileName = ""
		    fileName = cc.FileUtils:getInstance():getWritablePath()..uid..".png"
		    print("fileName",fileName)

		    local f = io.open(fileName, "r")

		    if f == nil then--如果本地没有就从网上下载
			    lt.CommonUtil:sendXMLHTTPrequrest("GET",url,nil,function(receive)

			    	local ff = io.open(fileName,"wb")
				    ff:write(receive) --下载后写入本地
				    ff:close()

				    if self.img~= nil then 
				        self.img:removeFromParent() 
				    end
				    local imgu = display.newSprite(fileName)
				    imgu:setScale(scalenum)
				    imgu:setPosition(posX,posY)
		    		self:addChild(imgu)
			 	end) 
			else
			 	f:close()
		        self.fullFileName = fileName
		        if self.img~= nil then 
			        	self.img:removeFromParent() 
			        end

			    local image= display.newSprite(fileName)
			    image:setScale(scalenum)
			   	image:setPosition(posX,posY)
		    	self:addChild(image)

			end
		end
	end
end

return HeadImage