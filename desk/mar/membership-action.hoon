/-  *action
/+  j=gol-cli-json
|_  mem=membership-action
++  grow
  |%
  ++  noun  mem
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
