/-  c=calendar
/+  *ventio, server, htmx, nooks, pytz,
    html-utils, tu=time-utils, clib=calendar,
    fi=webui-feather-icons,
    webui-calendar-day-view-day-square-event,
    webui-calendar-day-view-day-square-add-event
::
|_  $:  [zid=@t y=@ud m=@ud d=@ud]
        =gowl 
        base=(pole @t)
        [eyre-id=@ta req=inbound-request:eyre]
        request-line:server :: pre-parsed
    ==
+*  nuk  ~(. nooks gowl)
    mx   mx:html-utils
    kv   kv:html-utils
    zn   ~(. zn:pytz zid)
    now  (fall (~(localize-soft zn:pytz zid) now.gowl) now.gowl)
    cid           [our.gowl %our]
    calendar      (get-calendar cid) :: just %our calendar for now
::
++  event
  |=  [=cid:c =iref:c]
  %~  .
    webui-calendar-day-view-day-square-event
  :-  [zid y m d cid iref]
  :+  gowl
    %+  weld  base
    /event/(scot %p host.cid)/[name.cid]/[`@ta`eid.iref]/(scot %ud i.iref)
  [[eyre-id req] [ext site] args]
::
++  add-event
  |=  chunk=@ud
  %~  .
    webui-calendar-day-view-day-square-add-event
  :-  [zid y m d chunk]
  :+  gowl
    %+  weld  base
    /add-event/(scot %ud chunk)
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
  ?+    parms
    (strand-fail %bad-http-request ~)
    ::
      [%'GET' ~ *]
    (give-html-manx:htmx [our dap]:gowl eyre-id day-square:components |)
    ::
      [* [%add-event chunk=@ta *] *]
    handle:(add-event (slav %ud chunk.cad.parms))
    ::
      [* [%event host=@t name=@t eid=@t i=@t *] *]
    =/  =cid:c   [(slav %p host.cad.parms) name.cad.parms]
    =/  =iref:c  [eid.cad.parms (slav %ud i.cad.parms)] 
    handle:(event cid iref)
  ==
::
++  components
  =/  =date  [[& y] m d 0 0 0 ~]
  |%
  ++  events
    ^-  manx
    :: TODO: handle nulls
    ::
    =/  l=@da  (universalize:zn (year date))
    =/  r=@da  (add l ~d1)
    =/  irefs=(set iref:c)  (spa:~(or clib gowl calendar) l r)
    ;div
      ;*  %+  turn  ~(tap in irefs)
          |=  =iref:c
          (event:components:(event cid iref) &)
    ==
  ::
  ++  chunks
    ^-  marl
    %+  turn  (gulf 0 47)
    |=  chunk=@ud
    ;div
      ;+  (add-event:components:(add-event chunk) &)
      ;div
        =id          "{(en-html-id:htmx (weld base /chunk/(scot %ud chunk)))}"
        =class       "absolute w-full h-[25px] z-0"
        =style       "top: {(numb:htmx (mul chunk 25))}px;"
        =hx-post     "{(spud base)}/add-event/{(scow %ud chunk)}/unhide"
        =hx-target   "#{(en-html-id:htmx (weld base /add-event/(scot %ud chunk)))}"
        =hx-trigger  "click"
        =hx-swap     "outerHTML"
        ;
      ==
    ==
  ::
  ++  day-square
    ^-  manx
    =/  day-style=tape
      """
      background-image: linear-gradient(to bottom, #e5e7eb 1px, transparent 1px);
      background-size: 100% 50px;
      border-right: 1px solid #e5e7eb;
      border-bottom: 1px solid #e5e7eb;
      """
    ;div
      =style  day-style
      =class  "relative h-[1200px] min-w-0"
      ;*  chunks
      ;+  events
    ==
  --
--

