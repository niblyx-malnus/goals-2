|%
+$  id                 [host=ship name=term]
+$  dude               dude:gall
+$  rank               rank:title
+$  role               term
+$  roles              (set role)
+$  members            (map ship roles)
+$  metadata           (map @t json)
+$  invite             metadata
+$  request            metadata
+$  status             (unit [response=? =metadata])
+$  outgoing-invites   (map ship [=invite =status])
+$  incoming-requests  (map ship [=request =status])
+$  incoming-invites   (map id [=invite =status])
+$  outgoing-requests  (map id [=request =status])
+$  pool-data          [private=metadata public=metadata]
:: disallow or auto-accept requests
+$  auto               $@(%| [%& =metadata])
+$  graylist
  $:  ship=(map ship auto) :: black/whitelisted ships
      rank=(map rank auto) :: black/whitelisted ranks (i.e. banning comets)
      rest=(unit auto)     :: black/whitelist remaining
      dude=(unit dude)     :: optional outsource graylist
  ==
+$  pool
  $:  =members  :: already joined (includes host)
      =outgoing-invites
      =incoming-requests
      =graylist
      =pool-data
  ==
+$  pools  (map id pool)
+$  blocked
  $:  pools=(set id)   :: block invites
      hosts=(set ship) :: block invites
      peers=(set ship) :: block pool list requests
  ==
:: don't subscribe to foreign pools during development
:: state-syncing is time-wasting tedium; vent-views only to start
::
+$  remote-pools  (set id)
+$  state-0
  $:  %0
      =pools
      =remote-pools :: eventually will go into pools + synced via subs
      =incoming-invites
      =outgoing-requests
      =blocked
  ==
:: You will give anyone a list of pools you host which
:: they wouldn't be auto-rejected from as a (map id metadata)
:: with the pool's public metadata.
+$  transition
  $%  [%update-blocked p=(each blocked blocked)] :: %&: uni; %|: dif
      [%update-incoming-invites =id invite=(unit invite)]
      [%update-outgoing-requests =id request=(unit request)]
      [%update-incoming-invite-response =id =status]
      [%update-outgoing-request-response =id =status]
      [%update-pool =id p=pool-transition]
      [%create-pool =id]
      [%delete-pool =id]
  ==
::
+$  pool-transition
  $%  [%update-members member=ship roles=(unit (each roles roles))]
      [%update-outgoing-invites invitee=ship invite=(unit invite)]
      [%update-incoming-requests requester=ship request=(unit request)]
      [%update-outgoing-invite-response invitee=ship =status]
      [%update-incoming-request-response requester=ship =status]
      [%update-graylist fields=(list graylist-field)]
      [%update-pool-data fields=(list pool-data-field)]
  ==
::
+$  graylist-field
  $%  [%ship p=(list [ship (unit auto)])]
      [%rank p=(list [rank (unit auto)])]
      [%rest p=(unit auto)]
      [%dude p=(unit dude)]
  ==
::
+$  pool-data-field
  $%  [%private p=(list [@t (unit json)])]
      [%public p=(list [@t (unit json)])]
  ==
::
+$  action
  $%  [%create-pool graylist-fields=(list graylist-field) pool-data-fields=(list pool-data-field)]
      [%delete-pool =id]
      [%extend-invite =id invitee=ship =invite]
      [%cancel-invite =id invitee=ship]
      [%accept-invite =id =metadata]
      [%reject-invite =id =metadata]
      [%extend-request =id =request]
      [%cancel-request =id]
      [%accept-request =id requester=ship =metadata]
      [%reject-request =id requester=ship =metadata]
  ==
::
+$  gesture
  $%  [%invite =id invite=(unit invite)]
      [%invite-response =id =status]
      [%request =id request=(unit request)]
      [%request-response =id =status]
  ==
:: allows you to do things based on invite/request metadata
:: on invite/request resolution
:: e.g. update roles based on "invited as %admin"
::
+$  delegation
  $%  [%graylist =id requester=ship =request]
      [%add-from-invite =id invitee=ship =invite]
      [%add-from-request =id requester=ship =request]
  ==
::
+$  view
  $%  [%pools =metadata]
      [%public-data =id =metadata]
  ==
--
