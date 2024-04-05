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
  ++  ab  (each-method %above %below)
  ::
  ++  pd-settings
    %+  (pd ,[@t json] @t)
      (ot ~[setting+so contents+same])
    (ot ~[setting+so])
  ::
  ++  ab-goal-order
    %+  (ab ,[^key ^key] ,[^key ^key])
      (ot ~[dis+key dat+key])
    (ot ~[dis+key dat+key])
  ::
  ++  ab-pool-order
    %+  (ab ,[^pid ^pid] ,[^pid ^pid])
      (ot ~[dis+pid dat+pid])
    (ot ~[dis+pid dat+pid])
  ::
  ++  pd-goal-metadata
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (gid (~(got by p.jon) 'gid'))
    %.  o+(~(del by p.jon) 'gid')
    %+  (pd ,[@t json] [@t])
      (ot ~[field+so data+same])
    (ot ~[field+so])
  ::
  ++  pd-pool-metadata
    %+  (pd ,[@t json] [@t])
      (ot ~[property+so data+same])
    (ot ~[property+so])
  ::
  ++  pd-pool-metadata-field
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (so (~(got by p.jon) 'field'))
    %.  o+(~(del by p.jon) 'field')
    %+  (pd ,[@t json] [@t])
      (ot ~[property+so data+same])
    (ot ~[property+so])
  ::
  ++  pd-local-goal-metadata
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (key (~(got by p.jon) 'key'))
    %.  o+(~(del by p.jon) 'key')
    %+  (pd ,[@t json] [@t])
      (ot ~[field+so data+same])
    (ot ~[field+so])
  ::
  ++  pd-local-pool-metadata
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (pid (~(got by p.jon) 'pid'))
    %.  o+(~(del by p.jon) 'pid')
    %+  (pd ,[@t json] [@t])
      (ot ~[field+so data+same])
    (ot ~[field+so])
  ::
  ++  pd-local-metadata-properties
    |=  jon=json
    ?>  ?=(%o -.jon)
    :-  (so (~(got by p.jon) 'field'))
    =.  jon  o+(~(del by p.jon) 'field')
    ?~  p.jon  ~
    :-  ~
    %.  jon
    %+  (pd ,[@t json] [@t])
      (ot ~[property+so data+same])
    (ot ~[property+so])
  ::
  ++  local-action
    ^-  $-(json local-action:act)
    %-  of
    :~  [%goal-metadata pd-local-goal-metadata]
        [%pool-metadata pd-local-pool-metadata]
        [%metadata-properties pd-local-metadata-properties]
        [%settings pd-settings]
        [%create-pool (ot ~[title+so])]
        [%delete-pool (ot ~[pid+pid])]
    ==
  ::
  ++  pool-action
    ^-  $-(json pool-action:act)
    %-  of
    :~  [%set-pool-title (ot ~[title+so])]
        [%create-goal (ot ~[upid+unit-gid summary+so actionable+bo active+bo])]
        [%archive-goal (ot ~[gid+gid])]
        [%restore-goal (ot ~[gid+gid])]
        [%restore-to-root (ot ~[gid+gid])]
        [%delete-from-archive (ot ~[gid+gid])]
        [%delete-goal (ot ~[gid+gid])]
        [%yoke (ot ~[yoks+yoke-seq])]
        [%move (ot ~[cid+gid upid+unit-gid])]
        [%set-summary (ot ~[gid+gid summary+so])]
        [%set-start (ot ~[gid+gid start+unit-di])]
        [%set-end (ot ~[gid+gid end+unit-di])]
        [%set-chief (ot ~[gid+gid chief+ship rec+bo])]
        [%set-open-to (ot ~[gid+gid open-to+open-to])]
        [%set-actionable (ot ~[gid+gid val+bo])]
        [%set-complete (ot ~[gid+gid val+bo])]
        [%set-active (ot ~[gid+gid val+bo])]
        [%reorder-roots (ot ~[roots+(ar gid)])]
        [%reorder-children (ot ~[gid+gid children+(ar gid)])]
        [%reorder-archive (ot ~[context+unit-gid archive+(ar gid)])]
        [%update-goal-metadata pd-goal-metadata]
        [%update-pool-metadata pd-pool-metadata]
        [%update-pool-metadata-field pd-pool-metadata-field]
        [%delete-pool-metadata-field (ot ~[field+so])]
    ==
  ::
  ++  perms
    |=  jon=json
    ^-  (map ^ship ^role)
    %-  ~(gas by *(map ^ship ^role))
    %.(jon (ar (ot ~[ship+ship role+role])))
  ::
  ++  open-to  |=(jon=json ;;(^open-to ?~(jon ~ [~ (so jon)])))
  ::
  ++  role
    %-  su
    ;~  pose
      (cold %host (jest 'host'))
      (cold %admin (jest 'admin'))
      (cold %creator (jest 'creator'))
      (cold %viewer (jest 'viewer'))
    ==
  ++  unit-di  |=(jon=json ?~(jon ~ (some (di jon))))
  ++  unit-date  |=(jon=json ?~(jon ~ (some (date jon))))
  ++  unit-gid  |=(jon=json ?~(jon ~ (some (gid jon))))
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
      [%roots a+(turn roots.pool enjs-gid)]
      [%archive (enjs-archive archive.pool)]
      [%metadata o+metadata.pool]
      [%metadata-properties (enjs-metadata-properties metadata-properties.pool)]
  ==
