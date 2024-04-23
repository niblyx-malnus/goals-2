::  sub-count: agent wrapper for counting subscription updatess
::
::    usage: %-((agent path-type):sub-count your-agent)
::
/+  vio=ventio, default-agent
/=  x  /mar/counted-update
/=  x  /mar/counted-action
/=  x  /mar/path-count
/=  x  /mar/wire-count
|%
:: assume the first item in the path is the agent name
+$  counted-action  [paths=(list path) =page]
+$  counted-update  [count=@ =page]
::
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
          %sub-count-reset-path
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
      counted-update+!>(`counted-update`[count mark q.vase])
    ::
    ++  take-counted-update
      |=  =vase
      ^-  [@ cage]
      ~&  %taking-counted-update
      ~&  p.vase
      =+  !<(counted-update vase)
      ~&  [count+count mark+p.page]
      =/  nase=^vase  ((get-tube p.page) !>(q.page))
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
      ~&  %emitting-counted-card
      ~&  path+i.paths.p.card
      ~&  mark+p.cage.p.card
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
      =+  `counted-action`!<([paths=(list path) =page] vase)
      ;<  paths=(list path)  bind:m  (check-subscriber src.gowl paths)
      ;<  =tube:clay         bind:m  (build-our-tube q.byk.gowl %noun p.page)
      ;<  vnt=^vase          bind:m  (vine gowl vid p.page (tube !>(q.page)))
      =|  counts=(map path @)
      |-
      ?~  paths
        (pure:m (slop !>(counts) vnt))
      ;<  count=@  bind:m
        ?>  ?=(^ i.paths) :: assume first item of path is agent name
        (scry-hard ,@ :(weld /gx/[i.i.paths]/sub-count/path t.i.paths /noun))
      $(paths t.paths, counts (~(put by counts) i.paths count))
    ==
  ::
  ++  check-subscriber
    =,  vio
    =|  kept=(list path)
    |=  [src=ship paths=(list path)] :: assume first item of path is agent name
    =/  m  (strand ,(list path))
    ^-  form:m
    ?~  paths
      (pure:m kept)
    ?>  ?=(^ i.paths)
    ;<  [wex=boat:gall sup=bitt:gall]  bind:m
      (scry-hard ,[boat bitt]:gall /gx/[i.i.paths]/vent/subscriptions/noun)
    ?.  (~(has in (sy ~(val by sup))) [src t.i.paths])
      ~&  "{<src>} not subscribed to {<path>}"
      $(paths t.paths) :: simply ignore unsubscribed paths
    $(kept [i.paths kept], paths t.paths)

  ::
  ++  vent-counted-action
    =,  vio
    |=  [=dock paths=(map wire path) =page]
    =/  m  (strand ,^vase)
    ^-  form:m
    :: watch sub-count wires
    ::
    =/  dudes=(list dude:gall)
      %+  turn  ~(tap in ~(key by paths))
      |=(=wire ?>(?=(^ wire) i.wire))
    ;<  ~       bind:m  (watch-sub-counts dudes)
    :: vent the counted action
    ::
    ;<  [counts=(map path @) vnt=*]  bind:m
      ((vent ,[(map path @) *]) dock counted-action+[~(val by paths) page])
    :: do an in initial scry check in case no updates come
    ::
    ;<  counts=(map path @)  bind:m  (clear-already-done paths counts)
    :: catch wire updates and check if it's above counted
    ::
    |-
    ?:  =(0 ~(wyt by counts))
      ~?  >>  !=(0 ~(wyt by paths))
        ["wire residue (probably not subscribed): " ~(tap by paths)]
      (pure:m !>(vnt))
    :: take a sub-counts fact
    ::
    ;<  [sub-counts-wire=wire upd=cage]  bind:m  take-any-fact
    ?.  ?=([@ta %sub-counts ~] sub-counts-wire)  $
    =/  =dude:gall  i.sub-counts-wire
    ?.  ?=(%wire-count p.upd)  $
    =+  !<([=wire new-count=@] q.upd)
    ?~  pat=(~(get by paths) [dude wire])  $
    ?.  (~(has by counts) u.pat)  $
    ::  if the new count exceeds the received count, it's done
    ::
    =/  count=@  (~(got by counts) u.pat)
    ?.  (gte new-count count)  $
    ~&  >>  (crip (weld "{<dude>} {<wire>} count: " (numb count)))
    ~&  >>  (crip (weld "{<dude>} {<wire>} new count: " (numb new-count)))
    %=  $
      paths   (~(del by paths) [dude wire])
      counts  (~(del by counts) u.pat)
    ==
  ::
  ++  clear-already-done
    =,  vio
    |=  [paths=(map wire path) counts=(map path @)]
    =/  m  (strand ,(map path @))
    ^-  form:m
    :: get mapping from path to wire
    ::
    =/  wires=(map path wire)
      %-  ~(gas by *(map path wire))
      %+  turn  ~(tap by paths)
      |=([=wire =path] [path wire])
    :: iterate through counts
    ::
    =/  counts-list=(list [=path count=@])  ~(tap by counts)
    |-
    ?~  counts-list
      (pure:m counts)
    ?~  wyr=(~(get by wires) path.i.counts-list)
      ~&  %strange-missing-wire
      %=  $
        counts-list  t.counts-list
        counts       (~(del by counts) path.i.counts-list)
      ==
    ::  if the new count exceeds the received count, it's done
    ::
    ?>  ?=(^ u.wyr) :: assume first item of path is agent name
    ;<  new-count=@  bind:m
      (scry-hard ,@ :(weld /gx/[i.u.wyr]/sub-count/wire t.u.wyr /noun))
    ?.  (gte new-count count.i.counts-list)
      $(counts-list t.counts-list)
    ~&  >>  (crip (weld "{<`@tas`i.u.wyr>} {<t.u.wyr>} count: " (numb count.i.counts-list)))
    ~&  >>  (crip (weld "{<`@tas`i.u.wyr>} {<t.u.wyr>} new count: " (numb new-count)))
    %=  $
      counts-list  t.counts-list
      counts       (~(del by counts) path.i.counts-list)
    ==
  ::
  ++  watch-sub-counts
    =,  vio
    |=  dudes=(list dude:gall)
    =/  m  (strand ,~)
    ^-  form:m
    ?~  dudes  (pure:m ~)
    ;<  our=@p  bind:m  get-our
    ;<  ~  bind:m  (watch /[i.dudes]/sub-counts [our i.dudes] /sub-counts)
    $(dudes t.dudes)
  ::
  ++  numb :: adapted from numb:enjs:format
    |=  a=@u
    ^-  tape
    ?:  =(0 a)  "0"
    %-  flop
    |-  ^-  tape
    ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))])
  --
--
