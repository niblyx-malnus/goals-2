/-  iana, spider
/+  *ventio
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
    %noun
  ?>  ?=(%fetch-timezones q.vase)
  %-  (slog leaf+(weld "importing all timezones from " url-prefix:hc) ~)
  =/  files=wall  all-files:hc
  |-
  ?~  files
    (pure:m !>(~))
  %-  (slog leaf+"requesting {i.files}" ~)
  ;<  data=@t  bind:m  (fetch-cord (weld url-prefix:hc i.files))
  ;<  ~        bind:m  (import-blob:hc data)
  $(files t.files)
==
::
|_  =gowl
++  import-blob
  |=  data=@t
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  [our dap]:gowl
  :-  %iana-action  !>
  ^-  action:iana
  [%import-blob data]
::
++  url-prefix  "https://raw.githubusercontent.com/eggert/tz/main/"
::
++  all-files
  ^-  wall
  :~  "northamerica"
      "asia"
      "australasia"
      "africa"
      "antarctica"
      "europe"
      "southamerica"
  ==
--
