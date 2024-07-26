/-  c=calendar
/+  *ventio, server, htmx, nooks, fi=webui-feather-icons, html-utils,
    tu=time-utils, clib=calendar,
    webui-calendar-scripts,
    webui-calendar-create-event-panel
|_  $:  [zid=@t y=@ud m=@ud =date]
        =gowl 
        base=(pole @t)
        [eyre-id=@ta req=inbound-request:eyre]
        request-line:server :: pre-parsed
    ==
+*  nuk  ~(. nooks gowl)
    mx   mx:html-utils
    kv   kv:html-utils
    now  (fall (bind (~(utc-to-tz zn:pytz zid) now.gowl) tail) now.gowl)
    calendar      (get-calendar cid)
::
++  create-event-panel
  %~  .
    webui-calendar-create-event-panel
  :-  [zid date ~ %fuld]
  :+  gowl
    (weld base /create-event-panel)
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
+$  state  ? :: hidden create-event-panel
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
    (give-html-manx:htmx [our dap]:gowl eyre-id (add-event:components sta) |)
    ::
      [%'POST' [%hide ~] *]
    ;<  sta=state  bind:m  ((put:nuk state) base &)
    (give-html-manx:htmx [our dap]:gowl eyre-id (add-event:components sta) |)
    ::
      [%'POST' [%unhide ~] *]
    ;<  sta=state  bind:m  ((put:nuk state) base |)
    (give-html-manx:htmx [our dap]:gowl eyre-id (add-event:components sta) |)
    ::
      [%'POST' [%create-event-panel %create-event ~] *]
    :: send the update then hide container
    ;<  *  bind:m  handle:create-event-panel
    ;<  sta=state  bind:m  ((put:nuk state) base &)
    ;<  ~  bind:m
      %+  send-refresh:htmx  [our dap]:gowl
      %+  murn  ~(tap of (dip:nuk /))
      |=  [=path *]
      ?.  ?=([%htmx %goals %calendar @ta ~] path)
        ~
      [~ "#{(en-html-id:htmx path)}" (spud path) ~ ~]
    (pure:m !>(~))
    ::
      [* [%create-event-panel *] *]
    handle:create-event-panel
  ==
::
++  components
  |%
  ++  add-event
    |=  hidden=?
    ^-  manx
    =/  html-id=tape  (en-html-id:htmx base)
    ?:  hidden
      ;div(id html-id);
    ;div(id html-id, class "relative")
      ;div
        =class  "shadow-lg mt-1 px-2 py-1 text-xs rounded {?:(=(m m.date) "bg-green-500 text-white shadow-gray-400" "bg-green-300 text-gray-400 shadow-gray-300")}"
        (No title)
      ==
      ;+  (create-modal-container hidden)
    ==
  ::
  ++  create-modal-container
    |=  hidden=?
    ^-  manx
    =/  html-id=tape  (en-html-id:htmx base)
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
                =hx-post     "{(spud base)}/hide"
                =hx-target   "#{html-id}"
                =class       "m-1 text-gray-500 bg-gray-100 hover:bg-gray-200 transition duration-150 ease-in-out rounded-full p-2"
                ;+  fi-x
              ==
            ==
            ;+  default:components:create-event-panel
          ==
        ==
      == 
    ==
  --
--
