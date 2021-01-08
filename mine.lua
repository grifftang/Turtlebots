--[[ORE COLLECTING MINER V2.6 by BrunoZockt
 
MIT License
 
Copyright (c) 2018 Bruno Heberle
 
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 
 
V1.0 released 22.07.2016 17kb
V1.1 released 16.08.2016 17kb
V2.0 released 07.10.2017 35kb
V2.1 released 15.12.2017 40kb
V2.2 released 17.12.2017 42kb
V2.3 released 11.02.2018 46kb
V2.4 released 19.06.2018 57kb
V2.5 released 15.07.2018 68kb
V2.5.1 released 19.08.2018 78kb
V2.6 released 16.09.2018 90kb
This program is a work in progress and
will automatically update itself.
If you have any problems, questions or
suggestions I'd be happy if you wrote
an e-mail to 8run0z0ckt@gmail.com.
Feel free to use this program whenever
you want. If you want to use parts of
my program for developing, do so but
don't say it's yours - a sidenote
e.g. "by BrunoZockt" would be nice :)
If you want to understand this program
I recommend to read the variables first
and then the rest of the code from the
bottom to the top! Maybe I will add
some comments for better understanding
soon! The names of my functions and
variables may sound strange because
some are german and others are not
really creative, but I hope you
understand it anyways ;) ]]--
 
local HOST_ENV = _ENV or getfenv()
local OUR_ENV = {}
 
setmetatable(OUR_ENV, {__index = HOST_ENV, OUR_ENV = OUR_ENV})
setfenv(1, OUR_ENV)
 
-----###-----configurable variables-----###-----
 
settings = {
  ["language"] = "en",
  ["tunnelspace"] = 4,
  ["quantity"] = 10,
  ["length"] = 8,
  ["ignor"] = {"minecraft:stone", "minecraft:cobblestone", "minecraft:dirt", "minecraft:lava", "minecraft:flowing_lava", "minecraft:water", "minecraft:flowing_water", "minecraft:torch"},
  ["chestSelect"] = 3,
  ["torches"] = true,
  ["mainTorches"] = true,
  ["lateralTorches"] = 1,
  ["Autofuel"] = true,
  ["floor"] = true,
  ["trash"] = false,
  ["walls"] = false
}
 
-----###-----constants-----###-----
 
local programName = shell.getRunningProgram()
local label = os.getComputerLabel() or "the turtle"
local chestSlot = 16
local fuelLevel = turtle.getFuelLevel()
local w, h = term.getSize()
local kill = false
chestList = {"minecraft:chest", "IronChest:BlockIronChest", "IronChest:BlockIronChest:1", "IronChest:BlockIronChest:2", "IronChest:BlockIronChest:3", "IronChest:BlockIronChest:4", "IronChest:BlockIronChest:5", "IronChest:BlockIronChest:6"}
enderChestList = {"EnderStorage:enderChest", "enderstorage:ender_storage", "ThermalExpansion:Strongbox", "ThermalExpansion:Tesseract"}
cardinal = {"North", "West", "South", "East"}
 
-----###-----mining variables-----###-----
 
variables = {
  ["searching"] = false,
  ["level"] = 0,
  ["direction"] = 1,
  ["cache"] = {},
  ["maxSpace"] = false,
  ["setup"] = false,
  ["index"] = 2,
  ["slots"] = {"_","_","_","_","_","_","_","_","_","_","_","_","_","_","_","_"},
  ["torchPositions"] = {},
  ["stats"] = {
    ["dug"] = 0,
    ["ores"] = 0,
    ["time"] = 0,
    ["moves"] = 0
  },
  ["TorchDemand"] = 0,
  ["orientation"] = {},
  ["CrosswayAmount"] = 0,
  ["FuelDemand"] = 0,
  ["startDay"] = 0,
  ["startTime"] = 0
}
 
-----###-----menu variables-----###-----
 
local select = 1
local menustate
local checkbox = false
local gone = {}
local timer = {}
local chest = {"enderchest", "chest", "none"}
local objects = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}
local errors = {false, false, false, false, false, false, false, false}
local Check = {["Fuellevel"] = false, ["torches"] = false, ["chest"] = false}
 
local menuVars = {
  ["notificationCenter"] = {
    time = 0
  },
  ["drawOptions"] = {
    shift = 0,
    shift2 = 0,
    saved = false,
    scroll = 0,
    scroll2 = 0,
    focus = 100,
    ypos
  },
  ["drawPopup"] = {
    scroll = 0,
    lastscroll = 0,
    ypos = 9
  },
  ["drawNews"] = {
    scroll = 0
  }
}
 
 
-----###-----helpful functions-----###-----
 
function Sprint(str, xpos, ypos)
  term.setCursorPos(xpos, ypos)
  term.write(str)
end
 
