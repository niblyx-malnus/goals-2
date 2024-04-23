/-  gol=goals, act=action
/+  goals-node, goals-traverse, vd=goals-validate
::
=|  tans=(list pool-transition:act)
|_  =pool:gol
+*  this  .
    tv    ~(. goals-traverse goals.pool)
    nd    ~(. goals-node goals.pool)
++  abet  [(flop tans) pool]
++  teba  [tans pool] :: unflopped effects
++  apex  |=(=pool:gol this(pool pool, tans ~))
++  emit  |=(tan=pool-transition:act this(tans [tan tans]))
++  emil  |=(tanz=(list pool-transition:act) this(tans (weld tanz tans)))
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
::
++  check-root-chief
  |=  [=gid:gol mod=ship]
  =/  =goal:gol  (~(got by goals.pool) gid)
  ?~  parent.goal
    =(mod chief.goal)
  (check-root-chief u.parent.goal mod)
:: host, admin, or chief of root ancestor
:: goal master can edit and re-assign the goal
:: and move it anywhere they can create a goal
::
++  check-goal-master
  |=  [=gid:gol mod=ship]
  ^-  ?
  ?|  (check-pool-edit-perm mod)
      (check-root-chief gid mod)
  ==
:: can edit pool (host or admin)
:: or is chief on this goal or its ancestors
:: or is a deputy with edit permissions on this goal or its ancestors
::
++  check-goal-edit-perm
  |=  [=gid:gol mod=ship]
  ^-  ?
  ?|  (check-pool-edit-perm mod)
      |-
      =/  =goal:gol  (~(got by goals.pool) gid)
      ?|  =(mod chief.goal)
          ?=([~ %edit] (~(get by deputies.goal) mod))
          ?~(parent.goal %.n $(gid u.parent.goal))
      ==
  ==
:: can edit pool (host or admin)
:: or can edit this goal's parent
:: or is chief of this goal
::
++  check-goal-super
  |=  [=gid:gol mod=ship]
  ^-  ?
  =/  =goal:gol  (~(got by goals.pool) gid)
  ?|  ?~  parent.goal
        (check-pool-edit-perm mod)
      (check-goal-edit-perm u.parent.goal mod)
      =(mod chief.goal)
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
++  get-lineage
  |=  =gid:gol
  ^-  (list gid:gol)
  :-  gid
  =/  =goal:gol  (~(got by goals.pool) gid)
  ?~  parent.goal
    ~
  $(gid u.parent.goal)
::
++  nearest-common-ancestor
  |=  [a=gid:gol b=gid:gol]
  ^-  (unit gid:gol)
  =/  a-line=(list gid:gol)  (flop (get-lineage a))
  =/  b-line=(list gid:gol)  (flop (get-lineage b))
  =|  anc=(unit gid:gol)
  |-
  ?~  a-line
    anc
  ?~  b-line
    anc
  ?.  =(i.a-line i.b-line)
    anc
  %=  $
    anc     [~ i.a-line]
    a-line  t.a-line
    b-line  t.b-line
  ==
:: checks if mod can move kid under pid
::
++  check-move-to-goal-perm
  |=  [kid=gid:gol dad=gid:gol mod=ship]
  ^-  ?
  ?|  (check-pool-edit-perm mod)
      :: if master of kid and create permissions on dad
      ::
      ?&  (check-goal-master kid mod)
          (check-goal-create-perm dad mod)
      ==
      :: permissions on a goal which contains both goals
      ::
      ?~  nec=(nearest-common-ancestor kid dad)
        %.n
      (check-goal-edit-perm u.nec mod)
  ==
::
++  check-restore-to-root-perm
  |=  [=gid:gol mod=ship]
  ^-  ?
  =/  [context=(unit gid:gol) =goals:gol]
    (~(got by contents.archive.pool) gid)
  ::
  =/  =goal:gol  (~(got by goals) gid)
  ?|  (check-pool-edit-perm mod) :: only admins can force to root
      &(?=(~ context) =(mod chief.goal))
      &(?=(~ context) ?=([~ %edit] (~(get by deputies.goal) mod)))
  ==
