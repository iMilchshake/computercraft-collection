--
-- Recursive Minerscript by iMilchshake | Version: 1.5a
--
-- USAGE:
--  -Put Chests in Slot 1, Torches in Slot 2, leave Slot 3 empty
--	-Load the Script (with pastebin run/get)
--	-input length for the tunnel. 
--	-relax
--
-- Changelog:
-- 1.1a: 	-Gravelproof walking (Function: forward_check() "go forward with checking")
--       	-OreDetection
--			-Length Input
--
-- 1.2a:    -Stop on Critical Error
--			-setTorch() and setTorchUp() Method
--			-Proofer Gravelproof (looks a bit stupid but it works!)
-- 
-- 1.3a:	-Builds Bridges
--			-Will try to leak Liquid-Holes
--			-Detecting Ores Below!
--
-- 1.4a:    -Torch Reminder / Better Menu
--			-Even prooofer Gravelproof! (While Recursive-Oremining)
--			-Builds Chests (Needs Slot 3 for tmp moving around, so dont use that one!)
--			-Checks more Blocks for Ores
--
-- 1.5a:	-Safer Chesting	
--			-Summary when Finished
--			-Better Torches
--			-Stays loaded when done to show Summary
--
-- TODO:	-fuel control
--			-estimate Fuel-usage
--			-further Error Detection
--			-abort recursive Mining when last slot is full!
--




local function printSummary()
if critical_error==false then
	for b=1,15 do
		print("")
	end
end
print("-------------------------------------")
print("              Summary                ")
print("-------------------------------------")
print("Ores Found:         " .. ores)
print("Blocks mined total: " .. ores+(tunnel_length*6))
print("Torches placed:     " .. torches .. "/" .. (turtle.getItemCount(2)+torches))
print("Chests placed:      " .. chests .. "/" .. (turtle.getItemCount(1)+chests))
print("Fuel before: " .. startfuel .. " -> Fuel now: " .. turtle.getFuelLevel())
end

local function SpitOut()
	for i=4,16 do
			turtle.select(i)
			turtle.drop()
	end
	turtle.select(4)
end

local function saveChest()
	turtle.select(1)
	turtle.transferTo(3,1) --transfer one chest to slot 3
	turtle.select(3)
	turtle.turnLeft()
	if not turtle.place() then --try to place
		turtle.turnRight()
		turtle.turnRight()
		if not turtle.place() then
			turtle.turnRight()
			if not turtle.place() then		
				print("Critical Error: Cant Place Chest! No Chests or Colliding Blocks")
				critical_error=true
			
			else
				SpitOut()
			end
			turtle.turnLeft()
		else
			SpitOut()
		end
		
		turtle.turnLeft()
	else
		SpitOut()
		turtle.turnRight()
	end
	chests=chests+1 --assuming a chest was set because otherwise it will stop anyways
	turtle.select(4)
end

local function setTorch()
	turtle.select(2)
	if not turtle.place() then --try to place
		print("Error: No Torches or Colliding Block, will keep Minin.!")
	else
		torches=torches+1
	end
	turtle.select(4)
end

local function setTorchUp()
	turtle.select(2)
	turtle.turnLeft()
	if turtle.back() then
		if not turtle.placeUp() then --try to place
			print("Error: No Torches or Colliding Block, will keep Minin.!")
		else
			torches=torches+1
		end
	turtle.forward()
	else
		print("Error: Coulnt go back to place torch!")
	end
	turtle.turnRight()
	turtle.select(4)
end

local function forward_check() --go forward and check for gravel/sand
	while not turtle.forward() do
	sleep(0.1)
	turtle.dig()
	end
end

local function isOre(str)
    if string.find(string.lower(str),"ore") then
		print("Found Ore: (" .. str ..")")
		ores=ores+1
        return true
    else
        return false
    end
end

