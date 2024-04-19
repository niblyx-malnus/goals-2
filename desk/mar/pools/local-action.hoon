/-  p=pools
/+  j=pools-json
|_  act=local-action:p
++  grow
  |%
  ++  noun  act
  --
++  grab
  |%
  ++  noun  local-action:p
  ++  json  local-action:dejs:j
  --
++  grad  %noun
--
