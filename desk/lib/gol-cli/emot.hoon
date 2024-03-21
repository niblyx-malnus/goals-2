/-  gol=goals, act=action
/+  *gol-cli-util, pl=gol-cli-pool, nd=gol-cli-node, tv=gol-cli-traverse,
     gol-cli-goals, gs=gol-cli-state
::
|_  [=bowl:gall cards=(list card:agent:gall) state-5-30:gs]
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
++  create-pool
  |=  [=pid:gol own=ship title=@t]
  ^-  pool:gol
  ?<  (~(has by pools.store) pid)
  :*  pid
      title
      (~(put by *perms:gol) own %owner)
      ~  ~  [~ ~]  ~  ~
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
++  handle-transition
  |=  tan=transition:act
  ^-  _this
  ?>  =(src our):bowl
  ?-    -.tan
      %create-pool
    ?>  =(our.bowl host.pid.tan)
    =/  =pool:gol    (create-pool pid.tan src.bowl title.tan)
    =.  pools.store  (~(put by pools.store) pid.tan pool)
    =.  pool-order.local.store  [pid.tan pool-order.local.store]
    this
    ::
      %delete-pool
    :: TODO: purge locals; purge order
    ?>  =(our.bowl host.pid.tan)
    =.  pools.store  (~(del by pools.store) pid.tan)
    ?~  idx=(find [pid.tan]~ pool-order.local.store)  this
    =.  pool-order.local.store  (oust [u.idx 1] pool-order.local.store)
    this
  ==
::
++  handle-action
  |=  [mod=ship axn=action:act]
  ^-  _this
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
    ?~  dis=(mole |.((handle-action:this mod [%set-active pid gid %&])))
      this
    u.dis
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
      %set-actionable
    =+  axn
    =/  old=pool:gol  (~(got by pools.store) pid)
    =/  new=pool:gol  abet:(set-actionable:(apex:pl old) gid val mod)
    =.  pools.store   (~(put by pools.store) pid new)
    this
    ::
      %set-complete
    =+  axn
    ?-    val
        %&
      =.  this  (handle-action mod [%set-active pid gid %&])
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
      (handle-action:this our.bowl [%set-complete pid u.parent %&])
      ::
        %|
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
    ==
    ::
      %set-active
    =+  axn
    ?-    val
        %&
      :: automatically mark parent active if possible
      =/  parent=(unit gid:gol)
        parent:(~(got by goals:(~(got by pools.store) pid)) gid)
      =?  this  ?=(^ parent)
        (handle-action:this mod [%set-active pid u.parent %&])
      ~&  %marking-active
      =/  old=pool:gol  (~(got by pools.store) pid)
      =/  new=pool:gol  abet:(mark-done:(apex:pl old) s+gid now.bowl mod)
      this(pools.store (~(put by pools.store) pid new))
      ::
        %|
      :: automatically unmark child active if possible
      =/  children=(list gid:gol)
        children:(~(got by goals:(~(got by pools.store) pid)) gid)
      =.  this
        |-
        ?~  children
          this
        (handle-action:this mod [%set-active pid i.children %|])
      ~&  %unmarking-active
      =/  old=pool:gol  (~(got by pools.store) pid)
      =/  new=pool:gol  abet:(unmark-done:(apex:pl old) s+gid now.bowl mod)
      this(pools.store (~(put by pools.store) pid new))
    ==
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
      %set-chief
    =/  old=pool:gol  (~(got by pools.store) pid.axn)
    =/  new=pool:gol  abet:(set-chief:(apex:pl old) gid.axn chief.axn rec.axn mod)
    this(pools.store (~(put by pools.store) pid.axn new))
    ::
      %set-open-to
    =/  old=pool:gol  (~(got by pools.store) pid.axn)
    =/  new=pool:gol  abet:(set-open-to:(apex:pl old) gid.axn open-to.axn mod)
    this(pools.store (~(put by pools.store) pid.axn new))
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
      %update-local-goal-metadata
    ?>  =(src our):bowl
    =/  goal-metadata=(map @t json)  (~(gut by goal-metadata.local.store) key.axn ~)
    =.  goal-metadata
      ?-  -.p.axn
        %&  (~(put by goal-metadata) p.p.axn)
        %|  (~(del by goal-metadata) p.p.axn)
      ==
    this(goal-metadata.local.store (~(put by goal-metadata.local.store) key.axn goal-metadata))
    ::
      %update-local-pool-metadata
    ?>  =(src our):bowl
    =/  pool-metadata=(map @t json)  (~(gut by pool-metadata.local.store) pid.axn ~)
    =.  pool-metadata
      ?-  -.p.axn
        %&  (~(put by pool-metadata) p.p.axn)
        %|  (~(del by pool-metadata) p.p.axn)
      ==
    this(pool-metadata.local.store (~(put by pool-metadata.local.store) pid.axn pool-metadata))
    ::
      %update-local-metadata-field
    ?>  =(src our):bowl
    =/  properties  (~(gut by metadata-properties.local.store) field.axn ~)
    =.  properties
      ?-  -.p.axn
        %&  (~(put by properties) p.p.axn)
        %|  (~(del by properties) p.p.axn)
      ==
    %=    this
        metadata-properties.local.store
      (~(put by metadata-properties.local.store) field.axn properties)
    ==
    ::
      %delete-local-metadata-field
    this(metadata-properties.local.store (~(del by metadata-properties.local.store) field.axn))
    ::
      %update-pool-metadata
    =/  old=pool:gol  (~(got by pools.store) pid.axn)
    =/  new=pool:gol
      abet:(update-pool-metadata:(apex:pl old) p.axn mod)
    this(pools.store (~(put by pools.store) pid.axn new))
    ::
      %update-pool-metadata-field
    =/  old=pool:gol  (~(got by pools.store) pid.axn)
    =/  new=pool:gol
      abet:(update-pool-metadata-field:(apex:pl old) field.axn p.axn mod)
    this(pools.store (~(put by pools.store) pid.axn new))
    ::
      %delete-pool-metadata-field
    =/  old=pool:gol  (~(got by pools.store) pid.axn)
    =/  new=pool:gol
      abet:(delete-pool-metadata-field:(apex:pl old) field.axn mod)
    this(pools.store (~(put by pools.store) pid.axn new))
    ::
    %create-pool  !!
    %delete-pool  !!
    ::
      %update-goal-metadata
    =/  old=pool:gol  (~(got by pools.store) pid.axn)
    =/  new=pool:gol
      abet:(update-goal-metadata:(apex:pl old) gid.axn p.axn mod)
    this(pools.store (~(put by pools.store) pid.axn new))
    ::
      %update-setting
    ?>  =(src our):bowl
    =,  local.store
    ?-  -.p.axn
      %&  this(settings.local.store (~(put by settings) p.p.axn))
      %|  this(settings.local.store (~(del by settings) p.p.axn))
    ==
  ==
--
