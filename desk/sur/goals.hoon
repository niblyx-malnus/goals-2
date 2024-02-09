/-  jot=json-tree
|%
+$  moment    (unit @da)
+$  pid       [host=ship name=term]
+$  gid       @ta
+$  nid       [?(%s %e) =gid] :: node gid
+$  key       [=pid =gid]
+$  status    (lest [timestamp=@da done=?])
+$  node
  $:  =status
      =moment
      inflow=(set nid)
      outflow=(set nid)
  ==
+$  deputies  (map ship ?(%edit %create))
+$  goal
  $:  =gid
      summary=@t      :: (140 character summary of a goal)
      parent=(unit gid)
      children=(set gid)
      start=node
      end=node
      actionable=?    :: 
      chief=ship      :: sole person responsible
      =deputies       :: %edit can edit but not move
  ==
+$  goals    (map gid goal)
::
+$  role     ?(%owner %admin %creator %viewer)
+$  perms    (map ship role)
::
+$  archive  (map gid [par=(unit gid) =goals])
::
+$  pool
  $:  =pid
      title=@t
      =perms
      =goals
      =archive
  ==
::
+$  stock     (list [=gid chief=ship]) :: lineage; youngest to oldest
+$  ranks     (map ship gid) :: map of ship to highest ranking goal gid
+$  edge      (pair nid nid)
+$  edges     (set edge)
::
+$  order-by
  $:  by-precedence=(list gid)
      by-kickoff=(list gid)
      by-deadline=(list gid)
  ==
::
+$  module  [parent=(unit gid) version=@ud body=json]
::
+$  pool-data
  $:  properties=(map @t @t)
      tags=(map gid (set @t))
      fields=(map gid (map @t @t))
      tag-properties=(map @t (map @t @t))
      field-properties=(map @t (map @t @t))
      modules=(map @t (map @t module))
  ==
::
+$  pools  (map pid pool)
::
+$  local
  $:  goal-order=(list key)
      pool-order=(list pid) :: order of pools
      tags=(map key (set @t))
      fields=(map key (map @t @t))
      tag-properties=(map @t (map @t @t))
      field-properties=(map @t (map @t @t))
      settings=(map @t @t)
  ==
::
+$  store  
  $:  =pools
      =local
      pool-info=(map pid pool-data)
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
      young=(list [gid virtual=?])
      young-by-precedence=(list [gid virtual=?])
      young-by-kickoff=(list [gid virtual=?])
      young-by-deadline=(list [gid virtual=?])
      progress=[complete=@ total=@]
      prio-left=(set gid)
      prio-ryte=(set gid)
      prec-left=(set gid)
      prec-ryte=(set gid)
      nest-left=(set gid)
      nest-ryte=(set gid)
  ==
+$  pool-trace
  $:  stock-map=(map gid stock)
      roots=(list gid)
      roots-by-precedence=(list gid)
      roots-by-kickoff=(list gid)
      roots-by-deadline=(list gid)
      cache-roots=(list gid)
      cache-roots-by-precedence=(list gid)
      cache-roots-by-kickoff=(list gid)
      cache-roots-by-deadline=(list gid)
      d-k-precs=(map gid (set gid))
      k-k-precs=(map gid (set gid))
      d-d-precs=(map gid (set gid))
      left-bounds=(map nid moment)
      ryte-bounds=(map nid moment)
      left-plumbs=(map nid @)
      ryte-plumbs=(map nid @)
  ==
+$  trace
  $:  nodes=(map nid node-trace)
      goals=(map gid goal-trace)
      pools=(map pid pool-trace)
  ==
--
