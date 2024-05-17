/-  c=calendar
/+  clib=calendars, vent, dbug, verb, default-agent
:: Import to force compilation during development.
::
/=  x  /ted/vines/calendar
|%
+$  card     card:agent:gall
--
=|  state-0:c
=*  state  -
%-  agent:dbug
%+  verb  |
%-  agent:vent
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    cal   ~(abed agent:clib [bowl state])
::
++  on-init
  ^-  (quip card _this)
  =.  calendars  (~(put by calendars) [our.bowl %our] *calendar:c)
  [~ this]
::
++  on-save   !>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  :: =+  !<(old=state-0:c ole)
  =.  state  *state-0:c
  =.  calendars  (~(put by calendars) [our.bowl %our] *calendar:c)
  [~ this]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ~&  "poke to {<dap.bowl>} agent with mark {<mark>}"
  ?+    mark  (on-poke:def mark vase)
      %calendar-transition
    ?>  =(src our):bowl
    =+  !<(tan=transition:c vase)
    ~&  received-transition+tan
    =^  cards  state
      abet:(handle-transition:cal tan)
    [cards this]
    ::
      %calendar-compound-transition
    ?>  =(src our):bowl
    =+  !<(tan=compound-transition:c vase)
    ~&  received-compound-transition+tan
    =^  cards  state
      abet:(handle-compound-transition:cal tan)
    [cards this]
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
