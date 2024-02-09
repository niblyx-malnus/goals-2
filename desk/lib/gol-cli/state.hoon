/-  *goals, old-goals, update
/+  gol-cli-node
:: step-wisdom vs. step-nomadism
:: https://gist.github.com/philipcmonk/de5ba03b3ea733387fd13b758062cfce
|%
+$  card  card:agent:gall
::
+$  state-5-24  [%'5-24' =store]
+$  state-5-23  [%'5-23' =store:old-goals]
+$  versioned-state
  $%  state-5-23
      state-5-24
  ==
::
++  upgrade-io
  |=  [new=state-5-24 =bowl:gall]
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
  ^-  state-5-24
  ?-  -.old
    %'5-23'  (convert-5-23-to-5-24 old)
      %'5-24'
    %=    old
        pools.store
      %-  ~(gas by *pools)
      %+  turn  ~(tap by pools.store.old)
      |=  [=pid =pool]
      [pid pool]
      :: [pid (inflate-pool:fl pool)]
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
        |=([=pid pool] (sy (turn ~(tap in ~(key by goals)) (lead pid))))
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
++  convert-5-23-to-5-24
  |=  =state-5-23
  ^-  state-5-24
  !!
  :: TODO: rename par/kids to parent/children
  :: TODO: change done to a status=(list [timestamp=@da done=?])
--
