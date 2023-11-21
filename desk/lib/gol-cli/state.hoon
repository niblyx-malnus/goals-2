/-  *goals, old-goals, update, *group :: need to keep for historical reasons
:: step-wisdom vs. step-nomadism
:: https://gist.github.com/philipcmonk/de5ba03b3ea733387fd13b758062cfce
|%
+$  card  card:agent:gall
::
+$  state-5-12  [%'5-12' =store]
+$  state-5-11  [%'5-11' =store:old-goals]
+$  versioned-state
  $%  state-5-11
      state-5-12
  ==
::
++  upgrade-io
  |=  [new=state-5-12 =bowl:gall]
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
  ^-  state-5-12
  ?-  -.old
    %'5-11'  (convert-5-11-to-5-12 old)
      %'5-12'
    %=    old
        pools.store
      %-  ~(gas by *pools)
      %+  turn  ~(tap by pools.store.old)
      |=  [=pin =pool]
      [pin pool]
      :: [pin (inflate-pool:fl pool)]
    ==
  ==
::
:: Development states
::
++  convert-5-11-to-5-12
  |=  =state-5-11
  ^-  state-5-12
  !!
--
