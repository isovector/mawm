key("ctrl+alt+Left",  awful.tag.viewprev)
key("ctrl+alt+Right", awful.tag.viewnext)
key("mod+grave",      awful.tag.history.restore)

key("mod+shift+j",    awful.client.movenext)
key("mod+shift+k",    awful.client.moveprev)

key("mod+ctrl+j",     awful.client.focusnext)
key("mod+ctrl+k",     awful.client.focusprev)

key("mod+u",          awful.client.focusurgent)

key("mod+l",           function() awful.tag.incmwfact( 0.05)    end)
key("mod+h",           function() awful.tag.incmwfact(-0.05)    end)
key("mod+shift+h",     function() awful.tag.incnmaster( 1)      end)
key("mod+shift+l",     function() awful.tag.incnmaster(-1)      end)
key("mod+ctrl+h",      function() awful.tag.incncol( 1)         end)
key("mod+ctrl+l",      function() awful.tag.incncol(-1)         end)

key("mod+space",       awful.layout.next)
key("mod+shift+space", awful.layout.prev)

key("mod+ctrl+r",      awesome.restart)

key("alt+Tab",         awful.client.cycle)


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

ckey("mod+F11",        awful.client.togglefull)
ckey("mod+ctrl+space", awful.client.floating.toggle)
ckey("alt+t",          awful.client.toggletop)
ckey("alt+F4",         awful.client.close)
ckey("mod+m",          awful.client.togglemax)

cbutton("1",           awful.client.dofocus)
cbutton("alt+1",       awful.mouse.client.move)
cbutton("alt+3",       awful.mouse.client.resize)

