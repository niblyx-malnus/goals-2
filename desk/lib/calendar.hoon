/-  c=calendar, r=rules
/+  vlib=event, tu=time-utils
::
=|  tans=(list calendar-transition:c)
|_  [=bowl:gall =calendar:c]
+*  this  .
++  abet  [(flop tans) calendar]
++  teba  [tans calendar] :: unflopped effects
++  emit  |=(tan=calendar-transition:c this(tans [tan tans]))
++  emil  |=(tanz=(list calendar-transition:c) this(tans (weld tanz tans)))
::
++  handle-transition
  |=  tan=calendar-transition:c
  ^-  _this
  ?-    -.tan
    %init-calendar  this(calendar calendar.tan)
    ::
      %create-event
    ?<  (~(has by events.calendar) eid.tan)
    =|  =event:c
    =:  eid.event               eid.tan
        ruledata.event          (~(put by ruledata.event) skip-id:c skip:c)
        instances.event         (~(put by instances.event) 0 %skip ~)
        default-ruledata.event  skip-id:c
      ==
    this(events.calendar (~(put by events.calendar) eid.tan event))
    ::
      %delete-event
    this(events.calendar (~(del by events.calendar) eid.tan))
    ::
      %update-event
    (handle-event-transition [eid p]:tan)
  ==
::
++  handle-event-transition
  |=  [=eid:c tan=event-transition:c]
  ^-  _this
  =/  =event:c  (~(gut by events.calendar) eid *event:c)
  =.  event   event:(~(handle-transition vlib bowl event) tan)
  this(events.calendar (~(put by events.calendar) eid event))
::
++  handle-compound-transition
  |=  [mod=ship tan=compound-calendar-transition:c]
  ^-  _this
  ?-    -.tan
      %create-event
    =.  this  (handle-transition %create-event eid.tan)
    =/  =event:c  (~(got by events.calendar) eid.tan)
    =.  event
        =-  event
        %-  ~(handle-compound-transition vlib bowl event)
        [%init [dom metadata ruledata]:tan]
    =.  this
      %+  rap:or  eid.tan
      %+  murn  ~(tap by instances.event)
      |=  [i=@ud n=instance:c]
      ?.  &((gte i l.dom.tan) (lte i r.dom.tan))
        ~
      [~ i n]
    this(events.calendar (~(put by events.calendar) eid.tan event))
    ::
      %delete-event
    =/  =event:c  (~(got by events.calendar) eid.tan)
    =.  this  (pur:or eid.tan ~(tap in ~(key by instances.event)))
    (handle-transition %delete-event eid.tan)
    ::
      %update-event
    ?-    -.p.tan
        %init
      =/  =event:c  (~(got by events.calendar) eid.tan)
      =.  event   event:(~(handle-compound-transition vlib bowl event) p.tan)
      =.  this
        %+  rap:or  eid.tan
        %+  murn  ~(tap by instances.event)
        |=  [i=@ud n=instance:c]
        ?.  &((gte i l.dom.p.tan) (lte i r.dom.p.tan))
          ~
        [~ i n]
      this(events.calendar (~(put by events.calendar) eid.tan event))
      ::
        %update-metadata
      =/  =event:c  (~(got by events.calendar) eid.tan)
      =.  event   event:(~(handle-compound-transition vlib bowl event) p.tan)
      =.  this
        %+  rap:or  eid.tan
        %+  murn  ~(tap by instances.event)
        |=  [i=@ud n=instance:c]
        ?.  &((gte i l.dom.p.tan) (lte i r.dom.p.tan))
          ~
        [~ i n]
      this(events.calendar (~(put by events.calendar) eid.tan event))
      ::
        %update-ruledata
      =/  =event:c  (~(got by events.calendar) eid.tan)
      =.  event   event:(~(handle-compound-transition vlib bowl event) p.tan)
      =.  this
        %+  rap:or  eid.tan
        %+  murn  ~(tap by instances.event)
        |=  [i=@ud n=instance:c]
        ?.  &((gte i l.dom.p.tan) (lte i r.dom.p.tan))
          ~
        [~ i n]
      this(events.calendar (~(put by events.calendar) eid.tan event))
      ::
        %update-new
      =/  =event:c  (~(got by events.calendar) eid.tan)
      =.  event   event:(~(handle-compound-transition vlib bowl event) p.tan)
      =.  this
        %+  rap:or  eid.tan
        %+  murn  ~(tap by instances.event)
        |=  [i=@ud n=instance:c]
        ?.  &((gte i l.dom.p.tan) (lte i r.dom.p.tan))
          ~
        [~ i n]
      this(events.calendar (~(put by events.calendar) eid.tan event))
      ::
        %update-domain
      =/  =event:c  (~(got by events.calendar) eid.tan)
      =.  this
        %+  pur:or  eid.tan
        ~(tap in (~(dif in (sy (gulf dom.event))) (sy (gulf dom.p.tan))))
      =.  event   event:(~(handle-compound-transition vlib bowl event) p.tan)
      =.  this
        %+  rap:or  eid.tan
        %+  murn  ~(tap by instances.event)
        |=  [i=@ud n=instance:c]
        ?.  &((gte i l.dom.p.tan) (lte i r.dom.p.tan))
          ~
        [~ i n]
      this(events.calendar (~(put by events.calendar) eid.tan event))
    ==
  ==
