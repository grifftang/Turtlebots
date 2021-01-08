Instructions:

1. install github for turtles
> pastebin run p8PJVxC4

2. create a pull.lua using shell commands (wiki: https://computercraft.info/wiki/Shell_(API) )
shell.run("github clone grifftang/Turtlebots")
shell.run("cd Turtlebots/")
shell.run("main")
shell.run("cd ..")
shell.run("delete Turtlebots/")

3. create an alias for pull
> alias pull pull.lua

hit'em with a >pull