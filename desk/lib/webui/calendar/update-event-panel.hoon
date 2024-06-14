/-  c=calendar, r=rules, t=timezones
/+  *ventio, htmx, server, nooks, html-utils, tu=time-utils, fi=webui-feather-icons,
    inputs=webui-calendar-inputs
|_  $:  [zid=(unit zid:t) =date =cid:c =iref:c]
        =gowl 
        base=(pole @t)
        [eyre-id=@ta req=inbound-request:eyre]
        request-line:server :: pre-parsed
    ==
+*  nuk  ~(. nooks gowl)
    mx   mx:html-utils
    kv   kv:html-utils
    calendar  (get-calendar cid)
    rules  
      .^  rules:r  %gx
        (scot %p our.gowl)  %rule-store  (scot %da now.gowl)
        /rules/noun
      ==
::
++  id-num  (dedot:htmx (scow %uv (sham [date cid iref])))
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
++  fi-loader
  ^-  manx
  =/  =manx  (make:fi %loader)
  =.  manx  (pus:~(at mx manx) "height: .875em; width: .875em;")
  (pac:~(at mx manx) "animate-spin")
::
++  blue-fi-loader
  ^-  manx
  (pac:~(at mx fi-loader) "text-4xl text-blue-500")
::
++  input-style-classes
  """
  p-2 text-sm border rounded
  focus:outline-none focus:border-b-4
  focus:border-blue-600 caret-blue-600 !important
  """
::
++  duration
  |=  [name=tape default=@dr]
  =/  m=manx  (duration:inputs name | default)
  %+  ~(kit mx m)
    (tag:con:mx %input)
  (pac:tan:mx input-style-classes)
::
++  indexed-time
  |=  [name=tape default=@da]
  =/  m=manx  (indexed-time:inputs name & default)
  %+  ~(kit mx m)
    (tag:con:mx %input)
  (pac:tan:mx input-style-classes)
::
++  ordinal
  |=  name=tape
  =/  m=manx  (ordinal:inputs name &)
  (pac:~(at mx m) input-style-classes)
::
++  unsigned-decimal
  |=  name=tape
  =/  m=manx  (unsigned-decimal:inputs name &)
  (pac:~(at mx m) input-style-classes)
::
++  weekday-list
  |=  name=tape
  =/  m=manx  (weekday-list:inputs name &)
  (pac:~(at mx m) input-style-classes)
::
++  weekday
  |=  name=tape
  =/  m=manx  (weekday:inputs name &)
  (pac:~(at mx m) input-style-classes)
::
++  date-input
  |=  [name=tape default=@da]
  =/  m=manx  (date-input:inputs name & default)
  (pac:~(at mx m) input-style-classes)
::
++  time-input
  |=  [name=tape default=@dr]
  =/  m=manx  (time-input:inputs name & default)
  (pac:~(at mx m) input-style-classes)
::
++  month-input
  |=  name=tape
  =/  m=manx  (month-input:inputs name &)
  (pac:~(at mx m) input-style-classes)
::
++  week-input
  |=  name=tape
  =/  m=manx  (week-input:inputs name &)
  (pac:~(at mx m) input-style-classes)
::
++  create-event-action
  |=  l=key-value-list:kv
  ^-  calendar-action:c
  |^
  =/  =brac:kv  (de-bracket:kv l)
  ~&  brac+~(tap of brac)
  =/  title=@t  (reed:kv (~(get of brac) /metadata/title))
  =/  =dom:r    [0 (dec (rash (reed:kv (~(get of brac) /dom)) dem))]
  =/  =rid:r    (tape-to-rid (trip (reed:kv (~(get of brac) /ruledata/rid))))
  =/  =parm:r   parm:(~(got by rules) rid)
  =/  =args:r   (extract-rule-args parm (~(dip of brac) /ruledata/args)) 
  =/  =kind:r   (extract-rule-kind (~(dip of brac) /ruledata/kind))
  [%create-event dom title rid kind args]
  ::
  ++  extract-rule-args
    =|  =args:r
    |=  [=parm:r =brac:kv]
    ^-  args:r
    ?~  parm
      args
    %=    $
      parm  t.parm
        args
      %+  ~(put by args)
        p.i.parm
      ^-  arg:tu
      ?+    q.i.parm  !!
        %ud  ud+(rash (reed:kv (~(get of brac) /[p.i.parm])) dem)
        %od  od+;;(ord:tu (reed:kv (~(get of brac) /[p.i.parm])))
        %da  da+(de:date-input:tu (reed:kv (~(get of brac) /[p.i.parm])))
        %dr  dr+(extract-duration (~(dip of brac) /[p.i.parm]))
        %dl  dl+&+(de:time-input:tu (reed:kv (~(get of brac) /[p.i.parm])))
        %dx  dx+(extract-dext (~(dip of brac) /[p.i.parm]))
        %wl  wl+(extract-weekday-list (need (~(get of brac) /[p.i.parm])))
      ==
    ==
    ::
  ++  extract-duration
    |=  =brac:kv
    ^-  @dr
    =;  parts=(list @dr)
      (roll parts add)
    %+   turn  ~(tap by dir:brac)
    |=  [=@t =brac:kv]
    =/  =@dr  ?+(t !! %d ~d1, %h ~h1, %m ~m1, %s ~s1)
    (mul dr (fall (rush (reed:kv (~(get of brac) ~)) dem) 0))
  ::
  ++  extract-dext
    |=  =brac:kv
    ^-  dext:tu
    :-  (rash (reed:kv (~(get of brac) /i)) dem)
    (de:datetime-local:tu (reed:kv (~(get of brac) /d)))
  ::
  ++  extract-weekday-list
    =,  tu
    |=  l=(list @t)
    ^-  (list wkd-num)
    ?~  l
      ~
    :_  $(l t.l)
    ;;(wkd-num (wkd-to-num ;;(wkd i.l)))
  ::
  ++  extract-rule-kind
    |=  =brac:kv
    ^-  kind:r  
    =/  head=@t  (reed:kv (~(get of brac) /head))
    ;;  kind:r
    :-  head
    ?+    head  !!
      %fuld  ~
      %skip  ~
      %left  [~ (extract-duration (~(dip of brac) /d))]
      ::
        %both
      [~ ~]
    ==
  --
