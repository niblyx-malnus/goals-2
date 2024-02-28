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
    :-  (pid (~(got by p.jon) 'pid'))
    :-  (gid (~(got by p.jon) 'gid'))
    %.  o+(~(del by (~(del by p.jon) 'pid')) 'gid')
    %+  (pd ,[@t @t] [@t])
      (ot ~[field+so data+so])
    (ot ~[field+so])
  ::
  ++  pd-pool-property
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (pid (~(got by p.jon) 'pid'))
    %.  o+(~(del by p.jon) 'pid')
    %+  (pd ,[@t @t] [@t])
      (ot ~[property+so data+so])
    (ot ~[property+so])
  ::
  ++  pd-pool-tag-property
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (pid (~(got by p.jon) 'pid'))
    :-  (so (~(got by p.jon) 'tag'))
    %.  o+(~(del by (~(del by p.jon) 'pid')) 'tag')
    %+  (pd ,[@t @t] [@t])
      (ot ~[property+so data+so])
    (ot ~[property+so])
  ::
  ++  pd-pool-field-property
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (pid (~(got by p.jon) 'pid'))
    :-  (so (~(got by p.jon) 'field'))
    %.  o+(~(del by (~(del by p.jon) 'pid')) 'field')
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
    :-  (key (~(got by p.jon) 'key'))
    %.  o+(~(del by p.jon) 'key')
    %+  (ud (set @t) (set @t))
      (ot ~[tags+(as so)])
    (ot ~[tags+(as so)])
  ::
  ++  ud-local-goal-tags
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (key (~(got by p.jon) 'key'))
    %.  o+(~(del by p.jon) 'key')
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
        [%delete-pool (ot ~[pid+pid])]
        [%set-pool-title (ot ~[pid+pid title+so])]
        [%create-goal (ot ~[pid+pid upid+unit-id summary+so actionable+bo active+bo])]
        [%create-goal-with-tag (ot ~[pid+pid upid+unit-id summary+so actionable+bo tag+so])]
        [%archive-goal (ot ~[pid+pid gid+gid])]
        [%restore-goal (ot ~[pid+pid gid+gid])]
        [%delete-goal (ot ~[pid+pid gid+gid])]
        [%yoke (ot ~[pid+pid yoks+yoke-seq])]
        [%move (ot ~[pid+pid cid+gid upid+unit-id])]
        [%set-summary (ot ~[pid+pid gid+gid summary+so])]
        [%set-start (ot ~[pid+pid gid+gid start+unit-di])]
        [%set-end (ot ~[pid+pid gid+gid end+unit-di])]
        [%mark-actionable (ot ~[pid+pid gid+gid])]
        [%unmark-actionable (ot ~[pid+pid gid+gid])]
        [%mark-complete (ot ~[pid+pid gid+gid])]
        [%unmark-complete (ot ~[pid+pid gid+gid])]
        [%mark-active (ot ~[pid+pid gid+gid])]
        [%unmark-active (ot ~[pid+pid gid+gid])]
        [%reorder-roots (ot ~[pid+pid roots+(ar gid)])]
        [%reorder-children (ot ~[pid+pid gid+gid children+(ar gid)])]
        [%pools-slot-above (ot ~[dis+pid dat+pid])]
        [%pools-slot-below (ot ~[dis+pid dat+pid])]
        [%goals-slot-above (ot ~[dis+key dat+key])]
        [%goals-slot-below (ot ~[dis+key dat+key])]
        [%put-collection (ot ~[path+pa collection+collection])]
        [%del-collection (ot ~[path+pa])]
        [%update-pool-perms (ot ~[pid+pid new+perms])]
        [%update-pool-property pd-pool-property]
        [%update-pool-tag-property pd-pool-tag-property]
        [%update-pool-field-property pd-pool-field-property]
        [%update-goal-tags ud-goal-tags]
        [%update-goal-field pd-goal-field]
        [%update-local-goal-tags ud-local-goal-tags]
        [%update-local-tag-property pd-local-tag-property]
        [%update-setting pd-setting]
    ==
  ::
  ++  collection  (ot ~[keys+(ar key) themes+(as so)])
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
    ^-  (map ^ship ^role)
    %-  ~(gas by *(map ^ship ^role))
    %.(jon (ar (ot ~[ship+ship role+role])))

  ++  role
    %-  su
    ;~  pose
      (cold %owner (jest 'owner'))
      (cold %admin (jest 'admin'))
      (cold %creator (jest 'creator'))
      (cold %viewer (jest 'viewer'))
    ==
  ++  unit-di  |=(jon=json ?~(jon ~ (some (di jon))))
  ++  unit-date  |=(jon=json ?~(jon ~ (some (date jon))))
  ++  unit-id  |=(jon=json ?~(jon ~ (some (gid jon))))
  ++  key
    %+  cu
      |=  (pole knot)
      ?>  ?=([host=@ta name=@ta gid=@ta ~] +<)
      [[(slav %p host) name] gid]
    pa
  ++  gid
    %+  cu
      |=  (pole knot)
      ?>(?=([gid=@ta ~] +<) gid)
    pa
  ++  pid
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
      (ot ~[yoke+yoke-tag lid+gid rid+gid])
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
      [%local a+(turn goal-order.local.store enjs-key)]
  ==
  