::
++  check-restore-to-context-perm
  |=  [=gid:gol mod=ship]
  ^-  ?
  =/  [context=(unit gid:gol) =goals:gol]
    (~(got by contents.archive.pool) gid)
  =/  =goal:gol  (~(got by goals) gid)
  ?~  context
    ?|  (check-pool-edit-perm mod)
        =(mod chief.goal)
        ?=([~ %edit] (~(get by deputies.goal) mod))
    ==
  ?&  (~(has by goals.pool) u.context) :: context must be live
      ?|  (check-goal-edit-perm u.context mod)
          =(mod chief.goal)
          ?=([~ %edit] (~(get by deputies.goal) mod))
      ==
  ==
:: checks if mod can modify ship's pool permissions
::
++  check-pool-role-mod
  |=  [member=ship mod=ship]
  ^-  ?
  ?:  =(member host.pid.pool)
    ~&  >>>  "Cannot change host perms."
    %.n
  ?.  (check-pool-edit-perm mod)
    ~&  >>>  "Do not have host or admin perms."
    %.n
  ?.  =([~ %admin] (~(get by perms.pool) member))
    ~&  >  "Allowed to modify perms of non-admin."
    %.y
  ?:  |(=(mod host.pid.pool) =(mod member))
    ~&  >  "Allowed to modify admin as self or host."
    %.y
  ~&  >>>  "Must be host or self to modify admin perms."
  %.n
::
++  check-open-to
  |=  [=gid:gol mod=ship]
  ^-  ?
  =/  =goal:gol  (~(got by goals.pool) gid)
  ?+    open-to.goal  %.n
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
++  handle-transition
  |=  tan=pool-transition:act
  ^-  _this
  =.  this  (emit tan)
  ?-    -.tan
    %init-pool  this(pool pool.tan)
    ::
      %init-goal
    ?>  =(gid.tan gid.goal.tan)
    ?>  (~(has in outflow.start.goal.tan) [%e gid.tan])
    ?>  (~(has in inflow.end.goal.tan) [%s gid.tan])
    ?>  ?=(^ status.start.goal.tan)
    ?>  ?=(^ status.end.goal.tan)
    ?.  (lte (met 3 summary.goal.tan) 140)
      ~|("Summary exceeds 140 characters." !!)
    this(goals.pool (~(put by goals.pool) [gid goal]:tan))
    ::
      %dag-yoke
    :: Cannot put end before start
    ::
    ?:  &(?=(%e -.bef.tan) ?=(%s -.aft.tan) =(gid.bef.tan gid.aft.tan))
      ~|("inverting-goal-start-end" !!)
    :: Cannot create left-undone-right-done relationship
    ::
    ?:  ?&  !done.i.status:(got-node:nd bef.tan)
            done.i.status:(got-node:nd aft.tan)
        ==
      ~|("left-undone-right-done" !!)
    :: aft.tan must not come before bef.tan
    ::
    ?:  (check-path:tv aft.tan bef.tan %r)  ~|("already-ordered" !!)
    ::
    =/  bef-node=node:gol  (got-node:nd bef.tan)
    =/  aft-node=node:gol  (got-node:nd aft.tan)
    :: there must be no bound mismatch between bef.tan and aft.tan
    ::
    =/  lb  ?~(moment.bef-node (left-bound:tv bef.tan) moment.bef-node)
    =/  rb  ?~(moment.aft-node (ryte-bound:tv aft.tan) moment.aft-node)
    ?:  ?~(lb %| ?~(rb %| (gth u.lb u.rb)))  ~|("bound-mismatch" !!)
    :: dag-yoke
    ::
    =.  outflow.bef-node  (~(put in outflow.bef-node) aft.tan)
    =.  inflow.aft-node   (~(put in inflow.aft-node) bef.tan)
    =.  goals.pool        (update-node:nd bef.tan bef-node)
    =.  goals.pool        (update-node:nd aft.tan aft-node)
    this
    ::
      %dag-rend
    :: Cannot unrelate goal from itself
    ::
    ?:  =(gid.bef.tan gid.aft.tan)  ~|("same-goal" !!)
    :: Cannot destroy containment of an owned goal
    ::
    =/  l  (~(got by goals.pool) gid.bef.tan)
    =/  r  (~(got by goals.pool) gid.aft.tan)
    ?:  ?|  &(=(-.bef.tan %e) =(-.aft.tan %e) (~(has in (sy children.r)) gid.bef.tan))
            &(=(-.bef.tan %s) =(-.aft.tan %s) (~(has in (sy children.l)) gid.aft.tan))
        ==
      ~|("owned-goal" !!)
    :: dag-rend
    ::
    =/  bef-node=node:gol  (got-node:nd bef.tan)
    =/  aft-node=node:gol  (got-node:nd aft.tan)
    =.  outflow.bef-node  (~(del in outflow.bef-node) aft.tan)
    =.  inflow.aft-node   (~(del in inflow.aft-node) bef.tan)
    =.  goals.pool        (update-node:nd bef.tan bef-node)
    =.  goals.pool        (update-node:nd aft.tan aft-node)
    this
    ::
      %add-root
    this(roots.pool [gid.tan roots.pool])
    ::
      %del-root
    this(roots.pool (purge-from-list gid.tan roots.pool))
    ::
      %reorder-roots
    ?>  =((sy roots.tan) (sy roots.pool))
    this(roots.pool roots.tan)
    ::
      %add-child
    =/  =goal:gol  (~(got by goals.pool) dad.tan)
    ?:  actionable.goal  ~|("actionable-goal-cannot-have-child" !!)
    =.  children.goal  [kid.tan children.goal]
    this(goals.pool (~(put by goals.pool) dad.tan goal))
    ::
      %del-child
    =/  =goal:gol  (~(got by goals.pool) dad.tan)
    =.  children.goal  (purge-from-list kid.tan children.goal)
    this(goals.pool (~(put by goals.pool) dad.tan goal))
