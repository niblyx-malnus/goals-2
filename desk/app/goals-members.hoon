/-  *action
/+  vent, bout, dbug, default-agent, verb
/=  x  /ted/vines/goals-members
/=  x  /mar/membership-action
/=  x  /mar/membership-transition
::
|%
+$  invite
  $:  from=ship
  ==
+$  state-0
  $:  %0
      moon-as-planet=?
      =sub-histories
      incoming-invites=(map pid invite)
      outgoing-invites=(map pid (map ship invite))
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
  ~&  %nuking-goals-members-agent
  [~ this(state *state-0)]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ~&  "%goals-members app: receiving mark {(trip mark)}"
  ?+    mark  (on-poke:def mark vase)
      %noun
    ?>  =(src our):bowl
    ?>  =(%moon q.vase)
    =.  moon-as-planet  !moon-as-planet
    ~&  moon-as-planet+moon-as-planet
    [~ this]
    ::
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
      ::
        %add-incoming-invite
      ?>  =(src.bowl host.pid.tan)
      =.  incoming-invites  (~(put by incoming-invites) [pid from]:tan)
      [~ this]
      ::
        %add-outgoing-invite
      ?>  =(src our):bowl
      ?>  =(our.bowl host.pid.tan)
      =/  pool-invites=(map ship invite)  (~(gut by outgoing-invites) pid.tan ~)
      =.  pool-invites  (~(put by pool-invites) [to from]:tan)
      =.  outgoing-invites  (~(put by outgoing-invites) pid.tan pool-invites)
      [~ this]
    ==
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %moon-as-planet ~]  ``noun+!>(moon-as-planet)
    [%x %outgoing-invites ~]  ``noun+!>(outgoing-invites)
    [%x %incoming-invites ~]  ``noun+!>(incoming-invites)
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
