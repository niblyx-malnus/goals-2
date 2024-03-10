/-  gol=goals, axn=action, pyk=peek, spider
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
      %archive-goal-children
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  contents        (~(got by contents.archive.pool) rid.vyu)
    =/  =goal:gol       (~(got by goals.contents) gid.vyu)
    (send-archive-goal-data (turn children.goal (corl (lead pid.vyu) (lead rid.vyu))))
    ::
      %archive-goal-borrowed
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  contents        (~(got by contents.archive.pool) rid.vyu)
    =/  nd              ~(. gol-cli-node goals.contents)
    =/  =goal:gol       (~(got by goals.contents) gid.vyu)
    (send-archive-goal-data (turn ~(tap in (nest-left:nd gid.vyu)) (corl (lead pid.vyu) (lead rid.vyu))))
    ::
      %archive-goal-borrowed-by
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  contents        (~(got by contents.archive.pool) rid.vyu)
    =/  nd              ~(. gol-cli-node goals.contents)
    =/  =goal:gol       (~(got by goals.contents) gid.vyu)
    (send-archive-goal-data (turn ~(tap in (nest-ryte:nd gid.vyu)) (corl (lead pid.vyu) (lead rid.vyu))))
    ::
      %archive-goal-progress
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  contents        (~(got by contents.archive.pool) rid.vyu)
    =/  tv              ~(. gol-cli-traverse goals.contents)
    =/  prog=(list gid:gol)  ~(tap in (progeny:tv gid.vyu))
    =/  able=(list gid:gol)
      %+  murn  prog
      |=  =gid:gol
      ?.  actionable:(~(got by goals.contents) gid)
        ~
      `gid
    =/  comp=(list gid:gol)
      %+  murn  able
      |=  =gid:gol
      ?.  done.i.status.end:(~(got by goals.contents) gid)
        ~
      `gid
    %-  pure:m  !>
    =,  enjs:format
    %-  pairs
    :~  [%complete (numb (lent comp))]
        [%total (numb (lent able))]
    ==
    ::
      %archive-goal-lineage
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  contents        (~(got by contents.archive.pool) rid.vyu)
    =;  lineage=(list [pid:gol gid:gol gid:gol])
      (send-archive-goal-data lineage)
    =/  =goal:gol  (~(got by goals.contents) gid.vyu)
    |-
    ?~  parent.goal
      ~
    =/  parent=goal:gol
      (~(got by goals.contents) u.parent.goal)
    :-  [pid.vyu rid.vyu u.parent.goal]
    $(goal parent)
    ::
      %archive-goal-harvest
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  contents        (~(got by contents.archive.pool) rid.vyu)
    =/  tv  ~(. gol-cli-traverse goals.contents)
    =;  harvest=(list [pid:gol gid:gol gid:gol])
      (send-archive-goal-data harvest)
    =/  order=(list gid:gol)
      %+  murn  goal-order.local.store
      |=  [=pid:gol =gid:gol]
      ?.(=(pid pid.vyu) ~ `gid)
    (turn (ordered-harvest:tv gid.vyu order) (corl (lead pid.vyu) (lead rid.vyu)))
    ::
      %archive-goal-empty-goals
    =;  empty=(list [pid:gol gid:gol gid:gol])
      (send-archive-goal-data empty)
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  contents        (~(got by contents.archive.pool) rid.vyu)
    =/  tv  ~(. gol-cli-traverse goals.contents)
    =/  prog=(set gid:gol)  (progeny:tv gid.vyu)
    =;  empty=(list gid:gol)
      (turn empty (corl (lead pid.vyu) (lead rid.vyu)))
    %+  murn  ~(tap by goals.contents)
    |=  [=gid:gol =goal:gol]
    ?.  (~(has in prog) gid)  ~
    ?:  actionable.goal  ~
    ?~  children.goal  [~ gid]
    =/  children-all-complete
      %+  roll
        `(list gid:gol)`children.goal
      |=  [kid=gid:gol acc=?]
      &(acc done.i.status.end:(~(got by goals.contents) kid))
    ?.  children-all-complete
      ~
    [~ gid]
    ::
      %pool-archive
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    %-  send-archive-goal-data
    %+  turn  (~(gut by contexts.archive.pool) ~ ~)
    |=(=gid:gol [pid.vyu gid gid])
    ::
      %goal-archive
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    %-  send-archive-goal-data
    %+  turn  (~(gut by contexts.archive.pool) `gid.vyu ~)
    |=(=gid:gol [pid.vyu gid gid])
    ::
      %pool-roots
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    (send-goal-data (turn roots.pool (lead pid.vyu)))
    ::
      %goal-children
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  =goal:gol       (~(got by goals.pool) gid.vyu)
    (send-goal-data (turn children.goal (lead pid.vyu)))
    ::
      %goal-borrowed
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  nd              ~(. gol-cli-node goals.pool)
    =/  =goal:gol       (~(got by goals.pool) gid.vyu)
    (send-goal-data (turn ~(tap in (nest-left:nd gid.vyu)) (lead pid.vyu)))
    ::
      %goal-borrowed-by
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  nd              ~(. gol-cli-node goals.pool)
    =/  =goal:gol       (~(got by goals.pool) gid.vyu)
    (send-goal-data (turn ~(tap in (nest-ryte:nd gid.vyu)) (lead pid.vyu)))
    ::
    %goal          (send-goal-datum [pid gid]:vyu)
    %archive-goal  (send-archive-goal-datum [pid rid gid]:vyu)
    ::
      %harvest
    =;  harvest=(list key:gol)
      (send-goal-data harvest)
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
      %empty-goals
    =;  empty=(list key:gol)
      (send-goal-data empty)
    ?-    -.type.vyu
        %main
      =/  all-goals=goals:gol  (all-goals store)
      =/  tv  ~(. gol-cli-traverse all-goals)
      =;  empty=(list gid:gol)
        (turn empty decode-key)
      %+  murn  ~(tap by all-goals)
      |=  [=gid:gol =goal:gol]
      ?:  actionable.goal  ~
      ?~  children.goal  [~ gid]
      =/  children-all-complete
        %+  roll
          `(list gid:gol)`children.goal
        |=  [kid=gid:gol acc=?]
        &(acc done.i.status.end:(~(got by all-goals) kid))
      ?.  children-all-complete
        ~
      [~ gid]
      ::
        %pool
      =/  =pool:gol       (~(got by pools.store) pid.type.vyu)
      =;  empty=(list gid:gol)
        (turn empty (lead pid.type.vyu))
      %+  murn  ~(tap by goals.pool)
      |=  [=gid:gol =goal:gol]
      ?:  actionable.goal  ~
      ?~  children.goal  [~ gid]
      =/  children-all-complete
        %+  roll
          `(list gid:gol)`children.goal
        |=  [kid=gid:gol acc=?]
        &(acc done.i.status.end:(~(got by goals.pool) kid))
      ?.  children-all-complete
        ~
      [~ gid]
      ::
        %goal
      =/  =pool:gol       (~(got by pools.store) pid.type.vyu)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      =/  prog=(set gid:gol)  (progeny:tv gid.type.vyu)
      =;  empty=(list gid:gol)
        (turn empty (lead pid.type.vyu))
      %+  murn  ~(tap by goals.pool)
      |=  [=gid:gol =goal:gol]
      ?.  (~(has in prog) gid)  ~
      ?:  actionable.goal  ~
      ?~  children.goal  [~ gid]
      =/  children-all-complete
        %+  roll
          `(list gid:gol)`children.goal
        |=  [kid=gid:gol acc=?]
        &(acc done.i.status.end:(~(got by goals.pool) kid))
      ?.  children-all-complete
        ~
      [~ gid]
    ==
    ::
      %pool-tag-goals
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  keys=(list key:gol)
      %+  murn  ~(tap by goals.pool)
      |=  [=gid:gol =goal:gol]
      =/  =@t  (~(gut by metadata.goal) 'labels' '[]')
      =/  tags=(set @t)  ((as so):dejs:format (need (de:json:html t)))
      ?.  (~(has in tags) tag.vyu)
        ~
      `[pid.vyu gid]
    (send-goal-data keys)
    ::
      %pool-tag-harvest
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  tag-goals=(list gid:gol)
      %+  murn  ~(tap by goals.pool)
      |=  [=gid:gol =goal:gol]
      =/  =@t  (~(gut by metadata.goal) 'labels' '[]')
      =/  tags=(set @t)  ((as so):dejs:format (need (de:json:html t)))
      ?.  (~(has in tags) tag.vyu)
        ~
      `gid
    =;  harvest=(list key:gol)
      (send-goal-data harvest)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  order=(list gid:gol)
      %+  murn  goal-order.local.store
      |=  [=pid:gol =gid:gol]
      ?.(=(pid pid.vyu) ~ `gid)
    (turn (custom-roots-ordered-goals-harvest:tv tag-goals order) (lead pid.vyu))
    ::
      %local-tag-goals
    =;  keys=(list key:gol)
      (send-goal-data keys)
    %+  murn  ~(tap by goal-metadata.local.store)
    |=  [[=pid:gol =gid:gol] metadata=(map @t @t)]
    =/  =@t  (~(gut by metadata) 'labels' '[]')
    =/  tags=(set @t)  ((as so):dejs:format (need (de:json:html t)))
    =/  =pool:gol       (~(got by pools.store) pid)
    ?.  &((~(has by goals.pool) gid) (~(has in tags) tag.vyu))
      ~
    `[pid gid]
    ::
      %local-tag-harvest
    =/  tag-goals=(list gid:gol)
      %+  murn  ~(tap by goal-metadata.local.store)
      |=  [[=pid:gol =gid:gol] metadata=(map @t @t)]
      =/  =@t  (~(gut by metadata) 'labels' '[]')
      =/  tags=(set @t)  ((as so):dejs:format (need (de:json:html t)))
      =/  =pool:gol       (~(got by pools.store) pid)
      ?.  &((~(has by goals.pool) gid) (~(has in tags) tag.vyu))
        ~
      `(encode-key pid gid)
    =;  harvest=(list key:gol)
      (send-goal-data harvest)
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
    (pure:m !>(s+(~(gut by metadata.pool) 'note' '')))
    ::
      %pool-tag-note
    !!
    ::
      %local-tag-note
    !!
    ::
      %setting
    (pure:m !>(?~(s=(~(get by settings.local.store) setting.vyu) ~ s+u.s)))
    ::
      %pool-tags
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  vals=(list (set @t))
      %+  turn  ~(val by goals.pool)
      |=  =goal:gol
      =/  =@t  (~(gut by metadata.goal) 'labels' '[]')
      ((as so):dejs:format (need (de:json:html t)))
    =|  tags=(set @t)
    |-
    ?~  vals
      (pure:m !>(a+(turn ~(tap in tags) (lead %s))))
    $(vals t.vals, tags (~(uni in tags) i.vals))
    ::
      %local-goal-tags
    =/  vals=(list (set @t))
      %+  turn  ~(val by goal-metadata.local.store)
      |=  metadata=(map @t @t)
      =/  =@t  (~(gut by metadata) 'labels' '[]')
      ((as so):dejs:format (need (de:json:html t)))
    =|  tags=(set @t)
    |-
    ?~  vals
      (pure:m !>(a+(turn ~(tap in tags) (lead %s))))
    $(vals t.vals, tags (~(uni in tags) i.vals))
    ::
      %pool-fields
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    =,  enjs:format
    %-  pure:m  !>
    %-  pairs
    %+  murn  ~(tap by metadata-properties.pool)
    |=  [f=@t p=(map @t @t)]
    ^-  (unit [@t json])
    ?.  (~(has by p) 'attributeType')
      ~
    [~ f (pairs (turn ~(tap by p) |=([p=@t d=@t] [p s+d])))]
    ::
      %local-goal-fields
    =,  enjs:format
    %-  pure:m  !>
    %-  pairs
    %+  murn  ~(tap by metadata-properties.local.store)
    |=  [f=@t p=(map @t @t)]
    ^-  (unit [@t json])
    ?.  (~(has by p) 'attributeType')
      ~
    [~ f (pairs (turn ~(tap by p) |=([p=@t d=@t] [p s+d])))]
    ::
    %goal-data  (send-goal-data keys.vyu)
    ::
      %goal-lineage
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    =;  lineage=(list key:gol)
      (send-goal-data lineage)
    =/  =goal:gol  (~(got by goals.pool) gid.vyu)
    |-
    ?~  parent.goal
      ~
    =/  parent=goal:gol
      (~(got by goals.pool) u.parent.goal)
    :-  [pid.vyu u.parent.goal]
    $(goal parent)
    ::
      %goal-progress
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    =/  tv         ~(. gol-cli-traverse goals.pool)
    =/  prog=(list gid:gol)  ~(tap in (progeny:tv gid.vyu))
    =/  able=(list gid:gol)
      %+  murn  prog
      |=  =gid:gol
      ?.  actionable:(~(got by goals.pool) gid)
        ~
      `gid
    =/  comp=(list gid:gol)
      %+  murn  able
      |=  =gid:gol
      ?.  done.i.status.end:(~(got by goals.pool) gid)
        ~
      `gid
    %-  pure:m  !>
    =,  enjs:format
    %-  pairs
    :~  [%complete (numb (lent comp))]
        [%total (numb (lent able))]
    ==
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
      (convert-node pid start)
      (convert-node pid end)
      actionable
      chief
      deputies
      open-to
      metadata
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
      note=@t
      labels=(list @t) :: pool-specific
      tags=(list @t)   :: private
      inherited-labels=(list @t)
      inherited-tags=(list @t)
      attributes=(list [@t @t]) :: pool-specific
      fields=(list [@t @t])     :: private
      inherited-attributes=(list [@t @t])
      inherited-fields=(list [@t @t])
      parent=(unit key:gol)
      active=?
      complete=?
      actionable=?
  ==
++  enjs-goal-datum
  =,  enjs:format
  |=  goal-datum
  %-  pairs
  :~  [%key (enjs-key:goj key)]
      [%note s+note]
      [%summary s+summary]
      [%labels a+(turn labels (lead %s))]
      [%tags a+(turn tags (lead %s))]
      ['inheritedLabels' a+(turn inherited-labels (lead %s))]
      ['inheritedTags' a+(turn inherited-tags (lead %s))]
      [%attributes (pairs (turn attributes |=([a=@t d=@t] [a s+d])))]
      [%fields (pairs (turn fields |=([f=@t d=@t] [f s+d])))]
      ['inheritedAttributes' (pairs (turn inherited-attributes |=([a=@t d=@t] [a s+d])))]
      ['inheritedFields' (pairs (turn inherited-fields |=([f=@t d=@t] [f s+d])))]
      [%parent ?~(parent ~ (enjs-key:goj u.parent))]
      [%active b+active]
      [%complete b+complete]
      [%actionable b+actionable]
  ==
++  enjs-goal-data
  |=(goal-data=(list goal-datum) `json`a+(turn goal-data enjs-goal-datum))
++  get-goal-labels
  |=  [=key:gol =store:gol]
  ^-  (list @t)
  =/  =pool:gol  (~(got by pools.store) pid.key)
  =/  =goal:gol  (~(got by goals.pool) gid.key)
  =/  =@t  (~(gut by metadata.goal) 'labels' '[]')
  ~(tap in ((as so):dejs:format (need (de:json:html t))))
++  get-goal-tags :: private labels
  |=  [=key:gol =store:gol]
  ^-  (list @t)
  =/  metadata=(map @t @t)
    (~(gut by goal-metadata.local.store) key ~)
  =/  =@t  (~(gut by metadata) 'labels' '[]')
  ~(tap in ((as so):dejs:format (need (de:json:html t))))
++  get-goal-attributes
  |=  [=key:gol =store:gol]
  ^-  (list [@t @t])
  =/  =pool:gol  (~(got by pools.store) pid.key)
  =/  =goal:gol  (~(got by goals.pool) gid.key)
  %+  murn  ~(tap by metadata.goal)
  |=  [k=@t v=@t]
  ^-  (unit [@t @t])
  =/  properties=(map @t @t)
    (~(gut by metadata-properties.pool) k ~)
  ?.  (~(has by properties) 'attributeType')
    ~
  [~ k v]
++  get-goal-fields
  |=  [=key:gol =store:gol]
  ^-  (list [@t @t])
  =/  metadata=(map @t @t)
    (~(gut by goal-metadata.local.store) key ~)
  %+  murn  ~(tap by metadata)
  |=  [k=@t v=@t]
  ^-  (unit [@t @t])
  =/  properties=(map @t @t)
    (~(gut by metadata-properties.local.store) k ~)
  ?.  (~(has by properties) 'attributeType')
    ~
  [~ k v]
++  get-datum
  |=  [=key:gol =store:gol]
  ^-  (unit goal-datum)
  ?~  pul=(~(get by pools.store) pid.key)  ~
  ?~  get=(~(get by goals.u.pul) gid.key)  ~
  =+  u.get
  |^
  :-  ~
  :*  key
      summary
      (~(gut by metadata) 'note' '')
      (get-goal-labels key store) :: labels (pool-specific)
      (get-goal-tags key store)   :: tags (private)
      inherited-labels
      inherited-tags
      (get-goal-attributes key store) :: attributes (pool-specific)
      (get-goal-fields key store)   :: fields (private)
      inherited-attributes
      inherited-fields
      ?~(parent ~ `[pid.key u.parent])
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
    =/  =goal:gol  (~(got by goals.u.pul) u.parent)
    %+  weld
      (get-goal-labels [pid.key u.parent] store) :: labels (pool-specific)
    $(parent parent.goal)
  ++  inherited-tags
    %~  tap  in
    %-  ~(gas in *(set @t))
    |-
    ^-  (list @t)
    ?~  parent
      ~
    =/  =goal:gol  (~(got by goals.u.pul) u.parent)
    %+  weld
      (get-goal-tags [pid.key u.parent] store) :: tags (private)
    $(parent parent.goal)
  ++  inherited-attributes
    =|  attributes=(map @t @t)
    %~  tap  by
    ^-  (map @t @t)
    |-
    ?~  parent
      attributes
    =/  =goal:gol  (~(got by goals.u.pul) u.parent)
    =/  parent-attributes=(list [@t @t])
      (get-goal-attributes [pid.key u.parent] store)
    %=    $
      parent  parent.goal
        attributes
      %-  ~(gas by attributes)
      %+  murn  parent-attributes
      |=  [a=@t d=@t]
      ?:((~(has by attributes) a) ~ [~ a d])
    ==
  ++  inherited-fields
    =|  fields=(map @t @t)
    %~  tap  by
    ^-  (map @t @t)
    |-
    ?~  parent
      fields
    =/  =goal:gol  (~(got by goals.u.pul) u.parent)
    =/  parent-fields=(list [@t @t])
      (get-goal-fields [pid.key u.parent] store)
    %=    $
      parent  parent.goal
        fields
      %-  ~(gas by fields)
      %+  murn  parent-fields
      |=  [a=@t d=@t]
      ?:((~(has by fields) a) ~ [~ a d])
    ==
  --
