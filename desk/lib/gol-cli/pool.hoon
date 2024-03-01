/-  gol=goals, act=action
/+  *gol-cli-util, gol-cli-node, gol-cli-traverse, vd=gol-cli-validate
|_  p=pool:gol
+*  this  .
    tv    ~(. gol-cli-traverse goals.p)
    nd    ~(. gol-cli-node goals.p)
++  abet  p
++  apex  |=(p=pool:gol this(p p))
::
:: ============================================================================
:: 
:: SPAWNING/CACHING/WASTING/TRASHING/RENEWING GOALS
::
:: ============================================================================
::
:: Initialize a goal with initial state
++  init-goal
  |=  [=gid:gol summary=@t chief=ship now=@da author=ship]
  ^-  goal:gol
  ?.  (lte (met 3 summary) 140)
    ~|("Summary exceeds 140 characters." !!)
  =|  =goal:gol
  =.  gid.goal       gid
  =.  chief.goal    chief
  =.  summary.goal  summary
  :: =.  author.goal  author
  :: 
  :: Initialize inflowing and outflowing nodes
  =.  outflow.start.goal  (~(put in *(set nid:gol)) [%e gid])
  =.  inflow.end.goal     (~(put in *(set nid:gol)) [%s gid])
  =.  status.start.goal   [[now %|] ~]
  =.  status.end.goal     [[now %|] ~]
  goal
::
++  create-goal
  |=  [=gid:gol upid=(unit gid:gol) summary=@t now=@da mod=ship]
  ^-  _this
  ~&  %creating-goal
  ?>  ?~  upid
        (check-root-create-perm mod)
      (check-goal-create-perm u.upid mod)
  =/  goal  (init-goal gid summary mod now mod)
  =.  goals.p  (~(put by goals.p) gid goal)
  (move gid upid host.pid.p) :: divine intervention (owner)
::
:: Extract goal from goals
++  wrest-goal
  |=  [=gid:gol mod=ship]
  ^-  [trac=goals:gol _this]
  :: Get subgoals of goal including self
  ::
  =/  prog  (progeny:tv gid)
  :: Move goal to root
  ::
  =/  pore  (move gid ~ host.pid.p) :: divine intervention (owner)
  :: Partition subgoals of goal from rest of goals
  ::
  =.  pore  (partition:pore prog mod)
  :: Get extracted goals
  ::
  =/  trac=goals:gol  (gat-by goals.p.pore ~(tap in prog))
  :: Update goals to remaining
  ::
  =.  goals.p.pore  (gus-by goals.p.pore ~(tap in prog))
  :: TODO: both of these should get validated here (validate-goals:vd goals)
  :: return extracted goals and remaining goals
  ::
  [trac pore]
::
++  set-summary
  |=  [=gid:gol summary=@t mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm gid mod)
  ?.  (lte (met 3 summary) 140)
    ~|("Summary exceeds 140 characters." !!)
  =/  =goal:gol  (~(got by goals.p) gid)
  this(goals.p (~(put by goals.p) gid goal(summary summary)))
::
++  set-pool-title
  |=  [title=@t mod=ship]
  ^-  _this
  ?>  (check-pool-edit-perm mod)
  ?.  (lte (met 3 title) 140)
    ~|("Title exceeds 140 characters." !!)
  this(title.p title)
::
:: Move goal and subgoals from main goals to archive
++  archive-goal
  |=  [=gid:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm gid mod)
  =/  context=(unit gid:gol)  parent:(~(got by goals.p) gid)
  =^  trac  this
    (wrest-goal gid mod) :: mod has the correct perms for this
  =/  old-list=(list gid:gol)  (~(gut by contexts.archive.p) context ~)
  =/  new-list=(list gid:gol)  [gid old-list]
  =.  contexts.archive.p  (~(put by contexts.archive.p) context new-list)
  =.  contents.archive.p  (~(put by contents.archive.p) gid [context trac])
  this
