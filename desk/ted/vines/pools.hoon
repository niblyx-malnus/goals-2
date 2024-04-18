/-  p=pools, spider
/+  *ventio, lib=pools, sub-count
=,  strand=strand:spider
^-  thread:spider
::
=;  helper-core
::
%-  vine-thread
%-  vine:sub-count
|=  [=gowl vid=vent-id =mark =vase]
=/  m  (strand ,^vase)
^-  form:m
::
=*  hc  ~(. helper-core gowl)
::
~&  "vent to {<dap.gowl>} vine with mark {<mark>}"
?+  mark  (just-poke [our dap]:gowl mark vase) :: poke normally
  %pools-view           (handle-view:hc !<(view:p vase))
  %pools-gesture        (handle-gesture:hc !<(gesture:p vase))
  %pools-local-action   (handle-local-action:hc !<(local-action:p vase))
  %pools-pool-action    (handle-pool-action:hc !<([id:p pool-action:p] vase))
==
::
|_  =gowl
++  handle-view
  |=  vyu=view:p
  =/  m  (strand ,vase)
  ^-  form:m
  ~&  "%pools vine: receiving view {(trip -.vyu)}"
  ?-    -.vyu
      %pools
    :: return pools and public data that src.gowl isn't blacklisted from
    ::
    ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
    =/  pools-list=(list [=id:p =pool:p])
      %+  murn  ~(tap by pools)
      |=  [=id:p =pool:p]
      ?.  =(our.gowl host.id)
        ~
      [~ id pool]
    =|  discovered=(list [id:p metadata:p])
    |-
    ?~  pools-list
      %-  pure:m  !>
      %-  pairs:enjs:format
      %+  turn  discovered
      |=  [=id:p public=metadata:p]
      [(id-string:enjs:lib id) o+public]
    ;<  auto=(unit auto:p)  bind:m
      (graylist-resolution id.i.pools-list src.gowl request.vyu)
    ?:  ?=([~ %|] auto)
      $(pools-list t.pools-list)
    %=  $
      pools-list  t.pools-list
      discovered  [[id public.pool-data.pool]:i.pools-list discovered]
    ==
    ::
      %public-data
    :: return public data for the pool if src.gowl isn't blacklisted
    ::
    ?.  =(our.gowl host.id.vyu)
      (strand-fail %not-my-pool ~)
    ;<  auto=(unit auto:p)  bind:m
      (graylist-resolution id.vyu src.gowl request.vyu)
    ?:  ?=([~ %|] auto)
      (strand-fail %view-public-data-fail ~)
    ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
    (pure:m !>(o+public.pool-data:(~(got by pools) id.vyu)))
  ==
::
++  handle-gesture
  |=  ges=gesture:p
  =/  m  (strand ,vase)
  ^-  form:m
  ~&  "%pools vine: receiving gesture {(trip -.ges)}"
  ?-    -.ges
      %kick
    ?>  =(src.gowl host.id.ges)
    ;<  ~  bind:m  (delete-pool id.ges)
    (pure:m !>(~))
    ::
      %leave
    ;<  ~  bind:m  (update-members id.ges src.gowl ~)
    ;<  ~  bind:m  (kick-ship id.ges src.gowl)
    (pure:m !>(~))
    ::
      %invite
    ?>  =(src.gowl host.id.ges)
    ;<  ~  bind:m  (update-incoming-invites id.ges invite.ges)
    (pure:m !>(~))
    ::
      %invite-response
    ?>  =(our.gowl host.id.ges)
    ;<  ~  bind:m  (update-outgoing-invite-response id.ges src.gowl status.ges)
    ?~  status.ges
      (pure:m !>(~))
    ?.  response.u.status.ges
      (pure:m !>(~))
    ;<  ~  bind:m  (update-members id.ges src.gowl ~ &+~)
    (pure:m !>(~))
    ::
      %delete-invite
    ;<  ~  bind:m  (update-outgoing-invites id.ges src.gowl ~)
    (pure:m !>(~))
    ::
      %request
    ?>  =(our.gowl host.id.ges)
    ?~  request.ges
      ;<  ~  bind:m  (update-incoming-requests id.ges src.gowl ~)
      (pure:m !>(~))
    ;<  auto=(unit auto:p)  bind:m
      (graylist-resolution id.ges src.gowl u.request.ges)
    ?:  ?=([~ %|] auto)
      (strand-fail %request-fail ~)
    ;<  ~  bind:m  (update-incoming-requests id.ges src.gowl request.ges)
    ?~  auto
      (pure:m !>(~))
    ;<  ~  bind:m  (accept-request id.ges src.gowl metadata.u.auto)
    (pure:m !>(~))
    ::
      %request-response
    ?>  =(src.gowl host.id.ges)
    ;<  ~  bind:m  (update-outgoing-request-response id.ges status.ges)
    (pure:m !>(~))
    ::
      %delete-request
    ?>  =(src.gowl host.id.ges)
    ;<  ~  bind:m  (update-outgoing-requests id.ges ~)
    (pure:m !>(~))
    ::
      %watch-me
    ?>  =(src.gowl host.id.ges)
    ;<  ~  bind:m  (watch-valid-pool id.ges)
    (pure:m !>(~))
  ==
