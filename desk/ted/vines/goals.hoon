/-  gol=goals, axn=action, pyk=peek, spider
/+  *ventio, tree=filetree, gol-cli-traverse, gol-cli-node
=,  strand=strand:spider
^-  thread:spider
::
=<
::
%-  vine-thread
%-  vine:tree
|=  [=gowl vid=vent-id =mark =vase]
=/  m  (strand ,^vase)
^-  form:m
?>  |(=(our src):gowl (moon:title [our src]:gowl))
~?  >>  (moon:title [our src]:gowl)
  "%goals: moon access from {(scow %p src.gowl)}"
?+    mark  (just-poke [our dap]:gowl mark vase) :: poke normally
    %goal-view
  =+  !<(vyu=goal-view:axn vase)
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  ?-    -.vyu
      %pool-roots
    =/  =pool:gol       (~(got by pools.store) pin.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pin.vyu)
    %-  pure:m  !>
    :-  %pool-roots
    %+  turn  roots.pool
    |=  =id:gol
    =+  (~(got by goals.pool) id)
    :*  id
        summary
        done.deadline
        actionable
        ?~(pd ~ ~(tap in (~(gut by tags.u.pd) id ~)))
    ==
    ::
      %goal-young
    =/  =pool:gol       (~(got by pools.store) pin.id.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pin.id.vyu)
    =/  =goal:gol       (~(got by goals.pool) id.vyu)
    %-  pure:m  !>
    :-  %goal-young
    %+  turn  young.goal
    |=  =id:gol
    =+  (~(got by goals.pool) id)
    :*  id
        virtual=(~(has in kids.goal) id)
        summary
        done.deadline
        actionable
        ?~(pd ~ ~(tap in (~(gut by tags.u.pd) id ~)))
    ==
    ::
      %harvest
    =/  harvest=(list id:gol)
      ?-    -.type.vyu
          %main
        =/  all-goals=goals:gol  (all-goals store)
        =/  tv  ~(. gol-cli-traverse all-goals)
        (ordered-goals-harvest:tv goal-order.local.store)
        ::
          %pool
        =/  =pool:gol       (~(got by pools.store) pin.type.vyu)
        =/  tv  ~(. gol-cli-traverse goals.pool)
        (ordered-goals-harvest:tv goal-order.local.store)
        ::
          %goal
        =/  =pool:gol       (~(got by pools.store) pin.id.type.vyu)
        =/  tv  ~(. gol-cli-traverse goals.pool)
        (ordered-harvest:tv id.type.vyu goal-order.local.store)
      ==
    %-  pure:m  !>
    :-  %harvest
    %+  turn  harvest
    |=  =id:gol
    =/  =pool:gol           ~+((~(got by pools.store) pin.id))
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pin.id)
    =+  (~(got by goals.pool) id)
    :*  id
        summary
        done.deadline
        actionable
        ?~(pd ~ ~(tap in (~(gut by tags.u.pd) id ~)))
    ==
    ::
      %pool-tag-goals
    =/  =pool:gol       (~(got by pools.store) pin.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pin.vyu)
    =/  tag-goals=(list id:gol)
      ?~  pd  ~
      %+  murn  ~(tap by tags.u.pd)
      |=  [=id:gol tags=(set @t)]
      ?.  &((~(has by goals.pool) id) (~(has in tags) tag.vyu))
        ~
      `id
    %-  pure:m  !>
    :-  %pool-tag-goals
    %+  turn  tag-goals
    |=  =id:gol
    =+  (~(got by goals.pool) id)
    :*  id
        summary
        done.deadline
        actionable
        ?~(pd ~ ~(tap in (~(gut by tags.u.pd) id ~)))
    ==
    ::
      %pool-tag-harvest
    =/  =pool:gol       (~(got by pools.store) pin.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pin.vyu)
    =/  tag-goals=(list id:gol)
      ?~  pd  ~
      %+  murn  ~(tap by tags.u.pd)
      |=  [=id:gol tags=(set @t)]
      ?.  &((~(has by goals.pool) id) (~(has in tags) tag.vyu))
        ~
      `id
    =/  harvest=(list id:gol)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      (custom-roots-ordered-goals-harvest:tv tag-goals goal-order.local.store)
    %-  pure:m  !>
    :-  %pool-tag-goals
    %+  turn  harvest
    |=  =id:gol
    =+  (~(got by goals.pool) id)
    :*  id
        summary
        done.deadline
        actionable
        ?~(pd ~ ~(tap in (~(gut by tags.u.pd) id ~)))
    ==
    ::
      %pools-index
    %-  pure:m  !>
    :-  %pools-index
    %+  turn  pool-order.local.store
    |=(=pin:gol [pin title:(~(got by pools.store) pin)])
    ::
      %pool-title
    =/  =pool:gol       (~(got by pools.store) pin.vyu)
    (pure:m !>([%cord title.pool]))
    ::
      %pool-note
    =/  =pool:gol       (~(got by pools.store) pin.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pin.vyu)
    (pure:m !>([%cord (~(gut by ?~(pd ~ properties.u.pd)) 'note' '')]))
    ::
      %pool-tag-note
    =/  =pool:gol       (~(got by pools.store) pin.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pin.vyu)
    =/  properties      (~(gut by ?~(pd ~ tag-properties.u.pd)) tag.vyu ~)
    (pure:m !>([%cord (~(gut by properties) 'note' '')]))
    ::
      %goal-summary
    =/  =pool:gol       (~(got by pools.store) pin.id.vyu)
    =/  =goal:gol       (~(got by goals.pool) id.vyu)
    (pure:m !>([%cord summary.goal]))
    ::
      %goal-note
    =/  =pool:gol       (~(got by pools.store) pin.id.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pin.id.vyu)
    =/  fields=(map @t @t)  (~(gut by ?~(pd ~ fields.u.pd)) id.vyu ~)
    (pure:m !>([%cord (~(gut by fields) 'note' '')]))
    ::
      %setting
    (pure:m !>([%ucord (~(get by settings.local.store) setting.vyu)]))
    ::
      %goal-tags
    =/  =pool:gol       (~(got by pools.store) pin.id.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pin.id.vyu)
    =/  tags=(set @t)   (~(gut by ?~(pd ~ tags.u.pd)) id.vyu ~)
    (pure:m !>([%tags tags]))
    ::
      %local-goal-tags
    (pure:m !>([%tags `(set @t)`(~(gut by tags.local.store) id.vyu ~)]))
    ::
      %goal-parent
    =/  =pool:gol  (~(got by pools.store) pin.id.vyu)
    =/  =goal:gol  (~(got by goals.pool) id.vyu)
    (pure:m !>([%uid par.goal]))
    ::
      %goal-actionable
    =/  =pool:gol  (~(got by pools.store) pin.id.vyu)
    =/  =goal:gol  (~(got by goals.pool) id.vyu)
    (pure:m !>([%loob actionable.goal]))
    ::
      %goal-complete
    =/  =pool:gol  (~(got by pools.store) pin.id.vyu)
    =/  =goal:gol  (~(got by goals.pool) id.vyu)
    (pure:m !>([%loob actionable.goal]))
    ::
      %pool-tags
    =/  =pool:gol       (~(got by pools.store) pin.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pin.vyu)
    =/  vals  ~(val by ?~(pd ~ tags.u.pd))
    =|  tags=(set @t)
    |-
    ?~  vals
      (pure:m !>([%tags tags]))
    $(vals t.vals, tags (~(uni in tags) i.vals))
    ::
      %all-local-goal-tags
    =/  vals  ~(val by tags.local.store)
    =|  tags=(set @t)
    |-
    ?~  vals
      (pure:m !>([%tags tags]))
    $(vals t.vals, tags (~(uni in tags) i.vals))
  ==
==
::
|%
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
