--Kyle Slager
os.loadAPI("tools4fools")
MasterComp = {}

function MasterComp:receiveAndWrite()
	id, msg = rednet.receive("server")
	filename = msg.sender.id .. "_to_" .. msg.receiver .. tools4fools.getTime()
	path = "/disk/" .. msg.receiver .. "/" .. filename
	out = fs.open(path, "w")
	out.write(textutils.serialize())
	out.close()
end

function MasterComp:main()
	rednet.open("left")
	while true do
		self.receiveAndWrite()
	end
end



