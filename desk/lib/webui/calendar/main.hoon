/-  t=timezones
/+  *ventio, htmx, server, nooks, html-utils, fi=webui-feather-icons,
    iana-converter, tu=time-utils, webui-calendar-month-view
|_  $:  =gowl 
        base=(pole @t)
        [eyre-id=@ta req=inbound-request:eyre]
        request-line:server :: pre-parsed
    ==
+*  nuk  ~(. nooks gowl)
    mx   mx:html-utils
    kv   kv:html-utils
::
++  month-view
  |=  [zid=(unit zid:t) y=@ud m=@ud]
  %~  .
    webui-calendar-month-view
  :-  [zid y m]
  :+  gowl
    %+  weld  base
    /month-view/(crip (en:month-input:tu (year [%.y y] m 1 0 0 0 ~)))
  [[eyre-id req] [ext site] args]
::
++  blue-fi-loader
  ^-  manx
  =/  =manx  (make:fi %loader)
  =.  manx   (pus:~(at mx manx) "height: .875em; width: .875em;")
  (pac:~(at mx manx) "text-4xl text-blue-500 animate-spin")
::
++  get-zone
  |=  =zid:t
  .^  (unit zone:t)  %gx
    (scot %p our.gowl)  %timezones  (scot %da now.gowl)
    /zone/(scot %p p.zid)/[q.zid]/noun
  ==
::
++  get-now-tz
  |=  zone=(unit zid:t)
  ^-  (unit @da)
  ?~  zone
    `now.gowl
  =;  utc-to-tz
    ?~  utz=((need utc-to-tz) now.gowl)
      ~
    `d.u.utz
  .^  (unit utc-to-tz:t)  %gx
    (scot %p our.gowl)  %timezones  (scot %da now.gowl)
    /utc-to-tz/(scot %p p.u.zone)/[q.u.zone]/noun
  ==
::
++  html-id-to-zid
  |=  =tape
  ^-  zid:t
  %+  scan  tape
  ;~  (glue (just 'X'))
    fed:ag
    (cook crip (star prn))
  ==
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
    =/  =manx  (browser-timezone session-id)
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
  ==
::
+$  state  (unit zid:t)
++  init   (pure:(strand ,state) ~)
::
++  handle-session
  =/  m  (strand ,vase)
  ^-  form:m
  =+  ^=  parms
      :*  met=method.request.req
          cad=`(pole @t)`(need (decap:htmx base site))
          ext=ext
      ==
  ::
  ;<  sta=state  bind:m  ((get-or-init:nuk state) base init)
  ::
  ?+    parms  (strand-fail %bad-http-request ~)
      [%'POST' ~ *]
    =/  args=key-value-list:kv  (parse-body:kv body.request.req)
    =/  iana=@t  (fall (get-key:kv 'browser-timezone' args) '')
    =.  sta
      ?~  iana
        ~
      =/  =zid:t  [our.gowl (cat 3 'iana_' (enta-name:iana-converter iana))]
      ?~((get-zone zid) ~ [~ zid])
    ;<  sta=state  bind:m  ((put:nuk state) base sta)
    =/  =date  (yore (need (get-now-tz sta)))
    =/  =manx  month-view:components:(month-view sta [y m]:date)
    (give-html-manx:htmx [our dap]:gowl eyre-id (page-container manx ~) |)
    ::
      [%'GET' [%set-current-zone ~] *]
    =/  zone=@t  (need (get-key:kv 'zone' args))
    =.  sta
      ?:  =('' zone)
        ~
      [~ (html-id-to-zid (trip zone))]
    ;<  sta=state  bind:m  ((put:nuk state) base sta)
    (give-empty-200:htmx [our dap]:gowl eyre-id)
    ::
      [* [%month-view date=@ta *] *]
    handle:(month-view sta [y m]:(yore (de:month-input:tu date.cad.parms)))
  ==
::
++  page-container
  |=  [contents=manx scripts=(list tape)]
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
      ;+  dummy:htmx
      ;+  (refresher:htmx now.gowl /htmx/goals ~)
      ;div#page-contents
        ;+  contents
      ==
      ;*  %+  turn  scripts
          |=  script=tape
          ;script: {script}
    ==
  ==
::
++  browser-timezone
  |=  session-id=@ta
  ^-  manx
  %+  page-container
    ;div.flex.h-screen
      ;div.flex-1.flex.items-center.justify-center
        ;+  (pus:~(at mx blue-fi-loader) "height: 1em; width: 1em;")
      ==
      ;form
        ;input#browser-timezone.hidden
          =type        "text"
          =name        "browser-timezone"
          =value       ""
          =hx-trigger  "submit"
          =hx-post     "{(spud base)}/{(trip session-id)}"
          =hx-target   "#page-contents"
          =hx-swap     "innerHTML"
          ;
        ==
      ==
    ==
  :_  ~
  """
  document.addEventListener("DOMContentLoaded", function() \{
    const timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    const timezoneInput = document.getElementById('browser-timezone')
    timezoneInput.value = timeZone;
    htmx.trigger(timezoneInput, 'submit')
  });
  """
--
