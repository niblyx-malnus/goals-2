/+  *numb
|%
:: optional date
::
+$  moment  (unit @da)
:: ordinal numbers for weekday in a month
::
+$  ord  ?(%first %second %third %fourth %last)
:: days of the week
::
+$  wkd      ?(%mon %tue %wed %thu %fri %sat %sun)
+$  wkd-num  ?(%0 %1 %2 %3 %4 %5 %6)
:: months of year
::
+$  mnt      ?(%jan %feb %mar %apr %may %jun %jul %aug %sep %oct %nov %dec)
+$  mnt-num  ?(%1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12)
::
+$  dext     [i=@ud d=@da] :: indexed time
+$  delta    [sign=? d=@dr] :: positive or negative offset
::
+$  localtime  [tz=@t dext]
:: types for basic timezone functions
::
+$  tz-to-utc-list  $-(@da (list @da))
+$  tz-to-utc       $-(dext (unit @da))
+$  utc-to-tz       $-(@da (unit dext))
::
+$  span     [l=@da r=@da] :: UTC datetime pair
+$  fullday  @da           :: must be divisible by ~d1
+$  jump     @da
:: CALENDAR rule; NOT TIMEZONE rule
::
+$  rule-exception
  $%  [%skip ~]
      [%rule-error msg=@t]
  ==
:: Should never abandon support for any of these...
:: If need to update an arg, add a version like %ud-1...
::
+$  arg
  $%  [%ud p=@ud]                 :: natural number (unsigned decimal)
      [%od p=ord]                 :: ordinal numbers for weekday in a month
      [%da p=@da]                 :: datetime-local
      [%dr p=@dr]                 :: duration (?)
      [%dl p=delta]               :: delta (signed @dr)
      [%dx p=dext]                :: indexed datetime
      [%wd p=wkd]                 :: weekday
      [%wl p=(list wkd)]          :: weekday list
      [%dt p=[y=@ud m=@ud d=@ud]] :: date-input
      [%ct p=@dr]                 :: clocktime / time-input
      [%mt p=[y=@ud m=@ud]]       :: month-input
      [%wk p=[y=@ud w=@ud]]       :: week-input
  ==
::
++  wkd-to-num
  |=(=wkd `wkd-num`?-(wkd %mon %0, %tue %1, %wed %2, %thu %3, %fri %4, %sat %5, %sun %6))
::
++  mnt-to-num
  |=  =mnt
  ^-  @ud
  ?-  mnt
    %jan  1
    %feb  2
    %mar  3
    %apr  4
    %may  5
    %jun  6
    %jul  7
    %aug  8
    %sep  9
    %oct  10
    %nov  11
    %dec  12
  ==
::
++  num-to-wkd
  |=  num=@ud
  ^-  wkd
  ?:  =(0 num)  %mon
  ?:  =(1 num)  %tue
  ?:  =(2 num)  %wed
  ?:  =(3 num)  %thu
  ?:  =(4 num)  %fri
  ?:  =(5 num)  %sat
  ?:  =(6 num)  %sun
  !!
::
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
:: ~2000.1.1 was a saturday
:: 0, 1, 2, 3, 4, 5, 6
:: m, t, w, t, f, s, s
::
++  get-weekday
  |=  d=@da
  ;;  wkd-num
  %-  (curr mod 7)  %+  add  5  :: center on saturday
  ?:  (gth d ~2000.1.1)
    (mod (div (sub d ~2000.1.1) ~d1) 7)
  (sub 7 (mod +((div (sub ~2000.1.1 d) ~d1)) 7))
::
++  get-prev-monday  |=(d=@da (sub d (mul ~d1 (get-weekday d))))
++  get-next-monday
  |=  d=@da
  %+  add  d
  %+  mul  ~d1
  =/  w=@  (get-weekday d)
  ?:(=(0 w) 7 w)
::
++  days-in-month
  |=  [[a=? y=@ud] m=@ud]
  :: m is in range 1-12 (not zero-indexed)
  ::
  ?>  &((gte m 1) (lte m 12))
  `@ud`(snag (dec m) ?:((yelp y) moy:yo moh:yo))
::
++  days-left-in-year
  |=  =time
  ^-  @ud
  (div (sub (year [a +(y)]:(yore time) 1 1 0 0 0 ~) time) ~d1)
::
++  is-leap-year  yelp
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
++  sub-wkd
  |=  [a=@ud b=@ud]
  ^-  @ud
  ?>  &((lth a 7) (lth b 7))
  ?:  (gte a b)  (sub a b)
  (add a (sub 7 b))
::
++  btwn
  |=  [=@da s=moment e=moment]
  ^-  ?
  ?&  ?~(e & (lth da u.e))
      ?~(s & (gte da u.s))
  ==
