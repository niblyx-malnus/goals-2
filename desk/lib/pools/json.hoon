/-  p=pools
/+  u=json-utils
|%
++  enjs
  =,  enjs:format
  |%
  ++  id-string  |=(=id:p (rap 3 '/' (scot %p host.id) '/' name.id ~))
  ++  auto
    |=  =auto:p
    ^-  json
    ?@  auto
      (pairs ~[response+b/|])
    %-  pairs
    :~  [%response b+&]
        [%metadata o+metadata.auto]
    ==
  --
::
++  dejs
  =,  dejs:format
  |%
  ++  ship  (su fed:ag)
  ++  id-string  ;~(pfix fas ;~((glue fas) ;~(pfix sig fed:ag) sym))
  ++  id         (su id-string)
  ++  metadata
    |=  jon=json
    ^-  metadata:p
    ?>  ?=(%o -.jon)
    p.jon
  ::
  ++  invite   metadata
  ++  request  metadata
  ::
  ++  blocked
    |=  jon=json
    ^-  blocked:p
    *blocked:p
  ::
  ++  graylist-field
    |=  jon=json
    ^-  graylist-field:p
    *graylist-field:p
  ::
  ++  pool-data-field
    |=  jon=json
    ^-  pool-data-field:p
    *pool-data-field:p
  ::
  ++  ud-blocked
    %+  ((each-method:dejs:u %uni %dif) blocked:p blocked:p)
      (ot ~[p+blocked])
    (ot ~[p+blocked])
  ::
  ++  local-action
    ^-  $-(json local-action:p)
    %-  of
    :~  [%create-pool (ot ~[graylist-fields+(ar graylist-field) pool-data-fields+(ar pool-data-field)])]
        [%delete-pool (ot ~[id+id])]
        [%leave-pool (ot ~[id+id])]
        [%watch-pool (ot ~[id+id])]
        [%update-blocked (ot ~[p+ud-blocked])] :: %&: uni; %|: dif
        [%extend-request (ot ~[id+id request+request])]
        [%cancel-request (ot ~[id+id])]
        [%accept-invite (ot ~[id+id metadata+metadata])]
        [%reject-invite (ot ~[id+id metadata+metadata])]
        [%delete-invite (ot ~[id+id])]
    ==
  ::
  ++  pool-action
    ^-  $-(json pool-action:p)
    %-  of
    :~  [%kick-member (ot ~[member+ship])]
        [%kick-blacklisted (ot ~[requests+(op fed:ag request)])]
        [%update-graylist (ot ~[fields+(ar graylist-field)])]
        [%update-pool-data (ot ~[fields+(ar pool-data-field)])]
        [%extend-invite (ot ~[invitee+ship invite+invite])]
        [%cancel-invite (ot ~[invitee+ship])]
        [%accept-request (ot ~[requester+ship metadata+metadata])]
        [%reject-request (ot ~[requester+ship metadata+metadata])]
        [%delete-request (ot ~[requester+ship])]
    ==
  ::
  ++  view
    ^-  $-(json view:p)
    %-  of
    :~  [%pools (ot ~[request+request])]
        [%public-data (ot ~[id+id request+request])]
    ==
  --
--