:: TODO: when a goal is deleted from goals or from contents.archive
::       update the contexts in the archive (or delete completely?)
::
:: Restore goal from archive to main goals
++  restore-goal
  |=  [=gid:gol mod=ship]
  ^-  _this
  =+  (~(got by contents.archive.p) gid)
  ?>  ?~  context
        (check-goal-master gid mod)
      (check-goal-edit-perm u.context mod)
  =.  goals.p  (~(uni by goals.p) (validate-goals:vd goals))
  =.  roots.p  [gid roots.p]
  =/  old-list=(list gid:gol)  (~(got by contexts.archive.p) context)
  =/  new-list=(list gid:gol)  (find-and-oust gid old-list)
  =.  contexts.archive.p  (~(put by contexts.archive.p) context new-list)
  =.  contents.archive.p  (~(del by contents.archive.p) gid)
  (move:this gid context mod)
::
:: Restore goal from archive to main goals at root
++  restore-to-root
  |=  [=gid:gol mod=ship]
  ^-  _this
  ?>  (check-goal-master gid mod)
  =+  (~(got by contents.archive.p) gid)
  =.  goals.p  (~(uni by goals.p) (validate-goals:vd goals))
  =/  old-list=(list gid:gol)  (~(got by contexts.archive.p) context)
  =/  new-list=(list gid:gol)  (find-and-oust gid old-list)
  =.  contexts.archive.p  (~(put by contexts.archive.p) context new-list)
  =.  contents.archive.p  (~(del by contents.archive.p) gid)
  this
::
++  delete-from-archive
  |=  [=gid:gol mod=ship]
  ^-  _this
  :: Only admin level can perma-delete
  ::
  ?>  (check-pool-edit-perm mod)
  =+  (~(got by contents.archive.p) gid)
  =/  old-list=(list gid:gol)  (~(got by contexts.archive.p) context)
  =/  new-list=(list gid:gol)  (find-and-oust gid old-list)
  =.  contexts.archive.p  (~(put by contexts.archive.p) context new-list)
  =.  contents.archive.p  (~(del by contents.archive.p) gid)
  this
::
:: Permanently delete goal and subgoals from archive
++  delete-goal
  |=  [=gid:gol mod=ship]
  ^-  _this
  :: Only admin level can perma-delete
  ::
  ?>  (check-pool-edit-perm mod)
  =^  trac  this
    (wrest-goal gid mod) :: correctly handles orders
  this
::
:: Partition the set of goals q from its complement q- in goals.p
++  partition
  |=  [q=(set gid:gol) mod=ship]
  ^-  _this
  ::
  :: get complement of q
  =/  q-  (~(dif in ~(key by goals.p)) q)
  ::
  :: iterate through and break bonds between each gid in q
  :: and all ids in q's complement
  =/  q  ~(tap in q)
  =/  pore  this
  |-
  ?~  q
    pore
  $(q t.q, pore (break-bonds:pore i.q q- mod))
::
:: Break bonds between a goal and a set of other goals
++  break-bonds
  |=  [=gid:gol exes=(set gid:gol) mod=ship]
  ^-  _this
  ::
  :: get the existing bonds between gid and its (future) exes
  =/  pairs  (get-bonds:nd gid exes)
  ::
  :: iterate through and rend each of these bonds
  =/  pore  this
  |-
  ?~  pairs
    pore
  %=  $
    pairs  t.pairs
    pore  (dag-rend:pore p.i.pairs q.i.pairs mod)
  ==
::
:: ============================================================================
:: 
:: PERMISSIONS UTILITIES
::
:: ============================================================================
:: owner or admin
::
++  check-pool-edit-perm
  |=  mod=ship
  ^-  ?
  ?|  =(mod host.pid.p)
      ?=([~ %admin] (~(got by perms.p) mod))
  ==
:: owner, admin or creator
::
++  check-root-create-perm
  |=  mod=ship
  ^-  ?
  ?|  =(mod host.pid.p)
      ?=([~ ?(%admin %creator)] (~(got by perms.p) mod))
  ==
