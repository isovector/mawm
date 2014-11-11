local gears = require "gears"


beautiful.init("/home/bootstrap/.config/other-awesome/themes/multicolor/theme.lua")
gears.wallpaper.maximized("/home/bootstrap/.config/other-awesome/themes/multicolor/newwall.jpg", 1, true)

modkey = "Mod4"

tag("www")

layout(layouts.tile)

key("ctrl+mod+t", awesome.restart)
ckey("mod+ctrl+space", awful.client.floating.toggle)

menu = awful.menu({ items = { { "open terminal", "terminator" } } })
button(3, function() menu:toggle() end)
cbutton(1, function(c) client.focus = c; c:raise() end)

