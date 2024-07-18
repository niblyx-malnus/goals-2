/-  t=timezones, r=rules, iana
/+  tlib=timezones, tu=time-utils
|_  $:  =bowl:gall
        [=zones:iana =rules:iana =links:iana]
        to-to-jumps=(map rid:r to-to-jump:r)
    ==
+*  n  ~(. tlib [~ to-to-jumps])
:: A $raw-rule is simply a IANA rule represented as its own
:: timezone using our own $zone format. This is done because
:: these rules are used separately in the generation of many
:: different timezones and in principle the underlying offsets
:: for actual instantiations of a given rule in two different
:: timezones could be different.
:: In a $raw-rule, several things are left incomplete as these
:: depend on the zone context:
:: 1. The name of the rule is not finalized.
:: 2. The rule's offset from UTC is not finalized
::    (it contains what may be a relative offset; but not necessarily
::    relative to UTC).
:: 3. The actual time of the "jumps" to and from daylight savings time
::    (give or take on the order of 24 hours) are not finalized
::    (as these are defined in the context of the zone offset).
::
+$  raw-rule   zone:t
+$  raw-rules  (map zid:t zone:t)
:: Parameters for an Urbit-native jump rule
::
+$  tz-rule-parms
  $:  =tid:t
      dom=[l=@ud r=@ud]
      name=@t
      offset=delta:tu
      =rid:r
      =args:r
  ==
:: Initialize all the existing iana rules as "raw rule" zones
:: Each IANA "rule" can be interpreted as its own timezone
::
++  all-raw-rules
  ~+  ^-  raw-rules
  %-  ~(gas by *(map zid:t zone:t))
  %+  turn  ~(val by rules)
  iana-rule-to-raw-rule
:: A "raw rule" is a rule which has not been updated with the zone
:: offset yet...
::
++  iana-rule-to-raw-rule
  |=  =rule:iana
  ^-  [zid:t zone:t]
  =/  =zid:t
    [our.bowl (cat 3 'iana_raw-rule_' (sane-ta-iana-name name.rule))]
  ~&  [%making-raw-rule zid]
  =|  =zone:t
  =.  name.zone  name.rule
  =/  rules
    %-  zing
    %+  turn  ~(tap in entries.rule)
    rule-entry-to-tz-rule-parms
  [zid (create-rules-in-zone zone rules)]
:: Given a rule entry, get the parameters for creating a
:: "rule" of our explicit instance-based kind.
:: Add one rule for each year so that specific
:: utc/standard/wallclock jump time is handled for each instance
::
++  rule-entry-to-tz-rule-parms
  |=  re=rule-entry:iana
  ^-  (list tz-rule-parms)
  =/  name=@t          letter.re :: This name will be fixed in a later pass...
  =/  offset=delta:tu  save.re   :: This will be updated in a later pass...
  =/  [=rid:r =args:r]  (rule-entry-to-rid-args re)
  =/  num=@ud
    ?-  -.to.re
      %year  (sub y.to.re from.re)
      %only  0
      %max   100 :: only 100 iterations if it goes into present time
    ==
  :: Return rule creation parms one for each year of this rule-entry
  |-
  =.  args  (~(put by args) 'Start Year' ud+(add from.re num))
  :-  [(scot %uv (sham [re num])) [0 0] name offset rid args]
  ?:  =(0 num)  ~
  $(num (dec num))
:: Given a rule entry, get a first pass at the rule parameters
::
++  rule-entry-to-rid-args
  |=  rule-entry:iana
  ^-  [rid:r args:r]
  ?-    -.on
      %int
    :-  [~ %jump %yearly-nth-weekday-of-month-0]
    %-  ~(gas by *args:r)
    :~  ['Start Year' ud+from]
        ['Month' ud+(mnt-to-num:tu in)]
        ['Ordinal' od+ord.on]
        ['Weekday' ud+(wkd-to-num:tu wkd.on)]
        ['Time' dr+q.at]
        ['Offset' dl+*delta:tu] :: This is updated in a later pass...
    ==
    ::
      %aft
    :-  [~ %jump %yearly-first-weekday-after-date-0]
    %-  ~(gas by *args:r)
    :~  ['Start Year' ud+from]
        ['Month' ud+(mnt-to-num:tu in)]
        ['Day' ud+d.on]
        ['Weekday' ud+(wkd-to-num:tu wkd.on)]
        ['Time' dr+q.at]
        ['Offset' dl+*delta:tu] :: This is updated in a later pass...
    ==
    ::
      %dat
    :-  [~ %jump %yearly-on-date-0]
    %-  ~(gas by *args:r)
    :~  ['Start Year' ud+from]
        ['Month' ud+(mnt-to-num:tu in)]
        ['Day' ud+d.on]
        ['Time' dr+q.at]
        ['Offset' dl+*delta:tu] :: This is updated in a later pass...
    ==
  ==
