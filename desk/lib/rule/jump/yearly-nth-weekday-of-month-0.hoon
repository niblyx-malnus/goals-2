:+  'Yearly nth Weekday of Month'
  :~  ['Start Month' %mt]
      ['Ordinal' %od]
      ['Weekday' %wd]
      ['Clocktime' %ct]
      ['Offset' %dl] :: as if we were in this offset from UTC
  ==
'''
|=  args=(map @t arg)
=/  sm=[y=@ud m=@ud]  +:;;($>(%mt arg) (~(got by args) 'Start Month'))
=/  =ord              +:;;($>(%od arg) (~(got by args) 'Ordinal'))
=/  =wkd              +:;;($>(%wd arg) (~(got by args) 'Weekday'))
=/  time=@dr          +:;;($>(%ct arg) (~(got by args) 'Clocktime'))
=/  =delta            +:;;($>(%dl arg) (~(got by args) 'Offset'))
^-  $-(@ud (each jump rule-exception))
|=  idx=@ud
=/  day=(unit @da)  (nth-weekday [& (add y.sm idx)] m.sm ord wkd)
?~  day
  [%| %rule-error (crip "This date does not exist.")]
[%& (apply-invert-delta (add u.day time) delta)]
'''