::
++  handle-local-action
  |=  act=local-action:p
  |^
  =/  m  (strand ,vase)
  ^-  form:m
  ?>  =(src our):gowl
  ~&  "%pools vine: receiving local-action {(trip -.act)}"
  ?-    -.act
      %create-pool
    =/  title=@t  (extract-pool-title pool-data-fields.act)
    ;<  =id:p  bind:m  (unique-id title)
    ;<  ~      bind:m  (create-pool id)
    ;<  ~      bind:m  (update-graylist id graylist-fields.act)
    ;<  ~      bind:m  (update-pool-data id pool-data-fields.act)
    ;<  ~      bind:m  (update-members id our.gowl ~ &+(sy ~[%host]))
    (pure:m !>(s+(id-string:enjs:lib id)))
    ::
      %delete-pool
    ;<  ~  bind:m  (delete-pool id.act)
    (pure:m !>(~))
    ::
      %leave-pool
    ?<  =(our.gowl host.id.act) :: can't leave own pool
    ;<  *  bind:m  ((soften ,~) (cancel-request id.act))
    ;<  *  bind:m  ((soften ,~) (delete-invite id.act))
    ;<  *  bind:m  ((soften ,~) (give-leave-gesture id.act))
    ;<  ~  bind:m  (delete-pool id.act)
    (pure:m !>(~))
    ::
      %watch-pool
    ;<  ~  bind:m  (watch-valid-pool id.act)
    (pure:m !>(~))
    ::
      %update-blocked
    ;<  ~  bind:m
      (handle-transition ;;(transition:p act))
    (pure:m !>(~))
    ::
      %extend-request
    ?<  =(our.gowl host.id.act)
    ;<  ~  bind:m  (update-outgoing-requests id.act ~ request.act)
    ;<  ges=(each ~ goof)  bind:m
      ((soften ,~) (give-request-gesture [id ~ request]:act))
    :: cancel failed request
    ::
    ?:  ?=(%& -.ges)
      (pure:m !>(~))
    ;<  ~  bind:m  (cancel-request id.act)
    (pure:m !>(~))
    ::
      %cancel-request
    ;<  *  bind:m  ((soften ,~) (give-request-gesture [id ~]:act))
    ;<  ~  bind:m  (update-outgoing-requests id.act ~)
    (pure:m !>(~))
    ::
      %accept-invite
    ;<  ~  bind:m  (give-invite-response-gesture id.act [~ & metadata.act])
    ;<  ~  bind:m  (update-incoming-invite-response id.act [~ & metadata.act])
    ;<  ~  bind:m  (watch-valid-pool id.act)
    (pure:m !>(~))
    ::
      %reject-invite
    ;<  ~  bind:m  (give-invite-response-gesture id.act [~ | metadata.act])
    ;<  ~  bind:m  (update-incoming-invite-response id.act [~ | metadata.act])
    (pure:m !>(~))
    ::
      %delete-invite
    ;<  *  bind:m  ((soften ,~) (give-delete-invite-gesture id.act))
    ;<  ~  bind:m  (update-incoming-invites id.act ~)
    (pure:m !>(~))
  ==
  ::
  ++  handle-transition
    |=  =transition:p
    =/  m  (strand ,~)
    ^-  form:m
    %+  poke  [our.gowl %pools]
    pools-transition+!>(transition)
  --
