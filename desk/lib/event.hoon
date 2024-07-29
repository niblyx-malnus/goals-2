/-  c=calendar, r=rules
/+  p=pytz
::
=|  tans=(list event-transition:c)
|_  [=bowl:gall =event:c]
+*  this  .
++  abet  [(flop tans) event]
++  teba  [tans event] :: unflopped effects
++  emit  |=(tan=event-transition:c this(tans [tan tans]))
++  emil  |=(tanz=(list event-transition:c) this(tans (weld tanz tans)))
::
++  get-to-to-fuld
  |=  =rid:r
  ?>  ?=(%fuld q.rid)
  .^  (unit to-to-fuld:r)  %gx
    %+  weld
      /(scot %p our.bowl)/rule-store/(scot %da now.bowl)
    /to-to-fuld/[?~(p.rid %$ (scot %p u.p.rid))]/fuld/[r.rid]/noun
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
++  get-to-fuld
  |=  ruledata:c
  ^-  to-fuld:r
  ?>  ?=(%fuld q.rid)
  ?>  ?=(%fuld -.kind)
  =/  =to-to-fuld:r
    (need (get-to-to-fuld rid))
  (to-to-fuld args)
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
    ?:  ?=(%| -.out)
      [%| p.out]
    =/  l=(unit @da)  (~(tz-to-utc zn:p lz.kind) l.p.out)
    =/  r=(unit @da)  (~(tz-to-utc zn:p rz.kind) r.p.out)
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
    =/  l=(unit @da)   (~(tz-to-utc zn:p tz.kind) p.out)
    ?~  l
      [%| %bad-index `[tz.kind p.out] ~]
    =/  r=@da  (add u.l d.kind)
    ?^  (~(utc-to-tz zn:p tz.kind) r)
      [%& u.l r]
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
    =/  =aid:c  (scot %uv (sham ruledata.tan))
    this(ruledata.event (~(put by ruledata.event) aid ruledata.tan))
    ::
      %metadata
    =/  =mid:c  (scot %uv (sham metadata.tan))
    this(metadata.event (~(put by metadata.event) mid metadata.tan))
    ::
      %default-ruledata
    ?>  (~(has by ruledata.event) aid.tan)
    =/  dom=(list @ud)  (gulf dom.event)
    |-
    ?~  dom
      this(default-ruledata.event aid.tan)
    =/  aid=(unit aid:c)  (~(get by ruledata-map.event) i.dom)
    =.  ruledata-map.event
      ?~  aid
        (~(put by ruledata-map.event) i.dom default-ruledata.event)
      ?.  =(u.aid aid.tan)
        ruledata-map.event
      (~(del by ruledata-map.event) i.dom)
    $(dom t.dom)
    ::
      %default-metadata
    ?>  (~(has by metadata.event) mid.tan)
    =/  dom=(list @ud)  (gulf dom.event)
    |-
    ?~  dom
      this(default-metadata.event mid.tan)
    =/  mid=(unit mid:c)  (~(get by metadata-map.event) i.dom)
    =.  metadata-map.event
      ?~  mid
        (~(put by metadata-map.event) i.dom default-metadata.event)
      ?.  =(u.mid mid.tan)
        metadata-map.event
      (~(del by metadata-map.event) i.dom)
    $(dom t.dom)
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
        %fuld           fuld+(~+((get-to-fuld ruledata)) i.idx-list.tan)
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
    =/  =aid:c  (scot %uv (sham ruledata.tan))
    =/  =mid:c  (scot %uv (sham metadata.tan))
    =.  this  (handle-transition %dom dom.tan)
    =.  this  (handle-transition %metadata metadata.tan)
    =.  this  (handle-transition %default-metadata mid)
    =.  this  (handle-transition %ruledata ruledata.tan)
    =.  this  (handle-transition %default-ruledata aid)
    =.  this  (handle-compound-transition %update-metadata dom.tan ~ mid)
    (handle-compound-transition %update-ruledata dom.tan ~ aid)
    ::
      %update-metadata
    ~&  >  %update-metadata
    =/  idx-list=(list @ud)  (gulf dom.tan)
    |-
    ?~  idx-list
      (handle-transition %instantiate (gulf dom.tan))
    =.  this  (handle-transition %metadata-map i.idx-list mid.tan)
    $(idx-list t.idx-list)
    ::
      %update-ruledata
    ~&  >  %update-ruledata
    =/  idx-list=(list @ud)  (gulf dom.tan)
    |-
    ?~  idx-list
      (handle-transition %instantiate (gulf dom.tan))
    =.  this  (handle-transition %ruledata-map i.idx-list aid.tan)
    $(idx-list t.idx-list)
    ::
      %update-new
    ~&  >  %update-new
    =/  idx-list=(list @ud)  (gulf dom.tan)
    =/  =aid:c  (scot %uv (sham ruledata.tan))
    =/  =mid:c  (scot %uv (sham metadata.tan))
    |-
    ?~  idx-list
      =?  this  default.tan
        =.  this  (handle-transition %default-ruledata aid)
        (handle-transition %default-metadata mid)
      (handle-transition %instantiate (gulf dom.tan))
    =.  this  (handle-transition %ruledata ruledata.tan)
    =.  this  (handle-transition %ruledata-map i.idx-list ~ aid)
    =.  this  (handle-transition %metadata metadata.tan)
    =.  this  (handle-transition %metadata-map i.idx-list ~ mid)
    $(idx-list t.idx-list)
    ::
      %update-domain
    =.  this  (handle-transition %dom dom.tan)
    (handle-transition %instantiate (gulf dom.tan))
  ==
--
