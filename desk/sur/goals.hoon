/-  jot=json-tree
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
      young=(list id) :: an order on kids and "virtual" subgoals
      kickoff=node
      deadline=node
      actionable=?
      chief=ship
      =deputies
      summary=@t      :: (140 character summary of a goal)
  ==
+$  goals    (map id goal)
::
+$  role     ?(%owner %admin %creator)
+$  perms    (map ship (unit role))
::
+$  archive  (map id [par=(unit id) =goals])
::
+$  pool
  $:  =pin
      =perms
      =goals
      roots=(list id) :: an order on parentless goals
      =archive
      title=@t
  ==
::
+$  order-by
  $:  by-precedence=(list id)
      by-kickoff=(list id)
      by-deadline=(list id)
  ==
::
+$  module  [parent=(unit id) version=@ud body=json]
::
+$  pool-data
  $:  properties=(map @t @t)
      tags=(map id (set @t))
      fields=(map id (map @t @t))
      tag-properties=(map @t (map @t @t))
      field-properties=(map @t (map @t @t))
      modules=(map @t (map @t module))
  ==
::
+$  pools  (map pin pool)
::
+$  local
  $:  goal-order=(list id)
      pool-order=(list pin) :: order of pools
      tags=(map id (set @t))
      fields=(map id (map @t @t))
      tag-properties=(map @t (map @t @t))
      field-properties=(map @t (map @t @t))
      settings=(map @t @t)
  ==
::
+$  store  
  $:  =pools
      =local
      pool-info=(map pin pool-data)
      =json-tree:jot
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
