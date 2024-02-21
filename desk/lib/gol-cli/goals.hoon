/-  gol=goals
|_  store:gol
::
:: create unique goal gid based on source ship and creation time
++  unique-id
  |=  [=pid:gol now=@da]
  ^-  gid:gol
  =/  =goals:gol  goals:(~(got by pools) pid)
  =/  =gid:gol  (scot %da now)
  ?.  (~(has by goals) gid)
    gid
  $(now (add now ~s0..0001))
::
:: creating a mapping from old ids to new ids
:: to be used in the process of copying goals
++  new-gids
  |=  [=(list gid:gol) =pid:gol now=@da]
  ^-  (map gid:gol gid:gol)
  =/  idx  0
  =|  =(map gid:gol gid:gol)
  |-
  ?:  =(idx (lent list))
    map
  =/  new-gid  (unique-id pid now)
  %=  $
    idx  +(idx)
    map  (~(put by map) (snag idx list) new-gid)
  ==
::
++  clone-goals
  |=  [=goals:gol =pid:gol now=@da]
  ^-  [gid-map=(map gid:gol gid:gol) =goals:gol]
  =/  gid-map  (new-gids ~(tap in ~(key by goals)) pid now)
  :-  gid-map
  |^
  %-  ~(gas by *goals:gol)
  %+  turn  ~(tap by goals)
  |=  [=gid:gol =goal:gol]
  :-  (~(got by gid-map) gid)
  %=  goal
    parent  ?~(parent.goal ~ (some (new-gid u.parent.goal)))
    children  (new-list-gid children.goal)
    ::
    inflow.start  (new-set-nid inflow.start.goal)
    outflow.start  (new-set-nid outflow.start.goal)
    inflow.end  (new-set-nid inflow.end.goal)
    outflow.end  (new-set-nid outflow.end.goal)
  ==
  ++  new-gid  |=(=gid:gol (~(got by gid-map) gid))
  ++  new-nid  |=(=nid:gol [-.nid (new-gid gid.nid)])
  ++  new-list-gid  |=(=(list gid:gol) (turn list new-gid))
  ++  new-set-nid   |=(=(set nid:gol) (~(run in set) new-nid))
  --
--
