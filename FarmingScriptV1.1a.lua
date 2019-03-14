-- Automatic Farming Script V1.1a
-- Usage:
--	- build a fence that looks like that, place a chest(and a turtle facing "up") at the x
--  ┌────────────┐
--  │            │
--  │            │
--  │            │
--  │            │
-- ┌┘            │
-- │x┌───────────┘
-- └─┘   
--	- change the Settings(in code, sorry didnt finish this):
--		-x : 	width of farm
--		-y : 	height of farm
--		-ret :	each ret's row the turtle will return to the chest. 
--				If you want the Turtle to farm everything in one go just set it to 999
-- - put any seed in slot 2 for comparison
-- - let the turtle do its job :).
 


local function find_seeds()
  if turtle.getItemCount(2)==1 then
      for i = 3,16 do
        turtle.select(i)
        if turtle.compareTo(2) then
          return i
        end
      end
      return 0
  else
  return 0
  end
end
 
local function HarvestReplant()
  seed_slot = find_seeds()
  if seed_slot == 0 then
    turtle.select(2)
  else
    turtle.select(seed_slot)
  end
  turtle.digDown()
  turtle.placeDown()
end
 
local function CheckFuel()
  if turtle.getFuelLevel() < 20 then
    turtle.select(1)
    turtle.refuel(1)
  end
  if turtle.getFuelLevel() < 10 then
  print("CRITICAL FUEL LEVEL!")
  end
end
 
local function GoLeft()
    HarvestReplant()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
end
 
local function GoRight()
    HarvestReplant()
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
end
 
local function forward()
    CheckFuel()
    for i=1,y-1 do
        HarvestReplant()
        turtle.forward()
    end
    HarvestReplant() --letztes Feld machen
end
 
local function forwardnoplant()
    CheckFuel()
 
    for i=1,y-1 do
        turtle.forward()
    end
 
end
 
local function droptochest()
    for i=3,16 do
        turtle.select(i)
        turtle.dropDown()
    end
end
 
local function replantrow()
forward()
turtle.turnLeft()
turtle.turnLeft()
forwardnoplant()
turtle.turnLeft()
turtle.forward()
turtle.turnLeft()
cur_row=cur_row+1
end
 
 
 
 
 
local function goonfield()
    turtle.forward()
    turtle.turnRight()
    turtle.forward()
    turtle.turnLeft()
end
 
local function gotobase()
    turtle.turnLeft()
    for i=1,cur_row do
        turtle.forward()
    end
    turtle.turnRight()
    turtle.back()
end
 
local function returntorow()
    turtle.forward()
    turtle.turnRight()
    for i=1,cur_row do
        turtle.forward()
    end
    turtle.turnLeft()
end
 
local function replantall()
    for i=1,x do
        replantrow()       
        if i%ret==0 then
            print(cur_row .. ": Returning Home")
            gotobase()
            droptochest()
            returntorow()
        end
    end
    print("-> Finished task!")
end
 
 
 
x=7
y=36
cur_row=1
dir=0
ret=9 --go back to base each ret's row
 
est_fuel=0
for l=1,x do
    if l%ret==0 then
        est_fuel=est_fuel+((l+1)*2)
        print("go back fuel:" .. est_fuel)
    end
end
 
est_fuel=est_fuel+((y*2)*x)
est_fuel=est_fuel+(x*2)
if turtle.getFuelLevel()>est_fuel then
    print(">Task: 'farming' | Fuel: " .. turtle.getFuelLevel() .. "Required: "..est_fuel)
    goonfield()
    replantall()
    gotobase()
    droptochest()
else
    print("> Not Enough Fuel!! | Fuel: " .. turtle.getFuelLevel() .. "Required: "..est_fuel)
end