++  enjs-pools
  =,  enjs:format
  |=  =pools
  ^-  json
  %-  pairs
  %+  turn  ~(tap by pools) 
  |=  [=pid =pool] 
  ^-  [@t json]
  :-  (enjs-pid pid)
  (enjs-pool pool)
::
++  enjs-pool
  =,  enjs:format
  |=  =pool
  ^-  json
  %-  pairs
  :~  [%pid s+(enjs-pid pid.pool)]
      [%title s+title.pool]
      [%perms (enjs-perms perms.pool)]
      [%goals (enjs-goals goals.pool)]
      [%archive (enjs-archive archive.pool)]
  ==
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
  |=  order=(list key)
  ^-  json
  s+'Hello! I am your goal order!'
::
++  enjs-pool-order
  =,  enjs:format
  |=  order=(list pid)
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
  |=  [=@p =role] 
  %-  pairs
  :~  [%ship s+(scot %p p)]
      [%role s+role]
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
      [%lid (enjs-gid lid.yok)]
      [%rid (enjs-gid rid.yok)]
  ==
::
++  enjs-goals
  =,  enjs:format
  |=  =goals
  ^-  json
  %-  pairs
  %+  turn  ~(tap by goals) 
  |=  [=gid =goal] 
  ^-  [@t json]
  [gid (enjs-goal goal)]
::
:: ++  enjs-pex  enjs-pool-trace
:: ::
:: ++  enjs-pool-trace
::   =,  enjs:format
::   |=  trace=pool-trace
::   ^-  json
::   %-  pairs
::   :~  [%roots a+(turn roots.trace enjs-gid)]
::       [%roots-by-precedence a+(turn roots-by-precedence.trace enjs-gid)]
::       [%roots-by-start a+(turn roots-by-start.trace enjs-gid)]
::       [%roots-by-end a+(turn roots-by-end.trace enjs-gid)]
::       [%cache-roots a+(turn cache-roots.trace enjs-gid)]
::       [%cache-roots-by-precedence a+(turn cache-roots-by-precedence.trace enjs-gid)]
::       [%cache-roots-by-start a+(turn cache-roots-by-start.trace enjs-gid)]
::       [%cache-roots-by-end a+(turn cache-roots-by-end.trace enjs-gid)]
::   ==
::
:: ++  enjs-nex
::   =,  enjs:format
::   |=  =nex
::   ^-  json
::   :-  %a  %+  turn  ~(tap by nex) 
::   |=  [=gid nexus=goal-nexus trace=goal-trace] 
::   %-  pairs
::   :~  [%gid (enjs-gid gid)]
::       [%goal (enjs-goal-nexus-trace nexus trace)]
::   ==
::
++  enjs-gid-v
  =,  enjs:format
  |=  [=gid v=?]
  ^-  json
  %-  pairs
  :~  [%gid (enjs-gid gid)]
      [%virtual b+v]
  ==
