local UITableViewItem = class("UITableViewItem",function() 
		return ccui.ImageView:create("res/hallcomm/lobby/img/myRoom_bg3.png")
	end)

function UITableViewItem:ctor()
    self:setScale9Enabled(true)
    self:setContentSize(cc.size(400,70))

    self.text = cc.Label:createWithSystemFont("", "Arial", 36)
    self.text:setPosition(200,35)
    self:addChild(self.text)
end

--return cell size
function UITableViewItem:refreshData(data)
	
end

return UITableViewItem