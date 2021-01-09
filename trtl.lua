-- suck my toes krab
require("tools4fools")
require("Message")

DIRECTIONS = {'north','east','south','west'}

Trtl = {id = os.getComputerID(),
		x = 0,
		y = 0,
		z = 0,
		fuel = 0,
		dimension = 'earth',
		time = getTime(),
		task = nil,
		direction = 1,
		miningInfo = {},
	}

function Trtl:create(o)
	o = o or {}
    setmetatable(o, self)
    self.__index = self
	self.id = os.getComputerID()
	self.x = 0
	self.y = 0
	self.z = 0
	self.fuel = 0
	self.dimension = 'earth'
	self.time = getTime()
	self.task = nil
	self.direction = 1
	self.miningInfo = {}
  return o
end

function Trtl:setID()
	self.id = os.getComputerID()
end


function Trtl:checkTime() --Return the turtle calculated time (custom unix time from epoc of minecraft world)
  self.time = getTime()
end

function Trtl:sendMessage(recipient,text)
	--need to open rednet?
	rednet.open("left")
	msg = Message:create{sender = self, reciever = recipient, message = text}
	rednet.send(recipient,msg)
end

function Trtl:checkFuel()
  local x = turtle.getFuelLevel()
  if x == "unlimited" then
    self.fuel = 1000000000
  else
    self.fuel = x
  end
end

function Trtl:refuel()

end

function Trtl:turnRight()
	self.direction = (self.direction + 1) % 5
	if self.direction == 0 then
		self.direction = 1
	end
	turtle.turnRight()
end

function Trtl:turnRight()
	self.direction = (self.direction - 1) % 5
	if self.direction == 0 then
		self.direction = 1
	end
	turtle.turnRight()
end

function Trtl:SayDirection()
	print(self.direction)
	print(DIRECTIONS[self.direction])
end

function Trtl:runMiningSequence()

end

function Trtl:mineColumn()

end











