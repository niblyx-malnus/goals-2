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
    now  (need (get-now-tz zid))
    calendar  (get-calendar cid)
    event     (~(got by events:calendar) eid.iref)
    rules  
      .^  rules:r  %gx
        (scot %p our.gowl)  %rule-store  (scot %da now.gowl)
        /rules/noun
      ==
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
  |=  [name=tape default=ord:tu]
  =/  m=manx  (ordinal:inputs name & default)
  (pac:~(at mx m) input-style-classes)
::
++  unsigned-decimal
  |=  [name=tape default=@ud]
  =/  m=manx  (unsigned-decimal:inputs name & default)
  (pac:~(at mx m) input-style-classes)
::
++  weekday-list
  |=  [name=tape default=(list wkd:tu)]
  =/  m=manx  (weekday-list:inputs name & default)
  (pac:~(at mx m) input-style-classes)
::
++  weekday-input
  |=  [name=tape default=wkd:tu]
  =/  m=manx  (weekday:inputs name & default)
  (pac:~(at mx m) input-style-classes)
::
++  datetime-local
  |=  [name=tape default=@da]
  =/  m=manx  (datetime-local:inputs name & default)
  (pac:~(at mx m) input-style-classes)
::
++  date-input
  |=  [name=tape default=[y=@ud m=@ud d=@ud]]
  =/  m=manx  (date-input:inputs name & default)
  (pac:~(at mx m) input-style-classes)
::
++  time-input
  |=  [name=tape default=@dr]
  =/  m=manx  (time-input:inputs name & default)
  (pac:~(at mx m) input-style-classes)
::
++  delta-input
  |=  [name=tape default=delta:tu]
  =/  m=manx  (delta-input:inputs name & default)
  %+  ~(wit mx m)
    |=  [* m=manx] 
    ?=(?(%input %select) n.g.m)
  (pac:tan:mx input-style-classes)
::
++  month-input
  |=  [name=tape default=[y=@ud w=@ud]]
  =/  m=manx  (month-input:inputs name & default)
  (pac:~(at mx m) input-style-classes)
::
++  week-input
  |=  [name=tape default=[y=@ud w=@ud]]
  =/  m=manx  (week-input:inputs name & default)
  (pac:~(at mx m) input-style-classes)
::
++  update-event-parms
  |=  l=key-value-list:kv
  ^-  [metadata:c ruledata:c]
  |^
  =/  =brac:kv  (de-bracket:kv l)
  ~&  brac+~(tap of brac)
  =/  title=@t  (reed:kv (~(get of brac) /metadata/title))
  =/  =rid:r    (tape-to-rid (trip (reed:kv (~(get of brac) /ruledata/rid))))
  =/  =parm:r   parm:(~(got by rules) rid)
  =/  =args:r   (extract-rule-args parm (~(dip of brac) /ruledata/args)) 
  =/  =kind:r   (extract-rule-kind (~(dip of brac) /ruledata/kind))
  :_  [rid kind args]
  (~(put by *metadata:c) %title s+title)
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
        %da  da+(de:datetime-local:tu (reed:kv (~(get of brac) /[p.i.parm])))
        %dr  dr+(extract-duration (~(dip of brac) /[p.i.parm]))
        %dl  dl+(extract-delta (~(dip of brac) /[p.i.parm]))
        %dx  dx+(extract-dext (~(dip of brac) /[p.i.parm]))
        %wd  wd+;;(wkd:tu (reed:kv (~(get of brac) /[p.i.parm])))
        %wl  wl+;;((list wkd:tu) (need (~(get of brac) /[p.i.parm])))
        %dt  dt+(de:date-input:tu (reed:kv (~(get of brac) /[p.i.parm])))
        %ct  ct+(de:time-input:tu (reed:kv (~(get of brac) /[p.i.parm])))
        %mt  mt+(de:month-input:tu (reed:kv (~(get of brac) /[p.i.parm])))
        %wk  wk+(de:week-input:tu (reed:kv (~(get of brac) /[p.i.parm])))
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
  ++  extract-delta
    |=  =brac:kv
    ^-  delta:tu
    =/  sign=?  =('+' (reed:kv (~(get of brac) /sign)))
    =/  h=@ud   (mul ~h1 (fall (rush (reed:kv (~(get of brac) /h)) dem) 0))
    =/  m=@ud   (mul ~m1 (fall (rush (reed:kv (~(get of brac) /m)) dem) 0))
    [sign (add h m)]
  ::
  ++  extract-dext
    |=  =brac:kv
    ^-  dext:tu
    :-  (rash (reed:kv (~(get of brac) /i)) dem)
    (de:datetime-local:tu (reed:kv (~(get of brac) /d)))
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
      ::
        %left
      :-  (extract-timezone (reed:kv (~(get of brac) /tz)))
      (extract-duration (~(dip of brac) /d))
      ::
        %both
      :-  (extract-timezone (reed:kv (~(get of brac) /lz)))
      (extract-timezone (reed:kv (~(get of brac) /rz)))
    ==
  ::
  ++  extract-timezone
    |=  zone=@t
    ^-  (unit zid:t)
    =/  zone-by-names=(map @t zid:t)
      %-  ~(gas by *(map @t zid:t))
      %+  turn  ~(tap by zones)
      |=  [=zid:t =zone:t]
      [name.zone zid]
    ?:  =('' zone)
      ~
    [~ (~(got by zone-by-names) zone)]
  --
