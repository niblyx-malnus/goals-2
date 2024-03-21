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
?>  |(=(our src):gowl (moon:title [our src]:gowl))
~?  >>  (moon:title [our src]:gowl)
  "%pools vine: moon access from {(scow %p src.gowl)}"
;<  moon-as-planet=?  bind:m  (scry-hard ,? /gx/pools/moon-as-planet/noun)
~&  >>  moon-as-planet+moon-as-planet
=?  src.gowl  &(moon-as-planet (moon:title [our src]:gowl))  our.gowl
::
=*  hc  ~(. helper-core gowl)
::
~&  "%pools vine: receiving mark {(trip mark)}"
?+  mark  (just-poke [our dap]:gowl mark vase) :: poke normally
  %pools-gesture  (handle-pools-gesture:hc !<(gesture:p vase))
  %pools-action   (handle-pools-action:hc !<(action:p vase))
==
::
|_  =gowl
++  unique-id
  |=  pools=(set id:p)
  |=  name=@t
  |^  `id:p`(uniquify (tasify name))
  ++  uniquify
    |=  =term
    ^-  id:p
    ?.  (~(has in pools) [our.gowl term])
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
++  handle-pools-gesture
  |=  ges=gesture:p
  =/  m  (strand ,vase)
  ^-  form:m
  ~&  "%pools vine: receiving gesture {(trip -.ges)}"
  ?-    -.ges
      %invite
    ?>  =(src.gowl host.id.ges)
    ;<  ~  bind:m  (update-incoming-invites id.ges invite.ges)
    (pure:m !>(~))
    ::
      %invite-response
    ?>  =(our.gowl host.id.ges)
    ;<  ~  bind:m  (update-outgoing-invite-response id.ges src.gowl status.ges)
    :: TODO: If a response is affirmative, add to members
    (pure:m !>(~))
    ::
      %request
    ?>  =(our.gowl host.id.ges)
    ;<  ~  bind:m  (update-incoming-requests id.ges src.gowl request.ges)
    (pure:m !>(~))
    ::
      %request-response
    ?>  =(src.gowl host.id.ges)
    ;<  ~  bind:m  (update-outgoing-request-response id.ges status.ges)
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
    ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
    =/  =id:p     ((unique-id ~(key by pools)) title)
    ;<  ~  bind:m  (create-pool id)
    ;<  ~  bind:m  (update-graylist id graylist-fields.act)
    ;<  ~  bind:m  (update-pool-data id pool-data-fields.act)
    ;<  ~  bind:m  (update-members id our.gowl ~ &+(sy ~[%host]))
    (pure:m !>(s+(id-string:enjs:lib id)))
    ::
      %delete-pool
    ;<  ~  bind:m  (delete-pool id.act)
    (pure:m !>(~))
    ::
      %extend-invite
    ?>  =(our.gowl host.id.act)
    ;<  ~  bind:m  (give-invite-gesture [id invitee ~ invite]:act)
    ;<  ~  bind:m  (update-outgoing-invites id.act invitee.act ~ invite.act)
    (pure:m !>(~))
    ::
      %cancel-invite
    ?>  =(our.gowl host.id.act)
    ;<  ~  bind:m  (give-invite-gesture [id invitee ~]:act)
    ;<  ~  bind:m  (update-outgoing-invites id.act invitee.act ~)
    (pure:m !>(~))
    ::
      %accept-invite
    ~&  pools-accept-invite+src.gowl
    ;<  ~  bind:m  (give-invite-response-gesture id.act [~ & metadata.act])
    ;<  ~  bind:m  (update-incoming-invite-response id.act [~ & metadata.act])
    (pure:m !>(~))
    ::
      %reject-invite
    ;<  ~  bind:m  (give-invite-response-gesture id.act [~ | metadata.act])
    ;<  ~  bind:m  (update-incoming-invite-response id.act [~ | metadata.act])
    (pure:m !>(~))
    ::
      %extend-request
    ;<  ~  bind:m  (give-request-gesture [id ~ request]:act)
    ;<  ~  bind:m  (update-outgoing-requests id.act ~ request.act)
    (pure:m !>(~))
    ::
      %cancel-request
    ;<  ~  bind:m  (give-request-gesture [id ~]:act)
    ;<  ~  bind:m  (update-outgoing-requests id.act ~)
    (pure:m !>(~))
    ::
      %accept-request
    ?>  =(our.gowl host.id.act)
    ;<  ~  bind:m  (give-request-response-gesture id.act requestee.act [~ & metadata.act])
    ;<  ~  bind:m  (update-incoming-request-response id.act requestee.act [~ & metadata.act])
    :: TODO: add to members
    (pure:m !>(~))
    ::
      %reject-request
    ?>  =(our.gowl host.id.act)
    ;<  ~  bind:m  (give-request-response-gesture id.act requestee.act [~ | metadata.act])
    ;<  ~  bind:m  (update-incoming-request-response id.act requestee.act [~ | metadata.act])
    (pure:m !>(~))
  ==
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
  |=  [=id:p requestee=ship request=(unit request:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-incoming-requests requestee request]
::
++  update-incoming-request-response
  |=  [=id:p requestee=ship =status:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-incoming-request-response requestee status]
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
++  give-invite-gesture
  |=  [=id:p invitee=ship invite=(unit invite:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  ~&  invitee+invitee
  ~&  dap+dap.gowl
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
  |=  [=id:p requestee=ship =status:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [requestee dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%request-response id status]
--
