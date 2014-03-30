local awful     = require("awful")
local beautiful = require("beautiful")
local lain      = require("lib.lain")

markup = lain.util.markup

----------

-- clock
local clockicon = wibox.widget.imagebox(beautiful.widget_clock)
local mytextclock = awful.widget.textclock(markup("#7788af", timeFormat) .. markup("#f1af5f", "  %H:%M"))

-- Calendar
lain.widgets.calendar:attach(mytextclock, { font_size = 10 })

-- Weather
local weathericon = wibox.widget.imagebox(beautiful.widget_weather)
local yawn = lain.widgets.yawn(city, {
  settings = function()
    widget:set_markup(markup("#eca4c4", units .. "°C"))
  end
})

-- Battery
local baticon = wibox.widget.imagebox(beautiful.widget_batt)
local batwidget = lain.widgets.bat({
  settings = function()
    if bat_now.perc == "N/A" then
      bat_now.perc = "AC "
    else
      bat_now.perc = bat_now.perc .. "%"
    end
    widget:set_text(bat_now.perc)
  end
})

-- ALSA volume
local volicon = wibox.widget.imagebox(beautiful.widget_vol)
local volumewidget = lain.widgets.alsa({
  settings = function()
    if volume_now.status == "off" then
      volume_now.level = volume_now.level .. "M"
    end
    widget:set_markup(markup("#7493d2", volume_now.level .. "%"))
  end
})

-- Net 
local netdownicon = wibox.widget.imagebox(beautiful.widget_netdown)
local netdowninfo = wibox.widget.textbox()
local netupicon = wibox.widget.imagebox(beautiful.widget_netup)

local netupinfo = lain.widgets.net({
  settings = function()
    widget:set_markup(markup("#e54c62", net_now.sent))
    netdowninfo:set_markup(markup("#87af5f", net_now.received))
  end
})

-- cmus
local cmusicon = wibox.widget.imagebox()
local cmuswidget = lain.widgets.cmus({
  settings = function()
    cmus_notification_preset = {
      text = string.format("%s [%s] - %s\n%s", cmus_state.artist,
      cmus_state.album, cmus_state.date, cmus_state.title)
    }

    if cmus_state.status == "playing" then
      artist = cmus_state.artist:gsub("&", "&amp;") .. " > "
      title  = cmus_state.title:gsub("&", "&amp;") .. " "
      cmusicon:set_image(beautiful.widget_note_on)
    elseif cmus_state.status == "paused" then
      artist = "cmus "
      title  = "paused "
    else
      artist = ""
      title  = ""
      cmusicon:set_image(nil)
    end
    widget:set_markup(markup("#e54c62", artist) .. markup("#f1af5f", title))
  end
})

----------

-- todo(sandy): it would be nice if this were separate from the widgets
-- even better would be if each widget were entirely separate
local layout = mawm.layouts
local widgets = mawm.widgets

layout.left = {
  widgets.taglist,
  widgets.prompt,
  cmusicon,
  cmuswidget,
}

layout.right = {
  widgets.systray,

  -- network
  netdownicon,
  netdowninfo,
  netupicon,
  netupinfo,

  -- misc
  volicon,
  volumewidget,
  weathericon,
  yawn.widget,
  baticon,
  batwidget,

  -- time
  pomodoro.install,
  clockicon,
  mytextclock,
  widgets.layoutbox,
  widgets.spacer,
  pcfb.install,

  -- journal
  widgets.spacer,
  journal.install,
  widgets.spacer,
}
