/-  p=pools, spider
/+  *ventio, lib=pools
=,  strand=strand:spider
^-  thread:spider
::
=;  helper-core
::
%-  vine-thread
|=  [gowl=bowl:gall vid=vent-id =mark =vase]
=/  m  (strand ,^vase)
^-  form:m
::
=*  hc  ~(. helper-core gowl)
::
~&  "%pools vine: receiving mark {(trip mark)}"
?+  mark  (just-poke [our dap]:gowl mark vase) :: poke normally
  %pools-view     (handle-pools-view:hc !<(view:p vase))
  %pools-gesture  (handle-pools-gesture:hc !<(gesture:p vase))
  %pools-action   (handle-pools-action:hc !<(action:p vase))
==
::
|_  =gowl
++  handle-pools-view
  |=  vyu=view:p
  =/  m  (strand ,vase)
  ^-  form:m
  ~&  "%pools vine: receiving view {(trip -.vyu)}"
  ?-    -.vyu
      %pools
    :: return pools and public data that src.gowl isn't blacklisted from
    ::
    ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
    =/  pools-list  `(list [=id:p =pool:p])`~(tap by pools)
    =|  discovered=(list [id:p metadata:p])
    |-
    ?~  pools-list
      %-  pure:m  !>
      %-  pairs:enjs:format
      %+  turn  discovered
      |=  [=id:p public=metadata:p]
      [(id-string:enjs:lib id) o+public]
    ;<  auto=(unit auto:p)  bind:m
      (graylist-resolution id.i.pools-list src.gowl metadata.vyu)
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
    ;<  auto=(unit auto:p)  bind:m
      (graylist-resolution id.vyu src.gowl metadata.vyu)
    ?:  ?=([~ %|] auto)
      (strand-fail %view-public-data-fail ~)
    ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
    (pure:m !>(o+public.pool-data:(~(got by pools) id.vyu)))
  ==
::
++  handle-pools-gesture
  |=  ges=gesture:p
  =/  m  (strand ,vase)
  ^-  form:m
  ~&  "%pools vine: receiving gesture {(trip -.ges)}"
  ?-    -.ges
      %kick
    ?>  =(src.gowl host.id.ges)
    (pure:m !>(~))
    ::
      %leave
    :: TODO: kick non-members
    :: TODO: kick blacklisted
    ;<  ~  bind:m  (update-members id.ges src.gowl ~)
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
    ?.  ?=([~ %& *] status.ges)
      (pure:m !>(~))
    ;<  ~  bind:m
      %:  agent-watch-path
        %pools
        /pool/(scot %p host.id.ges)/[name.id.ges]
        [host.id.ges %pools]
        /pool/(scot %p host.id.ges)/[name.id.ges]
      ==
    (pure:m !>(~))
    ::
      %delete-request
    ?>  =(src.gowl host.id.ges)
    ;<  ~  bind:m  (update-outgoing-requests id.ges ~)
    (pure:m !>(~))
  ==
