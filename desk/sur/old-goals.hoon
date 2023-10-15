|%
++  v5
  =+  v4 :: successive states are nested cores
  |%
  :: values implied by the data structure
  ::
  +$  goal-trace
    $:  =stock
        =ranks
        young=(list [id virtual=?])
        young-by-precedence=(list [id virtual=?])
        young-by-kickoff=(list [id virtual=?])
        young-by-deadline=(list [id virtual=?])
        progress=[complete=@ total=@]
        prio-left=(set id)
        prio-ryte=(set id)
        prec-left=(set id)
        prec-ryte=(set id)
        nest-left=(set id)
        nest-ryte=(set id)
    ==
  ::
  +$  tag  [text=@t color=@t private=?]
  ::
  +$  field-data
    $%  [%ct d=@t] :: categorical
        [%ud d=@ud]
        [%rd d=@rd]
    ==
  ::
  +$  field-type
    $%  [%ct =(set @t)] :: categorical
        [%ud ~]
        [%rd ~]
    ==
  ::
  :: ++  tag-bunt
  ::   %-  sy
  ::   :~  [%tag1 '#ff0000' |]
  ::       [%tag2 '#00ff00' |]
  ::       [%tag3 '#0000ff' |]
  ::   ==
  ::
  +$  goal-hitch
    $:  desc=@t
        note=@t
        tags=(set tag) :: $~(tag-bunt (set tag))
        fields=(map @t field-data)
    ==
  ::
  +$  goal  [goal-nexus goal-froze goal-trace goal-hitch]
  ::
  :: named goal (modules are named)
  +$  ngoal
    $:  nexus=goal-nexus
        froze=goal-froze
        trace=goal-trace
        hitch=goal-hitch
    ==
  ::
  +$  goals  (map id goal)
  :: goals have changed...
  ::
  +$  pool-nexus
    $:  =goals
        cache=goals
        owner=ship
        perms=pool-perms
    ==
  ::
  +$  pool-trace
    $:  stock-map=(map id stock)
        roots=(list id)
        roots-by-precedence=(list id)
        roots-by-kickoff=(list id)
        roots-by-deadline=(list id)
        cache-roots=(list id)
        cache-roots-by-precedence=(list id)
        cache-roots-by-kickoff=(list id)
        cache-roots-by-deadline=(list id)
        d-k-precs=(map id (set id))
        k-k-precs=(map id (set id))
        d-d-precs=(map id (set id))
        left-bounds=(map nid moment)
        ryte-bounds=(map nid moment)
        left-plumbs=(map nid @)
        ryte-plumbs=(map nid @)
    ==
  ::
  +$  pool-hitch    
    $:  title=@t
        note=@t
        fields=(map @t field-type)
    ==
  ::
  +$  pool  [pool-nexus pool-froze trace=pool-trace pool-hitch]
  ::
  :: named pool (modules are named)
  +$  npool
    $:  nexus=pool-nexus
        froze=pool-froze
        trace=pool-trace
        hitch=pool-hitch
    ==
  ::
  +$  pools  (map pin pool)
  ::
  +$  goal-local
    $:  tags=(set tag)
    ==
  +$  local
    $:  order=(list id)
        pools=(list pin)
        goals=(map id goal-local)
    ==
  ::
  +$  store  
    $:  =index
        =pools
        cache=pools
        =local
    ==
  ::
  +$  nux  [goal-nexus goal-trace]
  +$  nex  (map id nux)
  +$  pex  pool-trace
  --
::
++  v4
  =+  v3 :: successive states are nested cores
  |%
  +$  nid  eid :: rename node id
  ::
  +$  stock  (list [=id chief=ship]) :: lineage; youngest to oldest
  +$  ranks  (map ship id) :: map of ship to highest ranking goal id
  ::
  +$  moment  (unit @da)
  ::
  +$  node-nexus
    $:  =moment
        inflow=(set nid)
        outflow=(set nid)
    ==
  ::
  :: values implied by the data structure
  +$  node-trace
    $:  left-bound=moment
        ryte-bound=moment
        left-plumb=@ud
        ryte-plumb=@ud
    ==
  ::
  +$  node  [node-nexus node-trace]
  ::
  +$  edge  (pair nid nid)
  +$  edges  (set edge)
  ::
  +$  goal-nexus
    $:  par=(unit id)
        kids=(set id)
        kickoff=node
        deadline=node
        complete=$~(%| ?)
        actionable=$~(%| ?)
        chief=ship
        spawn=(set ship)
    ==
  ::
  :: values implied by the data structure
  +$  goal-trace
    $:  =stock
        =ranks
        prio-left=(set id)
        prio-ryte=(set id)
        prec-left=(set id)
        prec-ryte=(set id)
        nest-left=(set id)
        nest-ryte=(set id)
    ==
  ::
  +$  goal  [goal-nexus goal-froze goal-trace goal-hitch]
  ::
  :: named goal (modules are named)
  +$  ngoal
    $:  nexus=goal-nexus
        froze=goal-froze
        trace=goal-trace
        hitch=goal-hitch
    ==
  ::
  +$  goals  (map id goal)
  ::
  +$  pool-role  ?(%admin %spawn)
  ::
  +$  pool-perms  (map ship (unit pool-role))
  ::
  +$  pool-nexus
    $:  =goals
        cache=goals
        owner=ship
        perms=pool-perms
    ==
  ::
  +$  pool-froze  [birth=@da creator=ship] :: owner moved to nexus
  ::
  +$  pool-trace
    $:  stock-map=(map id stock)
        left-bounds=(map nid moment)
        ryte-bounds=(map nid moment)
        left-plumbs=(map nid @)
        ryte-plumbs=(map nid @)
    ==
  ::
  +$  pool  [pool-nexus pool-froze trace=pool-trace pool-hitch]
  ::
  :: named pool (modules are named)
  +$  npool
    $:  nexus=pool-nexus
        froze=pool-froze
        trace=pool-trace
        hitch=pool-hitch
    ==
  ::
  +$  pools  (map pin pool)
  ::
  ++  lth-id
    |=  [a=id b=id]
    (lth birth.a birth.b)
  ::
  +$  index  ((mop id pin) lth-id)
  ++  idx-orm  ((on id pin) lth-id)
  ::
  +$  store  
    $:  =index
        =pools
        cache=pools
    ==
  ::
  +$  nux  [goal-nexus goal-trace]
  +$  nex  (map id nux)
  --
