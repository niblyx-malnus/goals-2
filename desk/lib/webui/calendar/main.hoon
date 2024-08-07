/-  t=timezones
/+  *ventio, htmx, server, nooks, html-utils, fi=webui-feather-icons,
    iana-converter, tu=time-utils,
    webui-calendar-month-view,
    webui-calendar-week-view,
    webui-calendar-day-view
|_  $:  =gowl 
        base=(pole @t)
        [eyre-id=@ta req=inbound-request:eyre]
        request-line:server :: pre-parsed
    ==
+*  nuk  ~(. nooks gowl)
    mx   mx:html-utils
    kv   kv:html-utils
::
++  zones
  .^  zones:t  %gx
    (scot %p our.gowl)  %timezones  (scot %da now.gowl)
    /zones/noun
  ==
::
++  month-view
  |=  [zid=(unit zid:t) y=@ud m=@ud]
  %~  .
    webui-calendar-month-view
  :-  [zid y m]
  :+  gowl
    %+  weld  base
    /month-view/(crip (en:month-input:tu y m))
  [[eyre-id req] [ext site] args]
::
++  week-view
  |=  [zid=(unit zid:t) y=@ud w=@ud]
  %~  .
    webui-calendar-week-view
  :-  [zid y w]
  :+  gowl
    %+  weld  base
    /week-view/(crip (en:week-input:tu y w))
  [[eyre-id req] [ext site] args]
::
++  day-view
  |=  [zid=(unit zid:t) y=@ud m=@ud d=@ud]
  %~  .
    webui-calendar-day-view
  :-  [zid y m d]
  :+  gowl
    %+  weld  base
    /day-view/(crip (en:date-input:tu y m d))
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
    =.  base  (weld base /[session-id])
    (give-html-manx:htmx [our dap]:gowl eyre-id timezone-getter |)
  ==
::
+$  state
  $:  view=?(%day %week %month)
      month=(unit [y=@ud m=@ud])
      week=(unit [y=@ud w=@ud])
      day=(unit [y=@ud m=@ud d=@ud])
      zone=(unit zid:t)
  ==
