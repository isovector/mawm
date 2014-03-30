local const = mawm.constants
local suit = awful.layout.suit

mawm.config = {
  default_mode  = "normal",
  terminal      = "terminator",
  city          = const.city.menlopark,
  profile       = nil,  -- use profile_map
  time_format   = "%a %d %b",

  keys = {
    lead = "\\",
    comm = "Mod4",
    show = "Mod1",
    ctrl = "Control",
    shft = "Shift",
  },

  tags = {
    { "web",    suit.tile },
    { "wksp1",  suit.tile },
    { "wksp2",  suit.tile },
    { "wksp3",  suit.tile },
    { "tools",  suit.max  },
    { "social", suit.fair },
  },

  layouts = {
    suit.floating,
    suit.tile,
    suit.fair,
    suit.max,
    suit.tile.bottom,
  },
}

naughty.config.defaults.position = "bottom_right"

