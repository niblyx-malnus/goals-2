/-  p=pools, gol=goals, axn=action, pyk=peek, spider
/+  *ventio, pools, tree=filetree,
    gol-cli-membership, gol-cli-view,
    gol-cli-traverse, gol-cli-node, gol-cli-pool,
    goj=gol-cli-json
=,  strand=strand:spider
^-  thread:spider
::
=<  =*  helper-core  .
::
%-  vine-thread
%-  vine:tree
|=  [gowl=bowl:gall vid=vent-id =mark =vase]
=/  m  (strand ,^vase)
^-  form:m
::
=*  hc   ~(. helper-core gowl)
=*  mhc  ~(. gol-cli-membership gowl)
=*  vhc  ~(. gol-cli-view gowl)
::
~&  "%goals vine: receiving mark {(trip mark)}"
;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
?+    mark  (just-poke [our dap]:gowl mark vase) :: poke normally
    %goal-membership-action
  (handle-membership-action:mhc !<(membership-action:axn vase))
  ::
    %goal-remote-view
  (handle-remote-view:vhc !<(remote-view:axn vase))
  ::
    %goal-local-view
  (handle-local-view:vhc !<(local-view:axn vase))
  ::
    %goal-action
  =+  !<(act=action:axn vase)
  =/  gam  %goal-action-and-mod
  ?+    -.act  (just-poke [our dap]:gowl gam !>([src.gowl act]))
      %create-pool
    :: only we can create a pool under our name
    ::
    ?>  =(src our):gowl
    =/  data-fields  [%public [%title ~ s+title.act]~]~
    ;<  =id:p  bind:m  (create-pools-pool:hc ~ data-fields)
    =/  data-fields  [%private ['goalsPool' ~ s+(id-string:enjs:pools id)]~]~
    ;<  ~  bind:m  (update-pool-data:hc id data-fields)
    ;<  ~  bind:m  (create-goals-pool:hc id title.act)
    (pure:m !>(s+(id-string:enjs:pools id)))
    ::
      %delete-pool
    :: only we can delete a pool under our name
    ::
    ?>  =(src our):gowl
    ;<  ~  bind:m  (delete-goals-pool:hc pid.act)
    :: don't crash if pool-pool deletion fails
    ;<  out=(each ~ goof)  bind:m
      ((soften ,~) (delete-pools-pool:hc pid.act))
    ~&  out
    (pure:m !>(~))
    ::
      %create-goal
    :: Hacky way to get new id
    ::
    =/  old=(set gid:gol)  ~(key by goals:(~(got by pools.store) pid.act))
    ;<  ~  bind:m  (poke [our dap]:gowl gam !>([src.gowl act]))
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
    (send-archive-goal-data (turn children.goal (corl (lead pid.vyu) (lead rid.vyu))) src.gowl)
    ::
      %archive-goal-borrowed
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  contents        (~(got by contents.archive.pool) rid.vyu)
    =/  nd              ~(. gol-cli-node goals.contents)
    =/  =goal:gol       (~(got by goals.contents) gid.vyu)
    (send-archive-goal-data (turn ~(tap in (nest-left:nd gid.vyu)) (corl (lead pid.vyu) (lead rid.vyu))) src.gowl)
    ::
      %archive-goal-borrowed-by
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  contents        (~(got by contents.archive.pool) rid.vyu)
    =/  nd              ~(. gol-cli-node goals.contents)
    =/  =goal:gol       (~(got by goals.contents) gid.vyu)
    (send-archive-goal-data (turn ~(tap in (nest-ryte:nd gid.vyu)) (corl (lead pid.vyu) (lead rid.vyu))) src.gowl)
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
      (send-archive-goal-data lineage src.gowl)
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
      (send-archive-goal-data harvest src.gowl)
    =/  order=(list gid:gol)
      %+  murn  goal-order.local.store
      |=  [=pid:gol =gid:gol]
      ?.(=(pid pid.vyu) ~ `gid)
    (turn (ordered-harvest:tv gid.vyu order) (corl (lead pid.vyu) (lead rid.vyu)))
    ::
      %archive-goal-empty-goals
    =;  empty=(list [pid:gol gid:gol gid:gol])
      (send-archive-goal-data empty src.gowl)
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
    %+  send-archive-goal-data
      %+  turn  (~(gut by contexts.archive.pool) ~ ~)
      |=(=gid:gol [pid.vyu gid gid])
    src.gowl
    ::
      %goal-archive
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    %+  send-archive-goal-data
      %+  turn  (~(gut by contexts.archive.pool) `gid.vyu ~)
      |=(=gid:gol [pid.vyu gid gid])
    src.gowl
    ::
      %pool-roots
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    (send-goal-data (turn roots.pool (lead pid.vyu)) src.gowl)
    ::
      %goal-children
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  =goal:gol       (~(got by goals.pool) gid.vyu)
    (send-goal-data (turn children.goal (lead pid.vyu)) src.gowl)
    ::
      %goal-borrowed
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  nd              ~(. gol-cli-node goals.pool)
    =/  =goal:gol       (~(got by goals.pool) gid.vyu)
    (send-goal-data (turn ~(tap in (nest-left:nd gid.vyu)) (lead pid.vyu)) src.gowl)
    ::
      %goal-borrowed-by
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  nd              ~(. gol-cli-node goals.pool)
    =/  =goal:gol       (~(got by goals.pool) gid.vyu)
    (send-goal-data (turn ~(tap in (nest-ryte:nd gid.vyu)) (lead pid.vyu)) src.gowl)
    ::
    %goal          (send-goal-datum [pid gid]:vyu src.gowl)
    %archive-goal  (send-archive-goal-datum pid.vyu rid.vyu gid.vyu src.gowl)
    ::
      %harvest
    =;  harvest=(list key:gol)
      (send-goal-data harvest src.gowl)
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
      (send-goal-data empty src.gowl)
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
      =/  tags=(set @t)
        ((as so):dejs:format (~(gut by metadata.goal) 'labels' a+~))
      ?.  (~(has in tags) tag.vyu)
        ~
      `[pid.vyu gid]
    (send-goal-data keys src.gowl)
    ::
      %pool-tag-harvest
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  tag-goals=(list gid:gol)
      %+  murn  ~(tap by goals.pool)
      |=  [=gid:gol =goal:gol]
      =/  tags=(set @t)
        ((as so):dejs:format (~(gut by metadata.goal) 'labels' a+~))
      ?.  (~(has in tags) tag.vyu)
        ~
      `gid
    =;  harvest=(list key:gol)
      (send-goal-data harvest src.gowl)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  order=(list gid:gol)
      %+  murn  goal-order.local.store
      |=  [=pid:gol =gid:gol]
      ?.(=(pid pid.vyu) ~ `gid)
    (turn (custom-roots-ordered-goals-harvest:tv tag-goals order) (lead pid.vyu))
    ::
      %pool-title
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    (pure:m !>(s+title.pool))
    ::
      %pool-note
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    (pure:m !>((~(gut by metadata.pool) 'note' s+'')))
    ::
      %pool-perms
    ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
    =/  =pool:p  (~(got by pools) pid.vyu)
    %-  pure:m  !>
    %-  pairs:enjs:format
    %+  turn  ~(tap by members.pool)
    |=  [=@p =roles:p]
    =/  roles  ~(tap in roles)
    ?>  (gte 1 (lent roles))
    [(scot %p p) s+?~(roles 'EMPTY!' i.roles)]
    ::
      %pool-graylist
    ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
    =/  =pool:p  (~(got by pools) pid.vyu)
    %-  pure:m  !>
    %-  pairs:enjs:format
    :~  :-  %ship
        %-  pairs:enjs:format
        %+  turn  ~(tap by ship.graylist.pool)
        |=  [=ship =auto:p]
        :-  (scot %p ship)
        (auto:enjs:^pools auto)
        :-  %rank
        %-  pairs:enjs:format
        %+  turn  ~(tap by rank.graylist.pool)
        |=  [=rank:title =auto:p]
        [rank (auto:enjs:^pools auto)]
        :-  %rest
        ?~  rest.graylist.pool
          ~
        (auto:enjs:^pools u.rest.graylist.pool)
    ==
    ::
      %pool-tag-note
    !!
    ::
      %pool-tags
    =/  =pool:gol       (~(got by pools.store) pid.vyu)
    =/  vals=(list (set @t))
      %+  turn  ~(val by goals.pool)
      |=  =goal:gol
      ((as so):dejs:format (~(gut by metadata.goal) 'labels' a+~))
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
    |=  [f=@t p=(map @t json)]
    ^-  (unit [@t json])
    ?.  (~(has by p) 'attributeType')
      ~
    [~ f o+p]
    ::
    %goal-data  (send-goal-data keys.vyu src.gowl)
    ::
      %goal-lineage
    =/  =pool:gol  (~(got by pools.store) pid.vyu)
    =;  lineage=(list key:gol)
      (send-goal-data lineage src.gowl)
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
    ::
      %outgoing-invites
    ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
    =/  =pool:p  (~(got by pools) pid.vyu)
    %-  pure:m  !>
    =,  enjs:format
    %-  pairs
    %+  turn  ~(tap by outgoing-invites.pool)
    |=  [to=@p =invite:p =status:p]
    ^-  [@t json]
    :-  (scot %p to)
    %-  pairs
    :~  [%invite o+invite]
        :-  %status
        ?~  status
          ~
        %-  pairs
        :-  ['response' b+response.u.status]
        ~(tap by metadata.u.status)
    ==
    ::
      %incoming-requests
    ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
    =/  =pool:p  (~(got by pools) pid.vyu)
    %-  pure:m  !>
    =,  enjs:format
    %-  pairs
    %+  turn  ~(tap by incoming-requests.pool)
    |=  [to=@p =request:p =status:p]
    ^-  [@t json]
    :-  (scot %p to)
    %-  pairs
    :~  [%request o+request]
        :-  %status
        ?~  status
          ~
        %-  pairs
        :-  ['response' b+response.u.status]
        ~(tap by metadata.u.status)
    ==
  ==
==
::
|_  =gowl
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
      attributes=(list [@t json]) :: pool-specific
      parent=(unit key:gol)
      src-perms=@t
      chief=ship
      deputies=(list [ship @t])
      open-to=(unit @t)
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
      [%attributes (pairs attributes)]
      [%parent ?~(parent ~ (enjs-key:goj u.parent))]
      ['yourPerms' s+src-perms]
      [%chief s+(scot %p chief)]
      [%deputies (pairs (turn deputies |=([=@p =@t] [(scot %p p) s+t])))]
      ['openTo' ?~(open-to ~ s+u.open-to)]
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
  ~(tap in ((as so):dejs:format (~(gut by metadata.goal) 'labels' a+~)))
++  get-goal-tags :: private labels
  |=  [=key:gol =store:gol]
  ^-  (list @t)
  =/  metadata=(map @t json)
    (~(gut by goal-metadata.local.store) key ~)
  ~(tap in ((as so):dejs:format (~(gut by metadata) 'labels' a+~)))
++  get-goal-attributes
  |=  [=key:gol =store:gol]
  ^-  (list [@t json])
  =/  =pool:gol  (~(got by pools.store) pid.key)
  =/  =goal:gol  (~(got by goals.pool) gid.key)
  %+  murn  ~(tap by metadata.goal)
  |=  [k=@t v=json]
  ^-  (unit [@t json])
  =/  properties=(map @t json)
    (~(gut by metadata-properties.pool) k ~)
  ?.  (~(has by properties) 'attributeType')
    ~
  [~ k v]
++  get-goal-fields
  |=  [=key:gol =store:gol]
  ^-  (list [@t json])
  =/  metadata=(map @t json)
    (~(gut by goal-metadata.local.store) key ~)
  %+  murn  ~(tap by metadata)
  |=  [k=@t v=json]
  ^-  (unit [@t json])
  =/  properties=(map @t json)
    (~(gut by metadata-properties.local.store) k ~)
  ?.  (~(has by properties) 'attributeType')
    ~
  [~ k v]
++  get-datum
  |=  [=key:gol =store:gol src=ship]
  ^-  (unit goal-datum)
  ?~  pul=(~(get by pools.store) pid.key)  ~
  ?~  get=(~(get by goals.u.pul) gid.key)  ~
  =+  u.get
  :-  ~
  :*  key
      summary
      (so:dejs:format (~(gut by metadata) 'note' s+''))
      (get-goal-labels key store) :: labels (pool-specific)
      (get-goal-attributes key store) :: attributes (pool-specific)
      ?~(parent ~ `[pid.key u.parent])
      (get-goal-permission-level:(apex:gol-cli-pool u.pul) gid.key src)
      chief
      ~(tap by deputies)
      open-to
      done.i.status.start
      done.i.status.end
      actionable
  ==
