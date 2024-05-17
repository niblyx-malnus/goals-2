/-  c=calendar, r=rules, t=timezones
/+  timezones
::
=|  =cache:r
=|  =zones:t
=|  tans=(list event-transition:c)
|_  =event:c
+*  this  .
    zon   ~(. timezones zones to-to-jumps.cache)
++  abet  [(flop tans) event]
++  teba  [tans event] :: unflopped effects
++  apex
  |=  [=event:c =cache:r =zones:t]
  %=    this
    tans   ~
    cache  cache
    zones  zones
    event  event
  ==
++  emit  |=(tan=event-transition:c this(tans [tan tans]))
++  emil  |=(tanz=(list event-transition:c) this(tans (weld tanz tans)))
::
++  get-tz-to-utc
  |=  uzid=(unit zid:t)
  ^-  (unit tz-to-utc:t)
  ?~  uzid  `|=(dext:t `d)
  (mole |.(tz-to-utc:(abed:zn:zon u.uzid)))
::
++  get-utc-to-tz
  |=  uzid=(unit zid:t)
  ^-  (unit utc-to-tz:t)
  ?~  uzid  `|=(d=@da [~ 0 d])
  (mole |.(utc-to-tz:(abed:zn:zon u.uzid)))
::
++  get-to-fullday
  |=  ruledata:c
  ^-  to-fullday:r
  ?>  ?=(%fuld q.rid)
  ?>  ?=(%fuld -.kind)
  =/  =to-to-fullday:r
    (~(got by to-to-fulldays.cache) rid)
  (to-to-fullday args)
::
++  get-to-span
  |=  ruledata:c
  ^-  to-span:r
  ?>  ?=(?(%both %left) q.rid)
  ?-    q.rid
      %both
    ?>  ?=(%both -.kind)
    |=  idx=@ud
    ^-  span-instance:r
    =/  =to-to-both:r  (~(got by to-to-boths.cache) rid)
    =/  =to-both:r     (to-to-both args)
    =/  out=(each [l=dext:r r=dext:r] rule-exception:r)  (to-both idx)
    ?:  ?=(%| -.out)  [%| p.out]
    ?~  letz=(get-tz-to-utc lz.kind)
      [%| %failed-to-retrieve-tz-to-utc lz.kind]
    ?~  ritz=(get-tz-to-utc rz.kind)
      [%| %failed-to-retrieve-tz-to-utc rz.kind]
    =/  l  (u.letz l.p.out)
    =/  r  (u.ritz r.p.out)
    ?:  ?&(?=(^ l) ?=(^ r))
      ?:  (lte u.l u.r)
        [%& u.l u.r]
      :^  %|  %out-of-order
        [[lz.kind l.p.out] u.l]
      [[rz.kind r.p.out] u.r]
    :^  %|  %bad-index
      ?^(l ~ `[lz.kind l.p.out])
    ?^(r ~ `[rz.kind r.p.out])
    ::
      %left
    ?>  ?=(%left -.kind)
    |=  idx=@ud
    ^-  span-instance:r
    =/  =to-to-left:r  (~(got by to-to-lefts.cache) rid)
    =/  =to-left:r     (to-to-left args)
    =/  out=(each dext:r rule-exception:r)  (to-left idx)
    ?:  ?=(%| -.out)  [%| p.out]
    ?~  tz-to-utc=(get-tz-to-utc tz.kind)
      [%| %failed-to-retrieve-tz-to-utc tz.kind]
    ?~  utc-to-tz=(get-utc-to-tz tz.kind)
      [%| %failed-to-retrieve-utc-to-tz tz.kind]
    =/  l  (u.tz-to-utc p.out)
    ?~  l  [%| %bad-index `[tz.kind p.out] ~]
    =/  r=@da  (add u.l d.kind)
    ?^  (u.utc-to-tz r)  [%& u.l r]
    [%| %out-of-bounds tz.kind r]
  ==
::
++  handle-transition
  |=  tan=event-transition:c
  ^-  _this
  ?-    -.tan
    %init-event  this(event event.tan)
    ::
    %dom         this(dom.event dom.tan)
    ::
      %ruledata
    ?<  (~(has by ruledata.event) aid.tan)  
    this(ruledata.event (~(put by ruledata.event) [aid ruledata]:tan))
    ::
      %metadata
    ?<  (~(has by metadata.event) mid.tan)  
    this(metadata.event (~(put by metadata.event) [mid metadata]:tan))
    ::
      %default-ruledata
    ?>  (~(has by ruledata.event) aid.tan)
    this(default-ruledata.event aid.tan)
    ::
      %default-metadata
    ?>  (~(has by metadata.event) mid.tan)
    this(default-metadata.event mid.tan)
    ::
      %ruledata-map
    this(ruledata-map.event (~(put by ruledata-map.event) [i aid]:tan))
    ::
      %metadata-map
    this(metadata-map.event (~(put by metadata-map.event) [i mid]:tan))
    ::
      %rsvp
    =/  =rsvps:c  (~(gut by rsvps.event) i.tan ~)
    =.  rsvps     (~(put by rsvps) [ship rsvp]:tan)
    this(rsvps.event (~(put by rsvps.event) i.tan rsvps))
    ::
      %instantiate
    |-
    ?~  idx-list.tan  this
    =/  =aid:c  (~(gut by ruledata-map.event) i.idx-list.tan default-ruledata.event)
    =/  =ruledata:c  (~(got by ruledata.event) aid)
    :: IMPORTANT: cached computation
    ::
    =/  =instance:c
      ?-    -.kind.ruledata
        %skip           skip+~
        %fuld           fuld+(~+((get-to-fullday ruledata)) i.idx-list.tan)
        ?(%left %both)  span+(~+((get-to-span ruledata)) i.idx-list.tan)
      ==
    %=  $
      idx-list.tan     t.idx-list.tan
      instances.event  (~(put by instances.event) i.idx-list.tan instance)
    ==
  ==
--
