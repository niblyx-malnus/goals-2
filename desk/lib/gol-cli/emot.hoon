/-  gol=goals, act=action
/+  *gol-cli-util, pl=gol-cli-pool, nd=gol-cli-node, tv=gol-cli-traverse,
     gol-cli-goals, gs=gol-cli-state
::
|_  [=bowl:gall cards=(list card:agent:gall) [state-5-12:gs =trace:gol]]
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
++  spawn-pool
  |=  [own=ship now=@da]
  ^-  pool:gol
  :*  (unique-pin own now)  ~  ~
      (~(put by *perms:gol) own `%owner)
  ==
::
++  clone-pool
  |=  [=old=pin:gol title=@t own=ship now=@da]
  ^-  [pin:gol pool:gol]
  =/  old-pool  (~(got by pools.store) old-pin)
  :: =/  [=pin:gol =pool:gol]  (spawn-pool title own now)
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
      %spawn-goal
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  =id:gol  (unique-id:gols pin now.bowl)
    :: edit permissions implied in the success of spawn-goal
    =/  pore  (spawn-goal:(apex:pl old) id upid mod)
    :: mark the goal started if possible
    =/  new=pool:gol
      ?~  upor=(mole |.((mark-done:pore k+id mod)))
        abet:pore
      abet:u.upor
    =.  pools.store         (~(put by pools.store) pin new)
    =/  data=pool-data:gol  (~(got by pool-info.store) pin)
    =/  fields=(map @t @t)  (~(gut by fields.data) id ~)
    =.  fields              (~(put by fields) 'description' desc)
    =.  fields.data         (~(put by fields.data) id fields)
    =.  pool-info.store     (~(put by pool-info.store) pin data)
    this
    ::
      %cache-goal
    =+  axn
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(cache-goal:(apex:pl old) id mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ::
      %renew-goal
    =+  axn
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(renew-goal:(apex:pl old) id mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ::
      %trash-goal
    =+  axn
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    ?:  (~(has by goals.old) id)
      =/  new=pool:gol  abet:(waste-goal:(apex:pl old) id mod)
      =.  pools.store        (~(put by pools.store) pin new)
      this
    =/  new=pool:gol  abet:(trash-goal:(apex:pl old) id mod)
    =.  pools.store        (~(put by pools.store) pin new)
    =/  prog               ~(tap in (~(progeny tv cache.old) id))
    this
    ::
      %move
    =+  axn
    =/  =pin:gol  pin.cid
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
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(mark-actionable:(apex:pl old) id mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ::
      %mark-complete
    =+  axn
    =/  =pin:gol  pin.id
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
    (handle-action:this [%mark-complete u.par])
    ::
      %unmark-actionable
    =+  axn
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(unmark-actionable:(apex:pl old) id mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ::
      %unmark-complete
    =+  axn
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(unmark-complete:(apex:pl old) id mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ::
      %set-kickoff
    =+  axn
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(set-kickoff:(apex:pl old) id kickoff mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ::
      %set-deadline
    =+  axn
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol  abet:(set-deadline:(apex:pl old) id deadline mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
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
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    =/  new=pool:gol
      =/  pore  (set-chief:(apex:pl old) id chief rec mod)
      abet:(replace-deputies:pore id deputies mod)
    =.  pools.store  (~(put by pools.store) pin new)
    this
    ::
      %edit-goal-desc
    =+  axn
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    ?>  (check-goal-edit-perm:(apex:pl old) id mod)
    =/  data=pool-data:gol  (~(got by pool-info.store) pin)
    =/  fields=(map @t @t)  (~(gut by fields.data) id ~)
    =.  fields              (~(put by fields) 'description' desc)
    =.  fields.data         (~(put by fields.data) id fields)
    =.  pool-info.store     (~(put by pool-info.store) pin data)
    this
    ::
      %edit-goal-note
    =+  axn
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    ?>  (check-goal-edit-perm:(apex:pl old) id mod)
    =/  data=pool-data:gol  (~(got by pool-info.store) pin)
    =/  fields=(map @t @t)  (~(gut by fields.data) id ~)
    =.  fields              (~(put by fields) 'note' note)
    =.  fields.data         (~(put by fields.data) id fields)
    =.  pool-info.store     (~(put by pool-info.store) pin data)
    this
    ::
      %add-goal-tag
    ~&  'adding-goal-tag...'
    =+  axn
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    :: ?<  private.tag
    ?>  (check-goal-edit-perm:(apex:pl old) id mod)
    =/  data=pool-data:gol  (~(got by pool-info.store) pin)
    =/  tags=(set @t)       (~(gut by tags.data) id ~)
    =.  tags                (~(put in tags) tag)
    =.  tags.data           (~(put by tags.data) id tags)
    =.  pool-info.store     (~(put by pool-info.store) pin data)
    this
    ::
      %del-goal-tag
    =+  axn
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    :: ?<  private.tag
    ?>  (check-goal-edit-perm:(apex:pl old) id mod)
    =/  data=pool-data:gol  (~(got by pool-info.store) pin)
    =/  tags=(set @t)       (~(gut by tags.data) id ~)
    =.  tags                (~(del in tags) tag)
    =.  tags.data           (~(put by tags.data) id tags)
    =.  pool-info.store     (~(put by pool-info.store) pin data)
    this
    ::
      %put-goal-tags
    =+  axn
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    ?>  (check-goal-edit-perm:(apex:pl old) id mod)
    =/  data=pool-data:gol  (~(got by pool-info.store) pin)
    =/  tags=(set @t)       (~(gut by tags.data) id ~)
    =.  tags                (~(uni in tags) new-tags)
    =.  tags.data           (~(put by tags.data) id tags)
    =.  pool-info.store     (~(put by pool-info.store) pin data)
    this
    ::
      %put-private-tags
    =+  axn
    =/  =pin:gol  pin.id
    ?>  =(src our):bowl
    :: ?>  (~(all in tags) |=(=tag:gol private.tag)) 
    =/  gl=goal-local:gol
      ?~  get=(~(get by goals.local.store) id)
        *goal-local:gol
      u.get
    =.  tags.gl  tags
    =.  goals.local.store  (~(put by goals.local.store) id gl)
    =/  =pool:gol  (~(got by pools.store) pin)
    =/  =goal:gol  (~(got by goals.pool) id)
    this
    ::
      %add-field-data
    =+  axn
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    ?>  (check-goal-edit-perm:(apex:pl old) id mod)
    =/  data=pool-data:gol  (~(got by pool-info.store) pin)
    =/  fields=(map @t @t)  (~(gut by fields.data) id ~)
    =.  fields              (~(put by fields) field dat)
    =.  fields.data         (~(put by fields.data) id fields)
    =.  pool-info.store     (~(put by pool-info.store) pin data)
    this
    ::
      %del-field-data
    =+  axn
    =/  =pin:gol  pin.id
    =/  old=pool:gol  (~(got by pools.store) pin)
    ?>  (check-goal-edit-perm:(apex:pl old) id mod)
    =/  data=pool-data:gol  (~(got by pool-info.store) pin)
    =/  fields=(map @t @t)  (~(gut by fields.data) id ~)
    =.  fields              (~(del by fields) field)
    =.  fields.data         (~(put by fields.data) id fields)
    =.  pool-info.store     (~(put by pool-info.store) pin data)
    this
    :: 
      %edit-pool-title
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    ?>  (check-pool-edit-perm:(apex:pl old) mod)
    =|  =pool-data:gol
    =.  properties.pool-data  (~(put by *(map @t @t)) 'title' title)
    =.  pool-info.store  (~(put by pool-info.store) pin pool-data)
    this
    :: 
      %edit-pool-note
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pin)
    ?>  (check-pool-edit-perm:(apex:pl old) mod)
    =|  =pool-data:gol
    =.  properties.pool-data  (~(put by *(map @t @t)) 'note' note)
    =.  pool-info.store  (~(put by pool-info.store) pin pool-data)
    this
    ::
      %spawn-pool
    =+  axn
    ?>  =(src our):bowl
    =/  =pool:gol    (spawn-pool [src now]:bowl)
    =.  pools.store  (~(put by pools.store) pin.pool pool)
    =|  =pool-data:gol
    =.  properties.pool-data  (~(put by *(map @t @t)) 'title' title)
    =.  pool-info.store  (~(put by pool-info.store) pin.pool pool-data)
    this
    ::
      %clone-pool
    =+  axn
    ?>  =(src our):bowl
    =/  [=pin:gol =pool:gol]  (clone-pool pin title [src now]:bowl)
    =.  pools.store  (~(put by pools.store) pin pool)
    this
    ::
      %trash-pool
    :: TODO: purge locals; purge order
    =+  axn
    ?>  =(src our):bowl
    ?>  =(src.bowl host.pin)
    :: TODO: implement pool deletion
    this
    ::
      %slot-above
    =+  axn
    ?~  idx=(find [dis]~ order.local.store)  !!
    =.  order.local.store  (oust [u.idx 1] order.local.store)
    ?~  idx=(find [dat]~ order.local.store)  !!
    =.  order.local.store  (into order.local.store u.idx dis)
    this
    ::
      %slot-below
    =+  axn
    ?~  idx=(find [dis]~ order.local.store)  !!
    =.  order.local.store  (oust [u.idx 1] order.local.store)
    ?~  idx=(find [dat]~ order.local.store)  !!
    =.  order.local.store  (into order.local.store +(u.idx) dis)
    this
  ==
--
