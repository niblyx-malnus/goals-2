/-  t=timezones, c=calendar
/+  *ventio, server, htmx, nooks, fi=webui-feather-icons, html-utils,
    tu=time-utils, clib=calendar,
    webui-calendar-month-view-day-square-event,
    webui-calendar-month-view-day-square-add-event
::
|_  $:  [zid=(unit zid:t) y=@ud m=@ud =date]
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
++  event
  |=  [zid=(unit zid:t) y=@ud m=@ud =^date =cid:c =iref:c]
  %~  .
    webui-calendar-month-view-day-square-event
  :-  [zid y m date cid iref]
  :+  gowl
    %+  weld  base
    /event/(scot %p host.cid)/[name.cid]/[`@ta`eid.iref]/(scot %ud i.iref)
  [[eyre-id req] [ext site] args]
::
++  add-event
  |=  [zid=(unit zid:t) y=@ud m=@ud =^date]
  %~  .
    webui-calendar-month-view-day-square-add-event
  :-  [zid y m date]
  :+  gowl
    %+  weld  base
    /add-event
  [[eyre-id req] [ext site] args]
::
++  zones
  .^  zones:t  %gx
    (scot %p our.gowl)  %timezones  (scot %da now.gowl)
    /zones/noun
  ==
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
      [* [%add-event *] *]
    handle:(add-event zid y ^m date)
    ::
      [* [%event host=@t name=@t eid=@t i=@t *] *]
    =/  =cid:c   [(slav %p host.cad.parms) name.cad.parms]
    =/  =iref:c  [eid.cad.parms (slav %ud i.cad.parms)] 
    handle:(event zid y ^m date cid iref)
  ==
::
++  components
  |%
  ++  jumps
    ^-  manx
    =/  l=@da  (need (get-tz-to-utc (year date) zid))
    =/  r=@da  (add l ~d1)
    =/  jumps=(list [@da iref:t])  (get-zone-jumps zid l r)
    ~&  jumps+jumps
    ;div;
  ::
  ++  events
    ^-  manx
    =/  l=@da  (need (get-tz-to-utc (year date) zid))
    =/  r=@da  (add l ~d1)
    =/  irefs=(set iref:c)  (spa:~(or clib gowl calendar) l r)
    =.  irefs  (~(uni in irefs) (sy (ful:~(or clib gowl calendar) (year date) (add (year date) ~d1))))
    ;div
      ;*  %+  turn  ~(tap in irefs)
          |=  =iref:c
          (event:components:(event zid y m date cid iref) &)
    ==
  ::
  ++  day-square
    ^-  manx
    ;div.flex.flex-col
      =style  "border-left: 1px solid #e5e7eb; border-bottom: 1px solid #efe7eb;"
      ;div.flex.justify-center.items-center.text-center
        ;+  ;div.p-2.flex.items-center.justify-center
              ;*  ?.  =(1 d.t.date)
                    ;
                  ;+  ;span
                        =class  "text-[12px] mr-1 {?:(=(m m.date) "text-gray-800" "text-gray-500")}"
                        ; {(snag (sub m.date 1) month-abbrv)}
                      ==
              ;+  ?.  =([m y d.t]:date [m y d.t]:(yore now))
                    ;div.bg-white.flex.items-center.justify-center.rounded-full
                      =style  "width: 24px; height: 24px;"
                      ;span
                        =class  "text-[12px] {?:(=(m m.date) "text-gray-800" "text-gray-500")}"
                        ; {(scow %ud d.t.date)}
                      ==
                    ==
                  ;div.bg-blue-500.flex.items-center.justify-center.rounded-full
                    =style  "width: 24px; height: 24px;"
                    ;span(class "text-[12px] text-white"): {(scow %ud d.t.date)}
                  ==
            ==
      ==
      ;div.flex-grow.relative
        ;div.flex.flex-col.absolute.inset-0.overflow-y-auto
          ;div
            =style       "width: calc(100% - 12px);"
            ;+  (add-event:components:(add-event zid y m date) &)
            ;+  events
          ==
          ;div.flex-grow
            =hx-post     "{(spud base)}/add-event/unhide"
            =hx-target   "#{(en-html-id:htmx (weld base /add-event))}"
            =hx-trigger  "click"
            =hx-swap     "outerHTML"
            ;
          ==
        ==
      ==
    ==
  --
--