::
++  handle-pool-action
  |=  [=id:p act=pool-action:p]
  |^
  =/  m  (strand ,vase)
  ^-  form:m
  ?>  =(src our):gowl
  ?>  =(our.gowl host.id)
  ~&  "%pools vine: receiving pool-action {(trip -.act)}"
  ?-    -.act
      %kick-member
    ?>  =(our.gowl host.id)
    ?<  =(our.gowl member.act) :: can't kick self as host
    ;<  ~  bind:m  (kick-ship id member.act)
    ;<  *  bind:m  ((soften ,~) (cancel-invite id member.act))
    ;<  *  bind:m  ((soften ,~) (delete-request id member.act))
    ;<  *  bind:m  ((soften ,~) (give-kick-gesture id member.act))
    ;<  ~  bind:m  (update-members id member.act ~)
    (pure:m !>(~))
    ::
      %kick-blacklisted
    ?>  =(our.gowl host.id)
    ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
    =/  =pool:p  (~(got by pools) id)
    ;<  [* sup=bitt:gall]  bind:m
      (scry-hard ,[* bitt:gall] /gx/pools/vent/subscriptions/noun)
    =/  subs=(list [=ship =path])  ~(val by sup)
    |-
    ?~  subs
      (pure:m !>(~))
    ?.  =([~ id] (mole |.((de-pool-path:lib path.i.subs))))
      $(subs t.subs)
    =/  =metadata:p  (~(gut by requests.act) ship.i.subs ~)
    ;<  auto=(unit auto:p)  bind:m
      (graylist-resolution id ship.i.subs metadata)
    ?.  |(?=([~ %|] auto) !(~(has by members.pool) ship.i.subs))
      $(subs t.subs)
    ;<  ~  bind:m  (kick-member id ship.i.subs)
    $(subs t.subs)
    ::
      %update-graylist
    ;<  ~  bind:m
      (handle-pool-transition ;;(pool-transition:p act))
    ;<  ~  bind:m  (kick-blacklisted id ~)
    (pure:m !>(~))
    ::
      %update-pool-data
    ;<  ~  bind:m
      (handle-pool-transition ;;(pool-transition:p act))
    (pure:m !>(~))
    ::
      %extend-invite
    ?>  =(our.gowl host.id)
    ?<  =(our.gowl invitee.act)
    ;<  ~  bind:m  (update-outgoing-invites id invitee.act ~ invite.act)
    ;<  ges=(each ~ goof)  bind:m
      ((soften ,~) (give-invite-gesture id [invitee ~ invite]:act))
    :: cancel failed invite
    ::
    ?:  ?=(%& -.ges)
      (pure:m !>(~))
    ;<  ~  bind:m  (cancel-invite id invitee.act)
    (pure:m !>(~))
    ::
      %cancel-invite
    ?>  =(our.gowl host.id)
    ;<  *  bind:m  ((soften ,~) (give-invite-gesture id invitee.act ~))
    ;<  ~  bind:m  (update-outgoing-invites id invitee.act ~)
    (pure:m !>(~))
    ::
      %accept-request
    ?>  =(our.gowl host.id)
    ;<  ~  bind:m  (give-request-response-gesture id requester.act [~ & metadata.act])
    ;<  *  bind:m  ((soften ,~) (give-watch-me-gesture id requester.act))
    ;<  ~  bind:m  (update-incoming-request-response id requester.act [~ & metadata.act])
    ;<  ~  bind:m  (update-members id requester.act ~ &+~)
    (pure:m !>(~))
    ::
      %reject-request
    ?>  =(our.gowl host.id)
    ;<  ~  bind:m  (give-request-response-gesture id requester.act [~ | metadata.act])
    ;<  ~  bind:m  (update-incoming-request-response id requester.act [~ | metadata.act])
    (pure:m !>(~))
    ::
      %delete-request
    ?>  =(our.gowl host.id)
    ;<  *  bind:m  ((soften ,~) (give-delete-request-gesture id requester.act))
    ;<  ~  bind:m  (update-incoming-requests id requester.act ~)
    (pure:m !>(~))
  ==
  ::
  ++  handle-pool-transition
    |=  =pool-transition:p
    =/  m  (strand ,~)
    ^-  form:m
    %+  poke  [our.gowl %pools]
    :-  %pools-transition  !>
    ^-  transition:p
    [%update-pool id pool-transition]
  --
