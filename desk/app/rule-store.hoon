/-  r=rules
/+  rlib=rules, vent, bind, server, dbug, verb, default-agent
:: Import to force compilation during development.
::
|%
+$  card            card:agent:gall
+$  inflated-state  [state-0:r =cache:r]
--
=|  inflated-state
=*  state  -<
%-  agent:dbug
%+  verb  |
%-  agent:vent
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    rul   ~(. rlib [bowl rules cache])
::
++  on-init
  ^-  (quip card _this)
  =.  rules.state  hardcode:rul
  =.  cache        cache-rules:rul
  [~ this]
::
++  on-save   !>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  =+  !<(old=state-0:r ole)
  =.  state  old
  =.  rules.state  hardcode:rul
  =.  cache        cache-rules:rul
  [~ this]
::
++  on-poke   on-poke:def
++  on-watch  on-watch:def
++  on-leave  on-leave:def
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %rules ~]        ``noun+!>(rules)
    [%x %cache ~]        ``noun+!>(cache)
    [%x %to-to-boths ~]  ``noun+!>(to-to-boths.cache)
    [%x %to-to-lefts ~]  ``noun+!>(to-to-lefts.cache)
    [%x %to-to-fulds ~]  ``noun+!>(to-to-fulds.cache)
    [%x %to-to-jumps ~]  ``noun+!>(to-to-jumps.cache)
    ::
      [%x %rules p=@ta q=@ta r=@ta ~]
    =/  =rid:r  [?~(p ~ `(slav %p p)) ;;(rule-type:^r q) r]:[pole .]
    :-  ~  :-  ~  :-  %noun  !>
    (~(get by rules) rid)
    ::
      [%x %to-to-both p=@ta q=@ta r=@ta ~]
    ?.  ?=(%both q.pole)  ~
    =/  =rid:r  [?~(p ~ `(slav %p p)) q r]:[pole .]
    :-  ~  :-  ~  :-  %noun  !>
    (~(get by to-to-boths.cache) rid)
    ::
      [%x %to-to-left p=@ta q=@ta r=@ta ~]
    ?.  ?=(%left q.pole)  ~
    =/  =rid:r  [?~(p ~ `(slav %p p)) q r]:[pole .]
    :-  ~  :-  ~  :-  %noun  !>
    (~(get by to-to-lefts.cache) rid)
    ::
      [%x %to-to-fuld p=@ta q=@ta r=@ta ~]
    ?.  ?=(%fuld q.pole)  ~
    =/  =rid:r  [?~(p ~ `(slav %p p)) q r]:[pole .]
    :-  ~  :-  ~  :-  %noun  !>
    (~(get by to-to-fulds.cache) rid)
    ::
      [%x %to-to-jump p=@ta q=@ta r=@ta ~]
    ?.  ?=(%jump q.pole)  ~
    =/  =rid:r  [?~(p ~ `(slav %p p)) q r]:[pole .]
    :-  ~  :-  ~  :-  %noun  !>
    (~(get by to-to-jumps.cache) rid)
  ==
::
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
