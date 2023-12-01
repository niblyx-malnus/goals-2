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
    =,  dejs:j
    |^
    ^-  $-(json goal-view)
    %-  of
    :~  [%harvest (ot ~[type+type])]
        [%pools-index ul]
        [%pool-roots (ot ~[pin+pin])]
        [%goal-young (ot ~[id+id])]
        [%pool-title (ot ~[pin+pin])]
        [%pool-note (ot ~[pin+pin])]
        [%goal-description (ot ~[id+id])]
        [%goal-note (ot ~[id+id])]
        [%goal-tags (ot ~[id+id])]
        [%goal-parent (ot ~[id+id])]
        [%goal-actionable (ot ~[id+id])]
        [%goal-complete (ot ~[id+id])]
        [%setting (ot ~[setting+so])]
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
