/-  *goals, old-goals, update
/+  gol-cli-node
:: step-wisdom vs. step-nomadism
:: https://gist.github.com/philipcmonk/de5ba03b3ea733387fd13b758062cfce
|%
+$  card  card:agent:gall
::
+$  state-5-18  [%'5-18' =store]
+$  state-5-17  [%'5-17' =store:old-goals]
+$  versioned-state
  $%  state-5-17
      state-5-18
  ==
::
++  upgrade-io
  |=  [new=state-5-18 =bowl:gall]
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
  ^-  state-5-18
  ?-  -.old
    %'5-17'  (convert-5-17-to-5-18 old)
      %'5-18'
    %=    old
        pools.store
      %-  ~(gas by *pools)
      %+  turn  ~(tap by pools.store.old)
      |=  [=pin =pool]
      [pin pool]
      :: [pin (inflate-pool:fl pool)]
      ::
        pool-order.local.store
      ?:  =((sy pool-order.local.store.old) ~(key by pools.store.old))
        pool-order.local.store.old
      ~(tap in ~(key by pools.store.old))
      ::
      ::   goal-order.local.store
      :: =/  all-goals=(set id)
      ::   
      :: ?:  =((sy goal-order.local.store.old) ~(key by goals.store.old))
      ::   goal-order.local.store.old
      :: ~(tap in ~(key by goals.store.old))
    ==
  ==
:: Development states
::
++  convert-5-17-to-5-18
  |=  =state-5-17
  ^-  state-5-18
  =/  =local
    :*  order.local.store.state-5-17
        pools.local.store.state-5-17
        ~  ~
        settings.local.store.state-5-17
    ==
  [%'5-18' pools.store.state-5-17 local pool-info.store.state-5-17]
--