function printCentered(str, ypos)
  term.setCursorPos(w/2 - #str/2 + 1, ypos)
  term.write(str)
end
 
function printRight(str, ypos, xoffset)
  if xoffset == nil then
    xoffset = 0
  end
  term.setCursorPos(w - xoffset - (#str - 1), ypos)
  term.write(str)
end
 
function printLeft(str, ypos)
  term.setCursorPos(1, ypos)
  term.write(str)
end
 
function printB(tab, y, stop, start)
  if start == nil then
    start = 1
  end
  if stop == nil then
    stop = w
  end
  local letters = 0
  for i in pairs(tab) do
    letters = letters + #tab[i]
  end
  local space = (stop-start)+1-letters
  term.setCursorPos(start, y)
  if (space/(#tab+1))%1 == 0 then
    for i in ipairs(tab) do
      term.write(string.rep(" ", space/(#tab+1))..tab[i])
    end
  elseif (space/(#tab))%2 == 0 then
    term.write(string.rep(" ", (space/#tab)/2))
    for i in ipairs(tab) do
      term.write(tab[i]..string.rep(" ", space/#tab))
    end
  elseif space == #tab-1 then
    term.write(tab[1])
    for i = 2, #tab do
      term.write(" "..tab[i])
    end
  else
    for i in ipairs(tab) do
      term.write(string.rep(" ", round(space/(#tab-i+2), "u"))..tab[i])
      space = space - round(space/(#tab-i+2), "u")
    end
  end
end
 
function printWrapped(tab, xpos, ypos, Space, sep)
  local sep = sep or " "
  if tab[1] == "-" then
    Sprint(tab[1]..sep, xpos, ypos)
    table.remove(tab, 1)
    xpos = xpos+2
    Space = Space-2
  end
  local leftSpace = Space
  local newxpos = xpos
  for word = 1, #tab do
    if Space < #tab[word] + #sep then
      return false
    elseif leftSpace >= #tab[word]+#sep then
      Sprint(tab[word]..sep, newxpos, ypos)
      leftSpace = leftSpace - (#tab[word]+#sep)
      newxpos = newxpos + #tab[word]+#sep
    else
      ypos = ypos + 1
      leftSpace = Space
      Sprint(tab[word]..sep, xpos, ypos)
      leftSpace = leftSpace - (#tab[word]+#sep)
      newxpos = xpos + (#tab[word]+#sep)
    end
  end
  return ypos
end
 
function printLine(xpos, start, stop, point, endPoint)
  for i = start, stop do
    Sprint("|", xpos, i)
  end
  if point ~= nil then
    Sprint(point, xpos, start)
    Sprint((endPoint or point), xpos, stop)
  end
end
 
function Splitter(inputstr, sep)
  if inputstr == nil then
    return nil
  elseif sep == nil then
    sep = "%s"
  end
  local t, i = {}, 1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end
 
local Version = tonumber(Splitter(os.version())[2])
 
function ItemCount(Block, Slot)
  if Slot == 0 then
    return false
  elseif Slot == nil then
    return false
  end
  local loops = 1
  if type(Block) == "table" then
    loops = #Block
  end
  if Version >= 1.64 then
    for i = 1, loops do
      local Data = turtle.getItemDetail(Slot)
      if Data == nil then
        return 0
      elseif loops == 1 then
        if Data.name == Block then
          return Data.count
        end
      else
        if Data.name == Block[i] then
          return Data.count
        end
      end
    end
    return false
  else
    return turtle.getItemCount(Slot)
  end
end
 
function Color()
  if Version <= 1.45 then
    return false
  elseif term.isColor() then
    return true
  else
    return false
  end
end
 
function MoveObjects(deleted, mode)
  if mode == 1 then
    for k, v in ipairs(gone) do
      if v == deleted then
        return
      end
    end
    for k, v in ipairs(objects) do
      if k > deleted and k < 12 then
        objects[k] = objects[k] - 1
      end
    end
    table.insert(gone, deleted)
  elseif mode == 2 then
    for k, v in ipairs(gone) do
      if v == deleted then
        table.remove(gone, k)
        for k, v in ipairs(objects) do
          if k > deleted and k < 12 then
            objects[k] = objects[k] + 1
          end
        end
      end
    end
  end
end
 
function OreCounter()
  if variables.searching == true then
    variables.stats["ores"] = variables.stats["ores"] + 1
    if variables.stats["ores"] == 1 then
      print(lang.status(settings.language, 1))
    else
      print(lang.status(settings.language, 2, variables.stats["ores"]))
    end
  end
end
 
function SlotCalculator(code, param)
  local output = {}
  local item
  if param ~= nil and param ~= "check" then
    item = param
  elseif param == "check" then
    if code == "T" then
      item = "minecraft:torch"
    elseif code == "C" then
      if settings.chestSelect == 1 then
        item = enderChestList
      elseif settings.chestSelect == 2 then
        item = chestList
      end
    end
  end
  for n = 1, #variables.slots do
    if variables.slots[n] == code then
      if param == "empty" then
        table.insert(output, n)
      elseif param == nil then
        if turtle.getItemCount(n) > 0 then
          table.insert(output, n)
        end
      elseif ItemCount(item, n) ~= false and ItemCount(item, n) ~= 0 then
        table.insert(output, n)
      end
    end
  end
  return output
end
 
function refuel(Amount, Execute)
  local ActualAmount = turtle.getItemCount()
  if ActualAmount < Amount then
    if Execute == true then
      if turtle.refuel() == false then
        return false
      else
        while turtle.refuel() ~= false do
        end
        return ActualAmount
      end
    else
      return false
    end
  else
    turtle.refuel(Amount)
    return true
  end
end
 
function basicInputHandler(orientation, event, key)
  if event == "key" then
    if key == 28 then
      menustate = menu[menustate].options[select]
      select = 1
    elseif orientation == "vertical" then
      if key == 200 and select > 1 then
        select = select-1
      elseif key == 208 and select < #menu[menustate].options then
        select = select + 1
      end
    else
      if key == 203 and select > 1 then
        select = select - 1
      elseif key == 205 and select < #menu[menustate].options then
        select = select + 1
      end
    end
  end
end
 
function save(path, content, todolist)
    local file = fs.open(path, "w")
  if todolist then
    file.writeLine("todoList = "..textutils.serialize(content))
  elseif type(content) == "table" then
    for k, v in pairs(content) do
      if type(content[k]) == "table" then
        file.writeLine(k.." = "..textutils.serialize(content[k]))
      else
        file.writeLine(k.." = "..tostring(content[k]))
      end
    end
  else
      file.writeLine(content)
  end
    file.close()
end
 
function translate(str, category)
  if category == "layout" then
    n = 35
  end
  for i = 1, n do
    if str == lang[category]("en", i) then
      return lang[category](settings.language, i)
    end
  end
end
 
function round(int, mode, dez)
  if dez == nil then
    dez = 1
  end
  if mode == "d" then
    mode = 0.4999
  elseif mode == "u" then
    mode = 0.5
  end
  return math.floor(int/dez+mode)*dez
end
 
local function compile(chunk) -- returns compiled chunk or nil and error message
  if type(chunk) ~= "string" then
    error("expected string, got ".. type(chunk), 2)
  end
 
  local function findChunkName(var)
    for k,v in pairs(HOST_ENV) do
      if v==var then
        return k
      end
    end
    return "Unknown chunk"
  end
 
  return load(chunk, findChunkName(chunk), "t", OUR_ENV)
end
 
function insert(code)
  table.insert(todoList, variables.index, code)
  variables.index = variables.index + 1
  save("database/OCM/resume/todoList", todoList, true)
end
 
-----###-----improved functions-----###-----
 
function dig(gravel)
  local a = false
  insert('OreCounter()')
  variables.stats["dug"] = variables.stats["dug"] + 1
  if gravel then
    while turtle.dig() do
      os.sleep(0.05)
      a = true
    end
    return a
  else
    return turtle.dig()
  end
end
 
function digUp()
  insert('OreCounter()')
  variables.stats["dug"] = variables.stats["dug"] + 1
  return turtle.digUp()
end
 
function digDown()
  insert('OreCounter()')
  variables.stats["dug"] = variables.stats["dug"] + 1
  return turtle.digDown()
end
 
function face(int)
  if int == variables.direction then
    return
  elseif (int + variables.direction)%2 == 0 then
    return turn()
  elseif math.abs(int - variables.direction) == 1 then
    if variables.direction < int then
      return left()
    else
      return right()
    end
  else
    if variables.direction < int then
      return right()
    else
      return left()
    end
  end
end
 
function right()
  turtle.turnRight()
  variables.direction = variables.direction - 1
  if variables.direction == 0 then
    variables.direction = 4
  end
end
 
function left()
  turtle.turnLeft()
  variables.direction = variables.direction + 1
  if variables.direction == 5 then
    variables.direction = 1
  end
end
 
function turn()
  left()
  left()
end
 
function Freeway()
  variables.searching = false
  insert([[while not turtle.forward() do
    if turtle.getFuelLevel() == 0 then
      Fuel()
    elseif dig() == false then
      turtle.attack()
    end
  end]])
  variables.stats["moves"] = variables.stats["moves"] + 1
end
 
function FreewayUp()
  variables.searching = false
  insert("variables.level = variables.level + 1")
  insert([[while not turtle.up() do
    if turtle.getFuelLevel() == 0 then
      Fuel()
    elseif digUp() == false then
      turtle.attackUp()
    end
  end]])
  variables.stats['moves'] = variables.stats['moves'] + 1
end
 
function FreewayDown()
  variables.searching = false
  insert("variables.level = variables.level - 1")
  insert([[while not turtle.down() do
    if turtle.getFuelLevel() == 0 then
      Fuel()
    elseif digDown() == false then
      turtle.attackDown()
    end
  end]])
  variables.stats['moves'] = variables.stats['moves'] + 1
end
 
function FreewayBack()
  variables.searching = false
  while not turtle.back() do
    if turtle.getFuelLevel() == 0 then
      Fuel()
    else
      turn()
      insert([[if dig() == false then
        for i = 1, 20 do
          turtle.attack()
          os.sleep(0.05)
        end
      end]])
      turn()
    end
  end
  variables.stats["moves"] = variables.stats["moves"] + 1
end
 
 
-----###-----drawMenus-----###-----
 
function notificationCenter()
  local advice = {
  lang.adv(settings.language, 1, ErrorSlot),
  lang.adv(settings.language, 2, 1),
  lang.adv(settings.language, 3, chestSlot),
  lang.adv(settings.language, 4, chestSlot),
  lang.adv(settings.language, 5, chestSlot),
  lang.adv(settings.language, 6, chestSlot),
  lang.adv(settings.language, 7, 1),
  lang.adv(settings.language, 8, 1)
  }
  if menuVars["notificationCenter"].time > 5 then
    for i = 1, #errors do
      if errors[i] ~= false then
        printWrapped(Splitter(advice[i], " "), 1, objects[8], w - 10)
        return
      end
    end
  end
  for i = 1, 4 do
    printLeft(lang.layout(settings.language, i), objects[i+7])
  end
  menuVars["notificationCenter"].time = menuVars["notificationCenter"].time + 0.5
end
 
function drawPopup(event, p1, p2, p3)
  local errorMessages = {
    lang.popup(settings.language, 1, ErrorSlot),
    lang.popup(settings.language, 2),
    lang.popup(settings.language, 1, chestSlot),
    lang.popup(settings.language, 3),
    lang.popup(settings.language, 1, chestSlot),
    lang.popup(settings.language, 4),
    lang.popup(settings.language, 5),
    lang.popup(settings.language, 6)
  }
  local leftBorder = round(w/9, "u")
  local rightBorder = round(w+1-w/9, "u")
  local winWidth = rightBorder-leftBorder-1
 
  menuVars["drawPopup"].lastscroll = menuVars["drawPopup"].scroll
 
  if event == "mouse_scroll" then
    menuVars["drawPopup"].scroll = menuVars["drawPopup"].scroll - p1
  elseif event == "mouse_click" and p1 == 1 then
    if p2 == leftBorder+winWidth then
      if p3 == 6 then
        menuVars["drawPopup"].scroll = menuVars["drawPopup"].scroll + 1
      elseif p3 == h-3 then
        menuVars["drawPopup"].scroll = menuVars["drawPopup"].scroll - 1
      end
    end
  elseif event == "key" then
    if p1 == 208 then
      menuVars["drawPopup"].scroll = menuVars["drawPopup"].scroll - 1
    elseif p1 == 200 then
      menuVars["drawPopup"].scroll = menuVars["drawPopup"].scroll + 1
    end
  end
  if menuVars["drawPopup"].scroll < -(menuVars["drawPopup"].ypos-menuVars["drawPopup"].lastscroll-(math.ceil((h-6)/10)+6)) then
    menuVars["drawPopup"].scroll = -(menuVars["drawPopup"].ypos-menuVars["drawPopup"].lastscroll-(math.ceil((h-6)/10)+6))
  elseif menuVars["drawPopup"].scroll > 0 then
    menuVars["drawPopup"].scroll = 0
  end
 
  printLine(leftBorder, 4, h-1, "+")
  printLine(rightBorder, 4, h-1, "+")
  menuVars["drawPopup"].ypos = math.ceil((h-6)/10)+5+menuVars["drawPopup"].scroll
  for i = 1, #errors do
    if errors[i] == true then
      menuVars["drawPopup"].ypos = printWrapped(Splitter("- "..errorMessages[i]), leftBorder+1, menuVars["drawPopup"].ypos+1, winWidth, " ")
    end
  end
  printCentered(string.rep("-", winWidth), 4)
  printCentered(string.rep("-", winWidth), h-1)
  printCentered(string.rep(" ", winWidth), 5)
  printCentered(string.rep(" ", winWidth), 6)
  printWrapped(Splitter(lang.popup(settings.language, 7, label)), leftBorder+1, math.ceil((h-6)/10)+4, winWidth, " ")
  printCentered(string.rep(" ", winWidth), h-3)
  printCentered(string.rep(" ", winWidth), 3)
  drawHeader()
  printLine(rightBorder-1, 6, h-3, "^", "v")
  if select == 1 then
    printB({">"..lang.popup(settings.language, 8).."<"," "..lang.popup(settings.language, 9).." ", " "..lang.popup(settings.language, 10).." "}, math.ceil((h-6)/10*9)+4, rightBorder-1, leftBorder+1)
  elseif select == 2 then
    printB({" "..lang.popup(settings.language, 8).." ",">"..lang.popup(settings.language, 9).."<", " "..lang.popup(settings.language, 10).." "}, math.ceil((h-6)/10*9)+4, rightBorder-1, leftBorder+1)
  else
    printB({" "..lang.popup(settings.language, 8).." "," "..lang.popup(settings.language, 9).." ", ">"..lang.popup(settings.language, 10).."<"}, math.ceil((h-6)/10*9)+4, rightBorder-1, leftBorder+1)
  end
end
 
function drawHeader()
  printCentered("ORE SEARCHING STRIP MINER by BrunoZockt", 1)
  printLeft(string.rep("-", w), 2)
end
 
function drawUpdate(event, p1, p2, p3)
  local leftBorder = round(w/6, "u")
  local rightBorder = round(w/6*5, "u")
  local winWidth = rightBorder-leftBorder-1
  local space = round(winWidth-13, "u")
  if event == "mouse_click" and p1 == 1 then
    if p2 == leftBorder+3 and p3 == math.ceil((h-6)/2)+5 then
      checkbox = not checkbox
    elseif p3 == math.ceil((h-6)/10*9)+4 then
      if p2 >= leftBorder+round(0.25*space, "u")+1 and p2 <= leftBorder+round(0.25*space, "u")+11 then
        if select == 1 then
          menustate = menu[menustate].options[select]
        else
          select = 1
        end
      elseif leftBorder+round(0.75*space, "u")+12 <= p2 and p2 <= leftBorder+round(0.75*space, "u")+13 then
        if select == 2 then
          menustate = menu[menustate].options[select]
        else
          select = 2
        end
      end
    end
  elseif event == "key" then
    if p1 == 203 and select > 1 then
      select = select - 1
    elseif p1 == 205 and select < #menu[menustate].options then
      select = select + 1
    elseif p1 == 28 then
      menustate = menu[menustate].options[select]
    end
  end
  printCentered(lang.layout(settings.language, 5), math.ceil((h-6)/6.9)+4)
  printCentered(string.rep("-", math.floor(w/3*2)), 4)
  printCentered(string.rep("-", math.floor(w/3*2)), 12)
  printLine(leftBorder, 4, 12, "+")
  printLine(rightBorder, 4, 12, "+")
  Sprint("_", leftBorder+3, math.ceil((h-6)/2)+4)
  Sprint("|_|"..lang.layout(settings.language, 6), leftBorder+2, math.ceil((h-6)/2)+5)
  if select == 1 then
    printB({">"..lang.layout(settings.language, 7).."<", " "..lang.layout(settings.language, 8).." "}, math.ceil((h-6)/10*9)+4, rightBorder-1, leftBorder+1)
  elseif select == 2 then
    printB({" "..lang.layout(settings.language, 7).." ", ">"..lang.layout(settings.language, 8).."<"}, math.ceil((h-6)/10*9)+4, rightBorder-1, leftBorder+1)
  end
  if checkbox == true then
    Sprint("X", leftBorder+3, math.ceil((h-6)/2)+5)
  end
end
 
function drawNews(event, p1, p2, p3)
  if event == "mouse_scroll" then
    menuVars["drawNews"].scroll = menuVars["drawNews"].scroll - p1
  elseif event == "key" then
    if p1 == 28 then
      menustate = menu[menustate].options[select]
      select = 1
      menuVars["drawNews"].scroll = 0
    elseif p1 == 208 then
      menuVars["drawNews"].scroll = menuVars["drawNews"].scroll - 1
    elseif p1 == 200 then
      menuVars["drawNews"].scroll = menuVars["drawNews"].scroll + 1
    end
  elseif event == "mouse_click" then
    if p1 == 1 then
      if p2 == w then
        if p3 == 3 then
          menuVars["drawNews"].scroll = menuVars["drawNews"].scroll + 1
        elseif p3 == h then
          menuVars["drawNews"].scroll = menuVars["drawNews"].scroll - 1
        end
      elseif p2 >= w/2-2 and p2 <= w/2+2 and p3 == h then
        menustate = menu[menustate].options[select]
        select = 1
        menuVars["drawNews"].scroll = 0
      end
    end
  end
  if menuVars["drawNews"].scroll > 0 then
    menuVars["drawNews"].scroll = 0
  elseif menuVars["drawNews"].scroll < -283 then
    menuVars["drawNews"].scroll = -283
  end
  Sprint("Patch 2.6", 1, 3+menuVars["drawNews"].scroll)
  Sprint("-----------", 1, 4+menuVars["drawNews"].scroll)
  Sprint("1.NEW FEATURES", 2, 6+menuVars["drawNews"].scroll)
  local ypos = printWrapped(Splitter("- The program will now continue automatically after a server restart."), 3, 7+menuVars["drawNews"].scroll, w-3, " ")
  ypos = printWrapped(Splitter("- To achieve this it is very important that there is always one torch available so that the turtle can orientate itself."), 4, ypos+1, w-4, " ")
  ypos = printWrapped(Splitter("- The program will also install my Startup Handler in 'startup' so that it can be automatically executed. Any file existing in 'startup' will be moved to 'old_startup' and called whenever there is no program that needs to be resumed."), 4, ypos+1, w-4, " ")
  ypos = printWrapped(Splitter("- Everything that needs to be done is written to an extern file, which also takes up some disk space (very unlikely to exceed 10kb). So make sure that there is some file space left."), 4, ypos+1, w-4, " ")
  ypos = printWrapped(Splitter("- The options 'chest' and 'enderchest' are now compatible with all the chests from the mods 'Iron chests' and 'Thermal Expansion'."), 4, ypos+1, w-4, " ")
  Sprint("2.OPTIMIZATIONS", 2, ypos+2)
  ypos = printWrapped(Splitter("- The path of the external files is now including your program name so that you could have multiple instances of the program on one turtle. The updater had to be modified aswell."), 3, ypos+3, w-3, " ")
  ypos = printWrapped(Splitter("- This page looks a lot cleaner now."), 3, ypos+3, w-3, " ")
  ypos = printWrapped(Splitter("- The variables are now ordered a lot better by splitting them into categories."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- Many minor changes in program structure to save a few bytes."), 3, ypos+1, w-3, " ")
  Sprint("3.Bug fixes", 2, ypos+2)
  ypos = printWrapped(Splitter("- The 'place Walls'-option will now place walls in water or lava like it was originally supposed to (quite stupid mistake on my part)."), 3, ypos+3, w-3, " ")
  Sprint("Patch 2.5.1", 1, ypos+2)
  Sprint("-----------", 1, ypos+3)
  Sprint("1.NEW FEATURES", 2, ypos+5)
  ypos = printWrapped(Splitter("- You can now choose to let the turtle build walls and ceiling to prevent the hallways from being flooded by water or lava."), 3, ypos+6, w-3, " ")
  ypos = printWrapped(Splitter("- If torches need to be placed, the turtle will now determine it's cardial direction at the beginning of digging."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- Torches will -now for real- be placed under all circumstances (see 'Bug fixes')."), 3, ypos+1, w-3, " ")
  Sprint("2.OPTIMIZATIONS", 2, ypos+2)
  ypos = printWrapped(Splitter("- When trash-option or chest-option is true, the turtle will now keep 1 Stack of cobblestone to place floor or walls, if selected."), 3, ypos+3, w-3, " ")
  ypos = printWrapped(Splitter("- Added the page counter in the bottom left"), 3, ypos+1, w-3, " ")
  Sprint("3.Bug fixes", 2, ypos+2)
  ypos = printWrapped(Splitter("- There was a 50% chance (turtle heading north or south) that 50% of the torches (either on the right or the left crosstunnel) were lost. That is because torches are by default placed heading west if possible. The turtle will now determine where it is heading and adjust the way it places torches accordingly so that it never loses a single torch."), 3, ypos+3, w-3, " ")
  ypos = printWrapped(Splitter("- When in default settings, 'chest' was set to 'none' there would be a slot for a chest anyways."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- I missed two instances in my code that would cause a crash when no cobblestone was available. However the probability to hit this crash was soooo low that I'm sure nobody ever encountered it."), 3, ypos+1, w-3, " ")
  Sprint("Patch 2.5", 1, ypos+2)
  Sprint("---------", 1, ypos+3)
  Sprint("1.NEW FEATURES", 2, ypos+5)
  ypos = printWrapped(Splitter("- If you are using ComputerCraft Version 1.64 or higher, the turtle won't determine whether to mine a block or not by comparing it to the Ignor-slots but by comparing it with the new Ignor-list, which you can add blocks to. This is not only easier and more flexible but also a lot faster."), 3, ypos+6, w-3, " ")
  ypos = printWrapped(Splitter("- If you want to, the turtle will now throw away items contained on the Ignor-list."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- The decision whether to empty the inventory into a chest, also takes the length of the lateral tunnel into account now, to prevent the loss of items."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- Torches will now be placed immediatly after digging the tunnel and not only after searching through the tunnel, to prevent mobspawns."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- Torches will now be placed under all circumstances, even if a block for the torch to hold on to has to be placed."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- As soon as torch-slots become free because all its torches have been placed, it changes to an empty slot now, which makes it available for ores."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- The program wont throw an error and terminate, when it doesn't have blocks it wants to place, it simply doesn't place them."), 3, ypos+1, w-3, " ")
  Sprint("2.OPTIMIZATIONS", 2, ypos+2)
  ypos = printWrapped(Splitter("- The turtle will also search right and left at the very first two blocks of the tunnel, just in case you are lazy."), 3, ypos+3, w-3, " ")
  ypos = printWrapped(Splitter("- When you decide to use no chest, the chest-slot will now be converted to an empty slot, available as inventory."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- The floor will now be placed after digging out ores, so that there will definitly be no holes in the ground."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- The inventory will now be cleared after finishing."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- Optimized the dig() function to run faster, increasing the overall speed of the program drasticly."), 3, ypos+1, w-3, " ")
  Sprint("3.Bug fixes", 2, ypos+2)
  ypos = printWrapped(Splitter("- In the main hallway, there was a 25% chance that the block a torch was just placed on gets destroyed a second after, and thereby losing the torch."), 3, ypos+3, w-3, " ")
  ypos = printWrapped(Splitter("- In rare cases when selected normal chest, the turtle would try to return to its chest after the program had finished, resulting in the turtle vanishing to Australia."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- Asking for fuel and taking that fuel wasn't always sync."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- The turtle would sometimes put the coal it needs to fuel itself into the chest."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- When a tunnellength <= 4 was chosen the turtle placed way too much torches."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- Many variables weren't refreshed after changing some options, messing up the preparation page."), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- When running out of fuel the turtle would think that it encountered an obstacle, constantly digging and hitting the air in front."), 3, ypos+1, w-3, " ")
  Sprint("Patch 2.4", 1, ypos+2)
  Sprint("---------", 1, ypos+3)
  Sprint("1.NEW FEATURES", 2, ypos+5)
  ypos = printWrapped(Splitter("- Option to place a floor, if needed"), 3, ypos+6, w-3, " ")
  ypos = printWrapped(Splitter("- Option to change language. Currently available: english, german"), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- Added a scrollbar to the options page, too"), 3, ypos+1, w-3, " ")
  Sprint("2.OPTIMIZATIONS", 2, ypos+2)
  ypos = printWrapped(Splitter("- The positions of the Buttons are determined more intelligent now, therefore being evenly spaced on every possible monitor size"), 3, ypos+3, w-3, " ")
  ypos = printWrapped(Splitter("- The structure of code is more centralized now, which results in faster processing and less blocked storage"), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- The Buttons of the options page won't slide up anymore when there is enough space, was a stupid feature anyways..."), 3, ypos+1, w-3, " ")
  Sprint("3.Bug fixes", 2, ypos+2)
  ypos = printWrapped(Splitter("- When more than 12 stacks torches were needed the ignore slots were overwritten, and wouldn't reset even when the options were changed to need less torches"), 3, ypos+3, w-3, " ")
  ypos = printWrapped(Splitter("- Fixed a bug that caused the turtle to claim having found an ore, even though it had not"), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- Fixed a bug where the turtle would place torches at wrong positions when the options were changed before start"), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- Everytime after placing a torch the turtle would freeze for a few seconds (related to the bug above), this precious time is being saved now"), 3, ypos+1, w-3, " ")
  Sprint("Patch 2.3", 1, ypos+2)
  Sprint("---------", 1, ypos+3)
  Sprint("1.LAYOUT", 2, ypos+5)
  ypos = printWrapped(Splitter("- Popup on execution in case of Errors"), 3, ypos+6, w-3, " ")
  ypos = printWrapped(Splitter("- Tiny optical improvement on the scrollbar"), 3, ypos+1, w-3, " ")
  Sprint("2.NEW FEATURES", 2, ypos+2)
  ypos = printWrapped(Splitter("- Option to make the turtle place the floor when it's missing"), 3, ypos+3, w-3, " ")
  ypos = printWrapped(Splitter("- Captions in the startmenu are visible for at least 5 seconds now"), 3, ypos+1, w-3, " ")
  Sprint("3.Bug fixes", 2, ypos+2)
  ypos = printWrapped(Splitter("- Autofuel would always refuel 5 coal, no matter how much was needed"), 3, ypos+3, w-3, " ")
  ypos = printWrapped(Splitter("- Options sometimes couldn't be selected or the layout got ugly"), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- In the startmenu the displayed amount of necessary torches was wrong"), 3, ypos+1, w-3, " ")
  Sprint("Patch 2.2", 1, ypos+2)
  Sprint("---------", 1, ypos+3)
  Sprint("1.NEW LAYOUT", 2, ypos+5)
  ypos = printWrapped(Splitter("- The awesome update window!"), 3, ypos+6, w-3, " ")
  ypos = printWrapped(Splitter("-> Anti-Annoying-Checkbox ;)"), 4, ypos+1, w-4, " ")
  ypos = printWrapped(Splitter("- This awesome news window!"), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("-> Very functional scrollbar (mouse_wheel, arrow-keys or arrow-buttons can be used)"), 4, ypos+1, w-4, " ")
  Sprint("2.NEW FEATURES", 2, ypos+2)
  ypos = printWrapped(Splitter("- Favorite options are now savable"), 3, ypos+3, w-3, " ")
  ypos = printWrapped(Splitter("- There is a new function that, when activated, places torches automatically: Perfectly spaced so no mobs can spawn!!!"), 3, ypos+1, w-3, " ")
  ypos = printWrapped(Splitter("- Torches on the main floor are placed instantly now, to prevent mobs from spawning"), 3, ypos+1, w-3, " ")
  Sprint("3.Bug fixes", 2, ypos+2)
  ypos = printWrapped(Splitter("- Putting wrong items into a torchslot resulted in a wrong Errormessage"), 3, ypos+3, w-3, " ")
  ypos = printWrapped(Splitter("- When normal chest was selected, the program crashed trying to deploy the chest"), 3, ypos+1, w-3, " ")
  printLeft(string.rep(" ", w-2), h)
  printLeft("Page "..tostring(math.ceil((-menuVars["drawNews"].scroll+1)/10)).."/"..tostring(math.ceil((ypos-menuVars["drawNews"].scroll)/10)-1), h)
  printCentered(">Ok<", h)
  printLine(w, 3, h, "^", "v")
  drawHeader()
end
 
function drawHome(event, p1, p2, p3)
  for i = 1, 3 do
    printCentered(lang.layout(settings.language, i+8), round((h-5)*(i/4), "u")+i+2)
  end
  printCentered(string.rep("-", #lang.layout(settings.language, select+8)), round((h-5)*(select/4), "u")+select+3)
end
 
function drawStart(event, p1, p2, p3)
  --Fuellevel
  if turtle.getFuelLevel() ~= "unlimited" then
    MoveObjects(3, 2)
    printLeft(lang.layout(settings.language, 12), objects[3])
    if settings.Autofuel then
      fuelLevel = turtle.getFuelLevel()
      if fuelLevel < 3*variables.FuelDemand/settings.quantity then
        Fuellevel = "low"
        errors[8] = true
        printCentered(lang.layout(settings.language, 13), objects[3])
      elseif fuelLevel >= variables.FuelDemand then
        Fuellevel = "perfect"
        errors[8] = false
      elseif fuelLevel > variables.FuelDemand*0.5 then
        Fuellevel = "ready"
        errors[8] = false
      else
        Fuellevel = "risky"
        errors[8] = false
      end
    else
      if fuelLevel >= variables.FuelDemand*1.5 then
        Fuellevel = "perfect"
      elseif fuelLevel >= variables.FuelDemand*1 then
        Fuellevel = "ready"
      else
        Fuellevel = "low"
        printCentered(lang.layout(settings.language, 13), objects[3])
      end
    end
    if help[1] == false then
      help[1] = fuelLevel
    end
    if Color() then
      if Fuellevel == "perfect" then
        term.setBackgroundColor(colors.lime)
      elseif Fuellevel == "ready" or Fuellevel == "risky" then
        term.setBackgroundColor(colors.yellow)
      elseif Fuellevel == "low" then
        term.setBackgroundColor(colors.red)
      end
      printRight(fuelLevel.."/"..variables.FuelDemand, objects[3])
      term.setBackgroundColor(colors.black)
    else
      if Fuellevel == "perfect" then
        printRight("+ "..fuelLevel.."/"..variables.FuelDemand, objects[3])
      elseif Fuellevel == "ready" or Fuellevel == "risky" then
        printRight("+/- "..fuelLevel.."/"..variables.FuelDemand, objects[3])
      elseif Fuellevel == "low" then
        printRight("- "..fuelLevel.."/"..variables.FuelDemand, objects[3])
      end
    end
  else
    MoveObjects(3, 1)
  end
 
  --Torches
  local TorchAmount = 0
  ErrorSlot = 0
  for i = 1, #variables.slots do
    if variables.slots[i] == "T" then
      if ItemCount("minecraft:torch", i) ~= false then
        TorchAmount = TorchAmount + ItemCount("minecraft:torch", i)
      else
        ErrorSlot = i
      end
    end
  end
  if ErrorSlot ~= 0 then
    errors[1] = true
  else
    errors[1] = false
  end
  if variables.TorchDemand ~= 0 then
    MoveObjects(4, 2)
    printLeft(lang.layout(settings.language, 14), objects[4])
    if TorchAmount < variables.TorchDemand then
      Check.torch = false
      if Color() then
        term.setBackgroundColor(colors.red)
      end
    else
      Check.torch = true
      if Color() then
        term.setBackgroundColor(colors.lime)
      end
    end
    printRight(TorchAmount.."/"..variables.TorchDemand, objects[4])
    if Check.torch == false then
      errors[7] = true
    else
      errors[7] = false
    end
    term.setBackgroundColor(colors.black)
  else
    MoveObjects(4, 1)
    errors[7] = false
  end
 
  --Chest
  errors[2] = false
  errors[3] = false
  errors[4] = false
  errors[5] = false
  errors[6] = false
  Check.chest = false
  if settings.chestSelect == 1 then
    MoveObjects(5, 2)
    printLeft(lang.layout(settings.language, 15), objects[5])
    if Version < 1.64 then
      if turtle.getItemCount(chestSlot) == 0 then
        errors[4] = true
      else
        Check.chest = true
      end
    else
      if ItemCount("minecraft:ender_chest", chestSlot) ~= false and ItemCount("minecraft:ender_chest", chestSlot) > 0 then
        errors[2] = true
      elseif ItemCount(enderChestList, chestSlot) == false then
        errors[3] = true
      elseif ItemCount(enderChestList, chestSlot) == 0 then
        errors[4] = true
      else
        Check.chest = true
      end
    end
  elseif settings.chestSelect == 2 then
    MoveObjects(5, 2)
    printLeft(lang.layout(settings.language, 18), objects[5])
    if ItemCount(chestList, chestSlot) == false then
      errors[5] = true
    elseif ItemCount(chestList, chestSlot) == 0 then
      errors[6] = true
    else
      Check.chest = true
    end
  else
    Check.chest = true
    MoveObjects(5, 1)
  end
  if Check.chest == false then
    if Color() then
      term.setBackgroundColor(colors.red)
    end
    printRight(lang.layout(settings.language, 16), objects[5])
  else
    if Color() then
      term.setBackgroundColor(colors.lime)
    end
    printRight(lang.layout(settings.language, 17), objects[5])
  end
  term.setBackgroundColor(colors.black)
 
  --Autofuel
  if settings.Autofuel == true then
    MoveObjects(6, 2)
    printLeft(lang.layout(settings.language, 19), objects[6])
    term.setBackgroundColor(colors.lime)
    printRight(lang.layout(settings.language, 17), objects[6])
    term.setBackgroundColor(colors.black)
    if help[4] == false then
      help[4] = turtle.getItemCount(AutofuelSlot)
    end
  else
    MoveObjects(6, 1)
  end
 
  printLeft(string.rep("-", w), objects[7])
 
  --Inventory
  if Version < 1.64 then
    for i = 1, #variables.slots do
      if variables.slots[i] == "I" then
        variables.slots[i] = "_"
      end
    end
    for i = 1, settings.ignor do
      variables.slots[i] = "I"
    end
  end
  for k, v in ipairs(SlotCalculator("T", "empty")) do
    variables.slots[v] = "_"
  end
  local stupid = SlotCalculator("_", "empty")
  for k, v in ipairs(stupid) do
    if k > #stupid-math.ceil(variables.TorchDemand/64) then
      variables.slots[v] = "T"
    end
  end
  notificationCenter()
  printRight("|"..variables.slots[1].."|"..variables.slots[2].."|"..variables.slots[3].."|"..variables.slots[4].."|", objects[8])
  printRight("|"..variables.slots[5].."|"..variables.slots[6].."|"..variables.slots[7].."|"..variables.slots[8].."|", objects[9])
  printRight("|"..variables.slots[9].."|"..variables.slots[10].."|"..variables.slots[11].."|"..variables.slots[12].."|", objects[10])
  printRight("|"..variables.slots[13].."|"..variables.slots[14].."|"..variables.slots[15].."|"..variables.slots[16].."|", objects[11])
 
  if objects[11] < 12 then
    printLeft(string.rep("-", w), 12)
  end
 
  --Buttons
  if select == 1 then
    printB({">"..lang.layout(settings.language, 20).."<", " "..lang.layout(settings.language, 10).." ", " "..lang.layout(settings.language, 21).." "}, objects[13])
  elseif select == 2 then
    printB({" "..lang.layout(settings.language, 20).." ", ">"..lang.layout(settings.language, 10).."<", " "..lang.layout(settings.language, 21).." "}, objects[13])
  elseif select == 3 then
    printB({" "..lang.layout(settings.language, 20).." ", " "..lang.layout(settings.language, 10).." ", ">"..lang.layout(settings.language, 21).."<"}, objects[13])
  end
 
  --Action
  if fuelLevel < 3*variables.FuelDemand/settings.quantity then
    local FuelAmount = math.ceil((3*variables.FuelDemand/settings.quantity-fuelLevel)/80)
    for i = 1, #SlotCalculator("_", "minecraft:coal") do
      turtle.select(SlotCalculator("_", "minecraft:coal")[i])
      local output = refuel(FuelAmount, true)
      if output == true then
        errors[8] = false
        Fuellevel = "risky"
      else
        FuelAmount = FuelAmount - output
      end
    end
  end
end
 
function drawOptions(event, p1, p2, p3)
  if menuVars["drawOptions"].focus == 100 then
    calculateFuelDemand()
    TorchCalculator()
    if menuVars["drawOptions"].saved == true and select == 3 then
      select = 2
    end
  end
  if event == "mouse_scroll" then
    if menuVars["drawOptions"].focus == 100 then
      menuVars["drawOptions"].scroll = menuVars["drawOptions"].scroll - p1
    elseif menuVars["drawOptions"].focus == 13+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift and ((p1 < 0 and menuVars["drawOptions"].scroll2 < 0) or (p1 >= 0 and h < menuVars["drawOptions"].ypos)) then
      menuVars["drawOptions"].scroll2 = menuVars["drawOptions"].scroll2 - p1
    end
  elseif event == "mouse_click" and p1 == 1 and menuVars["drawOptions"].focus == 100 then
    if p2 == w then
      if p3 == 3 then
        menuVars["drawOptions"].scroll = menuVars["drawOptions"].scroll + 1
      elseif p3 == h then
        menuVars["drawOptions"].scroll = menuVars["drawOptions"].scroll - 1
      end
    else
      menuVars["drawOptions"].focus = p3
      if menuVars["drawOptions"].focus > 15+menuVars["drawOptions"].shift+menuVars["drawOptions"].shift2 or menuVars["drawOptions"].focus > h-3 or menuVars["drawOptions"].focus < 3 then
        menuVars["drawOptions"].focus = 100
      end
    end
  elseif event == "key" then
    if p1 == 28 and menuVars["drawOptions"].focus ~= 0 then
      menuVars["drawOptions"].saved = false
      menuVars["drawOptions"].focus = 100
    elseif p1 == 208 and menuVars["drawOptions"].focus == 100 then
      menuVars["drawOptions"].scroll = menuVars["drawOptions"].scroll - 1
    elseif p1 == 200 and menuVars["drawOptions"].focus == 100 then
      menuVars["drawOptions"].scroll = menuVars["drawOptions"].scroll + 1
    else
      if settings.torches == false then
        if menuVars["drawOptions"].focus == 8+menuVars["drawOptions"].scroll then
          if p1 == 203 and settings.mainTorches == false then
            settings.mainTorches = true
          elseif p1 == 205 and settings.mainTorches == true then
            settings.mainTorches = false
          end
        end
      end
      menuVars["drawOptions"].shift2 = 0
      if Version >= 1.64 then
        if menuVars["drawOptions"].focus == 14+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift then
          if p1 == 203 and settings.trash == false then
            settings.trash = true
          elseif p1 == 205 and settings.trash == true then
            settings.trash = false
          end
        end
      else
        menuVars["drawOptions"].shift2 = menuVars["drawOptions"].shift2-1
      end
      if menuVars["drawOptions"].focus == 3+menuVars["drawOptions"].scroll then
        if p1 == 203 and settings.language == "de" then
          settings.language = "en"
        elseif p1 == 205 and settings.language == "en" then
          settings.language = "de"
        end
      elseif menuVars["drawOptions"].focus == 4+menuVars["drawOptions"].scroll then
        if p1 == 203 and settings.tunnelspace == 4 then
          settings.tunnelspace = 3
        elseif p1 == 205 and settings.tunnelspace == 3 then
          settings.tunnelspace = 4
        end
      elseif menuVars["drawOptions"].focus == 7+menuVars["drawOptions"].scroll then
        if p1 == 203 and settings.chestSelect > 1 then
          settings.chestSelect = settings.chestSelect - 1
        elseif p1 == 205 and settings.chestSelect < #chest then
          settings.chestSelect = settings.chestSelect + 1
        end
        for k, v in ipairs(chest) do
          if k == settings.chestSelect then
            v = true
          else
            v = false
          end
        end
      elseif menuVars["drawOptions"].focus == 8+menuVars["drawOptions"].scroll then
        if p1 == 203 and settings.torches == false then
          settings.torches = true
        elseif p1 == 205 and settings.torches == true then
          settings.torches = false
        end
      elseif menuVars["drawOptions"].focus == 11+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift then
        if p1 == 203 and settings.Autofuel == false then
          settings.Autofuel = true
        elseif p1 == 205 and settings.Autofuel == true then
          settings.Autofuel = false
        end
      elseif menuVars["drawOptions"].focus == 12+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift then
        if p1 == 203 and settings.floor == false then
          settings.floor = true
        elseif p1 == 205 and settings.floor == true then
          settings.floor = false
        end
      elseif menuVars["drawOptions"].focus == 13+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift then
        if p1 == 200 and menuVars["drawOptions"].scroll2 < 0 then
          menuVars["drawOptions"].scroll2 = menuVars["drawOptions"].scroll2+1
        elseif p1 == 208 and h < menuVars["drawOptions"].ypos then
          menuVars["drawOptions"].scroll2 = menuVars["drawOptions"].scroll2-1
        elseif Version >= 1.64 then
          if p1 == 57 or p1 == 14 then
            for i = 1, 16 do
              local data = turtle.getItemDetail(i)
              if data then
                for k, v in ipairs(settings.ignor) do
                  if v == data.name then
                    table.remove(settings.ignor, k)
                  end
                end
                if p1 == 57 then
                  table.insert(settings.ignor, data.name)
                end
              end
            end
          end
        end
      elseif menuVars["drawOptions"].focus == 15+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift then
        if p1 == 203 and settings.walls == false then
          settings.walls = true
        elseif p1 == 205 and settings.walls == true then
          settings.walls = false
        end
      end
    end
  end
  if menuVars["drawOptions"].scroll > 0 then
    menuVars["drawOptions"].scroll = 0
  elseif menuVars["drawOptions"].scroll < -(5+menuVars["drawOptions"].shift+menuVars["drawOptions"].shift2) then
    menuVars["drawOptions"].scroll = -(5+menuVars["drawOptions"].shift+menuVars["drawOptions"].shift2)
  end
 
  if settings.torches == false then
    if menuVars["drawOptions"].focus == 9+menuVars["drawOptions"].scroll then
      printLeft(lang.layout(settings.language, 31), menuVars["drawOptions"].focus)
      if settings.mainTorches == true then
        printRight(">"..lang.layout(settings.language, 29).."<  "..lang.layout(settings.language, 30).." ", menuVars["drawOptions"].focus)
      else
        printRight(lang.layout(settings.language, 29).."  >"..lang.layout(settings.language, 30).."<", menuVars["drawOptions"].focus)
      end
    elseif menuVars["drawOptions"].focus == 10+menuVars["drawOptions"].scroll then
      printLeft(lang.layout(settings.language, 32), menuVars["drawOptions"].focus)
      term.setCursorPos(w-2, menuVars["drawOptions"].focus)
      settings.lateralTorches = tonumber(read())
      term.clear()
      drawHeader()
      return drawOptions("key", 28)
    end
    menuVars["drawOptions"].shift = 0
  else
    menuVars["drawOptions"].shift = -2
  end
  if Version >= 1.64 then
    if menuVars["drawOptions"].focus == 14+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift then
      printLeft(lang.layout(settings.language, 39), menuVars["drawOptions"].focus)
      if settings.trash == true then
        printRight(">"..lang.layout(settings.language, 29).."<  "..lang.layout(settings.language, 30).." ", menuVars["drawOptions"].focus)
      else
        printRight(lang.layout(settings.language, 29).."  >"..lang.layout(settings.language, 30).."<", menuVars["drawOptions"].focus)
      end
    end
  end
  if menuVars["drawOptions"].focus == 3+menuVars["drawOptions"].scroll then
    printLeft(lang.layout(settings.language, 34), menuVars["drawOptions"].focus)
    if settings.language == "en" then
      printRight(">en<   de ", menuVars["drawOptions"].focus)
    else
      printRight("en   >de<", menuVars["drawOptions"].focus)
    end
  elseif menuVars["drawOptions"].focus == 4+menuVars["drawOptions"].scroll then
    printLeft(lang.layout(settings.language, 22), menuVars["drawOptions"].focus)
    if settings.tunnelspace == 3 then
      printRight(">2<  3 ", menuVars["drawOptions"].focus)
    else
      printRight("2  >3<", menuVars["drawOptions"].focus)
    end
  elseif menuVars["drawOptions"].focus == 5+menuVars["drawOptions"].scroll then
    printLeft(lang.layout(settings.language, 23), menuVars["drawOptions"].focus)
    term.setCursorPos(w-2, menuVars["drawOptions"].focus)
    settings.quantity = tonumber(read())
    term.clear()
    drawHeader()
    return drawOptions("key", 28)
  elseif menuVars["drawOptions"].focus == 6+menuVars["drawOptions"].scroll then
    printLeft(lang.layout(settings.language, 24), menuVars["drawOptions"].focus)
    term.setCursorPos(w-2, menuVars["drawOptions"].focus)
    settings.length = tonumber(read())
    term.clear()
    drawHeader()
    return drawOptions("key", 28)
  elseif menuVars["drawOptions"].focus == 7+menuVars["drawOptions"].scroll then
    printLeft(lang.layout(settings.language, 18), menuVars["drawOptions"].focus)
    variables.slots[16] = "C"
    if settings.chestSelect == 1 then
      printRight(">"..lang.layout(settings.language, 25).."< "..lang.layout(settings.language, 26).."  "..lang.layout(settings.language, 27).." ", menuVars["drawOptions"].focus)
    elseif settings.chestSelect == 2 then
      printRight(lang.layout(settings.language, 25).." >"..lang.layout(settings.language, 26).."< "..lang.layout(settings.language, 27).." ", menuVars["drawOptions"].focus)
    else
      printRight(lang.layout(settings.language, 25).."  "..lang.layout(settings.language, 26).." >"..lang.layout(settings.language, 27).."<", menuVars["drawOptions"].focus)
      if variables.slots[16] == "C" then
        variables.slots[16] = "_"
      end
    end
  elseif menuVars["drawOptions"].focus == 8+menuVars["drawOptions"].scroll then
    printLeft(lang.layout(settings.language, 28), menuVars["drawOptions"].focus)
    if settings.torches == true then
      printRight(">"..lang.layout(settings.language, 29).."< "..lang.layout(settings.language, 30).." ", menuVars["drawOptions"].focus)
    else
      printRight(" "..lang.layout(settings.language, 29).." >"..lang.layout(settings.language, 30).."<", menuVars["drawOptions"].focus)
    end
  elseif menuVars["drawOptions"].focus == 11+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift then
    printLeft(lang.layout(settings.language, 19), menuVars["drawOptions"].focus)
    if settings.Autofuel == true then
      printRight(">"..lang.layout(settings.language, 29).."<   "..lang.layout(settings.language, 30).." ", menuVars["drawOptions"].focus)
    else
      printRight(lang.layout(settings.language, 29).."   >"..lang.layout(settings.language, 30).."<", menuVars["drawOptions"].focus)
    end
  elseif menuVars["drawOptions"].focus == 12+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift then
    printLeft(lang.layout(settings.language, 33), menuVars["drawOptions"].focus)
    if settings.floor == true then
      printRight(">"..lang.layout(settings.language, 29).."<   "..lang.layout(settings.language, 30).." ", menuVars["drawOptions"].focus)
    else
      printRight(lang.layout(settings.language, 29).."   >"..lang.layout(settings.language, 30).."<", menuVars["drawOptions"].focus)
    end
  elseif menuVars["drawOptions"].focus == 13+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift then
    if Version >= 1.64 then
      printLeft(lang.layout(settings.language, 36), 3)
      local ypos = printWrapped(textutils.unserialize(string.gsub(textutils.serialize(settings.ignor), "minecraft:(%a+)", function(q) return q.."," end)), 1, 4, w)
      menuVars["drawOptions"].ypos = printWrapped(Splitter(lang.layout(settings.language, 37, label)), 1, ypos+2+menuVars["drawOptions"].scroll2, w-1)
      for i = 1, ypos+1 do
        printLeft(string.rep(" ", w), i)
      end
      drawHeader()
      printLeft(lang.layout(settings.language, 36), 3)
      printWrapped(textutils.unserialize(string.gsub(textutils.serialize(settings.ignor), "minecraft:(%a+_*%a*)", function(q) return q.."," end)), 1, 4, w)
      printLine(w, ypos+2, h, "^", "v")
    else
      printLeft(lang.layout(settings.language, 38), menuVars["drawOptions"].focus)
      term.setCursorPos(w-2, menuVars["drawOptions"].focus)
      settings.ignor = tonumber(read())
      term.clear()
      drawHeader()
      return drawOptions("key", 28)
    end
  elseif menuVars["drawOptions"].focus == 15+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift then
    printLeft(lang.layout(settings.language, 40), menuVars["drawOptions"].focus)
    if settings.walls == true then
      printRight(">"..lang.layout(settings.language, 29).."<   "..lang.layout(settings.language, 30).." ", menuVars["drawOptions"].focus)
    else
      printRight(lang.layout(settings.language, 29).."   >"..lang.layout(settings.language, 30).."<", menuVars["drawOptions"].focus)
    end
  elseif menuVars["drawOptions"].focus == 100 then
    printLeft(lang.layout(settings.language, 34), 3+menuVars["drawOptions"].scroll)
    printLeft(lang.layout(settings.language, 22), 4+menuVars["drawOptions"].scroll)
    printLeft(lang.layout(settings.language, 23), 5+menuVars["drawOptions"].scroll)
    printLeft(lang.layout(settings.language, 24), 6+menuVars["drawOptions"].scroll)
    printLeft(lang.layout(settings.language, 18), 7+menuVars["drawOptions"].scroll)
    printLeft(lang.layout(settings.language, 28), 8+menuVars["drawOptions"].scroll)
    if settings.torches == false then
      printLeft(lang.layout(settings.language, 31), 9+menuVars["drawOptions"].scroll)
      printLeft(lang.layout(settings.language, 32), 10+menuVars["drawOptions"].scroll)
    end
    printLeft(lang.layout(settings.language, 19), 11+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift)
    printLeft(lang.layout(settings.language, 33), 12+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift)
    printLeft("#"..lang.layout(settings.language, 36), 13+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift)
    printLeft(lang.layout(settings.language, 39), 14+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift)
    printLeft(lang.layout(settings.language, 40), 15+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift)
    printRight(settings.language, 3+menuVars["drawOptions"].scroll, 1)
    printRight(tostring(settings.tunnelspace-1), 4+menuVars["drawOptions"].scroll, 1)
    printRight(tostring(settings.quantity), 5+menuVars["drawOptions"].scroll, 1)
    printRight(tostring(settings.length), 6+menuVars["drawOptions"].scroll, 1)
    printRight(translate(chest[tonumber(settings.chestSelect)], "layout"), 7+menuVars["drawOptions"].scroll, 1)
    printRight(translate(tostring(settings.torches), "layout"), 8+menuVars["drawOptions"].scroll, 1)
    if settings.torches == false then
      printRight(translate(tostring(settings.mainTorches), "layout"), 9+menuVars["drawOptions"].scroll, 1)
      printRight(tostring(settings.lateralTorches), 10+menuVars["drawOptions"].scroll, 1)
    end
    printRight(translate(tostring(settings.Autofuel), "layout"), 11+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift, 1)
    printRight(translate(tostring(settings.floor), "layout"), 12+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift, 1)
    if Version >= 1.64 then
      printRight(tostring(#settings.ignor-4), 13+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift, 1)
    else
      printRight(tostring(settings.ignor), 13+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift, 1)
    end
    printRight(translate(tostring(settings.trash), "layout"), 14+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift, 1)
    printRight(translate(tostring(settings.walls), "layout"), 15+menuVars["drawOptions"].scroll+menuVars["drawOptions"].shift, 1)
    printLeft(string.rep(" ", w-1), h)
    printLeft(string.rep(" ", w-1), h-1)
    printLeft(string.rep(" ", w-1), h-2)
    printB({lang.layout(settings.language, 9), lang.layout(settings.language, 21), lang.layout(settings.language, 35)}, 12)
    if select == 1 then
      printB({string.rep("_", #lang.layout(settings.language, 9)), string.rep(" ", #lang.layout(settings.language, 21)), string.rep(" ", #lang.layout(settings.language, 35))}, 13)
    elseif select == 2 then
      printB({string.rep(" ", #lang.layout(settings.language, 9)), string.rep("_", #lang.layout(settings.language, 21)), string.rep(" ", #lang.layout(settings.language, 35))}, 13)
    else
      printB({string.rep(" ", #lang.layout(settings.language, 9)), string.rep(" ", #lang.layout(settings.language, 21)), string.rep("_", #lang.layout(settings.language, 35))}, 13)
    end
    printLine(w, 3, h-2, "^", "v")
    drawHeader()
  end
end
 
function drawResume(time)
  term.setCursorPos(1, 3)
  print("Program will resume in "..tostring(time).." seconds.\n")
  print("Press Enter to stop resuming...")
end
 
menu = {
  ["Update"] = {
    options = {"News", "Home"},
    orientation = "horizontal",
    draw = drawUpdate
  },
  ["News"] = {
    options = {"Home"},
    orientation = "horizontal",
    draw = drawNews
  },
  ["Home"] = {
    options = {"Start", "Options", "Quit"},
    orientation = "vertical",
    draw = drawHome
  },
  ["Start"] = {
    options = {"Go!", "Options", "Home"},
    orientation = "horizontal",
    draw = drawStart
  },
  ["Options"] = {
    options = {"Start", "Home", "Save as default"},
    orientation = "horizontal",
    draw = drawOptions
  },
  ["Popup"] = {
    options = {"Go!", "Start", "Quit"},
    orientation = "horizontal",
    draw = drawPopup
  }
}
 
-----###-----sequences-----###-----
 
function Return()
  face(1)
  if #variables.cache == 0 then
    return
  elseif variables.cache[#variables.cache] == 5 then
    insert('FreewayDown()')
  elseif variables.cache[#variables.cache] == 6 then
    insert('FreewayUp()')
  else
    insert('FreewayBack()')
    insert('variables.direction = variables.cache[#variables.cache]')
  end
  insert('face(1)')
  insert('table.remove(variables.cache, #variables.cache)')
end
 
function compare(method, slotNum)
  turtle.select(slotNum)
  if method == "down" then
    return turtle.compareDown()
  elseif method == "up" then
    return turtle.compareUp()
  elseif method == "front" then
    return turtle.compare()
  end
end
 
function CompareDown(walls)
  if Version >= 1.64 then
    local boolean, data = turtle.inspectDown()
    if boolean then
      for k, v in pairs(settings.ignor) do
        if v == data.name then
          return
        end
      end
    else
      return
    end
  elseif turtle.detectDown() then
    for k, v in pairs(SlotCalculator("I")) do
      if compare("down", k) == true then
        return
      end
    end
  else
    return
  end
  insert('variables.searching = true')
  insert('turtle.select(SlotCalculator("_", "empty")[1])')
  insert('digDown()')
  insert('FreewayDown()')
  insert('table.insert(variables.cache, 6)')
  insert('CompareAll("CompareUp()")')
end
 
function CompareUp(walls)
  if Version >= 1.64 then
    local boolean, data = turtle.inspectUp()
    if boolean then
      for k, v in pairs(settings.ignor) do
        if v == data.name then
          return (walls and placeWall("placeUp")) or nil
        end
      end
    else
      return (walls and placeWall("placeUp")) or nil
    end
  elseif turtle.detectUp() then
    for k, v in pairs(SlotCalculator("I")) do
      if compare("up", k) == true then
        return
      end
    end
  else
    return (walls and placeWall("placeUp")) or nil
  end
  insert('variables.searching = true')
  insert('turtle.select(SlotCalculator("_", "empty")[1])')
  insert('digUp()')
  insert('FreewayUp()')
  insert('table.insert(variables.cache, 5)')
  if walls == true then
    insert('placeWall()')
  end
  insert('CompareAll("CompareDown()")')
end
 
function CompareRight(walls)
  Compare(4, walls)
end
 
function CompareBack(walls)
  Compare(3, walls)
end
 
function CompareLeft(walls)
  Compare(2, walls)
end
 
function Compare(facing, walls)
  if facing == nil then
    facing = 1
  elseif type(facing) == "boolean" then
    walls = facing
    facing = 1
  end
  face(facing)
  if Version >= 1.64 then
    local boolean, data = turtle.inspect()
    if boolean then
      for k, v in pairs(settings.ignor) do
        if v == data.name then
          return (walls and placeWall("placeUp")) or nil
        end
      end
    else
      return (walls and placeWall()) or nil
    end
  elseif turtle.detect() then
    for k, v in pairs(SlotCalculator("I")) do
      if compare("front", k) == true then
        return
      end
    end
  else
    return (walls and placeWall()) or nil
  end
  insert('variables.searching = true')
  insert('turtle.select(SlotCalculator("_", "empty")[1])')
  insert('dig()')
  insert('Freeway()')
  insert('table.insert(variables.cache, variables.direction)')
  if walls == true then
    insert('placeWall("placeUp")')
  end
  insert('variables.direction = 1')
  insert('CompareAll("CompareBack()")')
end
 
function CompareAll(...)
  local exceptions = {...}
  local walls
  if type(exceptions[1]) == "boolean" then
    walls = exceptions[1]
    table.remove(exceptions, 1)
  end
  insert('Compare()')
  insert('CompareLeft()')
  insert('CompareBack()')
  insert('CompareRight()')
  insert('CompareUp()')
  insert('CompareDown()')
  insert('Return()')
  local sub = 0
  for j = 2, 8-sub do
    for k, v in ipairs(exceptions) do
      if v == todoList[j] then
        table.remove(todoList, j)
        table.remove(exceptions, k)
        j = j - 1
        sub = sub + 1
      end
    end
  end
  if walls == true then
    for i = 2, 15 do
      if todoList[i] == 'Return()' then
        break
      elseif string.find(todoList[i], 'placeWall(') == nil then
        if string.find(todoList[i], 'Up') ~= nil then
          table.insert(todoList, i+1, 'placeWall("placeUp")')
        elseif string.find(todoList[i], 'Down') == nil then
          table.insert(todoList, i+1, 'placeWall()')
        end
      end
    end
  end
end
 
function trash(keptCobble)
  for k, v in ipairs(SlotCalculator("_")) do
    local data = turtle.getItemDetail(v)
    for k2, v2 in pairs(settings.ignor) do
      if v2 == data.name then
        if not keptCobble and v2 == "minecraft:cobblestone" then
          keptCobble = true
        else
          turtle.select(v)
          turtle.drop()
        end
      end
    end
  end
end
 
function Enderchest(keptCoal, keptCobble)
  if (#SlotCalculator("_") >= #SlotCalculator("_", "empty")-1-math.ceil(settings.length/12) or keptCoal == true) and #SlotCalculator("C", "check") ~= 0 then
    turtle.select(SlotCalculator("C", "check")[1])
    if variables.level == 1 then
      insert('FreewayDown()')
    end
    insert('FreewayBack()')
    insert([[while not turtle.place() do
      turtle.attack()
    end]])
    insert([[for k, v in ipairs(SlotCalculator("_")) do
      if settings.Autofuel and not keptCoal and Version >= 1.64 and turtle.getItemDetail(v).name == "minecraft:coal" then
        keptCoal = true
      elseif not keptCobble and v == "minecraft:cobblestone" then
        keptCobble = true
      else
        turtle.select(v)
        while not turtle.drop() do
          print(lang.status(settings.language, 3))
          sleep(10)
        end
      end
    end
    turtle.select(SlotCalculator("C", "empty")[1])]])
    insert('dig()')
    insert('Freeway()')
    insert([[turtle.select(SlotCalculator("_", "empty")[1])
    print(lang.status(settings.language, 4))]])
  end
end
 
function NormalChest(keptCoal, keptCobble)
  local function goToOrigin()
    insert('turn()')
    insert([[if variables.level == 1 then
      FreewayDown()
    end
    for Way_Back = 1, variables.CrosswayAmount*settings.tunnelspace do
      Freeway()
    end]])
    insert('turn()')
  end
  local function dropOff()
    insert([[for k, v in ipairs(SlotCalculator("_")) do
      if settings.Autofuel and not keptCoal and Version >= 1.64 and turtle.getItemDetail(v).name == "minecraft:coal" then
        keptCoal = true
      elseif not keptCobble and v == "minecraft:cobblestone" then
        keptCobble = true
      else
        turtle.select(v)
        while not turtle.dropDown() and turtle.getItemCount() ~= 0 do
          print(lang.status(settings.language, 3))
          sleep(10)
        end
      end
    end]])
  end
  if variables.setup == true then
    goToOrigin()
    dropOff()
    insert([[for Way_Back = 1, variables.CrosswayAmount*settings.tunnelspace do
      Freeway()
    end]])
    insert('print(lang.status(settings.language, 4))')
  elseif #SlotCalculator("C", "check") == 0 then
      variables.setup = false
  elseif #SlotCalculator("_") >= #SlotCalculator("_", "empty")-1-math.ceil(settings.length/12) then
    goToOrigin()
    insert('turtle.select(SlotCalculator("C", "check")[1])')
    insert([[while not turtle.placeDown() do
      digDown()
    end]])
    insert('variables.setup = true')
    dropOff()
    insert([[for Way_Back = 1, variables.CrosswayAmount*settings.tunnelspace do
      Freeway()
    end]])
    insert('print(lang.status(settings.language, 4))')
  end
end
 
function Fuel()
  local FuelAmount = math.ceil(3*variables.FuelDemand/settings.quantity/80)
  fuelLevel = turtle.getFuelLevel()
  if fuelLevel < 3*variables.FuelDemand/settings.quantity then
    while true do
      while #SlotCalculator("_", "minecraft:coal") > 0 do
        turtle.select(SlotCalculator("_", "minecraft:coal")[1])
        local output = refuel(FuelAmount, true)
        if output == true then
          print(lang.status(settings.language, 5))
          return
        else
          FuelAmount = FuelAmount - output
        end
      end
      term.clear()
      term.setCursorPos(1,1)
      print(lang.status(settings.language, 6))
      write(lang.status(settings.language, 7))
      for k, v in ipairs(SlotCalculator("_", "empty")) do
        if k == #SlotCalculator("_", "empty") then
          print(v)
        else
          write(v..", ")
        end
      end
      os.pullEvent()
    end
  end
end
 
function placeFloor()
  if settings.floor == true and turtle.detectDown() == false and #SlotCalculator("_", "minecraft:cobblestone") ~= 0 then
    turtle.select(SlotCalculator("_", "minecraft:cobblestone")[1])
    turtle.placeDown()
  end
end
 
function placeWall(param)
  if param == true then
    param = "place"
  else
    param = param or "place"
  end
  if #SlotCalculator("_", "minecraft:cobblestone") > 0 then
    turtle.select(SlotCalculator("_", "minecraft:cobblestone")[1])
    turtle[param]()
    return true
  end
  return false
end
 
-----###-----Processing-----###-----
function TorchCalculator()
  local Tspace
  if settings.torches == true then
    if (settings.tunnelspace == 4 and settings.length <= 8) or (settings.tunnelspace == 3 and settings.length <= 10) then
      settings.lateralTorches = 1
    else
      settings.lateralTorches = math.floor((settings.length-math.floor(16/settings.tunnelspace))/12)+1
    end
    if (settings.tunnelspace == 4 and settings.length <= 3) or (settings.tunnelspace == 3 and settings.length <= 4) then
      settings.mainTorches = true
      settings.lateralTorches = 0
    elseif (settings.tunnelspace == 4 and ((settings.length+2)%12 <= 5 or settings.length == 9)) or (settings.tunnelspace == 3 and (settings.length+1)%12 <= 5) then
      settings.mainTorches = true
    else
      settings.mainTorches = false
    end
  end
  if settings.lateralTorches >= 1 then
    if settings.mainTorches == true then
      Tspace = round((settings.length+(settings.tunnelspace-1)-settings.lateralTorches)/(settings.lateralTorches+0.5), "u")
    else
      Tspace = (settings.length+(settings.tunnelspace-1)-settings.lateralTorches)/settings.lateralTorches
    end
    if Tspace == 11 then
      variables.maxSpace = true
    else
      variables.maxSpace = false
    end
    local done = false
    while not done do
      variables.torchPositions = {}
      table.insert(variables.torchPositions, round(Tspace/2, "d")+1)
      for i = 2, settings.lateralTorches do
        table.insert(variables.torchPositions, round(Tspace+1+variables.torchPositions[i-1], "d"))
      end
      if variables.torchPositions[#variables.torchPositions] > settings.length then
        Tspace = Tspace - 0.1
      else
        done = true
      end
    end
  else
    variables.maxSpace = false
    variables.torchPositions = {}
  end
  variables.TorchDemand = 2*(settings.lateralTorches*settings.quantity)+1
  if settings.mainTorches == true then
    variables.TorchDemand = variables.TorchDemand + settings.quantity
  end
  for k, v in ipairs(SlotCalculator("T", "empty")) do
    variables.slots[v] = "_"
  end
  local stupid = SlotCalculator("_", "empty")
  for k, v in ipairs(stupid) do
    if k > #stupid-math.ceil(variables.TorchDemand/64) then
      variables.slots[v] = "T"
    end
  end
end
 
function calculateFuelDemand()
  if settings.chestSelect == 1 then
    variables.FuelDemand = ((settings.length*2+settings.tunnelspace)*3+3)*settings.quantity
  elseif settings.chestSelect == 2 then
    variables.FuelDemand = math.ceil(((settings.length*2+settings.tunnelspace)*3+2)*settings.quantity+settings.tunnelspace*(settings.quantity/2)^2)
  else
    variables.FuelDemand = ((settings.length*2+settings.tunnelspace)*3+2)*settings.quantity
  end
  if variables.maxSpace == true then
    variables.FuelDemand = variables.FuelDemand + #variables.torchPositions
  end
end
 
 
-----###-----Core functions-----###-----
function update()
  if not fs.exists("database/"..programName.."/state") then
    save("database/"..programName.."/state", "0")
  end
  file = fs.open("database/"..programName.."/state", "r")
  local fileData = {}
  local line = file.readLine()
  repeat
    table.insert(fileData, line)
    line = file.readLine()
  until line == nil
  file.close()
  updated = fileData[1]
 
  if updated == "0" then
    kill = true
    term.clear()
    print("loading...")
    shell.run("pastebin get cR9vEiTc database/"..programName.."/lang")
    term.clear()
    local function installAsStartup()
      if fs.exists("startup") then
        os.loadAPI("startup")
        if startup.name == "SupHa - Startup Handler by BrunoZockt" then
          for k, v in ipairs(startup.getList()) do
            if v == programName then
              return
            end
          end
          startup.set(programName)
        else
          os.unloadAPI("startup")
          fs.move("startup", "old_startup")
          shell.run("pastebin get 19VG8eD6 startup")
          os.loadAPI("startup")
          startup.set("old_startup", "standart")
          startup.set(programName)
        end
      else
        shell.run("pastebin get 19VG8eD6 startup")
        os.loadAPI("startup")
        startup.set(programName)
      end
    end
    installAsStartup()
    if programName ~= "OCM" then
      fs.delete("database/OCM")
    end
    if shell.run("database/"..programName.."/updaterV2") == false then
      fs.delete("database/"..programName.."/updater")
      term.clear()
      print("loading...")
      shell.run("pastebin get rUMt9siN database/"..programName.."/updaterV2")
      term.clear()
      shell.run("database/"..programName.."/updaterV2")
    end
  end
end
 
function getVariables(path)
  local extSettings = {}
  if fs.exists("database/"..programName.."/"..path) then
    file = fs.open("database/"..programName.."/"..path, "r")
    local line = Splitter(file.readLine(), " = ")
    repeat
      if line[2] == "{" or line[2] == "{}" then
        local str = line[2]
        if line[2] == "{" then
        repeat
          local tline = file.readLine()
          if tline ~= nil then
            str = str..tline
          end
        until tline == "}"
        end
        extSettings[line[1]] = textutils.unserialize(str)
      else
        extSettings[line[1]] = line[2]
      end
      line = Splitter(file.readLine(), " = ")
    until line == nil
    file.close()
    for k, v in pairs(extSettings) do
      if type(extSettings[k]) ~= "table" then
        if not tonumber(extSettings[k]) then
          if extSettings[k] == "true" or extSettings[k] == "false" then
            extSettings[k] = extSettings[k] == "true"
          end
        else
          extSettings[k] = tonumber(extSettings[k])
        end
      end
      if Splitter(path, "/")[#Splitter(path, "/")] == "settings" then
        settings[k] = extSettings[k]
      elseif Splitter(path, "/")[#Splitter(path, "/")] == "variables" then
        variables[k] = extSettings[k]
      end
    end
  end
  if fs.exists("database/"..programName.."/updateCheckbox/V2.6") then
    local file = fs.open("database/"..programName.."/updateCheckbox/V2.6", "r")
    checkbox = file.readLine() == "true"
    file.close()
  end
  if checkbox == true then
    menustate = "Home"
  else
    menustate = "Update"
  end
  if settings.chestSelect < 3 and #SlotCalculator("C", "empty") == 0 then
    variables.slots[16] = "C"
  end
  calculateFuelDemand()
  TorchCalculator()
end
 
function getList(path)
  local file = fs.open("database/"..programName.."/"..path, "r")
  todoList = textutils.unserialize(Splitter(file.readLine(), " = ")[2]..file.readAll())
  file.close()
end
 
function saveVars(path, content)
  save("database/"..programName.."/"..path, content)
end
 
function compStep(n)
  if n == nil then
    n = 1
  else
    n = tonumber(n)
  end
  for i = 1, n do
    insert('turtle.select(SlotCalculator("T", "empty")[1])')
    insert('Freeway()')
    if variables.level == 0 then
      insert('CompareAll("Compare()", "CompareBack()", "CompareUp()")')
      insert('placeFloor()')
      insert('turtle.select(SlotCalculator("T", "empty")[1])')
      insert('FreewayUp()')
      insert('CompareAll("Compare()", "CompareBack()", "CompareDown()")')
    elseif variables.level == 1 then
      insert('CompareAll("Compare()", "CompareBack()", "CompareDown()")')
      insert('turtle.select(SlotCalculator("T", "empty")[1])')
      insert('FreewayDown()')
      insert('CompareAll("Compare()", "CompareBack()", "CompareUp()")')
      insert('placeFloor()')
    end
  end
end
 
function mainstep(n, first)
  if n == nil then
    n = 1
  else
    n = tonumber(n)
  end
  turtle.select(SlotCalculator("_", "empty")[1])
  for i = 1, n do
    insert('variables.searching = false')
    insert('dig()')
    insert('Freeway()')
    insert([[if variables.level == 0 then
      insert('placeFloor()')
      insert('digUp()')
      if ]]..tostring(first)..[[ and ]]..tostring(i)..[[ == 1 or (settings.walls == true and ]]..tostring(i)..[[ == 2 and settings.tunnelspace == 4) then
        insert('CompareAll("Compare()", "CompareBack()", "CompareUp()")')
      else
        insert('CompareDown()')
      end
      insert('FreewayUp()')
      if ]]..tostring(first)..[[ and ]]..tostring(i)..[[ == 1 or (settings.walls == true and ]]..tostring(i)..[[ == 2 and settings.tunnelspace == 4) then
        insert('CompareAll("Compare()", "CompareBack()", "CompareDown()")')
      else
        insert('CompareUp()')
        insert('placeWall("placeUp")')
      end
    elseif variables.level == 1 then
      insert('digDown()')
      if ]]..tostring(first)..[[ and ]]..tostring(i)..[[ == 1 or (settings.walls == true and ]]..tostring(i)..[[ == 2 and settings.tunnelspace == 4) then
        insert('CompareAll("Compare()", "CompareBack()", "CompareDown()")')
      else
        insert('CompareUp()')
        insert('placeWall("placeUp")')
      end
      if i == 2 and settings.mainTorches then
        insert('variables.searching = false')
        insert('dig(true)')
      end
      insert('FreewayDown()')
      if ]]..tostring(first)..[[ and ]]..tostring(i)..[[ == 1 or (settings.walls == true and ]]..tostring(i)..[[ == 2 and settings.tunnelspace == 4) then
        insert('CompareAll("Compare()", "CompareBack()", "CompareUp()")')
      else
        insert('CompareDown()')
      end
      insert('placeFloor()')
    end]])
    if settings.mainTorches == true then
      if i == 2 and #SlotCalculator('T', 'check') ~= 0 then
        insert([[turtle.select(SlotCalculator('T', 'check')[1])
        if variables.level == 1 then
          FreewayDown()
        end]])
        insert([[if not turtle.placeUp() then
          insert('FreewayUp()')
          insert('left()')
          insert('turtle.select(SlotCalculator("_", "minecraft:cobblestone")[1])')
          insert('dig()')
          insert('turtle.place()')
          insert('right()')
          insert('FreewayDown()')
          insert('turtle.select(SlotCalculator("T", "check")[1])')
          insert('turtle.placeUp()')
        end]])
        insert([[for k, v in ipairs(SlotCalculator('T', 'empty')) do
          variables.slots[v] = '_'
        end
        local stupid = SlotCalculator('_', 'empty')
        for k, v in ipairs(stupid) do
          if k > #stupid-math.ceil(variables.TorchDemand/64) then
            variables.slots[v] = 'T'
          end
        end
        variables.TorchDemand = variables.TorchDemand - 1]])
      end
    end
  end
end
 
function stepAside(n)
  if n == nil then
    n = 1
  else
    n = tonumber(n)
  end
  for i = 1, n do
    insert('variables.searching = false')
    insert('dig()')
    insert('Freeway()')
    if variables.level == 1 then
      insert('digDown()')
    elseif variables.level == 0 then
      insert('placeFloor()')
      insert('digUp()')
    end
  end
end
 
function youJustGotLittUp(steps, func, left)
  if left == nil then
    left = false
  end
  for Steprepeat = 1, steps do
    if func == stepAside then
      insert('stepAside()')
    end
    for k, v in ipairs(variables.torchPositions) do
      if ((func == stepAside and settings.length-v+1 == Steprepeat) or (func == compStep and v == Steprepeat)) and #SlotCalculator("T", "check") > 0 then
        insert([[turtle.select(SlotCalculator("T", "check")[1])
        if variables.maxSpace == true then
          if settings.mainTorches == false and left == true then
            if k%2 == #variables.torchPositions%2 then
              if variables.level == 1 then
                if variables.orientation[1] == "North" or variables.orientation[1] == "South" then
                  insert('dig()')
                end
                insert('FreewayDown()')
              elseif variables.orientation[1] == "North" or variables.orientation[1] == "South" then
                insert('FreewayUp()')
                insert('dig()')
                insert('FreewayDown()')
              end
            else
              if variables.level == 0 then
                insert('FreewayUp()')
              end
            end
          else
            if k%2 == #variables.torchPositions%2 then
              if variables.level == 0 then
                insert('FreewayUp()')
              end
            else
              if variables.level == 1 then
                if variables.orientation[1] == "North" or variables.orientation[1] == "South" then
                  insert('dig()')
                end
                insert('FreewayDown()')
              elseif variables.orientation[1] == "North" or variables.orientation[1] == "South" then
                insert('FreewayDown()')
                insert('dig()')
                insert('FreewayUp()')
              end
            end
          end
        elseif variables.orientation[1] == "North" or variables.orientation[1] == "South" then
          if variables.level == 0 then
            insert('FreewayUp()')
          end
        end]])
        insert([[if variables.level == 1 then
          turtle.placeDown()
        elseif variables.level == 0 then
          if not turtle.placeUp() then
            insert('FreewayUp()')
            insert('left()')
            insert('turtle.select(SlotCalculator("_", "minecraft:cobblestone")[1])')
            insert('dig()')
            insert('turtle.place()')
            insert('right()')
            insert('FreewayDown()')
            insert('turtle.select(SlotCalculator("T", "check")[1])')
            insert('turtle.placeUp()')
          end
        end]])
        insert([[for k, v in ipairs(SlotCalculator("T", "empty")) do
          variables.slots[v] = "_"
        end
        local stupid = SlotCalculator("_", "empty")
        for k, v in ipairs(stupid) do
          if k > #stupid-math.ceil(variables.TorchDemand/64) then
            variables.slots[v] = "T"
          end
        end]])
        insert([[if func == compStep then
          variables.TorchDemand = variables.TorchDemand - 1
        end
        turtle.select(SlotCalculator("_", "empty")[1])]])
      end
    end
    if func == compStep then
      if Steprepeat == settings.length then
        insert('Freeway()')
      else
        insert('compStep()')
      end
    end
  end
end
 
function tunnel(first)
  if settings.Autofuel == true then
    insert('Fuel()')
  end
  if settings.trash == true then
    insert('trash()')
  end
  if settings.chestSelect == 1 then
    insert('Enderchest()')
  elseif settings.chestSelect == 2 then
    insert('NormalChest()')
  end
  insert("mainstep(settings.tunnelspace, "..tostring(first)..")")
  insert("turtle.turnRight()")
  insert('old_orientation = {}')
  insert([[for k,v in ipairs(variables.orientation) do
    old_orientation[k] = v
  end]])
  for i = 1, 4 do
    insert('variables.orientation['..tostring(i)..'] = old_orientation[('..tostring(i)..'+2)%4+1]')
  end
  insert("youJustGotLittUp(settings.length, stepAside)")
  insert([[if variables.level == 1 then
    insert('CompareAll("CompareBack()", "CompareDown()")')
    insert('FreewayDown()')
    insert('CompareAll("CompareBack()", "CompareUp()")')
  else
    insert('CompareAll("CompareBack()", "CompareUp()")')
    insert('FreewayUp()')
    insert('CompareAll("CompareBack()", "CompareDown()")')
  end]])
  insert('face(3)')
  insert('old_orientation = {}')
  insert([[for k,v in ipairs(variables.orientation) do
    old_orientation[k] = v
  end]])
  for i = 1, 4 do
    insert('variables.orientation['..tostring(i)..'] = old_orientation[('..tostring(i)..'+1)%4+1]')
  end
  insert('variables.direction = 1')
  insert("youJustGotLittUp(settings.length, compStep)")
  insert("youJustGotLittUp(settings.length, stepAside, true)")
  insert([[if variables.level == 1 then
    insert('CompareAll("CompareBack()", "CompareDown()")')
    insert('FreewayDown()')
    insert('CompareAll("CompareBack()", "CompareUp()")')
  else
    insert('CompareAll("CompareBack()", "CompareUp()")')
    insert('FreewayUp()')
    insert('CompareAll("CompareBack()", "CompareDown()")')
  end]])
  insert('face(3)')
  insert('old_orientation = {}')
  insert([[for k,v in ipairs(variables.orientation) do
    old_orientation[k] = v
  end]])
  for i = 1, 4 do
    insert('variables.orientation['..tostring(i)..'] = old_orientation[('..tostring(i)..'+1)%4+1]')
  end
  insert('variables.direction = 1')
  insert("youJustGotLittUp(settings.length, compStep, true)")
  insert('turtle.turnLeft()')
  insert('old_orientation = {}')
  insert([[for k,v in ipairs(variables.orientation) do
    old_orientation[k] = v
  end]])
  for i = 1, 4 do
    insert('variables.orientation['..tostring(i)..'] = old_orientation[('..tostring(i)..')%4+1]')
  end
end
 
function go()
  saveVars("resume/settings", settings)
  variables.startDay = os.day()
  variables.startTime = os.time()
  for Tunnelrepeat = 1, settings.quantity do
    insert("tunnel("..tostring(Tunnelrepeat == 1)..")")
    insert([[variables.CrosswayAmount = variables.CrosswayAmount + 1
    print(lang.status(settings.language, 8, variables.CrosswayAmount, settings.quantity))]])
  end
  insert('print(lang.status(settings.language, 9))')
  insert('turn()')
  insert([[if variables.level == 1 then
    FreewayDown()
  end]])
  for Way_Back = 1, settings.quantity*settings.tunnelspace do
    insert('Freeway()')
  end
  if settings.trash == true then
    insert('trash()')
  end
  if settings.chestSelect == 1 then
    insert("Enderchest(true)")
  elseif settings.chestSelect == 2 then
    insert("NormalChest(true, true)")
  end
  insert([[local endDay = os.day()
  local endTime = os.time()
  variables.stats["time"] = (endDay-variables.startDay)*24.000+(endTime-variables.startTime)]])
end
 
function Navigation()
  table.insert(timer, os.startTimer(0.05))
  while true do
    local tempState = menustate
    local event, p1, p2, p3 = os.pullEvent()
    while (event == "timer" and p1 ~= timer[#timer]) or event == "key_up" do
      event, p1, p2, p3 = os.pullEvent()
    end
    if menuVars["drawOptions"].focus == 100 then
      basicInputHandler(menu[menustate].orientation, event, p1)
    end
    if menustate == "Quit" then
      break
    elseif menustate == "Save as default" then
      saveVars("settings", settings)
      menuVars["drawOptions"].saved = true
      menustate = "Options"
    elseif menustate == "Go!" then
      menustate = "Popup"
      local ready = true
      for i = 1, #errors do
        if errors[i] == true then
          ready = false
        end
      end
      if (Fuellevel ~= "low" and ready == true) or tempState == "Popup" then
        return execute()
      end
    end
    term.clear()
    drawHeader()
    if tempState == menustate then
      menu[menustate].draw(event, p1, p2, p3)
    else
      menu[menustate].draw()
    end
    if tempState == "Update" then
      save("database/"..programName.."/updateCheckbox/V2.6", checkbox)
    end
    table.insert(timer, os.startTimer(0.5))
  end
end
 
function extractstats()
  save("database/"..programName.."/variables.stats", variables.stats)
end
 
function close()
  fs.delete("database/"..programName.."/resume")
  term.clear()
  term.setCursorPos(1,1)
  if Color() then
    term.setTextColor(colors.yellow)
    print(os.version())
    term.setTextColor(colors.white)
  else
    print(os.version())
  end
  term.setCursorPos(1, 2)
end
 
-----###-----Executive-----###------
 
local function compile(chunk) -- returns compiled chunk or nil and error message
  if type(chunk) ~= "string" then
    error("expected string, got ".. type(chunk), 2)
  end
 
  local function findChunkName(var)
    for k,v in pairs(HOST_ENV) do
      if v==var then
        return k
      end
    end
    return "Unknown chunk"
  end
 
  return load(chunk, findChunkName(chunk), "t", OUR_ENV)
end
 
function getOrientation(resume)
  if resume then
    for i = 1, 2-variables.level do
      insert('FreewayUp()')
    end
  end
  if #SlotCalculator("T", "check") ~= 0 then
    insert('Freeway()')
    if Version >= 1.64 then
      insert('FreewayUp()')
      for i = 1, 3 do
        insert('right()')
        insert('dig(true)')
      end
      insert('right()')
      insert([[if turtle.detect() == false then
        turtle.select(SlotCalculator("_", "minecraft:cobblestone")[1])
        turtle.place()
      end]])
      insert('FreewayDown()')
      insert('turtle.select(SlotCalculator("T", "check")[1])')
      insert('turtle.placeUp()')
 
      insert('torch = {"West", "East", "North", "South"}')
      insert('_, data = turtle.inspectUp()')
      insert('new_orientation = torch[data.metadata]')
 
      insert('digUp()')
      insert('FreewayBack()')
      insert('_, data, torch = nil, nil, nil')
    else
      insert('Freeway()')
      insert('digDown()')
      insert('FreewayUp()')
      for i = 1, 4 do
        insert([[if turtle.detect() == false then
          turtle.select(SlotCalculator("_", "minecraft:cobblestone")[1])
          turtle.place()
        end]])
        insert('right()')
      end
      insert('FreewayDown()')
      insert('turtle.select(SlotCalculator("T", "check")[1])')
      insert('turtle.placeUp()')
 
      insert('torch = {"West", "South", "East", "North"}')
      for i = 1, 4 do
        insert('Freeway()')
        insert('digUp()')
        insert('os.sleep(0.5)')
        insert('FreewayBack()')
        insert([[if turtle.detectUp() == false then
          i = ]]..tostring(i)..[[
          insert('turtle.select(SlotCalculator("T", "check")[1])')
          insert('turtle.suckDown()')
          insert('new_orientation = torch[i]')
          insert('i = nil')
        end]])
        insert('turtle.turnLeft()')
      end
      insert('face(variables.direction)')
      insert('FreewayBack()')
    end
  end
  if resume then
    for i = 1, 2-variables.level do
      insert('FreewayDown()')
    end
    insert([[for k, v in pairs(cardinal) do
      if v == new_orientation then
        new_orientation = k
      end
      if v == variables.orientation[variables.direction] then
        variables.orientation[variables.direction] = k
      end
    end]])
    insert([[if new_orientation ~= variables.orientation[variables.direction] then
      if math.abs(new_orientation-variables.orientation[variables.direction]) == 2 then
        insert('turtle.turnLeft()')
        insert('turtle.turnLeft()')
      elseif (new_orientation-variables.orientation[variables.direction]+1)%4 == 0 then
        insert('turtle.turnLeft()')
      elseif (new_orientation-variables.orientation[variables.direction]-1)%4 == 0 then
        insert('turtle.turnRight()')
      end
    end]])
    insert('variables.orientation[variables.direction] = cardinal[variables.orientation[variables.direction]]')
  else
    insert([[for k, v in ipairs(cardinal) do
      if new_orientation == v then
        for i = 1, 4 do
          table.insert(variables.orientation, cardinal[(k+i-2)%4+1])
        end
      end
    end]])
  end
end
 
function execute(resume)
  if not resume then
    todoList = {"go()"}
  end
  table.insert(todoList, 1, 'getOrientation('..tostring(resume)..')')
  while #todoList > 0 do
    compile(todoList[1])()
    table.remove(todoList, 1)
    variables.index = 2
    save("database/"..programName.."/resume/todoList", todoList, true)
    saveVars("resume/variables", variables)
  end
end
 
function main()
  if fs.exists("database/"..programName.."/resume") then
    os.loadAPI("database/"..programName.."/lang")
    local countdown = 10
    local count = {}
    term.clear()
    drawResume(countdown)
    table.insert(count, os.startTimer(1))
    repeat
      local event, p1 = os.pullEvent()
      while (event == "timer" and p1 ~= count[#count]) do
        event, p1 = os.pullEvent()
      end
      if event == "key" then
        if p1 == 28 then
          fs.delete("database/"..programName.."/resume")
          return main()
        end
      elseif event == "timer" and p1 == count[#count] then
        countdown = countdown - 1
      end
      term.clear()
      drawResume(countdown)
      table.insert(count, os.startTimer(1))
    until countdown == 0
    getVariables("resume/settings")
    getVariables("resume/variables")
    getList("resume/todoList")
    execute(true)
  else
    update()
    if kill == true then
      return
    end
    save("database/"..programName.."/state", "0")
    os.loadAPI("database/"..programName.."/lang")
    getVariables("settings")
    Navigation()
  end
  --extractstats()
  close()
end
 
main()