/-  *goals, act=action
|%
++  dejs
  =,  dejs:format
  |%
  ++  action
    |=  jon=json
    ^-  action:act
    %.  jon
    %-  of
    :~  [%spawn-pool (ot ~[title+so])]
        [%clone-pool (ot ~[pin+pin title+so])]
        [%cache-pool (ot ~[pin+pin])]
        [%renew-pool (ot ~[pin+pin])]
        [%trash-pool (ot ~[pin+pin])]
        [%spawn-goal (ot ~[pin+pin upid+unit-id desc+so actionable+bo])]
        [%cache-goal (ot ~[id+id])]
        [%renew-goal (ot ~[id+id])]
        [%trash-goal (ot ~[id+id])]
        [%yoke (ot ~[pin+pin yoks+yoke-seq])]
        [%move (ot ~[cid+id upid+unit-id])]
        [%set-kickoff (ot ~[id+id kickoff+unit-di])]
        [%set-deadline (ot ~[id+id deadline+unit-di])]
        [%mark-actionable (ot ~[id+id])]
        [%unmark-actionable (ot ~[id+id])]
        [%mark-complete (ot ~[id+id])]
        [%unmark-complete (ot ~[id+id])]
        [%update-pool-perms (ot ~[pin+pin new+pool-perms])]
        [%edit-goal-desc (ot ~[id+id desc+so])]
        [%edit-pool-title (ot ~[pin+pin title+so])]
        [%edit-goal-note (ot ~[id+id note+so])]
        [%edit-pool-note (ot ~[pin+pin note+so])]
        [%add-goal-tag (ot ~[id+id tag+so])]
        [%del-goal-tag (ot ~[id+id tag+so])]
        [%put-goal-tags (ot ~[id+id tags+(as so)])]
        [%add-field-data (ot ~[id+id field+so data+so])]
        [%del-field-data (ot ~[id+id field+so])]
        [%put-private-tags (ot ~[id+id tags+(as so)])]
    ==
  ::
  ++  tag  (ot ~[text+so color+so private+bo])
  ::
  ++  field-type
    |=  jon=json
    !!
    :: ^-  ^field-type
    :: %.  jon
    :: %-  of
    :: :~  [%ct (as so)]
    ::     [%ud ul]
    ::     [%rd ul]
    :: ==
  ::
  ++  field-data
    |=  jon=json
    !!
    :: ^-  ^field-data
    :: %.  jon
    :: %-  of
    :: :~  [%ct (ot ~[d+so])]
    ::     [%ud (ot ~[d+(cu |=(=@t (slav %ud t)) so)])]
    ::     [%rd (ot ~[d+(cu |=(=@t (slav %rd t)) so)])]
    :: ==
  ::
  ++  pool-perms
    |=  jon=json
    ^-  (map ^ship (unit pool-role))
    %-  ~(gas by *(map ^ship (unit pool-role)))
    %.(jon (ar (ot ~[ship+ship role+unit-role])))

  ++  unit-role  |=(jon=json ?~(jon ~ (some (role jon))))
  ++  role
    %-  su
    ;~  pose
      (cold %admin (jest 'admin'))
      (cold %creator (jest 'creator'))
    ==
  ++  unit-di  |=(jon=json ?~(jon ~ (some (di jon))))
  ++  unit-date  |=(jon=json ?~(jon ~ (some (date jon))))
  ++  unit-id  |=(jon=json ?~(jon ~ (some (id jon))))
  ++  id
    %+  cu
      |=  (pole knot)
      ?>  ?=([host=@ta name=@ta key=@ta ~] +<)
      [[(slav %p host) name] key]
    pa
  ++  pin
    %+  cu
      |=  (pole knot)
      ?>  ?=([host=@ta name=@ta ~] +<)
      [(slav %p host) name]
    pa
  ::
  ++  set-ships  (as ship)
  ++  ship  (su fed:ag)
  ++  date  (su (cook |*(a=* (year +.a)) ;~(plug (just '~') when:^so)))
  ++  yoke-seq  (ar yoke)
  ++  yoke  
    |=  jon=json
    =/  out
      %.  jon
      (ot ~[yoke+yoke-tag lid+id rid+id])
    ^-  exposed-yoke:act
    ?-  -.out
      %prio-rend   [%prio-rend +<.out +>.out]
      %prio-yoke   [%prio-yoke +<.out +>.out]
      %prec-rend   [%prec-rend +<.out +>.out]
      %prec-yoke   [%prec-yoke +<.out +>.out]
      %nest-rend   [%nest-rend +<.out +>.out]
      %nest-yoke   [%nest-yoke +<.out +>.out]
      %hook-rend   [%hook-rend +<.out +>.out]
      %hook-yoke   [%hook-yoke +<.out +>.out]
      %held-rend   [%held-rend +<.out +>.out]
      %held-yoke   [%held-yoke +<.out +>.out]
    ==
  ::
  ++  yoke-tag
    |=  jon=json
    =/  tag=term  (so jon)
    ?+  tag  !!
      %prio-rend   %prio-rend
      %prio-yoke   %prio-yoke
      %prec-rend   %prec-rend
      %prec-yoke   %prec-yoke
      %nest-rend   %nest-rend
      %nest-yoke   %nest-yoke
      %hook-rend   %hook-rend
      %hook-yoke   %hook-yoke
      %held-rend   %held-rend
      %held-yoke   %held-yoke
    ==
  --