::
+$  state
  $~  :*  '(New event...)'
          ~
          %left
          :*  [~ %both %single-0]
              [~ %left %single-0]
              [~ %fuld %single-0]
              [~ %jump %single-0]
          ==
      ==
  $:  title=@t
      date=(unit @da)
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
  *state
::
++  send-refresh
  |=  refresh=(list hx-refresh:htmx)
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  htmx-refresh+!>(refresh)
::
++  handle
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
    =/  new-kind=@t
      (fall (get-key:kv 'ruledata[kind][head]' args) kind.sta)
    =/  new-date=(unit @da)
      (biff (get-key:kv 'date' args) (cury slaw %da))
    ;<  sta=state  bind:m
      ((put:nuk state) base sta(kind new-kind, date new-date))
    =/  =manx  ~(update-event-panel components sta)
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
    ::
      [%'POST' [%delete-event ~] *]
    =/  args=key-value-list:kv  (parse-body:kv body.request.req)
    =/  delete-option=@t  (fall (get-key:kv 'delete-option' args) 'whole-event')
    =/  =event:c  (~(got by events.calendar) eid.iref)
    =/  =calendar-action:c
      ?+    delete-option  !!
          %whole-event
        [%delete-event eid.iref]
        ::
          %this-instance
        [%update-event eid.iref %update-ruledata [i i]:iref ~ '0v0']
        ::
          %this-and-following-instances
        [%update-event eid.iref %update-domain [l.dom.event i.iref]]
      ==
    ;<  *  bind:m
      %+  (vent ,*)  [our.gowl %calendar]
      calendar-calendar-action+[[our.gowl %our] calendar-action]
    =/  =manx  ~(update-event-panel components sta)
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
  ==
