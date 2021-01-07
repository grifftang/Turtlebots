-- suck my toes krab
os.loadAPI(tools4fools)
Message = { time = getTime(),
			sender = nil,
			reciever = '',
			message = '',
			read = false,
			dimension = 'earth',
			task = nil
	}

function Message:create(o)
  o.parent = self
  return o
end