++  send-goal-datum
  |=  [=key:gol src=ship]
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  (pure:m !>(?~(datum=(get-datum key store src) ~ (enjs-goal-datum u.datum))))
++  send-goal-data
  |=  [keys=(list key:gol) src=ship]
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  (pure:m !>((enjs-goal-data (murn keys (curr get-datum [store src])))))
++  get-archive-goal-labels
  |=  [=pid:gol rid=gid:gol =gid:gol =store:gol]
  ^-  (list @t)
  =/  =pool:gol  (~(got by pools.store) pid)
  =+  (~(got by contents.archive.pool) rid)
  =/  =goal:gol  (~(got by goals) gid)
  ~(tap in ((as so):dejs:format (~(gut by metadata.goal) 'labels' a+~)))
++  get-archive-goal-attributes
  |=  [=pid:gol rid=gid:gol =gid:gol =store:gol]
  ^-  (list [@t json])
  =/  =pool:gol  (~(got by pools.store) pid)
  =+  (~(got by contents.archive.pool) rid)
  =/  =goal:gol  (~(got by goals) gid)
  %+  murn  ~(tap by metadata.goal)
  |=  [k=@t v=json]
  ^-  (unit [@t json])
  =/  properties=(map @t json)
    (~(gut by metadata-properties.pool) k ~)
  ?.  (~(has by properties) 'attributeType')
    ~
  [~ k v]
