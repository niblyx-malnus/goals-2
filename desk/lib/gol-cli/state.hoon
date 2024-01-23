/-  *goals, old-goals, update
/+  gol-cli-node
:: step-wisdom vs. step-nomadism
:: https://gist.github.com/philipcmonk/de5ba03b3ea733387fd13b758062cfce
|%
+$  card  card:agent:gall
::
+$  state-5-20  [%'5-20' =store]
+$  state-5-19  [%'5-19' =store:old-goals]
+$  versioned-state
  $%  state-5-19
      state-5-20
  ==
::
++  upgrade-io
  |=  [new=state-5-20 =bowl:gall]
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
  ^-  state-5-20
  ?-  -.old
    %'5-19'  (convert-5-19-to-5-20 old)
      %'5-20'
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
      =/  goals=(list (set id))
        (turn ~(val by pools.store.old) |=(pool ~(key by goals)))
      =/  all-goals=(set id)
        =|  all-goals=(set id)
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
++  convert-5-19-to-5-20
  |=  =state-5-19
  ^-  state-5-20
  :*  %'5-20'
      pools.store.state-5-19
      local.store.state-5-19
      pool-info.store.state-5-19
      *json-tree:jot
  ==
--
