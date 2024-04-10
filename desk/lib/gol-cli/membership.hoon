/-  gol=goals, axn=action, p=pools, spider
/+  *ventio, pools, gol-cli-pool
|_  =gowl
++  en-pool-path  |=(=pid:gol `path`/pool/(scot %p host.pid)/[name.pid])
++  de-pool-path
  |=  =path
  ^-  pid:gol
  =+  ;;([%pool host=@ta name=@ta ~] path)
  [(slav %p host) name]
::
++  handle-membership-action
  =,  strand=strand:spider
  |=  act=membership-action:axn
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  ?-    -.act
      %watch-pool
    ;<  ~  bind:m  (watch-valid-pool pid.act)
    (pure:m !>(~))
    ::
      %kick-member
    ?>  =(our.gowl host.pid.act)
    =*  pl  ~(. gol-cli-pool (~(got by pools.store) pid.act))
    ?>  (check-pool-role-mod:pl member.act src.gowl)
    ;<  ~  bind:m  (kick-member [pid member]:act)
    (pure:m !>(~))
    ::
      %set-pool-role
    ?>  =(our.gowl host.pid.act)
    ~&  >>  %setting-pool-role
    ;<  ~  bind:m  (goals-set-role pid.act member.act role.act src.gowl)
    ;<  ~  bind:m  (pools-set-role [pid member role]:act)
    (pure:m !>(~))
    ::
      %leave-pool
    ?>  =(src our):gowl
    ;<  ~  bind:m  (leave-pools-pool pid.act)
    ;<  ~  bind:m  (leave-goals-pool pid.act)
    ;<  ~  bind:m  (delete-goals-pool pid.act)
    (pure:m !>(~))
    ::
      %extend-invite
    ?>  =(our.gowl host.pid.act)
    =*  pl  ~(. gol-cli-pool (~(got by pools.store) pid.act))
    ?>  (check-pool-edit-perm:pl src.gowl)
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
    =*  pl  ~(. gol-cli-pool (~(got by pools.store) pid.act))
    ?>  (check-pool-edit-perm:pl src.gowl)
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
    =*  pl  ~(. gol-cli-pool (~(got by pools.store) pid.act))
    ?>  (check-pool-edit-perm:pl src.gowl)
    ;<  ~  bind:m  (accept-request pid.act requester.act)
    (pure:m !>(~))
    ::
      %reject-request
    ?>  =(our.gowl host.pid.act)
    =*  pl  ~(. gol-cli-pool (~(got by pools.store) pid.act))
    ?>  (check-pool-edit-perm:pl src.gowl)
    ;<  ~  bind:m  (reject-request pid.act requester.act)
    (pure:m !>(~))
    ::
      %delete-request
    ?>  =(our.gowl host.pid.act)
    =*  pl  ~(. gol-cli-pool (~(got by pools.store) pid.act))
    ?>  (check-pool-edit-perm:pl src.gowl)
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
++  watch-valid-pool
  |=  =pid:gol
  =/  m  (strand ,~)
  ^-  form:m
  ;<  =pools:p   bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
  =/  =pool:p   (~(gut by pools) pid *pool:p)
  ?.  (~(has by private.pool-data.pool) 'goalsPool')
    ~&  "%goals vine: ignoring watch for invalid %goals pool id"
    (pure:m ~)
  %:  agent-watch-path
    %goals
    /pool/(scot %p host.pid)/[name.pid]
    [host.pid %goals]
    /pool/(scot %p host.pid)/[name.pid]
  ==
::
++  leave-goals-pool
  |=  =pid:gol
  =/  m  (strand ,~)
  ^-  form:m
  %+  agent-send-card  dap.gowl
  [%pass (en-pool-path pid) %agent [host.pid dap.gowl] %leave ~]
::
++  delete-goals-pool
  |=  =pid:gol
  =/  m  (strand ,~)
  ^-  form:m
  (poke [our dap]:gowl goal-transition+!>([%delete-pool pid]))
::
++  goals-set-role
  |=  [=id:p member=ship =role:gol mod=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %goal-transition
  ^-  transition:axn
  :^  %update-pool  id  mod
  [%set-pool-role member ~ role]
::
++  pools-set-role
  |=  [=id:p member=ship =role:p]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  =pools:p   bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
  =/  =pool:p    (~(got by pools) id)
  =/  current=roles:p  (~(got by members.pool) member)
  ?:  =(current (sy ~[role]))
    ~&  %role-already-set
    (pure:m ~)
  ;<  ~  bind:m  (update-members id member ~ %| current)
  (update-members id member ~ %& (sy ~[role]))
::
++  update-members
  |=  [=id:p member=ship roles=(unit (each roles:p roles:p))]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl %pools]
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-members member roles]
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
++  leave-pools-pool
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