::
++  unique-id
  |=  name=@t
  =/  m  (strand ,id:p)
  ^-  form:m
  ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
  |^  (pure:m (uniquify (tasify name)))
  ++  uniquify
    |=  =term
    ^-  id:p
    ?.  (~(has by pools) [our.gowl term])
      [our.gowl term]
    =/  num=@t  (numb (end 4 eny.gowl))
    $(term (rap 3 term '-' num ~)) :: add random number to end
  ++  numb :: from numb:enjs:format
    |=  a=@u
    ?:  =(0 a)  '0'
    %-  crip
    %-  flop
    |-  ^-  ^tape
    ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))])
  ++  tasify
    |=  name=@t
    ^-  term
    =/  =tape
      %+  turn  (cass (trip name))
      |=(=@t `@t`?~(c=(rush t ;~(pose nud low)) '-' u.c))
    =/  =term
      ?~  tape  %$
      ?^  f=(rush i.tape low)
        (crip tape)
      (crip ['x' '-' tape])
    ?>(((sane %tas) term) term)
  --
::
++  extract-pool-title
  =/  title=@t  'New Pool'
  |=  fields=(list pool-data-field:p)
  ^-  @t
  ?~  fields
    title
  ?.  ?=(%public -.i.fields)
    $(fields t.fields)
  |-
  ?~  p.i.fields
    title
  =/  [key=@t val=(unit json)]  i.p.i.fields
  ?:  =(key 'title')
    ?~  val
      title
    (fall (so:dejs-soft:format u.val) title)
  $(p.i.fields t.p.i.fields)
::
++  graylist-resolution
  |=  [=id:p requester=ship =request:p]
  =/  m  (strand ,(unit auto:p))
  ^-  form:m
  ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
  =/  =graylist:p  graylist:(~(got by pools) id)
  ?~  dude.graylist
    :: if we don't delegate to an agent, defer to local graylist
    ::
    (local-graylist graylist requester)
  :: try to delegate white/blacklisting to an agent
  ::
  ;<  p=(each auto=(unit auto:p) goof)  bind:m
    %-  (soften ,(unit auto:p))
    (delegate-graylist u.dude.graylist id requester request)
  ?:  ?=(%& -.p)
    (pure:m p.p)
  :: if delegation failed, defer to local graylist
  ::
  (local-graylist graylist requester)
::
++  local-graylist
  |=  [=graylist:p requester=ship]
  =/  m  (strand ,(unit auto:p))
  ^-  form:m
  %-  pure:m
  ?^  auto=(~(get by ship.graylist) requester)  auto
  ?^  auto=(~(get by rank.graylist) (clan:title requester))  auto
  rest.graylist
::
++  watch-valid-pool
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  ;<  =incoming-invites:p   bind:m  (scry-hard ,incoming-invites:p /gx/pools/incoming-invites/noun)
  ;<  =outgoing-requests:p  bind:m  (scry-hard ,outgoing-requests:p /gx/pools/outgoing-requests/noun)
  =/  [* istat=status:p]  (~(gut by incoming-invites) id [~ ~])
  =/  [* rstat=status:p]  (~(gut by outgoing-requests) id [~ ~])
  ?>  |(?=([~ %& *] istat) ?=([~ %& *] rstat))
  %:  agent-watch-path
    %pools
    /pool/(scot %p host.id)/[name.id]
    [host.id %pools]
    /pool/(scot %p host.id)/[name.id]
  ==
