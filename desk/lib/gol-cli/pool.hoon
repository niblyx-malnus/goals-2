/-  gol=goals, act=action
/+  gol-cli-node, gol-cli-traverse, vd=gol-cli-validate
|_  =pool:gol
+*  this  .
    tv    ~(. gol-cli-traverse goals.pool)
    nd    ~(. gol-cli-node goals.pool)
++  abet  pool
++  apex  |=(=pool:gol this(pool pool))
::
:: ============================================================================
:: 
:: SPAWNING/CACHING/WASTING/TRASHING/RENEWING GOALS
::
:: ============================================================================
::
:: Initialize a goal with initial state
++  init-goal
  |=  [=gid:gol summary=@t chief=ship now=@da]
  ^-  goal:gol
  ?.  (lte (met 3 summary) 140)
    ~|("Summary exceeds 140 characters." !!)
  =|  =goal:gol
  =.  gid.goal       gid
  =.  chief.goal    chief
  =.  summary.goal  summary
  :: Initialize inflowing and outflowing nodes
  :: 
  =.  outflow.start.goal  (~(put in *(set nid:gol)) [%e gid])
  =.  inflow.end.goal     (~(put in *(set nid:gol)) [%s gid])
  =.  status.start.goal   [[now %|] ~]
  =.  status.end.goal     [[now %|] ~]
  goal
::
++  create-goal
  |=  [=gid:gol upid=(unit gid:gol) summary=@t now=@da mod=ship]
  ^-  _this
  ?>  ?~  upid
        (check-root-create-perm mod)
      (check-goal-create-perm u.upid mod)
  =/  goal  (init-goal gid summary mod now)
  =.  goals.pool  (~(put by goals.pool) gid goal)
  (handle-pool-transition host.pid.pool %move gid upid) :: divine intervention (host)
:: Move goal and subgoals from main goals to archive
::
++  archive-goal
  |=  [=gid:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm gid mod)
  =/  context=(unit gid:gol)  parent:(~(got by goals.pool) gid)
  =^  trac  this
    (wrest-goal gid mod) :: mod has the correct perms for this
  =/  old-list=(list gid:gol)  (~(gut by contexts.archive.pool) context ~)
  =/  new-list=(list gid:gol)  [gid old-list]
  =.  contexts.archive.pool  (~(put by contexts.archive.pool) context new-list)
  =.  contents.archive.pool  (~(put by contents.archive.pool) gid [context trac])
  this
:: TODO: when a goal is deleted from goals or from contents.archive
::       update the contexts in the archive (or delete completely?)
:: Restore goal from archive to main goals
::
++  restore-goal
  |=  [=gid:gol mod=ship]
  ^-  _this
  =+  (~(got by contents.archive.pool) gid)
  ?>  ?~  context
        (check-goal-master gid mod)
      (check-goal-edit-perm u.context mod)
  =.  goals.pool  (~(uni by goals.pool) (validate-goals:vd goals))
  =/  old-list=(list gid:gol)  (~(got by contexts.archive.pool) context)
  =/  new-list=(list gid:gol)  (purge-from-list gid old-list)
  =.  contexts.archive.pool  (~(put by contexts.archive.pool) context new-list)
  =.  contents.archive.pool  (~(del by contents.archive.pool) gid)
  (handle-pool-transition mod %move gid context)
:: Restore goal from archive to main goals at root
::
++  restore-to-root
  |=  [=gid:gol mod=ship]
  ^-  _this
  ?>  (check-goal-master gid mod)
  =+  (~(got by contents.archive.pool) gid)
  =.  goals.pool  (~(uni by goals.pool) (validate-goals:vd goals))
  =/  old-list=(list gid:gol)  (~(got by contexts.archive.pool) context)
  =/  new-list=(list gid:gol)  (purge-from-list gid old-list)
  =.  contexts.archive.pool  (~(put by contexts.archive.pool) context new-list)
  =.  contents.archive.pool  (~(del by contents.archive.pool) gid)
  (handle-pool-transition mod %move gid ~)
