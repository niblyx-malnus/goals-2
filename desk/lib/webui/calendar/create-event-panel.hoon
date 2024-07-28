/-  c=calendar, r=rules
/+  *ventio, *numb, htmx, server, nooks, pytz, iso=iso-8601,
    html-utils, tu=time-utils, fi=webui-feather-icons,
    inputs=webui-calendar-inputs
|_  $:  [zid=@t =date minute=(unit @dr) default=?(%fuld %left)]
        =gowl 
        base=(pole @t)
        [eyre-id=@ta req=inbound-request:eyre]
        request-line:server :: pre-parsed
    ==
+*  nuk  ~(. nooks gowl)
    mx   mx:html-utils
    kv   kv:html-utils
    now  (fall (bind (~(utc-to-tz zn:pytz zid) now.gowl) tail) now.gowl)
    rules  
      .^  rules:r  %gx
        (scot %p our.gowl)  %rule-store  (scot %da now.gowl)
        /rules/noun
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
  =/  m=manx  (ordinal:inputs name & %first)
  (pac:~(at mx m) input-style-classes)
::
++  unsigned-decimal
  |=  name=tape
  =/  m=manx  (unsigned-decimal:inputs name & 0)
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
++  create-event-action
  |=  l=key-value-list:kv
  ^-  calendar-action:c
  |^
  =/  =brac:kv  (de-bracket:kv l)
  =/  title=@t  (reed:kv (~(get of brac) /metadata/title))
  =?  title  =('' title)  '(No title)'
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
    ~&  brac+brac
    ~&  parm+parm
    ?~  parm
      args
    %=    $
      parm  t.parm
        args
      %+  ~(put by args)
        p.i.parm
      ^-  arg:tu
      ~&  iparm+p.i.parm
      ?+    q.i.parm  !!
        %ud  ud+(rash (reed:kv (~(get of brac) /[p.i.parm])) dem)
        %od  od+;;(ord:tu (reed:kv (~(get of brac) /[p.i.parm])))
        %da  da+(de:datetime-local:iso (reed:kv (~(get of brac) /[p.i.parm])))
        %dr  dr+(extract-duration (~(dip of brac) /[p.i.parm]))
        %dl  dl+(extract-delta (~(dip of brac) /[p.i.parm]))
        %dx  dx+(extract-dext (~(dip of brac) /[p.i.parm]))
        %wd  wd+;;(wkd:tu (reed:kv (~(get of brac) /[p.i.parm])))
        %wl  wl+;;((list wkd:tu) (need (~(get of brac) /[p.i.parm])))
        %dt  dt+(de:date-input:iso (reed:kv (~(get of brac) /[p.i.parm])))
        %ct  ct+(de:time-input:iso (reed:kv (~(get of brac) /[p.i.parm])))
        %mt  mt+(de:month-input:iso (reed:kv (~(get of brac) /[p.i.parm])))
        %wk  wk+(de:week-input:iso (reed:kv (~(get of brac) /[p.i.parm])))
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
    (de:datetime-local:iso (reed:kv (~(get of brac) /d)))
  ::
  ++  extract-weekday-list  |=(l=(list @t) ;;((list wkd:tu) l))
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
      :-  (reed:kv (~(get of brac) /tz))
      (extract-duration (~(dip of brac) /d))
      ::
        %both
      :-  (reed:kv (~(get of brac) /lz))
      (reed:kv (~(get of brac) /rz))
    ==
  --
::
+$  state
  $:  kind=@t
      $=  rids
      $:  both=[lz=@t rz=@t =rid:r]
          left=[tz=@t d=@dr =rid:r]
          fuld=rid:r
          jump=rid:r
      ==
  ==
::
++  default-state
  ^-  state
  :*  default
      :*  [zid zid [~ %both %single-0]]
          [zid ~h1 [~ %left %single-0]]
          [~ %fuld %single-0]
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
    =/  =manx  ~(create-event-panel components sta)
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
      [%'POST' [%create-event ~] *]
    =/  args=key-value-list:kv  (parse-body:kv body.request.req)
    =/  =calendar-action:c  (create-event-action args)
    ;<  *  bind:m
      %+  (vent ,*)  [our.gowl %calendar]
      calendar-calendar-action+[[our.gowl %our] calendar-action]
    =/  =manx  ~(loading components sta)
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
  ==
