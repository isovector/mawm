key("ctrl+alt+Left",  awful.tag.viewprev)
key("ctrl+alt+Right", awful.tag.viewnext)
key("mod+grave",      awful.tag.history.restore)

key("alt+Left",       function() lain.util.tag_view_nonempty(-1) end)
key("alt+Right",      function() lain.util.tag_view_nonempty(1) end)

-- layout manip
key("mod+shift+j",    function() awful.client.swap.byidx(  1)    end)
key("mod+shift+k",    function() awful.client.swap.byidx( -1)    end)

-- focus
key("mod+ctrl+j",     function() awful.screen.focus_relative( 1) end)
key("mod+ctrl+k",     function() awful.screen.focus_relative(-1) end)

key("mod+u",
    function()
        urgent  = awful.client.urgent.get()
        if urgent then
            awful.client.movetotag(
                awful.tag.selected(1),
            urgent)
            client.focus = urgent
            urgent:raise()
        end
end)

key("mod+l",           function() awful.tag.incmwfact( 0.05)    end)
key("mod+h",           function() awful.tag.incmwfact(-0.05)    end)
key("mod+shift+h",     function() awful.tag.incnmaster( 1)      end)
key("mod+shift+l",     function() awful.tag.incnmaster(-1)      end)
key("mod+ctrl+h",      function() awful.tag.incncol( 1)         end)
key("mod+ctrl+l",      function() awful.tag.incncol(-1)         end)

key("mod+space",       function() awful.layout.inc(layouts,  1)  end)
key("mod+shift+space", function() awful.layout.inc(layouts, -1)  end)

key("mod+ctrl+r",      awesome.restart)

-- tab shifting
key("alt+Tab",         function()
    awful.client.focus.byidx(-1)
    if client.focus then
        client.focus:raise()
    end
end)


for i = 1, 9 do
    key("mod+#" .. i + 9, function()
        local screen = mouse.screen
        local tag = awful.tag.gettags(screen)[i]
        if tag then
            awful.tag.viewonly(tag)
        end
    end)
    key("mod+ctrl+#" .. i + 9, function()
        local screen = mouse.screen
        local tag = awful.tag.gettags(screen)[i]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end)
    key("mod+shift+#" .. i + 9, function()
        local tag = awful.tag.gettags(client.focus.screen)[i]
        if client.focus and tag then
            awful.client.movetotag(tag)
        end
    end)
    key("mod+ctrl+shift+#" .. i + 9, function()
        local tag = awful.tag.gettags(client.focus.screen)[i]
        if client.focus and tag then
            awful.client.toggletag(tag)
        end
    end)
end

ckey("mod+F11",        function(c) c.fullscreen = not c.fullscreen  end)
ckey("mod+ctrl+space", awful.client.floating.toggle                     )
ckey("alt+t",          function(c) c.ontop = not c.ontop            end)
ckey("alt+F4",         function(c) c:kill() end)
ckey("mod+m",          function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
end)

cbutton("1",           function(c) client.focus = c; c:raise() end)
cbutton("alt+1",       awful.mouse.client.move)
cbutton("alt+3",       awful.mouse.client.resize)

-- DO ROR
-- DO SIGNALS

