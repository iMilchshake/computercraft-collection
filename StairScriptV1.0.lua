--Will simply dig you a Stair(1 block wide, 4 blocks high) with given length.

local function forward_check() --go forward and check for gravel/sand
	while not turtle.forward() do
	sleep(0.1)
	turtle.dig()
	end
end

local function treppe_step(i)
	turtle.dig()
	forward_check()
	turtle.digUp()
	sleep(0.5)
	while turtle.detectUp() do
		turtle.digUp()
		sleep(0.5)
	end
	turtle.digDown()
	turtle.down()
	print("Finished Step " .. i)
end

local function treppe(length)
print("starting task..")
	for i=0,length do
		treppe_step(i)
	end
end

for b=1,10 do
	print("")
end
print("-------------------------------------")
print("         Tobis Treppen Ding          ")
print("") 
print("-------------------------------------")
write("Enter Length: ")
treppe(read())