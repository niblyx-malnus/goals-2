/-  gol=goals, act=action, p=pools
/+  goals, vent, bout, dbug, default-agent, verb, sub-count,
    goals-node, default-subs,
:: import during development to force compilation
::
    goals-json
/=  x  /mar/goals/transition
/=  x  /mar/goals/pool-transition
/=  x  /mar/goals/compound-transition
/=  x  /mar/goals/local-action
/=  x  /mar/goals/pool-action
/=  x  /mar/goals/local-membership-action
/=  x  /mar/goals/pool-membership-action
/=  x  /mar/goals/view
/=  x  /ted/vines/goals
::
|%
+$  card        card:agent:gall
++  agent-subc  (agent ,[%pool path]):sub-count
--
::
=|  state-0:gol
=*  state  -
::
%+  verb  |
:: %-  agent:bout
%-  agent:dbug
%-  agent-subc
%-  agent:vent
^-  agent:gall
|_  =bowl:gall
+*  this  .
    dus   ~(. (default-subs this %.n %.y %.n) bowl)
    det   ~(. default:tree bowl)
    ghc   ~(. agent:goals bowl ~ state)
    vnt   ~(. (utils:vent this) bowl)
::
++  on-init
  ^-  (quip card _this)
  :_  this
  ;:  weld
    subscribe-to-pools-agent:ghc
    [poke-desk-into-venter:ghc]~
  ==
::
++  on-save   !>(state)
::
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  =/  old  !<(state-0:gol old-vase)
  :_  this(state old)
  ;:  weld
    subscribe-to-pools-agent:ghc
    [poke-desk-into-venter:ghc]~
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ~&  "poke to {<dap.bowl>} agent with mark {<mark>}"
  ?+    mark  (on-poke:dus mark vase)
      %goals-transition
    ?>  =(src our):bowl
    =+  !<(tan=transition:act vase)
    :: cannot update pool with a direct transition
    ::
    ?<  ?=(%update-pool -.tan)
    ~&  received-transition+tan
    =^  cards  state
      abet:(handle-transition:ghc tan)
    [cards this]
    ::
      %goals-compound-transition
    ?>  =(src our):bowl
    =+  !<(tan=compound-transition:act vase)
    ~&  received-compound-transition+tan
    =^  cards  state
      abet:(handle-compound-transition:ghc tan)
    [cards this]
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:dus pole)
    [%x %store ~]  ``noun+!>(store)
    [%x %pools ~]  ``json+!>((enjs-pools:goals-json pools.store))
    [%x %local ~]  ``json+!>((enjs-local:goals-json local.store))
  ==
::
++  on-watch
  |=  =(pole knot)
  ^-  (quip card _this)
  ?+    pole  (on-watch:dus pole)
    [%transitions ~]  ?>(=(src our):bowl [~ this])
    ::
      [%pool host=@ name=@ ~]
    =/  host=ship  (slav %p host.pole)
    ?>  =(host our.bowl)
    =/  =pid:gol    [host name.pole]
    =/  =pool:gol  (~(got by pools.store) pid)
    ?>  (~(has by perms.pool) src.bowl)
    :: give initial update
    ::
    :_(this [%give %fact ~ goals-pool-transition+!>([%init-pool pool])]~)
  ==
::
++  on-agent
  |=  [=(pole knot) =sign:agent:gall]
  ^-  (quip card _this)
  ?+    pole  (on-agent:dus pole sign)
      [%pool host=@ name=@ ~]
    =/  host=ship  (slav %p host.pole)
    ?>  =(host src.bowl)
    =/  =pid:gol      [host name.pole]
    ?+    -.sign  (on-agent:dus pole sign)
        %fact
      ?.  =(p.cage.sign %goals-pool-transition)
        (on-agent:dus pole sign)
      =+  !<(tan=pool-transition:act q.cage.sign)
      ~&  receiving-pool-transition+[pid+pid tan+tan]
      =^  cards  state
        abet:(handle-transition:ghc %update-pool pid tan)
      [cards this]
    ==
    ::
      [%pools-transitions ~]
    ?+    -.sign  (on-agent:dus pole sign)
        %kick
      %-  (slog leaf+"{<dap.bowl>} got kick from {<src.bowl>} on wire {<wire>}" ~)
      :_  this  :_  ~
      :*  %pass  /pools-transitions  %agent
          [our.bowl %pools]  %watch  /transitions
      ==
      ::
        %fact
      ?.  =(p.cage.sign %pools-transition)
        (on-agent:dus pole sign)
      (vent-cage:vnt cage.sign)
    ==
  ==
::
++  on-leave  on-leave:dus
++  on-arvo   on-arvo:dus
++  on-fail   on-fail:dus
--
