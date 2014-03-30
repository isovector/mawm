local conf = mawm.config

for i, tag in ipairs(conf.tags) do
  mawm.tags[i] = awful.tag(tag[1], 1, tag[2])
  mawm.nametags[tag[1]] = mawm.tags[i]
end

