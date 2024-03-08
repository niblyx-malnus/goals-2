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
+$  open-to   (unit ?(%admins %deputies %viewers)) :: who can claim the goal
+$  goal
  $:  =gid
      summary=@t         :: (140 character summary of a goal)
      parent=(unit gid)
      children=(list gid)
      start=node
      end=node
      actionable=?
      chief=ship         :: sole person responsible
      =deputies          :: %edit can edit but not move
      =open-to
      metadata=(map @t @t)
  ==
+$  goals    (map gid goal)
::
+$  role     ?(%owner %admin %creator %viewer)
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
      metadata=(map @t @t)
      metadata-properties=(map @t (map @t @t))
  ==
::
+$  pools  (map pid pool)
::
+$  local
  $:  goal-order=(list key)
      pool-order=(list pid)
      goal-metadata=(map key (map @t @t))
      pool-metadata=(map pid (map @t @t))
      metadata-properties=(map @t (map @t @t))
      settings=(map @t @t)
  ==
::
+$  store  
  $:  =pools
      =local
      =json-tree:jot
  ==
::
+$  stock  (list [=gid chief=ship]) :: lineage; youngest to oldest
+$  ranks  (map ship gid) :: map of ship to highest ranking goal gid
+$  edge   (pair nid nid)
+$  edges  (set edge)
--
