-- suck my toes krab
require("tools4fools")
Message = { time = getTime(),
			sender = nil,
			reciever = '',
			message = '',
			read = false,
			dimension = 'earth',
			task = nil
	}
Message.__index = Mesage

function Message:create(o)
  o = o or {}
  setmetatable(o, self)
  return o
end

