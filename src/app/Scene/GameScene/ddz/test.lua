-- local bit = require("bit")


-- -- 转换成是谁在操作，可根据服务器获取
-- function s2cPlayerPos(iPost)

-- 	-- local meExtraNum = self:getMyExtraNum()
-- 	-- local iPlayerNum = self:getPlayNum()

-- 	local meExtraNum = 1
-- 	local iPlayerNum = 3

-- 	local diff = iPost - meExtraNum + 2

-- 	if diff <= 0 then
-- 		diff = iPlayerNum
-- 	end

-- 	if diff > iPlayerNum then
-- 		diff = 1
-- 	end

-- 	return diff
-- end


-- local pos = s2cPlayerPos(1)

-- print("pos, ", pos)\\



-- print(nil == 0)













		


-- cCards =        [104,104,103,103,103,103,105,105]
-- player.handle_cards =   []
-- statu = 61181 ,i = 9 max_count = 4 arg_value = [3]
-- statu = 61181 ,i = 9 max_count = 4 arg_value = [3]
-- player.handle_cards after delete =      [0,0,0,0,0,0,0,0,0,0,0,0,106,106,106,106,209,111,307,313]



local cCards = {104,104,103,103,103,103,105,105}
local handle_cards = {103,103,103,103,104,104,104,104,105,105,105,105,106,106,106,106,209,111,307,313}


for i = 1, 20 do
	if not cCards[i] then
		break
	end 
	for j = 1, 20 do 
		if handle_cards[j] == cCards[i] then
			handle_cards[j] = 0
			-- for z = j, 19 do 
			-- 	player.handle_cards[z] = player.handle_cards[z+1]
			-- 	player.handle_cards[z+1] = 0
			-- end
			break
		end
	end			
end

for i, v in pairs(handle_cards) do 
	print(i, v)
end

-- print()






























