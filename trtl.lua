-- suck my toes krab

Trtl = {id = os.getComputerid(),
		x = 0,
		y = 0,
		z = 0,
		fuel = 0,
		dimension = 'earth',
		task = nil
	}

function Trtl:create(o)
  o.parent = self
  return o
end

function Trtl:checkTime() --Return the turtle calculated time (custom unix time from epoc of minecraft world)
  ticksPerSecond = 20
  hoursOfTicks = os.time() * 1000
  daysOfTicks = os.day() * 24 * 1000
  totalTicks = hoursOfTicks + daysOfTicks
  return int(totalTicks/ticksPerSecond)
end
