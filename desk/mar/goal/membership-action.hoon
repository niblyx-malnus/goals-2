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
    :~  [%kick-member (ot ~[pid+pid member+(su fed:ag)])]
        [%leave-pool (ot ~[pid+pid])]
        [%extend-invite (ot ~[pid+pid invitee+(su fed:ag)])]
        [%cancel-invite (ot ~[pid+pid invitee+(su fed:ag)])]
        [%accept-invite (ot ~[pid+pid])]
        [%reject-invite (ot ~[pid+pid])]
        [%delete-invite (ot ~[pid+pid])]
        [%extend-request (ot ~[pid+pid])]
        [%cancel-request (ot ~[pid+pid])]
        [%accept-request (ot ~[pid+pid requester+(su fed:ag)])]
        [%reject-request (ot ~[pid+pid requester+(su fed:ag)])]
        [%delete-request (ot ~[pid+pid requester+(su fed:ag)])]
    ==
  --
++  grad  %noun
--
