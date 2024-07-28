=>  |%
    +$  delta  [sign=? d=@dr]
    ++  numb :: adapted from numb:enjs:format
      |=  a=@u
      ^-  tape
      ?:  =(0 a)  "0"
      %-  flop
      |-  ^-  tape
      ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))])
    ::
    ++  zfill
      |=  [w=@ud t=tape]
      ^-  tape
      ?:  (lte w (lent t))
        t
      $(t ['0' t])
    ::
    ++  monadic-parsing
      |%
      :: parser bind
      ::
      ++  bind  
        |*  =mold
        |*  [sef=rule gat=$-(mold rule)]
        |=  tub=nail
        =/  vex  (sef tub)
        ?~  q.vex  vex
        ((gat p.u.q.vex) q.u.q.vex)
      :: lookahead arbitrary rule
      ::
      ++  peek
        |*  sef=rule
        |=  tub=nail
        =+  vex=(sef tub)
        ?~  q.vex
          [p=p.vex q=[~ u=[p=~ q=tub]]]
        [p=p.vex q=[~ u=[p=[~ p.u.q.vex] q=tub]]]
      ::
      ++  exact-dem
        |=  n=@ud
        =|  digits=(list @ud)
        |-
        ?:  =(0 n)
          %-  easy
          %+  roll  (flop digits)
          =|([p=@ q=@] |.((add p (mul 10 q)))) :: code from +bass
        ;<  d=@ud  bind  dit
        $(n (dec n), digits [d digits])
      --
    --
|%
++  print-utc-offset
  |=  offset=delta
  ^-  tape
  =/  hours=@ud    (div (mod d.offset ~d1) ~h1)
  =/  minutes=@ud  (div (mod d.offset ~h1) ~m1)
  ;:  weld
    ?:(sign.offset "+" "-")
    (zfill 2 (scow %ud hours))
    ?:(=(0 minutes) "" ":{(zfill 2 (scow %ud minutes))}")
  ==
::
++  timespan-description
  |=  [a=? d=@dr]
  ^-  tape
  =;  time=tape
    "{time} {?.(a "ago" "from now")}"
  ?:  (lth d ~s45)
    "a few seconds"
  ?:  (lth d ~m1.s30)
    "a minute"
  ?:  (lth d ~m45)
    "{(numb (div (add d ~s30) ~m1))} minutes"
  ?:  (lth d ~h1.m30)
    "an hour"
  ?:  (lth d ~h21)
    "{(numb (div (add d ~m30) ~h1))} hours"
  ?:  (lth d ~d1.h11)
    "a day"
  ?:  (lth d ~d25)
    "{(numb (div (add d ~h12) ~d1))} days"
  ?:  (lth d ~d45)
    "a month"
  ?:  (lth d ~d320)
    "{(numb (div (add d ~d15) ~d30))} days"
  ?:  (lth d ~d548)
    "a year"
  "{(numb (div (add d ~d182.h15) ~d365.h6))} days"
::
++  utc-relative-name
  |=  =delta
  ^-  tape
  ?:  =(0 d.delta)
    "UTC"
  =/  hours=@ud    (div (mod d.delta ~d1) ~h1)
  =/  minutes=@ud  (div (mod d.delta ~h1) ~m1)
  =/  start=tape  [?:(sign.delta '+' '-') (zfill 2 (numb hours))]
  ?:  =(0 minutes)
    start
  :(weld start ":" (zfill 2 (numb minutes)))
