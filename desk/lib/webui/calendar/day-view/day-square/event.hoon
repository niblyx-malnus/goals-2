/-  c=calendar
/+  *ventio, *numb, server, htmx, nooks, pytz, iso=iso-8601,
    html-utils, tu=time-utils, clib=calendar,
    fi=webui-feather-icons,
    webui-calendar-scripts,
    webui-calendar-update-event-panel
|_  $:  [zid=@t y=@ud m=@ud d=@ud =cid:c =iref:c]
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
    calendar  (get-calendar cid)
::
++  update-event-panel
  %~  .
    webui-calendar-update-event-panel
  :-  [zid [[& y] m d 0 0 0 ~] cid iref]
  :+  gowl
    (weld base /update-event-panel)
  [[eyre-id req] [ext site] args]
::
++  fi-x
  ^-  manx
  =/  =manx  (make:fi %x)
  =.  manx   (pus:~(at mx manx) "height: .875em; width: .875em;")
  (pac:~(at mx manx) "inline text-lg")
::
++  blue-fi-loader
  ^-  manx
  =/  =manx  (make:fi %loader)
  =.  manx   (pus:~(at mx manx) "height: .875em; width: .875em;")
  (pac:~(at mx manx) "text-4xl text-blue-500 animate-spin")
::
++  get-calendar
  |=  =cid:c
  .^  calendar:c  %gx
    (scot %p our.gowl)  %calendar  (scot %da now.gowl)
    /calendar/(scot %p host.cid)/[name.cid]/noun
  ==
::
+$  state  ? :: hidden update-event-panel
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
    (give-html-manx:htmx [our dap]:gowl eyre-id (event:components sta) |)
    ::
      [* [%hide ~] *]
    ;<  sta=state  bind:m  ((put:nuk state) base &)
    (give-html-manx:htmx [our dap]:gowl eyre-id (event:components sta) |)
    ::
      [* [%unhide ~] *]
    ;<  sta=state  bind:m  ((put:nuk state) base |)
    (give-html-manx:htmx [our dap]:gowl eyre-id (event:components sta) |)
    ::
      [%'POST' [%update-event-panel ?(%update-event %delete-event) ~] *]
    :: send the update then hide container
    ;<  *  bind:m  handle:update-event-panel
    ;<  ~  bind:m
      %+  send-refresh:htmx  [our dap]:gowl
      %+  murn  ~(tap of (dip:nuk /))
      |=  [=path *]
      ?.  ?=([%htmx %goals %calendar @ta ~] path)
        ~
      [~ "#{(en-html-id:htmx path)}" (spud path) ~ ~]
    (pure:m !>(~))
    ::
      [* [%update-event-panel *] *]
    handle:update-event-panel
  ==
::
++  components
  =/  =date  [[& y] m d 0 0 0 ~]
  |%
  ++  event
    |=  hidden=?
    ^-  manx
    =/  html-id=tape  (en-html-id:htmx base)
    ?.  (~(has by events.calendar) eid.iref)
      ;div(id html-id);
    =/  =event:c     (~(got by events.calendar) eid.iref)
    =/  =mid:c       (~(gut by metadata-map.event) i.iref default-metadata.event)
    =/  =metadata:c  (~(got by metadata.event) mid)
    =/  title=tape   (trip (so:dejs:format (~(gut by metadata) 'title' s+'NO TITLE!')))
    =/  =instance:c  (~(got by instances.event) i.iref)
    :: TODO: handle exceptions; handle nulls;
    ::
    ?>  ?=(%span -.instance)
    ?>  ?=(%& -.p.instance)
    =/  start=^date
      (yore (max (localize:zn l.p.p.instance) (year date)))
    =/  end=^date
      (yore (min (localize:zn r.p.p.instance) (add ~d1 (year date))))
    ?:  =(start end)
      ;div(id html-id);
    =/  start-px=@ud   (add (mul 50 h.t.start) (div (mul 50 m.t.start) 60))
    =/  end-px=@ud
      ?:  =(d.t.end +(d.t.date))
        1.200
      (add (mul 50 h.t.end) (div (mul 50 m.t.end) 60))
    =/  dif-px=@ud     (sub end-px start-px)
    =/  start-hr=tape  (dr-format:iso '12' (mod (year start) ~d1))
    =/  end-hr=tape    (dr-format:iso '12' (mod (year end) ~d1))
    ;div.relative(id html-id)
      ;div
        :: TODO: border-white only when not z-0 (bottom layer)
        =class       "absolute flex flex-col cursor-pointer mb-[4px] px-2 py-1 text-xs rounded truncate bg-green-500 text-white border border-white border-solid"
        =style       "top: {(numb start-px)}px; height: {(numb dif-px)}px; z-index: 1; width: calc(100% - 12px);"
        =hx-trigger  "click"
        =hx-post     "{(spud base)}/unhide"
        =hx-target   "#{html-id}"
        =hx-swap     "outerHTML"
        ;span: {title}
        ;span(class "text-[0.9em]"): {start-hr} - {end-hr}
      ==
      ;+  (modal-container hidden)
    ==
  ::
  ++  modal-container
    |=  hidden=?
    ^-  manx
    =/  html-id=tape  (en-html-id:htmx base)
    ?:  hidden
      ;div;
    ;div.fixed.inset-0.overflow-y-auto
      =style  "z-index: 100000;"
      ;div(class "flex items-center justify-center min-h-screen px-4 pt-4 pb-20 text-center sm:block sm:p-0")
        ;div.fixed.inset-0.transition-opacity
          ;div.absolute.inset-0.bg-gray-300.opacity-50;
        ==
        ;div
          =class            "fixed top-20 left-1/2 -translate-x-1/2 inline-block overflow-hidden text-left align-bottom transition-all transform bg-white rounded-lg shadow-xl sm:my-8 sm:align-middle sm:max-w-lg sm:w-full"
          ;div.flex.flex-col
            ;div.bg-gray-100.flex-1.flex.justify-end.h-12
              ;button
                =hx-post    "{(spud base)}/hide"
                =hx-target  "#{html-id}"
                =hx-swap    "outerHTML"
                =class      "m-1 text-gray-500 bg-gray-100 hover:bg-gray-200 transition duration-150 ease-in-out rounded-full p-2"
                ;+  fi-x
              ==
            ==
            ;+  (default:components:update-event-panel %update)
          ==
        ==
      == 
    ==
  --
--
