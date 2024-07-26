/-  c=calendar
/+  *ventio, server, htmx, nooks, pytz,
    html-utils, tu=time-utils, clib=calendar,
    fi=webui-feather-icons,
    webui-calendar-week-view-fullday-square-event,
    webui-calendar-week-view-fullday-square-add-event
::
|_  $:  [zid=@t y=@ud w=@ud =date collapse=?]
        =gowl 
        base=(pole @t)
        [eyre-id=@ta req=inbound-request:eyre]
        request-line:server :: pre-parsed
    ==
+*  nuk  ~(. nooks gowl)
    mx   mx:html-utils
    kv   kv:html-utils
    ez   ~(ez zn:pytz zid)
    now  (fall (to-tz:~(ez zn:pytz zid) now.gowl) now.gowl)
    cid           [our.gowl %our]
    calendar      (get-calendar cid) :: just %our calendar for now
::
++  event
  |=  [=cid:c =iref:c]
  %~  .
    webui-calendar-week-view-fullday-square-event
  :-  [zid y w date cid iref]
  :+  gowl
    %+  weld  base
    /event/(scot %p host.cid)/[name.cid]/[`@ta`eid.iref]/(scot %ud i.iref)
  [[eyre-id req] [ext site] args]
::
++  add-event
  %~  .
    webui-calendar-week-view-fullday-square-add-event
  :-  [zid y w date]
  :+  gowl
    %+  weld  base
    /add-event
  [[eyre-id req] [ext site] args]
::
++  get-calendar
  |=  =cid:c
  .^  calendar:c  %gx
    (scot %p our.gowl)  %calendar  (scot %da now.gowl)
    /calendar/(scot %p host.cid)/[name.cid]/noun
  ==
::
++  month-abbrv
  ^-  (list tape)
  ~["Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"]
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
    (give-html-manx:htmx [our dap]:gowl eyre-id fullday-square:components |)
    ::
      [* [%add-event *] *]
    handle:add-event
    ::
      [* [%event host=@t name=@t eid=@t i=@t *] *]
    =/  =cid:c   [(slav %p host.cad.parms) name.cad.parms]
    =/  =iref:c  [eid.cad.parms (slav %ud i.cad.parms)] 
    handle:(event cid iref)
  ==
::
++  components
  |%
  ++  events
    ^-  manx
    =/  l=@da  (year date)
    =/  r=@da  (add l ~d1)
    =/  irefs=(list iref:c)  (ful:~(or clib gowl calendar) l r)
    ;div
      ;*  ?.  &(collapse (lth 3 (lent irefs)))
            %+  turn  irefs
            |=  =iref:c
            (event:components:(event cid iref) &)
          %+  welp
            %+  turn  (scag 2 irefs)
            |=  =iref:c
            (event:components:(event cid iref) &)
          :_  ~
          ;div
            =id          (en-html-id:htmx (weld base /more))
            =class       "relative cursor-pointer z-10 mb-[4px] flex-grow px-2 py-1 text-xs rounded truncate bg-white text-gray-700 font-semibold hover:bg-gray-100 transition duration-150 ease-in-out"
            =style       "width: calc(100% - 12px);"
            =hx-post     "{(spud (moup:htmx 2 base))}/uncollapse"
            =hx-target   "#{(en-html-id:htmx (moup:htmx 2 base))}"
            =hx-trigger  "click" 
            =hx-swap     "outerHTML"
            ; {(numb:tu (sub (lent irefs) 2))} more
          ==
    ==
  ::
  ++  fullday-square
    ^-  manx
    ;div.relative.min-w-0
      =style  "border-right: 1px solid #e5e7eb; border-bottom: 1px solid $e5e7eb;"
      ;div.absolute.inset-0.z-0
        =id          "{(en-html-id:htmx (weld base /unhider))}"
        =hx-post     "{(spud base)}/add-event/unhide"
        =hx-target   "#{(en-html-id:htmx (weld base /add-event))}"
        =hx-trigger  "click"
        =hx-swap     "outerHTML"
        ;
      ==
      ;+  (add-event:components:add-event &)
      ;+  events
    ==
  --
--

