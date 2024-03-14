/-  *action
/+  vent, bout, dbug, default-agent, verb
::
|%
+$  state-0
  $:  %0
      =sub-histories
  ==
+$  card     card:agent:gall
--
::
=|  state-0
=*  state  -
::
%+  verb  |
:: %-  agent:bout
%-  agent:dbug
%-  agent:vent
^-  agent:gall
|_  =bowl:gall
+*  this    .
    def   ~(. (default-agent this %.n) bowl)
::
++  on-init   on-init:def
++  on-save   !>(state)
::
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  :: =/  old  !<(state-0 old-vase)
  :: [~ this(state old)]
  [~ this(state *state-0)]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src our):bowl
  ~&  "%goals-members app: receiving mark {(trip mark)}"
  ?+    mark  (on-poke:def mark vase)
      %membership-transition
    =+  !<(tan=membership-transition vase)
    ~&  "%goals-members app: receiving transition {(trip -.tan)}"
    ?-    -.tan
        %pool-sub-event
      ?>  =(src our):bowl
      =/  =sub-history   (~(got by sub-histories) pid.tan)
      =.  sub-history    [[now.bowl sub-event.tan] sub-history]
      =.  sub-histories  (~(put by sub-histories) pid.tan sub-history)
      [~ this]
    ==
  ==
::
++  on-peek   on-peek:def
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
