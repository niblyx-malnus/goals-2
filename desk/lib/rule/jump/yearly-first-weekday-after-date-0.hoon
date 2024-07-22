:+  'Yearly First Weekday After Date'
  :~  ['Start Date' %dt]
      ['Weekday' %wd]
      ['Clocktime' %ct]
      ['Offset' %dl] :: as if we were in this offset from UTC
  ==
'''
|=  args=(map @t arg)
=/  sd=[y=@ud m=@ud d=@ud]
               +:;;($>(%dt arg) (~(got by args) 'Start Date'))
=/  =wkd       +:;;($>(%wd arg) (~(got by args) 'Weekday'))
=/  time=@dr   +:;;($>(%ct arg) (~(got by args) 'Clocktime'))
=/  =delta     +:;;($>(%dl arg) (~(got by args) 'Offset'))
^-  $-(@ud (each jump rule-exception))
|=  idx=@ud
=/  day=(unit @da)  (first-weekday-after [& (add y.sd idx)] m.sd d.sd wkd)
?~  day
  [%| %rule-error (crip "This date does not exist.")]
[%& (apply-invert-delta (add u.day time) delta)]
'''
