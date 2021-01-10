Instructions:

1. install github for turtles
> pastebin run p8PJVxC4

2. pastebin the following pull.lua
> pastebin get LfbZqei7 pull.lua



Manual 2 (not needed if you did pastebin). create a pull.lua using shell commands (wiki: https://computercraft.info/wiki/Shell_(API) )

shell.run("delete Turtlebots/")
shell.run("github clone grifftang/Turtlebots")
shell.run("cd Turtlebots/")
shell.run("main")
shell.run("cd ..")


3. create an alias for pull
> alias pull pull.lua

hit'em with a >pull