awful       = require("awful")
awful.rules = require("awful.rules")
              require "awful.autofocus"
naughty     = require "naughty"
wibox       = require "wibox"
beautiful   = require "beautiful"
gears       = require "gears"
lfs         = require "lfs"
html        = require "markup"
gearsobj    = require "gears.object"



            if awesome.startup_errors then
                naughty.notify({ preset = naughty.config.presets.critical,
                                 title = "Oops, there were errors during startup!",
                                 text = awesome.startup_errors })
            end

            do
                local in_error = false
                awesome.connect_signal("debug::error", function (err)
                    if in_error then return end
                    in_error = true

                    naughty.notify({ preset = naughty.config.presets.critical,
                                     title = "Oops, an error happened!",
                                     text = err })
                    in_error = false
                end)
            end

            os.setlocale(os.getenv("LANG"))




mawm = { }

-- Variables

notification_pos = "top_right"


-- Setup env

local function get_tag(tagid)
    return tagid and (tags[tagid] or tags[tagid .. ":1"])
end

system = awful.util.spawn_with_shell

mawm.notifications = { }
function notify(level, text, title, additional, name)
    local prefs = { text = text, title = title, position = notification_pos }
    if beautiful.notify_levels and beautiful.notify_levels[level] then
        prefs.preset = beautiful.notify_levels[level]

        if prefs.preset.position then
            prefs.position = prefs.preset.position
        end
    end

    prefs = awful.util.table.join(prefs, additional)

    if name then
        unotify(mawm.notifications[name])
    end

    local notif = naughty.notify(prefs)

    if name then
        mawm.notifications[name] = notif
    end

    return notif
end

function unotify(notification)
    naughty.destroy(notification)
end

function every(time, func)
    local updater = timer({ timeout = time })
    updater:connect_signal("timeout", func)
    updater:start()
    return updater
end

function launch(program, tagid)
    mawm.nextTag = get_tag(tagid)
    awful.util.spawn(program)
end

function launch1(cmd)
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace-1)
    end
    awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

function method(obj, method, ...)
    local args = { ... }
    return function(c)
        obj = obj or c
        return obj[method](obj, unpack(args))
    end
end


function theme(theme)
    local path = string.format("%s/themes/%s/theme.lua", awful.util.getdir("config"), theme)
    beautiful.init(path)

    if beautiful.wallpaper then
        wallpaper(beautiful.wallpaper)
    end
end

function wallpaper(wall)
    for s = 1, screen.count() do
        gears.wallpaper.maximized(wall, s, true)
    end
end


function first_line(f)
    local fp = io.open(f)
    if not fp
    then
        return nil
    end

    local content = fp:read("*l")
    fp:close()
    return content
end

function format(str, t, ...)
    local args = { ... }
    if #args then
        str = string.format(str, unpack(args))
    end

    for key, val in pairs(t) do
        str = str:gsub(string.format("{%s}", key), val)
    end

    return str
end

mawm.modkeys = { }
function modkey(name, keysym)
    mawm.modkeys[name] = keysym
end

modkey("alt", "Mod1")
modkey("ctrl", "Control")
modkey("shift", "Shift")

local function parse_shortcut(method, short, cmd)
    local mods = { }
    local key = nil

    for token in tostring(short).gmatch(short, "[^ +]+") do
        if key ~= nil then
            table.insert(mods, key)
        end

        if mawm.modkeys[token] then
            key = mawm.modkeys[token]
        else
            key = token
        end
    end

    -- Buid a canonical nae to allow for remapping defaults
    table.sort(mods)
    local canonicalName = string.lower(table.concat(mods, "+") .. "+" .. key)

    -- Cast the key to a number if possible
    key = tonumber(key) or key

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
commands = { }
-- Plugins
function plugin(repo)
    local name = string.gsub(repo, "/", "-")
    local root = string.format("%s/installed-plugins", awful.util.getdir("config"), name)
    local path = string.format("%s/%s", root, name)

    if not lfs.attributes(path) then
        os.execute("mkdir -p " .. root)
        os.execute(string.format("git clone https://github.com/%s.git %s", repo, path))
        notify("system", "Finished installing plugin `" .. repo .. "'", "")
    end

    require(string.format("installed-plugins/%s/init", name))
end

mawm.signaler = gearsobj()
function signal(signal, callback)
    local root_signals = {
        ["exit"] = true,
        ["spawn::initiated"] = true,
        ["spawn::change"] = true,
        ["spawn::canceled"] = true,
        ["spawn::timeout"] = true,
        ["spawn::completed"] = true,
        ["debug::error"] = true,
        ["debug::deprecation"] = true,
        ["debug::index::miss"] = true,
        ["debug::newindex::miss"] = true,
    }

    if root_signals[signal] then
        awesome.connect_signal(signal, callback)
    else
        mawm.signaler:connect_signal(signal, function(obj, ...) callback(...) end)
    end
