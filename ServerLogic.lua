-- Kyle Slager
-- ServerLogic

--takes the users and passwords from the server and sends back the user password
function validateClient(users,passwords)
	while true do
		--receives a login request
		id, msg = rednet.receive("Login")
		for i,v in ipairs(users) do
			--if the username is valid, send back its corresponding password
			if msg == v then
				password = passwords[i]
				rednet.send(id, password, "Login")
				clear()
				break
			else
				rednet.send(id, "104", "Login")
				clear()
			end
		end
	end
end
