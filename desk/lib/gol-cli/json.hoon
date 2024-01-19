/-  *goals, act=action
|%
++  dejs
  =,  dejs:format
  |%
  :: json parsing for +each
  ::
  ++  ea
    |*  [a=mold b=mold]
    |=  [h=@ t=*]
    ?+  h  !!
      %y  ;;([%.y a] [%.y t])
      %n  ;;([%.n b] [%.n t])
    ==
  :: parse +each based on { "y": ... } vs { "n": ... }
  ::
  ++  ec
    |*  [a=mold b=mold]
    |*  [y=fist n=fist]
    (cu (ea a b) (of ~[y+y n+n]))
  :: parse +each based on
  :: { "method": "put", ... } vs { "method": "del", ... }
  ::
  ++  each-method
    |=  [ym=@t nm=@t]
    |*  [a=mold b=mold]
    |*  [y=fist n=fist]
    |=  jon=json
    ?>  ?=(%o -.jon)
    =;  l=?(%y %n)
      %-  ((ec a b) y n)
      o+(my [l o+(~(del by p.jon) 'method')]~)
    =/  met=json  (~(got by p.jon) 'method')
    ?>  ?=(%s -.met)
    ?:  =(p.met ym)  %y
    ?:  =(p.met nm)  %n
    !!
  ::
  ++  pd  (each-method %put %del)
  ++  ud  (each-method %uni %dif)
  ::
  ++  pd-setting
    %+  (pd ,[@t @t] @t)
      (ot ~[setting+so contents+so])
    (ot ~[setting+so])
  ::
  ++  pd-goal-field
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (id (~(got by p.jon) 'id'))
    %.  o+(~(del by p.jon) 'id')
    %+  (pd ,[@t @t] [@t])
      (ot ~[field+so data+so])
    (ot ~[field+so])
  ::
  ++  pd-pool-property
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (pin (~(got by p.jon) 'pin'))
    %.  o+(~(del by p.jon) 'pin')
    %+  (pd ,[@t @t] [@t])
      (ot ~[property+so data+so])
    (ot ~[property+so])
  ::
  ++  pd-pool-tag-property
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (pin (~(got by p.jon) 'pin'))
    :-  (so (~(got by p.jon) 'tag'))
    %.  o+(~(del by (~(del by p.jon) 'pin')) 'tag')
    %+  (pd ,[@t @t] [@t])
      (ot ~[property+so data+so])
    (ot ~[property+so])
  ::
  ++  pd-pool-field-property
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (pin (~(got by p.jon) 'pin'))
    :-  (so (~(got by p.jon) 'field'))
    %.  o+(~(del by (~(del by p.jon) 'pin')) 'field')
    %+  (pd ,[@t @t] [@t])
      (ot ~[property+so data+so])
    (ot ~[property+so])
  ::
  ++  pd-local-tag-property
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (so (~(got by p.jon) 'tag'))
    %.  o+(~(del by p.jon) 'tag')
    %+  (pd ,[@t @t] [@t])
      (ot ~[property+so data+so])
    (ot ~[property+so])
  ::
  ++  pd-local-field-property
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (so (~(got by p.jon) 'field'))
    %.  o+(~(del by p.jon) 'field')
    %+  (pd ,[@t @t] [@t])
      (ot ~[property+so data+so])
    (ot ~[property+so])
  ::
  ++  ud-goal-tags
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (id (~(got by p.jon) 'id'))
    %.  o+(~(del by p.jon) 'id')
    %+  (ud (set @t) (set @t))
      (ot ~[tags+(as so)])
    (ot ~[tags+(as so)])
  ::
  ++  action
    |=  jon=json
    ^-  action:act
    %.  jon
    %-  of
    :~  [%create-pool (ot ~[title+so])]
        [%delete-pool (ot ~[pin+pin])]
        [%set-pool-title (ot ~[pin+pin title+so])]
        [%create-goal (ot ~[pin+pin upid+unit-id summary+so actionable+bo])]
        [%create-goal-with-tag (ot ~[pin+pin upid+unit-id summary+so actionable+bo tag+so])]
        [%archive-goal (ot ~[id+id])]
        [%restore-goal (ot ~[id+id])]
        [%delete-goal (ot ~[id+id])]
        [%yoke (ot ~[pin+pin yoks+yoke-seq])]
        [%move (ot ~[cid+id upid+unit-id])]
        [%set-summary (ot ~[id+id summary+so])]
        [%set-kickoff (ot ~[id+id kickoff+unit-di])]
        [%set-deadline (ot ~[id+id deadline+unit-di])]
        [%mark-actionable (ot ~[id+id])]
        [%unmark-actionable (ot ~[id+id])]
        [%mark-complete (ot ~[id+id])]
        [%unmark-complete (ot ~[id+id])]
        [%roots-slot-above (ot ~[dis+id dat+id])]
        [%roots-slot-below (ot ~[dis+id dat+id])]
        [%young-slot-above (ot ~[pid+id dis+id dat+id])]
        [%young-slot-below (ot ~[pid+id dis+id dat+id])]
        [%pools-slot-above (ot ~[dis+pin dat+pin])]
        [%pools-slot-below (ot ~[dis+pin dat+pin])]
        [%goals-slot-above (ot ~[dis+id dat+id])]
        [%goals-slot-below (ot ~[dis+id dat+id])]
        [%update-pool-perms (ot ~[pin+pin new+perms])]
        [%update-pool-property pd-pool-property]
        [%update-pool-tag-property pd-pool-tag-property]
        [%update-pool-field-property pd-pool-field-property]
        [%update-goal-tags ud-goal-tags]
        [%update-goal-field pd-goal-field]
        [%update-local-goal-tags ud-goal-tags]
        [%update-local-tag-property pd-local-tag-property]
        [%update-setting pd-setting]
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
  ++  perms
    |=  jon=json
    ^-  (map ^ship (unit ^role))
    %-  ~(gas by *(map ^ship (unit ^role)))
    %.(jon (ar (ot ~[ship+ship role+unit-role])))

  ++  unit-role  |=(jon=json ?~(jon ~ (some (role jon))))
  ++  role
    %-  su
    ;~  pose
      (cold %owner (jest 'owner'))
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
      [%local a+(turn goal-order.local.store enjs-id)]
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
  ^-  json
  s+'Hello! I am a pool!'
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
++  enjs-goal-order
  =,  enjs:format
  |=  order=(list id)
  ^-  json
  s+'Hello! I am your goal order!'
::
++  enjs-pool-order
  =,  enjs:format
  |=  order=(list pin)
  ^-  json
  s+'Hello! I am your pool order!'
::
++  enjs-settings
  =,  enjs:format
  |=  settings=(map @t @t)
  ^-  json
  s+'Hello! I am your goals settings!'
::
++  enjs-pool-data
  =,  enjs:format
  |=  =pool-data
  ^-  json
  s+'Hello! I am some pool info!'
::
++  enjs-perms
  =,  enjs:format
  |=  =perms
  ^-  json
  :-  %a  %+  turn  ~(tap by perms) 
  |=  [chip=@p role=(unit role)] 
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
