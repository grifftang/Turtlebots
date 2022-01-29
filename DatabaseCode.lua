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
	if msgTable[const.msgTask()]==taskRead() then
		read()
	end
	if msgTable[const.msgTask()]==taskWrite() then
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
	fullPath = const.getInitPath() .. msgTable[const.msgDirectory()] .. msgTable[const.msgRequest()]
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
	directory = const.getInitPath() .. msgTable[const.msgDirectory()]
	if not fs.exist(directory) then 
		fs.makeDir(directory)
	end
	filename = directory .. msgTable[const.msgRequest()]
	if msgTable[const.writeUpdate()] then
		if fs.exist(filename) then
			fs.delete(filename)
		end
		writeData(msgTable)
		return
	end
	if msgTable[const.writeAdd()]

end

--END TASK FUNCTIONS

--START TASK HELPER FUNCTIONS

--Function to add data to a text file
function writeData(msgTable)
	file = fs.open(filename, "w")
	if msgTable[const.msgLines()]==1 or msgTable[const.msgLines()] == nil then
		file.writeLine(msgTable[const.msgData()])
	end
	for i=1,msgTable[const.msgLines()] do
		file.writeLine(msgTable[const.msgData()][i])
	end
end

--END TASK HELPER FUNCTIONS