end

function register_signal(signal)
    mawm.signaler:add_signal(signal)
end

function emit(signal, ...)
    mawm.signaler:emit_signal(signal, ...)
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


awful.rules.rules = { }

function rule(match, name, callback, ...)
    local t = { ... }
    local props = { }

    for i = 1, #t, 2 do
        props[t[i]] = t[i + 1]
    end

    table.insert(awful.rules.rules, {
        rule = {
            [match] = name
        },
        callback = callback,
        properties = props
    })
end

mawm.nextTag = nil
function commands.raise(cmd, val, tagid, prop)
    prop = prop or "class"

    return function()
        local clients = client.get()
        local focused = awful.client.next(0)
        local findex = 0
        local matched_clients = {}
        local n = 0

        --make an array of matched clients
        for i, c in pairs(clients) do
            if c[prop] == val or c[prop]:find(val) then
                n = n + 1
                matched_clients[n] = c
                if c == focused then
                    findex = n
                end
            end
        end

        if n > 0 then
            local c = matched_clients[1]
            if 0 < findex and findex < n then
                -- if the focused window matched switch focus to next in list
                c = matched_clients[findex+1]
            end

            local ctags = c:tags()
            if table.getn(ctags) == 0 then
                -- ctags is empty, show client on current tag
                local curtag = awful.tag.selected()
                awful.client.movetotag(curtag, c)
            else
                -- Otherwise, pop to first tag client is visible on
                awful.tag.viewonly(ctags[1])
            end

            -- And then focus the client
            client.focus = c
            c:raise()
        else
            launch(cmd, tagid)
        end
    end
end



mawm.tags = { }
mawm.taglayouts = { }
for s = 1, screen.count() do
    table.insert(mawm.tags, { })
    table.insert(mawm.taglayouts, { })
end

function tag(name, default)
    for s = 1, screen.count() do
        stag(s, name, default)
    end
end

function stag(s, tags, default)
    default = default or awful.layout.layouts[1] or awful.layout.suit.tile

    if type(tags) ~= "table" then
        tags = { tags }
    end

    for _, name in ipairs(tags) do
        table.insert(mawm.tags[s], name)
        table.insert(mawm.taglayouts[s], default)
    end
end

awful.layout.layouts = { }
function layout(which)
    table.insert(awful.layout.layouts, which)
end


mawm.start = { }
function start(program, tagid)
    table.insert(mawm.start, { program, tagid })
end

csignal = client.connect_signal

-- Install tag spawning support
mawm.clientsToSpawn = 0
csignal("manage", function(c)
    local tag = mawm.nextTag
    if tag then
        awful.client.movetotag(tag, c)

        if mawm.clientsToSpawn == 0 then
            -- suppress changing tags if we are starting up
            awful.tag.viewonly(tag)
        else
            mawm.clientsToSpawn = mawm.clientsToSpawn - 1
        end
        mawm.nextTag = nil
    end
end)



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
require "commands"

register_signal("mawm::load_config")


-- Allow plugins to hijack config loading
local loaded = loadfile "early-hooks.lua"
if loaded then
    loaded()
end

-- Give a useful WM name for java
start("wmname LG3D")

local loadHandler = { cancel = false }
emit("mawm::load_config", loadHandler)
if not loadHandler.cancel then
    require "config"
end

-- Add default buttons and keys to clients
table.insert(awful.rules.rules, 1,
{   rule = { },
    properties = {
        keys = join(mawm.ckeys),
        buttons = join(mawm.cbuttons),
        focus = awful.client.focus.filter,
        raise = true,
    }
})


tags = { }
for s = 1, screen.count() do
    local gentags = awful.tag(mawm.tags[s], s, mawm.taglayouts[s])
    for i, name in ipairs(mawm.tags[s]) do
        local id = string.format("%s:%d", name, s)
        tags[id] = gentags[i]
    end
end

-- Transform tag strings into real tags
for _, rule in ipairs(awful.rules.rules) do
    local props = rule.properties
    if props then
        if type(props.tag) == "string" then
            props.tag = get_tag(props.tag)
        end
    end
end

-- Mapping installers
root.buttons(join(mawm.gbuttons))
root.keys(join(mawm.gkeys))

mawm.clientsToSpawn = #mawm.start
for i, tup in ipairs(mawm.start) do
    local program = tup[1]
    local tagid = tup[2]

    if tagid then
        launch(program, tagid)
    else
        launch1(program)
    end
end

