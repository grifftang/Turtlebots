-- suck my toes krab
require("tools4fools")
require("Message")

DIRECTIONS = {'north','east','south','west'}
TORCH_INTERVAL = 2

Trtl = {id = os.getComputerID(),
		x = 0,
		y = 0,
		z = 0,
		dimension = 'earth',
		fuel = 0,
		time = 0,
		task = nil,
		direction = 1,
		miningInfo = {},
	}
Trtl.__index = Trtl

function Trtl:create(o)
	o = o or {}
    setmetatable(o, self)
  return o
end

function Trtl:setID()
	self.id = os.getComputerID()
end


function Trtl:checkTime() --Return the turtle calculated time (custom unix time from epoc of minecraft world)
  self.time = getTime()
  return self.time
end

function Trtl:sayTime()
	print(self:checkTime())
end

function Trtl:sendMessage(recipient,text)
	--need to open rednet?
	rednet.open("left")
	msg = Message:create{sender = self, reciever = recipient, message = text}
	rednet.send(recipient,msg)
end

function Trtl:updateFuel()
  local x = turtle.getFuelLevel()
  if x == "unlimited" then
    self.fuel = 1000000000
  else
    self.fuel = x
  end
end

function Trtl:turnRight()
	self.direction = (self.direction + 1) % 5
	if self.direction == 0 then
		self.direction = 1
	end
	turtle.turnRight()
end

function Trtl:turnLeft()
	self.direction = (self.direction - 1) % 5
	if self.direction == 0 then
		self.direction = 1
	end
	turtle.turnRight()
end

function Trtl:goFoward()
	if self.direction == 1 and turtle.forward() then --North = -Z 
		self.z = self.z - 1
	elseif self.direction == 2 and turtle.forward() then -- East = +X
		self.x = self.x + 1
	elseif self.direction == 3 and turtle.forward() then -- South = +Z
		self.z = self.z - 1
	elseif self.direction == 4 and turtle.forward() then -- West = -X
		self.x = self.x - 1
	else
		turtle.dig()
		os.sleep(0.05)
		self:goFoward()
		os.sleep(0.05)
	end
end

function Trtl:sayDirection ()
	print("Facing: " .. DIRECTIONS[self.direction])
end

function Trtl:sayCoords ()
	print("x: " .. self.x .. " Y: " .. self.y .. " Z: " .. self.z)
end

function Trtl:up()
	if turtle.up() then
		self.y = self.y + 1
	else
		turtle.digUp()
		os.sleep(0.05)
		self:up()
		os.sleep(0.05)
	end

end

function Trtl:down()
	if turtle.down() then
		self.y = self.y - 1
	else
		turtle.digDown()
		os.sleep(0.05)
		self:down()
		os.sleep(0.05)
	end
end


function Trtl:mineColumn(height)
	mineHeight = height or 4
	for up=1,mineHeight do
		turtle.dig("right")
		os.sleep(0.05)
		self:up()
		os.sleep(0.05)
		self:sayCoords()
	end
	for down=1,mineHeight+1 do
		self:down()
		os.sleep(0.05)
	end
end

function Trtl:turnToDirection(targDir)
	if DIRECTIONS[self.direction] ~= targDir then
		self:turnRight()
		self:turnToDirection(targDir)
		print("poop")
	end
	--print("You wanted "..targDir.." i'm at " .. self.direction) -- this should confirm that theyre acing the right way
end

function Trtl:moveToPoint(targx,targy,targz)
	--find the direction to go and then go
	--if no condition is met, we are there baby
	--use elseif so that you solve one at a time and multiple arent triggered
	print("I'm at: ".. "(X: " .. self.x .. " Y: " .. self.y .. " Z: " .. self.z .. ") Headed to: (Y:"..targx.." Y:"..targy.." Z:"..targz..")")
	if self.x < targx then     -- need to go East (target is +x)
		self:turnToDirection('east')
		self:goFoward()
	elseif self.x > targx then -- need to go West (target is -x)
		self:turnToDirection('west')
		self:goFoward()
	elseif self.z < targz then -- need to go South (target is +z)
		self:turnToDirection('north')
		self:goFoward()
	elseif self.z > targz then -- need to go North (Target is -Z)
		self:turnToDirection('south')
		self:goFoward()
	elseif self.y < targy then -- need to go up
		self:up()
	elseif self.y > targy then -- need to go down
		self:down()
	else
		print("we here baby")
		return true
	end

	self:moveToPoint(targx,targy,targz)
	 
end