::
      %reorder-children
    =/  =goal:gol  (~(got by goals.pool) gid.tan)
    ?>  =((sy children.tan) (sy children.goal))
    %=    this
        goals.pool
      %+  ~(put by goals.pool)
        gid.tan
      goal(children children.tan)
    ==
    ::
      %update-parent
    ?:  ?~(dad.tan %| actionable:(~(got by goals.pool) u.dad.tan))
      ~|("actionable-goal-cannot-have-child" !!)
    =/  =goal:gol  (~(got by goals.pool) kid.tan)
    this(goals.pool (~(put by goals.pool) kid.tan goal(parent dad.tan)))
    ::
      %archive-root-tree
    ?>  (~(has in (sy roots.pool)) gid.tan)
    :: Get subgoals of goal including self
    ::
    =/  progeny=(set gid:gol)  (progeny:tv gid.tan)
    =/  root-tree=goals:gol
      %-  ~(gas by *goals:gol)
      %+  turn  ~(tap in progeny)
      |=  =gid:gol
      [gid (~(got by goals.pool) gid)]
    ::
    %=    this
        contents.archive.pool
      %+  ~(put by contents.archive.pool)
        gid.tan
      [context.tan root-tree]
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
    this(contents.archive.pool (~(del by contents.archive.pool) gid.tan))
    ::
      %restore-content
    :: restores content to root
    ::
    =+  (~(got by contents.archive.pool) gid.tan)
    =.  goals.pool  (~(uni by goals.pool) (validate-goals:vd goals))
    this(contents.archive.pool (~(del by contents.archive.pool) gid.tan))
    ::
      %add-to-context
    =/  old-list=(list gid:gol)  (~(gut by contexts.archive.pool) context.tan ~)
    =/  new-list=(list gid:gol)  [gid.tan old-list]
    %=    this
        contexts.archive.pool
      (~(put by contexts.archive.pool) context.tan new-list)
    ==
    ::
      %del-from-context
    =/  old-list=(list gid:gol)  (~(got by contexts.archive.pool) context.tan)
    =/  new-list=(list gid:gol)  (purge-from-list gid.tan old-list)
    %=    this
        contexts.archive.pool
      (~(put by contexts.archive.pool) context.tan new-list)
    ==
    ::
      %reorder-archive
    =/  old-list=(list gid:gol)  (~(got by contexts.archive.pool) context.tan)
    ?>  =((sy archive.tan) (sy old-list))
    %=    this
        contexts.archive.pool
      (~(put by contexts.archive.pool) [context archive]:tan)
    ==
    ::
      %delete-context
    %=    this
        contexts.archive.pool
      (~(del by contexts.archive.pool) [~ context.tan])
    ==
    ::
      %set-actionable
    =/  goal  (~(got by goals.pool) gid.tan)
    ?-    val.tan
      %|  this(goals.pool (~(put by goals.pool) gid.tan goal(actionable %|)))
      ::
        %&
      ?^  children.goal  ~|("has-children" !!)
      this(goals.pool (~(put by goals.pool) gid.tan goal(actionable %&)))
    ==
    ::
      %mark-done
    =/  goal  (~(got by goals.pool) gid.nid.tan)
    ?:  (left-undone:tv nid.tan)  ~&  %left-undone  ~|("left-undone" !!)
    =.  goal
      ?-    -.nid.tan
          %s
        ?:  done.i.status.start.goal
          ~&(>> "already-done" goal)
        ?:  (lth now.tan timestamp.i.status.start.goal)
          ~&(>>> "bad-time" goal)
        goal(status.start [[now.tan %&] status.start.goal])
        ::
          %e
        ?:  done.i.status.end.goal
          ~&(>> "already-done" goal)
        ?:  (lth now.tan timestamp.i.status.end.goal)
          ~&(>>> "bad-time" goal)
        goal(status.end [[now.tan %&] status.end.goal])
      ==
    this(goals.pool (~(put by goals.pool) gid.nid.tan goal))
    ::
      %mark-undone
    =/  goal  (~(got by goals.pool) gid.nid.tan)
    ?:  (right-done:tv nid.tan)  ~|("right-done" !!)
    =.  goal
      ?-    -.nid.tan
          %s
        ?.  done.i.status.start.goal
          ~&(>> "already-undone" goal)
        ?:  (lth now.tan timestamp.i.status.start.goal)
          ~&(>>> "bad-time" goal)
        goal(status.start [[now.tan %|] status.start.goal])
        ::
          %e
        ?.  done.i.status.end.goal
          ~&(>> "already-undone" goal)
        ?:  (lth now.tan timestamp.i.status.end.goal)
          ~&(>>> "bad-time" goal)
        goal(status.end [[now.tan %|] status.end.goal])
      ==
    this(goals.pool (~(put by goals.pool) gid.nid.tan goal))
    ::
      %set-summary
    ?.  (lte (met 3 summary.tan) 140)
      ~|("Summary exceeds 140 characters." !!)
    =/  =goal:gol  (~(got by goals.pool) gid.tan)
    this(goals.pool (~(put by goals.pool) gid.tan goal(summary summary.tan)))
    ::
      %set-pool-title
    ?.  (lte (met 3 title.tan) 140)
      ~|("Title exceeds 140 characters." !!)
    this(title.pool title.tan)
    ::
      %set-start
    ?:  (bounded [%s gid.tan] start.tan %l)  ~|("bound-left" !!)
    ?:  (bounded [%s gid.tan] start.tan %r)  ~|("bound-ryte" !!)
    =/  goal  (~(got by goals.pool) gid.tan)
    this(goals.pool (~(put by goals.pool) gid.tan goal(moment.start start.tan)))
    ::
      %set-end
    ?:  (bounded [%e gid.tan] end.tan %l)  ~|("bound-left" !!)
    ?:  (bounded [%e gid.tan] end.tan %r)  ~|("bound-ryte" !!)
    =/  goal  (~(got by goals.pool) gid.tan)
    this(goals.pool (~(put by goals.pool) gid.tan goal(moment.end end.tan)))
    ::
      %set-pool-role
    ?~  role.tan
      this(perms.pool (~(del by perms.pool) ship.tan))
    ?<  ?=(%host u.role.tan)
    this(perms.pool (~(put by perms.pool) [ship u.role]:tan))
    ::
      %set-chief
    ?.  (~(has by perms.pool) chief.tan)
      ~|("chief not in pool" !!)
    =/  =goal:gol  (~(got by goals.pool) gid.tan)
    this(goals.pool (~(put by goals.pool) gid.tan goal(chief chief.tan)))
    ::
      %set-open-to
    =/  =goal:gol  (~(got by goals.pool) gid.tan)
    this(goals.pool (~(put by goals.pool) gid.tan goal(open-to open-to.tan)))
    ::
      %update-deputies
    =/  =goal:gol  (~(got by goals.pool) gid.tan)
    =.  deputies.goal
      ?-    -.p.tan
        %|  (~(del by deputies.goal) p.p.tan)
        ::
          %&
        ?.  (~(has by perms.pool) ship.p.p.tan)
          ~|("{<ship>} not in pool" !!)
        (~(put by deputies.goal) p.p.tan)
      ==
    this(goals.pool (~(put by goals.pool) gid.tan goal))
    ::
      %update-goal-metadata
    =/  =goal:gol  (~(got by goals.pool) gid.tan)
    =.  metadata.goal
      ?-  -.p.tan
        %&  (~(put by metadata.goal) p.p.tan)
        %|  (~(del by metadata.goal) p.p.tan)
      ==
    this(goals.pool (~(put by goals.pool) gid.tan goal))
    ::
      %update-pool-metadata
    %=    this
        metadata.pool
      ?-  -.p.tan
        %&  (~(put by metadata.pool) p.p.tan)
        %|  (~(del by metadata.pool) p.p.tan)
      ==
    ==
    ::
      %update-pool-metadata-field
    =/  properties  (~(gut by metadata-properties.pool) field.tan ~)
    =.  properties
      ?-  -.p.tan
        %&  (~(put by properties) p.p.tan)
        %|  (~(del by properties) p.p.tan)
      ==
    %=    this
        metadata-properties.pool
      (~(put by metadata-properties.pool) field.tan properties)
    ==
      ::
      %delete-pool-metadata-field
    this(metadata-properties.pool (~(del by metadata-properties.pool) field.tan))
  ==
