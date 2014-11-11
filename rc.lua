awful = require("awful")
awful.rules = require("awful.rules")

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


mawm.rules = { }
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


signal = awesome.connect_signal
csignal = client.connect_signal



-- Include user rc
-- require "default"
require "config"


-- Mapping installers
root.buttons(mawm.gbuttons)
root.keys(mawm.gkeys)

tags = { }
for s = 1, screen.count() do
    -- TODO: use defaults here
    tags[s] = awful.tag(mawm.tags[s], awful.layout.suit.floating)
end

awful.rules.rules = awful.util.table.join(
    {   rule = { },
        properties = {  keys = mawm.ckeys,
                        buttons = mawm.cbuttons
        }
    },
    mawm.rules
)

