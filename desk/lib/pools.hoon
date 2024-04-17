/-  p=pools
/+  u=json-utils
|_  [=bowl:gall cards=(list card:agent:gall) state-0:p]
+*  this   .
    state  +<+>
+$  card   card:agent:gall
++  abet   [(flop cards) state]
++  emit   |=(=card this(cards [card cards]))
++  emil   |=(cadz=(list card) this(cards (weld cadz cards)))
::
++  en-pool-path  |=(=id:p `path`/pool/(scot %p host.id)/[name.id])
++  de-pool-path
  |=  =path
  ^-  id:p
  =+  ;;([%pool host=@ta name=@ta ~] path)
  [(slav %p host) name]
::
++  handle-transition
  |=  tan=transition:p
  ^-  _this
  =.  this  (emit %give %fact ~[/transitions] pools-transition+!>(tan))
  ?-    -.tan
      %update-blocked
    ?-    -.p.tan
        %&
      ?<  (~(has in hosts.p.p.tan) our.bowl)
      ?<  (~(has in `(set ship)`(~(run in pools.p.p.tan) head)) our.bowl)
      %=  this
        pools.blocked  (~(uni in pools.blocked) pools.p.p.tan)
        hosts.blocked  (~(uni in hosts.blocked) hosts.p.p.tan)
      ==
      ::
        %|
      %=  this
        pools.blocked  (~(dif in pools.blocked) pools.p.p.tan)
        hosts.blocked  (~(dif in hosts.blocked) hosts.p.p.tan)
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
    =/  [* =status:p]  (~(gut by incoming-invites) id.tan [~ ~])
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
    =/  [* =status:p]  (~(gut by outgoing-requests) id.tan [~ ~])
    ?>  ?=(~ status)
    %=    this
        outgoing-requests
      %+  ~(put by outgoing-requests)
        id.tan
      [u.request.tan ~]
    ==
    ::
      %update-incoming-invite-response
    =/  [=invite:p *]  (~(got by incoming-invites) id.tan)
    %=    this
        incoming-invites
      %+  ~(put by incoming-invites)
        id.tan
      [invite status.tan]
    ==
    ::
      %update-outgoing-request-response
    =/  [=request:p *]  (~(got by outgoing-requests) id.tan)
    %=    this
        outgoing-requests
      %+  ~(put by outgoing-requests)
        id.tan
      [request status.tan]
    ==
    ::
      %create-pool
    ?>  =(our.bowl host.id.tan)
    this(pools (~(put by pools) id.tan *pool:p))
    ::
      %delete-pool
    this(pools (~(del by pools) id.tan))
    ::
      %update-pool
    =.  this  (handle-pool-transition [id p]:tan)
    ?.  =(our.bowl host.id.tan)
      this
    (emit %give %fact ~[(en-pool-path id.tan)] pools-pool-transition+!>(p.tan))
  ==
