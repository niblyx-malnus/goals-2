/+  p=pools, vent, bout, dbug, default-agent, verb
/=  x  /ted/vines/pools
/=  x  /mar/pools/transition
/=  x  /mar/pools/gesture
/=  x  /mar/pools/action
::
|%
+$  card     card:agent:gall
--
::
=|  state-0:p
=*  state  -
::
%+  verb  |
:: %-  agent:bout
%-  agent:dbug
%-  agent:vent
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    pul   ~(. p bowl ~ state)
::
++  on-init   on-init:def
++  on-save   !>(state)
::
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  =/  old  !<(state-0:p old-vase)
  [~ this(state old)]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src our):bowl
  ~&  "%pools app: receiving mark {(trip mark)}"
  ?+    mark  (on-poke:def mark vase)
      %pools-transition
    =+  !<(tan=transition:p vase)
    ~&  received-transition+tan
    =^  cards  state
      abet:(handle-transition:pul tan)
    [cards this]
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %state ~]  ``noun+!>(state)
    [%x %pools ~]  ``noun+!>(pools)
    [%x %incoming-invites ~]   ``noun+!>(incoming-invites)
    [%x %outgoing-requests ~]  ``noun+!>(outgoing-requests)
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