::
++  delete-from-archive
  |=  [=gid:gol mod=ship]
  ^-  _this
  :: Only admin level can perma-delete
  ::
  ?>  (check-pool-edit-perm mod)
  =+  (~(got by contents.archive.pool) gid)
  =/  old-list=(list gid:gol)  (~(got by contexts.archive.pool) context)
  =/  new-list=(list gid:gol)  (purge-from-list gid old-list)
  =.  contexts.archive.pool  (~(put by contexts.archive.pool) context new-list)
  =.  contents.archive.pool  (~(del by contents.archive.pool) gid)
  this
:: Permanently delete goal and subgoals from archive
::
++  delete-goal
  |=  [=gid:gol mod=ship]
  ^-  _this
  :: Only admin level can perma-delete
  ::
  ?>  (check-pool-edit-perm mod)
  =^  trac  this
    (wrest-goal gid mod) :: correctly handles orders
  this
:: Extract goal from goals
::
++  wrest-goal
  |=  [=gid:gol mod=ship]
  ^-  [trac=goals:gol _this]
  :: Get subgoals of goal including self
  ::
  =/  progeny=(set gid:gol)  (progeny:tv gid)
  :: Move goal to root (divine intervention by host)
  ::
  =.  this  (handle-pool-transition host.pid.pool %move gid ~)
  :: Partition subgoals of goal from rest of goals
  :: (Remove non-hierarchical DAG relationships)
  ::
  =.  this  (handle-pool-transition mod %partition progeny)
  :: Get extracted goals
  ::
  :-  %-  ~(gas by *goals:gol)
      %+  turn  ~(tap in progeny)
      |=  =gid:gol
      [gid (~(got by goals.pool) gid)]
  :: Update goals to remaining
  ::
  %=    this
      goals.pool
    %-  ~(gas by *goals:gol)
    %+  murn  ~(tap by goals.pool)
    |=  [=gid:gol =goal:gol]
    ?:  (~(has in progeny) gid)
      ~
    [~ gid goal]
  ==
::
:: ============================================================================
:: 
:: PERMISSIONS UTILITIES
::
:: ============================================================================
:: host or admin
::
++  check-pool-edit-perm
  |=  mod=ship
  ^-  ?
  ?|  =(mod host.pid.pool)
      ?=(%admin (~(got by perms.pool) mod))
  ==
:: host, admin or creator
::
++  check-root-create-perm
  |=  mod=ship
  ^-  ?
  ?|  =(mod host.pid.pool)
      ?=(?(%admin %creator) (~(got by perms.pool) mod))
  ==
:: most senior ancestor
::
++  stock-root
  |=  =gid:gol
  ^-  [=gid:gol chief=ship]
  (snag 0 (flop (get-stock:tv gid)))
:: host, admin, or chief of stock-root (most senior ancestor)
:: goal master can edit and re-assign the goal
:: and move it anywhere they can create a goal
::
++  check-goal-master
  |=  [=gid:gol mod=ship]
  ^-  ?
  ?|  (check-pool-edit-perm mod)
      =(mod chief:(stock-root gid))
  ==
::
++  get-ancestral-deputies
  |=  =gid:gol
  ^-  deputies:gol 
  :: ignore self; only ancestors
  =/  =stock:gol  ?~(get=(get-stock:tv gid) ~ t.get)
  =|  =deputies:gol
  |-
  ?~  stock
    deputies
  =/  =goal:gol  (~(got by goals.pool) gid.i.stock)
  %=  $
    stock     t.stock
    deputies  (~(uni by deputies) deputies.goal)
  ==
:: can edit pool (host or admin)
:: or is ranking member on goal
:: goal super can edit and re-assign the goal
::
++  check-goal-super
  |=  [=gid:gol mod=ship]
  ^-  ?
  ?|  (check-pool-edit-perm mod)
      ?=(^ (get-rank:tv mod gid))
      ?=([~ %edit] (~(get by (get-ancestral-deputies gid)) mod))
  ==
