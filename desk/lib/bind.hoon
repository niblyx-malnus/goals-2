/+  agentio, default-agent
|%
++  binding-to-cord
  |=  binding:eyre
  ^-  cord
  (rap 3 ?~(site '' u.site) '/' (join '/' path))
::
++  existing
  |=  =bowl:gall
  =+  .^  bindings=(list [binding:eyre duct action:eyre])
          %e  /(scot %p our.bowl)/[desk]/(scot %da now.bowl)
      ==
  (~(gas by *(map binding:eyre [duct action:eyre])) bindings)
::
++  bind-cards
  |=  $:  =bowl:gall
          cards=(list card:agent:gall)
          bindings=(list [=binding:eyre force=?])
      ==
  ^-  (list card:agent:gall)
  ?~  bindings
    cards
  =+  i.bindings
  =/  bound=?  (~(has by (existing bowl)) binding)
  ~?  >>  bound
    (rap 3 (binding-to-cord binding) ' is already bound' ~)
  =?  cards  |(force !bound) 
    :_(cards (~(connect pass:io /connect) binding dap.bowl))
  $(bindings t.bindings)
::
++  agent
  |=  bindings=(list [=binding:eyre force=?])
  |=  =agent:gall
  ^-  agent:gall
  !.
  |_  =bowl:gall
  +*  this  .
      ag    ~(. agent bowl)
      io    ~(. agentio bowl)
      def   ~(. (default-agent this %|) bowl)
  ::
  ++  on-init
    =^  cards  agent  on-init:ag
    :_(this (bind-cards bowl cards bindings))
  ::
  ++  on-save   on-save:ag
  ::
  ++  on-load
    |=  old-state=vase
    =^  cards  agent  (on-load:ag old-state)
    :_(this (bind-cards bowl cards bindings))
  ::
  ++  on-poke
    |=  [=mark =vase]
    =^  cards  agent  (on-poke:ag mark vase)
    [cards this]
  ::
  ++  on-peek   |=(=path (on-peek:ag path))
  ::
  ++  on-watch
    |=  =path
    ?:  ?=([%http-response *] path)
      [~ this]
    =^  cards  agent  (on-watch:ag path)
    [cards this]
  ::
  ++  on-leave
    |=  =path
    =^  cards  agent  (on-leave:ag path)
    [cards this]
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    =^  cards  agent  (on-agent:ag wire sign)
    [cards this]
  ::
  ++  on-arvo
    |=  [=wire =sign-arvo]
    ?.  ?=([%eyre %bound *] sign-arvo)
      =^  cards  agent  (on-arvo:ag wire sign-arvo)
      [cards this]
    ~&  ?:  accepted.sign-arvo
          [dap.bowl "bind accepted!" binding.sign-arvo]
        [dap.bowl "bind rejected!" binding.sign-arvo]
    [~ this]
  ::
  ++  on-fail
    |=  [=term =tang]
    =^  cards  agent  (on-fail:ag term tang)
    [cards this]
  --
--
