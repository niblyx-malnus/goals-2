/-  gol=goals, vyu=views, act=action, update
/+  dbug, default-agent, verb, gol-cli-emot, gs=gol-cli-state, nd=gol-cli-node,
:: import during development to force compilation
::
    gol-cli-json
/=  x  /mar/goal/ask
/=  x  /mar/goal/say
/=  x  /mar/goal/view-send
/=  x  /mar/view-ack
/=  x  /mar/goal/peek
/=  x  /mar/goal/action
/=  x  /mar/goal/update
/=  x  /mar/goal/away-update
::
|%
+$  inflated-state  [state-5:gs =views:vyu] 
+$  card  card:agent:gall
--
=|  inflated-state
=*  state  -
::
%+  verb  |
%-  agent:dbug
^-  agent:gall
=<
|_  =bowl:gall
+*  this    .
    def   ~(. (default-agent this %.n) bowl)
    hc    ~(. +> [bowl ~])
    cc    |=(cards=(list card) ~(. +> [bowl cards]))
    emot  ~(. gol-cli-emot bowl ~ state)
::
++  on-init   on-init:def
++  on-save   !>(-.state)
::
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state:gs old-vase)
  =/  new=state-5:gs     (convert-to-latest:gs old)
  =/  cards=(list card)  (upgrade-io:gs new bowl)
  [cards this(-.state new, views ~)]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %noun
    ?>  =(our src):bowl
    ?+    q.vase  (on-poke:def mark vase)
        %print-subs
      =;  [gsub=(list ship) asub=(list ship)]
        ~&([goals+gsub ask+asub] `this)
      :-  %+  murn  ~(tap by sup.bowl)
          |=  [duct =ship =path]
          ?.(?=([%goals ~] path) ~ (some ship))
      %+  murn  ~(tap by sup.bowl)
      |=  [duct =ship =path]
      ?.(?=([%goals ~] path) ~ (some ship))
    ==
    ::
      %view-ack
    =/  =vid:vyu  !<(vid:vyu vase)
    =/  [ack=_| =view:vyu]  (~(got by views) vid)
    `this(views (~(put by views) vid [& view]))
    ::
      %goal-ask
    =/  =ask:vyu  !<(ask:vyu vase)
    ~&  received-ask+ask
    =^  cards  state
      abet:(handle-ask:emot ask)
    [cards this]
    ::
      %goal-action
    =/  axn=action:act  !<(action:act vase)
    ~&  received-axn+axn
    ~&  [src+src our+our]:bowl
    =^  cards  state
      abet:(handle-action:emot axn)
    [cards this]
  ==
::
++  on-watch
  |=  =(pole knot)
  ^-  (quip card _this)
  ?+    pole  (on-watch:def pole)
      [%ask ~]    ~&(%watching-ask ?>(=(src our):bowl `this)) :: one-off ui requests
      ::
      [%pool @ @ ~]
    =^  cards  state
      abet:(handle-watch:emot pole)
    [cards this]
      ::
      [%view v=@ ~]
    ?>  =(src our):bowl
    ?>  (~(has by views) (slav %uv v.pole))
    `this
  ==
::
++  on-leave
  |=  =(pole knot)
  ?+    pole  (on-leave:def pole)
      [%ask ~]    ~&(%leaving-ask `this) :: one-off ui requests
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %store ~]  ``goal-peek+!>([%store store])
    [%x %views ~]  ``goal-peek+!>([%views views])
    ::
      [%x %pools %index ~]
    :-  ~  :-  ~  :-  %goal-peek  !>
    :-  %pools-index
    %+  turn  ~(tap by pools.store)
    |=  [=pin:gol =pool:gol]
    [pin title.pool]
    ::
      [%x %pool %roots owner=@ta birth=@da ~]
    =/  =pin:gol   [%pin (slav %p owner.pole) (slav %da birth.pole)]
    =/  =pool:gol  (~(got by pools.store) pin)
    :-  ~  :-  ~  :-  %goal-peek  !>
    :-  %pool-roots
    %+  turn  (~(root-goals nd goals.pool))
    |=  =id:gol
    [id desc:(~(got by goals.pool) id)]
    ::
      [%x %goal %kids owner=@ta birth=@da ~]
    =/  =id:gol    [(slav %p owner.pole) (slav %da birth.pole)]
    =/  =pin:gol   (got:idx-orm:gol index.store id)
    =/  =pool:gol  (~(got by pools.store) pin)
    =/  kids=(set id:gol)  kids:(~(got by goals.pool) id)
    :-  ~  :-  ~  :-  %goal-peek  !>
    :-  %goal-kids
    %+  turn  ~(tap in kids)
    |=  =id:gol
    [id desc:(~(got by goals.pool) id)]
    ::
      [%x %pool %title owner=@ta birth=@da ~]
    =/  =pin:gol   [%pin (slav %p owner.pole) (slav %da birth.pole)]
    =/  =pool:gol  (~(got by pools.store) pin)
    ``goal-peek+!>([%pool-title title.pool])  
    ::
      [%x %pool %note owner=@ta birth=@da ~]
    =/  =pin:gol   [%pin (slav %p owner.pole) (slav %da birth.pole)]
    =/  =pool:gol  (~(got by pools.store) pin)
    ``goal-peek+!>([%pool-note note.pool])  
    ::
      [%x %goal %desc owner=@ta birth=@da ~]
    =/  =id:gol    [(slav %p owner.pole) (slav %da birth.pole)]
    =/  =pin:gol   (got:idx-orm:gol index.store id)
    =/  =pool:gol  (~(got by pools.store) pin)
    =/  =goal:gol  (~(got by goals.pool) id)
    ``goal-peek+!>([%goal-desc desc.goal])  
    ::
      [%x %goal %note owner=@ta birth=@da ~]
    =/  =id:gol    [(slav %p owner.pole) (slav %da birth.pole)]
    =/  =pin:gol   (got:idx-orm:gol index.store id)
    =/  =pool:gol  (~(got by pools.store) pin)
    =/  =goal:gol  (~(got by goals.pool) id)
    ``goal-peek+!>([%goal-note note.goal])  
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%away @ @ @ *]
    ?+    -.sign  (on-agent:def wire sign)
        %poke-ack
      ?~  p.sign  `this
      %-  (slog u.p.sign)
      =^  cards  state
        abet:(handle-relay-poke-nack:emot wire u.p.sign)
      [cards this]
    ==
    ::
      [%pool @ @ ~] 
    =/  =pin:gol  (de-pool-path:emot wire)
    ?>  =(src.bowl owner.pin)
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign  `this
      %-  (slog 'Subscribe failure.' ~)
      %-  (slog u.p.sign)
      =^  cards  state
        abet:(handle-pool-watch-nack:emot pin)
      [cards this]
      ::
        %kick
      %-  (slog '%goal-store: Got kick, resubscribing...' ~)
      :_(this [%pass wire %agent [src dap]:bowl %watch wire]~)
      ::
        %fact
      ?>  =(p.cage.sign %goal-away-update)
      =/  upd=away-update:v5:update  !<(away-update:v5:update q.cage.sign)
      =^  cards  state
        abet:(handle-etch-pool-update:emot pin upd)
      [cards this]
    ==
  ==
::
++  on-arvo
  |=  [=(pole knot) =sign-arvo]
  ^-  (quip card _this)
  ?+    pole  (on-arvo:def pole sign-arvo)
      [%send-dot v=@ ~]
    ?+    sign-arvo  (on-arvo pole sign-arvo)
        [%behn %wake *]
      ~&  %sending-dot
      :_  this
      =/  view-path=path  /view/[v.pole]
      =/  cack-path=path  /check-ack/[v.pole]
      :~  [%give %fact ~[view-path] goal-view-send+!>([%dot view-path])]
          [%pass cack-path %arvo %b %wait (add now.bowl ~s10)]
      ==
    ==
    ::
      [%check-ack v=@ ~]
    =/  =vid:vyu  (slav %uv v.pole)
    ?+    sign-arvo  (on-arvo pole sign-arvo)
        [%behn %wake *]
      ~&  %checking-ack
      ?:  ack:(~(got by views) vid)
        =/  [ack=_| =view:vyu]  (~(got by views) vid)
        :_  this(views (~(put by views) vid [| view]))
        =/  next=@da  (add now.bowl ~s10)
        [%pass /send-dot/[v.pole] %arvo %b %wait next]~
      :_  this(views (~(del by views) vid))
      [%give %kick ~[/view/[v.pole]] ~]~
    ==
  ==
::
++  on-fail   on-fail:def
--
|_  [=bowl:gall cards=(list card)]
+*  core  .
++  abet  [(flop cards) state]
++  emit  |=(=card core(cards [card cards]))
++  emil  |=(cadz=(list card) core(cards (weld cadz cards)))
--
