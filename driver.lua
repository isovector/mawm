require "mawm.env"
require "mawm.error"
require "mawm.constants"
require "mawm.profiles"

require "config"
if mawm.config.profile == nil then
  mawm.config.profile = mawm.constants.profile_map[mawm.hostname]
end

if mawm.profiles[mawm.config.profile] then
  -- replace config with profile settings
  for k, v in pairs(mawm.profile) do
    mawm.config[k] = v
  end
end

require "mawm.tags"
require "mawm.default_widgets"
require "mawm.widgets"
require "mawm.layout"
require "mawm.modes"

-- install global keys
-- ROR
-- install client keys
-- rules
-- signals
-- setup
