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
  |=  [=id:gol summary=@t chief=ship author=ship]
  ^-  goal:gol
  ?.  (lte (met 3 summary) 140)
    ~|("Summary exceeds 140 characters." !!)
  =|  =goal:gol
  =.  chief.goal    chief
  =.  summary.goal  summary
  :: =.  author.goal  author
  :: 
  :: Initialize inflowing and outflowing nodes
  =.  outflow.kickoff.goal  (~(put in *(set nid:gol)) [%d id])
  =.  inflow.deadline.goal  (~(put in *(set nid:gol)) [%k id])
  goal
::
++  create-goal
  |=  [=id:gol upid=(unit id:gol) summary=@t mod=ship]
  ^-  _this
  ?>  ?~  upid
        (check-root-create-perm mod)
      (check-goal-create-perm u.upid mod)
  =/  goal  (init-goal id summary mod mod)
  =.  goals.p  (~(put by goals.p) id goal)
  =.  this  (put-roots id)
  =.  this  (move id upid host.pin.p) :: divine intervention (owner)
  :: mark the goal started if possible
  ::
  ?^  mol=(mole |.((mark-done k+id mod)))
    u.mol
  this
::
:: Extract goal from goals
++  wrest-goal
  |=  [=id:gol mod=ship]
  ^-  [trac=goals:gol _this]
  :: Get subgoals of goal including self
  ::
  =/  prog  (progeny:tv id)
  :: Move goal to root
  ::
  =/  pore  (move id ~ host.pin.p) :: divine intervention (owner)
  :: Partition subgoals of goal from rest of goals
  ::
  =.  pore  (partition:pore prog mod)
  :: Get extracted goals
  ::
  =/  trac=goals:gol  (gat-by goals.p.pore ~(tap in prog))
  :: Update goals to remaining
  ::
  =.  goals.p  (gus-by goals.p.pore ~(tap in prog))
  :: Delete from roots
  ::
  =.  pore  (del-roots id) :: delete from roots
  :: both of these should get validated here (validate-goals:vd goals)
  :: return extracted goals and remaining goals
  ::
  [trac pore]
::
++  set-summary
  |=  [=id:gol summary=@t mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm id mod)
  ?.  (lte (met 3 summary) 140)
    ~|("Summary exceeds 140 characters." !!)
  =/  =goal:gol  (~(got by goals.p) id)
  this(goals.p (~(put by goals.p) id goal(summary summary)))
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
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm id mod)
  =/  par=(unit id:gol)  par:(~(got by goals.p) id)
  =^  trac  this
    (wrest-goal id mod) :: mod has the correct perms for this
  this(archive.p (~(put by archive.p) id [par trac]))
::
:: Restore goal from archive to main goals
++  restore-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  :: TODO: Chief of goal etc should be able to renew in some cases?
  ::
  ?>  (check-pool-edit-perm mod) :: only owner/admins can renew
  =/  [par=(unit id:gol) new=goals:gol]  (~(got by archive.p) id)
  =.  goals.p    (~(uni by goals.p) (validate-goals:vd new))
  =.  archive.p  (~(del by archive.p) id)
  ?^  mol=(mole |.((move id par mod)))
    u.mol
  ~&(%failed-to-restore-under-old-parent this)
::
:: Permanently delete goal and subgoals from archive
++  delete-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-pool-edit-perm mod)
  =^  trac  this
    (wrest-goal id mod) :: correctly handles orders
  this(archive.p (~(del by archive.p) id))
::
:: Partition the set of goals q from its complement q- in goals.p
++  partition
  |=  [q=(set id:gol) mod=ship]
  ^-  _this
  ::
  :: get complement of q
  =/  q-  (~(dif in ~(key by goals.p)) q)
  ::
  :: iterate through and break bonds between each id in q
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
  |=  [=id:gol exes=(set id:gol) mod=ship]
  ^-  _this
  ::
  :: get the existing bonds between id and its (future) exes
  =/  pairs  (get-bonds:nd id exes)
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
  ?|  =(mod host.pin.p)
      ?=([~ %admin] (~(got by perms.p) mod))
  ==
:: owner, admin or deputy
::
++  check-root-create-perm
  |=  mod=ship
  ^-  ?
  ?|  =(mod host.pin.p)
      ?=([~ ?(%admin %creator)] (~(got by perms.p) mod))
  ==
