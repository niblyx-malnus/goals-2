/+  *time-utils
|%
+$  iana   [=zones =rules =links]
+$  links  (map @t @t)
+$  rules  (map @ta rule)
:: NOTE: rule-entry order IS NOT important
::
+$  rule   [name=@ta entries=(list rule-entry)]
+$  usw    ?(%utc %standard %wallclock)
::
+$  rule-entry
  $:  from=@ud
      to=rule-to
      in=mnt
      on=rule-on
      =at
      save=delta
      letter=@t
  ==
::
+$  at  (pair usw @dr)
::
+$  rule-to
  $%  [%year y=@ud]
      [%only ~]
      [%max ~]
  ==
::
+$  rule-on
  $%  [%int =ord =wkd]  :: recurs yrly on ord w of m
      [%aft d=@ud =wkd] :: recurs yrly on first w after d of m
      [%dat d=@ud]      :: recurs yrly on d of m
  ==
::
+$  zones  (map @ta zone)
:: NOTE: zone-entry order IS important
::
+$  zone   [name=@ta entries=(list zone-entry)]
::
+$  zone-entry
  $:  stdoff=delta
      rules=zone-rules
      format=@t
      =until
  ==
::
+$  until  (unit (pair usw @da))
::
+$  zone-rules
  $%  [%nothing ~]
      [%delta =delta]
      [%rule name=@ta]
  ==
::
+$  action
  $%  [%watch-iana ~]
      [%leave-iana ~]
      [%import-blob data=@t]
  ==
--
