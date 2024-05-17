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
  ?>  ?=(%convert-iana -.axn)
  ;<  ~  bind:m  convert-iana:hc
  (pure:m !>(~))
==
::
|_  =gowl
++  convert-iana
  =/  m  (strand ,~)
  ^-  form:m
  ;<  iana=(unit iana:iana)  bind:m
    (scry-hard ,(unit iana:iana) /gx/iana/iana/iana-data)
  ;<  =cache:r  bind:m
    (scry-hard ,cache:r /gx/rule-store/cache/noun)
  =/  =zones:t
    :: this process is simply too long
    :: it should be broken into pieces
    %~    convert-iana-zones-new
        iana-converter
     [gowl (fall iana [~ ~ ~]) to-to-jumps.cache]
  %+  poke  [our dap]:gowl
  :-  %timezones-transition  !>
  ^-  transition:t
  [%put-zones zones]
--