:: can edit pool (owner or admin)
:: or is ranking member on goal
:: or is a deputy with edit permissions
::
++  check-goal-edit-perm
  |=  [=id:gol mod=ship]
  ^-  ?
  ?|  (check-pool-edit-perm mod)
      ?=(^ (get-rank:tv mod id))
      ?=([~ %edit] (~(get by deputies:(~(got by goals.p) id)) mod))
  ==
:: can edit goal (owner, admin or ranking member on goal)
:: or is a deputy on the goal
::
++  check-goal-create-perm
  |=  [=id:gol mod=ship]
  ^-  ?
  ?|  (check-goal-edit-perm id mod)
      (~(has by deputies:(~(got by goals.p) id)) mod)
  ==
:: most senior ancestor
::
++  stock-root
  |=  =id:gol
  ^-  [=id:gol chief=ship]
  (snag 0 (flop (get-stock:tv id)))
:: owner, admin, or chief of stock-root
::
++  check-goal-master
  |=  [=id:gol mod=ship]
  ^-  ?
  ?|  (check-pool-edit-perm mod)
      =(mod chief:(stock-root id))
  ==
::
++  check-move-to-root-perm
  |=  [=id:gol mod=ship]
  ^-  ?
  ?&  (check-goal-master id mod)
      (check-root-create-perm mod)
  ==
:: checks if mod can move kid under pid
::
++  check-move-to-goal-perm
  |=  [kid=id:gol pid=id:gol mod=ship]
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
  ?:  =(ship host.pin.p)
    ~|("Cannot change host.pin.perms." !!)
  ?.  (check-pool-edit-perm mod)
    ~|("Do not have owner or admin perms." !!)
  ?:  ?&  =((~(get by perms.p) ship) (some (some %admin)))
          !|(=(mod host.pin.p) =(mod ship))
      ==
    ~|("Must be owner or self to modify admin perms." !!)
  %&
::
++  check-in-pool  |=(=ship |(=(ship host.pin.p) (~(has by perms.p) ship)))
:: replace all chiefs of goals whose chiefs have been kicked
::
++  replace-chiefs
   |=  kick=(set ship)
   ^-  _this
   :: list of all ids of goals with replacable chiefs
   ::
   =/  kickable=(list id:gol)
     %+  murn
       ~(tap by goals.p)
     |=  [=id:gol =goal:gol]
     ?.  (~(has in kick) chief.goal)
       ~
     (some id)
   :: accurate updated chief information
   ::
   =/  chiefs
     ((chain:tv id:gol ship) (replace-chief:tv kick host.pin.p) kickable ~)
   :: update goals.p to reflect new chief information
   ::
  %=  this
    goals.p
      %-  ~(gas by goals.p)
      %+  turn
        kickable
      |=  =id:gol
      =/  goal  (~(got by goals.p) id)
      [id goal(chief (~(got by chiefs) id))]
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
++  put-young
  |=  [pid=id:gol yid=id:gol]
  ^-  _this
  =/  =goal:gol  (~(got by goals.p) pid)
  ?>  (~(has in inflow.deadline.goal) d+yid)
  =.  young.goal  [yid young.goal]
  this(goals.p (~(put by goals.p) pid goal))
::
++  del-young
  |=  [pid=id:gol yid=id:gol]
  ^-  _this
  =/  =goal:gol  (~(got by goals.p) pid)
  ?<  (~(has in inflow.deadline.goal) d+yid)
  =/  idx=(unit @)  (find ~[yid] young.goal)
  ?~  idx
    ~|("couldn't find young..." this)
  =.  young.goal  (oust [u.idx 1] young.goal)
  this(goals.p (~(put by goals.p) pid goal))
::
++  put-roots
  |=  =id:gol
  ^-  _this
  =/  =goal:gol  (~(got by goals.p) id)
  ?>  ?=(~ par.goal)
  this(roots.p [id roots.p])
::
++  del-roots
  |=  =id:gol
  ^-  _this
  =/  goal=(unit goal:gol)  (~(get by goals.p) id)
  ?>  |(?=(~ goal) ?=(^ par.u.goal))
  =/  idx=(unit @)  (find ~[id] roots.p)
  ?~  idx
    ~|("couldn't find root..." this)
  this(roots.p (oust [u.idx 1] roots.p))
