/-  gol=goals
|_  store:gol
::
:: create unique goal id based on source ship and creation time
++  unique-id
  |=  [=pin:gol now=@da]
  ^-  id:gol
  =/  =goals:gol  goals:(~(got by pools) pin)
  =/  =id:gol  [pin (scot %da now)]
  ?.  (~(has by goals) id)
    id
  $(now (add now ~s0..0001))
::
:: creating a mapping from old ids to new ids
:: to be used in the process of copying goals
++  new-ids
  |=  [=(list id:gol) =pin:gol now=@da]
  ^-  (map id:gol id:gol)
  =/  idx  0
  =|  =(map id:gol id:gol)
  |-
  ?:  =(idx (lent list))
    map
  =/  new-id  (unique-id pin now)
  %=  $
    idx  +(idx)
    map  (~(put by map) (snag idx list) new-id)
  ==
::
++  clone-goals
  |=  [=goals:gol =pin:gol now=@da]
  ^-  [id-map=(map id:gol id:gol) =goals:gol]
  =/  id-map  (new-ids ~(tap in ~(key by goals)) pin now)
  :-  id-map
  |^
  %-  ~(gas by *goals:gol)
  %+  turn  ~(tap by goals)
  |=  [=id:gol =goal:gol]
  :-  (~(got by id-map) id)
  %=  goal
    par  ?~(par.goal ~ (some (new-id u.par.goal)))
    kids  (new-set-id kids.goal)
    ::
    inflow.kickoff  (new-set-nid inflow.kickoff.goal)
    outflow.kickoff  (new-set-nid outflow.kickoff.goal)
    inflow.deadline  (new-set-nid inflow.deadline.goal)
    outflow.deadline  (new-set-nid outflow.deadline.goal)
  ==
  ++  new-id  |=(=id:gol (~(got by id-map) id))
  ++  new-nid  |=(=nid:gol [-.nid (new-id id.nid)])
  ++  new-set-id  |=(=(set id:gol) (~(run in set) new-id))
  ++  new-set-nid  |=(=(set nid:gol) (~(run in set) new-nid))
  --
--
