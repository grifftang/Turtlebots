--Database Code
--Author Kyle "Scalable" Slager

core = require("tools4fools")
const = require("Constants")


function onBoot()
	messageType = const.funcDatabase() .. core.getMessageType()
	core.run(messageType,taskDelegation,adminTaskDelegation)
end

--START DELEGATORS
--Code for checking which task has been requested
function taskDelegation(msgTable)
	if taskRead(msgTable) then
		read()
	end
	if taskWrite(msgTable) then
		write()
	end
end

--Code for checking which admin task has been requested
function adminTaskDelegation(msgTable)

end
--END DELEGATORS


--START TASK FUNCTIONS
--Executes the read function and sends a rednet message with the result
function read(msgTable)
	fullPath = getInitPath() .. msgTable[const.msgDirectory()] .. msgTable[const.msgRequest()]
	if not fs.exist(fullPath) then
		return nil
	file = fs.open(fullPath, "r")
	if msgTable[const.msgLines()] == 1 then
		return file.readLine()
	end
	output={}
	for i=1,msgTable[const.msgLines()]
		table.insert(output,file.readLine())
	end
	return textutils.serialize(output)
end

--Executes the write function to store new information to the "database"
function write(msgTable)

end
--END TASK FUNCTIONS


--Definition of the path preceding what is user created
function getInitPath()
	return ""
end