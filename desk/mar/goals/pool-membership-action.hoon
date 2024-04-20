/-  *action, p=pools
/+  goj=goals-json, poj=pools-json
|_  act=[pid pool-membership-action]
++  grow
  |%
  ++  noun  act
  --
++  grab
  |%
  ++  noun  ,[pid pool-membership-action]
  ++  json
    ^-  $-(^json [pid pool-membership-action])
    =,  dejs:format
    %-  ot
    :~  [%pid pid:dejs:goj]
        :-  %axn
        %-  of
        :~  [%kick-member (ot ~[member+(su fed:ag)])]
            [%set-pool-role (ot ~[member+(su fed:ag) role+role:dejs:goj])]
            [%update-graylist (ot ~[fields+(ar graylist-field:dejs:poj)])]
            [%update-pool-data (ot ~[fields+(ar pool-data-field:dejs:poj)])]
            [%extend-invite (ot ~[invitee+(su fed:ag)])]
            [%cancel-invite (ot ~[invitee+(su fed:ag)])]
            [%accept-request (ot ~[requester+(su fed:ag)])]
            [%reject-request (ot ~[requester+(su fed:ag)])]
            [%delete-request (ot ~[requester+(su fed:ag)])]
        ==
    ==
  --
++  grad  %noun
--
