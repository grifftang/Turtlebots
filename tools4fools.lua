local DIRECTIONS = {"north", "east", "south", "west", ["north"] = 1, ["east"] = 2, ["south"] = 3, ["west"] = 4}
local _direction = 1

function getTime() --Return the turtle calculated time (custom unix time from epoc of minecraft world)
  ticksPerSecond = 20
  hoursOfTicks = os.time() * 1000
  daysOfTicks = os.day() * 24 * 1000
  totalTicks = hoursOfTicks + daysOfTicks
  return totalTicks/ticksPerSecond
end
 
function setDirection(direction)
  assert(type(direction) == string, "Expected string got "..type(direction))
  _direction = DIRECTIONS[direction]
end
 
function getDirection()
  return DIRECTIONS[_direction]
end
 
function place(slot)
  turtle.select(slot)
  return turtle.place()
end
 
function placeUp(slot)
  turtle.select(slot)
  return turtle.placeUp()
end
 
function placeDown(slot)
  turtle.select(slot)
  return turtle.placeDown()
end
 
function getItemSlot(item)
  for i = 1, 16 do
    data = turtle.getItemDetail(i)
    print(data.name)
    if data and data.name == item then
      return i
    end
  end
  return false
end
 
function getFuelLevel()
  local x = turtle.getFuelLevel()
  if x == "unlimited" then
    return 1000000000
  else
    return x
  end
end
 
function refuel(toFuel, withForce)
  local inStock = turtle.getItemCount()
  if inStock > toFuel then
    turtle.refuel(Amount)
    return true
  elseif withForce then
    return turtle.refuel(inStock)
  else
    return false
  end
end
 
function tunnel(l)
  l = l or 1
  for i = 1, l do
    digWithForce()
    forward()
  end
end
 
function forward(l)
  l = l or 1
  for i = 1, l do
    while not turtle.forward() do
      if turtle.detect() then
        turtle.dig()
      else
        turtle.attack()
      end
      os.sleep(0.05)
    end
  end
  return true
end
 
function up(l)
  l = l or 1
  for i = 1, l do
    while not turtle.up() do
      if turtle.detectUp() then
        turtle.digUp()
      else
        turtle.attackUp()
      end
      os.sleep(0.05)
    end
  end
  return true
end
 
function down(l)
  l = l or 1
  for i = 1, l do
    while not turtle.down() do
      if turtle.detectDown() then
        turtle.digDown()
      else
        turtle.attackDown()
      end
      os.sleep(0.05)
    end
  end
  return true
end
 
function back(l)
  l = l or 1
  for i = 1, l do
    if not turtle.back() then
      turn()
      forward()
      turn()
    end
  end
  return true
end
 
--gravel resistant version of turtle.dig
function digWithForce()
  local dug = false
  while turtle.dig() do
    os.sleep(0.05)
    dug = true
  end
  return dug
end
 
--gravel resistant version of turtle.digUp
function digUpWithForce()
  local dug = false
  while turtle.digUp() do
    os.sleep(0.05)
    dug = true
  end
  return dug
end
 
function face(direction)
  local action = remainder(direction - _direction, 4)
  if action == 0 then
    return
  elseif action == 1 then
    return right()
  elseif action == -1 then
    return left()
  else
    return turn()
  end
end
 
function right()
  turtle.turnRight()
  _direction = _direction % 4 + 1
end
 
function left()
  turtle.turnLeft()
  _direction = (_direction - 2) % 4 + 1
end
 
function turn()
  left()
  left()
end
 
function rightTurn()
  right()
  forward()
  right()
end
 
function leftTurn()
  left()
  forward()
  left()
end
 
local function remainder(dividend, divisor)
  return dividend - floor(dividend/divisor+0.5)*divisor
end