::
+$  state
  $:  date=(unit @da)
      kind=@t
      $=  rids
      $:  both=[lz=(unit zid:t) rz=(unit zid:t) =rid:r]
          left=[tz=(unit zid:t) d=@dr =rid:r]
          fuld=rid:r
          jump=rid:r
      ==
  ==
::
++  default-state
  ^-  state
  =/  =aid:c  (~(gut by ruledata-map.event) i.iref default-ruledata.event)
  =/  =ruledata:c  (~(got by ruledata.event) aid)
  =/  =kind:c  kind.ruledata
  =/  =rid:r   rid.ruledata
  :*  ~
      -.kind
      :*  ?:(?=(%both -.kind) [lz.kind rz.kind rid] [zid zid [~ %both %single-0]])
          ?:(?=(%left -.kind) [tz.kind d.kind rid] [zid ~h1 [~ %left %single-0]])
          ?:(?=(%fuld -.kind) rid [~ %fuld %single-0])
          [~ %jump %single-0]
      ==
  ==
::
++  init
  =/  m  (strand ,state)
  ^-  form:m
  %-  pure:m
  default-state
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
    =/  active-tab=?(%loading %update %delete)
      ;;  ?(%loading %update %delete)
      (fall (get-key:kv 'active-tab' args) %update)
    =/  new-kind=@t
      (fall (get-key:kv 'ruledata[kind][head]' args) kind.sta)
    =/  new-date=(unit @da)
      (biff (get-key:kv 'date' args) (cury slaw %da))
    ;<  sta=state  bind:m
      ((put:nuk state) base sta(kind new-kind, date new-date))
    =/  =manx  (~(update-event-panel components sta) active-tab)
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
    ::
      [%'POST' [%rule-kind-panel ~] *]
    =/  args=key-value-list:kv  (parse-body:kv body.request.req)
    =/  new-kind=(unit @t)     (get-key:kv 'ruledata[kind][head]' args)
    =/  new-rule-id=(unit @t)  (get-key:kv 'ruledata[rid]' args)
    =/  rule-id=(unit rid:r)  (bind new-rule-id (cork trip tape-to-rid))
    =/  new-state=state  sta
    =?  kind.new-state  ?=(^ new-kind)  u.new-kind
    =?  rids.new-state  ?=(^ rule-id)
      ?+  q.u.rule-id  !!
        %both  rids.new-state(rid.both u.rule-id)
        %left  rids.new-state(rid.left u.rule-id)
        %fuld  rids.new-state(fuld u.rule-id)
        %jump  rids.new-state(jump u.rule-id)
      ==
    ;<  sta=state  bind:m  ((put:nuk state) base new-state)
    =/  =manx  ~(rule-kind-panel components sta)
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
    ::
      [%'POST' [%delete-event ~] *]
    =/  args=key-value-list:kv  (parse-body:kv body.request.req)
    =/  instance-option=@t  (fall (get-key:kv 'instance-option' args) 'whole-event')
    =/  =calendar-action:c
      ?+    instance-option  !!
          %whole-event
        [%delete-event eid.iref]
        ::
          %this-instance
        [%update-event eid.iref %update-ruledata [i i]:iref ~ skip-id:c]
        ::
          %this-and-following-instances
        [%update-event eid.iref %update-domain [l.dom.event (dec i.iref)]]
      ==
    ;<  *  bind:m
      %+  (vent ,*)  [our.gowl %calendar]
      calendar-calendar-action+[[our.gowl %our] calendar-action]
    =/  =manx  (~(update-event-panel components sta) %loading)
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
    ::
      [%'POST' [%update-event ~] *]
    =/  args=key-value-list:kv  (parse-body:kv body.request.req)
    =/  instance-option=@t  (fall (get-key:kv 'instance-option' args) 'whole-event')
    =/  [=metadata:c =ruledata:c]  (update-event-parms args)
    =/  =calendar-action:c
      ?+    instance-option  !!
          %whole-event
        [%update-event eid.iref %update-new dom.event & metadata ruledata]
        ::
          %this-instance
        [%update-event eid.iref %update-new [i i]:iref | metadata ruledata]
        ::
          %this-and-following-instances
        ?>  (lte i.iref r.dom.event)
        [%update-event eid.iref %update-new [i.iref r.dom.event] & metadata ruledata]
      ==
    ;<  *  bind:m
      %+  (vent ,*)  [our.gowl %calendar]
      calendar-calendar-action+[[our.gowl %our] calendar-action]
    =/  =manx  (~(update-event-panel components sta) %loading)
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
  ==
