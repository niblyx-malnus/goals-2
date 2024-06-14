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
++  get-now-tz
  |=  zone=(unit zid:t)
  ^-  (unit @da)
  ?~  zone
    `now.gowl
  =;  utc-to-tz
    ?~  utz=((need utc-to-tz) now.gowl)
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
:: /day-square/[YYYY-MM-DD]
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
  ++  events
    ^-  manx
    =/  l=@da  (year date)
    =/  r=@da  (add l ~d1)
    =/  irefs=(set iref:c)  (spa:~(or clib gowl calendar) l r)
    ;div
      ;*  %+  turn  ~(tap in irefs)
          |=  =iref:c
          (event:components:(event zid y m date cid iref) &)
    ==
  ::
  ++  day-square
    ^-  manx
    ;div(class "flex flex-col justify-between p-2 border border-gray-100 overflow-hidden")
      ;div.flex.justify-center.items-center.text-center
        ;+  ;div.flex.items-center
              ;*  ?.  =(1 d.t.date)
                    ;
                  ;+  ;span
                        =class  "text-xs mb-2 mr-1 {?:(=(m m.date) "text-gray-700" "text-gray-400")}"
                        {(snag (sub m.date 1) month-abbrv)}
                      ==
              ;+  ?.  =([m y d.t]:date [m y d.t]:(yore now))
                      ;span
                        =class  "text-xs mb-2 {?:(=(m m.date) "text-gray-700" "text-gray-400")}"
                        {(scow %ud d.t.date)}
                      ==
                  ;div.w-6.h-6.bg-blue-500.flex.items-center.justify-center.rounded-full
                    ;span.text-xs.text-white: {(scow %ud d.t.date)}
                  ==
            ==
      ==
      ;div#contents.flex.flex-col.flex-1.relative.overflow-y-auto
        ;div
          ;+  (add-event:components:(add-event zid y m date) &)
          ;+  events
        ==
        ;div.relative.flex-1
          ;div.absolute.inset-0
            =hx-post     "{(spud base)}/add-event/unhide"
            =hx-target   "#day-square-add-event_{(numb:htmx (div (year date) ~d1))}"
            =hx-trigger  "click"
            =hx-swap     "outerHTML";
        ==
      ==
    ==
  --
--