::
++  kick-ship
  |=  [=id:p =ship]
  =/  m  (strand ,~)
  ^-  form:m
  (agent-kick-ship dap.gowl ~[(en-pool-path:lib id)] ~ ship)
::
++  kick-ships
  |=  [=id:p ships=(list ship)]
  =/  m  (strand ,~)
  ^-  form:m
  (agent-kick-ships dap.gowl ~[(en-pool-path:lib id)] ships)
::
++  create-pool
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  [%create-pool id]
::
++  delete-pool
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  [%delete-pool id]
::
++  update-graylist
  |=  [=id:p fields=(list graylist-field:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-graylist fields]
::
++  update-pool-data
  |=  [=id:p fields=(list pool-data-field:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-pool-data fields]
::
++  update-members
  |=  [=id:p member=ship roles=(unit (each roles:p roles:p))]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-members member roles]
::
++  update-outgoing-invites
  |=  [=id:p invitee=ship invite=(unit invite:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-outgoing-invites invitee invite]
::
++  update-outgoing-invite-response
  |=  [=id:p invitee=ship =status:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-outgoing-invite-response invitee status]
::
++  update-incoming-requests
  |=  [=id:p requester=ship request=(unit request:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-incoming-requests requester request]
::
++  update-incoming-request-response
  |=  [=id:p requester=ship =status:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-incoming-request-response requester status]
::
++  update-incoming-invites
  |=  [=id:p invite=(unit invite:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  [%update-incoming-invites id invite]
::
++  update-incoming-invite-response
  |=  [=id:p =status:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  [%update-incoming-invite-response id status]
::
++  update-outgoing-requests
  |=  [=id:p request=(unit request:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  [%update-outgoing-requests id request]
::
++  update-outgoing-request-response
  |=  [=id:p =status:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  [%update-outgoing-request-response id status]
::
++  timeout  ~s15
::
++  give-kick-gesture
  |=  [=id:p member=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [member dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%kick id]
::
++  give-leave-gesture
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [host.id dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%leave id]
::
++  give-invite-gesture
  |=  [=id:p invitee=ship invite=(unit invite:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [invitee dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%invite id invite]
::
++  give-invite-response-gesture
  |=  [=id:p =status:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [host.id dap.gowl]
   :-  %pools-gesture
  ^-  gesture:p
  [%invite-response id status]
::
++  give-delete-invite-gesture
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [host.id dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%delete-invite id]
::
++  give-request-gesture
  |=  [=id:p request=(unit request:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [host.id dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%request id request]
::
++  give-request-response-gesture
  |=  [=id:p requester=ship =status:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [requester dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%request-response id status]
::
++  give-delete-request-gesture
  |=  [=id:p requester=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [requester dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%delete-request id]
::
++  give-watch-me-gesture
  |=  [=id:p member=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [member dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%watch-me id]
::
++  kick-member
  |=  [=id:p member=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%kick-member member]
::
++  kick-blacklisted
  |=  [=id:p requests=(map ship request:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%kick-blacklisted requests]
::
++  accept-request
  |=  [=id:p requester=ship =metadata:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%accept-request requester metadata]
::
++  reject-request
  |=  [=id:p requester=ship =metadata:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%reject-request requester metadata]
::
++  cancel-invite
  |=  [=id:p invitee=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%cancel-invite invitee]
::
++  delete-invite
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %pools-local-action
  ^-  local-action:p
  [%delete-invite id]
::
++  cancel-request
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %pools-local-action
  ^-  local-action:p
  [%cancel-request id]
::
++  delete-request
  |=  [=id:p requester=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%delete-request requester]
::
++  delegate-graylist
  |=  [=dude:gall =id:p requester=ship =request:p]
  =/  m  (strand ,(unit auto:p))
  ^-  form:m
  %+  (vent ,(unit auto:p))
    [our.gowl dude]
  :-  %pools-delegation
  ^-  delegation:p
  [%graylist id requester request]
--
