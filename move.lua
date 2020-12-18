local move = {}

function move.X(curCoords)
	if dir == 2 then 
		turtle.turnLeft()
		dir = 1
	end
	if dir == 3 then 
		turtle.turnLeft()
		turtle.turnLeft()
		dir = 1
	end
	if dir == 4 then
		turtle.turnRight()
		dir = 1
	end
	if not turtle.detect() then
		turtle.forward()
		curCoords[0] = curCoords[0] + 1
		return curCoords
	else return false
	end
end


function move.nX(curCoords)
	if dir == 4 then 
		turtle.turnLeft()
		dir = 3
	end
	if dir == 1 then 
		turtle.turnLeft()
		turtle.turnLeft()
		dir = 3
	end
	if dir == 2 then
		turtle.turnRight()
		dir = 3
	end
	if not turtle.detect() then
		turtle.forward()
		curCoords[0] = curCoords[0] - 1
		return curCoords
	else return false
	end
end


function move.Z(curCoords)
	if dir == 3 then 
		turtle.turnLeft()
		dir = 2
	end
	if dir == 4 then 
		turtle.turnLeft()
		turtle.turnLeft()
		dir = 2
	end
	if dir == 1 then
		turtle.turnRight()
		dir = 2
	end
	if not turtle.detect() then
		turtle.forward()
		curCoords[2] = curCoords[2] + 1
		return curCoords
	else return false
	end
end


function move.nZ(curCoords)
	if dir == 1 then 
		turtle.turnLeft()
		dir = 4
	end
	if dir == 2 then 
		turtle.turnLeft()
		turtle.turnLeft()
		dir = 4
	end
	if dir == 3 then
		turtle.turnRight()
		dir = 4
	end
	if not turtle.detect() then
		turtle.forward()
		curCoords[2] = curCoords[2] - 1
		return curCoords
	else return false
	end
end


function move.Y(curCoords)
	if not turtle.detectUp() then
		turtle.up()
		curCoords[1] = curCoords[1] + 1
		return curCoords
	else return false
	end
end


function move.nY(curCoords)
	if not turtle.detectDown() then 
		turtle.down()
		curCoords[1] = curCoords[1] - 1
		return curCoords
	else return false
	end
end