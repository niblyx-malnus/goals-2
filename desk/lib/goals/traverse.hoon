/-  gol=goals
/+  goals-node
|_  =goals:gol
+*  nd  ~(. goals-node goals)
::
++  iflo  iflo:nd
++  oflo  oflo:nd
::
:: TODO: these should be cores
:: "engine" used to perform different kinds
:: of graph traversals using the traverse function
++  gine
  |*  [nod=mold med=mold fin=mold]
  :*  flow=|~(nod *(list nod))
      init=|~(nod *med)
      stop=|~([nod med] `?`%.n)
      meld=|~([nod neb=nod old=med new=med] new)
      land=|~([nod =med ?] med)
      exit=|~([nod vis=(map nod med)] `fin`!!)
      prnt=|~(nod *tape) :: for debugging cycles
  ==
::
:: set defaults for gine where output mold is same
:: as transition mold
++  ginn
  |*  [nod=mold med=mold]
  =/  gine  (gine nod med med)
  gine(exit |~([=nod vis=(map nod med)] (~(got by vis) nod)))
::
:: print nodes for debugging cycles
++  print-id   |=(=gid:gol (trip summary:(~(got by goals) gid)))
++  print-nid  |=(=nid:gol `tape`:(weld "{<`@tas`-.nid>} " (print-id gid.nid)))
::
:: traverse the underlying DAG (directed acyclic graph)
++  traverse
  |*  [nod=mold med=mold fin=mold]
  :: 
  :: takes an "engine" and a map of already visited nodes and values
  |=  [_(gine nod med fin) vis=(map nod med)]
  ::
  :: initialize path to catch cycles
  =|  pat=(list nod)
  ::
  :: accept single node gid
  |=  =nod
  ::
  :: final transformation
  ^-  fin  %+  exit  nod
  |-
  ^-  (map ^nod med)
  ::
  :: catch cycles
  =/  i  (find [nod]~ pat) 
  =/  cyc=(list ^nod)  ?~(i ~ [nod (scag +(u.i) pat)])
  :: TODO: never allow prnt to crash
  ?.  =(0 (lent cyc))  ~|(["cycle" (turn cyc prnt)] !!)
  ::
  :: iterate through neighbors (flo)
  =/  idx  0
  =/  flo  (flow nod)
  ::
  :: initialize output
  =/  med  (init nod)
  |-
  :: 
  :: stop when neighbors exhausted or stop condition met
  =/  cnd  (stop nod med)
  ?:  ?|  cnd
          =(idx (lent flo))
      ==
    ::
    :: output according to land function
    (~(put by vis) nod (land nod med cnd))
  ::
  =/  neb  (snag idx flo)
  ::
  :: make sure visited reflects output of next neighbor
  =.  vis
    ?:  (~(has by vis) neb)
      vis :: if already in visited, use stored output
    ::
    :: recursively compute output for next neighbor
    %=  ^$
      nod  neb
      pat  [nod pat]
      vis  vis :: this has been updated by inner trap
    ==
  ::
  :: update the output and go to the next neighbor
  %=  $
    idx  +(idx)
    ::
    :: meld the running output with the new output
    med  (meld nod neb med (~(got by vis) neb))
  ==
::
:: chain multiple traversals together, sharing visited map
++  chain
  |*  [nod=mold med=mold]
  |=  $:  trav=$-([nod (map nod med)] (map nod med))
          nodes=(list nod)
          vis=(map nod med)
      ==
  ^-  (map nod med)
  ?~  nodes
    vis
  %=  $
    nodes  t.nodes
    vis  (trav i.nodes vis)
  ==
::
:: check if there is a path from src to dst
++  check-path
  |=  [src=nid:gol dst=nid:gol dir=?(%l %r)]
  ^-  ?
  ?<  =(src dst)
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  ginn  (ginn nid:gol ?)
  =.  ginn
    %=  ginn
      flow  |=(=nid:gol ~(tap in (flo nid)))  :: inflow or outflow
      init  |=(=nid:gol (~(has in (flo nid)) dst))  :: check for dst
      stop  |=([nid:gol out=?] out)  :: stop on true
      meld  |=([nid:gol nid:gol a=? b=?] |(a b))
      :: prnt  print-nid
    ==
  (((traverse nid:gol ? ?) ginn ~) src)
