-- Kyle Slager
-- CC Serverside Code
os.loadAPI("ServerLogic")
 
--basic start up with currently hardcoded users, will be moved to database code
print("Starting up")
count = true
sSide = "left"
print("Loading users")
users = {"kyle", "griffin"}
passwords = {"test", "test"}
 
print("Loading...")
term.clear()
term.setCursorPos(1,1)
print("Version 1.0")
 
print("Booting :)")
rednet.open(sSide)
 
--runs client validation logic
ServerLogic.validateClient(users,passwords)