awful = require("awful")
awful.rules = require("awful.rules")
require "awful.autofocus"
naughty = require "naughty"
wibox = require "wibox"
beautiful = require "beautiful"
gears = require "gears"
lfs = require "lfs"

html = require "markup"

mawm = { }


function theme(theme)
    local path = string.format("%s/themes/%s/theme.lua", awful.util.getdir("config"), theme)
    beautiful.init(path)

    if beautiful.wallpaper then
        for s = 1, screen.count() do
            gears.wallpaper.maximized(beautiful.wallpaper, s, true)
        end
    end
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
        elseif token == "shift" then
            key = "Shift"
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

widgets = { }
-- Plugins
function plugin(repo)
    local name = string.gsub(repo, "/", "-")
    local root = string.format("%s/installed-plugins", awful.util.getdir("config"), name)
    local path = string.format("%s/%s", root, name)
    if not lfs.attributes(path) then
        -- TODO: Show naughty messages
        os.execute("mkdir -p " .. root)
        os.execute(string.format("git clone https://github.com/%s.git %s", repo, path))
    end

    require(string.format("installed-plugins/%s/init", name))
end


local function gen_glob_client_raw(which)
    -- Generate which(), cwhich() and rawwhich() functions
    local function gen_one(kind)
        local tprefix, fprefix
        if kind == "root" then
            tprefix = "g"
            fprefix = ""
        elseif kind == "client" then
            tprefix = "c"
            fprefix = "c"
        elseif kind == "raw" then
            fprefix = "raw"
        end

        local tab
        if tprefix then
            local name = string.format("%s%ss", tprefix, which)
            mawm[name] = { }
            tab = mawm[name]
        end

        _G[fprefix .. which] = function(short, cmd)
            local name, result = parse_shortcut(awful[which], short, cmd)
            if tab then
                tab[name] = result
            end
            return result
        end

        if tab then
            _G["u" .. fprefix .. which] = function(short)
                -- kinda gross but let's repurpose parsing to find our name
                local name = parse_shortcut(function() end, short)
                tab[name] = nil
            end
        end
    end

    gen_one("root")
    gen_one("client")
    gen_one("raw")
end

gen_glob_client_raw("key")
gen_glob_client_raw("button")


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



-- Wiboxing
function bar(position, s, left, middle, right, width)
    local left_method = "set_left"
    local right_method = "set_right"
    local layout_type = "horizontal"
    local width_type = "height"

    if position == "left" or position == "right" then
        left_method = "set_top"
        right_method = "set_bottom"
        layout_type = "vertical"
        width_type = "width"
    end

    local context = {
        screen = s,
        orientation = layout_type,
        oriented_container = wibox.layout.fixed[layout_type]
    }

    local properties = { position = position, screen = s }
    properties[width_type] = width or 20

    local wi = awful.wibox(properties)
    local layout = wibox.layout.align[layout_type]()

    local data = {}
    data[left_method] = left
    data["set_middle"] = middle
    data[right_method] = right

    for method, contents in pairs(data) do
        if contents then
            local builder = context.oriented_container()
            for _, widget in ipairs(contents) do
                local result = widget(context)
                if result then
                    builder:add(result)
                end
            end

            layout[method](layout, builder)
        end
    end

    wi:set_widget(layout)
end




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

