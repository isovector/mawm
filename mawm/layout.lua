local left  = mawm.widgets.left
local right = mawm.widgets.right
local layout = mawm.widgets.layout

for _, v in ipairs(mawm.layout.left) do
  left:add(v)
end

for _, v in ipairs(mawm.layout.right) do
  right:add(v)
end

layout:set_left(left)
layout:set_right(right)
mawm.widgets.wibox:set_widget(layout)

