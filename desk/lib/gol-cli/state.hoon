/-  *goals
/+  fl=gol-cli-inflater
:: step-wisdom vs. step-nomadism
:: https://gist.github.com/philipcmonk/de5ba03b3ea733387fd13b758062cfce
|%
+$  card  card:agent:gall
::
++  upgrade-io
  |=  [new=state-5 =bowl:gall]
  |^  ^-  (list card)
  :: TODO: Follow all pools and prompt others to refollow?
  ;:  weld
    kick-sup
    leave-wex
  ==
  ++  kick-sup
    ^-  (list card)
    %+  turn  ~(tap by sup.bowl)
    |=  [=duct =ship =path]
    [%give %kick ~[path] ~]
  ::
  ++  leave-wex
    ^-  (list card)
    %+  turn  ~(tap by wex.bowl)
    |=  [[=wire =ship =term] *]
    [%pass wire %agent [ship term] %leave ~]
  --
::
++  convert-to-latest
  |=  old=versioned-state
  ^-  state-5
  ?-  -.old
    %0  $(old (convert-0-to-1 old))
    %1  $(old (convert-1-to-2 old))
    %2  $(old (convert-2-to-3 old))
    %3  $(old (convert-3-to-4 old))
    %4  $(old (convert-4-to-5 old))
    ::
      %5
    %=    old
        pools.store
      %-  ~(gas by *pools)
      %+  turn  ~(tap by pools.store.old)
      |=  [=pin =pool]
      [pin (inflate-pool:fl pool)]
    ==
  ==
::
++  convert-4-to-5
  |=  =state-4
  ^-  state-5
  :: TODO: ACTUALLY IMPLEMENT
  ::       DON'T FORGET TO CONVERT SUB PATHS!!!
  *state-5 
::
++  convert-3-to-4
  |=  =state-3
  ^-  state-4
  :*  %4
      :*  (index-3-to-4 directory.store.state-3)
          (pools-3-to-4 pools.store.state-3)
          *pools:s4
      == 
      *groups
      *log:s4
  ==
  ::
++  index-3-to-4
  |=  =directory:s3
  ^-  index:s4
  (gas:idx-orm:s4 *index:s4 ~(tap by directory))
::
++  pools-3-to-4
  |=  =pools:s3
  ^-  pools:s4
  %-  ~(gas by *pools:s4)
  %+  turn
    ~(tap by pools)
  |=  [=pin:s3 =pool:s3]
  ^-  [pin:s4 pool:s4]
  [pin (pool-3-to-4 pool)]
::
++  pool-3-to-4
  |=  =npool:s3
  ^-  pool:s4
  =|  =npool:s4
  =.  froze.npool  [birth creator]:froze.^npool
  =.  owner.nexus.npool  owner.froze.^npool
  =.  perms.nexus.npool  (pool-perms-3-to-4 perms.^npool)
  =.  goals.nexus.npool  (goals-3-to-4 goals.nexus.^npool)
  =.  hitch.npool  hitch.^npool
  npool
::
++  pool-perms-3-to-4
  |=  pool-perms:s3
  =|  =pool-perms:s4
  =.  pool-perms
    %-  ~(gas by pool-perms)
    %+  murn
      ~(tap in admins) 
    |=  =ship
    ?:  (~(has by pool-perms) ship)
      ~
    (some [ship (some %admin)])
  =.  pool-perms
    %-  ~(gas by pool-perms)
    %+  murn
      ~(tap in captains) 
    |=  =ship
    ?:  (~(has by pool-perms) ship)
      ~
    (some [ship (some %spawn)])
  =.  pool-perms
    %-  ~(gas by pool-perms)
    %+  murn
      ~(tap in viewers) 
    |=  =ship
    ?:  (~(has by pool-perms) ship)
      ~
    (some [ship ~])
  pool-perms
