/-  p=pools, spider
/+  *ventio, lib=pools, j=pools-json, pools-api, sub-count
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
+*  pap  ~(. pools-api gowl)
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
      [(id-string:enjs:j id) o+(filter-metadata filter.vyu public)]
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
    %-  pure:m  !>
    :-  %o
    %+  filter-metadata  filter.vyu
    public.pool-data:(~(got by pools) id.vyu)
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
    ;<  ~  bind:m  (delete-pool:pap id.ges)
    (pure:m !>(~))
    ::
      %leave
    ;<  ~  bind:m  (update-members:pap id.ges src.gowl ~)
    ;<  ~  bind:m  (kick-ship id.ges src.gowl)
    (pure:m !>(~))
    ::
      %invite
    ?>  =(src.gowl host.id.ges)
    ;<  ~  bind:m  (update-incoming-invites:pap id.ges invite.ges)
    (pure:m !>(~))
    ::
      %invite-response
    ?>  =(our.gowl host.id.ges)
    ;<  ~  bind:m  (update-outgoing-invite-response:pap id.ges src.gowl status.ges)
    ?~  status.ges
      (pure:m !>(~))
    ?.  response.u.status.ges
      (pure:m !>(~))
    ;<  ~  bind:m  (update-members:pap id.ges src.gowl ~ &+~)
    (pure:m !>(~))
    ::
      %delete-invite
    ;<  ~  bind:m  (update-outgoing-invites:pap id.ges src.gowl ~)
    (pure:m !>(~))
    ::
      %request
    ?>  =(our.gowl host.id.ges)
    ?~  request.ges
      ;<  ~  bind:m  (update-incoming-requests:pap id.ges src.gowl ~)
      (pure:m !>(~))
    ;<  auto=(unit auto:p)  bind:m
      (graylist-resolution id.ges src.gowl u.request.ges)
    ?:  ?=([~ %|] auto)
      (strand-fail %request-fail ~)
    ;<  ~  bind:m  (update-incoming-requests:pap id.ges src.gowl request.ges)
    ?~  auto
      (pure:m !>(~))
    ;<  ~  bind:m  (accept-request:pap id.ges src.gowl metadata.u.auto)
    (pure:m !>(~))
    ::
      %request-response
    ?>  =(src.gowl host.id.ges)
    ;<  ~  bind:m  (update-outgoing-request-response:pap id.ges status.ges)
    (pure:m !>(~))
    ::
      %delete-request
    ?>  =(src.gowl host.id.ges)
    ;<  ~  bind:m  (update-outgoing-requests:pap id.ges ~)
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
  =/  m  (strand ,vase)
  ^-  form:m
  ?>  =(src our):gowl
  ~&  "%pools vine: receiving local-action {(trip -.act)}"
  ?-    -.act
      %create-pool
    =/  title=@t  (extract-pool-title pool-data-fields.act)
    ;<  =id:p  bind:m  (unique-id title)
    ;<  ~  bind:m
      %+  create-pool-compound-transition:pap
        id
      [graylist-fields pool-data-fields]:act
    (pure:m !>(s+(id-string:enjs:j id)))
    ::
      %delete-pool
    ;<  ~  bind:m  (delete-pool:pap id.act)
    (pure:m !>(~))
    ::
      %leave-pool
    ?<  =(our.gowl host.id.act) :: can't leave own pool
    ;<  *  bind:m  ((soften ,~) (cancel-request:pap id.act))
    ;<  *  bind:m  ((soften ,~) (delete-invite:pap id.act))
    ;<  *  bind:m  ((soften ,~) (give-leave-gesture:pap id.act))
    ;<  ~  bind:m  (delete-pool:pap id.act)
    (pure:m !>(~))
    ::
      %watch-pool
    ;<  ~  bind:m  (watch-valid-pool id.act)
    (pure:m !>(~))
    ::
      %update-blocked
    ;<  ~  bind:m
      (handle-transition:pap ;;(transition:p act))
    (pure:m !>(~))
    ::
      %extend-request
    ?<  =(our.gowl host.id.act)
    ;<  ~  bind:m  (update-outgoing-requests:pap id.act ~ request.act)
    ;<  ges=(each ~ goof)  bind:m
      ((soften ,~) (give-request-gesture:pap [id ~ request]:act))
    :: cancel failed request
    ::
    ?:  ?=(%& -.ges)
      (pure:m !>(~))
    ;<  ~  bind:m  (cancel-request:pap id.act)
    (pure:m !>(~))
    ::
      %cancel-request
    ;<  *  bind:m  ((soften ,~) (give-request-gesture:pap [id ~]:act))
    ;<  ~  bind:m  (update-outgoing-requests:pap id.act ~)
    (pure:m !>(~))
    ::
      %accept-invite
    ;<  ~  bind:m  (give-invite-response-gesture:pap id.act [~ & metadata.act])
    ;<  ~  bind:m  (update-incoming-invite-response:pap id.act [~ & metadata.act])
    ;<  ~  bind:m  (watch-valid-pool id.act)
    (pure:m !>(~))
    ::
      %reject-invite
    ;<  ~  bind:m  (give-invite-response-gesture:pap id.act [~ | metadata.act])
    ;<  ~  bind:m  (update-incoming-invite-response:pap id.act [~ | metadata.act])
    (pure:m !>(~))
    ::
      %delete-invite
    ;<  *  bind:m  ((soften ,~) (give-delete-invite-gesture:pap id.act))
    ;<  ~  bind:m  (update-incoming-invites:pap id.act ~)
    (pure:m !>(~))
  ==
