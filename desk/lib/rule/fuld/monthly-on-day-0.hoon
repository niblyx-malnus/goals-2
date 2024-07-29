:+  'Monthly on Day'
  :~  ['Start' %dt]
  ==
'''
|=  args=(map @t arg)
=/  start=fuld  +:;;($>(%dt arg) (~(got by args) 'Start'))
^-  $-(@ud (each fuld rule-exception))
|=  idx=@ud
=/  fuld=(unit fuld)  ((monthly-on-day start) idx)
?~  fuld
  [%| %rule-error 'This day does not exist in this month.']
[%& u.fuld]
'''

