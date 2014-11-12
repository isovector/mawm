theme "multicolor"

plugin "Paamayim/mawm-core-widgets"

require "default-key-bindings"

layout(layouts.fair)
layout(layouts.tile)
layout(layouts.tile.bottom)
layout(layouts.floating)

modkey = "Mod4"

tag { "www", "wksp1", "wksp2", "tools" }

menu = awful.menu({ items = { { "open terminal", "xterm" } } })
button(3, function() menu:toggle() end)

bar("top", 1,
    { widgets.tags, widgets.prompt() },
    { widgets.tasks },
    { widgets.systray, widgets.network("wlan0"), widgets.alsa, widgets.battery("BAT0"), widgets.clock("%H:%M"), widgets.layouts }
)

key("mod+r", function() prompt:run() end)

key("f", raise("luakit", "luakit", "www"))
key("g", raise("gvim", "GVIM", "wksp1", "name"))

start("gvim", "wksp1")


csignal("focus", function(c)
    c.border_color = beautiful.border_focus
end)

csignal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

