::  vent: agent wrapper for venter pattern
::
::    usage: %-(agent:vent your-agent)
::
/+  vio=ventio, default-agent
|%
+$  card  card:agent:gall
::
++  utils
  |*  agent=*
  |_  =bowl:gall
  :: forward vent requests directly to the vine
  ::
  ++  to-vine
    |=  [vid=vent-id:vio =page]
    ^-  (quip card _agent)
    =/  args=cage  noun+!>(`[bowl vid page])
    :: vine must have same desk and same name as agent in /ted/vines
    ::
    =/  =(fyrd:khan cage)  [q.byk.bowl (cat 3 'vines-' dap.bowl) args]
    :_(agent [%pass (en-path:vio vid) %arvo %k %fard fyrd]~)
  :: re-interpret a poke as a vent-request
  ::
  ++  vent-cage
    |=  [=mark =vase]
    ^-  (quip card _agent)
    (to-vine [*vent-id:vio mark q.vase])
  :: return the vine output on the vent path
  ::
  ++  vent-arow
    |=  [=path arow=(avow:khan cage)]
    ^-  (quip card _agent)
    =/  vid=vent-id:vio  (de-path:vio path)
    =?  arow  ?=(%| -.arow)
        :-  %|
        :-  mote.p.arow
        :_  tang.p.arow
        leaf+"crash in {(scow %p our.bowl)}'s %{(trip dap.bowl)} vine"
    =/  =cage  ?-(-.arow %& p.arow, %| goof+!>(p.arow))
    %-  (slog ?:(?=(%.y -.arow) ~ p.arow))
    :_  agent
    :~  [%give %fact ~[path] cage]
        [%give %kick ~[path] ~]
    ==
  --
::
++  agent
  |=  =agent:gall
  ^-  agent:gall
  !.
  |_  =bowl:gall
  +*  this  .
      def   ~(. (default-agent this %.n) bowl)
      vnt   ~(. (utils this) bowl)
      ag    ~(. agent bowl)
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card agent:gall)
    :: forward vent requests directly to the vine
    ::
    ?+    mark
      =^  cards  agent  (on-poke:ag mark vase)
      [cards this]
      ::
      %vent-request  (to-vine:vnt !<(request:vio vase))
      ::
        %send-cards
      ?>  =(our src):bowl
      [;;((list card) q.vase) this]
    ==
  ::
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    ?.  ?=([@ %vent *] path)
      (on-peek:ag path)
    ?+  path  [~ ~]
      [%x %vent %subscriptions ~]  ``noun+!>([wex sup]:bowl)
    ==
  ::
  ++  on-init
    ^-  (quip card agent:gall)
    =^  cards  agent  on-init:ag
    [cards this]
  ::
  ++  on-save   on-save:ag
  ::
  ++  on-load
    |=  old-state=vase
    ^-  (quip card agent:gall)
    =^  cards  agent  (on-load:ag old-state)
    [cards this]
  ::
  ++  on-watch
    |=  =path
    ^-  (quip card agent:gall)
    ?+    path
      =^  cards  agent  (on-watch:ag path)
      [cards this]
      [%vent @ta @ta @ta ~]  ?>(=(src.bowl (slav %p i.t.path)) `this)
      [%vent-on-agent ~]     ?>(=(our src):bowl `this) 
    ==
  ::
  ++  on-leave
    |=  =path
    ^-  (quip card agent:gall)
    =^  cards  agent  (on-leave:ag path)
    [cards this]
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    ^-  (quip card agent:gall)
    =^  cards  agent  (on-agent:ag wire sign)
    =;  =card
      [[card cards] this]
    (agent-update wire sign bowl)
  ::
  ++  on-arvo
    |=  [=wire =sign-arvo]
    ^-  (quip card agent:gall)
    =^  cards  agent
      ?.  ?=([%vent @ @ @ ~] wire)
        (on-arvo:ag wire sign-arvo)
      ?.  ?=([%khan %arow *] sign-arvo)
        (on-arvo:def wire sign-arvo)
      (vent-arow:vnt wire p.sign-arvo)
    [cards this]
  ::
  ++  on-fail
    |=  [=term =tang]
    ^-  (quip card agent:gall)
    =^  cards  agent  (on-fail:ag term tang)
    [cards this]
  --
::
++  agent-update
  |=  [=wire =sign:agent:gall =bowl:gall]
  ^-  card
  [%give %fact ~[/vent-on-agent] %noun !>(`noun`[bowl wire sign])]
--
