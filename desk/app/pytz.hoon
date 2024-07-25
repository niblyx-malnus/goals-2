/-  p=pytz
/+  pytz, vent, verb, dbug, default-agent
:: import to force compilation during development
::
/=  x  /ted/vines/pytz
::
|%
+$  card     card:agent:gall
+$  state-0  [%0 =zones:p]
--
::
%-  agent:dbug
%+  verb  |
=|  state-0
=*  state  -
%-  agent:vent
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    vnt   ~(. (utils:vent this) bowl)
::
++  on-init   on-init:def
::
++  on-save  !>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  =+  !<(old=state-0 ole)
  [~ this(state old)]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src our):bowl
  ?+    mark  (on-poke:def mark vase)
    %noun  (vent-cage:vnt mark vase)
    ::
      %pytz-action
    =+  !<(axn=action:p vase)
    ?>  ?=(%put-zone -.axn)
    :-  ~
    %=    this
        zones
      %+  ~(put by zones)  name.axn
      (gas:zon:p *zone:p data.axn)
    ==
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %zones ~]  ``json+!>((zones:enjs:pytz zones))
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
