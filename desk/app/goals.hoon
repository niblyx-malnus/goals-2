/-  gol=goals, act=action, p=pools
/+  goals, vent, bout, dbug, default-agent, verb, sub-count,
    tree=filetree, gs=gol-cli-state, gol-cli-node, default-subs,
:: import during development to force compilation
::
    gol-cli-json
/=  x  /mar/goal/transition
/=  x  /mar/goal/pool-transition
/=  x  /mar/goal/compound-transition
/=  x  /mar/goal/local-action
/=  x  /mar/goal/pool-action
/=  x  /mar/goal/membership-action
/=  x  /mar/goal/view
/=  x  /ted/vines/goals
::
|%
+$  card     card:agent:gall
++  non-cab
  %+  cook
    |=(a=tape (rap 3 ^-((list @) a)))
  (star ;~(pose nud low hep dot sig fas))
++  cab-split  (most cab non-cab)
--
::
=|  state-5-30:gs
=*  state  -
::
%+  verb  |
:: %-  agent:bout
%-  agent:dbug
%-  (agent ,[%pool path]):sub-count
%-  agent:vent
^-  agent:gall
:: %-  agent:tree
|_  =bowl:gall
+*  this  .
    dus   ~(. (default-subs this %.y %.y %.n) bowl)
    det   ~(. default:tree bowl)
    ghc   ~(. agent:goals bowl ~ state)
    vnt   ~(. (utils:vent this) bowl)
::
++  on-init
    ^-  (quip card _this)
    :_  this
    :~  :*   %pass  /pools-transitions  %agent
             [our.bowl %pools]  %watch  /transitions
    ==  ==
::
++  on-save   !>(state)
::
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  :: =/  old  !<(versioned-state:gs old-vase)
  =/  old  ;;(versioned-state:gs q.old-vase)
  =/  new=state-5-30:gs   (convert-to-latest:gs old)
  =/  cards=(list card)  (upgrade-io:gs new bowl)
  =.  cards
    :_  cards
    [%pass /pools-transitions %agent [our.bowl %pools] %watch /transitions]
  [cards this(state new)]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ~&  "poke to {<dap.bowl>} agent with mark {<mark>}"
  ?+    mark  (on-poke:dus mark vase)
      %goal-transition
    ?>  =(src our):bowl
    =+  !<(tan=transition:act vase)
    ~&  received-transition+tan
    =^  cards  state
      abet:(handle-transition:ghc tan)
    [cards this]
    ::
      %goal-compound-transition
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
    [%x %pools ~]  ``json+!>((enjs-pools:gol-cli-json pools.store))
    [%x %local ~]  ``json+!>((enjs-local:gol-cli-json local.store))
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
    :_(this [%give %fact ~ goal-pool-transition+!>([host %init-pool pool])]~)
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
      ?.  =(p.cage.sign %goal-pool-transition)
        (on-agent:dus pole sign)
      =+  !<([mod=ship tan=pool-transition:act] q.cage.sign)
      =^  cards  state
        abet:(handle-transition:ghc %update-pool pid mod tan)
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
:: ++  on-tree   on-tree:det
::
++  on-leave  on-leave:dus
++  on-arvo   on-arvo:dus
++  on-fail   on-fail:dus
--
