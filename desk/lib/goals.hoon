/-  gol=goals, p=pools, act=action
/+  ventio, pools, sub-count, goals-api, pools-api,
    pl=goals-pool, goals-node, goals-traverse,
    goj=goals-json, poj=pools-json
|%
++  en-pool-path  |=(=pid:gol `path`/pool/(scot %p host.pid)/[name.pid])
++  de-pool-path
  |=  =path
  ^-  pid:gol
  =+  ;;([%pool host=@ta name=@ta ~] path)
  [(slav %p host) name]
::
++  agent
  |_  [=bowl:gall cards=(list card:agent:gall) state-0:gol]
  +*  this   .
      state  +<+>
  +$  card  card:agent:gall
  ++  abet  [(flop cards) state]
  ++  emit  |=(=card this(cards [card cards]))
  ++  emil  |=(cadz=(list card) this(cards (weld cadz cards)))
  ::
  ++  subscribe-to-pools-agent
    ^-  (list card:agent:gall)
    ?:  (~(has by wex.bowl) [/pools-transitions our.bowl %pools])
      ~
    [%pass /pools-transitions %agent [our.bowl %pools] %watch /transitions]~
  ::
  ++  poke-desk-into-venter
    ^-  card:agent:gall
    [%pass /poke-desk-into-venter %agent [our.bowl %venter] %poke uni-desks+!>((sy ~[%goals]))]
  ::
  ++  handle-transition
    |=  tan=transition:act
    ^-  _this
    =.  this  (emit %give %fact ~[/transitions] goals-transition+!>(tan))
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
      (handle-pool-transition [pid p]:tan)
    ==
  ::
  ++  handle-pool-transition
    |=  [=pid:gol tan=pool-transition:act]
    ^-  _this
    =/  =pool:gol  (~(gut by pools.store) pid *pool:gol)
    =.  pool  pool:(handle-transition:(apex:pl pool) tan)
    this(pools.store (~(put by pools.store) pid pool))
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
    =/  =pool:gol  (~(gut by pools.store) pid *pool:gol)
    =^  tans  pool
      teba:(handle-compound-transition-safe:(apex:pl pool) mod tan)
    =.  pools.store  (~(put by pools.store) pid pool)
    %-  emil
    %+  turn  tans
    |=  tan=pool-transition:act
    [%give %fact ~[(en-pool-path pid)] goals-pool-transition+!>(tan)]
  --