:: can edit pool (owner or admin)
:: or is ranking member on goal
:: or is a deputy with edit permissions
::
++  check-goal-edit-perm
  |=  [=gid:gol mod=ship]
  ^-  ?
  ?|  (check-pool-edit-perm mod)
      ?=(^ (get-rank:tv mod gid))
      ?=([~ %edit] (~(get by deputies:(~(got by goals.p) gid)) mod))
  ==
:: can edit goal (owner, admin or ranking member on goal)
:: or is a deputy on the goal
::
++  check-goal-create-perm
  |=  [=gid:gol mod=ship]
  ^-  ?
  ?|  (check-goal-edit-perm gid mod)
      (~(has by deputies:(~(got by goals.p) gid)) mod)
  ==
:: most senior ancestor
::
++  stock-root
  |=  =gid:gol
  ^-  [=gid:gol chief=ship]
  (snag 0 (flop (get-stock:tv gid)))
:: owner, admin, or chief of stock-root
::
++  check-goal-master
  |=  [=gid:gol mod=ship]
  ^-  ?
  ?|  (check-pool-edit-perm mod)
      =(mod chief:(stock-root gid))
  ==
::
++  check-move-to-root-perm
  |=  [=gid:gol mod=ship]
  ^-  ?
  ?&  (check-goal-master gid mod)
      (check-root-create-perm mod)
  ==
:: checks if mod can move kid under pid
::
++  check-move-to-goal-perm
  |=  [kid=gid:gol pid=gid:gol mod=ship]
  ^-  ?
  ?|  (check-pool-edit-perm mod)
      :: permissions on a goal which contains both goals
      ::
      =/  krank  (get-rank:tv mod kid)
      =/  prank  (get-rank:tv mod pid)
      &(?=(^ krank) ?=(^ prank) =(krank prank))
      :: if chief of stock-root of kid and permissions on pid
      ::
      ?&  =(mod chief:(stock-root kid))
          (check-goal-edit-perm pid mod)
  ==  ==
:: checks if mod can modify ship's pool permissions
::
++  check-pool-role-mod
  |=  [=ship mod=ship]
  ^-  ?
  ?:  =(ship host.pid.p)
    ~|("Cannot change host.pid.perms." !!)
  ?.  (check-pool-edit-perm mod)
    ~|("Do not have owner or admin perms." !!)
  ?:  ?&  =((~(get by perms.p) ship) (some (some %admin)))
          !|(=(mod host.pid.p) =(mod ship))
      ==
    ~|("Must be owner or self to modify admin perms." !!)
  %&
::
++  check-in-pool  |=(=ship |(=(ship host.pid.p) (~(has by perms.p) ship)))
:: replace all chiefs of goals whose chiefs have been kicked
::
++  replace-chiefs
   |=  kick=(set ship)
   ^-  _this
   :: list of all ids of goals with replacable chiefs
   ::
   =/  kickable=(list gid:gol)
     %+  murn
       ~(tap by goals.p)
     |=  [=gid:gol =goal:gol]
     ?.  (~(has in kick) chief.goal)
       ~
     (some gid)
   :: accurate updated chief information
   ::
   =/  chiefs
     ((chain:tv gid:gol ship) (replace-chief:tv kick host.pid.p) kickable ~)
   :: update goals.p to reflect new chief information
   ::
  %=  this
    goals.p
      %-  ~(gas by goals.p)
      %+  turn
        kickable
      |=  =gid:gol
      =/  goal  (~(got by goals.p) gid)
      [gid goal(chief (~(got by chiefs) gid))]
  ==
:: remove a kick set from all goal deputies
::
++  purge-deputies
  |=  kick=(set ship)
  ^-  _this
  %=    this
      goals.p
    %-  ~(run by goals.p)
    |=  =goal:gol
    %=    goal
        deputies
      %-  ~(gas by *deputies:gol)
      %+  murn  ~(tap by deputies.goal)
      |=  [=ship role=?(%edit %create)]
      ?:((~(has in kick) ship) ~ [~ ship role])
    ==
  ==
