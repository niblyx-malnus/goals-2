:: stores IANA timezone data in raw format
:: and regularly fetches IANA data
::
/-  *iana
/+  iana-parser, parser-util, vent, verb, dbug, default-agent
/=  x  /ted/vines/iana
/=  x  /mar/iana/data
/=  x  /mar/iana/action
::
|%
+$  card  card:agent:gall
+$  state-0
  $:  %0
      next=(unit @da)
      iana-data=(unit iana)
  ==
--
::
=|  state-0
=*  state  -

%+  verb  |
%-  agent:dbug
=<
%-  agent:vent
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    vnt   ~(. (utils:vent this) bowl)
    hc    ~(. +> [bowl ~])
::
++  on-init   on-init:def
::
++  on-save   !>(state)
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
      %iana-action
    =^  cards  state
      abet:(handle-iana-action:hc !<(action:iana vase))
    [cards this]
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?.  ?=([%change ~] path)
    (on-watch:def path)
  ?>  =(our src):bowl
  :: simple notification of change to iana database
  ::
  =^  cards  state
    abet:notify:hc
  [cards this]
::
++  on-leave  on-leave:def
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %iana ~]   ``iana-data+!>(iana-data)
    [%x %watch ~]  ``loob+!>(?=(^ next))
  ==
::
++  on-agent  on-agent:def
::
++  on-arvo
  |=  [=(pole knot) =sign-arvo]
  ^-  (quip card _this)
  ?+    pole  (on-arvo:def pole sign-arvo)
      [%wait until=@ta ~]
    ?+    sign-arvo  (on-arvo:def pole sign-arvo)
        [%behn %wake *]
      ?^  error.sign-arvo
        (on-arvo:def pole sign-arvo)
      ?.  =(next (slaw %da until.pole))
        ~|('%iana: unexpected timer' !!)
      =^  cards  state
        abet:(set-timer:hc (add now.bowl ~d1))
      [cards this]
    ==
  ==
::
++  on-fail   on-fail:def
--
::
|_  [=bowl:gall cards=(list card)]
+*  core  .
++  abet  [(flop cards) state]
++  emit  |=(=card core(cards [card cards]))
++  emil  |=(cadz=(list card) core(cards (weld cadz cards)))
::
++  handle-iana-action
  |=  axn=action:iana
  ^-  _core
  ?-    -.axn
    %import-blob  (import-blob data.axn)
    ::
      %leave-iana
    =.  core  (rest-timer (need next))
    notify(iana-data ~)
    ::
      %watch-iana
    ?^  next
      core :: already watching, ignore
    (set-timer (add now.bowl ~d1))
  ==
::
++  set-timer
  |=  until=@da
  ^-  _core
  (emit(next [~ until]) %pass /wait/(scot %da until) %arvo %b %wait until)
::
++  rest-timer
  |=  until=@da
  ^-  _core
  (emit(next ~) %pass /wait/(scot %da until) %arvo %b %rest until)
::
++  notify  `_core`(emit %give %fact ~[/change] noun+!>(0))
::
++  import-blob
  |=  data=@t
  ^-  _core
  =/  =wall  (turn (to-wain:format data) trip)
  =/  =iana  (parse-timezones:iana-parser wall)
  =/  cap=@ud  1.000.000 :: limit timezones for each continent for faster testing
  =.  zones.iana
    %-  ~(gas by *zones:^iana)
    (scag cap ~(tap by zones.iana))
  =/  new-iana-data=^iana
    ?~  iana-data  *^iana
    u.iana-data
  =:  zones.new-iana-data  (~(uni by zones.new-iana-data) zones.iana)
      rules.new-iana-data  (~(uni by rules.new-iana-data) rules.iana)
      links.new-iana-data  (~(uni by links.new-iana-data) links.iana)
    ==
  =.  iana-data  `new-iana-data
  ?:(=(iana-data `new-iana-data) core notify)
--
