/-  c=calendar, r=rules, t=timezones
/+  timezones
::
=|  tans=(list event-transition:c)
|_  [=bowl:gall =event:c]
+*  this  .
++  abet  [(flop tans) event]
++  teba  [tans event] :: unflopped effects
++  emit  |=(tan=event-transition:c this(tans [tan tans]))
++  emil  |=(tanz=(list event-transition:c) this(tans (weld tanz tans)))
::
++  get-tz-to-utc
  |=  uzid=(unit zid:t)
  ^-  (unit tz-to-utc:t)
  ?~  uzid  `|=(dext:t `d)
  .^  (unit tz-to-utc:t)  %gx
    %+  weld
      /(scot %p our.bowl)/timezones/(scot %da now.bowl)
    /tz-to-utc/(scot %p p.u.uzid)/[q.u.uzid]/noun
  ==
::
++  get-utc-to-tz
  |=  uzid=(unit zid:t)
  ^-  (unit utc-to-tz:t)
  ?~  uzid  `|=(d=@da [~ 0 d])
  .^  (unit utc-to-tz:t)  %gx
    %+  weld
      /(scot %p our.bowl)/timezones/(scot %da now.bowl)
    /utc-to-tz/(scot %p p.u.uzid)/[q.u.uzid]/noun
  ==
::
++  get-to-to-fullday
  |=  =rid:r
  ?>  ?=(%fuld q.rid)
  .^  (unit to-to-fullday:r)  %gx
    %+  weld
      /(scot %p our.bowl)/rule-store/(scot %da now.bowl)
    /to-to-fullday/[?~(p.rid %$ (scot %p u.p.rid))]/fuld/[r.rid]/noun
  ==
::
++  get-to-to-both
  |=  =rid:r
  ?>  =(%both q.rid)
  .^  (unit to-to-both:r)  %gx
    %+  weld
      /(scot %p our.bowl)/rule-store/(scot %da now.bowl)
    /to-to-both/[?~(p.rid %$ (scot %p u.p.rid))]/both/[r.rid]/noun
  ==
::
++  get-to-to-left
  |=  =rid:r
  ?>  =(%left q.rid)
  .^  (unit to-to-left:r)  %gx
    %+  weld
      /(scot %p our.bowl)/rule-store/(scot %da now.bowl)
    /to-to-left/[?~(p.rid %$ (scot %p u.p.rid))]/left/[r.rid]/noun
  ==
::
++  get-to-fullday
  |=  ruledata:c
  ^-  to-fullday:r
  ?>  ?=(%fuld q.rid)
  ?>  ?=(%fuld -.kind)
  =/  =to-to-fullday:r
    (need (get-to-to-fullday rid))
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
    =/  =to-to-both:r  (need (get-to-to-both rid))
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
    =/  =to-to-left:r  (need (get-to-to-left rid))
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
    ?~  aid.tan
      this(ruledata-map.event (~(del by ruledata-map.event) i.tan))
    this(ruledata-map.event (~(put by ruledata-map.event) [i u.aid]:tan))
    ::
      %metadata-map
    ?~  mid.tan
      this(metadata-map.event (~(del by metadata-map.event) i.tan))
    this(metadata-map.event (~(put by metadata-map.event) [i u.mid]:tan))
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
::
++  handle-compound-transition
  |=  tan=compound-event-transition:c
  ^-  _this
  ?-    -.tan
      %init
    =.  this  (handle-transition %dom dom.tan)
    =.  this  (handle-transition %metadata [mid metadata]:tan)
    =.  this  (handle-transition %default-metadata mid.tan)
    =.  this  (handle-transition %ruledata [aid ruledata]:tan)
    =.  this  (handle-transition %default-ruledata aid.tan)
    (handle-transition %instantiate (gulf dom.tan))
    ::
      %update-metadata
    =/  idx-list=(list @ud)  (gulf dom.tan)
    |-
    ?~  idx-list
      (handle-transition %instantiate (gulf dom.tan))
    =.  this  (handle-transition %metadata-map i.idx-list mid.tan)
    $(idx-list t.idx-list)
    ::
      %update-ruledata
    =/  idx-list=(list @ud)  (gulf dom.tan)
    |-
    ?~  idx-list
      (handle-transition %instantiate (gulf dom.tan))
    =.  this  (handle-transition %ruledata-map i.idx-list aid.tan)
    $(idx-list t.idx-list)
    ::
      %update-domain
    =.  this  (handle-transition %dom dom.tan)
    (handle-transition %instantiate (gulf dom.tan))
  ==
--
