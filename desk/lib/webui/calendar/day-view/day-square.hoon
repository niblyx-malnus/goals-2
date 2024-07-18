/-  t=timezones, c=calendar
/+  *ventio, server, htmx, nooks, fi=webui-feather-icons, html-utils,
    tu=time-utils, clib=calendar,
    webui-calendar-day-view-day-square-event,
    webui-calendar-day-view-day-square-add-event
::
|_  $:  [zid=(unit zid:t) y=@ud m=@ud d=@ud]
        =gowl 
        base=(pole @t)
        [eyre-id=@ta req=inbound-request:eyre]
        request-line:server :: pre-parsed
    ==
+*  nuk  ~(. nooks gowl)
    mx   mx:html-utils
    kv   kv:html-utils
    now           (need (get-now-tz zid))
    cid           [our.gowl %our]
    calendar      (get-calendar cid) :: just %our calendar for now
::
++  zones
  .^  zones:t  %gx
    (scot %p our.gowl)  %timezones  (scot %da now.gowl)
    /zones/noun
  ==
::
++  event
  |=  [zid=(unit zid:t) y=@ud m=@ud d=@ud =cid:c =iref:c]
  %~  .
    webui-calendar-day-view-day-square-event
  :-  [zid y m d cid iref]
  :+  gowl
    %+  weld  base
    /event/(scot %p host.cid)/[name.cid]/[`@ta`eid.iref]/(scot %ud i.iref)
  [[eyre-id req] [ext site] args]
::
++  add-event
  |=  [zid=(unit zid:t) y=@ud m=@ud d=@ud chunk=@ud]
  %~  .
    webui-calendar-day-view-day-square-add-event
  :-  [zid y m d chunk]
  :+  gowl
    %+  weld  base
    /add-event/(scot %ud chunk)
  [[eyre-id req] [ext site] args]
::
++  get-calendar
  |=  =cid:c
  .^  calendar:c  %gx
    (scot %p our.gowl)  %calendar  (scot %da now.gowl)
    /calendar/(scot %p host.cid)/[name.cid]/noun
  ==
::
++  get-zone-jumps
  |=  [zone=(unit zid:t) l=@da r=@da]
  ^-  (list [@da iref:t])
  ?~  zone
    ~
  .^  (list [@da iref:t])  %gx
    (scot %p our.gowl)  %timezones  (scot %da now.gowl)
    /jumps/(scot %p p.u.zone)/[q.u.zone]/(scot %da l)/(scot %da r)/noun
  ==
::
++  get-now-tz  |=(zone=(unit zid:t) (get-utc-to-tz now.gowl zone))
::
++  get-utc-to-tz
  |=  [=time zone=(unit zid:t)]
  ^-  (unit @da)
  ?~  zone
    `time
  =;  utc-to-tz
    ?~  utz=((need utc-to-tz) time)
      ~
    `d.u.utz
  .^  (unit utc-to-tz:t)  %gx
    (scot %p our.gowl)  %timezones  (scot %da now.gowl)
    /utc-to-tz/(scot %p p.u.zone)/[q.u.zone]/noun
  ==
