/-  p=pools
/+  lib=pools, vent, bout, dbug, default-agent, verb, default-subs, sub-count
/=  x  /ted/vines/pools
/=  x  /mar/pools/transition
/=  x  /mar/pools/pool-transition
/=  x  /mar/pools/gesture
/=  x  /mar/pools/local-action
/=  x  /mar/pools/pool-action
/=  x  /mar/pools/view
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
%-  (agent ,[%pool path]):sub-count
%-  agent:vent
^-  agent:gall
|_  =bowl:gall
+*  this  .
    dus   ~(. (default-subs this %.y %.y %.n) bowl)
    pul   ~(. lib bowl ~ state)
::
++  on-init   on-init:dus
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
  ~&  "poke to {<dap.bowl>} agent with mark {<mark>}"
  ?+    mark  (on-poke:dus mark vase)
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
  ?+    pole  (on-peek:dus pole)
    [%x %state ~]              ``noun+!>(state)
    [%x %pools ~]              ``noun+!>(pools)
    [%x %blocked ~]            ``noun+!>(blocked)
    [%x %incoming-invites ~]   ``noun+!>(incoming-invites)
    [%x %outgoing-requests ~]  ``noun+!>(outgoing-requests)
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
    =/  =id:p    [host name.pole]
    =/  =pool:p  (~(got by pools) id)
    ?>  (~(has by members.pool) src.bowl)
    :: give initial update
    ::
    :_(this [%give %fact ~ pools-pool-transition+!>([%init-pool pool])]~)
  ==
::
++  on-agent
  |=  [=(pole knot) =sign:agent:gall]
  ^-  (quip card _this)
  ?+    pole  (on-agent:dus pole sign)
      [%pool host=@ name=@ ~]
    =/  host=ship  (slav %p host.pole)
    ?>  =(host src.bowl)
    =/  =id:p      [host name.pole]
    ?+    -.sign  (on-agent:dus pole sign)
        %fact
      ?.  =(p.cage.sign %pools-pool-transition)
        (on-agent:dus pole sign)
      =+  !<(tan=pool-transition:p q.cage.sign)
      =^  cards  state
        abet:(handle-transition:pul %update-pool id tan)
      [cards this]
    ==
  ==
::
++  on-leave  on-leave:dus
++  on-arvo   on-arvo:dus
++  on-fail   on-fail:dus
--
