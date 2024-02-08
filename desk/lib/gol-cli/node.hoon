/-  gol=goals
|_  =goals:gol
::
:: get a node from a node gid
++  got-node
  |=  =nid:gol
  ^-  node:gol
  =/  goal  (~(got by goals) gid.nid)
  ?-  -.nid
    %s  start.goal
    %e  end.goal
  ==
::
:: Update the node at nid with the given node
++  update-node
  |=  [=nid:gol =node:gol]
  ^-  goals:gol
  =/  goal  (~(got by goals) gid.nid)
  %+  ~(put by goals)
    gid.nid
  ?-  -.nid
    %s  goal(start node)
    %e  goal(end node)
  ==
::
++  iflo  |=(=nid:gol inflow:(got-node nid))
++  oflo  |=(=nid:gol outflow:(got-node nid))
::
:: nodes which have no outflows (must be ends)
++  root-nodes
  |.  ^-  (list nid:gol)
  %+  turn
    %+  skim
      ~(tap by goals)
    |=([gid:gol =goal:gol] =(~ outflow.end.goal))
  |=([=gid:gol =goal:gol] [%e gid])
::
:: nodes which have no inflows (must be starts)
++  leaf-nodes
  |.  ^-  (list nid:gol)
  %+  turn
    %+  skim
      ~(tap by goals)
    |=([gid:gol =goal:gol] =(~ inflow.start.goal))
  |=([=gid:gol =goal:gol] [%s gid])
::
++  is-unnested
  |=  =gid:gol
  ^-  ?
  =;  d-outflow  =(~ d-outflow)
  %+  murn
    ~(tap in (oflo [%e gid]))
  |=  =nid:gol
  ?.  ?=(%s -.nid)
    ~
  (some nid)
::
:: goals whose ends have no outflows to ends
++  root-goals
  |.  ^-  (list gid:gol)
  %+  turn
    %+  skim
      ~(tap by goals)
    |=([=gid:gol goal:gol] (is-unnested gid))
  |=([=gid:gol =goal:gol] gid)
::
:: parententless goals
++  waif-goals
  |.  ^-  (list gid:gol)
  %+  turn
    %+  skim
      ~(tap by goals)
    |=([gid:gol =goal:gol] =(~ parent.goal))
  |=([=gid:gol =goal:gol] gid)
::
:: childless goals
++  bare-goals
  |.  ^-  (list gid:gol)
  %+  turn
    %+  skim
      ~(tap by goals)
    |=([gid:gol =goal:gol] =(~ children.goal))
  |=([=gid:gol =goal:gol] gid)
::
:: accepts a end; returns inflowing ends
++  yong
  |=  =nid:gol
  ^-  (set nid:gol)
  ?>  =(%e -.nid)
  %-  ~(gas in *(set nid:gol))
  %+  murn
    ~(tap in (iflo nid))
  |=  =nid:gol
  ?-  -.nid
    %s  ~
    %e  (some nid)
  ==
::
:: gets the children and "virtual children" of a goal
++  yung
  |=  =gid:gol
  ^-  (list gid:gol)
  (turn ~(tap in (yong [%e gid])) |=(=nid:gol gid.nid))
::
:: gets the "virtual children" of a goal
:: (non-children inflowing ends to the end)
++  virt
  |=  =gid:gol
  ^-  (list gid:gol)
  %~  tap  in
  %-  %~  dif  in
      (~(gas in *(set gid:gol)) (yung gid))
  children:(~(got by goals) gid)
::
:: extracts ids of incomplete goals from a list of ids
++  incomplete
  |=  ids=(list gid:gol)
  ^-  (list gid:gol)
  (skip ids |=(=gid:gol done.i.status:(got-node e+gid)))
::
:: get all nodes from a set of ids
++  nodify
  |=  ids=(set gid:gol)
  ^-  (set nid:gol)
  =/  kix=(set nid:gol)  (~(run in ids) |=(=gid:gol [%s gid]))
  =/  ded=(set nid:gol)  (~(run in ids) |=(=gid:gol [%e gid]))
  (~(uni in kix) ded)
::
:: get the nodes from a set of nodes which are
:: contained in the inflow/outflow of a goal's start/end
++  bond-overlap
  |=  [=gid:gol nids=(set nid:gol) dir=?(%l %r) src=?(%s %e)]
  ^-  (set (pair nid:gol nid:gol))
  =/  flo  ?-(dir %l iflo, %r oflo)
  %-  ~(run in (~(int in nids) (flo [src gid])))
  |=(=nid:gol ?-(dir %l [nid src gid], %r [[src gid] nid]))
::
:: get the bonds which exist between a goal and a set of other goals
++  get-bonds
  |=  [=gid:gol ids=(set gid:gol)]
  ^-  (list (pair nid:gol nid:gol))
  ::
  :: get set of nodes of ids
  =/  nids  (nodify ids)
  :: 
  %~  tap  in
  ::
  :: get the nodes flowing into gid's start
  %-  ~(uni in (bond-overlap gid nids %l %s))
  ::
  :: get the nodes flowing out of gid's start
  %-  ~(uni in (bond-overlap gid nids %r %s))
  ::
  :: get the nodes flowing into gid's end
  %-  ~(uni in (bond-overlap gid nids %l %e))
  ::
  :: get the nodes flowing out of gid's end
  (bond-overlap gid nids %r %e)
:: 
:: kid - include if kid, yes or no?
:: parent - include if parent, yes or no?
:: dir - leftward or rightward
:: src - starting in start or end
:: dst - ending in start or end
++  neighbors
  |=  [=gid:gol kid=? parent=? dir=?(%l %r) src=?(%s %e) dst=?(%s %e)]
  ^-  (set gid:gol)
  =/  flow  ?-(dir %l (iflo [src gid]), %r (oflo [src gid]))
  =/  goal  (~(got by goals) gid)
  %-  ~(gas in *(set gid:gol))
  %+  murn
    ~(tap in flow)
  |=  =nid:gol
  ?.  ?&  =(dst -.nid) :: we keep when destination is as specified
          |(kid !(~(has in children.goal) gid.nid)) :: if k false, must not be in children
          |(parent !?~(parent.goal %| =(gid.nid u.parent.goal))) :: if p is false, must not be parent
      ==
    ~
  (some gid.nid)
::  
++  prio-left  |=(=gid:gol (neighbors gid %& %| %l %s %s))
++  prio-ryte  |=(=gid:gol (neighbors gid %| %& %r %s %s))
++  prec-left  |=(=gid:gol (neighbors gid %& %& %l %s %e))
++  prec-ryte  |=(=gid:gol (neighbors gid %& %& %r %e %s))
++  nest-left  |=(=gid:gol (neighbors gid %| %& %l %e %e))
++  nest-ryte  |=(=gid:gol (neighbors gid %& %| %r %e %e))
::
++  young  |=(=gid:gol (~(uni in children:(~(got by goals) gid)) (nest-left gid)))
--