:: Create rules in a zone based on given parameters...
::
++  create-rules-in-zone
  |=  [=zone:t rules=(list tz-rule-parms)]
  ^-  zone:t
  =/  core  ~(. zn:n zone)
  |-
  ?~  rules
    zon:abet:core
  %=  $
    rules  t.rules
    core   (create-rule:core i.rules)
  ==
:: Use this to reference already-created rules
::
++  get-rule-entry-tids
  |=  re=rule-entry:iana
  ^-  (list tid:t)
  =/  num=@ud
    ?-  -.to.re
      %year  (sub y.to.re from.re)
      %only  0
      %max   100 :: only 100 iterations if it goes into present time
    ==
  |-
  :-  (scot %uv (sham [re num]))
  ?:  =(0 num)
    ~
  $(num (dec num))
:: all lowercase; fas replaced by cab
::
++  sane-ta-iana-name
  |=  =@t
  ^-  @ta
  =-  ?>(((sane %ta) -) -)
  %-  crip
  %+  turn  (cass (trip t))
  |=(=@t ?.(=('/' t) t '_'))
:: Correct a iana rule name based on a iana zone name
::
++  new-rule-name
  |=  [=tz-rule:t format=@t]
  ^-  @t
  ?:  =('%z' format)
    (crip (utc-relative-name:tu offset.tz-rule))
  =/  name=tape  (trip format)
  =/  s  (find "%s" name)
  ?:  ?=(^ s)
    %-  crip
    ;:  weld
      (scag u.s name)
      ?:(=('-' name.tz-rule) "" (trip name.tz-rule))
      (slag (add u.s 2) name)
    ==
  =/  f  (find "/" name)
  ?:  ?=(^ f)
    ?:  =([& ~s0] offset.tz-rule)
      (crip (scag u.f name))
    (crip (slag +(u.f) name))
  ?.  |(=('-' name.tz-rule) =('' name.tz-rule))
    name.tz-rule
  (crip name)
:: based on raw-rule and zone offset, get the properly adjusted
:: rule (where the offset is ABSOLUTE relative to UTC)
::
++  raw-rule-zone-adjust-offset
  |=  [offset=delta:tu =rule:iana =zone:t]
  ^-  zone:t
  =/  old   ~(. zn:n zone)
  =/  core  ~(. zn:n zone)
  =/  rules=(list rule-entry:iana)  ~(tap in entries.rule)
  |-
  ?~  rules
    zon:abet:core
  =/  tids=(list tid:t)  (get-rule-entry-tids i.rules)
  |-
  ?~  tids  ^$(rules t.rules)
  =/  =tz-rule:t  (~(got by rules.zone) i.tids)
  :: update offset according to zone
  ::
  =/  new-offset=delta:tu  (compose-deltas:tu offset offset.tz-rule)
  =.  core  (update-rule:core i.tids [%offset new-offset]~)
  :: update args according to zone offset
  ::
  =/  [=rid:r =args:r]  rule.tz-rule
  =/  offset-arg=delta:tu
    ?-    p.at.i.rules
      %utc       *delta:tu
      %standard  offset
      ::
        %wallclock
      :: get only instance of the rule
      ::
      =/  jmp=jump-instance:r
        (~(got by instances.tz-rule) l.dom.tz-rule)
      ?.  ?=(%& -.jmp)
        +:;;($>(%dl arg:tu) (~(got by args) 'Offset'))
      :: get previous offset
      ::
      ?~  pof=(~(pof or:old order.zone) p.jmp)
        offset
      (compose-deltas:tu offset u.pof)
    ==
  =.  args  (~(put by args) 'Offset' dl+offset-arg)
  $(tids t.tids, core (update-rule-args:core i.tids rid args))
:: based on all raw rules, a rule name and the zone offset
:: get the properly adjusted rule
:: (where the offset is ABSOLUTE relative to UTC)
::
++  get-finalized-rule
  |=  [name=@t stdoff=delta:tu]
  ^-  zone:t
  =/  rule-id=zid:t  [our.bowl (rap 3 'iana_raw-rule_' (sane-ta-iana-name name) ~)]
  =/  rule=zone:t    (~(got by all-raw-rules) rule-id)
  =/  old=rule:iana  (~(got by rules) name)
  :: adjust offset with zone offset
  ::
  (raw-rule-zone-adjust-offset stdoff old rule)
