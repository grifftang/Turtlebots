-- suck my toes krab
os.loadAPI(tools4fools)

Trtl = {id = os.getComputerid(),
		x = 0,
		y = 0,
		z = 0,
		fuel = 0,
		dimension = 'earth',
		time = tools.getTime()
		task = nil
	}

function Trtl:create(o)
  o.parent = self
  return o
end

function Trtl:checkTime() --Return the turtle calculated time (custom unix time from epoc of minecraft world)
  self.time = getTime()
end
