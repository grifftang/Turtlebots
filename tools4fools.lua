function getTime() --Return the turtle calculated time (custom unix time from epoc of minecraft world)
  ticksPerSecond = 20
  hoursOfTicks = os.time() * 1000
  daysOfTicks = os.day() * 24 * 1000
  totalTicks = hoursOfTicks + daysOfTicks
  return int(totalTicks/ticksPerSecond)
end