::
++  handle-pool-action
  |=  [=id:p act=pool-action:p]
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
    ;<  *  bind:m  ((soften ,~) (cancel-invite:pap id member.act))
    ;<  *  bind:m  ((soften ,~) (delete-request:pap id member.act))
    ;<  *  bind:m  ((soften ,~) (give-kick-gesture:pap id member.act))
    ;<  ~  bind:m  (update-members:pap id member.act ~)
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
    ;<  ~  bind:m  (kick-member:pap id ship.i.subs)
    $(subs t.subs)
    ::
      %update-graylist
    ;<  ~  bind:m
      (handle-pool-transition:pap id ;;(pool-transition:p act))
    ;<  ~  bind:m  (kick-blacklisted:pap id ~)
    (pure:m !>(~))
    ::
      %update-pool-data
    ;<  ~  bind:m
      (handle-pool-transition:pap id ;;(pool-transition:p act))
    (pure:m !>(~))
    ::
      %extend-invite
    ?>  =(our.gowl host.id)
    ?<  =(our.gowl invitee.act)
    ;<  ~  bind:m  (update-outgoing-invites:pap id invitee.act ~ invite.act)
    ;<  ges=(each ~ goof)  bind:m
      ((soften ,~) (give-invite-gesture:pap id [invitee ~ invite]:act))
    :: cancel failed invite
    ::
    ?:  ?=(%& -.ges)
      (pure:m !>(~))
    ;<  ~  bind:m  (cancel-invite:pap id invitee.act)
    (pure:m !>(~))
    ::
      %cancel-invite
    ?>  =(our.gowl host.id)
    ;<  *  bind:m  ((soften ,~) (give-invite-gesture:pap id invitee.act ~))
    ;<  ~  bind:m  (update-outgoing-invites:pap id invitee.act ~)
    (pure:m !>(~))
    ::
      %accept-request
    ?>  =(our.gowl host.id)
    ;<  ~  bind:m  (give-request-response-gesture:pap id requester.act [~ & metadata.act])
    ;<  ~  bind:m
      %+  accept-request-compound-transition:pap
        id
      [requester metadata]:act
    ;<  *  bind:m  ((soften ,~) (give-watch-me-gesture:pap id requester.act))
    (pure:m !>(~))
    ::
      %reject-request
    ?>  =(our.gowl host.id)
    ;<  ~  bind:m  (give-request-response-gesture:pap id requester.act [~ | metadata.act])
    ;<  ~  bind:m  (update-incoming-request-response:pap id requester.act [~ | metadata.act])
    (pure:m !>(~))
    ::
      %delete-request
    ?>  =(our.gowl host.id)
    ;<  *  bind:m  ((soften ,~) (give-delete-request-gesture:pap id requester.act))
    ;<  ~  bind:m  (update-incoming-requests:pap id requester.act ~)
    (pure:m !>(~))
  ==
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
++  delegate-graylist
  |=  [=dude:gall =id:p requester=ship =request:p]
  =/  m  (strand ,(unit auto:p))
  ^-  form:m
  %+  (vent ,(unit auto:p))
    [our.gowl dude]
  :-  %pools-delegation
  ^-  delegation:p
  [%graylist id requester request]
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
++  filter-metadata
  |=  [=filter:p =metadata:p]
  ^-  metadata:p
  ?~  filter
    metadata
  ?-    -.u.filter
      %&
    %-  ~(gas by *metadata:p)
    %+  murn  ~(tap by metadata)
    |=  [=@t =json]
    ?.  (~(has in p.u.filter) t)
      ~
    [~ t json]
      %|
    %-  ~(gas by *metadata:p)
    %+  murn  ~(tap by metadata)
    |=  [=@t =json]
    ?:  (~(has in p.u.filter) t)
      ~
    [~ t json]
  ==
--