::
++  handle-compound-transition
  |=  [mod=ship tan=compound-pool-transition:act]
  ^-  _this
  ?-    -.tan
      %dag-yoke
    ?>  (check-dag-yoke-perm bef.tan aft.tan mod)
    (handle-transition tan)
    ::
      %dag-rend
    ?>  (check-dag-rend-perm bef.tan aft.tan mod)
    (handle-transition tan)
    ::
      %break-bonds
    =/  edges=(list edge:gol)  (get-bonds:nd [gid gids]:tan)
    |-
    ?~  edges
      this
    %=  $
      edges  t.edges
      this   (handle-compound-transition mod %dag-rend i.edges)
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
      this       (handle-compound-transition mod %break-bonds i.part-list complement)
    ==
    ::
      %yoke
    =,  yok.tan
    ?-  -.yok.tan
      %prio-yoke  (handle-compound-transition mod %dag-yoke [%s lid] [%s rid])
      %prio-rend  (handle-compound-transition mod %dag-rend [%s lid] [%s rid])
      %prec-yoke  (handle-compound-transition mod %dag-yoke [%e lid] [%s rid])
      %prec-rend  (handle-compound-transition mod %dag-rend [%e lid] [%s rid])
      %nest-yoke  (handle-compound-transition mod %dag-yoke [%e lid] [%e rid])
      %nest-rend  (handle-compound-transition mod %dag-rend [%e lid] [%e rid])
      %hook-yoke  (handle-compound-transition mod %dag-yoke [%s lid] [%e rid])
      %hook-rend  (handle-compound-transition mod %dag-rend [%s lid] [%e rid])
        %held-yoke
      =.  this  (handle-compound-transition mod %dag-yoke [%e lid] [%e rid])
      (handle-compound-transition mod %dag-yoke [%s rid] [%s lid])
        %held-rend
      =/  this  (handle-compound-transition mod %dag-rend [%e lid] [%e rid])
      (handle-compound-transition mod %dag-rend [%s rid] [%s lid])
    ==
    ::
      %nuke
    =;  yokes=(list exposed-yoke:act)
      |-
      ?~  yokes
        this
      %=  $
        yokes  t.yokes
        this   (handle-compound-transition mod %yoke i.yokes)
      ==
    |^
    ?-    -.nuke.tan
      %nuke-prio-left  prio-left
      %nuke-prio-ryte  prio-ryte
      %nuke-prio       (weld prio-left prio-ryte)
      %nuke-prec-left  prec-left
      %nuke-prec-ryte  prec-ryte
      %nuke-prec       (weld prec-left prec-ryte)
      %nuke-prio-prec  :(weld prio-left prio-ryte prec-left prec-ryte)
      %nuke-nest-left  nest-left
      %nuke-nest-ryte  nest-ryte
      %nuke-nest       (weld nest-left nest-ryte)
    ==
    ::
    ++  prio-left
      %+  turn
        ~(tap in (prio-left:nd gid.nuke.tan))
      |=  =gid:gol
      ^-  exposed-yoke:act
      [%prio-rend gid gid.nuke.tan]
    ::
    ++  prio-ryte
      %+  turn
        ~(tap in (prio-ryte:nd gid.nuke.tan))
      |=  =gid:gol
      ^-  exposed-yoke:act
      [%prio-rend gid.nuke.tan gid]
    ::
    ++  prec-left
      %+  turn
        ~(tap in (prec-left:nd gid.nuke.tan))
      |=  =gid:gol
      ^-  exposed-yoke:act
      [%prec-rend gid gid.nuke.tan]
    ::
    ++  prec-ryte
      %+  turn
        ~(tap in (prec-ryte:nd gid.nuke.tan))
      |=  =gid:gol
      ^-  exposed-yoke:act
      [%prec-rend gid.nuke.tan gid]
    ::
    ++  nest-left
      %+  turn
        ~(tap in (nest-left:nd gid.nuke.tan))
      |=  =gid:gol
      ^-  exposed-yoke:act
      [%nest-rend gid gid.nuke.tan]
    ::
    ++  nest-ryte
      %+  turn
        ~(tap in (nest-ryte:nd gid.nuke.tan))
      |=  =gid:gol
      ^-  exposed-yoke:act
      [%nest-rend gid.nuke.tan gid]
    --
    ::
      %move-to-root
    ?.  (check-move-to-root-perm gid.tan mod)
      ~|("missing-move-to-root-perms" !!)
    =/  kid-goal=goal:gol  (~(got by goals.pool) gid.tan)
    ?>  ?=(^ parent.kid-goal)
    =.  this  (handle-transition %update-parent gid.tan ~)
    =.  this  (handle-transition %del-child gid.tan u.parent.kid-goal)
    =.  this  (handle-transition %add-root gid.tan)
    (handle-compound-transition mod %yoke %held-rend gid.tan u.parent.kid-goal)
    ::
      %move-to-goal
    ?.  (check-move-to-goal-perm kid.tan dad.tan mod)
      ~|("missing-move-to-goal-perms" !!)
    =/  kid-goal=goal:gol  (~(got by goals.pool) kid.tan)
    =/  dad-goal=goal:gol  (~(got by goals.pool) dad.tan)
    ?<  =([~ dad.tan] parent.kid-goal)
    ?<  (~(has in (sy children.dad-goal)) kid.tan)
    :: divine intervention to move goal to root
    ::
    =?  this  ?=(^ parent.kid-goal)
      (handle-compound-transition host.pid.pool %move-to-root kid.tan)
    =?  this  actionable.dad-goal
      (handle-compound-transition mod %set-actionable dad.tan %|)
    =.  this  (handle-transition %update-parent kid.tan ~ dad.tan)
    =.  this  (handle-transition %add-child kid.tan dad.tan)
    =.  this  (handle-transition %del-root kid.tan)
    (handle-compound-transition mod %yoke %held-yoke kid.tan dad.tan)
    ::
      %move
    ?~  upid.tan
      (handle-compound-transition mod %move-to-root cid.tan)
    (handle-compound-transition mod %move-to-goal [cid u.upid]:tan)
    ::
      $?  %reorder-roots
          %set-pool-title
          %update-pool-metadata
          %update-pool-metadata-field
          %delete-pool-metadata-field
      ==
    ?>  (check-pool-edit-perm mod)
    (handle-transition tan)
    ::
      $?  %reorder-children
          %set-actionable
          %set-summary
          %set-start
          %set-end
          %update-goal-metadata
      ==
    ?>  (check-goal-edit-perm gid.tan mod)
    (handle-transition tan)
    ::
      ?(%mark-done %mark-undone)
    ?>  (check-goal-edit-perm gid.nid.tan mod)
    (handle-transition tan)
    ::
      %reorder-archive
    ?>  ?~  context.tan
          (check-pool-edit-perm mod)
        :: only works when the context itself is not archived
        (check-goal-edit-perm u.context.tan mod)
    (handle-transition tan)
    ::
      $?  %set-open-to
          %update-deputies
      ==
    ?.  (check-goal-super gid.tan mod)
      ~|("missing super perms" !!)
    (handle-transition tan)
    ::
      %set-pool-role
    ::   TODO:
    ::   If we remove a ship as a viewer, we must remove it from all goal
    ::   create sets. We must also remove it from all goal chiefs and replace
    ::   the chief with its nearest non-deleted ancestor chief or the pool
    ::   host when no ancestor is available.
    ::
    ?>  (check-pool-role-mod ship.tan mod)
    (handle-transition tan)
    ::
      %set-chief
    ?.  (check-goal-chief-mod-perm gid.tan mod)
      ~|("missing goal perms" !!)
    =.  this  (handle-transition %set-chief [gid chief]:tan)
    ?.  rec.tan
      this
    =/  children=(list gid:gol)  children:(~(got by goals.pool) gid.tan)
    |-
    ?~  children
      this
    =.  this  (handle-compound-transition mod tan(gid i.children))
    $(children t.children)
    ::
      %set-active
    ?-    val.tan
        %&
      :: automatically mark parent active if possible
      ::
      =/  parent=(unit gid:gol)
        parent:(~(got by goals.pool) gid.tan)
      =?  this  ?=(^ parent)
        (handle-compound-transition mod %set-active u.parent %& now.tan)
      ~&  %marking-active
      (handle-compound-transition mod %mark-done s+gid.tan now.tan)
      ::
        %|
      :: automatically unmark child active if possible
      ::
      =/  children=(list gid:gol)
        children:(~(got by goals.pool) gid.tan)
      =.  this
        |-
        ?~  children
          this
        (handle-compound-transition mod %set-active i.children %| now.tan)
      ~&  %unmarking-active
      (handle-compound-transition mod %mark-undone s+gid.tan now.tan)
    ==
    ::
      %set-complete
    ?-    val.tan
        %&
      =.  this  (handle-compound-transition mod %set-active gid.tan %& now.tan)
      ~&  %marking-complete
      =?  this  done.i.status.start:(~(got by goals.pool) gid.tan)
        (handle-compound-transition mod %mark-done s+gid.tan now.tan)
      =.  this
        (handle-compound-transition mod %mark-done e+gid.tan now.tan)
      :: automatically complete parent if all its children are complete
      ::
      =/  parent=(unit gid:gol)  parent:(~(got by goals.pool) gid.tan)
      ?~  parent  this
      ?.  %-  ~(all in (young:nd u.parent))
          |=(=gid:gol done.i.status:(got-node:nd e+gid.tan))
        this
      :: Set parent complete if possible
      ::
      =/  mul
        %-  mule  |.
        (handle-compound-transition mod %set-complete u.parent %& now.tan)
      ?-  -.mul
        %&  p.mul
        %|  ((slog p.mul) this)
      ==
      ::
        %|
      ~&  %unmarking-complete
      =.  this
        (handle-compound-transition mod %mark-undone e+gid.tan now.tan)
      :: Unmark start done if possible
      ::
      =/  mul
        %-  mule  |.
        (handle-compound-transition mod %mark-undone s+gid.tan now.tan)
      ?-  -.mul
        %&  p.mul
        %|  ((slog p.mul) this)
      ==
    ==
    ::
      %create-goal
    |^
    ?>  ?~   upid.tan
          (check-root-create-perm mod)
        (check-goal-create-perm u.upid.tan mod)
    =/  =goal:gol  (init-goal gid.tan summary.tan mod now.tan)
    =.  this  (handle-transition %init-goal gid.tan goal)
    =.  this  (handle-transition %add-root gid.tan)
    =?  this  ?=(^ upid.tan)
      %+  handle-compound-transition
        host.pid.pool :: divine intervention (host)
      [%move-to-goal gid.tan u.upid.tan]
    :: If you can set it active, do so
    ::
    =/  mul
      %-  mule  |.
      (handle-compound-transition mod %set-active gid.tan %& now.tan)
    ?-  -.mul
       %&  p.mul
       %|  ((slog p.mul) this)
    ==
    ::
    ++  init-goal
      |=  [=gid:gol summary=@t chief=ship now=@da]
      ^-  goal:gol
      =|  =goal:gol
      %=  goal
        gid       gid
        chief    chief
        summary  summary
        :: Initialize inflowing and outflowing nodes
        :: 
        outflow.start  (~(put in *(set nid:gol)) [%e gid])
        inflow.end     (~(put in *(set nid:gol)) [%s gid])
        status.start   [[now %|] ~]
        status.end     [[now %|] ~]
      ==
    --
    ::
      %archive-goal
    :: Move goal and subgoals from main goals to archive
    ::
    ?>  (check-goal-edit-perm gid.tan mod)
    =/  context=(unit gid:gol)  parent:(~(got by goals.pool) gid.tan)
    :: Move goal to root (divine intervention by host)
    ::
    =?  this  ?=(^ context)
      (handle-compound-transition host.pid.pool %move-to-root gid.tan)
    :: Partition subgoals of goal from rest of goals
    :: (Remove non-hierarchical DAG relationships)
    ::
    =.  this  (handle-compound-transition mod %partition (progeny:tv gid.tan))
    =.  this  (handle-transition %archive-root-tree gid.tan context)
    =.  this  (handle-transition %add-to-context context gid.tan)
    (handle-transition %del-root gid.tan)
    ::
      %restore-to-root
    :: Restore goal from archive to main goals
    ::
    ?>  (check-restore-to-root-perm gid.tan mod)
    =/  [context=(unit gid:gol) =goals:gol]
      (~(got by contents.archive.pool) gid.tan)
    =.  this  (handle-transition %restore-content gid.tan)
    =.  this  (handle-transition %del-from-context context gid.tan)
    (handle-transition %add-root gid.tan)
    ::
      %restore-goal
    ?>  (check-restore-to-context-perm gid.tan mod)
    :: Restore goal from archive to main goals
    ::
    =/  [context=(unit gid:gol) =goals:gol]
      (~(got by contents.archive.pool) gid.tan)
    :: divine intervention (host)
    ::
    =.  this  (handle-compound-transition host.pid.pool %restore-to-root gid.tan)
    ?~  context
      this
    (handle-compound-transition host.pid.pool %move-to-goal gid.tan u.context)
    ::
      %delete-from-archive
    :: Only admin level can perma-delete
    ::
    ?>  (check-pool-edit-perm mod)
    =/  [context=(unit gid:gol) =goals:gol]
      (~(got by contents.archive.pool) gid.tan)
    =.  this  (handle-transition %delete-content gid.tan)
    =.  this  (handle-transition %del-from-context context gid.tan)
    :: archive contents are recursively deleted
    ::
    =/  deleted=(list gid:gol)  ~(tap in ~(key by goals))
    |-
    ?~  deleted
      this
    =/  to-delete=(list gid:gol)
      (~(gut by contexts.archive.pool) [~ i.deleted] ~)
    |-
    ?~  to-delete
      =.  this  (handle-transition %delete-context i.deleted)
      ^$(deleted t.deleted)
    =.  this  (handle-compound-transition mod %delete-from-archive i.to-delete)
    $(to-delete t.to-delete)
    ::
      %delete-goal
    =.  this  (handle-compound-transition mod %archive-goal gid.tan)
    (handle-compound-transition mod %delete-from-archive gid.tan)
  ==
::
++  handle-transitions
  |=  tans=(list pool-transition:act)
  ^-  _this
  =.  tans  (flop tans) :: assumes tans in reverse chronological order
  |-
  ?~  tans
    this
  =.  this  (handle-transition i.tans)
  $(tans t.tans)
::
++  handle-compound-transition-safe
  |=  [mod=ship tan=compound-pool-transition:act]
  ^-  _this
  =/  old=pool:gol  pool
  =.  this  (handle-compound-transition mod tan)
  =/  new=pool:gol  pool:(handle-transitions:(apex old) tans)
  ?>  =(new pool)
  this
--
