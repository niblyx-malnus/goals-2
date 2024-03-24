/-  *pools
|_  [=bowl:gall cards=(list card:agent:gall) state-0]
+*  this   .
    state  +<+>
+$  card   card:agent:gall
++  abet   [(flop cards) state]
++  emit   |=(=card this(cards [card cards]))
++  emil   |=(cadz=(list card) this(cards (weld cadz cards)))
++  handle-transition
  |=  tan=transition
  ^-  _this
  :: only we can directly modify our agent state
  ::
  ?>  =(src our):bowl
  ?-    -.tan
      %update-blocked
    ?-    -.p.tan
        %&
      %=  this
        pools.blocked  (~(uni in pools.blocked) pools.p.p.tan)
        hosts.blocked  (~(uni in hosts.blocked) hosts.p.p.tan)
        peers.blocked  (~(uni in peers.blocked) peers.p.p.tan)
      ==
      ::
        %|
      %=  this
        pools.blocked  (~(dif in pools.blocked) pools.p.p.tan)
        hosts.blocked  (~(dif in hosts.blocked) hosts.p.p.tan)
        peers.blocked  (~(dif in peers.blocked) peers.p.p.tan)
      ==
    ==
    ::
      %update-incoming-invites
    ?~  invite.tan
      :: if invite is null, delete invite
      ::
      this(incoming-invites (~(del by incoming-invites) id.tan))
    :: cannot invite if blocked
    ::
    ?<  (~(has in pools.blocked) id.tan)
    ?<  (~(has in hosts.blocked) host.id.tan)
    :: the status of the current invite status must be undecided
    ::
    =/  [* =status]  (~(gut by incoming-invites) id.tan [~ ~])
    ?>  ?=(~ status)
    %=    this
        incoming-invites
      %+  ~(put by incoming-invites)
        id.tan
      [u.invite.tan ~]
    ==
    ::
      %update-outgoing-requests
    ?~  request.tan
      :: if request is null, delete request
      ::
      this(outgoing-requests (~(del by outgoing-requests) id.tan))
    :: the status of the current request status must be undecided
    ::
    =/  [* =status]  (~(gut by outgoing-requests) id.tan [~ ~])
    ?>  ?=(~ status)
    %=    this
        outgoing-requests
      %+  ~(put by outgoing-requests)
        id.tan
      [u.request.tan ~]
    ==
    ::
      %update-incoming-invite-response
    =/  [=invite *]  (~(got by incoming-invites) id.tan)
    %=    this
        incoming-invites
      %+  ~(put by incoming-invites)
        id.tan
      [invite status.tan]
    ==
    ::
      %update-outgoing-request-response
    =/  [=request *]  (~(got by outgoing-requests) id.tan)
    %=    this
        outgoing-requests
      %+  ~(put by outgoing-requests)
        id.tan
      [request status.tan]
    ==
    ::
      %create-pool
    :: we must be the host of the given pool
    ::
    ?>  =(our.bowl host.id.tan)
    this(pools (~(put by pools) id.tan *pool))
    ::
      %delete-pool
    :: we must be the host of the given pool
    ::
    ?>  =(our.bowl host.id.tan)
    this(pools (~(del by pools) id.tan))
    ::
      %update-pool
    :: we must be the host of the given pool
    ::
    ?>  =(our.bowl host.id.tan)
    =/  old=pool  (~(got by pools) id.tan)
    =/  pan=pool-transition  p.tan
    =;  new=pool
      this(pools (~(put by pools) id.tan new))
    ?-    -.pan
        %update-members
      ?~  roles.pan
        old(members (~(del by members.old) member.pan))
      ?-    -.u.roles.pan
          %&
        =/  =roles  (~(gut by members.old) member.pan ~)
        %=    old
            members
          %+  ~(put by members.old)
            member.pan
          (~(uni in roles) p.u.roles.pan)
        ==
        ::
          %|
        =/  =roles  (~(gut by members.old) member.pan ~)
        %=    old
            members
          %+  ~(put by members.old)
            member.pan
          (~(dif in roles) p.u.roles.pan)
        ==
      ==
      ::
        %update-outgoing-invites
      ?~  invite.pan
        :: if invite is null, delete invite
        ::
        old(outgoing-invites (~(del by outgoing-invites.old) invitee.pan))
      :: the status of the current invite status must be undecided
      ::
      =/  [* =status]  (~(gut by outgoing-invites.old) invitee.pan [~ ~])
      ?>  ?=(~ status)
      %=    old
          outgoing-invites
        %+  ~(put by outgoing-invites.old)
          invitee.pan
        [u.invite.pan ~]
      ==
      ::
        %update-incoming-requests
      ?~  request.pan
        :: if request is null, delete request
        ::
        old(incoming-requests (~(del by incoming-requests.old) requester.pan))
      :: the status of the current request status must be undecided
      ::
      =/  [* =status]  (~(gut by incoming-requests.old) requester.pan [~ ~])
      ?>  ?=(~ status)
      %=    old
          incoming-requests
        %+  ~(put by incoming-requests.old)
          requester.pan
        [u.request.pan ~]
      ==
      ::
        %update-outgoing-invite-response
      ~&  invitee+invitee.pan
      =/  [=invite *]  (~(got by outgoing-invites.old) invitee.pan)
      %=    old
          outgoing-invites
        %+  ~(put by outgoing-invites.old)
          invitee.pan
        [invite status.pan]
      ==
      ::
        %update-incoming-request-response
      =/  [=request *]  (~(got by incoming-requests.old) requester.pan)
      %=    old
          incoming-requests
        %+  ~(put by incoming-requests.old)
          requester.pan
        [request status.pan]
      ==
      ::
        %update-graylist
      |-
      ?~  fields.pan
        old
      ?-    -.i.fields.pan
        %dude  old(dude.graylist p.i.fields.pan)
        %rest  old(rest.graylist p.i.fields.pan)
        ::
          %ship
        |-
        ?~  p.i.fields.pan
          ^$(fields.pan t.fields.pan)
        =/  [=ship auto=(unit auto)]  i.p.i.fields.pan
        ?~  auto
          %=  $
            p.i.fields.pan     t.p.i.fields.pan
            ship.graylist.old  (~(del by ship.graylist.old) ship)
          ==
        %=  $
          p.i.fields.pan     t.p.i.fields.pan
          ship.graylist.old  (~(put by ship.graylist.old) ship u.auto)
        ==
        ::
          %rank
        |-
        ?~  p.i.fields.pan
          ^$(fields.pan t.fields.pan)
        =/  [=rank auto=(unit auto)]  i.p.i.fields.pan
        ?~  auto
          %=  $
            p.i.fields.pan     t.p.i.fields.pan
            rank.graylist.old  (~(del by rank.graylist.old) rank)
          ==
        %=  $
          p.i.fields.pan     t.p.i.fields.pan
          rank.graylist.old  (~(put by rank.graylist.old) rank u.auto)
        ==
      ==
      ::
        %update-pool-data
      |-
      ?~  fields.pan
        old
      ?-    -.i.fields.pan
          %private
        |-
        ?~  p.i.fields.pan
          ^$(fields.pan t.fields.pan)
        =/  [key=@t val=(unit json)]  i.p.i.fields.pan
        ?~  val
          %=  $
            p.i.fields.pan         t.p.i.fields.pan
            private.pool-data.old  (~(del by private.pool-data.old) key)
          ==
        %=  $
          p.i.fields.pan         t.p.i.fields.pan
          private.pool-data.old  (~(put by private.pool-data.old) key u.val)
        ==
        ::
          %public
        |-
        ?~  p.i.fields.pan
          ^$(fields.pan t.fields.pan)
        =/  [key=@t val=(unit json)]  i.p.i.fields.pan
        ?~  val
          %=  $
            p.i.fields.pan        t.p.i.fields.pan
            public.pool-data.old  (~(del by public.pool-data.old) key)
          ==
        %=  $
          p.i.fields.pan        t.p.i.fields.pan
          public.pool-data.old  (~(put by public.pool-data.old) key u.val)
        ==
      ==
    ==
  ==
::
++  enjs
  =,  enjs:format
  |%
  ++  id-string  |=(=id (rap 3 '/' (scot %p host.id) '/' name.id ~))
  ++  auto
    |=  =^auto
    ^-  json
    ?@  auto
      (pairs ~[response+b/|])
    %-  pairs
    :~  [%response b+&]
        [%metadata o+metadata.auto]
    ==
  --
::
++  dejs
  =,  dejs:format
  |%
  ++  id
    %+  cu
      |=  (pole knot)
      ?>  ?=([host=@ta name=@ta ~] +<)
      [(slav %p host) name]
    pa
  ++  action
    |=  jon=json
    ^-  ^action
    :: %.  jon
    :: %-  of
    :: :~
    :: ==
    *^action
  --
--