::
:: ============================================================================
:: 
:: YOKES/RENDS
::
:: ============================================================================
++  dag-yoke
  |=  [n1=nid:gol n2=nid:gol mod=ship]
  ^-  _this
  :: Check mod permissions
  :: Can yoke with permissions on *both* goals
  :: This only works if "rends" work with perms on *either*
  ::
  ?.  ?&  (check-goal-edit-perm gid.n1 mod)
          (check-goal-edit-perm gid.n2 mod)
      ==
    ~|("missing-goal-mod-perms" !!)
  :: Cannot relate goal to itself
  ::
  ?:  =(gid.n1 gid.n2)  ~|("same-goal" !!)
  :: Cannot create left-undone-right-done relationship
  ::
  ?:  ?&  !done.i.status:(got-node:nd n1)
          done.i.status:(got-node:nd n2)
      ==
    ~|("left-undone-right-done" !!)
  :: If the right gid is an actionable goal
  :: and we are relating the left gid end to the right gid end,
  :: unmark the right goal actionable
  ::
  =?  this  &(=(-.n1 %e) =(-.n2 %e) actionable:(~(got by goals.p) gid.n2))
    (unmark-actionable gid.n2 mod)
  :: n2 must not come before n1
  ::
  ?:  (check-path:tv n2 n1 %r)  ~|("before-n2-n1" !!)
  ::
  =/  node1  (got-node:nd n1)
  =/  node2  (got-node:nd n2)
  :: there must be no bound mismatch between n1 and n2
  ::
  =/  lb  ?~(moment.node1 (left-bound:tv n1) moment.node1)
  =/  rb  ?~(moment.node2 (ryte-bound:tv n2) moment.node2)
  ?:  ?~(lb %| ?~(rb %| (gth u.lb u.rb)))  ~|("bound-mismatch" !!)
  :: dag-yoke
  ::
  =.  outflow.node1  (~(put in outflow.node1) n2)
  =.  inflow.node2  (~(put in inflow.node2) n1)
  =.  goals.p  (update-node:nd n1 node1)
  =.  goals.p  (update-node:nd n2 node2)
  this
::
++  dag-rend
  |=  [n1=nid:gol n2=nid:gol mod=ship]
  ^-  _this
  :: Check mod permissions
  :: Can rend with permissions on *either* goal
  ::
  ?.  ?|  (check-goal-edit-perm gid.n1 mod)
          (check-goal-edit-perm gid.n2 mod)
      ==
    ~|("missing-goal-mod-perms" !!)
  :: Cannot unrelate goal from itself
  ::
  ?:  =(gid.n1 gid.n2)  ~|("same-goal" !!)
  :: Cannot destroy containment of an owned goal
  ::
  =/  l  (~(got by goals.p) gid.n1)
  =/  r  (~(got by goals.p) gid.n2)
  ?:  ?|  &(=(-.n1 %e) =(-.n2 %e) (~(has in (sy children.r)) gid.n1))
          &(=(-.n1 %s) =(-.n2 %s) (~(has in (sy children.l)) gid.n2))
      ==
    ~|("owned-goal" !!)
  :: dag-rend
  ::
  =/  node1  (got-node:nd n1)
  =/  node2  (got-node:nd n2)
  =.  outflow.node1  (~(del in outflow.node1) n2)
  =.  inflow.node2   (~(del in inflow.node2) n1)
  =.  goals.p  (update-node:nd n1 node1)
  =.  goals.p  (update-node:nd n2 node2)
  this
::
++  yoke
  |=  [yok=exposed-yoke:act mod=ship]
  ^-  _this
  =,  yok
  ?-  -.yok
    %prio-yoke  (dag-yoke [%s lid] [%s rid] mod)
    %prio-rend  (dag-rend [%s lid] [%s rid] mod)
    %prec-yoke  (dag-yoke [%e lid] [%s rid] mod)
    %prec-rend  (dag-rend [%e lid] [%s rid] mod)
    %nest-yoke  (dag-yoke [%e lid] [%e rid] mod)
    %nest-rend  (dag-rend [%e lid] [%e rid] mod)
    %hook-yoke  (dag-yoke [%s lid] [%e rid] mod)
    %hook-rend  (dag-rend [%s lid] [%e rid] mod)
      %held-yoke  
    =/  pore  (dag-yoke [%e lid] [%e rid] mod)
    (dag-yoke:pore [%s rid] [%s lid] mod)
      %held-rend  
    =/  pore  (dag-rend [%e lid] [%e rid] mod)
    (dag-rend:pore [%s rid] [%s lid] mod)
  ==
