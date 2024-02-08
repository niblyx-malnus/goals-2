/-  gol=goals, act=action
/+  *gol-cli-util, pl=gol-cli-pool, nd=gol-cli-node, tv=gol-cli-traverse,
     gol-cli-goals, gs=gol-cli-state
::
|_  [=bowl:gall cards=(list card:agent:gall) [state-5-23:gs =trace:gol]]
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
  ^-  pin:gol
  =/  =pin:gol  [own (scot %da now)]
  ?.  (~(has by pools.store) pin)
    pin
  $(now (add now ~s0..0001))
::
++  create-pool
  |=  [own=ship now=@da title=@t]
  ^-  pool:gol
  :*  (unique-pin own now)
      (~(put by *perms:gol) own `%owner)
      ~  ~  title
  ==
::
++  clone-pool
  |=  [=old=pin:gol title=@t own=ship now=@da]
  ^-  [pin:gol pool:gol]
  =/  old-pool  (~(got by pools.store) old-pin)
  :: =/  [=pin:gol =pool:gol]  (create-pool title own now)
  :: =.  pool  pool(goals goals:(clone-goals:gols goals.old-pool pin now))
  !! :: [pin (inflate-pool:fl pool)]
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
      %create-goal
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  =id:gol  (unique-id:gols pin now.bowl)
    :: edit permissions implied in the success of spawn-goal
    :: mark the goal started if possible
    =/  new=pool:gol
      abet:(create-goal:(apex:pl old) id upid summary mod)
    =.  goal-order.local.store  [[pin id] goal-order.local.store]
    this(pools.store (~(put by pools.store) pin new))
    ::
      %create-goal-with-tag
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  =id:gol  (unique-id:gols pin now.bowl)
    :: edit permissions implied in the success of spawn-goal
    :: mark the goal started if possible
    =/  new=pool:gol
      abet:(create-goal:(apex:pl old) id upid summary mod)
    =.  goal-order.local.store  [[pin id] goal-order.local.store]
    :: add the pool tag
    =/  data=pool-data:gol  (~(gut by pool-info.store) pin *pool-data:gol)
    =.  tags.data           (~(put by tags.data) id (sy ~[tag]))
    =.  pool-info.store     (~(put by pool-info.store) pin data)
    this(pools.store (~(put by pools.store) pin new))
    ::
      %archive-goal
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(archive-goal:(apex:pl old) id mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ::
      %restore-goal
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(restore-goal:(apex:pl old) id mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ::
      %delete-goal
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    ?:  (~(has by goals.old) id)
      =/  new=pool:gol  abet:(delete-goal:(apex:pl old) id mod)
      =.  pools.store        (~(put by pools.store) pin new)
      ?~  idx=(find [id]~ goal-order.local.store)  this
      =.  goal-order.local.store  (oust [u.idx 1] goal-order.local.store)
      this
    =/  new=pool:gol  abet:(delete-goal:(apex:pl old) id mod)
    =.  pools.store        (~(put by pools.store) pin new)
    ?~  idx=(find [id]~ goal-order.local.store)  this
    =.  goal-order.local.store  (oust [u.idx 1] goal-order.local.store)
    this
    ::
      %move
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(move:(apex:pl old) cid upid mod)
    =.  pools.store        (~(put by pools.store) pin new)
    this
    ::
      %yoke
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(plex-sequence:(apex:pl old) yoks mod)
    =.  pools.store        (~(put by pools.store) pin new)
    this
    ::
      %mark-actionable
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(mark-actionable:(apex:pl old) id mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ::
      %mark-complete
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(mark-complete:(apex:pl old) id mod)
    =.  pools.store  (~(put by pools.store) pin new)
    =/  par=(unit id:gol)  par:(~(got by goals.new) id)
    ?~  par  this
    ?.  %-  ~(all in (~(young nd goals.new) u.par))
        |=(=id:gol done:(~(got-node nd goals.new) d+id))
      this
    :: owner responsible for resulting completions
    =.  src.bowl  our.bowl
    (handle-action:this [%mark-complete pin u.par])
    ::
      %unmark-actionable
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(unmark-actionable:(apex:pl old) id mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ::
      %unmark-complete
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(unmark-complete:(apex:pl old) id mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ::
      %set-summary
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(set-summary:(apex:pl old) id summary mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ::
      %set-pool-title
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(set-pool-title:(apex:pl old) title mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ::
      %set-kickoff
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(set-kickoff:(apex:pl old) id kickoff mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ::
      %set-deadline
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(set-deadline:(apex:pl old) id deadline mod)
    =.  pools.store  (~(put by pools.store) pin new)
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
      %put-module
    !!
    ::
      %del-module
    !!
    ::
      %update-pool-perms
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    |^
    =/  new=pool:gol
      =/  upds  (perms-to-upds new)
      =/  pore  (apex:pl old)
      |-  ?~  upds  abet:pore
      %=  $
        upds  t.upds
        pore  (set-pool-role:pore ship.i.upds role.i.upds mod)
      ==
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ++  perms-to-upds
      |=  new=perms:gol
      ^-  (list [=ship role=(unit (unit role:gol))])
      =/  upds  
        %+  turn
          ~(tap by new)
        |=  [=ship role=(unit role:gol)]
        [ship (some role)]
      %+  weld
        upds
      ^-  (list [=ship role=(unit (unit role:gol))])
      %+  turn
        ~(tap in (~(dif in ~(key by perms.old)) ~(key by new)))
      |=(=ship [ship ~])
    --
    ::
      %update-goal-perms
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol
      =/  pore  (set-chief:(apex:pl old) id chief rec mod)
      abet:(replace-deputies:pore id deputies mod)
    =.  pools.store  (~(put by pools.store) pin new)
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
      %create-pool
    =+  axn
    ?>  =(src our):bowl
    =/  =pool:gol    (create-pool src.bowl now.bowl title)
    =.  pools.store  (~(put by pools.store) pin.pool pool)
    =.  pool-order.local.store  [pin.pool pool-order.local.store]
    this
    ::
      %delete-pool
    :: TODO: purge locals; purge order
    =+  axn
    ?>  =(src our):bowl
    ?>  =(src.bowl host.pin)
    =.  pools.store  (~(del by pools.store) pin)
    ?~  idx=(find [pin]~ pool-order.local.store)  this
    =.  pool-order.local.store  (oust [u.idx 1] pool-order.local.store)
    this
    ::
      %update-pool-property
    =/  old=pool:gol  (~(got by pools.store) pin.axn)
    ?>  (check-pool-edit-perm:(apex:pl old) mod)
    =/  data=pool-data:gol  (~(gut by pool-info.store) pin.axn *pool-data:gol)
    =.  properties.data
      ?-  -.p.axn
        %&  (~(put by properties.data) p.p.axn)
        %|  (~(del by properties.data) p.p.axn)
      ==
    this(pool-info.store (~(put by pool-info.store) pin.axn data))
    ::
      %update-pool-tag-property
    =/  old=pool:gol  (~(got by pools.store) pin.axn)
    ?>  (check-pool-edit-perm:(apex:pl old) mod)
    =/  data=pool-data:gol  (~(gut by pool-info.store) pin.axn *pool-data:gol)
    =/  properties  (~(gut by tag-properties.data) tag.axn ~)
    =.  properties
      ?-  -.p.axn
        %&  (~(put by properties) p.p.axn)
        %|  (~(del by properties) p.p.axn)
      ==
    =.  tag-properties.data
      (~(put by tag-properties.data) tag.axn properties)
    this(pool-info.store (~(put by pool-info.store) pin.axn data))
    ::
      %update-pool-field-property
    =/  old=pool:gol  (~(got by pools.store) pin.axn)
    ?>  (check-pool-edit-perm:(apex:pl old) mod)
    =/  data=pool-data:gol  (~(gut by pool-info.store) pin.axn *pool-data:gol)
    =/  properties  (~(gut by field-properties.data) field.axn ~)
    =.  properties
      ?-  -.p.axn
        %&  (~(put by properties) p.p.axn)
        %|  (~(del by properties) p.p.axn)
      ==
    =.  field-properties.data
      (~(put by field-properties.data) field.axn properties)
    this(pool-info.store (~(put by pool-info.store) pin.axn data))
    ::
      %update-goal-field
    =/  old=pool:gol  (~(got by pools.store) pin.axn)
    ?>  (check-goal-edit-perm:(apex:pl old) id.axn mod)
    =/  data=pool-data:gol  (~(gut by pool-info.store) pin.axn *pool-data:gol)
    =/  fields=(map @t @t)  (~(gut by fields.data) id.axn ~)
    =.  fields
      ?-  -.p.axn
        %&  (~(put by fields) p.p.axn)
        %|  (~(del by fields) p.p.axn)
      ==
    =.  fields.data         (~(put by fields.data) id.axn fields)
    this(pool-info.store (~(put by pool-info.store) pin.axn data))
    ::
      %update-goal-tags
    =/  old=pool:gol  (~(got by pools.store) pin.axn)
    ?>  (check-goal-edit-perm:(apex:pl old) id.axn mod)
    =/  data=pool-data:gol  (~(gut by pool-info.store) pin.axn *pool-data:gol)
    =/  tags=(set @t)       (~(gut by tags.data) id.axn ~)
    =.  tags
      ?-  -.p.axn
        %&  (~(uni in tags) p.p.axn)
        %|  (~(dif in tags) p.p.axn)
      ==
    =.  tags.data           (~(put by tags.data) id.axn tags)
    this(pool-info.store (~(put by pool-info.store) pin.axn data))
    ::
      %update-setting
    =,  local.store
    ?-  -.p.axn
      %&  this(settings.local.store (~(put by settings) p.p.axn))
      %|  this(settings.local.store (~(del by settings) p.p.axn))
    ==
  ==
--
