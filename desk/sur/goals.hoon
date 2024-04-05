/-  p=pools
|%
+$  pid       id:p
+$  gid       @ta
+$  nid       [?(%s %e) =gid] :: node gid
+$  key       [=pid =gid]
+$  status    (lest [timestamp=@da done=?])
+$  moment    (unit @da)
+$  node
  $:  =status
      =moment
      inflow=(set nid)
      outflow=(set nid)
  ==
+$  deputies    (map ship ?(%edit %create))
+$  goal-perms  ?(%master %super %editor %creator %viewer) 
+$  open-to     (unit ?(%supers %deputies %viewers)) :: who can claim the goal
+$  metadata    (map @t json)
+$  goal
  $:  =gid
      summary=@t             :: (140 character summary of a goal)
      parent=(unit gid)
      children=(list gid)
      start=node
      end=node
      actionable=?
      chief=ship             :: sole person responsible
      =deputies              :: %edit can edit but not move
      =open-to
      =metadata              :: arbitrary goal metadata
  ==
+$  goals    (map gid goal)
::
+$  role     ?(%host %admin %creator %viewer)
+$  perms    (map ship role)
::
+$  archive
  $:  contexts=(map (unit gid) (list gid))
      contents=(map gid [context=(unit gid) =goals])
  ==
::
+$  pool
  $:  =pid
      title=@t
      =perms
      =goals
      roots=(list gid)
      =archive
      =metadata
      metadata-properties=(map @t metadata)
  ==
::
+$  pool-event  [mod=ship tan=pool-transition]
::
+$  pool-transition 
  $%  [%create-goal =gid upid=(unit gid) summary=@t now=@da]
  ==
::
+$  pool-diff
  $%  [%pool =pool]
      [%title title=@t]
      [%perms p=(each perms (set ship))]
      [%goals =gid goal-diff=(unit goal-diff)]
      [%roots roots=(list gid)]
      [%archive =archive-diff]
      [%metadata p=(each metadata (set @t))]
      [%metadata-properties key=@t p=(unit (each metadata (set @t)))]
  ==
::
+$  archive-diff
  $%  [%contexts p=(each (map (unit gid) (list gid)) (set (unit gid)))]
      [%contents p=(each (map gid [(unit gid) goals]) (set gid))]
  ==
::
+$  goal-diff
  $%  [%goal =goal]
      [%summary summary=@t]
      [%parent parent=(unit gid)]
      [%children children=(list gid)]
      [%start =node-diff]
      [%end =node-diff]
      [%actionable actionable=?]
      [%chief =ship]
      [%deputies p=(each deputies (set ship))]
      [%open-to =open-to]
      [%metadata p=(each metadata (set @t))]
  ==
::
+$  node-diff
  $%  [%status timestamp=@da done=?]
      [%moment =moment]
      [%inflow p=(each nid nid)]  :: only ever happens one at a timme
      [%outflow p=(each nid nid)] :: only ever happens one at a time
  ==
::
+$  pools  (map pid pool)
::
+$  local
  $:  goal-order=(list key)
      pool-order=(list pid)
      goal-metadata=(map key (map @t json))
      pool-metadata=(map pid (map @t json))
      metadata-properties=(map @t (map @t json))
      settings=(map @t json)
  ==
::
+$  store  
  $:  =pools
      =local
  ==
::
+$  stock  (list [=gid chief=ship]) :: lineage; youngest to oldest
+$  ranks  (map ship gid) :: map of ship to highest ranking goal gid
+$  edge   (pair nid nid)
+$  edges  (set edge)
::
+$  exposed-yoke  
  $%  [%prio-rend lid=gid rid=gid] :: start-to-start
      [%prio-yoke lid=gid rid=gid] :: start-to-start
      [%prec-rend lid=gid rid=gid] :: end-to-start
      [%prec-yoke lid=gid rid=gid] :: end-to-start
      [%nest-yoke lid=gid rid=gid] :: end-to-end
      [%nest-rend lid=gid rid=gid] :: end-to-end
      [%hook-rend lid=gid rid=gid] :: start-to-end
      [%hook-yoke lid=gid rid=gid] :: start-to-end
      [%held-rend lid=gid rid=gid] :: start-to-start and end-to-end (containment)
      [%held-yoke lid=gid rid=gid] :: start-to-start and end-to-end (containment)
  ==
::
+$  nuke
  $%  [%nuke-prio-left =gid]
      [%nuke-prio-ryte =gid]
      [%nuke-prio =gid]
      [%nuke-prec-left =gid]
      [%nuke-prec-ryte =gid]
      [%nuke-prec =gid]
      [%nuke-prio-prec =gid]
      [%nuke-nest-left =gid]
      [%nuke-nest-ryte =gid]
      [%nuke-nest =gid]
  ==
::
+$  plex  $%(exposed-yoke nuke) :: complex yoke
--
