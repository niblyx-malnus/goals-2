/-  gol=goals, vyu=views, update
/+  gol-cli-etch, gol-cli-node, gol-cli-traverse, j=gol-cli-json
|_  [=store:gol =bowl:gall]
+*  etch  ~(. gol-cli-etch store)
++  view-data
  |=  =parm:list-view:vyu
  ^-  data:list-view:vyu
  ?-    -.type.parm
      %main
    =/  tv  ~(. gol-cli-traverse all-goals:etch)
    =/  nd  ~(. gol-cli-node all-goals:etch)
    ::
    =/  goals=(list [id:gol pack:list-view:vyu])
      :: first-gen-only?
      ::
      ?:  first-gen-only.parm
        (turn (waif-goals:nd) |=(=id:gol [id (id-to-pack id)]))
      %+  turn  ~(tap in ~(key by all-goals:etch))
      |=(=id:gol [id (id-to-pack id)])
    :: actionable-only?
    ::
    =?  goals  actionable-only.parm
      %+  murn  goals
      |=  [id:gol pack:list-view:vyu]
      ?.(actionable ~ (some +<))
    ::
    =?  goals  !=(~ tags.parm)
      %+  murn  goals
      |=  [=id:gol =pack:list-view:vyu]
      ?.  (filter-tags id method.parm tags.parm)  ~
      (some [id pack]) 
    :: order according to order.local.store
    ::
    goals
    ::
      %pool
    =/  pool  (~(got by pools.store) pin.type.parm)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  nd  ~(. gol-cli-node goals.pool)
    ::
    =/  goals=(list [id:gol pack:list-view:vyu])
      :: first-gen-only?
      ::
      ?:  first-gen-only.parm
        (turn (waif-goals:nd) |=(=id:gol [id (id-to-pack id)]))
      %+  turn  ~(tap in ~(key by goals.pool))
      |=(=id:gol [id (id-to-pack id)])
    :: actionable-only?
    ::
    =?  goals  actionable-only.parm
      %+  murn  goals
      |=  [id:gol pack:list-view:vyu]
      ?.(actionable ~ (some +<))
    ::
    =?  goals  !=(~ tags.parm)
      %+  murn  goals
      |=  [=id:gol =pack:list-view:vyu]
      ?.  (filter-tags id method.parm tags.parm)  ~
      (some [id pack]) 
    :: order according to order.local.store
    ::
    goals
    ::
      %goal
    =/  pool  (~(got by pools.store) pin.id.type.parm)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  nd  ~(. gol-cli-node goals.pool)
    ::
    =/  goals=(list [id:gol pack:list-view:vyu])
      =;  ids=(set id:gol)
        (turn ~(tap in ids) |=(=id:gol [id (id-to-pack id)]))
      :: first-gen-only? ignore-virtual?
      ::
      ?:  =([& &] [first-gen-only ignore-virtual.type]:parm)
        kids:(~(got by goals.pool) id.type.parm)
      ?:  =([& |] [first-gen-only ignore-virtual.type]:parm)
        (young:nd id.type.parm)
      ?:  =([| &] [first-gen-only ignore-virtual.type]:parm)
        (progeny:tv id.type.parm)
      ?>  =([| |] [first-gen-only ignore-virtual.type]:parm)
      (virtual-progeny:tv id.type.parm)
    :: actionable-only?
    ::
    =?  goals  actionable-only.parm
      %+  murn  goals
      |=  [id:gol pack:list-view:vyu]
      ?.(actionable ~ (some +<))
    ::
    =?  goals  !=(~ tags.parm)
      %+  murn  goals
      |=  [=id:gol =pack:list-view:vyu]
      ?.  (filter-tags id method.parm tags.parm)  ~
      (some [id pack]) 
    :: order according to order.local.store
    ::
    goals
  ==
::
++  view-diff
  |=  $:  =parm:list-view:vyu
          =data:list-view:vyu
          [=pin:gol upd=update:v5-1:update]
      ==
  ^-  (unit diff:list-view:vyu)
  =;  diff=(unit diff:list-view:vyu)
    ~|  "non-equivalent-list-view-diff"
    =/  check=?
      ?~  diff  =(data (view-data parm))
      =((view-data parm) (etch-diff data u.diff))
    ?>(check diff)
  =/  atad=data:list-view:vyu  (view-data parm)
  ?:  =(data atad)  ~
  (some [pin %replace atad])
::
++  etch-diff
  |=  [=data:list-view:vyu =diff:list-view:vyu]
  ^-  data:list-view:vyu
  ?>(?=(%replace +<.diff) +>.diff)
::
++  unify-tags
  |=  =id:gol
  ^-  goal:gol
  =/  =pool:gol  (~(got by pools.store) pin.id)
  =/  =goal:gol  (~(got by goals.pool) id)
  %=    goal
      tags
    %-  ~(uni in tags:(~(got by goals.pool) id))
    =+  get=(~(get by goals.local.store) id)
    ?~(get ~ tags.u.get)
  ==