:: convert a iana zone to our zone format
::
++  iana-zone-to-tz-zone
  |=  [name=@t z=zone:iana]
  ^-  [zid:t zone:t]
  |^
  =/  =zid:t  [our.bowl (rap 3 'iana_' (sane-ta-iana-name name) ~)]
  ~&  [%converting zid]
  =|  =zone:t
  =.  name.zone  name.z
  =/  entries=(list zone-entry:iana)  (flop entries.z)
  =|  last=(unit @da)
  =|  next=(unit @da)
  |-
  ?~  entries
    [zid zone]
  =.  next  (get-next i.entries)
  :: Add a single rule which jumps at the beginning of the zone's rules
  ::
  =/  start=tz-rule-parms  (get-start last next i.entries)
  :: Add overlapping rules if they exist
  ::
  =/  rules=(list tz-rule-parms)  (get-clipped-rules last next i.entries)
  :: Create rules and iterate
  ::
  %=  $
    last     next
    entries  t.entries
    zone     (create-rules-in-zone zone [start rules])
  ==
  ::
  ++  get-next
    |=  entry=zone-entry:iana
    ^-  (unit @da)
    ?~  until.entry
      ~
    ?-    p.u.until.entry
      %utc  `q.u.until.entry
      %standard  `(apply-invert-delta:tu q.u.until.entry stdoff.entry)
        %wallclock
      ?-    -.rules.entry
        %nothing  `(apply-invert-delta:tu q.u.until.entry stdoff.entry)
          %delta
        =/  offset=delta:tu  (compose-deltas:tu [stdoff delta.rules]:entry)
        `(apply-invert-delta:tu q.u.until.entry offset)
          %rule
        =/  rule=zone:t
          ~+((get-finalized-rule name.rules.entry stdoff.entry))
        =/  core  ~(. zn:n rule)
        ?^  pof=(~(pof or:core order.rule) q.u.until.entry)
          `(apply-invert-delta:tu q.u.until.entry u.pof)
        `(apply-invert-delta:tu q.u.until.entry stdoff.entry)
      ==
    ==
  ::
  ++  get-start
    |=  [last=(unit @da) next=(unit @da) entry=zone-entry:iana]
    ^-  tz-rule-parms
    :: if last is null, we are at the very beginning of the
    :: timezone, give default beginning of Jan 1, 1800
    :: (unless the next one is smaller than that)
    ::
    =/  =time  (fall last ?~(next ~1800.1.1 (min ~1800.1.1 u.next)))
    =/  offset=delta:tu
      ?-    -.rules.entry
        %nothing  stdoff.entry
        %delta    (compose-deltas:tu [stdoff delta.rules]:entry)
          %rule
        =/  rule=zone:t
          ~+((get-finalized-rule name.rules.entry stdoff.entry))
        =/  core  ~(. zn:n rule)
        ?^  pof=(~(pof or:core order.rule) time)
          u.pof
        stdoff.entry
      ==
    :: Name the start rule
    ::
    =/  name=@t
      ?-    -.rules.entry
        ?(%nothing %delta)  (crip (utc-relative-name:tu offset))
          %rule
        =/  rule=zone:t
          ~+((get-finalized-rule name.rules.entry stdoff.entry))
        =/  core  ~(. zn:n rule)
        ?^  pul=(~(pul or:core order.rule) time)
          name.rule:u.pul
        (crip (utc-relative-name:tu offset))
      ==
    :: Return tz-rule-parms
    ::
    :*  (scot %uv (sham [last eny.bowl])) :: need a unique tid
        [0 0]  name  offset
        [~ %jump %single-0]
        (~(put by *args:r) 'Time' da+time)
    ==
  ::
  ++  get-clipped-rules
    |=  [last=(unit @da) next=(unit @da) entry=zone-entry:iana]
    ^-  (list tz-rule-parms)
    ?.  ?=(%rule -.rules.entry)
      ~
    =/  rule=zone:t
      ~+((get-finalized-rule name.rules.entry stdoff.entry))
    =/  core  ~(. zn:n rule)
    %+  turn  ~(tap by rules:zon:abet:(clip-rules:core last next))
    |=  [=tid:t =tz-rule:t]
    =.  name.tz-rule  (new-rule-name tz-rule format.entry)
    [tid [dom name offset rid.rule args.rule]:tz-rule]
  --
:: Initialize rules to "raw rules" and convert all zones
::
++  convert-iana-zones-new
  ^-  (map zid:t zone:t)
  %-  ~(gas by *(map zid:t zone:t))
  %+  turn  ~(tap by zones)
  |=  [name=@t =zone:iana]
  (iana-zone-to-tz-zone name zone)
--