::
++  get-tz-to-utc
  |=  [=time zone=(unit zid:t)]
  ^-  (unit @da)
  ?~  zone
    `time
  =;  tz-to-utc
    :: assume first occurence of time in timezone (0 in dext)
    ::
    ((need tz-to-utc) 0 time)
  .^  (unit tz-to-utc:t)  %gx
    (scot %p our.gowl)  %timezones  (scot %da now.gowl)
    /tz-to-utc/(scot %p p.u.zone)/[q.u.zone]/noun
  ==
::
++  get-tz-time
  |=  [=time zone=(unit zid:t)]
  ^-  (unit @da)
  ?~  zone
    `time
  =;  utc-to-tz
    ?~  utz=((need utc-to-tz) time)
      ~
    `d.u.utz
  .^  (unit utc-to-tz:t)  %gx
    (scot %p our.gowl)  %timezones  (scot %da now.gowl)
    /utc-to-tz/(scot %p p.u.zone)/[q.u.zone]/noun
  ==
::
++  month-abbrv
  ^-  (list tape)
  ~["Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"]
::
++  dedot
  |=  =tape
  ^+  tape
  ?~  tape
    ~
  ?:  ?=(%'.' i.tape)
    $(tape t.tape)
  [i.tape $(tape t.tape)]
::
++  handle
  =/  =date  [[& y] m d 0 0 0 ~]
  =/  m  (strand ,vase)
  ^-  form:m
  ::
  =+  ^=  parms
      :*  met=method.request.req
          cad=`(pole @t)`(need (decap:htmx base site))
          ext=ext
      ==
  ::
  ?+    parms
    (strand-fail %bad-http-request ~)
    ::
      [%'GET' ~ *]
    (give-html-manx:htmx [our dap]:gowl eyre-id day-square:components |)
    ::
      [* [%add-event chunk=@ta *] *]
    handle:(add-event zid y ^m d (slav %ud chunk.cad.parms))
    ::
      [* [%event host=@t name=@t eid=@t i=@t *] *]
    =/  =cid:c   [(slav %p host.cad.parms) name.cad.parms]
    =/  =iref:c  [eid.cad.parms (slav %ud i.cad.parms)] 
    handle:(event zid y ^m d cid iref)
  ==
::
++  components
  =/  =date  [[& y] m d 0 0 0 ~]
  |%
  ++  jumps
    ^-  manx
    =/  l=@da  (need (get-tz-to-utc (year date) zid))
    =/  r=@da  (add l ~d1)
    =/  jumps=(list [@da iref:t])  (get-zone-jumps zid l r)
    ~&  jumps+jumps
    ;div
      ;*  %+  turn  jumps
          |=  [=time *]
          (jump (need (get-utc-to-tz time zid)))
    ==
  ::
  ++  jump
    |=  =time
    ^-  manx
    ~&  time+time
    =/  px-sec=@ud   (div :(mul 60 60 24 ~s1) 1.200)
    ~&  px-sec+`@dr`px-sec
    ~&  blah+`@dr`(mod time ~d1)
    =/  dow=@  (mod +((get-weekday:tu time)) 7) :: sunday 0-indexed
    =/  hp=tape  "col-start-{(numb:tu +(dow))} col-end-{(numb:tu (add dow 2))}"
    =/  vp=tape
      =/  v=@ud  (div (mod time ~d1) px-sec)
      ~&  v+v
      "top-[{(numb:tu v)}px]"
    ;div(class "absolute {hp} {vp} z-50 w-full h-2 bg-blue-500");
  ::
  ++  events
    ^-  manx
    :: TODO: handle nulls
    ::
    =/  l=@da  (need (get-tz-to-utc (year date) zid))
    =/  r=@da  (add l ~d1)
    =/  irefs=(set iref:c)  (spa:~(or clib gowl calendar) l r)
    ;div
      ;*  %+  turn  ~(tap in irefs)
          |=  =iref:c
          (event:components:(event zid y m d cid iref) &)
    ==
  ::
  ++  chunks
    ^-  marl
    %+  turn  (gulf 0 47)
    |=  chunk=@ud
    ;div
      ;+  (add-event:components:(add-event zid y m d chunk) &)
      ;div
        =id          "{(en-html-id:htmx (weld base /chunk/(scot %ud chunk)))}"
        =class       "absolute w-full h-[25px] z-0"
        =style       "top: {(numb:htmx (mul chunk 25))}px;"
        =hx-post     "{(spud base)}/add-event/{(scow %ud chunk)}/unhide"
        =hx-target   "#{(en-html-id:htmx (weld base /add-event/(scot %ud chunk)))}"
        =hx-trigger  "click"
        =hx-swap     "outerHTML"
        ;
      ==
    ==
  ::
  ++  day-square
    ^-  manx
    =/  day-style=tape
      """
      background-image: linear-gradient(to bottom, #e5e7eb 1px, transparent 1px);
      background-size: 100% 50px;
      border-right: 1px solid #e5e7eb;
      border-bottom: 1px solid #e5e7eb;
      """
    ;div
      =style  day-style
      =class  "relative h-[1200px] min-w-0"
      ;*  chunks
      ;+  events
      ;+  jumps
    ==
  --
--

