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
      %harvest
    =/  harvest=(list id:gol)
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
        =/  tv  ~(. gol-cli-traverse goals.pool)
        (ordered-goals-harvest:tv order.local.store)
        ::
          %goal
        =/  =pool:gol       (~(got by pools.store) pin.id.type.vyu)
        =/  tv  ~(. gol-cli-traverse goals.pool)
        (ordered-harvest:tv id.type.vyu order.local.store)
      ==
    %-  pure:m  !>
    :-  %harvest
    %+  turn  harvest
    |=  =id:gol
    =/  =pool:gol           ~+((~(got by pools.store) pin.id))
    =/  =pool-data:gol      ~+((~(got by pool-info.store) pin.id))
    =+  (~(got by goals.pool) id)
    :*  id
        summary
        done.deadline
        actionable
        ~(tap in (~(gut by tags.pool-data) id ~))
    ==
    ::
      %pools-index
    %-  pure:m  !>
    :-  %pools-index
    %+  turn  ~(tap by pools.store)
    |=  [=pin:gol =pool:gol]
    [pin title.pool]
    ::
      %pool-roots
    =/  =pool:gol       (~(got by pools.store) pin.vyu)
    =/  =pool-data:gol  (~(got by pool-info.store) pin.vyu)
    %-  pure:m  !>
    :-  %pool-roots
    %+  turn  roots.pool
    |=  =id:gol
    =+  (~(got by goals.pool) id)
    :*  id
        summary
        done.deadline
        actionable
        ~(tap in (~(gut by tags.pool-data) id ~))
    ==
    ::
      %goal-young
    =/  =pool:gol       (~(got by pools.store) pin.id.vyu)
    =/  =pool-data:gol  (~(got by pool-info.store) pin.id.vyu)
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
        ~(tap in (~(gut by tags.pool-data) id ~))
    ==
    ::
      %pool-title
    =/  =pool:gol       (~(got by pools.store) pin.vyu)
    (pure:m !>([%cord title.pool]))
    ::
      %pool-note
    =/  =pool:gol       (~(got by pools.store) pin.vyu)
    =/  =pool-data:gol  (~(got by pool-info.store) pin.vyu)
    (pure:m !>([%cord (~(gut by properties.pool-data) 'note' '')]))
    ::
      %pool-tag-note
    =/  =pool:gol       (~(got by pools.store) pin.vyu)
    =/  =pool-data:gol  (~(got by pool-info.store) pin.vyu)
    =/  properties      (~(gut by tag-properties.pool-data) tag.vyu ~)
    (pure:m !>([%cord (~(gut by properties) 'note' '')]))
    ::
      %goal-summary
    =/  =pool:gol       (~(got by pools.store) pin.id.vyu)
    =/  =goal:gol       (~(got by goals.pool) id.vyu)
    (pure:m !>([%cord summary.goal]))
    ::
      %goal-note
    =/  =pool:gol       (~(got by pools.store) pin.id.vyu)
    =/  =pool-data:gol  (~(got by pool-info.store) pin.id.vyu)
    =/  fields=(map @t @t)  (~(gut by fields.pool-data) id.vyu ~)
    (pure:m !>([%cord (~(gut by fields) 'note' '')]))
    ::
      %setting
    (pure:m !>([%ucord (~(get by settings.local.store) setting.vyu)]))
    ::
      %goal-tags
    =/  =pool:gol       (~(got by pools.store) pin.id.vyu)
    =/  =pool-data:gol  (~(got by pool-info.store) pin.id.vyu)
    =/  tags=(set @t)   (~(gut by tags.pool-data) id.vyu ~)
    (pure:m !>([%tags tags]))
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
    =/  =pool-data:gol  (~(got by pool-info.store) pin.vyu)
    =/  vals  ~(val by tags.pool-data)
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
