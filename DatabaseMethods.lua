-- Kyle Slager
-- DatabaseMethods

function receiveRequests()
	while true do
		id, msg = rednet.receive("dataReq")
		if msg then 
			os.queueEvent(id,msg)

function queryDatabase()
	id,msg = os.pullEvent()
	mid = string.find(msg,":")
	filename = string.sub(msg,1,3)
	var = string.sub(msg,5,mid-1)
	sendTo = string.sub(msg,mid+1)
