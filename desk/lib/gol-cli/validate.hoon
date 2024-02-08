/-  gol=goals
/+  *gol-cli-util, gol-cli-node, gol-cli-traverse
:: TODO: confirm start and end status timestamps alternate in order
|%
::
++  all-own-edges
  |=  =goals:gol
  ^-  [children=(set (pair gid:gol gid:gol)) parents=(set (pair gid:gol gid:gol))]
  =/  g  ~(tap in goals)
  =|  children=(set (pair gid:gol gid:gol))
  =|  parents=(set (pair gid:gol gid:gol))
  |-
  ?~  g
    [children parents]
  =/  [=gid:gol =goal:gol]  i.g
  %=  $
    g  t.g
    children  
      %-  ~(uni in children)
      ^-  (set (pair gid:gol gid:gol))
      %-  ~(run in children.goal)
      |=(kid=gid:gol [kid gid])
    parents  
      ?~  parent.goal
        parents
      %-  ~(put in parents)
      [gid u.parent.goal]
  ==
::
:: assert children/parent doubly-linked
++  doubly-own-linked  |=(=goals:gol `?`=(children parents):(all-own-edges goals))
::
++  all-dag-edges
  |=  =goals:gol
  ^-  [inflows=(set edge:gol) outflows=(set edge:gol)]
  =/  g  ~(tap in goals)
  =|  inflows=(set edge:gol)
  =|  outflows=(set edge:gol)
  |-
  ?~  g
    [inflows outflows]
  =/  [=gid:gol =goal:gol]  i.g
  =.  inflows
    %-  ~(uni in inflows)
    ^-  (set edge:gol)
    %-  ~(run in inflow.start.goal)
    |=(=nid:gol [nid [%s gid]])
  =.  outflows
    %-  ~(uni in outflows)
    ^-  (set edge:gol)
    %-  ~(run in outflow.start.goal)
    |=(=nid:gol [[%s gid] nid])
  %=  $
    g  t.g
    inflows  
      %-  ~(uni in inflows)
      ^-  (set edge:gol)
      %-  ~(run in inflow.end.goal)
      |=(=nid:gol [nid [%e gid]])
    outflows  
      %-  ~(uni in outflows)
      ^-  (set edge:gol)
      %-  ~(run in outflow.end.goal)
      |=(=nid:gol [[%e gid] nid])
  ==
::
:: assert nodes doubly-linked
++  doubly-dag-linked
  |=(=goals:gol `?`=(inflows outflows):(all-dag-edges goals))
::
::
++  kd-pairs
  |=  =goals:gol
  ^-  ?
  %-  ~(rep by goals)
  |=  [[=gid:gol =goal:gol] all=?]
  ?&  (~(has in outflow.start.goal) [%e gid])
      (~(has in inflow.end.goal) [%s gid])
  ==
::
:: assumes doubly-own-linked and doubly-dag-linked
++  ownership-containment
  |=  =goals:gol
  ^-  ?
  =/  branches  children:(all-own-edges goals)
  %-  ~(all in branches)
  |=  [kid=gid:gol pid=gid:gol]
  ^-  ?
  =/  goal  (~(got by goals) kid)
  ?&  (~(has in inflow.start.goal) [%s pid])
      (~(has in outflow.end.goal) [%e pid])
  ==
::
:: no actionable goal has goals nested below it
++  bare-actionable
  |=  =goals:gol
  ^-  ?
  %-  ~(all by goals)
  |=  =goal:gol
  ^-  ?
  ?.  actionable.goal
    %.y
  =;  kd=(set ?(%s %e))  
    !(~(has in kd) %e)
  %-  ~(run in inflow.end.goal)
  |=(=nid:gol -.nid)
::
++  check-bound-mismatch
  |=  =goals:gol
  ^-  ?
  =/  rn  (~(root-nodes gol-cli-node goals))
  =/  vis
    %:  (~(chain gol-cli-traverse goals) nid:gol (unit moment:gol))
      (~(bound-visit gol-cli-traverse goals) %l)
      rn
      ~
    ==
  =/  ids=(set gid:gol)  (~(run in ~(key by vis)) |=(=nid:gol gid.nid))
  ?.  =(0 ~(wyt in (~(dif in ids) ~(key by goals))))
    ~|("all ids not visited" !!)
  =/  vos=(map nid:gol (unit moment:gol))  (gat-by vis rn)
  (~(all by vos) |=(out=(unit moment:gol) !=(~ out)))
::
++  check-plete-mismatch
  |=  =goals:gol
  ^-  ?
  =/  rn  (~(root-nodes gol-cli-node goals))
  =/  vis
    %:  (~(chain gol-cli-traverse goals) nid:gol (unit ?))
      (~(plete-visit gol-cli-traverse goals) %l)
      rn
      ~
    ==
  =/  ids=(set gid:gol)  (~(run in ~(key by vis)) |=(=nid:gol gid.nid))
  ?.  =(0 ~(wyt in (~(dif in ids) ~(key by goals))))
    ~|("all ids not visited" !!)
  =/  vos=(map nid:gol (unit ?))  (gat-by vis rn)
  (~(all by vos) |=(out=(unit ?) !=(~ out)))
::
++  validate-goals
  |=  =goals:gol
  ^-  goals:gol
  :: assert parent/children doubly-linked
  ?.  (doubly-own-linked goals)
    ~|("ownership not doubly linked" !!)
  :: assert nodes doubly-linked
  ?.  (doubly-dag-linked goals)
    ~|("DAG not doubly linked" !!)
  :: assert corresponding starts and ends are linked
  ?.  (kd-pairs goals)
    ~|("starts not linked to ends" !!)
  :: assert all parent/children relationships reflects containment (held-yoke)
  ?.  (ownership-containment goals)
    ~|("some goals owned but not contained" !!)
  :: assert actionable goals have no children or nested goals
  ?.  (bare-actionable goals)
    ~|("actionable has nested" !!)
  :: assert traversal from roots produces correctly ordered moments
  ?.  (check-bound-mismatch goals)
    ~|("bound-mismatch-fail" !!)
  :: assert no completed end is right of any incomplete end
  ?.  (check-plete-mismatch goals)
    ~|("plete-mismatch-fail" !!)
  goals
--
