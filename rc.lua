awful = require("awful")
awful.rules = require("awful.rules")
require "awful.autofocus"
naughty = require "naughty"
wibox = require "wibox"
beautiful = require "beautiful"



mawm = { }


function set_theme(theme)
end

modkey = "Mod4"
local function parse_shortcut(method, short, cmd)
    local mods = { }
    local key = nil

    for token in tostring(short).gmatch(short, "[^ +]+") do
        if key ~= nil then
            table.insert(mods, key)
        end

        if token == "mod" then
            key = modkey
        elseif token == "alt" then
            key = "Mod1"
        elseif token == "ctrl" then
            key = "Control"
        else
            key = token
        end
    end

    -- Buid a canonical nae to allow for remapping defaults
    table.sort(mods)
    local canonicalName = string.lower(table.concat(mods, "+") .. "+" .. key)

    -- Cast the key to a number if possible
    local keyAsNumber = tonumber(key)
    if keyAsNumber ~= nil then
        key = keyAsNumber
    end

    return canonicalName, method(mods, key, cmd)
end

local function join(t)
    local result = { }
    for k, v in pairs(t) do
        result = awful.util.table.join(result, v)
    end

    return result
end

-- Plugins
function plugin(name)
end



-- Mapping helpers
mawm.gbuttons = { }
function button(short, cmd)
    local name, result = parse_shortcut(awful.button, short, cmd)
    mawm.gbuttons[name] = result
end

mawm.cbuttons = { }
function cbutton(short, cmd)
    local name, result = parse_shortcut(awful.button, short, cmd)
    mawm.cbuttons[name] = result
end


mawm.gkeys = { }
function key(short, cmd)
    local name, result = parse_shortcut(awful.key, short, cmd)
    mawm.gkeys[name] = result
end

mawm.ckeys = { }
function ckey(short, cmd)
    local name, result = parse_shortcut(awful.key, short, cmd)
    mawm.ckeys[name] = result
end


awful.rules.rules = -- Default rule
    {   rule = { },
        properties = {  keys = join(mawm.ckeys),
                        buttons = join(mawm.cbuttons),
                        focus = awful.client.focus.filter,
                        raise = true,
        }
    }
function rule()
end


mawm.tags = { }
for s = 1, screen.count() do
    table.insert(mawm.tags, { })
end

function tag(name)
    -- TODO(sandy): figure out how to get defaults in here
    for s = 1, screen.count() do
        stag(s, name)
    end
end

function stag(s, name, default)
    table.insert(mawm.tags[s], name)
end

awful.layout.layouts = { }
function layout(which)
    table.insert(awful.layout.layouts, which)
end


mawm.start = { }
function start(program)
    table.insert(mawm.start, program)
end

signal = awesome.connect_signal
csignal = client.connect_signal



-- Finish setting up environment
layouts = awful.layout.suit

-- Include user rc
-- require "default"
require "config"

tags = { }
for s = 1, screen.count() do
    -- TODO: use defaults here
    tags[s] = awful.tag(mawm.tags[s], s, awful.layout.suit.tile)
end

-- Mapping installers
root.buttons(join(mawm.gbuttons))
root.keys(join(mawm.gkeys))

for i, program in ipairs(mawm.start) do
    awful.util.spawn_with_shell(program)
end

