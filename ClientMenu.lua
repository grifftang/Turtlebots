-- Kyle Slager
-- ClientMenu

function grabClientMenu(serverID,username)
	rednet.send(serverID,username,"menuReq")
	serverID, msg = rednet.receive("menuReq",30)
	if msg then
		for i=1,table.getn(msg) do
			print(i .. ". " .. msg)
		end
	else
		print("Request Timed Out. Reevaluate your paremeters")
	return table.getn(msg)

function requestOption(serverID,opt)
	rednet.send(serverID,opt,"optReq")
	serverID, msg = rednet.receive("optReq",30)
	if msg then
		local inst = textutil.unserialize(msg)
		inst.run()
	else
		print("Request Timed Out. Reevaluate your paremeters")
	return inst




