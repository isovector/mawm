            local gears     = require("gears")
            awful.rules     = require("awful.rules")
            require("awful.autofocus")
            local naughty   = require("naughty")
            
            local pomodoro  = require("lib.plugins.pomodoro.pomodoro")
            local pcfb      = require("lib.plugins.pcfb.pcfb")
            local journal   = require("lib.plugins.journal.journal")

            newWindowTag = { tag = nil } 


            function spawn_in_tag(exec, tag)
              newWindowTag.tag = tag
              awful.util.spawn(exec)
            end

            run_once("unclutter")

            os.setlocale(os.getenv("LANG"))

            beautiful.init(awful.util.getdir("config") .. "/themes/multicolor/theme.lua")
            run_once("nm-applet")
            --run_once("xrandr --output DP1 --auto")

----------------------------------------------------

            if beautiful.wallpaper then
                for s = 1, screen.count() do
                    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
                end
            end

            markup      = lain.util.markup

----------------------------------------------------

            root.buttons(awful.util.table.join(
                --awful.button({ }, 3, function () mymainmenu:toggle() end),
                awful.button({ }, 4, awful.tag.viewnext),
                awful.button({ }, 5, awful.tag.viewprev)
            ))

            exec = os.execute

            function installKeys(gingkoMode)
                globalkeys = awful.util.table.join(

----------------------------------------------------

awful.key({ }, "XF86AudioRaiseVolume", function() exec("amixer -q set Master 2dB+", false) end),
awful.key({ }, "XF86AudioLowerVolume", function() exec("amixer -q set Master 2dB-", false) end),
awful.key({ }, "XF86Launch1", function () awful.util.spawn(terminal) end),
awful.key({ modkey }, "t", function () awful.util.spawn("thunar") end),

awful.key({ altkey }, "p", function() os.execute("scrot") end),

----------------------------------------------------

            -- journal
            awful.key({ modkey },           "v", function () 
                awful.prompt.run({ prompt = markup("#7493d2", " Write: ") },
                    mypromptbox[mouse.screen].widget,
                    journal.execute("write"), nil, nil)
            end),

            awful.key({ modkey },           "i", function () 
                awful.prompt.run({ prompt = markup("#7493d2", " Idea: ") },
                    mypromptbox[mouse.screen].widget,
                    journal.execute("open"), nil, nil)
            end),

            awful.key({ modkey, "Control" },"i", function () 
                journal.query("ideas", 6, "Close", "top_left")
                awful.prompt.run({ prompt = markup("#7493d2", " Close: ") },
                    mypromptbox[mouse.screen].widget,
                    journal.execute("close"), nil, nil)
            end),

            awful.key({ modkey },           "c", function () 
                journal.query("contexts", 6, "Context", "top_left")
                awful.prompt.run({ prompt = markup("#7493d2", " Context: ") },
                    mypromptbox[mouse.screen].widget,
                    journal.execute("context"), journal.completion)
            end),

            awful.key({ altkey }, "v", journal.propagate(8)),
            

            -- live-filter
            awful.key({ modkey },           "l", function () 
                awful.prompt.run({ prompt = markup("#7493d2", " Music: ") },
                    mypromptbox[mouse.screen].widget,
                    function (query) 
                      awful.util.spawn_with_shell(
                        "cmus-remote -C \"live-filter " .. query .. "\" &&" ..
                        "cmus-remote --next")
                    end, nil,
                    awful.util.getdir("cache") .. "/live-filter")
            end),

            -- pomodoro
            awful.key({ modkey },           "p", function () 
                awful.prompt.run({ prompt = markup("#de5e1e", " Pomodoro: ") },
                    mypromptbox[mouse.screen].widget,
                    function (name) 
                        pcfb.enable(true)
                        pomodoro.pomodoro("start", name, function()
                            pcfb.enable(false)
                        end) 
                    end, nil,
                    awful.util.getdir("cache") .. "/pomodoro")
            end),
            
            awful.key({ modkey, "Shift" },  "p", function () 
                pcfb.enable(true)
                pomodoro.pomodoro("again") 
            end),
            
            awful.key({ modkey, "Control" },  "p", function () 
                pcfb.enable(false)
                pomodoro.pomodoro("cancel") 
            end),
    
            -- pcfb
            awful.key({ modkey }, "bracketleft",
            function ()
                pcfb.enable(true)
            end),
            
            awful.key({ modkey }, "bracketright",
            function ()
                pcfb.enable(false)
            end),
            
            awful.key({ altkey }, "b",
            function () 
                pcfb.alert(4) 
            end),

            -- external desktop
            awful.key({ altkey }, "F7",
            function ()
                run_once("/home/tino/Projects/scython/scripts/external-desktop.scy")
            end),

            awful.key({ altkey, "Shift" }, "Tab",
                function ()
                    awful.client.focus.byidx(1)
                    if client.focus then
                        client.focus:raise()
                    end
                end),

            awful.key({ "Control", altkey }, "Left",   awful.tag.viewprev       ),
            awful.key({ "Control", altkey }, "Right",  awful.tag.viewnext       ),
            awful.key({ modkey }, "Escape", awful.tag.history.restore),

            awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end),
            awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end),

            -- By direction client focus
            awful.key({ modkey }, "j",
                function()
                    awful.client.focus.bydirection("down")
                    if client.focus then client.focus:raise() end
                end),
            awful.key({ modkey }, "k",
                function()
                    awful.client.focus.bydirection("up")
                    if client.focus then client.focus:raise() end
                end),
            awful.key({ modkey }, "h",
                function()
                    awful.client.focus.bydirection("left")
                    if client.focus then client.focus:raise() end
                end),
            awful.key({ modkey }, "l",
                function()
                    awful.client.focus.bydirection("right")
                    if client.focus then client.focus:raise() end
                end),

            -- Layout manipulation
            awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
            awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
            awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
            awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
            awful.key({ modkey,           }, "u", 
                function() 
                  urgent  = awful.client.urgent.get()
                  if urgent then
                    awful.client.movetotag(
                      awful.tag.selected(1),
                      urgent)
                    client.focus = urgent
                    urgent:raise()
                  end
                end),

            awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1)  end),
            awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1)  end),

            awful.key({ modkey, "Control" }, "r",      awesome.restart),

            -- Widgets popups
            awful.key({ altkey,           }, "c",      function () lain.widgets.calendar:show(7) end),
            awful.key({ altkey,           }, "w",      function () yawn.show(7) end),

             -- tab shifting
             awful.key({ altkey, }, "Tab",
             function ()
                 awful.client.focus.byidx(-1)
                 if client.focus then
                     client.focus:raise()
                 end
             end),

            -- cmus control
            awful.key({ "Control" }, "Down",
                function ()
                    awful.util.spawn_with_shell("cmus-remote --pause")
                    cmuswidget.update()
                end),
            awful.key({ "Control" }, "Up",
                function ()
                    awful.util.spawn_with_shell("cmus-remote --stop")
                    cmuswidget.update()
                end),
            awful.key({ "Control" }, "Left",
                function ()
                    awful.util.spawn_with_shell("cmus-remote --prev")
                    cmuswidget.update()
                end),
            awful.key({ "Control" }, "Right",
                function ()
                    awful.util.spawn_with_shell("cmus-remote --next")
                    cmuswidget.update()
                end),

            awful.key({ modkey }, "r", function () 
                mypromptbox[mouse.screen]:run(markup("#7788af", " Run: ")) 
                end)
            )

            clientkeys = awful.util.table.join(
                awful.key({ modkey,           }, "F11",      function (c) c.fullscreen = not c.fullscreen  end),
                awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
                awful.key({ altkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
                awful.key({ altkey                 }, "F4", function (c) c:kill() end),
                awful.key({ modkey,           }, "m",
                    function (c)
                        c.maximized_horizontal = not c.maximized_horizontal
                        c.maximized_vertical   = not c.maximized_vertical
                    end)
            )

            for i = 1, 9 do
                globalkeys = awful.util.table.join(globalkeys,
                    awful.key({ modkey }, "#" .. i + 9,
                              function ()
                                    local screen = mouse.screen
                                    local tag = awful.tag.gettags(screen)[i]
                                    if tag then
                                       awful.tag.viewonly(tag)
                                    end
                              end),
                    awful.key({ modkey, "Control" }, "#" .. i + 9,
                              function ()
                                  local screen = mouse.screen
                                  local tag = awful.tag.gettags(screen)[i]
                                  if tag then
                                     awful.tag.viewtoggle(tag)
                                  end
                              end),
                    awful.key({ modkey, "Shift" }, "#" .. i + 9,
                              function ()
                                  local tag = awful.tag.gettags(client.focus.screen)[i]
                                  if client.focus and tag then
                                      awful.client.movetotag(tag)
                                 end
                              end),
                    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                              function ()
                                  local tag = awful.tag.gettags(client.focus.screen)[i]
                                  if client.focus and tag then
                                      awful.client.toggletag(tag)
                                  end
                              end))
            end

            clientbuttons = awful.util.table.join(
                awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
                awful.button({ altkey }, 1, awful.mouse.client.move),
                awful.button({ altkey }, 3, awful.mouse.client.resize))

            require("aweror")
            globalkeys = awful.util.table.join(globalkeys, aweror.genkeys(modkey))
            root.keys(globalkeys)
            
            end

installKeys(false)

----------------------------------------------------

            function xrr(name)
              return { rule = { name = name }, properties = { tag = nametags.tools } }
            end

awful.rules.rules = {
    { rule = { }, properties = {
      focus = awful.client.focus.filter, size_hints_honor = false,
      keys = clientkeys, buttons = clientbuttons,
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal }
    },
    { rule = { role = "buddy_list" }, properties = { tag = nametags.social } },
    { rule = { instance = "skype" }, properties = { tag = nametags.social } },
    { rule = { name = "Skype(TM) Chat" }, properties = { floating = true } },
    { rule = { name = "Thunderbird" }, properties = { tag = nametags.tools } },
    { rule = { name = "XChat" }, properties = { tag = nametags.tools } },
    { rule = { role = "conversation" }, properties = { floating = true } },
    { rule = { instance = "Download" }, callback = function(c) c:kill() end },
    { rule = { instance = "plugin-container" }, properties = { floating = true } },
    xrr("WorkFlowy"),
    xrr("Google Calendar"),
    xrr("cmus"),
}

----------------------------------------------------

            client.connect_signal("manage", function (c, startup)
                if not startup and not c.size_hints.user_position
                   and not c.size_hints.program_position then
                    awful.placement.no_overlap(c)
                    awful.placement.no_offscreen(c)
                end

                if newWindowTag.tag then
                  awful.client.movetotag(nametags[newWindowTag.tag], c)
                  awful.tag.viewonly(nametags[newWindowTag.tag])
                  newWindowTag.tag = nil
                end
            end)

            client.connect_signal("focus",
                function(c)
                    if c.maximized_horizontal == true and c.maximized_vertical == true then
                        c.border_width = 0
                        c.border_color = beautiful.border_normal
                    else
                        c.border_width = beautiful.border_width
                        c.border_color = beautiful.border_focus
                    end
                end)
            client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

            for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
                    local clients = awful.client.visible(s)
                    local layout  = awful.layout.getname(awful.layout.get(s))

                    if #clients > 0 then -- Fine grained borders and floaters control
                        for _, c in pairs(clients) do -- Floaters always have borders
                            -- No borders with only one humanly visible client
                            if layout == "max" then
                                c.border_width = 0
                            elseif awful.client.floating.get(c) or layout == "floating" then
                                c.border_width = beautiful.border_width
                            elseif #clients == 1 then 
                                clients[1].border_width = 0
                                if layout ~= "max" then
                                    awful.client.moveresize(0, 0, 2, 0, clients[1])
                                end
                            else
                                c.border_width = beautiful.border_width
                            end
                        end
                    end
                  end)
            end

----------------------------------------------------            

run_once("pidgin")
run_once("wmname LG3D")
run_once("thunderbird")
run_once("xchat")
run_once("terminator -e cmus")

if not laptop then
  run_once("xset -dpms")
  run_once("xset s noblank")
  run_once("xset s off")
end

--run_once("xulrunner google.com/calendar/render")
spawn_in_tag("xulrunner google.com/calendar/render", "tools")
run_once("nm-applet")