local function mine(dir,mode) --mode: 1(normal) 0(ore-only) |dir: 0(d) 1(f) 2(u)
   
   if critical_error==true then
		print("Critical Error! Closing Mine Method.")
		return
	end

	if turtle.getItemCount(15)>0 then --save Stuff in Chest
		return
	end
	
    --print("direction:" .. dir .. " / mode: " .. mode)
   
    local success, data
    if dir == 0 then --up
    success, data = turtle.inspectUp()
    elseif dir==1 then --foward
    success, data = turtle.inspect()
    else --down
    success, data = turtle.inspectDown()
    end
   
    --if success==true then
    --  print("block gefunden!")
    --else
    --  print("kein block gefunden")
    --end
   
    if mode==1 then
        if dir == 0 then    --up
            turtle.digUp()
        elseif dir==1 then  --foward
            turtle.dig()
        else                --do
            turtle.digDown()
        end
    end
   
    if success then
        --if data.name == "minecraft:gold_ore" then --Found Ore
        if isOre(data.name) then --schaut ob ore im namen steht
        --print("I found ore!")
            if mode==0 then
                if dir == 0 then    --up
                    turtle.digUp()
					
					sleep(0.5) --wait for gravel
					while turtle.detectUp() do
					turtle.digUp()
					sleep(0.5)
					end
			
                elseif dir==1 then  --foward
                    turtle.dig()
                else                --down
                    turtle.digDown()
                end
            end
           
            if dir == 0 then    --up
                turtle.up()
            elseif dir==1 then  --foward
                --turtle.forward()
				forward_check() --check for gravel
            else                --down
                turtle.down()
            end
           
            mine(1,0)
            turtle.turnLeft()
            mine(1,0)
            turtle.turnLeft()
            mine(1,0)
            turtle.turnLeft()
            mine(1,0)
            turtle.turnLeft()
 
            mine(0,0)
            mine(2,0)
           
            if dir == 0 then    --up
                turtle.down()
            elseif dir==1 then  --foward
                turtle.back()
            else                --down
                turtle.up()
            end
		end
    end
    if mode==0 then
    end
end
 


local function tunnel_step(torch)
	if critical_error==true then
		print("Critical Error! Closing Tunnel Method")
		return
	end

	mine(1,1) --mine vorne
    forward_check()
    mine(0,1) --mine oben      
    turtle.turnLeft()
	
    mine(1,1) --mine vorne
	forward_check() 
	mine(0,1) --mine oben 
	mine(1,0) --nach ore suchen links unten
	turtle.up()
	mine(1,0) --nach ore suchen links oben
	mine(0,0) --Search for Ores Above!
	turtle.down()
	mine(2,0) --Search for Ores Below!
	turtle.turnRight()
	turtle.turnRight()
	forward_check() 
       
	mine(1,1) --mine vorne
	forward_check()
	mine(0,1) --mine oben
	mine(1,0) --nach ore suchen links unten
	turtle.up()
	mine(1,0) --nach ore suchen links oben
	mine(0,0) --Search for Ores Above!
	turtle.down()
	mine(2,0) --Search for Ores Below!
	
	if torch==true then
		--print("Trying to set torch")
		setTorchUp()
	end
	
	turtle.turnRight()
	turtle.turnRight()
	turtle.forward()

	turtle.turnRight()
	
	mine(2,0) --Search for Ores Below!
	
	if not turtle.detectDown() then --BUILD BRIDGE
		--print("Building Bridge!")
		turtle.select(4)
		turtle.placeDown()
	else
		--print("Floor is safe!")
	end
	
	if turtle.getItemCount(15)>0 then --save Stuff in Chest
		saveChest()
	end
	
	if critical_error==true then
		print("Critical Error! Closing Tunnel Step")
		return
	end
end
 
local function tunnel(length) --dir / mode
	print("   >Starting Task..")
	print("")
	print("-------------------------------------")
	turtle.select(4) --reserve slot 1(chests) and slot 2(torches) and slot 3(tmp chest)
    for i=0,length do
		if i%torch_distance==0 then
			tunnel_step(true) --set torch
		else
			tunnel_step(false) --dont set torch
		end
		
		if critical_error==true then
			print("Critical Error! blame the dev.")
			return
		end
	end
end

------------------------------------------------------------------------------------------

critical_error=false 
torch_distance=10
ores=0
chests=0
torches=0
startfuel=turtle.getFuelLevel()
for b=1,10 do
	print("")
end
print("-------------------------------------")
print("           Tobis Miner               ")
print("")  
print("  Slot(1): Chests | Slot(2): Torches ")
print("-------------------------------------")
write("Enter Length of Tunnel:")
tunnel_length=read()
tunnel(tunnel_length)
printSummary()
print("")
print("> Press any key to continue")
os.pullEvent("key")
for b=1,15 do
	print("")
end