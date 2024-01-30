/-  *goals, old-goals, update
/+  gol-cli-node
:: step-wisdom vs. step-nomadism
:: https://gist.github.com/philipcmonk/de5ba03b3ea733387fd13b758062cfce
|%
+$  card  card:agent:gall
::
+$  state-5-21  [%'5-21' =store]
+$  state-5-20  [%'5-20' =store:old-goals]
+$  versioned-state
  $%  state-5-20
      state-5-21
  ==
::
++  upgrade-io
  |=  [new=state-5-21 =bowl:gall]
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
  ^-  state-5-21
  ?-  -.old
    %'5-20'  (convert-5-20-to-5-21 old)
      %'5-21'
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
++  convert-5-20-to-5-21
  |=  =state-5-20
  ^-  state-5-21
  =/  pool-info
    %-  ~(gas by *(map pin pool-data))
    %+  turn  ~(tap by pool-info.store.state-5-20)
    |=  [=pin =pool-data:old-goals]
    ^-  [^pin ^pool-data]
    :-  pin
    :*  properties.pool-data
        tags.pool-data
        fields.pool-data
        tag-properties.pool-data
        field-properties.pool-data
        ~
    ==
  :*  %'5-21'
      pools.store.state-5-20
      local.store.state-5-20
      pool-info
      json-tree.store.state-5-20
  ==
--