:: TODO: parse basic (non-extended) format for ISO 8601 (no separators)
:: TODO: implement ordinal date parsing (YYYY-DDD)
:: TODO: implement week date parsing (YYYY-Www-D)
:: TODO: implement offset parsing (Z and +-hh:mm)
:: TODO: implement duration parsing (PnYnMnDTnHnMnS)
:: TODO: implement recurring intervals (Rn/PnYnMnDTnHnMnS)
:: TODO: implement start/end, start/duration, duration/end intervals
:: TODO: recurring intervals WITH start or end [of recurrence]
:: (None of the above are valid for any standard HTML inputs)
::
:: TODO: separate into an ISO 8601 library
:: TODO: make sure to handle 24:00 as 00:00 of the next day
:: TODO: a comma is a valid fractional separator in the HH:MM... portion
:: TODO: parameterize number of decimal places (datetime-local uses 3)
:: TODO: datetime-local should reuse code from date and time parsers
::
:: YYYY-MM-DDTHH:MM[:SS[.SSS]]
::
++  datetime-local
|%
++  en
  |=  d=@da
  ^-  tape
  =+  (yore d)
  =/  =tape
  ;:  weld
  (numb y)
  "-"
  (zfill 2 (scow %ud m))
  "-"
  (zfill 2 (scow %ud d.t))
  "T"
  ==
  =.  d     (mod d ~d1)
  =.  tape  :(weld tape (zfill 2 (scow %ud (div d ~h1))) ":")
  =.  d     (mod d ~h1)
  =.  tape  (weld tape (zfill 2 (scow %ud (div d ~m1))))
  =.  d     (mod d ~m1)
  ?:  =(0 d)
  tape
  =.  tape  :(weld tape ":" (zfill 2 (scow %ud (div d ~s1))))
  =.  d     (mod d ~s1)
  ?:  =(0 d)
  tape
  :(weld tape "." (zfill 3 (scow %ud (div (mul d 1.000) ~s1))))
  ++  de       |=(=@t `@da`(rash t parse))
  ++  de-soft  |=(=@t `(unit @da)`(rush t parse))
  ++  parse
    =,  monadic-parsing
    ;<  y=@ud   bind  (exact-dem 4)
    ;<  *       bind  hep
    ;<  mo=@ud  bind  (exact-dem 2)
    ;<  *       bind  hep
    ;<  d=@ud   bind  (exact-dem 2)
    ;<  *       bind  (just 'T')
    ;<  h=@ud   bind  (exact-dem 2)
    ;<  *       bind  col
    ;<  mi=@ud  bind  (exact-dem 2)
    =/  d=@da   (year [& y] mo d h mi 0 ~)
    ;<  is-col=(unit *)  bind  (peek col)
    ?~  is-col
      (easy d)
    ;<  *      bind  col
    ;<  s=@ud  bind  (exact-dem 2)
    =.  d      (add d (mul s ~s1))
    ;<  is-dot=(unit *)  bind  (peek dot)
    ?~  is-dot
      (easy d)
    ;<  *      bind  dot
    ;<  f=@ud  bind  (exact-dem 3)
    (easy (add d (div (mul f ~s1) 1.000)))
  --
::
++  offset
  |%
  ++  en
    |=  =delta
    ^-  @t
    ~?  >>  (gth (mod d.delta ~m1) 0)
      "granularity exceeds minute scale"
    %+  rap  3
    :~  ?:(sign.delta '+' '-')
        (crip (zfill 2 (numb (div d.delta ~h1))))
        ':'
        (crip (zfill 2 (numb (div (mod d.delta ~h1) ~m1))))
    ==

  ++  de       |=(=@t `delta`(rash t parse))
  ++  de-soft  |=(=@t `(unit delta)`(rush t parse))
  ++  parse
    =,  monadic-parsing
    ;<  sign=?  bind  (cook |=(=@t =(t '+')) ;~(pose lus hep))
    ;<  h=@ud   bind  (exact-dem 2)
    ;<  *       bind  col
    ;<  m=@ud   bind  (exact-dem 2)
    (easy `delta`[sign (add (mul h ~h1) (mul m ~m1))])
  --
:: YYYY-MM-DD
::
++  date-input
  |%
  ++  en
    |=  [y=@ud m=@ud d=@ud]
    ^-  tape
    "{(numb y)}-{(zfill 2 (numb m))}-{(zfill 2 (numb d))}"
  ++  de       |=(=@t `[y=@ud m=@ud d=@ud]`(rash t parse))
  ++  de-soft  |=(=@t `(unit [y=@ud m=@ud d=@ud])`(rush t parse))
  ++  parse
    =,  monadic-parsing
    ;<  y=@ud  bind  (exact-dem 4)
    ;<  *      bind  hep
    ;<  m=@ud  bind  (exact-dem 2)
    ;<  *      bind  hep
    ;<  d=@ud  bind  (exact-dem 2)
    (easy [y m d])
  --
