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
    =<
    ::
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
        [%update-blocked ud-blocked]
        [%update-graylist (ot ~[pid+pid fields+(ar graylist-field)])]
    ==
    ::
    |%
    ++  ud-blocked
      =,  dejs:j
      %+  (ud blocked:p blocked:p)
        (ot ~[pools+(as pid) hosts+(as (su fed:ag))])
      (ot ~[pools+(as pid) hosts+(as (su fed:ag))])
    ::
    ++  graylist-field
      =,  dejs:j
      |=  jon=json
      ^-  graylist-field:p
      %.  jon
      %-  of
      :~  [%ship (ar (ot ~[ship+(su fed:ag) auto+unit-auto]))]
          [%rank (ar (ot ~[rank+rank auto+unit-auto]))]
          [%rest unit-auto]
          [%dude |=(jon=json ?~(jon ~ [~ (so jon)]))]
      ==
    ::
    ++  rank  |=(jon=^json ;;(rank:title (so:dejs:format jon)))
    ::
    ++  unit-auto
      =,  dejs:j
      |=  jon=json
      ^-  (unit auto:p)
      ?~  jon
        ~
      ?.  (bo:dejs:format jon)
        [~ %|]
      [~ %& ~]
    --
  --
++  grad  %noun
--