++  send-goal-datum
  |=  =key:gol
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  (pure:m !>(?~(datum=(get-datum key store) ~ (enjs-goal-datum u.datum))))
++  send-goal-data
  |=  keys=(list key:gol)
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  (pure:m !>((enjs-goal-data (murn keys (curr get-datum store)))))
++  get-archive-goal-labels
  |=  [=pid:gol rid=gid:gol =gid:gol =store:gol]
  ^-  (list @t)
  =/  =pool:gol  (~(got by pools.store) pid)
  =+  (~(got by contents.archive.pool) rid)
  =/  =goal:gol  (~(got by goals) gid)
  =/  =@t  (~(gut by metadata.goal) 'labels' '[]')
  ~(tap in ((as so):dejs:format (need (de:json:html t))))
++  get-archive-goal-attributes
  |=  [=pid:gol rid=gid:gol =gid:gol =store:gol]
  ^-  (list [@t @t])
  =/  =pool:gol  (~(got by pools.store) pid)
  =+  (~(got by contents.archive.pool) rid)
  =/  =goal:gol  (~(got by goals) gid)
  %+  murn  ~(tap by metadata.goal)
  |=  [k=@t v=@t]
  ^-  (unit [@t @t])
  =/  properties=(map @t @t)
    (~(gut by metadata-properties.pool) k ~)
  ?.  (~(has by properties) 'attributeType')
    ~
  [~ k v]
