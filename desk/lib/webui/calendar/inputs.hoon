/+  tu=time-utils, html-utils, htmx, iso=iso-8601, *numb
=*  mx  mx:html-utils
|%
:: %dr
::
++  duration
  |=  [name=tape r=? default=@dr]
  ^-  manx
  |^
  (~(kit mx raw-html) (tag:con:mx %input) (req:tan:mx r))
  ::
  ++  raw-html
    =+  defaults
    ;span(style "display: flex; width: 100%; gap: 0.25rem")
      ;input(type "number", value d, min "0", name "{name}[d]", placeholder "DD", style "width: 25%"); 
      ;input(type "number", value h, min "0", max "23", name "{name}[h]", placeholder "HH", style "width: 25%");
      ;input(type "number", value m, min "0", max "59", name "{name}[m]", placeholder "MM", style "width: 25%");
      ;input(type "number", value s, min "0", max "59", name "{name}[s]", placeholder "SS", style "width: 25%");
    ==
  ::
  ++  defaults
    ^-  [d=tape h=tape m=tape s=tape]
    =/  d-num    (div default ~d1)
    =/  d        ?:(=(0 d-num) "" (numb d-num))
    =.  default  (mod default ~d1)
    =/  h-num    (div default ~h1)
    =/  h        ?:(=(0 h-num) "" (scow %ud h-num))
    =.  default  (mod default ~h1)
    =/  m-num    (div default ~m1)
    =/  m        ?:(=(0 m-num) "" (scow %ud m-num))
    =.  default  (mod default ~m1)
    =/  s-num    (div default ~s1)
    =/  s        ?:(=(0 s-num) "" (scow %ud s-num))
    [d h m s]
  --
:: %od
::
++  ordinal
  |=  [name=tape r=? default=ord:tu]
  ^-  manx
  =;  m=manx
    :: mark option with value of default ord as selected
    ::
    =.  m
      %+  ~(kit mx m)
        (tir:con:mx %value (trip default))
      (sec:tan:mx &)
    :: require this form input or not depending on r flag
    ::
    (req:~(at mx m) r)
  ::
  ;select
    =style  "width: 100%"
    =name   "{name}"
    ;option(value "first"): First
    ;option(value "second"): Second
    ;option(value "third"): Third
    ;option(value "fourth"): Fourth
    ;option(value "last"): Last
  == 
:: %ud
::
++  unsigned-decimal
  |=  [name=tape r=? default=@ud]
  ^-  manx
  =;  m=manx  (req:~(at mx m) r)
  ;input
    =style        "width: 100%"
    =name         "{name}"
    =value        "{(numb default)}"
    =placeholder  "0"
    =min          "0"
    ;
  ==
:: %wl
::
++  weekday-list
  |=  [name=tape r=? default=(list wkd:tu)]
  ^-  manx
  =;  m=manx
    :: mark option with value of default wkds as selected
    ::
    =.  m
      %+  ~(kit mx m)
        |=  [* m=manx]
        ?~  get=(get:~(at mx m) %value)
          %.n
        (~(has in (sy default)) ;;(wkd:tu (crip u.get)))
      (sec:tan:mx &)
    :: require this form input or not depending on r flag
    ::
    (req:~(at mx m) r)
  ::
  ;select
    =style     "width: 100%"
    =name      "{name}"
    =multiple  ""
    ;option(value "mon"): Monday
    ;option(value "tue"): Tuesday
    ;option(value "wed"): Wednesday
    ;option(value "thu"): Thursday
    ;option(value "fri"): Friday
    ;option(value "sat"): Saturday
    ;option(value "sun"): Sunday
  == 
:: %wd !!
::
++  weekday
  |=  [name=tape r=? default=wkd:tu]
  ^-  manx
  =;  m=manx
    :: mark option with value of default wkd as selected
    ::
    =.  m
      %+  ~(kit mx m)
        (tir:con:mx %value (trip default))
      (sec:tan:mx &)
    :: require this form input or not depending on r flag
    ::
    (req:~(at mx m) r)
  ::
  ;select
    =style     "width: 100%"
    =name      "{name}"
    ;option(value "mon"): Monday
    ;option(value "tue"): Tuesday
    ;option(value "wed"): Wednesday
    ;option(value "thu"): Thursday
    ;option(value "fri"): Friday
    ;option(value "sat"): Saturday
    ;option(value "sun"): Sunday
  == 
