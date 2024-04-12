/-  gol=goals, p=pools, act=action
/+  ventio, *gol-cli-util, pools, sub-count,
    pl=gol-cli-pool, gol-cli-node, gol-cli-traverse,
    gol-cli-goals, gs=gol-cli-state, goj=gol-cli-json
|%
++  en-pool-path  |=(=pid:gol `path`/pool/(scot %p host.pid)/[name.pid])
++  de-pool-path
  |=  =path
  ^-  pid:gol
  =+  ;;([%pool host=@ta name=@ta ~] path)
  [(slav %p host) name]
::
++  agent
  |_  [=bowl:gall cards=(list card:agent:gall) state-5-30:gs]
  +*  this   .
      state  +<+>
      gols   ~(. gol-cli-goals store)
  +$  card  card:agent:gall
  ++  abet  [(flop cards) state]
  ++  emit  |=(=card this(cards [card cards]))
  ++  emil  |=(cadz=(list card) this(cards (weld cadz cards)))
  ::
  ++  handle-transition
    |=  tan=transition:act
    ^-  _this
    =.  this  (emit %give %fact ~[/transitions] goal-transition+!>(tan))
    ?-    -.tan
        %pool-order
      ?-    -.p.tan
          %&
        %=    this
            pool-order.local.store
          ;:  weld
            (swag [0 idx.p.p.tan] pool-order.local.store)
            pids.p.p.tan
            (slag idx.p.p.tan pool-order.local.store)
          ==
        ==
        ::
          %|
        |-
        ?~  pids.p.p.tan
          this
        :: this will oust all instances of i.pids.p.p.tan
        ::
        ?~  idx=(find [i.pids.p.p.tan]~ pool-order.local.store)
          $(pids.p.p.tan t.pids.p.p.tan)
        $(pool-order.local.store (oust [u.idx 1] pool-order.local.store))
      ==
      ::
        %goal-order
      ?-    -.p.tan
          %&
        %=    this
            goal-order.local.store
          ;:  weld
            (swag [0 idx.p.p.tan] goal-order.local.store)
            keys.p.p.tan
            (slag idx.p.p.tan goal-order.local.store)
          ==
        ==
        ::
          %|
        |-
        ?~  keys.p.p.tan
          this
        :: this will oust all instances of i.keys.p.p.tan
        ::
        ?~  idx=(find [i.keys.p.p.tan]~ goal-order.local.store)
          $(keys.p.p.tan t.keys.p.p.tan)
        $(goal-order.local.store (oust [u.idx 1] goal-order.local.store))
      ==
      ::
        %goal-metadata
      =/  goal-metadata=(map @t json)  (~(gut by goal-metadata.local.store) key.tan ~)
      =.  goal-metadata
        ?-  -.p.tan
          %&  (~(put by goal-metadata) p.p.tan)
          %|  (~(del by goal-metadata) p.p.tan)
        ==
      this(goal-metadata.local.store (~(put by goal-metadata.local.store) key.tan goal-metadata))
      ::
        %pool-metadata
      =/  pool-metadata=(map @t json)  (~(gut by pool-metadata.local.store) pid.tan ~)
      =.  pool-metadata
        ?-  -.p.tan
          %&  (~(put by pool-metadata) p.p.tan)
          %|  (~(del by pool-metadata) p.p.tan)
        ==
      this(pool-metadata.local.store (~(put by pool-metadata.local.store) pid.tan pool-metadata))
      ::
        %metadata-properties
      =/  properties  (~(gut by metadata-properties.local.store) field.tan ~)
      ?~  p.tan
        %=    this
            metadata-properties.local.store
          (~(del by metadata-properties.local.store) field.tan)
        ==
      =.  properties
        ?-  -.u.p.tan
          %&  (~(put by properties) p.u.p.tan)
          %|  (~(del by properties) p.u.p.tan)
        ==
      %=    this
          metadata-properties.local.store
        (~(put by metadata-properties.local.store) field.tan properties)
      ==
      ::
        %settings
      ?-    -.p.tan
          %&
        this(settings.local.store (~(put by settings.local.store) p.p.tan))
        ::
          %|
        this(settings.local.store (~(del by settings.local.store) p.p.tan))
      ==
      ::
        %create-pool
      ?>  =(our.bowl host.pid.tan)
      ?<  (~(has by pools.store) pid.tan)
      =|  =pool:gol
      =:  pid.pool    pid.tan
          title.pool  title.tan
          perms.pool  (~(put by *perms:gol) host.pid.tan %host)
        ==
      =.  pools.store  (~(put by pools.store) pid.tan pool)
      =.  pool-order.local.store  [pid.tan pool-order.local.store]
      this
      ::
        %delete-pool
      :: TODO: purge locals; purge order
      =.  pools.store  (~(del by pools.store) pid.tan)
      ?~  idx=(find [pid.tan]~ pool-order.local.store)  this
      =.  pool-order.local.store  (oust [u.idx 1] pool-order.local.store)
      this
      ::
        %update-pool
      =.  this  (handle-pool-transition [pid mod p]:tan)
      (emit %give %fact ~[(en-pool-path pid.tan)] goal-pool-transition+!>([mod p]:tan))
    ==
  ::
  ++  handle-pool-transition
    |=  [=pid:gol mod=ship tan=pool-transition:act]
    ^-  _this
    =/  old=pool:gol  (~(gut by pools.store) pid *pool:gol)
    =;  new=pool:gol
      this(pools.store (~(put by pools.store) pid new))
    ?-    -.tan
        $?  %init-pool
            %dag-yoke
            %dag-rend
            %break-bonds
            %partition
            %yoke
            %move-to-root
            %move-to-goal
            %move
            %reorder-roots
            %reorder-children
            %reorder-archive
            %set-actionable
            %mark-done
            %mark-undone
            %set-summary
            %set-pool-title
            %set-start
            %set-end
            %set-pool-role
            %set-chief
            %set-open-to
            %update-deputies
            %update-goal-metadata
            %update-pool-metadata
            %update-pool-metadata-field
            %delete-pool-metadata-field
        ==
      abet:(handle-pool-transition:(apex:pl old) mod tan)
      ::
        %create-goal
      abet:(create-goal:(apex:pl old) gid.tan upid.tan summary.tan now.tan mod)
      ::
        %archive-goal
      abet:(archive-goal:(apex:pl old) gid.tan mod)
      ::
        %restore-goal
      abet:(restore-goal:(apex:pl old) gid.tan mod)
      ::
        %restore-to-root
      abet:(restore-to-root:(apex:pl old) gid.tan mod)
      ::
        %delete-from-archive
      abet:(delete-from-archive:(apex:pl old) gid.tan mod)
      ::
        %delete-goal
      abet:(delete-goal:(apex:pl old) gid.tan mod)
    ==
  ::
  ++  handle-compound-transition
    |=  tan=compound-transition:act
    ^-  _this
    ?-    -.tan
        %pool-order-slot
      ?-    -.p.tan
          %& :: above
        =.  this  (handle-transition [%pool-order %| ~[dis.p.p.tan]])
        ?~  idx=(find [dat.p.p.tan]~ pool-order.local.store)  !!
        (handle-transition [%pool-order %& u.idx ~[dis.p.p.tan]])
        ::
          %| :: below
        =.  this  (handle-transition [%pool-order %| ~[dis.p.p.tan]])
        ?~  idx=(find [dat.p.p.tan]~ pool-order.local.store)  !!
        (handle-transition [%pool-order %& +(u.idx) ~[dis.p.p.tan]])
      ==
      ::
        %goal-order-slot
      ?-    -.p.tan
          %& :: above
        =.  this  (handle-transition [%goal-order %| ~[dis.p.p.tan]])
        ?~  idx=(find [dat.p.p.tan]~ goal-order.local.store)  !!
        (handle-transition [%goal-order %& u.idx ~[dis.p.p.tan]])
        ::
          %| :: below
        =.  this  (handle-transition [%goal-order %| ~[dis.p.p.tan]])
        ?~  idx=(find [dat.p.p.tan]~ goal-order.local.store)  !!
        (handle-transition [%goal-order %& +(u.idx) ~[dis.p.p.tan]])
      ==
      ::
        %update-pool
      (handle-compound-pool-transition [pid mod p]:tan)
    ==
  ::
  ++  handle-compound-pool-transition
    |=  [=pid:gol mod=ship tan=compound-pool-transition:act]
    ^-  _this
    =>  |%
        ++  comp
          |=  tan=compound-pool-transition:act
          ^-  _this
          (handle-compound-pool-transition pid mod tan)
        ++  handle-pool-transition
          |=  tan=pool-transition:act
          ^-  _this
          (handle-transition [%update-pool pid mod tan])
        --
    =*  goals  goals:(~(got by pools.store) pid)
    =*  nd     ~(. gol-cli-node goals)
    ?-    -.tan
        %set-active
      ?-    val.tan
          %&
        :: automatically mark parent active if possible
        ::
        =/  parent=(unit gid:gol)
          parent:(~(got by goals) gid.tan)
        =?  this  ?=(^ parent)
          (comp [%set-active u.parent %&])
        ~&  %marking-active
        (handle-pool-transition %mark-done s+gid.tan now.bowl)
        ::
          %|
        :: automatically unmark child active if possible
        ::
        =/  children=(list gid:gol)
          children:(~(got by goals) gid.tan)
        =.  this
          |-
          ?~  children
            this
          (comp [%set-active i.children %|])
        ~&  %unmarking-active
        (handle-pool-transition %mark-undone s+gid.tan now.bowl)
      ==
      ::
        %set-complete
      ?-    val.tan
          %&
        =.  this  (comp [%set-active gid.tan %&])
        ~&  %marking-complete
        =?  this  done.i.status.start:(~(got by goals) gid.tan)
          (handle-pool-transition %mark-done s+gid.tan now.bowl)
        =.  this  (handle-pool-transition %mark-done e+gid.tan now.bowl)
        :: automatically complete parent if all its children are complete
        ::
        =/  parent=(unit gid:gol)  parent:(~(got by goals) gid.tan)
        ?~  parent  this
        ?.  %-  ~(all in (young:nd u.parent))
            |=(=gid:gol done.i.status:(got-node:nd e+gid.tan))
          this
        :: Set parent complete if possible
        ::
        =/  mul
          %-  mule  |.
          (comp [%set-complete u.parent %&])
        ?-  -.mul
          %&  p.mul
          %|  ((slog p.mul) this)
        ==
        ::
          %|
        ~&  %unmarking-complete
        =.  this  (handle-pool-transition %mark-undone e+gid.tan now.bowl)
        :: Unmark start done if possible
        ::
        =/  mul
          %-  mule  |.
          (handle-pool-transition %mark-undone s+gid.tan now.bowl)
        ?-  -.mul
          %&  p.mul
          %|  ((slog p.mul) this)
        ==
      ==
      ::
        %yokes
      |-
      ?~  yokes.tan
        this
      %=  $
        yokes.tan  t.yokes.tan
        this       (handle-pool-transition %yoke i.yokes.tan)
      ==
      ::
        %nukes
      %-  comp
      :-  %yokes
      %-  zing
      %+  turn  nukes.tan
      |=  =nuke:act
      |^
      ^-  (list exposed-yoke:act)
      ?-    -.nuke
        %nuke-prio-left  prio-left
        %nuke-prio-ryte  prio-ryte
        %nuke-prio  (weld prio-left prio-ryte)
        %nuke-prec-left  prec-left
        %nuke-prec-ryte  prec-ryte
        %nuke-prec  (weld prec-left prec-ryte)
        %nuke-prio-prec  :(weld prio-left prio-ryte prec-left prec-ryte)
        %nuke-nest-left  nest-left
        %nuke-nest-ryte  nest-ryte
        %nuke-nest  (weld nest-left nest-ryte)
      ==
      ::
      ++  prio-left
        %+  turn
          ~(tap in (prio-left:nd gid.nuke))
        |=  =gid:gol
        ^-  exposed-yoke:act
        [%prio-rend gid gid.nuke]
      ::
      ++  prio-ryte
        %+  turn
          ~(tap in (prio-ryte:nd gid.nuke))
        |=  =gid:gol
        ^-  exposed-yoke:act
        [%prio-rend gid.nuke gid]
      ::
      ++  prec-left
        %+  turn
          ~(tap in (prec-left:nd gid.nuke))
        |=  =gid:gol
        ^-  exposed-yoke:act
        [%prec-rend gid gid.nuke]
      ::
      ++  prec-ryte
        %+  turn
          ~(tap in (prec-ryte:nd gid.nuke))
        |=  =gid:gol
        ^-  exposed-yoke:act
        [%prec-rend gid.nuke gid]
      ::
      ++  nest-left
        %+  turn
          ~(tap in (nest-left:nd gid.nuke))
        |=  =gid:gol
        ^-  exposed-yoke:act
        [%nest-rend gid gid.nuke]
      ::
      ++  nest-ryte
        %+  turn
          ~(tap in (nest-ryte:nd gid.nuke))
        |=  =gid:gol
        ^-  exposed-yoke:act
        [%nest-rend gid.nuke gid]
      --
    ==
  --
