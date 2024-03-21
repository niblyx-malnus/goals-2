/-  *action
/+  j=gol-cli-json
|_  act=membership-action
++  grow
  |%
  ++  noun  act
  --
++  grab
  |%
  ++  noun  membership-action
  ++  json
    =,  dejs:j
    ^-  $-(json membership-action)
    %-  of
    :~  [%extend-invite (ot ~[pid+pid invitee+(su fed:ag)])]
        [%cancel-invite (ot ~[pid+pid invitee+(su fed:ag)])]
    ==
  --
++  grad  %noun
--