::
:: if output is ~, cannot reach dst from source in this direction
:: if output is [~ ~], no legal cut exists between src and dst
:: if output is [~ non-empty-set-of-ids], this is the legal cut between
::   src and dst which is nearest to src
++  first-legal-cut
  |=  legal=$-(edge:gol ?)
  |=  [src=nid:gol dst=nid:gol dir=?(%l %r)]
  ^-  (unit edges:gol)
  ?<  =(src dst)
  =/  flo  ?-(dir %l iflo, %r oflo)
  :: 
  :: swap order according to traversal direction
  =/  pear  |*([a=* b=*] `(pair _a _a)`?-(dir %l [b a], %r [a b]))
  :: might not exist
  :: first get a full visited map of all the paths from src to dst
  :: get all 
  =/  ginn  (ginn nid:gol (unit edges:gol))
  =.  ginn
    %=  ginn
      flow  |=(=nid:gol ~(tap in (flo nid)))  :: inflow or outflow
      init
        |=  =nid:gol
        ?.  (~(has in (flo nid)) dst)
          ::
          :: if dst not in flo, initialize to ~
          :: signifying no path found (yet) from nod to dst
          ~
        ?.  (legal (pear nid dst))
          ::
          :: if has dst in flo but can't legal cut, returns [~ ~]
          :: which signifies a path to dst, but no legal cut
          (some ~)
        ::
        :: if has dst in flo and can legally cut, return legal cut
        :: as cut set
        (some (~(put in *edges:gol) (pear nid dst)))
      ::
      stop  |=([nid:gol out=(unit edges:gol)] =([~ ~] out))
      meld
        |=  $:  nod=nid:gol  neb=nid:gol
                a=(unit (set (pair nid:gol nid:gol)))
                b=(unit (set (pair nid:gol nid:gol)))
            ==
        :: if neb returns ~, ignore it
        ?~  b
          a
        :: if can make legal cut between nod and neb,
        :: put nod / neb cut with existing cuts instead of u.b.
        :: the nearest-to-nod legal cut between nod and dst
        :: passing through neb is given by nod / neb
        ?:  (legal (pear nod neb))
          ?~  a
            (some (~(put in *edges:gol) (pear nod neb)))
          (some (~(put in u.a) (pear nod neb)))
        :: if u.b is ~ and we cannot make a legal cut nod / neb,
        :: return [~ ~]; there are no legal cuts between nod and dst
        ?:  =(~ u.b)
          (some ~)
        :: if u.b is non-empty and we cannot make legal cut nod / neb,
        :: add u.b to existing edges
        :: the nearest-to-nod legal cut between nod and dst
        :: passing through neb is given in u.b
        ?~  a
          (some (~(uni in *edges:gol) u.b))
        (some (~(uni in u.a) u.b))
      ::
      :: prnt  print-nid
    ==
  (((traverse nid:gol (unit edges:gol) (unit edges:gol)) ginn ~) src)
::
:: set of neighbors on path from src to dst
++  step-stones
  |=  [src=nid:gol dst=nid:gol dir=?(%l %r)]
  ^-  (set nid:gol)
  ?<  =(src dst)
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  gine  (gine nid:gol ? (set nid:gol))
  =.  gine
    %=  gine
      flow  |=(=nid:gol ~(tap in (flo nid)))
      init  |=(=nid:gol (~(has in (flo nid)) dst)) :: check for dst
      ::
      :: never stop for immediate neighbors of src
      stop  |=([=nid:gol out=?] ?:(=(nid src) %.n out))
      meld  |=([nid:gol nid:gol a=? b=?] |(a b))
      ::
      :: get neighbors which return true (have path to dst)
      exit
        |=  [=nid:gol vis=(map nid:gol ?)]
        %-  ~(gas in *(set nid:gol))
        %+  murn
          ~(tap in (flo nid))
        |=  =nid:gol
        ?:  (~(got by vis) nid)
          ~
        (some nid)
    ==
  (((traverse nid:gol ? (set nid:gol)) gine ~) src)
