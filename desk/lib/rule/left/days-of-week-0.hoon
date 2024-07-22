:+  'Days of Week'
  :~  ['Start Date' %dt]
      ['Clocktime' %ct]
      ['Weekdays' %wl]
  ==
'''
|=  args=(map @t arg)
=/  sd=[y=@ud m=@ud d=@ud]
                         +:;;($>(%dt arg) (~(got by args) 'Start Date'))
=/  ct=@dr               +:;;($>(%ct arg) (~(got by args) 'Clocktime'))
=/  weekdays=(list wkd)  +:;;($>(%wl arg) (~(got by args) 'Weekdays'))
^-  $-(@ud (each dext rule-exception))
|=  idx=@ud
=/  start=@da  (year [& y.sd] m.sd d.sd 0 0 0 ~)
=/  day=@da    ((days-of-week start weekdays) idx)
[%& 0 (add day ct)]
'''