:: can edit pool (host or admin)
:: or is ranking member on goal
:: or is a deputy with edit permissions
::
++  check-goal-edit-perm
  |=  [=gid:gol mod=ship]
  ^-  ?
  ?|  (check-goal-super gid mod)
      ?=([~ %edit] (~(get by deputies:(~(got by goals.pool) gid)) mod))
  ==
:: Can yoke with permissions on *both* goals
:: This only works if "rends" work with perms on *either*
::
++  check-dag-yoke-perm
  |=  [bef=nid:gol aft=nid:gol mod=ship]
  ?&  (check-goal-edit-perm gid.bef mod)
      (check-goal-edit-perm gid.aft mod)
  ==
:: Can rend with permissions on *either* goal
::
++  check-dag-rend-perm
  |=  [bef=nid:gol aft=nid:gol mod=ship]
  ?|  (check-goal-edit-perm gid.bef mod)
      (check-goal-edit-perm gid.aft mod)
  ==
:: can edit goal
:: or is a deputy with create permissions
::
++  check-goal-create-perm
  |=  [=gid:gol mod=ship]
  ^-  ?
  ?|  (check-goal-edit-perm gid mod)
      ?=([~ %create] (~(get by deputies:(~(got by goals.pool) gid)) mod))
  ==
::
++  check-move-to-root-perm
  |=  [=gid:gol mod=ship]
  ^-  ?
  ?&  (check-goal-master gid mod)
      (check-root-create-perm mod)
  ==
::
++  nearest-common-ancestor
  |=  [a=gid:gol b=gid:gol]
  ^-  (unit gid:gol)
  =/  a-flock=stock:gol  (flop (get-stock:tv a))
  =/  b-flock=stock:gol  (flop (get-stock:tv b))
  =|  anc=(unit gid:gol)
  |-
  ?~  a-flock
    anc
  ?~  b-flock
    anc
  ?.  =(gid.i.a-flock gid.i.b-flock)
    anc
  %=  $
    anc      [~ gid.i.a-flock]
    a-flock  t.a-flock
    b-flock  t.b-flock
  ==
:: checks if mod can move kid under pid
::
++  check-move-to-goal-perm
  |=  [kid=gid:gol dad=gid:gol mod=ship]
  ^-  ?
  ?|  (check-pool-edit-perm mod)
      :: permissions on a goal which contains both goals
      ::
      ?~  nec=(nearest-common-ancestor kid dad)
        %|
      (check-goal-edit-perm u.nec mod)
      :: if master of kid and edit permissions on dad
      ::
      ?&  (check-goal-master kid mod)
          (check-goal-create-perm dad mod)
  ==  ==
:: checks if mod can modify ship's pool permissions
::
++  check-pool-role-mod
  |=  [member=ship mod=ship]
  ^-  ?
  ?:  =(member host.pid.pool)
    ~|("Cannot change host perms." !!)
  ?.  (check-pool-edit-perm mod)
    ~|("Do not have host or admin perms." !!)
  ?:  ?&  =((~(get by perms.pool) member) (some (some %admin)))
          !|(=(mod host.pid.pool) =(mod member))
      ==
    ~|("Must be host or self to modify admin perms." !!)
  %&
::
++  check-open-to
  |=  [=gid:gol mod=ship]
  ^-  ?
  =/  =goal:gol  (~(got by goals.pool) gid)
  ?+    open-to.goal  %|
    [~ %supers]    (check-pool-edit-perm mod)
    [~ %deputies]  (check-goal-edit-perm gid mod)
    [~ %viewers]   (~(has by perms.pool) mod)
  ==
:: Check that I can modify the goal chief
::
++  check-goal-chief-mod-perm
  |=  [=gid:gol mod=ship]
  ^-  ?
  ?|  (check-goal-super gid mod)
      (check-open-to gid mod)
  ==
::
++  get-goal-permission-level
  |=  [=gid:gol mod=ship]
  ^-  goal-perms:gol
  ?:  (check-goal-master gid mod)       %master
  ?:  (check-goal-super gid mod)        %super
  ?:  (check-goal-edit-perm gid mod)    %editor
  ?:  (check-goal-create-perm gid mod)  %creator
  %viewer
