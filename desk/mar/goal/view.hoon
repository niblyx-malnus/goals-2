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
    :~  [%pool-roots (ot ~[pid+pid])]
        [%goal-young (ot ~[pid+pid gid+gid])]
        [%harvest (ot ~[type+type])]
        [%pool-tag-goals (ot ~[pid+pid tag+so])]
        [%pool-tag-harvest (ot ~[pid+pid tag+so])]
        [%local-tag-goals (ot ~[tag+so])]
        [%local-tag-harvest (ot ~[tag+so])]
        [%pools-index ul]
        [%pool-title (ot ~[pid+pid])]
        [%pool-note (ot ~[pid+pid])]
        [%pool-tag-note (ot ~[pid+pid tag+so])]
        [%local-tag-note (ot ~[tag+so])]
        [%goal-summary (ot ~[pid+pid gid+gid])]
        [%goal-note (ot ~[pid+pid gid+gid])]
        [%goal-tags (ot ~[pid+pid gid+gid])]
        [%goal-parent (ot ~[pid+pid gid+gid])]
        [%goal-actionable (ot ~[pid+pid gid+gid])]
        [%goal-complete (ot ~[pid+pid gid+gid])]
        [%goal-active (ot ~[pid+pid gid+gid])]
        [%setting (ot ~[setting+so])]
        [%pool-tags (ot ~[pid+pid])]
        [%all-local-goal-tags ul]
        [%collections ul]
        [%collection (ot ~[path+pa])]
    ==
    ++  type
      %-  of
      :~  main+|=(jon=json ?>(?=(~ jon) ~))
          pool+pid:dejs:j
          goal+key:dejs:j
      ==
    --
  --
++  grad  %noun
--
