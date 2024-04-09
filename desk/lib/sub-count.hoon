::  sub-count: agent wrapper for counting subscription updatess
::
::    usage: %-((agent path-type):sub-count your-agent)
::
/+  vio=ventio, default-agent
/=  x  /mar/counted-update
/=  x  /mar/counted-action
/=  x  /mar/path-count
/=  x  /mar/wire-count
/=  x  /mar/subscription-kick
|%
++  agent
  =<  agent
  |%
  +$  card  card:agent:gall
  +$  sign  sign:agent:gall
  :: STATE DOES NOT PERSIST BETWEEN RELOADS
  ::
  +$  state-0
    $:  %0
        paths=(map path @) :: count updates sent (exclude on-watch updates)
        wires=(map wire @) :: count at latest received update
    ==
  ::
  ++  agent
    =|  state-0
    =*  state  -
    |=  path-type=mold
    |=  =agent:gall
    ^-  agent:gall
    !.
    |_  =bowl:gall
    +*  this  .
        def   ~(. (default-agent this %.n) bowl)
        ag    ~(. agent bowl)
        utl   ~(. (utils path-type) bowl ~ state)
    ::
    ++  on-poke
      |=  [=mark =vase]
      ^-  (quip card agent:gall)
      ?+    mark
        =^  cards  agent  (on-poke:ag mark vase)
        =^  cards  state  abet:(process-cards:utl cards)
        [cards this]
          %reset-path
        ?>  =(our src):bowl
        =+  !<([=path count=@] vase)
        =.  paths  (~(put by paths) path count)
        :_(this [%give %fact ~[/sub-counts] path-count+!>([path count])]~)
      ==
    ::
    ++  on-peek
      |=  =(pole knot)
      ^-  (unit (unit cage))
      ?.  ?=([@ %sub-count *] pole)
        (on-peek:ag pole)
      ?+  pole  [~ ~]
        [%x %sub-count %state ~]    ``noun+!>(state)
        [%x %sub-count %path t=*]   ``noun+!>((~(gut by paths) t.pole 0))
        [%x %sub-count %wire t=*]   ``noun+!>((~(gut by wires) t.pole 0))
      ==
    ::
    ++  on-init
      ^-  (quip card agent:gall)
      =^  cards  agent  on-init:ag
      =^  cards  state  abet:(process-cards:utl cards)
      [cards this]
    :: STATE DOES NOT PERSIST BETWEEN RELOADS
    ::
    ++  on-save   on-save:ag
    ::
    ++  on-load
      |=  old-state=vase
      ^-  (quip card agent:gall)
      =^  cards  agent  (on-load:ag old-state)
      =^  cards  state  abet:(process-cards:utl cards)
      [cards this]
    ::
    ++  on-watch
      |=  =path
      ^-  (quip card agent:gall)
      ?+    path
        =^  cards  agent  (on-watch:ag path)
        =^  cards  state  abet:(process-on-watch-cards:utl path cards)
        [cards this]
        [%sub-counts ~]  ?>(=(our src):bowl [~ this])
      ==
    ::
    ++  on-leave
      |=  =path
      ^-  (quip card agent:gall)
      =^  cards  agent  (on-leave:ag path)
      =^  cards  state  abet:(process-cards:utl cards)
      [cards this]
    ::
    ++  on-agent
      |=  [=wire =sign:agent:gall]
      ^-  (quip card agent:gall)
      ?.  ?=(%fact -.sign)
        =^  cards  agent  (on-agent:ag wire sign)
        =^  cards  state  abet:(process-cards:utl cards)
        [cards this]
      ?.  ?=(%counted-update p.cage.sign)
        =^  cards  agent  (on-agent:ag wire sign)
        =^  cards  state  abet:(process-cards:utl cards)
        [cards this]
      =/  [count=@ =cage]  (take-counted-update:utl q.cage.sign)
      =^  cards  agent  (on-agent:ag wire %fact cage)
      =^  cards  state  abet:(process-cards:utl cards)
      :_  this(wires (~(put by wires) wire count))
      :_(cards [%give %fact ~[/sub-counts] wire-count+!>([wire count])])
    ::
    ++  on-arvo
      |=  [=wire =sign-arvo]
      ^-  (quip card agent:gall)
      =^  cards  agent  (on-arvo:ag wire sign-arvo)
      =^  cards  state  abet:(process-cards:utl cards)
      [cards this]
    ::
    ++  on-fail
      |=  [=term =tang]
      ^-  (quip card agent:gall)
      =^  cards  agent  (on-fail:ag term tang)
      =^  cards  state  abet:(process-cards:utl cards)
      [cards this]
    --
  ::
  ++  utils
    |=  path-type=mold
    |_  [=bowl:gall cards=(list card) state-0]
    +*  this  .
        state  +<+>
    ++  abet  [(flop cards) state]
    ++  emit  |=(=card this(cards [card cards]))
    ++  emil  |=(cadz=(list card) this(cards (weld cadz cards)))
    ::
    ++  make-counted-update
      |=  [count=@ =mark =vase]
      ^-  cage
      counted-update+!>([count mark q.vase])
    ::
    ++  take-counted-update
      |=  =vase
      ^-  [@ cage]
      ~&  %taking-counted-update
      ~&  p.vase
      =+  !<([count=@ =page] vase)
      =/  nase=^vase  ((get-tube p.page) !>(q.page))
      ~&  [count+count mark+p.page]
      %-  (slog (sell nase) ~)
      [count p.page nase]
    ::
    ++  get-tube
      |=  =mark
      .^  tube:clay  %cc
        /(scot %p our.bowl)/[q.byk.bowl]/(scot %da now.bowl)/noun/[mark]
      ==
    ::
    ++  process-card
      |=  =card
      ^-  _this
      ?.  ?=([%give %fact *] card)
        (emit card)
      |-
      ?~  paths.p.card
        this
      ?~  (mole |.(;;(path-type i.paths.p.card)))
        (emit %give %fact ~[i.paths.p.card] cage.p.card)
      =/  count=@   (~(gut by paths) i.paths.p.card 0)
      =/  upd=cage  (make-counted-update +(count) cage.p.card)
      =.  this      (emit %give %fact ~[i.paths.p.card] upd)
      =.  this      (emit %give %fact ~[/sub-counts] path-count+!>([i.paths.p.card count]))
      %=  $
        paths.p.card  t.paths.p.card
        paths       (~(put by paths) i.paths.p.card +(count))
      ==
    ::
    ++  process-on-watch-card
      |=  [=path =card]
      ^-  _this
      ?~  (mole |.(;;(path-type path)))
        (emit card)
      ?.  ?=([%give %fact *] card)
        (emit card)
      ?^  paths.p.card
        (process-card card)
      =/  count=@   (~(gut by paths) path 0)
      =/  upd=cage  (make-counted-update count cage.p.card)
      (emit %give %fact ~ upd)
    ::
    ++  process-cards
      |=  cards=(list card)
      ^-  _this
      ?~  cards
        this
      =.  this  (process-card i.cards)
      $(cards t.cards)
    ::
    ++  process-on-watch-cards
      |=  [=path cards=(list card)]
      ^-  _this
      ?~  cards
        this
      =.  this  (process-on-watch-card path i.cards)
      $(cards t.cards)
    --
  --
