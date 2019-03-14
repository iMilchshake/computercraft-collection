-- Will walk around randomly like a cleaning Robot
--
local function forward_check() --go forward and check for gravel/sand
	while not turtle.forward() do
	sleep(0.1)
	turtle.dig()
	end
end
local function randomTurn()
	if math.random()>=0.5 then
		turtle.turnRight()
		else
		turtle.turnLeft()
		end
end
local function wuseln()
	while(true) do
		if math.random()>=0.1 then
			if not turtle.forward() then
				randomTurn()
			end
		else
			randomTurn()
		end
		
		print("Fuel left: " .. 	turtle.getFuelLevel())
		
	end
end

for b=1,10 do
	print("")
end

math.randomseed(os.time()) 

print("-------------------------------------")
print("          Tobis Wusel Ding           ")
print("") 
print("-------------------------------------")
wuseln()