::
++  sane-fd  |=(fd=@da ~|(%insane-fullday ?>(=(0 (mod fd ~d1)) fd)))
::
++  apply-delta
  |=  [=time =delta]
  ^-  ^time
  ~?  (gth d.delta ~d1)  [%delta-more-than-day d.delta]
  (?:(sign.delta add sub) time d.delta)
::
++  invert-delta  |=(=delta delta(sign !sign.delta))
::
++  apply-invert-delta
  |=  [=time =delta]
  ^-  ^time
  (apply-delta time (invert-delta delta))
::
++  compose-deltas
  |=  [a=delta b=delta]
  ^-  delta
  ?:  =(sign.a sign.b)
    [sign.a (add d.a d.b)]
  ?:  (gte d.a d.b)
    [sign.a (sub d.a d.b)]
  [sign.b (sub d.b d.a)]
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
  :: check if done
  ::
  ++  done
    |=  tub=nail
    ^-  (like ?)
    ?~  q.tub
      [p.tub ~ %.y tub]
    [p.tub ~ %.n tub]
  :: lookahead arbitrary rule
  ::
  ++  peek
    |*  sef=rule
    |=  tub=nail
    =+  vex=(sef tub)
    ?~  q.vex
      [p=p.vex q=[~ u=[p=~ q=tub]]]
    [p=p.vex q=[~ u=[p=[~ p.u.q.vex] q=tub]]]
  --
::
++  exact-dem
|=  n=@ud
=,  monadic-parsing
=|  digits=(list @ud)
|-
?:  =(0 n)
  :: code from +bass
  ::
  (easy (roll (flop digits) =|([p=@ q=@] |.((add p (mul 10 q))))))
;<  d=@ud  bind  dit
$(n (dec n), digits [d digits])
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
    ;<  y=@ud   bind  dem
    ;<  *       bind  hep
    ;<  mo=@ud  bind  dem
    ;<  *       bind  hep
    ;<  d=@ud   bind  dem
    ;<  *       bind  (just 'T')
    ;<  h=@ud   bind  dem
    ;<  *       bind  col
    ;<  mi=@ud  bind  dem
    =/  d=@da   (year [& y] mo d h mi 0 ~)
    ;<  is-col=(unit *)  bind  (peek col)
    ?~  is-col
    (easy d)
    ;<  *      bind  col
    ;<  s=@ud  bind  dem
    =.  d      (add d (mul s ~s1))
    ;<  is-dot=(unit *)  bind  (peek dot)
    ?~  is-dot
    (easy d)
    ;<  *      bind  dot
    ;<  f=@ud  bind  dem
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
    ;<  y=@ud  bind  dem
    ;<  *      bind  hep
    ;<  m=@ud  bind  dem
    ;<  *      bind  hep
    ;<  d=@ud  bind  dem
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
    ;<  h=@ud  bind  dem
    ;<  *      bind  col
    ;<  m=@ud  bind  dem
    =/  d=@dr  (add (mul h ~h1) (mul m ~m1))
    ;<  is-col=(unit *)  bind  (peek col)
    ?~  is-col
      (easy d)
    ;<  *      bind  col
    ;<  s=@ud  bind  dem
    =.  d      (add d (mul s ~s1))
    ;<  is-dot=(unit *)  bind  (peek dot)
    ?~  is-dot
      (easy d)
    ;<  *      bind  dot
    ;<  f=@ud  bind  dem
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
:: first day of week is monday
:: first week is the week containing first thursday of the year
::
++  first-day-first-week
  |=  y=@ud
  ^-  @da
  =/  f=@da  (year [%.y y] 1 1 0 0 0 ~)
  =/  w=@    (get-weekday f)
  ?:  (lte w 3)
    (sub f (mul w ~d1))
  (add f (mul (sub 7 w) ~d1))
::
++  da-to-week-number
  |=  d=@da
  ^-  [y=@ud w=@ud]
  =/  =date  (yore d)
  =/  dof=@da  (first-day-first-week y.date)
  =/  dol=@da  (first-day-first-week (dec y.date))
  ?:  (lth d dof)
    [(dec y.date) +((div (sub d dol) ~d7))]
  =/  don=@da  (first-day-first-week +(y.date))
  ?:  (gte d don)
    [+(y.date) 1]
  [y.date +((div (sub d dof) ~d7))]
