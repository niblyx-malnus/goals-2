/-  c=calendar, r=rules
/+  *ventio, htmx, server, nooks
|_  $:  =gowl 
        base=(pole @t)
        [eyre-id=@ta req=inbound-request:eyre]
        request-line:server :: pre-parsed
    ==
+*  nuk  ~(. nooks gowl)
::
++  rid-to-tape
  |=  =rid:r
  ^-  tape
  (spud /[?~(p.rid %$ (scot %p u.p.rid))]/[q.rid]/[r.rid])
::
++  tape-to-rid
  |=  =tape
  ^-  rid:r
  =/  =(pole knot)  (scan tape stap)
  ?>  ?=([p=@ta q=@ta r=@ta ~] pole)
  [?~(p.pole ~ `(slav %p p.pole)) ;;(rule-type:r q.pole) r.pole]
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
  $:  title=@t
      kind=@t
      $=  rids
      $:  both=rid:r
          left=rid:r
          fuld=rid:r
          jump=rid:r
      ==
  ==
::
++  init
  =/  m  (strand ,state)
  ^-  form:m
  %-  pure:m
  :*  '(New event...)'
      %left
      :*  [~ %both %single-0]
          [~ %left %single-0]
          [~ %fuld %single-0]
          [~ %jump %single-0]
      ==
  ==
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
  ;<  sta=state  bind:m   ((get-or-init:nuk state) base init)
  ::
  ?+    parms  (strand-fail %bad-http-request ~)
      [%'GET' ~ *]
    =/  new-kind=@t  (fall (get-key:kv:htmx 'kind' args) kind.sta)
    ;<  sta=state  bind:m  ((put:nuk state) base sta(kind new-kind))
    =/  =manx  ~(create-event-panel apex:components sta)
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
    ::
      [%'POST' [%rule-kind-panel ~] *]
    =/  args=key-value-list:kv:htmx  (parse-body:kv:htmx body.request.req)
    =/  new-kind=(unit @t)     (get-key:kv:htmx 'kind' args)
    =/  new-rule-id=(unit @t)  (get-key:kv:htmx 'rule-id' args)
    =/  rule-id=(unit rid:r)  (bind new-rule-id (cork trip tape-to-rid))
    =/  new-state=state  sta
    =?  kind.new-state  ?=(^ new-kind)  u.new-kind
    =?  rids.new-state  ?=(^ rule-id)
      ?+  q.u.rule-id  !!
        %both  rids.new-state(both u.rule-id)
        %left  rids.new-state(left u.rule-id)
        %fuld  rids.new-state(fuld u.rule-id)
        %jump  rids.new-state(jump u.rule-id)
      ==
    ;<  sta=state  bind:m  ((put:nuk state) base new-state)
    =/  =manx  ~(rule-kind-panel apex:components sta)
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
  ==
::
++  components
  =+  =rules:r
  |_  state
  +*  this   .
      state  +<
  ++  apex
    %=    this 
        rules
      .^  rules:r  %gx
        (scot %p our.gowl)  %rule-store  (scot %da now.gowl)
        /rules/noun
      ==
    ==
  ::
  ++  create-event-panel
    ^-  manx
    ;div.flex.flex-col.m-2
      =id  "{(en-html-id:htmx base)}"
      ;div.border-b.mb-4
        ;form.m-2.flex.flex-col.items-center
          ;div.w-full.mx-2.mb-1.flex.items-center.justify-between
            ;span.m-2.font-medium.text-sm.text-gray-700: Add Event Title:
            ;input
              =type         "text"
              =name         "event-title"
              =class        "p-2 w-60 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
              =placeholder  "Add event title";
          ==
          ;div.w-full.mx-2.mb-1.flex.items-center.justify-between
            ;span.m-2.font-medium.text-sm.text-gray-700: Select Rule Type:
            ;select.p-2.w-60.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-700
              =hx-post     "{(spud base)}/rule-kind-panel"
              =hx-trigger  "change"
              =hx-target   "#{(en-html-id:htmx base)}_rule-kind-panel"
              =hx-swap     "outerHTML"
              =name        "kind"
              ;option(value "left"): By Duration
              ;option(value "both"): By End Time
              ;option(value "fuld"): Fullday
              ;option(value "jump"): Instantaneous
            ==
          ==
          ;+  rule-kind-panel
          ;button
            =type         "submit"
            =class        "px-4 py-2 text-white bg-blue-600 rounded hover:bg-blue-700"
            Save
          ==
        ==
      ==
    ==
  ::
  ++  browser-timezone
    ^-  manx
    ;div
      ;div#browser-timezone
        Timezone Placeholder
      ==
      ;script
        ;+  ;/
        """
        const timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
        document.getElementById('browser-timezone').textContent = `Current Time Zone: $\{timeZone}`;
        """
      ==
    ==
  ::
  ++  rule-kind-panel
    ^-  manx
    =/  rule-list=(list [rid:r rule:r])
      %+  murn  ~(tap by rules)
      |=  [=rid:r =rule:r]
      ?.  =(kind q.rid)
        ~
      [~ rid rule]
    =.  rule-list
      %+  sort
        rule-list
      |=  [[* a=rule:r] [* b=rule:r]]
      (alphabetical:htmx (trip name.a) (trip name.b))
    ;div.w-full.mx-2.flex.flex-col
      =id  "{(en-html-id:htmx base)}_rule-kind-panel"
      ;+  rule-kind-parameters
      ;div.mb-1.flex.items-center.justify-between
        ;span.m-2.font-medium.text-sm.text-gray-700: Select Rule:
        ;select.w-60.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-700
          =hx-post     "{(spud base)}/rule-kind-panel"
          =hx-trigger  "change"
          =hx-target   "#{(en-html-id:htmx base)}_rule-kind-panel"
          =hx-swap     "outerHTML"
          =name   "rule-id"
          ;*  %+  turn  rule-list
              |=  [=rid:r =rule:r]
              ?.  ?|  &(?=(%both kind) =(rid both.rids))
                      &(?=(%left kind) =(rid left.rids))
                      &(?=(%fuld kind) =(rid fuld.rids))
                      &(?=(%jump kind) =(rid jump.rids))
                  ==
                ;option(value (rid-to-tape rid)): {(trip name.rule)}
              ;option(value (rid-to-tape rid), selected ""): {(trip name.rule)}
        ==
      ==
      ;+  rule-specific-parameters
    ==
  ::
  ++  rule-kind-parameters
    ^-  manx
    ?+    kind
      ;div.hidden;
      ::
        %left
      ;div.w-full.flex.flex-col
        ;div.mb-1.w-full.flex.items-center.justify-between
          ;span.m-2.font-medium.text-sm.text-gray-700: Select Timezone:
          ;select.w-60.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-700
            ;option(value "test"): UTC
          ==
        ==
        ;div.mb-1.w-full.flex.items-center.justify-between
          ;span.m-2.font-medium.text-sm.text-gray-700: Duration:
          ;div.w-60
            ;span.flex-1.flex.items-center.gap-1
              ;input
                =type         "number"
                =min          "0"
                =name         "duration-days"
                =class        "w-1/4 p-2 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                =placeholder  "DD";
              ;input
                =type         "number"
                =min          "0"
                =max          "23"
                =name         "duration-hours"
                =class        "w-1/4 p-2 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                =placeholder  "HH";
              ;input
                =type         "number"
                =min          "0"
                =max          "59"
                =name         "duration-minutes"
                =class        "w-1/4 p-2 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                =placeholder  "MM";
              ;input
                =type         "number"
                =min          "0"
                =max          "59"
                =name         "duration-seconds"
                =class        "w-1/4 p-2 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                =placeholder  "SS";
            ==
          ==
        ==
      ==
      ::
        %both
      ;div.w-full.flex.flex-col
        ;div.mb-1.w-full.flex.items-center.justify-between
          ;span.m-2.font-medium.text-sm.text-gray-700: Select Start Timezone:
          ;select.w-60.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-700
            ;option(value "test"): UTC
          ==
        ==
        ;div.mb-1.w-full.flex.items-center.justify-between
          ;span.m-2.font-medium.text-sm.text-gray-700: Select End Timezone:
          ;select.w-60.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-700
            ;option(value "test"): UTC
          ==
        ==
      ==
    ==
  ::
  ++  rule-specific-parameters
    ~&  kind+kind
    ~&  rids+rids
    =/  =rid:r   ?+(kind !! %left left.rids, %both both.rids, %fuld fuld.rids, %jump jump.rids)
    =/  =rule:r  (~(got by rules) rid)
    ^-  manx
    ;div.w-full.flex.flex-col
      ;*  %+  turn  parm.rule
          |=  [name=@t =term]
          ^-  manx
          ?+    term
            ;span.mb-1.w-full.flex.items-center.justify-between
              ;span.m-2.font-medium.text-sm.text-gray-700: {(trip name)}:
              ;span: {(trip term)}
            ==
            ::
              %ud
            ;span.mb-1.w-full.flex.items-center.justify-between
              ;span.m-2.font-medium.text-sm.text-gray-700: {(trip name)}:
              ;span.flex.w-60
                ;input
                  =name         "number"
                  =value        "0"
                  =placeholder  "0"
                  =min          "0"
                  =class        "flex-1 p-2 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                  ;
                ==
              ==
            ==
            ::
              %od
            ;span.mb-1.w-full.flex.items-center.justify-between
              ;span.m-2.font-medium.text-sm.text-gray-700: {(trip name)}:
              ;span.flex.w-60
                ;select
                  =name   "ordinal"
                  =class  "flex-1 p-2 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                  ;option(value "first"): First
                  ;option(value "second"): Second
                  ;option(value "third"): Third
                  ;option(value "fourth"): Fourth
                  ;option(value "last"): Last
                == 
              ==
            ==
            ::
              %da
            ;span.mb-1.w-full.flex.items-center.justify-between
              ;span.m-2.font-medium.text-sm.text-gray-700: {(trip name)}:
              ;span.flex.w-60
                ;input
                  =type         "date"
                  =name         "date"
                  =class        "flex-1 p-2 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                  ;
                ==
              ==
            ==
            ::
              %dr
            ;span.mb-1.w-full.flex.items-center.justify-between
              ;span.m-2.font-medium.text-sm.text-gray-700: {(trip name)}:
              ;span.flex.w-60
                ;span.flex-1.flex.items-center.gap-1
                  ;input
                    =type         "number"
                    =min          "0"
                    =name         "duration-days"
                    =class        "w-1/4 p-2 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                    =placeholder  "DD";
                  ;input
                    =type         "number"
                    =min          "0"
                    =max          "23"
                    =name         "duration-hours"
                    =class        "w-1/4 p-2 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                    =placeholder  "HH";
                  ;input
                    =type         "number"
                    =min          "0"
                    =max          "59"
                    =name         "duration-minutes"
                    =class        "w-1/4 p-2 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                    =placeholder  "MM";
                  ;input
                    =type         "number"
                    =min          "0"
                    =max          "59"
                    =name         "duration-seconds"
                    =class        "w-1/4 p-2 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                    =placeholder  "SS";
                ==
              ==
            ==
            ::
              %dl
            ;span.mb-1.w-full.flex.items-center.justify-between
              ;span.m-2.font-medium.text-sm.text-gray-700: {(trip name)}:
              ;span.flex.w-60
                ;input
                  =type         "time"
                  =name         "time"
                  =class        "flex-1 p-2 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                  ;
                ==
              ==
            ==
            ::
              %dx
            ;span.mb-1.w-full.flex.items-center.justify-between
              ;span.m-2.font-medium.text-sm.text-gray-700: {(trip name)}:
              ;span.w-60.flex.items-center.gap-1
                ;input
                  =type         "number"
                  =min          "0"
                  =name         "dext-index"
                  =class        "w-12 p-2 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                  =value        "0"
                  =placeholder  "0"
                  ;
                ==
                ;input
                  =type         "datetime-local"
                  =name         "dext-date"
                  =class        "flex-1 p-2 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                  ;
                ==
              ==
            ==
            ::
              %wl
            ;span.mb-1.w-full.flex.items-center.justify-between
              ;span.m-2.font-medium.text-sm.text-gray-700: {(trip name)}:
              ;span.flex.w-60
                ;select
                  =name   "weekdays"
                  =class  "flex-1 p-2 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                  =multiple  ""
                  ;option(value "monday"): Monday
                  ;option(value "tuesday"): Tuesday
                  ;option(value "wednesday"): Wednesday
                  ;option(value "thursday"): Thursday
                  ;option(value "friday"): Friday
                  ;option(value "saturday"): Saturday
                  ;option(value "sunday"): Sunday
                == 
              ==
            ==
          ==
    ==
  --
::
++  duration
  ^-  manx
  ;span
    ;input(type "number", min "0", name "days", placeholder "DD");
    ;input(type "number", min "0", max "23", name "hours", placeholder "HH");
    ;input(type "number", min "0", max "59", name "minutes", placeholder "MM");
    ;input(type "number", min "0", max "59", name "seconds", placeholder "SS");
  ==
--
