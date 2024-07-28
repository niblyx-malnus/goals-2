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
        ?.  =(0 n)
          ;<  d=@ud  bind  dit
          $(n (dec n), digits [d digits])
        %-  easy
        %+  roll  (flop digits)
        =|([p=@ q=@] |.((add p (mul 10 q)))) :: code from +bass
      ::
      ++  at-least-dem
        |=  n=@ud
        =|  digits=(list @ud)
        |-
        ?.  =(0 n)
          ;<  d=@ud  bind  dit
          $(n (dec n), digits [d digits])
        ;<  rest=@ud  bind  dem
        %-  easy
        %+  add  rest
        %+  roll  (flop digits)
        =|([p=@ q=@] |.((add p (mul 10 q)))) :: code from +bass
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
    (zfill 2 (numb hours))
    ?:(=(0 minutes) "" ":{(zfill 2 (numb minutes))}")
  ==
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
++  dr-format
  |=  [as=@t d=@dr]
  ^-  tape
  ?+    as  !!
      %'24'
    ?>  (lth d ~d1)
    :: unlike time-input (ISO-8601), no leading hour zero
    ::
    =/  =tape  (numb (div d ~h1))
    =.  d      (mod d ~h1)
    ?:  =(0 d)
      tape
    =.  tape   :(weld tape ":" (zfill 2 (numb (div d ~m1))))
    =.  d      (mod d ~m1)
    ?:  =(0 d)
      tape
    =.  tape  :(weld tape ":" (zfill 2 (numb (div d ~s1))))
    =.  d      (mod d ~s1)
    ?:  =(0 d)
      tape
    :(weld tape "." (zfill 3 (numb (div (mul d 1.000) ~s1))))
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
:: TODO: parse basic (non-extended) format for ISO 8601 (no separators)
:: TODO: implement offset parsing (Z and +-hh:mm)
:: TODO: implement duration parsing (PnYnMnDTnHnMnS)
:: TODO: implement recurring intervals (Rn/PnYnMnDTnHnMnS)
:: TODO: implement start/end, start/duration, duration/end intervals
:: TODO: recurring intervals WITH start or end [of recurrence]
:: (None of the above are valid for any standard HTML inputs)
::
:: TODO: rename cores/gates in line with ISO-8601
::       instead of HTML inputs
::
:: YYYY-MM-DDTHH:MM[:SS[.SSS]]
::
++  datetime-local
  |%
  ++  en
    |=  d=@da
    ^-  tape
    =/  date=tape   (en:date-input [[a y] m d.t]:(yore d))
    =/  clock=tape  (en:time-input `@dr`(mod d ~d1))
    :(weld date "T" clock)
    ::
    ++  de       |=(=@t `@da`(rash t parse))
    ++  de-soft  |=(=@t `(unit @da)`(rush t parse))
    ++  parse
      =,  monadic-parsing
      ;<  [[a=? y=@ud] m=@ud d=@ud]  bind  parse:date-input
      ;<  *                          bind  (just 'T')
      ;<  clock=@dr                  bind  parse:time-input
      =/  d=@da  (year [a y] m d 0 0 0 ~)
      (easy (add d clock))
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
:: YYYY, -YYYY..., +YYYYY...
::
++  year-input
  |%
  ++  en
    |=  [a=? y=@ud]
    ^-  tape
    ?.  a
      ['-' (zfill 4 (numb (dec y)))] :: year 1 BC is year 0 in ISO-8601
    ?:  (lth y 10.000)
      (zfill 4 (numb y))
    ['+' (numb y)]
  ++  de       |=(=@t `[a=? y=@ud]`(rash t parse))
  ++  de-soft  |=(=@t `(unit [a=? y=@ud])`(rush t parse))
  ++  parse
    =,  monadic-parsing
    ;<  is-sign=(unit *)  bind  (peek ;~(pose hep lus))
    ?~  is-sign
      ;<  y=@ud  bind  (exact-dem 4)
      (easy [& y])
    ;<  is-hep=(unit *)  bind  (peek hep)
    ?^  is-hep
      ;<  *      bind  hep
      ;<  y=@ud  bind  (at-least-dem 4)
      (easy [| +(y)])
    ;<  *      bind  lus
    ;<  y=@ud  bind  (at-least-dem 5)
    (easy [& y])
  --
