--Constants
--Author: Kyle "Robust" Slager

--Definition of the path preceding what is user created
function getInitPath()
	return ""
end

--START TASK CONSTANTS

--String for read task
function taskRead()
	return "read"
end

--String for write task
function taskWrite()
	return "write"
end

--END TASK CONSTANTS

--START SUB TASK CONSTANTS

--String for update subtype of task write
function writeUpdate()
	return "update"
end

--String for add subtype of task write
function writeAdd()
	return "add"
end

--END SUB TASK CONSTANTS


--START MESSAGE CONSTANTS

--String for task key
function msgTask()
	return "task"
end

--String for directory key
function msgDirectory()
	return "dir"
end

--String for request key
function msgRequest()
	return "req"
end

--String for lines key
function msgLines()
	return "lines"
end

--String for data key
function msgData()
	return "data"
end

--END MESSAGE CONSTANTS


--START MESSAGE TYPE CONSTANTS

--String for a typings type message
function typeTypings()
	return "Typings"
end

--String for an admin type message
function typeAdmin()
	return "Admin"
end

--END MESSAGE TYPE CONSTANTS


--START FUNCTION TYPE CONSTANTS

--String for a computeer wth a database function
function funcDatabase()
	return "Database"
end

--END FUNCTION TYPE CONSTANTS