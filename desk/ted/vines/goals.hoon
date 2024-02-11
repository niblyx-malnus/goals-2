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
~&  "%goals vine: receiving mark {(trip mark)}"
;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
?+    mark  (just-poke [our dap]:gowl mark vase) :: poke normally
    %goal-action
  =+  !<(act=action:axn vase)
  ?+    -.act  (just-poke [our dap]:gowl mark vase)
      %create-goal
    =/  old=(set gid:gol)  ~(key by goals:(~(got by pools.store) pid.act))
    ;<  ~  bind:m  (poke [our dap]:gowl mark vase)
    ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
    =/  new=(set gid:gol)  ~(key by goals:(~(got by pools.store) pid.act))
    =/  gid-list=(list gid:gol)  ~(tap in (~(dif in new) old))
    ?>  ?=(^ gid-list)
    ?>  =(1 (lent gid-list))
    (pure:m !>([%uid `i.gid-list]))
  ==
  ::
    %goal-view
  =+  !<(vyu=goal-view:axn vase)
  ?-    -.vyu
      %pool-roots
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.vyu)
    %-  pure:m  !>
    :-  %pool-roots
    %+  turn  (~(waif-goals gol-cli-node goals.pool))
    |=  =gid:gol
    =+  (~(got by goals.pool) gid)
    :*  gid
        summary
        done.i.status.start
        done.i.status.end
        actionable
        %+  weld
          %+  turn
            ~(tap in (~(gut by tags.local.store) [pid.vyu gid] ~))
          (lead |)
        %+  turn
          ?~(pd ~ ~(tap in (~(gut by tags.u.pd) gid ~)))
        (lead &)
    ==
    ::
      %goal-young
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.vyu)
    =/  =goal:gol       (~(got by goals.pool) gid.vyu)
    %-  pure:m  !>
    :-  %goal-young
    %+  turn  ~(tap in (~(young gol-cli-node goals.pool) gid.vyu))
    |=  =gid:gol
    =+  (~(got by goals.pool) gid)
    :*  gid
        virtual=(~(has in children.goal) gid)
        summary
        done.i.status.start
        done.i.status.end
        actionable
        %+  weld
          %+  turn
            ~(tap in (~(gut by tags.local.store) [pid.vyu gid] ~))
          (lead |)
        %+  turn
          ?~(pd ~ ~(tap in (~(gut by tags.u.pd) gid ~)))
        (lead &)
    ==
    ::
      %harvest
    =/  harvest=(list key:gol)
      ?-    -.type.vyu
          %main
        =/  all-goals=goals:gol  (all-goals store)
        =/  tv  ~(. gol-cli-traverse all-goals)
        :: TODO: make all-goals flatten pid into goal ids
        !!
        :: (ordered-goals-harvest:tv goal-order.local.store)
        ::
          %pool
        =/  =pool:gol       (~(got by pools.store) pid.type.vyu)
        =/  tv  ~(. gol-cli-traverse goals.pool)
        !!
        :: (ordered-goals-harvest:tv goal-order.local.store)
        ::
          %goal
        =/  =pool:gol       (~(got by pools.store) pid.type.vyu)
        =/  tv  ~(. gol-cli-traverse goals.pool)
        !!
        :: (ordered-harvest:tv gid.type.vyu goal-order.local.store)
      ==
    %-  pure:m  !>
    :-  %harvest
    %+  turn  harvest
    |=  [=pid:gol =gid:gol]
    =/  =pool:gol           ~+((~(got by pools.store) pid))
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid)
    =+  (~(got by goals.pool) gid)
    :*  gid
        summary
        done.i.status.start
        done.i.status.end
        actionable
        %+  weld
          %+  turn
            ~(tap in (~(gut by tags.local.store) [pid gid] ~))
          (lead |)
        %+  turn
          ?~(pd ~ ~(tap in (~(gut by tags.u.pd) gid ~)))
        (lead &)
    ==
    ::
      %pool-tag-goals
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.vyu)
    =/  tag-goals=(list gid:gol)
      %+  murn  ?~(pd ~ ~(tap by tags.u.pd))
      |=  [=gid:gol tags=(set @t)]
      ?.  &((~(has by goals.pool) gid) (~(has in tags) tag.vyu))
        ~
      `gid
    %-  pure:m  !>
    :-  %pool-tag-goals
    %+  turn  tag-goals
    |=  =gid:gol
    =+  (~(got by goals.pool) gid)
    :*  gid
        summary
        done.i.status.start
        done.i.status.end
        actionable
        %+  weld
          %+  turn
            ~(tap in (~(gut by tags.local.store) [pid.vyu gid] ~))
          (lead |)
        %+  turn
          ?~(pd ~ ~(tap in (~(gut by tags.u.pd) gid ~)))
        (lead &)
    ==
    ::
      %pool-tag-harvest
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.vyu)
    =/  tag-goals=(list gid:gol)
      %+  murn  ~(tap by ?~(pd ~ tags.u.pd))
      |=  [=gid:gol tags=(set @t)]
      ?.  &((~(has by goals.pool) gid) (~(has in tags) tag.vyu))
        ~
      `gid
    =/  harvest=(list gid:gol)
      !!
      :: =/  tv  ~(. gol-cli-traverse goals.pool)
      :: (custom-roots-ordered-goals-harvest:tv tag-goals goal-order.local.store)
    %-  pure:m  !>
    :-  %pool-tag-goals
    %+  turn  harvest
    |=  =gid:gol
    =+  (~(got by goals.pool) gid)
    :*  gid
        summary
        done.i.status.start
        done.i.status.end
        actionable
        %+  weld
          %+  turn
            ~(tap in (~(gut by tags.local.store) [pid.vyu gid] ~))
          (lead |)
        %+  turn
          ?~(pd ~ ~(tap in (~(gut by tags.u.pd) gid ~)))
        (lead &)
    ==
    ::
      %local-tag-goals
    =/  tag-goals=(list key:gol)
      %+  murn  ~(tap by tags.local.store)
      |=  [[=pid:gol =gid:gol] tags=(set @t)]
      =/  =pool:gol       (~(got by pools.store) pid)
      ?.  &((~(has by goals.pool) gid) (~(has in tags) tag.vyu))
        ~
      `[pid gid]
    %-  pure:m  !>
    :-  %local-tag-goals
    %+  turn  tag-goals
    |=  [=pid:gol =gid:gol]
    =/  =pool:gol       (~(got by pools.store) pid)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid)
    =+  (~(got by goals.pool) gid)
    :*  gid
        summary
        done.i.status.start
        done.i.status.end
        actionable
        %+  weld
          %+  turn
            ~(tap in (~(gut by tags.local.store) [pid gid] ~))
          (lead |)
        %+  turn
          ?~(pd ~ ~(tap in (~(gut by tags.u.pd) gid ~)))
        (lead &)
    ==
    ::
      %local-tag-harvest
    =/  tag-goals=(list key:gol)
      %+  murn  ~(tap by tags.local.store)
      |=  [[=pid:gol =gid:gol] tags=(set @t)]
      =/  =pool:gol       (~(got by pools.store) pid)
      ?.  &((~(has by goals.pool) gid) (~(has in tags) tag.vyu))
        ~
      `[pid gid]
    =/  harvest=(list key:gol)
      !!
      :: =/  tv  ~(. gol-cli-traverse (all-goals store))
      :: (custom-roots-ordered-goals-harvest:tv tag-goals goal-order.local.store)
    %-  pure:m  !>
    :-  %local-tag-goals
    %+  turn  harvest
    |=  [=pid:gol =gid:gol]
    =/  =pool:gol       (~(got by pools.store) pid)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid)
    =+  (~(got by goals.pool) gid)
    :*  gid
        summary
        done.i.status.start
        done.i.status.end
        actionable
        %+  weld
          %+  turn
            ~(tap in (~(gut by tags.local.store) [pid gid] ~))
          (lead |)
        %+  turn
          ?~(pd ~ ~(tap in (~(gut by tags.u.pd) gid ~)))
        (lead &)
    ==
    ::
      %pools-index
    %-  pure:m  !>
    :-  %pools-index
    %+  turn  pool-order.local.store
    |=(=pid:gol [pid title:(~(got by pools.store) pid)])
    ::
      %pool-title
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    (pure:m !>([%cord title.pool]))
    ::
      %pool-note
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.vyu)
    (pure:m !>([%cord (~(gut by ?~(pd ~ properties.u.pd)) 'note' '')]))
    ::
      %pool-tag-note
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.vyu)
    =/  properties      (~(gut by ?~(pd ~ tag-properties.u.pd)) tag.vyu ~)
    (pure:m !>([%cord (~(gut by properties) 'note' '')]))
    ::
      %local-tag-note
    =/  properties  (~(gut by tag-properties.local.store) tag.vyu ~)
    (pure:m !>([%cord (~(gut by properties) 'note' '')]))
    ::
      %goal-summary
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  =goal:gol       (~(got by goals.pool) gid.vyu)
    (pure:m !>([%cord summary.goal]))
    ::
      %goal-note
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.vyu)
    =/  fields=(map @t @t)  (~(gut by ?~(pd ~ fields.u.pd)) gid.vyu ~)
    (pure:m !>([%cord (~(gut by fields) 'note' '')]))
    ::
      %setting
    (pure:m !>([%ucord (~(get by settings.local.store) setting.vyu)]))
    ::
      %goal-tags
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.vyu)
    =/  tags=(list (pair ? @t))
      %+  weld
        %+  turn
          ~(tap in (~(gut by tags.local.store) [pid.vyu gid.vyu] ~))
        (lead |)
      %+  turn
        ?~(pd ~ ~(tap in (~(gut by tags.u.pd) gid.vyu ~)))
      (lead &)
    (pure:m !>([%tags tags]))
    ::
      %local-goal-tags
    =/  tags=(list (pair ? @t))
      %+  turn
        ~(tap in (~(gut by tags.local.store) [pid.vyu gid.vyu] ~))
      (lead |)
    (pure:m !>([%tags tags]))
    ::
      %goal-parent
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    =/  =goal:gol  (~(got by goals.pool) gid.vyu)
    (pure:m !>([%uid parent.goal]))
    ::
      %goal-actionable
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    =/  =goal:gol  (~(got by goals.pool) gid.vyu)
    (pure:m !>([%loob actionable.goal]))
    ::
      %goal-complete
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    =/  =goal:gol  (~(got by goals.pool) gid.vyu)
    (pure:m !>([%loob done.i.status.end.goal]))
    ::
      %goal-active
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    =/  =goal:gol  (~(got by goals.pool) gid.vyu)
    (pure:m !>([%loob done.i.status.start.goal]))
    ::
      %pool-tags
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.vyu)
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
  ~&  "%goals vine: receiving action {(trip -.act)}"
  ?-    -.act
      %put
    ;<  ~  bind:m  (poke [our dap]:gowl json-tree-transition+!>(act))
    (pure:m !>(~))
    ::
      %del
    ;<  ~  bind:m  (poke [our dap]:gowl json-tree-transition+!>(act))
    (pure:m !>(~))
    ::
      %read
    =|  jsons=(map path json)
    |-
    ?~  paths.act
      (pure:m !>(jsons+jsons))
    =/  jons=(map @ta json)
      (fall (~(get of json-tree.store) (snip i.paths.act)) ~)
    =/  =json  (~(got by jons) (rear i.paths.act))
    %=  $
      paths.act  t.paths.act
      jsons      (~(put by jsons) i.paths.act json)
    ==
    ::
      %tree
    %-  pure:m
    !>  :-  %tree
    %-  zing
    %+  turn  ~(tap of (~(dip of json-tree.store) path.act))
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
