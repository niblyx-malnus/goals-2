/-  spider
/+  *ventio, bind, htmx, webui-main
=,  strand=strand:spider
^-  thread:spider
::
%-  vine-thread
%-  (vine:htmx /htmx/goals poll-interval:webui-main)
%-  vine:bind
|=  [gowl=bowl:gall vid=vent-id =mark =vase]
=/  m  (strand ,^vase)
^-  form:m
::
=*  htx  ~(. vine:webui-main gowl)
::
~&  "vent to {<dap.gowl>} vine with mark {<mark>}"
?+    mark  (strand-fail %bad-vent-request ~)
    %handle-http-request
  (handle-http-request:htx !<([@ta inbound-request:eyre] vase))
==