++  get-archive-datum
  |=  [=pid:gol rid=gid:gol =gid:gol =store:gol src=ship]
  ^-  (unit goal-datum)
  ?~  pul=(~(get by pools.store) pid)  ~
  ?~  ten=(~(get by contents.archive.u.pul) rid)  ~
  ?~  get=(~(get by goals.u.ten) gid)  ~
  =+  u.get
  :-  ~
  :*  [pid gid]
      summary
      (so:dejs:format (~(gut by metadata) 'note' s+''))
      (get-archive-goal-labels pid rid gid store) :: labels (pool-specific)
      (get-archive-goal-attributes pid rid gid store) :: attributes (pool-specific)
      ?~(parent ~ `[pid u.parent])
      (get-goal-permission-level:(apex:gol-cli-pool u.pul) gid src)
      chief
      ~(tap by deputies)
      open-to
      done.i.status.start
      done.i.status.end
      actionable
  ==
++  send-archive-goal-datum
  |=  [=pid:gol rid=gid:gol =gid:gol src=ship]
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  %-  pure:m  !>
  ?~  datum=(get-archive-datum pid rid gid store src)
    ~
  =/  =pool:gol  (~(got by pools.store) pid)
  =+  (~(got by contents.archive.pool) rid)
  %-  pairs:enjs:format
  :~  [%goal (enjs-goal-datum u.datum)]
      [%context ?~(context ~ s+u.context)]
  ==
++  send-archive-goal-data
  |=  [keys=(list [pid:gol gid:gol gid:gol]) src=ship]
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  %-  pure:m  !>
  %-  enjs-goal-data
  %+  murn  keys
  |=  [=pid:gol rid=gid:gol =gid:gol]
  (get-archive-datum pid rid gid store src)
::
++  create-goals-pool
  |=  [=pid:gol title=@t]
  =/  m  (strand ,~)
  ^-  form:m
  (poke [our dap]:gowl goals-transition+!>([%create-pool pid title]))
::
++  delete-goals-pool
  |=  =pid:gol
  =/  m  (strand ,~)
  ^-  form:m
  (poke [our dap]:gowl goals-transition+!>([%delete-pool pid]))
::
++  create-pools-pool
  |=  $:  graylist-fields=(list graylist-field:p)
          pool-data-fields=(list pool-data-field:p)
      ==
  =/  m  (strand ,id:p)
  ^-  form:m
  ;<  jon=json  bind:m
    %+  (vent ,json)  [our.gowl %pools]
    pools-action+[%create-pool graylist-fields pool-data-fields]
  (pure:m (id:dejs:pools jon))
::
++  delete-pools-pool
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  (poke [our.gowl %pools] pools-transition+!>([%delete-pool id]))
::
++  update-pool-data
  |=  [=id:p fields=(list pool-data-field:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl %pools]
  :-  %pools-transition  !>
  :+  %update-pool  id
  [%update-pool-data fields]
--