::
++  find-and-oust
  |*  [item=* =(list)]
  ^-  (^list _item)
  ?~  idx=(find [item]~ list)  
    list
  (oust [u.idx 1] list)
::
++  slot-above
  |=  [dis=* dat=* =(list)]
  ^-  (^list _dis)
  ?~  idx=(find [dis]~ list)  !!
  =.  list  (oust [u.idx 1] list)
  ?~  idx=(find [dat]~ list)  !!
  (into list u.idx dis)
::
++  slot-below
  |=  [dis=* dat=* =(list)]
  ^-  (^list _dis)
  ?~  idx=(find [dis]~ list)  !!
  =.  list  (oust [u.idx 1] list)
  ?~  idx=(find [dat]~ list)  !!
  (into list +(u.idx) dis)
::
++  move-to-root
  |=  [=gid:gol mod=ship]
  ^-  _this
  ?.  (check-move-to-root-perm gid mod)
    ~|("missing-move-to-root-perms" !!)
  =/  k  (~(got by goals.p) gid)  
  ?~  parent.k  this :: already at root
  =/  q  (~(got by goals.p) u.parent.k)
  ?>  (~(has in (sy children.q)) gid)
  =.  goals.p  (~(put by goals.p) gid k(parent ~))
  =.  goals.p  (~(put by goals.p) u.parent.k q(children (find-and-oust gid children.q)))
  =.  roots.p  [gid roots.p]
  (yoke [%held-rend gid u.parent.k] mod)
::
++  move-to-goal
  |=  [kid=gid:gol pid=gid:gol mod=ship]
  ^-  _this
  ?.  (check-move-to-goal-perm kid pid mod)
    ~|("missing-move-to-goal-perms" !!)
  :: move to root first if necessary
  ::
  =/  pore
    ?~  [parent:(~(got by goals.p) kid)]
      this
    (move-to-root kid host.pid.p) :: divine intervention (owner)
  =/  k  (~(got by goals.p.pore) kid)
  =/  q  (~(got by goals.p.pore) pid)
  ?<  (~(has in (sy children.q)) kid)
  =.  goals.p.pore  (~(put by goals.p.pore) kid k(parent (some pid)))
  =.  goals.p.pore  (~(put by goals.p.pore) pid q(children [kid children.q]))
  =.  roots.p.pore  (find-and-oust kid roots.p.pore)
  (yoke:pore [%held-yoke kid pid] mod)
::
++  move
  |=  [kid=gid:gol upid=(unit gid:gol) mod=ship]
  ^-  _this
  ?~(upid (move-to-root kid mod) (move-to-goal kid u.upid mod))
::
++  reorder-roots
  |=  [roots=(list gid:gol) mod=ship]
  ^-  _this
  ?>  (check-pool-edit-perm mod)
  ?>  =((sy roots) (sy roots.p))
  this(roots.p roots)
::
++  reorder-children
  |=  [=gid:gol children=(list gid:gol) mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm gid mod)
  =/  =goal:gol  (~(got by goals.p) gid)
  ?>  =((sy children) (sy children.goal))
  this(goals.p (~(put by goals.p) gid goal(children children)))
::
++  yoke-sequence
  |=  [yoks=(list exposed-yoke:act) mod=ship]
  ^-  _this
  =/  pore  this
  |-
  ?~  yoks
    pore
  %=  $
    yoks  t.yoks
    pore  (yoke:pore i.yoks mod)
  ==