::
++  vine
  =,  ventio
  |_  =gowl
  +*  gap  ~(. goals-api gowl)
      pap  ~(. pools-api gowl)
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
      =/  gray-fields  [%rest ~ %|]~ :: default is secret pool
      =/  data-fields  [%public ['title' ~ s+title.axn]~]~
      ;<  =id:p  bind:m  (create-pool-take-id gray-fields data-fields)
      =/  data-fields  [%public ['goalsPool' ~ s+(id-string:enjs:poj id)]~]~
      ;<  ~  bind:m  (update-pool-data:pap id data-fields)
      ;<  ~  bind:m  (create-pool:gap id title.axn)
      (pure:m !>(s+(id-string:enjs:poj id)))
      ::
        %delete-pool
      ;<  ~  bind:m  (delete-pool:gap pid.axn)               :: %goals pool
      ;<  *  bind:m  ((soften ,~) (delete-pool:pap pid.axn)) :: %pools pool
      (pure:m !>(~))
    ==
    ::
    ++  handle-transition
      |=  =transition:act
      =/  m  (strand ,~)
      ^-  form:m
      %+  poke  [our.gowl %goals]
      goals-transition+!>(transition)
    ::
    ++  handle-compound-transition
      |=  =compound-transition:act
      =/  m  (strand ,~)
      ^-  form:m
      %+  poke  [our.gowl %goals]
      goals-compound-transition+!>(compound-transition)
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
        goals-pool-action+[pid axn]
      ==
    :: deal with our pool
    ::
    ?-    -.axn
        %create-goal
      ;<  =gid:gol  bind:m  (unique-id pid)
      ;<  ~         bind:m
        %-  handle-compound-pool-transition
        [%create-goal gid upid.axn summary.axn active.axn now.gowl]
      :: mark the goal started if active and if possible
      ::
      ~&  %skipping-setting-active
      :: ;<  *  bind:m
      ::   ?.  active.axn
      ::     (pure:(strand ,~) ~)
      ::   ((soften ,~) (handle-compound-pool-transition %set-active gid %& now.gowl))
      (pure:m !>((enjs-key:goj [pid gid])))
      ::
        %set-complete
      ;<  ~  bind:m
        (handle-compound-pool-transition %set-complete gid.axn val.axn now.gowl)
      (pure:m !>(~))
      ::
        %set-active
      ;<  ~  bind:m
        (handle-compound-pool-transition %set-active gid.axn val.axn now.gowl)
      (pure:m !>(~))
      ::
        %set-pool-title
      ;<  ~  bind:m
        (handle-compound-pool-transition ;;(compound-pool-transition:act axn))
      ;<  ~  bind:m  (update-pool-data:pap pid [%public ['title' ~ s+title.axn]~]~)
      (pure:m !>(~))
      ::
        $?  %archive-goal
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
        (handle-compound-pool-transition ;;(compound-pool-transition:act axn))
      (pure:m !>(~))
    ==
    ::
    ++  pool-path  `path`(en-pool-path pid)
    ::
    ++  unique-id
      |=  =pid:gol
      =/  m  (strand ,gid:gol)
      ^-  form:m
      ;<  now=@da     bind:m  get-time
      ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
      =/  =goals:gol  goals:(~(got by pools.store) pid)
      |-
      =/  =gid:gol  (scot %da now)
      ?.  (~(has by goals) gid)
        (pure:m gid)
      $(now (add now ~s0..0001))
    ::
    ++  handle-compound-pool-transition
      |=  =compound-pool-transition:act
      =/  m  (strand ,~)
      ^-  form:m
      %+  poke  [our.gowl %goals]
      :-  %goals-compound-transition  !>
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
    :: XX: possible that most of this could be handled in the agent
    ::
    ++  handle-pools-pool-transition
      =,  strand=strand:spider
      |=  [=id:p tan=pool-transition:p]
      =/  m  (strand ,vase)
      ^-  form:m
      ;<  =store:gol  bind:m      (scry-hard ,store:gol /gx/goals/store/noun)
      ;<  =pools:p  bind:m        (scry-hard ,pools:p /gx/pools/pools/noun)
      =/  p-pool=pool:p           (~(got by pools) id)
      =/  g-pool=(unit pool:gol)  (~(get by pools.store) id)
      :: fix public data related to members and graylist
      ::
      ;<  ~  bind:m
        ?.  ?&  =(our.gowl host.id)
                ?=(?(%update-members %update-graylist) -.tan)
            ==
          (pure:(strand ,~) ~)
        %+  update-pool-data:pap  id
        (rectify-public-membership-data p-pool)
      :: 
      ?+    -.tan
        (pure:m !>(~))
          %init-pool
        ;<  ~  bind:m  (watch-pool:mem:gap id)
        (pure:m !>(~))
        ::
          %update-members
        ?.  =(our.gowl host.id)   :: don't edit a pool that isn't ours
          (pure:m !>(~))
        ?:  =(member.tan host.id) :: don't edit host role
          (pure:m !>(~))
        ?~  roles.tan             :: deletion
          ;<  ~  bind:m  (del-pool-role:gap id member.tan)
          (pure:m !>(~))
        =/  default=role:gol
          %+  fall
            %-  mole  |.
            (role:dejs:goj (~(got by metadata:(need g-pool)) 'defaultRole'))
          %viewer
        ?~  g-pool
          (pure:m !>(~))
        =/  =role:gol  (~(gut by perms.u.g-pool) member.tan default)
        ;<  ~  bind:m  (set-pool-role:mem:gap id member.tan role)
        (pure:m !>(~))
      ==
  ::
  ++  rectify-public-membership-data
    |=  =pool:p
    ^-  (list pool-data-field:p)
    :_  ~
    :-  %public
    ?~  rest.graylist.pool
      :~  ['accessType' ~ s+'private']
          ['memberCount' ~ (numb:enjs:format ~(wyt by members.pool))]
          ['members' ~ a+(turn ~(tap in ~(key by members.pool)) ship:enjs:poj)]
      ==
    ?-    u.rest.graylist.pool
        [%& *]
      :~  ['accessType' ~ s+'public']
          ['memberCount' ~ ~]
          ['members' ~ ~]
      ==
        %| :: Never publicly seen
      :~  ['accessType' ~ s+'secret']
          ['memberCount' ~ ~]
          ['members' ~ ~]
      ==
    ==
  ::
  ++  create-pool-take-id
    |=  $:  graylist-fields=(list graylist-field:p)
            pool-data-fields=(list pool-data-field:p)
        ==
    =/  m  (strand ,id:p)
    ^-  form:m
    ;<  jon=json  bind:m
      (create-pool-action:pap graylist-fields pool-data-fields)
    (pure:m (id:dejs:poj jon))
  --
--
