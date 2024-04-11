/-  *action
/+  j=gol-cli-json
|_  act=local-membership-action
++  grow
  |%
  ++  noun  act
  --
++  grab
  |%
  ++  noun  local-membership-action
  ++  json
    =<
    ::
    =,  dejs:j
    ^-  $-(json local-membership-action)
    %-  of
    :~  [%watch-pool (ot ~[pid+pid])]
        [%leave-pool (ot ~[pid+pid])]
        [%extend-request (ot ~[pid+pid])]
        [%cancel-request (ot ~[pid+pid])]
        [%accept-invite (ot ~[pid+pid])]
        [%reject-invite (ot ~[pid+pid])]
        [%delete-invite (ot ~[pid+pid])]
        [%update-blocked ud-blocked]
    ==
    ::
    |%
    ++  ud-blocked
      =,  dejs:j
      %+  (ud blocked:p blocked:p)
        (ot ~[pools+(as pid) hosts+(as (su fed:ag))])
      (ot ~[pools+(as pid) hosts+(as (su fed:ag))])
    --
  --
++  grad  %noun
--
