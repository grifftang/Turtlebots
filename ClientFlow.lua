-- Kyle Slager
-- ClientFlow

os.loadAPI("ClientMenu") --gets client menu for later
os.pullEvent = os.pullEventRaw
rednet.open("left")

--start function is the login sequence for the client
function start()
	while true do
    	term.clear()
    	term.setCursorPos(1,1)
    	print("Version 1.0")
    	print("Enter a server number:")
    	term.write("> ")
    	--requests the id of the server computer, will be hard coded once a server is established
    	serverID = read()
    	serverID = tonumber(serverID)
    	if serverID == "" then
        	print("No entry. Breaking")
        	break;
    	end
    	term.clear()
    	term.setCursorPos(1,1)
    	print("Select an option")
    	print("1. Login")
    	print("2. Shutdown")
    	term.write("> ")
    	--get the user choice... likely login
    	input = read()
    	if input == "" then
        	print("No entry. Breaking")
        	break;
    	elseif input == "2" then
        	os.shutdown()

        -- the login sequence
    	elseif input == "1" then
        	print("Login...")
        	write("Username: ")
        	username = read()
        	if username == "" then
            	print("No entry. Breaking")
            	break;
        	end
        	write("Password: ")
        	password = read("*")
        	if password == "" then
            	print("No entry. Breaking")
            	break;
        	end
        	--send the username to the server
        	rednet.send(serverID, username,"Login")
        	--server responds with msg being the password of the corrsponding user
        	serverID, msg = rednet.receive(5)
        	--if username didnt exist
        	if msg == "104" then
            	print("Invalid Username or Password")
            	sleep(5)
            --password validation happens on the client... i know this is a security risk, hopefully we are not hacked
        	elseif password == msg then
            	term.clear()
            	term.setCursorPos(1,1)
            	print("Welcome ", username)
            	--if password matches, we run the client below
            	running(serverID,username)
            	break;
        	else
            	print("Invalid Username or Password")
            	sleep(5)
        	end
    	print("Invalid Command")
    	sleep(5)
		end
	end
end

--this will basically execute the client side of the program
function running(sID,user)
	--gets the client menu which calls the server for the specific users menu
	len = ClientMenu.grabClientMenu(sID,user)
	if len > 0 then
		print("Select an option to proceed")
		unselected = true
		while unselected do
			term.write("> ")
			opt = read()
			if (opt > len or opt < 1) then 
				print("really boss? choose an option that is listed")
			else
				unselected = false
				--calls requestOption which will query the database for the serialized option object
				ClientMenu.requestOption(sID,opt)
			end
		end
	else
		print("Error in determining menu list. Check with your local professional")
  end
end


