os.loadAPI("Turtlebots/Message")
MasterComputerOutbox = {}

function MasterComputerOutbox:readAndSend()
	filelist = fs.list("disk/")
	if filelist[0] ~= nil then
		name = "disk/" .. filelist[0]
		file = fs.open(name, "r")
		msg = textutils.deserialize(file.readAll())
		rednet.send(msg.sender.id, msg, "server")

end

function MasterComp:main()
	running = true
	rednet.open("left")
	while running do
		local event, key = os.pullEvent("key")
		if key == keys.down then
		    print("whyy did you killl meeeee")
		    running = false
		end
		self.readAndSend()
	end
end