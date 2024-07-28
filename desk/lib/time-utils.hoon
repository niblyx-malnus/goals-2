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
:: TODO: replace $fullday with %fuld everywhere
::
+$  fullday  @da                    :: must be divisible by ~d1
+$  span  [l=@da r=@da]             :: UTC datetime pair
+$  jump  @da                       :: instantaneous event
+$  anum  [a=? y=@ud]               :: a signed year
+$  munt  [[a=? y=@ud] m=@ud]       :: month of year
+$  fuld  [[a=? y=@ud] m=@ud d=@ud] :: date by day of month
+$  week  [[a=? y=@ud] w=@ud]       :: week of year
+$  dawk  [[a=? y=@ud] w=@ud d=@ud] :: date by day of week
+$  nord  [[a=? y=@ud] n=@ud]       :: ordinal date (nth day of year)
:: CALENDAR rule; NOT TIMEZONE rule
::
+$  rule-exception
  $%  [%skip ~]
      [%rule-error msg=@t]
  ==
:: Should never abandon support for any of these...
:: If need to update an arg, add a version like %ud-1...
:: TODO: replace %mt with $munt, %wk with $week, %dt with $fuld
::
+$  arg
  $%  [%ud p=@ud]                 :: natural number (unsigned decimal)
      [%od p=ord]                 :: ordinal numbers for weekday in a month
      [%da p=@da]                 :: datetime-local
      [%dr p=@dr]                 :: duration
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
++  shift-anum
  |=  [[a=? y=@ud] sign=? n=@ud]
  ^-  anum
  ?:  =(a sign)
    [a (add a n)]
  ?:  (lth n y)
    [a (sub y n)]
  [!a +((sub n y))] :: .+ because year 0 does not exist
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
  ^+  time
  (?:(sign.delta add sub) time d.delta)
::
++  invert-delta  |=(=delta delta(sign !sign.delta))
::
++  apply-invert-delta
  |=  [=time =delta]
  ^+  time
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
:: first day of week is monday
:: first week is the week containing first thursday of the year
:: (according to ISO-8601)
::
++  first-day-first-week
  |=  [a=? y=@ud]
  ^-  @da
  =/  f=@da  (year [a y] 1 1 0 0 0 ~)
  =/  w=@    (get-weekday f)
  ?:  (lte w 3)
    (sub f (mul w ~d1))
  (add f (mul (sub 7 w) ~d1))
::
++  da-to-anum
  |=  d=@da
  ^-  anum
  [a y]:(yore d)
::
++  da-to-munt
  |=  d=@da
  ^-  munt
  [[a y] m]:(yore d)
::
++  da-to-fuld
  |=  d=@da
  ^-  fuld
  [[a y] m d.t]:(yore d)
::
++  da-to-week
  |=  d=@da
  ^-  week
  =/  =date  (yore d)
  =/  dof=@da  (first-day-first-week [a y]:date)
  =/  dol=@da  (first-day-first-week (shift-anum [a y]:date | 1))
  ?:  (lth d dof)
    [(shift-anum [a y]:date | 1) +((div (sub d dol) ~d7))]
  =/  don=@da  (first-day-first-week (shift-anum [a y]:date & 1))
  ?:  (gte d don)
    [(shift-anum [a y]:date & 1) 1]
  [[a y]:date +((div (sub d dof) ~d7))]
:: week value is 0-indexed in contrast to ISO-8601
::
++  da-to-dawk
  |=  d=@da
  ^-  dawk
  =/  [[a=? y=@ud] w=@ud]  (da-to-week d)
  [[a y] w (get-weekday d)]
::
++  da-to-nord
  |=  d=@da
  ^-  nord
  =+  (yore d)
  :-  [a y]
  +((div (sub d (year [a y] 1 1 0 0 0 ~)) ~d1))
::
++  week-to-first-da
  |=  [[a=? y=@ud] w=@ud]
  ^-  @da
  (add (mul ~d7 (dec w)) (first-day-first-week a y))
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
