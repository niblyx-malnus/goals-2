/-  t=timezones
/+  *ventio, server, htmx, nooks, html-utils, tu=time-utils,
    fi=webui-feather-icons,
    webui-calendar-scripts
:: specified by the date of the monday
:: (even though we display with Sunday first)
::
|_  $:  [zid=(unit zid:t) y=@ud w=@ud]
        =gowl 
        base=(pole @t)
        [eyre-id=@ta req=inbound-request:eyre]
        request-line:server :: pre-parsed
    ==
+*  nuk  ~(. nooks gowl)
    mx   mx:html-utils
    now  (need (get-now-tz zid))
::
++  active-rule
  ^-  (unit tz-rule:t)
  ?~  zid
    ~
  :-  ~
  .^  tz-rule:t  %gx
    (scot %p our.gowl)  %timezones  (scot %da now.gowl)
    /rule/(scot %p p.u.zid)/[q.u.zid]/noun
  ==
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
    (give-html-manx:htmx [our dap]:gowl eyre-id week-view:components |)
  ==
::
++  components
  |%
  ++  week-view
    ;div.h-screen.w-screen
      =id  (en-html-id:htmx base)
      ;+  week-panel
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
    =/  this-week=@da  (week-number-to-first-da:tu y w)
    =/  last-week=[y=@ud w=@ud]  (da-to-week-number:tu (sub this-week ~d7))
    =/  next-week=[y=@ud w=@ud]  (da-to-week-number:tu (add this-week ~d7))
    =/  today=[y=@ud w=@ud]  (da-to-week-number:tu now)
    =/  [y1=@ud m1=@ud]  [y m]:(yore (sub this-week ~d1)) :: sunday
    =/  [y2=@ud m2=@ud]  [y m]:(yore (add this-week ~d5)) :: saturday
    =/  month-title=tape
      ?:  =(m1 m2)
        "{(snag (sub m1 1) month-abbrv)} {(numb:htmx y1)}"
      ?.  =(y1 y2)
        "{(snag (sub m1 1) month-abbrv)}-{(snag (sub m2 1) month-abbrv)} {(numb:htmx y1)}-{(numb:htmx y2)}"
      "{(snag (sub m1 1) month-abbrv)}-{(snag (sub m2 1) month-abbrv)} {(numb:htmx y1)}"
    ::
    ;div(class "p-2 flex items-center space-x-4")
      ;select.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-800
        =name       "view"
        =hx-post    "{(spud (moup:htmx 2 base))}/set-current-view"
        =hx-target  "#{(en-html-id:htmx (moup:htmx 2 base))}"
        =hx-swap    "outerHTML"
        ;option(value "day"): Day
        ;option(value "week", selected ""): Week
        ;option(value "month"): Month
      ==
      ;button(class "text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-md border border-gray-20 p-2")
        =hx-get      "{(spud (moup:htmx 1 base))}/{(en:week-input:tu today)}"
        =hx-target   "#{(en-html-id:htmx base)}"
        =hx-trigger  "click" 
        =hx-swap     "outerHTML"
        ;span.text-sm.font-semi-bold: Today
      ==
      ;div(class "flex items-center space-x-1")
        ;button
          =hx-get      "{(spud (moup:htmx 1 base))}/{(en:week-input:tu last-week)}"
          =hx-target   "#{(en-html-id:htmx base)}"
          =hx-trigger  "click"
          =hx-swap     "outerHTML"
          =alt         "Previous month"
          =title       "Previous month"
          =class       "text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-full p-2"
          ;+  (~(set-style mx left-arrow) "height: .95em; width: .95em;")
        ==
        ;button
          =hx-get      "{(spud (moup:htmx 1 base))}/{(en:week-input:tu next-week)}"
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
      ;span.text-gray-800.text-2xl: {month-title}
      ;+  (timer (get-offset zid))
    ==
  ::
  ++  week-panel
    ^-  manx
    =/  sunday=@da  (sub (week-number-to-first-da:tu y w) ~d1)
    =/  days=(list date)
      %+  turn  (gulf 0 6)
      |=(idx=@ (yore (add sunday (mul idx ~d1))))
    =/  rul=(unit tz-rule:t)  active-rule
    =/  rule-name=tape  ?~(rul "" (trip name.u.rul))
    =/  offset-name=tape
      ?~(rul "UTC" (weld "UTC" (print-utc-offset:tu offset.u.rul)))
    ;div(class "p-4 flex flex-col h-full w-full min-w-[950px] min-h-[600px]")
      ;style: {style}
      ;+  toolbar
      :: Headers
      ::
      ;div.weekday-labels
        ;div.relative.min-w-0
          ;div.flex.flex-col
            ;span.text-xs.text-gray-400: Week {(numb:htmx w)}
            ;span.text-xs.text-gray-400: {(numb:htmx y)}
          ==
        ==
        ;*  |-
            ?~  days
              ~
            :_  $(days t.days)
            =/  weekday=tape  (snag (sub 7 (lent days)) weekday-headers)
            =/  today=?   =([m y d.t]:i.days [m y d.t]:(yore now))
            =/  before=?  (lth (year i.days) now)
            ;div.flex.flex-col.items-center.justify-center
              ;span
                =class  "text-center text-{?:(today "blue" "gray")}-500 text-xs font-semi-bold p-1"
                ; {weekday}
              ==
              ;div
                =class  "bg-{?:(today "blue" "white")}-500 hover:bg-{?:(today "blue-700" "gray-100")} flex items-center justify-center rounded-full"
                =style  "width: 48px; height: 48px;"
                ;span(class "text-[24px] text-{?:(today "white" ?:(before "gray-500" "gray-800"))}"): {(scow %ud d.t.i.days)}
              ==
            ==
      ==
      :: Fullday display
      ::
      ;div.fullday-row.h-auto
        ;div.fullday.relative.min-w-0
          ;+  ?:  =(offset-name (weld "UTC" rule-name))
                ;span.text-xs.text-gray-400: {offset-name}
              ;div.flex.flex-col
                ;span.text-xs.text-gray-400: {offset-name}
                ;span.text-xs.text-gray-400: {rule-name}
              ==
        ==
        ;div.fullday.relative.min-w-0.text-xs.text-gray-400
          ;
        ==
        ;div.fullday.relative.min-w-0.text-xs.text-gray-400
          ;div.bg-green-500.text-white.px-2.py-1.text-xs.rounded.truncate
            =style  "width: calc(100% - 8px); margin-bottom: 4px;"
            Fullday Event 1
          ==
          ;div.bg-green-500.text-white.px-2.py-1.text-xs.rounded.truncate
            =style  "width: calc(100% - 8px); margin-bottom: 4px;"
            Fullday Event 2
          ==
        ==
        ;div.fullday.relative.min-w-0.text-xs.text-gray-400
          ;
        ==
        ;div.fullday.relative.min-w-0.text-xs.text-gray-400
          ;
        ==
        ;div.fullday.relative.min-w-0.text-xs.text-gray-400
          ;
        ==
        ;div.fullday.relative.min-w-0.text-xs.text-gray-400
          ;
        ==
        ;div.fullday.relative.min-w-0.text-xs.text-gray-400
          ;
        ==
      ==
      :: Scrollable content
      ::
      ;div.flex-auto.flex.h-full.overflow-y-scroll.scrollbar
        :: Hour labels
        ::
        ;div.hour-label-column
          ;*  %+  turn  (gulf 1 23)
              |=  n=@ud
              ^-  manx
              ;div.hour-label.text-xs.text-gray-400
                =style  "top: {(numb:htmx (sub (mul 50 n) 8))}px;"
                ;*  ?:  (lth n 12)
                      ; {(scow %ud n)} AM
                    ?:  =(n 12)
                      ; {(scow %ud n)} PM
                    ; {(scow %ud (sub n 12))} PM

              ==
        ==
        :: Tick column
        ::
        ;div.tick-column;
        :: Day columns
        ::
        ;div.flex-auto.grid.grid-cols-7.relative
          ;+  cursor
          ;script: {(position-cursor:webui-calendar-scripts (en-html-id:htmx (weld base /cursor)) (get-offset zid))}
          ;div.day
            ;*  chunks
          ==
          ;div.day
            ;*  chunks
          ==
          ;div.day
            ;*  chunks
            ;div.absolute.flex.flex-col.bg-green-500.text-white.px-2.py-1.text-xs.rounded.truncate
              =style  "top: 500px; height: 50px; width: calc(100% - 8px); z-index: 1;"
              ;span: Meeting
              ;span: 10:00 AM - 11:00 AM
            ==
          ==
          ;div.day
            ;*  chunks
          ==
          ;div.day
            ;*  chunks
            ;div.absolute.flex.flex-col.bg-green-500.text-white.px-2.py-1.text-xs.rounded.truncate
              =style  "top: 600px; height: 100px; width: calc(100% - 8px); z-index: 1;"
              ;span: Lunch
              ;span: 12:00 PM - 1:00 PM
            ==
          ==
          ;div.day
            ;*  chunks
          ==
          ;div.day
            ;*  chunks
          ==
        ==
      ==
    ==
  ::
  ++  cursor
    =/  id=tape  (en-html-id:htmx (weld base /cursor))
    ;div.hidden
      =id     id
      ;div(class "w-full h-0.5 bg-[#EA4235]");
      ;div(class "absolute w-3 h-3 bg-[#EA4235] rounded-full -left-1.5 top-1/2 transform -translate-y-1/2");
    ==
  ::
  ++  chunks
    ^-  marl
    %+  turn  (gulf 0 47)
    |=  n=@
    ;div.chunk(style "top: {(numb:htmx (mul n 25))}px;");
  ::
  ++  style
    ^-  tape
    %-  trip
    '''
    .day {
        position: relative;
        height: 1200px;
        min-width: 0px;
        background-image: linear-gradient(to bottom, #e5e7eb 1px, transparent 1px);
        background-size: 100% 50px;
        border-top: 1px solid #e5e7eb;
        border-right: 1px solid #e5e7eb;
        border-bottom: 1px solid #e5e7eb;
    }
    .fullday-row {
        display: grid;
        height: auto;
        grid-template-columns: 70px repeat(7, 1fr);
    }
    .fullday {
        position: relative;
        min-width: 0px;
        border-right: 1px solid #e5e7eb;
        border-bottom: 1px solid #e5e7eb;
    }
    .chunk {
        position: absolute;
        width: 100%;
        height: 25px;
        z-index: 0;
    }
    .day-label {
        text-align: center;
        font-weight: bold;
        padding: 10px 0;
        border-bottom: 1px solid #e5e7eb;
        background-color: #f8f9fa;
    }
    .hour-label-column {
        position: relative;
        height: 1200px;
        width: 60px;
        min-width: 60px;
    }
    .tick-column {
        position: relative;
        height: 1200px;
        background-image: linear-gradient(to bottom, #e5e7eb 1px, transparent 1px);
        background-size: 100% 50px;
        border: 1px solid #e5e7eb;
        border-left: none;
        width: 10px;
        min-width: 10px;
    }
    .hour-label {
        position: absolute;
        left: 0;
        width: 100%;
        text-align: right;
        padding-right: 10px;
        box-sizing: border-box;
    }
    .weekday-labels {
        display: grid;
        grid-template-columns: 70px repeat(7, 1fr);
        border-right: 1px solid #e5e7eb;
        border-top: 1px solid #e5e7eb;
        padding: 8px 0;
    }
    .weekday-label {
        text-align: center;
        font-weight: bold;
        padding: 10px 0;
        background-color: white;
    }
    '''
  --
--

