--Kyle Slager
os.loadAPI("tools4fools")
MasterComp = {}

function MasterComp:receiveAndWrite()
	while true
		id, msg = rednet.receive("server")
		filename = msg.sender .. "_to_" .. msg.receiver .. tools4fools.getTime()
		path = "/disk/" .. msg.receiver .. "/" .. filename
		out = fs.open(path, "w")
		out.write(textutils.serialize())
		out.close()

function MasterComp:main()
	self.receiveAndWrite()