::
++  plyt  |=(=gid:gol done.i.status:(got-node:nd e+gid))
++  nolp  |=(=gid:gol !done.i.status:(got-node:nd e+gid))
::
++  done  |=(=nid:gol done.i.status:(got-node:nd nid))
++  nond  |=(=nid:gol !done.i.status:(got-node:nd nid))
::
:: for use with %[un]mark-complete
:: check if there are any uncompleted goals to the left OR
:: check if there are any completed goals to the right
++  get-plete
  |=  dir=?(%l %r)
  |=  =gid:gol
  ^-  ?
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  pyt  ?-(dir %l nolp, %r plyt)
  =/  ginn  (ginn nid:gol ?)
  =.  ginn
    %=  ginn
      flow  |=(=nid:gol ~(tap in (flo nid)))
      ::
      :: check end completion in the flo
      init  |=(=nid:gol &(=(-.nid %e) !=(gid gid.nid) (pyt gid.nid)))
      stop  |=([nid:gol out=?] out)  :: stop on true
      meld  |=([nid:gol nid:gol a=? b=?] |(a b))
    ==
  (((traverse nid:gol ? ?) ginn ~) [%e gid]) :: start at end
::
++  ryte-completed    (get-plete %r)
++  left-uncompleted  (get-plete %l)
::
:: for use with %[un]mark-done
:: check if there are any undone nodes to the left OR
:: check if there are any done nodes to the right
++  check-done-trail
  |=  dir=?(%l %r)
  |=  nod=nid:gol
  ^-  ?
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  don  ?-(dir %l nond, %r done)
  =/  ginn  (ginn nid:gol _|)
  =.  ginn
    %=  ginn
      flow  |=(=nid:gol ~(tap in (flo nid)))
      ::
      :: check doneness of nodes in the flow
      init  |=(=nid:gol &(!=(nod nid) (don nid)))
      stop  |=([nid:gol out=_|] out)  :: stop on true
      meld  |=([nid:gol nid:gol a=_| b=_|] |(a b))
    ==
  (((traverse nid:gol _| _|) ginn ~) nod)
::
++  right-done   (check-done-trail %r)
++  left-undone  (check-done-trail %l)
::
++  plete-visit
  |=  dir=?(%l %r)
  |=  [=nid:gol vis=(map nid:gol (unit ?))]
  ^-  (map nid:gol (unit ?))
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  pyt  ?-(dir %l nolp, %r plyt)
  =/  gine  (gine nid:gol (unit ?) (map nid:gol (unit ?)))
  =.  gine
    %=  gine
      flow  |=(=nid:gol ~(tap in (flo nid)))
      init  |=(nid:gol (some %.n))
      stop  |=([nid:gol out=(unit ?)] =(~ out))
      meld  
        |=  [nid:gol nid:gol a=(unit ?) b=(unit ?)]
        ?~  a  ~
        ?~  b  ~
        (some |(u.a u.b))
      land
        |=  [=nid:gol out=(unit ?) ?]
        ?~  out  ~
        ?:  =(%s -.nid)
          out
        ?:  (pyt gid.nid) :: %l: if I am incomplete
          (some %.y)     :: %l: return that there is left-incomplete
        ?:  u.out  ~     :: %l: if I am complete and there is left-incomplete
        (some %.n)       :: %l: else return that there is no left-incomplete
      exit  |=([=nid:gol vis=(map nid:gol (unit ?))] vis)
    ==
  (((traverse nid:gol (unit ?) (map nid:gol (unit ?))) gine vis) nid)
::
++  done-visit
  |=  dir=?(%l %r)
  |=  [=nid:gol vis=(map nid:gol (unit ?))]
  ^-  (map nid:gol (unit ?))
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  don  ?-(dir %l nond, %r done)
  =/  gine  (gine nid:gol (unit ?) (map nid:gol (unit ?)))
  =.  gine
    %=  gine
      flow  |=(=nid:gol ~(tap in (flo nid)))
      init  |=(nid:gol (some %.n))
      stop  |=([nid:gol out=(unit ?)] =(~ out))
      meld  
        |=  [nid:gol nid:gol a=(unit ?) b=(unit ?)]
        ?~  a  ~
        ?~  b  ~
        (some |(u.a u.b))
      land
        |=  [=nid:gol out=(unit ?) ?]
        ?~  out  ~    :: %l: propagate failure
        ?:  (don nid) :: %l: if I am undone
          (some %.y)  :: %l: return that there is left-undone
        ?:  u.out  ~  :: %l: if I am done and there is left-undone, fail
        (some %.n)    :: %l: else return that there is no left-undone
      exit  |=([=nid:gol vis=(map nid:gol (unit ?))] vis)
    ==
  (((traverse nid:gol (unit ?) (map nid:gol (unit ?))) gine vis) nid)