::
++  handle-pools-action
  |=  act=action:p
  =/  m  (strand ,vase)
  ^-  form:m
  :: only we can perform actions on our %pools agent
  ::
  ?>  =(src our):gowl
  ~&  "%pools vine: receiving action {(trip -.act)}"
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
      %kick-member
    ?>  =(our.gowl host.id.act)
    ?<  =(our.gowl member.act) :: can't kick self as host
    ;<  *  bind:m  ((soften ,~) (cancel-invite id.act member.act))
    ;<  *  bind:m  ((soften ,~) (delete-request id.act member.act))
    ;<  *  bind:m  ((soften ,~) (give-kick-gesture id.act member.act))
    ;<  ~  bind:m  (update-members id.act member.act ~)
    (pure:m !>(~))
    ::
      %leave-pool
    ?<  =(our.gowl host.id.act) :: can't leave own pool
    ;<  *  bind:m  ((soften ,~) (cancel-request id.act))
    ;<  *  bind:m  ((soften ,~) (delete-invite id.act))
    ;<  *  bind:m  ((soften ,~) (give-leave-gesture id.act))
    (pure:m !>(~))
    ::
      %extend-invite
    ?>  =(our.gowl host.id.act)
    ?<  =(our.gowl invitee.act)
    ;<  ~  bind:m  (give-invite-gesture [id invitee ~ invite]:act)
    ;<  ~  bind:m  (update-outgoing-invites id.act invitee.act ~ invite.act)
    (pure:m !>(~))
    ::
      %cancel-invite
    ?>  =(our.gowl host.id.act)
    ;<  *  bind:m  ((soften ,~) (give-invite-gesture [id invitee ~]:act))
    ;<  ~  bind:m  (update-outgoing-invites id.act invitee.act ~)
    (pure:m !>(~))
    ::
      %accept-invite
    ;<  ~  bind:m  (give-invite-response-gesture id.act [~ & metadata.act])
    ;<  ~  bind:m  (update-incoming-invite-response id.act [~ & metadata.act])
    ;<  ~  bind:m
      %:  agent-watch-path
        %pools
        /pool/(scot %p host.id.act)/[name.id.act]
        [host.id.act %pools]
        /pool/(scot %p host.id.act)/[name.id.act]
      ==
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
    ::
      %extend-request
    ?<  =(our.gowl host.id.act)
    ;<  ~  bind:m  (give-request-gesture [id ~ request]:act)
    ;<  ~  bind:m  (update-outgoing-requests id.act ~ request.act)
    (pure:m !>(~))
    ::
      %cancel-request
    ;<  *  bind:m  ((soften ,~) (give-request-gesture [id ~]:act))
    ;<  ~  bind:m  (update-outgoing-requests id.act ~)
    (pure:m !>(~))
    ::
      %accept-request
    ?>  =(our.gowl host.id.act)
    ;<  ~  bind:m  (give-request-response-gesture id.act requester.act [~ & metadata.act])
    ;<  ~  bind:m  (update-incoming-request-response id.act requester.act [~ & metadata.act])
    ;<  ~  bind:m  (update-members id.act requester.act ~ &+~)
    (pure:m !>(~))
    ::
      %reject-request
    ?>  =(our.gowl host.id.act)
    ;<  ~  bind:m  (give-request-response-gesture id.act requester.act [~ | metadata.act])
    ;<  ~  bind:m  (update-incoming-request-response id.act requester.act [~ | metadata.act])
    (pure:m !>(~))
    ::
      %delete-request
    ?>  =(our.gowl host.id.act)
    ;<  *  bind:m  ((soften ,~) (give-delete-request-gesture [id requester]:act))
    ;<  ~  bind:m  (update-incoming-requests id.act requester.act ~)
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
++  accept-request
  |=  [=id:p requester=ship =metadata:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %pools-action
  ^-  action:p
  [%accept-request id requester metadata]
::
++  reject-request
  |=  [=id:p requester=ship =metadata:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %pools-action
  ^-  action:p
  [%reject-request id requester metadata]
::
++  cancel-invite
  |=  [=id:p invitee=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %pools-action
  ^-  action:p
  [%cancel-invite id invitee]
::
++  delete-invite
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %pools-action
  ^-  action:p
  [%delete-invite id]
::
++  cancel-request
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %pools-action
  ^-  action:p
  [%cancel-request id]
::
++  delete-request
  |=  [=id:p requester=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %pools-action
  ^-  action:p
  [%delete-request id requester]
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
:: ++  get-outgoing-invite
::   |=  [=id:p invitee=ship]
::   =/  m  (strand ,invite:p)
::   ^-  form:m
::   ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
::   =/  =pool:p   (~(got by pools) id)
::   (pure:m invite:(~(got by outgoing-invites.pool) invitee))
::
:: ++  delegate-add-from-invite
::   |=  [=id:p invitee=ship]
::   =/  m  (strand ,(map dude:gall goof))
::   ^-  form:m
::   =|  goofs=(map dude:gall goof)
::   ;<  =invite:p  bind:m  (get-outgoing-invite id invitee)
::   =/  dudes  ((ar so):dejs:format (~(gut by invite) 'dudes' a+~))
::   |-
::   ?~  dudes
::     (pure:m goofs)
::   ;<  del=(each ~ goof)  bind:m
::     %-  (soften ,~)
::     %+  (set-timeout ,~)  timeout
::     %+  (vent ,~)
::       [our.gowl i.dudes]
::     :-  %pools-delegation
::     ^-  delegation:p
::     [%add-from-invite id invitee invite]
::   %=  $
::     dudes  t.dudes
::     goofs  ?-(-.del %& goofs, %| (~(put by goofs) i.dudes p.del))
::   ==
::
:: ++  get-incoming-request
::   |=  [=id:p requester=ship]
::   =/  m  (strand ,request:p)
::   ^-  form:m
::   ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
::   =/  =pool:p   (~(got by pools) id)
::   (pure:m request:(~(got by incoming-requests.pool) requester))
::
:: ++  delegate-add-from-request
::   |=  [=id:p requester=ship]
::   =/  m  (strand ,(map dude:gall goof))
::   ^-  form:m
::   =|  goofs=(map dude:gall goof)
::   ;<  =request:p  bind:m  (get-incoming-request id requester)
::   =/  dudes  ((ar so):dejs:format (~(gut by request) 'dudes' a+~))
::   |-
::   ?~  dudes
::     (pure:m goofs)
::   ;<  del=(each ~ goof)  bind:m
::     %-  (soften ,~)
::     %+  (set-timeout ,~)  timeout
::     %+  (vent ,~)
::       [our.gowl i.dudes]
::     :-  %pools-delegation
::     ^-  delegation:p
::     [%add-from-request id requester request]
::   %=  $
::     dudes  t.dudes
::     goofs  ?-(-.del %& goofs, %| (~(put by goofs) i.dudes p.del))
::   ==
--
