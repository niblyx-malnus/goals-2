/-  p=pools, gol=goals, axn=action, spider
/+  *ventio, pools, gol-cli-pool, gol-cli-node, gol-cli-traverse,
    goj=gol-cli-json
|_  =gowl
++  handle-pool-view
  =,  strand=strand:spider
  |=  vyu=pool-view:axn
  =/  m  (strand ,vase)
  ^-  form:m
  ?.  =(our.gowl host.pid.vyu)
    ?>  =(src our):gowl
    ;<  jon=json  bind:m
      ((vent ,json) [host.pid.vyu %goals] goal-pool-view+vyu)
    (pure:m !>(jon))
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  =/  =pool:gol  (~(got by pools.store) pid.vyu)
  ?-    +<.vyu
      %pool-data
    ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
    =/  =pool:p  (~(got by pools) pid.vyu)
    ?>  (~(has by members.pool) src.gowl)
    %-  pure:m  !>
    %-  pairs:enjs:format
    :~  [%private o+private.pool-data.pool]
        [%public o+public.pool-data.pool]
    ==
  ==
::
++  handle-remote-view
  =,  strand=strand:spider
  |=  vyu=remote-view:axn
  =/  m  (strand ,vase)
  ^-  form:m
  ?.  =(our.gowl dst.vyu)
    ?>  =(src our):gowl
    ;<  jon=json  bind:m
      ((vent ,json) [dst.vyu %goals] goal-remote-view+vyu)
    (pure:m !>(jon))
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  ?-    +<.vyu
      %pools-data
    ;<  =pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
    =|  response=(map @t json)
    |-
    ?~  pids.vyu
      (pure:m !>(o+response))
    =/  =pool:p  (~(got by pools) i.pids.vyu)
    %=    $
      pids.vyu  t.pids.vyu
        response
      %+  ~(put by response)
        (id-string:enjs:^pools i.pids.vyu)
      ?.  (~(has by members.pool) src.gowl)
        s+%permission-failure
      %-  pairs:enjs:format
      :~  [%private o+private.pool-data.pool]
          [%public o+public.pool-data.pool]
      ==
    ==
  ==
::
++  handle-local-view
  =,  strand=strand:spider
  |=  vyu=local-view:axn
  =/  m  (strand ,vase)
  ^-  form:m
  ?>  =(src our):gowl
  ;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
  ?-    -.vyu
      %pools-index
    !!
    ::
      %local-tag-goals
    =/  vals=(list (set @t))
      %+  turn  ~(val by goal-metadata.local.store)
      |=  metadata=(map @t json)
      ((as so):dejs:format (~(gut by metadata) 'labels' a+~))
    =|  tags=(set @t)
    |-
    ?~  vals
      (pure:m !>(a+(turn ~(tap in tags) (lead %s))))
    $(vals t.vals, tags (~(uni in tags) i.vals))
    ::
      %local-tag-harvest  
    !!
    ::
      %local-tag-note
    !!
    ::
      %local-goal-tags
    =/  vals=(list (set @t))
      %+  turn  ~(val by goal-metadata.local.store)
      |=  metadata=(map @t json)
      ((as so):dejs:format (~(gut by metadata) 'labels' a+~))
    =|  tags=(set @t)
    |-
    ?~  vals
      (pure:m !>(a+(turn ~(tap in tags) (lead %s))))
    $(vals t.vals, tags (~(uni in tags) i.vals))
    ::
      %local-goal-fields
    =,  enjs:format
    %-  pure:m  !>
    %-  pairs
    %+  murn  ~(tap by metadata-properties.local.store)
    |=  [f=@t p=(map @t json)]
    ^-  (unit [@t json])
    ?.  (~(has by p) 'attributeType')
      ~
    [~ f o+p]
    ::
      %local-blocked
    ;<  =blocked:p  bind:m  (scry-hard ,blocked:p /gx/pools/blocked/noun)
    =,  enjs:format
    %-  pure:m  !>
    %-  pairs
    :~  [%pools a+(turn (turn ~(tap in pools.blocked) id-string:enjs:pools) (lead %s))] 
        [%hosts a+(turn ~(tap in hosts.blocked) |=(=@p s+(scot %p p)))]
    ==
    ::
      %local-pools
    ;<  local=pools:p  bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
    %-  pure:m  !>
    :-  %a
    %+  turn
      %+  turn
        ~(tap in ~(key by local))
      id-string:enjs:pools
    (lead %s)
    ::
      %all-pools
    ;<  local=pools:p    bind:m  (scry-hard ,pools:p /gx/pools/pools/noun)
    %-  pure:m  !>
    :-  %a
    %+  turn
      %+  turn
        ~(tap in ~(key by local))
      id-string:enjs:pools
    (lead %s)
    ::
      %incoming-invites
    ;<  =incoming-invites:p  bind:m
      (scry-hard ,incoming-invites:p /gx/pools/incoming-invites/noun)
    %-  pure:m  !>
    =,  enjs:format
    %-  pairs
    %+  murn  ~(tap by incoming-invites)
    |=  [=pid:gol =invite:p =status:p]
    ^-  (unit [@t json])
    =/  dudes  ((as so):dejs:format (~(gut by invite) 'dudes' a+~))
    ?.  (~(has in dudes) dap.gowl)
      ~
    :-  ~
    :-  (enjs-pid:goj pid)
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
      %outgoing-requests
    ;<  =outgoing-requests:p  bind:m
      (scry-hard ,outgoing-requests:p /gx/pools/outgoing-requests/noun)
    %-  pure:m  !>
    =,  enjs:format
    %-  pairs
    %+  murn  ~(tap by outgoing-requests)
    |=  [=pid:gol =request:p =status:p]
    ^-  (unit [@t json])
    =/  dudes  ((as so):dejs:format (~(gut by request) 'dudes' a+~))
    ?.  (~(has in dudes) dap.gowl)
      ~
    :-  ~
    :-  (enjs-pid:goj pid)
    %-  pairs
    :~  [%request o+request]
        :-  %status
        ?~  status
          ~
        %-  pairs
        :-  ['response' b+response.u.status]
        ~(tap by metadata.u.status)
    ==
    ::
      %setting
    (pure:m !>(?~(s=(~(get by settings.local.store) setting.vyu) ~ s+u.s)))
  ==
::
++  enjs-pools-index
  =,  enjs:format
  |=  pools-index=(list [pid:gol @])
  :-  %a
  %+  turn  pools-index
  |=  [=pid:gol title=@t] 
  %-  pairs
  :~  [%pid s+(enjs-pid:goj pid)]
      [%title s+title]
  ==
--
