/+  tu=time-utils, html-utils, htmx
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
    =/  d        ?:(=(0 d-num) "" (numb:htmx d-num))
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
  |=  [name=tape r=?]
  ^-  manx
  =;  m=manx  (req:~(at mx m) r)
  ;select
    =style  "width: 100%"
    =name   "{name}"
    ;option(value "first", selected ""): First
    ;option(value "second"): Second
    ;option(value "third"): Third
    ;option(value "fourth"): Fourth
    ;option(value "last"): Last
  == 
:: %ud
::
++  unsigned-decimal
  |=  [name=tape r=?]
  ^-  manx
  =;  m=manx  (req:~(at mx m) r)
  ;input
    =style        "width: 100%"
    =name         "{name}"
    =value        "0"
    =placeholder  "0"
    =min          "0"
    ;
  ==
:: %wl
::
++  weekday-list
  |=  [name=tape r=?]
  ^-  manx
  =;  m=manx  (req:~(at mx m) r)
  ;select
    =style     "width: 100%"
    =name      "{name}"
    =multiple  ""
    :: TODO: selected should be TODAY's weekday
    ::
    ;option(value "mon", selected ""): Monday
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
  |=  [name=tape r=?]
  ^-  manx
  =;  m=manx  (req:~(at mx m) r)
  ;select
    =style     "width: 100%"
    =name      "{name}"
    :: TODO: selected should be TODAY's weekday
    ::
    ;option(value "monday", selected ""): Monday
    ;option(value "tuesday"): Tuesday
    ;option(value "wednesday"): Wednesday
    ;option(value "thursday"): Thursday
    ;option(value "friday"): Friday
    ;option(value "saturday"): Saturday
    ;option(value "sunday"): Sunday
  == 
:: %da
::
++  date-input
  |=  [name=tape r=? default=@da]
  ^-  manx
  =;  m=manx  (req:~(at mx m) r)
  ;input
    =style        "width: 100%"
    =type         "date"
    =name         "{name}"
    =value        "{(en:date-input:tu default)}"
    ;
  ==
:: %dl
::
++  time-input
  |=  [name=tape r=? default=@dr]
  ^-  manx
  =;  m=manx  (req:~(at mx m) r)
  ;input
    =style        "width: 100%"
    =type         "time"
    =name         "{name}"
    =value        "{(en:time-input:tu default)}"
    ;
  ==
:: %mn !!
::
++  month-input
  |=  [name=tape r=?]
  ^-  manx
  =;  m=manx  (req:~(at mx m) r)
  ;input
    =style        "width: 100%"
    =type         "month"
    =name         "{name}"
    ;
  ==
:: %wk !!
::
++  week-input
  |=  [name=tape r=?]
  ^-  manx
  =;  m=manx  (req:~(at mx m) r)
  ;input
    =style        "width: 100%"
    =type         "week"
    =name         "{name}"
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
      =value        "{(en:datetime-local:tu default)}"
      ;
    ==
  ==
--
