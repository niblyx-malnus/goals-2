/-  gol=goals, act=action
/+  vent, dbug, default-agent, verb,
    gol-cli-emot, gs=gol-cli-state, gol-cli-node,
:: import during development to force compilation
::
    gol-cli-json
/=  x  /mar/goal/peek
/=  x  /mar/goal/action
:: /=  x  /ted/vines/goals
::
|%
+$  inflated-state  [state-5-9:gs =trace:gol] 
+$  card     card:agent:gall
--
=|  inflated-state
=*  state  -
::
%+  verb  |
%-  agent:dbug
%-  agent:vent
^-  agent:gall
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
  :: =/  old  !<(versioned-state:gs old-vase)
  =/  old  ;;(versioned-state:gs q.old-vase)
  =/  new=state-5-9:gs   (convert-to-latest:gs old)
  =/  cards=(list card)  (upgrade-io:gs new bowl)
  [cards this(-.state new, trace *trace:gol)]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %goal-action
    =/  axn=action:act  !<(action:act vase)
    ~&  received-axn+axn
    ~&  [src+src our+our]:bowl
    =^  cards  state
      abet:(handle-action:emot axn)
    [cards this]
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %store ~]  ``goal-peek+!>([%store store])
    ::
      [%x %pools %index ~]
    :-  ~  :-  ~  :-  %goal-peek  !>
    :-  %pools-index
    %+  turn  ~(tap by pools.store)
    |=  [=pin:gol =pool:gol]
    [pin (~(got by properties.pool) 'title')]
    ::
      [%x %pool %roots host=@ta name=@ta ~]
    =/  =pin:gol   [(slav %p host.pole) name.pole]
    =/  =pool:gol  (~(got by pools.store) pin)
    =/  nd          ~(. gol-cli-node goals.pool)
    :-  ~  :-  ~  :-  %goal-peek  !>
    :-  %pool-roots
    %+  turn  (waif-goals:nd)
    |=  =id:gol
    =/  fields=(map @t @t)  (~(got by fields.pool) id)
    =+  (~(got by goals.pool) id)
    [id [(~(got by fields) 'description') done.deadline actionable]]
    ::
      [%x %goal %young host=@ta name=@ta key=@ta ~]
    =/  =pin:gol    [(slav %p host.pole) name.pole]
    =/  =id:gol     [pin key.pole]
    =/  =pool:gol   (~(got by pools.store) pin)
    =/  nd          ~(. gol-cli-node goals.pool)
    :-  ~  :-  ~  :-  %goal-peek  !>
    :-  %goal-young
    %+  turn  ~(tap in (young:nd id))
    |=  =id:gol
    =/  fields=(map @t @t)  (~(got by fields.pool) id)
    =+  (~(got by goals.pool) id)
    [id virtual=%| [(~(got by fields) 'description') done.deadline actionable]]
    ::
      [%x %pool %title host=@ta name=@ta ~]
    =/  =pin:gol    [(slav %p host.pole) name.pole]
    =/  =pool:gol  (~(got by pools.store) pin)
    ``goal-peek+!>([%pool-title (~(gut by properties.pool) 'title' '')])  
    ::
      [%x %pool %note host=@ta name=@ta ~]
    =/  =pin:gol    [(slav %p host.pole) name.pole]
    =/  =pool:gol  (~(got by pools.store) pin)
    ``goal-peek+!>([%pool-note (~(gut by properties.pool) 'note' '')])  
    ::
      [%x %goal %desc host=@ta name=@ta key=@ta ~]
    =/  =pin:gol    [(slav %p host.pole) name.pole]
    =/  =id:gol     [pin key.pole]
    =/  =pool:gol  (~(got by pools.store) pin)
    =/  fields=(map @t @t)  (~(got by fields.pool) id)
    ``goal-peek+!>([%goal-desc (~(gut by fields) 'description' '')])  
    ::
      [%x %goal %note host=@ta name=@da key=@ta ~]
    =/  =pin:gol    [(slav %p host.pole) name.pole]
    =/  =id:gol     [pin key.pole]
    =/  =pool:gol  (~(got by pools.store) pin)
    =/  fields=(map @t @t)  (~(got by fields.pool) id)
    ``goal-peek+!>([%goal-note (~(gut by fields) 'note' '')])  
    ::
      [%x %goal %tags host=@ta name=@ta key=@ta ~]
    =/  =pin:gol    [(slav %p host.pole) name.pole]
    =/  =id:gol     [pin key.pole]
    =/  =pool:gol  (~(got by pools.store) pin)
    =/  tags=(set @t)  (~(got by tags.pool) id)
    ``goal-peek+!>([%goal-tags ~(tap in tags)])  
    ::
      [%x %goal %parent host=@ta name=@da key=@ta ~]
    =/  =pin:gol    [(slav %p host.pole) name.pole]
    =/  =id:gol     [pin key.pole]
    =/  =pool:gol  (~(got by pools.store) pin)
    =/  =goal:gol  (~(got by goals.pool) id)
    ``goal-peek+!>([%uid par.goal])  
    ::
      [%x %goal %actionable host=@ta name=@da key=@ta ~]
    =/  =pin:gol    [(slav %p host.pole) name.pole]
    =/  =id:gol     [pin key.pole]
    =/  =pool:gol  (~(got by pools.store) pin)
    =/  =goal:gol  (~(got by goals.pool) id)
    ``goal-peek+!>([%loob actionable.goal])  
    ::
      [%x %goal %complete host=@ta name=@da key=@ta ~]
    =/  =pin:gol    [(slav %p host.pole) name.pole]
    =/  =id:gol     [pin key.pole]
    =/  =pool:gol  (~(got by pools.store) pin)
    =/  =goal:gol  (~(got by goals.pool) id)
    ``goal-peek+!>([%loob done.deadline.goal])  
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