::
++  week-number-to-first-da
  |=  [y=@ud w=@ud]
  ^-  @da
  (add (mul ~d7 (dec w)) (first-day-first-week y))
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
::
++  nth-weekday
  |=  [[a=? y=@ud] m=@ud =ord =wkd]
  ^-  (unit @da)
  =/  nwkd=date  [[a y] m 1 0 0 0 ~]
  :: shift to first w
  ::
  =/  v  (get-weekday (year nwkd))
  =.  d.t.nwkd  (add d.t.nwkd (sub-wkd (wkd-to-num wkd) v))
  =.  nwkd
    ?+    ord  nwkd
      %second  nwkd(d.t (add 7 d.t.nwkd))
      %third   nwkd(d.t (add 14 d.t.nwkd))
      %fourth  nwkd(d.t (add 21 d.t.nwkd))
      ::
        %last
      ?.  (lte (add 28 d.t.nwkd) (days-in-month [[a y] m]:nwkd))
        nwkd(d.t (add 21 d.t.nwkd))
      nwkd(d.t (add 28 d.t.nwkd))
    ==
  :: assert date existence/correctness
  ::
  ?.(=(nwkd (yore (year nwkd))) ~ `(year nwkd))
::
++  first-weekday-after
  |=  [[a=? y=@ud] m=@ud d=@ud =wkd]
  ^-  (unit @da)
  =/  nwkd=date  [[a y] m d 0 0 0 ~]
  ?.  =(nwkd (yore (year nwkd)))  ~  :: assert date existence/correctness
  =/  v  (get-weekday (year nwkd))
  =.  d.t.nwkd  (add d.t.nwkd (sub-wkd (wkd-to-num wkd) v))
  :: assert date existence/correctness
  ::
  ?.(=(nwkd (yore (year nwkd))) ~ `(year nwkd))
::
++  date-of-month
  |=  [[a=? y=@ud] m=@ud d=@ud]
  ^-  (unit @da)
  =/  nwkd=date  [[a y] m d 0 0 0 ~]
  :: assert date existence/correctness
  ::
  ?.(=(nwkd (yore (year nwkd))) ~ `(year nwkd))
::
++  days-of-week
  |=  [start=@da weekdays=(list wkd)]
  =/  weekdays=(list wkd-num)  (turn weekdays wkd-to-num)
  |=  idx=@ud
  |^  ^-  @da
  =.  start               (sane-fd start)
  =/  cycle-count=@ud     (div idx (lent weekdays))
  =/  cycle-offset=@ud    (mod idx (lent weekdays))
  =/  total-offset=@ud    (add (mul 7 cycle-count) (snag cycle-offset shifted-days))
  (add start (mul ~d1 total-offset))
  ++  start-wkd     `wkd-num`(wkd-num (get-weekday start))
  ++  on            ((^on @ @) lth)
  ++  shift         |=(w=@ :_(~ (sub-wkd w start-wkd)))
  ++  weekdays-mop
    ^-  ((mop @ @) lth)
    (gas:on *((mop @ @) gth) (turn weekdays shift))
  ++  shifted-days  (turn (tap:on weekdays-mop) head)
  --
::
++  monthly-nth-weekday
  |=  [start=@da =ord =wkd]
  |=  idx=@ud
  ^-  (unit @da) :: null if does not exist
  =.  start            (sane-fd start)
  =/  start-year=@ud   y:(yore start)
  =/  start-month=@ud  (dec m:(yore start)) :: 0-indexed
  =/  curr-year=@ud    (add (div (add idx start-month) 12) start-year)
  =/  curr-month=@ud   +((mod (add idx start-month) 12))
  :: Assumes date is A.D.
  ::
  (nth-weekday [& curr-year] curr-month ord wkd)
::
++  monthly-on-day
  |=  start=@da
  |=  idx=@ud
  ^-  (unit @da) :: null if does not exist
  =.  start            (sane-fd start)
  =/  start-year=@ud   y:(yore start)
  =/  start-month=@ud  (dec m:(yore start)) :: 0-indexed
  =/  day=@ud          d.t:(yore start)
  =/  curr-year=@ud    (add (div (add idx start-month) 12) start-year)
  =/  curr-month=@ud   +((mod (add idx start-month) 12))
  =/  datetime=@da     (year [[& curr-year] curr-month day 0 0 0 ~])
  ?.(=(day d.t:(yore datetime)) ~ `datetime)
::
++  yearly-on-date
  |=  start=@da
  |=  idx=@ud
  ^-  (unit @da) :: null if does not exist
  =.  start            (sane-fd start)
  =/  start-year=@ud   y:(yore start)
  =/  [m=@ud d=@ud]    [m d.t]:(yore start)
  =/  curr-year=@ud    (add idx start-year)
  =/  datetime=@da     (year [[& curr-year] m d 0 0 0 ~])
  ?.(=([m d] [m d.t]:(yore datetime)) ~ `datetime)
--
