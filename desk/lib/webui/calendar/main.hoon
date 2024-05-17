/-  p=pools, ui=goals-ui, tz=timezones
/+  *ventio, htmx, server, nooks, string, tu=time-utils, fi=webui-feather-icons,
    webui-calendar-create-event-panel
|_  $:  =gowl 
        base=(pole @t)
        [eyre-id=@ta req=inbound-request:eyre]
        request-line:server :: pre-parsed
    ==
+*  nuk  ~(. nooks gowl)
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
      [* [session-id=@ta *] *]
    =.  base  (weld base /[session-id.cad.parms])
    handle-session
    ::
      [%'GET' ~ *]
    =/  session-id=@ta  (get-unique-uv:nuk base)
    =.  site  (weld base /[session-id])
    =.  base  (weld base /[session-id])
    handle-session
  ==
::
+$  state
  $:  current-zone=(unit zid:tz)
      zone-names=(list [zid:tz @t])
      $=  views
      $:  month=[m=@ud y=@ud]
      ==
  ==
::
++  init
  =/  m  (strand ,state)
  ^-  form:m
  ;<  zone-names=(list [zid:tz @t])  bind:m
    (scry-hard ,(list [zid:tz @t]) /gx/timezones/zone-names/noun)
  %-  pure:m
  :*  ~
      zone-names
      [m y]:(yore now.gowl)
  ==
:: XX: THESE ARE BEING USED FOR ZONEID
::
++  pool-id-to-html-id
  |=  =id:p
  ^-  tape
  ;:  weld
    ?~(sco=(scow %p host.id) !! t.sco)
    "X" :: trying to stick to alphanumerics, -, and _
        :: but reserving _ for a more general delimeter
    (trip name.id)
  ==
++  html-id-to-pool-id
  |=  =tape
  ^-  id:p
  (scan tape ;~((glue (just 'X')) fed:ag (cook crip (star prn))))
::
++  get-tz-now
  |=  zone=(unit zid:tz)
  =/  m  (strand ,@da)
  ^-  form:m
  ?~  zone
    (pure:(strand ,@da) now.gowl)
  ;<  =utc-to-tz:tz  bind:(strand ,@da)
    :: use normal strandio scry here to avoid ;; clamming
    ::
    %+  scry  ,utc-to-tz:tz
    /gx/timezones/utc-to-tz/(scot %p p.u.zone)/[q.u.zone]/noun
  %-  pure:(strand ,@da)
  =/  zon=(unit dext:tz)  (utc-to-tz now.gowl)
  ?^  zon
    d.u.zon
  ~&  >  blah+=(utc-to-tz *utc-to-tz:tz)
  ~&  >>>  %failed-utc-to-tz
  ~2000.1.1
