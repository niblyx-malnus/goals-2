/-  gol=goals, act=action
/+  vent, dbug, default-agent, verb,
    gol-cli-emot, gs=gol-cli-state, gol-cli-node,
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
+$  inflated-state  [state-5-13:gs =trace:gol] 
+$  card     card:agent:gall
--
=|  inflated-state
=*  state  -
::
%+  verb  |
%-  agent:dbug
%-  agent:vent
^-  agent:gall
|_  =bowl:gall
+*  this    .
    def   ~(. (default-agent this %.n) bowl)
    hc    ~(. +> [bowl ~])
    cc    |=(cards=(list card) ~(. +> [bowl cards]))
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
  =/  new=state-5-13:gs   (convert-to-latest:gs old)
  =/  cards=(list card)  (upgrade-io:gs new bowl)
  [cards this(-.state new, trace *trace:gol)]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %goal-action
    =/  axn=action:act  !<(action:act vase)
    ~&  received-axn+axn
    ~&  [src+src our+our]:bowl
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
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
