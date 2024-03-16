/-  *action
/+  vent, bout, dbug, default-agent, verb
::
|%
+$  state-0
  $:  %0
      moon-as-planet=?
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
      %noun
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
    ==
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %moon-as-planet ~]  ``noun+!>(moon-as-planet)
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
:: An invite means we are prepared to auto-accept you to the whitelist
:: when you make a request and after which you can subscribe.
:: for each pool we 
:: (ma
:: A request is a request to be added to the whitelist after which you can
:: subscribe  
