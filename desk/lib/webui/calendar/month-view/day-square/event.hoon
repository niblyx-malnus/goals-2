/-  t=timezones, c=calendar
/+  *ventio, server, htmx, nooks, fi=webui-feather-icons, html-utils,
    tu=time-utils, clib=calendar,
    webui-calendar-scripts,
    webui-calendar-update-event-panel
|_  $:  [zid=(unit zid:t) y=@ud m=@ud =date =cid:c =iref:c]
        =gowl 
        base=(pole @t)
        [eyre-id=@ta req=inbound-request:eyre]
        request-line:server :: pre-parsed
    ==
+*  nuk  ~(. nooks gowl)
    mx   mx:html-utils
    kv   kv:html-utils
    now       (need (get-now-tz zid))
    calendar  (get-calendar cid)
::
++  update-event-panel
  |=  [zid=(unit zid:t) =^date =cid:c =iref:c]
  %~  .
    webui-calendar-update-event-panel
  :-  [zid date cid iref]
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
+$  state  ? :: hidden update-event-panel
++  init   (pure:(strand ,state) &)
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
    ;<  *  bind:m  handle:(update-event-panel zid date cid iref)
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
    handle:(update-event-panel zid date cid iref)
  ==
::
++  components
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
    =/  =aid:c       (~(gut by ruledata-map.event) i.iref default-ruledata.event)
    =/  =ruledata:c  (~(got by ruledata.event) aid)
    =/  title=tape   (trip (so:dejs:format (~(gut by metadata) 'title' s+'NO TITLE!')))
    =/  =instance:c  (~(got by instances.event) i.iref)
    :: TODO: handle exceptions; handle nulls;
    ::
    ?:  ?=(%span -.instance)
      ?>  ?=(%& -.p.instance)
      =/  start=@da    (max (need (get-utc-to-tz l.p.p.instance zid)) (year date))
      ;div(id html-id)
        ;div
          =class       "flex gap-1 items-center overflow-hidden hover:bg-gray-100 rounded cursor-pointer mb-[4px] px-2 py-1"
          =hx-trigger  "click"
          =hx-post     "{(spud base)}/unhide"
          =hx-target   "#{html-id}"
          =hx-swap     "outerHTML"
          ;div.bg-green-500.rounded-full.flex-shrink-0
            =style  "width: 8px; height: 8px;"
            ;
          ==
          ;div.flex.gap-1.items-center
            ;+  %-  need  %-  de-xml:html  %-  crip
                "<span class=\"text-xs text-gray-800 truncate\">{(dr-format:tu '12' (mod start ~d1))} <strong>{title}</strong></span>"
          ==
        ==
        ;+  (modal-container hidden)
      ==
    ?>  ?=(%fuld -.instance)
    ;div(id html-id)
      ;div
        =class       "cursor-pointer flex-grow mb-[4px] px-2 py-1 text-xs rounded truncate bg-green-500 hover:bg-green-600 text-white"
        =hx-trigger  "click"
        =hx-post     "{(spud base)}/unhide"
        =hx-target   "#{html-id}"
        =hx-swap     "outerHTML"
        {title}
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
    ;div
      =class  "fixed inset-0 z-10 overflow-y-auto"
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
            ;+  (default:components:(update-event-panel zid date cid iref) %update)
          ==
        ==
      == 
    ==
  --
--
