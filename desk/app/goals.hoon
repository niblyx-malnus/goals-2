/-  gol=goals, act=action
/+  goals, vent, bout, dbug, default-agent, verb,
    tree=filetree, gs=gol-cli-state, gol-cli-node,
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
%-  agent:vent
^-  agent:gall
:: %-  agent:tree
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    det   ~(. default:tree bowl)
    ghc   ~(. agent:goals bowl ~ state)
::
++  on-init   on-init:def
++  on-save   !>(state)
::
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  :: =/  old  !<(versioned-state:gs old-vase)
  =/  old  ;;(versioned-state:gs q.old-vase)
  =/  new=state-5-30:gs   (convert-to-latest:gs old)
  =/  cards=(list card)  (upgrade-io:gs new bowl)
  [cards this(state new)]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src our):bowl
  ~&  "%goals app: receiving mark {(trip mark)}"
  ?+    mark  (on-poke:def mark vase)
      %goal-transition
    =+  !<(tan=transition:act vase)
    ~&  received-transition+tan
    =^  cards  state
      abet:(handle-transition:ghc tan)
    [cards this]
    ::
      %goal-compound-transition
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
  ?+    pole  (on-peek:def pole)
    [%x %store ~]  ``noun+!>(store)
    [%x %pools ~]  ``json+!>((enjs-pools:gol-cli-json pools.store))
    [%x %local ~]  ``json+!>((enjs-local:gol-cli-json local.store))
  ==
::
++  on-watch
  |=  =(pole knot)
  ^-  (quip card _this)
  ?+    pole  (on-watch:def pole)
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
  ?+    pole  (on-agent:def pole sign)
      [%pool host=@ name=@ ~]
    =/  host=ship  (slav %p host.pole)
    ?>  =(host src.bowl)
    =/  =pid:gol      [host name.pole]
    ?+    -.sign  (on-agent:def pole sign)
        %watch-ack
      ?~  p.sign
        %-  (slog 'Subscription success.' ~)
        [~ this]
      %-  (slog 'Subscription failure.' ~)
      %-  (slog u.p.sign)
      [~ this]
      ::
        %kick
      :: resubscribe on kick
      ::
      %-  (slog '%pools: Got kick, resubscribing...' ~)
      :_(this [%pass pole %agent [src dap]:bowl %watch pole]~)
      ::
        %fact
      ?.  =(p.cage.sign %goal-pool-transition)
        (on-agent:def pole sign)
      =+  !<([mod=ship tan=pool-transition:act] q.cage.sign)
      =^  cards  state
        abet:(handle-pool-transition:ghc pid mod tan)
      :_  this
      :_  cards
      :*  %give  %fact  ~[/transitions]
          goal-transition+!>([%update-pool pid mod tan])
      ==
    ==
  ==
::
:: ++  on-tree   on-tree:det
::
++  on-leave  on-leave:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
