/-  ui=goals-ui
/+  *ventio
|_  =gowl
++  just-put
  |=  [=path =vase]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %nooks-put
  (slop !>(path) vase)
::
++  just-del
  |=  =path
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  nooks-del+!>(path)
::
++  just-lop
  |=  =path
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  nooks-lop+!>(path)
::
++  get-raw
  |=  =path
  .^  (unit vase)  %gx 
      (scot %p our.gowl)  dap.gowl  (scot %da now.gowl)
      :(weld /nooks/get path /noun)
  ==
::
++  fit
  |=  =path
  .^  ,[^path (unit vase)]  %gx 
      (scot %p our.gowl)  dap.gowl  (scot %da now.gowl)
      :(weld /nooks/fit path /noun)
  ==
::
++  dip
  |=  =path
  .^  nooks:ui  %gx 
      (scot %p our.gowl)  dap.gowl  (scot %da now.gowl)
      :(weld /nooks/dip path /noun)
  ==
::
++  get
  |*  state=mold
  |=  =path
  ^-  (unit state)
  =/  vax=(unit vase)  (get-raw path)
  ?~(vax ~ `!<(state u.vax))
::
++  put-raw
  |=  [=path =vase]
  =/  m  (strand ,(unit ^vase))
  ^-  form:m
  ;<  ~  bind:m  (just-put path vase)
  (pure:m (get-raw path))
::
++  del-raw
  |=  =path
  =/  m  (strand ,(unit vase))
  ^-  form:m
  ;<  ~  bind:m  (just-del path)
  (pure:m (get-raw path))
::
++  lop-raw
  |=  =path
  =/  m  (strand ,(unit vase))
  ^-  form:m
  ;<  ~  bind:m  (just-lop path)
  (pure:m (get-raw path))
::
++  put
  |*  state=mold
  =/  m  (strand ,state)
  |=  [=path =state]
  ;<  vax=(unit vase)  bind:m  (put-raw path !>(state))
  (pure:m !<(^state (need vax)))
::
++  get-or-init-raw
  =/  m  (strand ,vase)
  |=  [=path init=form:m]
  ^-  form:m
  =/  vax=(unit vase)  (get-raw path)
  ?^  vax
    (pure:m u.vax)
  ~&  >>  "{<dap.gowl>}: nook at {<path>} is uninitialized"
  ;<  nit=vase  bind:m  init
  ;<  vas=(unit vase)  bind:m  (put-raw path nit)
  (pure:m (need vas))
::
++  get-or-init
  |*  state=mold
  =/  m  (strand ,state)
  |=  [=path init=form:m]
  ^-  form:m
  =/  vax=(unit state)  ((get state) path)
  ?^  vax
    (pure:m u.vax)
  ~&  >>  "{<dap.gowl>}: nook at {<path>} is uninitialized"
  ;<  nit=state  bind:m  init
  ((put state) path nit)
::
++  id-safe-uv
  |=  =@uv
  %+  rap  3
  %+  rash  (scot %uv uv)
  %-  star
  ;~  pose
    (cold '-' (just '.'))
    next
  ==
::
++  get-unique-uv
  |=  base=(pole @t)
  ^-  @ta
  =/  dipped=nooks:ui  (dip base)
  =/  keys=(set @ta)  ~(key by dir.dipped)
  |-
  =/  key=@ta  (id-safe-uv (sham eny.gowl))
  ?.  (~(has in keys) key)
    key
  $(eny.gowl +(eny.gowl))
--
