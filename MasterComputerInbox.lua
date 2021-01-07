--Kyle Slager
os.loadAPI("./tools4fools.lua")
MasterComp = {}

function MasterComp:receiveAndWrite()
	id, msg = rednet.receive("server")
	filename = msg.sender.id .. "_to_" .. msg.receiver .. tools4fools.getTime()
	path = "/disk/" .. msg.receiver .. "/" .. filename
	out = fs.open(path, "w")
	out.write(textutils.serialize())
	out.close()
end

--my coding talent is wasted on you fucks

function MasterComp:main()
	running = true
	rednet.open("left")
	while running do
		local event, key = os.pullEvent("key")
		if key == keys.down then
		    print("wjyy did you killl meeeee")
		    running = false
		end
		self.receiveAndWrite()
	end
end