::
++  manage-orders
  |=  [type=?(%yoke %rend) n1=nid:gol n2=nid:gol]
  ^-  _this
  ?.  &(?=(%d -.n1) ?=(%d -.n2))  this
  ?-    type
      %yoke
    =.  this
      =/  =goal:gol  (~(got by goals.p) id.n1)
      ?.  ?&  ?=(^ par.goal)
              (~(has in (sy roots.p)) id.n1)
          ==
         this
       (del-roots id.n1)
    (put-young id.n2 id.n1)
    ::
      %rend
    =.  this
      =/  =goal:gol  (~(got by goals.p) id.n1)
      ?.  ?&  ?=(~ par.goal)
              !(~(has in (sy roots.p)) id.n1)
          ==
         this
       (put-roots id.n1)
    (del-young id.n2 id.n1)
  ==
:: slot dis above dat in pid's young
::
++  young-slot-above
  |=  [pid=id:gol dis=id:gol dat=id:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm pid mod)
  =/  goal  (~(got by goals.p) pid)
  ?~  idx=(find [dis]~ young.goal)  !!
  =.  young.goal  (oust [u.idx 1] young.goal)
  ?~  idx=(find [dat]~ young.goal)  !!
  =.  young.goal  (into young.goal u.idx dis)
  this(goals.p (~(put by goals.p) pid goal))
:: slot dis below dat in pid's young
::
++  young-slot-below
  |=  [pid=id:gol dis=id:gol dat=id:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm pid mod)
  =/  goal  (~(got by goals.p) pid)
  ?~  idx=(find [dis]~ young.goal)  !!
  =.  young.goal  (oust [u.idx 1] young.goal)
  ?~  idx=(find [dat]~ young.goal)  !!
  =.  young.goal  (into young.goal +(u.idx) dis)
  this(goals.p (~(put by goals.p) pid goal))
:: slot dis above dat in roots
::
++  roots-slot-above
  |=  [dis=id:gol dat=id:gol mod=ship]
  ^-  _this
  ?>  (check-pool-edit-perm mod)
  ?~  idx=(find [dis]~ roots.p)  !!
  =.  roots.p  (oust [u.idx 1] roots.p)
  ?~  idx=(find [dat]~ roots.p)  !!
  this(roots.p (into roots.p u.idx dis))
:: slot dis below dat in roots
::
++  roots-slot-below
  |=  [dis=id:gol dat=id:gol mod=ship]
  ^-  _this
  ?>  (check-pool-edit-perm mod)
  ?~  idx=(find [dis]~ roots.p)  !!
  =.  roots.p  (oust [u.idx 1] roots.p)
  ?~  idx=(find [dat]~ roots.p)  !!
  this(roots.p (into roots.p +(u.idx) dis))
::
++  dag-yoke
  |=  [n1=nid:gol n2=nid:gol mod=ship]
  ^-  _this
  :: Check mod permissions
  :: Can yoke with permissions on *both* goals
  :: This only works if "rends" work with perms on *either*
  ::
  ?.  ?&  (check-goal-edit-perm id.n1 mod)
          (check-goal-edit-perm id.n2 mod)
      ==
    ~|("missing-goal-mod-perms" !!)
  :: Cannot relate goal to itself
  ::
  ?:  =(id.n1 id.n2)  ~|("same-goal" !!)
  :: Cannot create left-undone-right-done relationship
  ::
  ?:  ?&  !done:(got-node:nd n1)
          done:(got-node:nd n2)
      ==
    ~|("left-undone-right-done" !!)
  :: If the right id is an actionable goal
  :: and we are relating the left id deadline to the right id deadline,
  :: unmark the right goal actionable
  ::
  =?  this  &(=(-.n1 %d) =(-.n2 %d) actionable:(~(got by goals.p) id.n2))
    (unmark-actionable id.n2 mod)
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
  ::
  (manage-orders %yoke n1 n2)
::
++  dag-rend
  |=  [n1=nid:gol n2=nid:gol mod=ship]
  ^-  _this
  :: Check mod permissions
  :: Can rend with permissions on *either* goal
  ::
  ?.  ?|  (check-goal-edit-perm id.n1 mod)
          (check-goal-edit-perm id.n2 mod)
      ==
    ~|("missing-goal-mod-perms" !!)
  :: Cannot unrelate goal from itself
  ::
  ?:  =(id.n1 id.n2)  ~|("same-goal" !!)
  :: Cannot destroy containment of an owned goal
  ::
  =/  l  (~(got by goals.p) id.n1)
  =/  r  (~(got by goals.p) id.n2)
  ?:  ?|  &(=(-.n1 %d) =(-.n2 %d) (~(has in kids.r) id.n1))
          &(=(-.n1 %k) =(-.n2 %k) (~(has in kids.l) id.n2))
      ==
    ~|("owned-goal" !!)
  :: dag-rend
  ::
  =/  node1  (got-node:nd n1)
  =/  node2  (got-node:nd n2)
  =.  outflow.node1  (~(del in outflow.node1) n2)
  =.  inflow.node2  (~(del in inflow.node2) n1)
  =.  goals.p  (update-node:nd n1 node1)
  =.  goals.p  (update-node:nd n2 node2)
  ::
  (manage-orders %rend n1 n2)
