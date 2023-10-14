/-  gol=goals, vyu=views, update
/+  j=gol-cli-json
|_  =store:gol
++  view-data
  |=  =parm:page:vyu
  ^-  data:page:vyu
  ?-    -.type.parm
    %main  [%main ~]
    %pool  [%pool title note]:(~(got by pools.store) pin.type.parm)
    ::
      %goal
    =/  =pin:gol  (got:idx-orm:gol index.store id.type.parm)
    =/  pool  (~(got by pools.store) pin)
    =.  goals.pool  (unify-tags goals.pool)
    =/  =goal:gol  (~(got by goals.pool) id.type.parm)
    [%goal pin [par desc note tags]:goal]
  ==
::
++  view-diff
  |=  $:  =parm:page:vyu
          =data:page:vyu
          [[=pin:gol mod=ship pid=@] upd=update:v5:update]
      ==
  ^-  (unit diff:page:vyu)
  =;  diff=(unit diff:page:vyu)
    ~|  "non-equivalent-page-view-diff"
    =/  check=?
      ?~  diff  =(data (view-data parm))
      =((view-data parm) (etch-diff data u.diff))
    ?>(check diff)
  =/  atad=data:page:vyu  (view-data parm)
  ?:  =(data atad)  ~
  (some [[pin mod pid] %replace atad])
::
++  etch-diff
  |=  [=data:page:vyu =diff:page:vyu]
  ^-  data:page:vyu
  ?>(?=(%replace +<.diff) +>.diff)
::
++  unify-tags
  |=  =goals:gol
  ^-  goals:gol
  %-  ~(gas by *goals:gol)
  %+  turn  ~(tap by goals)
  |=  [=id:gol =goal:gol]
  ^-  [id:gol goal:gol]
  :-  id
  %=    goal
      tags
   %-  ~(uni in tags.goal)
   ?~  get=(~(get by goals.local.store) id)
     ~
   tags.u.get
  ==
::
++  dejs
  =,  dejs:format
  |%
  ++  view-parm
    ^-  $-(json parm:page:vyu)
    (ot ~[type+type])
  ::
  ++  type
    ^-  $-(json type:page:vyu)
    %-  of
    :~  main+|=(jon=json ?>(?=(~ jon) ~))
        pool+pin:dejs:j
        goal+id:dejs:j
    ==
  --
::
++  enjs
  =,  j
  =,  enjs:format
  |%
  ++  view-data
    |=  =data:page:vyu
    ^-  json
    ?-    -.data
      %main  (frond %main ~)
        %pool
      %+  frond  %pool
      %-  pairs
      :~  [%title s+title.data]
          [%note s+note.data]
      ==
      ::
        %goal
      %+  frond  %goal
      %-  pairs
      :~  [%par-pool (enjs-pin par-pool.data)]
          [%par-goal ?~(par-goal.data ~ (enjs-id u.par-goal.data))]
          [%desc s+desc.data]
          [%note s+note.data]
          [%tags a+(turn ~(tap in tags.data) enjs-tag)]
      ==
    ==
  ::
  ++  view-diff
    |=  =diff:page:vyu
    ^-  json
    %-  pairs
    :~  :-  %hed
        %-  pairs
        :~  [%pin (enjs-pin pin.diff)]
            [%mod (ship mod.diff)]
            [%pid s+`@t`pid.diff]
        ==
        :-  %tel
        %+  frond  %page
        ?>  ?=(%replace +<.diff)
        =/  =data:page:vyu  +>.diff
        ?-    -.data
          %main  (frond %main ~)
            %pool
          %+  frond  %pool
          %-  pairs
          :~  [%title s+title.data]
              [%note s+note.data]
          ==
          ::
            %goal
          %+  frond  %goal
          %-  pairs
          :~  [%par-pool (enjs-pin par-pool.data)]
              [%par-goal ?~(par-goal.data ~ (enjs-id u.par-goal.data))]
              [%desc s+desc.data]
              [%note s+note.data]
              [%tags a+(turn ~(tap in tags.data) enjs-tag)]
          ==
        ==
    ==
  ::
  ++  view-parm
    |=  =parm:page:vyu
    ^-  json
    (frond %type (type type.parm))
  ::
  ++  type
    |=  =type:page:vyu
    ^-  json
    ?-  -.type
      %main  (frond %main ~)
      %pool  (frond %pool (enjs-pin pin.type))
      %goal  (frond %goal (enjs-id id.type))
    ==
  --
--
