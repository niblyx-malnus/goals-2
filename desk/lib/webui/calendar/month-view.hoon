/-  t=timezones
/+  *ventio, server, htmx, nooks, html-utils, tu=time-utils,
    webui-calendar-scripts,
    webui-calendar-month-view-day-square
|_  $:  [zid=(unit zid:t) y=@ud m=@ud]
        =gowl 
        base=(pole @t)
        [eyre-id=@ta req=inbound-request:eyre]
        request-line:server :: pre-parsed
    ==
+*  nuk  ~(. nooks gowl)
    mx   mx:html-utils
    now  (need (get-now-tz zid))
::
++  day-square
  |=  =date
  %~  .
    webui-calendar-month-view-day-square
  :-  [zid y m date]
  :+  gowl  (weld base /day-square/(crip (en:date-input:tu (year date))))
  [[eyre-id req] [ext site] args]
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
++  get-offset
  |=  zone=(unit zid:t)
  ^-  delta:tu
  ?~  zone
    [%& ~s0]
  .^  delta:tu  %gx
    (scot %p our.gowl)  %timezones  (scot %da now.gowl)
    /offset/(scot %p p.u.zone)/[q.u.zone]/noun
  ==
::
++  left-arrow
  ^-  manx
  =-  (fall (de-xml:html -) *manx)
  '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="4"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" /></svg>'
::
++  right-arrow
  ^-  manx
  =-  (fall (de-xml:html -) *manx)
  '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="4"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" /></svg>'
::
++  weekday-headers
  ^-  (list tape)
  ~["SUN" "MON" "TUE" "WED" "THU" "FRI" "SAT"]
::
++  month-abbrv
  ^-  (list tape)
  ~["Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"]
::
++  month-fullname
  ^-  (list tape)
  ~["January" "February" "March" "April" "May" "June" "July" "August" "September" "October" "November" "December"]
::
++  dedot
  |=  =tape
  ^+  tape
  ?~  tape
    ~
  ?:  ?=(%'.' i.tape)
    $(tape t.tape)
  [i.tape $(tape t.tape)]
:: /month-view/[month]/[year]
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
    (give-html-manx:htmx [our dap]:gowl eyre-id month-view:components |)
    ::
      [* [%day-square date=@ta *] *]
    handle:(day-square (yore (de:date-input:tu date.cad.parms)))
  ==