::
++  init
  %-  pure:(strand ,state)
  [%month ~ ~ ~ ~]
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
    =/  iana=@t  (fall (get-key:kv 'timezone-getter' args) '')
    =.  zone.sta
      ?~  iana
        ~
      =/  =zid:t  [our.gowl (cat 3 'iana_' (sane-ta-iana-name:iana-converter iana))]
      ?~((get-zone zid) ~ [~ zid])
    =/  =date  (yore (need (get-now-tz zone.sta)))
    ;<  sta=state  bind:m  ((put:nuk state) base sta)
    =/  =manx  month-view:components:(month-view zone.sta [y m]:date)
    (give-html-manx:htmx [our dap]:gowl eyre-id (contain manx) |)
    ::
      [%'GET' ~ *]
    ?-    view.sta
        %day
      =/  day=[@ud @ud @ud]  (fall day.sta [y m d.t]:(yore (need (get-now-tz zone.sta))))
      =/  =manx  day-view:components:(day-view zone.sta day)
      (give-html-manx:htmx [our dap]:gowl eyre-id (contain manx) |)
      ::
        %week
      =/  week=[@ud @ud]  (fall week.sta (da-to-week-number:tu (need (get-now-tz zone.sta))))
      =/  =manx  week-view:components:(week-view zone.sta week)
      (give-html-manx:htmx [our dap]:gowl eyre-id (contain manx) |)
      ::
        %month
      =/  month=[@ud @ud]  (fall month.sta [y m]:(yore (need (get-now-tz zone.sta))))
      =/  =manx  month-view:components:(month-view zone.sta month)
      (give-html-manx:htmx [our dap]:gowl eyre-id (contain manx) |)
    ==
    ::
      [%'POST' [%set-current-zone ~] *]
    =/  args=key-value-list:kv  (parse-body:kv body.request.req)
    =/  zone=@t  (need (get-key:kv 'zone' args))
    =/  zone-by-names=(map @t zid:t)
      %-  ~(gas by *(map @t zid:t))
      %+  turn  ~(tap by zones)
      |=  [=zid:t =zone:t]
      [name.zone zid]
    =.  zone.sta
      ?:  =('' zone)
        ~
      [~ (~(got by zone-by-names) zone)]
    ;<  sta=state  bind:m  ((put:nuk state) base sta)
    ?-    view.sta
        %day
      =/  day=[@ud @ud @ud]  (fall day.sta [y m d.t]:(yore (need (get-now-tz zone.sta))))
      =/  =manx  day-view:components:(day-view zone.sta day)
      (give-html-manx:htmx [our dap]:gowl eyre-id (contain manx) |)
      ::
        %week
      =/  week=[@ud @ud]  (fall week.sta (da-to-week-number:tu (need (get-now-tz zone.sta))))
      =/  =manx  week-view:components:(week-view zone.sta week)
      (give-html-manx:htmx [our dap]:gowl eyre-id (contain manx) |)
      ::
        %month
      =/  month=[@ud @ud]  (fall month.sta [y m]:(yore (need (get-now-tz zone.sta))))
      =/  =manx  month-view:components:(month-view zone.sta month)
      (give-html-manx:htmx [our dap]:gowl eyre-id (contain manx) |)
    ==
    ::
      [%'POST' [%set-current-view ~] *]
    =/  args=key-value-list:kv  (parse-body:kv body.request.req)
    =/  view=@t  (fall (get-key:kv 'view' args) %month)
    =.  view.sta  ;;(?(%day %week %month) view)
    ;<  sta=state  bind:m  ((put:nuk state) base sta)
    ?-    view.sta
        %day
      =/  day=[@ud @ud @ud]  (fall day.sta [y m d.t]:(yore (need (get-now-tz zone.sta))))
      =/  =manx  day-view:components:(day-view zone.sta day)
      (give-html-manx:htmx [our dap]:gowl eyre-id (contain manx) |)
      ::
        %week
      =/  week=[@ud @ud]  (fall week.sta (da-to-week-number:tu (need (get-now-tz zone.sta))))
      =/  =manx  week-view:components:(week-view zone.sta week)
      (give-html-manx:htmx [our dap]:gowl eyre-id (contain manx) |)
      ::
        %month
      =/  month=[@ud @ud]  (fall month.sta [y m]:(yore (need (get-now-tz zone.sta))))
      =/  =manx  month-view:components:(month-view zone.sta month)
      (give-html-manx:htmx [our dap]:gowl eyre-id (contain manx) |)
    ==
    ::
      [* [%day-view date=@ta *] *]
    =/  day=[@ud @ud @ud]  (de:date-input:tu date.cad.parms)
    =.  day.sta  [~ day]
    ;<  sta=state  bind:m  ((put:nuk state) base sta)
    handle:(day-view zone.sta day)
    ::
      [* [%week-view week=@ta *] *]
    =/  week=[@ud @ud]  (de:week-input:tu week.cad.parms)
    =.  week.sta  [~ week]
    ;<  sta=state  bind:m  ((put:nuk state) base sta)
    handle:(week-view zone.sta week)
    ::
      [* [%month-view date=@ta *] *]
    =/  month=[@ud @ud]  (de:month-input:tu date.cad.parms)
    =.  month.sta  [~ month]
    ;<  sta=state  bind:m  ((put:nuk state) base sta)
    handle:(month-view zone.sta month)
  ==
::
++  contain
  |=  contents=manx
  ;div(id (en-html-id:htmx base))
    ;+  contents
  ==
::
++  page-container
  |=  [contents=manx scripts=(list tape)]
  ^-  manx
  ;html(lang "en", style "scroll-behavior: smooth;")
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
      ;+  (refresher:htmx now.gowl /htmx/goals ~)
      ;+  (contain contents)
      ;*  %+  turn  scripts
          |=  script=tape
          ;script: {script}
    ==
  ==
::
++  timezone-getter
  ^-  manx
  %+  page-container
    ;div.flex.h-screen
      ;div.flex-1.flex.items-center.justify-center
        ;+  (pus:~(at mx blue-fi-loader) "height: 1em; width: 1em;")
      ==
      ;form
        ;input.hidden
          =id          (en-html-id:htmx (weld base /timezone-getter))
          =type        "text"
          =name        "timezone-getter"
          =value       ""
          =hx-trigger  "submit"
          =hx-post     "{(spud base)}"
          =hx-target   "#{(en-html-id:htmx base)}"
          =hx-swap     "outerHTML"
          ;
        ==
      ==
    ==
  :_  ~
  """
  document.addEventListener("DOMContentLoaded", function() \{
    const timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    const timezoneInput = document.getElementById('{(en-html-id:htmx (weld base /timezone-getter))}')
    timezoneInput.value = timeZone;
    htmx.trigger(timezoneInput, 'submit')
  });
  """
--
