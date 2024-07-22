/-  t=timezones, c=calendar
/+  *ventio, server, htmx, nooks, html-utils, tu=time-utils, clib=calendar,
    fi=webui-feather-icons,
    webui-calendar-scripts,
    webui-calendar-day-view-day-square,
    webui-calendar-day-view-fullday-square
:: specified by the date of the monday
:: (even though we display with Sunday first)
::
|_  $:  [zid=(unit zid:t) y=@ud m=@ud d=@ud]
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
  |=  when=@da
  ^-  (unit tz-rule:t)
  ?~  zid
    ~
  :-  ~
  .^  tz-rule:t  %gx
    (scot %p our.gowl)  %timezones  (scot %da now.gowl)
    /rule/(scot %p p.u.zid)/[q.u.zid]/(scot %da when)/noun
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
++  day-square
  %~  .
    webui-calendar-day-view-day-square
  :-  [zid y m d]
  :+  gowl  (weld base /day-square/(crip (en:date-input:tu y m d)))
  [[eyre-id req] [ext site] args]
::
++  fullday-square
  |=  collapse=?
  %~  .
    webui-calendar-day-view-fullday-square
  :-  [zid y m d collapse]
  :+  gowl  (weld base /fullday-square/(crip (en:date-input:tu y m d)))
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
++  up-arrow
  ^-  manx
  =-  (fall (de-xml:html -) *manx)
  '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="4"><path stroke-linecap="round" stroke-linejoin="round" d="M19 15l-7-7-7 7" /></svg>'
::
++  down-arrow
  ^-  manx
  =-  (fall (de-xml:html -) *manx)
  '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="4"><path stroke-linecap="round" stroke-linejoin="round" d="M5 9l7 7 7-7" /></svg>'
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
+$  state  ? :: collapsed fullday list
++  init   (pure:(strand ,state) &)
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
  ;<  sta=state  bind:m  ((get-or-init:nuk state) base init)
  ::
  ?+    parms
    (strand-fail %bad-http-request ~)
    ::
      [%'GET' ~ *]
    (give-html-manx:htmx [our dap]:gowl eyre-id ~(day-view components sta) |)
    ::
      [%'POST' [%collapse ~] *]
    ;<  sta=state  bind:m  ((put:nuk state) base &)
    (give-html-manx:htmx [our dap]:gowl eyre-id ~(day-view components sta) |)
    ::
      [%'POST' [%uncollapse ~] *]
    ;<  sta=state  bind:m  ((put:nuk state) base |)
    (give-html-manx:htmx [our dap]:gowl eyre-id ~(day-view components sta) |)
    ::
      [* [%day-square date=@ta *] *]
    handle:day-square
    ::
      [* [%fullday-square date=@ta *] *]
    handle:(fullday-square sta)
  ==
