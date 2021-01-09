-- suck my toes krab
require("tools4fools")
require("Message")

DIRECTIONS = {'north','east','south','west'}

Trtl = {id = os.getComputerID(),
		x = 0,
		y = 0,
		z = 0,
		dimension = 'earth',
		time = getTime(),
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

function Trtl:sayDirection ()
	print(self.direction)
	print(DIRECTIONS[self.direction])
end

function Trtl:up()
	if turtle.up() then
		self.y = self.y + 1
	end
end

function Trtl:down()
	if turtle.down() then
		self.y = self.y - 1
	end
end


function Trtl:digColumn ()
	mineHeight = 4
	for up=1,mineHeight+1 do
		turtle.dig("right")
		os.sleep(0.05)
		print("dig")
		self.up()
		os.sleep(0.05)
		print("up")
	end
	for down=1,mineHeight+1 do
		self.down()
		os.sleep(0.05)
	end
end

function Trtl:refuel()

end

function Trtl:checkFuel()

end


function Trtl:mine()
	self.checkFuel()
	self.
end

function Trtl:runMiningSequence(length,width)
	for i=1, length do
		for j=1 width do
			self.mine()
		end
	end
end














