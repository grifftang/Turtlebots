-- suck my toes krab
require("tools4fools")
require("Message")

DIRECTIONS = {'north','east','south','west'}
TORCH_INTERVAL = 8
TORCH_HOME = {1,0,0}
FUEL_HOME = {0,0,0}
ORE_HOME = {2,0,0}

Trtl = {id = os.getComputerID(),
		x = 0,
		y = 0,
		z = 0,
		ogx = x,
		ogy = y,
		ogz = z,
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
	self.direction = (self.direction % 4) + 1
	if self.direction == 0 then
		self.direction = 1
	end
	turtle.turnRight()
	os.sleep(0.05)
	print(self.direction)
end

function Trtl:turnLeft()
	self.direction = (self.direction % 5) - 1
	if self.direction == 0 then
		self.direction = 4
	end
	turtle.turnLeft()
	os.sleep(0.05)
	print(self.direction)
end

function Trtl:testDirection()
	self:turnLeft()
	self:sayDirection() --W
	self:turnLeft()
	self:sayDirection() --S
	self:turnLeft()
	self:sayDirection() --S
	self:turnLeft()
	self:sayDirection() --S
	self:turnLeft()
	self:sayDirection() --S
	self:turnLeft()
	self:sayDirection() --S
	-- self:turnRight()
	-- self:sayDirection() --W
	-- self:turnRight()
	-- self:sayDirection() --N
	-- self:turnRight()
	-- self:sayDirection() --E
	-- self:turnRight()
	-- self:sayDirection() --E
	-- self:turnRight()
	-- self:sayDirection() --E
	-- self:turnRight()
	-- self:sayDirection() --E
end

function Trtl:goFoward()
	if self.direction == 1 and turtle.forward() then --North = -Z 
		self.z = self.z - 1
	elseif self.direction == 2 and turtle.forward() then -- East = +X
		self.x = self.x + 1
	elseif self.direction == 3 and turtle.forward() then -- South = +Z
		self.z = self.z + 1
	elseif self.direction == 4 and turtle.forward() then -- West = -X
		self.x = self.x - 1
	else
		turtle.dig()
		os.sleep(0.05)
		self:goFoward()
		os.sleep(0.05)
	end
end

function Trtl:back()
	if self.direction == 1 and turtle.forward() then --North = -Z 
		self.z = self.z + 1
	elseif self.direction == 2 and turtle.forward() then -- East = +X
		self.x = self.x - 1
	elseif self.direction == 3 and turtle.forward() then -- South = +Z
		self.z = self.z - 1
	elseif self.direction == 4 and turtle.forward() then -- West = -X
		self.x = self.x + 1
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
	mineHeight = height
	for up=1,mineHeight do
		turtle.dig("right")
		os.sleep(0.05)
		self:up()
		os.sleep(0.05)
		turtle.dig("right")
		os.sleep(0.05)
		self:sayCoords()
	end
	for down=1,mineHeight do
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
	print("You wanted "..targDir.." i'm at " .. DIRECTIONS[self.direction]) -- this should confirm that theyre acing the right way
end

function Trtl:moveToPoint(targx,targy,targz)
	--find the direction to go and then go
	--if no condition is met, we are there baby
	--use elseif so that you solve one at a time and multiple arent triggered
	self:checkFuel()
	print("I'm at: ".. "(X: " .. self.x .. " Y: " .. self.y .. " Z: " .. sielf.z .. ") Headed to: (Y:"..targx.." Y:"..targy.." Z:"..targz..")")
	if self.x < targx then     -- need to go East (target is +x)
		self:turnToDirection('east')
		self:goFoward()
	elseif self.x > targx then -- need to go West (target is -x)
		self:turnToDirection('west')
		self:goFoward()
	elseif self.z < targz then -- need to go South (target is +z)
		self:turnToDirection('south')
		self:goFoward()
	elseif self.z > targz then -- need to go North (Target is -Z)
		self:turnToDirection('north')
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
	self:moveToPoint(FUEL_HOME[1],FUEL_HOME[2],FUEL_HOME[3])
	turtle.suckDown()
	self.refuel()
end

function Trtl:getBackToWork(x,y,z)
	self:moveToPoint(x,y,z)
end

function Trtl:refuel()
	i = getItemSlot("minecraft:coal")
	if i == false then --if search for coal comes up false
		if self.x == 0 and self.y == 0 and self.z == 0 then--if self.x == self.ogx and self.y == self.ogy and self.z == self.ogz then
			print("i am hooome i suck coal from below")
			turtle.suckDown()
			self:refuel()
		else
			print("baus i have no coal i must go home now")
			local ogX,ogY,ogZ = self.x,self.y,self.z
			self:goToFuel()
			self:getBackToWork(ogX,ogY,ogZ)
		end
		
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
	if x < 80 then--self:distanceFromFuel() + buffer then --if we can barely make it back
		print("miso thirtsy baus ("..self.fuel..")")
		self:refuel()
	end
end

function Trtl:checkInventoryFull()

end

function Trtl:goToTorches()
	self:moveToPoint(TORCH_HOME[1],TORCH_HOME[2],TORCH_HOME[3])
	turtle.suckDown()
end

function Trtl:layTorch()
	i = getItemSlot("minecraft:torch")
	if i == false then
		print("me no havo torcho")
		local x,y,z = self.x,self.y,self.z
		self:goToTorches()
		self:getBackToWork(x,y,z)
	else
		print("me havo torcho!!!")
		turtle.select(i)
		for i=1,2 do --flip it in reverse
			self:turnRight()
		end
		turtle.place()
		for i=1,2 do --forward again
			self:turnRight()
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
	self:checkIfTorchNeeded()
	self:mineColumn(height)
	self:goFoward()
end

function Trtl:runMiningSequence(length,width,height)
	for i=1, width do
		for j=1, length do --Go in a line of length
			self:mine(height)
		end
		if self.direction == 1 then -- Turn right, 
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
	self:moveToPoint(0,0,0)
end



--plz enjoy this code, it makes a line of trees and chops them
function Trtl:runLumberjackMeOff(numtrees)
	print("fuel goes in slot 1")
	print("Please make sure there is dirt in slot 2, saplings in slot 3, and the respective log in slot 4")
	
	self:checkFuel()

	self:goUp()
	self:turnLeft()
	self:turnLeft()
	self:back()
	self:back()
	self:back()

	--tree planting
	for i = 0, numtrees do
  		self:digDown()
  		turtle.select(2)
  		turtle.placeDown()
  		self:back()
  		turtle.select(3)
  		turtle.place()
  		self:back()
  		self:back()
  		self:back()
	end
	self:turnLeft()
	self:forward()
	self:turnRight()

	--tree chopping
	while true do
  		os.sleep(30)
  		for i = 0, numtrees do
    		self:forward()
    		self:forward()
    		self:forward()
    		self:forward()
    		self:turnRight()
    		turtle.select(4)
    		-- if the tree has grown
    		if turtle.compare() then
      			turtle.dig()
      			self:forward()
      			-- harvest the tree
      			while turtle.detectUp() do
      				turtle.digUp()  
      				self:up()
      			end
      			-- return to the ground
      			while not turtle.detectDown() do
       				self:down()
      			end
      			-- plant a new sapling
      			self:back()
      			turtle.select(3)
      			turtle.place()
    		end
    		self:turnLeft()
  		end
  		-- round the corner
  		self:forward()
  		self:turnRight()
  		self:forward()
  		if turtle.getItemCount(5) == 64 then
  			self:turnLeft()
  			self:forward()
  			self:forward()
  			self:down()
  			turtle.select(5)
  			turtle.drop()
  			self:up()
  			self:back()
  			self:back()
  			self:turnRight()
  		end
  		self:forward()
  		self:turnRight()
  		self:forward()
	end
end













