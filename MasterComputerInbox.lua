--Kyle Slager
tools4fools = require("tools4fools")

MasterComputerInbox = {}

function MasterComputerInbox:receiveAndWrite()
	id, msg = rednet.receive("server")
	filename = msg.sender.id .. "_to_" .. msg.receiver .. tools4fools.getTime()
	path = "/disk/" .. msg.receiver .. "/" .. filename
	out = fs.open(path, "w")
	out.write(textutils.serialize())
	out.close()
end

function MasterComputerInbox:main()
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