::
++  vine
  =,  ventio
  |_  =gowl
  ++  handle-local-action
    =,  strand=strand:spider
    |=  axn=local-action:act
    |^
    =/  m  (strand ,vase)
    ^-  form:m
    ?>  =(src our):gowl
    ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
    ?-    -.axn
        ?(%goal-metadata %pool-metadata %metadata-properties %settings)
      ;<  ~  bind:m
        (handle-transition ;;(transition:act axn))
      (pure:m !>(~))
      ::
        ?(%pool-order-slot %goal-order-slot)
      ;<  ~  bind:m
        (handle-compound-transition ;;(compound-transition:act axn))
      (pure:m !>(~))
      ::
        %create-pool
      =/  data-fields  [%public [%title ~ s+title.axn]~]~
      ;<  =id:p  bind:m  (create-pools-pool ~ data-fields)
      =/  data-fields  [%private ['goalsPool' ~ s+(id-string:enjs:pools id)]~]~
      ;<  ~  bind:m  (update-pool-data id data-fields)
      ;<  ~  bind:m  (create-goals-pool id title.axn)
      (pure:m !>(s+(id-string:enjs:pools id)))
      ::
        %delete-pool
      ;<  ~  bind:m  (delete-goals-pool pid.axn)
      ;<  *  bind:m  ((soften ,~) (delete-pools-pool pid.axn))
      (pure:m !>(~))
    ==
    ::
    ++  handle-transition
      |=  =transition:act
      =/  m  (strand ,~)
      ^-  form:m
      %+  poke  [our.gowl %goals]
      goal-transition+!>(transition)
    ::
    ++  handle-compound-transition
      |=  =compound-transition:act
      =/  m  (strand ,~)
      ^-  form:m
      %+  poke  [our.gowl %goals]
      goal-compound-transition+!>(compound-transition)
    --
  ::
  ++  handle-pool-action
    =,  strand=strand:spider
    |=  [=pid:gol axn=pool-action:act]
    |^
    =/  m  (strand ,vase)
    ^-  form:m
    ?.  =(our.gowl host.pid)
      :: forward action to remote pool
      :: (only returns when local copy synced)
      ::
      %:  vent-counted-action:vine:sub-count
        [host.pid dap.gowl]
        %-  ~(gas by *(map wire path))
        :~  [`wire`[%goals pool-path] `path`[%goals pool-path]]
            [`wire`[%pools pool-path] `path`[%pools pool-path]]
        ==
        goal-pool-action+[pid axn]
      ==
    :: deal with our pool
    ::
    ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
    ?-    -.axn
        %create-goal
      =/  =gid:gol  (~(unique-id gol-cli-goals store) pid now.gowl)
      ;<  ~  bind:m
        (handle-pool-transition %create-goal gid upid.axn summary.axn now.gowl)
      :: mark the goal started if active and if possible
      ::
      ;<  *  bind:m
        ?.  active.axn
          (pure:(strand ,~) ~)
        ((soften ,~) (handle-compound-pool-transition %set-active gid %&))
      (pure:m !>((enjs-key:goj [pid gid])))
      ::
        ?(%set-active %set-complete)
      ;<  ~  bind:m
        (handle-compound-pool-transition ;;(compound-pool-transition:act axn))
      (pure:m !>(~))
      ::
        $?  %set-pool-title
            %archive-goal
            %restore-goal
            %restore-to-root
            %delete-from-archive
            %delete-goal
            %move
            %set-start
            %set-end
            %set-summary
            %set-chief
            %set-open-to
            %set-actionable
            %reorder-roots
            %reorder-children
            %reorder-archive
            %update-goal-metadata
            %update-pool-metadata
            %update-pool-metadata-field
            %delete-pool-metadata-field
        ==
      ;<  ~  bind:m
        (handle-pool-transition ;;(pool-transition:act axn))
      (pure:m !>(~))
    ==
    ::
    ++  pool-path  `path`(en-pool-path pid)
    ::
    ++  handle-pool-transition
      |=  =pool-transition:act
      =/  m  (strand ,~)
      ^-  form:m
      %+  poke  [our.gowl %goals]
      :-  %goal-transition  !>
      ^-  transition:act
      [%update-pool pid src.gowl pool-transition]
    ::
    ++  handle-compound-pool-transition
      |=  =compound-pool-transition:act
      =/  m  (strand ,~)
      ^-  form:m
      %+  poke  [our.gowl %goals]
      :-  %goal-compound-transition  !>
      ^-  compound-transition:act
      [%update-pool pid src.gowl compound-pool-transition]
    --
    :: update from %pools agent /transitions subscription path
    ::
    ++  handle-pools-transition
      =,  strand=strand:spider
      |=  tan=transition:p
      =/  m  (strand ,vase)
      ^-  form:m
      ?>  =(our src):gowl
      ~&  >>  "receiving %pools transition {<`@tas`-.tan>} in %goals vine"
      ?+    -.tan  (pure:m !>(~))
          %update-pool
        (handle-pools-pool-transition [id p]:tan)
      ==
    ::
    ++  handle-pools-pool-transition
      =,  strand=strand:spider
      |=  [=id:p tan=pool-transition:p]
      =/  m  (strand ,vase)
      ^-  form:m
      ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
      ?+    -.tan
        (pure:m !>(~))
          %init-pool
        ;<  ~  bind:m  (watch-goals-pool id)
        (pure:m !>(~))
        ::
          %update-members
        ?.  =(our.gowl host.id)
          (pure:m !>(~))
        ?:  =(member.tan host.id)
          (pure:m !>(~))
        ?~  roles.tan
          ;<  ~  bind:m  (del-pool-role id member.tan)
          (pure:m !>(~))
        =/  =role:gol
          (~(gut by perms:(~(got by pools.store) id)) member.tan %viewer)
        ;<  ~  bind:m  (set-pool-role id member.tan role)
        (pure:m !>(~))
      ==
  ::
  ++  watch-goals-pool
    |=  =id:p
    =/  m  (strand ,~)
    ^-  form:m
    %+  (vent ,~)  [our.gowl %goals]
    :-  %goal-local-membership-action
    ^-  local-membership-action:act
    [%watch-pool id]
  :: Adds to %goals and %pools
  ::
  ++  set-pool-role
    |=  [=pid:gol member=ship =role:gol]
    =/  m  (strand ,~)
    ^-  form:m
    %+  (vent ,~)  [our.gowl %goals]
    :-  %goal-pool-membership-action
    :-  pid
    ^-  pool-membership-action:act
    [%set-pool-role member role]
  :: Deletes from %goals only (already removed in %pools)
  ::
  ++  del-pool-role
    |=  [=pid:gol member=ship]
    =/  m  (strand ,~)
    ^-  form:m
    %+  (vent ,~)  [our.gowl %goals]
    :-  %goal-transition
    :^  %update-pool  pid  our.gowl
    [%set-pool-role member ~]
  ::
  ++  create-pools-pool
    |=  $:  graylist-fields=(list graylist-field:p)
            pool-data-fields=(list pool-data-field:p)
        ==
    =/  m  (strand ,id:p)
    ^-  form:m
    ;<  jon=json  bind:m
      %+  (vent ,json)  [our.gowl %pools]
      :-  %pools-action
      [%create-pool graylist-fields pool-data-fields]
    (pure:m (id:dejs:pools jon))
  ::
  ++  update-pool-data
    |=  [=id:p fields=(list pool-data-field:p)]
    =/  m  (strand ,~)
    ^-  form:m
    %+  poke  [our.gowl %pools]
    :-  %pools-transition  !>
    :+  %update-pool  id
    [%update-pool-data fields]
  ::
  ++  create-goals-pool
    |=  [=pid:gol title=@t]
    =/  m  (strand ,~)
    ^-  form:m
    (poke [our.gowl %goals] %goal-transition !>([%create-pool pid title]))
  ::
  ++  delete-goals-pool
    |=  =pid:gol
    =/  m  (strand ,~)
    ^-  form:m
    (poke [our.gowl %goals] %goal-transition !>([%delete-pool pid]))
  ::
  ++  delete-pools-pool
    |=  =id:p
    =/  m  (strand ,~)
    ^-  form:m
    (poke [our.gowl %pools] %pools-transition !>([%delete-pool id]))
  --
--