::
++  components
  =/  =date  [[& y] m d 0 0 0 ~]
  |_  state
  +*  state  +<
  ++  day-view
    ;div.h-screen.w-screen
      =id  (en-html-id:htmx base)
      ;+  day-panel
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
    =/  today=[y=@ud m=@ud d=@ud]  [y m d.t]:(yore now)
    =/  this-day=@da  (year [& y] m d 0 0 0 ~)
    =/  day-before=[y=@ud m=@ud d=@ud]  [y m d.t]:(yore (sub this-day ~d1))
    =/  day-after=[y=@ud m=@ud d=@ud]   [y m d.t]:(yore (add this-day ~d1))
    =/  month-title=tape  "{(snag (sub m 1) month-abbrv)} {(numb:htmx y)}"
    ::
    ;div(class "p-2 flex items-center space-x-4")
      ;select.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-800
        =name       "view"
        =hx-post    "{(spud (moup:htmx 2 base))}/set-current-view"
        =hx-target  "#{(en-html-id:htmx (moup:htmx 2 base))}"
        =hx-swap    "outerHTML"
        ;option(value "day", selected ""): Day
        ;option(value "week"): Week
        ;option(value "month"): Month
      ==
      ;button(class "text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-md border border-gray-20 p-2")
        =hx-get      "{(spud (moup:htmx 1 base))}/{(en:date-input:tu [y m d.t]:(yore now))}"
        =hx-target   "#{(en-html-id:htmx base)}"
        =hx-trigger  "click" 
        =hx-swap     "outerHTML"
        ;span.text-sm.font-semi-bold: Today
      ==
      ;div(class "flex items-center space-x-1")
        ;button
          =hx-get      "{(spud (moup:htmx 1 base))}/{(en:date-input:tu day-before)}"
          =hx-target   "#{(en-html-id:htmx base)}"
          =hx-trigger  "click"
          =hx-swap     "outerHTML"
          =alt         "Day Before"
          =title       "Day Before"
          =class       "text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-full p-2"
          ;+  (~(set-style mx left-arrow) "height: .95em; width: .95em;")
        ==
        ;button
          =hx-get      "{(spud (moup:htmx 1 base))}/{(en:date-input:tu day-after)}"
          =hx-target   "#{(en-html-id:htmx base)}"
          =hx-trigger  "click"
          =hx-swap     "outerHTML"
          =alt         "Day After"
          =title       "Day After"
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
  ++  day-panel
    ^-  manx
    =/  today=@da  (year [[& y] m d 0 0 0 ~])
    =/  this-week=[y=@ud w=@ud]  (da-to-week-number:tu today)
    =/  rul=(unit tz-rule:t)  (active-rule today)
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
            ;span.text-xs.text-gray-400: Week {(numb:htmx w.this-week)}
            ;span.text-xs.text-gray-400: {(numb:htmx y)}
          ==
        ==
        ;+  =/  weekday=tape  (snag `@`(get-weekday:tu today) weekday-headers)
            =/  is-today=?   =([m y d.t]:(yore today) [m y d.t]:(yore now))
            =/  is-before=?  (lth today now)
            ;div.flex.flex-col.items-center.justify-center
              ;span
                =class  "text-center text-{?:(is-today "blue" "gray")}-500 text-xs font-semi-bold p-1"
                ; {weekday}
              ==
              ;div
                =class  "bg-{?:(is-today "blue" "white")}-500 hover:bg-{?:(is-today "blue-700" "gray-100")} flex items-center justify-center rounded-full"
                =style  "width: 48px; height: 48px;"
                ;span(class "text-[24px] text-{?:(is-today "white" ?:(is-before "gray-500" "gray-800"))}"): {(scow %ud d.t:(yore today))}
              ==
            ==
      ==
      :: Fullday display
      ::
      ;div.grid.h-auto
        =style  "grid-template-columns: 70px repeat(1, 1fr);"
        ;div.flex.flex-col.h-full.justify-center
          =style  "border-right: 1px solid #e5e7eb; border-bottom: 1px solid $e5e7eb;"
          ;+  ?:  =(offset-name (weld "UTC" rule-name))
                ;span.text-xs.text-gray-400: {offset-name}
              ;div.flex.flex-col
                ;span.text-xs.text-gray-400: {offset-name}
                ;span.text-xs.text-gray-400: {rule-name}
              ==
          ;div.flex-grow;
          ;div.flex.justify-center
            ;+  ?.  state :: collapsed / uncollapsed
                  ;button
                    =class       "p-2 text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-full"
                    =hx-post     "{(spud base)}/collapse"
                    =hx-target   "#{(en-html-id:htmx base)}"
                    =hx-trigger  "click" 
                    =hx-swap     "outerHTML"
                    =alt         "Collapse fullday section"
                    =title       "Collapse fullday section"
                    ;+  (~(set-style mx up-arrow) "height: .95em; width: .95em;")
                  ==
                ;button
                  =class       "p-2 text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-full"
                  =hx-post     "{(spud base)}/uncollapse"
                  =hx-target   "#{(en-html-id:htmx base)}"
                  =hx-trigger  "click" 
                  =hx-swap     "outerHTML"
                  =alt         "Expand fullday section"
                  =title       "Expand fullday section"
                  ;+  (~(set-style mx down-arrow) "height: .95em; width: .95em;")
                ==
          ==
        ==
        ;+  fullday-square:components:(fullday-square state)
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
        ;+  =/  tick-style=tape
              """
              background-image: linear-gradient(to bottom, #e5e7eb 1px, transparent 1px);
              background-size: 100% 50px;
              border-right: 1px solid #e5e7eb;
              border-bottom: 1px solid #e5e7eb;
              """
            ;div
              =style  tick-style
              =class  "relative h-[1200px] w-[10px] min-w-[10px]"
              ;
            ==

        :: Day columns
        ::
        ;div.flex-auto.grid.grid-cols-1.relative
          ;+  cursor
          ;script: {(position-cursor:webui-calendar-scripts (en-html-id:htmx (weld base /cursor)) (get-offset zid) (yore today))}
          ;+  day-square:components:day-square
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
  ++  style
    ^-  tape
    %-  trip
    '''
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
        grid-template-columns: 70px repeat(1, 1fr);
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

