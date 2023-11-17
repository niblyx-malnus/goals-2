|%
+$  moment    (unit @da)
+$  pin       [host=ship name=term]
+$  id        [=pin key=@ta] :: globally unique, always references source pool
+$  nid       [?(%k %d) =id]
+$  stock     (list [=id chief=ship]) :: lineage; youngest to oldest
+$  ranks     (map ship id) :: map of ship to highest ranking goal id
+$  node
  $:  done=$~(%| ?) :: kickoff: goal started; deadline: goal completed
      =moment
      inflow=(set nid)
      outflow=(set nid)
  ==
+$  edge      (pair nid nid)
+$  edges     (set edge)
+$  deputies  (map ship ?(%edit %create))
+$  goal
  $:  par=(unit id)
      kids=(set id)
      kickoff=node
      deadline=node
      actionable=?
      chief=ship
      =deputies
  ==
+$  goals  (map id goal)
::
+$  pool-role   ?(%admin %creator)
+$  pool-perms  (map ship (unit pool-role))
::
+$  pool
  $:  =goals
      cache=goals
      owner=ship
      perms=pool-perms
      properties=(map @t @t)
      tags=(map id (set @t))
      fields=(map id (map @t @t))
      tag-properties=(map @t (map @t @t))
      field-properties=(map @t (map @t @t))
  ==
+$  pools  (map pin pool)
::
+$  goal-local
  $:  tags=(set @t)
  ==
+$  local
  $:  order=(list id)
      pools=(list pin) :: order of pools
      goals=(map id goal-local)
  ==
::
+$  store  
  $:  =pools
      cache=pools
      =local
  ==
::
+$  node-trace
  $:  left-bound=moment
      ryte-bound=moment
      left-plumb=@ud
      ryte-plumb=@ud
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
+$  trace
  $:  nodes=(map nid node-trace)
      goals=(map id goal-trace)
      pools=(map pin pool-trace)
  ==
--
