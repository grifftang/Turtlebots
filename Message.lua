-- suck my toes krab
os.loadAPI(tools4fools)
Message = {time = getTime(),
		sender = os.getComputerID(),
		y = 0,
		z = 0,
		fuel = 0,
		dimension = 'earth',
		task = nil
	}

function Message:create(o)
  o.parent = self
  return o
end