::
++  check-in-pool  |=(=ship |(=(ship host.pid.pool) (~(has by perms.pool) ship)))
::
++  purge-from-list
  |*  [item=* =(list)]
  ^-  (^list _item)
  =/  allowed=(set _item)
    (~(del in (silt list)) item)
  %+  murn  list
  |=  i=_item
  ?.  (~(has in allowed) i)
    ~
  [~ i]
::
++  bounded
  |=  [=nid:gol =moment:gol dir=?(%l %r)]
  ^-  ?
  ?-  dir
    %l  =/(lb (left-bound:tv nid) ?~(moment %| ?~(lb %| (gth u.lb u.moment))))
    %r  =/(rb (ryte-bound:tv nid) ?~(moment %| ?~(rb %| (lth u.rb u.moment))))
  == 
::
++  handle-pool-event
  |=  ven=pool-event:act
  ^-  _this
  ?-    -.ven
      %dag-yoke
    :: Cannot put end before start
    ::
    ?:  &(?=(%e -.bef.ven) ?=(%s -.aft.ven) =(gid.bef.ven gid.aft.ven))
      ~|("inverting-goal-start-end" !!)
    :: Cannot create left-undone-right-done relationship
    ::
    ?:  ?&  !done.i.status:(got-node:nd bef.ven)
            done.i.status:(got-node:nd aft.ven)
        ==
      ~|("left-undone-right-done" !!)
    :: aft.ven must not come before bef.ven
    ::
    ?:  (check-path:tv aft.ven bef.ven %r)  ~|("already-ordered" !!)
    ::
    =/  bef-node=node:gol  (got-node:nd bef.ven)
    =/  aft-node=node:gol  (got-node:nd aft.ven)
    :: there must be no bound mismatch between bef.ven and aft.ven
    ::
    =/  lb  ?~(moment.bef-node (left-bound:tv bef.ven) moment.bef-node)
    =/  rb  ?~(moment.aft-node (ryte-bound:tv aft.ven) moment.aft-node)
    ?:  ?~(lb %| ?~(rb %| (gth u.lb u.rb)))  ~|("bound-mismatch" !!)
    :: dag-yoke
    ::
    =.  outflow.bef-node  (~(put in outflow.bef-node) aft.ven)
    =.  inflow.aft-node   (~(put in inflow.aft-node) bef.ven)
    =.  goals.pool        (update-node:nd bef.ven bef-node)
    =.  goals.pool        (update-node:nd aft.ven aft-node)
    this
    ::
      %dag-rend
    :: Cannot unrelate goal from itself
    ::
    ?:  =(gid.bef.ven gid.aft.ven)  ~|("same-goal" !!)
    :: Cannot destroy containment of an owned goal
    ::
    =/  l  (~(got by goals.pool) gid.bef.ven)
    =/  r  (~(got by goals.pool) gid.aft.ven)
    ?:  ?|  &(=(-.bef.ven %e) =(-.aft.ven %e) (~(has in (sy children.r)) gid.bef.ven))
            &(=(-.bef.ven %s) =(-.aft.ven %s) (~(has in (sy children.l)) gid.aft.ven))
        ==
      ~|("owned-goal" !!)
    :: dag-rend
    ::
    =/  bef-node=node:gol  (got-node:nd bef.ven)
    =/  aft-node=node:gol  (got-node:nd aft.ven)
    =.  outflow.bef-node  (~(del in outflow.bef-node) aft.ven)
    =.  inflow.aft-node   (~(del in inflow.aft-node) bef.ven)
    =.  goals.pool        (update-node:nd bef.ven bef-node)
    =.  goals.pool        (update-node:nd aft.ven aft-node)
    this
    ::
      %add-root
    this(roots.pool [gid.ven roots.pool])
    ::
      %del-root
    this(roots.pool (purge-from-list gid.ven roots.pool))
    ::
      %reorder-roots
    ?>  =((sy roots.ven) (sy roots.pool))
    this(roots.pool roots.ven)
    ::
      %add-child
    =/  =goal:gol  (~(got by goals.pool) dad.ven)
    ?:  actionable.goal  ~|("actionable-goal-cannot-have-child" !!)
    =.  children.goal  [kid.ven children.goal]
    this(goals.pool (~(put by goals.pool) dad.ven goal))
    ::
      %del-child
    =/  =goal:gol  (~(got by goals.pool) dad.ven)
    =.  children.goal  (purge-from-list kid.ven children.goal)
    this(goals.pool (~(put by goals.pool) dad.ven goal))
