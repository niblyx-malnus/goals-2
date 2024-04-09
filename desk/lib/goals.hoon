/-  gol=goals, p=pools, act=action
/+  ventio, *gol-cli-util, pools, sub-count,
    pl=gol-cli-pool, nd=gol-cli-node, tv=gol-cli-traverse,
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
    ?>  =(src our):bowl
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
        %create-pool
      ?>  =(our.bowl host.pid.tan)
      ?<  (~(has by pools.store) pid.tan)
      =|  =pool:gol
      =:  title.pool  title.tan
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
      :: we must be the host of the given pool
      ::
      ?>  =(our.bowl host.pid.tan)
      =.  this  (handle-pool-transition [pid mod p]:tan)
      (emit %give %fact ~[(en-pool-path pid.tan)] goals-pool-transition+!>([mod p]:tan))
    ==
  ::
  ++  handle-pool-transition
    |=  [=pid:gol mod=ship tan=pool-transition:act]
    ^-  _this
    =/  old=pool:gol  (~(gut by pools.store) pid *pool:gol)
    =;  new=pool:gol
      this(pools.store (~(put by pools.store) pid new))
    ?-    -.tan
        %init-pool
      ?>(=(mod host.pid) pool.tan)
      ::
        %reorder-roots
      abet:(reorder-roots:(apex:pl old) roots.tan mod)
      ::
        %reorder-children
      abet:(reorder-children:(apex:pl old) gid.tan children.tan mod)
      ::
        %reorder-archive
      abet:(reorder-archive:(apex:pl old) context.tan archive.tan mod)
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
      ::
        %move
      abet:(move:(apex:pl old) cid.tan upid.tan mod)
      ::
        %yoke
      abet:(plex-sequence:(apex:pl old) yoks.tan mod)
      ::
        %set-actionable
      abet:(set-actionable:(apex:pl old) gid.tan val.tan mod)
      ::
        %mark-done
      abet:(mark-done:(apex:pl old) nid.tan now.tan mod)
      ::
        %unmark-done
      abet:(unmark-done:(apex:pl old) nid.tan now.tan mod)
      ::
        %set-summary
      abet:(set-summary:(apex:pl old) gid.tan summary.tan mod)
      ::
        %set-pool-title
      abet:(set-pool-title:(apex:pl old) title.tan mod)
      ::
        %set-start
      abet:(set-start:(apex:pl old) gid.tan start.tan mod)
      ::
        %set-end
      abet:(set-end:(apex:pl old) gid.tan end.tan mod)
      ::
        %set-pool-role
      abet:(set-pool-role:(apex:pl old) ship.tan role.tan mod)
      ::
        %set-chief
      abet:(set-chief:(apex:pl old) gid.tan chief.tan rec.tan mod)
      ::
        %set-open-to
      abet:(set-open-to:(apex:pl old) gid.tan open-to.tan mod)
      ::
        %update-goal-metadata
      abet:(update-goal-metadata:(apex:pl old) gid.tan p.tan mod)
      ::
        %update-pool-metadata
      abet:(update-pool-metadata:(apex:pl old) p.tan mod)
      ::
        %update-pool-metadata-field
      abet:(update-pool-metadata-field:(apex:pl old) field.tan p.tan mod)
      ::
        %delete-pool-metadata-field
      abet:(delete-pool-metadata-field:(apex:pl old) field.tan mod)
    ==
  ::
  ++  handle-compound-transition
    |=  tan=compound-transition:act
    ^-  _this
    ?>  =(src our):bowl
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
        :: this will send appropriate transition updats
        ::
        ++  handle-pool-transition
          |=  tan=pool-transition:act
          ^-  _this
          (handle-transition [%update-pool pid mod tan])
        --
    =*  goals  goals:(~(got by pools.store) pid)
    ?-    -.tan
        %set-active
      ?-    val.tan
          %&
        :: automatically mark parent active if possible
        =/  parent=(unit gid:gol)
          parent:(~(got by goals) gid.tan)
        =?  this  ?=(^ parent)
          $(tan [%set-active u.parent %&])
        ~&  %marking-active
        (handle-pool-transition %mark-done s+gid.tan now.bowl)
        ::
          %|
        :: automatically unmark child active if possible
        =/  children=(list gid:gol)
          children:(~(got by goals) gid.tan)
        =.  this
          |-
          ?~  children
            this
          $(tan [%set-active i.children %|])
        ~&  %unmarking-active
        (handle-pool-transition %unmark-done s+gid.tan now.bowl)
      ==
      ::
        %set-complete
      ?-    val.tan
          %&
        =.  this  $(tan [%set-active gid.tan %&])
        ~&  %marking-complete
        =?  this  done.i.status.start:(~(got by goals) gid.tan)
          (handle-pool-transition %mark-done s+gid.tan now.bowl)
        =.  this  (handle-pool-transition %mark-done e+gid.tan now.bowl)
        :: automatically complete parent if all its children are complete
        ::
        =/  parent=(unit gid:gol)  parent:(~(got by goals) gid.tan)
        ?~  parent  this
        ?.  %-  ~(all in (~(young nd goals) u.parent))
            |=(=gid:gol done.i.status:(~(got-node nd goals) e+gid.tan))
          this
        :: TODO: make this only occur if has permissions on ancestors...
        :: host responsible for resulting completions
        $(mod our.bowl, tan [%set-complete u.parent %&])
        ::
          %|
        ~&  %unmarking-complete
        =.  this  (handle-pool-transition %unmark-done e+gid.tan now.bowl)
        :: Unmark start done if possible
        =/  mul
          %-  mule  |.
          (handle-pool-transition %unmark-done s+gid.tan now.bowl)
        ?-  -.mul
          %&  p.mul
          %|  ((slog p.mul) this)
        ==
      ==
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
      %+  poke  [our dap]:gowl
      goal-transition+!>(transition)
    ::
    ++  handle-compound-transition
      |=  =compound-transition:act
      =/  m  (strand ,~)
      ^-  form:m
      %+  poke  [our dap]:gowl
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
        `path`pool-path
        `wire`pool-path
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
        $?  %yoke
            %set-pool-title
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
      %+  poke  [our dap]:gowl
      :-  %goal-transition  !>
      ^-  transition:act
      [%update-pool pid src.gowl pool-transition]
    ::
    ++  handle-compound-pool-transition
      |=  =compound-pool-transition:act
      =/  m  (strand ,~)
      ^-  form:m
      %+  poke  [our dap]:gowl
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
      !!
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
    (poke [our dap]:gowl goal-transition+!>([%create-pool pid title]))
  ::
  ++  delete-goals-pool
    |=  =pid:gol
    =/  m  (strand ,~)
    ^-  form:m
    (poke [our dap]:gowl goal-transition+!>([%delete-pool pid]))
  ::
  ++  delete-pools-pool
    |=  =id:p
    =/  m  (strand ,~)
    ^-  form:m
    (poke [our.gowl %pools] pools-transition+!>([%delete-pool id]))
  --
--
