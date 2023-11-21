::  vent: agent wrapper for venter pattern
::
::    usage: %-(agent:vent your-agent)
::
/+  vio=ventio, default-agent
|%
++  agent
  |=  =agent:gall
  ^-  agent:gall
  !.
  |_  =bowl:gall
  +*  this  .
      def   ~(. (default-agent this %.n) bowl)
      ag    ~(. agent bowl)
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card:agent:gall agent:gall)
    :: forward vent requests directly to the vine
    ::
    ?+    mark
      =^  cards  agent  (on-poke:ag mark vase)
      [cards this]
        %vent-request
      :_(this ~[(to-vine:vio vase bowl)])
        %send-cards
      ?>  =(our src):bowl
      [;;((list card:agent:gall) q.vase) this]
    ==
  ::
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    (on-peek:ag path)
  ::
  ++  on-init
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  on-init:ag
    [cards this]
  ::
  ++  on-save   on-save:ag
  ::
  ++  on-load
    |=  old-state=vase
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  (on-load:ag old-state)
    [cards this]
  ::
  ++  on-watch
    |=  =path
    ^-  (quip card:agent:gall agent:gall)
    ?+    path
      =^  cards  agent  (on-watch:ag path)
      [cards this]
      [%vent @ta @ta @ta ~]  ?>(=(src.bowl (slav %p i.t.path)) `this)
      [%vent-on-arvo ~]      ?>(=(our src):bowl `this)
      [%vent-on-agent ~]     ?>(=(our src):bowl `this) 
    ==
  ::
  ++  on-leave
    |=  =path
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  (on-leave:ag path)
    [cards this]
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    ^-  (quip card:agent:gall agent:gall)
    =/  =card:agent:gall
      [%give %fact ~[/vent-on-agent] %noun !>(`noun`[bowl wire sign])]
    =^  cards  agent  (on-agent:ag wire sign)
    [[card cards] this]
  ::
  ++  on-arvo
    |=  [=wire =sign-arvo]
    ^-  (quip card:agent:gall agent:gall)
    =/  =card:agent:gall
      [%give %fact ~[/vent-on-arvo] %noun !>(`noun`[bowl wire sign-arvo])]
    ?.  ?=([%vent @ @ @ ~] wire)
      =^  cards  agent  (on-arvo:ag wire sign-arvo)
      [[card cards] this]
    ?.  ?=([%khan %arow *] sign-arvo)  (on-arvo:def wire sign-arvo)
    %-  (slog ?:(?=(%.y -.p.sign-arvo) ~ p.p.sign-arvo))
    :_(this [card (vent-arow:vio wire p.sign-arvo)])
  ::
  ++  on-fail
    |=  [=term =tang]
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  (on-fail:ag term tang)
    [cards this]
  --
--
