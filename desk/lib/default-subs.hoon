/+  default-agent
|*  [agent=* success=* naive-retry=* help=*]
|_  =bowl:gall
+*  def       ~(. (default-agent agent help) bowl)
++  on-init   on-init:def
++  on-save   on-save:def
++  on-load   on-load:def
++  on-poke   on-poke:def
++  on-peek   on-peek:def
++  on-fail   on-fail:def
++  on-arvo   on-arvo:def
::
++  on-watch
  |=  =path
  ~|  "unexpected subscription from {<src.bowl>} to {<dap.bowl>} on path {<path>}"
  !!
::
++  on-leave
  |=  =path
  %-  (slog leaf+"{<src.bowl>} leaving subscription to path {<path>}" ~)
  [~ agent]
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card:agent:gall _agent)
  ?-    -.sign
      %poke-ack
    ?~  p.sign
      ?.  ?=(%& success)
        [~ agent]
      %-  (slog leaf+"poke succeeded from {<dap.bowl>} on wire {<wire>}" ~)
      [~ agent]
    %-  (slog leaf+"poke failed from {<dap.bowl>} on wire {<wire>}" u.p.sign)
    [~ agent]
    ::
      %watch-ack
    ?.  ?=(%& success)
      [~ agent]
    ?~  p.sign
      %-  (slog leaf+"subscribe to {<src.bowl>} succeeded from {<dap.bowl>} on wire {<wire>}" ~)
      [~ agent]
    =/  =tank  leaf+"subscribe to {<src.bowl>} failed from {<dap.bowl>} on wire {<wire>}"
    %-  (slog tank u.p.sign)
    [~ agent]
    ::
      %kick
    %-  (slog leaf+"{<dap.bowl>} got kick from {<src.bowl>} on wire {<wire>}" ~)
    ?.  ?=(%& naive-retry)
      [~ agent]
    [[%pass wire %agent [src dap]:bowl %watch wire]~ agent]
    ::
      %fact
    ~|  "unexpected subscription update from {<src.bowl>} to {<dap.bowl>} on wire {<wire>}"
    ~|  "with mark {<p.cage.sign>}"
    !!
  ==
--
