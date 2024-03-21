/-  gol=goals, axn=action, p=pools, spider
/+  *ventio
|_  =gowl
++  handle-membership-action
  =,  strand=strand:spider
  |=  act=membership-action:axn
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  ?-    -.act
      %join
    !!
    :: :: watch the pool path
    :: ::
    :: ;<  p=(unit tang)  bind:m
    ::   %:  agent-watch-path-soft
    ::     %goals
    ::     /(scot %p host.pid.act)/[name.pid.act]
    ::     [host.pid.act %goals]
    ::     /(scot %p host.pid.act)/[name.pid.act]
    ::   ==
    :: :: update subscription history
    :: ::
    :: =/  =cage
    ::   membership-transition+!>([%pool-sub-event pid.act %watch-ack p])
    :: ;<  ~  bind:m  (poke [our.gowl %goals-members] cage)
    :: :: return or fail
    :: ::
    :: ?~  p
    ::   (pure:m !>(~))
    :: (strand-fail %pool-subscription-fail u.p)
    ::
      %extend-invite
    ?>  =(our.gowl host.pid.act)
    :: TODO: assert src.gowl has appropriate permissions wrt pool
    =/  =pool:gol  (~(got by pools.store) pid.act)
    =/  =invite:p
      %-  ~(gas by *invite:p)
      :~  [%goals-invite ~]
          [%from s+(scot %p src.gowl)]
          [%title s+title.pool]
      ==
    ;<  ~  bind:m  (extend-invite pid.act invitee.act invite)
    (pure:m !>(~))
    ::
      %cancel-invite
    ?>  =(our.gowl host.pid.act)
    :: TODO: assert src.gowl has appropriate permissions wrt pool
    ;<  ~  bind:m  (cancel-invite pid.act invitee.act)
    (pure:m !>(~))
    ::
      %accept-invite
    ?>  =(src our):gowl
    ;<  ~  bind:m  (accept-invite pid.act)
    (pure:m !>(~))
    ::
      %reject-invite
    ?>  =(src our):gowl
    ;<  ~  bind:m  (reject-invite pid.act)
    (pure:m !>(~))
  ==
::
++  send-error
  |=  data=(list [@t json])
  =/  m  (strand ,vase)
  =,  enjs:format
  %-  pure:m  !>
  (pairs [error+(pairs data) ~])
::
++  send-warning
  |=  data=(list [@t json])
  =/  m  (strand ,vase)
  =,  enjs:format
  %-  pure:m  !>
  (pairs [warning+(pairs data) ~])
::
++  extend-invite
  |=  [=id:p invitee=ship =invite:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl %pools]
  :-  %pools-action  !>
  [%extend-invite id invitee invite]
::
++  cancel-invite
  |=  [=id:p invitee=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl %pools]
  :-  %pools-action  !>
  [%cancel-invite id invitee]
::
++  accept-invite
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl %pools]
  :-  %pools-action  !>
  [%accept-invite id]
::
++  reject-invite
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl %pools]
  :-  %pools-action  !>
  [%reject-invite id]
--