::
:: perform several simultaneous rends
++  nuke
  |=  [=nuke:act mod=ship]
  ^-  _this
  |^
  ::
  %-  yoke-sequence
  :_  mod
  ?-    -.nuke
    %nuke-prio-left  prio-left
    %nuke-prio-ryte  prio-ryte
    %nuke-prio  (weld prio-left prio-ryte)
    %nuke-prec-left  prec-left
    %nuke-prec-ryte  prec-ryte
    %nuke-prec  (weld prec-left prec-ryte)
    %nuke-prio-prec  :(weld prio-left prio-ryte prec-left prec-ryte)
    %nuke-nest-left  nest-left
    %nuke-nest-ryte  nest-ryte
    %nuke-nest  (weld nest-left nest-ryte)
  ==
  ::
  ++  prio-left
    %+  turn
      ~(tap in (prio-left:nd gid.nuke))
    |=  =gid:gol
    ^-  exposed-yoke:act
    [%prio-rend gid gid.nuke]
  ::
  ++  prio-ryte
    %+  turn
      ~(tap in (prio-ryte:nd gid.nuke))
    |=  =gid:gol
    ^-  exposed-yoke:act
    [%prio-rend gid.nuke gid]
  ::
  ++  prec-left
    %+  turn
      ~(tap in (prec-left:nd gid.nuke))
    |=  =gid:gol
    ^-  exposed-yoke:act
    [%prec-rend gid gid.nuke]
  ::
  ++  prec-ryte
    %+  turn
      ~(tap in (prec-ryte:nd gid.nuke))
    |=  =gid:gol
    ^-  exposed-yoke:act
    [%prec-rend gid.nuke gid]
  ::
  ++  nest-left
    %+  turn
      ~(tap in (nest-left:nd gid.nuke))
    |=  =gid:gol
    ^-  exposed-yoke:act
    [%nest-rend gid gid.nuke]
  ::
  ++  nest-ryte
    %+  turn
      ~(tap in (nest-ryte:nd gid.nuke))
    |=  =gid:gol
    ^-  exposed-yoke:act
    [%nest-rend gid.nuke gid]
  --
::
:: composite yokes
++  plex
  |=  [=plex:act mod=ship]
  ^-  _this
  ?-    plex
      exposed-yoke:act
    (yoke plex mod)
      nuke:act
    (nuke plex mod)
  ==
::
:: sequence of composite yokes
++  plex-sequence
  |=  [plez=(list plex:act) mod=ship]
  ^-  _this
  =/  pore  this
  |-
  ?~  plez
    pore
  $(plez t.plez, pore (plex:pore i.plez mod))
::
:: ============================================================================
:: 
:: COMPLETE/ACTIONABLE/KICKOFF/DEADLINE/PERMS UPDATES
::
:: ============================================================================
::
:: if inflow to end has more than its own start;
:: in other words if has actually or virtually nested goals
++  has-nested  |=(=gid:gol `?`(gth (lent ~(tap in (iflo:nd [%e gid]))) 1))
::
++  mark-actionable
  |=  [=gid:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm gid mod)
  =/  goal  (~(got by goals.p) gid)
  ?:  (has-nested gid)  ~|("has-nested" !!)
  this(goals.p (~(put by goals.p) gid goal(actionable %&)))
::
++  unmark-actionable
  |=  [=gid:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm gid mod)
  =/  goal  (~(got by goals.p) gid)
  this(goals.p (~(put by goals.p) gid goal(actionable %|)))
::
++  mark-done
  |=  [=nid:gol now=@da mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm gid.nid mod)
  =/  goal  (~(got by goals.p) gid.nid)
  ~&  marking-done+-.nid
  ?:  (left-undone:tv nid)  ~&  %left-undone  ~|("left-undone" !!)
  =.  goal
    ?-    -.nid
        %s
      ?:  done.i.status.start.goal
        ~|("already-done" goal)
      ?:  (lth now timestamp.i.status.start.goal)
        ~|("bad-time" goal)
      goal(status.start [[now %&] status.start.goal])
      ::
        %e
      ?:  done.i.status.end.goal
        ~|("already-done" goal)
      ?:  (lth now timestamp.i.status.end.goal)
        ~|("bad-time" goal)
      goal(status.end [[now %&] status.end.goal])
    ==
  ~&  goal
  this(goals.p (~(put by goals.p) gid.nid goal))
