/-  spider, act=action, p=pools
/+  vio=ventio
:: catches invalid API calls at compile time
|%
++  poke
  |=  [dst=ship pok=poke:api]
  =/  m  (strand:vio ,~)
  ^-  form:m
  ~&  %api-poking
  %+  poke:vio  [dst ;;(dude:gall -.pok)]
  [;;(mark +<.pok) !>(+>.pok)]
::
++  vent
  |*  a=mold
  =/  m  (strand:vio ,a)
  |=  [dst=ship vnt=vent:api]
  ^-  form:m
  ~&  %api-venting
  %+  (vent:vio ,a)  [dst ;;(dude:gall -.vnt)]
  [;;(mark +<.vnt) +>.vnt]
::
++  api
  |%
  +$  poke
    $%  [%goals poke:goals]
        [%pools poke:pools]
    ==
  +$  vent
    $%  [%goals vent:goals]
        [%pools vent:pools]
    ==
  --
++  goals
  |%
  +$  poke
    $%  [%goal-transition transition:act]
        [%goal-compound-transition compound-transition:act]
    ==
  +$  vent
    $%  poke
        [%goal-local-action local-action:act]
        [%goal-pool-action pool-action:act]
        [%goal-membership-action membership-action:act]
        [%goal-view view:act]
    ==
  --
++  pools
  |%
  +$  poke
    $%  [%pools-transition transition:p]
    ==
  +$  vent
    $%  poke
        [%pools-action action:p]
        [%pools-gesture gesture:p]
        [%pools-view view:p]
    ==
  --
--