::
++  vine
  =<  vine
  |%
  ++  vine
    =,  vio
    |=  =vine
    ^+  vine
    |=  [=gowl vid=vent-id =mark =vase]
    =/  m  (strand ,^vase)
    ^-  form:m
    ?+    mark  (vine gowl vid mark vase) :: delegate to original
        %counted-action
      =+  !<([=path =page] vase)
      ;<  =tube:clay  bind:m  (build-our-tube q.byk.gowl %noun p.page)
      ;<  vnt=^vase   bind:m  (vine gowl vid p.page (tube !>(q.page)))
      ;<  count=@  bind:m
        (scry-hard ,@ :(weld /gx/[dap.gowl]/sub-count/path path /noun))
      (pure:m (slop !>(count) vnt))
    ==
  ::
  ++  vent-counted-action
    =,  vio
    |=  [=dock =path =wire =page]
    =/  m  (strand ,^vase)
    ^-  form:m
    ;<  our=@p  bind:m  get-our
    ;<  ~       bind:m  (watch /sub-counts [our q.dock] /sub-counts)
    ;<  [count=@ vnt=*]  bind:m
      ((vent ,[@ *]) dock counted-action+[path page])
    |-
    ;<  upd=cage  bind:m  (take-fact /sub-counts)
    ?.  ?=(%wire-count p.upd)  $
    =+  !<([wyre=^wire new-count=@] q.upd)
    ?.  =(wyre wire)           $
    ?.  (gte new-count count)  $
    ~&  >>  `@t`(cat 3 'count: ' (numb count))
    ~&  >>  `@t`(cat 3 'new count: ' (numb new-count))
    (pure:m !>(vnt))
  ::
  ++  numb :: from numb:enjs:format
    |=  a=@u
    ?:  =(0 a)  '0'
    %-  crip
    %-  flop
    |-  ^-  tape
    ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))])
  --
--