::
++  components
  |%
  ++  month-view
    ;div#month-view.flex.flex-col.h-screen.w-full.overflow-auto.p-9
      ;+  toolbar
      ;+  month-panel
    ==
  ::
  ++  timer
    |=  offset=delta:tu
    ^-  manx
    =+  (yore now)
    =/  hours=tape    (numb:htmx h.t)
    =/  minutes=tape  (numb:htmx m.t)
    =/  seconds=tape  (numb:htmx s.t)
    =/  initial-time=tape
      ;:  weld
        "{(zfill:tu 2 hours)}:"
        "{(zfill:tu 2 minutes)}:"
        "{(zfill:tu 2 seconds)}"
      ==
    ;div
      ;span#timer.text-gray-700.text-xl: {initial-time}
      ;script: {(start-timer:webui-calendar-scripts "timer" offset)}
    ==
  ::
  ++  toolbar
      ^-  manx
      =/  last-month=@da
        =/  [m=@ y=@]  ?:(=(m 1) [12 (sub y 1)] [(sub m 1) y])
        (year [& y] m 1 0 0 0 ~)
      ::
      =/  next-month=@da
        =/  [m=@ y=@]  ?:(=(m 12) [1 (add y 1)] [(add m 1) y])
        (year [& y] m 1 0 0 0 ~)
      ::
      ;div(class "flex items-center p-2 space-x-4")
        ;button(class "text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-md border border-gray-20 p-2")
          =hx-get      "{(spud (moup:htmx 1 base))}/{(en:month-input:tu (year [[& y] m 1 0 0 0 ~]:(yore now)))}"
          =hx-target   "#month-view"
          =hx-trigger  "click" 
          =hx-swap     "outerHTML"
          ;span.text-sm.font-semi-bold: Today
        ==
        ;div(class "flex items-center space-x-1")
          ;button
            =hx-get      "{(spud (moup:htmx 1 base))}/{(en:month-input:tu last-month)}"
            =hx-target   "#month-view"
            =hx-trigger  "click"
            =hx-swap     "outerHTML"
            =alt         "Previous month"
            =title       "Previous month"
            =class       "text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-full p-2"
            ;+  (~(set-style mx left-arrow) "height: .95em; width: .95em;")
          ==
          ;button
            =hx-get      "{(spud (moup:htmx 1 base))}/{(en:month-input:tu next-month)}"
            =hx-target   "#month-view"
            =hx-trigger  "click"
            =hx-swap     "outerHTML"
            =alt         "Next month"
            =title       "Next month"
            =class       "text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-full p-2"
            ;+  (~(set-style mx right-arrow) "height: .95em; width: .95em;")
          ==
        ==
        ;+  timezone-bar=*manx
        ;span.text-gray-700.text-2xl: {(snag (sub m 1) month-fullname)} {(numb:htmx y)}
        ;+  (timer (get-offset zid))
      ==
  ::
  ++  month-panel
    ^-  manx
    ?>  &((gte m 1) (lte m 12))
    =/  first-time=@da   (year [%.y y] m 1 0 0 0 ~)
    =/  first-day=@      (get-weekday:tu first-time)
    =.  first-day        (mod +(first-day) 7) :: Sunday first of week
    =/  start-time=@da   (sub first-time (mul first-day ~d1))
    =/  total-days=@     d.t:(yore (sub (year [%.y y] +(m) 1 0 0 0 ~) ~d1))
    =/  leading-cells=@  (add first-day total-days)
    =/  extra-cells=@    (mod (sub 7 (mod leading-cells 7)) 7)
    =/  total-cells=@    (add leading-cells extra-cells)
    =/  days=(list date)
      %+  turn  (gulf 1 total-cells)
      |=(idx=@ (yore (add start-time (mul (sub idx 1) ~d1))))
  
    =/  first-week=@
      (div (sub first-time (year [%.y y] 1 1 0 0 0 ~)) ~d7) :: zero-indexed
    =/  weeks=(list @ud)
      %+  turn  (gulf 1 (div total-cells 7))
      |=(idx=@ +((mod (add first-week (sub idx 1)) 52)))
    ::
    ;div.flex.items-center.h-full.bg-white.shadow-lg.rounded-lg.border.border-gray-100
      ;div#week-numbers.w-6.flex.flex-col.overflow-auto.h-full
        ;div(class "h-10 p-2 border border-gray-100"); :: space for headers
        ;div(class "flex-1 h-full grid grid-cols-1 gap-0")
          ;*  %+  turn  weeks
              |=  week=@ud
              ;div(class "bg-gray-100 pt-2 text-center text-gray-500 text-xs font-semi-bold border border-gray-200")
                {(scow %ud week)}
              ==
        ==
      ==
      ;div.flex-1.flex.flex-col.h-full
        ;div.flex-1.h-full.flex.flex-col
          :: Headers
          ::
          ;div(class "grid grid-cols-7 gap-0 h-10")
            ;*  %+  turn  weekday-headers
                |=  weekday=tape
                ;div(class "text-center text-gray-500 text-xs font-semi-bold p-2 border border-gray-100")
                  ; {weekday}
                ==
          ==
          ;div(class "grid grid-cols-7 grid-rows-{(numb:htmx (lent weeks))} gap-0 h-full")
            ;*  %+  turn  days
                |=  =date
                day-square:components:(day-square date)
          ==
        ==
      ==
    ==
  --
--
