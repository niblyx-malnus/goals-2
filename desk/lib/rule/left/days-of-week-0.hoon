:+  'Days of Week'
  :~  ['Start Date' %dt]
      ['Clocktime' %ct]
      ['Weekdays' %wl]
  ==
'''
|=  args=(map @t arg)
=/  sd=fuld              +:;;($>(%dt arg) (~(got by args) 'Start Date'))
=/  ct=@dr               +:;;($>(%ct arg) (~(got by args) 'Clocktime'))
=/  weekdays=(list wkd)  +:;;($>(%wl arg) (~(got by args) 'Weekdays'))
^-  $-(@ud (each dext rule-exception))
|=  idx=@ud
=/  =fuld    ((days-of-week sd weekdays) idx)
=/  day=@da  (fuld-to-da fuld)
[%& 0 (add day ct)]
'''
