/-  *goals, old-goals, update, *group :: need to keep for historical reasons
:: step-wisdom vs. step-nomadism
:: https://gist.github.com/philipcmonk/de5ba03b3ea733387fd13b758062cfce
|%
+$  card  card:agent:gall
::
+$  state-5-9  [%'5-9' =store]
+$  state-5-8  [%'5-8' =store:old-goals]
+$  versioned-state
  $%  state-5-8
      state-5-9
  ==
::
++  upgrade-io
  |=  [new=state-5-9 =bowl:gall]
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
  ^-  state-5-9
  ?-  -.old
    %'5-8'  (convert-5-8-to-5-9 old)
      %'5-9'
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
++  convert-5-8-to-5-9
  |=  =state-5-8
  ^-  state-5-9
  =/  =pools
    %-  ~(gas by *pools)
    %+  turn  ~(tap by pools.store.state-5-8)
    |=  [=pin pool:old-goals]
    ^-  [^pin pool]
    =/  =^goals
      %-  ~(gas by *^goals)
      %+  turn  ~(tap by goals)
      |=  [=id goal:old-goals]
      ^-  [^id goal]
      [id par kids kickoff deadline actionable chief deputies]
    :-  pin
    :*  goals
        ~
        owner
        perms
        properties
        (~(run by ^goals) |=(goal:old-goals tags))
        (~(run by ^goals) |=(goal:old-goals fields))
        tag-properties
        field-properties
    ==
  [%'5-9' pools ~ local.store.state-5-8]
--
