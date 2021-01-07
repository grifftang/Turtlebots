--Kyle Slager
os.loadAPI("tools4fools")
MasterComp = {}

function MasterComp:main()
	while true
		id, msg = rednet.receive()
		filename = msg.sender .. "_to_" .. msg.receiver .. tools4fools.getTime()
		path = "/disk/" .. msg.receiver .. filename
		out = fs.open(path, "w")
		out.write(textutils.serialize())
		out.close() 
		