:: get set of all ids whose start/end precedes a given node
::
++  precedents
  |=  kd=?(%s %e)
  |=  [=nid:gol vis=(map nid:gol (set gid:gol))]
  ^-  (map nid:gol (set gid:gol))
  =/  gine  (gine nid:gol (set gid:gol) (map nid:gol (set gid:gol)))
  =.  gine
    %=  gine
      init
        |=  =nid:gol
        %-  ~(gas in *(set gid:gol))
        %+  murn  ~(tap in (iflo nid))
        |=  =nid:gol
        ?.  =(kd -.nid)
          ~
        (some gid.nid)
      flow  |=(=nid:gol ~(tap in (iflo nid)))
      meld  |=([nid:gol nid:gol a=(set gid:gol) b=(set gid:gol)] (~(uni in a) b))
      land  |=([=nid:gol out=(set gid:gol) ?] out)
      exit  |=([=nid:gol vis=(map nid:gol (set gid:gol))] vis)
    ==
  (((traverse nid:gol (set gid:gol) (map nid:gol (set gid:gol))) gine vis) nid)
:: Get ids whose bef comes before an gid aft
:: (ie all ids whose ends precede an ids start)
::
++  precedents-map
  |=  [bef=?(%s %e) aft=?(%s %e)]
  ^-  (map gid:gol (set gid:gol))
  %-  ~(gas by *(map gid:gol (set gid:gol)))
  %+  murn
    %~  tap  by
    ((chain nid:gol (set gid:gol)) (precedents bef) (root-nodes:nd) ~)
  |=  [=nid:gol precs=(set gid:gol)]
  ?.  =(aft -.nid)  ~
  (some [gid.nid precs])
:: force a list of ids to be topologically sorted
::
++  topological-sort
  |=  $:  typ=?(%p %s %e)
          precs=(map gid:gol (set gid:gol))
          ids=(list gid:gol)
      ==
  ^-  (list gid:gol)
  |^
  =.  precs  purge :: only keep ids in list
  |-  ^-  (list gid:gol)
  ?:  =(~ precs)  ~
  :-  first
  $(precs (evict first))
  ++  ranks
    ^-  (map gid:gol @)
    =|  idx=@
    %-  ~(gas by *(map gid:gol @))
    |-  ^-  (list [gid:gol @])
    ?~  ids  ~
    :-  [i.ids idx]
    $(idx +(idx), ids t.ids)
  ++  evict
    |=  =gid:gol
    ^-  (map gid:gol (set gid:gol))
    %-  ~(gas by *(map gid:gol (set gid:gol)))
    %+  murn  ~(tap by precs)
    |=  [=gid:gol =(set gid:gol)]
    ?:  =(gid ^gid)  ~
    (some [gid (~(del in set) ^gid)])
  ++  purge
    =/  del=(list gid:gol)
      ~(tap in (~(dif in ~(key by goals)) (sy ids)))
    |-  ?~  del  precs
    $(del t.del, precs (evict i.del))
  ++  outer
    ^-  (list gid:gol)
    %+  murn  ~(tap by precs)
    |=  [=gid:gol =(set gid:gol)]
    ?.(=(~ set) ~ (some gid))
  ++  ranks-lth
    |=  [=gid:gol ac=gid:gol]
    ^-  gid:gol
    =/  i=@  (~(got by ranks) gid)
    =/  a=@  (~(got by ranks) ac)
    ?:((lth i a) gid ac)
  ++  k-lth
    |=  [=gid:gol ac=gid:gol]
    ^-  gid:gol
    =/  im  moment.start:(~(got by goals) gid)
    =/  am  moment.start:(~(got by goals) ac)
    ?:  =(im am)  (ranks-lth gid ac)
    ?~(im gid ?~(am ac ?:((lth u.im u.am) gid ac)))
  ++  d-lth
    |=  [=gid:gol ac=gid:gol]
    ^-  gid:gol
    =/  im  moment.end:(~(got by goals) gid)
    =/  am  moment.end:(~(got by goals) ac)
    ?:  =(im am)  (ranks-lth gid ac)
    ?~(am gid ?~(im ac ?:((lth u.im u.am) gid ac)))
  ++  first
    ^-  gid:gol
    =/  outer=(list gid:gol)  outer
    ?>  ?=(^ outer)
    %+  roll  t.outer
    |:  [gid=`gid:gol`i.outer ac=`gid:gol`i.outer]
    ?-  typ
      %p  (ranks-lth gid ac)
      %s  (k-lth gid ac)
      %e  (d-lth gid ac)
    ==
  --