::
++  yoke
  |=  [yok=exposed-yoke:act mod=ship]
  ^-  _this
  =,  yok
  ?-  -.yok
    %prio-yoke  (dag-yoke [%k lid] [%k rid] mod)
    %prio-rend  (dag-rend [%k lid] [%k rid] mod)
    %prec-yoke  (dag-yoke [%d lid] [%k rid] mod)
    %prec-rend  (dag-rend [%d lid] [%k rid] mod)
    %nest-yoke  (dag-yoke [%d lid] [%d rid] mod)
    %nest-rend  (dag-rend [%d lid] [%d rid] mod)
    %hook-yoke  (dag-yoke [%k lid] [%d rid] mod)
    %hook-rend  (dag-rend [%k lid] [%d rid] mod)
      %held-yoke  
    =/  pore  (dag-yoke [%d lid] [%d rid] mod)
    (dag-yoke:pore [%k rid] [%k lid] mod)
      %held-rend  
    =/  pore  (dag-rend [%d lid] [%d rid] mod)
    (dag-rend:pore [%k rid] [%k lid] mod)
  ==
::
++  move-to-root
  |=  [=id:gol mod=ship]
  ^-  _this
  ?.  (check-move-to-root-perm id mod)
    ~|("missing-move-to-root-perms" !!)
  =/  k  (~(got by goals.p) id)  
  ?~  par.k  this
  =/  q  (~(got by goals.p) u.par.k)
  =.  goals.p  (~(put by goals.p) id k(par ~))
  =.  goals.p  (~(put by goals.p) u.par.k q(kids (~(del in kids.q) id)))
  (yoke [%held-rend id u.par.k] mod)
::
++  move-to-goal
  |=  [kid=id:gol pid=id:gol mod=ship]
  ^-  _this
  ?.  (check-move-to-goal-perm kid pid mod)
    ~|("missing-move-to-goal-perms" !!)
  ::
  =/  pore  (move-to-root kid host.pin.p) :: divine intervention (owner)
  =/  k  (~(got by goals.p.pore) kid)
  =/  q  (~(got by goals.p.pore) pid)
  =.  goals.p.pore  (~(put by goals.p.pore) kid k(par (some pid)))
  =.  goals.p.pore  (~(put by goals.p.pore) pid q(kids (~(put in kids.q) kid)))
  (yoke:pore [%held-yoke kid pid] mod)
::
++  move
  |=  [kid=id:gol upid=(unit id:gol) mod=ship]
  ^-  _this
  ?~(upid (move-to-root kid mod) (move-to-goal kid u.upid mod))
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
      ~(tap in (prio-left:nd id.nuke))
    |=  =id:gol
    ^-  exposed-yoke:act
    [%prio-rend id id.nuke]
  ::
  ++  prio-ryte
    %+  turn
      ~(tap in (prio-ryte:nd id.nuke))
    |=  =id:gol
    ^-  exposed-yoke:act
    [%prio-rend id.nuke id]
  ::
  ++  prec-left
    %+  turn
      ~(tap in (prec-left:nd id.nuke))
    |=  =id:gol
    ^-  exposed-yoke:act
    [%prec-rend id id.nuke]
  ::
  ++  prec-ryte
    %+  turn
      ~(tap in (prec-ryte:nd id.nuke))
    |=  =id:gol
    ^-  exposed-yoke:act
    [%prec-rend id.nuke id]
  ::
  ++  nest-left
    %+  turn
      ~(tap in (nest-left:nd id.nuke))
    |=  =id:gol
    ^-  exposed-yoke:act
    [%nest-rend id id.nuke]
  ::
  ++  nest-ryte
    %+  turn
      ~(tap in (nest-ryte:nd id.nuke))
    |=  =id:gol
    ^-  exposed-yoke:act
    [%nest-rend id.nuke id]
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
:: if inflow to deadline has more than its own kickoff;
:: in other words if has actually or virtually nested goals
++  has-nested  |=(=id:gol `?`(gth (lent ~(tap in (iflo:nd [%d id]))) 1))
::
++  mark-actionable
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm id mod)
  =/  goal  (~(got by goals.p) id)
  ?:  (has-nested id)  ~|("has-nested" !!)
  this(goals.p (~(put by goals.p) id goal(actionable %&)))
