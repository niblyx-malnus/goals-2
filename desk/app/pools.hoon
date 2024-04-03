/+  p=pools, vent, bout, dbug, default-agent, verb
/=  x  /ted/vines/pools
/=  x  /mar/pools/transition
/=  x  /mar/pools/pool-transition
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
  ?+    pole  (on-watch:def pole)
      [%pool host=@ name=@ ~]
    =/  host=ship  (slav %p host.pole)
    ?>  =(host our.bowl)
    =/  =id:p    [host name.pole]
    =/  =pool:p  (~(got by pools) id)
    ?>  (~(has by members.pool) src.bowl)
    :: give initial update
    ::
    :_(this [%give %fact ~ pools-pool-transition+!>([%replace-pool pool])]~)
  ==
::
++  on-agent
  |=  [=(pole knot) =sign:agent:gall]
  ^-  (quip card _this)
  ?+    pole  (on-agent:def pole sign)
      [%pool host=@ name=@ ~]
    =/  host=ship  (slav %p host.pole)
    ?>  =(host src.bowl)
    =/  =id:p      [host name.pole]
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
      ?.  =(p.cage.sign %pools-pool-transition)
        (on-agent:def pole sign)
      =^  cards  state
        abet:(handle-pool-transition:pul id !<(pool-transition:p q.cage.sign))
      [cards this]
    ==
  ==
::
++  on-leave  on-leave:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
