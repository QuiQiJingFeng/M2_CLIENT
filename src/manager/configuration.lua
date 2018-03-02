local configuration = {}
function configuration:Init()
    self.json_obj = {
        account = "",
        password = ""
    }

    self.path = self:GetConfigPath()

    local fp = io.open(self.path, "r")
    if not fp then
        fp = io.open(self.path, "w")
        fp:close()
        return
    end

    local content = fp:read("*a")
    fp:close()

    if string.len(content) ~= 0 then
        self.json_obj = json.decode(content)
    end
end

function configuration:SetAccountInfo(account, pwd)
    self.json_obj["account"] = account
    self.json_obj["password"] = pwd
end

function configuration:GetAccountAndPwd()
    return self.json_obj["account"], self.json_obj["password"]
end

function configuration:Save()
    print("str ==   ",self.json_obj)
    --清空文件，然后重新写入
    local str = json.encode(self.json_obj)
    
    if str then
        local fp = io.open(self.path, "w+")

        if fp then
            fp:write(str)
            fp:close()
        end
    end
end

function configuration:GetConfigPath()
    return cc.FileUtils:getInstance():getWritablePath().."configuration"..".txt"
end



return configuration
