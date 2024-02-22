/-  gol=goals, axn=action, pyk=peek, spider, jot=json-tree
/+  *ventio, tree=filetree, gol-cli-traverse, gol-cli-node,
    goj=gol-cli-json
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
    :: Hacky way to get new id
    ::
    =/  old=(set gid:gol)  ~(key by goals:(~(got by pools.store) pid.act))
    ;<  ~  bind:m  (poke [our dap]:gowl mark vase)
    ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
    =/  new=(set gid:gol)  ~(key by goals:(~(got by pools.store) pid.act))
    =/  gid-list=(list gid:gol)  ~(tap in (~(dif in new) old))
    ?>  ?=(^ gid-list)
    ?>  =(1 (lent gid-list))
    (pure:m !>((enjs-key:goj [pid.act i.gid-list])))
  ==
  ::
    %goal-view
  =+  !<(vyu=goal-view:axn vase)
  ?-    -.vyu
      %pool-roots
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    (goal-data (turn roots.pool (lead pid.vyu)))
    ::
      %goal-children
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  =goal:gol       (~(got by goals.pool) gid.vyu)
    (goal-data (turn children.goal (lead pid.vyu)))
    ::
      %goal-borrowed
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  =goal:gol       (~(got by goals.pool) gid.vyu)
    (goal-data (turn borrowed.goal (lead pid.vyu)))
    ::
      %goal-borrowed-by
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  =goal:gol       (~(got by goals.pool) gid.vyu)
    (goal-data (turn borrowed-by.goal (lead pid.vyu)))
    ::
      %harvest
    =;  harvest=(list key:gol)
      (goal-data harvest)
    ?-    -.type.vyu
        %main
      =/  all-goals=goals:gol  (all-goals store)
      =/  tv  ~(. gol-cli-traverse all-goals)
      =/  key-order=(list gid:gol)
        (turn goal-order.local.store encode-key)
      (turn (ordered-goals-harvest:tv key-order) decode-key)
      ::
        %pool
      =/  =pool:gol       (~(got by pools.store) pid.type.vyu)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      =/  order=(list gid:gol)
        %+  murn  goal-order.local.store
        |=  [=pid:gol =gid:gol]
        ?.(=(pid pid.type.vyu) ~ `gid)
      (turn (ordered-goals-harvest:tv order) (lead pid.type.vyu))
      ::
        %goal
      =/  =pool:gol       (~(got by pools.store) pid.type.vyu)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      =/  order=(list gid:gol)
        %+  murn  goal-order.local.store
        |=  [=pid:gol =gid:gol]
        ?.(=(pid pid.type.vyu) ~ `gid)
      (turn (ordered-harvest:tv gid.type.vyu order) (lead pid.type.vyu))
    ==
    ::
      %pool-tag-goals
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.vyu)
    =/  keys=(list key:gol)
      %+  murn  ?~(pd ~ ~(tap by tags.u.pd))
      |=  [=gid:gol tags=(set @t)]
      ?.  &((~(has by goals.pool) gid) (~(has in tags) tag.vyu))
        ~
      `[pid.vyu gid]
    (goal-data keys)
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
    =;  harvest=(list key:gol)
      (goal-data harvest)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  order=(list gid:gol)
      %+  murn  goal-order.local.store
      |=  [=pid:gol =gid:gol]
      ?.(=(pid pid.vyu) ~ `gid)
    (turn (custom-roots-ordered-goals-harvest:tv tag-goals order) (lead pid.vyu))
    ::
      %local-tag-goals
    =;  keys=(list key:gol)
      (goal-data keys)
    %+  murn  ~(tap by tags.local.store)
    |=  [[=pid:gol =gid:gol] tags=(set @t)]
    =/  =pool:gol       (~(got by pools.store) pid)
    ?.  &((~(has by goals.pool) gid) (~(has in tags) tag.vyu))
      ~
    `[pid gid]
    ::
      %local-tag-harvest
    =/  tag-goals=(list gid:gol)
      %+  murn  ~(tap by tags.local.store)
      |=  [[=pid:gol =gid:gol] tags=(set @t)]
      =/  =pool:gol       (~(got by pools.store) pid)
      ?.  &((~(has by goals.pool) gid) (~(has in tags) tag.vyu))
        ~
      `(encode-key pid gid)
    =;  harvest=(list key:gol)
      (goal-data harvest)
    =/  tv  ~(. gol-cli-traverse (all-goals store))
    =/  key-order=(list gid:gol)
      (turn goal-order.local.store encode-key)
    %+  turn
      (custom-roots-ordered-goals-harvest:tv tag-goals key-order)
    decode-key
    ::
      %pools-index
    %-  pure:m  !>
    %-  enjs-pools-index
    %+  turn  pool-order.local.store
    |=(=pid:gol [pid title:(~(got by pools.store) pid)])
    ::
      %pool-title
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    (pure:m !>(s+title.pool))
    ::
      %pool-note
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.vyu)
    (pure:m !>(s+(~(gut by ?~(pd ~ properties.u.pd)) 'note' '')))
    ::
      %pool-tag-note
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.vyu)
    =/  properties      (~(gut by ?~(pd ~ tag-properties.u.pd)) tag.vyu ~)
    (pure:m !>(s+(~(gut by properties) 'note' '')))
    ::
      %local-tag-note
    =/  properties  (~(gut by tag-properties.local.store) tag.vyu ~)
    (pure:m !>(s+(~(gut by properties) 'note' '')))
    ::
      %goal-summary
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  =goal:gol       (~(got by goals.pool) gid.vyu)
    (pure:m !>(s+summary.goal))
    ::
      %goal-note
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.vyu)
    =/  fields=(map @t @t)  (~(gut by ?~(pd ~ fields.u.pd)) gid.vyu ~)
    (pure:m !>(s+(~(gut by fields) 'note' '')))
    ::
      %setting
    (pure:m !>(?~(s=(~(get by settings.local.store) setting.vyu) ~ s+u.s)))
    ::
      %goal-tags
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.vyu)
    =/  tags=(list @t)
      ?~(pd ~ ~(tap in (~(gut by tags.u.pd) gid.vyu ~)))
    (pure:m !>(a+(turn tags (lead %s))))
    ::
      %local-goal-tags
    =/  tags=(list @t)
      ~(tap in (~(gut by tags.local.store) [pid.vyu gid.vyu] ~))
    (pure:m !>(a+(turn tags (lead %s))))
    ::
      %goal-parent
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    =/  =goal:gol  (~(got by goals.pool) gid.vyu)
    (pure:m !>(?~(parent.goal ~ (enjs-key:goj [pid.vyu u.parent.goal]))))
    ::
      %goal-actionable
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    =/  =goal:gol  (~(got by goals.pool) gid.vyu)
    (pure:m !>(b+actionable.goal))
    ::
      %goal-complete
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    =/  =goal:gol  (~(got by goals.pool) gid.vyu)
    (pure:m !>(b+done.i.status.end.goal))
    ::
      %goal-active
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    =/  =goal:gol  (~(got by goals.pool) gid.vyu)
    (pure:m !>(b+done.i.status.start.goal))
    ::
      %pool-tags
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.vyu)
    =/  vals  ~(val by ?~(pd ~ tags.u.pd))
    =|  tags=(set @t)
    |-
    ?~  vals
      (pure:m !>(a+(turn ~(tap in tags) (lead %s))))
    $(vals t.vals, tags (~(uni in tags) i.vals))
    ::
      %all-local-goal-tags
    =/  vals  ~(val by tags.local.store)
    =|  tags=(set @t)
    |-
    ?~  vals
      (pure:m !>(a+(turn ~(tap in tags) (lead %s))))
    $(vals t.vals, tags (~(uni in tags) i.vals))
    ::
    %goal-data  (goal-data keys.vyu)
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
      (pure:m !>((enjs-jsons jsons)))
    =/  jons=(map @ta json)
      (fall (~(get of json-tree.store) (snip i.paths.act)) ~)
    =/  =json  (~(got by jons) (rear i.paths.act))
    %=  $
      paths.act  t.paths.act
      jsons      (~(put by jsons) i.paths.act json)
    ==
    ::
      %tree
    =;  paths=(list path)
      (pure:m !>(a+(turn paths |=(=path s+(spat path)))))
    %-  zing
    %+  turn  ~(tap of (~(dip of json-tree.store) path.act))
    |=  [=path =(map @ta json)]
    %+  turn  ~(tap in ~(key by map))
    |=(=@ta (weld path ~[ta]))
  ==
