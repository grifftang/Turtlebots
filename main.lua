require("trtl")
print("ready for orders baus")

t = Trtl:create{}
--t:setID()
--print(t.id)
-- print(t.id)
-- t:turnRight{}
-- t:sayDirection{}
--t:runMiningSequence(3)
--t:sayTime()

--t:testDirection()
t:runMiningSequence(40,30,5) --L,W,H
-- t:checkFuel()
-- t:moveToPoint(407,29,154)