::
++  id-to-pack
  |=  =id:gol
  ^-  pack:list-view:vyu
  =/  =pool:gol  (~(got by pools.store) pin.id)
  =/  pool-role=(unit ?(%owner pool-role:gol))
    ?:  =(our.bowl host.pin.id)  (some %owner)
    (~(got by perms.pool) our.bowl)
  =/  =goal:gol  (unify-tags id)
  :*  pin.id
      pool-role
      par.goal
      kids.goal
      kickoff.goal
      deadline.goal
      complete.goal
      actionable.goal
      chief.goal
      spawn.goal
      owner.goal
      birth.goal
      author.goal
      desc.goal
      note.goal
      tags.goal
      fields.goal
      stock.goal
      ranks.goal
      young.goal
      young-by-precedence.goal
      young-by-kickoff.goal
      young-by-deadline.goal
      progress.goal
      prio-left.goal
      prio-ryte.goal
      prec-left.goal
      prec-ryte.goal
      nest-left.goal
      nest-ryte.goal
  ==
::
++  filter-tags
  |=  $:  =id:gol
          method=?(%any %all)
          tags=(set tag:gol)
      ==
  ^-  ?
  =/  =pool:gol  (~(got by pools.store) pin.id)
  =/  =goal:gol  (~(got by goals.pool) id)
  ?-  method
    %any  !=(~ (~(int in tags) tags.goal))
    %all  =(tags (~(int in tags) tags.goal))
  ==
::
++  dejs
  =,  dejs:format
  |%
  ++  view-parm
    ^-  $-(json parm:list-view:vyu)
    %-  ot
    :~  type+type
        first-gen-only+bo
        actionable-only+bo
        method+method
        tags+(as tag:dejs:j)
    ==
  ::
  ++  method
    ^-  $-(json ?(%any %all))
    =/  cuk  |=(=@t ;;(?(%any %all) t))
    =/  par  ;~(pose (jest 'any') (jest 'all'))
    (su (cook cuk par))
  ::
  ++  type
    ^-  $-(json type:list-view:vyu)
    %-  of
    :~  main+|=(jon=json ?>(?=(~ jon) ~))
        pool+pin:dejs:j
        goal+(ot ~[id+id:dejs:j ignore-virtual+bo])
    ==
  --
::
++  enjs
  =,  enjs:format
  |%
  ++  view-data
    |=  =data:list-view:vyu
    ^-  json
    a+(turn goals.data id-pack)
  ::
  ++  id-pack
    |=  [=id:gol =pack:list-view:vyu]
    ^-  json
    %-  pairs
    :~  [%id (enjs-id:j id)]
        [%pin s+(pool-id:j pin.pack)]
        [%pool-role ?~(pool-role.pack ~ s+u.pool-role.pack)]
        [%goal (enjs-goal:j (convert-to-goal pack))]
    ==
  ::
  ++  convert-to-goal
    |=  pack:list-view:vyu
    ^-  goal:gol
    =|  =goal:gol
    %=  goal
      par                  par
      kids                 kids
      kickoff              kickoff
      deadline             deadline
      complete             complete
      actionable           actionable
      chief                chief
      spawn                spawn
      owner                owner
      birth                birth
      author               author
      desc                 desc
      note                 note
      tags                 tags
      fields               fields
      stock                stock
      ranks                ranks
      young                young
      young-by-precedence  young-by-precedence
      young-by-kickoff     young-by-kickoff
      young-by-deadline    young-by-deadline
      progress             progress
      prio-left            prio-left
      prio-ryte            prio-ryte
      prec-left            prec-left
      prec-ryte            prec-ryte
      nest-left            nest-ryte
    ==
  ::
  ++  view-diff
    |=  =diff:list-view:vyu
    ^-  json
    %-  pairs
    :~  :-  %hed
        %-  pairs
        :~  [%pin s+(pool-id:j pin.diff)]
        ==
        :-  %tel
        %+  frond  %list-view
        ?>  ?=(%replace +<.diff)
        :-  %a
        %+  turn
          `(list [id:gol pack:list-view:vyu])`+>.diff
        id-pack
    ==
  ::
  ++  view-parm
    |=  =parm:list-view:vyu
    ^-  json
    %-  pairs
    :~  [%type (type type.parm)]
        [%first-gen-only b+first-gen-only.parm]
        [%actionable-only b+actionable-only.parm]
        [%method s+method.parm]
        [%tags a+(turn ~(tap in tags.parm) enjs-tag:j)]
    ==
  ++  type
    |=  =type:list-view:vyu
    ^-  json
    ?-    -.type
      %main  (frond %main ~)
      %pool  (frond %pool s+(pool-id:j pin.type))
      ::
        %goal
      %+  frond  %goal
      %-  pairs
      :~  [%id (enjs-id:j id.type)]
          [%ignore-virtual b+ignore-virtual.type]
      ==
    ==
  --
--
