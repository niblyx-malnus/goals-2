/-  gol=goals, act=action
/+  vent, bout, dbug, default-agent, verb,
    tree=filetree, gol-cli-emot, gs=gol-cli-state, gol-cli-node,
:: import during development to force compilation
::
    gol-cli-json
/=  x  /mar/goal/action
/=  x  /mar/goal/view
/=  x  /mar/goal/vent
/=  x  /ted/vines/goals
/=  x  /ted/test
::
|%
+$  inflated-state  [state-5-17:gs =trace:gol] 
+$  card     card:agent:gall
++  non-cab
  %+  cook
    |=(a=tape (rap 3 ^-((list @) a)))
  (star ;~(pose nud low hep dot sig fas))
++  cab-split  (most cab non-cab)
--
::
=|  inflated-state
=*  state  -
::
%+  verb  |
:: %-  agent:bout
%-  agent:dbug
%-  agent:vent
^-  agent:gall
%-  agent:tree
|_  =bowl:gall
+*  this    .
    def   ~(. (default-agent this %.n) bowl)
    det   ~(. default:tree bowl)
    emot  ~(. gol-cli-emot bowl ~ state)
::
++  on-init   on-init:def
++  on-save   !>(-.state)
::
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  :: =/  old  !<(versioned-state:gs old-vase)
  =/  old  ;;(versioned-state:gs q.old-vase)
  =/  new=state-5-17:gs   (convert-to-latest:gs old)
  =/  cards=(list card)  (upgrade-io:gs new bowl)
  [cards this(-.state new, trace *trace:gol)]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src our):bowl
  ?+    mark  (on-poke:def mark vase)
      %goal-action
    =/  axn=action:act  !<(action:act vase)
    ~&  received-axn+axn
    =^  cards  state
      abet:(handle-action:emot axn)
    [cards this]
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %store ~]  ``noun+!>(store)
  ==
::
++  on-watch
  |=  =(pole knot)
  ^-  (quip card _this)
  ?+    pole  (on-watch:def pole)
    [%settings ~]  ?>(=(src our):bowl `this)
  ==
::
++  on-tree
  |=  =(pole knot)
  ?+    pole  (on-tree:det pole)
      ~
    :+  %|  ~
    ~['pools' 'local' 'pool_info']
    ::
      [%pools ~]
    :-  %|  :_  ~
    %+  turn  ~(tap in ~(key by pools.store))
    |=  =pin:gol
    :_  %json
    (rap 3 (scot %p host.pin) '_' name.pin ~)
    ::
      [%pools pin=@ta %json ~]
    =+  ;;  pin=[host=@t name=@t ~]  (rash pin.pole cab-split)
    =/  host=@p  (slav %p host.pin)
    [%& json+!>((enjs-pool:gol-cli-json (~(got by pools.store) [host name.pin])))]
    ::
      [%local ~]
    :+  %|
      :~  [%order %json]
          [%pools %json]
          [%settings %json]
      ==
    ~[%goals]
    ::
      [%local %order %json ~]
    [%& json+!>((enjs-order:gol-cli-json order.local.store))]
    ::
      [%local %pools %json ~]
    [%& json+!>((enjs-pools-order:gol-cli-json pools.local.store))]
    ::
      [%local %settings %json ~]
    [%& json+!>((enjs-settings:gol-cli-json settings.local.store))]
    ::
      [%local %goals ~]
    :-  %|  :_  ~
    %+  turn  ~(tap in ~(key by goals.local.store))
    |=  =id:gol
    :_  %json
    (rap 3 (scot %p host.pin.id) '_' name.pin.id '_' key.id ~)
    ::
      [%local %goals id=@ta %json ~]
    =+  ;;  id=[host=@t name=@t key=@t ~]  (rash id.pole cab-split)
    =/  host=@p  (slav %p host.id)
    [%& json+!>((enjs-goal-local:gol-cli-json (~(got by goals.local.store) [[host name.id] key.id])))]
    ::
      [%'pool_info' ~]
    :-  %|  :_  ~
    %+  turn  ~(tap in ~(key by pool-info.store))
    |=  =pin:gol
    :_  %json
    (rap 3 (scot %p host.pin) '_' name.pin ~)
    ::
      [%'pool_info' pin=@ta %json ~]
    =+  ;;  pin=[host=@t name=@t ~]  (rash pin.pole cab-split)
    =/  host=@p  (slav %p host.pin)
    [%& json+!>((enjs-pool-data:gol-cli-json (~(got by pool-info.store) [host name.pin])))]
  ==
::
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
