/-  *calendar, r=rules
/+  clib=calendar, rlib=rules, p=pytz, tu=time-utils
|%
+$  card  card:agent:gall
+$  sign  sign:agent:gall
++  agent
  =|  =rules:r
  =|  =cache:r
  =|  cards=(list card)
  |_  [=bowl:gall state-0]
  +*  this   .
      state  +<+
      rul    ~(. rlib [bowl rules cache])
  ::
  ++  abed  
    %=    this
        rules
      .^  =rules:r  %gx
        (scot %p our.bowl)  %rule-store  (scot %da now.bowl)
        /rules/noun
      ==
        cache
      .^  =cache:r  %gx
        (scot %p our.bowl)  %rule-store  (scot %da now.bowl)
        /cache/noun
      ==
    ==
  ::
  ++  abet  [(flop cards) state]
  ++  emit  |=(=card this(cards [card cards]))
  ++  emil  |=(cadz=(list card) this(cards (weld cadz cards)))
  ++  emil-cal
    |=  [cards=(list card) =cid cal=calendar]
    (emil(calendars (~(put by calendars) cid cal)) cards)
  ::
  ++  en-path     |=(=cid `path`/calendar/[(scot %p host.cid)]/[name.cid])
  ::
  ++  handle-transition
    |=  tan=transition
    ^-  _this
    ?-    -.tan
        %create-calendar
      ?>  =(our.bowl host.cid.tan)
      ?<  (~(has by calendars) cid.tan)
      =|  =calendar
      =:  cid.calendar    cid.tan
          title.calendar  title.tan
          perms.calendar  (~(put by *perms) host.cid.tan %host)
        ==
      this(calendars (~(put by calendars) cid.tan calendar))
      ::
        %delete-calendar
      this(calendars (~(del by calendars) cid.tan))
      ::
        %update-calendar
      (handle-calendar-transition [cid p]:tan)
    ==
  ::
  ++  handle-calendar-transition
    |=  [=cid tan=calendar-transition]
    ^-  _this
    =/  =calendar  (~(gut by calendars) cid *calendar)
    =.  calendar   calendar:(~(handle-transition clib bowl calendar) tan)
    this(calendars (~(put by calendars) cid calendar))
  ::
  ++  handle-compound-transition
    |=  tan=compound-transition
    ^-  _this
    ?-    -.tan
        %update-calendar
      (handle-compound-calendar-transition [cid mod p]:tan)
    ==
  ::
  ++  handle-compound-calendar-transition
    |=  [=cid mod=ship tan=compound-calendar-transition]
    ^-  _this
    =/  =calendar  (~(gut by calendars) cid *calendar)
    =^  tans  calendar
      teba:(~(handle-compound-transition clib bowl calendar) mod tan)
    =.  calendars  (~(put by calendars) cid calendar)
    %-  emil
    %+  turn  tans
    |=  tan=calendar-transition
    [%give %fact ~[(en-path cid)] goals-calendar-transition+!>(tan)]
  ::
  ++  get-to-fuld
    |=  [=rid =kind =args]
    ^-  to-fuld:r
    ?>  ?=(%fuld q.rid)
    ?>  ?=(%fuld -.kind)
    =/  =to-to-fuld:r
      (~(got by to-to-fulds.cache) rid)
    (to-to-fuld args)
  ::
  ++  get-to-span
    |=  [=rid =kind =args]
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
      =/  =to-to-left:r  (~(got by to-to-lefts.cache) rid)
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
  :: TODO: check permissions on these things
  ::
  ++  create-calendar
    |=  [=cid title=@t description=@t]
    ^-  _this
    =.  calendars  (~(put by calendars) cid *calendar)
    =/  core  (init:(abed:ca cid) title description)
    =.  this  (emil-cal abot:(do-updates:core [%role %& host.cid %admin]~))
    :: send calendar creation update on /home
    ::
    =/  =cage  calendar-home-update+!>([%calendar %& cid])
    (emit %give %fact ~[/home] cage)
  ::
  ++  update-calendar
    |=  [=cid fields=(list calendar-field)]
    ^-  _this
    (emil-cal abot:(do-updates:(abed:ca cid) fields))
  ::
  ++  delete-calendar
    |=  =cid
    ^-  _this
    :: only you, the host, can delete your calendar pool
    ::
    ?>  =(src our):bowl
    ?>  =(src.bowl host.cid)
    :: delete calendar and send update
    ::
    =.  calendars  (~(del by calendars) cid)
    :: kick all watchers
    ::
    =.  this  (emit %give %kick ~[(en-path cid)] ~)
    :: send calendar deletion update on /home
    ::
    =/  =cage  calendar-home-update+!>([%calendar %| cid])
    (emit %give %fact ~[/home] cage)
  ::
  ++  create-event
    |=  [=cid =eid =dom =aid =rid =kind =args =mid =metadata]
    ^-  _this
    ~&  %creating-event-1
    (emil-cal abot:(create-event:(abed:ca cid) eid dom aid rid kind args mid metadata))
  ::
  ++  create-event-until
    |=  [=cid =eid start=@ud until=@da =aid =rid =kind =args =mid =metadata]
    ^-  _this
    ~&  %creating-event-until-1
    (emil-cal abot:(create-event-until:(abed:ca cid) eid start until aid rid kind args mid metadata))
  ::
  ++  create-event-rule
    |=  [=cid =eid =aid =rid =kind =args]
    ^-  _this
    (emil-cal abot:(create-event-rule:(abed:ca cid) eid aid rid kind args))
  ::
  ++  update-event-rule
    |=  [=cid =eid =aid =rid =kind =args]
    ^-  _this
    (emil-cal abot:(update-event-rule:(abed:ca cid) eid aid rid kind args))
  ::
  ++  delete-event-rule
    |=  [=cid =eid =aid]
    ^-  _this
    (emil-cal abot:(delete-event-rule:(abed:ca cid) eid aid))
  ::
  ++  create-event-metadata
    |=  [=cid =eid =mid =metadata]
    ^-  _this
    (emil-cal abot:(create-event-metadata:(abed:ca cid) eid mid metadata))
  ::
  ++  update-event
    |=  [=cid =eid fields=(list event-field)]
    ^-  _this
    (emil-cal abot:(update-event:(abed:ca cid) eid fields))
  ::
  ++  update-event-instances
    |=  [=cid =eid =dom fields=(list instance-field)]
    ^-  _this
    (emil-cal abot:(update-event-instances:(abed:ca cid) eid dom fields))
  ::
  ++  update-event-domain
    |=  [=cid =eid =dom]
    ^-  _this
    (emil-cal abot:(update-event-domain:(abed:ca cid) eid dom))
  ::
  ++  update-event-metadata
    |=  [=cid =eid =mid fields=(list meta-field)]
    ^-  _this
    (emil-cal abot:(update-event-metadata:(abed:ca cid) eid mid fields))
  ::
  ++  delete-event-metadata
    |=  [=cid =eid =mid]
    ^-  _this
    (emil-cal abot:(delete-event-metadata:(abed:ca cid) eid mid))
  ::
  ++  delete-event
    |=  [=cid =eid]
    ^-  _this
    (emil-cal abot:(delete-event:(abed:ca cid) eid))
  ::
  ++  create-date
    |=  [=cid date=[m=@ud d=@ud] =metadata]
    ^-  _this
    (emil-cal abot:(create-date:(abed:ca cid) date metadata))
  ::
  ++  delete-date
    |=  [=cid =eid]
    ^-  _this
    (emil-cal abot:(delete-date:(abed:ca cid) eid))
  ::
  ++  handle-calendar-updates
    |=  [=cid upds=(list calendar-update)]
    ^-  _this
    !!
  ::
  ++  ca
    =|  [upds=(list calendar-update) old=calendar]
    |_  [=cid cal=calendar]
    +*  this  .
        mem   `(set ship)`~
    ++  abed
      |=  =^cid
      ^-  _this
      =/  cal=calendar
        (~(got by calendars) cid)
      this(cid cid, cal cal, old cal)
    ++  abet  !!
    ++  emit  |=(upd=calendar-update this(upds [upd upds]))
    ++  emil  |=(upds=(list calendar-update) this(upds (weld upds ^upds)))
    ++  abot
      =/  new=calendar  cal:(do-updates:this(cal old) (flop upds))
      ?:  =(cal new)
        abet
      ~|("non-equivalent-updates" !!)
    ::
    ++  init
      |=  [title=@t description=@t]
      ^-  _this
      =.  cal        *calendar :: initialize with bunt
      =.  this       (do-update %title title)
      (do-update %description description)
    ::
    ++  spans-in-subdomain
      |=  [l=@da r=@da]
      ^-  range
      ?>  (lte l r)
      %-  ~(gas by *range)
      %+  turn
        ^-  (list iref)
        %-  zing  %+  turn
          (tap:son:so (lot:son:so span-order.cal `+(r) `(dec l)))
        |=  [key=@da val=(set mome)]
        (turn ~(tap in val) tail)
      |=  =iref
      =/  ven=event  (~(got by events.cal) eid.iref)
      [iref (~(get-full-row vn eid.iref ven) i.iref)]
    ::
    ++  fulds-in-subdomain
      |=  [l=@da r=@da]
      ^-  range
      ?>  (lte l r)
      %-  ~(gas by *range)
      %+  turn
        ^-  (list iref)
        %-  zing  %+  turn
          (tap:fon:fo (lot:fon:fo fuld-order.cal `+(r) `(dec l)))
        |=([key=@da val=(set iref)] ~(tap in val))
      |=  =iref
      =/  ven=event  (~(got by events.cal) eid.iref)
      [iref (~(get-full-row vn eid.iref ven) i.iref)]
    ::
    ++  get-range
      |=  [l=@da r=@da]
      ^-  range
      ?>  (lte l r)
      %-  ~(uni by (spans-in-subdomain l r))
      (fulds-in-subdomain l r)
    ::
    ++  get-all-rules
      ^-  (set rid)
      %-  ~(gas in *(set rid))  
      %-  zing
      %+  turn  ~(tap by events.cal)
      |=  [eid ven=event]
      %+  turn  ~(tap by ruledata.ven)
      |=([aid =rid kind args] rid)
    ::
    ++  create-event
      |=  [=eid =dom =aid =rid =kind =args =mid =metadata]
      ^-  _this
      ~&  %creating-event-2
      =|  ven=event
      =.  events.cal  (~(put by events.cal) eid ven)
      =.  this  (emit %event %c eid ven)
      (do-updates upds:abet:(init:(abed:vn eid) dom aid rid kind args mid metadata))
    ::
    ++  create-event-until
      |=  [=eid start=@ud until=@da =aid =rid =kind =args =mid =metadata]
      ^-  _this
      ~&  %creating-event-until-2
      =|  ven=event
      =.  events.cal  (~(put by events.cal) eid ven)
      =.  this  (emit %event %c eid ven)
      (do-updates upds:abet:(init-until:(abed:vn eid) start until aid rid kind args mid metadata))
    ::
    ++  update-event
      |=  [=eid fields=(list event-field)]
      ^-  _this
      (do-updates upds:abet:(update:(abed:vn eid) fields))
    ::
    ++  update-event-domain
      |=  [=eid =dom]
      ^-  _this
      (do-updates upds:abet:(update-domain:(abed:vn eid) dom))
    ::
    ++  update-event-instances
      |=  [=eid =dom fields=(list instance-field)]
      ^-  _this
      (do-updates upds:abet:(update-instances:(abed:vn eid) dom fields))
    ::
    ++  delete-event  |=(=eid (do-update %event %d eid))
    ::
    ++  create-event-rule
      |=  [=eid =aid =rid =kind =args]
      ^-  _this
      (do-updates upds:abet:(create-rule:(abed:vn eid) aid rid kind args))
    ::
    ++  update-event-rule
      |=  [=eid =aid =rid =kind =args]
      ^-  _this
      (do-updates upds:abet:(update-rule:(abed:vn eid) aid rid kind args))
    ::
    ++  delete-event-rule
      |=  [=eid =aid]
      ^-  _this
      (do-updates upds:abet:(delete-rule:(abed:vn eid) aid))
    ::
    ++  create-event-metadata
      |=  [=eid =mid =metadata]
      ^-  _this
      (do-updates upds:abet:(create-metadata:(abed:vn eid) mid metadata))
    ::
    ++  update-event-metadata
      |=  [=eid =mid fields=(list meta-field)]
      ^-  _this
      (do-updates upds:abet:(update-metadata:(abed:vn eid) mid fields))
    ::
    ++  delete-event-metadata
      |=  [=eid =mid]
      ^-  _this
      (do-updates upds:abet:(delete-metadata:(abed:vn eid) mid))
    ::
    ++  create-date
      |=  [date=[m=@ud d=@ud] =metadata]
      ^-  _this
      =/  =eid             (scot %uv (sham eny.bowl))
      =/  ven=rdate        [date metadata]
      =.  rdates.cal       (~(put by rdates.cal) eid ven)
      (do-update %rdate %c eid ven)
    ::
    ++  delete-date   |=(=eid (do-update %rdate %d eid))
    :: span-order core
    ::
    ++  so
      |_  ord=((mop @da (set mome)) gth)
      ++  son  ((on @da (set mome)) gth)
      ++  get-time
        |=  =mome
        ^-  (unit time)
        =/  ven=event     (~(got by events.cal) eid.iref.mome)
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
        |=  =mome
        ^+  ord
        =/  time=(unit time)  (get-time mome)
        ?~  time  ord
        ~|  time+time
        =/  mom=(set ^mome)   (fall (get:son ord u.time) ~)
        =.  mom               (~(del in mom) mome)
        ?:  =(~ mom)
          +:(del:son ord u.time)
        (put:son ord u.time mom)
      ::
      ++  del
        |=  =iref
        ^+  ord
        =.  ord  (del-mome %l iref)
        (del-mome %r iref)
      ::
      ++  put-mome
        |=  [=mome =time]
        ^+  ord
        =/  mom=(set ^mome)
          ?^  umom=(get:son ord time)
            (~(put in u.umom) mome)
          (~(put in *(set ^mome)) mome)
        (put:son ord time mom)
      ::
      ++  put
        |=  [=iref [l=@da r=@da]]
        ^+  ord
        =.  ord  (put-mome l+iref l)
        (put-mome r+iref r)
      :: replace
      ::
      ++  rep-mome
        |=  [=mome =time]
        ^+  ord
        =.  ord  (del-mome mome)
        (put-mome mome time)
      ::
      ++  rep
        |=  [=iref [l=@da r=@da]]
        =.  ord  (rep-mome l+iref l)
        (rep-mome r+iref r)
      :: replace many
      ::
      ++  rap-mome
        |=  =(list [mome time])
        ^+  ord
        ?~  list  ord
        $(list t.list, ord (rep-mome i.list))
      ::
      ++  rap
        |=  =(list [iref [@da @da]])
        ^+  ord
        ?~  list  ord
        $(list t.list, ord (rep i.list))
      --
    :: fuld-order core
    ::
    ++  fo
      |_  ord=((mop @da (set iref)) gth)
      ++  fon  ((on @da (set iref)) gth)
      ++  get-time
        |=  =iref
        ^-  (unit @da)
        =/  ven=event  (~(got by events.cal) eid.iref)
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
        |=  =iref
        ^+  ord
        =/  time=(unit @)  (get-time iref)
        ?~  time
          ord
        =/  ref=(set ^iref)   (fall (get:fon ord u.time) ~)
        =.  ref               (~(del in ref) iref)
        ?:  =(~ ref)
          +:(del:fon ord u.time)
        (put:fon ord u.time ref)
      ::
      ++  put
        |=  [=iref =fuld]
        ^+  ord
        =/  ref=(set ^iref)
          ?^  uref=(get:fon ord (fuld-to-da:tu fuld))
            (~(put in u.uref) iref)
          (~(put in *(set ^iref)) iref)
        (put:fon ord (fuld-to-da:tu fuld) ref)
      :: replace
      ::
      ++  rep
        |=  [=iref =fuld]
        ^+  ord
        =.  ord  (del iref)
        (put iref fuld)
      :: replace many
      ::
      ++  rap
        |=  =(list [iref fuld])
        ^+  ord
        ?~  list
          ord
        $(list t.list, ord (rep i.list))
      --
    ::
    ++  reorder
      |=  [=eid upd=event-update]
      ^-  calendar
      ?.  ?=(%instance -.upd)  cal :: ignore non-instance updates
      ?-    -.p.upd
          %|
        :: delete an instance
        ::
        %=  cal
          span-order  (~(del so span-order.cal) [eid p.p.upd])
          fuld-order  (~(del fo fuld-order.cal) [eid p.p.upd])
        ==
          %&
        ?-    -.instance.p.p.upd
              %skip
            %=  cal
              span-order  (~(del so span-order.cal) [eid idx.p.p.upd])
              fuld-order  (~(del fo fuld-order.cal) [eid idx.p.p.upd])
            ==
            ::
            %fuld
          ?.  ?=(%& -.p.instance.p.p.upd)  cal :: ignore exceptions
          :: replace this instance in span-order
          ::
          %=    cal
            span-order  (~(del so span-order.cal) [eid idx.p.p.upd])
              fuld-order
            %-  ~(rep fo fuld-order.cal)
            :-  [eid idx.p.p.upd]
            p.p.instance.p.p.upd
          ==
          ::
            %span
          ?.  ?=(%& -.p.instance.p.p.upd)  cal :: ignore exceptions
          :: replace this instance in span-order
          ::
          %=    cal
            fuld-order  (~(del fo fuld-order.cal) [eid idx.p.p.upd])
              span-order
            %-  ~(rep so span-order.cal)
            :-  [eid idx.p.p.upd]
            p.p.instance.p.p.upd
          ==
        ==
      ==
    ::
    ++  vn
      =|  upds=(list event-update)
      |_  [=eid ven=event]
      +*  this  .
      ++  abet
        :_  [eid ven]
        ^=  upds
        %+  turn  (flop upds)
        |=  upd=event-update
        [%event %u eid upd]
      ++  abed
        |=  =^eid
        %=  this
          eid  eid
          ven  (~(got by events.cal) eid)
        ==
      ++  emit  |=(upd=event-update this(upds [upd upds]))
      ++  emil  |=(upds=(list event-update) this(upds (weld upds ^upds)))
      ::
      ++  init-base
        |=  [=dom =aid =rid =kind =args =mid =metadata]
        ^-  _this
        ?>  (lte dom)
        =.  this           (do-update %dom dom)
        =.  this           (create-rule '0v0' [~ %skip ''] [%skip ~] ~)
        =.  this           (create-rule aid rid kind args)
        =.  this           (do-update %default-ruledata aid)
        =.  this           (create-metadata mid metadata)
        (do-update %default-metadata mid)
      ::
      ++  init
        |=  [=dom =aid =rid =kind =args =mid =metadata]
        ^-  _this
        ?>  (lte dom)
        =.  this           (init-base dom aid rid kind args mid metadata)
        =.  instances.ven  (dummies dom)
        (instantiate (gulf dom))
      :: will always give you the first instance
      ::
      ++  init-until
        |=  [start=@ud until=@da =aid =rid =kind =args =mid =metadata]
        ^-  _this
        =.  this  (init [start start] aid rid kind args mid metadata)
        (extend-until until)
      ::
      ++  update
        |=  fields=(list event-field)
        ^-  _this
        =/  f-map=(map term @t)  (~(gas by *(map term @t)) fields)
        =/  default-ruledata=aid  (~(gut by f-map) %default-ruledata default-ruledata.ven)
        =/  default-metadata=mid  (~(gut by f-map) %default-metadata default-metadata.ven)
        ?>  (~(has by ruledata.ven) default-ruledata)
        ?>  (~(has by metadata.ven) default-metadata)
        (do-updates fields)
      ::
      ++  dummies
        |=  =dom
        ^-  (map @ud instance)
        %-  ~(gas by *(map @ud instance))
        (turn (gulf dom) |=(idx=@ud [idx %skip ~]))
      :: if already existing
      ::
      ++  dummify
        |=  [=dom fields=(list instance-field)]
        ^-  _this
        ?>  (gte l.dom l.dom.ven)
        ?>  (lte r.dom r.dom.ven)
        =/  f-map=(map term @t)  (~(gas by *(map term @t)) fields)
        %=    this
            instances.ven
          %-  ~(uni by instances.ven)
          %-  ~(gas by *(map @ud instance))
          (turn (gulf dom) |=(idx=@ud [idx %skip ~]))
          ::
            ruledata-map.ven
          =/  =aid  (~(gut by f-map) %aid default-ruledata.ven)
          ?:  =(aid default-ruledata.ven)
            ruledata-map.ven
          %-  ~(uni by ruledata-map.ven)
          %-  ~(gas by *(map @ud ^aid))
          (turn (gulf dom) |=(idx=@ud [idx aid]))
          ::
            metadata-map.ven
          =/  =mid  (~(gut by f-map) %mid default-metadata.ven)
          ?:  =(mid default-metadata.ven)
            metadata-map.ven
          %-  ~(uni by metadata-map.ven)
          %-  ~(gas by *(map @ud ^mid))
          (turn (gulf dom) |=(idx=@ud [idx mid]))
        ==
      ::
      ++  create-rule
        |=  [=aid =rid =kind =args]
        ^-  _this
        ?<  (~(has in ~(key by ruledata.ven)) aid)
        (do-update %rule %& aid rid kind args)
      ::
      ++  update-rule
        |=  [=aid =rid =kind =args]
        ^-  _this
        ?>  (~(has in ~(key by ruledata.ven)) aid)
        =.  this  (do-update %rule %& aid rid kind args)
        :: instantiate affected instances
        ::
        =/  idx-list=(list @ud)
          %+  murn  ~(tap by ruledata-map.ven)
          |=  [idx=@ud =^aid]
          ?.(=(aid ^aid) ~ [~ idx])
        (instantiate idx-list)
      ::
      ++  delete-rule
        |=  =aid
        ^-  _this
        ?<  =(aid default-ruledata.ven)
        ?<  =(0 aid)
        ?.  .=  ~  :: can't delete rules in use
             %+  murn  ~(tap by ruledata-map.ven)
             |=  [idx=@ud =^aid]
             ?.(=(aid ^aid) ~ `idx)
          ~|  %rule-in-use  !!
        (do-update %rule %| aid)
      ::
      ++  create-metadata
        |=  [=mid =metadata]
        ^-  _this
        ?<  (~(has in ~(key by metadata.ven)) mid)
        (do-update %metadata %c mid metadata)
      ::
      ++  update-metadata
        |=  [=mid fields=(list meta-field)]
        ^-  _this
        ?>  (~(has in ~(key by metadata.ven)) mid)
        %-  do-updates
        %+  turn  fields
        |=  fid=meta-field
        [%metadata %u mid fid]
      ::
      ++  delete-metadata
        |=  =mid
        ^-  _this
        ?<  =(mid default-metadata.ven)
        (do-update %metadata %d mid)
      ::
      ++  instantiate
        |=  idx-list=(list @ud)
        ^-  _this
        ?~  idx-list  this
        =/  =aid  (~(gut by ruledata-map.ven) i.idx-list default-ruledata.ven)
        =/  [rid =kind args]  (~(got by ruledata.ven) aid)
        :: IMPORTANT: cached computation
        ::
        =/  new=instance
          ?-    -.kind
            %skip           skip+~
            %fuld           fuld+(~+((get-to-fuld (~(got by ruledata.ven) aid))) i.idx-list)
            ?(%left %both)  span+(~+((get-to-span (~(got by ruledata.ven) aid))) i.idx-list)
          ==
        $(idx-list t.idx-list)
      :: extend using default rule until date
      ::
      ++  extend-until
        |=  until=@da
        ^-  _this
        =/  maxnum=@ud  (add l.dom.ven max-instances)
        =/  idx=@ud  +(r.dom.ven) :: start immediately to the right of existing
        |-
        ?:  (gte idx maxnum)
          (do-update %dom [l.dom.ven (dec idx)])
        =/  [=rid =kind =args]  (~(got by ruledata.ven) default-ruledata.ven)
        :: IMPORTANT: cached computation
        ::
        =/  new=instance  
          ?-    -.kind
            %skip           skip+~
            %fuld           fuld+(~+((get-to-fuld rid kind args)) idx)
            ?(%left %both)  span+(~+((get-to-span rid kind args)) idx)
          ==
        :: if we pass until, stop
        ::
        ?:  ?+  -.new  |
              %span  &(?=(%& -.p.new) (gth l.p.p.new until))
              %fuld  &(?=(%& -.p.new) (gth (fuld-to-da:tu p.p.new) until))
            ==
          (do-update %dom [l.dom.ven (dec idx)])
        =.  this
          (do-update %instance %& idx default-ruledata.ven default-metadata.ven ~ new)
        $(idx +(idx))
      ::    
      ++  update-domain
        |=  =dom
        ^-  _this
        ?>  (lte dom)
        =/  stan=(map @ud instance)  (dummies dom)
        =.  instances.ven   (~(uni by stan) (~(int by stan) instances.ven))
        (instantiate (gulf dom))
      ::
      ++  update-instances
        |=  [=dom fields=(list instance-field)]
        ^-  _this
        =.  this  (dummify dom fields)
        (instantiate (gulf dom))
      ::
      ++  update-instances-new
        |=  [=dom def=? =rid =kind =args =metadata]
        ^-  _this
        =/  =aid  (scot %uv (sham eny.bowl))
        =/  =mid  (scot %uv (sham (add 1 eny.bowl)))
        =?  this  def  (do-update %default-ruledata aid)
        =?  this  def  (do-update %default-metadata mid)
        =.  this  (do-update %rule %& aid rid kind args)
        =.  this  (do-update %metadata %c mid metadata)
        (update-instances dom ~[aid+aid mid+mid]) 
      ::
      ++  get-full-row
        |=  idx=@ud
        ^-  real-instance
        =/  i=instance  (~(got by instances.ven) idx)
        =/  =aid        (~(gut by ruledata-map.ven) idx default-ruledata.ven)
        =/  =mid        (~(gut by metadata-map.ven) idx default-metadata.ven)
        :+  (~(got by ruledata.ven) aid)
            (~(got by metadata.ven) mid)
        ?+  -.i  ~|(%skipped !!)
          %span  ?>(?=(%& -.p.i) span+p.p.i)
          %fuld  ?>(?=(%& -.p.i) fuld+p.p.i)
        ==
      ::
      ++  do-update
        |=  *
        ^-  _this
        !!
      ::
      ++  do-updates
        |=  upds=(list event-update)
        ^-  _this
        |-  ?~  upds  this
        $(upds t.upds, this (do-update i.upds))
      --
    ::
    ++  do-update
      |=  *
      ^-  _this
      !!
    ::
    ++  do-updates
      |=  upds=(list calendar-update)
      ^-  _this
      |-  ?~  upds  this
      $(upds t.upds, this (do-update i.upds))
    --
  --
--
