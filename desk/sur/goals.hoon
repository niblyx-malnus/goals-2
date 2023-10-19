/-  old-goals
=,  v5:old-goals
|%
+$  pin  [host=ship name=term]
+$  id   [=pin key=@ta] :: globally unique, always references source pool
+$  nid  [?(%k %d) =id]
+$  stock  (list [=id chief=ship]) :: lineage; youngest to oldest
+$  ranks  (map ship id) :: map of ship to highest ranking goal id
+$  node-nexus
  $:  =moment
      inflow=(set nid)
      outflow=(set nid)
  ==
+$  node-trace
  $:  left-bound=moment
      ryte-bound=moment
      left-plumb=@ud
      ryte-plumb=@ud
  ==
+$  node  [node-nexus node-trace]
+$  edge  (pair nid nid)
+$  edges  (set edge)
+$  goal-nexus
  $:  par=(unit id)
      kids=(set id)
      kickoff=node
      deadline=node
      complete=$~(%| ?)
      actionable=$~(%& ?)
      chief=ship
      spawn=(set ship)
  ==
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
+$  goal  [goal-nexus goal-froze goal-trace goal-hitch]
+$  ngoal :: modules are named
  $:  nexus=goal-nexus
      froze=goal-froze
      trace=goal-trace
      hitch=goal-hitch
  ==
+$  goals  (map id goal)
+$  pool-nexus
  $:  =goals
      cache=goals
      owner=ship
      perms=pool-perms
  ==
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
+$  pool  [pool-nexus pool-froze trace=pool-trace pool-hitch]
+$  npool :: modules are named
  $:  nexus=pool-nexus
      froze=pool-froze
      trace=pool-trace
      hitch=pool-hitch
  ==
::
+$  pools  (map pin pool)
+$  local
  $:  order=(list id)
      pools=(list pin)
      goals=(map id goal-local)
  ==
::
+$  store  
  $:  =pools
      cache=pools
      =local
  ==
+$  nux  [goal-nexus goal-trace]
+$  nex  (map id nux)
+$  pex  pool-trace
--
