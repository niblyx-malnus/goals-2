/-  *rules, iana
|%
+$  zid  zone-flag
+$  tid  @tatid
:: TODO: separate instances map from tz-rule?
::
+$  tz-rule
  $:  =dom
      name=@t
      offset=delta
      rule=[=rid =args]
      instances=(map @ud jump-instance)
  ==
::
+$  iref  [=tid i=@ud]
::
+$  zone
  $:  name=@t
      order=((mop @da iref) lth)
      rules=(map tid tz-rule)
      offsets=(jug delta tid)
  ==
::
+$  zones  (map zid zone)
::
+$  state-0  [%0 =zones]
::
+$  tz-rule-update
  $%  [%dom =dom]
      [%name name=@t]
      [%offset offset=delta]
      [%rule =rid =args]
      [%instance p=(each [idx=@ud int=jump-instance] @ud)]
  ==
::
+$  zone-update
  $%  [%init-zone =zone]
      [%name name=@t]
      [%rule p=(crud [=tid rul=tz-rule] [=tid =tz-rule-update] tid)]
  ==
::
+$  peek
  $%  [%zones =zones]
      [%zone =zone]
      [%flags flags=(list zid)]
  ==
::
+$  transition
  $%  [%put-zones =zones]
      [%put-zone =zid =zone]
      [%uni-zones =zones]
  ==
::
+$  action
  $%  [%convert-iana ~]
      [%convert-iana-zone keys=(list @t)]
  ==
--
