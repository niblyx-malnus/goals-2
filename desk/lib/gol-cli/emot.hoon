/-  gol=goals, act=action
/+  *gol-cli-util, pl=gol-cli-pool, nd=gol-cli-node, tv=gol-cli-traverse,
     gol-cli-goals, gs=gol-cli-state
::
|_  [=bowl:gall cards=(list card:agent:gall) [state-5-28:gs =trace:gol]]
+*  this   .
    state  +<+>
    gols   ~(. gol-cli-goals store)
+$  card  card:agent:gall
++  abet  [(flop cards) state]
++  emit  |=(=card this(cards [card cards]))
++  emil  |=(cadz=(list card) this(cards (weld cadz cards)))
::
:: ============================================================================
:: 
:: HELPERS
::
:: ============================================================================
::
++  unique-pin
  |=  [own=ship now=@da]
  ^-  pid:gol
  =/  =pid:gol  [own (scot %da now)]
  ?.  (~(has by pools.store) pid)
    pid
  $(now (add now ~s0..0001))
::
++  create-pool
  |=  [own=ship now=@da title=@t]
  ^-  pool:gol
  :*  (unique-pin own now)
      title
      (~(put by *perms:gol) own %owner)
      ~  ~  [~ ~]
  ==
::
++  clone-pool
  |=  [=old=pid:gol title=@t own=ship now=@da]
  ^-  [pid:gol pool:gol]
  =/  old-pool  (~(got by pools.store) old-pid)
  :: =/  [=pid:gol =pool:gol]  (create-pool title own now)
  :: =.  pool  pool(goals goals:(clone-goals:gols goals.old-pool pid now))
  !! :: [pid (inflate-pool:fl pool)]