::
++  fix-list
  |=  [old=(list gid:gol) new=(set gid:gol)]
  ^-  (list gid:gol)
  %+  weld
    :: add fresh ids to front
    ~(tap in (~(dif in new) (sy old)))
  :: remove stale ids
  |-  ^-  (list gid:gol)
  ?~  old  ~
  ?.  (~(has in new) i.old)
    $(old t.old)
  [i.old $(old t.old)]
::
++  fix-list-and-sort
  |=  $:  typ=?(%p %s %e)
          precs=(map gid:gol (set gid:gol))
          old=(list gid:gol)
          new=(set gid:gol)
      ==
  ^-  (list gid:gol)
  ::  add fresh ids to front and sort
  %^    topological-sort
      typ
    precs
  (fix-list old new)
::
:: get uncompleted leaf goals whose ends are left of nid
++  harvests
  |=  [=nid:gol vis=(map nid:gol (set gid:gol))]
  ^-  (map nid:gol (set gid:gol))
  =/  gine  (gine nid:gol (set gid:gol) (map nid:gol (set gid:gol)))
  =.  gine
    %=  gine
      ::
      :: incomplete inflow
      flow
        |=  =nid:gol
        %+  murn
          ~(tap in (iflo nid))
        |=  =nid:gol
        ?:  (plyt gid.nid)
          ~
        (some nid)
      ::
      meld  |=([nid:gol nid:gol a=(set gid:gol) b=(set gid:gol)] (~(uni in a) b))
      ::
      :: harvest
      land
        |=  [=nid:gol out=(set gid:gol) ?]
        ::
        :: a completed goal has no harvest
        ?:  (plyt gid.nid)
          ~
        ::
        :: in general, the harvest of a node is the union of the
        ::   harvests of its immediate inflow
        :: a end with an otherwise empty harvest
        ::   returns itself as its own harvest if it is actionable
        ?.  &(=(~ out) =(%e -.nid) actionable:(~(got by goals) gid.nid))
          out
        (~(put in *(set gid:gol)) gid.nid)
      exit  |=([=nid:gol vis=(map nid:gol (set gid:gol))] vis)
    ==
  ::
  :: work backwards from end
  (((traverse nid:gol (set gid:gol) (map nid:gol (set gid:gol))) gine vis) nid)
::
++  harvest
  |=(=gid:gol `(set gid:gol)`(~(got by (harvests [%e gid] ~)) [%e gid]))
::
++  goals-harvest
  |=  root-nodes=(list nid:gol)
  ^-  (set gid:gol)
  =/  vis=(map nid:gol (set gid:gol))
    ((chain nid:gol (set gid:gol)) harvests root-nodes ~)
  =|  harvest=(set gid:gol)
  |-  ?~  root-nodes  harvest
  %=  $
    root-nodes  t.root-nodes
    harvest     (~(uni in harvest) (~(got by vis) i.root-nodes))
  ==
::
++  ordered-harvest
  |=  [=gid:gol order=(list gid:gol)]
  ^-  (list gid:gol)
  (fix-list-and-sort %p (precedents-map %e %s) order (harvest gid))
::
++  ordered-goals-harvest
  |=  order=(list gid:gol)
  ^-  (list gid:gol)
  %:  fix-list-and-sort
      %p     (precedents-map %e %s)
      order  (goals-harvest (root-nodes:nd))
  ==
::
++  custom-roots-ordered-goals-harvest
  |=  [roots=(list gid:gol) order=(list gid:gol)]
  ^-  (list gid:gol)
  %:  fix-list-and-sort
      %p     (precedents-map %e %s)
      order  (goals-harvest (turn roots (lead %e)))
  ==