function Trtl:goToFuel()
	self:moveToPoint(0,0,0)
	turtle.suckDown()
	self.refuel()
end

function Trtl:getBackToWork(x,y,z)
	self:moveToPoint(x,y,z)
end

function Trtl:refuel()
	i = getItemSlot("minecraft:coal")
	if i == false then --if search for coal comes up false
		print("baus i have no coal i must go home now")
		local ogX,ogY,ogZ = self.x,self.y,self.z
		self:goToFuel()
		self:getBackToWork(ogX,ogY,ogZ)
	else
		print("me see fuel")
		turtle.select(i) --else i's the index baby
		turtle.refuel()
		self.fuel = turtle.getFuelLevel()
		print("me drink fuel ("..self.fuel..")")
	end
end

function Trtl:distanceFromFuel()
	return math.abs(self.x) + math.abs(self.y) + math.abs(self.z)   
end


function Trtl:checkFuel()
	x = turtle.getFuelLevel()
	self.fuel = x
	local buffer = 5
	if x < self:distanceFromFuel() + buffer then --if we can barely make it back
		print("miso thirtsy baus ("..self.fuel..")")
		self:refuel()
	end
end

function Trtl:checkInventoryFull()

end

function Trtl:layTorch()
	i = getItemSlot("minecraft:torch")
	if i == false then
		print("me no havo torcho")
	else
		print("me havo torcho!!!")
		turtle.select(i)
		for i=1,2 do --flip it in reverse
			self.turnRight()
		end
		turtle.place()
		for i=1,2 do --forward again
			self.turnRight()
		end
	end
end

function Trtl:checkIfTorchNeeded()
	--if on the floor and on the grid of interval length
	if self.x % TORCH_INTERVAL == 0 and self.z % TORCH_INTERVAL == 0 and self.y == 0 then
		print("pop a flare at " .. self.x ..", " .. self.y .. ", ".. self.z)
		self:layTorch()
	end
end

function Trtl:mine(height)
	self:checkFuel()
	self:checkInventoryFull()
	self:mineColumn(height)
	self:goFoward()
end

function Trtl:runMiningSequence(length,width,height)
	for i=1, length do
		for j=1, width do --Go in a line
			self:mine()
		end
		if self.direction == 1 then -- Turn
			self:turnRight()
			self:mineColumn(height)
			self:goFoward()
			self:turnRight()
		else
			self:turnLeft()
			self:mineColumn(height)
			self:goFoward()
			self:turnLeft()
		end
	end
end



--plz enjoy this code, it makes a line of trees and chops them
function Trtl:runLumberjackMeOff(numtrees)
	print("fuel goes in slot 1")
	print("Please make sure there is dirt in slot 2, saplings in slot 3, and the respective log in slot 4")
	
	--@XxGRIFFASCOPESxXadd your fueling code in here plz

	turtle.up()
	turtle.turnLeft()
	turtle.turnLeft()
	turtle.back()
	turtle.back()
	turtle.back()

	--tree planting
	for i = 0, numtrees do
  		turtle.digDown()
  		turtle.select(2)
  		turtle.placeDown()
  		turtle.back()
  		turtle.select(3)
  		turtle.place()
  		turtle.back()
  		turtle.back()
  		turtle.back()
	end
	turtle.turnLeft()
	turtle.forward()
	turtle.turnRight()

	--tree chopping
	while true do
  		os.sleep(30)
  		for i = 0, numtrees do
    		turtle.forward()
    		turtle.forward()
    		turtle.forward()
    		turtle.forward()
    		turtle.turnRight()
    		turtle.select(4)
    		-- if the tree has grown
    		if turtle.compare() then
      			turtle.dig()
      			turtle.forward()
      			-- harvest the tree
      			while turtle.detectUp() do
      				turtle.digUp()  
      				turtle.up()
      			end
      			-- return to the ground
      			while not turtle.detectDown() do
       				turtle.down()
      			end
      			-- plant a new sapling
      			turtle.back()
      			turtle.select(3)
      			turtle.place()
    		end
    		turtle.turnLeft()
  		end
  		-- round the corner
  		turtle.forward()
  		turtle.turnRight()
  		turtle.forward()
  		if turtle.getItemCount(5) == 64 then
  			turtle.turnLeft()
  			turtle.forward()
  			turtle.forward()
  			turtle.down()
  			turtle.select(5)
  			turtle.drop()
  			turtle.up()
  			turtle.back()
  			turtle.back()
  			turtle.turnRight()
  		end
  		turtle.forward()
  		turtle.turnRight()
  		turtle.forward()
	end
end













