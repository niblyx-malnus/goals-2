/-  gol=goals, axn=action, p=pools, spider
/+  *ventio, pools
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
      %kick-member
    ?>  =(our.gowl host.pid.act)
    :: TODO: assert src.gowl has appropriate permissions wrt pool
    ;<  ~  bind:m  (kick-member [pid member]:act)
    (pure:m !>(~))
    ::
      %leave-pool
    ?>  =(src our):gowl
    ;<  ~  bind:m  (leave-pool pid.act)
    (pure:m !>(~))
    ::
      %extend-invite
    ?>  =(our.gowl host.pid.act)
    :: TODO: assert src.gowl has appropriate permissions wrt pool
    =/  =pool:gol  (~(got by pools.store) pid.act)
    =/  =invite:p
      %-  ~(gas by *metadata:p)
      :~  [%dudes a+~[s+%goals]]
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
    ::
      %delete-invite
    ?>  =(src our):gowl
    ;<  ~  bind:m  (delete-invite pid.act)
    (pure:m !>(~))
    ::
      %extend-request
    ?>  =(our src):gowl
    =/  =request:p
      %-  ~(gas by *metadata:p)
      :~  [%dudes a+~[s+%goals]]
      ==
    ;<  ~  bind:m  (extend-request pid.act request)
    (pure:m !>(~))
    ::
      %cancel-request
    ?>  =(our src):gowl
    ;<  ~  bind:m  (cancel-request pid.act)
    (pure:m !>(~))
    ::
      %accept-request
    ?>  =(our.gowl host.pid.act)
    :: TODO: assert src.gowl has appropriate permissions wrt pool
    ;<  ~  bind:m  (accept-request pid.act requester.act)
    (pure:m !>(~))
    ::
      %reject-request
    ?>  =(our.gowl host.pid.act)
    :: TODO: assert src.gowl has appropriate permissions wrt pool
    ;<  ~  bind:m  (reject-request pid.act requester.act)
    (pure:m !>(~))
    ::
      %delete-request
    ?>  =(our.gowl host.pid.act)
    :: TODO: assert src.gowl has appropriate permissions wrt pool
    ;<  ~  bind:m  (delete-request [pid requester]:act)
    (pure:m !>(~))
    ::
      %update-blocked
    ?>  =(src our):gowl
    ;<  ~  bind:m  (update-blocked p.act)
    (pure:m !>(~))
    ::
      %update-graylist
    ?>  =(src our):gowl
    ;<  ~  bind:m  (update-graylist [pid fields]:act)
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
++  kick-member
  |=  [=id:p member=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-action
  ^-  action:p
  [%kick-member id member]
::
++  leave-pool
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-action
  ^-  action:p
  [%leave-pool id]
::
++  extend-invite
  |=  [=id:p invitee=ship =invite:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-action
  ^-  action:p
  [%extend-invite id invitee invite]
::
++  cancel-invite
  |=  [=id:p invitee=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-action
  ^-  action:p
  [%cancel-invite id invitee]
::
++  accept-invite
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-action
  ^-  action:p
  [%accept-invite id ~]
::
++  reject-invite
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-action
  ^-  action:p
  [%reject-invite id ~]
::
++  delete-invite
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-action
  ^-  action:p
  [%delete-invite id]
::
++  extend-request
  |=  [=id:p =request:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-action
  ^-  action:p
  [%extend-request id request]
::
++  cancel-request
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-action
  ^-  action:p
  [%cancel-request id]
::
++  accept-request
  |=  [=id:p requester=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-action
  ^-  action:p
  [%accept-request id requester ~]
::
++  reject-request
  |=  [=id:p requester=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-action
  ^-  action:p
  [%reject-request id requester ~]
::
++  delete-request
  |=  [=id:p requester=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-action
  ^-  action:p
  [%delete-request id requester]
::
++  update-blocked
  |=  upd=(each blocked:p blocked:p)
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-transition
  ^-  transition:p
  [%update-blocked upd]
::
++  update-graylist
  |=  [=id:p fields=(list graylist-field:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-transition
  ^-  transition:p
  :+  %update-pool  id
  [%update-graylist fields]
--
