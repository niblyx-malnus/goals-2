/-  *action
/+  j=gol-cli-json
|_  vyu=goal-view
++  grow
  |%
  ++  noun  vyu
  --
++  grab
  |%
  ++  noun  goal-view
  ++  json
    =,  dejs:format
    |^
    ^-  $-(json goal-view)
    %-  of
    :~  [%harvest (ot ~[type+type])]
    ==
    ++  type
      %-  of
      :~  main+|=(jon=json ?>(?=(~ jon) ~))
          pool+pin:dejs:j
          goal+id:dejs:j
      ==
    --
  --
++  grad  %noun
--
