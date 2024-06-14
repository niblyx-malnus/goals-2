/-  spider, c=calendar, p=pools
/+  *ventio, server, sub-count, calendar-api
=,  strand=strand:spider
^-  thread:spider
::
=<  =*  helper-core  .
::
%-  vine-thread
%-  vine:sub-count
|=  [gowl=bowl:gall vid=vent-id =mark =vase]
=/  m  (strand ,^vase)
^-  form:m
::
=*  hc   ~(. helper-core gowl)
::
~&  "vent to {<dap.gowl>} vine with mark {<mark>}"
?+    mark  (strand-fail %bad-vent-request ~)
    %calendar-calendar-action
  (handle-calendar-action:hc !<([cid:c calendar-action:c] vase))
==
::
|_  =gowl
+*  cap  ~(. calendar-api gowl)
++  handle-calendar-action
  |=  [=cid:c axn=calendar-action:c]
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  =calendars:c  bind:m  (scry-hard ,calendars:c /gx/calendar/calendars/noun)
  ?-    -.axn    
      %create-event
    =/  =metadata:c     (~(put by *metadata:c) title/s+title.axn)
    ;<  =eid:c  bind:m  (unique-eid cid)
    ;<  =mid:c  bind:m  (unique-mid cid eid)
    ;<  =aid:c  bind:m  (unique-aid cid eid)
    ;<  ~       bind:m  (create-event:cot:cap cid eid dom.axn mid metadata aid ruledata.axn)
    (pure:m !>(s+eid))
    ::
      %delete-event
    ;<  ~  bind:m  (delete-event:cot:cap cid eid.axn)
    (pure:m !>(~))
    ::
      %update-event
    ;<  ~  bind:m  (update-event:cot:cap cid [eid p]:axn)
    (pure:m !>(~))
  ==
::
++  unique-eid
  |=  =cid:c
  =/  m  (strand ,eid:c)
  ^-  form:m
  ;<  =calendars:c  bind:m  (scry-hard ,calendars:c /gx/calendar/calendars/noun)
  =/  cal=calendar:c  (~(got by calendars) cid)
  |-
  =/  =eid:c  (scot %uv (sham eny.gowl))
  ?.  (~(has in ~(key by events.cal)) eid)
    (pure:m eid)
  $(eny.gowl +(eny.gowl))
::
++  unique-mid
  |=  [=cid:c =eid:c]
  =/  m  (strand ,mid:c)
  ^-  form:m
  ;<  =calendars:c  bind:m  (scry-hard ,calendars:c /gx/calendar/calendars/noun)
  =/  ven=(unit event:c)  (~(get by events:(~(got by calendars) cid)) eid)
  ?~  ven
    (pure:m (scot %uv (sham eny.gowl)))
  |-
  =/  =mid:c  (scot %uv (sham eny.gowl))
  ?.  (~(has in ~(key by metadata.u.ven)) mid)
    (pure:m mid)
  $(eny.gowl +(eny.gowl))
::
++  unique-aid
  |=  [=cid:c =eid:c]
  =/  m  (strand ,aid:c)
  ^-  form:m
  ;<  =calendars:c  bind:m  (scry-hard ,calendars:c /gx/calendar/calendars/noun)
  =/  ven=(unit event:c)  (~(get by events:(~(got by calendars) cid)) eid)
  ?~  ven
    (pure:m (scot %uv (sham eny.gowl)))
  |-
  =/  =aid:c  (scot %uv (sham eny.gowl))
  ?.  (~(has in ~(key by ruledata.u.ven)) aid)
    (pure:m aid)
  $(eny.gowl +(eny.gowl))
--