::
++  enjs-metadata-properties
  =,  enjs:format
  |=  metadata-properties=(map @t (map @t json))
  %-  pairs
  %+  turn
    ~(tap by metadata-properties)
  |=  [f=@t p=(map @t json)]
  [f o+p]
::
++  enjs-perms
  =,  enjs:format
  |=  =perms
  ^-  json
  :-  %a
  %+  turn  ~(tap by perms) 
  |=  [=@p =role] 
  %-  pairs
  :~  [%ship s+(scot %p p)]
      [%role s+role]
  ==
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
++  enjs-local
  =,  enjs:format
  |=  local
  ^-  json
  %-  pairs
  :~  [%goal-order a+(turn goal-order enjs-key)]
      [%pool-order a+(turn pool-order (cork enjs-pid (lead %s)))]
      [%goal-metadata (enjs-goal-metadata goal-metadata)]
      [%pool-metadata (enjs-pool-metadata pool-metadata)]
      [%metadata-properties (enjs-metadata-properties metadata-properties)]
      [%settings o+settings]
  ==
::
++  enjs-goal-metadata
  =,  enjs:format
  |=  goal-metadata=(map key (map @t json))
  ^-  json
  %-  pairs
  %+  turn  ~(tap by goal-metadata)
  |=  [=key metadata=(map @t json)]
  [+:(enjs-key key) o+metadata]
::
++  enjs-pool-metadata
  =,  enjs:format
  |=  pool-metadata=(map pid (map @t json))
  ^-  json
  %-  pairs
  %+  turn  ~(tap by pool-metadata)
  |=  [=pid metadata=(map @t json)]
  [(enjs-pid pid) o+metadata]
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
      [%open-to ?~(open-to.goal ~ s+u.open-to.goal)]
      [%metadata o+metadata.goal]
  ==
::
++  enjs-archive-contexts
  =,  enjs:format
  |=  contexts=(map (unit gid) (list gid))
  ^-  json
  %-  pairs
  %+  turn  ~(tap by contexts)
  |=  [context=(unit gid) archive=(list gid)]
  ^-  [@t json]
  :-  ?~(context 'pool-root' u.context)
  a+(turn archive (lead %s))
::
++  enjs-archive-contents
  =,  enjs:format
  |=  contents=(map gid [(unit gid) goals])
  ^-  json
  %-  pairs
  %+  turn  ~(tap by contents)
  |=  [=gid context=(unit gid) =goals]
  ^-  [@t json]
  :-  gid
  %-  pairs
  :~  [%context ?~(context s+'pool-root' s+u.context)]
      [%goals (enjs-goals goals)]
  ==
::
++  enjs-archive
  =,  enjs:format
  |=  =archive
  ^-  json
  %-  pairs
  :~  contexts+(enjs-archive-contexts contexts.archive)
      contents+(enjs-archive-contents contents.archive)
  ==
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