::
++  goals-3-to-4
  |=  =goals:s3
  ^-  goals:s4
  %-  ~(gas by *goals:s4)
  %+  turn
    ~(tap by goals)
  |=  [=id:s3 =goal:s3]
  ^-  [id:s4 goal:s4]
  [id (goal-3-to-4 goal goals)]
  ::
++  goal-3-to-4
  |=  [=goal:s3 =goals:s3]
  ^-  goal:s4
  =|  =ngoal:s4
  =.  froze.ngoal  froze:`ngoal:s3`goal
  =.  nexus.ngoal  (nexus-3-to-4 goal)
  =.  hitch.ngoal  hitch:`ngoal:s3`goal
  ngoal
  ::
++  nexus-3-to-4
  |=  =goal:s3
  ^-  goal-nexus:s4
  =|  nexus=goal-nexus:s4
  =.  par.nexus  par.goal
  =.  kids.nexus  kids.goal
  =.  kickoff.nexus  (node-3-to-4 kickoff.goal)
  =.  deadline.nexus  (node-3-to-4 deadline.goal)
  =.  complete.nexus  complete.goal
  =.  actionable.nexus  actionable.goal
  =.  chief.nexus  owner.goal
  nexus
::
++  node-3-to-4
  |=  =edge:s3
  ^-  node:s4
  =|  =node:s4
  =.  moment.node  moment.edge
  =.  inflow.node  inflow.edge
  =.  outflow.node  outflow.edge
  node
::
++  convert-2-to-3
  |=  =state-2
  ^-  state-3
  `state-3`[%3 +.state-2]
:: From state-1 to state-2:
::   - add owner and birth to goal and pool
::   - restructure with froze, perms, nexus, togls, hitch
::
++  convert-1-to-2
  |=  =state-1
  ^-  state-2
  |^
  :*  %2
      directory.store.state-1
      (pools-1-to-2 pools.store.state-1)
  ==
  ::
  ++  goal-1-to-2
    |=  [=id:s1 =goal:s1]
    ^-  goal:s2
    =|  =goal:s2
    =.  owner.goal       owner.id
    =.  birth.goal       birth.id
    =.  desc.goal        desc.^goal
    =.  author.goal      author.^goal
    =.  chefs.goal       chefs.^goal
    =.  peons.goal       peons.^goal
    =.  par.goal         par.^goal
    =.  kids.goal        kids.^goal
    =.  kickoff.goal     kickoff.^goal
    =.  deadline.goal    deadline.^goal
    =.  complete.goal    complete.^goal
    =.  actionable.goal  actionable.^goal
    =.  archived.goal    archived.^goal
    goal
  ::
  ++  goals-1-to-2
    |=  =goals:s1
    ^-  goals:s2
    %-  ~(gas by *goals:s2)
    %+  turn
      ~(tap by goals)
    |=  [=id:s1 =goal:s1]
    ^-  [id:s2 goal:s2]
    [id (goal-1-to-2 id goal)]
  ::
  ++  pool-1-to-2
    |=  [=pin:s1 =pool:s1]
    ^-  pool:s2
    =|  =pool:s2
    =.  owner.pool       owner.pin
    =.  birth.pool       birth.pin
    =.  title.pool       title.^pool
    =.  creator.pool     creator.^pool
    =.  goals.pool       (goals-1-to-2 goals.^pool)
    =.  chefs.pool       chefs.^pool
    =.  peons.pool       peons.^pool
    =.  viewers.pool     viewers.^pool
    =.  archived.pool    archived.^pool
    pool
  ::
  ++  pools-1-to-2
    |=  =pools:s1
    ^-  pools:s2
    %-  ~(gas by *pools:s2)
    %+  turn
      ~(tap by pools)
    |=  [=pin:s1 =pool:s1]
    ^-  [pin:s2 pool:s2]
    [pin (pool-1-to-2 pin pool)]
  --
:: From state-0 to state-1:
::   - split was changed to edge
::   - project was changed to pool
::   - projects was changed to pools
::
++  convert-0-to-1
  |=  =state-0
  ^-  state-1
  [%1 `store:s1`store.state-0]
--
