/+  tu=time-utils, *numb
/~  files  wain  /lib/pytz
=>  |%
    +$  rule  [offset=delta:tu name=@t]
    +$  zone  ((mop @da rule) lth)
    ++  zon   ((on @da rule) lth)
    :: version of pytz python library used to generate dataset
    ::
    ++  version  `@t`(snag 0 (~(got by files) %version))
    ::
    ++  to-filename
      |=  n=@t
      ^-  term
      =/  name=tape  (cass (trip n))
      %+  rap  3
      |-
      ?~  name
        ~
      :_  $(name t.name)
      ?+  i.name  i.name
        %'/'  '-'
        %'_'  '-'
        %'+'  '--'
      ==
    ::
    ++  parse-zone-rows
      |=  rows=wain
      ^-  (list [@da rule])
      ?>  ?=(^ rows)
      ?>  =('Time,Offset,Name' i.rows)
      =/  contents=wain  t.rows
      |-
      ?~  contents
        ~
      :-  (rash i.contents parse-zone-row)
      $(contents t.contents)
    ::
    ++  parse-zone-row
      =,  monadic-parsing:tu
      ;<  jump=@da   bind  parse:datetime-local:tu
      ;<  *          bind  com
      ;<  =delta:tu  bind  parse:offset:tu
      ;<  *          bind  com
      ;<  name=@t    bind  (cook crip (star prn))
      (easy [jump delta name])
    --
::
=/  names=(list @t)  (~(got by files) %names)
=/  zones=(map @t zone)
  %-  ~(gas by *(map @t zone))
  =/  idx=@ud  1
  =/  total=@ud  (lent names)
  ^-  (list [@t zone])
  |-
  ?~  names
    ~
  ~&  >>  "loading timezone [{(numb idx)}/{(numb total)}]: {(trip i.names)}"
  :_  $(idx +(idx), names t.names)
  :-  i.names
  %+  gas:zon  *zone
  %-  parse-zone-rows
  %-  ~(got by files)
  (to-filename i.names)
|%
++  zn
  |_  name=@t
  ++  zone   (~(got by zones) name)
  ::
  ++  active-rule
    |=  utc-time=@da
    ^-  (unit [@da rule])
    (ram:zon (lot:zon zone ~ `utc-time))
  ::
  ++  active-offset
    |=  utc-time=@da
    ^-  (unit delta:tu)
    (bind (active-rule utc-time) (cork tail head))
  :: set of all offsets in the timezone
  ::
  ++  offsets
    ^-  (set delta:tu)
    %-  ~(gas in *(set delta:tu))
    %+  turn  (tap:zon zone)
    (cork tail head)
  ::
  ++  utc-to-tz
    ^-  utc-to-tz:tu
    |=  utc-time=@da
    ^-  (unit dext:tu)
    ?~  off=(active-offset utc-time)
      ~
    =/  tz-time=@da  (apply-delta:tu utc-time u.off)
    :: is this the first or second occurence of this tz-time?
    ::
    =/  times=(list @da)  (tz-to-utc-list tz-time)
    ?~  idx=(find [utc-time]~ times)
      ~
    [~ u.idx tz-time]
  ::
  ++  tz-to-utc
    ^-  tz-to-utc:tu
    |=  =dext:tu
    ^-  (unit @da)
    :: generate all possible times
    ::
    =/  times=(list @da)  (tz-to-utc-list d.dext)
    :: return the time at the requested index
    ::
    ?:  (lte (lent times) i.dext)
      ~
    [~ (snag i.dext times)]
  :: time ordered list of valid candidates
  ::
  ++  tz-to-utc-list
    ^-  tz-to-utc-list:tu
    |=  tz-time=@da
    ^-  (list @da)
    |^
    (sort candidates lth)
    :: invert this time for all offsets of the timezone
    ::
    ++  candidates
      ^-  (list @da)
      %+  murn  ~(tap in offsets)
      |=  offset=delta:tu
      ^-  (unit @da)
      =/  utc-candidate=@da  (apply-invert-delta:tu tz-time offset)
      ?.  (validate utc-candidate offset)
        ~
      [~ utc-candidate]
    :: check whether a candidate could have been validly
    :: generated by the given offset
    ::
    ++  validate
      |=  [utc-time=@da offset=delta:tu]
      ^-  ?
      ?~  off=(active-offset utc-time)
        %.n
      =(offset u.off)
    --
  ::
  ++  localize
    |=  utc-time=@da
    ^-  @da
    (tail (need (utc-to-tz utc-time)))
  ::
  ++  localize-soft
    |=  utc-time=@da
    ^-  (unit @da)
    (bind (utc-to-tz utc-time) tail)
  ::
  ++  universalize
    =|  idx=@ud
    |=  tz-time=@da
    ^-  @da
    (need (tz-to-utc idx tz-time))
  ::
  ++  universalize-soft
    =|  idx=@ud
    |=  tz-time=@da
    ^-  (unit @da)
    (tz-to-utc idx tz-time)
  --
--