++  enjs
  =,  enjs:format
  |%
  ++  stub  ~
  --
::
++  enjs-store
  =,  enjs:format
  |=  =store
  ^-  json
  %-  pairs
  :~  [%pools (enjs-pools pools.store)]
      [%cache (enjs-pools cache.store)]
      [%local a+(turn order.local.store enjs-id)]
  ==
  
++  enjs-pools
  =,  enjs:format
  |=  =pools
  :-  %a  %+  turn  ~(tap by pools) 
  |=  [=pin =pool] 
  %-  pairs
  :~  [%pin s+(pool-id pin)]
      [%pool (enjs-pool pool)]
  ==
::
++  enjs-pool
  =,  enjs:format
  |=  =pool
  !!
  :: |=  =npool
  :: %-  pairs
  :: :~  [%perms (enjs-pool-perms perms.nexus.npool)]
  ::     [%nexus (enjs-pool-nexus nexus.npool)]
  ::     [%trace (enjs-pool-trace trace.npool)]
  :: ==
::
:: ++  enjs-pool-froze
::   =,  enjs:format
::   |=  [froze=pool-froze owner=^ship]
::   ^-  json
::   %-  pairs
::   :~  [%owner (ship owner)]
::       [%birth (numb (unm:chrono:userlib birth.froze))]
::       [%creator (ship creator.froze)]
::   ==
::
++  enjs-pool-perms
  =,  enjs:format
  |=  perms=pool-perms
  ^-  json
  :-  %a  %+  turn  ~(tap by perms) 
  |=  [chip=@p role=(unit pool-role)] 
  %-  pairs
  :~  [%ship (ship chip)]
      [%role ?~(role ~ s+u.role)]
  ==
::
:: ++  enjs-pool-nexus
::   =,  enjs:format
::   |=  nexus=pool-nexus
::   ^-  json
::   %-  pairs
::   :~  [%goals (enjs-goals goals.nexus)]
::       [%cache (enjs-goals cache.nexus)]
::   ==
:: ::
:: ++  enjs-pool-hitch
::   =,  enjs:format
::   |=  ph=pool-hitch
::   ^-  json
::   %-  pairs
::   :~  [%title s+title.ph]
::       [%note s+note.ph]
::       :: [%fields (enjs-field-types fields.ph)]
::   ==
::
:: ++  enjs-field-types
::   =,  enjs:format
::   |=  fields=(map @t field-type)
::   ^-  json
::   %-  pairs
::   %+  turn  ~(tap by fields)
::   |=  [field=@t =field-type]
::   ^-  [@t json]
::   [field (enjs-field-type field-type)]
::
++  enjs-yoke
  =,  enjs:format
  |=  yok=exposed-yoke:act
  %-  pairs
  :~  [%yoke s+-.yok]
      [%lid (enjs-id lid.yok)]
      [%rid (enjs-id rid.yok)]
  ==
::
++  enjs-goals
  =,  enjs:format
  |=  =goals
  :-  %a  %+  turn  ~(tap by goals) 
  |=  [=id =goal] 
  %-  pairs
  :~  [%id (enjs-id id)]
      [%goal (enjs-goal goal)]
  ==
::
:: ++  enjs-pex  enjs-pool-trace
:: ::
:: ++  enjs-pool-trace
::   =,  enjs:format
::   |=  trace=pool-trace
::   ^-  json
::   %-  pairs
::   :~  [%roots a+(turn roots.trace enjs-id)]
::       [%roots-by-precedence a+(turn roots-by-precedence.trace enjs-id)]
::       [%roots-by-kickoff a+(turn roots-by-kickoff.trace enjs-id)]
::       [%roots-by-deadline a+(turn roots-by-deadline.trace enjs-id)]
::       [%cache-roots a+(turn cache-roots.trace enjs-id)]
::       [%cache-roots-by-precedence a+(turn cache-roots-by-precedence.trace enjs-id)]
::       [%cache-roots-by-kickoff a+(turn cache-roots-by-kickoff.trace enjs-id)]
::       [%cache-roots-by-deadline a+(turn cache-roots-by-deadline.trace enjs-id)]
::   ==
::
:: ++  enjs-nex
::   =,  enjs:format
::   |=  =nex
::   ^-  json
::   :-  %a  %+  turn  ~(tap by nex) 
::   |=  [=id nexus=goal-nexus trace=goal-trace] 
::   %-  pairs
::   :~  [%id (enjs-id id)]
::       [%goal (enjs-goal-nexus-trace nexus trace)]
::   ==
::
++  enjs-id-v
  =,  enjs:format
  |=  [=id v=?]
  ^-  json
  %-  pairs
  :~  [%id (enjs-id id)]
      [%virtual b+v]
  ==