::
++  handle-pool-transition
  |=  [=id:p tan=pool-transition:p]
  ^-  _this
  =/  old=pool:p  (~(gut by pools) id *pool:p)
  =;  new=pool:p
    this(pools (~(put by pools) id new))
  ?-    -.tan
    %init-pool  pool.tan
    ::
      %update-members
    ?~  roles.tan
      old(members (~(del by members.old) member.tan))
    ?-    -.u.roles.tan
        %&
      =/  =roles:p  (~(gut by members.old) member.tan ~)
      %=    old
          members
        %+  ~(put by members.old)
          member.tan
        (~(uni in roles) p.u.roles.tan)
      ==
      ::
        %|
      =/  =roles:p  (~(gut by members.old) member.tan ~)
      %=    old
          members
        %+  ~(put by members.old)
          member.tan
        (~(dif in roles) p.u.roles.tan)
      ==
    ==
    ::
      %update-outgoing-invites
    ?~  invite.tan
      :: if invite is null, delete invite
      ::
      old(outgoing-invites (~(del by outgoing-invites.old) invitee.tan))
    :: the status of the current invite status must be undecided
    ::
    =/  [* =status:p]  (~(gut by outgoing-invites.old) invitee.tan [~ ~])
    ?>  ?=(~ status)
    %=    old
        outgoing-invites
      %+  ~(put by outgoing-invites.old)
        invitee.tan
      [u.invite.tan ~]
    ==
    ::
      %update-incoming-requests
    ?~  request.tan
      :: if request is null, delete request
      ::
      old(incoming-requests (~(del by incoming-requests.old) requester.tan))
    :: the status of the current request status must be undecided
    ::
    =/  [* =status:p]  (~(gut by incoming-requests.old) requester.tan [~ ~])
    ?>  ?=(~ status)
    %=    old
        incoming-requests
      %+  ~(put by incoming-requests.old)
        requester.tan
      [u.request.tan ~]
    ==
    ::
      %update-outgoing-invite-response
    ~&  invitee+invitee.tan
    =/  [=invite:p *]  (~(got by outgoing-invites.old) invitee.tan)
    %=    old
        outgoing-invites
      %+  ~(put by outgoing-invites.old)
        invitee.tan
      [invite status.tan]
    ==
    ::
      %update-incoming-request-response
    =/  [=request:p *]  (~(got by incoming-requests.old) requester.tan)
    %=    old
        incoming-requests
      %+  ~(put by incoming-requests.old)
        requester.tan
      [request status.tan]
    ==
    ::
      %update-graylist
    |-
    ?~  fields.tan
      old
    ?-    -.i.fields.tan
      %dude  old(dude.graylist p.i.fields.tan)
      %rest  old(rest.graylist p.i.fields.tan)
      ::
        %ship
      |-
      ?~  p.i.fields.tan
        ^$(fields.tan t.fields.tan)
      =/  [=ship auto=(unit auto:p)]  i.p.i.fields.tan
      ?~  auto
        %=  $
          p.i.fields.tan     t.p.i.fields.tan
          ship.graylist.old  (~(del by ship.graylist.old) ship)
        ==
      %=  $
        p.i.fields.tan     t.p.i.fields.tan
        ship.graylist.old  (~(put by ship.graylist.old) ship u.auto)
      ==
      ::
        %rank
      |-
      ?~  p.i.fields.tan
        ^$(fields.tan t.fields.tan)
      =/  [=rank:p auto=(unit auto:p)]  i.p.i.fields.tan
      ?~  auto
        %=  $
          p.i.fields.tan     t.p.i.fields.tan
          rank.graylist.old  (~(del by rank.graylist.old) rank)
        ==
      %=  $
        p.i.fields.tan     t.p.i.fields.tan
        rank.graylist.old  (~(put by rank.graylist.old) rank u.auto)
      ==
    ==
    ::
      %update-pool-data
    |-
    ?~  fields.tan
      old
    ?-    -.i.fields.tan
        %private
      |-
      ?~  p.i.fields.tan
        ^$(fields.tan t.fields.tan)
      =/  [key=@t val=(unit json)]  i.p.i.fields.tan
      ?~  val
        %=  $
          p.i.fields.tan         t.p.i.fields.tan
          private.pool-data.old  (~(del by private.pool-data.old) key)
        ==
      %=  $
        p.i.fields.tan         t.p.i.fields.tan
        private.pool-data.old  (~(put by private.pool-data.old) key u.val)
      ==
      ::
        %public
      |-
      ?~  p.i.fields.tan
        ^$(fields.tan t.fields.tan)
      =/  [key=@t val=(unit json)]  i.p.i.fields.tan
      ?~  val
        %=  $
          p.i.fields.tan        t.p.i.fields.tan
          public.pool-data.old  (~(del by public.pool-data.old) key)
        ==
      %=  $
        p.i.fields.tan        t.p.i.fields.tan
        public.pool-data.old  (~(put by public.pool-data.old) key u.val)
      ==
    ==
  ==
::
++  enjs
  =,  enjs:format
  |%
  ++  id-string  |=(=id:p (rap 3 '/' (scot %p host.id) '/' name.id ~))
  ++  auto
    |=  =auto:p
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
  ++  ship  (su fed:ag)
  ++  id-string  ;~(pfix fas ;~((glue fas) ;~(pfix sig fed:ag) sym))
  ++  id         (su id-string)
  ++  metadata
    |=  jon=json
    ^-  metadata:p
    ?>  ?=(%o -.jon)
    p.jon
  ::
  ++  invite   metadata
  ++  request  metadata
  ::
  ++  blocked
    |=  jon=json
    ^-  blocked:p
    *blocked:p
  ::
  ++  graylist-field
    |=  jon=json
    ^-  graylist-field:p
    *graylist-field:p
  ::
  ++  pool-data-field
    |=  jon=json
    ^-  pool-data-field:p
    *pool-data-field:p
  ::
  ++  ud-blocked
    %+  ((each-method:dejs:u %uni %dif) blocked:p blocked:p)
      (ot ~[p+blocked])
    (ot ~[p+blocked])
  ::
  ++  local-action
    ^-  $-(json local-action:p)
    %-  of
    :~  [%create-pool (ot ~[graylist-fields+(ar graylist-field) pool-data-fields+(ar pool-data-field)])]
        [%delete-pool (ot ~[id+id])]
        [%leave-pool (ot ~[id+id])]
        [%watch-pool (ot ~[id+id])]
        [%update-blocked (ot ~[p+ud-blocked])] :: %&: uni; %|: dif
        [%extend-request (ot ~[id+id request+request])]
        [%cancel-request (ot ~[id+id])]
        [%accept-invite (ot ~[id+id metadata+metadata])]
        [%reject-invite (ot ~[id+id metadata+metadata])]
        [%delete-invite (ot ~[id+id])]
    ==
  ::
  ++  pool-action
    ^-  $-(json pool-action:p)
    %-  of
    :~  [%kick-member (ot ~[member+ship])]
        [%kick-blacklisted (ot ~[requests+(op fed:ag request)])]
        [%update-graylist (ot ~[fields+(ar graylist-field)])]
        [%update-pool-data (ot ~[fields+(ar pool-data-field)])]
        [%extend-invite (ot ~[invitee+ship invite+invite])]
        [%cancel-invite (ot ~[invitee+ship])]
        [%accept-request (ot ~[requester+ship metadata+metadata])]
        [%reject-request (ot ~[requester+ship metadata+metadata])]
        [%delete-request (ot ~[requester+ship])]
    ==
  ::
  ++  view
    ^-  $-(json view:p)
    %-  of
    :~  [%pools (ot ~[request+request])]
        [%public-data (ot ~[id+id request+request])]
    ==
  --
--
