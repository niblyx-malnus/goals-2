/-  gol=goals, act=action, jot=json-tree
/+  vent, bout, dbug, default-agent, verb,
    tree=filetree, gol-cli-emot, gs=gol-cli-state, gol-cli-node,
:: import during development to force compilation
::
    gol-cli-json
/=  x  /mar/goal/action
/=  x  /mar/goal/view
/=  x  /mar/json-tree-action
/=  x  /mar/json-tree-transition
/=  x  /mar/mimex
/=  x  /ted/vines/goals
/=  x  /ted/test
::
|%
+$  inflated-state  [state-5-25:gs =trace:gol] 
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
  =/  new=state-5-25:gs   (convert-to-latest:gs old)
  =/  cards=(list card)  (upgrade-io:gs new bowl)
  [cards this(-.state new, trace *trace:gol)]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src our):bowl
  ~&  "%goals app: receiving mark {(trip mark)}"
  ?+    mark  (on-poke:def mark vase)
      %goal-action
    =/  axn=action:act  !<(action:act vase)
    ~&  received-axn+axn
    =^  cards  state
      abet:(handle-action:emot axn)
    [cards this]
    ::
      %json-tree-transition
    =+  !<(tan=transition:jot vase)
    ~&  "%goals app: receiving transition {(trip -.tan)}"
    ?-    -.tan
        %put
      |-
      ?~  paths.tan
        `this
      =/  jons=(map @ta json)
        (fall (~(get of json-tree.store) (snip path.i.paths.tan)) ~)
      =.  jons  (~(put by jons) (rear path.i.paths.tan) json.i.paths.tan)
      =.  json-tree.store
        (~(put of json-tree.store) (snip path.i.paths.tan) jons)
      $(paths.tan t.paths.tan)
      ::
        %del
      |-
      ?~  paths.tan
        `this
      =/  jons=(map @ta json)
        (fall (~(get of json-tree.store) (snip i.paths.tan)) ~)
      =.  jons  (~(del by jons) (rear i.paths.tan))
      =.  json-tree.store
        ?~  jons
          (~(del of json-tree.store) (snip i.paths.tan))
        (~(put of json-tree.store) (snip i.paths.tan) jons)
      $(paths.tan t.paths.tan)
    ==
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %store ~]  ``noun+!>(store)
    [%x %pools ~]  ``json+!>((enjs-pools:gol-cli-json pools.store))
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
    |=  =pid:gol
    :_  %json
    (rap 3 (scot %p host.pid) '_' name.pid ~)
    ::
      [%pools pid=@ta %json ~]
    =+  ;;  pid=[host=@t name=@t ~]  (rash pid.pole cab-split)
    =/  host=@p  (slav %p host.pid)
    [%& json+!>((enjs-pool:gol-cli-json (~(got by pools.store) [host name.pid])))]
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
    [%& json+!>((enjs-goal-order:gol-cli-json goal-order.local.store))]
    ::
      [%local %pools %json ~]
    [%& json+!>((enjs-pool-order:gol-cli-json pool-order.local.store))]
    ::
      [%local %settings %json ~]
    [%& json+!>((enjs-settings:gol-cli-json settings.local.store))]
    ::
      [%local %goals ~]
    !!
    :: :-  %|  :_  ~
    :: %+  turn  ~(tap in ~(key by goals.local.store))
    :: |=  =gid:gol
    :: :_  %json
    :: (rap 3 (scot %p host.pid.gid) '_' name.pid.gid '_' key.gid ~)
    ::
      [%local %goals gid=@ta %json ~]
    !!
    :: =+  ;;  gid=[host=@t name=@t key=@t ~]  (rash gid.pole cab-split)
    :: =/  host=@p  (slav %p host.gid)
    :: [%& json+!>((enjs-goal-local:gol-cli-json (~(got by goals.local.store) [[host name.gid] key.gid])))]
    ::
      [%'pool_info' ~]
    :-  %|  :_  ~
    %+  turn  ~(tap in ~(key by pool-info.store))
    |=  =pid:gol
    :_  %json
    (rap 3 (scot %p host.pid) '_' name.pid ~)
    ::
      [%'pool_info' pid=@ta %json ~]
    =+  ;;  pid=[host=@t name=@t ~]  (rash pid.pole cab-split)
    =/  host=@p  (slav %p host.pid)
    [%& json+!>((enjs-pool-data:gol-cli-json (~(got by pool-info.store) [host name.pid])))]
  ==
::
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