::
      %reorder-children
    =/  =goal:gol  (~(got by goals.pool) gid.ven)
    ?>  =((sy children.ven) (sy children.goal))
    %=    this
        goals.pool
      %+  ~(put by goals.pool)
        gid.ven
      goal(children children.ven)
    ==
    ::
      %update-parent
    ?:  ?~(dad.ven %| actionable:(~(got by goals.pool) u.dad.ven))
      ~|("actionable-goal-cannot-have-child" !!)
    =/  =goal:gol  (~(got by goals.pool) kid.ven)
    this(goals.pool (~(put by goals.pool) kid.ven goal(parent dad.ven)))
    ::
      %archive-root-tree
    ?>  (~(has in (sy roots.pool)) gid.ven)
    :: Get subgoals of goal including self
    ::
    =/  progeny=(set gid:gol)  (progeny:tv gid.ven)
    =/  root-tree=goals:gol
      %-  ~(gas by *goals:gol)
      %+  turn  ~(tap in progeny)
      |=  =gid:gol
      [gid (~(got by goals.pool) gid)]
    ::
    %=    this
        contents.archive.pool
      %+  ~(put by contents.archive.pool)
        gid.ven
      [context.ven root-tree]
      ::
        goals.pool
      %-  ~(gas by *goals:gol)
      %+  murn  ~(tap by goals.pool)
      |=  [=gid:gol =goal:gol]
      ?:  (~(has in progeny) gid)
        ~
      [~ gid goal]
    ==
    ::
      %delete-content
    this(contents.archive.pool (~(del by contents.archive.pool) gid.ven))
    ::
      %restore-content
    :: restores content to root
    ::
    =+  (~(got by contents.archive.pool) gid.ven)
    =.  goals.pool  (~(uni by goals.pool) (validate-goals:vd goals))
    this(contents.archive.pool (~(del by contents.archive.pool) gid.ven))
    ::
      %add-to-context
    =/  old-list=(list gid:gol)  (~(gut by contexts.archive.pool) context.ven ~)
    =/  new-list=(list gid:gol)  [gid.ven old-list]
    %=    this
        contexts.archive.pool
      (~(put by contexts.archive.pool) context.ven new-list)
    ==
    ::
      %del-from-context
    =/  old-list=(list gid:gol)  (~(got by contexts.archive.pool) context.ven)
    =/  new-list=(list gid:gol)  (purge-from-list gid.ven old-list)
    %=    this
        contexts.archive.pool
      (~(put by contexts.archive.pool) context.ven new-list)
    ==
    ::
      %reorder-archive
    =/  old-list=(list gid:gol)  (~(got by contexts.archive.pool) context.ven)
    ?>  =((sy archive.ven) (sy old-list))
    %=    this
        contexts.archive.pool
      (~(put by contexts.archive.pool) [context archive]:ven)
    ==
    ::
      %delete-context
    :: when a context is deleted from main goals
    ::
    %=    this
        contexts.archive.pool
      (~(del by contexts.archive.pool) [~ context.ven])
    ==
    ::
      %remove-context
    :: when a context is deleted from main goals
    ::
    =/  [* =goals:gol]  (~(got by contents.archive.pool) gid.ven)
    %=  this
        contents.archive.pool
      %+  ~(put by contents.archive.pool)
        gid.ven
      [~ goals]
    ==
    ::
      %set-actionable
    =/  goal  (~(got by goals.pool) gid.ven)
    ?-    val.ven
      %|  this(goals.pool (~(put by goals.pool) gid.ven goal(actionable %|)))
      ::
        %&
      ?^  children.goal  ~|("has-children" !!)
      this(goals.pool (~(put by goals.pool) gid.ven goal(actionable %&)))
    ==
    ::
      %mark-done
    =/  goal  (~(got by goals.pool) gid.nid.ven)
    ?:  (left-undone:tv nid.ven)  ~&  %left-undone  ~|("left-undone" !!)
    =.  goal
      ?-    -.nid.ven
          %s
        ?:  done.i.status.start.goal
          ~&(>> "already-done" goal)
        ?:  (lth now.ven timestamp.i.status.start.goal)
          ~&(>>> "bad-time" goal)
        goal(status.start [[now.ven %&] status.start.goal])
        ::
          %e
        ?:  done.i.status.end.goal
          ~&(>> "already-done" goal)
        ?:  (lth now.ven timestamp.i.status.end.goal)
          ~&(>>> "bad-time" goal)
        goal(status.end [[now.ven %&] status.end.goal])
      ==
    this(goals.pool (~(put by goals.pool) gid.nid.ven goal))
    ::
      %mark-undone
    =/  goal  (~(got by goals.pool) gid.nid.ven)
    ?:  (right-done:tv nid.ven)  ~|("right-done" !!)
    =.  goal
      ?-    -.nid.ven
          %s
        ?.  done.i.status.start.goal
          ~&(>> "already-undone" goal)
        ?:  (lth now.ven timestamp.i.status.start.goal)
          ~&(>>> "bad-time" goal)
        goal(status.start [[now.ven %|] status.start.goal])
        ::
          %e
        ?.  done.i.status.end.goal
          ~&(>> "already-undone" goal)
        ?:  (lth now.ven timestamp.i.status.end.goal)
          ~&(>>> "bad-time" goal)
        goal(status.end [[now.ven %|] status.end.goal])
      ==
    this(goals.pool (~(put by goals.pool) gid.nid.ven goal))
    ::
      %set-summary
    ?.  (lte (met 3 summary.ven) 140)
      ~|("Summary exceeds 140 characters." !!)
    =/  =goal:gol  (~(got by goals.pool) gid.ven)
    this(goals.pool (~(put by goals.pool) gid.ven goal(summary summary.ven)))
    ::
      %set-pool-title
    ?.  (lte (met 3 title.ven) 140)
      ~|("Title exceeds 140 characters." !!)
    this(title.pool title.ven)
    ::
      %set-start
    ?:  (bounded [%s gid.ven] start.ven %l)  ~|("bound-left" !!)
    ?:  (bounded [%s gid.ven] start.ven %r)  ~|("bound-ryte" !!)
    =/  goal  (~(got by goals.pool) gid.ven)
    this(goals.pool (~(put by goals.pool) gid.ven goal(moment.start start.ven)))
    ::
      %set-end
    ?:  (bounded [%e gid.ven] end.ven %l)  ~|("bound-left" !!)
    ?:  (bounded [%e gid.ven] end.ven %r)  ~|("bound-ryte" !!)
    =/  goal  (~(got by goals.pool) gid.ven)
    this(goals.pool (~(put by goals.pool) gid.ven goal(moment.end end.ven)))
    ::
      %set-pool-role
    ?~  role.ven
      this(perms.pool (~(del by perms.pool) ship.ven))
    ?<  ?=(%host u.role.ven)
    this(perms.pool (~(put by perms.pool) [ship u.role]:ven))
    ::
      %set-chief
    ?.  (check-in-pool chief.ven)
      ~|("chief not in pool" !!)
    =/  =goal:gol  (~(got by goals.pool) gid.ven)
    this(goals.pool (~(put by goals.pool) gid.ven goal(chief chief.ven)))
    ::
      %set-open-to
    =/  =goal:gol  (~(got by goals.pool) gid.ven)
    this(goals.pool (~(put by goals.pool) gid.ven goal(open-to open-to.ven)))
    ::
      %update-deputies
    =/  =goal:gol  (~(got by goals.pool) gid.ven)
    =.  deputies.goal
      ?-    -.p.ven
        %|  (~(del by deputies.goal) p.p.ven)
        ::
          %&
        ?.  (check-in-pool ship.p.p.ven)
          ~|("{<ship>} not in pool" !!)
        (~(put by deputies.goal) p.p.ven)
      ==
    this(goals.pool (~(put by goals.pool) gid.ven goal))
    ::
      %update-goal-metadata
    =/  =goal:gol  (~(got by goals.pool) gid.ven)
    =.  metadata.goal
      ?-  -.p.ven
        %&  (~(put by metadata.goal) p.p.ven)
        %|  (~(del by metadata.goal) p.p.ven)
      ==
    this(goals.pool (~(put by goals.pool) gid.ven goal))
    ::
      %update-pool-metadata
    %=    this
        metadata.pool
      ?-  -.p.ven
        %&  (~(put by metadata.pool) p.p.ven)
        %|  (~(del by metadata.pool) p.p.ven)
      ==
    ==
    ::
      %update-pool-metadata-field
    =/  properties  (~(gut by metadata-properties.pool) field.ven ~)
    =.  properties
      ?-  -.p.ven
        %&  (~(put by properties) p.p.ven)
        %|  (~(del by properties) p.p.ven)
      ==
    %=    this
        metadata-properties.pool
      (~(put by metadata-properties.pool) field.ven properties)
    ==
      ::
      %delete-pool-metadata-field
    this(metadata-properties.pool (~(del by metadata-properties.pool) field.ven))
  ==
