/-  gol=goals, axn=action, pyk=peek, spider, jot=json-tree
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
;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
?+    mark  (just-poke [our dap]:gowl mark vase) :: poke normally
    %goal-view
  =+  !<(vyu=goal-view:axn vase)
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
        %+  weld
          %+  turn
            ~(tap in (~(gut by tags.local.store) id ~))
          (lead |)
        %+  turn
          ?~(pd ~ ~(tap in (~(gut by tags.u.pd) id ~)))
        (lead &)
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
        %+  weld
          %+  turn
            ~(tap in (~(gut by tags.local.store) id ~))
          (lead |)
        %+  turn
          ?~(pd ~ ~(tap in (~(gut by tags.u.pd) id ~)))
        (lead &)
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
        %+  weld
          %+  turn
            ~(tap in (~(gut by tags.local.store) id ~))
          (lead |)
        %+  turn
          ?~(pd ~ ~(tap in (~(gut by tags.u.pd) id ~)))
        (lead &)
    ==
    ::
      %pool-tag-goals
    =/  =pool:gol       (~(got by pools.store) pin.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pin.vyu)
    =/  tag-goals=(list id:gol)
      %+  murn  ?~(pd ~ ~(tap by tags.u.pd))
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
        %+  weld
          %+  turn
            ~(tap in (~(gut by tags.local.store) id ~))
          (lead |)
        %+  turn
          ?~(pd ~ ~(tap in (~(gut by tags.u.pd) id ~)))
        (lead &)
    ==
    ::
      %pool-tag-harvest
    =/  =pool:gol       (~(got by pools.store) pin.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pin.vyu)
    =/  tag-goals=(list id:gol)
      %+  murn  ~(tap by ?~(pd ~ tags.u.pd))
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
        %+  weld
          %+  turn
            ~(tap in (~(gut by tags.local.store) id ~))
          (lead |)
        %+  turn
          ?~(pd ~ ~(tap in (~(gut by tags.u.pd) id ~)))
        (lead &)
    ==
    ::
      %local-tag-goals
    =/  tag-goals=(list id:gol)
      %+  murn  ~(tap by tags.local.store)
      |=  [=id:gol tags=(set @t)]
      =/  =pool:gol       (~(got by pools.store) pin.id)
      ?.  &((~(has by goals.pool) id) (~(has in tags) tag.vyu))
        ~
      `id
    %-  pure:m  !>
    :-  %local-tag-goals
    %+  turn  tag-goals
    |=  =id:gol
    =/  =pool:gol       (~(got by pools.store) pin.id)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pin.id)
    =+  (~(got by goals.pool) id)
    :*  id
        summary
        done.deadline
        actionable
        %+  weld
          %+  turn
            ~(tap in (~(gut by tags.local.store) id ~))
          (lead |)
        %+  turn
          ?~(pd ~ ~(tap in (~(gut by tags.u.pd) id ~)))
        (lead &)
    ==
    ::
      %local-tag-harvest
    =/  tag-goals=(list id:gol)
      %+  murn  ~(tap by tags.local.store)
      |=  [=id:gol tags=(set @t)]
      =/  =pool:gol       (~(got by pools.store) pin.id)
      ?.  &((~(has by goals.pool) id) (~(has in tags) tag.vyu))
        ~
      `id
    =/  harvest=(list id:gol)
      =/  tv  ~(. gol-cli-traverse (all-goals store))
      (custom-roots-ordered-goals-harvest:tv tag-goals goal-order.local.store)
    %-  pure:m  !>
    :-  %local-tag-goals
    %+  turn  harvest
    |=  =id:gol
    =/  =pool:gol       (~(got by pools.store) pin.id)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pin.id)
    =+  (~(got by goals.pool) id)
    :*  id
        summary
        done.deadline
        actionable
        %+  weld
          %+  turn
            ~(tap in (~(gut by tags.local.store) id ~))
          (lead |)
        %+  turn
          ?~(pd ~ ~(tap in (~(gut by tags.u.pd) id ~)))
        (lead &)
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
      %local-tag-note
    =/  properties  (~(gut by tag-properties.local.store) tag.vyu ~)
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
    =/  tags=(list (pair ? @t))
      %+  weld
        %+  turn
          ~(tap in (~(gut by tags.local.store) id.vyu ~))
        (lead |)
      %+  turn
        ?~(pd ~ ~(tap in (~(gut by tags.u.pd) id.vyu ~)))
      (lead &)
    (pure:m !>([%tags tags]))
    ::
      %local-goal-tags
    =/  tags=(list (pair ? @t))
      %+  turn
        ~(tap in (~(gut by tags.local.store) id.vyu ~))
      (lead |)
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
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pin.vyu)
    =/  vals  ~(val by ?~(pd ~ tags.u.pd))
    =|  tags=(set @t)
    |-
    ?~  vals
      (pure:m !>([%tags (turn ~(tap in tags) (lead &))]))
    $(vals t.vals, tags (~(uni in tags) i.vals))
    ::
      %all-local-goal-tags
    =/  vals  ~(val by tags.local.store)
    =|  tags=(set @t)
    |-
    ?~  vals
      (pure:m !>([%tags (turn ~(tap in tags) (lead |))]))
    $(vals t.vals, tags (~(uni in tags) i.vals))
  ==
  ::
    %json-tree-action
  =+  !<(act=action:jot vase)
  ?-    -.act
      %put
    ;<  ~  bind:m  (poke [our dap]:gowl json-tree-transition+vase)
    (pure:m !>(~))
    ::
      %del
    ;<  ~  bind:m  (poke [our dap]:gowl json-tree-transition+vase)
    (pure:m !>(~))
    ::
      %read
    =/  jons=(map @ta json)
      (fall (~(get of json-tree.store) (snip path.act)) ~)
    (pure:m !>(json+(~(got by jons) (rear path.act))))
    ::
      %tree
    %-  pure:m
    !>  :-  %tree
    %-  zing
    %+  turn  ~(tap of json-tree.store) 
    |=  [=path =(map @ta json)]
    %+  turn  ~(tap in ~(key by map))
    |=(=@ta (weld path ~[ta]))
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