::
++  components
  |_  state
  +*  this   .
      state  +<
  ::
  ++  update-event-panel
    ^-  manx
    ?.  (~(has by events.calendar) eid.iref)
      ;div.flex.flex-col.items-center.p-2
        =id  "update-event_{id-num}"
        ;+  blue-fi-loader
      ==
    ;div.flex.flex-col.m-2
      =id  "update-event_{id-num}"
      ;div.border-b.mb-4
        ;div.text-2xl.font-semibold.text-center.text-gray-700.mb-2: Delete Event
        ;form.m-2.flex.flex-col.items-center
          =hx-post     "{(spud base)}/delete-event"
          =hx-trigger  "submit"
          =hx-target   "#update-event_{id-num}"
          =hx-swap     "outerHTML"
          ;+  =/  =event:c  (~(got by events.calendar) eid.iref)
              ?:  =(1 ~(wyt by instances.event))
                ;div.flex.flex-col.mb-4
                  ;label.flex.items-center.mb-2
                    ;input.mr-2
                      =type       "radio"
                      =name       "delete-option"
                      =value      "whole-event"
                      =checked    ""
                      =autofocus  ""
                      ;
                    ==
                    ;span: Delete event
                  ==
                ==
              ?:  =(i.iref l.dom.event)
                ;div.flex.flex-col.mb-4
                  ;label.flex.items-center.mb-2
                    ;input.mr-2
                      =type       "radio"
                      =name       "delete-option"
                      =value      "this-instance"
                      =checked    ""
                      =autofocus  ""
                      ;
                    ==
                    ;span: This instance
                  ==
                  ;label.flex.items-center.mb-2
                    ;input.mr-2
                      =type   "radio"
                      =name   "delete-option"
                      =value  "whole-event"
                      ;
                    ==
                    ;span: All instances
                  ==
                ==
              ;div.flex.flex-col.mb-4
                ;label.flex.items-center.mb-2
                  ;input.mr-2
                    =type       "radio"
                    =name       "delete-option"
                    =value      "this-instance"
                    =checked    ""
                    =autofocus  ""
                    ;
                  ==
                  ;span: This instance
                ==
                ;label.flex.items-center.mb-2
                  ;input.mr-2
                    =type   "radio"
                    =name   "delete-option"
                    =value  "this-and-following-instances"
                    ;
                  ==
                  ;span: This and following instances
                ==
                ;label.flex.items-center.mb-2
                  ;input.mr-2
                    =type   "radio"
                    =name   "delete-option"
                    =value  "whole-event"
                    ;
                  ==
                  ;span: All instances
                ==
              ==
          ;button
            =type         "submit"
            =class        "px-4 py-2 text-white bg-blue-600 rounded hover:bg-blue-700"
            Delete
          ==
        ==
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
      =id  "update-event_rule-kind_{id-num}"
      ;+  rule-kind-parameters
      ;div.mb-1.flex.items-center.justify-between
        ;span.m-2.font-medium.text-sm.text-gray-700: Select Rule:
        ;select.w-60.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-700
          =hx-post     "{(spud base)}/rule-kind-panel"
          =hx-trigger  "change"
          =hx-target   "#update-event_rule-kind_{id-num}"
          =hx-swap     "outerHTML"
          =name   "ruledata[rid]"
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
    ?.  ?=(?(%left %both) kind)
      ;div.hidden;
    =/  timezones=(list [zid:t tape])
      %+  sort
        %+  turn  ~(tap by zones)
        |=([=zid:t =zone:t] [zid (trip name.zone)])
      |=  [[* a=tape] [* b=tape]]
      (alphabetical:htmx a b)
    ?-    kind
      ::
        %left
      ;div.w-full.flex.flex-col
        ;div.mb-1.w-full.flex.items-center.justify-between
          ;span.m-2.font-medium.text-sm.text-gray-700: Select Timezone:
          ;select.w-60.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-700
            ;+  ?^  zid
                  ;option(value "test"): UTC
                ;option(value "test", selected ""): UTC
            ;*  %+  turn  timezones
                |=  [=zid:t name=tape]
                ?.  =(^zid [~ zid])
                  ;option(value "test"): {name}
                ;option(value "test", selected ""): {name}
          ==
        ==
        ;div.mb-1.w-full.flex.items-center.justify-between
          ;span.m-2.font-medium.text-sm.text-gray-700: Duration:
          ;div.w-60
            ;+  (duration "ruledata[kind][d]" ~h1)
          ==
        ==
      ==
      ::
        %both
      ;div.w-full.flex.flex-col
        ;div.mb-1.w-full.flex.items-center.justify-between
          ;span.m-2.font-medium.text-sm.text-gray-700: Select Start Timezone:
          ;select.w-60.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-700
            ;+  ?^  zid
                  ;option(value "test"): UTC
                ;option(value "test", selected ""): UTC
            ;*  %+  turn  timezones
                |=  [=zid:t name=tape]
                ?.  =(^zid [~ zid])
                  ;option(value "test"): {name}
                ;option(value "test", selected ""): {name}
          ==
        ==
        ;div.mb-1.w-full.flex.items-center.justify-between
          ;span.m-2.font-medium.text-sm.text-gray-700: Select End Timezone:
          ;select.w-60.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-700
            ;option(value "test"): UTC
            ;+  ?^  zid
                  ;option(value "test"): UTC
                ;option(value "test", selected ""): UTC
            ;*  %+  turn  timezones
                |=  [=zid:t name=tape]
                ?.  =(^zid [~ zid])
                  ;option(value "test"): {name}
                ;option(value "test", selected ""): {name}
          ==
        ==
      ==
    ==
  ::
  ++  rule-specific-parameters
    =/  =rid:r   ?+(kind !! %left left.rids, %both both.rids, %fuld fuld.rids, %jump jump.rids)
    =/  =rule:r  (~(got by rules) rid)
    ^-  manx
    ;div.w-full.flex.flex-col
      ;*  %+  turn  parm.rule
          |=  [name=@t =term]
          ^-  manx
          ;span.mb-1.w-full.flex.items-center.justify-between
            ;span.m-2.font-medium.text-sm.text-gray-700: {(trip name)}:
            ;span.flex.w-60
              ;+  =/  n=tape  "ruledata[args][{(trip name)}]"
                  :: TODO: make sure now is in correct timezone
                  =/  day=@da     (mul ~d1 (div (fall date now.gowl) ~d1))
                  =/  minute=@dr  (mul ~m1 (div (mod now.gowl ~d1) ~m1))
                  ?+  term
                         ;div: {(trip term)}
                    %ud  (unsigned-decimal n)
                    %od  (ordinal n)
                    %da  (date-input n day)
                    %dr  (duration n ~d1)
                    %dl  (time-input n minute)
                    %dx  (indexed-time n (add day minute))
                    %wl  (weekday-list n)
                  ==
            ==
          ==
      ;div
        =class  "{?:(=('Single' name.rule) "hidden" "")} w-full mx-2 mb-1 flex items-center justify-between"
        ;span.m-2.font-medium.text-sm.text-gray-700: Instances:
        ;input
          =type         "number"
          =name         "dom"
          =value        "1"
          =required     ""
          =min          "1"
          =max          "{(numb:htmx max-instances:c)}"
          =class        "p-2 w-60 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
          ;
        ==
      ==
    ==
  --
--