:: ============================================================================
:: 
:: UPDATES
::
:: ============================================================================
::
++  handle-action
  |=  axn=action:act
  ^-  _this
  =/  mod  src.bowl
  ?-    -.axn
      %reorder-roots
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(reorder-roots:(apex:pl old) roots mod)
    this(pools.store (~(put by pools.store) pid new))
    ::
      %reorder-children
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  =goal:gol     (~(got by goals.old) gid)
    =/  new=pool:gol  abet:(reorder-children:(apex:pl old) gid children mod)
    this(pools.store (~(put by pools.store) pid new))
    ::
      %reorder-archive
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(reorder-archive:(apex:pl old) context archive mod)
    this(pools.store (~(put by pools.store) pid new))
    ::
      %create-goal
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  =gid:gol      (unique-id:gols pid now.bowl)
    =/  new=pool:gol
      abet:(create-goal:(apex:pl old) gid upid summary now.bowl mod)
    =.  goal-order.local.store  [[pid gid] goal-order.local.store]
    =.  pools.store   (~(put by pools.store) pid new)
    :: mark the goal started if active.axn and if possible
    ::
    ?.  active  this
    ?~  dis=(mole |.((handle-action:this [%mark-active pid gid])))
      this
    u.dis
    ::
      %create-goal-with-tag
    !!
    :: =+  axn
    :: =/  old=pool:gol  (~(got by pools.store) pid)
    :: =/  =gid:gol  (unique-id:gols pid now.bowl)
    :: :: edit permissions implied in the success of spawn-goal
    :: :: mark the goal started if possible
    :: =/  new=pool:gol
    ::   abet:(create-goal:(apex:pl old) gid upid summary now.bowl mod)
    :: =.  goal-order.local.store  [[pid gid] goal-order.local.store]
    :: :: add the pool tag
    :: =/  data=pool-data:gol  (~(gut by pool-info.store) pid *pool-data:gol)
    :: =.  tags.data           (~(put by tags.data) gid (sy ~[tag]))
    :: =.  pool-info.store     (~(put by pool-info.store) pid data)
    :: this(pools.store (~(put by pools.store) pid new))
    ::
      %archive-goal
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(archive-goal:(apex:pl old) gid mod)
    =.  pools.store  (~(put by pools.store) pid new)
    this
    ::
      %restore-goal
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(restore-goal:(apex:pl old) gid mod)
    =.  pools.store  (~(put by pools.store) pid new)
    this
    ::
      %restore-to-root
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(restore-to-root:(apex:pl old) gid mod)
    =.  pools.store  (~(put by pools.store) pid new)
    this
    ::
      %delete-from-archive
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(delete-from-archive:(apex:pl old) gid mod)
    =.  pools.store  (~(put by pools.store) pid new)
    this
    ::
      %delete-goal
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(delete-goal:(apex:pl old) gid mod)
    =.  pools.store   (~(put by pools.store) pid new)
    ?~  idx=(find [gid]~ goal-order.local.store)  this
    =.  goal-order.local.store  (oust [u.idx 1] goal-order.local.store)
    this
    ::
      %move
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(move:(apex:pl old) cid upid mod)
    =.  pools.store   (~(put by pools.store) pid new)
    this
    ::
      %yoke
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(plex-sequence:(apex:pl old) yoks mod)
    =.  pools.store   (~(put by pools.store) pid new)
    this
    ::
      %mark-actionable
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(mark-actionable:(apex:pl old) gid mod)
    =.  pools.store   (~(put by pools.store) pid new)
    this
    ::
      %unmark-actionable
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(unmark-actionable:(apex:pl old) gid mod)
    =.  pools.store  (~(put by pools.store) pid new)
    this
    ::
      %mark-complete
    =+  axn
    =.  this  (handle-action [%mark-active pid gid])
    =/  old=pool:gol  (~(got by pools.store) pid)
    ~&  %marking-complete
    =/  pore
      ?:  done.i.status.start:(~(got by goals.old) gid)
        (apex:pl old)
      (mark-done:(apex:pl old) s+gid now.bowl mod)
    =/  new=pool:gol  abet:(mark-done:pore e+gid now.bowl mod)
    =.  pools.store  (~(put by pools.store) pid new)
    :: automatically complete parent if all its children are complete
    ::
    =/  parent=(unit gid:gol)  parent:(~(got by goals.new) gid)
    ?~  parent  this
    ?.  %-  ~(all in (~(young nd goals.new) u.parent))
        |=(=gid:gol done.i.status:(~(got-node nd goals.new) e+gid))
      this
    :: TODO: make this only occur if has permissions on ancestors...
    :: owner responsible for resulting completions
    =.  src.bowl  our.bowl
    (handle-action:this [%mark-complete pid u.parent])
    ::
      %unmark-complete
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    ~&  %unmarking-complete
    =/  pore  (unmark-done:(apex:pl old) e+gid now.bowl mod)
    =/  new=pool:gol
      :: Unmark start done if possible
      =/  mul  (mule |.((unmark-done:pore s+gid now.bowl mod)))
      ?-  -.mul
        %&  abet:p.mul
        %|  ((slog p.mul) abet:pore)
      ==
    this(pools.store (~(put by pools.store) pid new))
    ::
      %mark-active
    =+  axn
    :: automatically mark parent active if possible
    =/  parent=(unit gid:gol)
      parent:(~(got by goals:(~(got by pools.store) pid)) gid)
    =?  this  ?=(^ parent)
      (handle-action:this [%mark-active pid u.parent])
    ~&  %marking-active
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(mark-done:(apex:pl old) s+gid now.bowl mod)
    this(pools.store (~(put by pools.store) pid new))
    ::
      %unmark-active
    =+  axn
    :: automatically unmark child active if possible
    =/  children=(list gid:gol)
      children:(~(got by goals:(~(got by pools.store) pid)) gid)
    =.  this
      |-
      ?~  children
        this
      (handle-action:this [%unmark-active pid i.children])
    ~&  %unmarking-active
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(unmark-done:(apex:pl old) s+gid now.bowl mod)
    this(pools.store (~(put by pools.store) pid new))
    ::
      %set-summary
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(set-summary:(apex:pl old) gid summary mod)
    =.  pools.store  (~(put by pools.store) pid new)
    this
    ::
      %set-pool-title
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(set-pool-title:(apex:pl old) title mod)
    =.  pools.store  (~(put by pools.store) pid new)
    this
    ::
      %set-start
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(set-start:(apex:pl old) gid start mod)
    =.  pools.store  (~(put by pools.store) pid new)
    this
    ::
      %set-end
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(set-end:(apex:pl old) gid end mod)
    =.  pools.store  (~(put by pools.store) pid new)
    this
    ::
      %pools-slot-above
    =+  axn
    ?~  idx=(find [dis]~ pool-order.local.store)  !!
    =.  pool-order.local.store  (oust [u.idx 1] pool-order.local.store)
    ?~  idx=(find [dat]~ pool-order.local.store)  !!
    =.  pool-order.local.store  (into pool-order.local.store u.idx dis)
    this
    ::
      %pools-slot-below
    =+  axn
    ?~  idx=(find [dis]~ pool-order.local.store)  !!
    =.  pool-order.local.store  (oust [u.idx 1] pool-order.local.store)
    ?~  idx=(find [dat]~ pool-order.local.store)  !!
    =.  pool-order.local.store  (into pool-order.local.store +(u.idx) dis)
    this
    ::
      %goals-slot-above
    =+  axn
    ?~  idx=(find [dis]~ goal-order.local.store)  !!
    =.  goal-order.local.store  (oust [u.idx 1] goal-order.local.store)
    ?~  idx=(find [dat]~ goal-order.local.store)  !!
    =.  goal-order.local.store  (into goal-order.local.store u.idx dis)
    this
    ::
      %goals-slot-below
    =+  axn
    ?~  idx=(find [dis]~ goal-order.local.store)  !!
    =.  goal-order.local.store  (oust [u.idx 1] goal-order.local.store)
    ?~  idx=(find [dat]~ goal-order.local.store)  !!
    =.  goal-order.local.store  (into goal-order.local.store +(u.idx) dis)
    this
    ::
      %put-collection
    =/  cos=(map @ta collection:gol)
      (fall (~(get of collections.local.store) (snip path.axn)) ~)
    =.  cos  (~(put by cos) (rear path.axn) collection.axn)
    =.  collections.local.store
      (~(put of collections.local.store) (snip path.axn) cos)
    this
    ::
      %del-collection
    =/  cos=(map @ta collection:gol)
      (fall (~(get of collections.local.store) (snip path.axn)) ~)
    =.  cos  (~(del by cos) (rear path.axn))
    =.  collections.local.store
      ?~  cos
        (~(del of collections.local.store) (snip path.axn))
      (~(put of collections.local.store) (snip path.axn) cos)
    this
    ::
      %put-module
    !!
    ::
      %del-module
    !!
    ::
      %update-pool-perms
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    |^
    =/  new=pool:gol
      =/  upds  (perms-to-upds new)
      =/  pore  (apex:pl old)
      |-  ?~  upds  abet:pore
      %=  $
        upds  t.upds
        pore  (set-pool-role:pore ship.i.upds role.i.upds mod)
      ==
    =.  pools.store  (~(put by pools.store) pid new)
    this
    ++  perms-to-upds
      |=  new=perms:gol
      ^-  (list [=ship role=(unit role:gol)])
      =/  upds  
        %+  turn
          ~(tap by new)
        |=  [=ship =role:gol]
        [ship (some role)]
      %+  weld
        upds
      ^-  (list [=ship role=(unit role:gol)])
      %+  turn
        ~(tap in (~(dif in ~(key by perms.old)) ~(key by new)))
      |=(=ship [ship ~])
    --
    ::
      %update-goal-perms
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol
      =/  pore  (set-chief:(apex:pl old) gid chief rec mod)
      abet:(replace-deputies:pore gid deputies mod)
    =.  pools.store  (~(put by pools.store) pid new)
    this
    ::
      %update-local-goal-tags
    =+  axn
    ?>  =(src our):bowl
    =/  tags=(set @t)  (~(gut by tags.local.store) key.axn ~)
    =.  tags
      ?-  -.p.axn
        %&  (~(uni in tags) p.p.axn)
        %|  (~(dif in tags) p.p.axn)
      ==
    this(tags.local.store (~(put by tags.local.store) key.axn tags))
    ::
      %update-local-goal-field
    =+  axn
    ?>  =(src our):bowl
    =/  fields=(map @t @t)  (~(gut by fields.local.store) key.axn ~)
    =.  fields
      ?-  -.p.axn
        %&  (~(put by fields) p.p.axn)
        %|  (~(del by fields) p.p.axn)
      ==
    this(fields.local.store (~(put by fields.local.store) key.axn fields))
    ::
      %update-local-tag-property
    ?>  =(src our):bowl
    =/  properties  (~(gut by tag-properties.local.store) tag.axn ~)
    =.  properties
      ?-  -.p.axn
        %&  (~(put by properties) p.p.axn)
        %|  (~(del by properties) p.p.axn)
      ==
    =.  tag-properties.local.store
      (~(put by tag-properties.local.store) tag.axn properties)
    this
    ::
      %update-local-field-property
    ?>  =(src our):bowl
    =/  properties  (~(gut by field-properties.local.store) field.axn ~)
    =.  properties
      ?-  -.p.axn
        %&  (~(put by properties) p.p.axn)
        %|  (~(del by properties) p.p.axn)
      ==
    =.  field-properties.local.store
      (~(put by field-properties.local.store) field.axn properties)
    this
    ::
      %del-local-tag
    this(tag-properties.local.store (~(del by tag-properties.local.store) tag.axn))
    ::
      %del-local-field
    this(field-properties.local.store (~(del by field-properties.local.store) field.axn))
    ::
      %create-pool
    =+  axn
    ?>  =(src our):bowl
    =/  =pool:gol    (create-pool src.bowl now.bowl title)
    =.  pools.store  (~(put by pools.store) pid.pool pool)
    =.  pool-order.local.store  [pid.pool pool-order.local.store]
    this
    ::
      %delete-pool
    :: TODO: purge locals; purge order
    =+  axn
    ?>  =(src our):bowl
    ?>  =(src.bowl host.pid)
    =.  pools.store  (~(del by pools.store) pid)
    ?~  idx=(find [pid]~ pool-order.local.store)  this
    =.  pool-order.local.store  (oust [u.idx 1] pool-order.local.store)
    this
    ::
      %update-pool-property
    =/  old=pool:gol  (~(got by pools.store) pid.axn)
    ?>  (check-pool-edit-perm:(apex:pl old) mod)
    =/  data=pool-data:gol  (~(gut by pool-info.store) pid.axn *pool-data:gol)
    =.  properties.data
      ?-  -.p.axn
        %&  (~(put by properties.data) p.p.axn)
        %|  (~(del by properties.data) p.p.axn)
      ==
    this(pool-info.store (~(put by pool-info.store) pid.axn data))
    ::
      %update-pool-tag-property
    =/  old=pool:gol  (~(got by pools.store) pid.axn)
    ?>  (check-pool-edit-perm:(apex:pl old) mod)
    =/  data=pool-data:gol  (~(gut by pool-info.store) pid.axn *pool-data:gol)
    =/  properties  (~(gut by tag-properties.data) tag.axn ~)
    =.  properties
      ?-  -.p.axn
        %&  (~(put by properties) p.p.axn)
        %|  (~(del by properties) p.p.axn)
      ==
    =.  tag-properties.data
      (~(put by tag-properties.data) tag.axn properties)
    this(pool-info.store (~(put by pool-info.store) pid.axn data))
    ::
      %update-pool-field-property
    =/  old=pool:gol  (~(got by pools.store) pid.axn)
    ?>  (check-pool-edit-perm:(apex:pl old) mod)
    =/  data=pool-data:gol  (~(gut by pool-info.store) pid.axn *pool-data:gol)
    =/  properties  (~(gut by field-properties.data) field.axn ~)
    =.  properties
      ?-  -.p.axn
        %&  (~(put by properties) p.p.axn)
        %|  (~(del by properties) p.p.axn)
      ==
    =.  field-properties.data
      (~(put by field-properties.data) field.axn properties)
    this(pool-info.store (~(put by pool-info.store) pid.axn data))
    ::
      %update-goal-field
    =/  old=pool:gol  (~(got by pools.store) pid.axn)
    ?>  (check-goal-edit-perm:(apex:pl old) gid.axn mod)
    =/  data=pool-data:gol  (~(gut by pool-info.store) pid.axn *pool-data:gol)
    =/  fields=(map @t @t)  (~(gut by fields.data) gid.axn ~)
    =.  fields
      ?-  -.p.axn
        %&  (~(put by fields) p.p.axn)
        %|  (~(del by fields) p.p.axn)
      ==
    =.  fields.data         (~(put by fields.data) gid.axn fields)
    this(pool-info.store (~(put by pool-info.store) pid.axn data))
    ::
      %update-goal-tags
    =/  old=pool:gol  (~(got by pools.store) pid.key.axn)
    ?>  (check-goal-edit-perm:(apex:pl old) gid.key.axn mod)
    =/  data=pool-data:gol  (~(gut by pool-info.store) pid.key.axn *pool-data:gol)
    =/  tags=(set @t)       (~(gut by tags.data) gid.key.axn ~)
    =.  tags
      ?-  -.p.axn
        %&  (~(uni in tags) p.p.axn)
        %|  (~(dif in tags) p.p.axn)
      ==
    =.  tags.data           (~(put by tags.data) gid.key.axn tags)
    this(pool-info.store (~(put by pool-info.store) pid.key.axn data))
    ::
      %update-setting
    =,  local.store
    ?-  -.p.axn
      %&  this(settings.local.store (~(put by settings) p.p.axn))
      %|  this(settings.local.store (~(del by settings) p.p.axn))
    ==
  ==
--
