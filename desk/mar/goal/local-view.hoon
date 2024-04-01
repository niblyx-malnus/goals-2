/-  *action
/+  j=gol-cli-json
|_  vyu=local-view
++  grow
  |%
  ++  noun  vyu
  --
++  grab
  |%
  ++  noun  local-view
  ++  json
    =,  dejs:j
    ^-  $-(json local-view)
    %-  of
    :~  [%pools-index ul]
        [%local-tag-goals (ot ~[tag+so])]
        [%local-tag-harvest (ot ~[tag+so])]
        [%local-tag-note (ot ~[tag+so])]
        [%local-goal-tags ul]
        [%local-goal-fields ul]
        [%local-blocked ul]
        [%local-pools ul]
        [%remote-pools ul]
        [%incoming-invites ul]
        [%outgoing-requests ul]
        [%setting (ot ~[setting+so])]
    ==
  --
++  grad  %noun
--

