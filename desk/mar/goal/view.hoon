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
    :~  [%pool-roots (ot ~[pin+pin])]
        [%goal-young (ot ~[id+id])]
        [%harvest (ot ~[type+type])]
        [%pool-tag-goals (ot ~[pin+pin tag+so])]
        [%pool-tag-harvest (ot ~[pin+pin tag+so])]
        [%local-tag-goals (ot ~[tag+so])]
        [%local-tag-harvest (ot ~[tag+so])]
        [%pools-index ul]
        [%pool-title (ot ~[pin+pin])]
        [%pool-note (ot ~[pin+pin])]
        [%pool-tag-note (ot ~[pin+pin tag+so])]
        [%local-tag-note (ot ~[tag+so])]
        [%goal-summary (ot ~[id+id])]
        [%goal-note (ot ~[id+id])]
        [%goal-tags (ot ~[id+id])]
        [%goal-parent (ot ~[id+id])]
        [%goal-actionable (ot ~[id+id])]
        [%goal-complete (ot ~[id+id])]
        [%setting (ot ~[setting+so])]
        [%pool-tags (ot ~[pin+pin])]
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
