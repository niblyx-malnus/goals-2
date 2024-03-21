|%
+$  id                 [host=ship name=term]
+$  dude               dude:gall
+$  rank               rank:title
+$  role               term
+$  roles              (set role)
+$  members            (map ship roles)
+$  metadata           (map @t json)
+$  invite             metadata :: eventually deal with timestamps?
+$  request            metadata :: eventually deal with timestamps?
+$  status             (unit [response=? =metadata]) :: eventually deal with timestamps?
+$  outgoing-invites   (map ship [=invite =status])
+$  incoming-requests  (map ship [=request =status])
+$  incoming-invites   (map id [=invite =status])
+$  outgoing-requests  (map id [=request =status])
+$  pool-data          [private=metadata public=metadata]
+$  graylist
  $:  ship=(map ship ?) :: black/whitelisted ships
      rank=(map rank ?) :: black/whitelisted ranks (i.e. banning comets)
      rest=(unit ?)     :: auto-accept/reject remaining
      dude=(unit dude)  :: optional outsource graylist
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
+$  state-0
  $:  %0
      moon-as-planet=$~(| ?)
      =pools
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
      [%update-incoming-requests requestee=ship request=(unit request)]
      [%update-outgoing-invite-response invitee=ship =status]
      [%update-incoming-request-response requestee=ship =status]
      [%update-graylist fields=(list graylist-field)]
      [%update-pool-data fields=(list pool-data-field)]
  ==
::
+$  graylist-field
  $%  [%ship p=(list [ship (unit ?)])]
      [%rank p=(list [rank (unit ?)])]
      [%rest p=(unit ?)]
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
      [%accept-request =id requestee=ship =metadata]
      [%reject-request =id requestee=ship =metadata]
  ==
::
+$  gesture
  $%  [%invite =id invite=(unit invite)]
      [%invite-response =id =status]
      [%request =id request=(unit request)]
      [%request-response =id =status]
  ==
--