::
++  v3
  =+  v2 :: successive states are nested cores
  |%
  +$  goal-perms
    $:  captains=(set ship)
        peons=(set ship)
    ==
  ::
  +$  goal
    $:  goal-froze
        goal-perms
        goal-nexus
        goal-togls
        goal-hitch
    ==
  ::
  :: named goal (modules are named)
  +$  ngoal
    $:  froze=goal-froze
        perms=goal-perms
        nexus=goal-nexus
        togls=goal-togls
        hitch=goal-hitch
    ==
  ::
  +$  goals  (map id goal)
  ::
  +$  pool-perms
    $:  admins=(set ship)
        captains=(set ship)
        viewers=(set ship)
    ==
  ::
  +$  pool-nexus  =goals
  ::
  +$  pool
    $:  pool-froze
        pool-perms
        pool-nexus
        pool-togls
        pool-hitch
    ==
  ::
  :: named pool (modules are named)
  +$  npool
    $:  froze=pool-froze
        perms=pool-perms
        nexus=pool-nexus
        togls=pool-togls
        hitch=pool-hitch
    ==
  ::
  +$  pools  (map pin pool)
  ::
  +$  store  [=directory =pools]
  --
::
++  v2
  =+  v1 :: successive states are nested cores
  |%
  +$  goal-froze
    $:  owner=ship
        birth=@da
        author=ship
    ==
  ::
  +$  goal-perms
    $:  chefs=(set ship)
        peons=(set ship)
    ==
  ::
  +$  goal-nexus
    $:  par=(unit id)
        kids=(set id)
        kickoff=edge
        deadline=edge
    ==
  ::
  +$  goal-togls
    $:  complete=?(%.y %.n)
        actionable=?(%.y %.n)
        archived=?(%.y %.n)
    ==
  ::
  +$  goal-hitch  desc=@t
  ::
  +$  goal
    $:  goal-froze
        goal-perms
        goal-nexus
        goal-togls
        goal-hitch
    ==
  ::
  :: named goal (modules are named)
  +$  ngoal
    $:  froze=goal-froze
        perms=goal-perms
        nexus=goal-nexus
        togls=goal-togls
        hitch=goal-hitch
    ==
  ::
  +$  goals  (map id goal)
  ::
  +$  pool-froze
    $:  owner=ship
        birth=@da
        creator=ship
    ==
  ::
  +$  pool-perms
    $:  chefs=(set ship)
        peons=(set ship)
        viewers=(set ship)
    ==
  ::
  +$  pool-nexus  =goals
  ::
  +$  pool-togls  archived=?(%.y %.n)
  ::
  +$  pool-hitch  title=@t
  ::
  +$  pool
    $:  pool-froze
        pool-perms
        pool-nexus
        pool-togls
        pool-hitch
    ==
  ::
  :: named pool (modules are named)
  +$  npool
    $:  froze=pool-froze
        perms=pool-perms
        nexus=pool-nexus
        togls=pool-togls
        hitch=pool-hitch
    ==
  ::
  +$  pools  (map pin pool)
  ::
  +$  store  [=directory =pools]
  --
::
++  v1
  =+  v0 :: successive states are nested cores
  |%
  +$  edge
    $:  moment=(unit @da)
        inflow=(set eid)
        outflow=(set eid)
    ==
  ::
  +$  goal
    $:  desc=@t
        author=ship
        chefs=(set ship)
        peons=(set ship)
        par=(unit id)
        kids=(set id)
        kickoff=edge
        deadline=edge
        complete=?(%.y %.n)
        actionable=?(%.y %.n)
        archived=?(%.y %.n)
    ==
  ::
  +$  goals  (map id goal)
  ::
  +$  pool
    $:  title=@t
        creator=ship
        =goals
        chefs=(set ship)
        peons=(set ship)
        viewers=(set ship)
        archived=?(%.y %.n)
    ==
  ::
  +$  pools  (map pin pool)
  ::
  +$  store  [=directory =pools]
  --
::
++  v0
  |%
  ::
  :: $id: identity of a goal; determined by creator and time of creation
  +$  id  [owner=@p birth=@da]
  ::
  +$  eid  [?(%k %d) =id]
  ::
  +$  pin  [%pin id]
  ::
  +$  split
    $:  moment=(unit @da)
        inflow=(set eid)
        outflow=(set eid)
    ==
  ::
  +$  goal
    $:  desc=@t
        author=ship
        chefs=(set ship)
        peons=(set ship)
        par=(unit id)
        kids=(set id)
        kickoff=split
        deadline=split
        complete=?(%.y %.n)
        actionable=?(%.y %.n)
        archived=?(%.y %.n)
    ==
  ::
  +$  goals  (map id goal)
  ::
  +$  project
    $:  title=@t
        creator=ship
        =goals
        chefs=(set ship)
        peons=(set ship)
        viewers=(set ship)
        archived=?(%.y %.n)
    ==
  ::
  +$  projects  (map pin project)
  ::
  +$  directory  (map id pin)
  ::
  +$  store  [=directory =projects]
  --
--