::
++  handle-session
  =/  m  (strand ,vase)
  ^-  form:m
  =+  ^=  parms
      :*  met=method.request.req
          cad=(need (decap:htmx base site))
          ext=ext
      ==
  ::
  ;<  state  bind:m   ((get-or-init:nuk state) base init)
  =*  sta  -
  ::
  ?+    parms  (strand-fail %bad-http-request ~)
      [%'GET' ~ *]
    ;<  now=@da  bind:m  (get-tz-now current-zone)
    =/  =manx  (my-calendar now current-zone zone-names)
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
    ::
      [%'GET' [%month-view ~] *]
    ;<  now=@da  bind:m  (get-tz-now current-zone)
    =/  mn=@ud
      =/  val=(unit @t)  (get-key:kv:htmx 'month' args)
      (fall (^bind val (cury slav %ud)) m.month.views) :: unit bind
    =/  yr=@ud
      =/  val=(unit @t)  (get-key:kv:htmx 'year' args)
      (fall (^bind val (cury slav %ud)) y.month.views) :: unit bind
    ;<  state  bind:m  ((put:nuk state) base sta(month.views [mn yr]))
    =/  =manx  ~(view month-view now current-zone zone-names mn yr)
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
    ::
      [%'POST' [%timezones-search-list ~] *]
    =/  args=key-value-list:kv:htmx  (parse-body:kv:htmx body.request.req)
    =/  nedl=tape  (trip (need (get-key:kv:htmx 'search' args)))
    =/  =manx  (timezones-search-list nedl zone-names)
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
    ::
      [%'GET' [%set-current-zone ~] *]
    =/  zone=@t  (need (get-key:kv:htmx 'zone' args))
    =.  current-zone
      ?:  =('' zone)
        ~
      [~ (html-id-to-pool-id (trip zone))]
    ;<  now=@da  bind:m  (get-tz-now current-zone)
    ;<  state  bind:m  ((put:nuk state) base sta) :: current-zone updated
    =/  =manx  ~(view month-view now current-zone zone-names month.views)
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
    ::
      [%'GET' [%day-square-add-event ~] *]
    ;<  now=@da  bind:m  (get-tz-now current-zone)
    =/  =date  (yore (mul ~d1 (slav %ud (need (get-key:kv:htmx 'date' args)))))
    =/  hidden=@t  (fall (get-key:kv:htmx 'hidden' args) 'false')
    ?:  ?=(%true hidden)
      =/  =manx  (~(day-square-add-event month-view now current-zone zone-names month.views) & date)
      (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
    =/  =manx  (~(day-square-add-event month-view now current-zone zone-names month.views) | date)
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
    ::
      [* [%create-event-panel *] *]
    %~  handle
      webui-calendar-create-event-panel
    :+  gowl  (weld base /create-event-panel)
    [[eyre-id req] [ext site] args]
  ==
::
++  my-calendar
  |=  [now=@da current-zone=(unit zid:tz) zone-names=(list [zid:tz @t])]
  ;html(lang "en")
    ;head
      ;title: My Calendar
      ;script(src "https://unpkg.com/htmx.org");
      ;script(src "https://cdn.tailwindcss.com");
      ;meta(charset "utf-8");
      ;meta
        =name     "viewport"
        =content  "width=device-width, initial-scale=1";
      ;link(rel "icon", href "/htmx/goals/target.svg", type "image/svg+xml");
    ==
    ;body
      ;+  ~(view month-view now current-zone zone-names [m y]:(yore now))
      ;script: {custom-htmx-triggers}
    ==
  ==
::
++  custom-htmx-triggers
  ^~  %-  trip
  '''
  let wheelThrottled = false, wheelThrottleDelay = 1400;
  window.addEventListener('wheel', function(event) {
      if  (!wheelThrottled) {
          if (event.deltaY < 0) {
              console.log('Scrolled up');
              document.querySelectorAll('[hx-trigger]').forEach(element => {
                  htmx.trigger(element, 'scrollUpTrigger');
              });
          } else if (event.deltaY > 0) {
              console.log('Scrolled down');
              document.querySelectorAll('[hx-trigger]').forEach(element => {
                  htmx.trigger(element, 'scrollDownTrigger');
              });
          }
          wheelThrottled = true;
          setTimeout(function() {
              wheelThrottled = false;
          }, wheelThrottleDelay);
      }
  });
  '''
::
++  timezone-bar
  |=  [current-zone=(unit zid:tz) zone-names=(list [zid:tz @t])]
  ^-  manx
  =/  zone-names-map=(map zid:tz @t)  (~(gas by *(map zid:tz @t)) zone-names)
  ;div#timezone-bar(class "relative w-80")
    ;input
      =type          "search"
      =class         "form-control block w-full pl-9 pr-4 py-2 text-xl text-gray-700 bg-white border border-gray-300 rounded-md focus:border-blue-500 focus:outline-none focus:ring"
      =name          "search"
      =placeholder   "{?~(current-zone "UTC" (trip (~(got by zone-names-map) u.current-zone)))}"
      =onfocus       "document.getElementById('timezones-dropdown').classList.remove('hidden')"
      =onblur        "setTimeout(() => document.getElementById('timezones-dropdown').classList.add('hidden'), 300)"
      =hx-post       "{(spud base)}/timezones-search-list"
      =hx-trigger    "keyup changed delay:300ms"
      =hx-target     "#timezones-dropdown-results"
      =hx-indicator  "#timezones-search-indicator"
      ;
    ==
    ;span#timezones-search-indicator
      =class  "htmx-indicator absolute left-2 top-1/2 transform -translate-y-1/2"
      ;+  =/  =manx  (set-attribute:mx:htmx %style "height: .7em; width: .7em;" (make:fi %loader))
          (extend-attribute:mx:htmx %class " text-4xl text-blue-500 animate-spin" manx)
    ==
    ;div#timezones-dropdown(class "absolute left-0 right-0 z-10 mt-1 overflow-auto bg-white border border-gray-300 rounded-md shadow-lg max-h-80 hidden")
      ;div.flex.flex-col.items-center.justify-center
        ;div#timezones-dropdown-results.flex-1.h-full
          ;+  (timezones-search-list "" zone-names)
        ==
      ==
    ==
  ==
:: nice little function I wrote for Holium for find/replace inspiration
::
:: ++  replace-html
::   |=  htm=@t
::   ^-  (unit octs)
::   =/  rus
::     %+  rush  htm
::     %-  star
::     ;~  pose
::       (cold (scot %p our.bowl) (jest '{og-title}'))
::       (cold 'passport bio here' (jest '{og-description}'))
::       next
::     ==
::   ?~(rus ~ (some (as-octs:mimes:html (rap 3 u.rus)))) :: `(rap 3 u.rus))
::
++  timezones-search-list
  |=  [nedl=tape zone-names=(list [zid:tz @t])]
  ^-   manx
  =/  names=(list [zid:tz tape])
    (turn zone-names |=([=zid:tz name=@t] [zid (trip name)]))
  =.  names  (sort names |=([[* a=tape] [* b=tape]] (alphabetical:htmx a b)))
  =.  names
    %+  murn  names
    |=  [=zid:tz name=tape]
    ?:(&(!=(~ nedl) ?=(~ (find nedl name))) ~ `[zid name])
  ?~  names
    ;div(class "h-full px-4 py-2 border-b border-gray-200 hover:bg-gray-100")
      No matching timezones.
    ==
  ;ul.list-none.m-0.p-0
    ;*  %+  turn  names
        |=  [=zid:tz name=tape]
        =/  zone-id=tape  (pool-id-to-html-id zid)
        ;li(class "h-full px-4 py-2 border-b border-gray-200 hover:bg-gray-100")
          ;button
            =hx-get      "{(spud base)}/set-current-zone?zone={zone-id}&month={(scow %ud 5)}&year={(scow %ud 2.024)}"
            =hx-trigger  "click"
            =hx-target   "#month-view"
            =hx-swap     "outerHTML"
            {name}
          ==
        ==
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
++  set-attribute
  |=  [=manx =mane value=tape]
  ^+  manx
  (set-attribute:mx:htmx mane value manx)
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
++  month-view
  |_  [now=@da current-zone=(unit zid:tz) zone-names=(list [zid:tz @t]) m=@ y=@]
  +*  last-month  `[m=@ y=@]`?:(=(m 1) [12 (sub y 1)] [(sub m 1) y])
      next-month  `[m=@ y=@]`?:(=(m 12) [1 (add y 1)] [(add m 1) y])
  ++  view
    ;div#month-view.flex.flex-col.h-screen.w-full.overflow-auto.p-9
      ;+  toolbar
      ;+  month-panel
    ==
  ::
  ++  timer
    |=  [now=@da offset=delta:tu]
    ^-  manx
    =+  (yore (apply-delta:tu now offset))
    =/  hours=tape    (numb:htmx h.t)
    =/  minutes=tape  (numb:htmx m.t)
    =/  seconds=tape  (numb:htmx s.t)
    =/  initial-time=tape
      ;:  weld
        "{(zfill:string hours 2)}:"
        "{(zfill:string minutes 2)}:"
        "{(zfill:string seconds 2)}"
      ==
    =/  offset-attribute=tape
      %+  weld  
        ?:(sign.offset "" "-")
      (numb:htmx (div d.offset ~s1))
    ;div
      ;span#timer.text-gray-700.text-xl
        =offset  "{offset-attribute}"
        ; {initial-time}
      ==
      ;script
        ;+  ;/
        """
        function startTimer() \{
          const timer = document.getElementById('timer');
          const offset = parseInt(timer.getAttribute('offset'), 10);
        
          // Function to update the time
          function updateTime() \{
            const now = new Date(); // Current date and time
            const utcTime = Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), 
                                    now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds(), now.getUTCMilliseconds());
            const offsetTime = new Date(utcTime + offset * 1000);

            const hours = offsetTime.getUTCHours();
            const minutes = offsetTime.getUTCMinutes();
            const seconds = offsetTime.getUTCSeconds();

            const formattedTime = [
              hours.toString().padStart(2, '0'),
              minutes.toString().padStart(2, '0'),
              seconds.toString().padStart(2, '0')
            ].join(':');
        
            timer.textContent = formattedTime;
          }
        
          setInterval(updateTime, 1000);
        }
        startTimer();
        """
      ==
    ==
  ::
  ++  toolbar
      ^-  manx
      ;div(class "flex items-center p-2 space-x-4")
        ;button(class "text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-md border border-gray-20 p-2")
          =hx-get      "{(spud base)}/month-view?month={(scow %ud m:(yore now))}&year={(scow %ud y:(yore now))}"
          =hx-target   "#month-view"
          =hx-trigger  "click" 
          =hx-swap     "outerHTML"
          ;span.text-sm.font-semi-bold: Today
        ==
        ;div(class "flex items-center space-x-1")
          ;button
            =hx-get      "{(spud base)}/month-view?month={(scow %ud m.last-month)}&year={(scow %ud y.last-month)}"
            =hx-target   "#month-view"
            =hx-trigger  "click" :: , scrollUpTrigger" 
            =hx-swap     "outerHTML"
            =alt         "Previous month"
            =title       "Previous month"
            =class       "text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-full p-2"
            ;+  (set-attribute left-arrow %style "height: .95em; width: .95em;")
          ==
          ;button
            =hx-get      "{(spud base)}/month-view?month={(scow %ud m.next-month)}&year={(scow %ud y.next-month)}"
            =hx-target   "#month-view"
            =hx-trigger  "click" :: , scrollDownTrigger" 
            =hx-swap     "outerHTML"
            =alt         "Next month"
            =title       "Next month"
            =class       "text-gray-500 bg-white hover:bg-gray-100 transition duration-150 ease-in-out rounded-full p-2"
            ;+  (set-attribute right-arrow %style "height: .95em; width: .95em;")
          ==
        ==
        ;+  (timezone-bar current-zone zone-names)
        ;span.text-gray-700.text-2xl: {(snag (sub m 1) month-fullname)} {(numb:htmx y)}
        ;+  (timer now | ~h1)
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
            ;*  (turn days day-square)
          ==
        ==
      ==
    ==
  ::
  ++  day-square
    |=  =date
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
      ;div#contents.flex-1.relative.overflow-y-auto
        ;div.absolute.inset-0
          =hx-get      "{(spud base)}/day-square-add-event?date={(scow %ud (div (year date) ~d1))}"
          =hx-target   "#day-square-add-event_{(numb:htmx (div (year date) ~d1))}"
          =hx-trigger  "click"
          =hx-swap     "outerHTML";
        ;div.flex-1
          ;+  (day-square-add-event %.y date)
          ;div
            =class  "mt-1 px-2 py-1 text-xs rounded {?:(=(m m.date) "bg-green-500 text-white" "bg-green-300 text-gray-400")}"
            Event 1
          ==
          ;div
            =class  "mt-1 px-2 py-1 text-xs rounded {?:(=(m m.date) "bg-green-500 text-white" "bg-green-300 text-gray-400")}"
            Event 2
          ==
        ==
      ==
    ==
  ::
  ++  day-square-add-event
    |=  [hidden=? =date]
    ^-  manx
    ?:  hidden
      ;div
        =id  "day-square-add-event_{(numb:htmx (div (year date) ~d1))}";
    ;div
      =class  "relative"
      =id     "day-square-add-event_{(numb:htmx (div (year date) ~d1))}"
      ;div
        =class  "shadow-lg mt-1 px-2 py-1 text-xs rounded {?:(=(m m.date) "bg-green-500 text-white shadow-gray-400" "bg-green-300 text-gray-400 shadow-gray-300")}"
        (New event...)
      ==
      ;div.fixed.inset-0.z-10.overflow-y-auto
        ;div(class "flex items-center justify-center min-h-screen px-4 pt-4 pb-20 text-center sm:block sm:p-0")
          ;div.fixed.inset-0.transition-opacity
            ;div.absolute.inset-0.bg-gray-300.opacity-50;
          ==
          ;span(class "hidden sm:inline-block sm:align-middle sm:h-screen"): ​
          ;div
            =class            "fixed top-20 left-1/2 -translate-x-1/2 inline-block overflow-hidden text-left align-bottom transition-all transform bg-white rounded-lg shadow-xl sm:my-8 sm:align-middle sm:max-w-lg sm:w-full"
            =role             "dialog"
            =aria-modal       "true"
            =aria-labelledby  "modal-headline"
            ;div.flex.flex-col
              ;div.bg-gray-100.flex-1.flex.justify-end.h-12
                ;button
                  =hx-get      "{(spud base)}/day-square-add-event?hidden=true&date={(scow %ud (div (year date) ~d1))}"
                  =hx-target   "#day-square-add-event_{(numb:htmx (div (year date) ~d1))}"
                  =class       "m-1 text-gray-500 bg-gray-100 hover:bg-gray-200 transition duration-150 ease-in-out rounded-full p-2"
                  ;+  =/  fi-x=manx  (set-attribute:mx:htmx %style "height: .875em; width: .875em;" (make:fi %x))
                      (extend-attribute:mx:htmx %class " inline text-lg" fi-x)
                ==
              ==
              ;div.m-2.flex.justify-center
                =id          "{(en-html-id:htmx base)}_create-event-panel"
                =hx-get      "{(spud base)}/create-event-panel"
                =hx-target   "this"
                =hx-trigger  "load"
                =hx-swap     "outerHTML"
                ;+  =/  =manx  (set-attribute:mx:htmx %style "height: .875em; width: .875em;" (make:fi %loader))
                    (extend-attribute:mx:htmx %class " text-4xl text-blue-500 animate-spin" manx)
              ==
            ==
          ==
        == 
      ==
    ==
  --
--
