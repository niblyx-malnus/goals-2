/-  p=pools
/+  *ventio, pools, j=pools-json
|_  =gowl
++  dude  %pools
++  handle-transition
  |=  =transition:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl dude]
  pools-transition+!>(transition)
::
++  handle-pool-transition
  |=  [=id:p =pool-transition:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl dude]
  :-  %pools-transition  !>
  ^-  transition:p
  [%update-pool id pool-transition]
::
++  delete-pool
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl dude]
  :-  %pools-transition  !>
  ^-  transition:p
  [%delete-pool id]
::
++  update-pool-data
  |=  [=id:p fields=(list pool-data-field:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl dude]
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-pool-data fields]
::
++  update-members
  |=  [=id:p member=ship roles=(unit (each roles:p roles:p))]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl dude]
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-members member roles]
::
++  create-pool-transition
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our.gowl dude]
  :-  %pools-transition  !>
  ^-  transition:p
  [%create-pool id]
::
++  create-pool-action
  |=  $:  graylist-fields=(list graylist-field:p)
          pool-data-fields=(list pool-data-field:p)
      ==
  =/  m  (strand ,json)
  ^-  form:m
  %+  (vent ,json)  [our.gowl dude]
  :-  %pools-local-action
  ^-  local-action:p
  [%create-pool graylist-fields pool-data-fields]
::
++  kick-member
  |=  [=id:p member=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl dude]
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%kick-member member]
::
++  leave-pool
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl dude]
  :-  %pools-local-action
  ^-  local-action:p
  [%leave-pool id]
::
++  extend-invite
  |=  [=id:p invitee=ship =invite:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl dude]
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%extend-invite invitee invite]
::
++  cancel-invite
  |=  [=id:p invitee=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl dude]
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%cancel-invite invitee]
::
++  accept-invite
  |=  [=id:p =metadata:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl dude]
  :-  %pools-local-action
  ^-  local-action:p
  [%accept-invite id metadata]
::
++  reject-invite
  |=  [=id:p =metadata:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl dude]
  :-  %pools-local-action
  ^-  local-action:p
  [%reject-invite id metadata]
::
++  delete-invite
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl dude]
  :-  %pools-local-action
  ^-  local-action:p
  [%delete-invite id]
::
++  extend-request
  |=  [=id:p =request:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl dude]
  :-  %pools-local-action
  ^-  local-action:p
  [%extend-request id request]
::
++  cancel-request
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl dude]
  :-  %pools-local-action
  ^-  local-action:p
  [%cancel-request id]
::
++  accept-request
  |=  [=id:p requester=ship =metadata:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl dude]
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%accept-request requester metadata]
::
++  reject-request
  |=  [=id:p requester=ship =metadata:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl dude]
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%reject-request requester metadata]
::
++  delete-request
  |=  [=id:p requester=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl dude]
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%delete-request requester]
::
++  update-blocked
  |=  upd=(each blocked:p blocked:p)
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl dude]
  :-  %pools-local-action
  ^-  local-action:p
  [%update-blocked upd]
::
++  update-graylist-transition
  |=  [=id:p fields=(list graylist-field:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-graylist fields]
::
++  update-graylist-action
  |=  [=id:p fields=(list graylist-field:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our.gowl dude]
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%update-graylist fields]
::
++  update-outgoing-invites
  |=  [=id:p invitee=ship invite=(unit invite:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-outgoing-invites invitee invite]
::
++  update-outgoing-invite-response
  |=  [=id:p invitee=ship =status:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-outgoing-invite-response invitee status]
::
++  update-incoming-requests
  |=  [=id:p requester=ship request=(unit request:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-incoming-requests requester request]
::
++  update-incoming-request-response
  |=  [=id:p requester=ship =status:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  :+  %update-pool  id
  [%update-incoming-request-response requester status]
::
++  update-incoming-invites
  |=  [=id:p invite=(unit invite:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  [%update-incoming-invites id invite]
::
++  update-incoming-invite-response
  |=  [=id:p =status:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  [%update-incoming-invite-response id status]
::
++  update-outgoing-requests
  |=  [=id:p request=(unit request:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  [%update-outgoing-requests id request]
::
++  update-outgoing-request-response
  |=  [=id:p =status:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %pools-transition  !>
  ^-  transition:p
  [%update-outgoing-request-response id status]
::
++  timeout  ~s15
::
++  give-kick-gesture
  |=  [=id:p member=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [member dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%kick id]
::
++  give-leave-gesture
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [host.id dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%leave id]
::
++  give-invite-gesture
  |=  [=id:p invitee=ship invite=(unit invite:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [invitee dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%invite id invite]
::
++  give-invite-response-gesture
  |=  [=id:p =status:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [host.id dap.gowl]
   :-  %pools-gesture
  ^-  gesture:p
  [%invite-response id status]
::
++  give-delete-invite-gesture
  |=  =id:p
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [host.id dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%delete-invite id]
::
++  give-request-gesture
  |=  [=id:p request=(unit request:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [host.id dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%request id request]
::
++  give-request-response-gesture
  |=  [=id:p requester=ship =status:p]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [requester dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%request-response id status]
::
++  give-delete-request-gesture
  |=  [=id:p requester=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [requester dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%delete-request id]
::
++  give-watch-me-gesture
  |=  [=id:p member=ship]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (set-timeout ,~)  timeout
  %+  (vent ,~)  [member dap.gowl]
  :-  %pools-gesture
  ^-  gesture:p
  [%watch-me id]
::
++  kick-blacklisted
  |=  [=id:p requests=(map ship request:p)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  (vent ,~)  [our dap]:gowl
  :-  %pools-pool-action  :-  id
  ^-  pool-action:p
  [%kick-blacklisted requests]
--