++  get-archive-datum
  |=  [=pid:gol rid=gid:gol =gid:gol =store:gol]
  ^-  (unit goal-datum)
  ?~  pul=(~(get by pools.store) pid)  ~
  ?~  ten=(~(get by contents.archive.u.pul) rid)  ~
  ?~  get=(~(get by goals.u.ten) gid)  ~
  =+  u.get
  |^
  :-  ~
  :*  [pid gid]
      summary
      (~(gut by metadata) 'note' '')
      (get-archive-goal-labels pid rid gid store) :: labels (pool-specific)
      (get-goal-tags [pid gid] store)               :: tags (private)
      inherited-labels
      inherited-tags
      (get-archive-goal-attributes pid rid gid store) :: attributes (pool-specific)
      (get-goal-fields [pid gid] store)                 :: fields (private)
      inherited-attributes
      inherited-fields
      ?~(parent ~ `[pid u.parent])
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
      =/  parent=(unit gid:gol)  context.u.ten
      |-
      ^-  (list @t)
      ?~  parent
        ~
      =/  =goal:gol  (~(got by goals.u.pul) u.parent)
      %+  weld
        (get-goal-labels [pid u.parent] store) :: labels (pool-specific)
      $(parent parent.goal)
    =/  =goal:gol  (~(got by goals.u.ten) u.parent)
    %+  weld
      (get-archive-goal-labels pid rid u.parent store) :: labels (pool-specific)
    $(parent parent.goal)
  ++  inherited-tags
    %~  tap  in
    %-  ~(gas in *(set @t))
    |-
    ^-  (list @t)
    ?~  parent
      =/  parent=(unit gid:gol)  context.u.ten
      |-
      ^-  (list @t)
      ?~  parent
        ~
      =/  =goal:gol  (~(got by goals.u.pul) u.parent)
      %+  weld
        (get-goal-tags [pid u.parent] store) :: tags (private)
      $(parent parent.goal)
    =/  =goal:gol  (~(got by goals.u.ten) u.parent)
    %+  weld
      (get-goal-tags [pid u.parent] store) :: tags (private)
    $(parent parent.goal)
  ++  inherited-attributes
    :: TODO: inherit from context like in labels/tags
    =|  attributes=(map @t @t)
    %~  tap  by
    ^-  (map @t @t)
    |-
    ?~  parent
      attributes
    =/  =goal:gol  (~(got by goals.u.ten) u.parent)
    =/  parent-attributes=(list [@t @t])
      (get-archive-goal-attributes pid rid u.parent store)
    %=    $
      parent  parent.goal
        attributes
      %-  ~(gas by attributes)
      %+  murn  parent-attributes
      |=  [a=@t d=@t]
      ?:((~(has by attributes) a) ~ [~ a d])
    ==
  ++  inherited-fields
    :: TODO: inherit from context like in labels/tags
    =|  fields=(map @t @t)
    %~  tap  by
    ^-  (map @t @t)
    |-
    ?~  parent
      fields
    =/  =goal:gol  (~(got by goals.u.ten) u.parent)
    =/  parent-fields=(list [@t @t])
      (get-goal-fields [pid u.parent] store)
    %=    $
      parent  parent.goal
        fields
      %-  ~(gas by fields)
      %+  murn  parent-fields
      |=  [f=@t d=@t]
      ?:((~(has by fields) f) ~ [~ f d])
    ==
  --
++  send-archive-goal-datum
  |=  [=pid:gol rid=gid:gol =gid:gol]
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  %-  pure:m  !>
  ?~  datum=(get-archive-datum pid rid gid store)
    ~
  =/  =pool:gol  (~(got by pools.store) pid)
  =+  (~(got by contents.archive.pool) rid)
  %-  pairs:enjs:format
  :~  [%goal (enjs-goal-datum u.datum)]
      [%context ?~(context ~ s+u.context)]
  ==
++  send-archive-goal-data
  |=  keys=(list [pid:gol gid:gol gid:gol])
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  %-  pure:m  !>
  %-  enjs-goal-data
  %+  murn  keys
  |=  [=pid:gol rid=gid:gol =gid:gol]
  (get-archive-datum pid rid gid store)
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
