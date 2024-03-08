/-  *goals, old-goals, update
/+  gol-cli-node
:: step-wisdom vs. step-nomadism
:: https://gist.github.com/philipcmonk/de5ba03b3ea733387fd13b758062cfce
|%
+$  card  card:agent:gall
::
+$  state-5-29  [%'5-29' =store]
+$  state-5-28  [%'5-28' =store:old-goals]
+$  versioned-state
  $%  state-5-28
      state-5-29
  ==
::
++  upgrade-io
  |=  [new=state-5-29 =bowl:gall]
  |^  ^-  (list card)
  :: TODO: Follow all pools and prompt others to refollow?
  ;:  weld
    kick-sup
    leave-wex
  ==
  ++  kick-sup
    ^-  (list card)
    %+  turn  ~(tap by sup.bowl)
    |=  [=duct =ship =path]
    [%give %kick ~[path] ~]
  ::
  ++  leave-wex
    ^-  (list card)
    %+  turn  ~(tap by wex.bowl)
    |=  [[=wire =ship =term] *]
    [%pass wire %agent [ship term] %leave ~]
  --
::
++  convert-to-latest
  |=  old=versioned-state
  ^-  state-5-29
  ?-  -.old
    %'5-28'  (convert-5-28-to-5-29 old)
      %'5-29'
    %=    old
        pools.store
      %-  ~(gas by *pools)
      %+  turn  ~(tap by pools.store.old)
      |=  [=pid =pool]
      [pid pool]
      :: [pid (inflate-pool:fl pool)]
      :: Reorder pool-order if incorrect
      ::
        pool-order.local.store
      ?:  =((sy pool-order.local.store.old) ~(key by pools.store.old))
        pool-order.local.store.old
      ~(tap in ~(key by pools.store.old))
      :: Reorder goal-order if incorrect
      ::
        goal-order.local.store
      =/  goals=(list (set key))
        %+  turn  ~(tap by pools.store.old)
        |=([=pid pool] (sy (turn ~(tap in ~(key by goals)) (lead pid))))
      =/  all-goals=(set key)
        =|  all-goals=(set key)
        |-
        ?~  goals
          all-goals
        $(goals t.goals, all-goals (~(uni in all-goals) i.goals))
      ?:  =((sy goal-order.local.store.old) all-goals)
        goal-order.local.store.old
      ~(tap in all-goals)
    ==
  ==
:: Development states
::
++  convert-5-28-to-5-29
  |=  =state-5-28
  ^-  state-5-29
  =/  pools
    %-  ~(gas by *pools)
    %+  turn  ~(tap by pools.store.state-5-28)
    |=  [=pid =pool:old-goals]
    ^-  [^pid ^pool]
    =/  pd  (~(get by pool-info.store.state-5-28) pid)
    =/  =goals
      %-  ~(gas by *goals)
      %+  turn  ~(tap by goals.pool)
      |=  [=gid =goal:old-goals]
      ^-  [^gid ^goal]
      =/  tags=(set @t)  (~(gut by ?~(pd ~ tags.u.pd)) gid ~)
      =/  metadata=(map @t @t)
        %+  ~(put by *(map @t @t))
          'labels'
        %-  en:json:html
        a+(turn ~(tap in tags) (lead %s))
      :-  gid
      :*  gid.goal
          summary.goal
          parent.goal
          children.goal
          start.goal
          end.goal
          actionable.goal
          chief.goal
          deputies.goal
          open-to.goal
          metadata
      ==
    :-  pid
    :*  pid.pool
        title.pool
        perms.pool
        goals
        roots.pool
        [~ ~] :: archive.pool (no important archived goals)
        ~ :: metadata related to pool
        ~ :: metadata-properties
    ==
  =/  goal-metadata=(map key (map @t @t))
    %-  ~(gas by *(map key (map @t @t)))
    %+  turn  ~(tap by tags.local.store.state-5-28)
    |=  [=key tags=(set @t)]
    ^-  [^key (map @t @t)]
    :-  key
    %+  ~(put by *(map @t @t))
      'labels'
    %-  en:json:html
    a+(turn ~(tap in tags) (lead %s))
  =/  =local
    :*  goal-order.local.store.state-5-28
        pool-order.local.store.state-5-28
        goal-metadata
        ~ :: pool-metadata
        ~ :: metadata-properties
        settings.local.store.state-5-28
    ==
  [%'5-29' pools local json-tree.store.state-5-28]
--