::
++  mark-done
  |=  [=nid:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm id.nid mod)
  =/  goal  (~(got by goals.p) id.nid)
  ~&  marking-done+-.nid
  ?:  (left-undone:tv nid)  ~&  %left-undone  ~|("left-undone" !!)
  =.  goal
    ?-  -.nid
      %k  goal(done.kickoff %&)
      %d  goal(done.deadline %&)
    ==
  ~&  goal
  this(goals.p (~(put by goals.p) id.nid goal))
::
++  mark-complete
  |=  [=id:gol mod=ship]
  ^-  _this
  ~&  %marking-complete
  =/  pore  (mark-done k+id mod)
  (mark-done:pore d+id mod)
::
++  unmark-actionable
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm id mod)
  =/  goal  (~(got by goals.p) id)
  this(goals.p (~(put by goals.p) id goal(actionable %|)))
::
++  unmark-done
  |=  [=nid:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm id.nid mod)
  =/  goal  (~(got by goals.p) id.nid)
  ?:  (right-done:tv nid)  ~|("right-done" !!)
  =.  goal
    ?-  -.nid
      %k  goal(done.kickoff %|)
      %d  goal(done.deadline %|)
    ==
  this(goals.p (~(put by goals.p) id.nid goal))
::
++  unmark-complete
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  pore  (unmark-done d+id mod)
  :: Unmark kickoff done if possible
  ?~  unk=(mole |.((unmark-done:pore k+id mod)))
    pore
  u.unk
::
++  bounded
  |=  [=nid:gol =moment:gol dir=?(%l %r)]
  ^-  ?
  ?-  dir
    %l  =/(lb (left-bound:tv nid) ?~(moment %| ?~(lb %| (gth u.lb u.moment))))
    %r  =/(rb (ryte-bound:tv nid) ?~(moment %| ?~(rb %| (lth u.rb u.moment))))
  == 
::
++  set-kickoff
  |=  [=id:gol =moment:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm id mod)
  ?:  (bounded [%k id] moment %l)  ~|("bound-left" !!)
  ?:  (bounded [%k id] moment %r)  ~|("bound-ryte" !!)
  =/  goal  (~(got by goals.p) id)
  this(goals.p (~(put by goals.p) id goal(moment.kickoff moment)))
::
++  set-deadline
  |=  [=id:gol =moment:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm id mod)
  ?:  (bounded [%d id] moment %l)  ~|("bound-left" !!)
  ?:  (bounded [%d id] moment %r)  ~|("bound-ryte" !!)
  =/  goal  (~(got by goals.p) id)
  this(goals.p (~(put by goals.p) id goal(moment.deadline moment)))
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
  |=  [=ship role=(unit (unit role:gol)) mod=ship]
  ^-  _this
  ?>  (check-pool-role-mod ship mod)
  ?~  role
    =/  pore  (replace-chiefs (sy ~[ship]))
    =/  pore  (purge-deputies:pore (sy ~[ship]))
    pore(perms.p (~(del by perms.p) ship))
  this(perms.p (~(put by perms.p) ship u.role))
::
:: set the chief of a goal or optionally all its subgoals
++  set-chief
  |=  [=id:gol chief=ship rec=?(%.y %.n) mod=ship]
  ^-  _this
  ?.  (check-goal-edit-perm id mod)  ~|("missing goal perms" !!)
  ?.  (check-in-pool chief)  ~|("chief not in pool" !!)
  =/  ids  ?.(rec ~[id] ~(tap in (progeny:tv id)))
  %=  this
    goals.p
      %-  ~(gas by goals.p)
      %+  turn
        ids
      |=  =id:gol
      =/  goal  (~(got by goals.p) id)
      [id goal(chief chief)]
  ==
::
:: replace the deputies of a goal with new deputies
++  replace-deputies
  |=  [=id:gol =deputies:gol mod=ship]
  ^-  _this
  ?.  (check-goal-edit-perm id mod)  ~|("missing goal perms" !!)
  ?.  (~(all in ~(key by deputies)) check-in-pool)
    ~|("some ships in deputies are not in pool" !!)
  =/  goal  (~(got by goals.p) id)
  this(goals.p (~(put by goals.p) id goal(deputies deputies)))
--
