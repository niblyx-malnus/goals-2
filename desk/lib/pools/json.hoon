/-  p=pools
/+  u=json-utils
|%
++  enjs
  =,  enjs:format
  |%
  ++  ship  |=(=@p s+(scot %p p))
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
  :: TODO: implement
  ::
  ++  blocked
    |=  jon=json
    ^-  blocked:p
    *blocked:p
  ::
  ++  rank  |=(jon=json ;;(rank:title (so jon)))
  :: TODO: fix to handle accepting metadata
  ::
  ++  auto
    |=  jon=json
    ^-  auto:p
    ?.  (bo:dejs:format jon)
      %|
    [%& ~]
  ::
  ++  unit-auto
    |=  jon=json
    ^-  (unit auto:p)
    ?~(jon ~ [~ (auto jon)])
  ::
  ++  graylist-field
    |=  jon=json
    ^-  graylist-field:p
    %.  jon
    %-  of
    :~  [%ship (ar (ot ~[ship+(su fed:ag) auto+unit-auto]))]
        [%rank (ar (ot ~[rank+rank auto+unit-auto]))]
        [%rest unit-auto]
        [%dude |=(jon=json ?~(jon ~ [~ (so jon)]))]
    ==
  ::
  ++  pool-data-pair
    |=  jon=json
    ^-  [@t (unit json)]
    ?>  ?=(%o -.jon)
    :-  (so (~(got by p.jon) 'field'))
    ?~  get=(~(get by p.jon) 'data')
      ~
    [~ u.get]
  ::
  ++  pool-data-field
    |=  jon=json
    ^-  pool-data-field:p
    %.  jon
    %-  of
    :~  [%private (ar pool-data-pair)]
        [%public (ar pool-data-pair)]
    ==
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
  ++  filter
    |=  jon=json
    ^-  filter:p
    ?~  jon
      ~
    :-  ~
    ?>  ?=(%o -.jon)
    %.  jon
    %+  ((each-method:dejs:u %only %except) (set @t) (set @t))
      (ot ~[fields+(as so)])
    (ot ~[fields+(as so)])
  ::
  ++  view
    ^-  $-(json view:p)
    %-  of
    :~  [%pools (ot ~[request+request filter+filter])]
        [%public-data (ot ~[id+id request+request filter+filter])]
    ==
  --
--
