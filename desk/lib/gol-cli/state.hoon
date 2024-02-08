/-  *goals, old-goals, update
/+  gol-cli-node
:: step-wisdom vs. step-nomadism
:: https://gist.github.com/philipcmonk/de5ba03b3ea733387fd13b758062cfce
|%
+$  card  card:agent:gall
::
+$  state-5-23  [%'5-23' =store]
+$  state-5-22  [%'5-22' =store:old-goals]
+$  versioned-state
  $%  state-5-22
      state-5-23
  ==
::
++  upgrade-io
  |=  [new=state-5-23 =bowl:gall]
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
  ^-  state-5-23
  ?-  -.old
    %'5-22'  (convert-5-22-to-5-23 old)
      %'5-23'
    %=    old
        pools.store
      %-  ~(gas by *pools)
      %+  turn  ~(tap by pools.store.old)
      |=  [=pin =pool]
      [pin pool]
      :: [pin (inflate-pool:fl pool)]
      :: Reorder pool-order if incorrect
      ::
        pool-order.local.store
      ?:  =((sy pool-order.local.store.old) ~(key by pools.store.old))
        pool-order.local.store.old
      ~(tap in ~(key by pools.store.old))
      :: Reorder goal-order if incorrect
      ::
        goal-order.local.store
      =/  goals=(list (set key))
        %+  turn  ~(tap by pools.store.old)
        |=([=pin pool] (sy (turn ~(tap in ~(key by goals)) (lead pin))))
      =/  all-goals=(set key)
        =|  all-goals=(set key)
        |-
        ?~  goals
          all-goals
        $(goals t.goals, all-goals (~(uni in all-goals) i.goals))
      ?:  =((sy goal-order.local.store.old) all-goals)
        goal-order.local.store.old
      ~(tap in all-goals)
    ==
  ==
:: Development states
::
++  convert-5-22-to-5-23
  |=  =state-5-22
  ^-  state-5-23
  =/  pools
    %-  ~(gas by *pools)
    %+  turn  ~(tap by pools.store.state-5-22)
    |=  [=pin =pool:old-goals]
    ^-  [^pin ^pool]
    =/  =goals
      %-  ~(gas by *goals)
      %+  turn  ~(tap by goals.pool)
      |=  [=id:old-goals =goal:old-goals]
      ^-  [^id ^goal]
      :-  key.id
      :*  key.id
          ?~(par.goal ~ `key.u.par.goal)
          (~(gas in *(set ^id)) (turn ~(tap in kids.goal) |=(=id:old-goals key.id)))
          :*  done.kickoff.goal
              moment.kickoff.goal
              %-  ~(gas in *(set nid))
              (turn ~(tap in outflow.kickoff.goal) |=(=nid:old-goals [-.nid key.id.nid]))
              %-  ~(gas in *(set nid))
              (turn ~(tap in outflow.kickoff.goal) |=(=nid:old-goals [-.nid key.id.nid]))
          ==
          :*  done.deadline.goal
              moment.deadline.goal
              %-  ~(gas in *(set nid))
              (turn ~(tap in outflow.deadline.goal) |=(=nid:old-goals [-.nid key.id.nid]))
              %-  ~(gas in *(set nid))
              (turn ~(tap in outflow.deadline.goal) |=(=nid:old-goals [-.nid key.id.nid]))
          ==
          actionable.goal
          chief.goal
          deputies.goal
          summary.goal
      ==
    :-  pin
    :*  pin
        perms.pool
        goals
        ~
        title.pool
    ==
  =/  pool-info
    %-  ~(gas by *(map pin pool-data))
    %+  turn  ~(tap by pool-info.store.state-5-22)
    |=  [=pin =pool-data:old-goals]
    ^-  [^pin ^pool-data]
    :-  pin
    :*  properties.pool-data
        ::
        %-  ~(gas by *(map id (set @t)))
        %+  turn  ~(tap by tags.pool-data)
        |=  [=id:old-goals tags=(set @t)]
        [key.id tags]
        ::
        %-  ~(gas by *(map id (map @t @t)))
        %+  turn  ~(tap by fields.pool-data)
        |=  [=id:old-goals fields=(map @t @t)]
        [key.id fields]
        ::
        tag-properties.pool-data
        field-properties.pool-data
        ~
    ==
  :: TODO: convert id to @ta
  :: TODO: rename par/kids to parent/children
  :: TODO: rename kickoff/deadline to start/end
  :: TODO: change done to a status=(list [timestamp=@da done=?])
  :*  %'5-23'
      pools
      local.store.state-5-22
      pool-info
      json-tree.store.state-5-22
  ==
--