::
++  components
  |_  sta=state
  +*  this   .
      panel-id      (en-html-id:htmx base)
      rule-kind-id  (en-html-id:htmx (weld base /rule-kind))
  ::
  ++  default  update-event-panel:this(sta default-state)
  ::
  ++  update-event-panel
    |=  active-tab=?(%loading %update %delete)
    ^-  manx
    ?-    active-tab
        %loading
      ;div.flex.flex-col.items-center.p-2
        =id  panel-id
        ;+  blue-fi-loader
      ==
      ::
        ?(%update %delete)
      ;div.flex.flex-col.m-2
        =id  panel-id
        ;div.flex.flex-col.justify-center.border-b.mb-4
          ;div.text-2xl.font-semibold.text-center.text-gray-700.mb-2: Update Event
          ;+  =/  =mid:c  (~(gut by metadata-map.event) i.iref default-metadata.event)
              =/  =metadata:c  (~(got by metadata.event) mid)
              =/  title=tape
                (trip (so:dejs:format (~(gut by metadata) %title s+'')))
              ;div
                ;form.m-2.flex.flex-col.items-center
                  ;+  ?:  =(1 ~(wyt by instances.event))
                        ;div.flex.flex-col
                          ;label.flex.items-center.mb-2
                            ;input.mr-2
                              =type       "hidden"
                              =name       "instance-option"
                              =value      "whole-event"
                              ;
                            ==
                          ==
                        ==
                      ?:  =(i.iref l.dom.event)
                        ;div.flex.flex-col.mb-4
                          ;label.flex.items-center.mb-2
                            ;input.mr-2
                              =type       "radio"
                              =name       "instance-option"
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
                              =name   "instance-option"
                              =value  "whole-event"
                              ;
                            ==
                            ;span: All instances
                          ==
                        ==
                      ;div.flex.flex-col
                        ;label.flex.items-center.mb-2
                          ;input.mr-2
                            =type       "radio"
                            =name       "instance-option"
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
                            =name   "instance-option"
                            =value  "this-and-following-instances"
                            ;
                          ==
                          ;span: This and following instances
                        ==
                        ;label.flex.items-center.mb-2
                          ;input.mr-2
                            =type   "radio"
                            =name   "instance-option"
                            =value  "whole-event"
                            ;
                          ==
                          ;span: All instances
                        ==
                      ==
                  ;div.w-full.mx-2.mb-1.flex.items-center.justify-between
                    ;span.m-2.font-medium.text-sm.text-gray-700: Update Event Title:
                    ;input
                      =type         "text"
                      =name         "metadata[title]"
                      =pattern      ".*\\S+.*" :: double bas to escape escape
                      =class        "p-2 w-60 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
                      =placeholder  "Update event title"
                      =autofocus    ""
                      =value        title
                      ;
                    ==
                  ==
                  ;div.w-full.mx-2.mb-1.flex.items-center.justify-between
                    ;span.m-2.font-medium.text-sm.text-gray-700: Select Rule Type:
                    ;select.p-2.w-60.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-700
                      =hx-post     "{(spud base)}/rule-kind-panel"
                      =hx-trigger  "change"
                      =hx-target   "#{rule-kind-id}"
                      =hx-swap     "outerHTML"
                      =name        "ruledata[kind][head]"
                      ;+  ?.  =(%left kind.sta)
                            ;option(value "left"): By Duration
                          ;option(value "left", selected ""): By Duration
                      ;+  ?.  =(%both kind.sta)
                            ;option(value "both"): By End Time
                          ;option(value "both", selected ""): By End Time
                      ;+  ?.  =(%fuld kind.sta)
                            ;option(value "fuld"): Fullday
                          ;option(value "fuld", selected ""): Fullday
                      ;+  ?.  =(%jump kind.sta)
                            ;option(value "jump"): Instantaneous
                          ;option(value "jump", selected ""): Instantaneous
                    ==
                  ==
                  ;+  rule-kind-panel
                  ;div.flex.gap-4
                    ;button
                      =hx-post     "{(spud base)}/update-event"
                      =hx-trigger  "click"
                      =hx-target   "#{panel-id}"
                      =hx-swap     "outerHTML"
                      =class        "px-4 py-2 text-white bg-blue-500 rounded hover:bg-blue-600"
                      Save
                    ==
                    ;button
                      =hx-post     "{(spud base)}/delete-event"
                      =hx-trigger  "click"
                      =hx-target   "#{panel-id}"
                      =hx-swap     "outerHTML"
                      =class        "px-4 py-2 text-white bg-red-500 rounded hover:bg-red-600"
                      Delete
                    ==
                  ==
                ==
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
      ?.  =(kind.sta q.rid)
        ~
      [~ rid rule]
    =.  rule-list
      %+  sort
        rule-list
      |=  [[* a=rule:r] [* b=rule:r]]
      (alphabetical:htmx (trip name.a) (trip name.b))
    ;div.w-full.mb-2.mx-2.flex.flex-col
      =id  rule-kind-id
      ;+  rule-kind-parameters
      ;div.mb-1.flex.items-center.justify-between
        ;span.m-2.font-medium.text-sm.text-gray-700: Select Rule:
        ;select.w-60.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-700
          =hx-post     "{(spud base)}/rule-kind-panel"
          =hx-trigger  "change"
          =hx-target   "#{rule-kind-id}"
          =hx-swap     "outerHTML"
          =name   "ruledata[rid]"
          ;*  %+  turn  rule-list
              |=  [=rid:r =rule:r]
              ?.  ?|  &(?=(%both kind.sta) =(rid rid.both.rids.sta))
                      &(?=(%left kind.sta) =(rid rid.left.rids.sta))
                      &(?=(%fuld kind.sta) =(rid fuld.rids.sta))
                      &(?=(%jump kind.sta) =(rid jump.rids.sta))
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
    ?.  ?=(?(%left %both) kind.sta)
      ;div.hidden;
    =/  timezones=(list [zid:t tape])
      %+  sort
        %+  turn  ~(tap by zones)
        |=([=zid:t =zone:t] [zid (trip name.zone)])
      |=  [[* a=tape] [* b=tape]]
      (alphabetical:htmx a b)
    ?-    kind.sta
      ::
        %left
      ;div.w-full.flex.flex-col
        ;div.mb-1.w-full.flex.items-center.justify-between
          ;span.m-2.font-medium.text-sm.text-gray-700: Select Timezone:
          ;select.w-60.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-700
            =name  "ruledata[kind][tz]"
            ;+  ?^  tz.left.rids.sta
                  ;option(value ""): UTC
                ;option(value "", selected ""): UTC
            ;*  %+  turn  timezones
                |=  [=zid:t name=tape]
                ?.  =([~ zid] tz.left.rids.sta)
                  ;option(value "{name}"): {name}
                ;option(value "{name}", selected ""): {name}
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
            =name  "ruledata[kind][lz]"
            ;+  ?^  lz.both.rids.sta
                  ;option(value ""): UTC
                ;option(value "", selected ""): UTC
            ;*  %+  turn  timezones
                |=  [=zid:t name=tape]
                ?.  =([~ zid] lz.both.rids.sta)
                  ;option(value "{name}"): {name}
                ;option(value "{name}", selected ""): {name}
          ==
        ==
        ;div.mb-1.w-full.flex.items-center.justify-between
          ;span.m-2.font-medium.text-sm.text-gray-700: Select End Timezone:
          ;select.w-60.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-700
            =name  "ruledata[kind][rz]"
            ;+  ?^  rz.both.rids.sta
                  ;option(value ""): UTC
                ;option(value "", selected ""): UTC
            ;*  %+  turn  timezones
                |=  [=zid:t name=tape]
                ?.  =([~ zid] rz.both.rids.sta)
                  ;option(value "{name}"): {name}
                ;option(value "{name}", selected ""): {name}
          ==
        ==
      ==
    ==
  ::
  ++  rule-specific-parameters
    ^-  manx
    =/  =rid:r   ?+(kind.sta !! %left rid.left.rids.sta, %both rid.both.rids.sta, %fuld fuld.rids.sta, %jump jump.rids.sta)
    =/  =rule:r  (~(got by rules) rid)
    =/  =aid:c  (~(gut by ruledata-map.event) i.iref default-ruledata.event)
    =/  =ruledata:c  (~(got by ruledata.event) aid)
    =/  args=(unit args:c)
      ?.  ?-  -.kind.ruledata
            %both  =(rid.ruledata rid.both.rids.sta)
            %left  =(rid.ruledata rid.left.rids.sta)
            %fuld  =(rid.ruledata fuld.rids.sta)
            %skip  %.n
          ==
        ~
      `args.ruledata
    ;div.w-full.flex.flex-col
      ;*  %+  turn  parm.rule
          |=  [name=@t =term]
          ^-  manx
          ;span.mb-1.w-full.flex.items-center.justify-between
            ;span.m-2.font-medium.text-sm.text-gray-700: {(trip name)}:
            ;span.flex.w-60
              ;+  =/  n=tape  "ruledata[args][{(trip name)}]"
                  =/  day=@da         (mul ~d1 (div (fall date.sta now.gowl) ~d1))
                  =/  minute=@dr      (mul ~m30 (div (mod now ~d1) ~m30))
                  =/  weekday=wkd:tu  (num-to-wkd:tu (get-weekday:tu day))
                  ?+  term
                    ;div: {(trip term)}
                      %ud
                    ?~  args
                      (unsigned-decimal n 0)
                    %+  unsigned-decimal  n
                    +:;;($>(%ud arg:tu) (~(got by u.args) name))
                    ::
                      %od
                    ?~  args
                      (ordinal n %first)
                    %+  ordinal  n
                    +:;;($>(%od arg:tu) (~(got by u.args) name))
                    ::
                      %wd
                    ?~  args
                      (weekday-input n weekday)
                    %+  weekday-input  n
                    +:;;($>(%wd arg:tu) (~(got by u.args) name))
                    ::
                      %wl
                    ?~  args
                      (weekday-list n ~[weekday])
                    %+  weekday-list  n
                    +:;;($>(%wl arg:tu) (~(got by u.args) name))
                    ::
                      %da
                    ?~  args
                      (datetime-local n day)
                    %+  datetime-local  n
                    +:;;($>(%da arg:tu) (~(got by u.args) name))
                    ::
                      %dr
                    ?~  args
                      (duration n ~d1)
                    %+  duration  n
                    +:;;($>(%dr arg:tu) (~(got by u.args) name))
                    ::
                      %dl
                    ?~  args
                      (delta-input n *delta:tu)
                    %+  delta-input  n
                    p:;;($>(%dl arg:tu) (~(got by u.args) name))
                    ::
                      %dx
                    ?~  args
                      (indexed-time n (add day minute))
                    %+  indexed-time  n
                    d.p:;;($>(%dx arg:tu) (~(got by u.args) name))
                    ::
                      %dt
                    ?~  args
                      (date-input n [y m d.t]:(yore day))
                    %+  date-input  n
                    p:;;($>(%dt arg:tu) (~(got by u.args) name))
                    ::
                      %ct
                    ?~  args
                      (time-input n minute)
                    %+  time-input  n
                    p:;;($>(%ct arg:tu) (~(got by u.args) name))
                    ::
                      %mt
                    ?~  args
                      (month-input n [y m]:(yore day))
                    %+  month-input  n
                    p:;;($>(%mt arg:tu) (~(got by u.args) name))
                    ::
                      %wk
                    ?~  args
                      (week-input n (da-to-week-number:tu day))
                    %+  week-input  n
                    p:;;($>(%wk arg:tu) (~(got by u.args) name))
                  ==
            ==
          ==
    ==
  --
--

