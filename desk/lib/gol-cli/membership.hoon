/-  gol=goals, axn=action, p=pools, spider
/+  *ventio, pools, gol-cli-pool, sub-count
|_  =gowl
++  en-pool-path  |=(=pid:gol `path`/pool/(scot %p host.pid)/[name.pid])
++  de-pool-path
  |=  =path
  ^-  pid:gol
  =+  ;;([%pool host=@ta name=@ta ~] path)
  [(slav %p host) name]
::
++  handle-local-membership-action
  =,  strand=strand:spider
  |=  act=local-membership-action:axn
  =/  m  (strand ,vase)
  ^-  form:m
  ?>  =(src our):gowl
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  ?-    -.act
      %watch-pool
    ;<  ~  bind:m  (watch-valid-pool pid.act)
    (pure:m !>(~))
    ::
      %leave-pool
    ?>  =(src our):gowl
    ;<  ~  bind:m  (leave-pools-pool pid.act)
    ;<  ~  bind:m  (leave-goals-pool pid.act)
    ;<  ~  bind:m  (delete-goals-pool pid.act)
    (pure:m !>(~))
    ::
      %update-blocked
    ?>  =(src our):gowl
    ;<  ~  bind:m  (update-blocked p.act)
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
  ==
::
++  handle-pool-membership-action
  =,  strand=strand:spider
  |=  [=pid:gol act=pool-membership-action:axn]
  =/  m  (strand ,vase)
  ^-  form:m
  =/  pool-path=path  (en-pool-path pid)
  ?.  =(our.gowl host.pid)
    :: forward action to remote pool
    :: (only returns when local copy synced)
    ::
    %:  vent-counted-action:vine:sub-count
      [host.pid dap.gowl]
      %-  ~(gas by *(map wire path))
      :~  [`wire`[%goals pool-path] `path`[%goals pool-path]]
          [`wire`[%pools pool-path] `path`[%pools pool-path]]
      ==
      goal-pool-membership-action+[pid act]
    ==
  :: deal with our pool
  ::
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  :: only host or admins can modify pool level permissions
  ::
  =*  pl  ~(. gol-cli-pool (~(got by pools.store) pid))
  ?>  (check-pool-edit-perm:pl src.gowl)
  ?-    -.act
      %kick-member
    ;<  ~  bind:m  (kick-member pid member.act)
    ;<  ~  bind:m  (del-pool-role pid member.act)
    (pure:m !>(~))
    ::
      %set-pool-role
    ;<  ~  bind:m  (goals-set-role pid member.act role.act src.gowl)
    ;<  ~  bind:m  (pools-set-role pid [member role]:act)
    (pure:m !>(~))
    ::
      %extend-invite
    =/  =pool:gol  (~(got by pools.store) pid)
    =/  =invite:p
      %-  ~(gas by *metadata:p)
      :~  [%dudes a+~[s+%goals]]
          [%from s+(scot %p src.gowl)]
          [%title s+title.pool]
      ==
    ;<  ~  bind:m  (extend-invite pid invitee.act invite)
    (pure:m !>(~))
    ::
      %cancel-invite
    ;<  ~  bind:m  (cancel-invite pid invitee.act)
    (pure:m !>(~))
    ::
      %accept-request
    ;<  ~  bind:m  (accept-request pid requester.act)
    (pure:m !>(~))
    ::
      %reject-request
    ;<  ~  bind:m  (reject-request pid requester.act)
    (pure:m !>(~))
    ::
      %delete-request
    ;<  ~  bind:m  (delete-request pid requester.act)
    (pure:m !>(~))
    ::
      %update-graylist
    ;<  ~  bind:m  (update-graylist pid fields.act)
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
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%kick-member member]
:: Deletes from %goals only (already removed in %pools)
::
++  del-pool-role
  |=  [=pid:gol member=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %goals]
  :-  %goal-transition
  :^  %update-pool  pid  our.gowl
  [%set-pool-role member ~]
::
++  leave-pools-pool
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-local-action
  ^-  local-action:p
  [%leave-pool id]
::
++  extend-invite
  |=  [=id:p invitee=ship =invite:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%extend-invite invitee invite]
::
++  cancel-invite
  |=  [=id:p invitee=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%cancel-invite invitee]
::
++  accept-invite
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-local-action
  ^-  local-action:p
  [%accept-invite id ~]
::
++  reject-invite
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-local-action
  ^-  local-action:p
  [%reject-invite id ~]
::
++  delete-invite
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-local-action
  ^-  local-action:p
  [%delete-invite id]
::
++  extend-request
  |=  [=id:p =request:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-local-action
  ^-  local-action:p
  [%extend-request id request]
::
++  cancel-request
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-local-action
  ^-  local-action:p
  [%cancel-request id]
::
++  accept-request
  |=  [=id:p requester=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%accept-request requester ~]
::
++  reject-request
  |=  [=id:p requester=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%reject-request requester ~]
::
++  delete-request
  |=  [=id:p requester=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%delete-request requester]
::
++  update-blocked
  |=  upd=(each blocked:p blocked:p)
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-local-action
  ^-  local-action:p
  [%update-blocked upd]
::
++  update-graylist
  |=  [=id:p fields=(list graylist-field:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl %pools]
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%update-graylist fields]
--
