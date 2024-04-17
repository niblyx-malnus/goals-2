/-  *action, p=pools
/+  j=goals-json
|_  act=[pid pool-membership-action]
++  grow
  |%
  ++  noun  act
  --
++  grab
  |%
  ++  noun  ,[pid pool-membership-action]
  ++  json
    =<
    ::
    ^-  $-(^json [pid pool-membership-action])
    =,  dejs:format
    %-  ot
    :~  [%pid pid:dejs:j]
        :-  %axn
        %-  of
        :~  [%kick-member (ot ~[member+(su fed:ag)])]
            [%set-pool-role (ot ~[member+(su fed:ag) role+role:dejs:j])]
            [%update-graylist (ot ~[fields+(ar graylist-field)])]
            [%extend-invite (ot ~[invitee+(su fed:ag)])]
            [%cancel-invite (ot ~[invitee+(su fed:ag)])]
            [%accept-request (ot ~[requester+(su fed:ag)])]
            [%reject-request (ot ~[requester+(su fed:ag)])]
            [%delete-request (ot ~[requester+(su fed:ag)])]
        ==
    ==
    ::
    |%
    ++  graylist-field
      |=  jon=^json
      ^-  graylist-field:p
      =,  dejs:format
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
      |=  jon=^json
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
