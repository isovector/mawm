modkey = "Mod4"

tag("www")

menu = awful.menu({ items = { { "open terminal", "terminator" } } })
button(3, function() menu.toggle() end)

cbutton(1, function(c) client.focus = c; c:raise() end)

awful.util.spawn_with_shell("terminator")

