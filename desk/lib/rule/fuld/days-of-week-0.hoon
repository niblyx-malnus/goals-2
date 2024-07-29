:+  'Days of Week'
  :~  ['Start' %dt]
      ['Weekdays' %wl]
  ==
'''
|=  args=(map @t arg)
=/  sd=fuld              +:;;($>(%dt arg) (~(got by args) 'Start'))
=/  weekdays=(list wkd)  +:;;($>(%wl arg) (~(got by args) 'Weekdays'))
^-  $-(@ud (each fuld rule-exception))
|=  idx=@ud
[%& ((days-of-week sd weekdays) idx)]
'''