::
++  or
  |%
  ++  spa
    |=  [l=@da r=@da]
    ^-  (set iref:c)
    ?>  (lte l r)
    =|  irefs=(set iref:c)
    =/  =(list [@da val=(set mome:c)])
      :: (dec l) to be left inclusive
      (tap:son:so (lot:son:so span-order.calendar `r `(dec l)))
    |-
    ?~  list
      irefs
    %=  $
      list   t.list
      irefs  (~(uni in irefs) `(set iref:c)`(~(run in val.i.list) tail))
    ==
  ::
  ++  ful
    |=  [l=@da r=@da]
    ^-  (list iref:c)
    ?>  (lte l r)
    %-  zing  %+  turn
      :: (dec l) to be left inclusive
      (tap:fon:fo (lot:fon:fo fuld-order.calendar `r `(dec l)))
    |=([key=@da val=(set iref:c)] ~(tap in val))
  ::
  ++  del
    |=  =iref:c
    ^-  _this
    ~&  %deleting
    %=  this
      span-order.calendar  (~(del so span-order.calendar) iref)
      fuld-order.calendar  (~(del fo fuld-order.calendar) iref)
    ==
  ::
  ++  pur
    |=  [=eid:c idx-list=(list @ud)]
    ^-  _this
    ?~  idx-list
      this
    $(idx-list t.idx-list, this (del eid i.idx-list))
  ::
  ++  rip
    |=  [=iref:c =instance:c]
    ^-  _this
    ?-    -.instance
      %skip  ~&(%skipping (del iref))
        ::
        %fuld
      ?:  ?=(%| -.p.instance)
        this :: ignore exceptions
      :: replace this instance in span-order
      ::
      %=    this
        span-order.calendar  (~(del so span-order.calendar) iref)
          fuld-order.calendar
        (~(rep fo fuld-order.calendar) iref p.p.instance)
      ==
      ::
        %span
      ?:  ?=(%| -.p.instance)
        this :: ignore exceptions
      :: replace this instance in span-order
      ::
      %=    this
        fuld-order.calendar  (~(del fo fuld-order.calendar) iref)
          span-order.calendar
        (~(rep so span-order.calendar) iref p.p.instance)
      ==
    ==
  ::
  ++  rep
    |=  =iref:c
    ^-  _this
    =/  =event:c     (~(got by events.calendar) eid.iref)
    =/  =instance:c  (~(got by instances.event) i.iref)
    (rip iref instance)
  ::
  ++  rap
    |=  [=eid:c instances=(list (pair @ud instance:c))]
    ^-  _this
    |-
    ?~  instances
      this
    %=  $
      instances  t.instances
      this       (rip [eid p.i.instances] q.i.instances)
    ==
  :: span-order core
  ::
  ++  so
    |_  ord=((mop @da (set mome:c)) gth)
    ++  son  ((on @da (set mome:c)) gth)
    ++  get-time
      |=  =mome:c
      ^-  (unit @da)
      =/  ven=event:c     (~(got by events.calendar) eid.iref.mome)
      ?~  i=(~(get by instances.ven) i.iref.mome)  ~
      ?.  ?=(%span -.u.i)  ~
      ?+    -.p.u.i  ~
          %&
        ?-  -.mome
          %l  (some l.p.p.u.i)
          %r  (some r.p.p.u.i)
        ==
      ==
    ::
    ++  del-mome
      |=  =mome:c
      ^+  ord
      =/  time=(unit @da)  (get-time mome)
      ?~  time  ord
      ~|  time+time
      =/  mom=(set mome:c)  (fall (get:son ord u.time) ~)
      =.  mom               (~(del in mom) mome)
      ?:  =(~ mom)
        +:(del:son ord u.time)
      (put:son ord u.time mom)
    ::
    ++  del
      |=  =iref:c
      ^+  ord
      =.  ord  (del-mome %l iref)
      (del-mome %r iref)
    ::
    ++  put-mome
      |=  [=mome:c =time]
      ^+  ord
      =/  mom=(set mome:c)
        ?^  umom=(get:son ord time)
          (~(put in u.umom) mome)
        (~(put in *(set mome:c)) mome)
      (put:son ord time mom)
    ::
    ++  put
      |=  [=iref:c [l=@da r=@da]]
      ^+  ord
      =.  ord  (put-mome l+iref l)
      (put-mome r+iref r)
    :: replace
    ::
    ++  rep-mome
      |=  [=mome:c =time]
      ^+  ord
      =.  ord  (del-mome mome)
      (put-mome mome time)
    ::
    ++  rep
      |=  [=iref:c [l=@da r=@da]]
      =.  ord  (rep-mome l+iref l)
      (rep-mome r+iref r)
    :: replace many
    ::
    ++  rap-mome
      |=  =(list [mome:c time])
      ^+  ord
      ?~  list  ord
      $(list t.list, ord (rep-mome i.list))
    ::
    ++  rap
      |=  =(list [iref:c [@da @da]])
      ^+  ord
      ?~  list  ord
      $(list t.list, ord (rep i.list))
    --
  :: fuld-order core
  ::
  ++  fo
    |_  ord=((mop @da (set iref:c)) gth)
    ++  fon  ((on @da (set iref:c)) gth)
    ++  get-time
      |=  =iref:c
      ^-  (unit @da)
      =/  ven=event:c  (~(got by events.calendar) eid.iref)
      ?~  i=(~(get by instances.ven) i.iref)
        ~
      ?.  ?=(%fuld -.u.i)
        ~
      ?-  -.p.u.i
        %|  ~
        %&  [~ (fuld-to-da:tu p.p.u.i)]
      ==
    ::
    ++  del
      |=  =iref:c
      ^+  ord
      =/  time=(unit @)  (get-time iref)
      ?~  time
        ord
      =/  ref=(set iref:c)  (fall (get:fon ord u.time) ~)
      =.  ref               (~(del in ref) iref)
      ?:  =(~ ref)
        +:(del:fon ord u.time)
      (put:fon ord u.time ref)
    ::
    ++  put
      |=  [=iref:c =fuld:c]
      ^+  ord
      =/  ref=(set iref:c)
        ?^  uref=(get:fon ord (fuld-to-da:tu fuld))
          (~(put in u.uref) iref)
        (~(put in *(set iref:c)) iref)
      (put:fon ord (fuld-to-da:tu fuld) ref)
    :: replace
    ::
    ++  rep
      |=  [=iref:c =fuld:c]
      ^+  ord
      =.  ord  (del iref)
      (put iref fuld)
    :: replace many
    ::
    ++  rap
      |=  =(list [iref:c fuld:c])
      ^+  ord
      ?~  list
        ord
      $(list t.list, ord (rep i.list))
    --
  --
--
