awful   = require("awful")
naughty = require("naughty")

os.setlocale(os.getenv("LANG"))

----------

mawm = {
  run = awful.util.spawn_with_shell,
  hostname = "unknown",
  tags = { },
  config = { },
  constants = { },
}

----------

function mawm.pread(cmd)
  local result = ""
  local f = io.popen(cmd)
  for line in f:lines() do
    result = line
    break
  end
  f:close()
  return result
end

function mawm.run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell(
    "pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

----------

mawm.hostname = mawm.pread("uname -n")
mawm.run("wmname LG3D")