::
:: get priority of a given goal - highest priority is 0
:: priority is the number of unique goals which must be started
:: before the given goal is started
++  priority
  |=  =gid:gol
  ^-  @
  =/  gine  (gine nid:gol (set gid:gol) @)
  =.  gine
    %=  gine
      flow  |=(=nid:gol ~(tap in (iflo nid)))  :: inflow
      ::
      :: all inflows
      init
        |=  =nid:gol
        %-  ~(gas in *(set gid:gol))
        %+  turn
          ~(tap in (iflo nid))
        |=(=nid:gol gid.nid)
      ::
      meld  |=([nid:gol nid:gol a=(set gid:gol) b=(set gid:gol)] (~(uni in a) b))
      exit
        |=  [=nid:gol vis=(map nid:gol (set gid:gol))]
        ~(wyt in (~(got by vis) nid))  :: get count of priors
    ==
  ::
  :: work backwards from start
  (((traverse nid:gol (set gid:gol) @) gine ~) [%s gid])
::
:: highest to lowest priority (highest being smallest number)
++  hi-to-lo
  |=  lst=(list gid:gol)
  %+  sort  lst
  |=  [a=gid:gol b=gid:gol]
  (lth (priority a) (priority b))
::
++  get-bounds
  |=  dir=?(%l %r)
  |=  [=nid:gol vis=(map nid:gol moment:gol)]
  ^-  (map nid:gol moment:gol)
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  cmp  ?-(dir %l gth, %r lth)
  =/  gine  (gine nid:gol moment:gol (map nid:gol moment:gol))
  =.  gine
    %=  gine
      init  |=(=nid:gol ~)
      flow  |=(=nid:gol ~(tap in (flo nid)))
      meld 
        |=  [nid:gol neb=nid:gol a=moment:gol b=moment:gol]
        =/  nem  moment:(got-node:nd neb)
        =/  n
          ?~  b  nem
          ?~  nem  b
          ?.((cmp u.b u.nem) nem ~|("bound-mismatch" !!))
        ?~  a  n
        ?~  n  a
        ?:((cmp u.a u.n) a n)
      ::
      exit  |=([=nid:gol vis=(map nid:gol moment:gol)] vis)
    ==
  (((traverse nid:gol moment:gol (map nid:gol moment:gol)) gine vis) nid)
::
++  bound-visit
  |=  dir=?(%l %r)
  |=  [=nid:gol vis=(map nid:gol (unit moment:gol))]
  ^-  (map nid:gol (unit moment:gol))
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  tem  ?-(dir %l max, %r min)  :: extremum
  =/  gine  (gine nid:gol (unit moment:gol) (map nid:gol (unit moment:gol)))
  =.  gine
    %=  gine
      flow  |=(=nid:gol ~(tap in (flo nid)))
      init  |=(=nid:gol (some ~))
      stop  |=([nid:gol out=(unit moment:gol)] =(~ out))  :: stop if null
      meld
        |=  [nid:gol nid:gol out=(unit moment:gol) new=(unit moment:gol)]
        :: 
        :: if out or new has failed, return failure
        ?~  out  ~
        ?~  new  ~
        ::
        :: if either moment of out or new is null, return the other
        ?~  u.out  new
        ?~  u.new  out
        ::
        :: else return the extremum
        (some (some (tem u.u.out u.u.new)))
      ::
      land
        |=  [nid:gol out=(unit moment:gol) ?]
        ::
        :: if out has failed, return failure
        ?~  out  ~
        ::
        =/  mot  moment:(got-node:nd nid)
        ?~  mot  out :: if moment is null, pass along bound
        ?~  u.out  (some mot)
        =/  tem  (tem u.mot u.u.out)
        ?.  =(u.mot tem)
          ~ :: if moment is not extremum, fail (return null)
        (some (some tem)) :: else return new bound
      ::
      exit  |=([=nid:gol vis=(map nid:gol (unit moment:gol))] vis)
    ==
  %.  nid  %.  [gine vis]
  (traverse nid:gol (unit moment:gol) (map nid:gol (unit moment:gol)))
