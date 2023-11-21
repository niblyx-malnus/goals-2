/-  gol=goals, axn=action, pyk=peek, spider
/+  *ventio, gol-cli-traverse
=,  strand=strand:spider
^-  thread:spider
::
=<
::
%-  vine-thread
|=  [=gowl vid=vent-id =mark =vase]
=/  m  (strand ,^vase)
^-  form:m
?+    mark  (just-poke [our dap]:gowl mark vase) :: poke normally
    %goal-view
  =+  !<(vyu=goal-view:axn vase)
  ;<  =store:gol  bind:m  get-store
  ?-    -.type.vyu
      %main
    :: =/  all-goals=goals:gol  (all-goals store)
    :: =/  tv  ~(. gol-cli-traverse all-goals)
    :: =/  harvest=(list id:gol)
    ::   (ordered-goals-harvest:tv order.local.store)
    !!
    ::
      %pool
    =/  =pool:gol       (~(got by pools.store) pin.type.vyu)
    =/  =pool-data:gol  (~(got by pool-info.store) pin.type.vyu)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  harvest=(list id:gol)
      (ordered-goals-harvest:tv order.local.store)
    %-  pure:m  !>
    :-  %harvest
    %+  turn  harvest
    |=  =id:gol
    =/  fields=(map @t @t)  (~(got by fields.pool-data) id)
    =+  (~(got by goals.pool) id)
    :*  id
        (~(got by fields) 'description')
        done.deadline
        actionable
        ~(tap in (~(gut by tags.pool-data) id ~))
    ==
    ::
      %goal
    =,  pin=pin.id.type.vyu
    =/  =pool:gol       (~(got by pools.store) pin.id.type.vyu)
    =/  =pool-data:gol  (~(got by pool-info.store) pin.id.type.vyu)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  harvest=(list id:gol)
      (ordered-harvest:tv id.type.vyu order.local.store)
    %-  pure:m  !>
    :-  %harvest
    %+  turn  harvest
    |=  =id:gol
    =/  fields=(map @t @t)  (~(got by fields.pool-data) id)
    =+  (~(got by goals.pool) id)
    :*  id
        (~(got by fields) 'description')
        done.deadline
        actionable
        ~(tap in (~(gut by tags.pool-data) id ~))
    ==
  ==
==
::
|%
++  get-store
  =/  m  (strand ,store:gol)
  ^-  form:m
  ~&  %getting-store
  ;<  =peek:pyk  bind:m
    (scry-hard ,peek:pyk /gx/goals/store/noun)
  ?>(?=(%store -.peek) (pure:m store.peek))
::
++  all-goals  
  |=  =store:gol
  ^-  goals:gol
  =/  pools  ~(val by pools.store)
  =|  =goals:gol
  |-  ?~  pools  goals
  %=  $
    pools  t.pools
    goals  (~(uni by goals) goals.i.pools)
  ==
--