::
++  dr-format
  |=  [as=@t d=@dr]
  ^-  tape
  ?+    as  !!
      %'24'
    ?>  (lth d ~d1)
    :: unlike time-input (ISO-8601), no leading hour zero
    ::
    =/  =tape  (scow %ud (div d ~h1))
    =.  d      (mod d ~h1)
    ?:  =(0 d)
      tape
    =.  tape   :(weld tape ":" (zfill 2 (scow %ud (div d ~m1))))
    =.  d      (mod d ~m1)
    ?:  =(0 d)
      tape
    =.  tape  :(weld tape ":" (zfill 2 (scow %ud (div d ~s1))))
    =.  d      (mod d ~s1)
    ?:  =(0 d)
      tape
    :(weld tape "." (zfill 3 (scow %ud (div (mul d 1.000) ~s1))))
    ::
      %'12'
    ?:  (lth d ~h1)
      "{(dr-format '24' (add d ~h12))}am"
    ?:  (lth d ~h12)
      "{(dr-format '24' d)}am"
    ?:  (lth d ~h13)
      "{(dr-format '24' d)}pm"
    "{(dr-format '24' (sub d ~h12))}pm"
  ==
:: HH:MM[:SS[.SSS]]
::
++  time-input
  |%
  ++  en
    |=  d=@dr
    ^-  tape
    ?>  (lth d ~d1)
    =/  =tape  (weld (zfill 2 (scow %ud (div d ~h1))) ":")
    =.  d      (mod d ~h1)
    =.  tape   (weld tape (zfill 2 (scow %ud (div d ~m1))))
    =.  d      (mod d ~m1)
    ?:  =(0 d)
      tape
    =.  tape  :(weld tape ":" (zfill 2 (scow %ud (div d ~s1))))
    =.  d      (mod d ~s1)
    ?:  =(0 d)
      tape
    :(weld tape "." (zfill 3 (scow %ud (div (mul d 1.000) ~s1))))
  ++  de       |=(=@t `@dr`(rash t parse))
  ++  de-soft  |=(=@t `(unit @dr)`(rush t parse))
  ++  parse
    =,  monadic-parsing
    ;<  h=@ud  bind  (exact-dem 2)
    ;<  *      bind  col
    ;<  m=@ud  bind  (exact-dem 2)
    =/  d=@dr  (add (mul h ~h1) (mul m ~m1))
    ;<  is-col=(unit *)  bind  (peek col)
    ?~  is-col
      (easy d)
    ;<  *      bind  col
    ;<  s=@ud  bind  (exact-dem 2)
    =.  d      (add d (mul s ~s1))
    ;<  is-dot=(unit *)  bind  (peek dot)
    ?~  is-dot
      (easy d)
    ;<  *      bind  dot
    ;<  f=@ud  bind  (exact-dem 3)
    (easy (add d (div (mul f ~s1) 1.000)))
  --
:: YYYY-MM
::
++  month-input
  |%
  ++  en
    |=  [y=@ud m=@ud]
    ^-  tape
    "{(numb y)}-{(zfill 2 (numb m))}"
  ++  de       |=(=@t `[y=@ud m=@ud]`(rash t parse))
  ++  de-soft  |=(=@t `(unit [y=@ud m=@ud])`(rush t parse))
  ++  parse
    =,  monadic-parsing
    ;<  y=@ud  bind  dem
    ;<  *      bind  hep
    ;<  m=@ud  bind  dem
    (easy [y m])
  --
::
++  week-input
  |%
  ++  en
    |=  [y=@ud w=@ud]
    ^-  tape
    ;:  weld
      (numb y)
      "-W"
      (zfill 2 (scow %ud w))
    ==
  ++  de       |=(=@t `[y=@ud w=@ud]`(rash t parse))
  ++  de-soft  |=(=@t `(unit [y=@ud w=@ud])`(rush t parse))
  ++  parse
    =,  monadic-parsing
    ;<  y=@ud  bind  dem
    ;<  *      bind  ;~(plug hep (just 'W'))
    ;<  w=@ud  bind  dem
    (easy [y w])
  --
--