::
:: ++  enjs-goal-nexus-trace
::   =,  enjs:format
::   |=  nexus=[goal-nexus goal-trace]
::   ^-  json
::   %-  pairs
::   :~  [%par ?~(par.nexus ~ (enjs-id u.par.nexus))]
::       [%kids a+(turn ~(tap in kids.nexus) enjs-id)]
::       [%kickoff (enjs-node kickoff.nexus)]
::       [%deadline (enjs-node deadline.nexus)]
::       [%complete b+complete.nexus]
::       [%actionable b+actionable.nexus]
::       [%chief (ship chief.nexus)]
::       [%deputies a+(turn ~(tap in deputies.nexus) ship)]
::       [%tags a+(turn ~(tap in tags.nexus) (lead %s))]
::       [%fields (enjs-fields fields.nexus)]
::       [%stock (enjs-stock stock.nexus)]
::       [%ranks (enjs-ranks ranks.nexus)]
::       [%young a+(turn young.nexus enjs-id-v)]
::       [%young-by-precedence a+(turn young-by-precedence.nexus enjs-id-v)]
::       [%young-by-kickoff a+(turn young-by-kickoff.nexus enjs-id-v)]
::       [%young-by-deadline a+(turn young-by-deadline.nexus enjs-id-v)]
::       [%progress (enjs-progress progress.nexus)]
::       [%prio-left a+(turn ~(tap in prio-left.nexus) enjs-id)]
::       [%prio-ryte a+(turn ~(tap in prio-ryte.nexus) enjs-id)]
::       [%prec-left a+(turn ~(tap in prec-left.nexus) enjs-id)]
::       [%prec-ryte a+(turn ~(tap in prec-ryte.nexus) enjs-id)]
::       [%nest-left a+(turn ~(tap in nest-left.nexus) enjs-id)]
::       [%nest-ryte a+(turn ~(tap in nest-ryte.nexus) enjs-id)]
::   ==
::
++  enjs-stock
  =,  enjs:format
  |=  =stock
  ^-  json
  :-  %a  %+  turn  stock
  |=  [=id chief=@p]
  %-  pairs
  :~  [%id (enjs-id id)]
      [%chief (ship chief)]
  ==
::
++  enjs-ranks
  =,  enjs:format
  |=  =ranks
  ^-  json
  :-  %a
  %+  turn  ~(tap by ranks)
  |=  [chip=@p =id]
  %-  pairs
  :~  [%ship (ship chip)]
      [%id (enjs-id id)]
  ==
::
++  enjs-progress
  =,  enjs:format
  |=  [c=@ t=@]
  %-  pairs
  :~  complete+(numb c)
      total+(numb t)
  ==
::
++  enjs-goal
  =,  enjs:format
  |=  =goal
  ^-  json
  !!
  :: %-  pairs
  :: :~  [%nexus (enjs-goal-nexus-trace [nexus trace]:`ngoal`goal)]
  :: ==
::
++  enjs-fields
  =,  enjs:format
  |=  fields=(map @t @t)
  ^-  json
  %-  pairs
  %+  turn  ~(tap by fields)
  |=  [field=@t data=@t]
  ^-  [@t json]
  [field s+data]
::
++  enjs-node
   =,  enjs:format
   |=  =node:goal
   ^-  json
   %-  pairs
   :~  [%moment (enjs-moment moment.node)]
       [%inflow a+(turn ~(tap in inflow.node) enjs-nid)]
       [%outflow a+(turn ~(tap in outflow.node) enjs-nid)]
       :: [%left-bound (frond %moment (enjs-moment left-bound.node))]
       :: [%ryte-bound (frond %moment (enjs-moment ryte-bound.node))]
       :: [%left-plumb (numb left-plumb.node)]
       :: [%ryte-plumb (numb ryte-plumb.node)]
   ==
::
++  enjs-moment
  =,  enjs:format
  |=  =moment
  ^-  json
  ?~  moment  ~
  %-  numb
  (unm:chrono:userlib u.moment)
::
++  enjs-nid
  =,  enjs:format
  |=  =nid
  ^-  json
  %-  pairs
  :: change %edge -> %node when confirmed no frontend effects
  :~  [%edge s+-.nid]
      [%id (enjs-id +.nid)]
  ==
::
++  pool-id  |=(=pin (rap 3 '/' (scot %p host.pin) '/' name.pin ~))
++  enjs-id  |=(=id s+(rap 3 (pool-id pin.id) '/' key.id ~))
++  enjs-tang  |=(=tang a+(turn tang tank:enjs:format))
--