:: %dt
::
++  date-input
  |=  [name=tape r=? default=[[a=? y=@ud] m=@ud d=@ud]]
  ^-  manx
  =;  m=manx  (req:~(at mx m) r)
  ;input
    =style        "width: 100%"
    =type         "date"
    =name         "{name}"
    =value        "{(en:date-input:iso default)}"
    ;
  ==
:: %dl
::
++  delta-input
  |=  [name=tape r=? default=delta:tu]
  ^-  manx
  |^
  %+  ~(wit mx raw-html)
    |=  [* m=manx] 
    ?=(?(%input %select) n.g.m)
  (req:tan:mx r)
  ::
  ++  raw-html
    ;span(style "display: flex; width: 100%; gap: 0.25rem")
      ;+  =;  m=manx
            :: mark option with value of default as selected
            ::
            %+  ~(kit mx m)
              (tir:con:mx %value ?:(sign.default "+" "-"))
            (sec:tan:mx &)
          ::
          ;select(style "width: 20%", name "{name}[sign]")
            ;option(value "+"): +
            ;option(value "-"): -
          == 
      ;+  =+  defaults
          ;span(style "display: flex; width: 80%; gap: 0.25rem")
            ;input(type "number", value h, min "0", max "23", name "{name}[h]", placeholder "HH", style "width: 50%");
            ;input(type "number", value m, min "0", max "59", name "{name}[m]", placeholder "MM", style "width: 50%");
          ==
    ==
  ::
  ++  defaults
    ^-  [h=tape m=tape]
    =.  d.default  (mod d.default ~d1)
    =/  h-num      (div d.default ~h1)
    =/  h          ?:(=(0 h-num) "" (scow %ud h-num))
    =.  d.default  (mod d.default ~h1)
    =/  m-num      (div d.default ~m1)
    =/  m          ?:(=(0 m-num) "" (scow %ud m-num))
    [h m]
  --
:: %cl
::
++  time-input
  |=  [name=tape r=? default=@dr]
  ^-  manx
  =;  m=manx  (req:~(at mx m) r)
  ;input
    =style        "width: 100%"
    =type         "time"
    =name         "{name}"
    =value        "{(en:time-input:iso default)}"
    ;
  ==
::  %da
::
++  datetime-local
  |=  [name=tape r=? default=@da]
  ^-  manx
  =;  m=manx  (req:~(at mx m) r)
  ;input
    =style        "width: 100%"
    =type         "datetime-local"
    =name         "{name}"
    =value        "{(en:datetime-local:iso default)}"
    ;
  ==
:: %mt
::
++  month-input
  |=  [name=tape r=? default=[[a=? y=@ud] m=@ud]]
  ^-  manx
  =;  m=manx  (req:~(at mx m) r)
  ;input
    =style        "width: 100%"
    =type         "month"
    =name         "{name}"
    =value        "{(en:month-input:iso default)}"
    ;
  ==
:: %wk
::
++  week-input
  |=  [name=tape r=? default=[[a=? y=@ud] w=@ud]]
  ^-  manx
  =;  m=manx  (req:~(at mx m) r)
  ;input
    =style        "width: 100%"
    =type         "week"
    =name         "{name}"
    =value        "{(en:week-input:iso default)}"
    ;
  ==
:: %dx
::
++  indexed-time
  |=  [name=tape r=? default=@da]
  ^-  manx
  =;  m=manx  (~(kit mx m) (tag:con:mx %input) (req:tan:mx r))
  ;span(style "display: flex; width: 100%; gap: 0.25rem")
    ;input
      =style        "width: 20%"
      =type         "number"
      =min          "0"
      =name         "{name}[i]"
      =value        "0"
      =placeholder  "0"
      ;
    ==
    ;input
      =style        "width: 80%"
      =type         "datetime-local"
      =name         "{name}[d]"
      =value        "{(en:datetime-local:iso default)}"
      ;
    ==
  ==
--
