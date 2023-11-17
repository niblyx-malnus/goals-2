/-  gol=goals, vyu=views, update
/+  gol-cli-traverse, j=gol-cli-json
|_  =store:gol
:: TODO: Sever this data structure from the core backend data
:: structure
++  view-data
  |=  =parm:tree:vyu
  ^-  data:tree:vyu
  :: =-  ~&(- -)
  ?-    -.type.parm
    %main  [(unify-pools-tags pools) (unify-pools-tags cache)]:[store .]
    ::
      %pool
    :_  ~
    %-  unify-pools-tags
    %+  ~(put by *pools:gol)
      pin.type.parm
    (~(got by pools.store) pin.type.parm)
    ::
      %goal
    =,  pin=pin.id.type.parm
    =/  =pool:gol   (~(got by pools.store) pin)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  descendents=(set id:gol)
      (virtual-progeny:tv id.type.parm)
    =/  =goals:gol
       %-  ~(gas by *goals:gol)
       %+  murn  ~(tap by goals.pool)
       |=  [=id:gol =goal:gol]
       ?.  (~(has in descendents) id)
         ~
       (some [id goal])
    ::
    :_(~ (unify-pools-tags (~(put by *pools:gol) pin pool(goals goals))))
  ==
::
++  unify-pools-tags
  |=  =pools:gol
  ^-  pools:gol
  %-  ~(gas by *pools:gol)
  %+  turn  ~(tap by pools)
  |=  [=pin:gol =pool:gol]
  [pin pool(goals (unify-tags goals.pool))]
::
++  unify-tags
  |=  =goals:gol
  ^-  goals:gol
  %-  ~(gas by *goals:gol)
  %+  turn  ~(tap by goals)
  |=  [=id:gol =goal:gol]
  ^-  [id:gol goal:gol]
  :-  id
  %=    goal
      tags
   %-  ~(uni in tags.goal)
   ?~  get=(~(get by goals.local.store) id)
     ~
   tags.u.get
  ==
::
++  dejs
  =,  dejs:format
  |%
  ++  view-parm
    ^-  $-(json parm:tree:vyu)
    (ot ~[type+type])
  ::
  ++  type
    ^-  $-(json type:tree:vyu)
    %-  of
    :~  main+|=(jon=json ?>(?=(~ jon) ~))
        pool+pin:dejs:j
        goal+id:dejs:j
    ==
  --
::
++  enjs
  =,  j
  =,  enjs:format
  |%
  ++  view-data
    |=  =data:tree:vyu
    ^-  json
    %-  pairs
    :~  [%pools (enjs-pools pools.data)]
        [%cache (enjs-pools cache.data)]
    ==
  ::
  ++  view-parm
    |=  =parm:tree:vyu
    ^-  json
    (frond %type (type type.parm))
  ::
  ++  type
    |=  =type:page:vyu
    ^-  json
    ?-  -.type
      %main  (frond %main ~)
      %pool  (frond %pool s+(pool-id pin.type))
      %goal  (frond %goal (enjs-id id.type))
    ==
  --
--
