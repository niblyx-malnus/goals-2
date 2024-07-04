:: stores IANA timezone data converted to an urbit-native format
:: as well as any other custom timezones in that format
::
/-  t=timezones, iana, r=rules
/+  timezones, vent, verb, dbug, default-agent
:: import to force compilation during development
::
/=  x  /ted/vines/timezones
/=  x  /mar/timezones/transition
/=  x  /mar/timezones/action
::
|%
+$  card  card:agent:gall
--
::
%-  agent:dbug
%+  verb  |
=|  state-0:t
=*  state  -
%-  agent:vent
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    vnt   ~(. (utils:vent this) bowl)
    zon   ~(. timezones zones .^((map rid:r to-to-jump:r) %gx (scot %p our.bowl) %rule-store (scot %da now.bowl) /to-to-jumps/noun))
::
++  on-init   on-init:def
::
++  on-save  !>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  =+  !<(old=state-0:t ole)
  [~ this(state old)]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src our):bowl
  ?+    mark  (on-poke:def mark vase)
    %timezones-action  (vent-cage:vnt mark vase)
    ::
      %timezones-transition
    =+  !<(tan=transition:t vase)
    ?>  ?=(%put-zones -.tan)
    [~ this(zones zones.tan)]
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %zones ~]       ``noun+!>(zones)
    ::
      [%x %zone p=@ta q=@ta ~]
    =/  =zid:t   [(slav %p p.pole) q.pole]
    :-  ~  :-  ~  :-  %noun  !>
    (~(get by zones) zid)
    ::
      [%x %rule p=@ta q=@ta ~]
    =/  =zid:t   [(slav %p p.pole) q.pole]
    =/  =zone:t  (~(got by zones) zid)
    =/  pul=(unit [@ud rule=tz-rule:t])
      (~(pul or:(abed:zn:zon zid) order.zone) now.bowl)
    ``noun+!>(rule:(need pul))
    ::
      [%x %offset p=@ta q=@ta ~]
    =/  =zid:t   [(slav %p p.pole) q.pole]
    =/  =zone:t  (~(got by zones) zid)
    =/  pul=(unit [@ud rule=tz-rule:t])
      (~(pul or:(abed:zn:zon zid) order.zone) now.bowl)
    ``noun+!>(offset.rule:(need pul))
    ::
    [%x %zones2 ~]  ``zone-peek+!>(zones+zones)
    [%x %flags ~]   ``zone-peek+!>(flags+~(tap in ~(key by zones)))
    ::
      [%x %zone2 p=@ta q=@ta ~]
    =/  =zid:t   [(slav %p p.pole) q.pole]
    ``zone-peek+!>(zone+(~(got by zones) zid))
    ::
      [%x %tz-to-utc-list p=@ta q=@ta ~]
    :-  ~  :-  ~  :-  %noun  !>
    =/  =zid:t   [(slav %p p.pole) q.pole]
    ?.  (~(has by zones) zid)
      ~
    `tz-to-utc-list:(abed:zn:zon zid)
    ::
      [%x %tz-to-utc p=@ta q=@ta ~]
    :-  ~  :-  ~  :-  %noun  !>
    =/  =zid:t   [(slav %p p.pole) q.pole]
    ?.  (~(has by zones) zid)
      ~
    `tz-to-utc:(abed:zn:zon zid)
    ::
      [%x %utc-to-tz p=@ta q=@ta ~]
    :-  ~  :-  ~  :-  %noun  !>
    =/  =zid:t   [(slav %p p.pole) q.pole]
    ?.  (~(has by zones) zid)
      ~
    `utc-to-tz:(abed:zn:zon zid)
  ==
::
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