:: YYYY-MM-DD
::
++  date-input
  |%
  ++  en
    |=  [[a=? y=@ud] m=@ud d=@ud]
    ^-  tape
    %+  weld
      (en:year-input a y)
    "-{(zfill 2 (numb m))}-{(zfill 2 (numb d))}"
  ++  de       |=(=@t `[[a=? y=@ud] m=@ud d=@ud]`(rash t parse))
  ++  de-soft  |=(=@t `(unit [[a=? y=@ud] m=@ud d=@ud])`(rush t parse))
  ++  parse
    =,  monadic-parsing
    ;<  [a=? y=@ud]  bind  parse:year-input
    ;<  *            bind  hep
    ;<  m=@ud        bind  (exact-dem 2)
    ;<  *            bind  hep
    ;<  d=@ud        bind  (exact-dem 2)
    (easy [[a y] m d])
  --
:: HH:MM[:SS[.SSS]]
::
++  time-input
  =|  sep=?(%',' %'.')
  =/  places=@ud  3
  |%
  ++  en
    |=  d=@dr
    ^-  tape
    =/  =tape  (weld (zfill 2 (numb (div d ~h1))) ":")
    =.  d      (mod d ~h1)
    =.  tape   (weld tape (zfill 2 (numb (div d ~m1))))
    =.  d      (mod d ~m1)
    ?:  =(0 d)
      tape
    =.  tape  :(weld tape ":" (zfill 2 (numb (div d ~s1))))
    =.  d      (mod d ~s1)
    ?:  =(0 d)
      tape
    ;:  weld
      tape
      (trip sep)
      (zfill places (numb (div (mul d (pow 10 places)) ~s1)))
    ==
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
    ;<  is-sep=(unit *)  bind  (peek ;~(pose dot com))
    ?~  is-sep
      (easy d)
    ;<  *      bind  dot
    ;<  f=@ud  bind  (exact-dem places)
    (easy (add d (div (mul f ~s1) (pow 10 places))))
  --
:: YYYY-MM
::
++  month-input
  |%
  ++  en
    |=  [[a=? y=@ud] m=@ud]
    ^-  tape
    %+  weld
      (en:year-input a y)
    "-{(zfill 2 (numb m))}"
  ++  de       |=(=@t `[[a=? y=@ud] m=@ud]`(rash t parse))
  ++  de-soft  |=(=@t `(unit [[a=? y=@ud] m=@ud])`(rush t parse))
  ++  parse
    =,  monadic-parsing
    ;<  [a=? y=@ud]  bind  parse:year-input
    ;<  *            bind  hep
    ;<  m=@ud        bind  (exact-dem 2)
    (easy [[a y] m])
  --
:: YYYY-Www
::
++  week-input
  |%
  ++  en
    |=  [[a=? y=@ud] w=@ud]
    ^-  tape
    ;:  weld
      (en:year-input a y)
      "-W"
      (zfill 2 (numb w))
    ==
  ++  de       |=(=@t `[[a=? y=@ud] w=@ud]`(rash t parse))
  ++  de-soft  |=(=@t `(unit [[a=? y=@ud] w=@ud])`(rush t parse))
  ++  parse
    =,  monadic-parsing
    ;<  [a=? y=@ud]  bind  parse:year-input
    ;<  *            bind  ;~(plug hep (just 'W'))
    ;<  w=@ud        bind  (exact-dem 2)
    (easy [[a y] w])
  --
:: YYYY-Www-D
::
++  week-date
  |%
  ++  en
    |=  [[a=? y=@ud] w=@ud d=@ud]
    ^-  tape
    ;:  weld
      (en:week-input [a y] w)
      "-"
      (numb +(d)) :: d is 0-indexed on Urbit
    ==
  ++  de       |=(=@t `[[a=? y=@ud] w=@ud d=@ud]`(rash t parse))
  ++  de-soft  |=(=@t `(unit [[a=? y=@ud] w=@ud d=@ud])`(rush t parse))
  ++  parse
    =,  monadic-parsing
    ;<  [[a=? y=@ud] w=@ud]  bind  parse:week-input
    ;<  *                    bind  hep
    ;<  d=@ud                bind  (exact-dem 1)
    (easy [[a y] w (dec d)]) :: d is 0-indexed on Urbit
  --
:: YYYY-DDD
::
++  ordinal-date
  |%
  ++  en
    |=  [[a=? y=@ud] n=@ud]
    ^-  tape
    ;:  weld
      (en:year-input a y)
      "-"
      (zfill 3 (numb n))
    ==
  ++  de       |=(=@t `[[a=? y=@ud] n=@ud]`(rash t parse))
  ++  de-soft  |=(=@t `(unit [[a=? y=@ud] n=@ud])`(rush t parse))
  ++  parse
    =,  monadic-parsing
    ;<  [a=? y=@ud]  bind  parse:year-input
    ;<  *            bind  hep
    ;<  n=@ud        bind  (exact-dem 3)
    (easy [[a y] n])
  --
--