::
++  components
  |_  sta=state
  +*  this   .
      panel-id      (en-html-id:htmx base)
      rule-kind-id  (en-html-id:htmx (weld base /rule-kind))
  ::
  ++  default  create-event-panel:this(sta default-state)
  ::
  ++  loading
    ^-  manx
    ;div.flex.flex-col.items-center.p-2
      =id  panel-id
      ;+  blue-fi-loader
    ==
  ::
  ++  create-event-panel
    ^-  manx
    ;div.flex.flex-col.m-2
      =id  panel-id
      ;div.border-b.mb-4
        ;div.text-2xl.font-semibold.text-center.text-gray-700.mb-2: Create Event
        ;form.m-2.flex.flex-col.items-center
          =hx-post     "{(spud base)}/create-event"
          =hx-trigger  "submit"
          =hx-target   "#{panel-id}"
          =hx-swap     "outerHTML"
          ;div.w-full.mx-2.mb-1.flex.items-center.justify-between
            ;span.m-2.font-medium.text-sm.text-gray-700: Add Event Title:
            ;input
              =type         "text"
              =name         "metadata[title]"
              =pattern      ".*\\S+.*" :: double bas to escape escape
              =class        "p-2 w-60 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
              =placeholder  "Add event title"
              =autofocus    ""
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
          ;button
            =type         "submit"
            =class        "px-4 py-2 text-white bg-blue-600 rounded hover:bg-blue-700"
            Save
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
    ;div.w-full.mx-2.flex.flex-col
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
    ?-    kind.sta
      ::
        %left
      ;div.w-full.flex.flex-col
        ;div.mb-1.w-full.flex.items-center.justify-between
          ;span.m-2.font-medium.text-sm.text-gray-700: Select Timezone:
          ;select.w-60.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-700
            =name  "ruledata[kind][tz]"
            ;*  %+  turn  names.pytz
                |=  n=@t
                =/  name=tape  (trip n)
                ?.  =(n zid)
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
            ;*  %+  turn  names.pytz
                |=  n=@t
                =/  name=tape  (trip n)
                ?.  =(n zid)
                  ;option(value "{name}"): {name}
                ;option(value "{name}", selected ""): {name}
          ==
        ==
        ;div.mb-1.w-full.flex.items-center.justify-between
          ;span.m-2.font-medium.text-sm.text-gray-700: Select End Timezone:
          ;select.w-60.p-2.border.border-gray-300.rounded-md.font-medium.text-sm.text-gray-700
            =name  "ruledata[kind][rz]"
            ;*  %+  turn  names.pytz
                |=  n=@t
                =/  name=tape  (trip n)
                ?.  =(n zid)
                  ;option(value "{name}"): {name}
                ;option(value "{name}", selected ""): {name}
          ==
        ==
      ==
    ==
  ::
  ++  rule-specific-parameters
    =/  =rid:r   ?+(kind.sta !! %left rid.left.rids.sta, %both rid.both.rids.sta, %fuld fuld.rids.sta, %jump jump.rids.sta)
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
                  =/  day=@da         (mul ~d1 (div (year date) ~d1))
                  =/  min=@dr         (fall minute (mul ~m30 (div (mod now ~d1) ~m30)))
                  =/  weekday=wkd:tu  (num-to-wkd:tu (get-weekday:tu day))
                  ?+  term
                         ;div: {(trip term)}
                    %ud  (unsigned-decimal n)
                    %od  (ordinal n)
                    %da  (datetime-local n day)
                    %dr  (duration n ~d1)
                    %dl  (delta-input n *delta:tu)
                    %dx  (indexed-time n (add day min))
                    %wd  (weekday-input n weekday)
                    %wl  (weekday-list n ~[weekday])
                    %dt  (date-input n [y m d.t]:(yore day))
                    %ct  (time-input n min)
                    %mt  (month-input n [y m]:(yore day))
                    %wk  (week-input n (da-to-week-number:tu day))
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
          =max          "{(numb max-instances:c)}"
          =class        "p-2 w-60 text-sm border rounded focus:outline-none focus:border-b-4 focus:border-blue-600 caret-blue-600 !important"
          ;
        ==
      ==
    ==
  --
--
