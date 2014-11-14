awful.client.dofocus      = function(c) client.focus = c; c:raise() end
awful.client.togglemax  = function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c.maximized_vertical   = not c.maximized_vertical
end
awful.client.close      = function(c) c:kill() end
awful.client.toggletop  = function(c) c.ontop = not c.ontop end
awful.client.togglefull = function(c) c.fullscreen = not c.fullscreen end
awful.client.focusprev  = function() awful.client.focus.byidx(-1) end
awful.client.focusnext  = function() awful.client.focus.byidx(1) end
awful.client.moveprev   = function() awful.client.swap.byidx(-1) end
awful.client.movenext   = function() awful.client.swap.byidx(1) end

awful.layout.prev = function() awful.layout.inc(layouts, -1) end
awful.layout.next = function() awful.layout.inc(layouts,  1) end

awful.screen.focusprev  = function() awful.screen.focus_relative(-1) end
awful.screen.focusnext  = function() awful.screen.focus_relative(1) end

awful.client.cycle = function()
    awful.client.focus.byidx(-1)
    if client.focus then
        client.focus:raise()
    end
end

awful.client.focusurgent = function()
    local urgent  = awful.client.urgent.get()
    if urgent then
        awful.client.movetotag(
            awful.tag.selected(1),
        urgent)
        client.focus = urgent
        urgent:raise()
    end
end

function commands.launch(prog)
    return function()
        launch(prog)
    end
end