::
++  handle-pool-transition
  |=  [mod=ship tan=pool-transition:act]
  ^-  _this
  ?+    -.tan  !!
      %init-pool
    ?>  =(mod host.pid.pool)
    this(pool pool.tan)
    ::
      %dag-yoke
    ?>  (check-dag-yoke-perm bef.tan aft.tan mod)
    (handle-pool-event tan)
    ::
      %dag-rend
    ?>  (check-dag-rend-perm bef.tan aft.tan mod)
    (handle-pool-event tan)
    ::
      %break-bonds
    =/  edges=(list edge:gol)  (get-bonds:nd [gid gids]:tan)
    |-
    ?~  edges
      this
    %=  $
      edges  t.edges
      this   (handle-pool-transition mod %dag-rend i.edges)
    ==
    ::
      %partition
    =/  complement=(set gid:gol)  (~(dif in ~(key by goals.pool)) part.tan)
    =/  part-list=(list gid:gol)  ~(tap in part.tan)
    |-
    ?~  part-list
      this
    %=  $
      part-list  t.part-list
      this       (handle-pool-transition mod %break-bonds i.part-list complement)
    ==
    ::
      %yoke
    =,  yok.tan
    ?-  -.yok.tan
      %prio-yoke  (handle-pool-transition mod %dag-yoke [%s lid] [%s rid])
      %prio-rend  (handle-pool-transition mod %dag-rend [%s lid] [%s rid])
      %prec-yoke  (handle-pool-transition mod %dag-yoke [%e lid] [%s rid])
      %prec-rend  (handle-pool-transition mod %dag-rend [%e lid] [%s rid])
      %nest-yoke  (handle-pool-transition mod %dag-yoke [%e lid] [%e rid])
      %nest-rend  (handle-pool-transition mod %dag-rend [%e lid] [%e rid])
      %hook-yoke  (handle-pool-transition mod %dag-yoke [%s lid] [%e rid])
      %hook-rend  (handle-pool-transition mod %dag-rend [%s lid] [%e rid])
        %held-yoke
      =.  this  (handle-pool-transition mod %dag-yoke [%e lid] [%e rid])
      (handle-pool-transition mod %dag-yoke [%s rid] [%s lid])
        %held-rend
      =/  this  (handle-pool-transition mod %dag-rend [%e lid] [%e rid])
      (handle-pool-transition mod %dag-rend [%s rid] [%s lid])
    ==
    ::
      %move-to-root
    :: TODO: delegate transformations to events
    ?.  (check-move-to-root-perm gid.tan mod)
      ~|("missing-move-to-root-perms" !!)
    =/  k  (~(got by goals.pool) gid.tan)
    ?~  parent.k
      this(roots.pool [gid.tan (purge-from-list gid.tan roots.pool)])
    =/  q  (~(got by goals.pool) u.parent.k)
    ?>  (~(has in (sy children.q)) gid.tan)
    =.  goals.pool  (~(put by goals.pool) gid.tan k(parent ~))
    =.  goals.pool  (~(put by goals.pool) u.parent.k q(children (purge-from-list gid.tan children.q)))
    =.  roots.pool  [gid.tan roots.pool]
    (handle-pool-transition mod %yoke %held-rend gid.tan u.parent.k)
    ::
      %move-to-goal
    :: TODO: delegate transformations to events
    ?.  (check-move-to-goal-perm kid.tan dad.tan mod)
      ~|("missing-move-to-goal-perms" !!)
    :: divine intervention to move goal to root
    ::
    =.  this  (handle-pool-transition host.pid.pool %move-to-root kid.tan)
    =/  k  (~(got by goals.pool) kid.tan)
    =/  q  (~(got by goals.pool) dad.tan)
    ?<  (~(has in (sy children.q)) kid.tan)
    =?  this  actionable.q
      (handle-pool-transition mod %set-actionable dad.tan %|)
    =.  goals.pool  (~(put by goals.pool) kid.tan k(parent (some dad.tan)))
    =.  goals.pool  (~(put by goals.pool) dad.tan q(children [kid.tan children.q]))
    =.  roots.pool  (purge-from-list kid.tan roots.pool)
    (handle-pool-transition mod %yoke %held-yoke kid.tan dad.tan)
    ::
      %move
    ?~  upid.tan
      (handle-pool-transition mod %move-to-root cid.tan)
    (handle-pool-transition mod %move-to-goal [cid u.upid]:tan)
    ::
      $?  %reorder-roots
          %set-pool-title
          %update-pool-metadata
          %update-pool-metadata-field
          %delete-pool-metadata-field
      ==
    ?>  (check-pool-edit-perm mod)
    (handle-pool-event tan)
    ::
      $?  %reorder-children
          %set-actionable
          %set-summary
          %set-start
          %set-end
          %update-goal-metadata
      ==
    ?>  (check-goal-edit-perm gid.tan mod)
    (handle-pool-event tan)
    ::
      ?(%mark-done %mark-undone)
    ?>  (check-goal-edit-perm gid.nid.tan mod)
    (handle-pool-event tan)
    ::
      %reorder-archive
    ?>  ?~  context.tan
          (check-pool-edit-perm mod)
        (check-goal-edit-perm u.context.tan mod)
    (handle-pool-event tan)
    ::
      $?  %set-open-to
          %update-deputies
      ==
    ?.  (check-goal-super gid.tan mod)
      ~|("missing super perms" !!)
    (handle-pool-event tan)
    ::
      %set-pool-role
    ::   TODO:
    ::   If we remove a ship as a viewer, we must remove it from all goal
    ::   create sets. We must also remove it from all goal chiefs and replace
    ::   the chief with its nearest non-deleted ancestor chief or the pool
    ::   host when no ancestor is available.
    ::
    ?>  (check-pool-role-mod ship.tan mod)
    (handle-pool-event tan)
    ::
      %set-chief
    ?.  (check-goal-chief-mod-perm gid.tan mod)
      ~|("missing goal perms" !!)
    =.  this  (handle-pool-event %set-chief [gid chief]:tan)
    ?.  rec.tan
      this
    =/  children=(list gid:gol)  children:(~(got by goals.pool) gid.tan)
    |-
    ?~  children
      this
    =.  this  (handle-pool-transition mod tan(gid i.children))
    $(children t.children)
  ==
--
