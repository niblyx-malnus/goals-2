/-  gol=goals, axn=action, p=pools, spider
/+  *ventio, pools, goals-pool, sub-count, goals-api, pools-api
|_  =gowl
+*  gap  ~(. goals-api gowl)
    pap  ~(. pools-api gowl)
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
    ;<  ~  bind:m  (leave-pool:pap pid.act)
    ;<  ~  bind:m  (leave-goals-pool pid.act)
    ;<  ~  bind:m  (delete-pool:gap pid.act)
    (pure:m !>(~))
    ::
      %update-blocked
    ?>  =(src our):gowl
    ;<  ~  bind:m  (update-blocked:pap p.act)
    (pure:m !>(~))
    ::
      %extend-request
    ?>  =(our src):gowl
    =/  =request:p
      %-  ~(gas by *metadata:p)
      :~  [%dudes a+~[s+%goals]]
      ==
    ;<  ~  bind:m  (extend-request:pap pid.act request)
    (pure:m !>(~))
    ::
      %cancel-request
    ?>  =(our src):gowl
    ;<  ~  bind:m  (cancel-request:pap pid.act)
    (pure:m !>(~))
    ::
      %accept-invite
    ?>  =(src our):gowl
    ;<  ~  bind:m  (accept-invite:pap pid.act ~)
    (pure:m !>(~))
    ::
      %reject-invite
    ?>  =(src our):gowl
    ;<  ~  bind:m  (reject-invite:pap pid.act ~)
    (pure:m !>(~))
    ::
      %delete-invite
    ?>  =(src our):gowl
    ;<  ~  bind:m  (delete-invite:pap pid.act)
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
      goals-pool-membership-action+[pid act]
    ==
  :: deal with our pool
  ::
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  :: only host or admins can modify pool level permissions
  ::
  =*  pl  ~(. goals-pool (~(got by pools.store) pid))
  ?>  (check-pool-edit-perm:pl src.gowl)
  ?-    -.act
      %kick-member
    ;<  ~  bind:m  (kick-member:pap pid member.act)
    ;<  ~  bind:m  (del-pool-role:gap pid member.act)
    (pure:m !>(~))
    ::
      %set-pool-role
    ;<  ~  bind:m  (set-pool-role:gap pid member.act role.act src.gowl)
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
    ;<  ~  bind:m  (extend-invite:pap pid invitee.act invite)
    (pure:m !>(~))
    ::
      %cancel-invite
    ;<  ~  bind:m  (cancel-invite:pap pid invitee.act)
    (pure:m !>(~))
    ::
      %accept-request
    ;<  ~  bind:m  (accept-request:pap pid requester.act ~)
    (pure:m !>(~))
    ::
      %reject-request
    ;<  ~  bind:m  (reject-request:pap pid requester.act ~)
    (pure:m !>(~))
    ::
      %delete-request
    ;<  ~  bind:m  (delete-request:pap pid requester.act)
    (pure:m !>(~))
    ::
      %update-graylist
    ;<  ~  bind:m  (update-graylist-action:pap pid fields.act)
    (pure:m !>(~))
    ::
      %update-pool-data
    ;<  ~  bind:m  (update-pool-data-action:pap pid fields.act)
    (pure:m !>(~))
  ==
::
++  watch-valid-pool
  |=  =pid:gol
  =/  m  (strand ,~)
  ^-  form:m
  ;<  =pools:p   bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
  =/  =pool:p   (~(gut by pools) pid *pool:p)
  ?.  (~(has by public.pool-data.pool) 'goalsPool')
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
  ;<  ~  bind:m  (update-members:pap id member ~ %| current)
  (update-members:pap id member ~ %& (sy ~[role]))
--