::
++  unmark-done
  |=  [=nid:gol now=@da mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm gid.nid mod)
  =/  goal  (~(got by goals.p) gid.nid)
  ?:  (right-done:tv nid)  ~|("right-done" !!)
  =.  goal
    ?-    -.nid
        %s
      ?.  done.i.status.start.goal
        ~|("already-undone" goal)
      ?:  (lth now timestamp.i.status.start.goal)
        ~|("bad-time" goal)
      goal(status.start [[now %|] status.start.goal])
      ::
        %e
      ?.  done.i.status.end.goal
        ~|("already-undone" goal)
      ?:  (lth now timestamp.i.status.end.goal)
        ~|("bad-time" goal)
      goal(status.end [[now %|] status.end.goal])
    ==
  this(goals.p (~(put by goals.p) gid.nid goal))
::
++  bounded
  |=  [=nid:gol =moment:gol dir=?(%l %r)]
  ^-  ?
  ?-  dir
    %l  =/(lb (left-bound:tv nid) ?~(moment %| ?~(lb %| (gth u.lb u.moment))))
    %r  =/(rb (ryte-bound:tv nid) ?~(moment %| ?~(rb %| (lth u.rb u.moment))))
  == 
::
++  set-start
  |=  [=gid:gol =moment:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm gid mod)
  ?:  (bounded [%s gid] moment %l)  ~|("bound-left" !!)
  ?:  (bounded [%s gid] moment %r)  ~|("bound-ryte" !!)
  =/  goal  (~(got by goals.p) gid)
  this(goals.p (~(put by goals.p) gid goal(moment.start moment)))
::
++  set-end
  |=  [=gid:gol =moment:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm gid mod)
  ?:  (bounded [%e gid] moment %l)  ~|("bound-left" !!)
  ?:  (bounded [%e gid] moment %r)  ~|("bound-ryte" !!)
  =/  goal  (~(got by goals.p) gid)
  this(goals.p (~(put by goals.p) gid goal(moment.end moment)))
::
:: Update pool permissions for individual ship.
:: If role is ~, remove ship as viewer.
::   If we remove a ship as a viewer, we must remove it from all goal
::   create sets. We must also remove it from all goal chiefs and replace
::   the chief with its nearest non-deleted ancestor chief or the pool
::   owner when no ancestor is available.
:: If role is [~ u=~], make ship basic viewer.
:: If role is [~ u=[~ u=?(%admin %creator)]], make ship ?(%admin %creator).
++  set-pool-role
  |=  [=ship role=(unit role:gol) mod=ship]
  ^-  _this
  ?>  (check-pool-role-mod ship mod)
  ?~  role
    =/  pore  (replace-chiefs (sy ~[ship]))
    =/  pore  (purge-deputies:pore (sy ~[ship]))
    pore(perms.p (~(del by perms.p) ship))
  this(perms.p (~(put by perms.p) ship u.role))
::
:: set the chief of a goal or optionally all its subgoals
:: TODO: incorporate open-to.goal
++  set-chief
  |=  [=gid:gol chief=ship rec=?(%.y %.n) mod=ship]
  ^-  _this
  ?.  (check-goal-edit-perm gid mod)  ~|("missing goal perms" !!)
  ?.  (check-in-pool chief)  ~|("chief not in pool" !!)
  =/  ids  ?.(rec ~[gid] ~(tap in (progeny:tv gid)))
  %=  this
    goals.p
      %-  ~(gas by goals.p)
      %+  turn
        ids
      |=  =gid:gol
      =/  goal  (~(got by goals.p) gid)
      [gid goal(chief chief)]
  ==
::
:: replace the deputies of a goal with new deputies
++  replace-deputies
  |=  [=gid:gol =deputies:gol mod=ship]
  ^-  _this
  ?.  (check-goal-edit-perm gid mod)  ~|("missing goal perms" !!)
  ?.  (~(all in ~(key by deputies)) check-in-pool)
    ~|("some ships in deputies are not in pool" !!)
  =/  goal  (~(got by goals.p) gid)
  this(goals.p (~(put by goals.p) gid goal(deputies deputies)))
--
