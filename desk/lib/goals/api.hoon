/-  gol=goals, act=action, p=pools
/+  *ventio
|_  =gowl
++  dude  %goals
++  create-pool
  |=  [=pid:gol title=@t]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl dude]
  :-  %goals-transition  !>
  ^-  transition:act
  [%create-pool pid title]
::
++  delete-pool
  |=  =pid:gol
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl dude]
  :-  %goals-transition  !>
  ^-  transition:act
  [%delete-pool pid]
:: Deletes from %goals only (already removed in %pools)
::
++  del-pool-role
  |=  [=pid:gol member=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl dude]
  :-  %goals-compound-transition  !>
  ^-  compound-transition:act
  :^  %update-pool  pid  our.gowl
  [%set-pool-role member ~]
::
++  set-pool-role
  |=  [=pid:gol member=ship =role:gol mod=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl dude]
  :-  %goals-compound-transition  !>
  ^-  compound-transition:act
  :^  %update-pool  pid  mod
  [%set-pool-role member ~ role]
::
++  mem
  |%
  ++  watch-pool
    |=  =pid:gol
    =/  m  (strand ,~)
    ^-  form:m
    %+  (vent ,~)  [our.gowl dude]
    :-  %goals-local-membership-action
    ^-  local-membership-action:act
    [%watch-pool pid]
  :: Adds to %goals and %pools
  ::
  ++  set-pool-role
    |=  [=pid:gol member=ship =role:gol]
    =/  m  (strand ,~)
    ^-  form:m
    %+  (vent ,~)  [our.gowl dude]
    :-  %goals-pool-membership-action
    :-  pid
    ^-  pool-membership-action:act
    [%set-pool-role member role]
  ::
  ++  accept-invite
    |=  =pid:gol
    =/  m  (strand ,~)
    ^-  form:m
    %+  (vent ,~)  [our.gowl dude]
    :-  %goals-local-membership-action
    ^-  local-membership-action:act
    [%accept-invite pid]
  ::
  ++  reject-invite
    |=  =pid:gol
    =/  m  (strand ,~)
    ^-  form:m
    %+  (vent ,~)  [our.gowl dude]
    :-  %goals-local-membership-action
    ^-  local-membership-action:act
    [%reject-invite pid]
  ::
  ++  delete-invite
    |=  =pid:gol
    =/  m  (strand ,~)
    ^-  form:m
    %+  (vent ,~)  [our.gowl dude]
    :-  %goals-local-membership-action
    ^-  local-membership-action:act
    [%delete-invite pid]
  ::
  ++  cancel-request
    |=  =pid:gol
    =/  m  (strand ,~)
    ^-  form:m
    %+  (vent ,~)  [our.gowl dude]
    :-  %goals-local-membership-action
    ^-  local-membership-action:act
    [%cancel-request pid]
  ::
  ++  extend-request
    |=  =pid:gol
    =/  m  (strand ,~)
    ^-  form:m
    %+  (vent ,~)  [our.gowl dude]
    :-  %goals-local-membership-action
    ^-  local-membership-action:act
    [%extend-request pid]
  ::
  ++  update-blocked
    |=  p=(each blocked:p blocked:p)
    =/  m  (strand ,~)
    ^-  form:m
    %+  (vent ,~)  [our.gowl dude]
    :-  %goals-local-membership-action
    ^-  local-membership-action:act
    [%update-blocked p]
  --
--
