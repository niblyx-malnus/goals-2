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
    :~  [%send-invite (ot ~[invitee+(su fed:ag) pid+pid])]
    ==
  --
++  grad  %noun
--
