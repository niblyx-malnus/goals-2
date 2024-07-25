/-  p=pytz
/+  *ventio, tu=time-utils
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
  ?>  ?=(%fetch-zones q.vase)
  ;<  start-time=@da  bind:m  get-time
  ;<  names-cord=@t  bind:m  (fetch-cord zone-names-url:hc)
  =/  names=(list @t)  (to-wain:format names-cord)
  |-
  ?~  names
    ;<  end-time=@da  bind:m  get-time
    ~&  >  "%pytz import finished in: {(scow %dr (sub end-time start-time))}"
    (pure:m !>(~))
  ~&  >>  "%pytz: importing zone {(trip i.names)}"
  =/  url=tape  (zone-csv-url:hc i.names)
  ;<  zone-csv=@t  bind:m  (fetch-cord url)
  =/  rows=(list @t)  (to-wain:format zone-csv)
  =/  data=(list [jump:tu rule:p])  (parse-zone-rows:hc rows)
  ;<  ~  bind:m
    %+  poke  [our dap]:gowl
    :-  %pytz-action  !>
    ^-  action:p
    [%put-zone i.names data]
  $(names t.names)
==
::
|_  =gowl
++  url-prefix  "https://raw.githubusercontent.com/niblyx-malnus/pytz-timezones/main/IANA_2024.1"
++  zone-names-url  (weld url-prefix "/zone_names.txt")
::
++  fas-to-cab
  |=  name=tape
  ^-  tape
  ?~  name
    ~
  :_  $(name t.name)
  ?:(=('/' i.name) '_' i.name)
::
++  zone-csv-url
  |=  name=@t
  ^-  tape
  :(weld url-prefix "/" (fas-to-cab (trip name)) ".csv")
::
++  parse-zone-rows
  |=  rows=wain
  ^-  (list [jump:tu rule:p])
  ?>  ?=(^ rows)
  ?>  =('Time,Offset,Name\0d' i.rows)
  =/  contents=wain  t.rows
  |-
  ?~  contents
    ~
  :-  (rash i.contents parse-zone-row)
  $(contents t.contents)
::
++  parse-zone-row
  =,  monadic-parsing:tu
  ;<  =jump:tu   bind  parse:datetime-local:tu
  ;<  *          bind  com
  ;<  =delta:tu  bind  parse:offset:tu
  ;<  *          bind  com
  ;<  name=@t    bind  (cook crip (star prn))
  ;<  *          bind  (jest '\0d')
  (easy [jump delta name])
--
