/-  t=timezones, r=rules, iana, spider
/+  *ventio, iana-converter 
=,  strand=strand:spider
^-  thread:spider
::
=;  helper-core
::
%-  vine-thread
|=  [gowl=bowl:gall vid=vent-id =mark =vase]
=/  m  (strand ,^vase)
^-  form:m
::
=*  hc  ~(. helper-core gowl)
::
~&  "vent to {<dap.gowl>} vine with mark {<mark>}"
?+    mark  (strand-fail %bad-vent-request ~)
    %timezones-action
  =+  !<(axn=action:t vase)
  ?-    -.axn
      %convert-iana
    ;<  ~  bind:m  convert-iana:hc
    (pure:m !>(~))
    ::
      %convert-iana-zone
    ;<  ~  bind:m  (convert-iana-zone:hc keys.axn)
    (pure:m !>(~))
  ==
==
::
|_  =gowl
++  convert-iana
  =/  m  (strand ,~)
  ^-  form:m
  ;<  uiana=(unit iana:iana)  bind:m
    (scry ,(unit iana:iana) /gx/iana/iana/iana-data)
  ;<  =cache:r  bind:m
    (scry ,cache:r /gx/rule-store/cache/noun)
  =/  data=iana:iana  (need uiana)
  =/  zones=(list [@t zone:iana])  ~(tap by zones.data)
  =/  core  ~(abet iana-converter [gowl data to-to-jumps.cache])
  |-
  ?~  zones
    (pure:m ~)
  ;<  ~  bind:m
    %+  poke  [our dap]:gowl
    :-  %timezones-transition  !>
    ^-  transition:t
    [%put-zone (convert-zone:core -.i.zones)]
  ;<  ~  bind:m  (sleep ~s2)
  $(zones t.zones)
::
++  convert-iana-zone
  |=  keys=(list @ta)
  =/  m  (strand ,~)
  ^-  form:m
  ;<  uiana=(unit iana:iana)  bind:m
    (scry ,(unit iana:iana) /gx/iana/iana/iana-data)
  ;<  =cache:r  bind:m
    (scry ,cache:r /gx/rule-store/cache/noun)
  =/  input=iana:iana  (fall uiana [~ ~ ~])
  =.  input
    :_  [rules links]:input
    =|  =zones:iana
    |-
    ?~  keys
      zones
    %=    $
      keys  t.keys 
        zones
      (~(put by zones) i.keys (~(got by zones.input) i.keys))
    ==
  =/  =zones:t
    convert-zones:~(abet iana-converter [gowl input to-to-jumps.cache])
  %+  poke  [our dap]:gowl
  :-  %timezones-transition  !>
  ^-  transition:t
  [%uni-zones zones]
--
