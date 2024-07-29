:+  'Days of Week'
  :~  ['Start' %dt]
      ['Weekdays' %wl]
  ==
'''
|=  args=(map @t arg)
=/  sd=[y=@ud m=@ud d=@ud]  +:;;($>(%dt arg) (~(got by args) 'Start'))
=/  weekdays=(list wkd)     +:;;($>(%wl arg) (~(got by args) 'Weekdays'))
=/  start=@da  (year [& y.sd] m.sd d.sd 0 0 0 ~)
^-  $-(@ud (each fuld rule-exception))
|=  idx=@ud
=/  day=@da  ((days-of-week start weekdays) idx)
[%& (da-to-fuld day)]
'''