==
::
|%
++  encode-key  |=(key:gol (rap 3 (enjs-pid:goj pid) '/' gid ~))
++  decode-key
  |=  =cord
  ^-  key:gol
  =/  =(pole knot)  (rash cord stap) 
  ?>  ?=([host=@ta name=@ta gid=@ta ~] -)
  [[(slav %p host.pole) name.pole] gid.pole]
++  convert-node
  |=  [=pid:gol node:gol]
  ^-  node:gol
  :*  status
      moment
      (~(run in inflow) |=(=nid:gol [-.nid (encode-key pid gid.nid)]))
      (~(run in outflow) |=(=nid:gol [-.nid (encode-key pid gid.nid)]))
  ==
++  convert-goal
  |=  [=pid:gol goal:gol]
  ^-  goal:gol
  :*  (encode-key pid gid)
      summary
      ?~(parent ~ `(encode-key pid u.parent))
      (turn children (cury encode-key pid))
      (turn borrowed-by (cury encode-key pid))
      (turn borrowed (cury encode-key pid))
      (convert-node pid start)
      (convert-node pid end)
      actionable
      chief
      deputies
      open-to
  ==
++  all-goals
  |=  =store:gol
  ^-  goals:gol
  =/  pools=(list pool:gol)
    ~(val by pools.store)
  =|  =goals:gol
  |-
  ?~  pools
    goals
  %=  $
    pools  t.pools
      goals
    :: make unique goal ids by prepending pid
    ::
    %-  ~(uni by goals)
    %-  ~(gas by *goals:gol)
    %+  turn  ~(tap by goals.i.pools)
    |=  [=gid:gol =goal:gol]
    :-  (encode-key pid.i.pools gid)
    (convert-goal pid.i.pools goal)
  ==
+$  goal-datum
  $:  =key:gol
      summary=@t
      labels=(list @t) :: pool-specific
      tags=(list @t)   :: private
      inherited-labels=(list @t)
      inherited-tags=(list @t)
      active=?
      complete=?
      actionable=?
  ==
++  enjs-goal-data
  =,  enjs:format
  |=  goal-data=(list goal-datum)
  ^-  json
  :-  %a
  %+  turn  goal-data
  |=  goal-datum
  %-  pairs
  :~  [%key (enjs-key:goj key)]
      [%summary s+summary]
      [%labels a+(turn labels (lead %s))]
      [%tags a+(turn tags (lead %s))]
      ['inheritedLabels' a+(turn inherited-labels (lead %s))]
      ['inheritedTags' a+(turn inherited-tags (lead %s))]
      [%active b+active]
      [%complete b+complete]
      [%actionable b+actionable]
  ==
++  goal-data
  |=  keys=(list key:gol)
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  %-  pure:m  !>
  %-  enjs-goal-data
  %+  murn  keys
  |=  =key:gol
  =/  =pool:gol                (~(got by pools.store) pid.key)
  =/  pd=(unit pool-data:gol)  (~(get by pool-info.store) pid.key)
  ?~  get=(~(get by goals.pool) gid.key)
    ~
  =+  u.get
  |^
  :-  ~
  :*  key
      summary
      ?~(pd ~ ~(tap in (~(gut by tags.u.pd) gid ~))) :: labels (pool-specific)
      ~(tap in (~(gut by tags.local.store) key ~))   :: tags (private)
      inherited-labels
      inherited-tags
      done.i.status.start
      done.i.status.end
      actionable
  ==
  ++  inherited-labels
    %~  tap  in
    %-  ~(gas in *(set @t))
    |-
    ^-  (list @t)
    ?~  parent
      ~
    =/  =goal:gol  (~(got by goals.pool) u.parent)
    %+  weld
      ?~(pd ~ ~(tap in (~(gut by tags.u.pd) u.parent ~))) :: labels (pool-specific)
    $(parent parent.goal)
  ++  inherited-tags
    %~  tap  in
    %-  ~(gas in *(set @t))
    |-
    ^-  (list @t)
    ?~  parent
      ~
    =/  =goal:gol  (~(got by goals.pool) u.parent)
    %+  weld
      ~(tap in (~(gut by tags.local.store) [pid.key u.parent] ~))   :: tags (private)
    $(parent parent.goal)
  --
++  enjs-pools-index
  =,  enjs:format
  |=  pools-index=(list [pid:gol @])
  :-  %a
  %+  turn  pools-index
  |=  [=pid:gol title=@t] 
  %-  pairs
  :~  [%pid s+(enjs-pid:goj pid)]
      [%title s+title]
  ==
++  enjs-jsons
  =,  enjs:format
  |=  jsons=(map ^path ^json)
  o/(malt (turn ~(tap by jsons) |=([=^path =^json] [(spat path) json])))
--
