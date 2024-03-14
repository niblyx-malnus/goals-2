/-  gol=goals, act=action
/+  vent, bout, dbug, default-agent, verb,
    tree=filetree, gol-cli-emot, gs=gol-cli-state, gol-cli-node,
:: import during development to force compilation
::
    gol-cli-json
/=  x  /mar/goal/action
/=  x  /mar/goal/view
/=  x  /ted/vines/goals
/=  x  /ted/test
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
+*  this    .
    def   ~(. (default-agent this %.n) bowl)
    det   ~(. default:tree bowl)
    emot  ~(. gol-cli-emot bowl ~ state)
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
      %goal-action-and-mod
    =+  !<([mod=ship axn=action:act] vase)
    ~&  received-axn+axn
    =^  cards  state
      abet:(handle-action:emot mod axn)
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
    [%settings ~]  ?>(=(src our):bowl `this)
  ==
::
:: ++  on-tree   on-tree:det
::
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
