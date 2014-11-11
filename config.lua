theme "multicolor"

plugin "Paamayim/mawm-core-widgets"

require "default-key-bindings"

layout(layouts.floating)
layout(layouts.tile)
layout(layouts.tile.left)
layout(layouts.tile.bottom)
layout(layouts.tile.top)
layout(layouts.fair)
layout(layouts.fair.horizontal)
layout(layouts.spiral)
layout(layouts.spiral.dwindle)
layout(layouts.max)
layout(layouts.max.fullscreen)
layout(layouts.magnifier)

modkey = "Mod4"

tag("1")
tag("2")
tag("3")
tag("4")
tag("5")
tag("6")
tag("7")
tag("8")
tag("9")

menu = awful.menu({ items = { { "open terminal", "xterm" } } })
button(3, function() menu:toggle() end)

bar("top", 1,
    { widgets.tags, widgets.prompt() },
    { widgets.tasks },
    { widgets.systray, widgets.clock("%H:%M"), widgets.layouts }
)

key("mod+r", function() prompt:run() end)

key("g", raise("gvim", "GVIM", "5", "name"))

start("gvim", "2")
