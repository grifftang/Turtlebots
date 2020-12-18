move = require "move"
local adnav = {}
sSide = "right"
channel = 0
curCoords = { 0, 0, 0 }
destCoords = { 0, 0, 0 }
dir = 1

function adnav.setSSide(newSSide)
	sSide = newSSide
end

function adnav.setChannel(newChannel)
	channel = newChannel
end

function adnav.getSSide()
	return sSide
end

function adnav.getChannel()
	return channel
end

function adnav.setCoordinates(x,y,z)
	destCoords[0] = x
	destCoords[1] = y
	destCoords[2] = z
end

function adnav.receiveCoordinates()
	rednet.open(sSide)
	local id, msg = rednet.receive(1)
	if msg then
		if (msg[0] ~= destCoords[0]) or (msg[1] ~= destCoords[1]) or (msg[2] ~= destCoords[2]) then
			destCoords[0] = msg[0]
			destCoords[1] = msg[1]
			destCoords[2] = msg[2]
		end
	end 
end

function adnav.sendCoordinates(coords,t,f)
	rednet.open(sSide)
	rednet.send(channel, "Init")
	if not msg or id ~= channel then
		print("Critical connection error")
		return
	end
	outpack = coords .. t .. f
	rednet.send(channel, outpack)
end

function adnav.navigateToDestCoordinates(f)
	distToCoord = ((destCoords[0] - curCoords[0])^2 + (destCoords[1] - destCoords[1])^2 + (destCoords[2]-curCoords[2]))^(1/2)
	if (f * 80) < distToCoord then
		adnav.sendCoordinates(coords, "RED ALERT", "LOW FUEL")
	else
	notThere = true
	moveCount = 0
	tryCount = 0
	while (notThere) do
		if (curCoords[0] < destCoords[0]) then
			tryCount = tryCount + 1
			local try = move.X(curCoords)
			if try then 
				curCoords = try
				moveCount = moveCount + 1
			end
		elseif (curCoords[0] > destCoords[0]) then
			tryCount = tryCount + 1
			local try = move.nX(curCoords)
			if try then 
				curCoords = try
				moveCount = moveCount + 1
			end
		elseif (curCoords[2] < destCoords[2]) then
			tryCount = tryCount + 1
			local try = move.Z(curCoords)
			if try then 
				curCoords = try
				moveCount = moveCount + 1
			end
		elseif (curCoords[2] > destCoords[2]) then
			tryCount = tryCount + 1
			local try = move.nZ(curCoords)
			if try then 
				curCoords = try
				moveCount = moveCount + 1
			end
		elseif (curCoords[1] < destCoords[1]) then
			tryCount = tryCount + 1
			local try = move.Y(curCoords)
			if try then 
				curCoords = try
				moveCount = moveCount + 1
			end
		elseif (curCoords[1] > destCoords[1]) then
			tryCount = tryCount + 1
			local try = move.nY(curCoords)
			if try then 
				curCoords = try
				moveCount = moveCount + 1
			end
		else
			if (tryCount > 10 and moveCount < 2) then
			adnav.sendCoordinates(coords, "RED ALERT", "STUCK")
			end
			notThere = false
		end
	end
end
end

return adnav