::
:: length of longest path to root or leaf
++  plomb
  |=  dir=?(%l %r)
  |=  [=nid:gol vis=(map nid:gol @)]
  ^-  (map nid:gol @)
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  gine  (gine nid:gol @ (map nid:gol @))
  =.  gine
    %=  gine
      flow  |=(=nid:gol ~(tap in (flo nid)))
      meld  |=([nid:gol nid:gol a=@ b=@] (max a b))
      land  |=([nid:gol out=@ ?] +(out))
      exit  |=([=nid:gol vis=(map nid:gol @)] vis)
    ==
  (((traverse nid:gol @ (map nid:gol @)) gine vis) nid)
::
:: get depth of a given goal (lowest level is depth of 1)
:: this is mostly for printing accurate level information in the CLI
++  plumb
  |=  =gid:gol
  ^-  @
  =/  ginn  (ginn nid:gol @)
  =.  ginn
    %=  ginn
      flow  |=(=nid:gol ~(tap in (yong:nd nid)))
      meld  |=([nid:gol nid:gol a=@ b=@] (max a b))
      land  |=([nid:gol out=@ ?] +(out))
    ==
  (((traverse nid:gol @ @) ginn ~) [%e gid])
::
:: all nodes left or right of a given node including self
++  to-ends
  |=  [=nid:gol dir=?(%l %r)]
  ^-  (set nid:gol)
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  ginn  (ginn nid:gol (set nid:gol))
  =.  ginn
    %=  ginn
      flow  |=(=nid:gol ~(tap in (flo nid)))
      init  |=(=nid:gol (~(put in *(set nid:gol)) nid))
      meld  |=([nid:gol nid:gol a=(set nid:gol) b=(set nid:gol)] (~(uni in a) b))
    ==
  (((traverse nid:gol (set nid:gol) (set nid:gol)) ginn ~) nid)
::
:: all descendents including self
++  progeny
  |=  =gid:gol
  ^-  (set gid:gol)
  =/  ginn  (ginn gid:gol (set gid:gol))
  =.  ginn
    %=  ginn
      flow  |=(=gid:gol children:(~(got by goals) gid))
      init  |=(=gid:gol (~(put in *(set gid:gol)) gid))
      meld  |=([gid:gol gid:gol a=(set gid:gol) b=(set gid:gol)] (~(uni in a) b))
    ==
  (((traverse gid:gol (set gid:gol) (set gid:gol)) ginn ~) gid)
::
:: all descendents including self
++  virtual-progeny
  |=  =gid:gol
  ^-  (set gid:gol)
  =/  ginn  (ginn gid:gol (set gid:gol))
  =.  ginn
    %=  ginn
      flow  |=(=gid:gol ~(tap in (young:nd gid)))
      init  |=(=gid:gol (~(put in *(set gid:gol)) gid))
      meld  |=([gid:gol gid:gol a=(set gid:gol) b=(set gid:gol)] (~(uni in a) b))
    ==
  (((traverse gid:gol (set gid:gol) (set gid:gol)) ginn ~) gid)
::
++  replace-chief
  |=  [kick=(set ship) owner=ship]
  |=  [=gid:gol vis=(map gid:gol ship)]
  ^-  (map gid:gol ship)
  =/  gaso  [gid:gol ship (map gid:gol ship)]
  =/  gine  (gine gaso)
  =.  gine
    %=  gine
      flow  |=(=gid:gol =/(parent parent:(~(got by goals) gid) ?~(parent ~ [u.parent]~)))
      init  |=(=gid:gol chief:(~(got by goals) gid))
      stop  |=([gid:gol =ship] !(~(has in kick) ship)) :: stop if not in kick set
      meld  |=([gid:gol gid:gol a=ship b=ship] b)
      land  |=([=gid:gol =ship cnd=?] ?:(cnd ship owner)) :: if not in kick set
    ==
  (((traverse gaso) gine vis) gid)
::
:: smol helpers
++  anchor  |.(+((roll (turn (root-goals:nd) plumb) max)))
::
++  left-bound  |=(=nid:gol (~(got by ((get-bounds %l) nid ~)) nid))
++  ryte-bound  |=(=nid:gol (~(got by ((get-bounds %r) nid ~)) nid))
++  left-plumb  |=(=nid:gol (~(got by ((plomb %l) nid ~)) nid))
++  ryte-plumb  |=(=nid:gol (~(got by ((plomb %r) nid ~)) nid))
--
