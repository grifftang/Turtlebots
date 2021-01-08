--[[startup handler by BrunoZockt
 
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
]]--
 
local programs = {
  ["standart"] = ""
}
 
local color = term.isColor()
 
name = "SupHa - Startup Handler by BrunoZockt"
 
local function uploadList()
  local file = fs.open("database/startup", "w")
  file.writeLine(textutils.serialize(programs))
  file.close()
end
 
function getList(terminal)
  local function downloadList()
    local programs = {["standart"] = ""}
    if fs.exists("database/startup") then
      local file = fs.open("database/startup", "r")
      programs = textutils.unserialize(file.readAll())
      file.close()
    end
    return programs
  end
 
  local programs = downloadList()
  if terminal then
    print(textutils.serialize(programs))
  else
    return programs
  end
end
 
function set(path, position, terminal)
  programs = getList()
  local result = nil
  if fs.exists(path) == true then
    if position == "standart" then
      programs["standart"] = path
    else
      table.insert(programs, (tonumber(position) or #programs+1), path)
    end
    if terminal then
      print("Success!")
      print(textutils.serialize(programs))
    else
      result = true
    end
  else
    if terminal then
      if color then
        term.setTextColor(colors.red)
      end
      print("Error: could not find path")
      if color then
        term.setTextColor(colors.white)
      end
    else
      result = false
    end
  end
  uploadList()
  return result
end
 
function remove(path, terminal)
  programs = getList()
  for k, v in ipairs(programs) do
    if v == path then
      table.remove(programs, k)
      if terminal then
        print("Success!")
        print(textutils.serialize(programs))
      end
      uploadList()
      return true
    end
  end
  if terminal then
    if color then
      term.setTextColor(colors.red)
    end
    print("Error: "..path.." was not found on the list")
    if color then
      term.setTextColor(colors.white)
    end
  end
  return false
end
 
local function shelly()
  shell.path()
end
 
if pcall(shelly) == true then
  local args = {...}
  if args[1] == "getList" then
    getList(true)
  elseif args[1] == "set" then
    set(args[2], args[3], true)
  elseif args[1] == "remove" then
    remove(args[2], true)
  elseif #args == 0 then
    programs = getList()
    local program = ""
    if fs.exists(programs["standart"]) then
      program = programs["standart"]
    end
 
    for i = 1, #programs do
      if fs.exists(programs[i]) then
        if fs.exists("database/"..programs[i].."/resume") then
          program = programs[i]
          break
        end
      end
    end
 
    shell.run(program)
  else
    if color then
      term.setTextColor(colors.red)
    end
    print("Error: wrong argument: "..args[1])
    if color then
      term.setTextColor(colors.white)
    end
  end
end