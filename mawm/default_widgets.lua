local wibox = require("wibox")

local key = mawm.config.keys
local layouts = mawm.config.layouts
local wiwid = wibox.widget

mawm.widgets = { }
mawm.layout = { 
  left = { }, 
  right = { },
}

local widgets = mawm.widgets

widgets.spacer = wibox.widget.textbox(" ")
widgets.prompt = awful.widget.prompt()

widgets.layoutbox = awful.widget.layoutbox(s)
widgets.layoutbox:buttons(awful.util.table.join(
  awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
  awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
  awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
  awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end))
)

local at = awful.tag
widgets.taglist = awful.widget.taglist(
  1, 
  awful.widget.taglist.filter.all, 
  awful.util.table.join(
    awful.button({ }, 1, at.viewonly),
    awful.button({ key.comm }, 1, awful.client.movetotag),
    awful.button({ }, 3, at.viewtoggle),
    awful.button({ key.comm }, 3, awful.client.toggletag),
    awful.button({ }, 4, function(t) at.viewnext(at.getscreen(t)) end),
    awful.button({ }, 5, function(t) at.viewprev(at.getscreen(t)) end)
  )
)

widgets.wibox = awful.wibox({ position = "top", screen = 1, height = 20 }) 
widgets.systray = wibox.widget.systray()

widgets.left    = wibox.layout.fixed.horizontal()
widgets.right   = wibox.layout.fixed.horizontal()
widgets.layout  = wibox.layout.align.horizontal() 
