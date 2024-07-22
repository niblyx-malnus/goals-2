/-  t=timezones
/+  *ventio, server, htmx, nooks, html-utils, tu=time-utils,
    fi=webui-feather-icons,
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
++  zones
  .^  zones:t  %gx
    (scot %p our.gowl)  %timezones  (scot %da now.gowl)
    /zones/noun
  ==
::
++  globe
  =/  =manx  (make:fi %globe)
  (pus:~(at mx manx) "height: .875em; width: .875em;")
::
++  day-square
  |=  =date
  %~  .
    webui-calendar-month-view-day-square
  :-  [zid y m date]
  :+  gowl  (weld base /day-square/(crip (en:date-input:tu [y m d.t]:date)))
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
    =/  [y=@ud m=@ud d=@ud]  (de:date-input:tu date.cad.parms)
    handle:(day-square [& y] m d 0 0 0 ~)
  ==
::
++  components
  |%
  ++  month-view
    ;div.h-screen.w-screen.overflow-scroll.scrollbar
      =id  (en-html-id:htmx base)
      ;div(class "p-4 flex flex-col h-full w-full min-w-[950px] min-h-[600px]")
        ;+  toolbar
        ;+  month-panel
      ==
    ==
  ::
  ++  timer
    |=  offset=delta:tu
    ^-  manx
    =/  id=tape  (en-html-id:htmx (weld base /timer))
    ;div
      ;span.text-gray-800.text-xl(id id);
      ;script: {(start-timer:webui-calendar-scripts id offset)}
    ==
  ::
  ++  toolbar
    ^-  manx
    =/  last-month=[y=@ud m=@ud]
      ?:(=(m 1) [(sub y 1) 12] [y (sub m 1)])
    ::
    =/  next-month=[y=@ud m=@ud]
      ?:(=(m 12) [(add y 1) 1] [y (add m 1)])
    ::
    ;div(class "p-2 flex items-center space-x-4")
      ;select.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-800
        =name     "view"
        =hx-post  "{(spud (moup:htmx 2 base))}/set-current-view"
        =hx-target  "#{(en-html-id:htmx (moup:htmx 2 base))}"
        =hx-swap    "outerHTML"
        ;option(value "day"): Day
        ;option(value "week"): Week
        ;option(value "month", selected ""): Month
      ==
      ;button(class "text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-md border border-gray-20 p-2")
        =hx-get      "{(spud (moup:htmx 1 base))}/{(en:month-input:tu [y m]:(yore now))}"
        =hx-target   "#{(en-html-id:htmx base)}"
        =hx-trigger  "click" 
        =hx-swap     "outerHTML"
        ;span.text-sm.font-semi-bold: Today
      ==
      ;div(class "flex items-center space-x-1")
        ;button
          =hx-get      "{(spud (moup:htmx 1 base))}/{(en:month-input:tu last-month)}"
          =hx-target   "#{(en-html-id:htmx base)}"
          =hx-trigger  "click"
          =hx-swap     "outerHTML"
          =alt         "Previous month"
          =title       "Previous month"
          =class       "text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-full p-2"
          ;+  (~(set-style mx left-arrow) "height: .95em; width: .95em;")
        ==
        ;button
          =hx-get      "{(spud (moup:htmx 1 base))}/{(en:month-input:tu next-month)}"
          =hx-target   "#{(en-html-id:htmx base)}"
          =hx-trigger  "click"
          =hx-swap     "outerHTML"
          =alt         "Next month"
          =title       "Next month"
          =class       "text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-full p-2"
          ;+  (~(set-style mx right-arrow) "height: .95em; width: .95em;")
        ==
      ==
      ;+  =/  timezones=(list [zid:t tape])
            %+  sort
              %+  turn  ~(tap by zones)
              |=([=zid:t =zone:t] [zid (trip name.zone)])
            |=  [[* a=tape] [* b=tape]]
            (alphabetical:htmx a b)
          ;select.w-60.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-800
            =name       "zone"
            =hx-post    "{(spud (moup:htmx 2 base))}/set-current-zone"
            =hx-target  "#{(en-html-id:htmx (moup:htmx 2 base))}"
            =hx-swap    "outerHTML"
            ;+  ?^  zid
                  ;option(value ""): UTC
                ;option(value "", selected ""): UTC
            ;*  %+  turn  timezones
                |=  [=zid:t name=tape]
                ?.  =(^zid [~ zid])
                  ;option(value "{name}"): {name}
                ;option(value "{name}", selected ""): {name}
          ==
      ;button(class "text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-md border border-gray-20 p-2")
        =id          "{(en-html-id:htmx (weld base /here))}"
        =name        "zone"
        =onclick     "this.setAttribute('value', Intl.DateTimeFormat().resolvedOptions().timeZone);"
        =title       "Set timezone according to browser."
        =hx-post     "{(spud (moup:htmx 2 base))}/set-current-zone"
        =hx-target   "#{(en-html-id:htmx (moup:htmx 2 base))}"
        =hx-trigger  "click" 
        =hx-swap     "outerHTML"
        ;+  globe
      ==
      ;span.text-gray-800.text-2xl: {(snag (sub m 1) month-fullname)} {(numb:htmx y)}
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
    ::
    =/  weeks=(list @ud)
      %+  turn  (gulf 1 (div total-cells 7))
      |=  idx=@
      w:(da-to-week-number:tu (add start-time (mul ~d1 +((mul 7 (dec idx))))))
    ::
    ;div.flex-grow.flex.flex-col
      =style  "border-right: 1px solid #e5e7eb;"
      :: Headers
      ::
      ;div
        =style  "display: grid; grid-template-columns: 20px repeat(7, 1fr);"
        ;div.empty-column.bg-gray-100;
        ;*  %+  turn  weekday-headers
            |=  weekday=tape
            ;div
               =class  "p-2 text-center text-gray-500 text-xs font-semi-bold"
               =style  "border-left: 1px solid #e5e7eb; border-top: 1px solid #efe7eb;"
              ; {weekday}
            ==
      ==
      ;div.flex.flex-grow
        ;div
          =class  "grid grid-cols-1 grid-rows-{(numb:htmx (lent weeks))} gap-0"
          =style  "width: 20px; min-width: 20px;"
          ;*  %+  turn  weeks
              |=  week=@ud
              ;div(class "bg-gray-100 pt-2 text-center text-gray-500 text-xs font-semi-bold")
                {(scow %ud week)}
              ==
        ==
        ;div(class "flex-grow grid grid-cols-7 grid-rows-{(numb:htmx (lent weeks))} gap-0")
          ;*  %+  turn  days
              |=  =date
              day-square:components:(day-square date)
        ==
      ==
    ==
  --
--