::
:: ++  enjs-goal-nexus-trace
::   =,  enjs:format
::   |=  nexus=[goal-nexus goal-trace]
::   ^-  json
::   %-  pairs
::   :~  [%par ?~(par.nexus ~ (enjs-gid u.par.nexus))]
::       [%kids a+(turn ~(tap in kids.nexus) enjs-gid)]
::       [%start (enjs-node start.nexus)]
::       [%end (enjs-node end.nexus)]
::       [%complete b+complete.nexus]
::       [%actionable b+actionable.nexus]
::       [%chief (ship chief.nexus)]
::       [%deputies a+(turn ~(tap in deputies.nexus) ship)]
::       [%tags a+(turn ~(tap in tags.nexus) (lead %s))]
::       [%fields (enjs-fields fields.nexus)]
::       [%stock (enjs-stock stock.nexus)]
::       [%ranks (enjs-ranks ranks.nexus)]
::       [%young a+(turn young.nexus enjs-gid-v)]
::       [%young-by-precedence a+(turn young-by-precedence.nexus enjs-gid-v)]
::       [%young-by-start a+(turn young-by-start.nexus enjs-gid-v)]
::       [%young-by-end a+(turn young-by-end.nexus enjs-gid-v)]
::       [%progress (enjs-progress progress.nexus)]
::       [%prio-left a+(turn ~(tap in prio-left.nexus) enjs-gid)]
::       [%prio-ryte a+(turn ~(tap in prio-ryte.nexus) enjs-gid)]
::       [%prec-left a+(turn ~(tap in prec-left.nexus) enjs-gid)]
::       [%prec-ryte a+(turn ~(tap in prec-ryte.nexus) enjs-gid)]
::       [%nest-left a+(turn ~(tap in nest-left.nexus) enjs-gid)]
::       [%nest-ryte a+(turn ~(tap in nest-ryte.nexus) enjs-gid)]
::   ==
::
++  enjs-stock
  =,  enjs:format
  |=  =stock
  ^-  json
  :-  %a  %+  turn  stock
  |=  [=gid chief=@p]
  %-  pairs
  :~  [%gid (enjs-gid gid)]
      [%chief (ship chief)]
  ==
::
++  enjs-ranks
  =,  enjs:format
  |=  =ranks
  ^-  json
  :-  %a
  %+  turn  ~(tap by ranks)
  |=  [chip=@p =gid]
  %-  pairs
  :~  [%ship (ship chip)]
      [%gid (enjs-gid gid)]
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
  %-  pairs
  :~  [%gid (enjs-gid gid.goal)]
      [%summary s+summary.goal]
      [%parent ?~(parent.goal ~ (enjs-gid u.parent.goal))]
      [%children a+(turn children.goal enjs-gid)]
      [%start (enjs-node start.goal)]
      [%end (enjs-node end.goal)]
      [%actionable b+actionable.goal]
      [%chief s+(scot %p chief.goal)]
      [%deputies (pairs (turn ~(tap by deputies.goal) |=([=@p =@t] [(scot %p p) s+t])))]
  ==
::
++  enjs-archive
  =,  enjs:format
  |=  =archive
  ^-  json
  %-  pairs
  %+  turn  ~(tap by archive)
  |=  [=gid par=(unit gid) =goals]
  ^-  [@t json]
  :-  gid
  %-  pairs
  :~  [%par ?~(par ~ s+u.par)]
      [%goals (enjs-goals goals)]
  ==
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
  :~  [%status (enjs-status status.node)]
      [%moment (enjs-moment moment.node)]
      [%inflow a+(turn ~(tap in inflow.node) enjs-nid)]
      [%outflow a+(turn ~(tap in outflow.node) enjs-nid)]
  ==
::
++  enjs-status
  =,  enjs:format
  |=  =status
  ^-  json
  :-  %a
  %+  turn  status
  |=  [timestamp=@da done=?]
  %-  pairs
  :~  [%timestamp (numb (unm:chrono:userlib timestamp))]
      [%done b+done]
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
  :~  [%node s+-.nid]
      [%gid (enjs-gid +.nid)]
  ==
::
++  enjs-pid   |=(=pid (rap 3 '/' (scot %p host.pid) '/' name.pid ~))
++  enjs-gid   |=(=gid s+(cat 3 '/' gid))
++  enjs-key   |=(=key s+(rap 3 (enjs-pid pid.key) '/' gid.key ~))
++  enjs-tang  |=(=tang a+(turn tang tank:enjs:format))
--
