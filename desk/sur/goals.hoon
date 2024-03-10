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
      summary=@t             :: (140 character summary of a goal)
      parent=(unit gid)
      children=(list gid)
      start=node
      end=node
      actionable=?
      chief=ship             :: sole person responsible
      =deputies              :: %edit can edit but not move
      =open-to
      metadata=(map @t json) :: arbitrary goal metadata
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
      metadata=(map @t json)
      metadata-properties=(map @t (map @t json))
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
--
